# =============================================================================
# STAGE 4 — ECOSYSTEM IDENTIFICATION AND CITY COMPARISON
# Muslim-Friendly Tourism Ecosystems in Taiwan
# Taipei · Taichung · Kaohsiung
#
# Operational definition of a Muslim-friendly tourism ecosystem:
#   A halal-certified hotel qualifies if, within a given radius, there is
#   at least one halal restaurant AND at least one tourist attraction.
#   Tested at two thresholds: 1 km (standard) and 500 m (strict).
#
# Outputs:
#   stage4_hotel_ecosystem.csv       — hotel-level classification
#   stage4_ecosystem_summary.csv     — city-level summary
#   stage4_ecosystem_maps.png        — qualifying vs. non-qualifying hotels
#   stage4_qualification_rates.png   — bar chart by city and threshold
#   stage4_district_choropleth.png   — district-level % qualifying
# =============================================================================

setwd("~/Downloads/big data")
if (!exists("DATA_VERSION") || DATA_VERSION < 10L) source("00_data.R")

library(patchwork)
library(scales)

# ── Subsets ────────────────────────────────────────────────────────────────────
# FROM: Hotels + Hotel & Restaurant combos.
#       Combo facilities count as accommodation and as halal food sources for
#       other hotels, but not as their own restaurant access.
# TO  : Restaurants + Hotel & Restaurant combos (all halal food sources)
sf_d1_roles    <- sf_d1 %>% mutate(facility_uid = row_number())
sf_hotels      <- filter(sf_d1_roles, facility_type %in% c("Hotel", "Hotel & Restaurant"))
sf_restaurants <- filter(sf_d1_roles, facility_type %in% c("Restaurant", "Hotel & Restaurant"))

# ── Count features within a radius (buffer intersection) ─────────────────────
count_within <- function(from, to, radius, exclude_self = FALSE) {
  if (nrow(from) == 0 || nrow(to) == 0) return(integer(nrow(from)))
  hits <- st_intersects(st_buffer(from, dist = radius), to)
  if (exclude_self) {
    hits <- map2(hits, from$facility_uid, function(idx, uid) {
      idx[to$facility_uid[idx] != uid]
    })
  }
  lengths(hits)
}

# ── Classify each hotel at 1km and 500m thresholds ───────────────────────────
ecosystem_data <- map_dfr(CITIES, function(cn) {
  h <- filter(sf_hotels,      city == cn)
  r <- filter(sf_restaurants, city == cn)
  a <- filter(sf_d2,          city == cn)
  p <- filter(sf_d3,          city == cn)
  if (nrow(h) == 0) return(NULL)

  h %>%
    mutate(
      rest_1km    = count_within(h, r, 1000, exclude_self = TRUE),
      attr_1km    = count_within(h, a, 1000),
      prayer_1km  = count_within(h, p, 1000),
      eco_1km     = rest_1km >= 1 & attr_1km >= 1,
      rest_500m   = count_within(h, r, 500, exclude_self = TRUE),
      attr_500m   = count_within(h, a, 500),
      prayer_500m = count_within(h, p, 500),
      eco_500m    = rest_500m >= 1 & attr_500m >= 1
    )
})

# Export hotel-level table
ecosystem_data %>%
  st_drop_geometry() %>%
  select(city, hotel_name = name, facility_type,
         rest_1km, attr_1km, prayer_1km, eco_1km,
         rest_500m, attr_500m, prayer_500m, eco_500m) %>%
  write_csv("stage4_hotel_ecosystem.csv")

# ── City-level summary ────────────────────────────────────────────────────────
eco_summary <- ecosystem_data %>%
  st_drop_geometry() %>%
  group_by(city) %>%
  summarise(
    n_hotels       = n(),
    eco_1km_n      = sum(eco_1km),
    eco_1km_pct    = mean(eco_1km)     * 100,
    rest_1km_pct   = mean(rest_1km >= 1)   * 100,
    attr_1km_pct   = mean(attr_1km >= 1)   * 100,
    prayer_1km_pct = mean(prayer_1km >= 1) * 100,
    eco_500m_n     = sum(eco_500m),
    eco_500m_pct   = mean(eco_500m)    * 100,
    rest_500m_pct  = mean(rest_500m >= 1)  * 100,
    attr_500m_pct  = mean(attr_500m >= 1)  * 100,
    .groups = "drop"
  )

write_csv(eco_summary, "stage4_ecosystem_summary.csv")

# ── Console summary ────────────────────────────────────────────────────────────
cat("\n======================================================\n")
cat("STAGE 4 — ECOSYSTEM IDENTIFICATION SUMMARY\n")
cat("======================================================\n\n")

for (cn in CITIES) {
  row <- filter(eco_summary, city == cn)
  cat(sprintf("── %s (n = %d hotels) ──\n", cn, row$n_hotels))
  cat(sprintf("  Qualifying at 1 km    : %d of %d  (%.0f%%)\n",
              row$eco_1km_n, row$n_hotels, row$eco_1km_pct))
  cat(sprintf("  Qualifying at 500 m   : %d of %d  (%.0f%%)\n",
              row$eco_500m_n, row$n_hotels, row$eco_500m_pct))
  cat(sprintf("  Restaurant within 1km : %.0f%% of hotels\n", row$rest_1km_pct))
  cat(sprintf("  Attraction within 1km : %.0f%% of hotels\n", row$attr_1km_pct))
  cat(sprintf("  Prayer room within 1km: %.0f%% of hotels\n\n", row$prayer_1km_pct))
}

# =============================================================================
# VIZ A — Ecosystem map: qualifying vs. non-qualifying hotels per city
# =============================================================================

ECO_COLORS <- c("TRUE"  = "#1a9641", "FALSE" = "#d73027")
ECO_SHAPES <- c("TRUE"  = 16,        "FALSE" = 4)
ECO_LABELS <- c("TRUE"  = "Qualifying  (≥1 restaurant + ≥1 attraction within 1 km)",
                "FALSE" = "Not qualifying")

make_eco_map <- function(city_name) {
  lim    <- CITY_LIMITS[[city_name]]
  dist   <- filter(districts, city == city_name)
  dlabs  <- filter(dist_centroids, city == city_name)
  hotels <- filter(ecosystem_data, city == city_name) %>%
    mutate(eco_status = as.character(eco_1km))

  ggplot() +
    geom_sf(data = dist, fill = "#f0f0f0", colour = "#bbbbbb", linewidth = 0.4) +
    geom_text(data = dlabs, aes(cx, cy, label = district_en),
              size = 1.6, colour = "#555555", check_overlap = TRUE) +
    geom_sf(data = hotels, aes(colour = eco_status, shape = eco_status),
            size = 2.8, alpha = 0.90, stroke = 0.8) +
    scale_colour_manual(values = ECO_COLORS, labels = ECO_LABELS, name = NULL) +
    scale_shape_manual( values = ECO_SHAPES, labels = ECO_LABELS, name = NULL) +
    { if (!is.null(lim$xlim))
        coord_sf(xlim = lim$xlim, ylim = lim$ylim, expand = FALSE)
      else
        coord_sf(expand = FALSE) } +
    labs(
      title    = city_name,
      subtitle = "1 km radius threshold",
      caption  = "Data: Taiwan Tourism Administration · OSM · MOI"
    ) +
    theme_void(base_size = 9) +
    theme(
      plot.background       = element_rect(fill = "#f9f9f9", colour = NA),
      plot.title            = element_text(face = "bold", size = 11, hjust = 0.5,
                                           margin = margin(b = 2)),
      plot.subtitle         = element_text(size = 8, colour = "grey45", hjust = 0.5),
      plot.caption          = element_text(size = 5.5, colour = "grey50", hjust = 1),
      legend.position       = "bottom",
      legend.text           = element_text(size = 6.5),
      legend.key            = element_rect(fill = NA, colour = NA),
      legend.box.background = element_rect(colour = "#cccccc", fill = "white",
                                           linewidth = 0.3)
    ) +
    guides(
      colour = guide_legend(override.aes = list(size = 3.5)),
      shape  = guide_legend(override.aes = list(size = 3.5))
    )
}

eco_panel <- (make_eco_map("Taipei") | make_eco_map("Taichung") | make_eco_map("Kaohsiung")) +
  plot_annotation(
    title   = "Stage 4 — Ecosystem-Qualifying Halal Hotels",
    caption = "Green circle = qualifying (≥1 halal restaurant + ≥1 tourist attraction within 1 km)  ·  Red × = not qualifying",
    theme   = theme(
      plot.title   = element_text(face = "bold", size = 14),
      plot.caption = element_text(size = 7.5, colour = "grey50")
    )
  )

print(eco_panel)
ggsave("stage4_ecosystem_maps.png", eco_panel, width = 24, height = 10, dpi = 300, bg = "white")

# =============================================================================
# VIZ B — Bar chart: qualification rates by city and threshold
# =============================================================================

bar_data <- eco_summary %>%
  select(city, `1 km` = eco_1km_pct, `500 m` = eco_500m_pct) %>%
  pivot_longer(c(`1 km`, `500 m`), names_to = "threshold", values_to = "pct") %>%
  mutate(threshold = factor(threshold, levels = c("1 km", "500 m")))

bar_p <- ggplot(bar_data, aes(city, pct, fill = threshold)) +
  geom_col(position = position_dodge(0.65), width = 0.55, alpha = 0.90) +
  geom_text(
    aes(label = sprintf("%.0f%%", pct)),
    position = position_dodge(0.65),
    vjust = -0.45, size = 3.4, fontface = "bold"
  ) +
  scale_fill_manual(
    values = c("1 km" = "#2166ac", "500 m" = "#4dac26"),
    name   = "Radius threshold"
  ) +
  scale_y_continuous(
    labels = label_percent(scale = 1),
    limits = c(0, 115),
    expand = c(0, 0)
  ) +
  labs(
    title    = "Stage 4 — Ecosystem Qualification Rate by City",
    subtitle = "% of halal hotels meeting the ecosystem criteria (≥1 restaurant + ≥1 attraction within radius)",
    x = NULL, y = "% of hotels qualifying",
    caption  = "Data: Taiwan Tourism Administration · OSM · MOI"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title         = element_text(face = "bold", size = 13),
    plot.subtitle      = element_text(size = 9, colour = "grey40"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    legend.position    = "top"
  )

print(bar_p)
ggsave("stage4_qualification_rates.png", bar_p, width = 8, height = 6, dpi = 300, bg = "white")

# =============================================================================
# VIZ C — District-level choropleth: % qualifying hotels per district
# =============================================================================

eco_by_dist <- ecosystem_data %>%
  st_join(select(districts, dist_id), join = st_within) %>%
  st_drop_geometry() %>%
  group_by(dist_id) %>%
  summarise(
    n_hotels = n(),
    n_eco    = sum(eco_1km),
    eco_pct  = mean(eco_1km) * 100,
    .groups  = "drop"
  )

dist_eco <- districts %>%
  left_join(eco_by_dist, by = "dist_id") %>%
  mutate(eco_pct = replace_na(eco_pct, NA_real_))

make_dist_map <- function(city_name) {
  lim   <- CITY_LIMITS[[city_name]]
  df    <- filter(dist_eco, city == city_name)
  dlabs <- filter(dist_centroids, city == city_name)

  ggplot(df) +
    geom_sf(aes(fill = eco_pct), colour = "white", linewidth = 0.3) +
    geom_text(data = dlabs, aes(cx, cy, label = district_en),
              size = 1.5, colour = "black", check_overlap = TRUE) +
    scale_fill_gradient(
      low      = "#ffffcc",
      high     = "#006837",
      name     = "% qualifying\nhotels",
      na.value = "#e0e0e0",
      labels   = label_percent(scale = 1),
      limits   = c(0, 100)
    ) +
    { if (!is.null(lim$xlim))
        coord_sf(xlim = lim$xlim, ylim = lim$ylim, expand = FALSE)
      else
        coord_sf(expand = FALSE) } +
    labs(title = city_name) +
    theme_void(base_size = 9) +
    theme(
      plot.title        = element_text(face = "bold", size = 10, hjust = 0.5),
      legend.position   = "right",
      legend.key.height = unit(1.1, "cm"),
      legend.key.width  = unit(0.35, "cm"),
      legend.text       = element_text(size = 7),
      legend.title      = element_text(size = 7, face = "bold")
    )
}

dist_panel <- (make_dist_map("Taipei") | make_dist_map("Taichung") | make_dist_map("Kaohsiung")) +
  plot_annotation(
    title    = "Stage 4 — District-Level Ecosystem Score",
    subtitle = "% of halal hotels within each district qualifying at the 1 km threshold\nGrey = no halal hotels in district",
    caption  = "Data: Taiwan Tourism Administration · OSM · MOI",
    theme    = theme(
      plot.title    = element_text(face = "bold", size = 13),
      plot.subtitle = element_text(size = 9, colour = "grey40"),
      plot.caption  = element_text(size = 7, colour = "grey50")
    )
  )

print(dist_panel)
ggsave("stage4_district_choropleth.png", dist_panel,
       width = 24, height = 10, dpi = 300, bg = "white")

message("\nStage 4 complete. Outputs saved to ", getwd())

# =============================================================================
# END OF STAGE 4
# =============================================================================

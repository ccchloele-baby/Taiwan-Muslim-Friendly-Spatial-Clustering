# =============================================================================
# STAGE 2 — DISTANCE-BASED ACCESSIBILITY ANALYSIS
# Muslim-Friendly Tourism Ecosystems in Taiwan
# Taipei · Taichung · Kaohsiung
#
# For each halal-certified hotel calculates:
#   (1) Distance to nearest halal restaurant
#   (2) Distance to nearest tourist attraction
#   (3) Distance to nearest prayer room / mosque
#
# Outputs:
#   stage2_hotel_distances.csv
#   stage2_summary_table.html
#   stage2_histograms.png
#   stage2_boxplots.png
# =============================================================================

setwd("~/Downloads/big data")
if (!exists("DATA_VERSION") || DATA_VERSION < 10L) source("00_data.R")

pkgs <- c("scales", "patchwork", "gt")
new  <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new)

library(scales)
library(patchwork)
library(gt)

# ── Subsets ────────────────────────────────────────────────────────────────────
# FROM: Hotels + Hotel & Restaurant combos.
#       A traveller can stay in a combo facility, but restaurant access is
#       measured to a separate halal food source rather than the same facility.
# TO  : Restaurants + Hotel & Restaurant combos (both serve halal food)
sf_d1_roles    <- sf_d1 %>% mutate(facility_uid = row_number())
sf_hotels      <- filter(sf_d1_roles, facility_type %in% c("Hotel", "Hotel & Restaurant"))
sf_restaurants <- filter(sf_d1_roles, facility_type %in% c("Restaurant", "Hotel & Restaurant"))

# ── Nearest-neighbour distance (metres) ────────────────────────────────────────
# st_distance() returns a full n×m matrix; apply(, 1, min) extracts the closest.
nn_dist_m <- function(from, to) {
  if (nrow(from) == 0 || nrow(to) == 0) return(rep(NA_real_, nrow(from)))
  apply(st_distance(from, to), 1, min) %>% as.numeric()
}

nn_dist_m_external <- function(from, to) {
  if (nrow(from) == 0 || nrow(to) == 0) return(rep(NA_real_, nrow(from)))
  d <- st_distance(from, to)
  same_facility <- outer(from$facility_uid, to$facility_uid, `==`)
  d[same_facility] <- Inf
  mins <- apply(d, 1, min) %>% as.numeric()
  replace(mins, is.infinite(mins), NA_real_)
}

# ── Per-city distance calculation (avoids cross-city artefacts) ───────────────
hotel_distances <- map_dfr(CITIES, function(cn) {
  h <- filter(sf_hotels,      city == cn)
  r <- filter(sf_restaurants, city == cn)
  a <- filter(sf_d2,          city == cn)
  p <- filter(sf_d3,          city == cn)
  if (nrow(h) == 0) return(NULL)
  tibble(
    city              = cn,
    hotel_name        = h$name,
    facility_type     = h$facility_type,
    dist_restaurant_m = nn_dist_m_external(h, r),
    dist_attraction_m = nn_dist_m(h, a),
    dist_prayer_m     = nn_dist_m(h, p)
  )
})

write_csv(hotel_distances, "stage2_hotel_distances.csv")

# ── Summary statistics by city ─────────────────────────────────────────────────
summary_tbl <- hotel_distances %>%
  group_by(city) %>%
  summarise(
    n_hotels     = n(),
    # Restaurant
    rest_mean    = mean(dist_restaurant_m,      na.rm = TRUE),
    rest_median  = median(dist_restaurant_m,    na.rm = TRUE),
    rest_min     = min(dist_restaurant_m,       na.rm = TRUE),
    rest_max     = max(dist_restaurant_m,       na.rm = TRUE),
    rest_pct500  = mean(dist_restaurant_m <= 500,  na.rm = TRUE) * 100,
    rest_pct1k   = mean(dist_restaurant_m <= 1000, na.rm = TRUE) * 100,
    # Attraction
    attr_mean    = mean(dist_attraction_m,      na.rm = TRUE),
    attr_median  = median(dist_attraction_m,    na.rm = TRUE),
    attr_min     = min(dist_attraction_m,       na.rm = TRUE),
    attr_max     = max(dist_attraction_m,       na.rm = TRUE),
    attr_pct500  = mean(dist_attraction_m <= 500,  na.rm = TRUE) * 100,
    attr_pct1k   = mean(dist_attraction_m <= 1000, na.rm = TRUE) * 100,
    # Prayer
    pray_mean    = mean(dist_prayer_m,          na.rm = TRUE),
    pray_median  = median(dist_prayer_m,        na.rm = TRUE),
    pray_min     = min(dist_prayer_m,           na.rm = TRUE),
    pray_max     = max(dist_prayer_m,           na.rm = TRUE),
    pray_pct500  = mean(dist_prayer_m <= 500,   na.rm = TRUE) * 100,
    pray_pct1k   = mean(dist_prayer_m <= 1000,  na.rm = TRUE) * 100,
    .groups = "drop"
  )

# ── Formatted HTML table via {gt} ─────────────────────────────────────────────
gt_tbl <- summary_tbl %>%
  gt(rowname_col = "city") %>%
  tab_header(
    title    = "Stage 2 — Distance to Nearest Facility (metres)",
    subtitle = "Halal-Certified Hotels incl. Hotel & Restaurant combos · Taipei / Taichung / Kaohsiung"
  ) %>%
  tab_spanner(label = "Nearest Halal Restaurant",     columns = starts_with("rest_")) %>%
  tab_spanner(label = "Nearest Tourist Attraction",   columns = starts_with("attr_")) %>%
  tab_spanner(label = "Nearest Prayer Room / Mosque", columns = starts_with("pray_")) %>%
  cols_label(
    n_hotels    = "Hotels (n)",
    rest_mean   = "Mean",  rest_median = "Median", rest_min = "Min",  rest_max = "Max",
    rest_pct500 = "≤500m %",  rest_pct1k  = "≤1km %",
    attr_mean   = "Mean",  attr_median = "Median", attr_min = "Min",  attr_max = "Max",
    attr_pct500 = "≤500m %",  attr_pct1k  = "≤1km %",
    pray_mean   = "Mean",  pray_median = "Median", pray_min = "Min",  pray_max = "Max",
    pray_pct500 = "≤500m %",  pray_pct1k  = "≤1km %"
  ) %>%
  fmt_number(
    columns  = c(ends_with("mean"), ends_with("median"), ends_with("min"), ends_with("max")),
    decimals = 0
  ) %>%
  fmt_number(
    columns  = c(ends_with("pct500"), ends_with("pct1k")),
    decimals = 1
  ) %>%
  tab_style(style = cell_text(weight = "bold"), locations = cells_column_spanners()) %>%
  tab_options(
    table.font.size            = px(12),
    heading.title.font.size    = px(14),
    column_labels.font.weight  = "bold"
  )

print(gt_tbl)
gtsave(gt_tbl, "stage2_summary_table.html")

# ── Distribution histograms (3 rows × 3 cities) ───────────────────────────────
CITY_COL <- c("Taipei" = "#2166ac", "Taichung" = "#1a9641", "Kaohsiung" = "#d73027")

hist_theme <- theme_minimal(base_size = 10) +
  theme(
    strip.text       = element_text(face = "bold", size = 9),
    panel.grid.minor = element_blank(),
    plot.title       = element_text(face = "bold", size = 10)
  )

make_hist <- function(dist_col, x_label, panel_title, binwidth = 200) {
  xmax <- quantile(hotel_distances[[dist_col]], 0.97, na.rm = TRUE) * 1.05
  ggplot(hotel_distances, aes(.data[[dist_col]], fill = city)) +
    geom_histogram(binwidth = binwidth, colour = "white", alpha = 0.85) +
    geom_vline(xintercept = 500,  linetype = "dashed", linewidth = 0.5, colour = "grey35") +
    geom_vline(xintercept = 1000, linetype = "dotted", linewidth = 0.5, colour = "grey35") +
    annotate("text", x = 520,  y = Inf, label = "500 m", vjust = 1.4,
             hjust = 0, size = 2.5, colour = "grey35") +
    annotate("text", x = 1020, y = Inf, label = "1 km",  vjust = 1.4,
             hjust = 0, size = 2.5, colour = "grey35") +
    facet_wrap(~city, ncol = 3, scales = "free_y") +
    scale_fill_manual(values = CITY_COL, guide = "none") +
    scale_x_continuous(labels = label_comma(suffix = "m"), limits = c(0, xmax)) +
    scale_y_continuous(breaks = scales::breaks_extended(n = 5)) +
    labs(title = panel_title, x = x_label, y = "Number of hotels") +
    hist_theme
}

hist_rest <- make_hist("dist_restaurant_m",
                       "Distance to nearest halal restaurant (m)",
                       "A  |  Nearest Halal Restaurant")
hist_attr <- make_hist("dist_attraction_m",
                       "Distance to nearest tourist attraction (m)",
                       "B  |  Nearest Tourist Attraction")
hist_pray <- make_hist("dist_prayer_m",
                       "Distance to nearest prayer room / mosque (m)",
                       "C  |  Nearest Prayer Room / Mosque")

combined_hist <- (hist_rest / hist_attr / hist_pray) +
  plot_annotation(
    title   = "Stage 2 — Distance from Halal-Certified Hotels to Nearest Muslim-Friendly Facilities",
    caption = "Data: Taiwan Tourism Administration · OSM · MOI  |  Projected: TWD97 EPSG:3826",
    theme   = theme(
      plot.title   = element_text(face = "bold", size = 13),
      plot.caption = element_text(size = 7, colour = "grey50")
    )
  )

print(combined_hist)
ggsave("stage2_histograms.png", combined_hist, width = 14, height = 14, dpi = 300, bg = "white")

# ── Boxplot comparison ─────────────────────────────────────────────────────────
dist_long <- hotel_distances %>%
  pivot_longer(
    cols      = c(dist_restaurant_m, dist_attraction_m, dist_prayer_m),
    names_to  = "type",
    values_to = "distance_m"
  ) %>%
  mutate(type = recode(type,
                       dist_restaurant_m = "Halal\nRestaurant",
                       dist_attraction_m = "Tourist\nAttraction",
                       dist_prayer_m     = "Prayer Room\n/ Mosque"))

boxplot_p <- ggplot(dist_long, aes(type, distance_m, fill = city, colour = city)) +
  geom_boxplot(alpha = 0.45, outlier.size = 0.8, linewidth = 0.5,
               position = position_dodge(0.8), width = 0.65) +
  geom_hline(yintercept = 500,  linetype = "dashed", linewidth = 0.4, colour = "grey35") +
  geom_hline(yintercept = 1000, linetype = "dotted", linewidth = 0.4, colour = "grey35") +
  scale_fill_manual(values = CITY_COL, name = "City") +
  scale_colour_manual(values = CITY_COL, name = "City") +
  scale_y_continuous(labels = label_comma(suffix = "m")) +
  labs(
    title    = "Stage 2 — Distance Distribution by Facility Type and City",
    subtitle = "Dashed = 500 m threshold · Dotted = 1 km threshold",
    x = NULL, y = "Distance to nearest facility (m)",
    caption  = "Data: Taiwan Tourism Administration · OSM · MOI"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(size = 9, colour = "grey40"),
    legend.position  = "top",
    panel.grid.minor = element_blank()
  )

print(boxplot_p)
ggsave("stage2_boxplots.png", boxplot_p, width = 10, height = 7, dpi = 300, bg = "white")

# ── Console summary ────────────────────────────────────────────────────────────
cat("\n======================================================\n")
cat("STAGE 2 — DISTANCE ANALYSIS SUMMARY\n")
cat("======================================================\n")
cat(sprintf("Total hotels analysed: %d\n\n", nrow(hotel_distances)))

for (cn in CITIES) {
  s <- filter(hotel_distances, city == cn)
  cat(sprintf("── %s (n = %d) ──\n", cn, nrow(s)))
  cat(sprintf("  Nearest restaurant  : median %5.0f m  (%.0f%% within 1 km)\n",
              median(s$dist_restaurant_m, na.rm = TRUE),
              mean(s$dist_restaurant_m <= 1000, na.rm = TRUE) * 100))
  cat(sprintf("  Nearest attraction  : median %5.0f m  (%.0f%% within 1 km)\n",
              median(s$dist_attraction_m, na.rm = TRUE),
              mean(s$dist_attraction_m <= 1000, na.rm = TRUE) * 100))
  cat(sprintf("  Nearest prayer room : median %5.0f m  (%.0f%% within 1 km)\n\n",
              median(s$dist_prayer_m, na.rm = TRUE),
              mean(s$dist_prayer_m <= 1000, na.rm = TRUE) * 100))
}

message("Stage 2 complete. Outputs saved to ", getwd())

# =============================================================================
# END OF STAGE 2
# =============================================================================

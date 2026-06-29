# =============================================================================
# STAGE 1 — EXPLORATORY SPATIAL DATA ANALYSIS
# Muslim-Friendly Tourism Ecosystems in Taiwan
# Taipei · Taichung · Kaohsiung
#
# EMOJI LEGEND (consistent across all titles, labels, legends):
#     Halal-certified hotels / Hotel & Restaurant
#     Halal-certified restaurants
#     Tourist attractions
#     Prayer rooms & mosques
#     MRT stations
#
# Outputs:
#   stage1_taipei.png
#   stage1_taichung.png
#   stage1_kaohsiung.png
#   stage1_comparison.png
# =============================================================================

setwd("~/Downloads/big data")
source("00_data.R")   # always reload — guarantees correct CITY_LIMITS

pkgs <- c("ggspatial", "patchwork")
new  <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new)

library(ggspatial)
library(patchwork)

# ── Shared visual scales ───────────────────────────────────────────────────────
LAYERS <- c("Hotel", "Hotel & Restaurant", "Restaurant",
            "Tourist Attraction", "Prayer Room", "Mosque", "MRT Station")

LAYER_SHAPES <- c(16, 18, 15, 17, 25, 8, 3)
LAYER_COLORS <- c("#2166ac", "#762a83", "#d73027",
                  "#1a9641", "#e6820e", "#8b3a00", "#888888")
LAYER_SIZES  <- c(2.2, 2.2, 2.2, 2.0, 2.0, 3.5, 1.6)

names(LAYER_SHAPES) <- names(LAYER_COLORS) <- names(LAYER_SIZES) <- LAYERS

map_theme <- theme_void(base_size = 10) +
  theme(
    plot.background       = element_rect(fill = "#f5f5f5", colour = NA),
    panel.background      = element_rect(fill = "#f5f5f5", colour = NA),
    plot.title            = element_text(face = "bold", size = 11, margin = margin(b = 4)),
    plot.caption          = element_text(size = 5.5, colour = "grey50", hjust = 1),
    legend.position       = "right",
    legend.key            = element_rect(fill = NA, colour = NA),
    legend.text           = element_text(size = 7.5),
    legend.spacing.y      = unit(0.3, "cm"),
    legend.key.size       = unit(0.45, "cm"),
    legend.box.background = element_rect(colour = "#cccccc", fill = "white", linewidth = 0.4),
    legend.box.margin     = margin(4, 4, 4, 4)
  )

# ── City map builder ───────────────────────────────────────────────────────────
make_city_map <- function(city_name) {

  lim   <- CITY_LIMITS[[city_name]]
  dist  <- filter(districts, city == city_name)
  dlabs <- filter(dist_centroids, city == city_name)

  # Tag each sf layer with its legend label
  tag <- function(sf_obj, lyr) mutate(sf_obj, layer = lyr)

  fd1  <- filter(sf_d1,  city == city_name)
  fd2  <- filter(sf_d2,  city == city_name)
  fd3  <- filter(sf_d3,  city == city_name)
  fmrt <- filter(sf_mrt, city == city_name)

  p <- ggplot() +

    # District polygons and labels
    geom_sf(data = dist, fill = "white", colour = "#aaaaaa", linewidth = 0.4) +
    geom_text(data = dlabs, aes(cx, cy, label = district_en),
              size = 1.8, colour = "#444444", check_overlap = TRUE) +

    # Layers (drawn back-to-front so halal facilities sit on top)
    geom_sf(data = tag(fmrt, "MRT Station"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.45) +
    geom_sf(data = tag(fd2, "Tourist Attraction"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.75) +
    geom_sf(data = tag(filter(fd3, facility_category == "Prayer Room"), "Prayer Room"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.85) +
    geom_sf(data = tag(filter(fd3, facility_category == "Mosque"), "Mosque"),
            aes(colour = layer, shape = layer, size = layer)) +
    geom_sf(data = tag(filter(fd1, facility_type == "Restaurant"), "Restaurant"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.90) +
    geom_sf(data = tag(filter(fd1, facility_type == "Hotel"), "Hotel"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.92) +
    geom_sf(data = tag(filter(fd1, facility_type == "Hotel & Restaurant"), "Hotel & Restaurant"),
            aes(colour = layer, shape = layer, size = layer), alpha = 0.92) +

    # Unified colour / shape / size scales (control BOTH points AND legend)
    scale_colour_manual(name = NULL, values = LAYER_COLORS, breaks = LAYERS) +
    scale_shape_manual (name = NULL, values = LAYER_SHAPES, breaks = LAYERS) +
    scale_size_manual  (name = NULL, values = LAYER_SIZES,  breaks = LAYERS) +

    # North arrow and scale bar
    annotation_north_arrow(
      location = "bl", which_north = "true",
      pad_x = unit(0.3, "cm"), pad_y = unit(0.8, "cm"),
      style = north_arrow_fancy_orienteering(text_size = 8)
    ) +
    annotation_scale(
      location = "bl", width_hint = 0.25,
      pad_x = unit(0.3, "cm"), pad_y = unit(0.3, "cm"),
      text_cex = 0.6
    ) +

    coord_sf(xlim = lim$xlim, ylim = lim$ylim, expand = FALSE) +

    labs(
      title   = paste("Muslim-Friendly Tourism Infrastructure —", city_name),
      caption = "Data: Taiwan Tourism Administration · OpenStreetMap · MOI"
    ) +
    map_theme +
    guides(
      colour = guide_legend(override.aes = list(
        size = 3,
        fill = LAYER_COLORS   # shape=25 (Prayer Room) needs fill; others are unaffected
      )),
      shape  = guide_legend(override.aes = list(size = 3)),
      size   = "none"
    )

  p
}

# ── Produce and export individual city maps ────────────────────────────────────
map_taipei    <- make_city_map("Taipei")
map_taichung  <- make_city_map("Taichung")
map_kaohsiung <- make_city_map("Kaohsiung")

print(map_taipei)
print(map_taichung)
print(map_kaohsiung)

ggsave("stage1_taipei.png",    map_taipei,    width = 9,  height = 10, dpi = 300, bg = "white")
ggsave("stage1_taichung.png",  map_taichung,  width = 9,  height = 10, dpi = 300, bg = "white")
ggsave("stage1_kaohsiung.png", map_kaohsiung, width = 9,  height = 10, dpi = 300, bg = "white")

# ── Three-city comparison panel ────────────────────────────────────────────────
comparison <- (map_taipei | map_taichung | map_kaohsiung) +
  plot_annotation(
    title   = "Muslim-Friendly Tourism Ecosystems in Taiwan",
    caption = "Data: Taiwan Tourism Administration · OpenStreetMap · MOI",
    theme   = theme(plot.title = element_text(face = "bold", size = 14))
  ) &
  theme(legend.position = "right")

print(comparison)
ggsave("stage1_comparison.png", comparison, width = 27, height = 10, dpi = 300, bg = "white")

# ── Facility count summary ─────────────────────────────────────────────────────
counts <- tibble(City = CITIES) %>%
  mutate(
    `Hotels`= map_int(City, ~sum(sf_d1$city == .x & sf_d1$facility_type == "Hotel")),
    `Hotel & Restaurant`= map_int(City, ~sum(sf_d1$city == .x & sf_d1$facility_type == "Hotel & Restaurant")),
    `Restaurants`= map_int(City, ~sum(sf_d1$city == .x & sf_d1$facility_type == "Restaurant")),
    `Attractions`= map_int(City, ~sum(sf_d2$city == .x)),
    `Prayer Rooms`= map_int(City, ~sum(sf_d3$city == .x & sf_d3$facility_category == "Prayer Room")),
    `Mosques`= map_int(City, ~sum(sf_d3$city == .x & sf_d3$facility_category == "Mosque")),
    `MRT Stations`= map_int(City, ~sum(sf_mrt$city == .x))
  )

cat("\n──  Stage 1 Facility Counts ───────────────────────────\n")
print(counts)
message("\nStage 1 complete. Maps saved to ", getwd())

# =============================================================================
# END OF STAGE 1
# =============================================================================

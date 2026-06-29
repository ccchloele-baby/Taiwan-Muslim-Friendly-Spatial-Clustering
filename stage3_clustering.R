# =============================================================================
# STAGE 3 — SPATIAL CONCENTRATION AND INFRASTRUCTURE INTENSITY
# Muslim-Friendly Tourism Ecosystems in Taiwan
# Taipei · Taichung · Kaohsiung
#
# Purpose:
#   Identify where Muslim-friendly tourism resources are concentrated.
#   Moran's I is retained as a statistical check, but the main interpretation is
#   descriptive because each city has only 8-12 districts.
#
# Outputs:
#   stage3_intensity_comparison.png       — district support intensity
#   stage3_composition_by_district.png    — facility mix by district
#   stage3_kde_taipei.png                 — descriptive point-density map
#   stage3_kde_taichung.png
#   stage3_kde_kaohsiung.png
#   stage3_kde_comparison.png
#   stage3_kde_mrt_comparison.png         — same KDE map with MRT overlay
#   stage3_moran_results.csv              — global Moran's I table
#   stage3_district_intensity.csv         — district-level input table
# =============================================================================

setwd("~/Downloads/big data")
if (!exists("DATA_VERSION") || DATA_VERSION < 10L) source("00_data.R")

pkgs <- c("spatstat.geom", "spatstat.explore", "spdep", "patchwork", "scales")
new  <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new)

library(spatstat.geom)
library(spatstat.explore)
library(spdep)
library(patchwork)
library(scales)

# =============================================================================
# SECTION 1 — DISTRICT-LEVEL RESOURCE COUNTS
# =============================================================================

pip_count <- function(pts, poly) {
  if (nrow(pts) == 0) return(integer(nrow(poly)))
  joined <- st_join(pts["geometry"], poly["dist_id"], left = FALSE)
  counts <- st_drop_geometry(joined) %>% count(dist_id)
  poly %>%
    st_drop_geometry() %>%
    select(dist_id) %>%
    left_join(counts, by = "dist_id") %>%
    mutate(n = replace_na(n, 0L)) %>%
    pull(n)
}

districts <- districts %>%
  mutate(
    n_halal      = pip_count(sf_d1, districts),
    n_attraction = pip_count(sf_d2, districts),
    n_prayer     = pip_count(sf_d3, districts),
    support_intensity = n_halal + n_prayer
  )

district_intensity <- districts %>%
  st_drop_geometry() %>%
  select(city, district, district_en, n_halal, n_attraction, n_prayer,
         support_intensity) %>%
  arrange(city, desc(support_intensity))

write_csv(district_intensity, "stage3_district_intensity.csv")

# =============================================================================
# SECTION 2 — MORAN'S I AS A STATISTICAL CHECK
# =============================================================================

make_listw <- function(poly) {
  nb2listw(poly2nb(poly, queen = TRUE, snap = 1), style = "W", zero.policy = TRUE)
}

VAR_MAP <- list(
  list(col = "support_intensity", lab = "Muslim-Friendly Support Intensity"),
  list(col = "n_halal",                  lab = "Halal Facilities"),
  list(col = "n_attraction",             lab = "Tourist Attractions"),
  list(col = "n_prayer",                 lab = "Prayer Rooms / Mosques")
)

run_moran <- function(city_name, var_col, var_label) {
  df <- filter(districts, city == city_name)
  x  <- df[[var_col]]

  if (var(x, na.rm = TRUE) == 0) {
    return(tibble(city = city_name, variable = var_label,
                  moran_I = NA_real_, z_score = NA_real_,
                  p_value = NA_real_, result = "No variation"))
  }

  mt <- moran.test(x, make_listw(df), zero.policy = TRUE)
  i  <- mt$estimate["Moran I statistic"]
  e  <- mt$estimate["Expectation"]
  v  <- mt$estimate["Variance"]

  tibble(city = city_name, variable = var_label,
         moran_I = round(i, 4),
         z_score = round((i - e) / sqrt(v), 3),
         p_value = round(mt$p.value, 4),
         result  = case_when(
           mt$p.value < 0.05 & i > e ~ "Clustered",
           mt$p.value < 0.05 & i < e ~ "Dispersed",
           TRUE ~ "Random"))
}

moran_results <- map_dfr(CITIES, function(cn) {
  map_dfr(VAR_MAP, ~run_moran(cn, .x$col, .x$lab))
})

cat("\n-- Global Moran's I: district-level spatial autocorrelation --\n")
print(moran_results)
write_csv(moran_results, "stage3_moran_results.csv")

# =============================================================================
# SECTION 3 — MUSLIM-FRIENDLY SUPPORT INTENSITY CHOROPLETH
# =============================================================================

INTENSITY_MAX <- max(districts$support_intensity, na.rm = TRUE)

make_intensity_map <- function(city_name) {
  df   <- filter(districts, city == city_name)
  lim  <- CITY_LIMITS[[city_name]]
  dlbs <- filter(dist_centroids, city == city_name) %>%
    st_drop_geometry() %>%
    left_join(st_drop_geometry(df) %>%
                select(dist_id, support_intensity),
              by = "dist_id") %>%
    mutate(label = paste0(district_en, "\n", support_intensity))

  ggplot(df) +
    geom_sf(aes(fill = support_intensity),
            colour = "white", linewidth = 0.35) +
    geom_text(data = dlbs, aes(cx, cy, label = label),
              size = 2.0, colour = "grey12", lineheight = 0.9,
              check_overlap = TRUE) +
    scale_fill_gradient(
      low = "#f7fbff", high = "#08519c",
      limits = c(0, INTENSITY_MAX),
      name = "Support\nintensity",
      labels = label_number(accuracy = 1)
    ) +
    coord_sf(xlim = lim$xlim, ylim = lim$ylim, expand = FALSE) +
    labs(
      title = city_name,
      subtitle = "Halal facilities + prayer facilities; tourist attractions shown separately",
      caption = "District-level Muslim-friendly support score; not the Stage 4 hotel qualification measure"
    ) +
    theme_void(base_size = 9) +
    theme(
      plot.background = element_rect(fill = "#f8f8f8", colour = NA),
      plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
      plot.subtitle = element_text(size = 7.5, colour = "grey35", hjust = 0.5),
      plot.caption = element_text(size = 5.5, colour = "grey50", hjust = 1),
      legend.position = "right",
      legend.title = element_text(size = 7, face = "bold"),
      legend.text = element_text(size = 6.5)
    )
}

intensity_maps <- map(CITIES, make_intensity_map)
names(intensity_maps) <- CITIES

intensity_comparison <- wrap_plots(intensity_maps, nrow = 1) +
  plot_annotation(
    title = "Stage 3 — District Muslim-Friendly Support Intensity",
    subtitle = "Higher scores indicate stronger concentration of halal and prayer-support infrastructure",
    caption = "Support intensity = halal hotels/restaurants + prayer rooms/mosques; tourist attractions are contextual",
    theme = theme(
      plot.title = element_text(face = "bold", size = 15),
      plot.subtitle = element_text(size = 10, colour = "grey35"),
      plot.caption = element_text(size = 7, colour = "grey50")
    )
  )

print(intensity_comparison)
ggsave("stage3_intensity_comparison.png", intensity_comparison,
       width = 24, height = 9, dpi = 300, bg = "white")
message("Intensity comparison saved -> stage3_intensity_comparison.png")

# =============================================================================
# SECTION 4 — FACILITY COMPOSITION BY DISTRICT
# =============================================================================

composition_data <- district_intensity %>%
  mutate(district_label = paste(city, district_en, sep = " - "),
         district_label = reorder(district_label, support_intensity)) %>%
  pivot_longer(
    cols = c(n_halal, n_attraction, n_prayer),
    names_to = "resource_type",
    values_to = "count"
  ) %>%
  mutate(
    resource_type = recode(
      resource_type,
      n_halal = "Halal hotels/restaurants",
      n_attraction = "Tourist attractions",
      n_prayer = "Prayer rooms/mosques"
    ),
    resource_type = factor(
      resource_type,
      levels = c("Halal hotels/restaurants", "Tourist attractions",
                 "Prayer rooms/mosques")
    )
  )

composition_chart <- ggplot(
  composition_data,
  aes(x = district_label, y = count, fill = resource_type)
) +
  geom_col(width = 0.72, colour = "white", linewidth = 0.15) +
  coord_flip() +
  facet_wrap(~city, scales = "free_y", nrow = 1) +
  scale_fill_manual(
    values = c(
      "Halal hotels/restaurants" = "#2166ac",
      "Tourist attractions" = "#1a9641",
      "Prayer rooms/mosques" = "#e6820e"
    ),
    name = NULL
  ) +
  labs(
    title = "Stage 3 — Facility Composition by District",
    subtitle = "Tourist attractions are shown as context, separate from the support-intensity score",
    x = NULL, y = "Number of facilities",
    caption = "Counts are clipped to the original city-core districts used in this study"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 9, colour = "grey35"),
    plot.caption = element_text(size = 7, colour = "grey50"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    strip.text = element_text(face = "bold"),
    axis.text.y = element_text(size = 7)
  )

print(composition_chart)
ggsave("stage3_composition_by_district.png", composition_chart,
       width = 14, height = 8, dpi = 300, bg = "white")
message("Composition chart saved -> stage3_composition_by_district.png")

# =============================================================================
# SECTION 5 — ATTRACTION + PRAYER KDE WITH HALAL FACILITY OVERLAY
# =============================================================================

KDE_SIGMA <- 800

HALAL_BUBBLE_GRID <- c("Taipei" = 1800, "Taichung" = 800, "Kaohsiung" = 800)
HALAL_BUBBLE_SIZE_RANGE <- c(2.8, 14)
HALAL_BUBBLE_LIMITS <- c(1, 15)
HALAL_BUBBLE_BREAKS <- c(1, 5, 10, 15)
MRT_LINK_K <- 2
MRT_LINK_MAX_DIST <- c("Taipei" = 2200, "Taichung" = 2500, "Kaohsiung" = 3500)

make_halal_bubbles <- function(halal_pts, grid_size = HALAL_BUBBLE_GRID) {
  if (nrow(halal_pts) == 0) return(halal_pts)
  xy <- st_coordinates(halal_pts)
  st_drop_geometry(halal_pts) %>%
    mutate(
      x = xy[, "X"],
      y = xy[, "Y"],
      gx = round(x / grid_size) * grid_size,
      gy = round(y / grid_size) * grid_size
    ) %>%
    group_by(gx, gy) %>%
    summarise(
      n_halal = n(),
      bx = mean(x),
      by = mean(y),
      label = paste(sort(unique(facility_type)), collapse = " + "),
      .groups = "drop"
    ) %>%
    st_as_sf(coords = c("bx", "by"), crs = st_crs(halal_pts))
}

make_mrt_edges <- function(mrt_pts, max_dist, k = MRT_LINK_K) {
  empty_edges <- st_sf(
    edge_id = integer(),
    geometry = st_sfc(crs = st_crs(mrt_pts))
  )
  if (nrow(mrt_pts) < 2) return(empty_edges)

  xy <- st_coordinates(mrt_pts)
  dm <- matrix(as.numeric(st_distance(mrt_pts)),
               nrow = nrow(mrt_pts), ncol = nrow(mrt_pts))
  diag(dm) <- Inf

  edge_tbl <- map_dfr(seq_len(nrow(mrt_pts)), function(i) {
    ordered <- order(dm[i, ])
    near <- ordered[is.finite(dm[i, ordered]) & dm[i, ordered] <= max_dist]
    near <- near[seq_len(min(k, length(near)))]
    tibble(from = i, to = near, dist_m = as.numeric(dm[i, near]))
  })

  if (nrow(edge_tbl) == 0) return(empty_edges)

  edge_tbl <- edge_tbl %>%
    mutate(a = pmin(from, to), b = pmax(from, to)) %>%
    distinct(a, b, .keep_all = TRUE)

  geoms <- st_sfc(
    lapply(seq_len(nrow(edge_tbl)), function(i) {
      st_linestring(rbind(
        xy[edge_tbl$a[i], c("X", "Y")],
        xy[edge_tbl$b[i], c("X", "Y")]
      ))
    }),
    crs = st_crs(mrt_pts)
  )

  st_sf(edge_id = seq_len(nrow(edge_tbl)), dist_m = edge_tbl$dist_m,
        geometry = geoms)
}

sf_to_ppp <- function(pts, win_sf) {
  xy  <- st_coordinates(pts)
  win <- as.owin(st_geometry(st_union(win_sf)))
  ppp(xy[, "X"], xy[, "Y"], window = win, check = FALSE)
}

make_kde_map <- function(city_name, show_mrt = FALSE) {
  lim  <- CITY_LIMITS[[city_name]]
  dist <- filter(districts, city == city_name)
  win  <- filter(city_boundaries, city == city_name)
  dlbs <- filter(dist_centroids, city == city_name)

  kde_pts <- bind_rows(
    filter(sf_d2, city == city_name) %>%
      select(geometry) %>% mutate(resource_type = "Attraction"),
    filter(sf_d3, city == city_name) %>%
      select(geometry) %>% mutate(resource_type = "Prayer room/mosque")
  )

  halal_pts <- filter(sf_d1, city == city_name)
  halal_grid <- HALAL_BUBBLE_GRID[[city_name]]
  halal_bubbles <- make_halal_bubbles(halal_pts, grid_size = halal_grid)
  mrt_pts <- filter(sf_mrt, city == city_name)
  mrt_edges <- make_mrt_edges(
    mrt_pts,
    max_dist = MRT_LINK_MAX_DIST[[city_name]],
    k = MRT_LINK_K
  )

  if (nrow(kde_pts) == 0) {
    return(
      ggplot() +
        geom_sf(data = dist, fill = "grey92", colour = "white", linewidth = 0.4) +
        {if (show_mrt && nrow(mrt_edges) > 0) geom_sf(data = mrt_edges, colour = "#26547c", linewidth = 0.45, alpha = 0.68)} +
        {if (show_mrt && nrow(mrt_pts) > 0) geom_sf(data = mrt_pts, shape = 21, size = 1.2, fill = "#ffffff", colour = "#26547c", stroke = 0.35, alpha = 0.95)} +
        geom_sf(data = halal_bubbles, aes(size = n_halal),
                shape = 21, fill = "#a63603", colour = "white", alpha = 0.82) +
        scale_size_continuous(
          range = HALAL_BUBBLE_SIZE_RANGE,
          limits = HALAL_BUBBLE_LIMITS,
          breaks = HALAL_BUBBLE_BREAKS,
          name = "Halal facilities"
        ) +
        labs(title = city_name,
             subtitle = "No attraction/prayer points available for KDE") +
        theme_void(base_size = 9)
    )
  }

  kde_im  <- density(sf_to_ppp(kde_pts, win), sigma = KDE_SIGMA)

  kde_grid <- expand.grid(x = kde_im$xcol, y = kde_im$yrow) %>%
    mutate(kde_density = as.vector(t(kde_im$v))) %>%
    filter(!is.na(kde_density), is.finite(kde_density)) %>%
    st_as_sf(coords = c("x", "y"), crs = st_crs(dist)) %>%
    st_filter(dist)

  kde_by_district <- st_join(kde_grid, dist["dist_id"], left = FALSE)

  district_kde <- kde_by_district %>%
    st_drop_geometry() %>%
    group_by(dist_id) %>%
    summarise(kde_density = mean(kde_density, na.rm = TRUE), .groups = "drop")

  dist_plot <- dist %>%
    left_join(district_kde, by = "dist_id") %>%
    mutate(kde_density = replace_na(kde_density, 0))

  p <- ggplot() +
    geom_sf(data = dist_plot, aes(fill = kde_density),
            colour = "white", linewidth = 0.3) +
    scale_fill_gradient(
      low = "#fde8f0", high = "#9d1d49",
      name = "\nKDE density\nattractions +\nprayer points",
      na.value = "grey90",
      guide = guide_colorbar(title.position = "top",
                             barwidth = 0.55, barheight = 3.5,
                             ticks = FALSE)
    ) +
    geom_sf(data = dist, fill = NA, colour = "#888888", linewidth = 0.22) +
    {if (show_mrt && nrow(mrt_edges) > 0) geom_sf(data = mrt_edges, colour = "#26547c", linewidth = 0.5, alpha = 0.72)} +
    {if (show_mrt && nrow(mrt_pts) > 0) geom_sf(data = mrt_pts, shape = 21, size = 1.2, fill = "#ffffff", colour = "#26547c", stroke = 0.35, alpha = 0.95)} +
    geom_sf(data = kde_pts, aes(colour = resource_type, shape = resource_type),
            size = 0.75, alpha = 0.55) +
    geom_text(data = dlbs, aes(cx, cy, label = district_en),
              size = 1.7, colour = "grey15", check_overlap = TRUE) +
    geom_sf(data = halal_bubbles, aes(size = n_halal),
            shape = 21, fill = "#a63603", colour = "white",
            alpha = 0.82, stroke = 0.25) +
    scale_colour_manual(
      values = c("Attraction" = "#1a9641", "Prayer room/mosque" = "#e6820e"),
      name = "KDE source points"
    ) +
    scale_shape_manual(
      values = c("Attraction" = 16, "Prayer room/mosque" = 17),
      name = "KDE source points"
    ) +
    scale_size_continuous(
      range = HALAL_BUBBLE_SIZE_RANGE,
      limits = HALAL_BUBBLE_LIMITS,
      breaks = HALAL_BUBBLE_BREAKS,
      name = "Halal facilities\nnear this location"
    ) +
    coord_sf(xlim = lim$xlim, ylim = lim$ylim, expand = FALSE) +
    labs(
      title = paste("KDE Concentration —", city_name),
      subtitle = sprintf(
        "Fill: attraction + prayer KDE; small points: KDE inputs; bubbles: grouped halal facility locations; sigma = %d m",
        KDE_SIGMA
      ),
      caption = sprintf("Halal bubbles combine Hotel, Hotel & Restaurant, and Restaurant records within %d m grid cells", halal_grid)
    ) +
    theme_void(base_size = 9) +
    theme(
      plot.background = element_rect(fill = "#f9f9f9", colour = NA),
      plot.title = element_text(face = "bold", size = 11),
      plot.subtitle = element_text(size = 7, colour = "grey35"),
      plot.caption = element_text(size = 5.5, colour = "grey50", hjust = 1),
      legend.position = "right",
      legend.title = element_text(size = 7, face = "bold"),
      legend.text = element_text(size = 6.5),
      legend.key.size = unit(0.35, "cm"),
      legend.spacing.y = unit(0.4, "cm")
    )

  if (show_mrt) {
    p <- p +
      labs(
        subtitle = sprintf(
          "Fill: attraction + prayer KDE; blue network: MRT station proximity overlay; bubbles: grouped halal facilities; sigma = %d m",
          KDE_SIGMA
        ),
        caption = sprintf(
          "MRT overlay uses station coordinates connected to nearby stations because the MRT workbook has no line field; halal bubbles grouped within %d m grid cells",
          halal_grid
        )
      )
  }

  p
}

kde_maps <- list()
for (cn in CITIES) {
  p <- make_kde_map(cn)
  kde_maps[[cn]] <- p
  print(p)
  fname <- sprintf("stage3_kde_%s.png", tolower(cn))
  ggsave(fname, p, width = 10, height = 9, dpi = 300, bg = "white")
  message("KDE saved -> ", fname)
}

kde_comparison <- wrap_plots(kde_maps, nrow = 1) +
  plot_annotation(
    title = "Stage 3 — KDE Concentration with Support Bubbles",
    subtitle = "Fill = density of tourist attractions and prayer facilities; bubbles = grouped halal facility locations",
    caption = sprintf("KDE inputs: Dataset 2 attractions + Dataset 3 prayer facilities; bubbles: Dataset 1 halal facilities grouped within city-specific grid cells; Gaussian kernel sigma = %d m; TWD97 EPSG:3826", KDE_SIGMA),
    theme = theme(
      plot.title = element_text(face = "bold", size = 15),
      plot.subtitle = element_text(size = 10, colour = "grey35"),
      plot.caption = element_text(size = 7, colour = "grey50")
    )
  )

print(kde_comparison)
ggsave("stage3_kde_comparison.png", kde_comparison,
       width = 28, height = 10, dpi = 300, bg = "white")
message("KDE comparison saved -> stage3_kde_comparison.png")

kde_mrt_maps <- list()
for (cn in CITIES) {
  p <- make_kde_map(cn, show_mrt = TRUE)
  kde_mrt_maps[[cn]] <- p
  print(p)
  fname <- sprintf("stage3_kde_mrt_%s.png", tolower(cn))
  ggsave(fname, p, width = 10, height = 9, dpi = 300, bg = "white")
  message("KDE + MRT saved -> ", fname)
}

kde_mrt_comparison <- wrap_plots(kde_mrt_maps, nrow = 1) +
  plot_annotation(
    title = "Stage 3 — KDE Concentration with MRT Overlay",
    subtitle = "Fill = density of tourist attractions and prayer facilities; blue network = MRT station proximity overlay; bubbles = grouped halal facility locations",
    caption = sprintf("KDE inputs: Dataset 2 attractions + Dataset 3 prayer facilities; MRT overlay: station coordinates connected to nearby stations; bubbles: Dataset 1 halal facilities grouped within city-specific grid cells; Gaussian kernel sigma = %d m; TWD97 EPSG:3826", KDE_SIGMA),
    theme = theme(
      plot.title = element_text(face = "bold", size = 15),
      plot.subtitle = element_text(size = 10, colour = "grey35"),
      plot.caption = element_text(size = 7, colour = "grey50")
    )
  )

print(kde_mrt_comparison)
ggsave("stage3_kde_mrt_comparison.png", kde_mrt_comparison,
       width = 28, height = 10, dpi = 300, bg = "white")
message("KDE + MRT comparison saved -> stage3_kde_mrt_comparison.png")

# =============================================================================
# CONSOLE SUMMARY
# =============================================================================

cat("\n======================================================\n")
cat("STAGE 3 — SPATIAL CONCENTRATION SUMMARY\n")
cat("======================================================\n\n")

cat("District-level resource totals:\n")
districts %>%
  st_drop_geometry() %>%
  group_by(city) %>%
  summarise(
    districts = n(),
    halal_facilities = sum(n_halal),
    tourist_attractions = sum(n_attraction),
    prayer_facilities = sum(n_prayer),
    support_intensity = sum(support_intensity),
    .groups = "drop"
  ) %>%
  print()

cat("\nTop districts by support intensity:\n")
district_intensity %>%
  group_by(city) %>%
  slice_max(support_intensity, n = 5, with_ties = FALSE) %>%
  ungroup() %>%
  select(city, district_en, n_halal, n_attraction, n_prayer,
         support_intensity) %>%
  print(n = 20)

cat("\nGlobal Moran's I statistical check:\n")
print(moran_results)

cat("\nInterpretation note:\n")
cat("  Moran's I tests whether similar districts are adjacent. Mostly random\n")
cat("  results mean high-resource districts exist, but they are not consistently\n")
cat("  surrounded by other high-resource districts at the district scale.\n\n")

cat("Outputs saved to:", getwd(), "\n")
cat("  stage3_intensity_comparison.png\n")
cat("  stage3_composition_by_district.png\n")
cat("  stage3_kde_taipei.png | stage3_kde_taichung.png | stage3_kde_kaohsiung.png\n")
cat("  stage3_kde_comparison.png\n")
cat("  stage3_kde_mrt_taipei.png | stage3_kde_mrt_taichung.png | stage3_kde_mrt_kaohsiung.png\n")
cat("  stage3_kde_mrt_comparison.png\n")
cat("  stage3_moran_results.csv\n")
cat("  stage3_district_intensity.csv\n")
cat("======================================================\n")

# =============================================================================
# END OF STAGE 3
# =============================================================================

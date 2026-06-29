# =============================================================================
# 00_data.R — Load, clean, and project all datasets
# Muslim-Friendly Tourism Ecosystems in Taiwan
# Source this file at the top of every stage script.
# =============================================================================

# ── Version stamp — increment this whenever 00_data.R changes ─────────────────
# Stage scripts check DATA_VERSION; a mismatch forces a full re-source so
# cached objects from an older run are never accidentally reused.
DATA_VERSION <- 10L

# ── Clear any stale objects from a previous session ───────────────────────────
rm(list = intersect(
  ls(),
  c("sf_d1", "sf_d2", "sf_d3", "sf_mrt",
    "districts", "dist_centroids", "city_boundaries", "CITY_LIMITS",
    "TAICHUNG_ORIG_DIST", "KAOHSIUNG_ORIG_DIST",
    "TAICHUNG_ORIG_EN", "KAOHSIUNG_ORIG_EN",
    "taiwan_dist", "d1", "d2", "d3", "d3_pr", "d3_mo", "mrt",
    "filter_to_orig_cities", "to_sf")
))

pkgs <- c("tidyverse", "sf", "readxl", "janitor")
new  <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(new)) install.packages(new)

library(tidyverse)
library(sf)
library(readxl)
library(janitor)

# ── Paths ─────────────────────────────────────────────────────────────────────
DATA_DIR <- path.expand("~/Downloads")
SHP_PATH <- path.expand("~/Downloads/OFiles_9e222fea-bafb-4436-9b17-10921abc6ef2 2/TOWN_MOI_1140318.shp")
OUT_DIR  <- path.expand("~/Downloads/big data")

CITIES <- c("Taipei", "Taichung", "Kaohsiung")

D1_CANDIDATES <- c(
  file.path(OUT_DIR,  "Dataset 1 — Halal-Certified Hotels and Restaurants (1).xlsx"),
  file.path(DATA_DIR, "Dataset 1 — Halal-Certified Hotels and Restaurants (1).xlsx"),
  file.path(DATA_DIR, "Dataset 1 — Halal-Certified Hotels and Restaurants.xlsx")
)
D1_PATH <- D1_CANDIDATES[file.exists(D1_CANDIDATES)][1]
if (is.na(D1_PATH)) {
  stop("Dataset 1 workbook not found. Checked: ", paste(D1_CANDIDATES, collapse = " | "))
}

# ── Load raw Excel files ───────────────────────────────────────────────────────
d1_raw <- read_excel(
  D1_PATH,
  sheet = "Hotel & restaurant"
) %>% clean_names()

d2_raw <- read_excel(
  file.path(DATA_DIR, "Dataset 2 — Tourist Attractions (1).xlsx"),
  sheet = "Summary"
) %>% clean_names()

d3_pr_raw <- read_excel(
  file.path(DATA_DIR, "Dataset 3 — Prayer Rooms and Mosques (1).xlsx"),
  sheet = "Muslim-Friendly Facilities"
) %>% clean_names()

d3_mo_raw <- read_excel(
  file.path(DATA_DIR, "Dataset 3 — Prayer Rooms and Mosques (1).xlsx"),
  sheet = "Mosque"
) %>% clean_names()

mrt_raw <- read_excel(
  file.path(DATA_DIR, "MRT - cord.xlsx"),
  sheet = "Sheet1"
) %>% clean_names()

# ── Standardise and filter ────────────────────────────────────────────────────

# D1: halal hotels & restaurants
d1 <- d1_raw %>%
  rename(name = facility_name) %>%
  mutate(
    latitude  = parse_number(as.character(latitude)),
    longitude = parse_number(as.character(longitude))
  ) %>%
  distinct(name, facility_type, city, district, latitude, longitude, .keep_all = TRUE) %>%
  filter(city %in% CITIES, !is.na(latitude), !is.na(longitude))

# D2: tourist attractions
d2 <- d2_raw %>%
  rename(name = attraction_name) %>%
  filter(city %in% CITIES, !is.na(latitude), !is.na(longitude))

# D3: prayer rooms (from Muslim-Friendly Facilities sheet)
d3_pr <- d3_pr_raw %>%
  rename(name = organization_name) %>%
  filter(city %in% CITIES, !is.na(latitude), !is.na(longitude)) %>%
  select(name, latitude, longitude, city, district, facility_category, address)

# D3: mosques (from Mosque sheet — no district column, add it as NA)
d3_mo <- d3_mo_raw %>%
  rename(name = organization_name) %>%
  mutate(facility_category = "Mosque", district = NA_character_) %>%
  filter(city %in% CITIES, !is.na(latitude), !is.na(longitude)) %>%
  select(name, latitude, longitude, city, district, facility_category, address)

d3 <- bind_rows(d3_pr, d3_mo)

# MRT stations
mrt <- mrt_raw %>%
  rename(name = station) %>%
  filter(city %in% CITIES, !is.na(latitude), !is.na(longitude))

# ── Convert to sf, reproject to TWD97 EPSG:3826 ───────────────────────────────
to_sf <- function(df, lon = "longitude", lat = "latitude") {
  df %>%
    mutate(across(all_of(c(lon, lat)), ~parse_number(as.character(.x)))) %>%
    st_as_sf(coords = c(lon, lat), crs = 4326) %>%
    st_transform(3826)
}

sf_d1  <- to_sf(d1)
sf_d2  <- to_sf(d2)
sf_d3  <- to_sf(d3)
sf_mrt <- to_sf(mrt)

# ── Administrative boundaries (district shapefile) ────────────────────────────
taiwan_dist <- st_read(SHP_PATH, options = "ENCODING=UTF-8", quiet = TRUE) %>%
  st_transform(3826)

# ── Original city district lists (pre-2010 merger) ────────────────────────────
# Filtered using the English romanisation from TOWNENG (shapefile-native,
# no encoding risk) rather than Chinese characters that may differ by variant.
TAICHUNG_ORIG_EN  <- c("Central", "East", "West", "South", "North",
                        "Xitun", "Nantun", "Beitun")
KAOHSIUNG_ORIG_EN <- c("Xinxing", "Qianjin", "Lingya", "Yancheng", "Gushan",
                        "Cijin", "Qijin", "Qianzhen", "Sanmin", "Nanzi",
                        "Xiaogang", "Zuoying")

# Keep Chinese names for back-compat (used in memory notes / comments)
TAICHUNG_ORIG_DIST  <- c("中區", "東區", "西區", "南區", "北區",
                           "西屯區", "南屯區", "北屯區")
KAOHSIUNG_ORIG_DIST <- c("新興區", "前金區", "苓雅區", "鹽埕區", "鼓山區",
                           "旗津區", "前鎮區", "三民區", "楠梓區", "小港區", "左營區")

all_districts <- taiwan_dist %>%
  filter(COUNTYNAME %in% c("臺北市", "臺中市", "高雄市")) %>%
  mutate(
    city        = case_when(
      COUNTYNAME == "臺北市" ~ "Taipei",
      COUNTYNAME == "臺中市" ~ "Taichung",
      COUNTYNAME == "高雄市" ~ "Kaohsiung"
    ),
    district    = TOWNNAME,
    district_en = str_remove(TOWNENG, "\\s+District$") %>% str_squish()
  )

districts <- all_districts %>%
  filter(
    (city == "Taipei") |
    (city == "Taichung"  & district_en %in% TAICHUNG_ORIG_EN) |
    (city == "Kaohsiung" & district_en %in% KAOHSIUNG_ORIG_EN)
  ) %>%
  mutate(dist_id = row_number())

# Verify — warn loudly if any city ended up with 0 districts (name mismatch)
n_dist <- districts %>%
  st_drop_geometry() %>%
  count(city, name = "n") %>%
  complete(city = CITIES, fill = list(n = 0L))
cat("\n── Districts kept per city after pre-merger filter ─────────\n")
print(n_dist)
missing <- filter(n_dist, n == 0)$city
if (length(missing) > 0) {
  warning("0 districts kept for: ", paste(missing, collapse = ", "),
          " — check TOWNENG values in shapefile vs filter lists above")
}

# District centroids for map labels
dist_centroids <- districts %>%
  mutate(
    cx = map_dbl(geometry, ~st_centroid(.) %>% st_coordinates() %>% .[, "X"]),
    cy = map_dbl(geometry, ~st_centroid(.) %>% st_coordinates() %>% .[, "Y"])
  )

# City boundary unions (KDE window)
# These are now derived from the filtered (original-city-only) district polygons
city_boundaries <- districts %>%
  group_by(city) %>%
  summarise(geometry = st_union(geometry), .groups = "drop")

# ── Clip all point datasets to original city boundaries ───────────────────────
# Removes any facilities whose coordinates fall in the former county areas that
# are now part of the merged municipality but outside the original urban cores.
filter_to_orig_cities <- function(sf_pts) {
  map_dfr(CITIES, function(cn) {
    sub <- sf_pts %>% filter(city == cn)
    if (nrow(sub) == 0) return(sub)          # skip st_filter on empty sf
    bounds <- filter(city_boundaries, city == cn)
    st_filter(sub, bounds)
  })
}
sf_d1  <- filter_to_orig_cities(sf_d1)
sf_d2  <- filter_to_orig_cities(sf_d2)
sf_d3  <- filter_to_orig_cities(sf_d3)
sf_mrt <- filter_to_orig_cities(sf_mrt)

# ── Map coordinate limits — computed from filtered district bounding boxes ─────
# [[ ]] extracts plain scalars (no name attribute), giving coord_sf clean
# numeric vectors.  10 % margin added on every side.
CITY_LIMITS <- setNames(lapply(CITIES, function(cn) {
  extent_districts <- filter(districts, city == cn)
  if (cn == "Kaohsiung") {
    # Qijin includes remote island geometry in this MOI file; keep it for
    # analysis, but exclude it from the plotting window so urban maps stay legible.
    extent_districts <- filter(extent_districts, district_en != "Qijin")
  }
  bb   <- st_bbox(extent_districts)
  xmin <- bb[["xmin"]];  xmax <- bb[["xmax"]]
  ymin <- bb[["ymin"]];  ymax <- bb[["ymax"]]
  xpad <- (xmax - xmin) * 0.10
  ypad <- (ymax - ymin) * 0.10
  list(xlim = c(xmin - xpad, xmax + xpad),
       ylim = c(ymin - ypad, ymax + ypad))
}), CITIES)

# Print so we can verify the numbers look sensible
cat("\n── CITY_LIMITS (TWD97 metres) ───────────────────────────────\n")
for (cn in CITIES) {
  lim <- CITY_LIMITS[[cn]]
  cat(sprintf("  %-12s  x [%7.0f – %7.0f]   y [%7.0f – %7.0f]\n",
              cn, lim$xlim[1], lim$xlim[2], lim$ylim[1], lim$ylim[2]))
}

message("00_data.R: all objects ready (sf_d1, sf_d2, sf_d3, sf_mrt, districts, city_boundaries).")

# ---- Load libs ----
library(tidyverse)
library(readxl)
library(sf)
library(geographr)

# - raw -
lba_england <-
  read_excel("data-raw/lba-england.xlsx") |>
  select(
    ward17_code = `Ward Code`
  )

lba_wales <-
  read_excel("data-raw/lba-wales.xlsx") |>
  select(
    msoa11_code = MSOA
  )

lba_scotland <-
  read_excel(
    "data-raw/lba-scotland.xlsx"
  ) |>
  select(
    iz11_code = `Area code`
  ) |>
  mutate(iz11_code = str_to_upper(iz11_code))

lba_ni <-
  read_excel(
    "data-raw/lba-ni.xlsx"
  ) |>
  select(
    soa11_code = `LSOA code`
  )

# - Boundaries -
# OCSI used 2017 wards
raw <-
  read_sf("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/WGS84_UK_Wards_December_2017_Boundaries/MapServer/3/query?outFields=*&where=1%3D1&f=geojson")

boundaries_wards17 <-
  raw |>
  st_transform(crs = 4326) |>
  st_make_valid() |>
  # ms_simplify(keep = 0.6) |> # any lower and areas are dropped
  select(ward17_code = wd17cd, ward17_name = wd17nm)

boundaries_lba_england <-
  boundaries_wards17 |>
  right_join(lba_england) |>
  rename(
    lba_name = ward17_name,
    lba_code = ward17_code
  )

boundaries_lba_wales <-
  boundaries_msoa11 |>
  right_join(lba_wales) |>
  rename(
    lba_name = msoa11_name,
    lba_code = msoa11_code
  )

boundaries_lba_scotland <-
  boundaries_iz11 |>
  right_join(lba_scotland) |>
  rename(
    lba_name = iz11_name,
    lba_code = iz11_code
  )

boundaries_lba_ni <-
  boundaries_soa11 |>
  right_join(lba_ni) |>
  rename(
    lba_name = soa11_name,
    lba_code = soa11_code
  )

# - Join area -
boundaries_lba <-
  bind_rows(
    boundaries_lba_england,
    boundaries_lba_wales,
    boundaries_lba_scotland,
    boundaries_lba_ni
  )

# Check areas plot correctly
ggplot() +
  geom_sf(data = boundaries_ltla21, fill = NA, size = 0.1) +
  geom_sf(data = lba_areas, fill = "red") +
  theme_minimal()

# - Export -
usethis::use_data(boundaries_lba, overwrite = TRUE)
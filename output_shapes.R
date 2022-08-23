## Extract results of interest, write TAF output tables

## Before:
## After:

library(icesTAF)
library(tidyr)
library(dplyr)
library(sf)

mkdir("output")
mkdir("zip")

load("model/request.RData")

# req_a
req_a %>%
  rename(
    kwfhr = "kw_fishinghours",
    kwfhr_c = "kw_fishinghours_cat",
    kwfhr_cl = "kw_fishinghours_cat_low",
    kwfhr_ch = "kw_fishinghours_cat_high"
  ) %>%
  st_write(file.path("output", "effort_all_gears.shp"), append = FALSE)

# req_b
req_b %>%
  rename(
    sur = "surface",
    subsur = "subsurface",
    sur_sar = "surface_sar",
    subsur_sar = "subsurface_sar",

    kwfhr = "kw_fishinghours",
    kwfhr_c = "kw_fishinghours_cat",
    kwfhr_cl = "kw_fishinghours_cat_low",
    kwfhr_ch = "kw_fishinghours_cat_high",

    fhr = "fishing_hours",
    fhr_c = "fishing_hours_cat",
    fhr_cl = "fishing_hours_cat_low",
    fhr_ch = "fishing_hours_cat_high",

    totwt = "totweight",
    totwt_c = "totweight_cat",
    totwt_cl = "totweight_cat_low",
    totwt_ch = "totweight_cat_high",

    totval = "totvalue",
    totval_c = "totvalue_cat",
    totval_cl = "totvalue_cat_low",
    totval_ch = "totvalue_cat_high",
  ) %>%
  st_write(file.path("output", "intensity.shp"))

# footprint
req_b3_footprint_90 %>%
  st_write(file.path("output", "footprint_90.shp"))

# fraction
req_b4_fraction %>%
  rename(
    max_frac = "max_fraction_trawled"
  ) %>%
  st_write(file.path("output", "max_fraction_sar.shp"))

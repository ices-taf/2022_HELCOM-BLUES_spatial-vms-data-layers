
library(icesTAF)
library(data.table)
library(icesVMS)
library(sfdSAR)
library(dplyr)
library(ggplot2)
library(sf)

source("utilities.R")

mkdir("model")

vms <- fread("data/vms_complete.csv")


msg("doing request part a")
req_a <-
  vms %>%
  filter(
    vms$gear_group_a != ""
  ) %>%
  mutate(quarter = ceiling(month / 3)) %>%
  group_by(year, quarter, gear_group_a, c_square) %>%
  vms_summarise() %>%
  select(
    year, quarter, c_square, gear_group_a, kw_fishinghours, anonymous
  ) %>%
  rename(
    gear_group = "gear_group_a"
  ) %>%
  group_by(
    gear_group
  ) %>%
  mutate(
    kw_fishinghours_cat = get_cat(kw_fishinghours),
    kw_fishinghours_cat_low = catlow(kw_fishinghours_cat),
    kw_fishinghours_cat_high = cathigh(kw_fishinghours_cat),
    kw_fishinghours = replace(kw_fishinghours, !anonymous, NA)
  ) %>%
  ungroup() %>%
  vms_add_spatial()


msg("doing request part b")
req_b0 <-
  vms %>%
  filter(
    !is.na(surface)
  ) %>%
  mutate(quarter = ceiling(month / 3)) %>%
  group_by(year, quarter, c_square) %>%
  vms_summarise() %>%
  select(
    year, quarter, c_square, fishing_hours, kw_fishinghours, totweight, totvalue, surface, subsurface, surface_sar, subsurface_sar, anonymous
  ) %>%
  mutate(
    gear_group = "total"
  ) %>%
  vms_categorise_b()



req_b1 <-
  vms %>%
  filter(
    !is.na(surface)
  ) %>%
  mutate(quarter = ceiling(month / 3)) %>%
  group_by(year, quarter, gear_group_b1, c_square) %>%
  vms_summarise() %>%
  select(
    year, quarter, c_square, fishing_hours, kw_fishinghours, totweight, totvalue, surface, subsurface, surface_sar, subsurface_sar, gear_group_b1, anonymous
  ) %>%
  rename(
    gear_group = "gear_group_b1"
  ) %>%
  vms_categorise_b()



req_b2 <-
  vms %>%
  filter(
    !is.na(surface)
  ) %>%
  mutate(quarter = ceiling(month / 3)) %>%
  group_by(year, quarter, gear_group_b2, c_square) %>%
  vms_summarise() %>%
  select(
    year, quarter, c_square, fishing_hours, kw_fishinghours, totweight, totvalue, surface, subsurface, surface_sar, subsurface_sar, gear_group_b2, anonymous
  ) %>%
  rename(
    gear_group = "gear_group_b2"
  ) %>%
  vms_categorise_b()


req_b <-
  rbind(req_b0, req_b1, req_b2) %>%
  vms_add_spatial()


msg("doing request part b3")
# calculate footprint for total gears
req_b3_footprint_90 <-
  req_b0 %>%
  select(
    year, quarter, c_square, surface_sar
  ) %>%
  arrange(
    surface_sar
  ) %>%
  group_by(year, quarter) %>%
  mutate(
    prop_sar = cumsum(surface_sar) / sum(surface_sar)
  ) %>%
  ungroup() %>%
  filter(
    prop_sar > 0.1
  ) %>%
  select(
    year, quarter, c_square
  ) %>%
  vms_add_spatial()


# fractal area
req_b4_fraction <-
  req_b0 %>%
  select(
    year, quarter, c_square, surface_sar
  ) %>%
  mutate(
    max_fraction_trawled = pmin(surface_sar, 1)
  ) %>%
  select(
    -surface_sar
  ) %>%
  vms_add_spatial()

save(req_a, req_b, req_b3_footprint_90, req_b4_fraction, file = "model/request.RData")

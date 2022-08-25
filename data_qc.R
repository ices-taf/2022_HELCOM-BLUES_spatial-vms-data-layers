
library(icesTAF)
library(dplyr)
library(sf)
library(data.table)
library(ggplot2)

# get 2016 data
total_2016 <-
  read_sf(
    taf.data.path(
      "helcom_product_2017", "2016",
      "HELCOM_intensity_total_2016.shp"
    )
  ) %>%
  mutate(
    sar = ifelse(SurfSAR < 0, NA, SurfSAR)
  ) %>%
  select(
    c_square,
    sar
  )

any(table(total_2016$c_square) > 1)



vms <- fread("data/vms_complete.csv")

new_total_2016 <-
  vms %>%
    filter(
      !is.na(benthisMetiers) & year == 2016
    ) %>%
    group_by(
      c_square
    ) %>%
    summarise(
      sar = sum(surface_sar, na.rm = TRUE),
      .groups = "drop"
    )

any(table(new_total_2016$c_square) > 1)


# join
joined <-
  new_total_2016 %>%
  rename(
    new_sar = sar
  ) %>%
  left_join(
    total_2016 %>% rename(old_sar = sar), by = "c_square"
  )

ggplot(joined, aes(new_sar, old_sar)) +
  geom_point()

lm(new_sar ~ old_sar - 1, data = joined)


# check coeffs
# over all length - OK
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(oal = (avg_oal - as.numeric(avLoa)) / as.numeric(avLoa)) %>%
  ggplot(aes(benthisMetiers, oal, col = year)) +
  geom_point()

# kw - OK
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(kw = (avg_kw - as.numeric(avKw)) / as.numeric(avKw)) %>%
  ggplot(aes(benthisMetiers, kw, col = year)) +
  geom_point()

# modelled gear width ok
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(width = (gearWidth_model / 1000 - as.numeric(gearWidth)) / as.numeric(gearWidth)) %>%
  ggplot(aes(benthisMetiers, width, col = year)) +
  geom_point()

# supplied gear width
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  ggplot(aes(benthisMetiers, avgGearWidth, col = year)) +
  geom_point() +
  facet_wrap(~country, scales = "free")

vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(width = (avgGearWidth / 1000 - as.numeric(gearWidth)) / as.numeric(gearWidth)) %>%
  ggplot(aes(benthisMetiers, width, col = year)) +
  geom_point() + facet_wrap(~country, scales = "free")

# modelled gear width
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(width = (gearWidth_model / 1000 - as.numeric(gearWidth)) / as.numeric(gearWidth)) %>%
  ggplot(aes(benthisMetiers, width, col = year)) +
  geom_point() + facet_wrap(~country, scales = "free")

# filled gear width
vms %>%
  filter(!is.na(benthisMetiers)) %>%
  mutate(width = (gearWidth_filled - as.numeric(gearWidth)) / as.numeric(gearWidth)) %>%
  ggplot(aes(benthisMetiers, width, col = year)) +
  geom_point() + facet_wrap(~country, scales = "free")

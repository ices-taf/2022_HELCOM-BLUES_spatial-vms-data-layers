library(icesTAF)
library(data.table)
library(dplyr)
library(icesVMS)

mkdir("data")

# get benthis lookup
metier_lookup_old <- get_metier_lookup() %>% tibble()

# add in RCG update
# add update
update <- read.csv(taf.boot.path("initial", "data", "gears_not_assigned_jsv.csv"))

update <-
  update %>%
  select(
    leMetLevel6, benthisMetiers
  ) %>%
  unique()

metier_lookup <-
  rbind(
    update,
    metier_lookup_old %>% select(leMetLevel6, benthisMetiers)
  ) %>%
  mutate(benthisMetiers = replace(benthisMetiers, benthisMetiers %in% c("", "NA"), NA))


# get vms
vms_all_helcom <- fread(taf.data.path("vms", "vms.csv")) %>%
  rename(
    c_square = "cSquare", LE_MET_level6 = "leMetLevel6",
    AnonVessels = "anonVessels", UniqueVessels = "uniqueVessels",
    gear_code = "gearCode", vessel_length_category = "vesselLengthCategory"
  )

dim(vms_all_helcom)

# join and filter
vms <-
  vms_all_helcom %>%
  filter(!is.na(c_square)) %>%
  left_join(
    metier_lookup,
    by = c(LE_MET_level6 = "leMetLevel6")
  )

# maybe have a vms_clean...

# set to 3
vms$AnonVessels[is.na(vms$UniqueVessels)] <- ""
vms$UniqueVessels[is.na(vms$UniqueVessels)] <- 3

#save(vms, file = "data/vms.Rdata")

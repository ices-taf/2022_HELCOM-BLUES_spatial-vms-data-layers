## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)
library(data.table)
library(icesVMS)
library(sfdSAR)
library(dplyr)
library(ggplot2)
library(sf)

mkdir("data")

gear_groups <-
  list(
    a =
      list(
        Dredges = "DRB",
        Bottom_trawls = c("OTB", "OTT", "PTB", "TBN", "TBS"),
        Pelagic_trawls = c("OTM", "PTM"),
        Longlines = c("LL", "LLS", "LLD", "LX"),
        Traps = c("FPO", "FYK", "FPN"),
        Nets = c("GNS", "GTR", "GND", "GTN"),
        Demersal_seines = c("SDN", "SSC")
      ),
    b =
      list(
        Dredges = "DRB",
        Demersal_seines = c("SDN", "SSC"),
        Otter_trawls = c("OTB", "OTT", "PTB", "TBN", "TBS")
      )
  )

gear_group <- function(x) {
  out <- rep(names(x), sapply(x, length))
  names(out) <- unlist(x, use.names = FALSE)
  out
}

gear_group_a <- gear_group(gear_groups$a)
gear_group_b <- gear_group(gear_groups$b)

vms$gear_group_a <- unname(gear_group_a[vms$gear_code])
vms$gear_group_b1 <- unname(gear_group_b[vms$gear_code])
vms$gear_group_b2 <- replace(vms$benthisMetiers, vms$benthisMetiers %in% c("TBB_MOL", "TBB_DMF", "SSC_DMF"), NA)

table(vms$gear_group_a)
table(vms$gear_group_b1)
table(vms$gear_group_b2)

save(vms, file = "data/vms_subsets.Rdata")

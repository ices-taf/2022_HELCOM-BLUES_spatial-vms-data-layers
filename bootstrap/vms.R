#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name vms
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2020
#' @tafAccess Restricted
#' @tafSource script

# packages
library(icesTAF)
library(sf)
library(icesVMS)
library(data.table)
library(dplyr)

helcom_csquares <- st_read(taf.data.path("helcom_csquares", "helcom_csquares.geojson"))

vms1 <- get_vms(year = 2016:2021, ices_area = "3a")
vms2 <- get_vms(year = 2016:2021, ecoregion = "Baltic Sea")

vms <-
  rbind(
    vms1,
    vms2 %>% filter(!id %in% vms1$id)
  )

# filter on c_square
vms <- vms %>% filter(cSquare %in% helcom_csquares$csquare)

if (FALSE) {
  plot(helcom_csquares["csquare"], col = "blue", border = 0)
  plot(helcom_csquares[helcom_csquares$csquare %in% unique(vms$cSquare),"csquare"], col="red", add = TRUE, border = 0)
}

# filter on countries
countries <-
  c("BE", "DE", "DK", "EE", "ES", "FI", "FR", "IE", "IS", "LT", "LV", "NL", "NO", "PL", "SE", "GB", "PT")

vms <- vms %>% filter(country %in% countries)

fwrite(vms, file = "vms.csv")

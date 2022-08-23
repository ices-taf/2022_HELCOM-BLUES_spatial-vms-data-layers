#' Helcom area C-squares
#'
#' Helcom area C-squares
#'
#' @name helcom_csquares
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2020
#' @tafAccess Public
#' @tafSource script

library(icesTAF)
library(icesVMS)
library(sf)
library(dplyr)

# load helcom shape
helcom <- st_read(taf.data.path("helcom_areas", "helcom_simple.geojson"))
helcom <- st_transform(helcom, crs = 4326)

# get the csqaures in the baltic (broadly)
helcom_csquares <- get_csquare(ecoregion = "Baltic Sea") %>% tibble()
csq_split <- strsplit(helcom_csquares$c_square, ":")

csq_big <-
  unique(
    sapply(
      csq_split,
      function(x) {
        paste0(
          x[1], ":",
          substring(x[2], 1, 1)
        )
      }
    )
  )

# check coverage
chk_map <- function(csqs) {
  browseURL(
    paste0(
      "http://www.obis.org.au/cgi-bin/cs_map.pl?csq=",
      paste(csqs, collapse = "|")
    )
  )
}

if (FALSE) {
  chk_map(unique(sapply(csq_split, "[[", 1)))
  chk_map(csq_big)
  chk_map(c(csq_big, "1503:3", "1603:1"))
}

# generate all c-squares within these bigger squares
quad <- c(rep(rep(1:2, c(5, 5)), 5), rep(rep(3:4, c(5, 5)), 5))
csq_sub <- paste0(quad, sprintf("%02i", 0:99))

csqs_full <-
  unlist(
    lapply(
      c(csq_big, "1503:3", "1603:1"),
      function(x) {
        x_split <- as.numeric(strsplit(x, ":")[[1]])
        out <- paste0(x_split[1], ":", csq_sub[quad == x_split[2]])
        out <- paste0(rep(out, each = 100), ":", csq_sub)
        paste0(rep(out, each = 4), ":", rep(1:4, length(out)))
      }
    )
  )

# convert to spatial
csqs_full_sf <-
  tibble(
    csquare = csqs_full,
    lat = sfdSAR::csquare_lat(csqs_full),
    lon = sfdSAR::csquare_lon(csqs_full),
    wkt = icesVMS::wkt_csquare(lat, lon)
  ) %>%
  st_as_sf(wkt = "wkt", crs = 4326)

if (FALSE) {
  chk_map(csqs_full)
  plot(helcom)
  plot(csqs_full_sf["csquare"], add = TRUE)
}

# filter to helcom area
lst <- st_intersects(csqs_full_sf, helcom)
csqs_full_sf <- csqs_full_sf[lengths(lst) > 0,]

if (FALSE) {
  plot(helcom, col = "red")
  plot(csqs_full_sf["csquare"], add = TRUE)
}

st_write(csqs_full_sf, "helcom_csquares.geojson")

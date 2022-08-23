#' Download Helcom areas
#'
#' Download Helcom areas from ICES GIS rest service
#'
#' @name helcom_areas
#' @format geojson
#' @tafOriginator ICES
#' @tafYear 2022
#' @tafPeriod 2022-2022
#' @tafAccess Public
#' @tafSource script

library(icesTAF)
library(sf)
library(httr)
library(nngeo)

baseurl <-
  "http://gis.ices.dk/gis/rest/services/External_reference_layers/HELCOM_subbasins/MapServer/0/query?where=SB_Code%3D2&geometryType=esriGeometryPolygon&geometryPrecision=2&f=json"

url <- httr::parse_url(baseurl)
url$query$where <- "SB_Code IS NOT NULL"
url$query$geometryPrecision <- 2
url <- httr::build_url(url)
filename <- "helcom.geojson"

# change time to 1000 as service can be very slow
to <- getOption("timeout")
options(timeout = 10000)

download.file(url, destfile = filename, quiet = FALSE)

# reset timeout
options(timeout = to)

helcom <- read_sf(filename)
helcom <- nngeo::st_remove_holes(helcom)
helcom <- st_union(helcom)
helcom <- nngeo::st_remove_holes(helcom)

# plot(helcom, col = "red")
# plot(st_simplify(helcom, dTolerance = 5000), col = "seagreen", add = TRUE)

helcom <- st_simplify(helcom, dTolerance = 5000)

st_write(helcom, "helcom_simple.geojson")

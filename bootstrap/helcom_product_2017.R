#' HELCOM request 2017 for spatial data layers of fishing intensity/pressure

#'

#' Spatial data layers of fishing intensity/ pressure per gear type for surface and subsurface abrasion, for the years 2009 to 2016 in the HELCOM region.

#'

#' @name helcom_product_2017

#' @format ESRI shapefiles

#' @tafOriginator ICES

#' @tafYear 2027

#' @tafPeriod 2009-2016

#' @tafAccess Public

#' @tafSource script

# get data product zip from ICES library

library(httr)
library(glue)

downloadFromFigshare <- function(doi) {
  
  resp <- GET(glue("https://api.figshare.com/v2/articles?doi={doi}"))
  article <- content(resp, simplifyVector = TRUE)
  article_id <- article$id

  files <-
    content(
      GET(glue("https://api.figshare.com/v2/articles/{article_id}/files")),
      simplifyVector = TRUE
    )

  download(files$download_url, destfile = files$name)
  message(glue("Downloaded: \n\t{files$name}\nto\n\t{getwd()}"))

  return(files)
}

# get 2017 Helcom VMS data product
files <- downloadFromFigshare("10.17895/ices.data.4684")


# get shapefiles for 2016 from zip file
unzip(files$name, list = TRUE)
unzip(
  files$name,
  junkpaths = TRUE,
  files = "ICES.2017.HELCOM-spatial-data-fishing-intensity/ICES.2017.Shapefiles-HELCOM-spatial-data-fishing-intensity.zip"
)

shapes_fname <- "ICES.2017.Shapefiles-HELCOM-spatial-data-fishing-intensity.zip"
shapes <- unzip("ICES.2017.Shapefiles-HELCOM-spatial-data-fishing-intensity.zip", list = TRUE)
unzip(
  "ICES.2017.Shapefiles-HELCOM-spatial-data-fishing-intensity.zip",
  files = grep("2016", shapes$Name, value = TRUE)
)

# clean up
unlink(shapes_fname)
unlink(files$name)

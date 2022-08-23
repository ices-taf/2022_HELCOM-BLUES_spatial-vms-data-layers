#' VMS data from the ICES VMS and Logbook Database
#'
#' VMS data from the ICES VMS and Logbook Database
#'
#' @name rcg_metier_lookup
#' @format csv file
#' @tafOriginator ICES
#' @tafYear 2020
#' @tafAccess Restricted
#' @tafSource script

library(dplyr)
library(data.table)
library(stringr)

url <- "https://raw.githubusercontent.com/ices-eg/RCGs/master/Metiers/Reference_lists/RDB_ISSG_Metier_list.csv"
rcg <-
  fread(url) %>%
  select(
    Metier_level6,
    Old_code,
    Benthis_metiers
  )

rcg$Benthis_metiers[rcg$Benthis_metiers == ""] <- NA
rcg$Old_code[rcg$Old_code == ""] <- NA

rcg <- rcg %>% filter(!is.na(Benthis_metiers))

rcg_new <-
  rcg %>%
  filter(
    is.na(Old_code)
  )

rcg_old <-
  rcg %>%
  filter(
    !is.na(Old_code)
  ) %>%
  mutate(
    n = str_count(Old_code, ",") + 1
  )

tibble(
  Metier_level6 = rep(rcg_old$Metier_level6, rcg_old$n),
  Benthis_metiers = rep(rcg_old$Benthis_metiers, rcg_old$n)
) %>%
  mutate(
    Old_code = unlist(strsplit(rcg_old$Old_code, ", "))
  )

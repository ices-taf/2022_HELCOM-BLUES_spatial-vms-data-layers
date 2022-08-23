#' ICES Data Disclaimer
#'
#' ICES Data Disclaimer for special requests, a template is modified
#' to create a specific disclaimer for this product
#'
#' @name disclaimer
#' @format txt file
#' @tafOriginator ICES
#' @tafYear 2021
#' @tafAccess Public
#' @tafSource script

# read correct disclaimer template
github_raw_url <- "https://raw.githubusercontent.com"
disclaimer_repo <- "ices-tools-prod/disclaimers"
disclaimer_tag <- "1adaffbbe80ae8b155ff557cfa7ecc996c25308f"
disclaimer_fname <- "disclaimer_vms_data_ouput.txt"

disclaimer_url <-
  paste(
    github_raw_url,
    disclaimer_repo,
    disclaimer_tag,
    disclaimer_fname,
    sep = "/"
  )

disclaimer <- readLines(disclaimer_url)

# specific entries
data_specific <-
  paste(
    "The zip file contains shapefiles and png maps images of fishing effort, fishing intensity, fishing footprint, and maximum fraction trawled."
  )

recomended_citation <- "ICES. 2022. HELCOM request on the production of spatial data layers of fishing intensity/pressure. In Report of the ICES Advisory Committee, 2021. ICES Advice 2021, sr.2021.12. https://doi.org/10.17895/ices.data.20310255"

metadata <- "10.17895/ices.data.20310255"

# apply to sections
# data specific info
line <- grep("3. DATA SPECIFIC INFORMATION", disclaimer)
disclaimer <-
  c(
    disclaimer[1:line],
    data_specific,
    disclaimer[(line + 1):length(disclaimer)]
  )

if (FALSE) {
  # recomended citation
  line <- grep("Recommended citation:", disclaimer)
  disclaimer <-
    c(
      disclaimer[1:line],
      recomended_citation,
      disclaimer[(line + 1):length(disclaimer)]
    )
}


# metadata section
line <- grep("7. METADATA", disclaimer)
disclaimer <-
  c(
    disclaimer[1:(line)],
    "Further details about the dataset can be found in the file README.md"
  )

cat(disclaimer, file = "disclaimer.txt", sep = "\n")

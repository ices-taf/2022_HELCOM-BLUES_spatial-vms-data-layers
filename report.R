## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)
library(tmap)
library(dplyr)
library(sf)
library(htmlwidgets)
library(tidyr)

mkdir("report")
mkdir("zip")

#sourceTAF("report_maps.R")

cp("report_readme.md", "report/readme.md")

sourceTAF("report_zip.R")

library(TAF)
library(rmarkdown)

source.taf("report_map.R")
source.taf("report_plots.R")
source.taf("report_tables.R")
render("report.Rmd")
source.taf("report_www.R")

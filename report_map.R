## Prepare map

## Before: cities.csv, flights.csv (output)
## After:  map.pdf, map.svg (report)

library(TAF)

source("utilities.R")  # drawmap

mkdir("report")

cities <- read.taf("output/cities.csv")
flights <- read.taf("output/flights.csv")

pdf("report/map.pdf", width=6.5, height=4.5)
drawmap(flights, cities)
dev.off()

svg("report/map.svg", width=6.5, height=4.5)
drawmap(flights, cities)
dev.off()

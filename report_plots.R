## Plots

## Before: cities.csv (output)
## After:  temperature.png (report)

library(TAF)

cities <- read.taf("output/cities.csv")
cities <- cities[!duplicated(cities$Airport),]  # AKL
cities <- cities[!cities$Stay == 0,]  # SIN, DXB, DOH, SYD

taf.png("temperature")
barplot(cities$Temperature, names=cities$Airport, ylab="Temperature")
abline(h=seq(0,35,5), col="gray", lty=3)
barplot(cities$Temperature, names=cities$Airport, add=TRUE)
dev.off()

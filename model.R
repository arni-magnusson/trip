## Run analysis, write model results

## Before: cities.csv, flights.csv (data)
## After:  cities.csv, flights.csv (model)

library(TAF)
library(gmt)  # deg2num, geodist

mkdir("model")

## Read data
cities <- read.taf("data/cities.csv")
flights <- read.taf("data/flights.csv")

## Look up flight start and end points
flights$Nfrom <- cities$Latitude[match(flights$From, cities$Airport)]
flights$Efrom <- cities$Longitude[match(flights$From, cities$Airport)]
flights$Nto <- cities$Latitude[match(flights$To, cities$Airport)]
flights$Eto <- cities$Longitude[match(flights$To, cities$Airport)]

## Calculate flight distance, value, and speed
flights$Distance <- with(flights, round(geodist(Nfrom, Efrom, Nto, Eto)))
flights$Value <- round(flights$Distance / flights$Cost)
flights$Speed <- round(flights$Distance / deg2num(flights$Duration), -1)

## Create a second Los Angeles, Auckland, and Noumea to return to
cities <- rbind(cities, cities[cities$City == "Los Angeles",])
cities <- rbind(cities, cities[cities$City == "Auckland",])
cities <- rbind(cities, cities[cities$City == "Noumea",])

# Calculate nights in each city
cities$Arrive <- flights$ArriveDate[match(cities$Airport, flights$To)]
cities$Depart <- flights$Date[match(cities$Airport, flights$From)]
# Noumea start
cities$Arrive[1] <- min(cities$Arrive, na.rm=TRUE)
# 2nd time in LAX
cities$Arrive[cities$Airport=="LAX"][2] <-
  flights$ArriveDate[flights$To=="LAX"][2]
cities$Depart[cities$Airport=="LAX"][2] <- flights$Date[flights$From=="LAX"][2]
# 2nd time in AKL
cities$Arrive[cities$Airport=="AKL"][2] <-
  flights$ArriveDate[flights$To=="AKL"][2]
cities$Depart[cities$Airport=="AKL"][2] <- flights$Date[flights$From=="AKL"][2]
# Noumea end
cities$Depart[nrow(cities)] <- max(cities$Depart, na.rm=TRUE)
cities$Stay <- as.integer(as.Date(cities$Depart) - as.Date(cities$Arrive))
cities$Stay[cities$City == "Lima"] <- 0  # fly after midnight

## Calculate flight layover
flights$Date <- as.Date(flights$Date)
flights$ArriveDate <- as.Date(flights$ArriveDate)
connecting <- c(flights$Date[-1] - flights$ArriveDate[-nrow(flights)] <= 1,
                FALSE)
takeoff <- as.POSIXct(paste(flights$Date, flights$TakeOff))
landing <- as.POSIXct(paste(flights$ArriveDate, flights$Landing))
layover <- num2deg(takeoff[-1] - landing[-nrow(flights)], zero=TRUE)
layover <- sub(":00$", "", layover)
flights$Layover <- ifelse(connecting, layover, "")

## Write results
write.taf(cities, dir="model")
write.taf(flights, dir="model")

library(ggplot2)  # map_data
library(maps)     # world

drawmap <- function(flights, cities)
{
  # Read world coordinates from 'maps' package, using ggplot2 tools
  world <- map_data("world")
  world$group <- as.integer(world$group)

  # Combine two world maps, side by side
  rownames(world) <- NULL
  world2 <- rbind(world, transform(world, long=long+360, group=group+10000L))

  par(plt=c(0.01,0.99,0.02,0.98))
  plot(NA, xlim=c(115,345), ylim=c(-47,68), ann=FALSE, axes=FALSE)
  map <- lapply(split(world2, world2$group), polygon, border="white", lwd=0.4,
                col="olivedrab4")

  # Offset city and flight longitude
  cities$Longitude[cities$Longitude < 0] <-
    cities$Longitude[cities$Longitude < 0] + 360
  flights$Efrom[flights$Efrom < 0] <- flights$Efrom[flights$Efrom < 0] + 360
  flights$Eto[flights$Eto < 0] <- flights$Eto[flights$Eto < 0] + 360

  # Draw flights and cities
  with(flights, segments(Efrom, Nfrom, Eto, Nto, lwd=1.5))
  points(Latitude~Longitude, cities, subset=Stay > 0,
         pch=21, cex=1.6, bg="red3")
  points(Latitude~Longitude, cities, subset=Airport %in% c("NOU", "AKL", "LIM"),
         pch=21, cex=1.6, bg="red3")
  points(Latitude~Longitude, cities,
         subset=Airport %in% c("SJO","YYZ"), pch=21, cex=1.6, bg="olivedrab4")
  points(c(225,225), c(-38,-44), pch=21, cex=1.5, bg=c("red3","olivedrab4"))
  text(c(230,230), c(-38,-44), c("explore","connect"), adj=0, cex=0.8)
  box()
}

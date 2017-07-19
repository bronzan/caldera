library(geosphere)


top630 <- read.csv("citylist.csv", stringsAsFactors=FALSE)
model_grid <- read.csv("conus-grid.csv", stringsAsFactors=FALSE)


# Find closest grid point for each city
print(paste("Finding closest grid points at", Sys.time()))
closest_stns <- data.frame()

for (i in 1:nrow(top630))
{
rownum <- which(distHaversine(c(top630$Longitude[i], top630$Latitude[i]),cbind(model_grid$Lon, model_grid$Lat)) == min(distHaversine(c(top630$Longitude[i], top630$Latitude[i]),cbind(model_grid$Lon, model_grid$Lat))))[1]
newrow <- data.frame(top630[i,], model_grid[rownum,], distHaversine(c(top630$Longitude[i], top630$Latitude[i]),c(model_grid$Lon[rownum], model_grid$Lat[rownum])))
colnames(newrow)[(ncol(newrow) - 2):ncol(newrow)] <- c("grid_lon", "grid_lat", "grid_dist")
closest_stns <- rbind(closest_stns, newrow)
}

write.csv(closest_stns, file="caldera_with_grid.csv")

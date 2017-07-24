print(Sys.time())
options(stringsAsFactors=FALSE)

## set to caldera directory
setwd("~/projects/caldera")

## load daymet data
print(paste("loading daymet data", Sys.time()))
load("daymet_with_latlon.RData")

## load city list
cities <- read.csv("city_header.csv")

#merge to get current data into shape
print(paste("merging daymet and cities", Sys.time()))
tmax.current <- merge(cities, daymet, by=c("lon", "lat"), all.x=TRUE)

print(paste("ordering daymet", Sys.time()))
tmax.current <- tmax.current[order(tmax.current$lon, tmax.current$lat),]

# save space
rm(daymet)
rm(cities)

# location of data
dataDir <- "/Volumes/conus/test_data/"

#### THIS IS WHERE TO ITERATE

## load data
model <- "canesm2"
rcp <- "rcp26"

print(paste("loading 2016 data", Sys.time()))
fn2016 <- paste0("tasmax_", model, "_", rcp, "_2016.RData")
load(paste0(dataDir, fn2016))
model2016 <- model.output
print(paste("ordering 2016 data", Sys.time()))
model2016 <- model2016[order(model2016$lon, model2016$lat),]
rm(model.output)

## calculate deltas
print(paste("loading 2050 data", Sys.time()))
fn2050 <- paste0("tasmax_", model, "_", rcp, "_2050.RData")
load(paste0(dataDir, fn2050))
model2050 <- model.output
print(paste("ordering 2050 data", Sys.time()))
model2050 <- model2050[order(model2050$lon, model2050$lat),]
rm(model.output)

print(paste("calculating deltas", Sys.time()))
delta2050 <- as.data.frame(cbind(model2050$lon, model2050$lat, model2050$city, model2050$state, model2050[,5:7304] - model2016[,5:7304]))

## apply deltas to current
print(paste("applying deltas", Sys.time()))
tmax.2050 <- as.data.frame(cbind(model2050$lon, model2050$lat, model2050$city, model2050$state, tmax.current[,5:7304] + delta2050[,5:7304]))



print(Sys.time())
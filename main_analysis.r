 

## set to caldera directory
setwd("/Users/jbronzan/projects/caldera")

## load daymet data
daymet <- read.csv("daymet-data-all")

## load city list
cities <- read.csv("city_header.csv")


tmax.current <- merge 
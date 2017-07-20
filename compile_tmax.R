options(stringsAsFactors = FALSE)


## list directories with model results for rcp26
directories <- list.files("/Volumes/conus", pattern="rcp26")

## get list of models
models <- c()
for (d in 1:length(directories))
{
	underscore <- gregexpr("_",directories[d])[[1]][1]
	models[d] <- substr(directories[d],1,underscore-1)
}

## GET TMAX FOR 20-YEAR PERIOD
model <- models[1] # iterate here to cycle though models

years <- 1997:2016 # iterate here to cycle through years

rcp <- "rcp26" # iterate here to cycle through RCPs

var <- "tasmax" # iterate here to cycle through variables

## LOOP BEGINS here	


dataDir <- paste0("/Volumes/conus/", model, "_", rcp, "_r1i1p1")


for (yr in years)
{
	fn <- paste0(dataDir, "/", )
}


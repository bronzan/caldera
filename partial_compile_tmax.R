options(stringsAsFactors = FALSE)
#setwd("/Users/jbronzan/projects/caldera")

## GET TMAX FOR 20-YEAR PERIOD

#startyears <- 1997
startyears <- c(1997, 2031, 2056, 2080) # iterate here to cycle through years


#rcps <- "rcp26"
rcps <- c("rcp45", "rcp85") # iterate here to cycle through RCPs

var <- "tasmax" # iterate here to cycle through variables

## load city files with grid_lat and grid_lon
grid_city <- read.csv(file="city_header.csv")
colnames(grid_city)[which(colnames(grid_city) == "grid_lon")] <- "lon"
colnames(grid_city)[which(colnames(grid_city) == "grid_lat")] <- "lat"

## Cycle through RCPs
for (r in 1:1)
{
	rcp <- rcps[r]
	rcp.start.time <- Sys.time()
	print(paste("---- Started", rcp, "at", rcp.start.time, "----"))


	## list directories with model results for rcp26 (only models we want)
	directories <- list.files("/Volumes/conus", pattern="rcp26")
	## get list of models
	models <- c()
	for (d in 1:length(directories))
	{
		underscore <- gregexpr("_",directories[d])[[1]][1]
		models[d] <- substr(directories[d],1,underscore-1)
	}	


	## now cycle through models
	#	for (m in 1:1)
	
	for (m in 2:length(models))
	{
		model.output <- data.frame()
		model <- models[m] # iterate here to cycle though models
		model.start.time <- Sys.time()
		print(paste("**** started model", model, "at", model.start.time, "****"))
		# define directory holding CMIP5 CONUS data
		dataDir <- paste0("/Volumes/conus/", model, "_", rcp, "_r1i1p1")

		for (fr in 1:length(startyears))
		{
			startyear <- startyears[fr]
			years <- startyear:(startyear + 19)
	#		for (y in 1:5)
			print(paste("> started frame at", Sys.time()))

			for (y in 1:length(years))  ## PRODUCTION version
			{
				# load data file
				yr <- years[y]
				print(paste(yr,Sys.time()))
				fn <- paste0(dataDir, "/", var, "_", model, "_", rcp, "_", yr, ".RData")
				load(fn)

				# fix column names for data file
				colnames(var.df)[1:2] <- c("lon", "lat")

				# merge with the desired grid so we're not building frames with more points than we need
				var.frame <- merge(grid_city, var.df, by=c("lon", "lat"), all.x = TRUE)

				## confirm that the order is correct before attaching
				if (y == 1)
				{
					model.output <- var.frame[,1:(ncol(var.frame) - 6)]
				} else
				{
					if (sum(paste0(var.frame$lon,var.frame$lat) == paste0(model.output$lon,model.output$lat)) == nrow(model.output))
					{
						model.output <- cbind(model.output, var.frame[,5:(ncol(var.frame) - 6)])
					}
				}

			}
			save(model.output, file=paste0("/Volumes/conus/model_compiled/", var, "_", model, "_", rcp, "_", yr, ".RData"))
			print(paste("> finished frame at", Sys.time()))
		}
		print(paste("**** finished model", model, "at", Sys.time(), "****"))
		print(paste0("       (elapsed time ", Sys.time() - model.start.time, ")"))
	}

	print(paste("---- Finished", rcp, "at", Sys.time(), "----"))
	print(paste0("       (elapsed time ", Sys.time() - rcp.start.time, ")"))
}











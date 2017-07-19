## convert threshold data to JSON for justin

library(rjson)

## load threshold data
thresh <- read.csv(file="dummydata.csv")

endrow <- nrow(thresh)  ## testing

finaloutput <- list(rep(NA,endrow))



## cycle through rows
finaloutput <- list(rep(NA,endrow))

for (r in 1:endrow) 
##initialize output list


{
	output <- list()
	output[["city"]] <- thresh$city[r]
	output[["state"]] <- thresh$state[r]

	## Process current data
	yr <- "2016"
	temps <- c("85", "90", "95", "100", "105", "110", "115")
	threshes <- c("over85","over90","over95","over100","over105","over110","over115")
	colsearch <- paste0(threshes, "_", yr)
	lump <- list()

	for (i in 1:length(colsearch))
	{
		lump[[temps[i]]] <- as.character(thresh[1,paste0("over", temps[i], "_", yr)])
	}

	output[[yr]] <- lump

	## Process projection data
	rcps <- c("rcp26", "rcp45", "rcp85")
	years <- c("2050", "2075", "2100")
	threshes <- c("over85","over90","over95","over100","over105","over110","over115")














	## cycle through RCPs
	for (i in 2:4) #i is output item number
	{
		j <- i - 1 ## j is lookup key
		rcp <- rcps[j]
		templist <- list()
		## cycle through thresholds
		for (k in 1:length(temps))
		{
			temp <- temps[k]
			yearlist <- list()
			for (l in 1:length(years))
			{
				year <- years[l]
				yearlist[[year]] <- as.character(thresh[1,paste0("over", temp, "_", year, "_", rcp)])

			}
			templist[[temp]] <- yearlist

		}
		output[[rcp]] <- templist
	}
	finaloutput[[r]] <- output
}
cat(toJSON(finaloutput),file="dummydata.json")
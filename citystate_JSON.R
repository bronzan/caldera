thresh <- read.csv(file="dummydata.csv")



#citystate <- list(rep(NA, 4)) ## testing
citystate <- list(rep(NA, nrow(thresh)))
item <- list()

#for (i in 1:4)  ## testing
for (i in 1:nrow(thresh))
{
	citystate[[i]] <- paste0(thresh$city[i], ", ", thresh$state[i])
}

cat(toJSON(citystate), file="index.json")

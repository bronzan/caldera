options(stringsAsFactors=FALSE)
setwd("/Users/jamesbronzan/projects/caldera")
years <- 1997:2016

## Assemble dates
day31 <- c(paste0("0",1:9), as.character(10:31))
day30 <- c(paste0("0",1:9), as.character(10:30))
day28 <- c(paste0("0", 1:9), as.character(10:28))

yeardates <- c(paste0("01", day31), paste0("02", day28),paste0("03", day31),paste0("04", day30),paste0("05", day31),paste0("06", day30),paste0("07", day31),paste0("08", day31),paste0("09", day30),paste0("10", day31),paste0("11", day30),paste0("12", day31))

dates <- c()
for (y in years) {
	dates <- c(dates, paste0(y, yeardates))
}

daymet <- data.frame()
## Iterate through filenames
fns <- list.files("daymet-data")

for (f in 1:length(fns))

{
	fn <- fns[f]
	if (f %% 100 == 0) {print(paste(f, "at", Sys.time()))}  #keep track of speed

	## Get lat/lon out of filename
	x <- gregexpr("x", fn)[[1]]
	lat <- substr(fn, 1, x-1)
	lon <- substr(fn, x+1, nchar(fn))

	dat <- read.csv(file=paste0("daymet-data/", fn), skip=7)
	newrow <- c(lon, lat, dat[which(dat$year == 1997)[1]:which(dat$year == 2016)[365],7])
	daymet <- rbind(daymet, newrow)

	if (f %% 1000 == 0)
	{
		colnames(daymet) <- c("lon", "lat", dates)
		write.csv(daymet, file=paste0("daymet-frames/daymet-row-", f, ".csv"), row.names=FALSE)
		daymet <- data.frame()
	}
}

colnames(daymet) <- c("lon", "lat", dates)
write.csv(daymet, file=paste0("daymet-frames/daymet-row-", f, ".csv"), row.names=FALSE)
daymet <- data.frame()

for (f in list.files("daymet-frames", pattern="daymet-row"))
{
	chunk <- read.csv(paste0("daymet-frames/", f))
	daymet <- rbind(daymet, chunk)
}

write.csv(daymet, file="daymet-frames/daymet-data-all.csv", row.names=FALSE)




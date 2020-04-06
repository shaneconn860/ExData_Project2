library(ggplot2)


#Create directory first

if (!file.exists("./data")) {
        dir.create("./data")
}

#Set variables for download

downloadURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
downloadFile <- "./data/project.zip"
file1 <- "./data/exdata_data_NEI_data/Source_Classification_Code.rds"
file2 <- "./data/exdata_data_NEI_data/summarySCC_PM25.rds"

#Download and Unzip zip file 

if (!file.exists(file1)) {
        download.file(downloadURL, downloadFile, method = "curl")
        unzip(downloadFile, overwrite = T, exdir = "./data")
}

#Load rds files in to R

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

#6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County

#Subset both Baltimore and LA and then motor vehicles
dualLocations <-subset(NEI, NEI$fips %in% c("24510", "06037") & NEI$type == "ON-ROAD")
dualLocationVehicles <- aggregate(Emissions ~ year + fips, dualLocations, sum)

ggplot(dualLocationVehicles, aes(year, Emissions, col=fips)) + geom_point() + geom_line() + ggtitle("Baltimore vs LA County Motor Vehicle Emissions") + scale_colour_discrete(name = "Location", labels = c("LA County", "Baltimore"))

# Save to png file
dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()
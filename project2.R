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

#1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

#Aggregate total emissions by year
totalEmissions <- aggregate(Emissions ~ year, NEI, sum)

#Plot emissions by year for Baltimore
plot(totalEmissions$year, totalEmissions$Emissions, main="Total Emissions by Year", xlab="Year", ylab="Emissions", type="l", col="red")

# Save to png file
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()

#2. Have total emissions from PM2.5 decreased in Baltimore City, Maryland from 1999 to 2008?

#Isolate Baltimore data by subsetting
baltimore <- subset(NEI, NEI$fips=="24510")

#Aggregate emissions by year for Baltimore
baltimoreEmissions <- aggregate(Emissions ~ year, baltimore, sum)

#Plot emissions by year for Baltimore
plot(baltimoreEmissions$year, baltimoreEmissions$Emissions, main="Total Baltimore Emissions by Year", xlab="Year", ylab="Emissions", type="l", col="red")

# Save to png file
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()

#3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen increases/decreases in emissions from 1999–2008 for Baltimore City?

#Aggregate emissions by year and type using baltimore variable used previously
baltimoreType <- aggregate(Emissions ~ year + type, baltimore, sum)

#Plot
ggplot(data=baltimoreType, aes(year, Emissions, col=type)) + geom_point() + geom_line() + ggtitle("Baltimore Emissions by Year and Type")

# Save to png file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()

#4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?        

coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE),]
coal2 <- NEI[NEI$SCC %in% coal$SCC,]
totalCoal <- aggregate(Emissions ~ year + type, coal2, sum)

ggplot(totalCoal, aes(year, Emissions, type)) + geom_point() + geom_line()

# Save to png file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()

#5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#Subset and aggregrate vehicles AND Baltimore data

baltimore <-subset(NEI, NEI$fips=="24510" & NEI$type == "ON-ROAD")
baltimoreVehicles <- aggregate(Emissions ~ year, baltimore, sum)

#Plot
ggplot(baltimoreVehicles, aes(year, Emissions)) + geom_point() + geom_line() + ggtitle("Baltimore Motor Vehicle Emissions")

# Save to png file
dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()

#6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County

#Subset both Baltimore and LA and then motor vehicles
dualLocations <-subset(NEI, NEI$fips %in% c("24510", "06037") & NEI$type == "ON-ROAD")
dualLocationVehicles <- aggregate(Emissions ~ year + fips, dualLocations, sum)

ggplot(dualLocationVehicles, aes(year, Emissions, col=fips)) + geom_point() + geom_line() + ggtitle("Baltimore vs LA County Motor Vehicle Emissions") + scale_colour_discrete(name = "Location", labels = c("LA County", "Baltimore"))

# Save to png file
dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()
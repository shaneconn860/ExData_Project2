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
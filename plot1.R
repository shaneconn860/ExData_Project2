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

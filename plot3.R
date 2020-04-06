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

#3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen increases/decreases in emissions from 1999–2008 for Baltimore City?

#Aggregate emissions by year and type using baltimore variable used previously
baltimoreType <- aggregate(Emissions ~ year + type, baltimore, sum)

#Plot
ggplot(data=baltimoreType, aes(year, Emissions, col=type)) + geom_point() + geom_line() + ggtitle("Baltimore Emissions by Year and Type")

# Save to png file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
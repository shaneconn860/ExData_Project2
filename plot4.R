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

#4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?        

coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE),]
coal2 <- NEI[NEI$SCC %in% coal$SCC,]
totalCoal <- aggregate(Emissions ~ year + type, coal2, sum)

ggplot(totalCoal, aes(year, Emissions, type)) + geom_point() + geom_line()

# Save to png file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
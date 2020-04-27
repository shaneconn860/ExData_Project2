---
title: "Exploratory Data Analysis - Fine Particulate Matter (PM2.5)"
output: 
  html_document:
    keep_md: true
---

## Synopsis

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data used in this assignment are for 1999, 2002, 2005, and 2008.

## Data Processing


```r
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
```


```r
#Load rds files in to R

library(ggplot2)

NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
```

### 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?


```r
#Aggregate total emissions by year
totalEmissions <- aggregate(Emissions ~ year, NEI, sum)

#Plot emissions by year for Baltimore
plot(totalEmissions$year, totalEmissions$Emissions, main="Total Emissions by Year", xlab="Year", ylab="Emissions", type="l", col="red")
```

![](project2_files/figure-html/unnamed-chunk-3-1.png)<!-- -->


### 2. Have total emissions from PM2.5 decreased in Baltimore City, Maryland from 1999 to 2008?


```r
#Isolate Baltimore data by subsetting
baltimore <- subset(NEI, NEI$fips=="24510")

#Aggregate emissions by year for Baltimore
baltimoreEmissions <- aggregate(Emissions ~ year, baltimore, sum)

#Plot emissions by year for Baltimore
plot(baltimoreEmissions$year, baltimoreEmissions$Emissions, main="Total Baltimore Emissions by Year", xlab="Year", ylab="Emissions", type="l", col="red")
```

![](project2_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

### 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen increases/decreases in emissions from 1999–2008 for Baltimore City?


```r
#Aggregate emissions by year and type using baltimore variable used previously
baltimoreType <- aggregate(Emissions ~ year + type, baltimore, sum)

#Plot
ggplot(data=baltimoreType, aes(year, Emissions, col=type)) + geom_point() + geom_line() + ggtitle("Baltimore Emissions by Year and Type")
```

![](project2_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

### 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?        


```r
coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE),]
coal2 <- NEI[NEI$SCC %in% coal$SCC,]
totalCoal <- aggregate(Emissions ~ year + type, coal2, sum)

ggplot(totalCoal, aes(year, Emissions, type)) + geom_point() + geom_line()
```

![](project2_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

### 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?


```r
#Subset and aggregrate vehicles AND Baltimore data

baltimore <-subset(NEI, NEI$fips=="24510" & NEI$type == "ON-ROAD")
baltimoreVehicles <- aggregate(Emissions ~ year, baltimore, sum)

#Plot
ggplot(baltimoreVehicles, aes(year, Emissions)) + geom_point() + geom_line() + ggtitle("Baltimore Motor Vehicle Emissions")
```

![](project2_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

### 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County


```r
#Subset both Baltimore and LA and then motor vehicles
dualLocations <-subset(NEI, NEI$fips %in% c("24510", "06037") & NEI$type == "ON-ROAD")
dualLocationVehicles <- aggregate(Emissions ~ year + fips, dualLocations, sum)

ggplot(dualLocationVehicles, aes(year, Emissions, col=fips)) + geom_point() + geom_line() + ggtitle("Baltimore vs LA County Motor Vehicle Emissions") + scale_colour_discrete(name = "Location", labels = c("LA County", "Baltimore"))
```

![](project2_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

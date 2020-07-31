## SOURCING THIS FILE will open all relevant datasets & variables used elsewhere in the code.
countries <- c("Brazil", "Canada", "China", "Germany", "India", "Iran", "Italy", "Japan", "Russia", "Saudi Arabia", "USA")

country_boxes <- read.csv('country_boxes.csv')
country_boxes <- country_boxes[, colnames(country_boxes) != "X"]

country_no2 <- read.csv('country_average_no2.csv')
country_no2 <- country_no2[, colnames(country_no2) != "X"]
country_no2["Date"] <- paste(country_no2[,"month"], country_no2[,"day"], sep=" ")
country_no2["Date_official"] <- as.Date(paste(country_no2[,"year"], country_no2[,"month"], country_no2[,"day"], sep=" "), "%Y %m %d")

# Get each year's data in separate matrices; 01/01/20?? - 07/18/20??
country_no2_2015 <- country_no2[1:199,]
country_no2_2016 <- country_no2[366:552,]
country_no2_2017 <- country_no2[719:913,]
country_no2_2018 <- country_no2[1080:1278,]
country_no2_2019 <- country_no2[1445:1643,]
country_no2_2020 <- country_no2[1810:2009,]

# Get averages for each day across 2015-2019
country_averages <- aggregate(country_no2[1:1810,], list(country_no2[1:1810,"day"], country_no2[1:1810,"month"]), mean, na.rm=TRUE)
country_averages["Date"] <- paste(country_averages[,"month"], country_averages[,"day"], sep=" ")
# Isolate only Jan 1 - July 18
country_averages <- country_averages[1:200,]

# Load oxford lockdown data
countries <- c("Brazil", "Canada", "China", "Germany", "India", "Iran", "Italy", "Japan", "Russia", "Saudi.Arabia", "USA")

gov_allequal <- read.csv('lockdown_data/All_equal.csv')
rownames(gov_allequal) <- countries
gov_allequal <- as.data.frame(t(gov_allequal))
gov_allequal["Date_official"] <- as.Date(rownames(gov_allequal), 'X%d%b%Y')

gov_transport <- read.csv('lockdown_data/only_travel.csv')
rownames(gov_transport) <- countries
gov_transport <- as.data.frame(t(gov_transport))
gov_transport["Date_official"] <- as.Date(rownames(gov_transport), 'X%d%b%Y')


gov_weighted <- read.csv('lockdown_data/travel_higher.csv')
rownames(gov_weighted) <- countries
gov_weighted <- as.data.frame(t(gov_weighted))
gov_weighted["Date_official"] <- as.Date(rownames(gov_weighted), 'X%d%b%Y')

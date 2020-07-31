# Download package from github and load libraries
library(devtools)
require(devtools)
install_github('davidcarslaw/openair')
library(openair)

# Downolad data from site kc1 for 2019 and 2020. 
# meta = True will return meta data such as site name and lat/long coordinates
kc1 <- importAURN(site = "kc1", year = 2019:2020, meta = TRUE)
View(kc1)

# Take the average by day (can change to multiple hours ("8 hour"), days, weeks, etc)
sub2 <- timeAverage(kc1, avg.time = "day")
View(sub2)

# Plot of the two years
plot(sub2$date, sub2$pm2.5, type = "l")

# Find meta info for sites
aurn <- importMeta(source = "aurn")
View(aurn)

# How many of each site type
table(aurn$site_type)

# More detailed info, all = TRUE
library(tidyverse)
aurn_detailed <- importMeta(source = "aurn", all = TRUE)

# Find how many sites measure NO2
no2_sites <- filter(
  aurn_detailed,
  variable == "NO2",
  site_type == "Urban Traffic"
)

nrow(no2_sites)

# Plot on a map
library(leaflet)

aurn_unique <- distinct(aurn_detailed, site, .keep_all = TRUE)

# information for map markers
content <- paste(
  paste(
    aurn_unique$site,
    paste("Code:", aurn_unique$code),
    paste("Start:", aurn_unique$date_started),
    paste("End:", aurn_unique$date_ended),
    paste("Site Type:", aurn_unique$site_type),
    sep = "<br/>"
  )
)


# European data
europe <- importMeta(source = "europe")
europe_detailed <- importMeta(source = "Europe", all = TRUE)

europe_unique <- distinct(europe_detailed, site, .keep_all = TRUE)

# information for map markers
content_europe <- paste(
  paste(
    europe_unique$site,
    paste("Code:", europe_unique$code),
    paste("Start:", europe_unique$date_started),
    paste("End:", europe_unique$date_ended),
    paste("Site Type:", europe_unique$site_type),
    sep = "<br/>"
  )
)



# draw plot
leaflet(europe) %>%
  addTiles() %>%
  addMarkers(~ longitude, ~ latitude, popup = content_europe,
             clusterOptions = markerClusterOptions())

# no2 sites in Europe
data_processes <- get_saq_processes()
site_no2 <- data_processes[data_processes$variable == "no2",]$site


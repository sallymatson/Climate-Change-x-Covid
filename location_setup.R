library(maps)

# Demonstating the tool using Burlington, VT:
lat = 44.4
lon = -73.2
country <- map.where(database="world", x=lon, y=lat)

# Create a matrix where each entry maps to the country
countries <- matrix(nrow=720, ncol=1440)
# Offset by 0.25/2 on each end, so that we get the center of the box
lons = seq(-180+0.25/2, 180-0.25/2, by=0.25)
lats = seq(-90+0.25/2, 90-0.25/2, by=0.25)
for (lat_i in 1:720){
  print(paste("We're on", lat_i))
  for (lon_i in 1:1440){
    out = map.where(database="world", x=lons[lon_i], y=lats[lat_i])
    if (is.na(out)){
      # Ocean!
      countries[lat_i, lon_i] = "XX"
    } else {
      countries[lat_i, lon_i] = out
    }
  }
}
write.csv(countries, "countries.csv")

countries_cleaned <- matrix(nrow=720, ncol=1440)
for (lat_i in 1:720){
  print(paste("We're on", lat_i))
  for (lon_i in 1:1440){
    country_clean <- sub("\\:.*", "", countries[lat_i, lon_i])
    countries_cleaned[lat_i, lon_i] <- country_clean
  }
}
write.csv(countries_cleaned, "countries_cleaned.csv")



# Using the chosen countries, get emissions for the day:
filenames <- list.files("data/", pattern="*.he5")
row = 1
world_averages <- matrix(ncol=16, nrow=2009)
countries <- c("Brazil", "Canada", "China", "Germany", "India", "Iran", "Italy", "Japan", "Russia", "Saudi Arabia", "USA")
colnames(world_averages) <- c("year", "month", "day", "date", countries, "World")
for (file in filenames){
  filename = file
  ncin <- nc_open(paste("data/", filename, sep=""))
  year <- substr(filename, 20, 23)
  month <- substr(filename, 25, 26)
  day <- substr(filename, 27, 28)
  no2 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
  world_averages[row,"year"] <- year
  world_averages[row,"month"] <- month
  world_averages[row,"day"] <- day
  world_averages[row,"date"] <- paste(year, month, day, sep="")
  world_averages[row,"World"] <- sum(no2, na.rm=TRUE)/sum(!is.na(no2))
  for (country in countries){
    no2_val <- daily_emissions(no2, countries_cleaned, country)
    world_averages[row,country] <- no2_val
  }
  row = row + 1
}

write.csv(world_averages, 'country_averages_adjusted_new.csv')

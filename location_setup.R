library(maps)

# Burlington, VT:
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

# Create a hashmap with country names as KEYS
# and a list of all of the country's boxes as VALUES
country_hash = new.env()
for (lat_i in 1:720){
  print(paste("We're on", lat_i))
  for (lon_i in 1:1440){
    country = countries_cleaned[lat_i, lon_i]
    if (country != "XX"){
      coords = list(c(lat=lat_i, lon=lon_i))
      country_hash[[country]] = c(country_hash[[country]], coords)
    }
  }
}

what_is_map.where <- function(){
  # Demonstating the tool using Burlington, VT:
  lat = 44.4
  lon = -73.2
  country <- map.where(database="world", x=lon, y=lat)
}


create_country_grid_mapping <- function(){
  
  # Create a matrix with dimensions 720 by 1440. Each matrix entry represents a 
  # 0.25x0.25 degree lat/lon box. Here, we find the middle lat & lon of each matrix 
  # entry assuming equal distribution of boxes across lat & lon. We then figure out 
  # which country that lat & lon corresponds to, and label the matrix entry with the 
  # name of the country. 

  countries <- matrix(nrow=720, ncol=1440)
  # Offset by 0.25/2 on each end, so that we get the center of the box
  lons = seq(-180+0.25/2, 180-0.25/2, by=0.25)
  lats = seq(-90+0.25/2, 90-0.25/2, by=0.25)

  for (lat_i in 1:720){
    for (lon_i in 1:1440){
      out = map.where(database="world", x=lons[lon_i], y=lats[lat_i])
      if (is.na(out)){
        # Ocean!
        countries[lat_i, lon_i] = "XX"
      } else {
        # map.where returns different landmasses as different values; we are 
        # interested in looking at entire countries as a whole so we remove
        # the added value and retain just the country's name.
        countries[lat_i, lon_i] = country_name
        country_name <- sub("\\:.*", "", out)
      }
    }
  }
  write.csv(countries, "countries.csv")
}


daily_emissions <- function(no2_mat, country_boxes, country){
  
  # Calculates TOTAL estimated emissions for one country on one day.
  # Accounts for differing proportions of missing data (NA) for different countries
  # by taking average box value & multiplying by total # boxes.
  
  # Sums up all NO2 just from the country:
  country_observed_no2 = sum((country_boxes==country)*no2_mat, na.rm=TRUE)
  # Calculates number of boxes for that country with readings (not counting NA):
  box_in_country_not_na = sum((country_boxes==country)*!is.na(no2_mat))
  # Gets the average box value for the country:
  country_average = country_observed_no2 / box_in_country_not_na
  # Calculates total number of boxes for the country:
  country_total_boxes = sum(country_boxes==country)
  # Multiplies average box value by the total number of boxes:
  country_total_no2_adjusted = country_average * country_total_boxes
  return(country_total_no2_adjusted)
}


calculate_daily_average_no2 <- function(countries){

  # Using the chosen countries, get emissions for the day
  
  # Uses ALL .he5 files in the no2_data folder so be careful that you have the correct
  # files that you want. For information on how to download the data, see the github's 
  # readme.
  filenames <- list.files("no2_data/", pattern="*.he5")
  row = 1
  world_averages <- matrix(ncol=16, nrow=2009)
  colnames(world_averages) <- c("year", "month", "day", "date", countries, "World")
  for (filename in filenames){
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
    # TODO: parallelize
    for (country in countries){
      no2_val <- daily_emissions(no2, countries_cleaned, country)
      world_averages[row,country] <- no2_val
    }
    row = row + 1
  }
  write.csv(world_averages, 'country_averages_no2_new.csv')  
}


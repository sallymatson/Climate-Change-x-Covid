# Get one country's emissions:
daily_emissions <- function(no2_mat, countries_cleaned, country){
  country_observed_no2 = sum((countries_cleaned==country)*no2_mat, na.rm=TRUE)
  box_in_country_not_na = sum((countries_cleaned==country)*!is.na(no2_mat))
  country_average = country_observed_no2 / box_in_country_not_na
  country_total_boxes = sum(countries_cleaned==country)
  country_total_no2_adjusted = country_average * country_total_boxes
  return(country_total_no2_adjusted)
}

world_emissions <- function(no2_mat, countries_cleaned){
  observed_no2 = sum(no2_mat, na.rm=TRUE)
  boxes_not_na = sum(!is.na(no2_mat))
  average = observed_no2 / boxes_not_na
  total_boxes = 720 * 1440
  total_no2_adjusted = average * total_boxes
  return(total_no2_adjusted)
}

world_emissions_land <- function(no2_mat, countries_cleaned) {
  observed_no2 = sum((countries_cleaned!="XX")*no2_mat, na.rm=TRUE)
  boxes_not_na = sum((countries_cleaned!="XX")*!is.na(no2_mat))
  average = observed_no2 / boxes_not_na
  total_boxes = sum(countries_cleaned!="X")
  total_no2_adjusted = average * total_boxes
  return(total_no2_adjusted)  
}

date_is <- function(num_days){
  start_date = as.Date('2015-01-01')
  return (start_date + num_days)
}




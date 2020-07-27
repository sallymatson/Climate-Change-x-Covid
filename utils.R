# Get one country's emissions:
daily_emissions <- function(no2_mat, countries_cleaned, country){
  country_observed_no2 = sum((countries_cleaned==country)*no2_mat, na.rm=TRUE)
  box_in_country_not_na = sum((countries_cleaned==country)*!is.na(no2_mat))
  country_average = country_observed_no2 / box_in_country_not_na
  country_total_boxes = sum(countries_cleaned==country)
  country_total_no2_adjusted = country_average * country_total_boxes
  return(country_total_no2_adjusted)
}

date_is <- function(num_days){
  start_date = as.Date('2015-01-01')
  return (start_date + num_days)
}

country_boxes <- read.csv('countries_cleaned.csv')
country_boxes <- country_boxes[, colnames(country_boxes) != "X"]

country_no2 <- read.csv('country_averages_adjusted_new.csv')
country_no2 <- country_no2[, colnames(country_no2) != "X"]




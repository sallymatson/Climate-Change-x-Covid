# Get one country's emissions:
country_emissions <- function(no2, country){
  return(sum((countries_cleaned==country)*t(no2), na.rm=TRUE)/sum(countries_cleaned==country))
}
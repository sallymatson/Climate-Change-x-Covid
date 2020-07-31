
lockdown_correlation <- function(no2_data, ld_data, country){
  
  # Calculates correlation for one country between the given no2 data 
  # and the lockdown data. Could be easily substituted with movement 
  # data by changing around some variable names.
  
  no2_name <- paste(country, "NO2", sep="-")
  # Subset the data for just the columns needed:
  no2 <- no2_data[,c(country, "Date_official","year","Date")]
  no2 <- no2[no2[,"year"]==2020,]
  names(no2) <- c(no2_name, "Date_official","year","Date")
  no2_avgs <- country_averages[,c(country,"Date")]
  # Looking at the percent change from the daily average of 2015 to 2019:
  no2_new <- merge(no2, no2_avgs)
  # Use a rolling mean for both the past average & 2020 data:
  no2_new["Pastavg"] <- rollmean(no2_new[,country], k=3, fill=c("expand", "expand", "expand"))
  no2_new["2020"] <- rollmean(no2_new[,no2_name], k=3, fill=c("expand", "expand", "expand"))
  # Percent change is (2020 - pastavg)/pastavg:
  no2_new["Change"] <- (no2_new[,"2020"]-no2_new[,"Pastavg"])/no2_new[,"Pastavg"]
  no2 <- no2_new[,c("Change", "Date_official")]
  
  ld <- ld_data[,c(country, "Date_official")]
  # Take 3 day rolling mean for lockdown data as well:
  ld[,country] <- rollmean(ld[,country], k=3, fill=c("expand", "expand", "expand"))

  # Merge using the "Date_official" category name, which maches month & day:
  df <- merge(no2, ld)
  
  # Calculate the correlation
  out <- cor(df[,"Change"], df[,country], use="complete.obs")
  
  # Optionally plot for visual effect:
  # plot(df[,"Change"], df[,country])

  return(out)
}

corr.main <- function() {
  oxford_results <- matrix(nrow=11, ncol=3)
  colnames(oxford_results) <- c('R_EQ', 'R_WT', 'R_TP')
  countries <- c("Brazil", "Canada", "China", "Germany", "India", "Iran", "Italy", "Japan", "Russia", "Saudi.Arabia", "USA")
  rownames(oxford_results) <- countries
  for (country in countries){
    oxford_results[country,"R_EQ"] <- suppressWarnings(lockdown_correlation(country_no2, gov_allequal, country))
    oxford_results[country,"R_WT"] <- suppressWarnings(lockdown_correlation(country_no2, gov_weighted, country))
    oxford_results[country,"R_TP"] <- suppressWarnings(lockdown_correlation(country_no2, gov_transport, country))
  }
  return(oxford_results)
}

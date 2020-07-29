lockdown_correlation <- function(no2_data, ld_data, country){
  no2_name <- paste(country, "NO2", sep="-")
  ld_name <- paste(country, "LD", sep="-")
  
  # Subset the data for just the columns needed:
  no2 <- no2_data[,c(country, "Date_official","year","Date")]
  no2 <- no2[no2[,"year"]==2020,]
  names(no2) <- c(no2_name, "Date_official","year","Date")
  no2_avgs <- country_averages[,c(country,"Date")]
  no2_new <- merge(no2, no2_avgs)
  no2_new <- no2_new[order(no2_new[,"Date_official"]),]
  no2_new["Pastavg"] <- rollmean(no2_new[,country], k=3, fill=c(0, "expand", 0))
  no2_new["2020"] <- rollmean(no2_new[,no2_name], k=3, fill=c(0, "expand", 0))
  # Percent change is (2020 - pastavg)/pastavg
  no2_new["Change"] <- (no2_new[,"2020"]-no2_new[,"Pastavg"])/no2_new[,"Pastavg"]
  plot(no2_new[,"Date_official"], no2_new[,"Change"])
  abline(h=0, col=2)
  
  no2 <- no2_new[,c("Change", "Date_official")]
  ld <- ld_data[,c(country, "Date_official")]
  
  df <- merge(no2, ld)
  out <- cor(df[,"Change"], df[,country], use="complete.obs")
  plot(df[,"Change"], df[,country])
  return(out)
}

c <- lockdown_correlation(country_no2, gov_weighted, "Italy")


monthly_diff <- function(no2_data, country, month){
  early_months <- c(1:199, 366:552, 719:913, 1080:1278, 1445:1643,1810:2009)
  no2_subset <- no2_data[early_months,c(country,"Date_official","month","year","day")]
  no2_subset_by_month <- no2_subset[no2_subset[,"month"]==month,]
  pre_2020 <- no2_subset_by_month[no2_subset_by_month[,"year"]<2020,]
  in_2020 <- no2_subset_by_month[no2_subset_by_month[,"year"]==2020,]
  averages <- aggregate(no2_subset_by_month, by=list(no2_subset_by_month[,"year"]), mean, na.rm=TRUE)
  t.out <- t.test(pre_2020[,country], in_2020[,country], alternative="greater")
  plot(no2_subset_by_month[,"day"], no2_subset_by_month[,country], col=no2_subset_by_month[,"year"])
  title(paste("NO2 by year for month", month, "in", country))
  return(t.out)
}

country_now = "USA"
t.jan <- monthly_diff(country_no2, country_now, 1)$p.value
t.feb <- monthly_diff(country_no2, country_now, 2)$p.value
t.mar <- monthly_diff(country_no2, country_now, 3)$p.value
t.apr <- monthly_diff(country_no2, country_now, 4)$p.value
t.may <- monthly_diff(country_no2, country_now, 5)$p.value
t.jun <- monthly_diff(country_no2, country_now, 6)$p.value
t.jul <- monthly_diff(country_no2, country_now, 7)$p.value


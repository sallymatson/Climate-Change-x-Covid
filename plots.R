library(zoo)

country_no2_num <- (as.matrix(country_no2))


plot(rollmean(country_no2_num[,"World"], 7, fill=c("extend", "extend", "extend")), type='l', col=2, axes=FALSE, xlab="Date", ylab="No2")
axis(at=seq(2009),labels=date_is(1:2009), side=1)
axis(side=2)


compare_year <- function(country){
  plot(rollmean(country_no2_num[1826:2009,country], 7, fill=c("extend", "extend", "extend")),
       type='l', col=2, axes=FALSE, xlab="Date", ylab="No2",
       ylim=c(min(country_no2_num[c(1461:1644,1826:2009),country], na.rm=TRUE), max(country_no2_num[c(1461:1644,1826:2009),country], na.rm=TRUE)))
  lines(rollmean(country_no2_num[1461:1644,country], 7, fill=c("extend", "extend", "extend")), type='l', col=1)
  axis(at=seq(184),labels=date_is(1826:2009), side=1)
  axis(side=2)
  title(country)
}

percent_change <- function(country){
  plot((country_no2_num[1826:2009,country]-country_no2_num[1461:1644,country])/(country_no2_num[1461:1644,country]),
       type='l', col=2, axes=FALSE, xlab="Date", ylab="No2")
  axis(at=seq(184),labels=date_is(1826:2009), side=1)
  axis(side=2)
  title(country)
  abline(h=0)
}



lons = seq(-180+0.25/2, 180-0.25/2, by=0.25)
lats = seq(-90+0.25/2, 90-0.25/2, by=0.25)
lonlat <- mesh(lons, lats)
quilt.plot(as.vector(lonlat$x),
           as.vector(lonlat$y),
           as.vector(t((ifelse(countries_mat=="USA", 1, NA))*no2)), ny=720, nx=1440)

quilt.plot(as.vector(lonlat$x),
           as.vector(lonlat$y),
           as.vector(t((countries_cleaned=="USA")*!is.na(no2))), ny=720, nx=1440)



country_observed_no2 = sum((countries_cleaned==country)*no2_mat, na.rm=TRUE)
box_in_country_not_na = sum((countries_cleaned==country)*!is.na(no2_mat))
country_average = country_observed_no2 / box_in_country_not_na
country_total_boxes = sum(countries_cleaned==country)
country_total_no2_adjusted = country_average * country_total_boxes   
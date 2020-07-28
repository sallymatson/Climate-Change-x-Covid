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
  plot(100*(country_no2_num[1826:2009,country]-country_no2_num[1461:1644,country])/(country_no2_num[1461:1644,country]),
       type='l', col=2, axes=FALSE, xlab="Date", ylab="No2")
  axis(at=seq(184),labels=date_is(1826:2009), side=1)
  axis(side=2)
  title("Percent change in NO2 from 2019 to 2020")
  abline(h=0)
}

compare_to_past <- function(country){
  plot(rollmean(country_no2_2020[,country], 7, fill=c("extend", "extend", "extend")),
       type='l', col=2, axes=FALSE, xlab="Date", ylab="No2",
       ylim=c(min(country_no2_2020[,country], na.rm=TRUE), max(country_no2_2020[,country], na.rm=TRUE)))
  lines(rollmean(new[1:183,"ChinaAVG"], 7, fill=c("extend", "extend", "extend")), type='l', col=1)
  axis(at=seq(184),labels=date_is(1826:2009), side=1)
  axis(side=2)
  title(country)  
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


yearly_comparison <- function(country){
  plot(as.Date(country_no2_2015[,"Date"], '%m %d'), country_no2_2015[,country], type="l", col="grey85",
       xlab="Date", ylab="NO2", ylim=c(3e+19, 9e+19))
  lines(as.Date(country_no2_2016[,"Date"], '%m %d'), country_no2_2016[,country], type="l", col=3)
  lines(as.Date(country_no2_2017[,"Date"], '%m %d'), country_no2_2017[,country], type="l", col=4)
  lines(as.Date(country_no2_2018[,"Date"], '%m %d'), country_no2_2018[,country], type="l", col=5)
  lines(as.Date(country_no2_2019[,"Date"], '%m %d'), country_no2_2019[,country], type="l", col=6)
  lines(as.Date(country_averages[,"Date"], '%m %d'), country_averages[,country], type="l", col=1)
  lines(as.Date(country_no2_2020[,"Date"], '%m %d'), country_no2_2020[,country], type="l", col=2)
  title(paste(country, "NO2 From 2015-2020"))
}

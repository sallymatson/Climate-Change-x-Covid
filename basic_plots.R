library(plot3D)
library(fields)

one_day_plot <- function(no2){
  
  # Plot one day's worth of data -- code by Laura!
  
  lons = seq(-180+0.25/2, 180-0.25/2, by=0.25)
  lats = seq(-90+0.25/2, 90-0.25/2, by=0.25)
  lonlat <- mesh(lons, lats)
  
  quilt.plot(as.vector(lonlat$x),
             as.vector(lonlat$y),
             as.vector(t(no2)/1e15),
             nx = 1440,
             ny = 720,
             zlim = c(2, 10),
             xlab = "Longitude",
             ylab = "Latitude",
             main = expression('OMI/AURA NO'[2]*' Data 07/07/2020'),
             legend.lab = expression(10^15~"molecule/cm"^2), legend.cex= 0.8)
}

yearly_comparison <- function(country){
  
  # Plots all years 2015 - 2020 on one graph, highlighting the 2015-2019 average & 2020
  
  plot(as.Date(country_no2_2015[,"Date"], '%m %d'), 
       country_no2_2015[,country]/10^15, 
       type="l", 
       col="grey85",
       xlab="Date", 
       ylim=c(2.4, 3.8),
       ylab = expression("Daily Average NO"[2]*" (molecules/cm"^2*")"),
       las=1)
  mtext(expression("x"*10^15), side=2, line=-1, at=3.9, las=1)
  lines(as.Date(country_no2_2016[,"Date"], '%m %d'), country_no2_2016[,country]/10^15, type="l", col="grey85")
  lines(as.Date(country_no2_2017[,"Date"], '%m %d'), country_no2_2017[,country]/10^15, type="l", col="grey85")
  lines(as.Date(country_no2_2018[,"Date"], '%m %d'), country_no2_2018[,country]/10^15, type="l", col="grey85")
  lines(as.Date(country_no2_2019[,"Date"], '%m %d'), country_no2_2019[,country]/10^15, type="l", col="grey85")
  lines(as.Date(country_averages[,"Date"], '%m %d'), country_averages[,country]/10^15, type="l", col=1)
  lines(as.Date(country_no2_2020[,"Date"], '%m %d'), country_no2_2020[,country]/10^15, type="l", col=2)
  title(paste("Global Average NO2 From 2015-2020"))
  legend("bottomright", 
         legend = c("2015 to 2019", "Mean 2015-2019", "2020"), 
         col = c("gray85", "black", "red"), pch=15, inset=0.05)
}



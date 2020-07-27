gov <- read.csv('govresponse.csv')
rownames(gov) <- gov[,1]
gov <- gov[,3:ncol(gov)]

normalize <- function(to_normalize){
  max <- max(to_normalize, na.rm=TRUE)
  min <- min(to_normalize, na.rm=TRUE)
  normalized_vals <- (to_normalize-min)/(max-min)
}


plot(normalize(unlist(gov["China",])))
percent_change <- (country_no2_num[1826:2009,country]-country_no2_num[1461:1644,country])/(country_no2_num[1461:1644,country])
lines(rollmean(normalize(percent_change),7,fill=c("extend", "extend", "extend")))

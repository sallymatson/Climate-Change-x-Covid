library(ncdf4)
setwd("~/Documents/ResearchCode/ClimateData/data")
# This code opens each data file and extracts the date and the global no2 average:
filenames <- list.files(".", pattern="*.he5")
row = 1
out <- matrix(ncol=4, nrow=7)

for (file in filenames){
  filename = file
  ncin <- nc_open(filename)
  year <- substr(filename, 20, 23)
  month <- substr(filename, 25, 26)
  day <- substr(filename, 27, 28)
  no2 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
  no2_global_avg <- (sum(no2, na.rm=TRUE)/sum(!is.na(no2)))
  out[row,1] <- year
  out[row,2] <- month
  out[row,3] <- day
  out[row,4] <- no2_global_avg
  row = row+1
}
test <- list()
for (file in filenames){
  filename = file
  ncin <- nc_open(filename)
  year <- substr(filename, 20, 23)
  month <- substr(filename, 25, 26)
  day <- substr(filename, 27, 28)
  test[row] <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
  row = row+1
}

# This code calculates the average no2 for one country on one day:
filename = "/Users/Laura/Documents/ResearchCode/ClimateCOVID/OMI-Aura_L3-OMNO2d_2020m0712_v003-2020m0714t004312.he5"
ncin <- nc_open(filename)
no2 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
sum((countries_cleaned==USA)*t(no2), na.rm=TRUE)/sum(countries_cleaned==USA)
# ^ can also use the function in utils.R

library(fields)
lons = seq(-180+0.25/2, 180-0.25/2, by=0.25)
lats = seq(-90+0.25/2, 90-0.25/2, by=0.25)
long_no2 = as.vector(no2)
quilt.plot(lons, lats, as.vector(no2))




#make mesh of points
library(plot3D)
lonlat <- mesh(lons, lats)
lonlat$z <- long_no2
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           lonlat$z, 
           col = tim.colors(64, 0.5))

#Plot of NA vs not NA
no2_NA <- ifelse(is.na(as.vector(no2)), 0, 1)
quilt.plot(as.vector(lonlat$x), as.vector(lonlat$y), no2_NA, zlim = c(0.1, 1))

no2_NA1 <- ifelse(!is.na(as.vector(no2)), 1, "NA")

#open multiple files
filename = "/Users/Laura/Documents/ResearchCode/ClimateCOVID/OMI-Aura_L3-OMNO2d_2020m0712_v003-2020m0714t004312.he5"
ncin <- nc_open(filenames[1])
no2_1 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[2])
no2_2 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[3])
no2_3 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[4])
no2_4 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[5])
no2_5 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[6])
no2_6 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
ncin <- nc_open(filenames[7])
no2_7 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))

image.plot(no2_1)
#make plots
lonlat <- mesh(lons, lats)
lonlat$z <- long_no2
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           lonlat$z, 
           col = tim.colors(64, 0.5))

no2_NA1 <- ifelse(is.na(as.vector(t(no2_1))), 0, 1)
quilt.plot(as.vector(lonlat$x), as.vector(lonlat$y), no2_NA1, zlim = c(1, 1))


no2_NA2 <- ifelse(is.na(as.vector(no2_2)), 0, 1)
quilt.plot(as.vector(lonlat$x), as.vector(lonlat$y), no2_NA2, zlim = c(1, 1))
sum((countries_cleaned==USA)*t(no2), na.rm=TRUE)/sum(countries_cleaned==USA)
# ^ can also use the function in utils.R
countries_cleaned <- countries_cleaned[,-1]
no2 = no2_1
usa_no2 = (countries_cleaned=="USA")*no2
china_no2 = (countries_cleaned=="China")*no2
italy_no2 = (countries_cleaned=="Italy")*no2
india_no2 = (countries_cleaned=="China")*no2
diff_usachina <- usa_no2 - china_no2
diff_italyindia = abs(italy_no2 - india_no2)
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(diff_usachina)),
           nx = 1440,
           ny = 720)

quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(diff_italyindia)))
world(add = TRUE)
no2_subset <- no2
no2_subset[!is.na(diff_italyindia) ==0] = NA
##This is the plot that works
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2)), 
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
world(col = "black")
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_1)), 
           add.legend = FALSE,
           add = TRUE,           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_2)), 
           add.legend = FALSE,
           add = TRUE,
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_3)), 
           add.legend = FALSE,
           add = TRUE,
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_4)), 
           add.legend = FALSE,
           add = TRUE,
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_5)), 
           add.legend = FALSE,
           add = TRUE, 
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_6)), 
           add.legend = FALSE,
           add = TRUE,
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_7)), 
           add.legend = TRUE,
           add = TRUE,
           nx = 1440, 
           ny = 720, 
           zlim = c(2e15, 8e15))

#testing if they are different
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_1-no2_2)))

#plot only the US
quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2_1)), 
           nx = 1440, 
           ny = 720, 
           xlim = c(-135,-65),
           ylim = c(19,65),
           zlim = c(2e15, 8e15))
world(add = TRUE)
US(add = TRUE)

#getting US only...
usa_index <- countries_cleaned == "USA"
no2[!usa_index] <- NA

quilt.plot(as.vector(lonlat$x), 
           as.vector(lonlat$y), 
           as.vector(t(no2)),
           nx = 1440,
           ny = 720)

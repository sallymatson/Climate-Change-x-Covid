library(ncdf4)

# This code opens each data file and extracts the date and the global no2 average:
filenames <- list.files(".", pattern="*.he5")
row = 1
out <- matrix(ncol=4, nrow=2009)

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

# This code calculates the average no2 for one country on one day:
filename = "OMI-Aura_L3-OMNO2d_2020m0718_v003-2020m0719t165936.he5"
ncin <- nc_open(filename)
no2 <- t(ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened"))
sum((countries_cleaned==USA)*t(no2), na.rm=TRUE)/sum(countries_cleaned==USA)
# ^ can also use the function in utils.R


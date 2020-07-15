library(ncdf4)
library(maps)

filename = "OMI-Aura_L3-OMNO2d_2020m0301_v003-2020m0611t080447.he5"
ncin <- nc_open(filename)

v1 <- ncvar_get(ncin,"ColumnAmountNO2CloudScreened")

v1 <- ncvar_get(ncin, "Data Fields/ColumnAmountNO2")
dim(v1)

lon <- ncvar_get(ncin, "Data Fields/phony_dim_0")

heatmap(v1)

plot(v1[,1])

heatmap(v1, na.rm=TRUE)




filenames <- list.files(".", pattern="*.he5")
filenames <- filenames[seq(1,length(filenames), by=5)]

setwd("~/Projects/AIM/nitrogen/data")
out <- matrix(ncol=4, nrow=2000)
row = 1
for (file in filenames){
  filename = file
  ncin <- nc_open(filename)
  year <- substr(filename, 20, 23)
  month <- substr(filename, 25, 26)
  day <- substr(filename, 27, 28)
  v1 <- ncvar_get(ncin,"Data Fields/ColumnAmountNO2CloudScreened")
  nitrogen = (sum(v1, na.rm=TRUE)/sum(!is.na(v1)))
  out[row,1] <- year
  out[row,2] <- month
  out[row,3] <- day
  out[row,4] <- nitrogen
  row = row+1
}


out<- out[1:400,]

plot(out[,4], type='l')
plot(out[,2], out[,4], type='l')

file = "OMI-Aura_L3-OMNO2d_2015m0101_v003-2019m1122t175558.he5"
ncin <- nc_open(file)

# 1440: longitudinal direction
# 720: latitude
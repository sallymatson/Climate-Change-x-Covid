library(ncdf4)
library(maps)


filenames <- list.files(".", pattern="*.he5")
#filenames <- filenames[seq(1,length(filenames), by=100)]

out <- matrix(ncol=4, nrow=2009)
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


plot(out[,4], type='l')
plot(out[,2], out[,4], type='l')

# 1440: longitudinal direction
# 720: latitude
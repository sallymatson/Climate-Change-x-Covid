# Do smoothing first & then do a comparison from each year 

paired_t_over_time <- function(y1_data, y2_data, country){
  y1 <- y1_data[,c(country,"Date")]
  y1["Y1"] <- rollmean(y1[,country], k=7, c("expand", "expand", "expand"))
  colnames(y1) <- c("USA-old", "Date", "Y1")
  y2 <- y2_data[,c(country,"Date", "Date_official")]
  y2["Y2"] <- rollmean(y2[,country], k=7, c("expand", "expand", "expand"))
  df <- merge(y1, y2)
  t.test(df[,"Y1"], df[,"Y2"], paired=TRUE)
}

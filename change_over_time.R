## This file has the code needed to generate the paired t-tests from 2015-2020

percent_change <- function(past, present){
  mean_present <- mean(present, na.rm=TRUE)
  mean_past <- mean(past, na.rm=TRUE)
  return((mean_present - mean_past)/mean_past)
}


paired_t_over_time <- function(y1_data, y2_data, country){

  # Performs a paired t-test on 7-day rolling average of two consecutive time series 

  y1 <- y1_data[,c(country,"Date")]
  y1["Y1"] <- suppressWarnings(rollmean(y1[,country], k=7, fill=c("expand", "expand", "expand")))
  colnames(y1) <- c("old", "Date", "Y1")
  y2 <- y2_data[,c(country,"Date", "Date_official")]
  y2["Y2"] <- suppressWarnings(rollmean(y2[,country], k=7, c("expand", "expand", "expand")))
  df <- merge(y1, y2)
  out <- t.test(df[,"Y1"], df[,"Y2"], paired=TRUE, alternative="two.sided")
  return(out)
}


calculate_t_values <- function() {
  p_values <- matrix(nrow=11, ncol=5)
  rownames(p_values) <- countries
  colnames(p_values) <- c('15 to 16', '16 to 17', '17 to 18', '18 to 19', '19 to 20')
  
  mean_percent_change <- matrix(nrow=11, ncol=5)
  rownames(mean_percent_change) <- countries
  colnames(mean_percent_change) <- c('15 to 16', '16 to 17', '17 to 18', '18 to 19', '19 to 20')
  
  for (country in countries){
    out.15.16 <- paired_t_over_time(country_no2_2015, country_no2_2016, country)
    p_values[country,'15 to 16'] <- out.15.16$p.value
    mean_percent_change[country,'15 to 16'] <- percent_change(country_no2_2015[,country], country_no2_2016[,country])
    
    out.16.17 <- paired_t_over_time(country_no2_2016, country_no2_2017, country)
    p_values[country,'16 to 17'] <- out.16.17$p.value
    mean_percent_change[country,'16 to 17'] <- percent_change(country_no2_2016[,country], country_no2_2017[,country])
    
    out.17.18 <- paired_t_over_time(country_no2_2017, country_no2_2018, country)
    p_values[country,'17 to 18'] <- out.17.18$p.value
    mean_percent_change[country,'17 to 18'] <- percent_change(country_no2_2017[,country], country_no2_2018[,country])
    
    out.18.19 <- paired_t_over_time(country_no2_2018, country_no2_2019, country)
    p_values[country,'18 to 19'] <- out.18.19$p.value
    mean_percent_change[country,'18 to 19'] <- percent_change(country_no2_2018[,country], country_no2_2019[,country])
    
    out.19.20 <- paired_t_over_time(country_no2_2019, country_no2_2020, country)
    p_values[country,'19 to 20'] <- out.19.20$p.value
    mean_percent_change[country,'19 to 20'] <- percent_change(country_no2_2019[,country], country_no2_2020[,country])
  }
  
  return(list(p_values=p_values, mean_percent_change=mean_percent_change))
}


plot_t_test_results <- function(p_values, mean_percent_change){
  
  # Creates the tile plot with all of the t-test values
  
  # RECALL:
  # if mean of differences is NEGATIVE than x - y is NEGATIVE so x < y 
  # if p < 0.05 and mean < 0: Previous year was lower (no2 increasing) 
  # if p < 0.05 and mean > 0: Previous year was higher (no2 decreasing)
  # if p >= 0.05: No significant change

  # Organize the information into the right form for geom_plot:
  to_plot <- matrix(nrow=11*5, ncol=4)
  colnames(to_plot) <- c("Country", "Year", "P", "Percentchange")
  row = 1
  for (country in countries){
    for (year in c('15 to 16', '16 to 17', '17 to 18', '18 to 19', '19 to 20')){
      to_plot[row,"Country"] <- country
      to_plot[row,"Year"] <- year
      to_plot[row,"P"] <- p_values[country,year]
      if (p_values[country,year] >= 0.05){
        # Not significant difference
        to_plot[row,"Percentchange"] <- "NA"
      } else {
        to_plot[row,"Percentchange"] <- 100*mean_percent_change[country,year] 
      }
      row = row + 1
    }
  }
  
  to_plot <- as.data.frame(to_plot)
  # Order countries from most to least emissions:
  country_order <- c("China", "USA", "India", "Russia", "Japan", "Germany", "Iran", "Canada", "Saudi.Arabia", "Indonesia", "Brazil", "Italy")
  to_plot$Country <- factor(to_plot$Country, levels = rev(country_order))
  
  # Plot the tile plot!!
  ggplot(to_plot, aes(y=Country, x=Year, fill=as.numeric(as.character(Percentchange)))) +
    geom_tile(color="black", na.rm=TRUE) + 
    scale_fill_gradient2(midpoint=0, low="green", mid="white",
                         high="red", space ="Lab", name="% Change") + 
    xlab("Year Comparison") + ggtitle("Change in NO2 Emissions between Consecutive Years") +
    theme(axis.line = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())
}

t.test.main <- function(){
  t.out <- calculate_t_values()
  plot_t_test_results(t.out$p_values, t.out$mean_percent_change)
}


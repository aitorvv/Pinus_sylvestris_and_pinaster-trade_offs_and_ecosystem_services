#!/usr/bin/Rscript

# Support functions to graph climatic data ----
#
# Aitor Vázquez Veloso
# 2024-10-07
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#



library(tidyverse)



# Graph climodiagram of Walter and Lieth using wc_month data extracted from WorldClim ----
# written by: Aitor Vázquez Veloso
# date: 2024-10-07
# parameters:
# - wc_month: monthly data from WorldClim extracted using the function "wc_monthly_climate"
# - time0: initial year of the period to analyze
# - time: final year of the period to analyze
# - output_path: path to save the graph
# returns:
# - a data frame with the species codes and names

get_climodiagram <- function(wc_month, time0, time, output_path){
  
  # copy monthly data and filter the desired period of time
  df_clim <- wc_month
  period <- c(time0:time)
  time_period <- paste(time0, time, sep = "-")
  df_clim <- df_clim %>% filter(year %in% period)
  
  # average monthly data 
  df_clim <- df_clim %>% 
    group_by(ID, month, long, lat) %>% 
    summarise(tmean = mean(tmean), prec = mean(prec))
  
  # add a column for "wet" and "dry" months based on precipitation ~ temperature
  df_clim <- df_clim %>%
    mutate(month_type = ifelse(prec > 2*tmean, "Wet months", "Dry months"))
  
  # set the maximum precipitation and temperature values having the proportion 1:2
  max_precip <- max(df_clim$prec) + 1
  max_temp <- max_precip / 2  # temperature axis will be half of precipitation scale
  
  # calculate values to display in the subtitle
  mean_temp <- round(mean(df_clim$tmean), 1)
  annual_prec <- round(sum(df_clim$prec), 1)
  
  # custom month labels 
  month_labels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  
  
  
  # create the climodiagram
  ggplot(df_clim, aes(x = month)) +
    
    # shaded area for dry and wet months
    geom_rect(aes(xmin = as.numeric(month) - 0.5, xmax = as.numeric(month) + 0.5,
                  ymin = 0, ymax = max_precip, fill = month_type), alpha = 0.2) +
    
    # precipitation (right axis, blue line)
    geom_bar(aes(y = prec), stat = "identity", fill = "blue", alpha = 0.4, width = 0.8) +  # Precipitation bars
    geom_line(aes(y = prec), color = "blue", size = 1, group = 1) +  # Precipitation line
    
    # temperature (left axis, orange line with points); values are doubled to match the precipitation scale
    geom_line(aes(y = tmean*2), color = "orange", size = 1, group = 1) +  # Temperature line
    geom_point(aes(y = tmean*2), color = "orange", size = 3) +  # Points for temperature
    
    # dual axis scaling with a 1:2 proportion
    scale_y_continuous(
      name = "Temperature (°C)", 
      # set NA for automatic scaling of the temperature axis to prevent clipping
      limits = c(0, NA),  # automatically adjust temperature scale based on data
      # divide temperature axis labels by 2; if changed before some data can be excluded
      labels = function(x) x / 2,
      sec.axis = sec_axis(~ ., name = "Precipitation (mm)", breaks = seq(0, max_precip*2 + 5, by = 10))  # set precipitation axis
    ) +
    
    # custom month labels
    scale_x_discrete(labels = month_labels) +
    
    # customize colors for wet/dry months
    scale_fill_manual(values = c("Wet months" = "yellow", "Dry months" = "skyblue")) +
    
    # add labels and titles
    labs(
      title = "Walter and Lieth Climate Diagram",
      subtitle = paste("Annual Precipitation: ", annual_prec, " mm  |  Average Temperature: ", mean_temp, 
                       "°C  |  Data from ", time_period, sep = ""),  # caption is another good option
      x = "Month", y = "Temperature (°C)",
      fill = "Months: "
    ) +
    
    # customize theme to resemble the image
    theme_minimal() +
    theme(
      plot.title = element_text(size = 15, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 10, face = "italic", hjust = 0.5),
      axis.title.x = element_blank(),
      axis.title.y.left = element_text(color = "orange", size = 12),  # color the temperature axis label
      axis.title.y.right = element_text(color = "blue", size = 12),   # color the precipitation axis label
      legend.position = "bottom",
      # legend.title = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "gray", size = 0.2)
    )
  
  # save the plot
  ggsave(filename = paste(output_path, 'climodiagram_walter_lieth.png', sep = ''), dpi = 300, width = 7, height = 5)
}

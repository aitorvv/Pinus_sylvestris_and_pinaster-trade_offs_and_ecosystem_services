# Get climate data from coordinates ====
#
# Aitor Vázquez Veloso, 19/04/2024
#--------------------------------------#


# Basic steps ====

# path
setwd('')



#
#
# The next code can be used just if WorldClim data is available on your own computer ----
#
#

# # libraries
# library(tidyverse)
# library(raster)
# library(rgdal)
# library(eurostat)
# 
# # load data
# # df <- read.csv('coordenadas.csv', sep = ',')
# df <- data.frame(ID = 1,
#                  lat = 41.858128,
#                  long = -2.950415,
#                  time0 = 1990,
#                  time = 2020)
# 
# 
# # Graph coordinates ====
# 
# 
# # shape all Europe
# shp_0 <- get_eurostat_geospatial(resolution = 10, 
#                                  nuts_level = 1, # big regions
#                                  year = 2021,
#                                  crs = 4326) # WGS84
# 
# # shape Spain
# shp_es <- shp_0[shp_0$CNTR_CODE == 'ES', ]
# 
# # check it
# shp_es %>% 
#   ggplot() +
#   geom_sf()
# 
# # get small regions
# shp_regions  <- get_eurostat_geospatial(
#   resolution = 10,
#   nuts_level = 2, # medium regions
#   year = 2021,
#   crs = 4326) # WGS84
# 
# # get regions from Spain
# shp_es_regions <- shp_regions[shp_regions$CNTR_CODE == 'ES', ]
# 
# # plot Spain regions
# shp_es_regions %>% 
#   ggplot() +
#   geom_sf(size = 0.2, color = "blue") + # border line
#   geom_point(aes(x = long, y = lat), data = df, size = 2, color = "red") +
#   scale_x_continuous(limits = c(-10, 5)) +
#   scale_y_continuous(limits = c(36, 45)) +
#   labs(
#     title = "Site locations",
#     #subtitle = "Annual % of change, 2020 vs 2019",
#     #caption = "Data: Eurostat tec00115"
#   ) +
#   theme_void() # skip borders of the plot
# 
# # get provinces
# shp_small_regions  <- get_eurostat_geospatial(
#   resolution = 10,
#   nuts_level = 3, # province regions
#   year = 2021,
#   crs = 4326) # WGS84
# 
# # get regions from Spain
# shp_cyl_regions <- shp_small_regions[shp_small_regions$CNTR_CODE == 'ES', ]
# 
# # get regions from CyL
# shp_cyl_regions <- shp_cyl_regions[shp_cyl_regions$NAME_LATN %in% c('Ávila', 'Zamora', 'Salamanca', 'León',
#                                                                     'Palencia', 'Valladolid', 'Burgos', 'Soria', 'Segovia'), ]
# 
# # plot Spain regions
# shp_cyl_regions %>% 
#   ggplot() +
#   geom_sf(size = 0.2, color = "blue") + # border line
#   geom_point(aes(x = long, y = lat), data = df, size = 2, color = "red") +
#   scale_x_continuous(limits = c(-10, 5)) +
#   scale_y_continuous(limits = c(36, 45)) +
#   labs(
#     title = "Site locations",
#     #subtitle = "Annual % of change, 2020 vs 2019",
#     #caption = "Data: Eurostat tec00115"
#   ) +
#   theme_void() # skip borders of the plot
# 
# 
# # Manage dataset ====
# 
# # include starting point to the period of time
# # df$time0 <- df$time - 1
# 
# # duplicate ID to adapt it to the functions
# #df$ID <- df$localID
# 
# # target CRS
# CRS <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
# 
# 
# # Get climate data ====
# 
# # 1. run function to get historical climate data
# source('/media/aitor/WDE/iuFOR_trabajo/Proyectos/WorldClim/scripts/wc_historic_monthly_data.R')
# 
# # my period of time
# #period <- df$time_period
# 
# # run functions for month, year and period historical data
# folder_path <- "/media/aitor/WDE/iuFOR_trabajo/Proyectos/WorldClim/historical_monthly_data/"
# 
# # create empty df
# wc_month <- data.frame()
# 
# # loop through each row, as each period of time if different for each plot
# for(k in 1:nrow(df)){
#   
#   # get specific data and period of time
#   k_df <- df[k, ]
#   k_period <- c(k_df$time0:k_df$time)
#   
#   # transform plot data into spatial dataframe
#   k_spdf <- SpatialPointsDataFrame(k_df[ ,c('long','lat')], k_df, proj4string = CRS(CRS))
#   my_points <- spTransform(k_spdf, CRS(CRS))
#   
#   # get climate data
#   k_wc_month <- wc_monthly_climate(wc_path = folder_path,
#                                    points = my_points, 
#                                    data_period = k_period)
#   
#   # bind data
#   wc_month <- rbind(wc_month, k_wc_month)
# }
# 
# # original way to calculate monthly data silenced
# # wc_month <- wc_monthly_climate(wc_path = folder_path,
# #                                points = my_points, 
# #                                data_period = period)
# 
# wc_year <- wc_annual_climate(df = wc_month)
# 
# wc_period <- wc_average_climate(df = wc_year)
# # 
# # # 2. run function to get future climate data
# # source('/media/aitor/WDE/iuFOR_trabajo/Proyectos/WorldClim/scripts/wc_future_MIROC6_data.R')
# # 
# # # run function to get future climate data
# # folder_path <- '/media/aitor/WDE/iuFOR_trabajo/Proyectos/WorldClim/MIROC6_SSP2/'
# # future_clima <- wc_future_climate(folder_path = folder_path, 
# #                                   points = my_points)
# 
# # 3. run function to estimate Martonne Aridity index
# source('/media/aitor/WDE/iuFOR_trabajo/Proyectos/WorldClim/scripts/wc_climate_index.R')
# 
# # calculate martonne for the period of historical data
# m_hist_period <- wc_martonne(df = wc_period, 
#                              prec = wc_period$prec, 
#                              tmean = wc_period$tmean) 
# 
# # calculate martonne for the future periods of time
# # m_fut_period <- wc_martonne(df = future_clima, 
# #                             prec = future_clima$prec, 
# #                             tmean = future_clima$tmean) 
# 
# 
# # 4. clean data obtained and merge with the previous data set
# 
# # adapt historic data
# m_hist_period <- dplyr::select(m_hist_period, ID, M)
# m_hist_period <- rename(m_hist_period, 'MARTONNE' = 'M')
# 
# # adapt future data
# # m_fut_by_period <- m_per_periods(m_fut_period = m_fut_period)
# 
# # merge data with the original one
# plots <- merge(df, m_hist_period, by.x = 'ID', by.y = 'ID')
# # plots4 <- merge(plots4, m_fut_by_period, by.x = 'PLOT_ID', by.y = 'ID')
# 
# # skip possible empty plots
# plots <- plots[plots$MARTONNE != c('', 'NA', 'NaN'), ]
# 
# 
# # Save results ====
# #write.csv(plots, 'plots_climate_data.csv', row.names = FALSE)
# save.image('plot_climate_data_all.RData')

#
#
# The previous code can be used just if WorldClim data is available on your own computer ----
#
#


# Graph climogram for the period 1990-2020 ====

source("3_code/4_plot_climodiagram.R")

load("1_data/2_results/climate/wc_month.rdata")

get_climodiagram(wc_month = wc_month, 
                 time0 = 1990,
                 time = 2020,
                 output_path = '4_figures/location_map/climodiagram/')

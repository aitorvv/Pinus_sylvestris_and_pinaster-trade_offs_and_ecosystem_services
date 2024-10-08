# Export production results to a table ====
#
# Aitor Vázquez Veloso, 08/10/2024
#--------------------------------------#



#### Basic steps ####

library(tidyverse)

setwd('')



#### Data for the ESs included in the paper ####

# load all the data in the same file
load('1_data/2_results/simulation_results.RData')

# filter the data by the selected rotation period
data <- new_df[new_df$Scenario_age == 90, ]
data <- data[data$Action == 'Execution', ]

# add a column with the management type
data$Management <- ifelse(grepl('bau', data$Scenario_file_name), 'BAU', 
                       ifelse(grepl('control', data$Scenario_file_name), 'CONTROL', 
                              ifelse(grepl('carb', data$Scenario_file_name), 'CARBON', 
                                     ifelse(grepl('wood', data$Scenario_file_name), 'WOOD', 'MUSHROOM'))))

# select the columns to export
data <- dplyr::select(data, Management, Plot_ID, V_saw_big, V_saw_small_all, Ectomycorrhizal_mushrooms,Carbon_total_all)

# order by management and plot
data <- data[order(data$Plot_ID, data$Management), ]

# export the data
write.csv(data, '4_figures/production_results.csv', row.names = FALSE)



#### Data for additional metrics included in the paper supplementary material ####

# load all the data in the same file
load('1_data/2_results/simulation_results.RData')

# filter the data by the selected rotation period
data_sm <- new_df[new_df$Scenario_age == 90, ]
data_sm <- data_sm[data_sm$Action == 'Execution', ]

# add a column with the management type
data_sm$Management <- ifelse(grepl('bau', data_sm$Scenario_file_name), 'BAU', 
                          ifelse(grepl('control', data_sm$Scenario_file_name), 'CONTROL', 
                                 ifelse(grepl('carb', data_sm$Scenario_file_name), 'CARBON', 
                                        ifelse(grepl('wood', data_sm$Scenario_file_name), 'WOOD', 'MUSHROOM'))))

# select the columns to export
data_sm <- dplyr::select(data_sm, Management, Plot_ID, N, G, dg, Do, h_mean, Ho, V, V_all, WT, WT_all)
                         

# order by management and plot
data_sm <- data_sm[order(data_sm$Plot_ID, data_sm$Management), ]

# export the data
write.csv(data_sm, '4_figures/production_results-sup_material.csv', row.names = FALSE)

#------------------------------------------------------------------------------------------#
####                            Summarize SIMANFOR scenarios                            ####
#                                                                                          #
#                            Aitor Vázquez Veloso, 16/08/2023                              #
#                              Last modification: 15/01/2024                               #
#------------------------------------------------------------------------------------------#



#### Summary ####

# Code developed to summarize a group of scenarios in a single df to compare them easily


#### Basic steps ####

# libraries
library(readxl)
library(plyr)
library(dplyr)
library(tidyverse)

# set directory
general_dir <- '2_simanfor/output/'
setwd(general_dir)


#### Read SIMANFOR outputs (just plot information) ####

plots <- tibble()  # will contain plot data
directory <- list.dirs(path = ".")  # will contain folder names

# for each subfolder...
for (folder in directory){ 
  
  # each subfolder is stablished as main one
  specific_dir <- paste(general_dir, "substract", folder, sep = "")
  specific_dir <- gsub("substract.", "", specific_dir)
  setwd(specific_dir)
  
  # extract .xlsx files names
  files_list <- list.files(specific_dir, pattern="xlsx")
  
  # for each file...
  for (doc in files_list){
    
    # read plot data
    plot_data <- read_excel(doc, sheet = "Plots")
    
    # create a new column with its name                
    plot_data$File_name <- doc  
    
    # add information to plot df
    ifelse(length(plots) == 0, plots <- rbind(plot_data), plots <- rbind(plots, plot_data))
  }
}


#### Data management - stand evolution ####

# make a copy of the data
df <- plots  

# get scenario code
df$n_scnr <- substr(df$Scenario_file_name, 1, 6)

# select useful information about scenarios
df <- select(df, n_scnr, T, Scenario_age, Action, Harvest_type, Harvest_criteria, Harvest_severity, Trees_to_preserve, 
             Species_to_harvest, Harvest_severity_target)
df <- df[!duplicated(df), ]

# filter management not applied to our stands due to age restriction
# df <- df[df$Scenario_age >= 50,]
# df <- df[!(df$Scenario_age == 50 & df$Action == 'Execution'), ]

# delete Initial load
df <- df[df$Action != 'Initial load', ]

# ver resultados
view(df)

# exportar
write_csv(df, '../../4_figures/summary_scenarios.csv')

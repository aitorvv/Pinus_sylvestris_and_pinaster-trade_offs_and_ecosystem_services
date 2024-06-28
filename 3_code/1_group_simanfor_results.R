#------------------------------------------------------------------------------------------#
####                        Group SIMANFOR results on a single df                       ####
#                                                                                          #
#                            Aitor Vázquez Veloso, 31/03/2022                              #
#                              Last modification: 06/05/2024                               #
#------------------------------------------------------------------------------------------#



#### Summary ####

# Extended explanation here: 
# https://github.com/simanfor/resultados/blob/main/analisis_resultados/analisis_resultados_SIMANFOR.R


#### Basic steps ####

# libraries
library(readxl)
library(plyr)
library(dplyr)
library(ggplot2)
library(tidyverse)

# data set to work with (must be run with all of them)
dataset <- '_WOOD'  # '', '_MUSH', '_BAU', '_CARB', '_WOOD'

# set directory
general_dir <- paste("2_simanfor/output", dataset, sep = "")
if(dataset == 'output'){max_n_scnr <- 8} else {max_n_scnr <- 13}
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
    ifelse(length(plots) == 0, plots <- rbind(plot_data), plots <- bind_rows(plots, plot_data))
  }
}


#### Data management - stand and accumulated wood evolution ####

# set the directory
setwd('')

# make a copy of the data
df <- plots  

# function to round on ages on 5 years step
redondeo <- function(x, base){  
  base * round(x/base)
}                                 

# remove initial load
df <- df[!df$Action == "Initial load", ]

# fill NAs with 0 values
df[is.na(df)] <- 0

# calculate differences per scenario step on the desired variables
# that is the first step to record losses and gains due to thinning
df <- df %>%
  group_by(File_name, Scenario_file_name) %>%
  mutate(V_diff = V - lag(V),
         V_saw_small_diff = V_saw_small - lag(V_saw_small),
         WS_diff= WS - lag(WS),
         # WTHICKB_diff= WTHICKB - lag(WTHICKB),
         # WB2_7_diff= WB2_7 - lag(WB2_7),
         # WTHINB_diff= WTHINB - lag(WTHINB),
         # WTBL_diff= WTBL - lag(WTBL),
         #WSTB_diff= WSTB - lag(WSTB),
         WB_diff= WB - lag(WB),
         WR_diff= WR - lag(WR),
         WT_diff= WT - lag(WT),
         Carbon_total_diff= Carbon_total - lag(Carbon_total),
         Carbon_stem_diff= Carbon_stem - lag(Carbon_stem),
         Carbon_branches_diff= Carbon_branches - lag(Carbon_branches),
         Carbon_roots_diff= Carbon_roots - lag(Carbon_roots),
  )

# skip future errors
#df <- df[!is.na(df$Carbon_total_diff), ]

# create a new df with accumulated values
new_df <- tibble()

# for each scenario...
for(scnr in unique(df$Scenario_file_name)){
  
  # get data
  scnr <- df[df$Scenario_file_name == scnr, ]
  
  # for each plot in the scenario...
  for(plot in unique(scnr$File_name)){
    
    # get data
    plot <- scnr[scnr$File_name == plot, ]
    
    # stablish initial values for accumulated variables as 0
    all_V <- all_WS <- all_WB <- all_WR <- all_WT <- 0
    all_V_saw_small <- 0
    all_Carbon_total <- all_Carbon_stem <- all_Carbon_branches <- all_Carbon_roots <- 0
    
    # for each row...
    for(row in 1:nrow(plot)){
      
      # select data
      new_row <- plot[row, ]
      
      # if it is row 1, then initial values must be taken
      if(row == 1){
        
        # get initial value
        all_V <- new_row$V
        all_V_saw_small <- new_row$V_saw_small
        
        all_WS <- new_row$WS
        # all_WTHICKB <- new_row$WTHICKB
        # all_WB2_7 <- new_row$WB2_7
        # all_WTHINB <- new_row$WTHINB
        # all_WTBL <- new_row$WTBL
        #all_WSTB <- new_row$WSTB
        all_WB <- new_row$WB
        all_WR <- new_row$WR
        all_WT <- new_row$WT
        all_Carbon_total <- new_row$Carbon_total
        all_Carbon_stem <- new_row$Carbon_stem
        all_Carbon_branches <- new_row$Carbon_branches
        all_Carbon_roots <- new_row$Carbon_roots
        
        # add value to the row
        new_row$V_all <- all_V
        new_row$V_saw_small_all <- all_V_saw_small
        new_row$WS_all <- all_WS
        # new_row$WTHICKB_all <- all_WTHICKB
        # new_row$WB2_7_all <- all_WB2_7
        # new_row$WTHINB_all <- all_WTHINB
        # new_row$WTBL_all <- all_WTBL
        #new_row$WSTB_all <- all_WSTB
        new_row$WB_all <- all_WB
        new_row$WR_all <- all_WR
        new_row$WT_all <- all_WT
        new_row$Carbon_total_all <- all_Carbon_total
        new_row$Carbon_stem_all <- all_Carbon_stem
        new_row$Carbon_branches_all <- all_Carbon_branches
        new_row$Carbon_roots_all <- all_Carbon_roots
        
        # if it is another row, then difference between rows is added in abs()
      } else {
        
        # add increment to the previous value
        all_V <- all_V + abs(new_row$V_diff)
        all_V_saw_small <- all_V_saw_small + abs(new_row$V_saw_small_diff)
        
        all_WS <- all_WS + abs(new_row$WS_diff)
        # all_WTHICKB <- all_WTHICKB + abs(new_row$WTHICKB_diff)
        # all_WB2_7 <- all_WB2_7 + abs(new_row$WB2_7_diff)
        # all_WTHINB <- all_WTHINB + abs(new_row$WTHINB_diff)
        # all_WTBL <- all_WTBL + abs(new_row$WTBL_diff)
        #all_WSTB <- all_WSTB + abs(new_row$WSTB_diff)
        all_WB <- all_WB + abs(new_row$WB_diff)
        all_WR <- all_WR + abs(new_row$WR_diff)
        all_WT <- all_WT + abs(new_row$WT_diff)
        all_Carbon_total <- all_Carbon_total + abs(new_row$Carbon_total_diff)
        all_Carbon_stem <- all_Carbon_stem + abs(new_row$Carbon_stem_diff)
        all_Carbon_branches <- all_Carbon_branches + abs(new_row$Carbon_branches_diff)
        all_Carbon_roots <- all_Carbon_roots + abs(new_row$Carbon_roots_diff)
        
        # add value to the row
        new_row$V_all <- all_V
        new_row$V_saw_small_all <- all_V_saw_small
        
        new_row$WS_all <- all_WS
        # new_row$WTHICKB_all <- all_WTHICKB
        # new_row$WB2_7_all <- all_WB2_7
        # new_row$WTHINB_all <- all_WTHINB
        # new_row$WTBL_all <- all_WTBL
        #new_row$WSTB_all <- all_WSTB
        new_row$WB_all <- all_WB
        new_row$WR_all <- all_WR
        new_row$WT_all <- all_WT
        new_row$Carbon_total_all <- all_Carbon_total
        new_row$Carbon_stem_all <- all_Carbon_stem
        new_row$Carbon_branches_all <- all_Carbon_branches
        new_row$Carbon_roots_all <- all_Carbon_roots
      }
      
      # add new row to a new df
      new_df <- rbind(new_df, new_row)
      
    } # row
  } # plot
} # scenario

# round ages
new_df$T <- redondeo(new_df$T, 5) 

# get scenario code
new_df$n_scnr <- substr(new_df$Scenario_file_name, 0, max_n_scnr)

# delete empty rows
new_df <- new_df[!is.na(new_df$n_scnr), ]

rm(new_row, plot, plot_data, plots, scnr, all_V, all_WR, all_WS,
   all_WT, all_WB, directory, doc, files_list, all_V_saw_small,
   general_dir, row, specific_dir, redondeo, folder, max_n_scnr,
   all_Carbon_total, all_Carbon_branches, all_Carbon_roots, all_Carbon_stem)


#### Mean accumulated stand evolution ####

# mean values by scenario and year
stand_evolution <- ddply(new_df, c('n_scnr', 'T'), summarise, 
                         
                         # general variables                         
                         N = mean(N, na.rm = TRUE),                  
                         dg = mean(dg, na.rm = TRUE),
                         Ho = mean(Ho, na.rm = TRUE),  
                         V = mean(V, na.rm = TRUE), 
                         G = mean(G, na.rm = TRUE),
                         
                         # Mushroom variables
                         Ectomycorrhizal_mushrooms = mean(Ectomycorrhizal_mushrooms, na.rm = TRUE),
                         B_edulis = mean(B_edulis, na.rm = TRUE),
                         L_deliciosus = mean(L_deliciosus, na.rm = TRUE),
                         
                         # biomass classification - stand variables
                         WS = mean(WS, na.rm = TRUE),
                         # WTHICKB = mean(WTHICKB, na.rm = TRUE),
                         # WB2_7 = mean(WB2_7, na.rm = TRUE),
                         # WTHINB = mean(WTHINB, na.rm = TRUE),
                         # WTBL = mean(WTBL, na.rm = TRUE),
                         #WSTB = mean(WSTB, na.rm = TRUE), 
                         WB = mean(WB, na.rm = TRUE), 
                         WR = mean(WR, na.rm = TRUE),
                         WT = mean(WT, na.rm = TRUE), 
                         Carbon_total = mean(Carbon_total, na.rm = TRUE), 
                         Carbon_stem = mean(Carbon_stem, na.rm = TRUE), 
                         Carbon_branches = mean(Carbon_branches, na.rm = TRUE), 
                         Carbon_roots = mean(Carbon_roots, na.rm = TRUE), 
                         
                         # all accumulated stand variables
                         WS_all = mean(WS_all, na.rm = TRUE),
                         # WTHICKB_all = mean(WTHICKB_all, na.rm = TRUE),
                         # WB2_7_all = mean(WB2_7_all, na.rm = TRUE),
                         # WTHINB_all = mean(WTHINB_all, na.rm = TRUE),
                         # WTBL_all = mean(WTBL_all, na.rm = TRUE),
                         #WSTB_all = mean(WSTB_all, na.rm = TRUE),
                         WB_all = mean(WB_all, na.rm = TRUE),
                         WR_all = mean(WR_all, na.rm = TRUE),
                         WT_all = mean(WT_all, na.rm = TRUE),
                         Carbon_total_all = mean(Carbon_total_all, na.rm = TRUE),
                         Carbon_stem_all = mean(Carbon_stem_all, na.rm = TRUE),
                         Carbon_branches_all = mean(Carbon_branches_all, na.rm = TRUE),
                         Carbon_roots_all = mean(Carbon_roots_all, na.rm = TRUE),
                         
                         V_saw_small_all = mean(V_saw_small_all, na.rm = TRUE),
                         V_all = mean(V_all, na.rm = TRUE)
)


#### Save results ####

save.image(paste('1_data/2_results/simulation_results', dataset, '.RData', sep = ''))  # save results

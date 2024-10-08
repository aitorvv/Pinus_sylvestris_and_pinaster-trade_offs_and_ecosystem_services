# Graph SIMANFOR simulation results ====
#
# Aitor Vázquez Veloso, 28/06/2024
#--------------------------------------#

#### Basic steps ####

library(ggplot2)
library(ggpubr)
library(viridis)
library(dplyr)
library(plyr)
library(stringr)

setwd('')


#### Load and manage data ####

# data to graph
topics <- c('WOOD', 'MUSH', 'CARB')

# new df
mix_df <- data.frame()
mix_mush_df <- data.frame()

for(topic in topics){
  
  # load information
  load(paste('1_data/2_results/simulation_results_', topic, '.RData', sep = ''))
 
  # column for simulation goal
  new_df$Goal <- ifelse(str_detect(new_df$n_scnr, 'wood'), 'Wood',
                        ifelse(str_detect(new_df$n_scnr, 'carb'), 'Carbon',
                               ifelse(str_detect(new_df$n_scnr, 'mush'), 'Mushroom', 
                                      ifelse(str_detect(new_df$n_scnr, 'bau'), 'BAU',
                                             'Control'))))
  
  # copy data
  mush_df <- new_df

  # filter data
  new_df <- new_df[new_df$T == 120, ]
  new_df <- new_df[new_df$Action != 'Thinning', ]
  new_df$Plot_by_scnr <- paste(new_df$Plot_ID, new_df$n_scnr, sep = '_')
   
  # delete pure stands from the data
  new_df <- new_df[grepl('MX', new_df$Plot_by_scnr), ]
  
  # save in a new df
  mix_df <- rbind(mix_df, new_df)
  
  # prepare mushroom data
  
  # skip thinnings from data
  mush_df <- mush_df[mush_df$Action != 'Thinning',]
  mush_df <- plyr::ddply(mush_df, .(Plot_ID, n_scnr, Goal), summarise, 
                         Ectomycorrhizal_mushrooms_mean = mean(Ectomycorrhizal_mushrooms),
                         Ectomycorrhizal_mushrooms = sum(Ectomycorrhizal_mushrooms*5),
                         Edible_mushroom = sum(Edible_mushroom*5),
                         Marketed_mushroom = sum(Marketed_mushroom*5),
                         B_edulis = sum(B_edulis*5),
                         L_deliciosus = sum(L_deliciosus*5))
  mush_df$Plot_by_scnr <- paste(mush_df$Plot_ID, mush_df$n_scnr, sep = '_')
  
  # delete pure stands from the data
  mush_df <- mush_df[grepl('MX', mush_df$Plot_by_scnr), ]
  
  # save in a new df
  mix_mush_df <- rbind(mix_mush_df, mush_df)
}

# merge data with the neccesary columns
mix_df <- select(mix_df, Plot_by_scnr, n_scnr, Goal, G_proportion_sp1, N_proportion_sp1, 
                 V_saw_big, V_saw_small, Carbon_total_all)
new_df <- merge(mix_df, mix_mush_df, by = c('Plot_by_scnr', 'n_scnr', 'Goal'))
new_df$Initial_mixture <- substring(new_df$Plot_by_scnr, 4, 7)
new_df$Maintain_mixture <- substring(new_df$Plot_by_scnr, 18, 21)
new_df$Maintain_mixture <- ifelse(grepl('PS', new_df$Maintain_mixture, fixed = TRUE), 'YES', 'NO')
new_df$Mixtures <- paste(new_df$Initial_mixture, new_df$Maintain_mixture, sep = '_')
new_df <- select(new_df, Initial_mixture, Maintain_mixture, n_scnr, Goal, G_proportion_sp1, N_proportion_sp1, 
                 Ectomycorrhizal_mushrooms_mean, V_saw_big, V_saw_small, Carbon_total_all)

# remove unnecessary data
rm(mix_df, mix_mush_df, mush_df, df, stand_evolution, dataset, topic, topics)


# graph template ====

get_graph <- function(df, y_column, g_title, x_text, y_text, name){
  
  graph <- ggplot(df, aes(x = Initial_mixture, y = y_column, fill = Maintain_mixture)) +
    geom_bar(stat = 'identity', position = position_dodge(width = 0.9)) +
    #scale_fill_viridis(discrete = TRUE) +
    scale_fill_manual(values = c('NO' = 'darkolivegreen', 'YES' = 'darkolivegreen3')) +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill = "white", color = NA),  # Fondo del gráfico
      panel.background = element_rect(fill = "white", color = NA),  # Fondo del panel
      plot.title = element_text(hjust = 0.5),
      axis.title.x = element_text(size = 14),  # Tamaño del texto del eje x
      axis.title.y = element_text(size = 14),  # Tamaño del texto del eje y
      axis.text.x = element_text(size = 13),  # Tamaño del texto de las etiquetas del eje x
      strip.text = element_text(size = 18),  # Tamaño del texto de las etiquetas de los grupos
      legend.text = element_text(size = 14),   # Tamaño del texto de la leyenda
      legend.title = element_text(size = 16)   # Tamaño del título de la leyenda
    ) +
    labs(title = g_title,
         y = y_text,
         x = x_text,
         fill = "Maintain mixture   ") +
    facet_wrap(~ Goal, scales = 'free_y')
  
  # show and save graph
  graph
  ggsave(paste('4_figures/bar_graphs/mixtures-free_maintain/', name, '.png', sep = ''), width = 10, height = 6)
  
  return(graph)
}

# graph elaboration ====

# G proportion
get_graph(df = new_df, y_column = new_df$G_proportion_sp1, 
          g_title = 'Pinus sylvestris basal area proportion at the end of the simulation',
          x_text = 'Initial mixture', y_text = 'Basal area proportion (%)', name = 'G_proportion')

# N proportion
get_graph(df = new_df, y_column = new_df$N_proportion_sp1, 
          g_title = 'Pinus sylvestris density proportion at the end of the simulation',
          x_text = 'Initial mixture', y_text = 'Density proportion (%)', name = 'N_proportion')

# Ectomycorrhizal mushrooms
df <- new_df[new_df$Goal == 'Mushroom',]
g_ecto <- get_graph(df = df, y_column = df$Ectomycorrhizal_mushrooms_mean, 
          g_title = 'Mean ectomycorrhizal mushrooms production during the simulation period',
          x_text = 'Initial mixture', y_text = expression("Mean ectomycorrhizal mushrooms" ~ (kg ~ ha^-1 ~ year^-1)), 
          name = 'Ectomycorrhizal_mushrooms')

# V saw big
df <- new_df[new_df$Goal == 'Wood',]
g_sbig <- get_graph(df = df, y_column = df$V_saw_big, 
          g_title = 'Production of big sawlogs at the end of the simulation',
          x_text = 'Initial mixture', y_text = expression("Volume of big sawlogs" ~ (m^3 ~ ha^-1)), 
          name = 'V_saw_big')

# V saw small
g_ssma <- get_graph(df = df, y_column = df$V_saw_small, 
          g_title = 'Production of small sawlogs at the end of the simulation',
          x_text = 'Initial mixture', y_text = expression("Volume of small sawlogs" ~ (m^3 ~ ha^-1)), 
          name = 'V_saw_small')

# Carbon total
df <- new_df[new_df$Goal == 'Carbon',]
g_carb <- get_graph(df = df, y_column = df$Carbon_total_all, 
          g_title = 'Total carbon storage at the end of the simulation',
          x_text = 'Initial mixture', y_text = expression("Total carbon storage" ~ (tn ~ ha^-1)), 
          name = 'Carbon_total_all')


# Group all the graphs ====

# delete titles and x axis labels
g_carb <- g_carb + labs(title = NULL, x = NULL)
g_ecto <- g_ecto + labs(title = NULL, x = NULL)
g_sbig <- g_sbig + labs(title = NULL, x = NULL)
g_ssma <- g_ssma + labs(title = NULL, x = NULL)

# generate the grid
combined_plot <- ggarrange(g_carb, g_ecto, g_sbig, g_ssma, 
          ncol = 2, nrow = 2,
          common.legend = TRUE, legend = "right",
          labels = c('A', 'B', 'C', 'D'))
          #label.x = 0.05, label.y = 0.95)
combined_plot                           

# add a title to the bottom
combined_plot_annotated <- annotate_figure(combined_plot,
                                           bottom = text_grob("Initial mixture", size = 17))
combined_plot_annotated

# save the graph
ggsave('4_figures/bar_graphs/mixtures-free_maintain/combined_plot.png', width = 17, height = 10)

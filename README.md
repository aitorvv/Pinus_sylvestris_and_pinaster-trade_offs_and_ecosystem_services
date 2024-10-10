# *Pinus sylvestris and pinaster* - trade offs and ecosystem services 

*A repository with the original data, code and results of the scientific article titled:*

***Trade-Offs and Management Strategies for Ecosystem Services in Mixed Scots Pine and Maritime Pine Forests***

---

# Trade-Offs and Management Strategies for Ecosystem Services in Mixed Scots Pine and Maritime Pine Forests

:open_file_folder: Repository DOI: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13904531.svg)](https://doi.org/10.5281/zenodo.13904531)

<!-- 
:bulb: Have a look at the original poster [here](http://dx.doi.org/10.13140/RG.2.2.27865.94564).

:bookmark: Poster DOI: http://dx.doi.org/10.13140/RG.2.2.27865.94564

:open_file_folder: Repository DOI: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10993345.svg)](https://doi.org/10.5281/zenodo.10993345)

--- 

-->

## :book: Abstract

Mixed forests are increasingly recognized for their resilience to climate change and enhanced ecosystem services (ESs) provision, making them a focal point for sustainable forest management strategies. This study examines the trade-offs in ESs provision between pure and different mixed stands proportions of Scots pine (*Pinus sylvestris* L.) and Maritime pine (*Pinus pinaster* Ait.) in the Northern Iberian Range, Spain. Using the SIMANFOR simulation platform, we evaluated various silvicultural scenarios developed to obtain different ESs such as carbon sequestration, timber and mushroom yields. Our findings reveal that ESs provision varies depending on the forest type (pure or mixed) and the mixture proportion, following different trends on each ES. The initial species proportions and their maintenance were less critical than the management approach itself, which significantly influenced ESs outcomes. Focusing solely on individual ESs can lead to trade-offs, as highlighted by our study on silviculture focused on big saw timber yields. However, adopting a balanced approach that considers multiple ESs can mitigate these trade-offs. Our findings underscore the effectiveness of this approach in maximizing yields of mushrooms, sequestered carbon, and small saw timber. This research provides valuable insights for forest managers aiming to balance productivity and sustainability in ESs provision, providing strategies to maximize compatible ESs effectively.

---

## :file_folder: Repository Contents

- :floppy_disk: **1_data**:
    
    - :evergreen_tree: **1_raw** contains the tree and plot original datasets used to perform simulations; climate raw data extracted from WorldClim is also there in *.RData* format

    - :evergreen_tree: **2_results** contains the simulation results grouped by the silvicultural scenario
    
      - :sunny: **climate**: climate data obtained from [WorldClim data](https://www.worldclim.org/data/index.html); data from the study area in available on this folder
        


- :seedling: :arrow_right: :deciduous_tree: **2_simanfor** contains the outputs for all the simulations developed with [SIMANFOR](www.simanfor.es). Check out them! There are a lot of features unexplored in this work :wood: :maple_leaf:

- :computer: **3_code**:


| Script Name     | Purpose                  | Input                    | Output                   |
|-----------------|-----------------------|--------------------------|--------------------------|
| `0_wc_data_from_coordinates.r` *code to extract data from WorldClim not attached*| Uses the original study area coordinates data to extract climate information from downloaded [WorldClim data](https://www.worldclim.org/data/index.html) | study area coordinates | `1_data/1_raw/plot_climate_data_all.RData`
| `1_group_simanfor_results.r` | Reads all the SIMANFOR outputs, complete the calculations and organize them to be graph | `1_data/1_raw/*.xlsx` | `1_data/2_results/*.RData` |
| `2.0_graph_results.r` | Code to graph results the simulation results already grouped with the previous code | `1_data/2_results/*.RData` | `4_figures/bar_graphs/mixtures-free_maintain` |
| `2.1_table_results.r` | Code to extract results of the simulation that are included in the paper | `1_data/2_results/*.RData` | `4_figures/production_results.csv` and `4_figures/production_results-sup_material.csv` |
| `3_summary_scenarios.r` | Code to create a simulation summary for the silvicultural scenarios simulated with SIMANFOR | `1_data/2_results/simulation_results.RData` | `4_figures/summary_scenarios.csv` |
| `4_plot_climodiagram.R` | Code with a function to create climodiagrams from monthly weather data | - | -
| `4_wc_data_from_coordinates.r` | Code to extract climate information from WorldClim data and plot a climodiagram using the function of the previous file | `1_data/2_results/climate/*` | `4_figures/location_map/climodiagram/climodiagram_walter_lieth.png` |

- :bar_chart: **4_figures**: graphs developed with the previously detailed code and figures used in the article:

    - *location_map* includes the QGIS project used to create the location map and its result
    - *simanfor* contains the figures used to show the simulator workflow
    - *graphs* contains the plots included in the study and additional ones
    - *\*.csv* files include numerical outputs that has been included in the study

- :books: **5_bibliography**: references used in the article and additional information related to the topic

---

## :information_source: License

The content of this repository is under the [MIT license](./LICENSE).

---

## :link: About the authors:

#### Aitor Vázquez Veloso:

[![](https://github.com/aitorvv.png?size=50)](https://github.com/aitorvv) \\
[ORCID](https://orcid.org/0000-0003-0227-506X) \\
[Researchgate](https://www.researchgate.net/profile/Aitor_Vazquez_Veloso) \\
[LinkedIn](https://www.linkedin.com/in/aitorvazquezveloso/) \\
[Twitter](https://twitter.com/aitorvv) \\
[UVa](https://portaldelaciencia.uva.es/investigadores/178830/detalle)

#### Irene Ruano Benito

[![](https://github.com/ireneruano.png?size=50)](https://github.com/ireneruano) \\
[ORCID](https://orcid.org/0000-0003-4059-1928) \\
[Researchgate](https://www.researchgate.net/profile/Irene-Ruano) \\
[LinkedIn](https://www.linkedin.com/in/ireneruano) \\
[Twitter](https://x.com/iruanopalencia) \\
[UVa](https://portaldelaciencia.uva.es/investigadores/181463/detalle)

#### Felipe Bravo Oviedo:

[![](https://github.com/Felipe-Bravo.png?size=50)](https://github.com/Felipe-Bravo) \\
[ORCID](https://orcid.org/0000-0001-7348-6695) \\
[Researchgate](https://www.researchgate.net/profile/Felipe-Bravo-11) \\
[LinkedIn](https://www.linkedin.com/in/felipebravooviedo) \\
[Twitter](https://twitter.com/fbravo_SFM) \\
[UVa](https://portaldelaciencia.uva.es/investigadores/181874/detalle)

---

[*Pinus sylvestris and pinaster* - trade offs and ecosystem services 
](https://github.com/aitorvv/Pinus_sylvestris_and_pinaster-trade_offs_and_ecosystem_services) 
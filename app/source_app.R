library(tidyverse)
library(here)
library(rio)
library(ggtext)
library(rnaturalearth)
library(rnaturalearthdata)

# movement page ----
mvmt_full <- import(here("data-clean", "mvmt_full.csv"))

# movements
movements <- mvmt_full %>% distinct(group) %>% arrange(group) %>% pull()

# movement methods vis
mvmt_methods_plot <- function(movement) {
  
  mvmt_plot <- mvmt_full %>% 
    filter(group == movement) %>%
    select(facname, year, method) %>% 
    mutate(col = case_when(method == "Violence" ~ "#9C3A4A",
                           method == "Nonviolence" ~ "#146AA1",
                           method == "Mixed" ~ "#06AAC1",
                           method == "No activity" ~ "#6C8995")) %>% 
    arrange(method)
  
  ggplot(mvmt_plot, aes(x = year, y = facname, fill = method)) + 
    geom_raster() + 
    theme_minimal() + 
    theme(plot.title = element_markdown(face = "bold", size = 16),
          plot.title.position = "plot",
          plot.subtitle = element_markdown(size = 14),
          legend.position = "none",
          axis.text = element_text(size = 12)) + 
    labs(title = paste0(movement, "'s evolution of methods over time"),
         subtitle = "Mapping periods of <span style = 'color:#9C3A4A;'>violence</span>, <span style = 'color:#146AA1;'>non-violence</span>, <span style = 'color:#06AAC1;'>mixed methods</span>, and <span style = 'color:#6C8995;'>no activity</span>",
         x = NULL,
         y = NULL) + 
    scale_fill_manual(values = mvmt_plot %>% distinct(col) %>% pull())
  
}

# movement map
mvmt_map_plot <- function(movement) {
  
  mvmt_df <- mvmt_full %>% 
    filter(group == movement)
  
  map <- ne_countries(scale = "medium", returnclass = "sf") %>% 
    filter(admin %in% (mvmt_df %>% distinct(country) %>% pull()))
  
  ggplot(map) + 
    geom_sf() + 
    theme_void()
  
}

mvmt_map_plot(movements[1])

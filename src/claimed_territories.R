# This script creates the base file for the claimed territory database.

library(tidyverse)
library(here)
library(rnaturalearth)
library(rnaturalearthdata)

claimed_territories <- rio::import(here("data-clean", "claimed_territories.csv")) %>% 
  filter(group == "Berbers")

countries <- claimed_territories %>% distinct(country) %>% pull()
claimed <- claimed_territories %>% distinct(name) %>% pull()

map <- ne_states(country = countries, returnclass = "sf") %>% 
  mutate(col = case_when(name %in% claimed ~ 1))

ggplot(map, aes(fill = col)) + 
  geom_sf() + 
  theme_void() + 
  theme(legend.position = "none")


# This script cleans and structures relevant data on movements. 

library(tidyverse)
library(here)

# import raw organisation data ----
org_raw <- rio::import(here("data-raw", "SRDP_Org_2019_release.dta")) %>% 
  select(facname:political_nocoop)

# determine violence strategy ----
org_df <- org_raw %>% 
  mutate(violence = case_when(violence_state == 1 | fatal_violence_state == 1 | violence_org == 1 | fatal_violence_org == 1 | violence_ingroup == 1 | fatal_violence_ingroup == 1 | violence_outgroup == 1 | fatal_violence_outgroup ~ 1,
                              TRUE ~ 0),
         nonviolence = case_when(economic_noncoop == 1 | protest_demonstration == 1 | nvintervention == 1 | social_noncoop == 1 | institutional == 1 | political_nocoop == 1 ~ 1,
                                 TRUE ~ 0),
         method = case_when(violence == 1 & nonviolence == 1 ~ "Mixed",
                            violence == 1 & nonviolence != 1 ~ "Violence",
                            violence != 1 & nonviolence == 1 ~ "Nonviolence",
                            TRUE ~ "No activity"),
         # account for coding error
         country = case_when(group == "Bakongo" ~ "Angola",
                             group == "Lunda and Yeke", ~ "Democratic Republic of the Congo",
                             country == "United States" ~ "United States of America",
                             TRUE ~ country))

# get risk assessment ----
org_df <- org_df %>% 
  left_join(rio::import(here("data-clean", "mvmt_description.csv"))) %>% 
  select(facname, country, group, year, method, risk_assessment) %>% 
  mutate(method = factor(method)) %>% 
  distinct() %>% 
  write_csv(here("data-clean", "mvmt_full.csv"))



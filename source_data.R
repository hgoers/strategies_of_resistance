library(tidyverse)
library(here)
library(rio)

# download data from PRIO ----
# TO DO

# read in data ----
raw_mvmt_df <- import(here("data-raw", "SRDP_Mvmt_2019_release.dta")) 
raw_org_df <- import(here("data-raw", "SRDP_Org_2019_release.dta")) 

# lengthen and clean data ----
# set parametres of interest
vio_tactics <- c("Violence against the state", "Fatal violence against the state",
                 "Violence against another organization", "Fatal violence against another organization",
                 "Violence against in-group civilians", "Fatal violence against in-group civilians",
                 "Violence against out-group civilians", "Fatal violence against out-group civilians")


org_df <- raw_org_df %>% 
  select(facname:political_nocoop) %>% 
  pivot_longer(violence_state:political_nocoop, names_to = "tactic") %>% 
  mutate(tactic = recode(tactic, 
                         violence_state = "Violence against the state",
                         fatal_violence_state = "Fatal violence against the state",
                         violence_org = "Violence against another organization",
                         fatal_violence_org = "Fatal violence against another organization",
                         violence_ingroup = "Violence against in-group civilians",
                         fatal_violence_ingroup = "Fatal violence against in-group civilians",
                         violence_outgroup = "Violence against out-group civilians",
                         fatal_violence_outgroup = "Fatal violence against out-group civilians",
                         economic_noncoop = "Economic noncooperation",
                         protest_demonstration = "Protest and demonstration",
                         nvintervention = "Non-violent intervention",
                         social_noncoop = "Social noncooperation",
                         institutional = "Institutional action",
                         political_nocoop = "Political noncooperation")) %>% 
  filter(value == 1) %>% 
  select(-value) %>% 
  mutate(violence = case_when(tactic %in% vio_tactics ~ 1,
                              TRUE ~ 0),
         fatal_violence = case_when(str_detect(tactic, "Fatal") ~ 1,
                                    TRUE ~ 0))
  

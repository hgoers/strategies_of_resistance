# This script pulls the risk assessment of each movement included in the 
# Minorities at Risk project.

library(tidyverse)
library(here)
library(rvest)

# get movement IDs ----
mvmt_id <- rio::import(here("data-raw", "SRDP_Org_2019_release.dta")) %>% 
  distinct(group, numcode) %>% 
  drop_na(numcode)

# pull descriptions from MAR ----
get_MAR <- function(group_id) {
  
  url <- paste0("http://www.mar.umd.edu/assessment.asp?groupId=", group_id)
  
  content <- xml2::read_html(url)
  
  risk_assessment <- content %>% 
    html_nodes("p") %>% 
    html_text() %>% 
    as_tibble() %>% 
    mutate(type = case_when(value == "Risk Assessment | Analytic Summary | References" ~ "Risk assessment",
                            value == "top" ~ "Content")) %>% 
    fill(type) %>% 
    filter(type == "Risk assessment",
           value != "Risk Assessment | Analytic Summary | References",
           str_detect(value, "[A-z]")) %>% 
    pull(value)
  
  risk_assessment <- paste(risk_assessment, collapse = " ")
  
  mvmt_info <- tibble(numcode = group_id, risk_assessment)
  
}

mvmt_raw <- map_dfr(mvmt_id$numcode, get_MAR)

mvmt_clean <- mvmt_raw %>% 
  mutate(risk_assessment = str_replace_all(risk_assessment, "�", "'")) %>% 
  filter(risk_assessment != "n/a") %>% 
  write_csv(here("data-clean", "mvmt_description.csv"))

#### Preamble ####
# Purpose: Cleans raw dinesafe data
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisites: access and read raw_dinesafe_data

#### Workplace setup ####
library(tidyverse)

#### Data cleaning ####
# read raw data file in 
raw_dinesafe_data <- read_csv("data/01-raw_data")

# pull out variables of interest
dinesafe_data <- raw_dinesafe_data |>
  select(`Establishment Type`, `Min. Inspections Per Year`, `Severity`, `Action`)

# rename variables
dinesafe_data <- dinesafe_data |>
  rename(establishment_type = `Establishment Type`,
         min_inspections = `Min. Inspections Per Year`,
         severity = `Severity`,
         action = `Action`)

# get rid of na rows
dinesafe_data <- dinesafe_data |>
  drop_na()

dinesafe_data <- dinesafe_data |>
  filter(severity != "NA - Not Applicable")

#### Save as cleaned data ####
write_csv(dinesafe_data, "data/02-analysis_data")

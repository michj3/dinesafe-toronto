#### Preamble ####
# Purpose: Simulate possible observations with the US polling dataset
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisites: access and read dinesafe_data and/or 02-analysis_data

#### Workplace setup ####
library(tidyverse)
library(arrow)

#### Simulation ####
establishments <- c("Formal Dining", "Fast Food", "Grocery", "Industrial", "Institutional")
inspections <- c(1,2,3)
severity_levels <- c("M - Minor", "C - Crucial", "S - Significant")

set.seed(3)
simulated_dinesafe_data <- tibble(
  "Establishment Type" = sample(establishments, size = 100, replace = TRUE),
  "Minimum Inspections Per Year" = sample(inspections, size = 100, replace = TRUE),
  "Severity Level" = sample(severity_levels, size = 100, replace = TRUE)
)

write_csv(simulated_dinesafe_data, "data/00-simulated_data.csv")
write_parquet(simulated_dinesafe_data, "data/00-simulated_data.parquet")

#### Preamble ####
# Purpose: Simulate possible observations with the US polling dataset
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisites: access and read dinesafe_data and/or 02-analysis_data

#### Workplace setup ####
library(tidyverse)

#### Simulation ####
establishments <- c("Food Depot", "Food Take out", "Restaurant", "Food Store
                    (Convenience/Variety)", "Food Processing Plant", "Food Caterer",
                    "Community Kitchen (Meal Program)", "Boarding / Lodging Home - Kitchen",
                    "Bakery", "Cafeteria - Private Access","Food Bank","Food Court Vendor",
                    "Supermarket", "Cocktail Bar / Beverage Room", "Retirement Homes(Licensed)",
                    "Butcher Shop","Fish Shop", "Child Care - Food Preparation", 
                    "Child Care - Catered","Serving Kitchen", "Institutional Food Services",
                    "Mobile Food Preparation Premises","Centralized Kitchen",
                    "Banquet Facility","Cafeteria - Public Access", "Private Club",
                    "Commissary", "Food Vending Facility", "Ice Cream / Yogurt Vendors",
                    "Student Nutrition Site","College / University Food Services",
                    "Rest Home", "Bake Shop","Nursing Home / Home for the Aged",
                    "Elementary School Food Services","Secondary School Food Services",
                    "Hospitals & Health Facilities", "Food Cart","Refreshment Stand (Stationary)",
                    "Other Educational Facility Food Services","Church Banquet Facility",
                    "Catering Vehicle", "Flea Market", "Hot Dog Cart")
inspections <- c(1,2,3)
severity_levels <- c("M - Minor", "C - Crucial", "S - Significant")

set.seed(3)
simulated_dinesafe_data <- tibble(
  "Establishment Type" = sample(establishments, size = 100, replace = TRUE),
  "Minimum Inspections Per Year" = sample(inspections, size = 100, replace = TRUE),
  "Severity Level" = sample(severity_levels, size = 100, replace = TRUE)
)

write_csv(simulated_dinesafe_data, "data/00-simulated_data.csv")

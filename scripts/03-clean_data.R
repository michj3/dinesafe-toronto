#### Preamble ####
# Purpose: Cleans raw dinesafe data
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisites: access and read raw_dinesafe_data

#### Workplace setup ####
library(tidyverse)
library(arrow)

#### Data cleaning ####
# read raw data file in 
raw_dinesafe_data <- read_csv("data/01-raw_data.csv")

# pull out variables of interest
dinesafe_data <- raw_dinesafe_data |>
  select(`Establishment Type`, `Min. Inspections Per Year`, `Severity`, `Action`)

# rename variables
dinesafe_data <- dinesafe_data |>
  rename(establishment_type = `Establishment Type`,
         min_inspections = `Min. Inspections Per Year`,
         severity = `Severity`,
         action = `Action`)

# get rid of n/a rows
dinesafe_data <- dinesafe_data |>
  drop_na()

dinesafe_data <- dinesafe_data |>
  filter(severity != "NA - Not Applicable")

# group establishment_type into categories for purpose of modeling
# formal dining
dinesafe_data <- dinesafe_data |>
  mutate(establishment_type = case_when(
    establishment_type %in% c("Restaurant", "Cocktail Bar / Beverage Room", "Bakery", "Bake Shop") ~ "Formal Dining",
    TRUE ~ establishment_type  # Keep other values unchanged
  ))

# institution food prep
dinesafe_data <- dinesafe_data |>
  mutate(establishment_type = case_when(
    establishment_type %in% c("College / University Food Services", "Child Care - Catered", "Institutional Food Services", "Cafeteria - Private Access",
                              "Cafeteria - Public Access", "Student Nutrition Site", "Secondary School Food Services", 
                              "Child Care - Food Preparation", "Hospitals & Health Facilities", "Elementary School Food Services",
                              "Church Banquet Facility", "Other Educational Facility Food Services", "Rest Home",
                              "Nursing Home / Home for the Aged", "Serving Kitchen", "Community Kitchen (Meal Program)",
                              "Food Caterer", "Boarding / Lodging Home - Kitchen", "Food Bank", "Private Club", "Centralized Kitchen",
                              "Retirement Homes(Licensed)", "Commissary", "Banquet Facility") ~ "Institution Food Prep",
    TRUE ~ establishment_type 
  ))

# grocery
dinesafe_data <- dinesafe_data |>
  mutate(establishment_type = case_when(
    establishment_type %in% c("Supermarket", "Fish Shop", "Flea Market", "Butcher Shop", "Food Vending Facility",
                              "Food Store (Convenience/Variety)") ~ "Grocery",
    TRUE ~ establishment_type 
  ))

# fast food
dinesafe_data <- dinesafe_data |>
  mutate(establishment_type = case_when(
    establishment_type %in% c("Food Take Out", "Food Court Vendor", "Ice Cream / Yogurt Vendors", "Food Cart", "Hot Dog Cart",
                              "Hot Dog Cart", "Refreshment Stand (Stationary)", "Mobile Food Preparation Premises", "Catering Vehicle") ~ "Fast Food",
    TRUE ~ establishment_type 
  ))

# industrial food preparation
dinesafe_data <- dinesafe_data |>
mutate(establishment_type = case_when(
  establishment_type %in% c("Food Processing Plant", "Food Depot") ~ "Industrial",
  TRUE ~ establishment_type 
))

#### Save as cleaned data ####
write_csv(dinesafe_data, "data/02-analysis_data.csv")
write_parquet(dinesafe_data, "data/02-analysis_data.parquet")

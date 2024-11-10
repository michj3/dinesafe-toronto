#### Preamble ####
# Purpose: Downloads and saves the data from OpenDataToronto
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca

#### Work space set up ####

library(tidyverse)
library(opendatatoronto)
library(dplyr)

#### Download data #### 

# get package
package <- show_package("b6b4f3fb-2e2c-47e7-931d-b87d22806948")
package

# get all resources for this package
resources <- list_package_resources("b6b4f3fb-2e2c-47e7-931d-b87d22806948")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
raw_dinesafe_data <- filter(datastore_resources, row_number()==1) %>% get_resource()
raw_dinesafe_data

#### Save data ####
write_csv(raw_dinesafe_data, "data/01-raw_data")

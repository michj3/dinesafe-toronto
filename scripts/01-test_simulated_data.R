#### Preamble ####
# Purpose: Test simulation data 
# Author: Michelle Ji
# Date: 10 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisites: access and read 00-simulated_data.R

#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Test ####
# test that there are 44 types of food establishments
test_that("There are exactly 44 types of food establishments", {
  num_types <- length(unique(simulated_dinesafe_data$`Establishment Type`))
  expect_equal(num_types, 44)
})

# test that minimum inspections is 1, maximum is 3
test_that("minimum inspections are between 1 and 3", {
  expect_true(all(simulated_dinesafe_data$`Minimum Inspections Per Year` >= 1))
  expect_true(all(simulated_dinesafe_data$`Minimum Inspections Per Year` <= 3))
})

# test that there are only 3 severity levels
test_that("There are exactly 3 severity levels", {
  num_severity_levels <- length(unique(simulated_dinesafe_data$`Severity Level`))
  expect_equal(num_severity_levels, 3)
})

# test classes
test_that("Column types are as expected", {
  expect_true(is.character(simulated_dinesafe_data$`Severity Level`))
  expect_true(is.character(simulated_dinesafe_data$`Establishment Type`))
  expect_true(is.numeric(simulated_dinesafe_data$`Minimum Inspections Per Year`))
})

# test for missing values
test_that("No missing values in critical columns", {
  expect_false(any(is.na(simulated_dinesafe_data$`Severity Level`))) 
  expect_false(any(is.na(simulated_dinesafe_data$`Establishment Type`))) 
  expect_false(any(is.na(simulated_dinesafe_data$`Minimum Inspections Per Year`)))
})

# note: the data may contain duplicate rows but they are for different dinesafe violations


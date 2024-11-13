#### Preamble ####
# Purpose: Make models of the data to generate inferential statistics
# Author: Michelle Ji
# Date: 12 November 2024
# Contact: michelle.ji@mail.utoronto.ca
# Prerequisite:  Run 02-download_data.R, 03-clean_data.R

#### Work space set up ####
library(tidyverse)
library(VGAM)
library(car)
dinesafe_data <- read_csv("data/02-analysis_data.csv")


#### Model ####
# convert categorical variables into factor
dinesafe_data$severity <- as.factor(dinesafe_data$severity) 
dinesafe_data$establishment_type <- as.factor(dinesafe_data$establishment_type)
dinesafe_data$min_inspections <- as.factor(dinesafe_data$min_inspections)

# Relevel to use "minor" as reference level
dinesafe_data$severity <- relevel(dinesafe_data$severity, ref = "M - Minor")
# fit multinomial logistic regression model
dinesafe_model <- vglm(severity ~ min_inspections + establishment_type, 
                       data = dinesafe_data, family = multinomial)
# Check the updated factor levels
levels(dinesafe_data$severity)

summary(dinesafe_model)

#### Model Validation ####
# independence of observations
# we can assume independent observations since each of the observations is a separate
# restaurant or individual violation of dinesafe. the restaurants 
# do not have any relationship with each other

# linearity in log odds -- we see a linear relationship with the numerical variable
# of min_inspections to log odds. the vertical lines are due to the fact that min_inspections only takes 3 possible distinct values 
# we likely can only use this to check since the other predictor is categorical

dinesafe_data$min_inspections <- as.numeric(as.character(dinesafe_data$min_inspections))
fitted_probs <- fitted(dinesafe_model, type = "response")
log_odds <- log(fitted_probs[, 1] / fitted_probs[, 3])

plot(dinesafe_data$min_inspections, log_odds, 
     xlab = "min_inspections", ylab = "Predicted Log-Odds", 
     main = "Linearity Check for Log-Odds")


# no multicollinearity

#if we look at the correlation, the only concern is between min_inspections3 and min_inspections2. 
# however, they are the same variable, R is just treating them as different for the sake of their 
# different levels. we can say that there is not significant multicollinearity with the model. 

#make dummies so that we can look at establishment_type as "numerical" to look at correlation/multicollinearity
dummies <- model.matrix(severity ~ min_inspections + establishment_type - 1, data = dinesafe_data)
lm_model <- lm(severity ~ dummies, data = dinesafe_data)
cor(dummies)


# sufficient sample size
# there are 18,771 observations so the sample size is sufficient enough

# can look at residual deviance to see if model is reasonable
null_model <- vglm(severity ~ 1, family = multinomial(), data = dinesafe_data)
deviance_null <- deviance(null_model)  # Null model deviance
deviance_model <- deviance(dinesafe_model)  # Your model deviance
difference <- deviance_null - deviance_model
difference

df_difference <- 2
# Calculate p-value using chi-squared distribution
p_value <- 1 - pchisq(difference, df = df_difference)
p_value

# p value is 0, meaning that the model is better than the null model with 
# a very small chance that the observed improvement in deviance is due to random chance


#### Save Model ####
saveRDS(
  dinesafe_model,
  file = "models/dinesafe_model.rds"
)

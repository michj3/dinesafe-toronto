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
# of min_inspections to log odds
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

# can look at residual deviance to see if model is reinstasonable
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

#### Model Results ####
# forest plot

library(broom)
library(ggplot2)

estimated_coefficients <- coef(dinesafe_model)
std_errors <- sqrt(diag(vcov(dinesafe_model)))

results <- data.frame(
  Estimate = estimated_coefficients,
  Std_Error = std_errors
)

lower_ci <- estimated_coefficients - 1.96 * std_errors
upper_ci <- estimated_coefficients + 1.96 * std_errors

plot_data <- data.frame(
  Variable = names(estimated_coefficients),
  Estimate = estimated_coefficients,
  Lower_CI = lower_ci,
  Upper_CI = upper_ci
)

ggplot(plot_data, aes(x = Estimate, y = Variable)) +
  geom_point() +
  geom_errorbarh(aes(xmin = Lower_CI, xmax = Upper_CI), height = 0.2) +
  labs(x = "Coefficient Estimate", y = "") +
  ggtitle("Forest Plot of Coefficient Estimates") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") + 
  theme_minimal()

# bar plot min inspections
severity_count <- dinesafe_data |>
  group_by(min_inspections, severity) |>
  summarise(count = n(), .groups = "drop")

ggplot(severity_count, aes(x = min_inspections, y = count, fill = severity)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(x = "Minimum Inspections per Year", y = "Count of Violations", 
       title = "Distribution of DineSafe Violation Severity by Minimum Inspections") +
  scale_fill_manual(values = c("C - Crucial" = "slateblue", "S - Significant" = "red3", "M - Minor" = "seagreen")) +
  theme_minimal()

# bar plot food establishment
prediction_data <- data.frame(establishment_type = unique(dinesafe_data$establishment_type),
                              min_inspections = mean(as.numeric(as.character(dinesafe_data$min_inspections)), 
                                                     na.rm = TRUE))
predicted_probs <- predict(dinesafe_model, newdata = prediction_data, type = "response")
prediction_data$Crucial <- predicted_probs[, 1]  # First column is "Crucial"
prediction_data$Significant <- predicted_probs[, 2]  # Second column is "Significant"
prediction_data$Minor <- predicted_probs[, 3]  # Third column is "Minor"
library(tidyr)
tidy_prediction_data <- prediction_data |>
  pivot_longer(cols = c("Crucial", "Significant", "Minor"),
               names_to = "Severity",
               values_to = "Probability")

ggplot(tidy_prediction_data, aes(x = establishment_type, y = Probability, fill = Severity)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Predicted Probabilities by Establishment Type",
       x = "Establishment Type",
       y = "Probability",
       fill = "Severity Level") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


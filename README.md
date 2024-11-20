# Understanding DineSafe Toronto 

## Overview

This repository provides the scripts, data, and paper used to model and understand Toronto's food sanitation and health program, DineSafe. DineSafe data, consisting of inspections from June 2022 to June 2024 was collected from OpenDataToronto and a multinomial logisitc regression model was built to understand the relationship between the severity of an inspection violation with other factors. From the model, minimum number of inspections per year and type of food establishment were concluded to both affect the severity of violation.

## File Structure

The repo is structured as:

-   `data` contains the raw data, analysis (cleaned), and simulated data. Data was initially obtained from OpenDataToronto. Simulated and analysis data can be found both in '.csv' and '.parquet' form. 
-   `model` contains the multinomial logistic regression model used in analysis, stored in RDS format.
-   `other` contains  details about LLM chat interactions, sketches, and plots produced. 
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to downlaod, clean simulate, and model the data. 


## Statement on LLM usage

Aspects of the code and understanding the model were written with the help of ChatGPT-4.  Tthe entire chat history is available in `other/llm_usage`

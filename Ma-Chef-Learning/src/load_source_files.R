# Used for reading and writing JSON
library(jsonlite)
# Used for plotting
library(ggplot2)
# Used for nlp processing 
library(tm)
# Used for count function
library(plyr)
# Used for decision tree
#library(rpart)
# Used for decision tree plotting
library(randomForest)

# Currently unused
#library(dplyr)
#library(caret)

setwd("C:/Users/PAUL/Documents/ECS_171/Ma-Chef-Learning/")

load_source_files <- function() {
  source("src/plot_cuisine_histogram.R")
  source("src/get_ingredient_freq_by_cuisine.R")
  source("src/create_bag_of_words.R")
  source("src/preprocess_data.R")
  source("src/write_data_to_csv.R")
  source("src/build_decision_tree.R")
  source("src/remove_common_terms.R")
  source("src/add_missing_columns.R")
  source("src/predict_and_get_results.R")
}

load_source_files()

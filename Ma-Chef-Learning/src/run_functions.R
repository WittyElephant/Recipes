## Read in JSON data from file using jsonlite library

memory.limit(size=4095)
train_json <- "data/train.json"
test_json <- "data/test.json"
training_data <- fromJSON(train_json, flatten = TRUE)
testing_data <- fromJSON(test_json, flatten = TRUE)

# Preprocess training data
training_results <- preprocess_data(training_data)
training_data <- training_results$data
ingredients_corpus <- training_results$ingredients_corpus

# Preprocess testing data
testing_results <- preprocess_data(testing_data)
testing_data <- testing_results$data
testing_corpus <- testing_results$ingredients_corpus

# Uncomment if you want to distribution of cuisine data
#plot_cuisine_histogram(training_data)

# Uncomment this if you want to write processed data sets to a JSON/CSV files
#write(toJSON(training_data, pretty = 2), 
#      file = "data/processed_train.json")
#write(toJSON(testing_data, pretty = 2), 
#      file = "data/processed_test.json")
#write_data_to_csv(training_data)

# Uncomment this if you want to get JSON file of ingredient frequency by cuisine
#ingredient_count_by_cuisine <- get_ingredient_freq_by_cuisine(training_data)
#write(toJSON(ingredient_count_by_cuisine, pretty = 2), 
#      file = "data/ingredient_frequency_by_cuisine.json")

# Create DocumentTermMatrixs for training and testing data
ingredients_bag_of_words <- create_bag_of_words(ingredients_corpus)
ingredients_bag_of_words$cuisine <- as.factor(training_data$cuisine)

testing_bag <- create_bag_of_words(testing_corpus)
testing_bag <- add_missing_columns(ingredients_bag_of_words, testing_bag)

# DO NOT UNCOMMENT
# Tried to do feature selection. Didn't work. Keeping code for reference
#control = trainControl(method="repeatedcv", number=10, repeats=3)
#decision_tree = train(cuisine~., data = ingredients_bag_of_words, method = "rpart", 
#                      trControl = control, tuneLength = 30)
#results <- cbind(testing_data$id, colnames(cart_predict)[apply(cart_predict,1,which.max)]))

# Used training data to construct a decision tree
decision_tree <- build_decision_tree(ingredients_bag_of_words)

# Use testing data on decision tree to predict results
results <- predict_and_get_results(decision_tree, testing_bag, testing_data$id)

# Generate file name with data & time and write submission data to csv
sub_name <- paste(c("data/submission_", 
                    format(Sys.time(), "%Y-%m-%d_%H-%M-%S"), 
                    ".csv"), 
                  collapse = "")
write.table(results, file = sub_name, quote = FALSE, sep = ",", row.names = FALSE)


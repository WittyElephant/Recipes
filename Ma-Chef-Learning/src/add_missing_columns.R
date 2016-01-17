# Decision tree is NOT able to predict on data that is missing any of the 
# columns used in training data, so we need to add those missing columns
# to the testing data and just make them zero vectors
add_missing_columns <- function(training, testing) {
  missing_columns <- setdiff(colnames(training),colnames(testing))
  testing[, c(as.character(missing_columns))] <- rep(0, length(testing$avocado))
  
  return(testing)
}
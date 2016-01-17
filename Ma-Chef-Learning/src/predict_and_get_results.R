# Using the trained decision tree, predict cuisine from the testing data
# and turn it into the proper dataframe format for submission
predict_and_get_results <- function(decision_tree, testing, ids) {
  
  cart_predict <- predict(decision_tree, newdata = testing, type = "response")
  
  results <- cbind(ids, as.character(cart_predict))
  colnames(results) <- c("id","cuisine")
  
  return(results)
}
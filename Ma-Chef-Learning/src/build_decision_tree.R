# Builds the decision tree using rpart library
build_decision_tree <- function(data) {
  # The first argument of the randomForest function is a formula.
  # The formula's syntax is outcome ~ predictor1 + predictor2 + etc. 
  # To specify all variables not already mentioned in formula as predictors use the . identifier
  decision_tree <- randomForest(cuisine ~ ., data = data, ntree=50)

  # Uncomment this if you want to generate error plot
  #png(filename="../plots/error_plot.png")
  #plot(decision_tree, main="Classification Error for Each Cuisine", col=rainbow(21))
  #legend("topright", title="Cuisines", colnames(decision_tree$err.rate), fill=rainbow(21), bg="transparent")
  #dev.off()
  
  return(decision_tree)
}

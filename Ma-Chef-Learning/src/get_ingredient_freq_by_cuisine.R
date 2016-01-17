# Generate JSON file of ingredient frequency by cuisine
get_ingredient_freq_by_cuisine <- function(data) {
  length_of_ingredients <- sapply(data$ingredients, length)
  
  ingredients <- data.frame(rep(data$cuisine, length_of_ingredients),
                            values = unlist(data$ingredients))
  
  colnames(ingredients) <- c("cuisine", "ingredient")
  
  ingredient_count_by_cuisine <- count(ingredients, 
                                       vars = c("cuisine", "ingredient"))
  
  ingredient_count_by_cuisine <- ingredient_count_by_cuisine[
    with(ingredient_count_by_cuisine, order(cuisine, -freq)),]
  
  return(ingredient_count_by_cuisine)
}
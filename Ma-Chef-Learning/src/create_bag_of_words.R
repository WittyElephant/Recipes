# Convert ingredients to bag of words. Returns a document term matrix (aka bag of words)
create_bag_of_words <- function(ingredients_corpus) {
  ingredients_bag_of_words <- DocumentTermMatrix(ingredients_corpus)
  
  # Remove terms from matrix that appear in less than 1% of the data. 
  # Any lower and R can't load matrix due to memory constraints. I need more RAM :(
  ingredients_bag_of_words <- removeSparseTerms(ingredients_bag_of_words, 0.99)
  
  # Removes terms from matrix that appear in more than 10% of the data 
  #ingredients_bag_of_words <- removeCommonTerms(ingredients_bag_of_words, 0.1)
  
  ingredients_bag_of_words <- as.data.frame(as.matrix(ingredients_bag_of_words))
  
  return(ingredients_bag_of_words)
}

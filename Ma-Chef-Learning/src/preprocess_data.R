# Convert ingredient words into stem words. Returns list of data and ingredients_corpus
preprocess_data <- function(data) {
  ingredients_corpus <- Corpus(VectorSource(data$ingredients))
  
  # Custom transformation to replace passed pattern with underscores
  space_to_underscore <- content_transformer(function(x, pattern)
    gsub(pattern,"_",x))
  
  # Removes stub words from ingrediets (ex: and)
  ingredients_corpus <- tm_map(ingredients_corpus, removeWords, stopwords("english"))
  
  # Converts words to their stem variants (ex: seasoning -> season)
  ingredients_corpus <- tm_map(ingredients_corpus, stemDocument)
  
  # Converst all words to lower case
  ingredients_corpus <- tm_map(ingredients_corpus, content_transformer(tolower))
  
  # Removes all punctuation
  ingredients_corpus <- tm_map(ingredients_corpus, removePunctuation)
  
  # Replaces all spaces with underscores
  ingredients_corpus <- tm_map(ingredients_corpus, space_to_underscore, " ")
  
  # Replace ingredient data with processed data
  ingredients <- sapply(ingredients_corpus, `[`, "content")
  data$ingredients <- ingredients
  
  return(list("data" = data, "ingredients_corpus" = ingredients_corpus))
}

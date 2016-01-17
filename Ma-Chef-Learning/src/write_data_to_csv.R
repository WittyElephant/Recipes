## Write data to CSV file
write_data_to_csv <- function(data) {
  cat("Cuisine, Ingredients", file="data/training.csv", sep="\n")
  sapply(1:nrow(data), function(index) {
    cat(paste(c(data$cuisine[index], 
                paste(data$ingredients[[index]], 
                      collapse = ", ")
                ), 
              collapse = ", "), 
        file="data/training.csv", 
        append=TRUE, 
        sep="\n")
  })
}
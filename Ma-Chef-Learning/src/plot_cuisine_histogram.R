# Generate histogram of all 20 cuisines' frequencies using ggplot2 library
plot_cuisine_histogram <- function(data) {
  cuisine_hist <- ggplot(data.frame(data), aes(x=cuisine))
  cuisine_hist + geom_histogram() + labs(x="Cuisine Type",
                                         y="Number of Recipies",
                                         title="Frequency of Cuisines in Data")
}
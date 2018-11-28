library(SentimentAnalysis)

data <- readRDS("./pulling_data/merged_data.rds")

sentiment <- analyzeSentiment(data$recommendation)

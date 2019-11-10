library(readr)
library(readxl)

previous_data <- read_csv("../1_data_oct_26_new_program_classification/data_oct_26.csv")

previous_data <- previous_data[, !(names(previous_data) %in% c("Mentions_new", "Recommendations_new", "Mentions_old", "Recommendations_old"))]

new_mentions <- read_excel("./mentions_recos_v2_11_10_2019.xlsx", sheet = 1)
new_recommendations <- read_excel("./mentions_recos_v2_11_10_2019.xlsx", sheet = 2)

new_data <- merge(previous_data, new_mentions, by = c("Country", "Year", "Topic"), all = TRUE)
new_data <- merge(new_data, new_recommendations, by = c("Country", "Year", "Topic"), all = TRUE)

write_csv(new_data, "data_nov_10.csv")

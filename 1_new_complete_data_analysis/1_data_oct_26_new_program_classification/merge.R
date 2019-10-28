library(readr)
library(readxl)

previous_data <- read_csv("../1_data_sept_20_merged_with_new_recs/data_with_new_mentions_recs.csv")

new_program_classification <- read_excel("./LHS_WB_and_IMF_DGDP_Program Countries.xlsx")
just_new_vars <- new_program_classification[, c("Country.x",  "Year", "Topic", "Precautionary", "Program or not","Concessional", "Nonconcessional", "Combined")]
names(just_new_vars)[1] <- "Country"
names(just_new_vars)[5] <- "program_or_not"


all_data <- merge(previous_data, just_new_vars, by = c("Country", "Year", "Topic"), all = TRUE)

all_data$Precautionary[is.na(all_data$Precautionary)] <- 0
all_data$program_or_not[is.na(all_data$program_or_not)] <- 0
all_data$Concessional[is.na(all_data$Concessional)] <- 0
all_data$Nonconcessional[is.na(all_data$Nonconcessional)] <- 0
all_data$Combined[is.na(all_data$Combined)] <- 0

write_csv(all_data, "data_oct_26.csv")

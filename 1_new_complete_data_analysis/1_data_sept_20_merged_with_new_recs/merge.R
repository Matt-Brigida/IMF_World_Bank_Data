library(readr)

## data from w
old_full_data <- read_csv("../data_from_w_sept_20/data_with_inf_and_unemp.csv")

names(old_full_data)[3] <- "Country"

new_mentions_recs <- read_csv("../new_mentions_recs.csv")

names(new_mentions_recs)[4] <- "Mentions_new"       
names(new_mentions_recs)[5] <- "Recommendations_new"

### Merge LHS with WB data------

all_data <- merge(old_full_data, new_mentions_recs, by = c("Country", "Year", "Topic"), all = TRUE)

dim(old_full_data)[1]
dim(new_mentions_recs)[1]
dim(all_data)[1]

names(all_data)[5] <- "Mentions_old"
names(all_data)[6] <- "Recommendations_old"

write_csv(all_data, "data_with_new_mentions_recs.csv")


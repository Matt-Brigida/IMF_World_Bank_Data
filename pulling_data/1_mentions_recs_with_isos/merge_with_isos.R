
library(readr)

mentions <- read_csv("./raw_exp.txt")
names(mentions)[1] <- "Country"
mentions$Topic <- gsub(",", "", mentions$Topic)
dim(mentions)
## [1] 11928     4

recs <- read_csv("./rec_exp.txt")
recs$Topic <- gsub(",", "", recs$Topic)
dim(recs)
## [1] 9126    4

lhs_data <- merge(mentions, recs, by = c("Country", "Year", "Topic"), all = TRUE)
dim(lhs_data)
## [1] 12212     5


isos <- read_csv("./unique_country_iso.csv")
isos$Country <- toupper(isos$Country)


data <- merge(lhs_data, isos, by = c("Country"), all.x=TRUE)

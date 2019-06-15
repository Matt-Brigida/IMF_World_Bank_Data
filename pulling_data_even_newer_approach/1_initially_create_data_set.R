library(tidyverse)

### Mentions

mentions <- read.csv("./raw_exp.txt", stringsAsFactors=FALSE, header=TRUE, strip.white = TRUE)
mentions$Topic <- gsub(",", "", mentions$Topic)
names(mentions)[1]  <- "Country"

## calculate % mentions for each topic by country/year group------

mentions <- mentions %>%
    group_by(Country, Year) %>%
    mutate(scaled_mentions = Mentions / sum(Mentions))

## make sure each row is unique----

mentionsIndex <- paste0(mentions$Country, "_", mentions$Year)
mentionsIndex <- gsub(" ", "", mentionsIndex)

mentions <- cbind(mentionsIndex, data.frame(mentions))

# mentions$Country <- gsub(" ", "", mentions$Country)

saveRDS(mentions, "mentions.rds")

### Recommendations

recs <- read.csv("./rec_exp.txt", stringsAsFactors=FALSE, header=TRUE, strip.white = TRUE)
recs$Topic <- gsub(",", "", recs$Topic)
names(recs)[1]  <- "Country"

## calculate % recommendations for each topic by country/year group------

recs <- recs %>%
    group_by(Country, Year) %>%
    mutate(scaled_recommendations = Recommendations / sum(Recommendations))

## make sure each row is unique----

recsIndex <- paste0(recs$Country, "_", recs$Year)
recsIndex <- gsub(" ", "", recsIndex)

recs <- cbind(recsIndex, data.frame(recs))

# recs$Country <- gsub(" ", "", recs$Country)

saveRDS(recs, "recommendations.rds")

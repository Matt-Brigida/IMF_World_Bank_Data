### pull in data-----

library(readr)

WBdata <- read_csv("./WB_data.csv")
names(WBdata)[1] <- "Country"
names(WBdata)[2] <- "Year"
WBdata$Country <- toupper(WBdata$Country)

### extract only current account % of GDP------

CAdata <- WBdata[, c("Country", "Year", "iso2c","BN.CAB.XOKA.GD.ZS")]
dim(CAdata)
## [1] 15576     4

### extract only years for which we have LHS data------

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

### Merge LHS with CA data------

all_data <- merge(lhs_data, CAdata, by = c("Country", "Year"), all.x = TRUE)

write_csv(all_data, "lhs_CA_data.csv")

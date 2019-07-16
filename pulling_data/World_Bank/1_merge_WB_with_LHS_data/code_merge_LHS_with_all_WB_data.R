### pull in data-----

library(readr)

WBdata <- read_csv("./WB_data.csv")
names(WBdata)[1] <- "Country"
names(WBdata)[2] <- "Year"
WBdata$Country <- toupper(WBdata$Country)

### change namibia's iso2c from NA to string NAM
WBdata[WBdata$Country == "NAMIBIA",]$iso2c <- "NAM"

### extract only years for which we have LHS data------

LHS <- read_csv("../1_mentions_recs_with_isos/LHS_with_iso.csv")
dim(LHS)

### Merge LHS with WB data------

all_data <- merge(LHS, WBdata, by = c("iso2c", "Year"), all.x = TRUE)

write_csv(all_data, "LHS_and_WB_data.csv")

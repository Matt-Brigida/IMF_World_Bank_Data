library(readr)
library(readxl)
library(WDI)

previous_data <- read_csv("../1_data_dec_13_new_mentions_recos/data_dec_13.csv")

## merge in NY.GDP.PCAP.PP.CD (gdp per capita, PPP, current $)

gdppp <- WDI(country = "all", indicator = "NY.GDP.PCAP.PP.CD", start = 1900, end = 2019)

names(gdppp)[2] <- "Country"
names(gdppp)[4] <- "Year"

## replace "NA" for namibia with "NAM"

gdppp$iso2c <- gsub("NA", "NAM", gdppp$iso2c)

## merge

### Merge LHS with WB data------

all_data <- merge(previous_data, gdppp, by = c("iso2c", "Year"), all.x = TRUE)

dim(previous_data)
dim(all_data)

all_data <- all_data[, !(names(all_data) %in% "Country.y")]
names(all_data)[3] <- "Country"

dim(previous_data)
dim(all_data)

write_csv(all_data, "data_dec_13_with_gdp_per_capita.csv")

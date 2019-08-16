library(readr)
library(WDI)

## data from w
data <- read_csv("../analysis_data.csv")

inf <- WDI(country = "all", indicator = "FP.CPI.TOTL.ZG", start = 1900, end = 2019)

unemp <- WDI(country = "all", indicator = "SL.UEM.TOTL.ZS", start = 1900, end = 2019)

WBdata <- merge(inf, unemp, by = c("country", "year", "iso2c"), all = TRUE)

names(WBdata)[1] <- "Country"
names(WBdata)[2] <- "Year"
WBdata$Country <- toupper(WBdata$Country)

### change namibia's iso2c from NA to string NAM
WBdata[WBdata$Country == "NAMIBIA", ]$iso2c <- "NAM"

### Merge LHS with WB data------

all_data <- merge(data, WBdata, by = c("iso2c", "Year"), all.x = TRUE)

## Drop country and country.y columns
all_data <- all_data[, !(names(all_data) %in% c("Country", "Country.y"))]

write_csv(all_data, "updated_analysis_data.csv")

### merge measure from w on 8/15------

library(readr)
library(WDI)

## data from w
data <- read_csv("./updated_analysis_data.csv")

## new WB data
poverty <- WDI(country = "all", indicator = "SI.POV.NAHC", start = 1900, end = 2019)

edu_gdp <- WDI(country = "all", indicator = "SE.XPD.TOTL.GD.ZS", start = 1900, end = 2019)

edu_edu <- WDI(country = "all", indicator = "SE.XPD.TOTL.GB.ZS", start = 1900, end = 2019)

literacy <- WDI(country = "all", indicator = "SE.ADT.LITR.ZS", start = 1900, end = 2019)

legal <- WDI(country = "all", indicator = "IC.LGL.CRED.XQ", start = 1900, end = 2019)

pub_mgmt <- WDI(country = "all", indicator = "IQ.CPA.PUBS.XQ", start = 1900, end = 2019)

private_credit <- WDI(country = "all", indicator = "FS.AST.PRVT.GD.ZS", start = 1900, end = 2019)

social_welfare <- WDI(country = "all", indicator = "IQ.CPA.SOCI.XQ", start = 1900, end = 2019)


WBdata <- merge(poverty, edu_gdp, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(edu_edu, WBdata, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(literacy, WBdata, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(legal, WBdata, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(pub_mgmt, WBdata, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(private_credit, WBdata, by = c("country", "year", "iso2c"), all = TRUE)
WBdata <- merge(social_welfare, WBdata, by = c("country", "year", "iso2c"), all = TRUE)

names(WBdata)[1] <- "Country"
names(WBdata)[2] <- "Year"
WBdata$Country <- toupper(WBdata$Country)

### change namibia's iso2c from NA to string NAM
WBdata[WBdata$Country == "NAMIBIA", ]$iso2c <- "NAM"

### Merge LHS with WB data------

all_data <- merge(data, WBdata, by = c("iso2c", "Year"), all.x = TRUE)

## Drop country and country.y columns
all_data <- all_data[, !(names(all_data) %in% c("Country", "Country.y"))]

write_csv(all_data, "updated_analysis_data_with_8_15.csv")

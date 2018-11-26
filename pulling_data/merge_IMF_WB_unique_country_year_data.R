
### merge IMF and WB data-------

imf <- readRDS("./IMF/IMFdata.rds")
wb <- readRDS("./World_Bank/WB_data.rds")

## get list of countries/years with recommendations

recs <- readRDS("./unique_country_year.rds")

## merge-----

data_all <- merge(imf, wb, by = c("year", "iso2c"), all = TRUE)
## data_narrow <- merge(imf, wb, by = c("year", "iso2c"), all = FALSE)

data_all$country <- toupper(data_all$country)

recs_data <- merge(data_all, recs, by = c("year", "country"), all = FALSE)

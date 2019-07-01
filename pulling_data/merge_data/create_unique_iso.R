### create unique csv of country/iso pairs-------
library(readr)

d <- readRDS("./country_iso.rds")
d <- unique(d)

write_csv(d, "unique_country_iso.csv")

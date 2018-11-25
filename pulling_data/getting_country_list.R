### get list of countries for analysis----
## The idea is to see what data is available from the IMF or WB for all of these countries

## import IMF recommentations
recs <- read.table("./IMFRecommendations_fixed_line.txt", header = TRUE, sep = "|", stringsAsFactors = FALSE)

country_year <- unique(recs[c("country", "year")])

saveRDS(country_year, "unique_country_year.rds")

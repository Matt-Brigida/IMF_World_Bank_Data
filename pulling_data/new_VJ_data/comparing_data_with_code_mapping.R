## read in old VJ data--------

codes <- readRDS("./country_iso.rds")
names(codes)[2] <- c("Country")
codes$Country <- toupper(codes$Country)
codes <- unique(codes)

## read in new VJ data--------

new_data <- read.csv("./new_VJ_data.csv", header=TRUE, stringsAsFactors=FALSE, strip.white=TRUE)


## dont merge with year, just nees iso for each country------

new_data_with_iso <- merge(new_data, codes, by = c("Country"), all.x = TRUE)
names(new_data_with_iso)[c(1, 2)] <- c("country", "year")

saveRDS(new_data_with_iso, "new_VJ_data_merged_with_iso_codes.rds")

## read in old VJ data--------

codes <- readRDS("./country_iso.rds")
names(codes)[2] <- c("Country")
codes$Country <- toupper(codes$Country)
codes <- unique(codes)

## read in new VJ data--------

new_data <- read.csv("./raw_exp.txt", header=TRUE, stringsAsFactors=FALSE, strip.white=TRUE)

## need to remove trailing whitespace from country

names(new_data)[1] <- "Country"

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

new_data$Country <- trim(new_data$Country)

## dont merge with year, just nees iso for each country------

new_data_with_iso <- merge(new_data, codes, by = c("Country"), all.x = TRUE)
names(new_data_with_iso)[c(1, 2)] <- c("country", "year")

saveRDS(new_data_with_iso, "mentions_merged_with_iso_codes.rds")

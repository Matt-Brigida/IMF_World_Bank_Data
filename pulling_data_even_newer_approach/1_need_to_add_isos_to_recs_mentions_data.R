## read in old VJ data--------

codes <- readRDS("./country_iso.rds")
names(codes)[2] <- c("Country")
codes$Country <- toupper(codes$Country)
codes <- unique(codes)

## read in new VJ data--------

# think we should merge with the mentions file createed in (1), now th raw file--------
# new_data <- read.csv("./raw_exp.txt", header=TRUE, stringsAsFactors=FALSE, strip.white=TRUE)

new_data <- readRDS("./mentions.rds")

## need to remove trailing whitespace from country

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

new_data$Country <- trim(new_data$Country)

## dont merge with year, just need iso for each country------

new_data_with_iso <- merge(new_data, codes, by = c("Country"), all.x = TRUE)

### after merge the following countries do not have an iso
unique(new_data_with_iso[!complete.cases(new_data_with_iso),]$Country)
##  [1] "BAHAMAS"              "CONGO"                "EGYPT"               
##  [4] "GAMBIA"               "HONG KONG"            "IRAN"                
##  [7] "KOREA"                "MACEDONIA"            "MICRONESIA"          
## [10] "REPUBLIC OF NAURU"    "REPUBLIC OF SLOVENIA" "SWAZILAND"           
## [13] "TIMOR"                "YEMEN"

## these countries do not have the same name between the country_iso.rds and VJ data files.

## can we merge WB and IMF data without the iso??

names(new_data_with_iso)[c(1, 2)] <- c("country", "year")

saveRDS(new_data_with_iso, "mentions_merged_with_iso_codes.rds")

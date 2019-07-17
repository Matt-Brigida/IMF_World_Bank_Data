library(readr)
library(readxl)
library(tidyr)

dgdp_imf <- read_excel("../IMF/imf-dm-export-20190717.xls", na='no data')

dgdp <- gather(dgdp_imf, "year", "dgdp", -country)
dgdp$country <- toupper(dgdp$country)
names(dgdp)[1] <- "Country.x"
names(dgdp)[2] <- "Year"

lhs_wb <- read_csv("../World_Bank/1_merge_WB_with_LHS_data/LHS_and_WB_data.csv")

all <- merge(lhs_wb, dgdp, by = c("Country.x", "Year"), all.x = TRUE)

write_csv(all, "LHS_WB_and_IMF_DGDP.csv")

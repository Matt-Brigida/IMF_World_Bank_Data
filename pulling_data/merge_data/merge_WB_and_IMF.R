#### read in data--------

library(readr)
IMFdata <- read_csv("pulling_data/IMF/IMFdata.csv")
WBdata <- read_csv("pulling_data/World_Bank/WB_data.csv")
View(IMFdata)
View(WBdata)

merged <- merge(IMFdata, WBdata, by = c("iso2c", "year"))
View(merged)

write_csv(merged, "pulling_data/IMF_WB_merged.csv")

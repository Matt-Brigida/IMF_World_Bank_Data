library(readr)
library(readxl)

previous_data <- read_csv("../1_data_dec_13_new_mentions_recos/data_dec_13.csv")

## merge in NY.GDP.PCAP.PP.CD (gdp per capita, PPP, current $)

write_csv(new_data, "data_dec_13_with_gdp_per_capita.csv")

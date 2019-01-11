#### read in data from VJ

fromVJ <- read.csv("./new_VJ_data.csv", header=TRUE, stringsAsFactors=FALSE, strip.white=TRUE)

toVJ <- readRDS("./new_VJ_data_with_iso.rds")

dim(fromVJ)
dim(toVJ)

## why to VJ has much more data?????

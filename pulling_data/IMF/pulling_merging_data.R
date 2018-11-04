
library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

databaseID <- "IFS"
startdate = "1900-01-01"
enddate = "2016-12-31"
checkquery = FALSE

## country_list <- c("ES", "GR")
country_list <- c("")  # all countries
## cpi, ppi, industrial prod manufacturing, unemployment rate, 
indicators <- c("PCPI_IX", "PPPI_IX", "AIPMA_IX", "LUR_PT", "BFPAD_BP6_USD", "BXG_BP6_USD")
## indicators <- c("")  # cant do all indicators like so
    
queryfilter <- list(CL_FREA = "", CL_AREA_IFS = country_list, CL_INDICATOR_IFS = indicators)

data <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery, tidy = TRUE)

## extract quarterly data for a particular country------
getQ <- function(country_code, data){
    tmp <- data[data$'@REF_AREA' == country_code, ]
    tmp <- tmp[tmp$'@FREQ' == "Q", ]
    tmp <- tmp[ , !(names(tmp) %in% c('@OBS_STATUS', '@FREQ'))]
    return(tmp)
}

## extract annual data for a particular country------
getA <- function(country_code, data){
    tmp <- data[data$'@REF_AREA' == country_code, ]
    tmp <- tmp[tmp$'@FREQ' == "A", ]
    tmp <- tmp[ , !(names(tmp) %in% c('@OBS_STATUS', '@FREQ'))]
    return(tmp)
}


library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

databaseID <- "IFS"
startdate = "1900-01-01"
enddate = "2016-12-31"
checkquery = FALSE

## country_list <- c("ES", "GR")
country_list <- c("")  # all countries

### Indicators List
## search for indicators here: http://data.imf.org/?sk=4C514D48-B6BA-49ED-8AB9-52B0C1A0179B&sId=1409151240976
## cpi, ppi, industrial prod manufacturing, unemployment rate, 
indicators <- c("PCPI_IX", "PPPI_IX", "AIPMA_IX", "LUR_PT")
## indicators <- c("")  # cant do all indicators like so
    

queryfilter <- list(CL_FREA = "", CL_AREA_IFS = country_list, CL_INDICATOR_IFS = indicators)

data <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery, tidy = TRUE)



## merging data------

## get only annual data
data  <- data[data$'@TIME_FORMAT' == "P1Y", ]

PCPI_IX <- data[data$'@INDICATOR' == "PCPI_IX", ]
PCPI_IX <- PCPI_IX[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(PCPI_IX) <- c("year", "PCPI_IX", "iso2c")


## merge data for export------
final_data <- merge(PCPI_IX, , by = c("country", "iso2c"), all = TRUE)






### function to extract quarterly or annual data for a given country--------
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

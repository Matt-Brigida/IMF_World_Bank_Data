### load libraries----

library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")
library(WDI)


### Merge IMF Variable

merge_imf <- function(indicator, backup = TRUE){

    ## read in data-----
    olddata <- readRDS("./merged_data.rds")
    
    ## check if indicator is already in data set----
    if (indicator %in% names(olddata)){
        return("indicator already in data set")
    }

    ## pull imf indicator----

    databaseID <- "IFS"
    startdate = "1900-01-01"
    enddate = "2016-12-31"
    checkquery = FALSE
    country_list <- c("")  # all countries

    queryfilter <- list(CL_FREA = "", CL_AREA_IFS = country_list, CL_INDICATOR_IFS = indicator)

    ind_data <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery, tidy = TRUE)

    ## check if indicator pulled any data----
    if (is.null(ind_data)){
        return("indicator has no data.")
    }

    ## format data for merge-----
    ind_data  <- ind_data[ind_data$'@TIME_FORMAT' == "P1Y", ]

    ind_data <- ind_data[ind_data$'@INDICATOR' == indicator, ]
    ind_data <- ind_data[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
    names(ind_data) <- c("year", indicator, "iso2c")

    ## merge imf indicator----

    new_data <- merge(ind_data, olddata, by = c("year", "iso2c"), all.y = TRUE)

    ## save new data set------

    saveRDS(new_data, "merged_data.rds")

    ## save old data as backup-----

    if(backup == TRUE){
        saveRDS(olddata, file = paste0("merged_data_backup_before_", indicator, ".rds"))
        }
    
}



### Merge WB Variable

merge_wb <- function(indicator, backup = TRUE){

    ## read in data-----
    olddata <- readRDS("./merged_data.rds")
    
    ## check if indicator is already in data set----
    if (indicator %in% names(olddata)){
        return("indicator already in data set")
    }

    ## pull wb indicator----
    ind_data <- WDI(country = "all", indicator = indicator, start = 1900, end = 2019)

    ## check if indicator pulled any data----
    if (is.null(ind_data)){
        return("indicator has no data.")
    }

    ## merge wb indicator----

    new_data <- merge(ind_data, olddata, by = c("country", "year", "iso2c"), all.y = TRUE)

    ## save new data set------

    saveRDS(new_data, "merged_data.rds")

    ## save old data as backup-----

    if(backup == TRUE){
        saveRDS(olddata, file = paste0("merged_data_backup_before_", indicator, ".rds"))
        }

}

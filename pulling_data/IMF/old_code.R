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

### Code that is used to find codes or is no longer useful------


## get list of indicators-----
WDIcache()
## search list of indicators------
WDIsearch(string = "financing", field = "name", short = TRUE, cache = NULL)
WDIsearch(string = "current", field = "name", short = TRUE, cache = NULL)
WDIsearch(string = "finance", field = "name", short = TRUE, cache = NULL)
WDIsearch(string = "rating", field = "name", short = TRUE, cache = NULL)
WDIsearch(string = "business", field = "name", short = TRUE, cache = NULL)




### test if some indicator has data-----
test <- function(ind){
  return(WDI(country = "all", indicator = ind, start = 1900, end = 2019))
}


### Think unnecessary---used to see % missing data wrt country/year data (but not IMF recs -- i.e. weighted country/year)
cabp$country <- toupper(cabp$country)
cabpM <- merge(cabp, cy, by = c("country", "year"))
sum(is.na(cabpM$BN.CAB.XOKA.GD.ZS)) / dim(cabpM)[1]  ## % number of NAs
## 0.07982262

mil$country <- toupper(mil$country)
milM <- merge(mil, cy, by = c("country", "year"))
sum(is.na(milM$MS.MIL.XPND.CN)) / dim(milM)[1]  ## % number of NAs
## 0.1241685


FDI$country <- toupper(FDI$country)
FDIM <- merge(FDI, cy, by = c("country", "year"))
sum(is.na(FDIM$BN.KLT.DINV.CD)) / dim(FDIM)[1]  ## % number of NAs
## 0.08425721



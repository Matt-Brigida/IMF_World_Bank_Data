library(WDI)

## get list of indicators-----
WDIcache()
## search list of indicators------
WDIsearch(string = "financing", field = "name", short = TRUE, cache = NULL)
WDIsearch(string = "current", field = "name", short = TRUE, cache = NULL)

## Current Account Balance as % of GDP
cabp <- WDI(country = "all", indicator = "BN.CAB.XOKA.GD.ZS", start = 1900, end = 2019)

## Financing via international capital markets (gross inflows, % of GDP)
fvicfp <- WDI(country = "all", indicator = "CM.FIN.INTL.GD.ZS", start = 1900, end = 2019) ## no data

## Domestic financing, total (% of GDP)
dfp <- WDI(country = "all", indicator = "GB.FIN.DOMS.GD.ZS", start = 1900, end = 2019)  ## no data

## Financing from abroad (% of GDP)
ffap <- WDI(country = "all", indicator = "GB.FIN.ABRD.GDP.ZS", start = 1900, end = 2019)  ## no data

## Military Expenditures (US $)
mil <- WDI(country = "all", indicator = "MS.MIL.XPND.CN", start = 1900, end = 2019)  ## no data


### merge data-----

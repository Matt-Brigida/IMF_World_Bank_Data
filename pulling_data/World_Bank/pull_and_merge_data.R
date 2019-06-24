library(WDI)

### Data already pulled------
### Pull data for each indicator------

## Current Account Balance as % of GDP
cabp <- WDI(country = "all", indicator = "BN.CAB.XOKA.GD.ZS", start = 1900, end = 2019)

## Military Expenditures (US $)
mil <- WDI(country = "all", indicator = "MS.MIL.XPND.CN", start = 1900, end = 2019)

## Firms using banks to finance investment (% of firms)" 
fin_inv <- WDI(country = "all", indicator = "IC.FRM.BNKS.ZS", start = 1900, end = 2019)

## "Present value of external debt (current US$)"
pv_ex_debt <- WDI(country = "all", indicator = "DT.DOD.PVLX.CD", start = 1900, end = 2019)

## 
multilateral_debt <- WDI(country = "all", indicator = "DT.DOD.MLAT.ZS", start = 1900, end = 2019)

## PG list

## Foreign direct investment, net (BoP, current US$)(BN.KLT.DINV.CD)
FDI <- WDI(country = "all", indicator = "BN.KLT.DINV.CD", start = 1900, end = 2019)

## Personal remittances, received (% of GDP)(BX.TRF.PWKR.DT.GD.ZS)
PR <- WDI(country = "all", indicator = "BX.TRF.PWKR.DT.GD.ZS", start = 1900, end = 2019)

## Trade in services (% of GDP)(BG.GSR.NFSV.GD.ZS)
TIS <- WDI(country = "all", indicator = "BG.GSR.NFSV.GD.ZS", start = 1900, end = 2019)

## Agriculture, forestry, and fishing, value added (% of GDP)(NV.AGR.TOTL.ZS)
AFF <- WDI(country = "all", indicator = "NV.AGR.TOTL.ZS", start = 1900, end = 2019)

## Exports of goods and services (% of GDP)(NE.EXP.GNFS.ZS)
EGS <- WDI(country = "all", indicator = "NE.EXP.GNFS.ZS", start = 1900, end = 2019)

## GDP growth (annual %)(NY.GDP.MKTP.KD.ZG)
GDPG <- WDI(country = "all", indicator = "NY.GDP.MKTP.KD.ZG", start = 1900, end = 2019)

## GDP per capita (current US$)(NY.GDP.PCAP.CD)
## GDP per capita growth (annual %)(NY.GDP.PCAP.KD.ZG)
GDPPCG <- WDI(country = "all", indicator = "NY.GDP.PCAP.KD.ZG", start = 1900, end = 2019)

## Gross domestic savings (% of GDP)(NY.GDS.TOTL.ZS)
GDS <- WDI(country = "all", indicator = "NY.GDS.TOTL.ZS", start = 1900, end = 2019)

## Imports of goods and services (% of GDP)(NE.IMP.GNFS.ZS)
IGS <- WDI(country = "all", indicator = "NE.IMP.GNFS.ZS", start = 1900, end = 2019)

## Individuals using the Internet (% of population)(IT.NET.USER.ZS)
## Labor force participation rate, total (% of total population ages 15+) (modeled ILO estimate)(SL.TLF.CACT.ZS)
LPR <- WDI(country = "all", indicator = "SL.TLF.CACT.ZS", start = 1900, end = 2019)

## Ease of doing business (IC.BUS.EASE.XQ) | "Ease of doing business index (1=most business-friendly regulations)"
EASE <- WDI(country = "all", indicator = "IC.BUS.EASE.XQ", start = 1900, end = 2019)

 
## Inflation, consumer prices (annual %)(FP.CPI.TOTL.ZG)

## Unemployment, total (% of total labor force) (modeled ILO estimate)(SL.UEM.TOTL.ZS)

### No Data----------

## Financing via international capital markets (gross inflows, % of GDP)
fvicfp <- WDI(country = "all", indicator = "CM.FIN.INTL.GD.ZS", start = 1900, end = 2019) ## no data

## Domestic financing, total (% of GDP)
dfp <- WDI(country = "all", indicator = "GB.FIN.DOMS.GD.ZS", start = 1900, end = 2019)  ## no data

## Financing from abroad (% of GDP)
ffap <- WDI(country = "all", indicator = "GB.FIN.ABRD.GDP.ZS", start = 1900, end = 2019)  ## no data

## Total deficit to be financed (US$, BoP)
financed <- WDI(country = "all", indicator = "BN.CUR.ACTX.CD", start = 1900, end = 2019) ## no data


### merge data-----

data <- merge(cabp, mil, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, fin_inv, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, pv_ex_debt, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, multilateral_debt, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, FDI, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, PR, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, TIS, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, AFF, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, EGS, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, GDPG, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, GDPPCG, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, GDS, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, IGS, by = c("country", "year", "iso2c"), all = TRUE)
data <- merge(data, LPR, by = c("country", "year", "iso2c"), all = TRUE)



## read in old data
data <- readRDS("./WB_data.rds")

data <- merge(data, EASE, by = c("country", "year", "iso2c"), all = TRUE)


## write data------
saveRDS(data, "WB_data.rds")

write.csv(data, "WB_data.csv", row.names=FALSE)

### Add new data


## pull new data

## merge new data

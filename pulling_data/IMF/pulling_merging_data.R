
library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

databaseID <- "IFS"
startdate = "1900-01-01"
enddate = "2016-12-31"
checkquery = FALSE

country_list <- c("")  # all countries

### Indicators List
## search for indicators here: http://data.imf.org/?sk=4C514D48-B6BA-49ED-8AB9-52B0C1A0179B&sId=1409151240976

## GDP | NGDP_R_CH_SA_XDC | National Accounts, Expenditure, Gross Domestic Product, Real, Reference Chained, Seasonally adjusted, Domestic Currency

## Debt | BCG_GALM_G01_XDC | Fiscal, Budgetary Central Government, Assets and Liabilities, Debt (at Market Value), Classification of the stocks of assets and liabilities, 2001 Manual, Domestic Currency
## Debt | CG01_GALM_G01_XDC | Fiscal, Central Government, Assets and Liabilities, Debt (at Market Value), Classification of the stocks of assets and liabilities, 2001 Manual, Domestic Currency

### Inflation | PCPI_PC_CP_A_PT | Prices, Consumer Price Index, All items, Percentage change, Corresponding period previous year, Percent

## This is the current account *in USD*. We need to find GDP also in USD---above it is in domestic currency. 
## BGS_BP6_USD | Balance of Payments, Current Account, Goods and Services, Net, US Dollars

## LUR_PT | Labor Markets, Unemployment Rate, Percent

indicators <- c("NGDP_R_CH_SA_XDC", "BCG_GALM_G01_XDC", "CG01_GALM_G01_XDC", "BGS_BP6_USD", "LUR_PT")

queryfilter <- list(CL_FREA = "", CL_AREA_IFS = country_list, CL_INDICATOR_IFS = indicators)

data <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery, tidy = TRUE)

## merging data------

## get only annual data
data  <- data[data$'@TIME_FORMAT' == "P1Y", ]

NGDP_R_CH_SA_XDC <- data[data$'@INDICATOR' == "NGDP_R_CH_SA_XDC", ]
NGDP_R_CH_SA_XDC <- NGDP_R_CH_SA_XDC[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(NGDP_R_CH_SA_XDC) <- c("year", "NGDP_R_CH_SA_XDC", "iso2c")

BCG_GALM_G01_XDC <- data[data$'@INDICATOR' == "BCG_GALM_G01_XDC", ]
BCG_GALM_G01_XDC <- BCG_GALM_G01_XDC[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(BCG_GALM_G01_XDC) <- c("year", "BCG_GALM_G01_XDC", "iso2c")

CG01_GALM_G01_XDC <- data[data$'@INDICATOR' == "CG01_GALM_G01_XDC", ]
CG01_GALM_G01_XDC <- CG01_GALM_G01_XDC[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(CG01_GALM_G01_XDC) <- c("year", "CG01_GALM_G01_XDC", "iso2c")

BGS_BP6_USD <- data[data$'@INDICATOR' == "BGS_BP6_USD", ]
BGS_BP6_USD <- BGS_BP6_USD[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(BGS_BP6_USD) <- c("year", "BGS_BP6_USD", "iso2c")

LUR_PT <- data[data$'@INDICATOR' == "LUR_PT", ]
LUR_PT <- LUR_PT[, c('@TIME_PERIOD', '@OBS_VALUE', '@REF_AREA')]
names(LUR_PT) <- c("year", "LUR_PT", "iso2c")

## merge data for export------
final_data <- merge(NGDP_R_CH_SA_XDC, BCG_GALM_G01_XDC, by = c("year", "iso2c"), all = TRUE)
final_data <- merge(CG01_GALM_G01_XDC, final_data, by = c("year", "iso2c"), all = TRUE)
final_data <- merge(BGS_BP6_USD, final_data, by = c("year", "iso2c"), all = TRUE)
final_data <- merge(LUR_PT, final_data, by = c("year", "iso2c"), all = TRUE)

saveRDS(final_data, "IMFdata.rds")
write.csv(final_data, "IMFdata.csv", row.names=FALSE)

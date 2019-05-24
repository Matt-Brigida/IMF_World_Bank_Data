

recs <- read.csv("../../rec_exp.txt", stringsAsFactors=FALSE, header=TRUE)
recs$Topic <- gsub(",", "", recs$Topic)
names(recs)[1]  <- "Country"

recsED <- recs[recs$Topic == "External Debt", ]

## make sure each row is unique----

theIndex <- paste0(recsED$Country, "_", recsED$Year)

length(unique(theIndex))
length(theIndex)

recsED <- cbind(theIndex, recsED)
recsED$theIndex <- gsub(" ", "", recsED$theIndex)
rm(theIndex)


## Merge with IMF/WB Data-------

## WB codes----
## Foreign direct investment, net (BoP, current US$)(BN.KLT.DINV.CD)
## Current account balance (% of GDP)(BN.CAB.XOKA.GD.ZS)
## Personal remittances, received (% of GDP)(BX.TRF.PWKR.DT.GD.ZS)
## Trade in services (% of GDP)(BG.GSR.NFSV.GD.ZS)
## Agriculture, forestry, and fishing, value added (% of GDP)(NV.AGR.TOTL.ZS)
## Exports of goods and services (% of GDP)(NE.EXP.GNFS.ZS)
## GDP growth (annual %)(NY.GDP.MKTP.KD.ZG)
## GDP per capita (current US$)(NY.GDP.PCAP.CD)
## GDP per capita growth (annual %)(NY.GDP.PCAP.KD.ZG)
## Gross domestic savings (% of GDP)(NY.GDS.TOTL.ZS)
## Imports of goods and services (% of GDP)(NE.IMP.GNFS.ZS)
## Individuals using the Internet (% of population)(IT.NET.USER.ZS)
## Labor force participation rate, total (% of total population ages 15+) (modeled ILO estimate)(SL.TLF.CACT.ZS)
 
## Inflation, consumer prices (annual %)(FP.CPI.TOTL.ZG)

## Unemployment, total (% of total labor force) (modeled ILO estimate)(SL.UEM.TOTL.ZS)

econ <- read.csv("../../../pulling_data/merged_data.csv", stringsAsFactors=FALSE, header=TRUE)

econ_vars_for_model <- econ[, c("country", "year", "BN.CAB.XOKA.GD.ZS.x", "NY.GDP.PCAP.KD.ZG", "IC.FRM.BNKS.ZS")]

## now need to extract only unique country and year subsets-----

theIndex <- paste0(econ_vars_for_model$country, "_", econ_vars_for_model$year)

econ_vars_for_model <- cbind(theIndex, econ_vars_for_model)

econ_vars_for_model <- subset(econ_vars_for_model, !duplicated(econ_vars_for_model$theIndex))


#### Join data-----

mergedRecsED <- merge(recsED, econ_vars_for_model, by = "theIndex")

mergedRecsED <- mergedRecsED[, c("Country", "Year", "Recommendations", "BN.CAB.XOKA.GD.ZS.x", "NY.GDP.PCAP.KD.ZG")]

mergedRecsED <- mergedRecsED[complete.cases(mergedRecsED), ]

## convert to plm
library(plm)

mergedRecsED_p <- pdata.frame(mergedRecsED, index = c("Country", "Year"), drop.index=TRUE, row.names=TRUE)

FEestimate <- plm(Recommendations ~  BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, data = mergedRecsED_p, model = "between", effect = "individual")

summary(FEestimate)
## Oneway (individual) effect Between Model

## Call:
## plm(formula = Recommendations ~ BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, 
##     data = mergedRecsED_p, effect = "individual", model = "between")

## Unbalanced Panel: n = 118, T = 1-14, N = 501
## Observations used in estimation: 118

## Residuals:
##     Min.  1st Qu.   Median  3rd Qu.     Max. 
## -2.83090 -0.90882 -0.20379  0.63798  8.25765 

## Coefficients:
##                      Estimate Std. Error t-value  Pr(>|t|)    
## (Intercept)          2.644742   0.179095 14.7673 < 2.2e-16 ***
## BN.CAB.XOKA.GD.ZS.x -0.053904   0.013821 -3.9001 0.0001623 ***
## NY.GDP.PCAP.KD.ZG    0.082575   0.047455  1.7401 0.0845234 .  
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Total Sum of Squares:    276.74
## Residual Sum of Squares: 234.02
## R-Squared:      0.15435
## Adj. R-Squared: 0.13964
## F-statistic: 10.4949 on 2 and 115 DF, p-value: 6.5087e-05

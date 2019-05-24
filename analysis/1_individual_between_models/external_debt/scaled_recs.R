

recs <- read.csv("../../rec_exp.txt", stringsAsFactors=FALSE, header=TRUE)
recs$Topic <- gsub(",", "", recs$Topic)
names(recs)[1]  <- "Country"

## calculate % mentions for each topic by country/year group------

library(dplyr)

recs <- recs %>%
    group_by(Country, Year) %>%
    mutate(scaled = Recommendations / sum(Recommendations))


recsED <- recs[recs$Topic == "External Debt", ]

## make sure each row is unique----

theIndex <- paste0(recsED$Country, "_", recsED$Year)

length(unique(theIndex))
length(theIndex)

recsED <- cbind(theIndex, data.frame(recsED))
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
rm(theIndex)

econ_vars_for_model <- subset(econ_vars_for_model, !duplicated(econ_vars_for_model$theIndex))


#### Join data-----

mergedRecsED <- merge(recsED, econ_vars_for_model, by = "theIndex")

mergedRecsED <- mergedRecsED[, c("Country", "Year", "Recommendations", "scaled", "BN.CAB.XOKA.GD.ZS.x", "NY.GDP.PCAP.KD.ZG")]

mergedRecsED <- mergedRecsED[complete.cases(mergedRecsED), ]

## convert to plm
library(plm)

mergedRecsED_p <- pdata.frame(mergedRecsED, index = c("Country", "Year"), drop.index=TRUE, row.names=TRUE)

FEestimate <- plm(scaled ~  BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, data = mergedRecsED_p, model = "between", effect = "individual")

summary(FEestimate)
## Oneway (individual) effect Between Model

## Call:
## plm(formula = scaled ~ BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, 
##     data = mergedRecsED_p, effect = "individual", model = "between")

## Unbalanced Panel: n = 118, T = 1-14, N = 501
## Observations used in estimation: 118

## Residuals:
##       Min.    1st Qu.     Median    3rd Qu.       Max. 
## -0.0881715 -0.0234303 -0.0091043  0.0194669  0.1557293 

## Coefficients:
##                        Estimate  Std. Error t-value  Pr(>|t|)    
## (Intercept)          0.11252394  0.00524324 21.4608 < 2.2e-16 ***
## BN.CAB.XOKA.GD.ZS.x -0.00237493  0.00040463 -5.8693  4.31e-08 ***
## NY.GDP.PCAP.KD.ZG    0.00126530  0.00138931  0.9107    0.3643    
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Total Sum of Squares:    0.26688
## Residual Sum of Squares: 0.20058
## R-Squared:      0.24841
## Adj. R-Squared: 0.23534
## F-statistic: 19.0049 on 2 and 115 DF, p-value: 7.3922e-08

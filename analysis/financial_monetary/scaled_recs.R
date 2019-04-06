

recs <- read.csv("../rec_exp.txt", stringsAsFactors=FALSE, header=TRUE)
recs$Topic <- gsub(",", "", recs$Topic)
names(recs)[1]  <- "Country"

## calculate % mentions for each topic by country/year group------

library(dplyr)

recs <- recs %>%
    group_by(Country, Year) %>%
    mutate(scaled = Recommendations / sum(Recommendations))


recsED <- recs[recs$Topic == "Financial/Monetary", ]

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

econ <- read.csv("../../pulling_data/merged_data.csv", stringsAsFactors=FALSE, header=TRUE)

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

FEestimate <- plm(scaled ~  BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, data = mergedRecsED_p, model = "within", effect = "twoways")

summary(FEestimate)
## Twoways effects Within Model

## Call:
## plm(formula = scaled ~ BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, 
##     data = mergedRecsED_p, effect = "twoways", model = "within")

## Unbalanced Panel: n = 120, T = 1-15, N = 605

## Residuals:
##      Min.   1st Qu.    Median   3rd Qu.      Max. 
## -0.221643 -0.063341 -0.003375  0.058708  0.343598 

## Coefficients:
##                       Estimate Std. Error t-value Pr(>|t|)
## BN.CAB.XOKA.GD.ZS.x 0.00091247 0.00067711  1.3476   0.1784
## NY.GDP.PCAP.KD.ZG   0.00084294 0.00170420  0.4946   0.6211

## Total Sum of Squares:    5.6252
## Residual Sum of Squares: 5.6001
## R-Squared:      0.0044725
## Adj. R-Squared: -0.29312
## F-statistic: 1.04452 on 2 and 465 DF, p-value: 0.35268

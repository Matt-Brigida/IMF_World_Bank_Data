

recs <- read.csv("../../rec_exp.txt", stringsAsFactors=FALSE, header=TRUE)
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

## Unbalanced Panel: n = 120, T = 1-15, N = 605
## Observations used in estimation: 120

## Residuals:
##       Min.    1st Qu.     Median    3rd Qu.       Max. 
## -0.1770221 -0.0397268 -0.0021165  0.0381839  0.1708881 

## Coefficients:
##                       Estimate Std. Error t-value Pr(>|t|)    
## (Intercept)         0.24433078 0.00834804 29.2680   <2e-16 ***
## BN.CAB.XOKA.GD.ZS.x 0.00093218 0.00059651  1.5627   0.1208    
## NY.GDP.PCAP.KD.ZG   0.00221909 0.00230935  0.9609   0.3386    
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Total Sum of Squares:    0.47307
## Residual Sum of Squares: 0.4615
## R-Squared:      0.024465
## Adj. R-Squared: 0.0077889
## F-statistic: 1.46708 on 2 and 117 DF, p-value: 0.23481

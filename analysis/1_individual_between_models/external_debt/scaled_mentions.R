

### pull and format mentions and recommendation data------

mentions <- read.csv("../../raw_exp.txt", stringsAsFactors=FALSE, header=TRUE)
mentions$Topic <- gsub(",", "", mentions$Topic)
names(mentions)[1]  <- "Country"

## calculate % mentions for each topic by country/year group------

library(dplyr)

mentions <- mentions %>%
    group_by(Country, Year) %>%
    mutate(scaled = Mentions / sum(Mentions))

mentionsED <- mentions[mentions$Topic == "External Debt", ]

## make sure each row is unique----

mentionsEDindex <- paste0(mentionsED$Country, "_", mentionsED$Year)
mentionsEDindex <- gsub(" ", "", mentionsEDindex)

length(unique(mentionsEDindex))
## [1] 1493
length(mentionsEDindex)
## [1] 1493

mentionsED <- cbind(mentionsEDindex, data.frame(mentionsED))

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

econ_vars_for_model <- econ[, c("country", "year", "BN.CAB.XOKA.GD.ZS.x", "NY.GDP.PCAP.KD.ZG")]

## now need to extract only unique country and year subsets-----

econVarsIndex <- paste0(econ_vars_for_model$country, "_", econ_vars_for_model$year)

econ_vars_for_model <- cbind(econVarsIndex, econ_vars_for_model)

econ_vars_for_model <- subset(econ_vars_for_model, !duplicated(econ_vars_for_model$econVarsIndex))


#### Join data-----

mergedMentionsED <- merge(mentionsED, econ_vars_for_model, by.x = "mentionsEDindex", by.y = "econVarsIndex")

mergedMentionsED <- mergedMentionsED[, c("Country", "Year", "Mentions", "scaled", "BN.CAB.XOKA.GD.ZS.x", "NY.GDP.PCAP.KD.ZG")]

mergedMentionsED <- mergedMentionsED[complete.cases(mergedMentionsED), ]

## convert to plm
library(plm)

mergedMentionsED_p <- pdata.frame(mergedMentionsED, index = c("Country", "Year"), drop.index=TRUE, row.names=TRUE)

FEestimate <- plm(scaled ~  BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, data = mergedMentionsED_p, model = "between", effect = "individual")

summary(FEestimate)
## Oneway (individual) effect Between Model

## Call:
## plm(formula = scaled ~ BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, 
##     data = mergedMentionsED_p, effect = "individual", model = "between")

## Unbalanced Panel: n = 120, T = 1-15, N = 593
## Observations used in estimation: 120

## Residuals:
##        Min.     1st Qu.      Median     3rd Qu.        Max. 
## -0.06595919 -0.02701776 -0.00067466  0.02183160  0.13715802 

## Coefficients:
##                        Estimate  Std. Error t-value  Pr(>|t|)    
## (Intercept)          0.14296383  0.00523707 27.2984 < 2.2e-16 ***
## BN.CAB.XOKA.GD.ZS.x -0.00269278  0.00036133 -7.4525 1.724e-11 ***
## NY.GDP.PCAP.KD.ZG    0.00105119  0.00143370  0.7332    0.4649    
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Total Sum of Squares:    0.26939
## Residual Sum of Squares: 0.17852
## R-Squared:      0.3373
## Adj. R-Squared: 0.32598
## F-statistic: 29.7757 on 2 and 117 DF, p-value: 3.523e-11


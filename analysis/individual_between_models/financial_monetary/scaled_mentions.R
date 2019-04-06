

### pull and format mentions and recommendation data------

mentions <- read.csv("../../raw_exp.txt", stringsAsFactors=FALSE, header=TRUE)
mentions$Topic <- gsub(",", "", mentions$Topic)
names(mentions)[1]  <- "Country"

## calculate % mentions for each topic by country/year group------

library(dplyr)

mentions <- mentions %>%
    group_by(Country, Year) %>%
    mutate(scaled = Mentions / sum(Mentions))

mentionsED <- mentions[mentions$Topic == "Financial/Monetary", ]

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
## -0.14701697 -0.02212391 -0.00050183  0.02995795  0.09498014 

## Coefficients:
##                        Estimate  Std. Error t-value  Pr(>|t|)    
## (Intercept)          0.21909254  0.00531130 41.2502 < 2.2e-16 ***
## BN.CAB.XOKA.GD.ZS.x  0.00111175  0.00036645  3.0339  0.002975 ** 
## NY.GDP.PCAP.KD.ZG   -0.00045546  0.00145402 -0.3132  0.754654    
## ---
## Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Total Sum of Squares:    0.19915
## Residual Sum of Squares: 0.18362
## R-Squared:      0.077969
## Adj. R-Squared: 0.062208
## F-statistic: 4.9469 on 2 and 117 DF, p-value: 0.0086619

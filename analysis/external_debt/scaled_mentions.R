

### pull and format mentions and recommendation data------

mentions <- read.csv("raw_exp.txt", stringsAsFactors=FALSE, header=TRUE)
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

econ <- read.csv("../pulling_data/merged_data.csv", stringsAsFactors=FALSE, header=TRUE)

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

FEestimate <- plm(Mentions ~  BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, data = mergedMentionsED_p, model = "within", effect = "twoways")

summary(FEestimate)
## Twoways effects Within Model

## Call:
## plm(formula = Mentions ~ BN.CAB.XOKA.GD.ZS.x + NY.GDP.PCAP.KD.ZG, 
##     data = mergedMentionsED_p, effect = "twoways", model = "within")

## Unbalanced Panel: n = 120, T = 1-15, N = 593

## Residuals:
##       Min.    1st Qu.     Median    3rd Qu.       Max. 
## -102.26200  -16.67060   -0.88939   14.93331  166.44097 

## Coefficients:
##                     Estimate Std. Error t-value Pr(>|t|)
## BN.CAB.XOKA.GD.ZS.x  0.18870    0.20878  0.9038   0.3666
## NY.GDP.PCAP.KD.ZG   -0.39250    0.52178 -0.7522   0.4523

## Total Sum of Squares:    524010
## Residual Sum of Squares: 522510
## R-Squared:      0.0028667
## Adj. R-Squared: -0.3031
## F-statistic: 0.651167 on 2 and 453 DF, p-value: 0.52192

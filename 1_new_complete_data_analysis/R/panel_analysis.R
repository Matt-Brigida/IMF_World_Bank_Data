library(readr)
library(plm)
library(dplyr)

d <- read_csv("../analysis_data.csv")

remove <- c("Country.y", "iso2c", "MS.MIL.XPND.CN")
d <- d[, !(names(d) %in% remove)]

## calculate % mentions for each topic by country/year group------

d <- d %>%
    group_by(Country.x, Year) %>%
    mutate(sMentions = Mentions / sum(Mentions, na.rm=TRUE)) %>%
    mutate(sRecommentations = Recommendations / sum(Recommendations, na.rm=TRUE))


### explanatory variables-----

vars <- c("BN.CAB.XOKA.GD.ZS", "NY.GDP.PCAP.KD.ZG", "SL.TLF.CACT.ZS")#, "GB.XPD.RSDV.GD.ZS")

mentions_form <- as.formula(paste("sMentions ~", paste(vars, collapse="+")))

recommendations_form <- as.formula(paste("sRecommentations ~", paste(vars, collapse="+")))

### separate by category-------

ed <- subset(d, Topic == "External Debt")


### convert to p data frame-----------

ed <- pdata.frame(ed, index = c("Country.x", "Year"), drop.index=TRUE, row.names=TRUE)

SM_ED_results <- plm(mentions_form, data = ed, model = "between", effect = "individual")

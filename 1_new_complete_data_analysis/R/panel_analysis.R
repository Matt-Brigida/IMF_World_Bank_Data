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

vars <- c("BN.CAB.XOKA.GD.ZS", # Current Account Balance as % of GDP
          "IC.FRM.BNKS.ZS", # Firms using banks to finance investment (% of firms)
          "BX.KLT.DINV.WD.GD.ZS", # Foreign direct investment, net inflows (% of GDP) (Replace Foreign direct investment net)
          "BX.TRF.PWKR.DT.GD.ZS", # Personal remittances, received (% of GDP)
          "BG.GSR.NFSV.GD.ZS", # Trade in services (% of GDP)
          "NV.AGR.TOTL.ZS", # Agriculture, forestry, and fishing, value added (% of GDP)
          "NE.EXP.GNFS.ZS", # Exports of goods and services (% of GDP)
          "NY.GDP.MKTP.KD.ZG", # GDP growth (annual %)
          "NY.GDP.PCAP.KD.ZG", # GDP per capita growth (annual %)
          "NY.GDS.TOTL.ZS", # Gross domestic savings (% of GDP)
          "NE.IMP.GNFS.ZS", # Imports of goods and services (% of GDP)
          "SL.TLF.CACT.ZS", # Labor force participation rate, total (% of total population ages 15+) (modeled ILO estimate)
          "BCG_GALM_G01_XDC" # Central government debt, total (% of GDP)
          )

mentions_form <- as.formula(paste("sMentions ~", paste(vars, collapse="+")))

recommendations_form <- as.formula(paste("sRecommentations ~", paste(vars, collapse="+")))

### separate by category-------

ed <- subset(d, Topic == "External Debt")


### convert to p data frame-----------

ed <- pdata.frame(ed, index = c("Country.x", "Year"), drop.index=TRUE, row.names=TRUE)

SM_ED_results <- plm(mentions_form, data = ed, model = "between", effect = "individual")
SM_ED_results <- plm(mentions_form, data = ed, model = "random")


SR_ED_results <- plm(recommendations_form, data = ed, model = "between", effect = "individual")

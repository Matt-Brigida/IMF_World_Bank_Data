import numpy as np
import pandas as pd
from linearmodels import PanelOLS
from linearmodels import RandomEffects
import statsmodels.api as sm

### format data------
data = pd.read_csv("./1_new_complete_data_analysis/merge_new_data/updated_analysis_data_with_8_15.csv")

### create scaled mentions and recommendations------

data.groupby(['Country.x', 'Year'])['Mentions'] / (data.groupby(['Country.x', 'Year']).sum()['Mentions'])


Year = pd.Categorical(data.Year)
data = data.set_index(['Country.x', 'Year'])
data['Year'] = Year


### create model------

exog_vars = [
"BN.CAB.XOKA.GD.ZS", # Current Account Balance as % of GDP
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
]

exog = sm.add_constant(data[exog_vars])
mod = RandomEffects(data.Mentions, exog)
re_res = mod.fit()
print(re_res)

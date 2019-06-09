library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

#  availableDB <- DataflowMethod()  ## doesn't work, problem on IMF end

IFS.available.codes <- DataStructureMethod("IFS")


### GDP-------

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Gross Domestic Product")

## NGDP_R_CH_SA_XDC | National Accounts, Expenditure, Gross Domestic Product, Real, Reference Chained, Seasonally adjusted, Domestic Currency

### Debt

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Debt")

## BCG_GALM_G01_XDC | Fiscal, Budgetary Central Government, Assets and Liabilities, Debt (at Market Value), Classification of the stocks of assets and liabilities, 2001 Manual, Domestic Currency
## CG01_GALM_G01_XDC | Fiscal, Central Government, Assets and Liabilities, Debt (at Market Value), Classification of the stocks of assets and liabilities, 2001 Manual, Domestic Currency
## GG_GALM_G01_XDC | Fiscal, General Government, Assets and Liabilities, Debt (at Market Value), Classification of the stocks of assets and liabilities, 2001 Manual, Domestic Currency
## FMD_SA_USD | Monetary, Debt, Seasonally Adjusted, US Dollars

### Inflation-------
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Price Index")






CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Current")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Balance of Payments")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Portfolio investment, Net acquisition of financial assets, Debt securities")

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Exchange")

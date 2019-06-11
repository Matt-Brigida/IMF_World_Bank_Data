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

## PCPI_PC_CP_A_PT | Prices, Consumer Price Index, All items, Percentage change, Corresponding period previous year, Percent

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Current Account")

## can only get this in USD, but we need to scale it by GDP which we can only get in domestic currency
## BGS_BP6_USD | Balance of Payments, Current Account, Goods and Services, Net, US Dollars

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Balance of Payments")

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Unemployment")

## LUR_PT | Labor Markets, Unemployment Rate, Percent

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "GDP Growth")

CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Foreign")




CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Exchange Reserves")

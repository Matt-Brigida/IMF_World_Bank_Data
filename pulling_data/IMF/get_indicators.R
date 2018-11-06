library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

#  availableDB <- DataflowMethod()  ## doesn't work, problem on IMF end

IFS.available.codes <- DataStructureMethod("IFS")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Current")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Balance of Payments")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Portfolio investment, Net acquisition of financial assets, Debt securities")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Price Index")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Exchange")

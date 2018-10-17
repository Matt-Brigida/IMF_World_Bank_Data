
library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

#  availableDB <- DataflowMethod()  ## doesn't work, problem on IMF end

IFS.available.codes <- DataStructureMethod("IFS")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Current")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Balance of Payments")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Portfolio investment, Net acquisition of financial assets, Debt securities")

databaseID <- "IFS"
startdate = "1900-01-01"
enddate = "2016-12-31"
checkquery = FALSE

## Germany, Norminal GDP in Euros, Norminal GDP in National Currency
## queryfilter <- list(CL_FREA = "", CL_AREA_IFS = "GR", CL_INDICATOR_IFS = c("BXG_BP6_USD"))

## spain, germany, "Portfolio investment, Net acquisition of financial assets, Debt securities"
queryfilter <- list(CL_FREA = "", CL_AREA_IFS = c("ES", "GR"), CL_INDICATOR_IFS = c("BFPAD_BP6_USD"))

BFPADBP6query <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, checkquery)

## look at first tome series, how to tell whether it is spain or germany---maybe have to query one country at a time
BFPADBP6query$Obs[[1]]

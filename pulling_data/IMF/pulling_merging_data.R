
library("IMFData", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.5")

#  availableDB <- DataflowMethod()  ## doesn't work, problem on IMF end

IFS.available.codes <- DataStructureMethod("IFS")
CodeSearch(IFS.available.codes, "CL_INDICATOR_IFS", "Current")

databaseID <- "IFS"
startdate = "2001-01-01"
enddate = "2016-12-31"
checkquery = FALSE

## Germany, Norminal GDP in Euros, Norminal GDP in National Currency
queryfilter <- list(CL_FREA = "", CL_AREA_IFS = "GR", CL_INDICATOR_IFS = c("BXG_BP6_USD", "BMG_BP6_USD"))
GR.NGDP.query <- CompactDataMethod(databaseID, queryfilter, startdate, enddate, 
                                   checkquery)
GR.NGDP.query$Obs[[1]]

# code and function to create html tables of select world bank data
# date: 10/10/2014

# load required libraries ----
library(WDI)
library(xtable)

# get data from world bank ----
gdpMKTP <- WDI(country="all", indicator="NY.GDP.MKTP.CN", start = 2012, end = 2014)
gdpPCAP <- WDI(country="all", indicator="NY.GDP.PCAP.CD", start = 2012, end = 2014)
pop <- WDI(country="all", indicator="SP.POP.TOTL", start = 2012, end = 2014)
inrDPST <- WDI(country="all", indicator="FR.INR.DPST", start = 2012, end = 2014)
inrLEND <- WDI(country="all", indicator="FR.INR.LEND", start = 2012, end = 2014)
inrRINR <- WDI(country="all", indicator="FR.INR.RINR", start = 2012, end = 2014)
prvt <- WDI(country="all", indicator="FD.AST.PRVT.GD.ZS", start = 2012, end = 2014)
totl <- WDI(country="all", indicator="FP.CPI.TOTL.ZG", start = 2012, end = 2014)
gd <- WDI(country="all", indicator="BN.CAB.XOKA.GD.ZS", start = 1900, end = 2019)
cd <- WDI(country="all", indicator="BN.CAB.XOKA.CD", start = 2012, end = 2014)

# create list of countries to pass to 'tables' function ----
list <- c("France","Germany","Spain") #for all countries change to 'list <- cd$country'

tables <- function(countries){
for (i in 1:length(countries)){
    # get vector of data for table ----
    data <- c(gdpMKTP$NY.GDP.MKTP.CN[gdpMKTP$country == countries[i]][1], gdpPCAP$NY.GDP.PCAP.CD[gdpPCAP$country == countries[i]][1], pop$SP.POP.TOTL[pop$country == countries[i]][1], inrDPST$FR.INR.DPST[inrDPST$country == countries[i]][1], inrLEND$FR.INR.LEND[inrLEND$country == countries[i]][1], inrRINR$FR.INR.RINR[inrRINR$country == countries[i]][1], prvt$FD.AST.PRVT.GD.ZS[prvt$country == countries[i]][1], totl$FP.CPI.TOTL.ZG[totl$country == countries[i]][1], gd$BN.CAB.XOKA.GD.ZS[gd$country == countries[i]][1], cd$BN.CAB.XOKA.CD[cd$country == countries[i]][1])
       # convert to xtable ----
       df <- as.data.frame(cbind(c("GDP (current US$)","GDP per capita (current US$)", "Population (Total)", "Deposit interest rate (%)", "Lending interest rate (%)", "Real interest rate (%)", "Domestic credit to private sector by banks (% of GDP)", "Inflation, consumer prices (annual %)", "Current account balance (% of GDP)", "Current account balance (BoP, current US$)"), data))
       names(df) <- c(countries[i], "")
       xtab <- xtable(df)
         # write to html file in working directory ----
         fileConn <- file(paste(countries[i], ".html", sep="")) #file("table.html")
         writeLines(print(xtab, type = "html"), fileConn)
         close(fileConn)
                          }
                     }


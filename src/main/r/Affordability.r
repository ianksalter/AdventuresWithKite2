# Title     : Affordability
# Objective : To determine possible Basic Income amounts and Simple Tax rates that are possible given current UK income.
# Created by: ian
# Created on: 04/06/2018

# Import Basic Income Stuff
source("src/main/r/BasicIncomeSimpleTax.r")
source("src/main/r/UKTaxAndBenefits.r")
source("src/main/r/RevenueAndCost.r")


# Constants
# From… https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/710887/Table_2.1.pdf
totalUKTaxPayers2015_16 <- 31000000
# 5.2 average unemployment for 2015-2016
# From: https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/timeseries/mgsx/lms
ukUnemployment2015_16 <-5.2
#: From:https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/uklabourmarket/february2016
in_work <- 31.417 #Million
in_work16to64 <- 30.251 #Million
inWork65Plus <- 1.201 #Million
employmentRate16to64 <- 0.741 #Proportion of 16 to 64 in work.
unemployed16to64 <- 1.690000 # million - Check agains unemployment figures
economicallyInactive16to64 <- 8.88 #million
economicallyInactive65Plus <- 10.116000 #million
# Data from
# https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationprojections/adhocs/007825greatbritainmidyearpopulationestimates2015baseddata
mydata <-read.csv("data/UKPopulationData2105.csv") 
populationData <- mydata[[1]]
# Data re 2015/16 taxpayers from
# https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/710887/Table_2.1.pdf
taxpayers <- 30.700 #Million
lowerRateTaxpayers <- 0
saversRateTaxpayers <- 0.806 #Million
basicRateTaxpayers <- 25.300 #Million
higherRateTaxpayers <- 4.510 #Million
additionalrateTaxpayers <- 0.362 #Million
under65Taxpayers <- 24.500 #Million
over65Taxpayers <- 6.490 #Million
statePensionTaxpayers <- 6.870 #Million

#TODO find details of:
# National Insurance Payers
# State pension recievers
# Child benefit payements


# 2015 16BudgetDataFrom:
# https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/627535/Whole_of_Government_Accounts_2015_to_2016_WEB.pdf
incomeTaxRevenue <- 170 #billion
nationalInsuranceRevenue <- 102 #billion
socialProtectionTotal <- 264.2 #billion
spendingOnStatePension <- 91.5 #billion
childBenefit <- 11.7 #billion
workingAgeBenefits <- 25.8 #billion
disabilityLivingAllowance <- 14.3 #billion

# From:
# http://www.pensionspolicyinstitute.org.uk/pension-facts/pension-facts-tables/table-1-demographics
noPeopleOfStatePensionAge <- (12.312 + 12.530)/2 # mean of 2015 and 2016 in millions

# From:
# https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/457239/DWP11-benefit-and-pension-rates-april-2015-280815.pdf
statePension <- 115.95 * 52
basicIncome <- statePension

paymentsToUnemployed <-  (unemployed16to64 * basicIncome)/1000
nonTaxPayingPensioners <- noPeopleOfStatePensionAge - statePensionTaxpayers
paymentsToNonTaxPayingPensioners = (nonTaxPayingPensioners * basicIncome)/1000

# To work back from here to find the data that is needed  
targetRevenueRaise <- 
  incomeTaxRevenue + 
  nationalInsuranceRevenue - 
  workingAgeBenefits - 
  spendingOnStatePension -
  disabilityLivingAllowance +
  paymentsToUnemployed +
  paymentsToNonTaxPayingPensioners
  
  
  

#Fitting the distribution

# Read in UK Percentile Tax Data 2015_16
# Sourced From: https://www.gov.uk/government/statistics/percentile-points-from-1-to-99-for-total-income-before-and-after-tax
mydata <-read.csv("data/UKIncomePercentilesPreTax2015-16.csv") 
incomeData <- mydata[[1]]

# Chart data
hist(incomeData)
plot(density(incomeData))
plot(ecdf(incomeData))

# Fit data to a log normal distribution
library(fitdistrplus)
incomeDistribution <- fitdist(incomeData,"lnorm")
incomeDistMeanLog <- exp(incomeDistribution$estimate["meanlog"][[1]])
incomeDistSdLog <- exp(incomeDistribution$estimate["sdlog"][[1]])


# Testing the aproach with UK tax
ukTaxRevenueAndCost <- RevenueAndCost$new(
  amountFunction = incomeTax2015$amount,
  population = taxpayers * 1000000,
  mean = incomeDistMeanLog,
  standardDeviation = incomeDistSdLog
)


# Testing the aproach with UK tax

bistRevenueAndCost <- RevenueAndCost$new(
  amountFunction = function(x){1}      #defaultBist$finalIncome,
  population = 1, #taxpayers * 1000000,
  mean = incomeDistMeanLog,
  standardDeviation = incomeDistSdLog
)






#Stuff below here can probably go as its replaced by the revenue and cost class.


# Log normal ProbablityDensityFunction
logNormalPdf <- function(x,mean,sd){
    (1/(x*sd*sqrt(2*pi)))*
     exp(-(log(x)-mean)^2/(2*sd^2))
}

# Log normal ProbablityDensityFunction
logNormalPdfTest <- function(x){
  mean <- 1
  sd <- 1
  (1/(x*sd*sqrt(2*pi)))*
    exp(-(log(x)-mean)^2/(2*sd^2))
}

# Particular version for UK Income
incomeDistLogNormal <- function(x){
  logNormalPdf(x,incomeDistMeanLog,incomeDistSdLog)
}

# test.txt stuff - should go to test function
incomeDistributionVector <- sapply(seq(0,100000,1000),incomeDistLogNormal)
logNormalDistribution <- dlnorm(seq(0,100000,1000),meanlog=10.1376053,sdlog=0.5588517)
plot(logNormalDistribution,incomeDistributionVector)

# Basic Income Simple Tax Revenue
bistRevenue <- function(income,mean,standardDeviation,population){
  population * (income - bistIncome(income)) * logNormalPdf(income,mean,standardDeviation)
}

bistRevenue2015_16 <- function(income){
  bistRevenue(income,incomeDistMeanLog,incomeDistSdLog,totalUKTaxPayers2015_16)
}

# Integration stuff
integrand <- function(x){1-x}
integrate(integrand,lower=0,upper=1)
integrate(incomeDistLogNormal,lower=0,upper=1000000) # Almost all fo the distribution
integrate(bistRevenue2015_16,lower=0,upper=1000000) # Almost all fo the distribution

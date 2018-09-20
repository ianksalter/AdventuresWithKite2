# Plots illustrating the affordability of basic income simple tax

source("src/main/r/BasicIncomeSimpleTax.r")
source("src/main/r/UKTaxAndBenefits.r")
source("src/main/r/RevenueAndCost.r")
source("src/main/r/CommonGraphics.r")

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06

# I need to find out how income is distributed and find UK Percentile Tax Data 2015_16:
# Sourced From: https://www.gov.uk/government/statistics/percentile-points-from-1-to-99-for-total-income-before-and-after-tax
# This gives me an estimate of income for the person at each percent along income distribution from 1 until 99.
# "This table gives certain percentile points of the income distribution as estimated from the Survey of Personal Incomes 2015/16
incomeData <-read.csv("data/UKIncomePercentilesPreTax2015-16.csv") 


# Chart data
qplot(incomeData,geom="histogram",binwidth = 10000)

#Fit data to a normal distribution
library(fitdistrplus)
fittedDistribution <- fitdist(incomeData$Income,"lnorm")
incomeDistMeanLog <- fittedDistribution$estimate["meanlog"][[1]]
incomeDistSdLog <- fittedDistribution$estimate["sdlog"][[1]]

#Functions for taxIncome distribution
incomePDFFunction <- function(income){
  dlnorm(income,meanlog = incomeDistMeanLog,sdlog = incomeDistSdLog)
}
taxFunction <- function(income){
  taxAndBenefits2015$incomeTax$amount(income)
}
taxRevenueFunction <- function(income){
  taxFunction(income) * incomePDFFunction(income)
}


integrate(function(x){sapply(x,taxRevenueFunction)},lower=0,upper=Inf)

#Create a dataframe of the data
income <- seq(from=1,to=200000,by=100)
incomePDF <- sapply(income,incomePDFFunction)
taxRevenue <- sapply(income,taxRevenueFunction)
incomeDistDf <- data.frame(income,incomePDF,taxRevenue)

# Create graph of uk income distribution
ggplotBist(incomeDistDf,200000,20000,0.0005,0.00005,aes(x=income)) + 
geom_area(aes(y=incomePDF), fill="grey70") + 
  geom_line(aes(y=incomePDF))
scale_fill_manual(name="",values = c("Distribution of Income"="grey80")) +
  labs(x="Initial Income 1000s",y="UK Income Distribution Function")  +
  theme(legend.position=c(0.1, 0.9))

# Create graph of uk tax revenue based upon income distribution
ggplotBist(incomeDistDf,200000,20000,0.1,0.01,aes(x=income)) + 
  geom_area(aes(y=taxRevenue), fill="grey70") + 
  geom_line(aes(y=taxRevenue))
  scale_fill_manual(name="",values = c("Distribution of Income"="grey80")) +
  labs(x="Initial Income 1000s",y="UK Income Distribution Function")  +
  theme(legend.position=c(0.1, 0.9))


numericalIntegrate <- function(integrand,lower=0, upper=200000,step=1){
  result<-0
  for(x in seq(lower,upper-step,step)){
    result <- result + integrand(x+step/2)*step
  }
  result
}  

#test.txt
numericalIntegrate(function(x){1},lower=0,upper=100,step=2)


# Data re 2015/16 taxpayers from
# https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/710887/Table_2.1.pdf
taxpayers <- 30.700 #Million
# lowerRateTaxpayers <- 0
# saversRateTaxpayers <- 0.806 #Million
# basicRateTaxpayers <- 25.300 #Million
# higherRateTaxpayers <- 4.510 #Million
# additionalrateTaxpayers <- 0.362 #Million
# under65Taxpayers <- 24.500 #Million
# over65Taxpayers <- 6.490 #Million
statePensionTaxpayers <- 6.870 #Million

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

paymentsToUnemployed <-  (unemployed16to64 * basicIncome)/1000 #Billion
nonTaxPayingPensioners <- noPeopleOfStatePensionAge - statePensionTaxpayers
paymentsToNonTaxPayingPensioners = (nonTaxPayingPensioners * basicIncome)/1000 #Billion

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
incomeData <- mydata[[1]]/1000 #Division so we can talk about units in 

# Chart data
hist(incomeData)
plot(density(incomeData))
plot(ecdf(incomeData))

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06

# Fit data to a log normal distribution
library(fitdistrplus)
fittedDistribution <- fitdist(incomeData,"lnorm")
incomeDistMeanLog <- fittedDistribution$estimate["meanlog"][[1]]
incomeDistSdLog <- fittedDistribution$estimate["sdlog"][[1]]


# Testing the aproach with UK tax
ukTaxRevenueAndCost <- RevenueAndCost$new(
  amountFunction = incomeTax2015$amount,
  population = taxpayers * 1000, #Reduced by 1000 due to the income scaling????
  mean = incomeDistMeanLog,
  standardDeviation = incomeDistSdLog
)

ukTaxRevenueAndCostDf <- ukTaxRevenueAndCost$dataFrame(from=0,to=160,by=0.1)

# Create graph of the log normal distribution for uk income
ggplotBist(ukTaxRevenueAndCostDf,160,20,0.05,0.005,aes(x=initialIncome)) + 
  geom_area(aes(y=logNormalPDF), fill="grey70") + 
  geom_line(aes(y=logNormalPDF)) +
  scale_fill_manual(name="",values = c("Distribution of Income"="grey80")) +
  labs(x="Initial Income 1000s",y="Probability of Earning")  +
  theme(legend.position=c(0.1, 0.9))

# Create graph of uk incme distribution
ggplotBist(ukTaxRevenueAndCostDf,160,20,1000000,100000,aes(x=initialIncome)) + 
  geom_area(aes(y=incomeDistribution), fill="grey70") + 
  geom_line(aes(y=incomeDistribution)) +
  scale_fill_manual(name="",values = c("Distribution of Income"="grey80")) +
  labs(x="Initial Income 1000s",y="UK Income Distribution Function")  +
  theme(legend.position=c(0.1, 0.9))

# Create graph of uk incme distribution
ggplotBist(ukTaxRevenueAndCostDf,160,20,3000000,300000,aes(x=initialIncome)) + 
  geom_area(aes(y=amount), fill="grey70") + 
  geom_line(aes(y=amount)) +
  scale_fill_manual(name="",values = c("Distribution of Tax Income"="grey80")) +
  labs(x="Initial Income 1000s",y="Tax Revenue by Income")  +
  theme(legend.position=c(0.1, 0.9))

ukTaxRevenueAndCost$overallAmount()/1000000 - incomeTaxRevenue #Should be zero.

bistRevenueAndCost <- RevenueAndCost$new(
  amountFunction = defaultBist$finalIncome,
  population = taxpayers * 1000,
  mean = incomeDistMeanLog,
  standardDeviation = incomeDistSdLog
)

bistRevenueAndCostDf <- bistRevenueAndCost$dataFrame(from=0,to=160,by=0.1)


# Create graph of uk incme distribution
ggplotBist(bistRevenueAndCostDf,160,20,3000000,300000,aes(x=initialIncome)) + 
  geom_area(aes(y=amount), fill="grey70") + 
  geom_line(aes(y=amount)) +
  scale_fill_manual(name="",values = c("Distribution of Tax Income"="grey80")) +
  labs(x="Initial Income 1000s",y="BistRevenue")  +
  theme(legend.position=c(0.1, 0.9))

bistRevenueAndCost$overallAmount()/1000000

#NOTE - consider working out the centiles from your distribution and comparing the two.

# This file creates a set of functions representing the key components of the UK 
# Tax and Benefit System in 2017/2018. It is not supposed to create 
# a set of calculators covering every eventuality, but a set that can be used 
# to illustrate discussions of the tax and benefit system.


# Income Tax Constants for 2017/2018
# Sourced from:
# https://www.gov.uk/guidance/rates-and-thresholds-for-employers-2017-to-2018
basePersonalAllowance <- 11500
allowanceThreshold <- 100000
basicRateLimit <- 33500
higherRateLimit <- 150000
basicRate <- 0.20
higherRate <- 0.40
additionalRate <- 0.45

#' The Personal Allowance Function
#'
#' This function determines how much personal alowance a person has dependant upon their income.
#' In the UK the personal allowance is how much you can earn tax free. However the allowance is 
#' reduced by one pound for every £2 earned over £100,000
#' the allowance is reduced
#' @param income The initial income of the person.
#' @keywords uk income tax, personal allowance
#' @export
#' @examples
#' personalAllowance()
personalAllowance <- function(income){
  if (income < allowanceThreshold)
    basePersonalAllowance
  else
    max(0 , basePersonalAllowance - floor((income-allowanceThreshold)/2))
}

#' The Income Tax Function
#'
#' This function determines how much income tax a single person pays depending upon their income.
#' Note this ignores scotland for sake of simplicity
#' @param income The initial income of the person.
#' @keywords uk income tax
#' @export
#' @examples
#' incomeTax()
incomeTax <- function(income){
  allowance <- personalAllowance(income)
  higherRateThreshold <- basicRateLimit + allowance
  additionalRateThreshold <- higherRateLimit + allowance  
  tax <- 0
  if  (income > allowance){
    taxableIncomeAtBasicRate <- min(income,higherRateThreshold) - allowance
    tax <- tax + taxableIncomeAtBasicRate * basicRate
  }
  if  (income > higherRateThreshold){
    taxableIncomeAtHigherRate <- min(income,additionalRateThreshold) - higherRateThreshold
    tax <- tax + taxableIncomeAtHigherRate * higherRate
  }
  if (income > additionalRateThreshold){
    taxableIncomeAtAdditionalRate <- income - additionalRateThreshold 
    tax <- tax + taxableIncomeAtAdditionalRate * additionalRate
  }
  tax
}

# National Insurance Constants for 2017/2018
# Sourced from:
# https://www.gov.uk/guidance/rates-and-thresholds-for-employers-2017-to-2018
primaryThreshold <- 8164
secondaryThreshold <- 8164
upperEarningsLimit <- 45000
standardRate <- 0.12
lowerRate <- 0.02
employerRate <- 0.138

#' The Employees National Insurance Function
#'
#' This function determines the level of employees national insurance contributions for a given income.
#' @param income The initial income of the person.
#' @keywords uk national insurance employee
#' @export
#' @examples
#' employeesNationalInsurance()
employeesNationalInsurance <- function(income){
  insurance <- 0
  if  (income > primaryThreshold){
    insuranceIncomeAtStandardRate <- min(income,upperEarningsLimit) - primaryThreshold
    insurance <- insurance + insuranceIncomeAtStandardRate * standardRate
  }
  if (income > upperEarningsLimit){
    insuranceIncomeAtLowerRate <- income - upperEarningsLimit 
    insurance <- insurance + insuranceIncomeAtLowerRate * lowerRate
  }
  insurance
}

#' The Employers National Insurance Function
#'
#' This function determines the level of employers national insurance contributions for a given income.
#' @param income The intial income of the person.
#' @keywords uk national insurance employer
#' @export
#' @examples
#' employersNationalInsurance()
employersNationalInsurance <- function(income){
  if (income > secondaryThreshold){
    insurance <- (income - secondaryThreshold)*employerRate 
  } else
    insurance <- 0
  insurance
}

# Universal Credit Constants for 2017/2018
# Data from:
# https://revenuebenefits.org.uk/universal-credit/guidance/entitlement-to-uc/calculating-universal-credi
ucMaximumAmount <- 371.8 * 12
ucHigherWorkAllowance <- 0
ucEarnedTaper <- 0.63
ucUnearnedTaper <- 1

#' The Universal Credit Function
#'
#' This function determines the amount of universal credit due for a given income.
#' note assumes at present all 
#' @param earnedIncome The initial earned income of the person.
#' @param unearnedIncome The inttial unearned income of the person.
#' @keywords uk universal credit
#' @export
#' @examples
#' universalCredit()
universalCredit <- function(earnedIncome,unearnedIncome=0){
  max(0,
      ucMaximumAmount - 
        (earnedIncome - ucHigherWorkAllowance)*ucEarnedTaper -
        (unearnedIncome*ucUnearnedTaper))
}




# TODO: adjustedUkIncomeTaxDataFrame - gives gross income as inclusive of employers ni contribution.

#' The UK Income Tax Data Frame function
#'
#' This function creates a data frame with the following columns
#' 1) initialIncome
#' 2) personalAllowance
#' 3) incomeTax
#' 4) employeesNationalInsurance
#' 5) employersNationalInsurance
#' 6) universalCreditEarned - assumes all income is earned
#' 7) universalCreditUnearned - assumes all income is unearned
#' 9) finalIncomeEarned - assumes all income is earned
#' 10) finalIncomeUnearned - assumes all income is unearned
#' @param from The starting point for the gross income vector of the data frame. Defaults to 1.
#' @param to The ending point of the gross income vector of the data frame. Defaults to 50001.
#' @param by The increments of the gross income vector of the data frame. Defaukts to 1000.)
#' @keywords income tax, national insurance, tax credit
#' @export
#' @examples
#' ukIncomeTaxDataFrame()
ukIncomeTaxDataFrame <- function(from=1,to=50001,by=1000) {
  initialIncome <- seq(from,to,by)
  personalAllowance <- sapply(initialIncome,personalAllowance)
  incomeTax <- sapply(initialIncome,incomeTax)
  employeesNationalInsurance <- sapply(initialIncome,employeesNationalInsurance)
  employersNationalInsurance <- sapply(initialIncome,employersNationalInsurance)
  universalCreditEarned <- sapply(initialIncome,universalCredit)
  universalCreditUnearned <- sapply(initialIncome,function(income){universalCredit(0,income)})
  finalIncomeEarned <-
    initialIncome + universalCreditEarned - incomeTax - employeesNationalInsurance
  finalIncomeUnearned <-
    initialIncome + universalCreditUnearned - incomeTax 
  data.frame(initialIncome,
             personalAllowance,
             incomeTax,
             employeesNationalInsurance,
             employersNationalInsurance,
             universalCreditEarned,
             universalCreditUnearned,
             finalIncomeEarned,
             finalIncomeUnearned)
}

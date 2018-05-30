# This file creates a set of functions that give income taking into account income tax, 
# national insurance and tax credits

#' The Personal Allowance Function
#'
#' This function determines how much personal alowance a person has dependant upon their income.
#' In the UK the personal allowance is how much you can earn tax free. However the allowance is 
#' reduced by one pound for every £2 earned over £100,000
#' the allowance is reduced
#' @param income The gross income of the person.
#' @keywords uk income tax, personal allowance
#' @export
#' @examples
#' personalAllowance()
personalAllowance <- function(income){
  allowance <- 11000
  allowanceLimit <- 100000
  if (income < allowanceLimit)
    allowance
  else
    max(0 , allowance-floor((income-allowanceLimit)/2))
}

#' The Income Tax Function
#'
#' This function determines how much income tax a single person pays depending upon their income.
#' Note this ignores scotland for sake of simplicity
#' @param income The gross income of the person.
#' @keywords uk income tax
#' @export
#' @examples
#' incomeTax()
incomeTax <- function(income){
  allowance <- personalAllowance(income)
  higherRateThreshold <- 32000 + allowance
  additionalRateThreshold <- 150000 + allowance  
  tax <- 0
  if  (income > allowance){
    taxableIncomeAtBasicRate <- min(income,higherRateThreshold) - allowance
    tax <- tax + taxableIncomeAtBasicRate * 0.2
  }
  if  (income > higherRateThreshold){
    taxableIncomeAtHigherRate <- min(income,additionalRateThreshold) - higherRateThreshold
    tax <- tax + taxableIncomeAtHigherRate * 0.4
  }
  if (income > additionalRateThreshold){
    taxableIncomeAtAditionalRate <- income - additionalRateThreshold 
    tax <- tax + taxableIncomeAtAditionalRate * 0.45
  }
  tax
}

#' The Income Net of Income Tax Function
#'
#' This function determines how much net income after income tax that a single person 
#' pays depending upon their income.
#' Note this ignores scotland for sake of simplicity.ukIncomeTaxD
#' @param income The gross income of the person.
#' @keywords uk income tax
#' @export
#' @examples
#' incomeNetOfIncomeTax()
incomeNetOfIncomeTax<- function(income){
  income - incomeTax(income)
}

#' The Employees National Insurance Function
#'
#' This function determines the level of employees national insurance contributions for a given income.
#' @param income The gross income of the person.
#' @keywords uk national insurance employee
#' @export
#' @examples
#' employeesNationalInsurance()
employeesNationalInsurance <- function(income){
  primaryThreshold <- 672 * 12
  upperEarningsLimit <- 3583 * 12
  insurance <- 0
  if  (income > primaryThreshold){
    insuranceIncomeAtMainRate <- min(income,upperEarningsLimit) - primaryThreshold
    insurance <- insurance + insuranceIncomeAtMainRate * 0.12
  }
  if (income > upperEarningsLimit){
    insuranceIncomeAtUpperRate <- income - upperEarningsLimit 
    insurance <- insurance + insuranceIncomeAtUpperRate * 0.02
  }
  insurance
}

#' The Employers National Insurance Function
#'
#' This function determines the level of employers national insurance contributions for a given income.
#' @param income The gross income of the person.
#' @keywords uk national insurance employer
#' @export
#' @examples
#' employersNationalInsurance()
employersNationalInsurance <- function(income){
  secondaryThreshold <- 676 * 12
  rate = 0.138
  if (income > secondaryThreshold){
    insurance <- (income - secondaryThreshold)*rate 
  } else
    insurance <- 0
  insurance
}

#' The National Insurance Function
#'
#' This function determines the total level of national insurance contributions for a given income.
#' @param income The gross income of the person.
#' @keywords uk national insurance employer
#' @export
#' @examples
#' nationalInsurance()
nationalInsurance <- function(income){
  employeesNationalInsurance(income) + employersNationalInsurance(income)
}


#' The Income Net Of Employees National Insurance Function
#'
#' This function determines the total level of national insurance contributions for a given income.
#' @param income The gross income of the person.
#' @keywords uk national insurance employer
#' @export
#' @examples
#' incomeNetOfEmployeesNationalInsurance()
incomeNetOfEmployeesNationalInsurance <- function(income){
  income - employeesNationalInsurance(income)
}

#' The Income Net Of National Insurance and Income Tax Function
#'
#' This function determines the total level of national insurance contributions for a given income.
#' @param income The gross income of the person.
#' @keywords uk national insurance employer
#' @export
#' @examples
#' incomeNetOfNationalInsuranceAndIncomeTax()
incomeNetOfNationalInsuranceAndIncomeTax <- function(income){
  income - employeesNationalInsurance(income) - incomeTax(income)
}

# TODO: Tax Credits
# TODO: adjustedUkIncomeTaxDataFrame - gives gross income as inclusive of employers ni contribution.

#' The UK Income Tax Data Frame function
#'
#' This function creates a data frame with the following columns
#' 1) grossIncome
#' 2) personal allowance
#' 3) incomeTax
#' 4) incomeNetOfIncomeTax
#' 5) employeesNationalInsurance
#' 6) employersNationalInsurance
#' 7) incomeNetOfEmployeesNationalInsurance
#' 8) incomeNetOfNationalInsuranceAndIncomeTax
#' 9) taxCredits
#' 10) netIncome
#' @param from The starting point for the gross income vector of the data frame. Defaults to 1.
#' @param to The ending point of the gross income vector of the data frame. Defaults to 50001.
#' @param by The increments of the gross income vector of the data frame. Defaukts to 1000.)
#' @keywords income tax, national insurance, tax credit
#' @export
#' @examples
#' ukIncomeTaxDataFrame()
ukIncomeTaxDataFrame <- function(from=1,to=50001,by=1000) {
  grossIncome <- seq(from,to,by)
  personalAllowance <- sapply(grossIncome,personalAllowance)
  incomeTax <- sapply(grossIncome,incomeTax)
  incomeNetOfIncomeTax <- sapply(grossIncome,incomeNetOfIncomeTax)
  employeesNationalInsurance <- sapply(grossIncome,employeesNationalInsurance)
  employersNationalInsurance <- sapply(grossIncome,employersNationalInsurance)
  incomeNetOfEmployeesNationalInsurance <- sapply(grossIncome,incomeNetOfEmployeesNationalInsurance)
  incomeNetOfNationalInsuranceAndIncomeTax <- sapply(grossIncome,incomeNetOfNationalInsuranceAndIncomeTax)
  taxCredits <- grossIncome
  netIncome <- grossIncome
  data.frame(grossIncome,
             personalAllowance,
             incomeTax,
             incomeNetOfIncomeTax,
             employeesNationalInsurance,
             employersNationalInsurance,
             incomeNetOfEmployeesNationalInsurance,
             incomeNetOfNationalInsuranceAndIncomeTax,
             taxCredits,
             netIncome)
}

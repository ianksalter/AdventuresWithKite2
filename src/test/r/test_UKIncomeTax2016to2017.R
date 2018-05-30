# Unit tests for the functions in the file UKIncomeTax2016to2017.r

source("src/main/r/UKIncomeTax2016to2017.r")

library(testthat)

context('Testing UK Income Tax 2016 to 2017')

test_that('personalAllowance function produces expected values',{
  expect_equal(personalAllowance(100000),11000)
  expect_equal(personalAllowance(100002),10999)
  expect_equal(personalAllowance(100004),10998)
  expect_equal(personalAllowance(122000),0)
})

test_that('incomeTax function produces expected values',{
  expect_equal(incomeTax(5000),0)
  expect_equal(incomeTax(21000),2000)
  # Test data from calculator here: http://iknowtax.com/2016/
  expect_equal(incomeTax(24000),2600)
  expect_equal(incomeTax(43000),6400)
  expect_equal(incomeTax(55000),11200)
  expect_equal(incomeTax(120000),41200)
  expect_equal(incomeTax(200000),76100)
  expect_equal(incomeTax(500000),211100)
})

test_that('incomeNetOfIncomeTax function produces expected values',{
  expect_equal(incomeNetOfIncomeTax(5000),5000)
  expect_equal(incomeNetOfIncomeTax(21000),19000)
})

test_that('employeesNationalInsurance function produces expected values',{
  # Test data based upon the following calcs
  primaryThreshold <- 672
  upperEarningsLimit <- 3583
  mainRate <- 0.12
  lowerRate <- 0.02
  insuranceFor1000PerMonth <- (1000-primaryThreshold)*mainRate
  insuranceFor12000PerYear <- insuranceFor1000PerMonth * 12
  insuranceFor5000PerMonth <- (5000-upperEarningsLimit)*lowerRate + (3583-primaryThreshold)*mainRate
  insuranceFor60000PerYear <- insuranceFor5000PerMonth * 12
  #Tests
  expect_equal(employeesNationalInsurance(12000),insuranceFor12000PerYear)
  expect_equal(employeesNationalInsurance(60000),insuranceFor60000PerYear)
})

test_that('employersNationalInsurance function produces expected values',{
  # Test data based upon the following calcs:
  secondaryThreshold <- 676
  rate <- 0.138
  insuranceFor1000PerMonth <- (1000-secondaryThreshold)*rate
  insuranceFor12000PerYear <- insuranceFor1000PerMonth * 12
  insuranceFor5000PerMonth <- (5000-secondaryThreshold)*rate
  insuranceFor60000PerYear <- insuranceFor5000PerMonth * 12
  #Tests
  expect_equal(employersNationalInsurance(12000),insuranceFor12000PerYear)
  expect_equal(employersNationalInsurance(60000),insuranceFor60000PerYear)
})

test_that('nationalInsurance function produces expected values',{
  expect_equal(
    nationalInsurance(12000),
    employeesNationalInsurance(12000) + employersNationalInsurance(12000))
})

test_that('incomeNetOfEmployeesNationalInsurance function produces expected values',{
  income <- 12000
  expect_equal(
    incomeNetOfEmployeesNationalInsurance(income),
    income -
      employeesNationalInsurance(12000))
})

test_that('incomeNetOfNationalInsuranceAndIncomeTax function produces expected values',{
  income <- 12000
  expect_equal(
    incomeNetOfNationalInsuranceAndIncomeTax(income),
    income - 
      employeesNationalInsurance(income) -
      incomeTax(income))
})

test_that('ukIncomeTaxDataFrame function has the correct shape',{
  incomeTaxDf <- ukIncomeTaxDataFrame()
  expect_length(incomeTaxDf$grossIncome,51)
  expect_length(incomeTaxDf$personalAllowance,51)
  expect_length(incomeTaxDf$incomeTax,51)
  expect_length(incomeTaxDf$incomeNetOfIncomeTax,51)
  expect_length(incomeTaxDf$employeesNationalInsurance,51)
  expect_length(incomeTaxDf$employersNationalInsurance,51)
  expect_length(incomeTaxDf$incomeNetOfEmployeesNationalInsurance,51)
  expect_length(incomeTaxDf$incomeNetOfNationalInsuranceAndIncomeTax,51)
  expect_length(incomeTaxDf$taxCredits,51)
  expect_length(incomeTaxDf$netIncome,51)
})

test_that('ukIncomeDataFrame function produces correct values',{
  incomeTaxDf <- ukIncomeTaxDataFrame()
  expect_equal(incomeTaxDf$grossIncome[1],1)
  expect_equal(incomeTaxDf$personalAllowance[41],personalAllowance(incomeTaxDf$grossIncome[40]))
  expect_equal(incomeTaxDf$incomeTax[35],incomeTax(incomeTaxDf$grossIncome[35]))
  expect_equal(incomeTaxDf$incomeNetOfIncomeTax[20],incomeNetOfIncomeTax(incomeTaxDf$grossIncome[20]))
  expect_equal(incomeTaxDf$employeesNationalInsurance[35],
               employeesNationalInsurance(incomeTaxDf$grossIncome[35]))
  expect_equal(incomeTaxDf$employersNationalInsurance[35],
               employersNationalInsurance(incomeTaxDf$grossIncome[35]))
  expect_equal(incomeTaxDf$incomeNetOfNationalInsuranceAndIncomeTax[35],
               incomeNetOfNationalInsuranceAndIncomeTax(incomeTaxDf$grossIncome[35]))
  # expect_equal(incomeTaxDf$nationalInsurance[1],1)
  # expect_equal(incomeTaxDf$incomeNetOfNationalInsurance[1],1)
  # expect_equal(incomeTaxDf$incomeNetOfNationalInsuranceAndIncomeTax[1],1)
  # expect_equal(incomeTaxDf$taxCredits[1],1)
  # expect_equal(incomeTaxDf$netIncome[1],1)
})

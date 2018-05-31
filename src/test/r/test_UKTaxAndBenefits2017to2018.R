# Unit tests for the functions in the file UKTaxAndBenefits2017to2018.r

source("src/main/r/UKTaxAndBenefits2017to2018.r")

library(testthat)

context('Testing UK Tax and Benefit fnctions 2017 to 2018')

test_that('Income Tax Constants are correct',{
  # Note source for this data is:
  # https://www.gov.uk/guidance/rates-and-thresholds-for-employers-2017-to-2018
  expect_equal(basePersonalAllowance,11500)
  expect_equal(allowanceThreshold,100000)
  expect_equal(basicRateLimit,33500)
  expect_equal(higherRateLimit,150000)
  expect_equal(basicRate,0.20)
  expect_equal(higherRate,0.40)
  expect_equal(additionalRate,0.45)
})

test_that('personalAllowance function produces expected values',{
  expect_equal(personalAllowance(100000),11500)
  expect_equal(personalAllowance(100002),11499)
  expect_equal(personalAllowance(100004),11498)
  expect_equal(personalAllowance(123000),0)
})

test_that('incomeTax function produces expected values',{
  expect_equal(incomeTax(5000),0)
  expect_equal(incomeTax(21500),2000)
  # Test data from calculator here: http://iknowtax.com/2016/
  expect_equal(incomeTax(24000),2500)
  expect_equal(incomeTax(43000),6300)
  expect_equal(incomeTax(55000),10700)
  expect_equal(incomeTax(120000),40700)
  expect_equal(incomeTax(200000),75800)
  expect_equal(incomeTax(500000),210800)
})


test_that('National Insurance Constants are correct',{
  # Note source for this data is:
  # https://www.gov.uk/guidance/rates-and-thresholds-for-employers-2017-to-2018
  expect_equal(primaryThreshold,8164)
  expect_equal(secondaryThreshold,8164)
  expect_equal(upperEarningsLimit,45000)
  expect_equal(standardRate,0.12)
  expect_equal(lowerRate,0.02)
  expect_equal(employerRate,0.138)
})

test_that('employeesNationalInsurance function produces expected values',{
  # Test data based upon the following calcs:
  insuranceFor12000PerYear <- (12000-primaryThreshold)*standardRate
  insuranceFor60000PerYear <- (60000-upperEarningsLimit)*lowerRate + 
    (upperEarningsLimit-primaryThreshold)*standardRate
  #Tests
  expect_equal(employeesNationalInsurance(12000),insuranceFor12000PerYear)
  expect_equal(employeesNationalInsurance(60000),insuranceFor60000PerYear)
})

test_that('employersNationalInsurance function produces expected values',{
  # Test data based upon the following calcs:
  insuranceFor12000PerYear <- (12000-secondaryThreshold)*employerRate
  insuranceFor60000PerYear <- (60000-secondaryThreshold)*employerRate
  #Tests
  expect_equal(employersNationalInsurance(12000),insuranceFor12000PerYear)
  expect_equal(employersNationalInsurance(60000),insuranceFor60000PerYear)
})

test_that('Universal Credit Constants are correct',{
  expect_equal(ucMaximumAmount,371.8*12)
  expect_equal(ucHigherWorkAllowance,0)
  expect_equal(ucEarnedTaper,0.63)
  expect_equal(ucUnearnedTaper,1)
})

test_that('universalCredit function produces expected values',{
  expect_equal(universalCredit(0),ucMaximumAmount)
  expect_equal(universalCredit(1000),ucMaximumAmount-(1000*ucEarnedTaper))
  expect_equal(universalCredit(ucMaximumAmount/ucEarnedTaper),0)
  expect_equal(universalCredit(1000,1000),ucMaximumAmount-1000*ucEarnedTaper-1000*ucUnearnedTaper)
  expect_equal(universalCredit(0,ucMaximumAmount),0)
  expect_equal(universalCredit(ucMaximumAmount,ucMaximumAmount),0)
})


test_that('ukIncomeTaxDataFrame function has the correct shape',{
  incomeTaxDf <- ukIncomeTaxDataFrame()
  expect_length(incomeTaxDf$initialIncome,51)
  expect_length(incomeTaxDf$personalAllowance,51)
  expect_length(incomeTaxDf$incomeTax,51)
  expect_length(incomeTaxDf$employeesNationalInsurance,51)
  expect_length(incomeTaxDf$employersNationalInsurance,51)
  expect_length(incomeTaxDf$universalCreditEarned,51)
  expect_length(incomeTaxDf$universalCreditUnearned,51)
  expect_length(incomeTaxDf$finalIncomeEarned,51)
  expect_length(incomeTaxDf$finalIncomeUnearned,51)
})

test_that('ukIncomeDataFrame function produces correct values',{
  incomeTaxDf <- ukIncomeTaxDataFrame()
  expect_equal(incomeTaxDf$initialIncome[1],1)
  testPoint1 <- 5
  initialIncome1 <- incomeTaxDf$initialIncome[testPoint1]
  testPoint2 <-35
  initialIncome2 <- incomeTaxDf$initialIncome[testPoint2]
  expect_equal(incomeTaxDf$personalAllowance[testPoint2],
               personalAllowance(initialIncome2))
  expect_equal(incomeTaxDf$incomeTax[testPoint2],
               incomeTax(initialIncome2))
  expect_equal(incomeTaxDf$employeesNationalInsurance[testPoint2],
               employeesNationalInsurance(initialIncome2))
  expect_equal(incomeTaxDf$employersNationalInsurance[testPoint2],
               employersNationalInsurance(initialIncome2))
  expect_equal(incomeTaxDf$universalCreditEarned[testPoint1],
               universalCredit(initialIncome1))
  expect_equal(incomeTaxDf$universalCreditUnearned[testPoint1],
               universalCredit(0,initialIncome1))
  expect_equal(incomeTaxDf$finalIncomeEarned[testPoint1],
               initialIncome1 +
                 universalCredit(initialIncome1) -
                 incomeTax(initialIncome1) -
                 employeesNationalInsurance(initialIncome1)) 
  expect_equal(incomeTaxDf$finalIncomeUnearned[testPoint1],
               initialIncome1 +
               universalCredit(0,initialIncome1)-
                 incomeTax(initialIncome1))
})



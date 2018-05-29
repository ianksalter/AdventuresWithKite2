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
  expect_equal(incomeTax(43000)-6400)
  expect_equal(incomeTax(55000)-11200)
  expect_equal(incomeTax(120000)-41200)
  expect_equal(incomeTax(200000)-76100)
  expect_equal(incomeTax(500000)-211100)
})

test_that('incomeNetOfIncomeTax function produces expected values',{
  expect_equal(incomeNetOfIncomeTax(5000),5000)
  expect_equal(incomeNetOfIncomeTax(21000),19000)
})

test_that('bifitProportionTaxPaid function produces expected values',{
  expect_equal(bifitProportionTaxPaid(10400),0)
  expect_equal(bifitProportionTaxPaid(5000,1000,0.2),0)
})

test_that('employeesNationalInsurance function produces expected values',{
  # Test data from calculator here: http://iknowtax.com/2016/
  expect_true(abs(employeesNationalInsurance(12000)-472.8) < 1)
  expect_true(abs(employeesNationalInsurance(24000)-1912.8) < 1)
  # Test data from:
  # https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/634930/nic_sp_toolkit_2016-17.pdf
  expect_true(abs(employeesNationalInsurance(23920)-1903.2) < 1)
})

test_that('employersNationalInsurance function produces expected values',{
  # Test data from:
  # https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/634930/nic_sp_toolkit_2016-17.pdf
  expect_true(abs(employersNationalInsurance(23920)-2181.5) < 1)
})

test_that('nationalInsurance function produces expected values',{
  expect_equal(
    nationalInsurance(12000),
    employeesNationalInsurance(12000) + employersNationalInsurance(12000))
})


test_that('ukIncomeTaxDataFrame function has the correct shape',{
  incomeTaxDf <- ukIncomeTaxDataFrame()
  expect_length(incomeTaxDf$grossIncome,51)
  expect_length(incomeTaxDf$personalAllowance,51)
  expect_length(incomeTaxDf$incomeTax,51)
  expect_length(incomeTaxDf$incomeNetOfIncomeTax,51)
  expect_length(incomeTaxDf$nationalInsurance,51)
  expect_length(incomeTaxDf$incomeNetOfNationalInsurance,51)
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
  # expect_equal(incomeTaxDf$nationalInsurance[1],1)
  # expect_equal(incomeTaxDf$incomeNetOfNationalInsurance[1],1)
  # expect_equal(incomeTaxDf$incomeNetOfNationalInsuranceAndIncomeTax[1],1)
  # expect_equal(incomeTaxDf$taxCredits[1],1)
  # expect_equal(incomeTaxDf$netIncome[1],1)
})

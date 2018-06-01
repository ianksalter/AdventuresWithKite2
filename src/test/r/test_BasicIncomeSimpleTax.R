# Unit tests for the functions in the file BasicIncomeFlatIncomeTax.r

source("src/main/r/BasicIncomeSimpleTax.r")

library(testthat)

context('Testing Basic Income Flat Income Tax')

test_that('basicIncome function produces expected values',{
  expect_equal(basicIncome(1000),5200)
  expect_equal(basicIncome(1000,10000),10000)
})

test_that('simpleTax function produces expected values',{
  expect_equal(simpleTax(1000),500)
  expect_equal(simpleTax(1000,0.2),200)
})

test_that('bistIncome function produces expected values',{
  expect_equal(bistIncome(1000),5700)
  expect_equal(bistIncome(1000,1000,0.2),1800)
})

test_that('bistProportionTaxPaid function produces expected values',{
  expect_equal(bistProportionTaxPaid(10400),0)
  expect_equal(bistProportionTaxPaid(5000,1000,0.2),0)
})

test_that('bistDataFrame function produces correct structure',{
  bistDf <- bistDataFrame()
  expect_length(bistDf$initialIncome,11)
  expect_length(bistDf$basicIncome,11)
  expect_length(bistDf$simpleTax,11)
  expect_length(bistDf$bistIncome,11)
  expect_length(bistDf$bistProportionTaxPaid,11)
})

test_that('bistDataFrame function produces correct values',{
  bistDf <- bistDataFrame()
  expect_equal(bistDf$initialIncome[1],1)
  testPoint <- 5
  testIncome <- bistDf$initialIncome[testPoint]
  expect_equal(bistDf$basicIncome[testPoint],
               basicIncome(testIncome))
  expect_equal(bistDf$simpleTax[testPoint],
               simpleTax(testIncome))
  expect_equal(bistDf$bistIncome[testPoint],
               bistIncome(testIncome))
  expect_equal(bistDf$bistProportionTaxPaid[testPoint],
               bistProportionTaxPaid(testIncome))
})

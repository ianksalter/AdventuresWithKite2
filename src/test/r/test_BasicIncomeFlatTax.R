# Unit tests for the functions in the file BasicIncomeFlatIncomeTax.r

source("src/main/r/BasicIncomeFlatIncomeTax.r")

library(testthat)

context('Testing Basic Income Flat Income Tax')

test_that('basicIncome function produces expected values',{
  expect_equal(basicIncome(1000),5200)
  expect_equal(basicIncome(1000,10000),10000)
})

test_that('flatTaxIncome function produces expected values',{
  expect_equal(flatTaxIncome(1000),500)
  expect_equal(flatTaxIncome(1000,0.2),800)
})

test_that('bifitIncome function produces expected values',{
  expect_equal(bifitIncome(1000),5700)
  expect_equal(bifitIncome(1000,1000,0.2),1800)
})

test_that('bifitProportionTaxPaid function produces expected values',{
  expect_equal(bifitProportionTaxPaid(10400),0)
  expect_equal(bifitProportionTaxPaid(5000,1000,0.2),0)
})

test_that('bifitDataFrame function produces correct size frame',{
  bifitDF <- bifitDataFrame()
  expect_equal(ncol(bifitDF),5)
  expect_equal(nrow(bifitDF),11)
  bifitDF <- bifitDataFrame(1,101,2)
  expect_equal(ncol(bifitDF),5)
  expect_equal(nrow(bifitDF),51)
})

test_that('bifitDataFrame function produces correct values',{
  bifitDF <- bifitDataFrame()
  expect_equal(bifitDF[1,1],1)
  expect_equal(bifitDF[1,2],5200)
  expect_equal(bifitDF[1,3],0.5)
  expect_equal(bifitDF[1,4],5200.5)
  bifitDF <- bifitDataFrame(1,101,2,1000,0.2)
  expect_equal(bifitDF[2,1],3)
  expect_equal(bifitDF[2,2],1000)
  expect_equal(bifitDF[2,3],2.4)
  expect_equal(bifitDF[2,4],1002.4)
  bifitDF <- bifitDataFrame(1,11001,1)
  expect_equal(bifitDF[10400,5],0)
})

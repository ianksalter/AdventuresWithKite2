# Unit tests for the functions in the file RevenueAndCost.r

source("src/main/r/RevenueAndCost.R")

library(testthat)

context('Testing Revenue Income and Cost')

test_that('RevenueAndCost$amount method produces expected values',{
  testRevenueAndCost <- RevenueAndCost$new(
    amountFunction = function(income){1},
    population = 1,
    mean = 1,
    standardDeviation = 1
  )
  expect_equal(testRevenueAndCost$amount(1),
               testRevenueAndCost$population *
                 testRevenueAndCost$logNormalPDF(1) *
                 testRevenueAndCost$amountFunction(1))
})

test_that('RevenueAndCost$overallAmount method produces expected values',{
  testRevenueAndCost1 <- RevenueAndCost$new(
    amountFunction = function(income){1},
    population = 1,
    mean = 1,
    standardDeviation = 1
  )
  testRevenueAndCost2 <- RevenueAndCost$new(
    amountFunction = function(income){2},
    population = 1,
    mean = 1,
    standardDeviation = 1
  )
  expect_equal(testRevenueAndCost1$overallAmount()$value,1)
  expect_equal(testRevenueAndCost2$overallAmount()$value,2)
})
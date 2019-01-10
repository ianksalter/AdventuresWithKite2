# Unit tests for the functions in the file BasicIncomeSimpleTax.r




source("src/main/r/BasicIncomeSimpleTax.r")

library(testthat)

context('Testing Basic Income Flat Income Tax')

test_that('BasicIncomeSimpleTax$basicIncome method produces expected values',{
  expect_equal(defaultBist$basicIncome(1000),5200)
  bist10000Amount <- BasicIncomeSimpleTax$new(amount=10000)
  expect_equal(bist10000Amount$basicIncome(1000),10000)
})

test_that('BasicIncomeSimpleTax$simpleTax method produces expected values',{
  expect_equal(defaultBist$simpleTax(1000),500)
  bist0.2Rate <- BasicIncomeSimpleTax$new(rate=0.2) 
  expect_equal(bist0.2Rate$simpleTax(1000),200)
})

test_that('BasicIncomeSimpleTax$finalIncome method produces expected values',{
  expect_equal(defaultBist$finalIncome(1000),5700)
  bist1000Amount0.2Rate <- BasicIncomeSimpleTax$new(amount=1000,rate=0.2)  
  expect_equal(bist1000Amount0.2Rate$finalIncome(1000),1800)
})

test_that('BasicIncomeSimpleTax$taxProportion method produces expected values',{
  expect_equal(defaultBist$taxProportion(10400),0)
  bist1000Amount0.2Rate <- BasicIncomeSimpleTax$new(amount=1000,rate=0.2) 
  expect_equal(bist1000Amount0.2Rate$taxProportion(5000),0)
})

test_that('BasicIncomeSimpleTax$dataFrame method produces correct structure',{
  bistDf <- defaultBist$dataFrame()
  expect_length(bistDf$initialIncome,11)
  expect_length(bistDf$basicIncome,11)
  expect_length(bistDf$simpleTax,11)
  expect_length(bistDf$finalIncome,11)
  expect_length(bistDf$taxProportion,11)
})

test_that('BasicIncomeSimpleTax$dataFrame method produces correct values',{
  bistDf <- defaultBist$dataFrame()
  expect_equal(bistDf$initialIncome[1],1)
  testPoint <- 5
  testIncome <- bistDf$initialIncome[testPoint]
  expect_equal(bistDf$basicIncome[testPoint],
               defaultBist$basicIncome(testIncome))
  expect_equal(bistDf$simpleTax[testPoint],
               defaultBist$simpleTax(testIncome))
  expect_equal(bistDf$finalIncome[testPoint],
               defaultBist$finalIncome(testIncome))
  expect_equal(bistDf$taxProportion[testPoint],
               defaultBist$taxProportion(testIncome))
})

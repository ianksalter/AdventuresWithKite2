library(R6)
#' The Basic Income Simple Tax class
#'
#' This class describes the notion of a Basic Income Simple Tax (BIST).
#' @field amount The base amount of universal basic income.
#' @field rate The rate at which income is taxed.
#' @keywords uk income tax, personal allowance
#' @export
#' @examples
#' BasicIncomeSimpleTax
BasicIncomeSimpleTax <-R6Class("BasicIncomeSimpleTax",
  public = list(
    amount = NULL,
    rate = NULL,
    initialize = function (amount = 5200, rate = 0.5){
      self$amount <- amount
      self$rate <- rate
    },
    #' The Basic Income method
    #'
    #' The uiniversal income that everyone recieves regardless of income.
    #' @param income The initial income of the person.
    #' @keywords basic income
    #' @export
    #' @examples
    #' basicIncome()
    basicIncome = function(income){
      self$amount
    },
    #' The Simple Tax method
    #'
    #' The tax paid for a given income.
    #' @param income The initial income of the person.
    #' @keywords basic income
    #' @export
    #' @examples
    #' simpleTax()
    simpleTax = function(income){
      income*self$rate
    },
    #' The Final Income method
    #'
    #' The final income after basic income and simple tax.
    #' @param income The initial income of the person.
    #' @keywords basic income
    #' @export
    #' @examples
    #' finalIncome()
    finalIncome = function(income){
      income + self$basicIncome(income) - self$simpleTax(income)
    },
    #' Tax Proportion method
    #'
    #' This shows the the overall proportion of tax paid for each income.
    #' @param income The initial income of the person.
    #' @keywords basic income
    #' @export
    #' @examples
    #' taxProportion()
    taxProportion = function(income){
      (income - self$finalIncome(income))/income
    },
    #' The Data Frame method
    #'
    #' This method returns a data frame with the following columns based upon
    #' the tax and benefit structures:
    #' 1) initialIncome
    #' 2) basicIncome
    #' 3) simpleTax
    #' 4) bistIncome
    #' 5) proportionTaxPaid
    #' @param from The first point of initialIncome.
    #' @param to The final point of the initial Income in the frame.
    #' @param by The incriments by which initial income is increased in the frame.
    #' dataFrame()
    dataFrame = function(from=1,to=50001,by=5000){
      initialIncome <- seq(from,to,by)
      basicIncome <- sapply(initialIncome,self$basicIncome)
      simpleTax <- sapply(initialIncome,self$simpleTax)
      finalIncome <- sapply(initialIncome,self$finalIncome)
      taxProportion <- sapply(initialIncome,self$taxProportion)
      data.frame(initialIncome,
                 basicIncome,
                 simpleTax,
                 finalIncome,
                 taxProportion)
    }
  )
)

defaultBist <- BasicIncomeSimpleTax$new()
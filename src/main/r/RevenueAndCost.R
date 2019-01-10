library(R6)#' The Revenue and Cost class
#'
#' The Revenue and Cost class calculates revenue and cost for a tax
#' or benefit.
#' @field amountFunction Single varaible function for which the cost or benefit is being calculated.
#' @field population The no of people in the population who pay the tax or are entitled to the benefit.
#' @field mean The mean of the population income for a log normal distribution
#' @field standardDeviation The standard deviation of the population income for a log normal distribution
#' 
#' @keywords Tax Benefits Revenue Cost
#' @export
#' @examples
RevenueAndCost <-R6Class("RevenueAndCost",
  public = list(
   amountFunction = NULL,
   population = NULL,
   mean = NULL,
   standardDeviation = NULL,
   initialize = function (amountFunction = NA, population = NA,mean = NA, standardDeviation = NA){
     self$amountFunction <- amountFunction
     self$population <- population
     self$mean <- mean
     self$standardDeviation <- standardDeviation
   },
   #' The Amount method
   #'
   #' Returns the amount that the tax or benifit would raise or cost at a given income point
   #' @param income The initial income of the person.
   #' amount()
   amount = function(income){
     self$population * self$logNormalPDF(income) * self$amountFunction(income)
   },
   #' The Overall Amount method
   #'
   #' This gives the overall amount of cost or revenue of the system
   #' NOTE the function returns the list that results
   #' from integrating the amount function to access the amount use
   #' overallAmount()$value
   #' overallAmount()
   overallAmount = function(){
     integrate(self$amount,lower=0,upper=Inf)
   },
   #' The logNormalPDF method
   #'
   #' The probablity density function for the log normal distribution with
   #' given mean and standard deviation
   #' @param income The initial income of the person.
   #' logNormalPDF()
   logNormalPDF = function (x){
     (1/(x*self$standardDeviation*sqrt(2*pi)))*
       exp(-(log(x)-self$mean)^2/(2*self$standardDeviation^2))
   }
  )#,
  # private = list(
  # )
)
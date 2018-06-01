#' The Basic Income Function
#'
#' This function determines the universal basic income a person would
#' have given their income. Note as the income is universal this function
#' is a constant
#' @param income The initial income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @keywords BIST, basic income, simple tax
#' @export
#' @examples
#' basicIncome()
basicIncome <- function(income,amount=5200){
  amount
}

#' The Simple Tax Function
#'
#' This function determines the tax a person would pay under the 
#' Basic Income and Simple Tax system.
#' @param income The initial income of the person
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords BIST, simple tax
#' @export
#' @examples
#' simpleTax()
simpleTax <- function(income,rate=0.5){
  income * rate
}

#' The BIST Income Function
#'
#' This function determines the net amount of of income a person would
#' have under a basic income and simple tax system.
#' @param income The gross income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords BIST, basic income, simple tax
#' @export
#' @examples
#' bistIncome()
bistIncome<- function(income,amount=5200,rate=0.5){
  income + basicIncome(income,amount) - simpleTax(income,rate)
}

#' The BIST Proportion Tax Paid Function
#'
#' This function indicates the proportain of tax paid for each income level
#' have under a basic income simple tax system.
#' @param income The initial income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords BIST, basic income, simple tax, proportion
#' @export
#' @examples
#' bifitProportionTaxPaid()
#The proportion of tax paid
bistProportionTaxPaid <- function(income,amount=5200,rate=0.5){
  (income - bistIncome(income,amount,rate))/income
}

#' The BIST Data Frame function
#'
#' This function creates a data frame with the following colums
#' 1) initialIncome 
#' 2) basicIncome
#' 3) simpleTax
#' 4) bistIncome
#' 5) bistProportionTaxPaid
#' @param from The starting point for the income vector of the data frame. Defaults to 1.
#' @param to The ending point of the income vector of the data frame. Defaults to 50001.
#' @param by The increments of the income vector of the data frame. Defaukts to 5000.
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords BIST, basic income, simple tax
#' @export
#' @examples
#' bistDataFrame()
bistDataFrame <- function(from=1,to=50001,by=5000,amount=5200,rate=0.5) {
  initialIncome <- seq(from,to,by)
  basicIncome <- sapply(initialIncome,
                              function(income){basicIncome(income,amount)})
  simpleTax <- sapply(initialIncome,
                              function(income){simpleTax(income,rate)})
  bistIncome <- sapply(initialIncome,
                              function(income){bistIncome(income,amount,rate)})
  
  bistProportionTaxPaid <- sapply(initialIncome,
                                  function(income){bistProportionTaxPaid(income,amount,rate)})
  data.frame(initialIncome,
             basicIncome,
             simpleTax,
             bistIncome,
             bistProportionTaxPaid)
}

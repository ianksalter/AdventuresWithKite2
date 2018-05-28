#' The Basic Income Function
#'
#' This function determines the universal basic income a person would
#' have given their income. Note as the income is universal this function
#' is a constant
#' @param income The gross income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @keywords bifit, basic income, flat tax
#' @export
#' @examples
#' basicIncome()
basicIncome <- function(income,amount=5200){
  income - income + amount #Used to force vector operation wierd inint TODO: Find a better way.
}

#' The Flat Tax Income Function
#'
#' This function determines the net amount of of income a person would
#' have under a flat tax system.
#' @param income The gross income of the person
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords bifit, flat tax
#' @export
#' @examples
#' flatIncomeTax()
flatTaxIncome <- function(income,rate=0.5){
  income * (1 - rate)
}

#' The Bifit Income Function
#'
#' This function determines the net amount of of income a person would
#' have under a basic income flat incom tax - BIFIT system.
#' @param income The gross income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords bifit, basic income, flat tax
#' @export
#' @examples
#' bifitIncome()
bifitIncome<- function(income,amount=5200,rate=0.5){
  basicIncome(income,amount) + flatTaxIncome(income,rate)
}

#' The Bifit Proportion Tax Paid Function
#'
#' This function indicates the proportain of tax paid for each income level
#' have under a basic income flat incom tax - BIFIT system.
#' @param income The gross income of the person
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords bifit, basic income, flat tax, proportion
#' @export
#' @examples
#' bifitProportionTaxPaid()
#The proportion of tax paid
bifitProportionTaxPaid <- function(income,amount=5200,rate=0.5){
  (income - bifitIncome(income,amount,rate))/income
}

#' The BIFIT Data Frame function
#'
#' This function creates a data frame with the following colums
#' 1) income 
#' 2) basic income
#' 3) flat tax income
#' 4) bifit income
#' @param from The starting point for the income vector of the data frame. Defaults to 1.
#' @param to The ending point of the income vector of the data frame. Defaults to 50001.
#' @param by The increments of the income vector of the data frame. Defaukts to 5000.
#' @param amount The amount of income per year in the basic income scheme. Defaults to 5200 i.e 100 pw.
#' @param rate The rate at which income tax is paid. Defaults to 0.5 (in other words 50%)
#' @keywords bifit, basic income, flat tax
#' @export
#' @examples
#' basicIncomeDataFrame()
bifitDataFrame <- function(from=1,to=50001,by=5000,amount=5200,rate=0.5) {
  incomeVector <- seq(from,to,by)
  basicIncomeVector <- basicIncome(incomeVector,amount)
  flatTaxIncomeVector <- flatTaxIncome(incomeVector,rate)
  bifitIncomeVector <- bifitIncome(incomeVector,amount,rate)
  bifitProportionTaxPaidVector <- bifitProportionTaxPaid(incomeVector,amount,rate)
  data.frame(incomeVector,
             basicIncomeVector,
             flatTaxIncomeVector,
             bifitIncomeVector,
             bifitProportionTaxPaidVector)
}

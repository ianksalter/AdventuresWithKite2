# This file creates the first set of plots used to explain UK Income Tax structure for 2016 to 2017

# Reference the tax functions defined in the file
source("src/main/r/UKIncomeTax2016to2017.r")

#Generate the UK Income Tax Data Frame
ukIncomeTaxDF <- ukIncomeTaxDataFrame()

#Import plotting library
library(ggplot2)

# Create graph to plot income tax
# Set up plot axis
xAxisBreaks <- c(0,1,2,3,4,5)*10000
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*5000
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeTax)) +
  labs(x="Gross Income",y="Tax") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,50500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=48000,y=10500,label="Income Tax")
ggsave("plots/Income Tax.png")


# Create graph to plot income net of income tax
# Set up plot axis
xAxisBreaks <- c(0,1,2,3,4,5)*10000
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*5000
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfIncomeTax)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,50500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=45000,y=42500,label="Income Net of Income Tax")
ggsave("plots/Income Net of Income Tax.png")

# Generate a flat tax incomes data frame
incomeNetOfNationalInsuranceVector <- sapply(incomes,incomeNetOfNationalInsurance)
incomeNetOfNationalInsuranceDf <- data.frame(incomes,incomeNetOfNationalInsuranceVector)
incomeNetOfNationalInsuranceDf  


# Graph of National Insurance
ggplot(incomeNetOfNationalInsuranceDf) + 
  geom_line(aes(incomes,incomeNetOfNationalInsuranceVector)) +
  labs(x="Income",y="Income Net of National Insurance",title="Income Net of National Insurance 2016-20167 UK") +
  coord_cartesian(ylim=c(0,100000))
ggsave("plots/IncomeNetOfNationalInsurance.png")


incomeNetOfTaxAndNationalInsurance <- function(income){
  income - nationalInsurance(income) - incomeTax(income)
}

# Generate a flat tax incomes data frame
incomeNetOfTaxAndNationalInsuranceVector <- sapply(incomes,incomeNetOfTaxAndNationalInsurance)
incomeNetOfTaxAndNationalInsuranceDF <- data.frame(incomes,incomeNetOfTaxAndNationalInsuranceVector)
incomeNetOfTaxAndNationalInsuranceDF  


# Graph of Income after National Insurance
ggplot(incomeNetOfTaxAndNationalInsuranceDF) + 
  geom_line(aes(incomes,incomeNetOfTaxAndNationalInsuranceVector)) +
  labs(x="Income",y="Income Net of Tax and National Insurance",title="Income Net of Tax and National Insurance 2016-20167 UK") +
  coord_cartesian(ylim=c(0,100000))
ggsave("plots/IncomeNetOfTaxAndNationalInsurance.png")
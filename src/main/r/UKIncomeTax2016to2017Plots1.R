# This file creates the first set of plots used to explain UK Income Tax structure for 2016 to 2017

# Reference the tax functions defined in the file
source("src/main/r/UKIncomeTax2016to2017.r")



#Import plotting library
library(ggplot2)

#Generate the UK Income Tax Data Frame
ukIncomeTaxDF <- ukIncomeTaxDataFrame(to=160001,by=1000)

# Create Personal Allowance Plot
# Set up plot axis
xAxisBreaks <- seq(0,160000,20000)
yAxisBreaks <- seq(0,20000,1000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,personalAllowance)) +
  labs(x="Gross Income",y="Allowance") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,20500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=113000,y=11000,label="Personal Allowance")
ggsave("plots/PersonalAllowance.png")


# Create graph to plot income tax
# Set up plot axis
yAxisBreaks <-  seq(0,70000,10000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeTax)) +
  labs(x="Gross Income",y="Tax") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,70500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=152000,y=60500,label="Income Tax")
ggsave("plots/IncomeTax.png")

# Create graph to plot income net of income tax
# Set up plot axis
yAxisBreaks <-  seq(0,110000,10000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfIncomeTax)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,110500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=145000,y=104500,label="Income Net of Income Tax")
ggsave("plots/IncomeNetofIncomeTax.png")


# Create graph to plot income net of income tax vs no intervention
# Set up plot axis
yAxisBreaks <-  seq(0,160000,20000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfIncomeTax)) +
  geom_line(aes(grossIncome,grossIncome),linetype="dotted") +
  geom_ribbon(aes(x=grossIncome,ymin=incomeNetOfIncomeTax,ymax=grossIncome),fill="grey80") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,160500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=145000,y=104500,label="Income Net of Income Tax") +
  annotate("text",x=145000,y=156000,label="No Intervention")
ggsave("plots/IncomeNetofIncomeTaxVsNoIntervention.png")


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
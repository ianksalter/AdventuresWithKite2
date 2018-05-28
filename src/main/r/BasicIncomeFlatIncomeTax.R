# This file creates the functions and grphs for basic income and flat tax

#The basic income function
basicIncome <- function(income,amount=5200){
  income - income + amount #Used to force vector operation wierd inint TODO: Find a better way.
}

#Tests of basic income function
# TODO: Move to R Unit tests
basicIncome(1000)
basicIncome(1000) == 5200
# TODO: Add tests to basicIncome for non default parameters

#Generate a regular sequence of incomes from 1 to 100000 in increments of 5000
incomeVector <- seq(1,50001,5000)
incomeVector

# Generate a basic incomes data frame
basicIncomeVector <- basicIncome(incomeVector)
basicIncomeDf <- data.frame(incomeVector,basicIncomeVector)

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06

# Define lables that apear on the x and y axis 
xAxisBreaks <- c(0,1,2,3,4,5)*10000
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*1000

# Create graph for basic incomes
ggplot(basicIncomeDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,10000),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46300,y=5400,label="Basic Income (5200)")
ggsave("plots/BasicIncome.png")


#The flat tax function
flatTaxIncome <- function(income,rate=0.5){
  income * rate
}

# Generate a flat tax incomes data frame
flatIncomeTaxVector <- flatTaxIncome(incomeVector)
flatTaxIncomeDf <- data.frame(incomeVector,basicIncomeVector,flatIncomeTaxVector)


# make y axis lables wider 
yAxisBreaks <- c(0,1,2,3,4,5)*5000

# Create graph for flat tax incomes
ggplot(flatTaxIncomeDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) + 
  geom_line(aes(incomeVector,flatIncomeTaxVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,26000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46300,y=5800,label="Basic Income (5200)") +
  annotate("text",x=47500,y=25500,label="Flat Tax (0.5)")
ggsave("plots/FlatTaxIncome.png")

#The bifit (Basic Income Flat Income Tax) function
bifitIncome<- function(income,amount=5200,rate=0.5){
  basicIncome(income,amount) + flatTaxIncome(income,rate)
}

# Generate a bifit incomes vector corresponding to the incomes in the incomes vector
bifitIncomeVector <- bifitIncome(incomeVector)

# Generate a straight line called without bifit
withoutBifit <- incomeVector

# Bifit Data Frame
bifitIncomesDf <- data.frame(incomeVector,basicIncomeVector,flatIncomeTaxVector,bifitIncomeVector, withoutBifit)
bifitIncomesDf

# make more y axis lables
yAxisBreaks <- c(0,1,2,3,4,5,6,7)*5000

# Create graph for BIFIT
ggplot(bifitIncomesDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) + 
  geom_line(aes(incomeVector,flatIncomeTaxVector)) + 
  geom_line(aes(incomeVector,bifitIncomeVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,35000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46000,y=6000,label="Basic Income (5200)") +
  annotate("text",x=47200,y=26000,label="Flat Tax (0.5)") +
  annotate("text",x=40000,y=31100,label="BIFIT (5200, 0.5) = Basic Income (5200) + Flat Tax (0.5)")
ggsave("plots/Bifit.png")

# make more y axis lables
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*5000

# Create graph for dflat tax incomes
ggplot(bifitIncomesDf) + 
  geom_line(aes(incomeVector,bifitIncomeVector)) +
  geom_line(aes(incomeVector,withoutBifit),linetype="dotted") +
  geom_ribbon(aes(x=incomeVector,ymin=bifitIncomeVector,ymax=withoutBifit),fill="grey80") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,55000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks)+
  annotate("text",x=47000,y=31100,label="BIFIT (5200, 0.5)")+
  annotate("text",x=47000,y=50500,label="No Intervention")
ggsave("plots/BifitVsOnIntervention.png")

# Percentage of tax paid at each income level

#The proportion of tax paid
bifitProportionTaxPaid <- function(income,amount=5200,rate=0.5){
  (income - bifitIncome(income,amount,rate))/income
}

# Data Frame for proportion tax paind
fineGrainedIncomes <- seq(1,50001,100)
bifitProportionTaxPaidVector <- bifitProportionTaxPaid(fineGrainedIncomes)
proportionTaxPaidDf <- data.frame(fineGrainedIncomes,bifitProportionTaxPaidVector)
proportionTaxPaidDf

# make more y axis lables
yAxisBreaks <- seq(-1,0.6,0.1)

# Create graph for prportion of tax paid
ggplot(proportionTaxPaidDf) + 
  geom_line(aes(fineGrainedIncomes,bifitProportionTaxPaidVector)) +
  labs(x="Income",y="Proportion of Income Paid in Tax") +
  coord_cartesian(xlim=c(0,50700),ylim=c(-1,0.6),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) +
  scale_y_continuous(breaks = yAxisBreaks)
ggsave("plots/BifitProportionTaxPaid.png")

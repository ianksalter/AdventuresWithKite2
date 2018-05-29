# This file creates the first set of plots used to define BIFIT - Basic Income Flat Income Tax

# Reference the basic income functions defined in the file
source("src/main/r/BasicIncomeFlatIncomeTax.r")

# Generate a basic income flat income tax (bifit) data frame using default settings
bifitDf <- bifitDataFrame()

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06

# Create graph for basic incomes
# Define lables that apear on the x and y axis 
xAxisBreaks <- seq(0,50000,10000)
#TODO: Change y access breaks to seq operations
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*1000
#Create plot
ggplot(bifitDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,10000),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46300,y=5400,label="Basic Income (5200)")
ggsave("plots/BasicIncome.png")

# Create graph for flat tax incomes with basic incomes
# make y axis lables wider 
yAxisBreaks <- c(0,1,2,3,4,5)*5000
#create plot
ggplot(bifitDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) + 
  geom_line(aes(incomeVector,flatTaxIncomeVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,26000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46300,y=5800,label="Basic Income (5200)") +
  annotate("text",x=47500,y=25500,label="Flat Tax (0.5)")
ggsave("plots/FlatTaxIncome.png")

# Create graph for BIFIT
# make more y axis lables
yAxisBreaks <- c(0,1,2,3,4,5,6,7)*5000
#create plot
ggplot(bifitDf) + 
  geom_line(aes(incomeVector,basicIncomeVector)) + 
  geom_line(aes(incomeVector,flatTaxIncomeVector)) + 
  geom_line(aes(incomeVector,bifitIncomeVector)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,35000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=46000,y=6000,label="Basic Income (5200)") +
  annotate("text",x=47200,y=26000,label="Flat Tax (0.5)") +
  annotate("text",x=40000,y=31100,label="BIFIT (5200, 0.5) = Basic Income (5200) + Flat Tax (0.5)")
ggsave("plots/Bifit.png")

# Create graph of bifit income against no intervention
# make more y axis lables
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*5000
#create plot
ggplot(bifitDf) + 
  geom_line(aes(incomeVector,bifitIncomeVector)) +
  geom_line(aes(incomeVector,incomeVector),linetype="dotted") +
  geom_ribbon(aes(x=incomeVector,ymin=bifitIncomeVector,ymax=incomeVector),fill="grey80") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,55000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=47000,y=31100,label="BIFIT (5200, 0.5)") +
  annotate("text",x=47000,y=50500,label="No Intervention")
ggsave("plots/BifitVsNoIntervention.png")

# Create graph of bifit income against no intervention with fixed point
# make more axis lables
yAxisBreaks <- c(0,1,2,3,4,5,6,7,8,9,10)*5000
#create plot
ggplot(bifitDf) + 
  geom_line(aes(incomeVector,bifitIncomeVector)) +
  geom_line(aes(incomeVector,incomeVector),linetype="dotted") +
  geom_ribbon(aes(x=incomeVector,ymin=bifitIncomeVector,ymax=incomeVector),fill="grey80") +
  geom_vline(xintercept=10400,linetype="dashed") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,50700),ylim=c(0,55000),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=47000,y=31100,label="BIFIT (5200, 0.5)") +
  annotate("text",x=47000,y=50500,label="No Intervention") +
  annotate("text",x=11400,y=900,label="10400",size=3)
ggsave("plots/BifitFixedPoint.png")

# Create a plot of percentage of tax paid at each income level
proportionTaxPaidDf <- bifitDataFrame(1,50001,100)
# make more axis lables
yAxisBreaks <- seq(-1,0.6,0.1)
# create plot
ggplot(proportionTaxPaidDf) + 
  geom_line(aes(incomeVector,bifitProportionTaxPaidVector)) +
  labs(x="Income",y="Proportion of Income Paid in Tax") +
  coord_cartesian(xlim=c(0,50700),ylim=c(-1,0.6),expand = FALSE) +
  scale_x_continuous(breaks = xAxisBreaks) +
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=44500,y=0.44,label="ProportionTaxPaid (5200, 0.5)")
ggsave("plots/BifitProportionTaxPaid.png")

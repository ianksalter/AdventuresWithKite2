# This file creates the first set of plots used to define BIFIT - Basic Income Flat Income Tax

# Reference the basic income functions defined in the file
source("src/main/r/BasicIncomeSimpleTax.r")
source("src/main/r/CommonGraphics.r")

# Generate a basic income flat income tax (bifit) data frame using default settings
bistDf <- bistDataFrame()

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06



# Create graph of income with out tax or benifits
ggplotBist(bistDf,45000,5000,45000,5000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome), fill="grey70") + 
  geom_line(aes(y=initialIncome)) +
  scale_fill_manual(name="",values = c("Basic Income"="grey80")) +
  labs(x="Initial Income",y="Income Without Tax or Benefits")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/IncomeWithoutTaxOrBenefit.png")

# Create graph of basic incomes
ggplotBist(bistDf,45000,5000,50000,5000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome + basicIncome), fill="grey70") +
  geom_area(aes(y=basicIncome, fill="Basic Income")) +  
  geom_line(aes(y=initialIncome + basicIncome)) +
  scale_fill_manual(name="",values = c("Basic Income"="grey80")) +
  labs(x="Initial Income",y="Initial Income with Basic Income (5200)")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/BasicIncome.png")

# Create graph of income after simple tax
ggplotBist(bistDf,45000,5000,50000,5000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome, fill="Simple Tax")) + 
  geom_area(aes(y=initialIncome - simpleTax), fill="grey70") + 
  geom_line(aes(y=initialIncome - simpleTax)) +
  scale_fill_manual(name="",values = c("Simple Tax"="grey80")) +
  labs(x="Initial Income",y="Initial Income less Simple Tax (0.5)")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/SimpleTax.png")


# Create graph for bistIncome
ggplotBist(bistDf,45000,5000,50000,5000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome + basicIncome,fill="1 Simple Tax")) + 
  geom_area(aes(y=bistIncome),fill="grey80") + 
  geom_area(aes(y=basicIncome, fill="2 Basic Income")) +  
  geom_line(aes(y=bistIncome)) +
  scale_fill_manual(name="",values = c("2 Basic Income"="grey70","1 Simple Tax"="grey90")) +
  labs(x="Initial Income",y="Basic Income Simple Tax BIST (5200,0.5)")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/BasicIncomeSimpleTax.png")

# Create Graph of Final vs Initial Income under BIST
ggplotBist(bistDf,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistIncome,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=bistIncome)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  labs(x="Initial Income",y="Final Income under BIST (amount=5200, rate=0.5)")
ggsave("plots/BISTFinalVsInitialIncome.png")

# Create Graph of Final vs Initial Income under BIST with the Fixed Point
ggplotBist(bistDf,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistIncome,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=bistIncome)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  geom_vline(xintercept=10400,linetype="dashed") +
  labs(x="Initial Income",y="Final Income under BIST (amount=5200, rate=0.5)") +
  annotate("text",x=11400,y=900,label="10400",size=3)
ggsave("plots/BISTFinalVsInitialIncomeFixedPoint.png")


# Create a plot of percentage of tax paid at each income level
# Create a finer grained version of the BIST Data Frame
fineBistDf <- bistDataFrame(by=100)
ggplotBist(fineBistDf,50000,5000,1,0.1) + 
  geom_line(aes(initialIncome,bistProportionTaxPaid)) +
  labs(x="Income",y="Proportion of Income Paid in Tax")
ggsave("plots/BISTProportionTaxPaid.png")

# This file creates the first set of plots used to explain UK Income Tax structure for 2016 to 2017

# Reference the tax functions defined in the file
source("src/main/r/UKTaxAndBenefits2017to2018.r")
source("src/main/r/CommonGraphics.r")
source("src/main/r/BasicIncomeSimpleTax.r")

#Import plotting library
library(ggplot2)

#Generate the UK Income Tax Data Frame
ukIncomeTaxDF <- ukIncomeTaxDataFrame(to=170001,by=1000)

   

# Create graph to plot income tax
ggplotBist(ukIncomeTaxDF,160000,20000,70000,10000) + 
  geom_line(aes(initialIncome,incomeTax)) +
  labs(x="Initial Income",y="Income Tax")
ggsave("plots/IncomeTax.png")

# Create graph to plot initial income less income tax
ggplotBist(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome,fill="Income Tax")) + 
  geom_area(aes(y=initialIncome-incomeTax), fill="grey70") + 
  geom_line(aes(y=initialIncome - incomeTax)) +
  scale_fill_manual(name="",values = c("Income Tax"="grey80")) +
  labs(x="Initial Income",y="Income After Income Tax")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/InitialIncomeLessIncomeTax.png")

# Create graph to plot employees national insurance
ggplotBist(ukIncomeTaxDF,160000,20000,7000,1000) + 
  geom_line(aes(initialIncome,employeesNationalInsurance)) +
  labs(x="Initial Income",y="Employees National Insurance")
ggsave("plots/EmployeesNationalInsurance.png")

# Create graph to plot gross income less employeees national insurance
ggplotBist(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome,fill="Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance), fill="grey70") + 
  geom_line(aes(y=initialIncome - employeesNationalInsurance)) +
  scale_fill_manual(name="",values = c("Employees NI"="grey80")) +
  labs(x="Initial Income",y="Income After Employees NI")  +
  theme(legend.position=c(0.15, 0.9))
ggsave("plots/InitialIncomeLessEmployeesNI.png")


# Create graph to plot initial income with adjustments for
#   Income Tax
#   Employees National Insurance
ggplotBist(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) +
  geom_area(aes(y=initialIncome,fill="1 Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance,fill="2 Income Tax")) + 
  geom_area(aes(y=initialIncome-incomeTax-employeesNationalInsurance), fill="grey70") + 
  geom_line(aes(y=initialIncome - employeesNationalInsurance - incomeTax)) + 
  scale_fill_manual(name="",values = c("1 Employees NI"="grey90","2 Income Tax"="grey80")) +
  labs(x="Initial Income",y="Income After Employees NI & Tax")  +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/InitialIncomeLessTaxAndEmployeesNI.png")  

# Create graph to plot employers national insurance
ggplotBist(ukIncomeTaxDF,160000,20000,25000,5000) + 
  geom_line(aes(initialIncome,employersNationalInsurance)) +
  labs(x="Initial Income",y="Employers National Insurance")
ggsave("plots/EmployersNationalInsurance.png")

#Create a finer graned data smaller data frame for Universal Credit Graphs
ukIncomeTaxDFStart <- ukIncomeTaxDataFrame(to=10001,by=10)

# Create graph to plot universal credit
ggplotBist(ukIncomeTaxDFStart,8000,1000,5000,500) +
  geom_line(aes(initialIncome,universalCreditEarned)) +
  labs(x="Initial Income",y="Universal Credit after Earned Initial Income")
ggsave("plots/UniversalCreditEarned.png")

# Create graph to plot initial income plusearned universal credit
ggplotBist(ukIncomeTaxDFStart,8000,1000,8000,1000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=universalCreditEarned+initialIncome,ymax=initialIncome,fill="Universal Credit")) +
  geom_line(aes(y=universalCreditEarned+initialIncome)) +
  scale_fill_manual(name="",values = c("Universal Credit"="grey90")) +
  labs(x="Initial Earned Income",y="Initial Earned Income with Universal Credit") +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/EarnedIncomePlusUniversalCredit.png")

# Create graph to plot gross income with adjustments for
#   Income Tax
#   Employees National Insurance
#   Universal Credit
ggplotBist(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  #geom_ribbon(aes(x=initialIncome,ymin=universalCreditEarned+initialIncome,ymax=initialIncome,fill="1 Universal Credit")) +
  geom_area(aes(y=initialIncome,fill="1 Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance,fill="2 Income Tax")) + 
  geom_area(aes(y=finalIncomeEarned), fill="grey70") + 
  geom_area(aes(y=universalCreditEarned, fill="3 Universal Credit")) + 
  geom_line(aes(y=finalIncomeEarned)) + 
  scale_fill_manual(name="",values = c("3 Universal Credit"="grey60",
                                       "1 Employees NI"="grey90",
                                       "2 Income Tax"="grey80")) +
  labs(x="Initial Earned Income",y="Final Income")  +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/FinalIncomeEarned.png")

# Create Graph of Final vs Initial Income based upon Earned Income
ggplotBist(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=finalIncomeEarned,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=finalIncomeEarned)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  labs(x="Initial Earned Income",y="Final Income")
ggsave("plots/FinalvsInitialIncome.png")



#Generate a bigger UK Income Tax Data Frame
#Simulation of final income using BIST
bistFinalIncomeSimulation1 <- sapply(ukIncomeTaxDF$initialIncome,function(income){bistIncome(income,4461.6,0.37)})

# Create Graph of Final vs Initial Income based upon Earned Income simulated using BIST
ggplotBist(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation1,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation1)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  labs(x="Initial Earned Income",y="Final Income BIST Simulation (amount=4461.6, rate=0.37)")
ggsave("plots/FinalIncomeBISTSimulation.png")

# Create Graph of Final Income compared to its simulation via BIST
ggplotBist(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation1,ymax=finalIncomeEarned),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation1)) + 
  geom_line(aes(y=finalIncomeEarned),linetype="dotted") +
  labs(x="Initial Earned Income",y="BIST Simulation 1 (amount=4461.6, rate=0.37)")
ggsave("plots/FinalIncomevsBISTSimulation1.png")

#Generate a bigger UK Income Tax Data Frame
# Second Simulation of final income using BIST
bistFinalIncomeSimulation2 <- sapply(ukIncomeTaxDF$initialIncome,function(income){bistIncome(income,10400,0.47)})

# Create Graph of Final Income compared to its simulation via BIST
ggplotBist(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation2,ymax=finalIncomeEarned),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation2)) + 
  geom_line(aes(y=finalIncomeEarned),linetype="dotted") +
  labs(x="Initial Earned Income",y="BIST Simulation 2 (amount=10400, rate=0.47)")
ggsave("plots/FinalIncomevsBISTSimulation2.png")

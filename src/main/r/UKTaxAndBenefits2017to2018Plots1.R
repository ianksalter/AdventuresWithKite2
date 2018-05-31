# This file creates the first set of plots used to explain UK Income Tax structure for 2016 to 2017

# Reference the tax functions defined in the file
source("src/main/r/UKTaxAndBenefits2017to2018.r")
source("src/main/r/BasicIncomeFlatIncomeTax.r")

#Import plotting library
library(ggplot2)

#' The ggplotTax sets up a standard plot format for all tax plots
#'
#' This function sets up the common coordinates and axis number displays for all tax plots 
#' @param frame The data frame the plot is built upon
#' @param xAxisLimit The x axis starts at 0 and ends at the xAxisLimit + half an xTick padding
#' @param xAxisTick Distance between displayed numbers on the x axis
#' @param yAxisLimit The y axis starts at 0 and ends at the yAxisLimit + half a yTick padding
#' @param yAxisTick Distance between displayed numbers on the y axis
#' @keywords dataFrame, plot, axis, ticks
#' @export
#' @examples
#' ggplotTax()
ggplotTax <- function(frame,xAxisLimit,xAxisTick,yAxisLimit,yAxisTick,mapping=aes()){
  xPaddingRight <- xAxisTick/2
  yPaddingTop <- yAxisTick/2
  ggplot(frame,mapping) +
    coord_cartesian(
      xlim=c(0,xAxisLimit + xPaddingRight),
      ylim=c(0,yAxisLimit + yPaddingTop),
      expand = FALSE) + 
    scale_x_continuous(breaks = seq(0,xAxisLimit,xAxisTick)) + 
    scale_y_continuous(breaks = seq(0,yAxisLimit,yAxisTick))
}

#Generate the UK Income Tax Data Frame
ukIncomeTaxDF <- ukIncomeTaxDataFrame(to=170001,by=1000)

# Create Personal Allowance Plot
ggplotTax(ukIncomeTaxDF,160000,20000,12000,1000) + 
  geom_line(aes(initialIncome,personalAllowance)) +
  labs(x="Initial Income",y="Personal Allowance")
ggsave("plots/PersonalAllowance.png")

# Create graph to plot income tax
ggplotTax(ukIncomeTaxDF,160000,20000,70000,10000) + 
  geom_line(aes(initialIncome,incomeTax)) +
  labs(x="Initial Income",y="Income Tax")
ggsave("plots/IncomeTax.png")

# Create graph to plot initial income less income tax
ggplotTax(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome,fill="Income Tax")) + 
  geom_area(aes(y=initialIncome-incomeTax, fill="Income less Income Tax")) + 
  geom_line(aes(y=initialIncome - incomeTax)) + 
  geom_line(aes(initialIncome,initialIncome),linetype="dotted") +
  scale_fill_manual(name="",values = c("Income Tax"="grey80","Income less Income Tax"="grey70")) +
  labs(x="Initial Income",y="Income After Income Tax")  +
  theme(legend.position=c(0.1, 0.9))
ggsave("plots/InitialIncomeLessIncomeTax.png")

# Create graph to plot employees national insurance
ggplotTax(ukIncomeTaxDF,160000,20000,7000,1000) + 
  geom_line(aes(initialIncome,employeesNationalInsurance)) +
  labs(x="Initial Income",y="Employees National Insurance")
ggsave("plots/EmployeesNationalInsurance.png")

# Create graph to plot gross income less employeees national insurance
ggplotTax(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) + 
  geom_area(aes(y=initialIncome,fill="Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance, fill="Income less Employees NI")) + 
  geom_line(aes(y=initialIncome - employeesNationalInsurance)) + 
  geom_line(aes(initialIncome,initialIncome),linetype="dotted") +
  scale_fill_manual(name="",values = c("Employees NI"="grey80","Income less Employees NI"="grey70")) +
  labs(x="Initial Income",y="Income After Employees NI")  +
  theme(legend.position=c(0.15, 0.9))
ggsave("plots/InitialIncomeLessEmployeesNI.png")


# Create graph to plot initial income with adjustments for
#   Income Tax
#   Employees National Insurance
ggplotTax(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) +
  geom_area(aes(y=initialIncome,fill="Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance,fill="Income Tax")) + 
  geom_area(aes(y=initialIncome-incomeTax-employeesNationalInsurance, fill="Income less Tax & Employees NI")) + 
  geom_line(aes(y=initialIncome - employeesNationalInsurance - incomeTax)) + 
  geom_line(aes(initialIncome,initialIncome),linetype="dotted") +
  scale_fill_manual(name="",values = c("Employees NI"="grey90",
                                       "Income Tax"="grey80",
                                       "Income less Tax & Employees NI"="grey70")) +
  labs(x="Initial Income",y="Income After Employees NI & Tax")  +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/InitialIncomeLessTaxAndEmployeesNI.png")  

# Create graph to plot employers national insurance
ggplotTax(ukIncomeTaxDF,160000,20000,25000,5000) + 
  geom_line(aes(initialIncome,employersNationalInsurance)) +
  labs(x="Initial Income",y="Amount") +
  annotate("text",x=142000,y=21750,label="Employers National Insurance")
ggsave("plots/EmployersNationalInsurance.png")

#Create a finer graned data smaller data frame for Universal Credit Graphs
ukIncomeTaxDFStart <- ukIncomeTaxDataFrame(to=10001,by=10)

# Create graph to plot universal credit
ggplotTax(ukIncomeTaxDFStart,8000,1000,5000,500) +
  geom_line(aes(initialIncome,universalCreditEarned)) +
  labs(x="Initial Income",y="Universal Credit after Earned Initial Income")
ggsave("plots/UniversalCreditEarned.png")

# Create graph to plot initial income plusearned universal credit
ggplotTax(ukIncomeTaxDFStart,8000,1000,8000,1000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=universalCreditEarned+initialIncome,ymax=initialIncome,fill="Universal Credit")) +
  geom_line(aes(y=universalCreditEarned+initialIncome)) +
  geom_line(aes(y=initialIncome),linetype="dotted") +
  scale_fill_manual(name="",values = c("Universal Credit"="grey90")) +
  labs(x="Initial Earned Income",y="Initial Earned Income with Universal Credit") +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/EarnedIncomePlusUniversalCredit.png")

# Create graph to plot gross income with adjustments for
#   Income Tax
#   Employees National Insurance
#   Universal Credit
ggplotTax(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=universalCreditEarned+initialIncome,ymax=initialIncome,fill="1 Universal Credit")) +
  geom_area(aes(y=initialIncome,fill="2 Employees NI")) + 
  geom_area(aes(y=initialIncome-employeesNationalInsurance,fill="3 Income Tax")) + 
  geom_area(aes(y=initialIncome-incomeTax-employeesNationalInsurance), fill="grey60") + 
  geom_line(aes(y=finalIncomeEarned)) + 
  geom_line(aes(initialIncome,initialIncome),linetype="dotted") +
  scale_fill_manual(name="",values = c("1 Universal Credit"="grey90",
                                       "2 Employees NI"="grey80",
                                       "3 Income Tax"="grey70")) +
  labs(x="Initial Earned Income",y="Final Income")  +
  theme(legend.position=c(0.2, 0.85))
ggsave("plots/FinalIncomeEarned.png")

# Create Graph of Final vs Initial Income based upon Earned Income
ggplotTax(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=finalIncomeEarned,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=finalIncomeEarned)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  labs(x="Initial Earned Income",y="Final Income")
ggsave("plots/FinalvsInitialIncome.png")



#Generate a bigger UK Income Tax Data Frame
#Simulation of final income using BIST
bistFinalIncomeSimulation1 <- sapply(ukIncomeTaxDF$initialIncome,function(income){bifitIncome(income,4461.6,0.37)})

# Create Graph of Final vs Initial Income based upon Earned Income simulated using BIST
ggplotTax(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation1,ymax=initialIncome),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation1)) + 
  geom_line(aes(y=initialIncome),linetype="dotted") +
  labs(x="Initial Earned Income",y="Final Income BIST Simulation (amount=4461.6, rate=0.37)")
ggsave("plots/FinalIncomeBISTSimulation.png")

# Create Graph of Final Income compared to its simulation via BIST
ggplotTax(ukIncomeTaxDF,50000,5000,50000,5000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation1,ymax=finalIncomeEarned),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation1)) + 
  geom_line(aes(y=finalIncomeEarned),linetype="dotted") +
  labs(x="Initial Earned Income",y="BIST Simulation 1 (amount=4461.6, rate=0.37)")
ggsave("plots/FinalIncomevsBISTSimulation1.png")

#Generate a bigger UK Income Tax Data Frame
# Second Simulation of final income using BIST
bistFinalIncomeSimulation2 <- sapply(ukIncomeTaxDF$initialIncome,function(income){bifitIncome(income,10400,0.47)})

# Create Graph of Final Income compared to its simulation via BIST
ggplotTax(ukIncomeTaxDF,160000,20000,160000,20000,aes(x=initialIncome)) +
  geom_ribbon(aes(x=initialIncome,ymin=bistFinalIncomeSimulation2,ymax=finalIncomeEarned),fill="grey90") +
  geom_line(aes(y=bistFinalIncomeSimulation2)) + 
  geom_line(aes(y=finalIncomeEarned),linetype="dotted") +
  labs(x="Initial Earned Income",y="BIST Simulation 2 (amount=10400, rate=0.47)")
ggsave("plots/FinalIncomevsBISTSimulation2.png")

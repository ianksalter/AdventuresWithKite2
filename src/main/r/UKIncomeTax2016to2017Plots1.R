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
  labs(x="Gross Income",y="Amount") +
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
  annotate("text",x=145000,y=156000,label="Gross Income")
ggsave("plots/GrossIncomeLessIncomeTax.png")


# Create graph to plot employees national insurance
# Set up plot axis
yAxisBreaks <-  seq(0,7000,1000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,employeesNationalInsurance)) +
  labs(x="Gross Income",y="Amount") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,7100),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=142000,y=6750,label="Employees National Insurance")
ggsave("plots/EmployeesNationalInsurance.png")

# Create graph to plot income net of employees national insurance
# Set up plot axis
yAxisBreaks <-  seq(0,160000,10000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfEmployeesNationalInsurance)) +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,160500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=135000,y=157000,label="Income Net of Employees National Insurance")
ggsave("plots/IncomeNetofEmployeesNationalInsurance.png")

# Create graph to plot income net of employees national insurance vs no intervention
# Set up plot axis
yAxisBreaks <-  seq(0,160000,20000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfEmployeesNationalInsurance)) +
  geom_line(aes(grossIncome,grossIncome),linetype="dotted") +
  geom_ribbon(aes(x=grossIncome,ymin=incomeNetOfEmployeesNationalInsurance,ymax=grossIncome),fill="grey80") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,160500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=135000,y=104500,label="Income Net of National Insurance") +
  annotate("text",x=145000,y=156000,label="Gross Income")
ggsave("plots/GrossIncomeLessEmployeesNI.png")


# Create graph to plot income net of income tax employees national insurance vs no intervention
# Set up plot axis
yAxisBreaks <-  seq(0,160000,20000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,incomeNetOfIncomeTax)) + 
  geom_line(aes(grossIncome,incomeNetOfNationalInsuranceAndIncomeTax)) +
  geom_line(aes(grossIncome,grossIncome),linetype="dotted") +
  geom_ribbon(aes(x=grossIncome,
                  ymin=incomeNetOfIncomeTax,
                  ymax=grossIncome),fill="grey80")+
  geom_ribbon(aes(x=grossIncome,
                  ymin=incomeNetOfNationalInsuranceAndIncomeTax,
                  ymax=incomeNetOfIncomeTax),fill="grey70") +
  labs(x="Gross Income",y="Net Income") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,160500),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  geom_label(x=135000,y=104500,label="Income Tax") +
  geom_label(x=140000,y=75000,label="Employees National Insurance") +
  annotate("text",x=134000,y=64500,label="Income Net of Tax and National Insurance") +
  annotate("text",x=145000,y=156000,label="Gross Income")
ggsave("plots/GrossIncomeLessTaxAndEmployeesNI.png")

# Create graph to plot employers national insurance
# Set up plot axis
yAxisBreaks <-  seq(0,25000,5000)
# create plot
ggplot(ukIncomeTaxDF) + 
  geom_line(aes(grossIncome,employersNationalInsurance)) +
  labs(x="Gross Income",y="Amount") +
  coord_cartesian(xlim=c(0,160700),ylim=c(0,25100),expand = FALSE) + 
  scale_x_continuous(breaks = xAxisBreaks) + 
  scale_y_continuous(breaks = yAxisBreaks) +
  annotate("text",x=142000,y=21750,label="Employers National Insurance")
ggsave("plots/EmployersNationalInsurance.png")


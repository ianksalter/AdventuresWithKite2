# This file creates a plots used to show how BIST relates to human subsistance and ecological footprint.

# Reference the basic income functions defined in the file
source("src/main/r/BasicIncomeSimpleTax.r")
source("src/main/r/CommonGraphics.r")

# Generate a basic income flat income tax (bifit) data frame using default settings
bistDf <- defaultBist$dataFrame()

#Import plotting library
library(ggplot2)
options(scipen=999)  # turn off scientific notation like 1e+06

# Create Graph of Final vs Initial Income under BIST with illustration of subsistance and ecological footprint
ggplot(bistDf,aes(x=initialIncome)) +
  coord_cartesian(
    xlim=c(0,40000 + 0),
    ylim=c(0,40000 + 0),
    expand = FALSE) +
    theme(axis.text.x= element_blank(),axis.ticks.x = element_blank(),
          axis.text.y = element_blank(),axis.ticks.y = element_blank()) +
    geom_ribbon(aes(x=initialIncome,ymin=finalIncome,ymax=initialIncome),fill="grey90") +
    geom_line(aes(y=finalIncome)) +
    geom_line(aes(y=initialIncome),linetype="dotted") +
    geom_hline(yintercept=3400,linetype="dashed",color="grey60") +
    annotate("text",x=1500 , y=4400, label="Subsistence",size=3,color="grey60") +
    geom_hline(yintercept=15400,linetype="dashed",color="grey60") +
    annotate("text",x=6500 , y=16400, label="Sustainable Footprint (1 global hectare / world polulation)",size=3,color="grey60") +
    labs(x="Initial Income",y="Final Income")
ggsave("plots/BISTSubsistanceAndEcologicalFootprint.png")
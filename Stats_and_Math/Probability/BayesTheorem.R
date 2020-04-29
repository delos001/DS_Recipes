
# Bayes' Theorem Calculation
# What is the probability a hospital is a for profit hospital if it is in MW?
# Refer to Section 4.8 for the formula used in this example.  The numerator in 
#   that formula gives us intersection probability for a MW for-profit hospital.
# The denominator sums up the intersection probabilities to provide the 
#   probability of a MW hospital


# EXAMPLE 1

hospital <- read.csv(file.path("c:/RBlack/","Hospital.csv"),sep=",")

control <- factor(hospital$Control, labels = c("G_NFed","NG_NP","Profit","F_GOV"))  # create factors for Control
region <- factor(hospital$Geog..Region, labels = c("So","NE","MW",'SW',"RM","CA","NW"))  # create factors for Geographic Region
control_region <- table(control, region)  # create table with both vectors

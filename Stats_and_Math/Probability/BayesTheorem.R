
# Bayes' Theorem Calculation
# What is the probability a hospital is a for profit hospital if it is in MW?
# Refer to Section 4.8 for the formula used in this example.  The numerator in 
#   that formula gives us intersection probability for a MW for-profit hospital.
# The denominator sums up the intersection probabilities to provide the 
#   probability of a MW hospital

#----------------------------------------------------------
# EXAMPLE 1

hospital <- read.csv(file.path("c:/RBlack/","Hospital.csv"),sep=",")

control <- factor(hospital$Control, 
                  labels = c("G_NFed","NG_NP",
                             "Profit","F_GOV"))  # create factors for Control
region <- factor(hospital$Geog..Region, 
                 labels = c("So","NE","MW",'SW',
                            "RM","CA","NW"))  # create factors for Geographic Region
control_region <- table(control, region)  # create table with both vectors


# the numerator is the product of the marginal probability for a 
#   for-profit hospital times the conditional probability of a MW 
#   hospital given for-profit.  This is the intersection probability 
#   of MW and for-profit or 11/200 (see chart above)
numerator <- (mcr[3,8]/mcr[5,8])*(mcr[3,3]/mcr[3,8])


# gives marginal probabilities by type of hospital:
marginal <- mcr[,8]/mcr[5,8]


# looks at MW hosptials  and gives marginal for MW hospitals
conditional <- mcr[,3]/mcr[,8]


# gives probability of various intersections between the two 
#   (each type of hospital in the MW)
intersection <- marginal*conditional

# sum of intersection gives probability of hospital being in MW
numerator/sum(intersection[1:4])


#----------------------------------------------------------
# EXAMPLE 2
# still using hospital dataset above
# factor service column by medical and psych
service <- factor(hospital$Service, labels = c("medical", "psychiatric"))
service <- addmargins(table(service))

p <- service[2]/service[3]  # divide column 2 by 3 to get probability of psychiatric




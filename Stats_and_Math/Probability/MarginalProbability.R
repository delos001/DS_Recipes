# Probabilities from a table
# Demonstration of calculations in Figure 4.7 of Business Statistics by Black.

control <- factor(hospital$Control, 
                  labels = c("G_NFed","NG_NP",
                             "Profit","F_GOV"))
region <- factor(hospital$Geog..Region, 
                 labels = c("So","NE","MW",'SW',
                            "RM","CA","NW"))
control_region <- table(control, region)


# Marginal probability hospital is for profit?  
# Uses a table and indexing the values by row and column (so mcr[row3,col8]
mcr[3,8]/mcr[5,8]

# Union probability Rocky Mountain or Not Government Not for-profit?
(mcr[5,5]+mcr[2,8]-mcr[2,5])/mcr[5,8]

# Intersection probability for-profit in California?
mcr[3,6]/mcr[5,8]

# Conditional probability hospital is in Midwest if for-profit?
mcr[3,3]/mcr[3,8]

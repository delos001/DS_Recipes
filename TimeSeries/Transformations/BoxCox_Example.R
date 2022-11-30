

#----------------------------------------------------------
# BASIC EXAMPLE
#----------------------------------------------------------
# box cox transformation: BoxCox.lambda() function will chooses a lamda
# Having chosen a transformation, we need to forecast the transformed data. 
# then, we need to reverse the transformation (or back-transform) to obtain 
# forecasts on the original scale. (see formula in one note)
lambda <- BoxCox.lambda(elec) 
plot(BoxCox(elec,l ambda))

#----------------------------------------------------------
# EXAMPLE 2
#----------------------------------------------------------

# https://www.isixsigma.com/tools-templates/normality/making-data-normal-using-box-cox-power-transformation/

# George Box and David Cox developed a procedure to identify an 
# appropriate exponent (Lambda = l) to use to transform data into 
# a “normal shape.” The Lambda value indicates the power to which 
# all data should be raised. In order to do this, the Box-Cox power 
# transformation searches from Lambda = -5 to Lamba = +5 until the 
# best value is found. 

x <- StudentLoans$total_increase_in_debt
y <- StudentLoans$observation_number
bc <- boxcox(x~1)
lam <- bc$x[which.max(bc$y)]

BClam <- lam

truehist(BoxCox(x,lam), 
         main="True Histograph of Increase in Debt (Box-Cox Transform)", 
         xlab="Dollar Value of Increase in Debt (in MM, Box-Cox)", 
         ylab="Frequency of Occurrences")

BoxCoxPlot<-ts.plot(BoxCox(x,lam), 
                    main="Total Debt Increase by Quarter (in Millions, Box-Cox Transform)", 
                    xlab="Quarter in terms of Time Series", 
                    ylab="Change in Debt (Box-Cox)", 
                    col="blue")

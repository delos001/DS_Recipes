
#----------------------------------------------------------
#----------------------------------------------------------
BASE R
#----------------------------------------------------------
#----------------------------------------------------------

tumor <- read.csv(file.path("tumor.csv"), sep=",")

library(qcc)
patient.status <- table(tumor$status)
pareto.chart(patient.status)

# counts the distibution based on the age groups 
#   (these may need to be defined: using the code below):
# classes <- c(0,20,40,60,80,100) 
# result <- cut(tumor$age, breaks = classes, right = FALSE)
age.distribution <- count

pareto.chart(age.distribution)

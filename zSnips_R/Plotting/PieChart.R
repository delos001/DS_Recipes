


#----------------------------------------------------------
#----------------------------------------------------------
# BASE R
#----------------------------------------------------------
#----------------------------------------------------------


#----------------------------------------------------------
# EXAMPLE 1
#----------------------------------------------------------
tumor <- read.csv(file.path("tumor.csv"), sep=",")

patient.status <- table(tumor$status)  
patient.status
pie(patient.status)


#----------------------------------------------------------
# EXAMPLE 2
#----------------------------------------------------------
tumor <- read.csv(file.path("tumor.csv"), sep=",")

# defines age classes to turn age ratio data into ordinal data
# cut: determines which class age value belongs in
classes <- c(0,20,40,60,80,100) 
result <- cut(tumor$age, 
              breaks = classes, 
              right = FALSE)
result

count = table(result)
pie(count)


#----------------------------------------------------------
# EXAMPLE 3
#----------------------------------------------------------
lbls <- c("Class 1","Class 2","Class 3","Class 4","Class 5")
colors = c("red", "yellow", "green", "violet", "orange") 
pie(count, 
    labels = lbls, 
    col = colors, 
    main = "Pie Chart of Age Distribution")

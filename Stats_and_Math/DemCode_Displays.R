# Demonstration R Code for PREDICT 401 
# This program will demonstrate various data displays using RStudio and base R.
#-------------------------------------------------------------------------------

tumor <- read.csv(file.path("c:/R401/", "tumor.csv"), sep=",")

# The tumor data are from 205 patients in Denmark with malignant melanoma. 
# The data frame has 205 rows and 5 variables. The variables are:

# status    "died" died from melanoma, "alive" alive, "other" died other causes
# sex       "male", "female"
# age       age in years
# thickness tumour thickness in mm
# ulcer     "present", "absent"

#-------------------------------------------------------------------------------
# Check the structure of the data set.  Calculate some simple statistics.

str(tumor)
head(tumor, n = 5L)
summary(tumor)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Qualitative Data Displays of Individual Variables
#-------------------------------------------------------------------------------
# A pie chart is a circular display of data where the area represents 100% of the
# data, and each slice the corresponding percent breakdown.  Form a pie chart
# showing the breakdown of patient status.

patient.status <- table(tumor$status)  # This is a simple frequency table.
patient.status
pie(patient.status)

# Plot a pie chart based on age classification.  This demonstrates how a ratio
# variable can be converted into an ordinal variable using age classes.

classes <- c(0,20,40,60,80,100)  # This defines the age class boundaries.

result <- cut(tumor$age, breaks = classes, right = FALSE)
result
# Note that in doing this an ordinal variable has been generated.  Each 
# observation is identified by its respective age class.  The age classes have an
# implicit order: [0, 20), [20, 40), [40, 60), and so forth.

count <- table(result)
pie(count)

# The labels and colors can be changed and a title added.
lbls <- c("Class 1","Class 2","Class 3","Class 4","Class 5")
colors = c("red", "yellow", "green", "violet", "orange") 
pie(count, labels = lbls, col = colors, main = "Pie Chart of Age Distribution")

#-------------------------------------------------------------------------------
# Bar graphs are used to display qualitative data with the catgories on one axis,
# and the magnitude of some quantity, like frequency, forming the length of a bar.

# Form vertical and horizontal bar plots showing age distribution frequencies.

barplot(count) 

# The generic display can be enhanced.
colors = c("red", "yellow", "green", "violet", "orange") 
barplot(count, col=colors, main = "Bar Plot of Age Distribution",
        names.arg = c("[0,20)","[20,40)","[40,60)","[60,80)","[80,100)"),
        xlab = "Age Class", ylab = "Frequency")

barplot(count, col=colors, main = "Bar Plot of Age Distribution",
        names.arg = c("Class 1","Class 2","Class 3","Class 4","Class 5"),
        xlab = "Age Class", ylab = "Frequency", horiz = TRUE)

#-------------------------------------------------------------------------------
# Form stacked and adjacent bar plots with colors and legend.

# Bar plots are useful when dealing with nominal and ordinal variables.
counts <- table(tumor$sex, tumor$status)
barplot(counts, main="Patient Distribution by Status and Sex", ylab = "Frequency",
        xlab="Status", col=c("darkblue","red"),legend = rownames(counts))

# result <- cut(tumor$age, breaks = classes, right = FALSE) was defined earlier.

counts <- table(result, tumor$sex)
counts <- t(counts)  #This organizes the data for vertical stacking.
counts

barplot(counts, main="Patient Distribution by Age and Sex", ylab = "Frequency",
        xlab="Age Class", col=c("darkblue","red"),legend = rownames(counts))

barplot(counts, main="Patient Distribution by Age and Sex", ylab = "Frequency",
        xlab="Age Class", col=c("darkblue","red"),legend = rownames(counts),
        names.arg = c("Class 1","Class 2","Class 3","Class 4","Class 5"), beside = TRUE)   

#--------------------------------------------------------------------------------
# A pareto chart is a particular application of a bar graph in which the categories
# are ranked in order of occurrence. The previous bar plot turns out to be similar 
# to a pareto chart.  To generate a pareto chart, the package "qcc" needs to be 
# installed and called so that the function "pareto.chart()" can be used.

library(qcc)
patient.status <- table(tumor$status)
pareto.chart(patient.status)

age.distribution <- count
pareto.chart(age.distribution)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Quantitative data displays of individual variables
#-------------------------------------------------------------------------------
# Histograms show the frequency of data in given class intervals.  The shape of 
# data distribution is revealed for an initial overview.

# Form histograms showing age distribution.  Use the same class boundaries and 
# colors.  Here age is treated as a ratio variable without prior classification.

hist(tumor$age)
hist(tumor$age, breaks = classes, main = "Histogram Showing Age Distribution",
     xlab = "Age Class", col = colors)        
      
# A frequency polygon is similar to a histogram displaying class frequencies
# versus class midpoint.  Form a display using the vector "count" defined earlier.

center <- c(10, 30, 50, 70, 90)  # Class interval midpoints
plot(center, count)
plot(center, count, type = "b", col = "red", main = "Frequency Polygon",
     xlab = "Age Class Midpoints", ylab = "Frequency", xlim = c(0, 100))

# An ogive is a cumulative frequency polygon.  Steep slopes identify where sharp
# increases in frequencies occur.  Construct an ogive of age distribution defined 
# earlier.  (The following calculation could be done using a "for" loop.)  

cum.count <- numeric(0)   # This defines cum.count as a numeric vector.

cum.count[1] <- count[1]
cum.count[2] <- cum.count[1]+ count[2]
cum.count[3] <- cum.count[2] + count[3]
cum.count[4] <- cum.count[3] + count[4]
cum.count[5] <- cum.count[4] + count[5]
cum.count

n <- cum.count[5]

plot(center, cum.count, type = "b", col = "red", main = "Ogive of Age Distribution",
     xlab = "Age Class Midpoints", ylab = "Cumulative Frequency", xlim = c(0, 100))

plot(center, cum.count/n, type = "b", col = "red", xlab = "Age Class Midpoints", 
     main = "Ogive of Cumulative Relative Frequencies", xlim = c(0, 100), 
     ylab = "Cumulative Relative Frequency")

#-------------------------------------------------------------------------------
# A stem-and-leaf plot is sometimes used to give a unique view of the data.  The
# left most digits of a variable form the stem, and the right most form the leaf.
# R will round off the leaf entries to single digits.

sort(tumor$thickness, decreasing = FALSE)

# Note how the stem-and-leaf plot rounds the original data prior to plotting.
stem(tumor$thickness)

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Look at two variables simultaneously.
#-------------------------------------------------------------------------------
# Calculate various summary statistics such as the mean, standard deviation, etc.
# R provides a variety of functions which can be used with tables and lists.

tapply(tumor$thickness, list(tumor$sex, tumor$ulcer), FUN = mean)
tapply(tumor$thickness, list(tumor$sex, tumor$ulcer), FUN = sd)
tapply(tumor$thickness, list(tumor$status, tumor$ulcer), FUN = length)

#-------------------------------------------------------------------------------
# Form a simple contingency table.  Contingency tables provide a way to evaluate
# the relationship between two qualitative variables, in this case sex and status.

mytable <- (table(tumor$sex,tumor$status))
mytable

# Convert the cells counts in this table to proportions.
n <- sum(mytable)
n
mytable/n

prop.table(mytable)  # This is a quicker way to obtain proportions.

addmargins(mytable)
prop.table(mytable, 1) # row proportions
prop.table(mytable, 2) # column proportions

addmargins(table(tumor$sex,tumor$status,tumor$ulcer))

#-------------------------------------------------------------------------------
# Scatterplots are useful for displaying the relationship between two numerical
# variables.  Form a scatterplot of tumor thickness versus age.

plot(tumor$age, tumor$thickness)
plot(tumor$age, tumor$thickness, main = "Tumor Thickness versus Age", col = "red",
     cex = 1.0, pch = 16,  xlab = "Age", ylab = "Thickness")

#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
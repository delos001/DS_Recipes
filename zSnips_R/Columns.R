# IN THIS SCRIPT:
# Add columns
# Remove columns
# Name columns
# Rename columns
# Perform operations across columns
# Test for column present
# Dynamically reference columns


#---------------------------------------------------------------------------
# ADD COLUMNS
# in this example, df has 3 rows
#---------------------------------------------------------------------------
data$size      <- c("small", "large", "medium")
data[["size"]] <- c("small", "large", "medium")
data[,"size"]  <- c("small", "large", "medium")
data$size      <- 0   # Use the same value (0) for all rows

# create column where college is added for eachrow
Elite=rep("No",nrow(college))

# create column where 'Yes' is added if Top10per > 50
Elite[college$Top10perc>50]="Yes"



#---------------------------------------------------------------------------
# REMOVE COLUMNS
#---------------------------------------------------------------------------
df = df[,-1] # creates new df with first column removed

# Other examples
data$size      <- NULL
data[["size"]] <- NULL
data[,"size"]  <- NULL
data[[3]]      <- NULL
data[,3]       <- NULL
data           <- subset(data, select=-size)


#---------------------------------------------------------------------------
# NAME COLUMNS 
#---------------------------------------------------------------------------
overview <- cbind(xs, xi[,3], xl[,3], xr[,3], count)
colnames(overview) <- c("location","region","Spending","Income","Count")

#---------------------------------------------------------------------------
# RENAME COLUMNS
# note: dplyr has a rename function
#---------------------------------------------------------------------------

# Basic rename example using base R
colnames(cc_data)[colnames(cc_data)=="PAY_0"] = "PAY_1"

# Replace column names by concatenating the "q_" with original column name
#   where x is the dataframe containing the columns
colnames(y) <- paste("q_", colnames(x), sep = "")


# Rename column by adding specified text ("diff" in this case) and separate by using _
colnames(var_diff_both) = paste(colnames(var_diff_both), "diff", sep="_")


#----------------------------------------------------------
#----------------------------------------------------------
# OPERATIONS ACROSS COLUMNS
#----------------------------------------------------------
#----------------------------------------------------------

dft$Avg_Bill_Amt = rowMeans(df[,13:18])
df$Max_Bill_Amt = apply(df[13:18],1, FUN=max)
df$var = rowSums(df[,c('colA', 'colB', 'colC')])



#---------------------------------------------------------------------------
# Identify if a desired column is present, and if not, create it

# YourTBL is the data frame/tibble containing one or more of 
#     the columns shown below.
#---------------------------------------------------------------------------
# specify the columns expected
colNameList <- c( "ColA",
                 "ColB",
                 "ColC", 
                 "ColD")

# look for each column and if not present, create it and set values to NA
YourTBL[colNameList[!(colNameList %in% colnames(YourTBL))]] = NA


#---------------------------------------------------------------------------
## Dynamically Reference columns from a list of columns of interest
#---------------------------------------------------------------------------
df = data.frame(Col1=rnorm(10),
                Col2=rnorm(10),
                Col3=rnorm(10))

InterestCol = c("Col1",
                "Col3")

GetIndex = match(InterestCol,names(df))

df1 = df[,GetIndex] # create df based on InterestCol

df$calc = rowSums(df[, GetIndex]) # calculate row sums using InterstCol


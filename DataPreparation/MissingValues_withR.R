


# PACKAGES

# Amelia
Library(Amelia)
missmap(feat_comb, 
        main="Missing Map", 
        y.labels = NULL, 
        y.at=NULL, 
        rank.order = TRUE)

# VIM
Library(VIM)

# Mice
Library(mice)
md.pattern(feat_comb)  # Produces table showing missing variable values, produce heat-map like image

#----------------------------------------------------------
# CUSTOM FUNCTION TO GET MISSING VALUE STATS ON DF
#1
#MISSING STATISTICS CUSTOM
cf_miss_stats_tbl = function(x){
  cf_miss_stats = function(m) {
    miss = data.frame(rbind(length(m),
                            sum(is.na(m) == TRUE),
                            sum(is.na(m) == TRUE) / length(m)),
                      row.names = c("Length", "Missing","%Missing"))
    colnames(miss) = colnames(m)
    return(miss)
  }
  round(t(data.frame(apply(x, 2, cf_miss_stats))),2)
}



#----------------------------------------------------------
# BASIC TRUE/FALSE FOR MISSING VALUE
# determines if a value in a list is a missing value
x1<- c(1,4,3,NA,7)
is.na(x1)
# FALSE FALSE FALSE  TRUE FALSE


#----------------------------------------------------------
# CONVERT TO NA UPON READ FILE
# when you read file, use na.strings and tell R which character to 
#   replace with null values
auto=read.table("Auto.txt", header=T, na.strings="?")


#----------------------------------------------------------
# SUMMARIZE MISSING VALUES
sum(is.na(Hitters$Salary))



#----------------------------------------------------------
# DELETE MISSING VALUES
Hitters = na.omit(Hitters)
dim(Hitters)


#----------------------------------------------------------
# FILTER FOR MISSING VALUES ONLY
Hitters = Hitters[-which(is.na(Hitters$Salary)), ]



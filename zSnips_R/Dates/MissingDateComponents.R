
################################################################################
# Title                   : Missing Date components
# Tag(s)                  : Dates.tt
################################################################################

# Imputing Dates

#START DATE IMPUTATION FUNCTION------------------------------------
#set conditionals based on business definition
#specify day, month, year, you want to use

cf_stdat = function(dd,mm,yy){
  paste(ifelse(is.na(dd), 1, dd),
        ifelse(is.na(mm), 1, mm),
        ifelse(is.na(yy), 2000, yy),
        sep = "-") %>%
    lubridate::dmy() 
}


#END DATE IMPUTATION FUNCTION
#set conditionals based on business definition
#specify day, month, year, and max date columns you want to use

cf_endat = function(ongo,dd,mm,yy,maxdate){
    ifelse(ongo == "Ongoing", 
         format(maxdate, '%Y-%m-%d'),
         paste(
           ifelse(is.na(yy), 
                  year(maxdate), yy),
           ifelse(is.na(mm), 12, mm),
           ifelse(is.na(dd), 28, dd),
           sep = "-")) %>% 
    lubridate::ymd()  #order refers to input order
}




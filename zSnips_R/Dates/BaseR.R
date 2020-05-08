
#--------------------------------------------------------------------------
# BASIC EXAMPLE
fps_date = as.Date(c('29-Dec-2016'), format = '%d-%b-%Y')

# as.date convert
mutate(`Date` = as.Date(`Date Numeric`, origin = "1970-01-01")) 


#--------------------------------------------------------------------------
# LAPPLY TO CONVERT MULTIPLE COLUMNS
#use lapply to convert date variables to date and specify format
edcSV[,c(12,14:15,24,33)] = lapply(edcSV[,c(12,14:15,24,33)], 
                                           as.Date, format = "%d-%b-%y")


#--------------------------------------------------------------------------
# posix convert
mutate(`Date` = as.POSIXct(`Date Numeric`, origin="1970-01-01", tz="UTC")) 
  

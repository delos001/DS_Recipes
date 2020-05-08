
# In this script:
# 
# Ceiling
# Interval between dates
# Sequences between dates
# Wee numbers


#------------------------------------------------------------------
# Ceiling
#------------------------------------------------------------------
# gets last date of month based on specified date
tdy = as.Date(format(Sys.time(), '%d-%m-%Y'), format = '%d-%m-%Y')
tdy_end = ceiling_date(tdy, unit = 'month')



#------------------------------------------------------------------
# Interval Between Dates
#------------------------------------------------------------------

# By month
SDUR = time_length(interval(SSDst,tdy_end), unit = 'month')

# By day
SDUR_d = time_length(interval(SSDst,tdy), unit = 'day')



#------------------------------------------------------------------
# Sequences Between Dates
#------------------------------------------------------------------
StudyDurMons = data.frame(seq(as.Date(SSDst), 
                              by = 'month', 
                              length.out = 12))


seqdf = data.frame('Date_full' = seq(firDt, 
                                     by = 'weeks', l
                                     ength.out = 12))                   
                              
                              

#------------------------------------------------------------------
# Sequences Between Dates
#------------------------------------------------------------------
# Get week numbers using 1Jan as the start point
date_derive = seqdf %>%
  mutate(Year_Week = paste(year(Date_full), 
                           ifelse(nchar(ceiling(yday(Date_full)/7)) == 1,
                                  paste(0, ceiling(yday(Date_full)/7), 
                                        sep = ""), 
                                  ceiling(yday(Date_full)/7)), 
                           sep = ""))

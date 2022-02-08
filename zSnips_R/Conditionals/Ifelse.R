

#----------------------------------------------------------
# if 
#     the month column contains value in "sj_rain_month" vector and 
#     city column is "sj"
# or
# if .
#     month column cotains value in "iq_rain_months" vector and 
#     city column is "iq"
# put a 1, else put a 0
new_variables$rain_seas = ifelse(
                                (is.element(new_variables$month, sj_rain_months) &
                                (new_variables$city =="sj")) |
                                (is.element(new_variables$month, iq_rain_months) &
                                (new_variables$city =="iq")), 1, 0)

##test add for demo delete later

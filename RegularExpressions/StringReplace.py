
# looks for everythign that starts with /S regardless of 
# what is after that.  replaces with ""
hotelinfo['HotelURL'] = hotelinfo['HotelURL'].str.replace('/S.+',"")

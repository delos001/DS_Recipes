


#----------------------------------------------------------
# CURRENT YEAR
from datetime import datetime
print now.year


#----------------------------------------------------------
# CURRENT MONTH
from datetime import datetime
print now.month

#----------------------------------------------------------
# CURRENT DAY
from datetime import datetime
print now.day

#----------------------------------------------------------
# CURRENT DATE AND TIME
from datetime import datetime
now = datetime.now()
print now

# Specify format
# can replace the / with - or  order that month, day year appears
from datetime import datetime
now = datetime.now()
print '%s/%s/%s' % (now.month, now.day, now.year)

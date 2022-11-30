

from datetime import datetime

print now.hour    # prints current hour

print now.minute  # prints current minute

print now.second  # prints current second


# prints in format hh:mm:ss
from datetime import datetime
now = datetime.now()
print '%s:%s:%s' % (now.hour, now.minute, now.second)







# Open file and use custom regex expression to get HTML tags
# https://kevin.deldycke.com/2008/07/python-ultimate-regular-expression-to-catch-html-tags/

import re 
import urllib 
page=urllib.urlopen('index.html').read()

page=urllib.urlopen('index.html').read() 
ultimate_regexp = \
"(?i)<\/?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)\/?>"

for match in re.finditer(ultimate_regexp, page):
print repr(match.group())



#----------------------------------------------------------
# EXAMPLE 2
ultimate_regexp = \
"(?i)<\/?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)\/?>"

# runs regex on addresses column in the hoteinfo df
hotelinfo['Address']=hotelinfo['Address'].str.replace(ultimate_regexp,"")
# replaces 'c/'
hotelinfo['Address']=hotelinfo['Address'].str.replace('c/',"") 
# replaces everything that starts with /S in the columns
hotelinfo['HotelURL']=hotelinfo['HotelURL'].str.replace('/S.+',"")#delete nonUR

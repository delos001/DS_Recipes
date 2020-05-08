

#----------------------------------------------------------
#----------------------------------------------------------
# BEAUTIFUL SOUP
#----------------------------------------------------------
#----------------------------------------------------------

#----------------------------------------------------------
# EXAMPLE 1
import re     # import regex
import urllib  # import package to read html files into python

from bs4 import BeautifulSoup 
page = urllib.urlopen('index.html').read() 


#----------------------------------------------------------
# EXAMPLE 2
# read file and run through BS package
from bs4 import BeautifulSoup 
page=urllib.urlopen('index.html').read() 
page=BeautifulSoup(page,'html.parser') # run page through BeautufilSoup pack
print(page.get_text())   # print whats left after BeautifulSoup runs

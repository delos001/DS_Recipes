
#  regular expression.tt
#  extract text.tt
#  remove text.tt


# used to extract text (dosage) from free text field combining dose and units
  # derive_dose: 1: replace non-numbers with "-"
  #              2: replace lagging dash with a blank
  #              3: trim any lagging white space (just in case)

  mutate(Dose_Derived = str_trim(                                            #3
                          gsub('\\-$', '',                                   #2
                               gsub("[^0-9.-]+", "-",                        #1
                                    `YourColumn`)),   
                          side = 'right'))


#-----------------------------------------------------------------------------------
# GSUB EXTRACT EXAMPLE
# original text:
# Lab Test not received for lab Test Name (Ur. T. Protein, Random Frozen) and 
#       test code (RCT2288) with Accession #(N/A)
# get text between specified strings
# create new column (cola)
# using gsub: 
# "Test Name" is first string, "and" is last string
# the 's' are for spaces:  \\s means to skip/exclude the spaces between the two words
# the \\(  and \\) tells it to skip/exclude the parentheses too

df$cola = gsub('^.*Test Name\\s\\(*|\\)\\s*and test code.*$', '',df$colb)

# Does same thing but with qdapRegex
library(qdapRegex)
rm_between(x, 'This', 'first', extract=TRUE)[[1]]


#-----------------------------------------------------------------------------------
# remove all text after a specified character
    # in this example the character is a space and dash
    # replace with ""
mutate(`NewColumnfix` = sub(" -.*","",`YourColumn`))

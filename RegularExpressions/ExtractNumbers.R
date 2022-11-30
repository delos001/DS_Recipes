


as.numeric(unlist(regmatches(testregex1, gregexpr("[[:digit:]]+", testregex1))))


extract_numeric(testregex1)



#-----------------------------------------------------------------------------------
#uses extract_numeric (requires tidyr): 
# is a wrapper for gsub('^\\.|\\.$', '', test)
# This example extracts numbers by substituting non-numbers, with a comma and space 
#     then trims the space of the right side (*note: it leaves a trailing comma)

mutate(Dose_Derived = extract_numeric(`df$col`),
         Dose_Derived1 = str_trim(gsub("[^0-9.-]+", ", ", `df$col`), side = 'right'),
                  
         # This example extracts numbers like above and then gets rid of the comma by 
         #    identifying the trailing comma ('\\, $') and replaceing with blank ''. 
         # Note: this would get leading and trailing comma: gsub('^\\,|\\,$', '', test)  
         #    (because the ^ indicates beginning of the string
         Dose_Derived3 = gsub('\\, $', '', gsub("[^0-9.-]+", ", ", `df$col`)),
         
         # This does same as above and then trims any spaces
         Dose_Derived3 = str_trim(gsub('\\, $', '', gsub("[^0-9.-]+", ", ", `df$col`)), side = 'right')

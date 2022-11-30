
## THE COMPLETE REGULAR EXPRESSION COURSE FOR BEGINNERS
##    https://www.udemy.com/course/regular-expressions-mastery/
##    Instructor: Sujith George




#-------------------------------------------------------------------------------
#     LOAD PACKAGES
#-------------------------------------------------------------------------------
library(dplyr)


#-------------------------------------------------------------------------------
#     SET FILE PATH
#-------------------------------------------------------------------------------
regpath = 'C:/Users/Jason/Desktop/GitHub/DS_Recipes/RegularExpressions/TutorialData'





## Section 2: The basic set
##   Using pattern to select strings that match

#-------------------------------------------------------------------------------
#     REPEAT CHARACTER *
#-------------------------------------------------------------------------------

##  the * symbol indicates zero or more of whatever character it follows--------
##      pattern: starts with 'foo', has zero or more a's, ends with bar
regex01 = read.csv(file.path(regpath, 'regex01.txt'), 
                   header = FALSE, 
                   sep = " ")

pat = regex01 %>%
  dplyr::filter(grepl('fooa*bar', V1))  # zero or more a's



#-------------------------------------------------------------------------------
#     WILDCARD CHARACTER .
#-------------------------------------------------------------------------------

## the . symbol is wildcard-----------------------------------------------------
##    pattern: starts with 'foo', any one character, ends with 'bar'

regex02 = read.csv(file.path(regpath, 'regex02.txt'), header = FALSE)

pat = regex02 %>%
  dplyr::filter(grepl('foo.bar', V1))




## using the . and * = zero or more of any letter-------------------------------
## pattern: starts with 'foo' then any number of letters, ends with 'bar'
regex03 = read.csv(file.path(regpath, 'regex03.txt'), header = FALSE)


pat = regex03 %>%
  dplyr::filter(grepl('foo.*bar', V1))



#-------------------------------------------------------------------------------
#     WHITE SPACE CHARACTER
#-------------------------------------------------------------------------------

## patterns that include white space
##   pattern: start with 'foo' contains any number of spaces, ends with 'bar'
##      note: remember R requires double \\ so the escape character is \\
regex04 = read.csv(file.path(regpath, 'regex04.txt'), header = FALSE)

pat = regex04 %>%
  dplyr::filter(grepl("foo\\s*bar", V1))




#-------------------------------------------------------------------------------
#     CHARACTER CLASSESS 
#-------------------------------------------------------------------------------

## CHARACTER CLASSES BASIC------------------------------------------------------
## Character classes  using [] to specify characters
##     pattern: one of letters a, b or c is in the string

regex05 = read.csv(file.path(regpath, 'regex05.txt'), header = FALSE)

pat = regex05 %>%
  dplyr::filter(grepl('[fcl]oo', V1))



## Character classes basic continued
##   pattern: starts with f, c, d, p, l , b and ends with 'oo'
##     note it is same as above but could be unmanageable if too many characters

regex06 = read.csv(file.path(regpath, 'regex06.txt'), header = FALSE)

pat = regex06 %>%
  dplyr::filter(grepl('[fcdplb]oo', V1))



##  CHARACTER CLASSESS WITH NEGATION--------------------------------------------

## instead of including all possible characters, we can exclude
##   pattern: starts with all characters except m and h, and ends with 'oo'

regex07 = read.csv(file.path(regpath, 'regex07.txt'), header = FALSE)

pat = regex07 %>%
  dplyr::filter(grepl('[^mh]oo', V1))  ## carrot symbol negates the class
  



##  CHARACTER CLASSESS WITH RANGES----------------------------------------------

## Character class with ranges [a-d]
##   pattern: starts with letter from j to m and ends with 'oo'

regex08 = read.csv(file.path(regpath, 'regex08.txt'), header = FALSE)

pat = regex08 %>%
  dplyr::filter(grepl('[j-m]oo', V1))



## Character class with ranges continued: range plus other character
##    pattern: starts with letters from j to m or z, and ends with 'oo'

regex09 = read.csv(file.path(regpath, 'regex09.txt'), header = FALSE)

pat = regex09 %>%
  dplyr::filter(grepl('[j-mz]oo', V1))




## Character class with ranges continued: CASE and range plus other character
##    pattern: starts with any case letters from j to m or z, and ends with 'oo'

regex10 = read.csv(file.path(regpath, 'regex10.txt'), header = FALSE)

pat = regex10 %>%
  dplyr::filter(grepl('[j-mJ-Mz]oo', V1))



##  ESCAPING SPECIAL CHARACTERS WITH BACKSLASH----------------------------------


## Using the \ to escape special characters
##     pattern: any num of x's followed by period, followed by any num of y's
regex11 = read.csv(file.path(regpath, 'regex11.txt'), header = FALSE)

pat = regex11 %>%
  dplyr::filter(grepl('x*\\.y', V1))


## More complicated example requiring escape for special characters
##      patttern: starts with x, contains #, :, or . and then ends with y
##      note: : and # are not special characters so wouldn't need escape
regex12 = read.csv(file.path(regpath, 'regex12.txt'), header = FALSE)

pat = regex12 %>%
  dplyr::filter(grepl('x[#:\\.]y', V1))

## same as above but demonstrates you don't need to escape characters in sq brackets
##    exception is ^ and - which have special meaning inside square brackets
##    in square brackets: ^ means negate, - used to specify a range
pat = regex12 %>%
  dplyr::filter(grepl('x[#:.]y', V1))


## Another example using escape: uses \\ in character brackets because of ^
##    pattern: start with x, contains #, :, or ^ and ends with y
regex13 = read.csv(file.path(regpath, 'regex13.txt'), header = FALSE)

pat = regex13 %>%
  dplyr::filter(grepl('x[\\^#:]y', V1))


## Another exmaple using escape with additional special characters
##  pattern: start with x, contains #, \ or : and ends with y
regex14 = read.csv(file.path(regpath, 'regex14.txt'), header = FALSE)

pat = regex14 %>%
  dplyr::filter(grepl('x[#\\\\\\^]y', V1))



#  ANCHORS----------------------------------------------------------------------

##  Start of a string: the carrot anchor ^
##     The ^ symbol means 'beginning of the text'
##     Note ^ inside [] means to negate, but outside means 'beginning of line'

## Example using ^ to specify pattern at beginning of string
##   pattern: start with 'foo' then any chanaracter any number of times
regex15 = read.csv(file.path(regpath, 'regex15.txt'), header = FALSE)

pat = regex15 %>%
  dplyr::filter(grepl('^foo.*', V1))


##  End of a string: the $ anchor
##  The $ symbol means 'end of the string'

## Example using $ to specify pattern at end of string
##   pattern: string ends with 'bar' and contains any characters in any amount prior to bar
regex16 = read.csv(file.path(regpath, 'regex16.txt'), header = FALSE)

pat = regex16 %>%
  dplyr::filter(grepl('.*bar$', V1))


## Example combining ^ and $
##  pattern: nothing befor or after 'foo'

regex17 = read.csv(file.path(regpath, 'regex17.txt'), header = FALSE)

pat = regex17 %>%
  dplyr::filter(grepl('^foo$', V1))

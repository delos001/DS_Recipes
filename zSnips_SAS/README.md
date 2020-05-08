## Variable Naming Rules
-  variable names <= 32 characters
-  variable names must start with leter or an underscore
-  variable names can only contain letters, numbers, or underscore
-  variable names can contain upper and lower case letters

## Code Formatting
  - Comments in green
  - Data in yellow
  - Commands are in bold

  Line Comments: /* your text */

## Missing Data
 - missing character data represented by a blank
 - missing numerical data represented by a period

## Telling SAS the program/script is done:
  - quit;
  - stop;
  - abort;
---
## Basics
- PROC DATASETS lib=mydata lists all data sets in directory 
	+ (where lib=mydata specifies the library, if lib not specified, defaults to working dir)
- PROC CONTENTS displays metadata for the file: the number of variables, rows, names and types of each varible
	+ proc contents data=mydata.building_prices; run;
- PROC PRINT displays the first 10 observations in the file (change obs=10) to a larger or smaller number if desired
- PROC MEANS gives the number of observations, the mean, standard deviation, min, max of the X variable
- PROC UNIVARIATE gives a histogram of the X variable 
- PROC FREQ gives the distribution and histogram of the COLOR variable.

---

## Operators

| Symbol | Syntax | Description |
| ------ | ------ | ----------- |
| = | eq | equals |
| ^= or  ~= | ne | not equal |
| > | gt | greater than |
| < | lt | less than |
| >= | ge | greater than or equal to |
| <= | le | less than or equal to |


| Symbol | Definition |Example | Result |
| ------ | ------ | ------ | ------ |
| ** | exponentiation | a**3 | raise A to the third power |
| * | multiplication  | 2*y | multiply 2 by the value of Y |
| / | division | var/5 | divide the value of VAR by 5 |
| + | addition | var + 3 | add 3 to the value of var|
| - | subtraction | var1 - var2 | subtract the value of var2 from the value of var1 |

## Natural Exponent
	• Represented by “e”
	• “e” is an irrational number similar to “PI” in that it goes on forever  e = 2.718281828459045…
	• eX usually represented by exp(X) by most math packages such as SAS

	Natural Log
	• Represented by “ln”
	• “ln(X)” returns a logarithm of the base of “e”.
	• “ln(X)” is usually represented by:
		• ln(X) while log base 10 will be represented by log(X)
	• HOWEVER … in SAS (confusingly enough)… “ln(X)” is represented by:
		• log(X) while log base 10 will be represented by log10(X)
	CONVERSION
	• X = ln( eX ) = eln(X)
	• 5 = ln( e5 ) = ln( 148.413 ) = 5
	• 5 = eln(5) = e1.609 = 5
## Set seed
- uniform  ex: u = uniform(123)

/*--------------------------------------------------------------------------------------------
BASIC PROC STEP
--------------------------------------------------------------------------------------------*/

/* beging with 'Proc' statement, perform specific analysis for function, produce results or report */

/* Example 1 */
data temp; 
      set mydata.buildings_prices;
run;

proc print data=temp (obs=10);
run;

/* Example 2 */
title "test title";
proc print data = temp1;
run;

/* Example 3 */
PROC SGPLOT data=sample ;             /* creates a scatter plot for specified x and y data */
       scatter x=sat y=gpa ;
run ;


/*--------------------------------------------------------------------------------------------
BASIC DATA STEP
--------------------------------------------------------------------------------------------*/

/*
Data steps: begin with 'Data' staement, read and modify data, then create SAS data set
*/


/* EXAMPLE 1 */
data tempdata;             /* names the dataset you are creating as 'tempdata' */
  set mydata.buildings_prices;
  x_sqr = x*x              /* creates new column: sets x_sqr as x*x 
run;


/* EXAMPLE 2 */
data sampledata;
input SAT GPA           /* tells SAS what variables will be:  SAT is one variable, GPA is another */
Label SAT = "High School SAT"   /* since inputs are short, a label can be used to describe the input */
      GPA = "College GPA";
      
/* Datalines tells SAS anything after this is the data and goes directly into the variables in the order in 
which they are listed for the input goes through in order that the data is listed/entered  
***NOTE: this has to be the last step in the Data Step */
Datalines;
1650 3.22
1790 3.22
1870 3.25
;
run; 



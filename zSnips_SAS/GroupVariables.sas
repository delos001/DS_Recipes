

/*--------------------------------------------------------------------------
Creating variable groups/classes
--------------------------------------------------------------------------*/

/* sets the grouping by "group" and "country" variables */
proc means data=temp;
	class group country;
	var _numeric_;
run;


/* Example 2 
breaks up y variable into two classes to get statistics based on class
*/
proc means data=temp1 p5 p10 p25 p50 p75 p90 p95 ndec=2;
class y;
var x1 x2 x3;
run;

/*--------------------------------------------------------------------------
Group Rank example
--------------------------------------------------------------------------*/

/*
this is an example of grouping a data set into 10 bins on the P_Target variable, 
then ranking then and adding a column to tell which bin each data point falls under (1-10)
*/

/* sets macro variables */
%let Path = /folders/myfolders/sasuser.v94/Sample Lecture Code;
%let Name = mydata;
%let LIB = &Name..;

%let TARGET 	= TARGET;
%let P_TARGET	= P_TARGET1;
%let INFILE 	= &LIB.GAINS_LIFT;
%let RANKVAR	= RANK;
%let GROUPS		= 10;
%let SORTFILE	= SORTFILE;
%let RANKFILE	= RANKFILE;

proc sort data=&INFILE. out=&SORTFILE.;   /* sorts the source file (infile) and creates an outfile */
by descending &P_TARGET.;                 /* specifies descending sort on the P_Target variable 
run;

/* rank data from sort file, creates output file, and divided into groups (of 10) */
proc rank data=&SORTFILE. out=&RANKFILE. groups=&GROUPS. descending;
var &P_TARGET.;                  /* ranks based on the P_Target variable */
ranks &RANKVAR.;                 /* creates a column to show the rank */
run;

data &RANKFILE.;                 /* creates new file called rankfile */
set &RANKFILE.;                  /* based on rankfile */
&RANKVAR. = &RANKVAR. + 1;       /* numerically increases the rank column by 1 for each successive rank (1-10) */
run;

proc means data=&RANKFILE. noprint;   /* proc means with no printing of statistics */
class &RANKVAR.;                      /* create a class to perform calculations upon based on the rankvar column (the ranks 1-10) */

/* create output file where: all target values within each rank are summed and the minimum value of P_Target in each 
class is put in cutoff column */
output out=&MEANFILE. sum( &TARGET. )=&TARGET. min(&P_TARGET.)=CUTOFF;
run;

/*
Output explanation:
log likelihood is the error term
Estimate is the beta values
*/


/*-------------------------------------------------------------------------------
PROBIT EXAMPLE
*/

data SCOREFILE;
set TEMPFILE;

TEMP		= -569.331 + 36.0494*X6 -3.6142*X8;     *you could call temp the z-score in this case;
P_PROBIT	= probnorm(TEMP);                     *so probnorm gives you the probability, given the zscore;

drop TEMP;
run;

proc print data=SCOREFILE;
run;


/*-------------------------------------------------------------------------------
GENMOD EXAMPLE
*/
data SCOREFILE;
set TEMPFILE;

TEMP		= -501.599 + 31.7541*X6 - 3.1829*X8;
P_GENMOD	= probnorm(TEMP);

drop TEMP;
run;


/*-------------------------------------------------------------------------------
MACRO EXAMPLE
*/
%macro SCORE( INFILE, OUTFILE );

data &OUTFILE.;
set &INFILE.;
TEMP = -190.9 + 12.0548*X6 – 1.2010*X8;
Y_Hat_Probit_0 = probnorm(TEMP);
drop TEMP;
run;

%mend;

/*When you call the SAS Macro, pass it the name of the data set and a name of a 
new data set where you want to store the results
Now it is possible to predict the “Y” value for new input values. */
%SCORE( TEMPFILE, MY_NEW_FILE );

data SomeNewData;
input X6 X8;
datalines;
15  25
20  35
25  45
30  50
35  55
;
run; 

%SCORE(SomeNewData, NowItsScored );

proc print data=NowItsScored;
run;

proc print data=SCOREFILE;
run;

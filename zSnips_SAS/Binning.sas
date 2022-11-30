
/*-------------------------------------------------------------------------
Ad Hoc Binning:
done based on a business rule or to achieve some business goal such as:
	Bin variables related to customers based upon profitability
	Bin variables to maximize predictive power
	Bin variables based on any other decision
Bins are usually assigned with “IF-THEN-ELSE” Logic
*/

data XFORM;
set TEMPFILE;
if 	X <=   0 then ADHOC_X = 0;
else if 	X <= 100 then ADHOC_X = 1;
else if 	X <= 200 then ADHOC_X = 2;
else ADHOC_X = 3;
run;

proc freq data=XFORM;
table ADHOC_X / plots=freqplot;
run;


/*-------------------------------------------------------------------------
Normalization:
The following SAS code will place the X values into 4 equally space buckets by 
  normalizing the range
Run a PROC MEANS and store the output into a SAS Data Set named “MEANFILE”
The variables inside of MEANFILE will be stored in Macro Variables (“call symput”)

The data will then do the following:
	Using the MIN and MAX values from PROC MEANS, Normalize the X values to a range of 0.0 to 1.0
	Multiply the normalized value by the number of desired buckets and take the integer value
	The result will be an integer ranging from 0 to N-1 (where N is the number of buckets).
	Example: 
	 If there are 4 desired buckets and the normalized value is 0.7
    4 * 0.7 = 2.8
	  Integer value of 2.8 = 2
    BUCKET = 2
*/
proc means data=TEMPFILE noprint;
output 	out	= MEANFILE 
	min(X)	= MINx 
	max(X)	= MAXx;
run;

data;
set MEANFILE;
call symput("MINx",MINx);
call symput("MAXx",MAXx);
run;

%let BIN = 4;

data XFORM;
set TEMPFILE;
NORM_X  	= ( X - &MINX. ) / (&MAXX.-&MINX.);
BUCKET_X	= min(int(&BIN.*NORM_X),&BIN.-1);
run;


/*-------------------------------------------------------------------------
Quantiles
The following SAS code will place the X values into 4 quantiles that will all have 
    approximately the same membership.
Run a PROC RANK and store the output into a SAS Data Set named “RANKFILE”
Run a PROC MEANS and determine the maximum value of each Quantile
Write a Data Step with “IF-THEN-ELSE” Logic to put X into a Quantile
NOTE: After the PROC RANK has been executed, the data has been placed into the 
    appropriate quantiles. The data step is therefore unnecessary. 
    The purpose of writing the DATA STEP is to be able to put new data into quantiles 
    when the model has been placed into production.
*/

%let BIN = 4;

proc rank data=TEMPFILE out=RANKFILE  groups=&BIN.;
var X;
ranks QUANT_X;
run;

proc print data=RANKFILE(obs=10);
run;
proc means data=RANKFILE MAX;
class QUANT_X;
var X ;
run;

data XFORM;
set TEMPFILE;
if 	X <= -2.6412568 then QUANT_X = 0;
else if 	X <= 20.9473816 then QUANT_X = 1;
else if 	X <= 84.8102529 then QUANT_X = 2;
else QUANT_X = 3;
run;

proc freq data=XFORM;
table QUANT_X / plots=freqplot;
run;

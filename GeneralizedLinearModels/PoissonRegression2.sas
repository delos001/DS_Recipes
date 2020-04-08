/*
Note: Poisson Regression is actually a special case of Negative Binomial Regression 
    where the mean and the variance are equal. 
  Many times, if the variance and the mean are similar, both Poisson and Negative Binomial 
    Regressions will converge to the same result.
	Poisson Regression	Predictive Model for "Count Data"  positive integer target 
    variables 0,1,2,3, ect
		
Predictive Model for "Count Data"  positive integer target variables 0,1,2,3, ect

  The data follows either
	  “Poisson” Distribution
	   “Negative Binomial” Distribution
LINEAR REGRESSION Not usually a good choice because:
  The relationship between INPUTS and TARGET are not linear
  Linear Regression can yield a NEGATIVE prediction (Counts must be >0)
 
Errors distribution won’t be random (“heteroskedastic”)
		
	example	Assume:
		        X6    = 20    
		        X8    = 35.3
		                LN_Yi = 2.0213" + 0.0297∗X6 - 0.0074∗X8"
		                LN_Yi = 2.0213" + 0.0297∗20 - 0.0074∗35.3"
		                2.3541 = 2.0213" + 0.0297∗20 - 0.0074∗35.3"
		                
		                Y_i  = exp(LN_Yi)
		                Y_i  = exp(2.3541)
		                10.5284 = exp(2.3541)
		
		Expected Count is 10.5284 
		Note: Even though the “Y” values are integers, the output can be continuous numbers
 */
		
*----------------------------------------------------------------------------;
*Poisson, Negative Binomial and Regression combined example;

NOTE: 
for poisson, mean should equal var.  
for neg binomial, var greater than mean.  
(its not in this example but we still use this just to show the code).  
Tukey says violations can be violated and we can still get good results some times
*----------------------------------------------------------------------------;

data TEMPFILE;
input X6 X8 YTEMP;
Y = round(YTEMP,1);
drop YTEMP; 
datalines;
20  35.3  10.98
20  29.7  11.13
23  30.8  12.51
20  58.8  8.40
; run;

proc means data=TEMPFILE MEAN VAR;
var Y;
run;

proc univariate data=TEMPFILE noprint;
histogram Y;
run;


proc reg data=TEMPFILE;
model Y = X6 X8;
output out=TEMPFILE p=Y_REG;
run;
quit;

proc genmod data=TEMPFILE;
model Y = X6 X8 /link=log dist=poi;   *PROC GENMOD with POISSON (“poi”) distribution;
output out=TEMPFILE p=Y_POI;
run;

proc genmod data=TEMPFILE;
model Y = X6 X8 /link=log dist=nb;   *PROC GENMOD with NEGATIVE BINOMIAL (“nb”) distribution;
output out=TEMPFILE p=Y_NB;
run;

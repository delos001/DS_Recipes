
/*----------------------------------------------------------------
where error is a function created: 
error = 50*normal(0) ;  
where normal is a SAS function that creates random variables 
(will generate one random variable for each observation in the data set)
*/

proc sgplot ;
  histogram error 
run;
  
/*----------------------------------------------------------------
specify LotArea as the variable and binwidth of 15000
*/ 

proc sgplot data=temp1;
	histogram LotArea / binwidth=15000;
run;


/*----------------------------------------------------------------
Midpoints specifies midpoints of the bar charts so the tally will 
be based on these
*/ 

proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength /midpoints = 0  2  4  6  8  10  12  14 ;
run;


/*----------------------------------------------------------------
MATRIX WITH HISTOGRAM
*/ 

/*----------------------------------------------------------------
Proc corr with temp1 data, 
plotted in matrix with histogram down diagonal.  
nvar for all data
*/ 

ods graphics on;
title "OLS Regression SAS Tutorial";
title2 "Scatterplot Matrix";
proc corr data=temp1 plot=matrix(histogram nvar=all);
run;
ods graphics off;


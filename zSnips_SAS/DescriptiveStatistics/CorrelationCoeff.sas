* NOTE: proc corr should be between continuous data points (not categorical);


/*-----------------------------------------------------------------------------
Basic Example
-----------------------------------------------------------------------------*/

title "Proc Corr Example: Anscombe Quartet";
ods graphics on;
proc corr data=temp1 
  rank plots=matrix  plots(maxpoints=none);   /* to include all points*/
	var x1;                               /* Correlate x1 with y1*/
	with y1;
	Title2 "X1 and Y1 Correplation";
run;


/*-----------------------------------------------------------------------------
Chose all numeric variables (rather than type each var of interest)
-----------------------------------------------------------------------------*/

proc corr data=temp1 rank;   *correlation and ranks correlation value (highest value first);
	var _numeric_;       *this tells sas to chose all variables that are numeric;
	with saleprice;
run;

/*-----------------------------------------------------------------------------
Chose columns based on names (rather than type each var of interest)
-----------------------------------------------------------------------------*/
proc corr data=temp;
var return_:;			*return_:  get every column that begins with return_  and : is a wild card;
	with response_VV;    
run; quit;


/*-----------------------------------------------------------------------------
Create correlatin matrix
proc corr with temp1 data, plotted in matrix with histogram down diagonal.  
nvar for all data
-----------------------------------------------------------------------------*/
title "OLS Regression SAS Tutorial";
ods graphics on;

title2 "Scatterplot Matrix";
proc corr data=temp1 plot=matrix(histogram nvar=all);
run;
ods graphics off;



/*----------------------------------------------------------------------------
PROC MEANS-------------------------------------------------------------------
----------------------------------------------------------------------------*/

/*
proc means for 1st and 99th percentile based on target wins variable 
(variable of interest)
*/

proc means data=mbraw p1 p99;
var target_wins;
run;

/*---------------------------------------------------------------------------
proc means to get general statistics (you specify which)
-standard deviation, 
-1st, fifth twenty fifth, seventyfifth, ninety fifth percentiles, 
-minimum, maximum, median, mean, 
-number of observations, number of missing observations
*/

proc means data=mbraw  stddev p1 p5 p25 p75 p95 min max mean median n nmiss;


/*---------------------------------------------------------------------------
creates a class so each variable will have the proc mean values grouped by 
number of above ground bedrooms
*/
proc means data=temp1;
	class bedroomAbvGr;
	var saleprice;
run;


/*---------------------------------------------------------------------------
apply mean based on a criteria
*/
proc means data=&TEMPFILE. mean var;
where ShowerLength > 0;
var ShowerLength;
run;




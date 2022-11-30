

/*---------------------------------------------------------------------
Example 1
gives a lot of stats about sale price:
look at the quanitles: gives you information about the 
    1.5IQR +Q3 and Q1-1.5IQR
---------------------------------------------------------------------*/
proc univariate normal plot data=temp1;
	var saleprice
	histogram saleprice/normal (color=red w=2);
run;


/*---------------------------------------------------------------------
Example 2
gets the specified quantiles
---------------------------------------------------------------------*/
proc means data=temp1 p5 p10 p25 p50 p75 p90 p95 ndec=2;
class y;
var x1 x2 x3;
run;

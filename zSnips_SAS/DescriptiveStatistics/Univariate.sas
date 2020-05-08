



/*----------------------------------------------------------------------------
PROC UNIVARIATE---------------------------------------------------------------
-----------------------------------------------------------------------------*/

/*
Example 1
gives a lot of stats about sale price:
look at the quanitles: gives you information about the 1.5IQR +Q3 and Q1-1.5IQR
*/
proc univariate normal plot data=temp1;
	var saleprice;
	histogram saleprice/normal (color=red w=2);
run;


/*
Example 2
*/
proc univariate data=TEMPFILE noprint;
histogram X;
run;

proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength /midpoints = 0  2  4  6  8  10  12  14 ;
run;

/*
Example 3
*/
proc univariate normal plot data=mbmod1a;
	var Target_Wins
		sqTarget_Wins 
		logTarget_Wins
		log2Target_Wins
		hlfPTarget_Wins
		neghlfPTarget_Wins
		recipTarget_Wins;
	histogram Target_Wins
		sqTarget_Wins 
		logTarget_Wins
		log2Target_Wins
		hlfPTarget_Wins
		neghlfPTarget_Wins
		recipTarget_Wins/normal (color=red w=2);
run;
ods graphics off;






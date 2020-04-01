/* BASIC LOESS LINE */

ods graphics on;
proc sgplot data=temp1;                                   /*proc sgplot statement using temp1 data*/
	loess x=x1 y=y1 / nomarkers;                            /*creates a LOESS curve with no markers */
	reg x=x1 y=y1;                                          /*creates a regression line */
	Title2 "X1 and Y1 Scatter Plot with LOESS and Regression Curve";    /*creates second level title */
run;

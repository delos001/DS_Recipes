
/*---------------------------------------------------------------
proc sgplot statement using temp1 data
creates a LOESS curve with no markers
creates a regression line
creates second level title
*/

ods graphics on;
proc sgplot data=temp1;
	loess x=x1 y=y1 / nomarkers;
	reg x=x1 y=y1;
	Title2 "X1 and Y1 Scatter Plot with LOESS and Regression Curve";
run;


/*---------------------------------------------------------------
proc scatter with temp1 data
another way was to plot against but also adds LOESS and Regression Curve
adds second level title
*/

Proc SGscatter data=temp1;
	compare x=x1 y=y1 / loess reg;
	title2 "X1 and X2 Scatter Plot with LOESS and Regression Curve";
run;

ods graphics on;
ods graphics off

/* BASIC SCATTER PLOT----------------------------------------------------------*/

/* Ex 1 */
proc sgplot ;
  scatter x=x y=y;
run;

/* Ex 2 */
proc sgplot data=sample ; 
       scatter x=sat y=gpa ;
title "Enter Title Here";
run ;

/*--------------------------------------------------------------------------------
proc scatter with temp1 data
plot and also adds LOESS and Regression Curve
*/

Proc SGscatter data=temp1;
	compare x=x1 y=y1 / loess reg;
	title2 "X1 and X2 Scatter Plot with LOESS and Regression Curve";
run;

/*--------------------------------------------------------------------------------
Print 2 scatter plots next to each other
*/
proc sgscatter data=temp2;
	plot(saleprice logsaleprice) * grlivarea;
run;

/*--------------------------------------------------------------------------------
Print 2x2 scatter plot grid
*/

proc sgscatter data=temp2;
	plot(saleprice logsaleprice) * (grlivarea loggrlivarea);
run;

/* SCATTER PLOT MATRIX----------------------------------------------------------*/

/*--------------------------------------------------------------------------------
lists each variable you want in the scatter plot matrix
with salesprice as the response variable
*/

proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
	var LotFrontage LotArea MasVnrArea BsmtFinSF1;
	with saleprice;
run;

/*--------------------------------------------------------------------------------
scatter plot matrix for multiple variables
*/
proc corr data=temp1 rank plots=matrix plots(maxpoints=none);
	var BsmtFinSF1 BsmtUnfSF FirstFlrSF GarageArea GrLivArea
	LotArea LowQualFinSF MasVnrArea OpenPorchSF PoolArea
	SecondFlrSF TotalBsmtSF WoodDeckSF;
run;


/*--------------------------------------------------------------------------------
proc corr with temp1 data, plotted in matrix with histogram down diagonal.  
nvar for all data
*/

title "OLS Regression SAS Tutorial";
title2 "Scatterplot Matrix";
proc corr data=temp1 plot=matrix(histogram nvar=all);
run;


/* SCATTER WITH LINES------------------------------------------------------------*/

/*--------------------------------------------------------------------------------
scatter plot of temp1 data
create linear regression line in the scatter plot
*/

proc sgplot data=temp1;
	reg x=masvnrarea y=saleprice / lineattrs=(color=red thickness=3);
run;

proc sgscatter data=temp1;
compare x=(GrLivArea)
	y=Saleprice/loess;
run;


/* SCATTER GROUPING BY COLOR------------------------------------------------------------*/

/*--------------------------------------------------------------------------------
abels each data point with the corresponding country.  colors by the "group" variable
*/
proc sgplot data=temp;
	title 'Scatter Plot: Raw Employment Data';
	scatter y=tc x=ser / datalabel=country group=group;
run;

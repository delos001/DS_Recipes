
/* BASIC BAR CHARTS----------------------------------------------------------------*/

/* vertical bar chart*/
proc sgplot data=temp1;
	vbar OverallQual;
run;


/* horizontal bar chart*/
proc sgplot data=temp1;
	hbar Exterior1;
run;


/* GROUPED BAR CHARTS --------------------------------------------------------------*/

/*------------------------------------------------------------------------------------
long_correlations is the data
xaxis is tkr, 
the value of bars is from the correlation column column and 
it is grouped (colored by and in the legend too) by sector
*/ 

ods graphics on;
title 'Market Index Correlations';  
proc sgplot data=long_correlations;  
	format correlation 3.2;
	vbar tkr / response=correlation group=sector 
	groupdisplay=cluster datalabel;
run; quit;
ods graphics off;

/*------------------------------------------------------------------------------------
format might be the graph type (need to look up)
put sector on the xaxis, 
the bar values are the correlation, 
it is grouped by the trk column, and the xaxis data lablels are clustered
*/
ods graphics on;
title 'Correlations with the Market Index';
proc sgplot data=long_correlations;
	format correlation 3.2;
	vbar sector / response=correlation group=tkr groupdisplay=cluster datalabel;
run; quit;
ods graphics off;


/*------------------------------------------------------------------------------------
nway suppresses SAS from creating a row with overall mean.  
noprint suppreses the output from printing (helpful if large output)
creates a class so the mean of each class can be calculated 
	(in this case, the classes set by the sector column)
the variable that the mean is being calcualted on is the correlation column
set an output, name it mean_correlation then get the mean of the correlation (by sector) and 
put in new column in output call mean_correlation
*/

proc means data=long_correlations nway noprint;
class sector;
var correlation;
output out=mean_correlation mean(correlation)=mean_correlation;
run;

ods graphics on;
title 'Mean Correlations with the Market Index by Sector';
proc sgplot data=mean_correlation;
	format mean_correlation 3.2;
	vbar sector / response=mean_correlation datalabel;
run;
ods graphics off;


/*------------------------------------------------------------------------------------
default use of proc sgplot
notince here that it gets mean of the data label (same thing that was done above)
*/

ods graphics on;
title 'Mean Correlations with the Market Index by Sector - SGPLOT COMPUTES MEANS';
proc sgplot data=long_correlations;
	format correlation 3.2;
	vbar sector / response=correlation stat=mean datalabel;
run; quit;
ods graphics off;

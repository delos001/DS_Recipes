
/*BASIC PARTIAL REGRESSION WITH PLOT OUTPUT EXAMPLE
creates regression model with partial regression
Output plots :
1:studentized residuals vs. predited values
2:studentized residuals vs. regressors
3: studentized residuals by time plots the normal probability plot of studentized residuals
*/


Model time=cases distance / partial;
	plot rstudent.*(predicted. cases distance obs.);
	
	plot npp.*rstudent
run;

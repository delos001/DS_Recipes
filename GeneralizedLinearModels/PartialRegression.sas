
/*
To find the impact of the nested variables (additional variables) added to a model:
FULL MODEL:   
  Y(math) = b0 + b1*X1 + b2*X2 + b3*X3 + b4*X4+ b5*X5+ b6*X6

REDUCED MODEL:   
  Y(math) = b0 + b1*X1 + b2*X2 + b3*X3 + b4*X4

Note the reduced model is fully nested within the full model.  
All variables of reduced model are in full model.  
We could go through a process like was done above and isolate the unique contributions to each of the variables. 
What is the difference in the two models?  Conceptually, it is the unique contributions of X5, X6.   
Computationally, it is:    
SS(X5,X6) = SS(regression full model) – SS(regression reduced model)
*/



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

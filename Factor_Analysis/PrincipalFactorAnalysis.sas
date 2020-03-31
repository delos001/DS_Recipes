
/*
input data set
method of estimation: principal, prinit, ml, uls  these are: 
      (interative principal FA, maximul likelihood, unweighted least squares)
set prior communality estimates: max, smc, one (required):
      (always use SMC squared multiple correlation first and then max (maximum absolute correlation) if needed)
perform a rotation: none, varimax, promax  (varimax is orthogonal, promax is oblique where factors will be correlated)

SAE default for priors is one and this will cause Proc Factor to perform Principal Component Analysis not Factor Analysis  
*/

Proc Factor
	data=value
	method=principal
	priors=smc
  rotate=none

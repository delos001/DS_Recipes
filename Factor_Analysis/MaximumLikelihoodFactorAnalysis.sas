
/*
method of estimation: principal, prinit, ml, uls  
  these are: (interative principal FA, maximul likelihood, unweighted least squares)
set prior communality estimates: max, smc, one  
  (need to specify this: always use SMC squared multiple correlation first and then max (maximum absolute correlation) if needed)
perform a rotation: none, varimax, promax  
  (varimax is orthogonal, promax is oblique where factors will be correlated)

NOTE: Prinit, ML, ULS are all iterative methods so if estimated communality exceeds 1, SAS will stop iterating 
  in this case we do not have a valid factor solution
SAS will allow these options to continue to interate if you specify Heywood or Ultraheywood option 
  (but these aren't considered valid for factor analysis)

Maximum likelihood factor analysis is a formal statistical model with formal statistical assumptions that allow statistical inference.  hence output from a ML FA will contain additional information that is not available for the other estimation procedures (principal, iterative principal, and unweighted FA)
*/

Proc Factor
	data=value
	method=ML
	priors=smc
  rotate=none

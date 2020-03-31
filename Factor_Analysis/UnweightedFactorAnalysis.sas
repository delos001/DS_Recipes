
/*
note: other arugments left off to focus those directly needed for principal FA (see parent Factora Analysis tab for other arguments).  
Example, you will want to specify 
    the number of common factors (nfactors) or the mineigen, or proportion too. 
    (SAS defaults to proportion if none are specified)
    
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

*/

Proc Factor
	data=value
	method=ULS
	priors=smc
  rotate=none

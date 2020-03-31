/*
Proc Factor
	data=value: input data set
	method=value: method of estimation: principal, prinit, ml, uls  
		these are: (interative principal FA, maximul likelihood, unweighted least squares)
	priors=value: set prior communality estimates: max, smc, one  
		(need to specify this: always use SMC squared multiple correlation first and 
		then max (maximum absolute correlation) if needed)
	nfactors=value: number of common factors to fit  
		(if you specify this option, don't use mineigen or proportion)
	mineigen=0 (default): minimum eigenvalue criteria for factor selection  
		(if you specify this option, don't use nfactor or proportion)
	proportion=value: value in range (0,1) 
		selects # of common factors needed for predetermined variance proportion 
		(ie 70% variance explained) (if you specify this option, don't use nfactor or mineigen)
	rotate=none(default): perform a rotation: none, varimax, promax  
		(varimax is orthogonal, promax is oblique where factors will be correlated)
	reorder: reorders the values from high to low
	out=value: output data set with original data and factor scores
	outstat=value: output data set containing all associated statistical output
	plots=all: produce all plots associated with factor anlayis
	nplots=value: number of factors to plot, default is all factors
	residuals: call by name option for producing residual correlation matrix, diagonal elements are the unique variances
	reorder: call by name option for reordering variables in the output data set so varaibles are 
			grouped based on their factors relationships
	heywood: allows Heywood estimating procedure which 
			allows communality estimates to exceed 1 (not valid for factor analysis)
	var a b c d: you use var to specify if you are only interested in doing FA on a certain number of variables 
		(if you leave this out, all variables in data set will be used)

SAE default for priors is one and this will cause Proc Factor to perform Principal Component Analysis not Factor Analysis  
*/

/*----------------------------------------------------------------------------------------------
Principal Factor Analysis
----------------------------------------------------------------------------------------------*/
Proc Factor
	data=value
	method=principal
	priors=smc
	rotate=none



libname mydata "/scs/wtm926/" access=readonly;

data temp;
	set mydata.stock_portfolio_data;
run;

proc contents data=temp;
run;

proc print data=temp(obs=10); 
run;

proc sort data=temp;
	by date;
run;

proc print data=temp(obs=10); 
run;

/*Q1
drop some fo the variables to be left with banking, oild field svs, 
oil refining, industrial*/
data tempdrop;
	set temp;
drop AA HON MMM DPS KO PEP MPC GS ;
run;

/*compute log returns for remaining data variables*/
proc sort data=temp; by date; 
run;
data tempdrop1;
	set tempdrop;
	
	return_BAC = log(BAC/lag1(BAC));
	return_BHI = log(BHI/lag1(BHI));
	return_CVX = log(CVX/lag1(CVX));
	return_DD  = log(DD/lag1(DD));
	return_DOW = log(DOW/lag1(DOW));
	return_HAL = log(HAL/lag1(HAL));
	return_HES = log(HES/lag1(HES));
	return_HUN = log(HUN/lag1(HUN));
	return_JPM = log(JPM/lag1(JPM));
	return_SLB = log(SLB/lag1(SLB));
	return_WFC = log(WFC/lag1(WFC));
	return_XOM = log(XOM/lag1(XOM));
	response_VV = log(VV/lag1(VV));
run;

proc print data=tempdrop1(obs=10);
run;

ods trace on;
ods output PearsonCorr=portfolio_correlations;
proc corr data=tempdrop1;
var return_:;
	with response_VV;
run;
ods trace off;

proc print data=portfolio_correlations; 
run; 

/*set data as wide_correlations from portfolio and keep all columns
that begin with return_*/
data wide_correlations;
	set portfolio_correlations (keep=return_:);
run;

/*use proc transpose to change data type from wide to long*/
proc transpose data=wide_correlations out=long_correlations;
run; 

data long_correlations;
	set long_correlations;
	tkr = substr(_NAME_,8,3);
	drop _NAME_;
	rename COL1=correlation;
run;

proc print data=long_correlations; 
run; 

/*merge on the sector ID*/

data sector;
input tkr $ 1-3 sector $ 4-35; 
datalines;
BAC Banking
BHI Oil Field Services
CVX Oil Refining
DD  Industrial - Chemical
DOW Industrial - Chemical
HAL Oil Field Services
HES Oil Refining
HUN Industrial - Chemical
JPM Banking
SLB Oil Field Services
WFC Banking
XOM Oil Refining
VV  Market Index
;
run;
/*now print the data set created above*/
proc sort data=sector; 
	by tkr; 
run;

proc print data=sector; 
run;


proc sort data=long_correlations; 
	by tkr; 
run;

proc print data=long_correlations; 

/*merge the data_long correlations set with the sector set to 
combine the industries with the correlations against reponse variable
VV*/
data long_correlations;
	merge long_correlations (in=a) sector (in=b);
	by tkr;
	if (a=1) and (b=1);
run;

proc print data=long_correlations; 
run;

data return_data;
	set tempdrop1 (keep= return_:);
run;

/*Q2
performing a Principal Factor Analysis without a factor rotation. 
Under this SAS procedure call SAS will automatically select the number
of factors to retain.*/

ods graphics on;
proc factor data=return_data
	method=principal
	priors=smc
	rotate=none
	plots=(all);
run;
ods graphics off;

/*Q3
apply VARIMAX rotation to the Principal Factor Analysis*/

ods graphics on;
proc factor data=return_data
	method=principal
	priors=smc
	rotate=varimax
	plots=(all);
run;
ods graphics off;

/*Q4
s use Maximum Likelihood Estimation to estimate the 
common factors (Maximum Likelihood Factor Analysis) 
with a VARIMAX rotation*/

ods graphics on;
proc factor data=return_data
	method=ML
	priors=smc
	rotate=varimax reorder
	plots=(all);
run;
ods graphics off;

/*Q5
Maximum
Likelihood Factor Analysis with a VARIMAX rotation (the same factor 
analysis as in (4)), but with the MAX argument for the PRIORS option*/

ods graphics on;
proc factor data=return_data
	method=ML
	priors=max
	rotate=varimax reorder
	plots=(all loadings);
run;
ods graphics off;

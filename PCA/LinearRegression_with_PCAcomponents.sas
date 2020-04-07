
Code:
libname mydata "/scs/wtm926/" access=readonly;

data temp;
	set mydata.stock_portfolio_data;
run;

proc print data=temp(obs=10); 
run;

proc contents data=temp;

proc sort data=temp;
	by date;
run;

proc print data=temp(obs=10); 
run;

/*Note that the data needs to be sorted in the correct
direction in order for us to compute the correct return;
proc sort data=temp; by date; run; quit*/

* Compute the log-returns: log of the ratio of today's price to 
yesterday's price;

data temp;
	set temp;

	return_AA  = log(AA/lag1(AA));
	return_BAC = log(BAC/lag1(BAC));
	return_BHI = log(BHI/lag1(BHI));
	return_CVX = log(CVX/lag1(CVX));
	return_DD  = log(DD/lag1(DD));
	return_DOW = log(DOW/lag1(DOW));
	return_DPS = log(DPS/lag1(DPS));
	return_GS  = log(GS/lag1(GS));
	return_HAL = log(HAL/lag1(HAL));
	return_HES = log(HES/lag1(HES));
	return_HON = log(HON/lag1(HON));
	return_HUN = log(HUN/lag1(HUN));
	return_JPM = log(JPM/lag1(JPM));
	return_KO  = log(KO/lag1(KO));	
	return_MMM = log(MMM/lag1(MMM));
	return_MPC = log(MPC/lag1(MPC));
	return_PEP = log(PEP/lag1(PEP));
	return_SLB = log(SLB/lag1(SLB));
	return_WFC = log(WFC/lag1(WFC));
	return_XOM = log(XOM/lag1(XOM));
	*return_VV  = log(VV/lag1(VV));
	response_VV = log(VV/lag1(VV));
run;

proc print data=temp(obs=10); run; quit;

/* Use ODS TRACE to print out all of the data sets available to 
ODS for a particular SAS procedure.;
* We can also look these data sets up in the SAS User's Guide*/
ods trace on;
ods output PearsonCorr=portfolio_correlations;
proc corr data=temp;
var return_:;
	with response_VV;
run; quit;
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
AA  Industrial - Metals
BAC Banking
BHI Oil Field Services
CVX Oil Refining
DD  Industrial - Chemical
DOW Industrial - Chemical
DPS Soft Drinks
GS  Banking
HAL Oil Field Services
HES Oil Refining
HON Manufacturing
HUN Industrial - Chemical
JPM Banking
KO  Soft Drinks
MMM Manufacturing
MPC Oil Refining
PEP Soft Drinks
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

/*create a grouped bar plot*/
ods graphics on;
title 'Market Index Correlations';
proc sgplot data=long_correlations;
	format correlation 3.2;
	vbar tkr / response=correlation group=sector 
	groupdisplay=cluster datalabel;
run; quit;
ods graphics off;

/*create again with changes to formatting*/
ods graphics on;
title 'Market Index Correlations';
proc sgplot data=long_correlations;
	format correlation 3.2;
	vbar sector / response=correlation group=tkr 
	groupdisplay=cluster datalabel;
run;
ods graphics off;

/*produce plots by sector of the mean correlation*/
proc means data=long_correlations nway noprint;
class sector;
var correlation;
output out=mean_correlation mean(correlation)=mean_correlation;
run;

proc print data=mean_correlation; 
run;

/*crate barplot based on mean correlation*/
ods graphics on;
title 'Mean Market Index Correlations by Sector';
proc sgplot data=mean_correlation;
	format mean_correlation 3.2;
	vbar sector / response=mean_correlation datalabel;
run;
ods graphics off;

/*use SGPLOT stat=mean to calculate mean for the sectors*/
ods graphics on;
title 'Mean Correlations with the Market Index by Sector - SGPLOT COMPUTES MEANS';
proc sgplot data=long_correlations;
	format correlation 3.2;
	vbar sector / response=correlation stat=mean datalabel;
run; quit;
ods graphics off;

title '';

/*Q5
create a new data set that only has the predictor variables and 
not the response variable*/

data return_data;
	set temp (keep= return_:);
run;

proc print data=return_data (obs=10);
run;

/*Compute principal components*/
ods graphics on;
proc princomp data=return_data 
	out=pca_output 
	outstat=eigenvectors 
	plots=scree(unpackpanel);
run;
ods graphics off;

proc print data=pca_output(obs=10); 
run; 

/*plotting the first 2 eigen values*/
data pca2;
	set eigenvectors(where=(_NAME_ in ('Prin1','Prin2')));
	drop _TYPE_ ;
run;

proc print data=pca2; 
run;

proc transpose data=pca2 out=long_pca; 
run;
proc print data=long_pca; 
run;

data long_pca;
	set long_pca;
	format tkr $3.;
	tkr = substr(_NAME_,8,3);
	drop _NAME_;
run;

proc print data=long_pca; 
run;

/* Plot the first two principal components*/
ods graphics on;
proc sgplot data=long_pca;
scatter x=Prin1 y=Prin2 / datalabel=tkr;
run; quit;
ods graphics off;

/*Q6
Use principal components in regression modeling
Split the data into train and test data sets
	*append a column in its current order;
	*generate a uniform(0,1) random variable with seed set to 123*/
data cv_data;
	merge pca_output temp(keep=response_VV);

	u = uniform(123);
	if (u < 0.70) then train = 1;
	else train = 0;

	if (train=1) then train_response=response_VV;
	else train_response=.;
run;

proc print data=cv_data(obs=10); 
run;

proc print data=temp(keep=response_VV obs=10); 
run; 
quit;

/*Q7
Fit a regression model using all of the individual stocks with 
train_response as the response variable*/
ods graphics on;
proc reg data=cv_data;
model train_response = return_: / vif ;
output out=model1_output predicted=Yhat ;
run; quit;
ods graphics off;

/*Q8
Fit a regression model using the first eight principal components using train_response as the response
variable*/
ods graphics on;
proc reg data=cv_data;
model train_response = prin1-prin8 / vif ;
output out=model2_output predicted=Yhat  ;
run; quit;
ods graphics off;

proc print data=model1_output(obs=10); 
run;

* Model 1 Individual Variables OLSR;
data model1_output;
	set model1_output;
	square_error = (response_VV - Yhat)**2;
	absolute_error = abs(response_VV - Yhat);
run;

proc means data=model1_output nway noprint;
class train;
var square_error absolute_error;
output out=model1_error 
	mean(square_error)=MSE_1
	mean(absolute_error)=MAE_1;
run; quit;

proc print data=model1_error; run;

* Model 2 PCA model;
data model2_output;
	set model2_output;
	square_error = (response_VV - Yhat)**2;
	absolute_error = abs(response_VV - Yhat);
run;

proc means data=model2_output nway noprint;
class train;
var square_error absolute_error;
output out=model2_error 
	mean(square_error)=MSE_2
	mean(absolute_error)=MAE_2;
run;

proc print data=model2_error; 
run;
/*merge the two tables (model1_error and model2_errror together*/
data error_table;
	merge model1_error(drop= _TYPE_ _FREQ_) 
		model2_error(drop= _TYPE_ _FREQ_);
	by train;
run;

proc print data=error_table; 
run;

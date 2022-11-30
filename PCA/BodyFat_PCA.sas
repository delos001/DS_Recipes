<<<<<<< HEAD
/* In SAS, principal components are computed using numerical linear algebra */

/* -------------------------------------------------------------------------------------
BASIC FUNCTION INPUTS:
--------------------------------------------------------------------------------------*/

proc princomp  /*principal component procedure step (run initial, look at screeplot to know how many ncomps to include */
data = temp1;
ncomp = 8                 /*optional argument: specify the number of principal components to compute*/
prefix = %str(test)       /*optional argument: prefix for naming the principal components*/
out = outvalue            /*name the data set*/
outstat = eigenvectors    /*specify the statistic you want to go to the output, ie: eigenvectors, factors, eigenvalues, etc*/
ID = idvalue              /*create labels for the observations*/

/*do this after you did screeplot to figure out the ncomp: produce all plots associated with PCA  
      (other options include: none, scatter, pattern, unpack, unpackpanel*/
plots = all
/*do this plot first to identif ncomp number if you want:  
      will produe the scree plot an and variance explained in a panel plot*/
plots = Scree(unpackpanel)


/* -------------------------------------------------------------------------------------
EXAMPLE 1:
--------------------------------------------------------------------------------------*/
ODS GRAPHICS ON;

libname mydata "/scs/wtm926/" access=readonly;

DATA bodyfat;
  SET mydata.bodyfat;
 if (height > 40) ;               /*specify only observations in height column where height is >40*/
RUN;

proc sgplot data=bodyfat ;       /*reate scatter plot of height vs. weight*/
   scatter x=weight y=height ;
run ;

proc princomp 
data=bodyfat 
out=pca_output 
outstat=eigenvectors 
plots=scree(unpackpanel);
  var age--wrist_cir ;            /*variable of interest (age) and every other variable in between age and wrist_circ*/
run; 

proc print data=pca_output(obs=10); 
run; 
QUIT;


/* -------------------------------------------------------------------------------------
FULL EXAMPLE:
--------------------------------------------------------------------------------------*/
ods graphics on;
proc princomp data=return_data 
	out=pca_output 
	outstat=eigenvectors 
	plots=scree(unpackpanel);
run;
ods graphics off;


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

ods graphics on;
proc reg data=cv_data;
model train_response = return_: / vif ;
output out=model1_output predicted=Yhat ;
run; 
quit;
ods graphics off;
=======
/* 
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
*/

TITLE "Read in Body Fat Datafile and Begin Analysis";
ODS GRAPHICS ON; * to get scatterplots with high-resolution graphics out of SAS procedures;


libname mydata "/scs/wtm926/" access=readonly;


DATA bodyfat;
  SET mydata.bodyfat;
 if (height > 40) ;
RUN;


proc sgplot data=bodyfat ;
   scatter x=weight y=height ;
run ;



proc princomp data=bodyfat out=pca_output outstat=eigenvectors plots=scree(unpackpanel);
  var age--wrist_cir ;
run; 


proc print data=pca_output(obs=10); run; 


QUIT;
>>>>>>> 410e3143e2365ba628386f53654e16a34d6951fa

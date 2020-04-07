

libname mydata'/scs/wtm926/' access=readonly;
proc datasets library=mydata;
run;

Data temp1;
	set mydata.ames_housing_data;

proc contents data=temp1;
run;

/*get frequencies for lot frontage variable*/
proc freq data=temp1;
	tables lotconfig;
run;

/* Part A 
Q1**************
Select a Character (i.e. a string or qualitative) variable 
that has at least 3 categories that you think might be useful
in understanding or predicting SalePrice (Y). In a SAS data step,
create a numerically coded categorical variable that has a number
indicating each of the levels of the character variable.*/

data lotconfig1;
	set temp1;
	if lotconfig='Corner' then lotconfigcode=1;
	if lotconfig='CulDSac' then lotconfigcode=2;
	if lotconfig='FR2' then lotconfigcode=3;
	if lotconfig='FR3' then lotconfigcode=4;
	if lotconfig='Inside' then lotconfigcode=5;

/*create table to make sure all was coded correctly*/
proc freq data=lotconfig1;
	tables lotconfig lotconfigcode;
run;

/*Once you have created this categorical variable, use a 
PROC SORT on this categorical variable*/
proc sort data=lotconfig1;
 by lotconfigcode;

/*Once you have created this categorical variable, use a 
PROC MEANS BY the categorical variable to find the mean of 
Y (SalePrice) of each level of the categorical variable.*/
proc means data=lotconfig1;
	by lotconfigcode;
	var saleprice;

/*Q2**************
Fit a simple linear regression model using the categorical 
variable from step 1) as the predictor variable to predict 
Y (SalePrice)*/
proc reg data=lotconfig1;
	model saleprice=lotconfigcode;
run;
	
/*Q3***************
In a new SAS data step, dummy code the categorical variable
 so that there is one dummy coded variable for each category*/
 
 Data lotconfig2;
 	set lotconfig1;
 	
 	if Lotconfig in ('Corner','CulDSac','FR2','FR3','Inside')
 		then do;
 		/*note you are leaving out 'corner' to create baseline*/
 		lotconfig_cul = (lotconfig eq 'CulDSac');
 		lotconfig_fr2 = (lotconfig eq 'FR2');
 		lotconfig_fr3 = (lotconfig eq 'FR3');
 		lotconfig_ins = (lotconfig eq 'Inside');
 		end;
 		
/*create table to make sure all was coded correctly*/
 proc freq data=lotconfig2;
 	table lotconfig lotconfig_cul lotconfig_fr2 lotconfig_fr3
 		lotconfig_ins;
 run;

/*Fit a multiple regression model using the dummy coded variables,
but be sure to leave the dummy coded variable out of the model for
the category that is the basis for interpretation. */ 

proc reg data=lotconfig2;
	model saleprice= lotconfig_cul lotconfig_fr2 lotconfig_fr3 
	lotconfig_ins;
run;

/*Q5***********
Create a set of dummy coded variables for at least one other 
character var of your choice that has at least 3 categories.
create table to identify variables*/
proc freq data=temp1;
	tables paveddrive;
run;

/*create numerical code for each level*/
data paveddrive1;
	set lotconfig2;
	if paveddrive='Y' then paveddrivecode=1;
	if paveddrive='P' then paveddrivecode=2;
	if paveddrive='N' then paveddrivecode=3;

/*check frequencies to make sure coded correctly*/
proc freq data=paveddrive1;
	tables paveddrive paveddrivecode;
run;
	
Data paveddrive2;
 	set paveddrive1;
 	
 	if  paveddrive in ('Y','P','N')
 		then do;
 		/*note you are leaving out 'y' to create baseline*/
 		paveddrive_p = (paveddrive eq 'P');
 		paveddrive_n = (paveddrive eq 'N');
 		end;
/*create table to make sure all was coded correctly*/
 proc freq data=paveddrive2;
 	table paveddrive paveddrive_p paveddrive_n;
 run;

/*change the dataset name to temp2*/ 
data temp2;
	set paveddrive2;

/*Part B 
Q6*************
Use all of the possible continuous predictor variables and the
dummy coded variables you created from Part A for this analysis*/

proc reg data=temp2;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=forward;
	
proc reg data=temp2;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=backward;

proc reg data=temp2;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=stepwise;

proc reg data=temp2;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=adjrsq aic bic;

/*after identifying the model parameters fro adjrsq selection
above, these are put in the proc reg to run the regression and
get the parameter estimates*/
proc reg data=temp2;
	model saleprice=LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF 
	FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ScreenPorch PoolArea MiscVal lotconfig_cul 
	lotconfig_ins paveddrive_p paveddrive_n;
	
	
proc reg data=temp2;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=cp aic bic;

/*after identifying the model parameters fro Mallows CP selection
above, these are put in the proc reg to run the regression and
get the parameter estimates*/
proc reg data=temp2;
	model saleprice=LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF 
	FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ScreenPorch PoolArea MiscVal lotconfig_cul 
	paveddrive_p paveddrive_n;
	
		
proc reg data=temp2 outest=rsqest;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=adjrsq aic bic;
	
proc sort data=rsqest; 
	by _aic_;
proc print data=rsqest;
run;

/*after identifying the model parameters fro AIC and BIC 
selection above, these are put in the proc reg to run the 
regression and get the parameter estimates*/
proc reg data=temp2;
	model saleprice=LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF 
	FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ScreenPorch PoolArea MiscVal lotconfig_cul 
	paveddrive_p paveddrive_n;

/*repeat above and sort by bic to see if that provides same
model*/	
proc reg data=temp2 outest=cpest;
	model saleprice=LotFrontage LotArea MasVnrArea BsmtFinSF1 
	BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF 
	LowQualFinSF GrLivArea GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ThreeSsnPorch ScreenPorch PoolArea MiscVal
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins
	paveddrive_p paveddrive_n/
	selection=adjrsq aic bic;
	
proc sort data=cpest; 
	by _bic_;
proc print data=cpest;
run;

/*Q7***********
Select one of the six models from step 6) that either has a 
dummy coded variable that was selected by the automated procedure
or non-statistically significant continuous variables or both. 
Call this the BASE model and please retain all of the summary fit
statistics (i.e R-squared, etc.). Now, refit the BASE model after
making the above described adjustments*/

/*using the Lowest AIC Automated Selection Variables*/
proc reg data=temp2;
	model saleprice=LotArea MasVnrArea BsmtFinSF1 TotalBsmtSF 
	FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ScreenPorch PoolArea MiscVal lotconfig_cul 
	paveddrive_p paveddrive_n;
/*remove LotArea. Add lotconfig_fr2 lotconfig_fr3 lotconfig_ins*/
proc reg data=temp2;
	model saleprice=MasVnrArea BsmtFinSF1 TotalBsmtSF 
	FirstFlrSF SecondFlrSF GarageArea WoodDeckSF OpenPorchSF 
	EnclosedPorch ScreenPorch PoolArea MiscVal lotconfig_cul 
	lotconfig_fr2 lotconfig_fr3 lotconfig_ins paveddrive_p 
	paveddrive_n;
	
/*repeating base model vs. refitted process with forward 
selection*/
proc reg data=temp2;
	model saleprice=LotArea MasVnrArea BsmtFinSF1 
	BsmtUnfSF TotalBsmtSF LowQualFinSF GrLivArea GarageArea 
	WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch 
	ScreenPorch PoolArea MiscVal lotconfig_cul lotconfig_ins
	paveddrive_p;
/*refitted: remove lotarea bsmtfinsf1 threessnporch and Add 
lotconfig_fr2 lotconfig_fr3 and paveddrive_n*/ 
proc reg data=temp2;
	model saleprice=MasVnrArea BsmtFinSF1 
	TotalBsmtSF LowQualFinSF GrLivArea GarageArea WoodDeckSF 
	OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal 
	lotconfig_cul lotconfig_ins lotconfig_fr2 lotconfig_fr3
	paveddrive_p paveddrive_n;
	
/*Q8*************
Create a train/test split of the data for cross-validation. We 
will use a standard SAS trick to keep “two” data sets as one data
set. We will do this by defining a new response variable 
train_response*/

Data bldgtype;
 	set temp2;
 	
 	if  bldgtype in ('1Fam','2fmCon','Duplex','TwnhsE','Twnhs')
 		then do;
 		/*note you are leaving out '1Fam' to create baseline*/
 		bldgtype_2F = (bldgtype eq '2fmCon');
 		bldgtype_Du = (bldgtype eq 'Duplex');
 		bldgtype_TE = (bldgtype eq 'TwnhsE');
 		bldgtype_TI = (bldgtype eq 'Twnhs');
 		end;
/*check to make sure coding worked*/
proc freq data=bldgtype;
	tables bldgtype bldgtype_2F bldgtype_Du bldgtype_TE 
	bldgtype_TI;
run;

data crossval;
	set bldgtype;

/* generate a uniform(0,1) random variable with seed set to 123*/
u=uniform(123);
if (u<0.70) then train=1;
else train=0;
if(train=1) then train_response=SalePrice;
else train_response=.;
run;

/*Q9********
Fit a multiple regression model using your choice of 
explanatory variables to predict Y (SalePrice). Note, this model 
is fit on entire set of data. Call this your “Original” Model */

Proc reg data=crossval;
	model saleprice=TotalBsmtSF FirstFlrSF SecondFlrSF 
	GarageArea bldgtype_2F bldgtype_Du bldgtype_TE bldgtype_TI
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins;
	output out=origModel predicted=yhat;
proc print data=origModel (obs=10);

Proc reg data=origModel;
	model train_response=TotalBsmtSF FirstFlrSF SecondFlrSF 
	GarageArea bldgtype_2F bldgtype_Du bldgtype_TE bldgtype_TI
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins;

/*9C************
Use a new SAS data step and a PROC MEANS statements to calculate
the average squared error and average absolute error (MAE)*/
Data crossval2;
	set origModel;
		maeOrig = abs(yhat-saleprice);
		maeTrain = abs(yhat-train_response);
		if train=0 then maeValid = abs(yhat-saleprice);
		else maeValid=.;
		
		mseOrig =(yhat-saleprice)*(yhat-saleprice);
		mseTrain =(yhat-train_response)*(yhat-train_response);
		if train=0 then mseValid =(yhat-saleprice)*(yhat-saleprice);
		else mseValid=.;
		
proc print data=crossval2 (obs=10);

/*use proce mean to get MAE*/
proc means data=crossval2;
	var maeOrig;
	title 'MAE Orignal Calculation';


proc means data=crossval2;
	var maeTrain;
	title 'MAE Training Calculation';


proc means data=crossval2;
	var maeValid;
	title 'MAE Validation Calculation';

/*use proce mean to get MSE*/
proc means data=crossval2;
	var mseOrig;
	title 'MSE Orignal Calculation';


proc means data=crossval2;
	var mseTrain;
	title 'MSE Training Calculation';


proc means data=crossval2;
	var mseValid;
	title 'MSE Validation Calculation';
	
/*Q10************
create another DATA Step. Define the variable “Prediction_Grade” (define the
variable using format $7.*/
data oporig;
	set crossval2;
pctDiff = abs((yhat - saleprice)/saleprice);
length Predict_Grade $7;

if (pctDiff <= 0.10) then Predict_Grade = 'Grade 1';
else if (pctDiff > 0.10) and (pctDiff <= 0.15) then Predict_Grade= 'Grade 2';
else Predict_Grade = 'Grade 3';

proc print data=oporig (obs=10);
run;

proc freq data=oporig;
	tables Predict_Grade;
run;
/*training model*/
data optrain;
	set crossval2;
if train_response=. then delete;

pctDiff = abs((yhat - train_response)/train_response);
length Predict_Grade $7;

if (pctDiff <= 0.10) then Predict_Grade = 'Grade 1';
else if (pctDiff > 0.10) and (pctDiff <= 0.15) 
	then Predict_Grade= 'Grade 2';
else Predict_Grade = 'Grade 3';

proc print data=optrain (obs=10);
run;

proc freq data=optrain;
	tables Predict_Grade;
run;

data opvalid;
	set crossval2;
if train=1 then delete;
pctDiff = abs((yhat - saleprice)/saleprice);
length Predict_Grade $7;

if (pctDiff <= 0.10) then Predict_Grade = 'Grade 1';
else if (pctDiff > 0.10) and (pctDiff <= 0.15) 
	then Predict_Grade= 'Grade 2';
else Predict_Grade = 'Grade 3';

proc print data=opvalid (obs=10);
run;

proc freq data=opvalid;
	tables Predict_Grade;

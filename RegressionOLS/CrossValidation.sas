
/* EXAMPLE BASED ON THE HOUSING DATA SET (code to load data not present here)
We will use the newly created response variable: train_response, when fitting our models. 
If you save the predicted values or the residuals to a new resultant dataset, you will have 
access to the predicted and/or residual values for ALL of the records in the dataset. In other 
words, you’ll have predicted or residuals for both the training and the validation components 
of the dataset. 
*/

u=uniform(123);				/* set seed*/
if (u<0.70) then train=1;	/* use seed to randomly select train set: if random number is <0.7, create train column and put 1*/
else train=0;			/* zero in train colum will be the test set
if(train=1) then train_response=SalePrice;	/* if train column has a 1, create 'train response' and enter SalePrice value*/
else train_response=.;		/* else, put an empty value*/
run;

Proc reg data=crossval;		/* this runs a proc reg on the entire data set*/
	model saleprice=TotalBsmtSF FirstFlrSF SecondFlrSF 
	GarageArea bldgtype_2F bldgtype_Du bldgtype_TE bldgtype_TI
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins;
	output out=origModel predicted=yhat;		/*creates the predicted values here and puts everything in a new output file*/


Data crossval2;			/*creates new data set from the origModel file created above*/
	set origModel;

	mseOrig =(yhat-saleprice)*(yhat-saleprice);
	mseTrain =(yhat-train_response)*(yhat-train_response);
	if train=0 then mseValid =(yhat-saleprice)*(yhat-saleprice);
	else mseValid=.;
	
	maeOrig = abs(yhat-saleprice); 		/*calculates absolute error*/
	maeTrain = abs(yhat-train_response);
	if train=0 then maeValid = abs(yhat-saleprice);
	else maeValid=.;

/*the rest of the code here uses proc means to get the average mse and mae so you can put it in a table*/
proc means data=crossval2;
	var maeOrig;
	title 'MAE Orignal Calculation';

proc means data=crossval2;
	var maeTrain;
	title 'MAE Training Calculation';

proc means data=crossval2;
	var maeValid;
	title 'MAE Validation Calculation';

proc means data=crossval2;
	var mseOrig;
	title 'MSE Orignal Calculation';

proc means data=crossval2;
	var mseTrain;
	title 'MSE Training Calculation';

proc means data=crossval2;
	var mseValid;
title 'MSE Validation Calculation';

u=uniform(123);
if (u<0.70) then train=1;
else train=0;
if(train=1) then train_response=SalePrice;
else train_response=.;
run;

Proc reg data=crossval;
	model saleprice=TotalBsmtSF FirstFlrSF SecondFlrSF 
	GarageArea bldgtype_2F bldgtype_Du bldgtype_TE bldgtype_TI
	lotconfig_cul lotconfig_fr2 lotconfig_fr3 lotconfig_ins;
	output out=origModel predicted=yhat;


Data crossval2;
	set origModel;

	mseOrig =(yhat-saleprice)*(yhat-saleprice);
	mseTrain =(yhat-train_response)*(yhat-train_response);
	if train=0 then mseValid =(yhat-saleprice)*(yhat-saleprice);
	else mseValid=.;
	
	maeOrig = abs(yhat-saleprice);
	maeTrain = abs(yhat-train_response);
	if train=0 then maeValid = abs(yhat-saleprice);
	else maeValid=.;
	
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

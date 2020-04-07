/*NOTE: this is continuation from CrossValidation.sas script*/


Data crossval2;
	set origModel;

	mseOrig =(yhat-saleprice)*(yhat-saleprice);     /*calc mse on original data set*/
	mseTrain =(yhat-train_response)*(yhat-train_response);         /*calc mse on train data set*/
	if train=0 then mseValid =(yhat-saleprice)*(yhat-saleprice);   /*calc mse on validaiton data set*/
else mseValid=.;



/* EXAMPLE WITH BOTH MEAN AND ABSOLUTE ERROR-----------------------------------------------------
run regression using cv_data file
set model where train_response is the response variable and using prin1 through prin8 
    (from prin component analysis) as predictors.  
Add vif calc
create an output file named model2_output and add a 'predicted' column and put yhat calculation in that column
*/

proc reg data=cv_data;
model train_response = prin1-prin8 / vif ;
output out=model2_output predicted=Yhat  ;
run; quit;

data model2_output;
	set model2_output;
	square_error = (response_VV - Yhat)**2;
	absolute_error = abs(response_VV - Yhat);
run;

/*run procmean: 
nway suppresses SAS from creating a row with overall mean.  
noprint suppreses the output from printing (helpful if large output)*/


proc means data=model2_output nway noprint;
class train;          /*create 0 and 1 in train column: gives means for each class (70% train and 30% test data)*/
var square_error absolute_error;    /*get means for both square_error and absolute_error*/
output out=model2_error             /*create new ouput to put these variables in*/
	mean(square_error)=MSE_2          /*get mean of the square error and put in MSE_2 column*/
	mean(absolute_error)=MAE_2;/      /*get mean of the absolute error and put in the MAE_2 column)*/
run; quit;

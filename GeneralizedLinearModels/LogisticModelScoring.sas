
/*---------------------------------------------------------------------
EXAMPLE 1
this example uses macro to call the Infile variable that is associated 
  with the raw data
---------------------------------------------------------------------*/


data deployfile;
set &Infile.;

imp_Income = Income;                            *put all the changes/fixes you did for the model;
if missing(imp_Income) then imp_Income=62000;

/*put the resulting model parameters to calculate probability with the out-of-sample data
  for car_use (private or commercial): 
    if it is a commercial car, the risk is higher so the model parameter output is 
      associated with commerical car use.  
    if the values for car use is commercial, the parameter estimate is multiplied by a 1, 
      therwise it is multiplied by a zero */
yhat=-1.0177
+(CAR_USE in ("Commerical"))*0.7278

+TRAVTIME*0.00555                       *this is the 2nd variable parameter;
+imp_Income*-0.0000085                  *this is the 3rd variable parameter;

*/note, in the output as you scroll all the way to the right, 
    it gives the log odds (in the logistic model output, it gaveprobability) 
    so you need to convert it to probability:
cap yhat so the exponent doesn't get to large and bog sas down*/
if yhat > 999 then yhat=999;
if yhat < -999 then yhat= -999;

/*first: you have to take the exponent of yhat to convert the it to odds:  
    P_Target_Flag = exp (yhat)
then you convert to probability by dividing exp(yhat) by 1+exp(yhat)  
    ie: odds divided by 1 + odds give you probability score
P_Target_Flag = exp( yhat ) /(1 + exp(yhat))


/*---------------------------------------------------------------------------
ANOTHER EXAMPLE
----------------------------------------------------------------------------*/
LogOdds = -4.3256
	+flgMortdue 		*0.5563
	+flgVALUE 		*4.4104
	+flgYOJ 			*-1.0697
	+impDEROG 		*0.4954
	+flgDEROG 		*-5.9133
	+impDELINQ 		*0.8449
	+impCLAGE 		*-0.00581
	+flgCLAGE 		*1.2259
	+impNINQ 		*0.1388
	+impCLNO 		*-0.0159
	+flgCLNO 		*2.7048
	+impDEBTINC 		*0.0915
	+flgDEBTINC 		*2.6489
	+(impJOB in ("Mgr"))	*-0.4993
	+(impJOB in ("Office"))	*-1.2001
	+(impJOB in ("Other"))	*-0.469
	+(impJOB in ("ProfExe"))*-0.703
	+(impJOB in ("Sales"))	*0.9905
	+flgJOB 			*-2.1281;

if LogOdds > 999 then LogOdds = 999;
if LogOdds <-999 then LogOdds =-999;
	
ODDS = exp(LogOdds);
PROB = ODDS/ (1+ODDS);
run;



/*---------------------------------------------------------------------------
MACRO EXAMPLE
this example is data step for three different regression calculations 
(this is just the calculation part not full data step: see examples 
below for remainder of code)
-----------------------------------------------------------------------------*/
%macro SCORE( INFILE, OUTFILE );

data &OUTFILE.;
set &INFILE.;

TEMP = -327.0 + 20.5993*X6 - 2.0414*X8;       *Calculate Prob of Y=1 from LOGIT Reference="0";
TEMP = exp(TEMP);
TEMP = TEMP / (1.0+TEMP);
Y_Hat_Logit_0 = TEMP;

TEMP = 210.6 + -13.2155*X6 + 1.2996*X8;       *Calculate Prob of Y=1 from LOGIT Reference="1";
TEMP = exp(TEMP);
if missing(TEMP) then TEMP = 99999;           *in case value is too large and SAS can't cacluate causing a missing value;
TEMP = TEMP / (1.0+TEMP);
Y_Hat_Logit_1 = 1-TEMP;

TEMP = -190.9 + 12.0548*X6 - 1.2010*X8;
Y_Hat_Probit_0 = probnorm(TEMP);

drop TEMP;
run;

%mend;

/*Now it is possible to predict the “Y” value for new input values*/
data SomeNewData;
input X6 X8;
datalines;
15  25
20  35
25  45
30  50
35  55
;
run; 

%SCORE(SomeNewData, NowItsScored );

proc print data=NowItsScored;
run;

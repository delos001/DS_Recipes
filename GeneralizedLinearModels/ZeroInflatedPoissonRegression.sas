
/*-----------------------------------------------------------------
Model 1
-----------------------------------------------------------------*/
%let OUTFILE 	= SHOWER;
%let TEMPFILE 	= TEMPFILE;

%let NO_SHOWER = 0.25;
%let AVERAGE = 11;
%let HOWMANY = 1000;

%let MALE	=	M;
%let FEMALE	=	F;

%let MIDDLEAGE	=	MIDDLEAGE;
%let YOUNG	=	YOUNG;
%let ELDERLY	=	ELDERLY;


data &OUTFILE.;

length INDEX 		8.;
length SHOWERLENGTH 	8.;

SEED = 1;

do INDEX = 1 to &HOWMANY.;
	AVERAGE		= &AVERAGE.;
	NOSHOWER	= &NO_SHOWER.;

	SEX = "&FEMALE."; 
	if ranuni(1) < 0.5 then SEX = "&MALE.";
	if SEX in ("&FEMALE.") then do;
		AVERAGE 	= AVERAGE + 2;
		NOSHOWER 	= NOSHOWER - 0.1;
	end;

	AGE_RANGE = "&MIDDLEAGE.";
	if ranuni(1) < 0.4 then AGE_RANGE = "&YOUNG.";
	if ranuni(1) < 0.2 then AGE_RANGE = "&ELDERLY.";
	if AGE_RANGE in ("&YOUNG.") then do;
		AVERAGE 	= AVERAGE - 2;
	end;
	if AGE_RANGE in ("&ELDERLY.") then do;
		AVERAGE 	= AVERAGE + 2;
		NOSHOWER 	= NOSHOWER - 0.1;
	end;

	INCOME = 10000 + 50000*ranuni(1);
	if SEX in ("&MALE.") then INCOME = 1.2*INCOME;
	if AGE_RANGE in ("&YOUNG.") 	then INCOME = 0.7*INCOME;
	if AGE_RANGE in ("&ELDERLY.") 	then INCOME = 0.9*INCOME;
	INCOME = round(INCOME,1000);

	AVERAGE = AVERAGE + 0.10 * INCOME/1000.0;
	BUCKET = round( INCOME / 10000,1 );
	NOSHOWER = NOSHOWER - BUCKET/100.0;
	INCOME = INCOME/1000;

	call ranpoi(SEED, AVERAGE, ShowerLength); 
	if ranuni(1) < NOSHOWER then ShowerLength = 0;

	output;
end;
drop SEED;
drop AVERAGE;
drop NOSHOWER;
drop BUCKET;
run;



/*-----------------------------------------------------------------
Model 2
-----------------------------------------------------------------*/

data &TEMPFILE.;
set &OUTFILE.;
run;

proc print data=&TEMPFILE.(obs=10);
run;

proc means data=&TEMPFILE. mean var;
where ShowerLength > 0;
var ShowerLength;
run;

proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength 		/midpoints = 0  2  4  6  8  10  12  14 ;
run;


/*-----------------------------------------------------------------
DIFFERENT APPROACHES FOR ZIP POISSON REGRESSION
-----------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------
METHOD 1-----------------------------------------------------------------------------
Method:
Solve the problem exactly like any other Poisson and/or Negative Binomial Model

Advantages:
Simple and familiar
No harm in trying because it might work (and many times it will)

Disadvantages:
It might not work
*/

/*specifies poisson distribution and log link function
IMPORTANT: this creates an output file with the predicted values named (P_TARGET_NOI)*/
proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=poi link=log;
   output out=&TEMPFILE. pred=P_TARGET_POI;
run;

/*uses proc genmod
specifies negative binomial distribution and log link function
IMPORTANT: this creates an output file with the predicted values named (P_TARGET_NB) */
proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = 
   		INCOME SEX AGE_RANGE / dist=nb link=log;   *specify log link function;
   output out=&TEMPFILE. pred=P_TARGET_NB;   *creates output file with predited values;
run;

proc print data=&TEMPFILE.(obs=10);
var ShowerLength P_TARGET_POI P_TARGET_NB;    
run;

/*noprint leaves off the statistics that are standard with univariate proc
create histogrms for each.
The distribution of the Poisson and Negative Binomial models are somewhat similar to the actual data. 
They won’t have the “spike” at zero because these models won’t account for that. 
Nonetheless, they do appear to have some similarity */
proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_POI 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_NB 		/midpoints = 0  2  4  6  8  10  12  14 ;
run;


/*-----------------------------------------------------------------------------------
METHOD 2-----------------------------------------------------------------------------
notice the dist=zip.  (instead of POI or NB) this is different than in method 1
second proc genmod: uses a logit link function. This is the code to predict the 
	probability that the count is a “zero” value.
note: it is assumed that sex and age_range predict whether a person took a shower or skipped
creates output file with specified variables:
	P_TARGET_ZIP: The coefficients predicting the amount of time a person will spend in the shower.
	P_ZERO_ZIP: The coefficients predicting the probability that a value will be zero.
*/

proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=ZIP link=log;
   zeromodel SEX AGE_RANGE / link=logit;
   
   /*output:
   Coefficients to predict duration person will spend in shower *IF* they were to take a shower
   Coefficients to predict LOG ODDS that a person will *NOT* take a shower. 
   	This needs to be converted from LOG ODDS to ODDS to PROBABILITY.
   */
   output out=&TEMPFILE. pred=P_TARGET_ZIP pzero=P_ZERO_ZIP
run;

/*
CREATING A STAND ALONE SCORE CODE
In order to create stand alone score code, both models need to be implemented into a data step. 
The first model, predicts the amount of time in the shower assuming that the person takes 
	a shower (no zero values).
*/

data &TEMPFILE.;   			*start with empty dataset;
/*STEP 2: Use the parameters from GENMOD to calculate the Natural LOG (“LN”) 
	of the Shower Length (call this value “TEMP”).
note: coefficients found from output 1 table above */
set &TEMPFILE.;
	TEMP = 2.3068 + 
		INCOME * 0.0063 + 
		(SEX in ("F")) *0.1258 + 
		(AGE_RANGE in ("ELDERLY")) * 0.2811 + 
		(AGE_RANGE in ("MIDDLEAGE")) *0.1378;
	P_SCORE_ZIP_ALL = exp( TEMP );
	
	/*Use the parameters from GENMOD to calculate the LOGIT value that the 
	person does *NOT* take a shower (call this value “TEMP”). note: coefficients 
	found from output 2 table above*/
	TEMP = -1.5682 + 
		(SEX in ("F")) *-0.8200 + 
		(AGE_RANGE in ("ELDERLY")) * -0.9467 + 
		(AGE_RANGE in ("MIDDLEAGE")) *0.1765;
	
	/*Convert the LOGIT (aka “TEMP”) into the PROBABILITY that a person does NOT take a shower. 
	Call this variable P_SCORE_ZERO. (normal logistic conversion calculation, see logistic 
	regression scoring data step tab)*/
	P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));
	
	/*STEP 6: Calculate the EXPECTED time in the shower. This will be the Time in the shower 
	(assuming that a shower was taken) “P_SCORE_ZIP_ALL” multiplied by the probability that a 
	person takes a shower (1 minus the probability that they don’t take a shower) “P_SCORE_ZERO”. 
	Call this new value “P_SCORE_ZIP” */
	P_SCORE_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);
run;

/*CHECK THAT PROBABILITY OF NO SHOWER IS THE SAME:
A PROC PRINT of the first 10 values will demonstrate that the probability value of “NO SHOWER” 
is the same value from PROC GENMOD and from the SCORE CODE 
(genmod result is above with p_zero_zip also highlight yellow): they should be the same */
proc print data=&TEMPFILE.(obs=10);
var P_ZERO_ZIP P_SCORE_ZERO;
run;

/*
CHECK THAT EXPECTED TIME IN THE SHOWER IS THE SAME:
A PROC PRINT of the first 10 values will demonstrate that the probability value of the expected time 
in the shower is the same value from PROC GENMOD and from the SCORE CODE. 
(see similar colored variables above in the proc genmod).  the output should show they are the same */
proc print data=&TEMPFILE.(obs=10);
var P_TARGET_ZIP P_SCORE_ZIP;
run;

*data &TEMPFILE.;
*set &TEMPFILE.;
*P_TARGET_ZIP = round(P_TARGET_ZIP,0.1);
*P_SCORE_ZIP = round(P_SCORE_ZIP,0.1);
*run;

*proc print data=&TEMPFILE.(obs=10);
*var P_TARGET_ZIP P_SCORE_ZIP;
*run;


/*-----------------------------------------------------------------------------------
METHOD 3----------------------------------------------------------------------
Exactly the same as Method 2: ZIP Regression, except that it is a different distribution. 
	Use “ZINB” instead of “ZIP” so after using code in line below, see method 2 tab for 
	remaining code.

Advantages:
Everything is the same as ZIP … including the advantages.
Since there are virtually no differences, why not try ZINB and see what happens.

Disadvantages:
Same as ZIP
*/

/*the Code for a ZINB model is similar to a ZIP model except that the ZIP option is changed to ZINB.
Sometimes, the NEGATIVE BINOMIAL distribution models will converge to the same solution as the POISSON 
models. In those cases, it might be useful to use different parameters in MODEL and/or ZEROMODEL because 
getting different answers will improve the chances of finding a good model.  For example: you could add 
"income" to the zeromodel or leave it out to see what is best proc genmod data=&TEMPFILE. */

class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=ZINB link=log;
   zeromodel INCOME SEX AGE_RANGE / link=logit;
   output out=&TEMPFILE. pred=P_TARGET_ZINB pzero=P_ZERO_ZINB;;
run;


/*-----------------------------------------------------------------------------------
METHOD 4----------------------------------------------------------------------
Method:
Build a Logistic Regression Model to predict if the count is “0” or “not 0”
Build a model to predict the count value (assuming it is not 0)
Multiply the probability of “not 0” by the count to get the expected count
Advantages:
	Flexible and Versatile:
		Advantage of having access to specialized logistic regression software allowing for 
			options such as FORWARD/BACKWARD/STEPWISE regression
		The “0” and “Not 0” model can be any type of model (“Tree”, “Neural Net”, etc.)
		Count model can be any type of model (“Regression”, “Tree”, “Neural Network”, etc.).
		Can even use different types of software (“R”, “Python”,”SAS”, etc.)
Disadvantages:
This can make things a lot more complicated
*/


/*For a Logistic Hurdle Model, the target (in this case ShowerLength) needs to be converted into two variables:
	a BINARY target variable (TARGET_FLAG) (if shower length is > 0, puts a 1 there.  if not, puts a zero) 
	a Count variable TARGET_AMT.  (has “1” subtracted from it. 
		This allows for a true Poisson distribution. 
		The one must be added back to the predicted value.)  
NOTE: if 1 is not subtracted from target_amt, result will be the same as proc genmod with 
zip or zinb distribution (method 2,3) */

data &TEMPFILE.;
set &TEMPFILE.;
TARGET_FLAG	= (ShowerLength>0);
TARGET_AMT	= ShowerLength - 1;
if TARGET_FLAG = 0 then TARGET_AMT = .;
run;

/*This is the code to predict the probability that the count value is greater than 0.
This code has the advantage of all the options of PROC LOGIT
Also, other model techniques can be employed such as TREES or Neural Networks. */
proc logistic data=&TEMPFILE.;
class SEX AGE_RANGE / param = ref ;
model TARGET_FLAG(ref="0") = INCOME SEX AGE_RANGE /selection=stepwise;
output out=&TEMPFILE. pred=P_TARGET_FLAG;
run;

/*This is the code to predict the amount of minutes in the shower, assuming that a 
	shower was taken.
Recall that TARGET_AMT = ShowerLength-1. This is not a necessary conversion, but may 
	be considered a best practice in order to have a true Poisson or Negative 
	Binomial distribution.
This model is not limited to GENMOD, 
	it can be any type of model from REGRESSION to TREE to NEURAL NETWORK or anything else */
proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model TARGET_AMT = INCOME SEX AGE_RANGE / dist=poi link=log;
   output out=&TEMPFILE. pred=P_TARGET_AMT;
run;

/*The two values, P_TARGET_FLAG and P_TARGET_AMT must be multiplied in order to determine 
	the expected time in the shower.
Notice that 1 is added to P_TARGET_AMT in order to correct for the 1 that was subtracted earlier */
data &TEMPFILE.;
set &TEMPFILE.;
P_TARGET_HURDLE = P_TARGET_FLAG * (P_TARGET_AMT+1);
run;

*To create stand alone data step score code;
/*STEP1: In order to create stand alone score code, both models need to be implemented into a data step. 
The first model, predicts the amount of time in the shower assuming that the person takes a shower 
(no zero values) */
data &TEMPFILE.;
set &TEMPFILE.;

/*STEP2: Use the parameters from LOGISTIC REGRESSION to calculate the LOGIT of the probability that a 
person takes a shower. Call this value “TEMP”.  (coefficients found from first table above) */
TEMP = 1.5682  
+ (SEX in ("F")) *0.8200 
+ (AGE_RANGE in ("ELDERLY")) * 0.9468 
+ (AGE_RANGE in ("MIDDLEAGE")) * -0.1765; 

/*STEP 3: Convert the LOGIT value to a PROBABILITY that a person will take a shower. 
Call this value P_SCORE_FLAG.*/
P_SCORE_FLAG = exp(TEMP) / (1+exp(TEMP));

/*STEP 4: Use the parameters from GENMOD to calculate the amount of time that a person takes a shower. 
Call this value “TEMP”. (coefficients found from second table, above) */
TEMP = 2.2082
+ INCOME * 0.0067
+ (SEX in ("F")) *0.1347 
+ (AGE_RANGE in ("ELDERLY")) * 0.3012 
+ (AGE_RANGE in ("MIDDLEAGE")) * 0.1484;

/*STEP 5: Convert “TEMP” into the Minutes spent in the shower (assuming that a shower was taken). 
Call this value P_SCORE_AMT.  (note that we add the one back after getting inverse log since it 
	was subtracted above to create poisson or neg binomial distribution) */
P_SCORE_AMT = exp(TEMP) + 1;

/*STEP 6: Multiply P_SCORE_FLAG and P_SCORE_AMT and to determine the expected time in the shower. 
Call this value P_SCORE_HURDLE.*/
P_SCORE_HURDLE = P_SCORE_FLAG * P_SCORE_AMT;
drop TEMP;
run;

/*CHECK THAT EXPECTED TIME IN THE SHOWER IS THE SAME:
A PROC PRINT of the first 10 values will demonstrate that the probability value of the expected time in the 
shower is the same value from PROC GENMOD and from the SCORE CODE.  
(values should be close, but with rounding errors) */
proc print data=&TEMPFILE.(obs=10);
var P_TARGET_FLAG P_SCORE_FLAG;
run;

proc print data=&TEMPFILE.(obs=10);
var P_TARGET_AMT P_SCORE_AMT;
run;

proc print data=&TEMPFILE.(obs=10);
var P_TARGET_HURDLE P_SCORE_HURDLE;
run;


proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_POI 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_NB 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_ZIP 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_ZINB		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_HURDLE	/midpoints = 0  2  4  6  8  10  12  14 ;
run;



proc means data=&TEMPFILE. mean;
var ShowerLength;
run;



/*---------------------------------------------------------------------------------
MODEL VALIDATION MACRO
The following macro will compare the accuracy of the various models against taking 
	a simple average or “mean” value.

%FIND_ERROR( DATAFILE, P, MEANVAL );
	DATAFILE = File with the scored values
	P = Exponent of the Error. 
	A value of 1 will give the AVERAGE ERROR
	A value of 2 will give the ROOT MEAN SQUARE ERROR
	A value of some other constant, say 1.5, will use that exponent.
MEANVAL = This is the Mean or Average Value of the target
----------------------------------------------------------------------------------*/
%macro FIND_ERROR( DATAFILE, P, MEANVAL );
%let ERRFILE 	= ERRFILE;
%let MEANFILE	= MEANFILE;

data &ERRFILE.;
set &DATAFILE.;
	ERROR_MEAN	= abs( ShowerLength - &MEANVAL.)	**&P.;
	ERROR_POI		= abs( ShowerLength - P_TARGET_POI )	**&P.;
	ERROR_NB		= abs( ShowerLength - P_TARGET_NB )	**&P.;
	ERROR_ZIP		= abs( ShowerLength - P_TARGET_ZIP )	**&P.;
	ERROR_ZINB	= abs( ShowerLength - P_TARGET_ZINB )	**&P.;
	ERROR_HURDLE	= abs( ShowerLength - P_TARGET_HURDLE )	**&P.;
run;


proc means data=&ERRFILE. noprint;
output out=&MEANFILE.
	mean(ERROR_MEAN)	=	ERROR_MEAN
	mean(ERROR_POI)	=	ERROR_POI
	mean(ERROR_NB)	=	ERROR_NB
	mean(ERROR_ZIP)	=	ERROR_ZIP
	mean(ERROR_ZINB)	=	ERROR_ZINB
	mean(ERROR_HURDLE)	=	ERROR_HURDLE
	;
run;T

data &MEANFILE.;
length P 8.;
set &MEANFILE.;
	P		= &P.;
	ERROR_MEAN	= ERROR_MEAN	** (1.0/&P.);
	ERROR_POI 	= ERROR_POI	** (1.0/&P.);
	ERROR_NB 		= ERROR_NB	** (1.0/&P.);
	ERROR_ZIP 	= ERROR_ZIP	** (1.0/&P.);
	ERROR_ZINB 	= ERROR_ZINB	** (1.0/&P.);
	ERROR_HURDLE 	= ERROR_HURDLE	** (1.0/&P.);
	drop _TYPE_;
run;

proc print data=&MEANFILE.;
run;

%mend;

%FIND_ERROR( &TEMPFILE., 1	, 13.31 );
%FIND_ERROR( &TEMPFILE., 1.5	, 13.31 );
%FIND_ERROR( &TEMPFILE., 2	, 13.31 );

%let ERRFILE 	= ERRFILE;
%let MEANFILE	= MEANFILE;

data &ERRFILE.;
set &DATAFILE.;
	ERROR_MEAN		= abs( ShowerLength - &MEANVAL.			)**&P.;
	ERROR_POI 		= abs( ShowerLength - P_TARGET_POI 		)**&P.;
	ERROR_NB 		= abs( ShowerLength - P_TARGET_NB 		)**&P.;
	ERROR_ZIP 		= abs( ShowerLength - P_TARGET_ZIP 		)**&P.;
	ERROR_ZINB 		= abs( ShowerLength - P_TARGET_ZINB 	)**&P.;
	ERROR_HURDLE 	= abs( ShowerLength - P_TARGET_HURDLE 	)**&P.;
run;


proc means data=&ERRFILE. noprint;
output out=&MEANFILE.
	mean(ERROR_MEAN)	=	ERROR_MEAN
	mean(ERROR_POI)		=	ERROR_POI
	mean(ERROR_NB)		=	ERROR_NB
	mean(ERROR_ZIP)		=	ERROR_ZIP
	mean(ERROR_ZINB)	=	ERROR_ZINB
	mean(ERROR_HURDLE)	=	ERROR_HURDLE
	;
run;

data &MEANFILE.;
length P 8.;
set &MEANFILE.;
	P				= &P.;
	ERROR_MEAN		= ERROR_MEAN	** (1.0/&P.);
	ERROR_POI 		= ERROR_POI		** (1.0/&P.);
	ERROR_NB 		= ERROR_NB		** (1.0/&P.);
	ERROR_ZIP 		= ERROR_ZIP		** (1.0/&P.);
	ERROR_ZINB 		= ERROR_ZINB	** (1.0/&P.);
	ERROR_HURDLE 	= ERROR_HURDLE	** (1.0/&P.);
	drop _TYPE_;
run;

proc print data=&MEANFILE.;
run;

%mend;

%FIND_ERROR( &TEMPFILE., 1	, 13.31 );
%FIND_ERROR( &TEMPFILE., 1.5, 13.31 );
%FIND_ERROR( &TEMPFILE., 2	, 13.31 );








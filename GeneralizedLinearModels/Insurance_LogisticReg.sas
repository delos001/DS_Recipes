/*---------------------------------------------------------------------------------------
Example code, (full example below)
----------------------------------------------------------------------------------------*/

/*
Usually, three different PROCS doing the same thing should give the same result …
However ….
The data set is small and it is perfectly separable. Therefore, there are an infinite 
	number of solutions that will separate the “1” and “0” values. 
	Notice that the error term (“log likelihood”) for all three models is close to zero.
Therefore, even though there are different solutions, all of these are correct.
For more complex models, the three approaches would yield similar results.

/*Example 1---------------------------------------------------------------------
uses proc logistic
REF=“0” means that PROC LOGISTIC will compute the probability that Y=1
REF=“1” means that PROC LOGISTIC will compute the probability that Y=0
*/
proc logistic data=TEMPFILE;
model Y(ref="0") = X6 X8;
run;
quit;

/*Example 2---------------------------------------------------------------------
uses proc probit
**note this is different than the "Probit Regression" tab: while both use proc probit, 
	here logistic distribution is specified
*/
proc probit data=TEMPFILE;
model Y(ref="0") = X6 X8 /d=logistic;
run;
quit;

/*Example 3---------------------------------------------------------------------
use proc genmod
*/
proc genmod data=TEMPFILE descending;
model Y = X6 X8 /dist=binomial link=logit;
run;

/*Example 4---------------------------------------------------------------------
model y on independent variables x1, x2, x3.  
instead of predicting y, the model predicts the logits: log(pi/(1-pi))
note that the result is predicted probabilities
*/
proc logistic data=bankrupt descending;
model y=x1 x2 x3;
run;

/*Example 5---------------------------------------------------------------------
gives a roc curve plot
must specify which variables are class variables
ref=0 tells it to do compute prob that Y=1.  ref=1 means proc logistic will compute probability that Y=0
variable 1
variable 2
variable 3
specs for the roc curve specified above
*/
proc logistic data=insmod1 plot (only)=(roc(ID=prob));
class car_use / param=reference;
model target_flag (ref="0")=
	car_use
	travtime
	imp_income
	/roceps=0.1;
run;

/*Example 6---------------------------------------------------------------------
*proc logistic with progit regression
ref=0 means proc logistic will compute the probability that Y=1
link=probit means proc logistic will compute a probitregression
*/
proc logistic data=TEMPFILE;
model Y(ref=“0”) = X6 X8 /link=probit;
run;
quit;



/*---------------------------------------------------------------------------------------
Full example code
note:
	ref=0 means prob logistic predicts probability that Y=1.  
	ref=1 means proc logistic predicts probability that Y=0.
----------------------------------------------------------------------------------------*/

libname p411 "C:\Dropbox\N_NORTHWESTERN\X_Instructor\PRED411\PRED411_ARCHIVES\UNIT_02_LOGISTIC\HW02_INSURANCE\SYNC\DATA";

%let INFILE 	= p411.logit_insurance;
%let TEMPFILE 	= p411.TEMPFILE;
%let SCRUBFILE 	= SCRUBFILE;


proc print data=&INFILE.(obs=6);
run;

data &TEMPFILE.;
set &INFILE.;
drop INDEX;
drop TARGET_AMT;
run;

proc print data=&TEMPFILE.(obs=7);
run;

proc means data=&TEMPFILE. nmiss mean median;
var 	KIDSDRIV AGE HOMEKIDS YOJ INCOME  
	HOME_VAL TRAVTIME BLUEBOOK TIF 
	OLDCLAIM CLM_FREQ  MVR_PTS CAR_AGE ;
run;

proc means data=&TEMPFILE. nmiss mean median;
var _numeric_ ;
run;

proc freq data=&TEMPFILE.;
table _character_ /missing;
run;

data &SCRUBFILE.;
set &TEMPFILE.;

IMP_AGE = AGE;
if missing( IMP_AGE ) then IMP_AGE = 45;

IMP_INCOME 	= INCOME;
M_INCOME 	= 0;
if missing(IMP_INCOME) then do;
	IMP_INCOME = 54000;
	M_INCOME = 1;
end;
if IMP_INCOME > 180000 then IMP_INCOME = 180000;


IMP_HOME_VAL = HOME_VAL;
if missing( IMP_HOME_VAL ) then IMP_HOME_VAL = 160000;

IMP_YOJ = YOJ;
if missing( IMP_YOJ ) then IMP_YOJ = 11;

IMP_CAR_AGE = CAR_AGE;
if missing( IMP_CAR_AGE )then IMP_CAR_AGE = 8;

IMP_JOB = JOB;
if missing(IMP_JOB) then do;
	if IMP_INCOME > 100000 then 
		IMP_JOB = "Doctor";	
	else if IMP_INCOME > 80000 then 
		IMP_JOB = "Lawyer";
	else
		IMP_JOB = "z_Blue Collar";
end;


JOB_WHITE_COLLAR = IMP_JOB in ("Doctor","Lawyer");

drop AGE;
drop INCOME;
drop HOME_VAL;
drop YOJ;
drop CAR_AGE;
drop JOB;
drop RED_CAR;

run;

proc means data=&SCRUBFILE. nmiss mean;
class JOB;
var IMP_INCOME;
run;

proc means data=&SCRUBFILE. nmiss min mean median;
var _numeric_;
run;

proc freq data=&SCRUBFILE.;
table _character_ /missing;
run;

proc print data=&SCRUBFILE.(obs=8);
run;

proc freq data=&SCRUBFILE.;
table ( _character_ ) * TARGET_FLAG /missing;
run;

proc means data=&SCRUBFILE. mean median;
class TARGET_FLAG;
var _numeric_;
run;

proc univariate data=&SCRUBFILE. plot;
class TARGET_FLAG;
var IMP_INCOME;
histogram;
run;

proc univariate data=&SCRUBFILE.;
class TARGET_FLAG;
var _numeric_;
histogram;
run;

proc contents data=&SCRUBFILE.;
run; 

* model 1-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
model TARGET_FLAG( ref="0" ) = 
					JOB_WHITE_COLLAR
					KIDSDRIV 
					HOMEKIDS 
					TRAVTIME 
					BLUEBOOK 
					TIF 
					OLDCLAIM 
					CLM_FREQ 
					MVR_PTS 
					IMP_AGE 
					IMP_YOJ 
					M_INCOME 
					IMP_INCOME 
					IMP_HOME_VAL 
					IMP_CAR_AGE 
					/selection=forward;
run;

* model 2-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class IMP_JOB;
model TARGET_FLAG( ref="0" ) = 
					IMP_JOB
					KIDSDRIV 
					TIF 
					MVR_PTS 
					IMP_AGE 
					IMP_YOJ 
					IMP_CAR_AGE 
					;
run;

* model 3-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class IMP_JOB /param=ref;
model TARGET_FLAG( ref="0" ) = 
					IMP_JOB
					KIDSDRIV 
					TIF 
					MVR_PTS 
					IMP_AGE 
					IMP_YOJ 
					IMP_CAR_AGE 
					;
run;


* model 4-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class IMP_JOB(ref="Doctor") /param=ref;
model TARGET_FLAG( ref="0" ) = 
					IMP_JOB
					KIDSDRIV 
					TIF 
					MVR_PTS 
					IMP_AGE 
					IMP_YOJ 
					IMP_CAR_AGE 
					;
run;

* model 5-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class IMP_JOB(ref="Doctor") /param=ref;
model TARGET_FLAG( ref="0" ) = 
					IMP_JOB
					KIDSDRIV 
					;
run;


* model 6-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class REVOKED(ref="No") /param=ref;
model TARGET_FLAG( ref="0" ) = 
					REVOKED
					KIDSDRIV 
					MVR_PTS 
					IMP_YOJ
					;
run;


* Predict -------------------------------------------------;
data PATRIOTS;
set p411.logit_insurance;

IMP_YOJ = YOJ;
if missing( IMP_YOJ ) then IMP_YOJ = 11;

YHAT = 	-1.2310 						+ 
		0.8886*( REVOKED in ("Yes") ) 	+
		0.3775*KIDSDRIV 				+
		0.2078*MVR_PTS					+
		-0.0374*IMP_YOJ
		;

YHAT = exp( YHAT );
PROB = YHAT / (1+YHAT);

run;

proc print data=PATRIOTS(obs=10);
var PROB;
run;

proc means data=PATRIOTS nmiss;
var PROB;
run;

data CRASHED;
set &INFILE.;
if TARGET_FLAG > 0;
drop TARGET_FLAG;
run;

proc print data=CRASHED(obs=30);
run;


* model 6-------------------------------------------------;
proc logistic data=&SCRUBFILE.   plot(only)=(roc(ID=prob))    ;
class REVOKED(ref="No") /param=ref;
model TARGET_FLAG( ref="0" ) = 
					REVOKED
					KIDSDRIV 
					MVR_PTS 
					IMP_YOJ
					/roceps=0.05
					;
run;



* model 7-------------------------------------------------;
proc logistic data=&SCRUBFILE.;
class 	REVOKED(ref="No") /param=ref;
class	EDUCATION /param=ref;
model TARGET_FLAG( ref="0" ) = 
					EDUCATION
					REVOKED
					KIDSDRIV 
					MVR_PTS 
					IMP_YOJ
					;
score out=fred;
run;

proc print data=fred(obs=3);
run;




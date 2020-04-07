


%let PATH 	= C:\Dropbox\N_NORTHWESTERN\Z_NWU411\U2LOGISTIC\HELOC\DATA;

libname LR "&PATH.";


%let INFILE		= LR.HELOC;
%let TEMPFILE 	= LR.JOE;


proc contents data=&INFILE.;
run;

proc print data=&INFILE.(obs=10);
run;



data &TEMPFILE.;
set &INFILE.;



IMP_MORTDUE = MORTDUE;
M_MORTDUE	= 0;
if missing( IMP_MORTDUE ) then do;
	IMP_MORTDUE = 65205;
	M_MORTDUE	= 1;
end;

IMP_DEBTINC = DEBTINC;
M_DEBTINC	= 0;
if missing( IMP_DEBTINC ) then do;
	IMP_DEBTINC = 34;
	M_DEBTINC	= 1;
end;


IMP_YOJ = YOJ;
M_YOJ	= 0;
if missing( IMP_YOJ ) then do;
	IMP_YOJ = 7;
	M_YOJ	= 1;
end;


IMP_JOB = JOB;
if missing(IMP_JOB) then IMP_JOB = "Other";

IMP_REASON = REASON;
if missing( IMP_REASON ) then IMP_REASON = "None";

TRAIN_FLAG = ranuni(1) > 0.2;

run;


proc print data=&TEMPFILE.(obs=3);
run;



proc means data=&TEMPFILE. nmiss mean median;
var _numeric_;
run;


proc freq data=&TEMPFILE.;
table _character_ /missing;
run;


data TRAIN;
set &TEMPFILE.;
if TRAIN_FLAG = 1;
run;

data TEST;
set &TEMPFILE.;
if TRAIN_FLAG = 0;
run;


proc logistic data=TRAIN plot(only)=(roc(ID=prob));
class IMP_JOB IMP_REASON  /param=ref;
model TARGET_FLAG( ref="0" ) = IMP_MORTDUE M_MORTDUE IMP_DEBTINC M_DEBTINC IMP_YOJ M_YOJ IMP_JOB IMP_REASON /selection=stepwise roceps=0.1;
run;



data SCORED;
set TEST;

IMP_MORTDUE = MORTDUE;
M_MORTDUE	= 0;
if missing( IMP_MORTDUE ) then do;
	IMP_MORTDUE = 65205;
	M_MORTDUE	= 1;
end;

IMP_DEBTINC = DEBTINC;
M_DEBTINC	= 0;
if missing( IMP_DEBTINC ) then do;
	IMP_DEBTINC = 34;
	M_DEBTINC	= 1;
end;

IMP_YOJ = YOJ;
M_YOJ	= 0;
if missing( IMP_YOJ ) then do;
	IMP_YOJ = 7;
	M_YOJ	= 1;
end;

IMP_JOB = JOB;
if missing(IMP_JOB) then IMP_JOB = "Other";

IMP_REASON = REASON;
if missing( IMP_REASON ) then IMP_REASON = "None";

LOG_ODDS = 	-4.7214 								+ 
			-3.33E-6	* IMP_MORTDUE				+
			0.4569		* M_MORTDUE					+
			0.0934		* IMP_DEBTINC				+
			2.9427		* M_DEBTINC					+
			-0.0256		* IMP_YOJ					+
			-1.0280		* M_YOJ						+
			-0.2275		* (IMP_JOB in ("Mgr"))		+
			-1.0300		* (IMP_JOB in ("Office"))	+
			-0.3193		* (IMP_JOB in ("Other"))	+
			-0.6603		* (IMP_JOB in ("ProfExe"))	+
			0.5832		* (IMP_JOB in ("Sales"));

ODDS = EXP( log_odds );
PROB = ODDS / (1+ODDS);

run;

proc means data=SCORED nmiss;
var PROB;
run;


proc print data=SCORED ( OBS = 50 );
var INDEX PROB TARGET_FLAG;
run;






proc logistic data=TRAIN plot(only)=(roc(ID=prob));
class IMP_JOB IMP_REASON  /param=ref;
model TARGET_FLAG( ref="0" ) = IMP_DEBTINC M_DEBTINC /selection=stepwise roceps=0.1;
run;


data SCORED;
set TEST;

IMP_DEBTINC = DEBTINC;
M_DEBTINC	= 0;
if missing( IMP_DEBTINC ) then do;
	IMP_DEBTINC = 34;
	M_DEBTINC	= 1;
end;

LOG_ODDS = -5.5698 + 0.0908 * IMP_DEBTINC + 2.9618 * M_DEBTINC;
ODDS = EXP( log_odds );
PROB = ODDS / (1+ODDS);

run;

proc means data=SCORED nmiss;
var PROB;
run;

proc print data=SCORED ( OBS = 50 );
var INDEX PROB TARGET_FLAG;
run;






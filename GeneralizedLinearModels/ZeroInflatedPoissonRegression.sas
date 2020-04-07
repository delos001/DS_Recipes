

%let OUTFILE 	= SHOWER;
%let TEMPFILE 	= TEMPFILE;


%let NO_SHOWER = 0.25;
%let AVERAGE = 11;
%let HOWMANY = 1000;

%let MALE	=	M;
%let FEMALE	=	F;


%let MIDDLEAGE	=	MIDDLEAGE;
%let YOUNG		=	YOUNG;
%let ELDERLY	=	ELDERLY;



data &OUTFILE.;

length INDEX 			8.;
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









proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=poi link=log;
   output out=&TEMPFILE. pred=P_TARGET_POI;
run;

proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=nb link=log;
   output out=&TEMPFILE. pred=P_TARGET_NB;
run;


proc print data=&TEMPFILE.(obs=10);
var ShowerLength P_TARGET_POI P_TARGET_NB;
run;

proc univariate data=&TEMPFILE. noprint;
histogram ShowerLength		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_POI 		/midpoints = 0  2  4  6  8  10  12  14 ;
histogram P_TARGET_NB 		/midpoints = 0  2  4  6  8  10  12  14 ;
run;







proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=ZIP link=log;
   zeromodel SEX AGE_RANGE / link=logit;
   output out=&TEMPFILE. pred=P_TARGET_ZIP pzero=P_ZERO_ZIP;
run;

data &TEMPFILE.;
set &TEMPFILE.;
	TEMP = 2.3068 + INCOME * 0.0063 + (SEX in ("F")) *0.1258 + (AGE_RANGE in ("ELDERLY")) * 0.2811 + (AGE_RANGE in ("MIDDLEAGE")) *0.1378;
	P_SCORE_ZIP_ALL = exp( TEMP );

	TEMP = -1.5682 + (SEX in ("F")) *-0.8200 + (AGE_RANGE in ("ELDERLY")) * -0.9467 + (AGE_RANGE in ("MIDDLEAGE")) *0.1765;
	P_SCORE_ZERO = exp(TEMP)/(1+exp(TEMP));

	P_SCORE_ZIP = P_SCORE_ZIP_ALL * (1-P_SCORE_ZERO);
run;

proc print data=&TEMPFILE.(obs=10);
var P_ZERO_ZIP P_SCORE_ZERO;
run;

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










proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model ShowerLength = INCOME SEX AGE_RANGE / dist=ZINB link=log;
   zeromodel INCOME SEX AGE_RANGE / link=logit;
   output out=&TEMPFILE. pred=P_TARGET_ZINB pzero=P_ZERO_ZINB;;
run;






data &TEMPFILE.;
set &TEMPFILE.;
TARGET_FLAG	= (ShowerLength>0);
TARGET_AMT	= ShowerLength - 1;
if TARGET_FLAG = 0 then TARGET_AMT = .;
run;

proc logistic data=&TEMPFILE.;
class SEX AGE_RANGE / param = ref ;
model TARGET_FLAG(ref="0") = INCOME SEX AGE_RANGE /selection=stepwise;
output out=&TEMPFILE. pred=P_TARGET_FLAG;
run;

proc genmod data=&TEMPFILE.;
class SEX AGE_RANGE;
   model TARGET_AMT = INCOME SEX AGE_RANGE / dist=poi link=log;
   output out=&TEMPFILE. pred=P_TARGET_AMT;
run;

data &TEMPFILE.;
set &TEMPFILE.;
P_TARGET_HURDLE = P_TARGET_FLAG * (P_TARGET_AMT+1);
run;


data &TEMPFILE.;
set &TEMPFILE.;
TEMP = 1.5682  
+ (SEX in ("F")) *0.8200 
+ (AGE_RANGE in ("ELDERLY")) * 0.9468 
+ (AGE_RANGE in ("MIDDLEAGE")) * -0.1765; 
P_SCORE_FLAG = exp(TEMP) / (1+exp(TEMP));

TEMP = 2.2082
+ INCOME * 0.0067
+ (SEX in ("F")) *0.1347 
+ (AGE_RANGE in ("ELDERLY")) * 0.3012 
+ (AGE_RANGE in ("MIDDLEAGE")) * 0.1484;

P_SCORE_AMT = exp(TEMP) + 1;
P_SCORE_HURDLE = P_SCORE_FLAG * P_SCORE_AMT;
drop TEMP;
run;



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


%macro FIND_ERROR( DATAFILE, P, MEANVAL );

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








/*
FIVE METHODS OF DEALING WITH MISSING VALUES:
Delete records with missing values
Avoid using a variable that has a missing value
Use a business rule to fix a missing value
Fill in the missing value with an average value (i.e. Mean, Median, Mode)
Use a decision tree (or similar tool) to build a model to impute the missing value.
*/

/*
n 	: Number of values not missing
nmiss	: Number of values missing
mean	: Mean or average of the non-missing values
*/


/*------------------------------------------------------------------------------
Example 1
add the commands to proc print to get more stats about missing values
*/

proc means data=CUSTOMERS n nmiss mean;
var AGE CAR_VALUE FLAG_CONTACT HOME_VALUE INCOME VACATION YOJ;
run;



/*------------------------------------------------------------------------------
Impute Missing Values
Imputed Variables
Y	: Target Variable
X	: Input Variable (has missing values)
IMP_X	: New Input Variable with all missing values “fixed”
M_X	: Flag variable M_X=0 means variable is original 1 means variable imputed.
*/

/*------------------------------------------------------------------------------
Basic example
*/

data NEWFILE;
set ORIGINAL;
IMP_X = X;
m_X = 0;
if missing(IMP_X) then do;
	IMP_X = 3.4;
	m_X = 1;
end;
run;

proc reg data=NEWFILE;
A: Model Y = IMP_X;
B: Model Y = IMP_X M_X;
run;
quit;


/*------------------------------------------------------------------------------
Multiple operations example
this missing value code assumes the following regression model was run and resulted 
in following coefficients:
Assume that these were the resulting coefficients
Intercept	=	5
A 		=	4.5
B 		=	-3.2
C 		=	6.1
D 		=	-2.6
D_Missing_Flag	=	13
*/
roc reg data=INFILE2;
Model Y = A B C D D_Missing_Flag;
Run;

data INFILE2;
Set INFILE1;
if missing(A) then delete;
if missing(B) then B = 10;
if missing(C) then do;
	if A>0 then C=5; else C=10;
end;
D_Missing_Flag = 0;
if missing(D) then do;
	D_Missing_Flag = 1;
	D = 25;
end;
run; 


/*------------------------------------------------------------------------------
Full Examples
------------------------------------------------------------------------------*/
%let PATH = .;
%let NAME = NWU;
%let LIB = &NAME..;

libname &NAME. "&PATH.";

%let INFILE = &LIB.FixMissingValues_Customers;

data CUSTOMERS;
set &INFILE.;
run;

proc contents data=CUSTOMERS;
run;

proc print data=CUSTOMERS(obs=10);
run;

proc means data=CUSTOMERS n nmiss mean;
var AGE CAR_VALUE FLAG_CONTACT HOME_VALUE INCOME VACATION YOJ;
run;

proc freq data=CUSTOMERS;
table JOB EDUCATION FLAG_CONTACT /missing;
run;

data NEW_CUSTOMERS;
set CUSTOMERS;
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
drop CAR_VALUE;
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
if missing(FLAG_CONTACT) then FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;

IMP_AGE = AGE;
if missing(AGE) then IMP_AGE = 44.9;
drop AGE;

IMP_YOJ = YOJ;
M_YOJ = 0;
if missing(YOJ) then do;
	IMP_YOJ = 10.5;
	M_YOJ = 1;
end;
drop YOJ;

IMP_HOME_VALUE = HOME_VALUE;
M_HOME_VALUE = 0;
if missing(HOME_VALUE) then do;
	IMP_HOME_VALUE = 154000;
	M_HOME_VALUE = 1;
end;
drop HOME_VALUE;

if missing(FLAG_CONTACT) then FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;


proc print data=NEW_CUSTOMERS(obs=100);
run;


proc print data=NEW_CUSTOMERS(obs=15);
run;


/*-----------------------------------------------------------*/

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;

IMP_JOB = JOB;
M_JOB = 0;
if missing(JOB) then do;
	IMP_JOB = "PROFESSIONAL";
	M_JOB = 1;
end;
drop JOB;

IMP_EDUCATION = EDUCATION;
M_EDUCATION = 0;
if EDUCATION in ("???") then do;
	IMP_EDUCATION = "HighSchool";
	M_EDUCATION = 1;
end;
drop EDUCATION;

IMP_AGE = AGE;
if missing(AGE) then IMP_AGE = 44.9;
drop AGE;

IMP_YOJ = YOJ;
M_YOJ = 0;
if missing(YOJ) then do;
	IMP_YOJ = 10.5;
	M_YOJ = 1;
end;
drop YOJ;

IMP_HOME_VALUE = HOME_VALUE;
M_HOME_VALUE = 0;
if missing(HOME_VALUE) then do;
	IMP_HOME_VALUE = 154000;
	M_HOME_VALUE = 1;
end;
drop HOME_VALUE;

if missing(FLAG_CONTACT) then FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;


proc freq data=NEW_CUSTOMERS;
table IMP_JOB M_JOB  IMP_EDUCATION M_EDUCATION /missing;
run;

proc print data=NEW_CUSTOMERS(obs=100);
run;


proc print data=NEW_CUSTOMERS(obs=15);
run;




/*-----------------------------------------------------------*/

data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;

IMP_INCOME = INCOME;
M_INCOME = 0;
if missing(IMP_INCOME) then do;
	M_INCOME = 1;
	if JOB in ("OFFICE","OTHER") then do;
		if YOJ >= 1.5 or missing(YOJ) then 
			IMP_INCOME = 27215; else IMP_INCOME = 96;
	end;
	else do;
		if EDUCATION in ("GRADSCHOOL","???") then 
			IMP_INCOME = 100370; else IMP_INCOME = 64691;
	end;
end;
drop INCOME;

IMP_JOB = JOB; M_JOB = 0;
if missing(JOB) then do; IMP_JOB = "PROFESSIONAL"; M_JOB = 1; end;
drop JOB;

IMP_EDUCATION = EDUCATION; M_EDUCATION = 0;
if EDUCATION in ("???") then do; IMP_EDUCATION = "HighSchool"; M_EDUCATION = 1; end;
drop EDUCATION;

IMP_AGE = AGE; if missing(AGE) then IMP_AGE = 44.9; drop AGE;

IMP_YOJ = YOJ; M_YOJ = 0;
if missing(YOJ) then do; IMP_YOJ = 10.5; M_YOJ = 1; end;
drop YOJ;

IMP_HOME_VALUE = HOME_VALUE; M_HOME_VALUE = 0;
if missing(HOME_VALUE) then do; IMP_HOME_VALUE = 154000; M_HOME_VALUE = 1; end;
drop HOME_VALUE;

if missing(FLAG_CONTACT) then FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;

proc print data=NEW_CUSTOMERS(obs=100);
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

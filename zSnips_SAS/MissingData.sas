/*--------------------------------------------------------------------------------------
EXAMPLE: MISSING DATA TABLE-------------------------------------------------------------
---------------------------------------------------------------------------------------*/

/* create a table that will show the missing values */

proc freq data = &Infile.;
table car_use /missing;
run;


proc freq data=tempfile;
table target_flag * impjob /missing;
run;



/*--------------------------------------------------------------------------------------
EXAMPLE: -------------------------------------------------------------
---------------------------------------------------------------------------------------*/
Step 1:  explore the data  (ie: proc contents)
Step 2: determine if there are missing values (proc means statement with n, nmiss, mean)
Step 3: determine if categorical variables are missing (proc freq for character variables 
        with /missing command)
Step 4: fix missing values with data step
*/

/*Step1*/
proc contents

/*Step2 specify stats for missing variables*/
proc means data=CUSTOMERS mean median n nmiss;
proc means data=CUSTOMERS n nmiss mean;
var AGE CAR_VALUE FLAG_CONTACT HOME_VALUE INCOME VACATION YOJ;
run;

/*Step3 creates tables for the Job, Education, Flag_Contact (which are categorical)*/
proc freq data=CUSTOMERS;
table JOB EDUCATION FLAG_CONTACT /missing;
run;

/*Step4 put the original data in a new data set where the missing value handling will occur*/
data NEW_CUSTOMERS;
set CUSTOMERS;
run;

proc print data=NEW_CUSTOMERS(obs=15);
run;

/*Step4.1 option 1: to delete the row if data is missing */
data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
run;

/*Step4.2 option2: avoid using hte variable with the missing value (if there are a lot of 
missing values, ie: high percentage of total observations) this is probably a good idea */
data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
drop CAR_VALUE;
run;

/Step4.3 option3: use business rule to fix a missing value */
data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;
if missing(FLAG_CONTACT) then FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;

/* Step4.4 option4: impute the missing values with an average*/
data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;

IMP_AGE = AGE;
if missing(AGE) then IMP_AGE = 44.9; /*impute with mean*/
drop AGE;                            /*drop original variable*/

IMP_YOJ = YOJ;
M_YOJ = 0;
if missing(YOJ) then do;
	IMP_YOJ = 10.5;    /*impute with mean*/
	M_YOJ = 1;         /*add impute flag*/
end;
drop YOJ;

IMP_HOME_VALUE = HOME_VALUE;
M_HOME_VALUE = 0;
if missing(HOME_VALUE) then do;
	IMP_HOME_VALUE = 154000;
	M_HOME_VALUE = 1;
end;
drop HOME_VALUE;      /*drop original variable*/

/*Step4.5 option 5: use a decision tree to impute missing value
For the INCOME variable, a simple decision tree was used to predict the value 
of INCOME based upon the other variables in the data set
*/
data NEW_CUSTOMERS;
set CUSTOMERS;
if missing(VACATION) then delete;

IMP_INCOME = INCOME;
M_INCOME = 0;
if missing(IMP_INCOME) then do;
  M_INCOME = 1;
if JOB in ("OFFICE","OTHER") then do;
	if YOJ >= 1.5 or missing(YOJ) then 
    IMP_INCOME = 27215; 
  else IMP_INCOME = 96;
end;
else do;
	if EDUCATION in ("GRADSCHOOL","???") then 
    IMP_INCOME = 100370; 
  else IMP_INCOME = 64691;
end;
end;
drop INCOME;

IMP_JOB = JOB; M_JOB = 0;
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
if missing(AGE) then 
  IMP_AGE = 44.9; 
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

if missing(FLAG_CONTACT) then 
  FLAG_CONTACT = 0;
if FLAG_CONTACT = 0 then 
  delete;
drop FLAG_CONTACT;
drop CAR_VALUE;
run;





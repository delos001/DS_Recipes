

%let Path = /folders/myfolders/sasuser.v94/Unit02;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let Infile = &LIB.logit_insurance;
%let testfile = &LIB.logit_insurance_test;
%let Tempfile = Tempfile;

proc means data=&testfile;
proc means data=&infile;

data deploybbpurepre;
set &testfile;
/*add imputed Job*/

flJOB = 0;
if missing(JOB) then flJOB=1;
impJOB = JOB;
if missing(JOB) then impJOB = "Unknown";

capCar_Age = CAR_AGE;
if CAR_AGE < 0 then capCAR_AGE = 0;	

/*add imputed income*/
	IF EDUCATION = "<High School" THEN regEDUCATION3=0;
	IF EDUCATION = "Bachelors" THEN regEDUCATION3=22152;
	IF EDUCATION = "Masters" THEN regEDUCATION3=29332;
	IF EDUCATION = "PhD" THEN regEDUCATION3=66497;
	IF EDUCATION = "z_High School" THEN regEDUCATION3=8150;
	
	IF impJOB = "Clerical" THEN regJOB3=0;
	IF impJOB = "Doctor" THEN regJOB3=29645;
	IF impJOB = "Home Maker" THEN regJOB3=-32294;
	IF impJOB = "Lawyer" THEN regJOB3=25606;
	IF impJOB = "Manager" THEN regJOB3=27992;
	IF impJOB = "Professional" THEN regJOB3= 24496;
	IF impJOB = "Student" THEN regJOB3=-25913;
	IF impJOB = "z_Blue Collar" THEN regJOB3=19442;
	IF impJOB = "Unknown" THEN regJOB3 = 38954;

	IF CLM_FREQ = 0 THEN regCLM_FREQ3 = 0;	
	IF CLM_FREQ = 1 THEN regCLM_FREQ3 = -6291;
	IF CLM_FREQ = 2 THEN regCLM_FREQ3 = -1864;
	IF CLM_FREQ = 3 THEN regCLM_FREQ3 = -2411;
	IF CLM_FREQ = 4 THEN regCLM_FREQ3 = -9983;
		
	IF MSTATUS = "Yes" THEN regMSTATUS3 = 0;
	IF MSTATUS = "z_No" THEN regMSTATUS3 = 1279;
	
	IF PARENT1 = "No" THEN regPARENT13 =0;
	IF PARENT1 = "Yes" THEN regPARENT13 =898;
	

flINCOME = 0;
if missing(INCOME) then flINCOME =1;		
impINCOME = INCOME;
if missing(INCOME) then impINCOME=
					12771
					+ BLUEBOOK  * 1.1
					+ regEDUCATION3
					+ regJOB3
					+ regCLM_FREQ3
					+ regMSTATUS3
					+ regPARENT13;
	
if impINCOME < 0 then impINCOME =0;

/*add impAGE*/
	IF impJOB = "Clerical" THEN regJOB=0;
	IF impJOB = "Doctor" THEN regJOB=2.4;
	IF impJOB = "Home Maker" THEN regJOB=4.6;
	IF impJOB = "Lawyer" THEN regJOB=2.8;
	IF impJOB = "Manager" THEN regJOB=2.2;
	IF impJOB = "Professional" THEN regJOB= 1.6;
	IF impJOB = "Student" THEN regJOB=2.8;
	IF impJOB = "z_Blue Collar" THEN regJOB=1.0;
	IF impJOB = "Unknown" THEN regJOB=0.6;

	IF CAR_TYPE = "Minivan" THEN regCAR_TYPE= 0;
	IF CAR_TYPE = "Panel Truck" THEN regCAR_TYPE= -2.2;
	IF CAR_TYPE = "Pickup" THEN regCAR_TYPE= 0.2;
	IF CAR_TYPE = "Sports Car" THEN regCAR_TYPE= 3.8;
	IF CAR_TYPE = "Van" THEN regCAR_TYPE= -0.9;
	IF CAR_TYPE = "z_SUV" THEN regCAR_TYPE= 2.6;

	IF EDUCATION = "<High School" THEN regEDUCATION=0;
	IF EDUCATION = "Bachelors" THEN regEDUCATION=0.02;
	IF EDUCATION = "Masters" THEN regEDUCATION=1.0;
	IF EDUCATION = "PhD" THEN regEDUCATION=2.6;
	IF EDUCATION = "z_High School" THEN regEDUCATION=-0.1;
	
	IF MSTATUS = "Yes" THEN regMSTATUS = 0;
	IF MSTATUS = "z_No" THEN regMSTATUS = -1.2;
	
	IF SEX = "M" THEN regSEX = 0;
	IF SEX = "z_F" THEN regSEX = -2.9;
	
	IF URBANICITY = "Highly Urban/ Urban" THEN regURBANICITY = 0;
	IF URBANICITY = "z_Highly Rural/ Rural" THEN regURBANICITY = 0.6;

flAGE = 0;
if missing(AGE) then flAGE=1;
impAGE=AGE;
if missing(AGE) then impAGE =
				38.6
				+ KIDSDRIV		* 2.8
				+ HOMEKIDS		* -3.9
				+ BLUEBOOK		* 0.0002
				+ YOJ			* 0.4
				+ HOME_VAL		* 0.000003
				+ regJOB
				+ regCAR_TYPE
				+ regEDUCATION
				+ regMSTATUS
				+ regSEX
				+ regURBANICITY;
if missing(impAGE) then impAGE = 45;
				
/*add imputed YOJ*/
	IF EDUCATION = "<High School" THEN regEDUCATION2=0;
	IF EDUCATION = "Bachelors" THEN regEDUCATION2=-0.2;
	IF EDUCATION = "Masters" THEN regEDUCATION2=0.3;
	IF EDUCATION = "PhD" THEN regEDUCATION2=-0.8;
	IF EDUCATION = "z_High School" THEN regEDUCATION2=0.02;
	
	IF impJOB = "Clerical" THEN regJOB2=0;
	IF impJOB = "Doctor" THEN regJOB2=-0.4;
	IF impJOB = "Home Maker" THEN regJOB2=-5.3;
	IF impJOB = "Lawyer" THEN regJOB2=-0.4;
	IF impJOB = "Manager" THEN regJOB2=-0.4;
	IF impJOB = "Professional" THEN regJOB2= -0.3;
	IF impJOB = "Student" THEN regJOB2=-5.2;
	IF impJOB = "z_Blue Collar" THEN regJOB2=-0.2;
	IF impJOB = "Unknown" THEN regJOB2 = -0.6;

	IF MSTATUS = "Yes" THEN regMSTATUS2 = 0;
	IF MSTATUS = "z_No" THEN regMSTATUS2 = -0.96;

flYOJ = 0;
if missing(YOJ) then flYOJ =1;		
impYOJ= YOJ;
if missing(YOJ) then impYOJ =
				7.0
				+ KIDSDRIV 		* -0.4
				+ HOMEKIDS		* 0.9
				+ impAGE			* 0.1
				+ impINCOME		* 0.00001
				+ regEDUCATION2
				+ regJOB2
				+ regMSTATUS2;

/*add imputed car_age*/
	IF EDUCATION = "<High School" THEN regEDUCATION5=0;
	IF EDUCATION = "Bachelors" THEN regEDUCATION5=5.5;
	IF EDUCATION = "Masters" THEN regEDUCATION5=10.7;
	IF EDUCATION = "PhD" THEN regEDUCATION5=10.5;
	IF EDUCATION = "z_High School" THEN regEDUCATION5=1.1;

flCAR_AGE = 0;
if missing(capCAR_AGE) then flCAR_AGE =1;
impCAR_AGE = capCAR_AGE;
if missing(capCAR_AGE) then impCAR_AGE=
					3.59539 
					+ impHOME_VAL * -0.00000121
					+regEDUCATION5;
					
/*add imputed home_value*/
	IF EDUCATION = "<High School" THEN regEDUCATION4=0;
	IF EDUCATION = "Bachelors" THEN regEDUCATION4=13804;
	IF EDUCATION = "Masters" THEN regEDUCATION4=9999;
	IF EDUCATION = "PhD" THEN regEDUCATION4=-4463;
	IF EDUCATION = "z_High School" THEN regEDUCATION4=2106;

	IF MSTATUS = "Yes" THEN regMSTATUS4 = 0;
	IF MSTATUS = "z_No" THEN regMSTATUS4 = -131744;
	
	IF PARENT1 = "Yes" THEN regPARENT14 = 0;
	IF PARENT1 = "No" THEN regPARENT14 = -21851;

flHOME_VAL = 0;
if missing(HOME_VAL) then flHOME_VAL =1;
impHOME_VAL = HOME_VAL;
if missing(HOME_VAL) then impHOME_VAL=
						93479
						+ HOMEKIDS 	* -4523.3
						+ impAGE		* 927
						+ impINCOME	* 1.6
						+ CLM_FREQ  * -3571
						+ impCAR_AGE* -868.8
						+ regEDUCATION4
						+ regMSTATUS4
						+ regPARENT14;

if impHOME_VAL < 0 then impHOME_VAL = 0;

/*create suspicious income variable*/
temp = 0;
if ((impJOB = "Home Maker") OR (impJOB = "Student")) then temp=1;
SUSP_INCOME=0;
if (impINCOME < 10000) and temp=0
	then SUSP_INCOME = 1;
drop temp;

/*create average claim per year variable*/
CLAIM_PER_YEAR = OLDCLAIM/5;

/*create cost per claim*/
IF CLM_FREQ = 0 THEN COST_PER_CLAIM=0;
	ELSE COST_PER_CLAIM = OLDCLAIM/CLM_FREQ;

/*create do you own home flag*/
OWN_HOME = 0;
if HOME_VAL > 0 then OWN_HOME=1;

/*create income to home value ratio*/
if impHOME_VAL = 0 then INCOME_HOME=0;
ELSE INCOME_HOME = impINCOME/impHOME_VAL;

drop
AGE
JOB
YOJ
INCOME
HOME_VAL
CAR_AGE
capCar_Age
regEDUCATION3
regJOB3
regCLM_FREQ3
regMSTATUS3
regPARENT13
regJOB
regCAR_TYPE
regEDUCATION
regMSTATUS
regSEX
regURBANICITY
regEDUCATION2
regJOB2
regMSTATUS2
regEDUCATION5
regEDUCATION4
regMSTATUS4
regPARENT14;

/*create transformed variables*/
logBlueBook = sign(BlueBook)*log(abs(BlueBook)+1);
logMVR_PTS = sign(MVR_PTS)*log(abs(MVR_PTS)+1);
logOLDCLAIM = sign(OLDCLAIM)*log(abs(OLDCLAIM)+1);
logTRAVTIME = sign(TRAVTIME)*log(abs(TRAVTIME)+1);
logimpCAR_AGE = sign(impCAR_AGE)*log(abs(impCAR_AGE)+1);
logimpHOME_VAL = sign(impHOME_VAL)*log(abs(impHOME_VAL)+1);
logimpINCOME = sign(impINCOME)*log(abs(impINCOME)+1);
run;



data deploybbpureprea;
set deploybbpurepre;

/*standardized trimming ZTRANS*/
proc means data=deploybbpureprea;
output out = meanfile
	mean(Claim_Per_Year)=U1
	stddev(Claim_Per_Year)=S1
	mean(Cost_Per_Claim)=U2
	stddev(Cost_Per_Claim)=S2
	mean(Cost_Per_Claim)=U3
	stddev(Cost_Per_Claim)=S3;
run;
data;
set meanfile;
call symput("U1",U1);
call symput("S1",S1);
call symput("U2",U2);
call symput("S2",S2);
call symput("U3",U3);
call symput("S3",S3);
run;

data deploybbpureprea;
set deploybbpureprea;
stdClaim_Per_Year = (Claim_Per_Year-&U1.)/&S1.;
T_stdClaim_Per_Year = max(min(stdClaim_Per_Year,3),-3);
stdCost_Per_Claim = (Cost_Per_Claim-&U2.)/&S2.;
T_stdCost_Per_Claim = max(min(stdCost_Per_Claim,3),-3);
stdTIF = (TIF-&U3.)/&S3.;
T_stdTIF = max(min(stdTIF,3),-3);

drop stdClaim_Per_Year stdCost_Per_Claim stdTIF;

/*these are based on prog log from mod 2: ie: significant vs. not*/
ED_nss = Education in ("<High School","Phd" "z_High School");
ED_zhs = Education in ("z_High School");
ED_ba = Education in ("Bachelors");
ED_ma = Education in ("Masters");
CARType_suv = Car_Type in ("z_SUV");
CARType_sc = Car_Type in ("Sports Car");
CARType_mv = Car_Type in ("Minivan");
CARType_nss = Car_Type in ("Panel Truck", "Pickup", "Van");
JOBnss = impJOB in ("Home Maker", "Lawyer", "Professional");
Jobbc = impJOB in ("z_Blue Collar");
JOBdr = impJob in ("Doctor");
JOBman = impJob in ("Manager");
Jobst = impJob in ("Student");
JOBunk = impJob in ("Unknown");

if impJOB="Clerical" then JOB_cl = 1;
	else JOB_cl = 0;
if impJOB="Doctor" then JOB_dr = 1;
	else JOB_dr = 0;
if impJOB="Home Maker" then JOB_hm = 1;
	else JOB_hm = 0;
if impJOB="Lawyer" then JOB_la = 1;
	else JOB_la = 0;
if impJOB="Manager" then JOB_ma = 1;
	else JOB_ma = 0;
if impJOB="Professional" then JOB_pr = 1;
	else JOB_pr = 0;
if impJOB="Student" then JOB_st = 1;
	else JOB_st = 0;
if impJOB="z_Blue Collar" then JOB_bc = 1;
	else JOB_bc = 0;
if impJOB="Unknown" then JOB_un = 1;
	else JOB_un = 0;

/*get rid of negative age value*/
capCar_Age = CAR_AGE;
if CAR_AGE < 0 then capCAR_AGE = 0;

/*create dummy variables for variables with less than 7 levels*/
KIDSDRIV_0=(KIDSDRIV=0);
KIDSDRIV_1=(KIDSDRIV=1);
KIDSDRIV_2=(KIDSDRIV=2);
KIDSDRIV_3=(KIDSDRIV=3);
KIDSDRIV_4=(KIDSDRIV=4);

HOMEKIDS_0=(HOMEKIDS=0);
HOMEKIDS_1=(HOMEKIDS=1);
HOMEKIDS_2=(HOMEKIDS=2);
HOMEKIDS_3=(HOMEKIDS=3);
HOMEKIDS_4=(HOMEKIDS=4);
HOMEKIDS_5=(HOMEKIDS=5);

CLM_FREQ_0=(CLM_FREQ=0);
CLM_FREQ_1=(CLM_FREQ=1);
CLM_FREQ_2=(CLM_FREQ=2);
CLM_FREQ_3=(CLM_FREQ=3);
CLM_FREQ_4=(CLM_FREQ=4);
CLM_FREQ_5=(CLM_FREQ=5);

/*create dummy variables for categorical variables*/
if CAR_TYPE="Minivan" then CAR_TYPE_mv = 1;
	else CAR_TYPE_mv = 0;
if CAR_TYPE="Panel Truck" then CAR_TYPE_pt = 1;
	else CAR_TYPE_pt = 0;
if CAR_TYPE="Pickup" then CAR_TYPE_pu = 1;
	else CAR_TYPE_pu = 0;
if CAR_TYPE="Sports Car" then CAR_TYPE_sc = 1;
	else CAR_TYPE_sc = 0;
if CAR_TYPE="Van" then CAR_TYPE_vn = 1;
		else CAR_TYPE_vn = 0;
if CAR_TYPE="z_SUV" then CAR_TYPE_su = 1;
	else CAR_TYPE_su = 0;

if CAR_USE="Commercial" then CAR_USE_co = 1;
	else CAR_USE_co = 0;
if CAR_USE="Private" then CAR_USE_pr = 1;
	else CAR_USE_pr = 0;

if EDUCATION="<High School" then EDUCATION_lhs = 1;
	else EDUCATION_lhs = 0;
if EDUCATION="Bachelors" then EDUCATION_ba = 1;
	else EDUCATION_ba = 0;
if EDUCATION="Masters" then EDUCATION_ma = 1;
	else EDUCATION_ma = 0;
if EDUCATION="PhD" then EDUCATION_ph = 1;
	else EDUCATION_ph = 0;
if EDUCATION="z_High School" then EDUCATION_zhs = 1;
		else EDUCATION_zhs = 0;

if MSTATUS="Yes" then MSTATUS_y = 1;
	else MSTATUS_y = 0;
if MSTATUS="z_No" then MSTATUS_n = 1;
	else MSTATUS_n = 0;

if PARENT1="Yes" then PARENT1_y = 1;
	else PARENT1_y = 0;
if PARENT1="No" then PARENT1_n = 1;
	else PARENT1_n = 0;

if RED_CAR="yes" then RED_CAR_y = 1;
	else RED_CAR_y = 0;
if RED_CAR="no" then RED_CAR_n = 1;
	else RED_CAR_n = 0;

if REVOKED="Yes" then REVOKED_y = 1;
	else REVOKED_y = 0;
if REVOKED="No" then REVOKED_n = 1;
	else REVOKED_n = 0;

if SEX="M" then SEX_m =1;
	else SEX_m =0;
if SEX="z_F" then SEX_f =1;
	else SEX_f =0;

if URBANICITY="Highly Urban/ Urban" then URBANICITY_u = 1;
	else URBANICITY_u = 0;
if URBANICITY="z_Highly Rural/ Rural" then URBANICITY_r = 1;
	else URBANICITY_r = 0;

/*put the resulting model parameters to calculate probability 
with the out-of-sample data*/
yhat = 
-130.0
+KIDSDRIV	 							*	0.4140
+(CAR_USE	in("Commercial"))				*	0.6459
+(MSTATUS	in("Yes"))					*	-0.4193
+(PARENT1	in("No"))						*	-0.4605
+(REVOKED	in("No"))						*	-0.9784
+(URBANICITY in("Highly Urban/ Urban"))	*	2.3367
+flJOB	 								*	-0.4702
+logBlueBook	 						*	-0.3498
+logMVR_PTS	 							*	0.2661
+logOLDCLAIM	 						*	0.0908
+logTRAVTIME	 						*	0.4242
+logimpHOME_VAL	 						*	-0.0298
+logimpINCOME	 						*	-0.0673
+T_stdClaim_Per_Year	 				*	-0.3049
+T_stdTIF	 							*	-315.0
+(ED_nss	in("0"))						*	-0.4290
+(CARType_sc	in("0"))					*	-0.2683
+(CARType_mv	in("0"))					*	0.6655
+(JOBnss	in("0"))						*	0.3004
+(JOBdr	in("0"))							*	0.8833
+(JOBman	in("0"))						*	1.0050
+(Jobst	in("0"))							*	0.4424
;

/*cap yhat so the exponent doesn't get to large and bog sas down*/
if yhat > 999 then yhat=999;
if yhat < -999 then yhat= -999;

/*converts to odd: P_Target_Flag = exp(yhat)
conver to probability: P_Target_Flag = exp(yhat)/(1+exp(yhat))*/
P_Target_Flag = exp(yhat)/(1+exp(yhat));

P_Target_Amt = 
				-7053.00919
+logBlueBook * 1365.09791
+logMVR_PTS	* 418.40664
+MSTATUS_y 	* -906.05183
+SEX_f 		* -680.88109;

Pure_Premium = P_Target_Flag * P_Target_Amt;
run;

proc means data=&Infile.;
proc means data=deploybbpureprea;
data ppfinal;
set deploybbpureprea;
keep index;
keep P_Target_Flag;
keep P_Target_Amt;
keep Pure_Premium ;

libname outfile '/folders/myfolders/sasuser.v94/Unit02';
data outfile.PPscorefile;
set ppfinal;
run;

proc print data=outfile.PPscorefile;
run;

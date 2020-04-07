

%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

%let fixedfile = fixedfile;
%let varlist = varlist;
%let Tempfile = Tempfile;
%let Mod1 = Mod1;
%let Mod2 = Mod2;
%let Mod3 = Mod3;


libname &Name. "&Path.";

%let Infile = &LIB.wine;

proc contents data=&Infile.;
proc print data=&Infile (obs=10);

/***********************************************************************
*                                                                      *
*                          EDA                                         *
*                                                                      *
***********************************************************************/
proc means data=&Infile. min p1 median mean p99 max nmiss stddev maxdec=2;

proc univariate normal plot data=&InFile.;
	var target;
		histogram 	target/normal (color=red w=2);
run;

/*create two other "target" variables to create 3 diff types of model: regression, 
poisson or neg binom, and hurdle*/
data &Tempfile.;
set &Infile.;
Target_flag = (Target > 0); /*puts a 1 if >0, else puts a 0*/
Target_Amt = Target -1;  /*we subtract 1 which will be added back later*/
if Target_flag = 0 then Target_Amt = .; /*puts blank when target_nozero =0*/
run;

proc univariate normal plot data=&Tempfile.;
	var target target_flag target_amt;
		histogram 	target target_flag target_amt/normal (color=red w=2);
run;

proc means data=&tempfile. min max n;
run;

proc freq data=&Tempfile.;
table Target Target_flag Target_Amt / missing;
/*Target_flag:  
zero cases sold = 2734
1 or more sold = 10061*/

proc print data=&Tempfile. (obs=20);
var Target Target_flag Target_Amt;
run;

proc univariate normal plot data=&Tempfile.;
	var Target 
		Target_Amt;
		histogram 	Target 
					Target_Amt/normal (color=red w=2);
run;

proc means data=&tempfile. min p1 median mean p99 max n nmiss stddev var;
var
	FixedAcidity
	VolatileAcidity
	CitricAcid
	ResidualSugar
	Chlorides
	FreeSulfurDioxide
	TotalSulfurDioxide
	Density
	pH
	Sulphates
	Alcohol
	LabelAppeal
	AcidIndex
	STARS;
run;

proc means data=&tempfile. min median mean max n nmiss maxdec=2;
class Target_flag;
var
	FixedAcidity
	VolatileAcidity
	CitricAcid
	ResidualSugar
	Chlorides
	FreeSulfurDioxide
	TotalSulfurDioxide
	Density
	pH
	Sulphates
	Alcohol
	LabelAppeal
	AcidIndex
	STARS;
run;

/*from proc means above, we notice that when star is missing, the bottles
don't seem to sell so creating freq table below*/
proc freq data=&Tempfile.;
table Stars*Target_flag / missing;
run;
/*when star rating is missing, bottle doesn't seel 60% of the time
and does sell 40% of the time
if star is 1, it doesn't sell 19% of time and 80% is does sell
if 3 or 4 stars, at least 1 bottle sells 100% of time*/

proc univariate normal plot data=&Tempfile.;
 	var 	FixedAcidity
			VolatileAcidity
			CitricAcid
			ResidualSugar
			Chlorides
			FreeSulfurDioxide
			TotalSulfurDioxide
			Density
			pH
			Sulphates
			Alcohol
			LabelAppeal
			AcidIndex
			STARS;
			histogram 		FixedAcidity
							VolatileAcidity
							CitricAcid
							ResidualSugar
							Chlorides
							FreeSulfurDioxide
							TotalSulfurDioxide
							Density
							pH
							Sulphates
							Alcohol
							LabelAppeal
							AcidIndex
							STARS/normal (color=red w=2);
run;

proc means data=&tempfile. min median mean max n nmiss maxdec=2;
/***********************************************************************
*                                                                      *
*                          Fix File                                    *
*
***********************************************************************/
data &fixedfile.;
set &tempfile.;

/********don't forget that we created these************/
/* 
Target_flag = (Target > 0);
Target_Amt = Target -1; 
if Target_flag = 0 then Target_Amt = .; */

/*create imputed value variables*/
impResidualSugar = ResidualSugar;
impChlorides = Chlorides;
impFreeSulfurDioxide = FreeSulfurDioxide;
impTotalSulfurDioxide = TotalSulfurDioxide;
imppH = pH;
impSulphates = Sulphates;
impAlcohol = Alcohol;
impSTARS = STARS;

/*create imputed values, missing value, low cap, high cap flags*/
mResidualSugar = 0;
if missing(impResidualSugar) then do;
	impResidualSugar = 4.5;
	mResidualSugar = 1;
	end;
	
mChlorides = 0;
if missing(impChlorides) then do;
	impChlorides = 0.05;
	mChlorides = 1;
	end;
	
mFreeSulfurDioxide = 0;
if missing(impFreeSulfurDioxide) then do;
	impFreeSulfurDioxide = 30;
	mFreeSulfurDioxide = 1;
	end;
	
mTotalSulfurDioxide = 0;
if missing(impTotalSulfurDioxide) then do;
	impTotalSulfurDioxide = 122;
	mTotalSulfurDioxide = 1;
	end;

mpH = 0;
if missing(imppH) then do;
	imppH = 3.2;
	mpH = 1;
	end;
	
mSulphates = 0;
if missing(impSulphates) then do;
	impSulphates = 0.5;
	mSulphates = 1;
	end;
	
mAlcohol = 0;
if missing(impAlcohol) then do;
	impAlcohol = 10.4;
	mAlcohol = 1;
	end;
	
mSTARS = 0;
if missing(impSTARS) then do;
	impSTARS = 2;
	mSTARS = 1;
	end;

keep 
Index
Target
Target_flag
Target_Amt
FixedAcidity
VolatileAcidity
CitricAcid
impResidualSugar
mResidualSugar
impChlorides
mChlorides
impFreeSulfurDioxide
mFreeSulfurDioxide
impTotalSulfurDioxide
mTotalSulfurDioxide
Density
imppH
mpH
impSulphates
mSulphates
impAlcohol
mAlcohol
LabelAppeal
AcidIndex
impSTARS
mSTARS;
run;

proc means data=&tempfile. min p1 median mean p99 max n nmiss stddev var;
class Target_flag;
run;
proc means data=&fixedfile. min p1 median mean p99 max n nmiss stddev var;
class Target_flag;
run;

/*CREATE A SECOND FIXED FILE FOR MODEL 1 THAT CAPS ALL THE VARIABLES AT P1&P99*/
data fixedfilecaps;
set &fixedfile.;

/*cap non-imputed variables*/
cFixedAcidity = FixedAcidity;
hcFixedAcidity=0;
lcFixedAcidity=0;
if  FixedAcidity <-10 then do;
	cFixedAcidity = -10 ;
	lcFixedAcidity=1;
	end;
if  FixedAcidity >24 then do;
	cFixedAcidity = 24 ;
	hcFixedAcidity=1;
	end;
	
cVolatileAcidity = VolatileAcidity;
hcVolatileAcidity=0;
lcVolatileAcidity=0;
if  VolatileAcidity <-1.8 then do;
	cVolatileAcidity = -1.8 ;
	lcVolatileAcidity=1;
	end;
if  VolatileAcidity >2.5 then do;
	cVolatileAcidity = 2.5 ;
	hcVolatileAcidity=1;
	end;
	
cCitricAcid = CitricAcid;
hcCitricAcid=0;
lcCitricAcid=0;
if  CitricAcid <-2.1 then do;
	cCitricAcid = -2.1;
	lcCitricAcid=1;
	end;
if  CitricAcid >2.6 then do;
	cCitricAcid = 2.6 ;
	hcCitricAcid=1;
	end;

cDensity = Density;
hcDensity=0;
lcDensity=0;
if  Density <0.9 then do;
	cDensity = 0.9;
	lcDensity=1;
	end;
if  Density >1.07 then do;
	cDensity = 1.07 ;
	hcDensity=1;
	end;

cAcidIndex = AcidIndex;
hcAcidIndex=0;
lcAcidIndex=0;
if  AcidIndex <6 then do;
	cAcidIndex = 6;
	lcAcidIndex=1;
	end;
if  AcidIndex >13 then do;
	cAcidIndex = 13 ;
	hcAcidIndex=1;
	end;

/*cap imputed variables*/
cimpResidualSugar = impResidualSugar;
hcResidualSugar=0;
lcResidualSugar=0;
if  impResidualSugar <-91 then do;
	cimpResidualSugar = -91 ;
	lcResidualSugar=1;
	end;
if  impResidualSugar >99 then do;
	cimpResidualSugar = 99 ;
	hcResidualSugar=1;
	end;

cimpChlorides= impChlorides;
hcChlorides=0;
lcChlorides=0;
if  impChlorides <-1 then do;
	cimpChlorides = -1 ;
	lcChlorides=1;
	end;
if  impChlorides >0.95 then do;
	cimpChlorides = 0.95 ;
	hcChlorides=1;
	end;

cimpFreeSulfurDioxide = impFreeSulfurDioxide;
hcFreeSulfurDioxide=0;
lcFreeSulfurDioxide=0;
if  impFreeSulfurDioxide <-388 then do;
	cimpFreeSulfurDioxide = -388 ;
	lcFreeSulfurDioxide=1;
	end;
if  impFreeSulfurDioxide >469 then do;
	cimpFreeSulfurDioxide = 469 ;
	hcFreeSulfurDioxide=1;
	end;

cimpTotalSulfurDioxide = impTotalSulfurDioxide;
hcTotalSulfurDioxide=0;
lcTotalSulfurDioxide=0;
if  impTotalSulfurDioxide <-531 then do;
	cimpTotalSulfurDioxide = -531 ;
	lcTotalSulfurDioxide=1;
	end;
if  impTotalSulfurDioxide >767 then do;
	cimpTotalSulfurDioxide = 767;
	hcTotalSulfurDioxide=1;
	end;

cimppH = imppH;
hcpH=0;
lcpH=0;
if  imppH <1.3 then do;
	cimppH = 1.3 ;
	lcpH=1;
	end;
if  imppH >5.1 then do;
	cimppH = 5.1;
	hcpH=1;
	end;

cimpSulphates = impSulphates;
hcSulphates=0;
lcSulphates=0;
if  impSulphates <-2.1 then do;
	cimpSulphates = -2.1 ;
	lcSulphates=1;
	end;
if  impSulphates >3.1 then do;
	cimpSulphates = 3.1;
	hcSulphates=1;
	end;

cimpAlcohol = impAlcohol;
hcAlcohol=0;
lcAlcohol=0;
if  impAlcohol <0.1 then do;
	cimpAlcohol = 0.1 ;
	lcAlcohol=1;
	end;
if  impAlcohol >20 then do;
	cimpAlcohol = 20;
	hcAlcohol=1;
	end;

keep
Index
Target
Target_flag
Target_Amt

cFixedAcidity
hcFixedAcidity
lcFixedAcidity

cVolatileAcidity
hcVolatileAcidity
lcVolatileAcidity

cCitricAcid
hcCitricAcid
lcCitricAcid

mResidualSugar
cimpResidualSugar
hcResidualSugar
lcResidualSugar

mChlorides
cimpChlorides
hcChlorides
lcChlorides

mFreeSulfurDioxide
cimpFreeSulfurDioxide
hcFreeSulfurDioxide
lcFreeSulfurDioxide

mTotalSulfurDioxide
cimpTotalSulfurDioxide
hcTotalSulfurDioxide
lcTotalSulfurDioxide

cDensity
hcDensity
lcDensity

mpH
cimppH
hcpH
lcpH

mSulphates
cimpSulphates
hcSulphates
lcSulphates

mAlcohol
cimpAlcohol
hcAlcohol
lcAlcohol

LabelAppeal

cAcidIndex
hcAcidIndex
lcAcidIndex

impSTARS
mSTARS;
run;

proc means data=&fixedfile. min p1 median mean p99 max n nmiss stddev var;
class Target_flag;
run;

proc means data=fixedfilecaps min p1 median mean p99 max n nmiss stddev var;
class Target_flag;
run;
/***********************************************************************
*                                                                      *
*                          Model 1: Regression                         *
*                                                                      *
***********************************************************************/
data mod1;
set FixedFilecaps;
run;

proc reg data=mod1;
model Target = 
				cFixedAcidity
				hcFixedAcidity
				lcFixedAcidity
				
				cVolatileAcidity
				hcVolatileAcidity
				lcVolatileAcidity
				
				cCitricAcid
				hcCitricAcid
				lcCitricAcid
				
				mResidualSugar
				cimpResidualSugar
				hcResidualSugar
				lcResidualSugar
				
				mChlorides
				cimpChlorides
				hcChlorides
				lcChlorides
				
				mFreeSulfurDioxide
				cimpFreeSulfurDioxide
				hcFreeSulfurDioxide
				lcFreeSulfurDioxide
				
				mTotalSulfurDioxide
				cimpTotalSulfurDioxide
				hcTotalSulfurDioxide
				lcTotalSulfurDioxide
				
				cDensity
				hcDensity
				lcDensity
				
				mpH
				cimppH
				hcpH
				lcpH
				
				mSulphates
				cimpSulphates
				hcSulphates
				lcSulphates
				
				mAlcohol
				cimpAlcohol
				hcAlcohol
				lcAlcohol
				
				LabelAppeal
				
				cAcidIndex
				hcAcidIndex
				lcAcidIndex
				
				impSTARS
				mSTARS / selection=stepwise ;
run;

ods graphics on;
proc reg data=mod1 plots=(all);
model Target = 					
				cVolatileAcidity
				cimpChlorides
				cimpFreeSulfurDioxide
				cimpTotalSulfurDioxide
				cimppH
				hcpH
				lcpH
				cimpSulphates
				cimpAlcohol
				LabelAppeal
				cAcidIndex
				impSTARS
				mSTARS;

output out= outfile1 p=x_Reg;
run;
ods graphics off;

proc means data=outfile1;
run;
/***********************************************************************
*                          Model 1: Score DataStep                     *
***********************************************************************/
/*the data step to deploy the model to out-of-sample data*/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let testfile = &LIB.wine_test;

data Mod1score;
set &testfile;

Target_flag = (Target > 0);
Target_Amt = Target -1;
if Target_flag = 0 then Target_Amt = .;

/*create imputed value variables*/
impResidualSugar = ResidualSugar;
impChlorides = Chlorides;
impFreeSulfurDioxide = FreeSulfurDioxide;
impTotalSulfurDioxide = TotalSulfurDioxide;
imppH = pH;
impSulphates = Sulphates;
impAlcohol = Alcohol;
impSTARS = STARS;

/*create imputed values, missing value, low cap, high cap flags*/
mResidualSugar = 0;
if missing(impResidualSugar) then do;
	impResidualSugar = 4.5;
	mResidualSugar = 1;
	end;
	
mChlorides = 0;
if missing(impChlorides) then do;
	impChlorides = 0.05;
	mChlorides = 1;
	end;
	
mFreeSulfurDioxide = 0;
if missing(impFreeSulfurDioxide) then do;
	impFreeSulfurDioxide = 30;
	mFreeSulfurDioxide = 1;
	end;
	
mTotalSulfurDioxide = 0;
if missing(impTotalSulfurDioxide) then do;
	impTotalSulfurDioxide = 122;
	mTotalSulfurDioxide = 1;
	end;

mpH = 0;
if missing(imppH) then do;
	imppH = 3.2;
	mpH = 1;
	end;
	
mSulphates = 0;
if missing(impSulphates) then do;
	impSulphates = 0.5;
	mSulphates = 1;
	end;
	
mAlcohol = 0;
if missing(impAlcohol) then do;
	impAlcohol = 10.4;
	mAlcohol = 1;
	end;
	
mSTARS = 0;
if missing(impSTARS) then do;
	impSTARS = 2;
	mSTARS = 1;
	end;

/*cap non-imputed variables*/
cFixedAcidity = FixedAcidity;
hcFixedAcidity=0;
lcFixedAcidity=0;
if  FixedAcidity <-10 then do;
	cFixedAcidity = -10 ;
	lcFixedAcidity=1;
	end;
if  FixedAcidity >24 then do;
	cFixedAcidity = 24 ;
	hcFixedAcidity=1;
	end;
	
cVolatileAcidity = VolatileAcidity;
hcVolatileAcidity=0;
lcVolatileAcidity=0;
if  VolatileAcidity <-1.8 then do;
	cVolatileAcidity = -1.8 ;
	lcVolatileAcidity=1;
	end;
if  VolatileAcidity >2.5 then do;
	cVolatileAcidity = 2.5 ;
	hcVolatileAcidity=1;
	end;
	
cCitricAcid = CitricAcid;
hcCitricAcid=0;
lcCitricAcid=0;
if  CitricAcid <-2.1 then do;
	cCitricAcid = -2.1;
	lcCitricAcid=1;
	end;
if  CitricAcid >2.6 then do;
	cCitricAcid = 2.6 ;
	hcCitricAcid=1;
	end;

cDensity = Density;
hcDensity=0;
lcDensity=0;
if  Density <0.9 then do;
	cDensity = 0.9;
	lcDensity=1;
	end;
if  Density >1.07 then do;
	cDensity = 1.07 ;
	hcDensity=1;
	end;

cAcidIndex = AcidIndex;
hcAcidIndex=0;
lcAcidIndex=0;
if  AcidIndex <6 then do;
	cAcidIndex = 6;
	lcAcidIndex=1;
	end;
if  AcidIndex >13 then do;
	cAcidIndex = 13 ;
	hcAcidIndex=1;
	end;

/*cap imputed variables*/
cimpResidualSugar = impResidualSugar;
hcResidualSugar=0;
lcResidualSugar=0;
if  impResidualSugar <-91 then do;
	cimpResidualSugar = -91 ;
	lcResidualSugar=1;
	end;
if  impResidualSugar >99 then do;
	cimpResidualSugar = 99 ;
	hcResidualSugar=1;
	end;

cimpChlorides= impChlorides;
hcChlorides=0;
lcChlorides=0;
if  impChlorides <-1 then do;
	cimpChlorides = -1 ;
	lcChlorides=1;
	end;
if  impChlorides >0.95 then do;
	cimpChlorides = 0.95 ;
	hcChlorides=1;
	end;

cimpFreeSulfurDioxide = impFreeSulfurDioxide;
hcFreeSulfurDioxide=0;
lcFreeSulfurDioxide=0;
if  impFreeSulfurDioxide <-388 then do;
	cimpFreeSulfurDioxide = -388 ;
	lcFreeSulfurDioxide=1;
	end;
if  impFreeSulfurDioxide >469 then do;
	cimpFreeSulfurDioxide = 469 ;
	hcFreeSulfurDioxide=1;
	end;

cimpTotalSulfurDioxide = impTotalSulfurDioxide;
hcTotalSulfurDioxide=0;
lcTotalSulfurDioxide=0;
if  impTotalSulfurDioxide <-531 then do;
	cimpTotalSulfurDioxide = -531 ;
	lcTotalSulfurDioxide=1;
	end;
if  impTotalSulfurDioxide >767 then do;
	cimpTotalSulfurDioxide = 767;
	hcTotalSulfurDioxide=1;
	end;

cimppH = imppH;
hcpH=0;
lcpH=0;
if  imppH <1.3 then do;
	cimppH = 1.3 ;
	lcpH=1;
	end;
if  imppH >5.1 then do;
	cimppH = 5.1;
	hcpH=1;
	end;

cimpSulphates = impSulphates;
hcSulphates=0;
lcSulphates=0;
if  impSulphates <-2.1 then do;
	cimpSulphates = -2.1 ;
	lcSulphates=1;
	end;
if  impSulphates >3.1 then do;
	cimpSulphates = 3.1;
	hcSulphates=1;
	end;

cimpAlcohol = impAlcohol;
hcAlcohol=0;
lcAlcohol=0;
if  impAlcohol <0.1 then do;
	cimpAlcohol = 0.1 ;
	lcAlcohol=1;
	end;
if  impAlcohol >20 then do;
	cimpAlcohol = 20;
	hcAlcohol=1;
	end;

P_Regression = 3.77766
+ cVolatileAcidity			*	-0.10047
+ cimpChlorides				*	-0.11700
+ cimpFreeSulfurDioxide		*	0.00029208
+ cimpTotalSulfurDioxide	*	0.00022438
+ cimppH					*	-0.06295
+ hcpH						*	0.30187
+ lcpH						*	-0.27797
+ cimpSulphates				*	-0.03191
+ cimpAlcohol				*	0.01308
+ LabelAppeal				*	0.46750
+ cAcidIndex				*	-0.21264
+ impSTARS					*	0.77819
+ mSTARS					*	-2.24222
;
run;

proc print data=Mod1score (obs=10);
run;

proc means data=Mod1score min mean max n;
run;

data Mod1output;
set Mod1score;
keep index;
keep target;
keep P_Regression;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Mod1output;
set Mod1output;
run;

proc print data=outfile.Mod1output;
run;

proc print data=mod1score (obs=10);
run;

/***********************************************************************
*                                                                      *
*                          Model 2: Logistic LogLink NB dist           *
*                                                                      *
***********************************************************************/
proc genmod data=outfile1;
	model Target = 
					cVolatileAcidity
					cimpChlorides
					cimpFreeSulfurDioxide
					cimpTotalSulfurDioxide
					cimpSulphates
					cimpAlcohol
					LabelAppeal
					cAcidIndex
					impSTARS
					mSTARS / link=log dist=nb;
					output out=outfile2 p=x_nb;
run;

/***********************************************************************
*                          Model 2: Score DataStep                     *
***********************************************************************/
/*the data step to deploy the model to out-of-sample data*/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let testfile = &LIB.wine_test;

data Mod2score;
set &testfile;

Target_flag = (Target > 0);
Target_Amt = Target -1;
if Target_flag = 0 then Target_Amt = .;

/*create imputed value variables*/
impResidualSugar = ResidualSugar;
impChlorides = Chlorides;
impFreeSulfurDioxide = FreeSulfurDioxide;
impTotalSulfurDioxide = TotalSulfurDioxide;
imppH = pH;
impSulphates = Sulphates;
impAlcohol = Alcohol;
impSTARS = STARS;

/*create imputed values, missing value, low cap, high cap flags*/
mResidualSugar = 0;
if missing(impResidualSugar) then do;
	impResidualSugar = 4.5;
	mResidualSugar = 1;
	end;
	
mChlorides = 0;
if missing(impChlorides) then do;
	impChlorides = 0.05;
	mChlorides = 1;
	end;
	
mFreeSulfurDioxide = 0;
if missing(impFreeSulfurDioxide) then do;
	impFreeSulfurDioxide = 30;
	mFreeSulfurDioxide = 1;
	end;
	
mTotalSulfurDioxide = 0;
if missing(impTotalSulfurDioxide) then do;
	impTotalSulfurDioxide = 122;
	mTotalSulfurDioxide = 1;
	end;

mpH = 0;
if missing(imppH) then do;
	imppH = 3.2;
	mpH = 1;
	end;
	
mSulphates = 0;
if missing(impSulphates) then do;
	impSulphates = 0.5;
	mSulphates = 1;
	end;
	
mAlcohol = 0;
if missing(impAlcohol) then do;
	impAlcohol = 10.4;
	mAlcohol = 1;
	end;
	
mSTARS = 0;
if missing(impSTARS) then do;
	impSTARS = 2;
	mSTARS = 1;
	end;

/*cap non-imputed variables*/
cFixedAcidity = FixedAcidity;
hcFixedAcidity=0;
lcFixedAcidity=0;
if  FixedAcidity <-10 then do;
	cFixedAcidity = -10 ;
	lcFixedAcidity=1;
	end;
if  FixedAcidity >24 then do;
	cFixedAcidity = 24 ;
	hcFixedAcidity=1;
	end;
	
cVolatileAcidity = VolatileAcidity;
hcVolatileAcidity=0;
lcVolatileAcidity=0;
if  VolatileAcidity <-1.8 then do;
	cVolatileAcidity = -1.8 ;
	lcVolatileAcidity=1;
	end;
if  VolatileAcidity >2.5 then do;
	cVolatileAcidity = 2.5 ;
	hcVolatileAcidity=1;
	end;
	
cCitricAcid = CitricAcid;
hcCitricAcid=0;
lcCitricAcid=0;
if  CitricAcid <-2.1 then do;
	cCitricAcid = -2.1;
	lcCitricAcid=1;
	end;
if  CitricAcid >2.6 then do;
	cCitricAcid = 2.6 ;
	hcCitricAcid=1;
	end;

cDensity = Density;
hcDensity=0;
lcDensity=0;
if  Density <0.9 then do;
	cDensity = 0.9;
	lcDensity=1;
	end;
if  Density >1.07 then do;
	cDensity = 1.07 ;
	hcDensity=1;
	end;

cAcidIndex = AcidIndex;
hcAcidIndex=0;
lcAcidIndex=0;
if  AcidIndex <6 then do;
	cAcidIndex = 6;
	lcAcidIndex=1;
	end;
if  AcidIndex >13 then do;
	cAcidIndex = 13 ;
	hcAcidIndex=1;
	end;

/*cap imputed variables*/
cimpResidualSugar = impResidualSugar;
hcResidualSugar=0;
lcResidualSugar=0;
if  impResidualSugar <-91 then do;
	cimpResidualSugar = -91 ;
	lcResidualSugar=1;
	end;
if  impResidualSugar >99 then do;
	cimpResidualSugar = 99 ;
	hcResidualSugar=1;
	end;

cimpChlorides= impChlorides;
hcChlorides=0;
lcChlorides=0;
if  impChlorides <-1 then do;
	cimpChlorides = -1 ;
	lcChlorides=1;
	end;
if  impChlorides >0.95 then do;
	cimpChlorides = 0.95 ;
	hcChlorides=1;
	end;

cimpFreeSulfurDioxide = impFreeSulfurDioxide;
hcFreeSulfurDioxide=0;
lcFreeSulfurDioxide=0;
if  impFreeSulfurDioxide <-388 then do;
	cimpFreeSulfurDioxide = -388 ;
	lcFreeSulfurDioxide=1;
	end;
if  impFreeSulfurDioxide >469 then do;
	cimpFreeSulfurDioxide = 469 ;
	hcFreeSulfurDioxide=1;
	end;

cimpTotalSulfurDioxide = impTotalSulfurDioxide;
hcTotalSulfurDioxide=0;
lcTotalSulfurDioxide=0;
if  impTotalSulfurDioxide <-531 then do;
	cimpTotalSulfurDioxide = -531 ;
	lcTotalSulfurDioxide=1;
	end;
if  impTotalSulfurDioxide >767 then do;
	cimpTotalSulfurDioxide = 767;
	hcTotalSulfurDioxide=1;
	end;

cimppH = imppH;
hcpH=0;
lcpH=0;
if  imppH <1.3 then do;
	cimppH = 1.3 ;
	lcpH=1;
	end;
if  imppH >5.1 then do;
	cimppH = 5.1;
	hcpH=1;
	end;

cimpSulphates = impSulphates;
hcSulphates=0;
lcSulphates=0;
if  impSulphates <-2.1 then do;
	cimpSulphates = -2.1 ;
	lcSulphates=1;
	end;
if  impSulphates >3.1 then do;
	cimpSulphates = 3.1;
	hcSulphates=1;
	end;

cimpAlcohol = impAlcohol;
hcAlcohol=0;
lcAlcohol=0;
if  impAlcohol <0.1 then do;
	cimpAlcohol = 0.1 ;
	lcAlcohol=1;
	end;
if  impAlcohol >20 then do;
	cimpAlcohol = 20;
	hcAlcohol=1;
	end;

P_Genmod_NB = 1.4772
+ cVolatileAcidity			*	-0.0326
+ cimpChlorides				*	-0.0364
+ cimpFreeSulfurDioxide		*	0.0001
+ cimpTotalSulfurDioxide	*	0.0001
+ cimpSulphates				*	-0.0122
+ cimpAlcohol				*	0.0037
+ LabelAppeal				*	0.1591
+ cAcidIndex				*	-0.0834
+ impSTARS					*	0.1877
+ mSTARS					*	-1.0236
;

P_Genmod_NB = exp(P_Genmod_NB);
run;

proc print data=Mod2score (obs=10);
run;

proc means data=Mod2score min mean max n;
run;

data Mod2output;
set Mod2score;
keep index;
keep target;
keep P_Genmod_NB;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Mod2output;
set Mod2output;
run;

proc print data=outfile.Mod2output;
run;
/***********************************************************************
*                                                                      *
*                        Model 3: Logistic LogLink POIdist, Star Class *
*                                                                      *
***********************************************************************/
/*used a class for impSTARS and LabelAppeal*/
proc genmod data=outfile2;
	class impSTARS LabelAppeal;
	model Target = 
				cVolatileAcidity
				cimpChlorides
				cimpFreeSulfurDioxide
				cimpTotalSulfurDioxide
				cimpSulphates
				cimpAlcohol
				LabelAppeal
				cAcidIndex
				impSTARS
				mSTARS / link=log dist=poi;
output out=outfile3 p=x_poi;
run;

proc means data=outfile3;
run;

/***********************************************************************
*                          Model 3: Score DataStep                     *
***********************************************************************/
/*the data step to deploy the model to out-of-sample data*/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let testfile = &LIB.wine_test;

data Mod3score;
set &testfile;

Target_flag = (Target > 0);
Target_Amt = Target -1;
if Target_flag = 0 then Target_Amt = .;

/*create imputed value variables*/
impResidualSugar = ResidualSugar;
impChlorides = Chlorides;
impFreeSulfurDioxide = FreeSulfurDioxide;
impTotalSulfurDioxide = TotalSulfurDioxide;
imppH = pH;
impSulphates = Sulphates;
impAlcohol = Alcohol;
impSTARS = STARS;

/*create imputed values, missing value, low cap, high cap flags*/
mResidualSugar = 0;
if missing(impResidualSugar) then do;
	impResidualSugar = 4.5;
	mResidualSugar = 1;
	end;
	
mChlorides = 0;
if missing(impChlorides) then do;
	impChlorides = 0.05;
	mChlorides = 1;
	end;
	
mFreeSulfurDioxide = 0;
if missing(impFreeSulfurDioxide) then do;
	impFreeSulfurDioxide = 30;
	mFreeSulfurDioxide = 1;
	end;
	
mTotalSulfurDioxide = 0;
if missing(impTotalSulfurDioxide) then do;
	impTotalSulfurDioxide = 122;
	mTotalSulfurDioxide = 1;
	end;

mpH = 0;
if missing(imppH) then do;
	imppH = 3.2;
	mpH = 1;
	end;
	
mSulphates = 0;
if missing(impSulphates) then do;
	impSulphates = 0.5;
	mSulphates = 1;
	end;
	
mAlcohol = 0;
if missing(impAlcohol) then do;
	impAlcohol = 10.4;
	mAlcohol = 1;
	end;
	
mSTARS = 0;
if missing(impSTARS) then do;
	impSTARS = 2;
	mSTARS = 1;
	end;

/*cap non-imputed variables*/
cFixedAcidity = FixedAcidity;
hcFixedAcidity=0;
lcFixedAcidity=0;
if  FixedAcidity <-10 then do;
	cFixedAcidity = -10 ;
	lcFixedAcidity=1;
	end;
if  FixedAcidity >24 then do;
	cFixedAcidity = 24 ;
	hcFixedAcidity=1;
	end;
	
cVolatileAcidity = VolatileAcidity;
hcVolatileAcidity=0;
lcVolatileAcidity=0;
if  VolatileAcidity <-1.8 then do;
	cVolatileAcidity = -1.8 ;
	lcVolatileAcidity=1;
	end;
if  VolatileAcidity >2.5 then do;
	cVolatileAcidity = 2.5 ;
	hcVolatileAcidity=1;
	end;
	
cCitricAcid = CitricAcid;
hcCitricAcid=0;
lcCitricAcid=0;
if  CitricAcid <-2.1 then do;
	cCitricAcid = -2.1;
	lcCitricAcid=1;
	end;
if  CitricAcid >2.6 then do;
	cCitricAcid = 2.6 ;
	hcCitricAcid=1;
	end;

cDensity = Density;
hcDensity=0;
lcDensity=0;
if  Density <0.9 then do;
	cDensity = 0.9;
	lcDensity=1;
	end;
if  Density >1.07 then do;
	cDensity = 1.07 ;
	hcDensity=1;
	end;

cAcidIndex = AcidIndex;
hcAcidIndex=0;
lcAcidIndex=0;
if  AcidIndex <6 then do;
	cAcidIndex = 6;
	lcAcidIndex=1;
	end;
if  AcidIndex >13 then do;
	cAcidIndex = 13 ;
	hcAcidIndex=1;
	end;

/*cap imputed variables*/
cimpResidualSugar = impResidualSugar;
hcResidualSugar=0;
lcResidualSugar=0;
if  impResidualSugar <-91 then do;
	cimpResidualSugar = -91 ;
	lcResidualSugar=1;
	end;
if  impResidualSugar >99 then do;
	cimpResidualSugar = 99 ;
	hcResidualSugar=1;
	end;

cimpChlorides= impChlorides;
hcChlorides=0;
lcChlorides=0;
if  impChlorides <-1 then do;
	cimpChlorides = -1 ;
	lcChlorides=1;
	end;
if  impChlorides >0.95 then do;
	cimpChlorides = 0.95 ;
	hcChlorides=1;
	end;

cimpFreeSulfurDioxide = impFreeSulfurDioxide;
hcFreeSulfurDioxide=0;
lcFreeSulfurDioxide=0;
if  impFreeSulfurDioxide <-388 then do;
	cimpFreeSulfurDioxide = -388 ;
	lcFreeSulfurDioxide=1;
	end;
if  impFreeSulfurDioxide >469 then do;
	cimpFreeSulfurDioxide = 469 ;
	hcFreeSulfurDioxide=1;
	end;

cimpTotalSulfurDioxide = impTotalSulfurDioxide;
hcTotalSulfurDioxide=0;
lcTotalSulfurDioxide=0;
if  impTotalSulfurDioxide <-531 then do;
	cimpTotalSulfurDioxide = -531 ;
	lcTotalSulfurDioxide=1;
	end;
if  impTotalSulfurDioxide >767 then do;
	cimpTotalSulfurDioxide = 767;
	hcTotalSulfurDioxide=1;
	end;

cimppH = imppH;
hcpH=0;
lcpH=0;
if  imppH <1.3 then do;
	cimppH = 1.3 ;
	lcpH=1;
	end;
if  imppH >5.1 then do;
	cimppH = 5.1;
	hcpH=1;
	end;

cimpSulphates = impSulphates;
hcSulphates=0;
lcSulphates=0;
if  impSulphates <-2.1 then do;
	cimpSulphates = -2.1 ;
	lcSulphates=1;
	end;
if  impSulphates >3.1 then do;
	cimpSulphates = 3.1;
	hcSulphates=1;
	end;

cimpAlcohol = impAlcohol;
hcAlcohol=0;
lcAlcohol=0;
if  impAlcohol <0.1 then do;
	cimpAlcohol = 0.1 ;
	lcAlcohol=1;
	end;
if  impAlcohol >20 then do;
	cimpAlcohol = 20;
	hcAlcohol=1;
	end;

P_Genmod_POI = 
2.4330
+ cVolatileAcidity	 		*	-0.0320
+ cimpChlorides	 			*	-0.0378
+ cimpFreeSulfurDioxide	 	*	0.0001
+ cimpTotalSulfurDioxide 	*	0.0001
+ cimpSulphates	 			*	-0.0129
+ cimpAlcohol	 			*	0.0041
+ (LabelAppeal	in("-2"))	*	-0.6960
+ (LabelAppeal	in("-1"))	*	-0.4598
+ (LabelAppeal	in("0"))	*	-0.2695
+ (LabelAppeal	in("1"))	*	-0.1367
+ cAcidIndex	 			*	-0.0825
+ (impSTARS	in("1"))		*	-0.5587
+ (impSTARS	in("2"))		*	-0.2389
+ (impSTARS	in("3"))		*	-0.1203
+ mSTARS	 				*	-1.0861
;

P_Genmod_POI = exp(P_Genmod_POI);
run;

proc print data=Mod3score (obs=10);
run;

proc means data=Mod3score min mean max n;
run;

data Mod3output;
set Mod3score;
keep index;
keep target;
keep P_Genmod_POI;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Mod3output;
set Mod3output;
run;

proc means data=Mod3score min mean max;
run;

proc print data=outfile.Mod3output;
run;
/***********************************************************************
*                                                                      *
*                        Model 4: Hurdle Model                         *
*                                                                      *
***********************************************************************/
/*Hurdle Model*/
/****************HURDLE MODEL FIRST PART****************/
/*logistic regression with selected vars from stepwise above
Predicts probability that they will buy at least one case of wine*/

proc logistic data= outfile3 PLOTS(MAXPOINTS=NONE) plot (only)=(roc(ID=prob));
	class 	impSTARS 
			LabelAppeal
			hcFixedAcidity
			lcFixedAcidity
			hcVolatileAcidity
			lcVolatileAcidity
			hcCitricAcid
			lcCitricAcid					
			mResidualSugar
			hcResidualSugar
			lcResidualSugar
			mChlorides
			hcChlorides
			lcChlorides
			mFreeSulfurDioxide
			hcFreeSulfurDioxide
			lcFreeSulfurDioxide
			mTotalSulfurDioxide
			hcTotalSulfurDioxide
			lcTotalSulfurDioxide
			hcDensity
			lcDensity
			mpH
			hcpH
			lcpH
			mSulphates
			hcSulphates
			lcSulphates
			mAlcohol
			hcAlcohol
			lcAlcohol
			hcAcidIndex
			lcAcidIndex /param=reference;
				model Target_flag(ref="0") =
								cFixedAcidity
								hcFixedAcidity
								lcFixedAcidity
								
								cVolatileAcidity
								hcVolatileAcidity
								lcVolatileAcidity
								
								cCitricAcid
								hcCitricAcid
								lcCitricAcid
								
								mResidualSugar
								cimpResidualSugar
								hcResidualSugar
								lcResidualSugar
								
								mChlorides
								cimpChlorides
								hcChlorides
								lcChlorides
								
								mFreeSulfurDioxide
								cimpFreeSulfurDioxide
								hcFreeSulfurDioxide
								lcFreeSulfurDioxide
								
								mTotalSulfurDioxide
								cimpTotalSulfurDioxide
								hcTotalSulfurDioxide
								lcTotalSulfurDioxide
								
								cDensity
								hcDensity
								lcDensity
								
								mpH
								cimppH
								hcpH
								lcpH
								
								mSulphates
								cimpSulphates
								hcSulphates
								lcSulphates
								
								mAlcohol
								cimpAlcohol
								hcAlcohol
								lcAlcohol
								
								LabelAppeal
								
								cAcidIndex
								hcAcidIndex
								lcAcidIndex
								
								impSTARS
								mSTARS / selection=stepwise roceps=0.1 ;
run;

/*using the results of the above logistic regression*/
proc logistic data= outfile3 PLOTS(MAXPOINTS=NONE) plot (only)=(roc(ID=prob));
	class 	
			hcpH/param=reference;
				model Target_flag(ref="0") =
								
								cVolatileAcidity
								cimpFreeSulfurDioxide
								cimpTotalSulfurDioxide
								cimppH
								hcpH
								cimpSulphates
								cimpAlcohol
								cAcidIndex
								impSTARS
								mSTARS / roceps=0.1 ;
output out=outfile4 p=x_Logit_Hurdle;
run;

proc means data=outfile4;
run;

/****************HURDLE MODEL SECOND PART****************/
/*proc genmod to predict target amount: the amount that will be bought
when wine is actually purchased*/

/*proc reg attempt: how much wine will be bought if wine is bought*/

/*proc genmod attempt: how much wine will be bought if wine is bought*/
proc genmod data=outfile4;
model Target_amt = 
					cimpAlcohol
					LabelAppeal
					cAcidIndex
					impSTARS
					mSTARS
					cAcidIndex / link=log dist=poi;
output out=outfile4_1 p=x_Genmod_Hurdle;
run;

proc means data=outfile4_1;
run;


/***********************************************************************
*                          Model 4: Score DataStep                     *
***********************************************************************/
/*the data step to deploy the model to out-of-sample data*/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let testfile = &LIB.wine_test;

data Mod4score;
set &testfile;

Target_flag = (Target > 0);
Target_Amt = Target -1;
if Target_flag = 0 then Target_Amt = .;

/*create imputed value variables*/
impResidualSugar = ResidualSugar;
impChlorides = Chlorides;
impFreeSulfurDioxide = FreeSulfurDioxide;
impTotalSulfurDioxide = TotalSulfurDioxide;
imppH = pH;
impSulphates = Sulphates;
impAlcohol = Alcohol;
impSTARS = STARS;

/*create imputed values, missing value, low cap, high cap flags*/
mResidualSugar = 0;
if missing(impResidualSugar) then do;
	impResidualSugar = 4.5;
	mResidualSugar = 1;
	end;
	
mChlorides = 0;
if missing(impChlorides) then do;
	impChlorides = 0.05;
	mChlorides = 1;
	end;
	
mFreeSulfurDioxide = 0;
if missing(impFreeSulfurDioxide) then do;
	impFreeSulfurDioxide = 30;
	mFreeSulfurDioxide = 1;
	end;
	
mTotalSulfurDioxide = 0;
if missing(impTotalSulfurDioxide) then do;
	impTotalSulfurDioxide = 122;
	mTotalSulfurDioxide = 1;
	end;

mpH = 0;
if missing(imppH) then do;
	imppH = 3.2;
	mpH = 1;
	end;
	
mSulphates = 0;
if missing(impSulphates) then do;
	impSulphates = 0.5;
	mSulphates = 1;
	end;
	
mAlcohol = 0;
if missing(impAlcohol) then do;
	impAlcohol = 10.4;
	mAlcohol = 1;
	end;
	
mSTARS = 0;
if missing(impSTARS) then do;
	impSTARS = 2;
	mSTARS = 1;
	end;

/*cap non-imputed variables*/
cFixedAcidity = FixedAcidity;
hcFixedAcidity=0;
lcFixedAcidity=0;
if  FixedAcidity <-10 then do;
	cFixedAcidity = -10 ;
	lcFixedAcidity=1;
	end;
if  FixedAcidity >24 then do;
	cFixedAcidity = 24 ;
	hcFixedAcidity=1;
	end;
	
cVolatileAcidity = VolatileAcidity;
hcVolatileAcidity=0;
lcVolatileAcidity=0;
if  VolatileAcidity <-1.8 then do;
	cVolatileAcidity = -1.8 ;
	lcVolatileAcidity=1;
	end;
if  VolatileAcidity >2.5 then do;
	cVolatileAcidity = 2.5 ;
	hcVolatileAcidity=1;
	end;
	
cCitricAcid = CitricAcid;
hcCitricAcid=0;
lcCitricAcid=0;
if  CitricAcid <-2.1 then do;
	cCitricAcid = -2.1;
	lcCitricAcid=1;
	end;
if  CitricAcid >2.6 then do;
	cCitricAcid = 2.6 ;
	hcCitricAcid=1;
	end;

cDensity = Density;
hcDensity=0;
lcDensity=0;
if  Density <0.9 then do;
	cDensity = 0.9;
	lcDensity=1;
	end;
if  Density >1.07 then do;
	cDensity = 1.07 ;
	hcDensity=1;
	end;

cAcidIndex = AcidIndex;
hcAcidIndex=0;
lcAcidIndex=0;
if  AcidIndex <6 then do;
	cAcidIndex = 6;
	lcAcidIndex=1;
	end;
if  AcidIndex >13 then do;
	cAcidIndex = 13 ;
	hcAcidIndex=1;
	end;

/*cap imputed variables*/
cimpResidualSugar = impResidualSugar;
hcResidualSugar=0;
lcResidualSugar=0;
if  impResidualSugar <-91 then do;
	cimpResidualSugar = -91 ;
	lcResidualSugar=1;
	end;
if  impResidualSugar >99 then do;
	cimpResidualSugar = 99 ;
	hcResidualSugar=1;
	end;

cimpChlorides= impChlorides;
hcChlorides=0;
lcChlorides=0;
if  impChlorides <-1 then do;
	cimpChlorides = -1 ;
	lcChlorides=1;
	end;
if  impChlorides >0.95 then do;
	cimpChlorides = 0.95 ;
	hcChlorides=1;
	end;

cimpFreeSulfurDioxide = impFreeSulfurDioxide;
hcFreeSulfurDioxide=0;
lcFreeSulfurDioxide=0;
if  impFreeSulfurDioxide <-388 then do;
	cimpFreeSulfurDioxide = -388 ;
	lcFreeSulfurDioxide=1;
	end;
if  impFreeSulfurDioxide >469 then do;
	cimpFreeSulfurDioxide = 469 ;
	hcFreeSulfurDioxide=1;
	end;

cimpTotalSulfurDioxide = impTotalSulfurDioxide;
hcTotalSulfurDioxide=0;
lcTotalSulfurDioxide=0;
if  impTotalSulfurDioxide <-531 then do;
	cimpTotalSulfurDioxide = -531 ;
	lcTotalSulfurDioxide=1;
	end;
if  impTotalSulfurDioxide >767 then do;
	cimpTotalSulfurDioxide = 767;
	hcTotalSulfurDioxide=1;
	end;

cimppH = imppH;
hcpH=0;
lcpH=0;
if  imppH <1.3 then do;
	cimppH = 1.3 ;
	lcpH=1;
	end;
if  imppH >5.1 then do;
	cimppH = 5.1;
	hcpH=1;
	end;

cimpSulphates = impSulphates;
hcSulphates=0;
lcSulphates=0;
if  impSulphates <-2.1 then do;
	cimpSulphates = -2.1 ;
	lcSulphates=1;
	end;
if  impSulphates >3.1 then do;
	cimpSulphates = 3.1;
	hcSulphates=1;
	end;

cimpAlcohol = impAlcohol;
hcAlcohol=0;
lcAlcohol=0;
if  impAlcohol <0.1 then do;
	cimpAlcohol = 0.1 ;
	lcAlcohol=1;
	end;
if  impAlcohol >20 then do;
	cimpAlcohol = 20;
	hcAlcohol=1;
	end;
/*


/*logistic hurdle (first part: prob that wine will be bought)*/
P_Logit_Hurdle=
3.8899
+ cVolatileAcidity	 		*	-0.1907
+ cimpFreeSulfurDioxide		*	0.000586
+ cimpTotalSulfurDioxide	*	0.000887
+ cimppH	 				*	-0.2247
+ (hcpH	in("0"))			*	-0.6555
+ cimpSulphates	 			*	-0.1030
+ cimpAlcohol	 			*	-0.0189
+ cAcidIndex	 			*	-0.4175
+ impSTARS	 				*	2.3932
+ mSTARS	 				*	-4.1930
;
P_Logit_Hurdle = exp(P_Logit_Hurdle) / (1+exp(P_Logit_Hurdle));

/*genmod hurdle (second part: predict how much will be bought)*/

P_Genmod_Hurdle=
0.8411
+ cimpAlcohol	*	0.0095
+ LabelAppeal	*	0.2958
+ cAcidIndex	*	-0.0226
+ impSTARS	*	0.1209
+ mSTARS	*	-0.2087
;

P_Genmod_Hurdle = exp(P_Genmod_Hurdle)+1;

P_Target_Hurdle = P_Logit_Hurdle * P_Genmod_Hurdle;

proc means data=Mod4score min mean max n;
run;

data Mod4output;
set Mod4score;
keep index;
keep target;
keep P_Target_HURDLE;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Mod4output;
set Mod4output;
run;

proc means data=Mod4score min mean max;
run;

/***********************************************************************
*                                                                      *
*               Model 5: Hurdle Model Decision Tree Imputation         *
*                                                                      *
***********************************************************************/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

%let fixedfiletree = fixedfiletree;
%let varlist = varlist;
%let Tempfiletree = Tempfiletree;
libname &Name. "&Path.";

%let Infiletree = &LIB.wine;

proc contents data=&Infiletree.;
proc print data=&Infile (obs=10);

data &Tempfiletree.;
set &Infiletree.;

Target_flag = (Target > 0); /*puts a 1 if >0, else puts a 0*/
Target_Amt = Target -1;  /*we subtract 1 which will be added back later*/
if Target_flag = 0 then Target_Amt = .; /*puts blank when target_nozero =0*/

*------------------------------------------------------------*;
* EM SCORE CODE;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Input Data Source;
* TYPE: SAMPLE;
* NODE: Ids;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Metadata Node;
* TYPE: UTILITY;
* NODE: Meta;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Partition Class;
* TYPE: SAMPLE;
* NODE: Part;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Imputation;
* TYPE: MODIFY;
* NODE: Impt;
*------------------------------------------------------------*;
*;
* TREE IMPUTATION;
*;
*;
* IMPUTE VARIABLE: Alcohol;
*;
length IMP_Alcohol 8;
label IMP_Alcohol = 'Imputed Alcohol';
IMP_Alcohol = Alcohol;
if missing(IMP_Alcohol) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Alcohol = 'Predicted: Alcohol';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(Density ) AND
Density < 0.994285 THEN DO;
IF NOT MISSING(Density ) AND
Density < 0.98661 THEN DO;
IF NOT MISSING(Chlorides ) AND
0.0425 <= Chlorides THEN DO;
P_Alcohol = 10.0511498178506;
END;
ELSE DO;
P_Alcohol = 10.7160265049416;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
0.99259 <= Density THEN DO;
P_Alcohol = 10.6303582853486;
END;
ELSE DO;
P_Alcohol = 11.5116435541859;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
1.001185 <= Density THEN DO;
IF NOT MISSING(ResidualSugar ) AND
5.95 <= ResidualSugar THEN DO;
IF NOT MISSING(FixedAcidity ) AND
FixedAcidity < -2.95 THEN DO;
P_Alcohol = 11.8736111111111;
END;
ELSE DO;
P_Alcohol = 9.95872245467224;
END;
END;
ELSE DO;
P_Alcohol = 10.7597821859198;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
26.5 <= FreeSulfurDioxide THEN DO;
P_Alcohol = 9.67133529990166;
END;
ELSE DO;
P_Alcohol = 10.2433507739263;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Alcohol;
*;
IMP_Alcohol = P_ALCOHOL;
END;
*;
* IMPUTE VARIABLE: Chlorides;
*;
length IMP_Chlorides 8;
label IMP_Chlorides = 'Imputed Chlorides';
IMP_Chlorides = Chlorides;
if missing(IMP_Chlorides) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Chlorides = 'Predicted: Chlorides';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
P_Chlorides = 0.05482248910092;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Chlorides;
*;
IMP_Chlorides = P_CHLORIDES;
END;
*;
* IMPUTE VARIABLE: FreeSulfurDioxide;
*;
length IMP_FreeSulfurDioxide 8;
label IMP_FreeSulfurDioxide = 'Imputed FreeSulfurDioxide';
IMP_FreeSulfurDioxide = FreeSulfurDioxide;
if missing(IMP_FreeSulfurDioxide) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_FreeSulfurDioxide = 'Predicted: FreeSulfurDioxide';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
9.5 <= AcidIndex THEN DO;
P_FreeSulfurDioxide = 9.2664054848188;
END;
ELSE DO;
P_FreeSulfurDioxide = 32.8256493214703;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: FreeSulfurDioxide;
*;
IMP_FreeSulfurDioxide = P_FREESULFURDIOXIDE;
END;
*;
* IMPUTE VARIABLE: ResidualSugar;
*;
length IMP_ResidualSugar 8;
label IMP_ResidualSugar = 'Imputed ResidualSugar';
IMP_ResidualSugar = ResidualSugar;
if missing(IMP_ResidualSugar) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_ResidualSugar = 'Predicted: ResidualSugar';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(TotalSulfurDioxide ) AND
158.5 <= TotalSulfurDioxide THEN DO;
P_ResidualSugar = 7.64509173218955;
END;
ELSE DO;
P_ResidualSugar = 4.24809571535955;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: ResidualSugar;
*;
IMP_ResidualSugar = P_RESIDUALSUGAR;
END;
*;
* IMPUTE VARIABLE: STARS;
*;
length IMP_STARS 8;
label IMP_STARS = 'Imputed STARS';
IMP_STARS = STARS;
if missing(IMP_STARS) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH I_STARS $ 12;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_STARS1 = 'Predicted: STARS=1';
label P_STARS2 = 'Predicted: STARS=2';
label P_STARS3 = 'Predicted: STARS=3';
label P_STARS4 = 'Predicted: STARS=4';
label Q_STARS1 = 'Unadjusted P: STARS=1';
label Q_STARS2 = 'Unadjusted P: STARS=2';
label Q_STARS3 = 'Unadjusted P: STARS=3';
label Q_STARS4 = 'Unadjusted P: STARS=4';
label I_STARS = 'Into: STARS';
label U_STARS = 'Unnormalized Into: STARS';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_12 $ 12;
DROP _ARBFMT_12;
_ARBFMT_12 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('-2' ,'-1' ) THEN DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('-2' ) THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 5.85 THEN DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < 0.375 THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 4.3 THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.4;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.4;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 1;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0;
Q_STARS2 = 1;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Chlorides ) AND
0.0495 <= Chlorides THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.2;
P_STARS3 = 0.4;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.2;
Q_STARS3 = 0.4;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 1;
P_STARS2 = 0;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 1;
Q_STARS2 = 0;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
-0.135 <= Sulphates THEN DO;
IF NOT MISSING(pH ) AND
pH < 2.58 THEN DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
35.5 <= FreeSulfurDioxide THEN DO;
P_STARS1 = 0.78571428571428;
P_STARS2 = 0.21428571428571;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.78571428571428;
Q_STARS2 = 0.21428571428571;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.30434782608695;
P_STARS2 = 0.47826086956521;
P_STARS3 = 0.21739130434782;
P_STARS4 = 0;
Q_STARS1 = 0.30434782608695;
Q_STARS2 = 0.47826086956521;
Q_STARS3 = 0.21739130434782;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < 0.215 THEN DO;
P_STARS1 = 0.3;
P_STARS2 = 0.5;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.3;
Q_STARS2 = 0.5;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.75;
P_STARS2 = 0.23076923076923;
P_STARS3 = 0.01923076923076;
P_STARS4 = 0;
Q_STARS1 = 0.75;
Q_STARS2 = 0.23076923076923;
Q_STARS3 = 0.01923076923076;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Chlorides ) AND
Chlorides < 0.0325 THEN DO;
IF NOT MISSING(Sulphates ) THEN DO;
P_STARS1 = 0.92307692307692;
P_STARS2 = 0;
P_STARS3 = 0.07692307692307;
P_STARS4 = 0;
Q_STARS1 = 0.92307692307692;
Q_STARS2 = 0;
Q_STARS3 = 0.07692307692307;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.25;
P_STARS2 = 0.125;
P_STARS3 = 0.625;
P_STARS4 = 0;
Q_STARS1 = 0.25;
Q_STARS2 = 0.125;
Q_STARS3 = 0.625;
Q_STARS4 = 0;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 8.9 THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.4;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.4;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.925;
P_STARS2 = 0.05;
P_STARS3 = 0.025;
P_STARS4 = 0;
Q_STARS1 = 0.925;
Q_STARS2 = 0.05;
Q_STARS3 = 0.025;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
Density < 0.99167 THEN DO;
IF NOT MISSING(Sulphates ) AND
0.035 <= Sulphates THEN DO;
IF NOT MISSING(CitricAcid ) AND
CitricAcid < -0.885 THEN DO;
P_STARS1 = 0.18518518518518;
P_STARS2 = 0.66666666666666;
P_STARS3 = 0.14814814814814;
P_STARS4 = 0;
Q_STARS1 = 0.18518518518518;
Q_STARS2 = 0.66666666666666;
Q_STARS3 = 0.14814814814814;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.43181818181818;
P_STARS2 = 0.40530303030303;
P_STARS3 = 0.14393939393939;
P_STARS4 = 0.01893939393939;
Q_STARS1 = 0.43181818181818;
Q_STARS2 = 0.40530303030303;
Q_STARS3 = 0.14393939393939;
Q_STARS4 = 0.01893939393939;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FixedAcidity ) AND
16.7 <= FixedAcidity THEN DO;
P_STARS1 = 0.875;
P_STARS2 = 0.125;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.875;
Q_STARS2 = 0.125;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < -1.865 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.8;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0;
Q_STARS2 = 0.8;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.49019607843137;
P_STARS2 = 0.27941176470588;
P_STARS3 = 0.22058823529411;
P_STARS4 = 0.00980392156862;
Q_STARS1 = 0.49019607843137;
Q_STARS2 = 0.27941176470588;
Q_STARS3 = 0.22058823529411;
Q_STARS4 = 0.00980392156862;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
2.1775 <= VolatileAcidity THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 10.85 THEN DO;
P_STARS1 = 0.33333333333333;
P_STARS2 = 0.66666666666666;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.33333333333333;
Q_STARS2 = 0.66666666666666;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < -1.19999999999999 THEN DO;
P_STARS1 = 0.2;
P_STARS2 = 0.6;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.2;
Q_STARS2 = 0.6;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 0;
P_STARS3 = 0.85714285714285;
P_STARS4 = 0.14285714285714;
Q_STARS1 = 0;
Q_STARS2 = 0;
Q_STARS3 = 0.85714285714285;
Q_STARS4 = 0.14285714285714;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
1.745 <= VolatileAcidity THEN DO;
IF NOT MISSING(Alcohol ) AND
13.9 <= Alcohol THEN DO;
P_STARS1 = 0.33333333333333;
P_STARS2 = 0.33333333333333;
P_STARS3 = 0.33333333333333;
P_STARS4 = 0;
Q_STARS1 = 0.33333333333333;
Q_STARS2 = 0.33333333333333;
Q_STARS3 = 0.33333333333333;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.89473684210526;
P_STARS2 = 0.05263157894736;
P_STARS3 = 0.05263157894736;
P_STARS4 = 0;
Q_STARS1 = 0.89473684210526;
Q_STARS2 = 0.05263157894736;
Q_STARS3 = 0.05263157894736;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FixedAcidity ) AND
26.45 <= FixedAcidity THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.71428571428571;
P_STARS3 = 0.14285714285714;
P_STARS4 = 0.14285714285714;
Q_STARS1 = 0;
Q_STARS2 = 0.71428571428571;
Q_STARS3 = 0.14285714285714;
Q_STARS4 = 0.14285714285714;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.49382716049382;
P_STARS2 = 0.40123456790123;
P_STARS3 = 0.09336419753086;
P_STARS4 = 0.01157407407407;
Q_STARS1 = 0.49382716049382;
Q_STARS2 = 0.40123456790123;
Q_STARS3 = 0.09336419753086;
Q_STARS4 = 0.01157407407407;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
END;
END;
ELSE DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('1' ,'2' ) THEN DO;
IF NOT MISSING(Alcohol ) AND
11.025 <= Alcohol THEN DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
-80 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.27272727272727;
P_STARS2 = 0.40495867768595;
P_STARS3 = 0.23140495867768;
P_STARS4 = 0.09090909090909;
Q_STARS1 = 0.27272727272727;
Q_STARS2 = 0.40495867768595;
Q_STARS3 = 0.23140495867768;
Q_STARS4 = 0.09090909090909;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
VolatileAcidity < -0.625 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.8;
P_STARS3 = 0;
P_STARS4 = 0.2;
Q_STARS1 = 0;
Q_STARS2 = 0.8;
Q_STARS3 = 0;
Q_STARS4 = 0.2;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.1578947368421;
P_STARS2 = 0.05263157894736;
P_STARS3 = 0.57894736842105;
P_STARS4 = 0.21052631578947;
Q_STARS1 = 0.1578947368421;
Q_STARS2 = 0.05263157894736;
Q_STARS3 = 0.57894736842105;
Q_STARS4 = 0.21052631578947;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
1.47 <= VolatileAcidity THEN DO;
IF NOT MISSING(Sulphates ) AND
1.57 <= Sulphates THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.16666666666666;
P_STARS3 = 0.16666666666666;
P_STARS4 = 0.66666666666666;
Q_STARS1 = 0;
Q_STARS2 = 0.16666666666666;
Q_STARS3 = 0.16666666666666;
Q_STARS4 = 0.66666666666666;
I_STARS = '4';
U_STARS = 4;
END;
ELSE DO;
P_STARS1 = 0.3015873015873;
P_STARS2 = 0.31746031746031;
P_STARS3 = 0.28571428571428;
P_STARS4 = 0.09523809523809;
Q_STARS1 = 0.3015873015873;
Q_STARS2 = 0.31746031746031;
Q_STARS3 = 0.28571428571428;
Q_STARS4 = 0.09523809523809;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
2.38 <= Sulphates THEN DO;
P_STARS1 = 0.1;
P_STARS2 = 0.9;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.1;
Q_STARS2 = 0.9;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.10444177671068;
P_STARS2 = 0.28811524609843;
P_STARS3 = 0.41776710684273;
P_STARS4 = 0.18967587034813;
Q_STARS1 = 0.10444177671068;
Q_STARS2 = 0.28811524609843;
Q_STARS3 = 0.41776710684273;
Q_STARS4 = 0.18967587034813;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
END;
ELSE DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('2' ) THEN DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(VolatileAcidity ) AND
VolatileAcidity < 0.175 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.3;
P_STARS3 = 0.3;
P_STARS4 = 0.4;
Q_STARS1 = 0;
Q_STARS2 = 0.3;
Q_STARS3 = 0.3;
Q_STARS4 = 0.4;
I_STARS = '4';
U_STARS = 4;
END;
ELSE DO;
P_STARS1 = 0.41666666666666;
P_STARS2 = 0.25;
P_STARS3 = 0.16666666666666;
P_STARS4 = 0.16666666666666;
Q_STARS1 = 0.41666666666666;
Q_STARS2 = 0.25;
Q_STARS3 = 0.16666666666666;
Q_STARS4 = 0.16666666666666;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
P_STARS1 = 0.11475409836065;
P_STARS2 = 0.27322404371584;
P_STARS3 = 0.41530054644808;
P_STARS4 = 0.1967213114754;
Q_STARS1 = 0.11475409836065;
Q_STARS2 = 0.27322404371584;
Q_STARS3 = 0.41530054644808;
Q_STARS4 = 0.1967213114754;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
P_STARS1 = 0.21171770972037;
P_STARS2 = 0.39680426098535;
P_STARS3 = 0.28428761651131;
P_STARS4 = 0.10719041278295;
Q_STARS1 = 0.21171770972037;
Q_STARS2 = 0.39680426098535;
Q_STARS3 = 0.28428761651131;
Q_STARS4 = 0.10719041278295;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(Chlorides ) AND
0.0555 <= Chlorides THEN DO;
IF NOT MISSING(Density ) AND
1.04897 <= Density THEN DO;
P_STARS1 = 0.16666666666666;
P_STARS2 = 0;
P_STARS3 = 0.66666666666666;
P_STARS4 = 0.16666666666666;
Q_STARS1 = 0.16666666666666;
Q_STARS2 = 0;
Q_STARS3 = 0.66666666666666;
Q_STARS4 = 0.16666666666666;
I_STARS = '3';
U_STARS = 3;
END;
ELSE DO;
P_STARS1 = 0.49822064056939;
P_STARS2 = 0.31672597864768;
P_STARS3 = 0.16370106761565;
P_STARS4 = 0.02135231316725;
Q_STARS1 = 0.49822064056939;
Q_STARS2 = 0.31672597864768;
Q_STARS3 = 0.16370106761565;
Q_STARS4 = 0.02135231316725;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
4.5 <= FreeSulfurDioxide THEN DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
304 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.64516129032258;
P_STARS2 = 0.29032258064516;
P_STARS3 = 0;
P_STARS4 = 0.06451612903225;
Q_STARS1 = 0.64516129032258;
Q_STARS2 = 0.29032258064516;
Q_STARS3 = 0;
Q_STARS4 = 0.06451612903225;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.35833333333333;
P_STARS2 = 0.3875;
P_STARS3 = 0.2125;
P_STARS4 = 0.04166666666666;
Q_STARS1 = 0.35833333333333;
Q_STARS2 = 0.3875;
Q_STARS3 = 0.2125;
Q_STARS4 = 0.04166666666666;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
P_STARS1 = 0.23809523809523;
P_STARS2 = 0.4;
P_STARS3 = 0.32380952380952;
P_STARS4 = 0.03809523809523;
Q_STARS1 = 0.23809523809523;
Q_STARS2 = 0.4;
Q_STARS3 = 0.32380952380952;
Q_STARS4 = 0.03809523809523;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 10.95 THEN DO;
IF NOT MISSING(Sulphates ) AND
2.185 <= Sulphates THEN DO;
IF NOT MISSING(Chlorides ) AND
Chlorides < 0.5165 THEN DO;
P_STARS1 = 0.18;
P_STARS2 = 0.64;
P_STARS3 = 0.18;
P_STARS4 = 0;
Q_STARS1 = 0.18;
Q_STARS2 = 0.64;
Q_STARS3 = 0.18;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 0.41666666666666;
P_STARS3 = 0.5;
P_STARS4 = 0.08333333333333;
Q_STARS1 = 0;
Q_STARS2 = 0.41666666666666;
Q_STARS3 = 0.5;
Q_STARS4 = 0.08333333333333;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
525 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.19791666666666;
P_STARS2 = 0.54166666666666;
P_STARS3 = 0.26041666666666;
P_STARS4 = 0;
Q_STARS1 = 0.19791666666666;
Q_STARS2 = 0.54166666666666;
Q_STARS3 = 0.26041666666666;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.33980582524271;
P_STARS2 = 0.40776699029126;
P_STARS3 = 0.21245002855511;
P_STARS4 = 0.0399771559109;
Q_STARS1 = 0.33980582524271;
Q_STARS2 = 0.40776699029126;
Q_STARS3 = 0.21245002855511;
Q_STARS4 = 0.0399771559109;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
P_STARS1 = 0.26866585067319;
P_STARS2 = 0.38739290085679;
P_STARS3 = 0.28396572827417;
P_STARS4 = 0.05997552019583;
Q_STARS1 = 0.26866585067319;
Q_STARS2 = 0.38739290085679;
Q_STARS3 = 0.28396572827417;
Q_STARS4 = 0.05997552019583;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: STARS;
*;
length _format200 $200;
drop _format200;
_format200 = strip(I_STARS);
if _format200="4" then IMP_STARS = 4;
else
if _format200="3" then IMP_STARS = 3;
else
if _format200="2" then IMP_STARS = 2;
else
if _format200="1" then IMP_STARS = 1;
END;
*;
* IMPUTE VARIABLE: Sulphates;
*;
length IMP_Sulphates 8;
label IMP_Sulphates = 'Imputed Sulphates';
IMP_Sulphates = Sulphates;
if missing(IMP_Sulphates) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Sulphates = 'Predicted: Sulphates';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
10.5 <= AcidIndex THEN DO;
P_Sulphates = 0.70503157894736;
END;
ELSE DO;
P_Sulphates = 0.51950495049504;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Sulphates;
*;
IMP_Sulphates = P_SULPHATES;
END;
*;
* IMPUTE VARIABLE: TotalSulfurDioxide;
*;
length IMP_TotalSulfurDioxide 8;
label IMP_TotalSulfurDioxide = 'Imputed TotalSulfurDioxide';
IMP_TotalSulfurDioxide = TotalSulfurDioxide;
if missing(IMP_TotalSulfurDioxide) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_TotalSulfurDioxide = 'Predicted: TotalSulfurDioxide';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_12 $ 12;
DROP _ARBFMT_12;
_ARBFMT_12 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
_ARBFMT_12 = PUT( STARS , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('1' ,'2' ) THEN DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < 6.95 THEN DO;
P_TotalSulfurDioxide = 88.7770700636942;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 7.45 THEN DO;
P_TotalSulfurDioxide = 253.851351351351;
END;
ELSE DO;
P_TotalSulfurDioxide = 129.805486284289;
END;
END;
END;
ELSE DO;
P_TotalSulfurDioxide = 75.8012568735271;
END;
END;
ELSE DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < 5.75 THEN DO;
IF NOT MISSING(VolatileAcidity ) AND
1.765 <= VolatileAcidity THEN DO;
P_TotalSulfurDioxide = 41.5602409638554;
END;
ELSE DO;
P_TotalSulfurDioxide = 116.359597652975;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
FreeSulfurDioxide < 36.5 THEN DO;
P_TotalSulfurDioxide = 125.195661512027;
END;
ELSE DO;
P_TotalSulfurDioxide = 156.011736139214;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: TotalSulfurDioxide;
*;
IMP_TotalSulfurDioxide = P_TOTALSULFURDIOXIDE;
END;
*;
* IMPUTE VARIABLE: pH;
*;
length IMP_pH 8;
label IMP_pH = 'Imputed pH';
IMP_pH = pH;
if missing(IMP_pH) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_pH = 'Predicted: pH';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
AcidIndex < 7.5 THEN DO;
IF NOT MISSING(AcidIndex ) AND
AcidIndex < 6.5 THEN DO;
P_pH = 3.31947154471544;
END;
ELSE DO;
P_pH = 3.22725755334882;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
0.4125 <= VolatileAcidity THEN DO;
P_pH = 3.21901160464185;
END;
ELSE DO;
P_pH = 3.14187912646013;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: pH;
*;
IMP_pH = P_PH;
END;
*;
* Drop prediction variables since they are for INPUTS not TARGETS;
* Replace _NODE_ by _XODE_ so it can be safely dropped;
*;
drop
P_Alcohol
P_Chlorides
P_FreeSulfurDioxide
P_ResidualSugar
P_STARS4
P_STARS3
P_STARS2
P_STARS1
I_STARS
U_STARS
Q_STARS4
Q_STARS3
Q_STARS2
Q_STARS1
P_Sulphates
P_TotalSulfurDioxide
P_pH
;
*;
*INDICATOR VARIABLES;
*;
label M_Alcohol = "Imputation Indicator for Alcohol";
if missing(Alcohol) then M_Alcohol = 1;
else M_Alcohol= 0;
label M_Chlorides = "Imputation Indicator for Chlorides";
if missing(Chlorides) then M_Chlorides = 1;
else M_Chlorides= 0;
label M_FreeSulfurDioxide = "Imputation Indicator for FreeSulfurDioxide";
if missing(FreeSulfurDioxide) then M_FreeSulfurDioxide = 1;
else M_FreeSulfurDioxide= 0;
label M_ResidualSugar = "Imputation Indicator for ResidualSugar";
if missing(ResidualSugar) then M_ResidualSugar = 1;
else M_ResidualSugar= 0;
label M_STARS = "Imputation Indicator for STARS";
if missing(STARS) then M_STARS = 1;
else M_STARS= 0;
label M_Sulphates = "Imputation Indicator for Sulphates";
if missing(Sulphates) then M_Sulphates = 1;
else M_Sulphates= 0;
label M_TotalSulfurDioxide = "Imputation Indicator for TotalSulfurDioxide";
if missing(TotalSulfurDioxide) then M_TotalSulfurDioxide = 1;
else M_TotalSulfurDioxide= 0;
label M_pH = "Imputation Indicator for pH";
if missing(pH) then M_pH = 1;
else M_pH= 0;
*------------------------------------------------------------*;
* TOOL: Transform;
* TYPE: MODIFY;
* NODE: Trans;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* Computed Code;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TRANSFORM: AcidIndex , (AcidIndex + 1)**2;
*------------------------------------------------------------*;
label SQR_AcidIndex = 'Transformed AcidIndex';
length SQR_AcidIndex 8;
if AcidIndex eq . then SQR_AcidIndex = .;
else do;
SQR_AcidIndex = (AcidIndex + 1)**2;
end;
*------------------------------------------------------------*;
* TRANSFORM: CitricAcid , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_CitricAcid = 'Transformed CitricAcid';
length OPT_CitricAcid $36;
if (CitricAcid eq .) then OPT_CitricAcid="04:0.385-high, MISSING";
else
if (CitricAcid < 0.195) then
OPT_CitricAcid = "01:low-0.195";
else
if (CitricAcid >= 0.195 and CitricAcid < 0.285) then
OPT_CitricAcid = "02:0.195-0.285";
else
if (CitricAcid >= 0.285 and CitricAcid < 0.385) then
OPT_CitricAcid = "03:0.285-0.385";
else
if (CitricAcid >= 0.385) then
OPT_CitricAcid = "04:0.385-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: Density , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_Density = 'Transformed Density';
length OPT_Density $36;
if (Density eq .) then OPT_Density="03:0.993025-1.002255, MISSING";
else
if (Density < 0.9829) then
OPT_Density = "01:low-0.9829";
else
if (Density >= 0.9829 and Density < 0.993025) then
OPT_Density = "02:0.9829-0.993025";
else
if (Density >= 0.993025 and Density < 1.002255) then
OPT_Density = "03:0.993025-1.002255, MISSING";
else
if (Density >= 1.002255) then
OPT_Density = "04:1.002255-high";
*------------------------------------------------------------*;
* TRANSFORM: FixedAcidity , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_FixedAcidity = 'Transformed FixedAcidity';
length OPT_FixedAcidity $36;
if (FixedAcidity eq .) then OPT_FixedAcidity="01:low-7.95, MISSING";
else
if (FixedAcidity < 7.95) then
OPT_FixedAcidity = "01:low-7.95, MISSING";
else
if (FixedAcidity >= 7.95 and FixedAcidity < 10.45) then
OPT_FixedAcidity = "02:7.95-10.45";
else
if (FixedAcidity >= 10.45) then
OPT_FixedAcidity = "03:10.45-high";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Alcohol , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Alcohol = 'Transformed: Imputed Alcohol';
length OPT_IMP_Alcohol $36;
if (IMP_Alcohol eq .) then OPT_IMP_Alcohol="04:10.866667-high, MISSING";
else
if (IMP_Alcohol < 9.05) then
OPT_IMP_Alcohol = "01:low-9.05";
else
if (IMP_Alcohol >= 9.05 and IMP_Alcohol < 9.7666666667) then
OPT_IMP_Alcohol = "02:9.05-9.7666667";
else
if (IMP_Alcohol >= 9.7666666667 and IMP_Alcohol < 10.866666667) then
OPT_IMP_Alcohol = "03:9.7666667-10.866667";
else
if (IMP_Alcohol >= 10.866666667) then
OPT_IMP_Alcohol = "04:10.866667-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Chlorides , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Chlorides = 'Transformed: Imputed Chlorides';
length OPT_IMP_Chlorides $36;
if (IMP_Chlorides eq .) then OPT_IMP_Chlorides="02:0.0075-0.0575, MISSING";
else
if (IMP_Chlorides < 0.0075) then
OPT_IMP_Chlorides = "01:low-0.0075";
else
if (IMP_Chlorides >= 0.0075 and IMP_Chlorides < 0.0575) then
OPT_IMP_Chlorides = "02:0.0075-0.0575, MISSING";
else
if (IMP_Chlorides >= 0.0575 and IMP_Chlorides < 0.1345) then
OPT_IMP_Chlorides = "03:0.0575-0.1345";
else
if (IMP_Chlorides >= 0.1345) then
OPT_IMP_Chlorides = "04:0.1345-high";
*------------------------------------------------------------*;
* TRANSFORM: IMP_FreeSulfurDioxide , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_FreeSulfurDioxide = 'Transformed: Imputed FreeSulfurDioxide';
length OPT_IMP_FreeSulfurDioxide $36;
if (IMP_FreeSulfurDioxide eq .) then OPT_IMP_FreeSulfurDioxide="04:41.75-high, MISSING";
else
if (IMP_FreeSulfurDioxide < -1.75) then
OPT_IMP_FreeSulfurDioxide = "01:low--1.75";
else
if (IMP_FreeSulfurDioxide >= -1.75 and IMP_FreeSulfurDioxide < 22.5) then
OPT_IMP_FreeSulfurDioxide = "02:-1.75-22.5";
else
if (IMP_FreeSulfurDioxide >= 22.5 and IMP_FreeSulfurDioxide < 41.75) then
OPT_IMP_FreeSulfurDioxide = "03:22.5-41.75";
else
if (IMP_FreeSulfurDioxide >= 41.75) then
OPT_IMP_FreeSulfurDioxide = "04:41.75-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_ResidualSugar , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_ResidualSugar = 'Transformed: Imputed ResidualSugar';
length OPT_IMP_ResidualSugar $36;
if (IMP_ResidualSugar eq .) then OPT_IMP_ResidualSugar="04:7.225-high, MISSING";
else
if (IMP_ResidualSugar < 1.475) then
OPT_IMP_ResidualSugar = "01:low-1.475";
else
if (IMP_ResidualSugar >= 1.475 and IMP_ResidualSugar < 4.55) then
OPT_IMP_ResidualSugar = "02:1.475-4.55";
else
if (IMP_ResidualSugar >= 4.55 and IMP_ResidualSugar < 7.225) then
OPT_IMP_ResidualSugar = "03:4.55-7.225";
else
if (IMP_ResidualSugar >= 7.225) then
OPT_IMP_ResidualSugar = "04:7.225-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Sulphates , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Sulphates = 'Transformed: Imputed Sulphates';
length OPT_IMP_Sulphates $36;
if (IMP_Sulphates eq .) then OPT_IMP_Sulphates="04:0.555-high, MISSING";
else
if (IMP_Sulphates < -0.085) then
OPT_IMP_Sulphates = "01:low--0.085";
else
if (IMP_Sulphates >= -0.085 and IMP_Sulphates < 0.435) then
OPT_IMP_Sulphates = "02:-0.085-0.435";
else
if (IMP_Sulphates >= 0.435 and IMP_Sulphates < 0.555) then
OPT_IMP_Sulphates = "03:0.435-0.555";
else
if (IMP_Sulphates >= 0.555) then
OPT_IMP_Sulphates = "04:0.555-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_TotalSulfurDioxide , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_TotalSulfurDioxide = 'Transformed: Imputed TotalSulfurDioxide';
length OPT_IMP_TotalSulfurDioxide $36;
if (IMP_TotalSulfurDioxide eq .) then OPT_IMP_TotalSulfurDioxide="04:145.5-high, MISSING";
else
if (IMP_TotalSulfurDioxide < -10.5) then
OPT_IMP_TotalSulfurDioxide = "01:low--10.5";
else
if (IMP_TotalSulfurDioxide >= -10.5 and IMP_TotalSulfurDioxide < 80.5) then
OPT_IMP_TotalSulfurDioxide = "02:-10.5-80.5";
else
if (IMP_TotalSulfurDioxide >= 80.5 and IMP_TotalSulfurDioxide < 145.5) then
OPT_IMP_TotalSulfurDioxide = "03:80.5-145.5";
else
if (IMP_TotalSulfurDioxide >= 145.5) then
OPT_IMP_TotalSulfurDioxide = "04:145.5-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_pH , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_pH = 'Transformed: Imputed pH';
length OPT_IMP_pH $36;
if (IMP_pH eq .) then OPT_IMP_pH="04:3.255-high, MISSING";
else
if (IMP_pH < 2.975) then
OPT_IMP_pH = "01:low-2.975";
else
if (IMP_pH >= 2.975 and IMP_pH < 3.075) then
OPT_IMP_pH = "02:2.975-3.075";
else
if (IMP_pH >= 3.075 and IMP_pH < 3.255) then
OPT_IMP_pH = "03:3.075-3.255";
else
if (IMP_pH >= 3.255) then
OPT_IMP_pH = "04:3.255-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: VolatileAcidity , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_VolatileAcidity = 'Transformed VolatileAcidity';
length OPT_VolatileAcidity $36;
if (VolatileAcidity eq .) then OPT_VolatileAcidity="04:0.3125-high, MISSING";
else
if (VolatileAcidity < -1.0425) then
OPT_VolatileAcidity = "01:low--1.0425";
else
if (VolatileAcidity >= -1.0425 and VolatileAcidity < -0.095) then
OPT_VolatileAcidity = "02:-1.0425--0.095";
else
if (VolatileAcidity >= -0.095 and VolatileAcidity < 0.3125) then
OPT_VolatileAcidity = "03:-0.095-0.3125";
else
if (VolatileAcidity >= 0.3125) then
OPT_VolatileAcidity = "04:0.3125-high, MISSING";
*------------------------------------------------------------*;
* TOOL: Score Node;
* TYPE: ASSESS;
* NODE: Score;
*------------------------------------------------------------*;

run;

proc means data=&tempfiletree. min median mean max nmiss maxdec=2;
run;

proc freq data=&tempfiletree.;
table _character_;
run;

proc logistic data= &tempfiletree. PLOTS(MAXPOINTS=NONE) plot (only)=(roc(ID=prob));
	class 	OPT_CitricAcid
			OPT_Density
			OPT_FixedAcidity
			OPT_IMP_Alcohol
			OPT_IMP_Chlorides
			OPT_IMP_FreeSulfurDioxide
			OPT_IMP_ResidualSugar
			OPT_IMP_Sulphates
			OPT_IMP_TotalSulfurDioxide
			OPT_IMP_pH
			OPT_VolatileAcidity /param=reference;
				model Target_flag(ref="0") =

										OPT_CitricAcid
										OPT_Density
										OPT_FixedAcidity
										OPT_IMP_Alcohol
										OPT_IMP_Chlorides
										OPT_IMP_FreeSulfurDioxide
										OPT_IMP_ResidualSugar
										OPT_IMP_Sulphates
										OPT_IMP_TotalSulfurDioxide
										OPT_IMP_pH
										OPT_VolatileAcidity
										
										FixedAcidity
										VolatileAcidity
										CitricAcid
										ResidualSugar
										Chlorides
										FreeSulfurDioxide
										TotalSulfurDioxide
										Density
										pH
										Sulphates
										Alcohol
										LabelAppeal
										AcidIndex
										STARS
										IMP_Alcohol
										IMP_Chlorides
										IMP_FreeSulfurDioxide
										IMP_ResidualSugar
										IMP_STARS
										IMP_Sulphates
										IMP_TotalSulfurDioxide
										IMP_pH
										M_Alcohol
										M_Chlorides
										M_FreeSulfurDioxide
										M_ResidualSugar
										M_STARS
										M_Sulphates
										M_TotalSulfurDioxide
										M_pH
										SQR_AcidIndex
										/ selection=stepwise roceps=0.1 ;
run;

/*exlude the transformed binned variables*/
proc logistic data= &tempfiletree. PLOTS(MAXPOINTS=NONE) plot (only)=(roc(ID=prob));
				model Target_flag(ref="0") =

										FixedAcidity
										VolatileAcidity
										CitricAcid
										ResidualSugar
										Chlorides
										FreeSulfurDioxide
										TotalSulfurDioxide
										Density
										pH
										Sulphates
										Alcohol
										LabelAppeal
										AcidIndex
										STARS
										IMP_Alcohol
										IMP_Chlorides
										IMP_FreeSulfurDioxide
										IMP_ResidualSugar
										IMP_STARS
										IMP_Sulphates
										IMP_TotalSulfurDioxide
										IMP_pH
										M_Alcohol
										M_Chlorides
										M_FreeSulfurDioxide
										M_ResidualSugar
										M_STARS
										M_Sulphates
										M_TotalSulfurDioxide
										M_pH
										SQR_AcidIndex
										/ selection=stepwise roceps=0.1 ;
run;

/*based on decision tree variable importance selection*/
proc logistic data= &tempfiletree. PLOTS(MAXPOINTS=NONE) plot (only)=(roc(ID=prob));
					class 	OPT_VolatileAcidity										
							OPT_IMP_TotalSulfurDioxide	
							OPT_Density
							OPT_IMP_Alcohol
							OPT_IMP_Chlorides
							OPT_IMP_Sulphates
							OPT_CitricAcid
							OPT_IMP_FreeSulfurDioxide
							/param=reference;
							model Target_flag(ref="0") =

										M_STARS
										IMP_STARS
										OPT_VolatileAcidity										
										SQR_AcidIndex
										OPT_IMP_TotalSulfurDioxide	
										OPT_Density
										OPT_IMP_Alcohol
										OPT_IMP_Chlorides
										OPT_IMP_Sulphates
										OPT_CitricAcid
										OPT_IMP_FreeSulfurDioxide
										/ roceps=0.1 ;
output out=outfile5 p=x_Logit_Hurdle2;
run;

/****************HURDLE MODEL 5 SECOND PART****************/
/*proc genmod to predict target amount: the amount that will be bought
when wine is actually purchased*/

/*proc reg attempt: how much wine will be bought if wine is bought*/

/*proc genmod attempt: how much wine will be bought if wine is bought*/
proc genmod data=outfile5;
	class 	OPT_IMP_Alcohol
			M_STARS
			OPT_VolatileAcidity
			OPT_IMP_Sulphates
			OPT_IMP_Sulphates
			OPT_IMP_FreeSulfurDioxide
			OPT_IMP_ResidualSugar
			LabelAppeal;
model Target_amt = 
					LabelAppeal
					IMP_STARS
					OPT_IMP_Alcohol
					M_STARS
					OPT_VolatileAcidity
					SQR_AcidIndex
					OPT_IMP_Sulphates
					OPT_IMP_Sulphates
					OPT_IMP_FreeSulfurDioxide
					OPT_IMP_ResidualSugar
					 / link=log dist=poi;
output out=outfile5_1 p=x_Genmod_Hurdle2;
run;

proc means data=outfile5_1;
run;

/***********************************************************************
*                          Model 5: Score DataStep                     *
***********************************************************************/
%let Path = /folders/myfolders/sasuser.v94/Unit03/WineSales;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let testfile = &LIB.wine_test;

data Mod5score;
set &testfile;

Target_flag = (Target > 0); /*puts a 1 if >0, else puts a 0*/
Target_Amt = Target -1;  /*we subtract 1 which will be added back later*/
if Target_flag = 0 then Target_Amt = .; /*puts blank when target_nozero =0*/


*------------------------------------------------------------*;
* EM SCORE CODE;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Input Data Source;
* TYPE: SAMPLE;
* NODE: Ids;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Metadata Node;
* TYPE: UTILITY;
* NODE: Meta;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Partition Class;
* TYPE: SAMPLE;
* NODE: Part;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Imputation;
* TYPE: MODIFY;
* NODE: Impt;
*------------------------------------------------------------*;
*;
* TREE IMPUTATION;
*;
*;
* IMPUTE VARIABLE: Alcohol;
*;
length IMP_Alcohol 8;
label IMP_Alcohol = 'Imputed Alcohol';
IMP_Alcohol = Alcohol;
if missing(IMP_Alcohol) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Alcohol = 'Predicted: Alcohol';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(Density ) AND
Density < 0.994285 THEN DO;
IF NOT MISSING(Density ) AND
Density < 0.98661 THEN DO;
IF NOT MISSING(Chlorides ) AND
0.0425 <= Chlorides THEN DO;
P_Alcohol = 10.0511498178506;
END;
ELSE DO;
P_Alcohol = 10.7160265049416;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
0.99259 <= Density THEN DO;
P_Alcohol = 10.6303582853486;
END;
ELSE DO;
P_Alcohol = 11.5116435541859;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
1.001185 <= Density THEN DO;
IF NOT MISSING(ResidualSugar ) AND
5.95 <= ResidualSugar THEN DO;
IF NOT MISSING(FixedAcidity ) AND
FixedAcidity < -2.95 THEN DO;
P_Alcohol = 11.8736111111111;
END;
ELSE DO;
P_Alcohol = 9.95872245467224;
END;
END;
ELSE DO;
P_Alcohol = 10.7597821859198;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
26.5 <= FreeSulfurDioxide THEN DO;
P_Alcohol = 9.67133529990166;
END;
ELSE DO;
P_Alcohol = 10.2433507739263;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Alcohol;
*;
IMP_Alcohol = P_ALCOHOL;
END;
*;
* IMPUTE VARIABLE: Chlorides;
*;
length IMP_Chlorides 8;
label IMP_Chlorides = 'Imputed Chlorides';
IMP_Chlorides = Chlorides;
if missing(IMP_Chlorides) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Chlorides = 'Predicted: Chlorides';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
P_Chlorides = 0.05482248910092;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Chlorides;
*;
IMP_Chlorides = P_CHLORIDES;
END;
*;
* IMPUTE VARIABLE: FreeSulfurDioxide;
*;
length IMP_FreeSulfurDioxide 8;
label IMP_FreeSulfurDioxide = 'Imputed FreeSulfurDioxide';
IMP_FreeSulfurDioxide = FreeSulfurDioxide;
if missing(IMP_FreeSulfurDioxide) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_FreeSulfurDioxide = 'Predicted: FreeSulfurDioxide';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
9.5 <= AcidIndex THEN DO;
P_FreeSulfurDioxide = 9.2664054848188;
END;
ELSE DO;
P_FreeSulfurDioxide = 32.8256493214703;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: FreeSulfurDioxide;
*;
IMP_FreeSulfurDioxide = P_FREESULFURDIOXIDE;
END;
*;
* IMPUTE VARIABLE: ResidualSugar;
*;
length IMP_ResidualSugar 8;
label IMP_ResidualSugar = 'Imputed ResidualSugar';
IMP_ResidualSugar = ResidualSugar;
if missing(IMP_ResidualSugar) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_ResidualSugar = 'Predicted: ResidualSugar';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(TotalSulfurDioxide ) AND
158.5 <= TotalSulfurDioxide THEN DO;
P_ResidualSugar = 7.64509173218955;
END;
ELSE DO;
P_ResidualSugar = 4.24809571535955;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: ResidualSugar;
*;
IMP_ResidualSugar = P_RESIDUALSUGAR;
END;
*;
* IMPUTE VARIABLE: STARS;
*;
length IMP_STARS 8;
label IMP_STARS = 'Imputed STARS';
IMP_STARS = STARS;
if missing(IMP_STARS) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH I_STARS $ 12;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_STARS1 = 'Predicted: STARS=1';
label P_STARS2 = 'Predicted: STARS=2';
label P_STARS3 = 'Predicted: STARS=3';
label P_STARS4 = 'Predicted: STARS=4';
label Q_STARS1 = 'Unadjusted P: STARS=1';
label Q_STARS2 = 'Unadjusted P: STARS=2';
label Q_STARS3 = 'Unadjusted P: STARS=3';
label Q_STARS4 = 'Unadjusted P: STARS=4';
label I_STARS = 'Into: STARS';
label U_STARS = 'Unnormalized Into: STARS';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_12 $ 12;
DROP _ARBFMT_12;
_ARBFMT_12 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('-2' ,'-1' ) THEN DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('-2' ) THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 5.85 THEN DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < 0.375 THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 4.3 THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.4;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.4;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 1;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0;
Q_STARS2 = 1;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Chlorides ) AND
0.0495 <= Chlorides THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.2;
P_STARS3 = 0.4;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.2;
Q_STARS3 = 0.4;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 1;
P_STARS2 = 0;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 1;
Q_STARS2 = 0;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
-0.135 <= Sulphates THEN DO;
IF NOT MISSING(pH ) AND
pH < 2.58 THEN DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
35.5 <= FreeSulfurDioxide THEN DO;
P_STARS1 = 0.78571428571428;
P_STARS2 = 0.21428571428571;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.78571428571428;
Q_STARS2 = 0.21428571428571;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.30434782608695;
P_STARS2 = 0.47826086956521;
P_STARS3 = 0.21739130434782;
P_STARS4 = 0;
Q_STARS1 = 0.30434782608695;
Q_STARS2 = 0.47826086956521;
Q_STARS3 = 0.21739130434782;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < 0.215 THEN DO;
P_STARS1 = 0.3;
P_STARS2 = 0.5;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.3;
Q_STARS2 = 0.5;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.75;
P_STARS2 = 0.23076923076923;
P_STARS3 = 0.01923076923076;
P_STARS4 = 0;
Q_STARS1 = 0.75;
Q_STARS2 = 0.23076923076923;
Q_STARS3 = 0.01923076923076;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Chlorides ) AND
Chlorides < 0.0325 THEN DO;
IF NOT MISSING(Sulphates ) THEN DO;
P_STARS1 = 0.92307692307692;
P_STARS2 = 0;
P_STARS3 = 0.07692307692307;
P_STARS4 = 0;
Q_STARS1 = 0.92307692307692;
Q_STARS2 = 0;
Q_STARS3 = 0.07692307692307;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.25;
P_STARS2 = 0.125;
P_STARS3 = 0.625;
P_STARS4 = 0;
Q_STARS1 = 0.25;
Q_STARS2 = 0.125;
Q_STARS3 = 0.625;
Q_STARS4 = 0;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 8.9 THEN DO;
P_STARS1 = 0.4;
P_STARS2 = 0.4;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.4;
Q_STARS2 = 0.4;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.925;
P_STARS2 = 0.05;
P_STARS3 = 0.025;
P_STARS4 = 0;
Q_STARS1 = 0.925;
Q_STARS2 = 0.05;
Q_STARS3 = 0.025;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Density ) AND
Density < 0.99167 THEN DO;
IF NOT MISSING(Sulphates ) AND
0.035 <= Sulphates THEN DO;
IF NOT MISSING(CitricAcid ) AND
CitricAcid < -0.885 THEN DO;
P_STARS1 = 0.18518518518518;
P_STARS2 = 0.66666666666666;
P_STARS3 = 0.14814814814814;
P_STARS4 = 0;
Q_STARS1 = 0.18518518518518;
Q_STARS2 = 0.66666666666666;
Q_STARS3 = 0.14814814814814;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.43181818181818;
P_STARS2 = 0.40530303030303;
P_STARS3 = 0.14393939393939;
P_STARS4 = 0.01893939393939;
Q_STARS1 = 0.43181818181818;
Q_STARS2 = 0.40530303030303;
Q_STARS3 = 0.14393939393939;
Q_STARS4 = 0.01893939393939;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FixedAcidity ) AND
16.7 <= FixedAcidity THEN DO;
P_STARS1 = 0.875;
P_STARS2 = 0.125;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.875;
Q_STARS2 = 0.125;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
Sulphates < -1.865 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.8;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0;
Q_STARS2 = 0.8;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.49019607843137;
P_STARS2 = 0.27941176470588;
P_STARS3 = 0.22058823529411;
P_STARS4 = 0.00980392156862;
Q_STARS1 = 0.49019607843137;
Q_STARS2 = 0.27941176470588;
Q_STARS3 = 0.22058823529411;
Q_STARS4 = 0.00980392156862;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
2.1775 <= VolatileAcidity THEN DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 10.85 THEN DO;
P_STARS1 = 0.33333333333333;
P_STARS2 = 0.66666666666666;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.33333333333333;
Q_STARS2 = 0.66666666666666;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < -1.19999999999999 THEN DO;
P_STARS1 = 0.2;
P_STARS2 = 0.6;
P_STARS3 = 0.2;
P_STARS4 = 0;
Q_STARS1 = 0.2;
Q_STARS2 = 0.6;
Q_STARS3 = 0.2;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 0;
P_STARS3 = 0.85714285714285;
P_STARS4 = 0.14285714285714;
Q_STARS1 = 0;
Q_STARS2 = 0;
Q_STARS3 = 0.85714285714285;
Q_STARS4 = 0.14285714285714;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
1.745 <= VolatileAcidity THEN DO;
IF NOT MISSING(Alcohol ) AND
13.9 <= Alcohol THEN DO;
P_STARS1 = 0.33333333333333;
P_STARS2 = 0.33333333333333;
P_STARS3 = 0.33333333333333;
P_STARS4 = 0;
Q_STARS1 = 0.33333333333333;
Q_STARS2 = 0.33333333333333;
Q_STARS3 = 0.33333333333333;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.89473684210526;
P_STARS2 = 0.05263157894736;
P_STARS3 = 0.05263157894736;
P_STARS4 = 0;
Q_STARS1 = 0.89473684210526;
Q_STARS2 = 0.05263157894736;
Q_STARS3 = 0.05263157894736;
Q_STARS4 = 0;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FixedAcidity ) AND
26.45 <= FixedAcidity THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.71428571428571;
P_STARS3 = 0.14285714285714;
P_STARS4 = 0.14285714285714;
Q_STARS1 = 0;
Q_STARS2 = 0.71428571428571;
Q_STARS3 = 0.14285714285714;
Q_STARS4 = 0.14285714285714;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.49382716049382;
P_STARS2 = 0.40123456790123;
P_STARS3 = 0.09336419753086;
P_STARS4 = 0.01157407407407;
Q_STARS1 = 0.49382716049382;
Q_STARS2 = 0.40123456790123;
Q_STARS3 = 0.09336419753086;
Q_STARS4 = 0.01157407407407;
I_STARS = '1';
U_STARS = 1;
END;
END;
END;
END;
END;
END;
ELSE DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('1' ,'2' ) THEN DO;
IF NOT MISSING(Alcohol ) AND
11.025 <= Alcohol THEN DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
-80 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.27272727272727;
P_STARS2 = 0.40495867768595;
P_STARS3 = 0.23140495867768;
P_STARS4 = 0.09090909090909;
Q_STARS1 = 0.27272727272727;
Q_STARS2 = 0.40495867768595;
Q_STARS3 = 0.23140495867768;
Q_STARS4 = 0.09090909090909;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
VolatileAcidity < -0.625 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.8;
P_STARS3 = 0;
P_STARS4 = 0.2;
Q_STARS1 = 0;
Q_STARS2 = 0.8;
Q_STARS3 = 0;
Q_STARS4 = 0.2;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.1578947368421;
P_STARS2 = 0.05263157894736;
P_STARS3 = 0.57894736842105;
P_STARS4 = 0.21052631578947;
Q_STARS1 = 0.1578947368421;
Q_STARS2 = 0.05263157894736;
Q_STARS3 = 0.57894736842105;
Q_STARS4 = 0.21052631578947;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
1.47 <= VolatileAcidity THEN DO;
IF NOT MISSING(Sulphates ) AND
1.57 <= Sulphates THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.16666666666666;
P_STARS3 = 0.16666666666666;
P_STARS4 = 0.66666666666666;
Q_STARS1 = 0;
Q_STARS2 = 0.16666666666666;
Q_STARS3 = 0.16666666666666;
Q_STARS4 = 0.66666666666666;
I_STARS = '4';
U_STARS = 4;
END;
ELSE DO;
P_STARS1 = 0.3015873015873;
P_STARS2 = 0.31746031746031;
P_STARS3 = 0.28571428571428;
P_STARS4 = 0.09523809523809;
Q_STARS1 = 0.3015873015873;
Q_STARS2 = 0.31746031746031;
Q_STARS3 = 0.28571428571428;
Q_STARS4 = 0.09523809523809;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
IF NOT MISSING(Sulphates ) AND
2.38 <= Sulphates THEN DO;
P_STARS1 = 0.1;
P_STARS2 = 0.9;
P_STARS3 = 0;
P_STARS4 = 0;
Q_STARS1 = 0.1;
Q_STARS2 = 0.9;
Q_STARS3 = 0;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.10444177671068;
P_STARS2 = 0.28811524609843;
P_STARS3 = 0.41776710684273;
P_STARS4 = 0.18967587034813;
Q_STARS1 = 0.10444177671068;
Q_STARS2 = 0.28811524609843;
Q_STARS3 = 0.41776710684273;
Q_STARS4 = 0.18967587034813;
I_STARS = '3';
U_STARS = 3;
END;
END;
END;
END;
ELSE DO;
_ARBFMT_12 = PUT( LabelAppeal , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('2' ) THEN DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(VolatileAcidity ) AND
VolatileAcidity < 0.175 THEN DO;
P_STARS1 = 0;
P_STARS2 = 0.3;
P_STARS3 = 0.3;
P_STARS4 = 0.4;
Q_STARS1 = 0;
Q_STARS2 = 0.3;
Q_STARS3 = 0.3;
Q_STARS4 = 0.4;
I_STARS = '4';
U_STARS = 4;
END;
ELSE DO;
P_STARS1 = 0.41666666666666;
P_STARS2 = 0.25;
P_STARS3 = 0.16666666666666;
P_STARS4 = 0.16666666666666;
Q_STARS1 = 0.41666666666666;
Q_STARS2 = 0.25;
Q_STARS3 = 0.16666666666666;
Q_STARS4 = 0.16666666666666;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
P_STARS1 = 0.11475409836065;
P_STARS2 = 0.27322404371584;
P_STARS3 = 0.41530054644808;
P_STARS4 = 0.1967213114754;
Q_STARS1 = 0.11475409836065;
Q_STARS2 = 0.27322404371584;
Q_STARS3 = 0.41530054644808;
Q_STARS4 = 0.1967213114754;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
P_STARS1 = 0.21171770972037;
P_STARS2 = 0.39680426098535;
P_STARS3 = 0.28428761651131;
P_STARS4 = 0.10719041278295;
Q_STARS1 = 0.21171770972037;
Q_STARS2 = 0.39680426098535;
Q_STARS3 = 0.28428761651131;
Q_STARS4 = 0.10719041278295;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
IF NOT MISSING(Chlorides ) AND
0.0555 <= Chlorides THEN DO;
IF NOT MISSING(Density ) AND
1.04897 <= Density THEN DO;
P_STARS1 = 0.16666666666666;
P_STARS2 = 0;
P_STARS3 = 0.66666666666666;
P_STARS4 = 0.16666666666666;
Q_STARS1 = 0.16666666666666;
Q_STARS2 = 0;
Q_STARS3 = 0.66666666666666;
Q_STARS4 = 0.16666666666666;
I_STARS = '3';
U_STARS = 3;
END;
ELSE DO;
P_STARS1 = 0.49822064056939;
P_STARS2 = 0.31672597864768;
P_STARS3 = 0.16370106761565;
P_STARS4 = 0.02135231316725;
Q_STARS1 = 0.49822064056939;
Q_STARS2 = 0.31672597864768;
Q_STARS3 = 0.16370106761565;
Q_STARS4 = 0.02135231316725;
I_STARS = '1';
U_STARS = 1;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
4.5 <= FreeSulfurDioxide THEN DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
304 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.64516129032258;
P_STARS2 = 0.29032258064516;
P_STARS3 = 0;
P_STARS4 = 0.06451612903225;
Q_STARS1 = 0.64516129032258;
Q_STARS2 = 0.29032258064516;
Q_STARS3 = 0;
Q_STARS4 = 0.06451612903225;
I_STARS = '1';
U_STARS = 1;
END;
ELSE DO;
P_STARS1 = 0.35833333333333;
P_STARS2 = 0.3875;
P_STARS3 = 0.2125;
P_STARS4 = 0.04166666666666;
Q_STARS1 = 0.35833333333333;
Q_STARS2 = 0.3875;
Q_STARS3 = 0.2125;
Q_STARS4 = 0.04166666666666;
I_STARS = '2';
U_STARS = 2;
END;
END;
ELSE DO;
P_STARS1 = 0.23809523809523;
P_STARS2 = 0.4;
P_STARS3 = 0.32380952380952;
P_STARS4 = 0.03809523809523;
Q_STARS1 = 0.23809523809523;
Q_STARS2 = 0.4;
Q_STARS3 = 0.32380952380952;
Q_STARS4 = 0.03809523809523;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 10.95 THEN DO;
IF NOT MISSING(Sulphates ) AND
2.185 <= Sulphates THEN DO;
IF NOT MISSING(Chlorides ) AND
Chlorides < 0.5165 THEN DO;
P_STARS1 = 0.18;
P_STARS2 = 0.64;
P_STARS3 = 0.18;
P_STARS4 = 0;
Q_STARS1 = 0.18;
Q_STARS2 = 0.64;
Q_STARS3 = 0.18;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0;
P_STARS2 = 0.41666666666666;
P_STARS3 = 0.5;
P_STARS4 = 0.08333333333333;
Q_STARS1 = 0;
Q_STARS2 = 0.41666666666666;
Q_STARS3 = 0.5;
Q_STARS4 = 0.08333333333333;
I_STARS = '3';
U_STARS = 3;
END;
END;
ELSE DO;
IF NOT MISSING(TotalSulfurDioxide ) AND
525 <= TotalSulfurDioxide THEN DO;
P_STARS1 = 0.19791666666666;
P_STARS2 = 0.54166666666666;
P_STARS3 = 0.26041666666666;
P_STARS4 = 0;
Q_STARS1 = 0.19791666666666;
Q_STARS2 = 0.54166666666666;
Q_STARS3 = 0.26041666666666;
Q_STARS4 = 0;
I_STARS = '2';
U_STARS = 2;
END;
ELSE DO;
P_STARS1 = 0.33980582524271;
P_STARS2 = 0.40776699029126;
P_STARS3 = 0.21245002855511;
P_STARS4 = 0.0399771559109;
Q_STARS1 = 0.33980582524271;
Q_STARS2 = 0.40776699029126;
Q_STARS3 = 0.21245002855511;
Q_STARS4 = 0.0399771559109;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
ELSE DO;
P_STARS1 = 0.26866585067319;
P_STARS2 = 0.38739290085679;
P_STARS3 = 0.28396572827417;
P_STARS4 = 0.05997552019583;
Q_STARS1 = 0.26866585067319;
Q_STARS2 = 0.38739290085679;
Q_STARS3 = 0.28396572827417;
Q_STARS4 = 0.05997552019583;
I_STARS = '2';
U_STARS = 2;
END;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: STARS;
*;
length _format200 $200;
drop _format200;
_format200 = strip(I_STARS);
if _format200="4" then IMP_STARS = 4;
else
if _format200="3" then IMP_STARS = 3;
else
if _format200="2" then IMP_STARS = 2;
else
if _format200="1" then IMP_STARS = 1;
END;
*;
* IMPUTE VARIABLE: Sulphates;
*;
length IMP_Sulphates 8;
label IMP_Sulphates = 'Imputed Sulphates';
IMP_Sulphates = Sulphates;
if missing(IMP_Sulphates) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_Sulphates = 'Predicted: Sulphates';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
10.5 <= AcidIndex THEN DO;
P_Sulphates = 0.70503157894736;
END;
ELSE DO;
P_Sulphates = 0.51950495049504;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: Sulphates;
*;
IMP_Sulphates = P_SULPHATES;
END;
*;
* IMPUTE VARIABLE: TotalSulfurDioxide;
*;
length IMP_TotalSulfurDioxide 8;
label IMP_TotalSulfurDioxide = 'Imputed TotalSulfurDioxide';
IMP_TotalSulfurDioxide = TotalSulfurDioxide;
if missing(IMP_TotalSulfurDioxide) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_TotalSulfurDioxide = 'Predicted: TotalSulfurDioxide';
label _WARN_ = 'Warnings';
****** TEMPORARY VARIABLES FOR FORMATTED VALUES ******;
LENGTH _ARBFMT_12 $ 12;
DROP _ARBFMT_12;
_ARBFMT_12 = ' ';
/* Initialize to avoid warning. */
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
8.5 <= AcidIndex THEN DO;
_ARBFMT_12 = PUT( STARS , BEST12.);
%DMNORMIP( _ARBFMT_12);
IF _ARBFMT_12 IN ('1' ,'2' ) THEN DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < 6.95 THEN DO;
P_TotalSulfurDioxide = 88.7770700636942;
END;
ELSE DO;
IF NOT MISSING(Alcohol ) AND
Alcohol < 7.45 THEN DO;
P_TotalSulfurDioxide = 253.851351351351;
END;
ELSE DO;
P_TotalSulfurDioxide = 129.805486284289;
END;
END;
END;
ELSE DO;
P_TotalSulfurDioxide = 75.8012568735271;
END;
END;
ELSE DO;
IF NOT MISSING(ResidualSugar ) AND
ResidualSugar < 5.75 THEN DO;
IF NOT MISSING(VolatileAcidity ) AND
1.765 <= VolatileAcidity THEN DO;
P_TotalSulfurDioxide = 41.5602409638554;
END;
ELSE DO;
P_TotalSulfurDioxide = 116.359597652975;
END;
END;
ELSE DO;
IF NOT MISSING(FreeSulfurDioxide ) AND
FreeSulfurDioxide < 36.5 THEN DO;
P_TotalSulfurDioxide = 125.195661512027;
END;
ELSE DO;
P_TotalSulfurDioxide = 156.011736139214;
END;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: TotalSulfurDioxide;
*;
IMP_TotalSulfurDioxide = P_TOTALSULFURDIOXIDE;
END;
*;
* IMPUTE VARIABLE: pH;
*;
length IMP_pH 8;
label IMP_pH = 'Imputed pH';
IMP_pH = pH;
if missing(IMP_pH) then do;
****************************************************************;
****** DECISION TREE SCORING CODE ******;
****************************************************************;
****** LENGTHS OF NEW CHARACTER VARIABLES ******;
LENGTH _WARN_ $ 4;
****** LABELS FOR NEW VARIABLES ******;
label P_pH = 'Predicted: pH';
label _WARN_ = 'Warnings';
****** ASSIGN OBSERVATION TO NODE ******;
IF NOT MISSING(AcidIndex ) AND
AcidIndex < 7.5 THEN DO;
IF NOT MISSING(AcidIndex ) AND
AcidIndex < 6.5 THEN DO;
P_pH = 3.31947154471544;
END;
ELSE DO;
P_pH = 3.22725755334882;
END;
END;
ELSE DO;
IF NOT MISSING(VolatileAcidity ) AND
0.4125 <= VolatileAcidity THEN DO;
P_pH = 3.21901160464185;
END;
ELSE DO;
P_pH = 3.14187912646013;
END;
END;
****************************************************************;
****** END OF DECISION TREE SCORING CODE ******;
****************************************************************;
*;
* ASSIGN VALUE TO: pH;
*;
IMP_pH = P_PH;
END;
*;
* Drop prediction variables since they are for INPUTS not TARGETS;
* Replace _NODE_ by _XODE_ so it can be safely dropped;
*;
drop
P_Alcohol
P_Chlorides
P_FreeSulfurDioxide
P_ResidualSugar
P_STARS4
P_STARS3
P_STARS2
P_STARS1
I_STARS
U_STARS
Q_STARS4
Q_STARS3
Q_STARS2
Q_STARS1
P_Sulphates
P_TotalSulfurDioxide
P_pH
;
*;
*INDICATOR VARIABLES;
*;
label M_Alcohol = "Imputation Indicator for Alcohol";
if missing(Alcohol) then M_Alcohol = 1;
else M_Alcohol= 0;
label M_Chlorides = "Imputation Indicator for Chlorides";
if missing(Chlorides) then M_Chlorides = 1;
else M_Chlorides= 0;
label M_FreeSulfurDioxide = "Imputation Indicator for FreeSulfurDioxide";
if missing(FreeSulfurDioxide) then M_FreeSulfurDioxide = 1;
else M_FreeSulfurDioxide= 0;
label M_ResidualSugar = "Imputation Indicator for ResidualSugar";
if missing(ResidualSugar) then M_ResidualSugar = 1;
else M_ResidualSugar= 0;
label M_STARS = "Imputation Indicator for STARS";
if missing(STARS) then M_STARS = 1;
else M_STARS= 0;
label M_Sulphates = "Imputation Indicator for Sulphates";
if missing(Sulphates) then M_Sulphates = 1;
else M_Sulphates= 0;
label M_TotalSulfurDioxide = "Imputation Indicator for TotalSulfurDioxide";
if missing(TotalSulfurDioxide) then M_TotalSulfurDioxide = 1;
else M_TotalSulfurDioxide= 0;
label M_pH = "Imputation Indicator for pH";
if missing(pH) then M_pH = 1;
else M_pH= 0;
*------------------------------------------------------------*;
* TOOL: Transform;
* TYPE: MODIFY;
* NODE: Trans;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* Computed Code;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TRANSFORM: AcidIndex , (AcidIndex + 1)**2;
*------------------------------------------------------------*;
label SQR_AcidIndex = 'Transformed AcidIndex';
length SQR_AcidIndex 8;
if AcidIndex eq . then SQR_AcidIndex = .;
else do;
SQR_AcidIndex = (AcidIndex + 1)**2;
end;
*------------------------------------------------------------*;
* TRANSFORM: CitricAcid , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_CitricAcid = 'Transformed CitricAcid';
length OPT_CitricAcid $36;
if (CitricAcid eq .) then OPT_CitricAcid="04:0.385-high, MISSING";
else
if (CitricAcid < 0.195) then
OPT_CitricAcid = "01:low-0.195";
else
if (CitricAcid >= 0.195 and CitricAcid < 0.285) then
OPT_CitricAcid = "02:0.195-0.285";
else
if (CitricAcid >= 0.285 and CitricAcid < 0.385) then
OPT_CitricAcid = "03:0.285-0.385";
else
if (CitricAcid >= 0.385) then
OPT_CitricAcid = "04:0.385-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: Density , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_Density = 'Transformed Density';
length OPT_Density $36;
if (Density eq .) then OPT_Density="03:0.993025-1.002255, MISSING";
else
if (Density < 0.9829) then
OPT_Density = "01:low-0.9829";
else
if (Density >= 0.9829 and Density < 0.993025) then
OPT_Density = "02:0.9829-0.993025";
else
if (Density >= 0.993025 and Density < 1.002255) then
OPT_Density = "03:0.993025-1.002255, MISSING";
else
if (Density >= 1.002255) then
OPT_Density = "04:1.002255-high";
*------------------------------------------------------------*;
* TRANSFORM: FixedAcidity , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_FixedAcidity = 'Transformed FixedAcidity';
length OPT_FixedAcidity $36;
if (FixedAcidity eq .) then OPT_FixedAcidity="01:low-7.95, MISSING";
else
if (FixedAcidity < 7.95) then
OPT_FixedAcidity = "01:low-7.95, MISSING";
else
if (FixedAcidity >= 7.95 and FixedAcidity < 10.45) then
OPT_FixedAcidity = "02:7.95-10.45";
else
if (FixedAcidity >= 10.45) then
OPT_FixedAcidity = "03:10.45-high";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Alcohol , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Alcohol = 'Transformed: Imputed Alcohol';
length OPT_IMP_Alcohol $36;
if (IMP_Alcohol eq .) then OPT_IMP_Alcohol="04:10.866667-high, MISSING";
else
if (IMP_Alcohol < 9.05) then
OPT_IMP_Alcohol = "01:low-9.05";
else
if (IMP_Alcohol >= 9.05 and IMP_Alcohol < 9.7666666667) then
OPT_IMP_Alcohol = "02:9.05-9.7666667";
else
if (IMP_Alcohol >= 9.7666666667 and IMP_Alcohol < 10.866666667) then
OPT_IMP_Alcohol = "03:9.7666667-10.866667";
else
if (IMP_Alcohol >= 10.866666667) then
OPT_IMP_Alcohol = "04:10.866667-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Chlorides , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Chlorides = 'Transformed: Imputed Chlorides';
length OPT_IMP_Chlorides $36;
if (IMP_Chlorides eq .) then OPT_IMP_Chlorides="02:0.0075-0.0575, MISSING";
else
if (IMP_Chlorides < 0.0075) then
OPT_IMP_Chlorides = "01:low-0.0075";
else
if (IMP_Chlorides >= 0.0075 and IMP_Chlorides < 0.0575) then
OPT_IMP_Chlorides = "02:0.0075-0.0575, MISSING";
else
if (IMP_Chlorides >= 0.0575 and IMP_Chlorides < 0.1345) then
OPT_IMP_Chlorides = "03:0.0575-0.1345";
else
if (IMP_Chlorides >= 0.1345) then
OPT_IMP_Chlorides = "04:0.1345-high";
*------------------------------------------------------------*;
* TRANSFORM: IMP_FreeSulfurDioxide , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_FreeSulfurDioxide = 'Transformed: Imputed FreeSulfurDioxide';
length OPT_IMP_FreeSulfurDioxide $36;
if (IMP_FreeSulfurDioxide eq .) then OPT_IMP_FreeSulfurDioxide="04:41.75-high, MISSING";
else
if (IMP_FreeSulfurDioxide < -1.75) then
OPT_IMP_FreeSulfurDioxide = "01:low--1.75";
else
if (IMP_FreeSulfurDioxide >= -1.75 and IMP_FreeSulfurDioxide < 22.5) then
OPT_IMP_FreeSulfurDioxide = "02:-1.75-22.5";
else
if (IMP_FreeSulfurDioxide >= 22.5 and IMP_FreeSulfurDioxide < 41.75) then
OPT_IMP_FreeSulfurDioxide = "03:22.5-41.75";
else
if (IMP_FreeSulfurDioxide >= 41.75) then
OPT_IMP_FreeSulfurDioxide = "04:41.75-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_ResidualSugar , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_ResidualSugar = 'Transformed: Imputed ResidualSugar';
length OPT_IMP_ResidualSugar $36;
if (IMP_ResidualSugar eq .) then OPT_IMP_ResidualSugar="04:7.225-high, MISSING";
else
if (IMP_ResidualSugar < 1.475) then
OPT_IMP_ResidualSugar = "01:low-1.475";
else
if (IMP_ResidualSugar >= 1.475 and IMP_ResidualSugar < 4.55) then
OPT_IMP_ResidualSugar = "02:1.475-4.55";
else
if (IMP_ResidualSugar >= 4.55 and IMP_ResidualSugar < 7.225) then
OPT_IMP_ResidualSugar = "03:4.55-7.225";
else
if (IMP_ResidualSugar >= 7.225) then
OPT_IMP_ResidualSugar = "04:7.225-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_Sulphates , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_Sulphates = 'Transformed: Imputed Sulphates';
length OPT_IMP_Sulphates $36;
if (IMP_Sulphates eq .) then OPT_IMP_Sulphates="04:0.555-high, MISSING";
else
if (IMP_Sulphates < -0.085) then
OPT_IMP_Sulphates = "01:low--0.085";
else
if (IMP_Sulphates >= -0.085 and IMP_Sulphates < 0.435) then
OPT_IMP_Sulphates = "02:-0.085-0.435";
else
if (IMP_Sulphates >= 0.435 and IMP_Sulphates < 0.555) then
OPT_IMP_Sulphates = "03:0.435-0.555";
else
if (IMP_Sulphates >= 0.555) then
OPT_IMP_Sulphates = "04:0.555-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_TotalSulfurDioxide , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_TotalSulfurDioxide = 'Transformed: Imputed TotalSulfurDioxide';
length OPT_IMP_TotalSulfurDioxide $36;
if (IMP_TotalSulfurDioxide eq .) then OPT_IMP_TotalSulfurDioxide="04:145.5-high, MISSING";
else
if (IMP_TotalSulfurDioxide < -10.5) then
OPT_IMP_TotalSulfurDioxide = "01:low--10.5";
else
if (IMP_TotalSulfurDioxide >= -10.5 and IMP_TotalSulfurDioxide < 80.5) then
OPT_IMP_TotalSulfurDioxide = "02:-10.5-80.5";
else
if (IMP_TotalSulfurDioxide >= 80.5 and IMP_TotalSulfurDioxide < 145.5) then
OPT_IMP_TotalSulfurDioxide = "03:80.5-145.5";
else
if (IMP_TotalSulfurDioxide >= 145.5) then
OPT_IMP_TotalSulfurDioxide = "04:145.5-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: IMP_pH , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_IMP_pH = 'Transformed: Imputed pH';
length OPT_IMP_pH $36;
if (IMP_pH eq .) then OPT_IMP_pH="04:3.255-high, MISSING";
else
if (IMP_pH < 2.975) then
OPT_IMP_pH = "01:low-2.975";
else
if (IMP_pH >= 2.975 and IMP_pH < 3.075) then
OPT_IMP_pH = "02:2.975-3.075";
else
if (IMP_pH >= 3.075 and IMP_pH < 3.255) then
OPT_IMP_pH = "03:3.075-3.255";
else
if (IMP_pH >= 3.255) then
OPT_IMP_pH = "04:3.255-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: VolatileAcidity , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_VolatileAcidity = 'Transformed VolatileAcidity';
length OPT_VolatileAcidity $36;
if (VolatileAcidity eq .) then OPT_VolatileAcidity="04:0.3125-high, MISSING";
else
if (VolatileAcidity < -1.0425) then
OPT_VolatileAcidity = "01:low--1.0425";
else
if (VolatileAcidity >= -1.0425 and VolatileAcidity < -0.095) then
OPT_VolatileAcidity = "02:-1.0425--0.095";
else
if (VolatileAcidity >= -0.095 and VolatileAcidity < 0.3125) then
OPT_VolatileAcidity = "03:-0.095-0.3125";
else
if (VolatileAcidity >= 0.3125) then
OPT_VolatileAcidity = "04:0.3125-high, MISSING";
*------------------------------------------------------------*;
* TOOL: Score Node;
* TYPE: ASSESS;
* NODE: Score;
*------------------------------------------------------------*;

/*logistic hurdle (first part: predict if wine will be bought Target>0)*/
P_Logit_Hurdle2 = 2.2874
+ M_STARS	 											*	-2.2874
+ IMP_STARS	 											*	0.6508
+ (OPT_VolatileAcidity	in("01:low--1.0425"))			*	0.4811
+ (OPT_VolatileAcidity	in("02:-1.0425--0.095"))		*	0.1929
+ (OPT_VolatileAcidity	in("03:-0.095-0.3125"))			*	0.3547
+ SQR_AcidIndex											*	-0.0132
+ (OPT_IMP_TotalSulfurDioxide	in("01:low--10.5"))		*	-0.2993
+ (OPT_IMP_TotalSulfurDioxide	in("02:-10.5-80.5"))	*	-0.7178
+ (OPT_IMP_TotalSulfurDioxide	in("03:80.5-145.5"))	*	-0.00897
+ (OPT_Density	in("01:low-0.9829"))					*	0.00459
+ (OPT_Density	in("02:0.9829-0.993025"))				*	0.2798
+ (OPT_Density	in("03:0.993025-1.002255, MISSING"))	*	-0.0608
+ (OPT_IMP_Alcohol	in("01:low-9.05"))					*	0.2685
+ (OPT_IMP_Alcohol	in("02:9.05-9.7666667"))			*	0.0889
+ (OPT_IMP_Alcohol	in("03:9.7666667-10.866667"))		*	0.1886
+ (OPT_IMP_Chlorides	in("01:low-0.0075"))			*	-0.0286
+ (OPT_IMP_Chlorides	in("02:0.0075-0.0575, MISSING"))*	0.2730
+ (OPT_IMP_Chlorides	in("03:0.0575-0.1345"))			*	-0.4165
+ (OPT_IMP_Sulphates	in("01:low--0.085"))			*	0.1870
+ (OPT_IMP_Sulphates	in("02:-0.085-0.435"))			*	0.3718
+ (OPT_IMP_Sulphates	in("03:0.435-0.555"))			*	0.2044
+ (OPT_CitricAcid	in("01:low-0.195"))					*	-0.1836
+ (OPT_CitricAcid	in("02:0.195-0.285"))				*	0.2026
+ (OPT_CitricAcid	in("03:0.285-0.385"))				*	0.0698
+ (OPT_IMP_FreeSulfurDioxide	in("01:low--1.75"))		*	-0.2051
+ (OPT_IMP_FreeSulfurDioxide	in("02:-1.75-22.5"))	*	-0.4040
+ (OPT_IMP_FreeSulfurDioxide	in("03:22.5-41.75"))	*	-0.1148
;

P_Logit_Hurdle2 = exp(P_Logit_Hurdle2) / (1+exp(P_Logit_Hurdle2));

/*genmod hurdle (second part: predict how much will be bought)*/
P_Genmod_Hurdle2=
1.1791
+ (LabelAppeal	in("-2"))							*	-1.4335
+ (LabelAppeal	in("-1"))							*	-0.7824
+ (LabelAppeal	in("0"))							*	-0.4266
+ (LabelAppeal	in("1"))							*	-0.1860

+ IMP_STARS	 										*	0.1214

+ (OPT_IMP_Alcohol	in("01:low-9.05"))				*	-0.0912
+ (OPT_IMP_Alcohol	in("02:9.05-9.7666667"))		*	-0.1616
+ (OPT_IMP_Alcohol	in("03:9.7666667-10.866667"))	*	-0.0947

+ (M_STARS	in("0"))									*	0.1616

+ (OPT_VolatileAcidity	in("01:low--1.0425"))		*	0.0412
+ (OPT_VolatileAcidity	in("02:-1.0425--0.095"))	*	0.0225
+ (OPT_VolatileAcidity	in("03:-0.095-0.3125"))		*	0.0432

+ SQR_AcidIndex	 									*	-0.0007

+ (OPT_IMP_Sulphates	in("01:low--0.085"))		*	-0.0158
+ (OPT_IMP_Sulphates	in("02:-0.085-0.435"))		*	-0.0157
+ (OPT_IMP_Sulphates	in("03:0.435-0.555"))		*	-0.0445

+ (OPT_IMP_FreeSulfurDioxide in("01:low--1.75"))	*	-0.0075
+ (OPT_IMP_FreeSulfurDioxide in("02:-1.75-22.5"))	*	-0.0538
+ (OPT_IMP_FreeSulfurDioxide in("03:22.5-41.75"))	*	0.0321

+ (OPT_IMP_ResidualSugar	in("01:low-1.475"))		*	0.0019
+ (OPT_IMP_ResidualSugar	in("02:1.475-4.55"))	*	0.0317
+ (OPT_IMP_ResidualSugar	in("03:4.55-7.225"))	*	0.0250
;

P_Genmod_Hurdle2 = exp(P_Genmod_Hurdle2)+1;

P_Target_HURDLE2 = P_Logit_Hurdle2 * P_Genmod_Hurdle2;

run;
proc means data=Mod5score min mean max n;
run;


data Mod5output;
set Mod5score;
keep index;
keep target;
keep P_Target_HURDLE2;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Mod5output;
set Mod5output;
run;

proc print data=Mod5output;
run;

/***********************************************************************
*                                                                      *
*               Compare All Models for Model Selection                 *
*                                                                      *
***********************************************************************/

%let Combine_x_All = Combine_x_All;

/*create data file with the x_predicted values from the wine data regression
procedure (not the data step)*/
data Compare_x_1_4;
set outfile4_1;

x_hurdle = x_Logit_Hurdle * (x_Genmod_Hurdle+1);

keep 
Index
Target
x_Reg
x_nb
x_poi
x_hurdle;
run;


data Compare_x_5;
set outfile5_1;

x_Hurdle2 = x_Logit_Hurdle2 * (x_Genmod_Hurdle2+1);

keep Index Target x_Hurdle2;
run;

proc means data=compare_x_5 min mean max;
run;

Data &Combine_x_All.;
	merge Compare_x_1_4 Compare_x_5;
	by Index;
x_Ensemble = (x_Reg + x_NB + x_POI + x_Hurdle + x_hurdle2)/5;
run;

proc print data=&Combine_x_All. (obs=10);
run;

/*create data file with the P_Target from the data step*/
Data Combine_P_All;
	merge mod1output mod2output mod3output mod4output mod5output;
	by Index;


proc means data=&combine_x_all sum;
var
target
x_Reg
x_poi 
x_nb
x_HURDLE
x_HURDLE2
x_Ensemble;
run;

/*Compare Models*/
%macro FIND_ERROR( DATAFILE, P, MEANVAL );

%let ERRFILE 	= ERRFILE;
%let MEANFILE	= MEANFILE;

data &ERRFILE.;
set &DATAFILE;
	ERROR_MEAN			= abs( Target - &MEANVAL.)		**&P.;
	ERROR_REGRESSION	= abs( Target - x_Reg) 			**&P.;
	ERROR_POI			= abs( Target - x_poi )			**&P.;
	ERROR_NB			= abs( Target - x_nb )			**&P.;
	ERROR_HURDLE		= abs( Target - x_HURDLE )		**&P.;
	ERROR_HURDLE2		= abs( Target - x_HURDLE2)		**&P.;
	ERROR_ENSEMBLE		= abs( Target - x_Ensemble )	**&P.;	
run;


proc means data=&ERRFILE. noprint;
output out=&MEANFILE.
	mean(ERROR_MEAN)		=	ERROR_MEAN
	mean(ERROR_REGRESSION) 	= 	ERROR_REGRESSION
	mean(ERROR_POI)			=	ERROR_POI
	mean(ERROR_NB)			=	ERROR_NB
	mean(ERROR_HURDLE)		=	ERROR_HURDLE
	mean(ERROR_HURDLE2)		=	ERROR_HURDLE2
	mean(ERROR_ENSEMBLE)	=	ERROR_ENSEMBLE	
	;
run;

data &MEANFILE.;
length P 8.;
set &MEANFILE.;
	P					= &P.;
	ERROR_MEAN			= ERROR_MEAN		** (1.0/&P.);
	ERROR_REGRESSION	= ERROR_REGRESSION  ** (1.0/&P.);
	ERROR_POI 			= ERROR_POI			** (1.0/&P.);
	ERROR_NB 			= ERROR_NB			** (1.0/&P.);
	ERROR_HURDLE 		= ERROR_HURDLE		** (1.0/&P.);
	ERROR_HURDLE2 		= ERROR_HURDLE2		** (1.0/&P.);
	ERROR_ENSEMBLE		= ERROR_ENSEMBLE 	** (1.0/&P.);
	drop _TYPE_;
run;

proc print data=&MEANFILE.;
run;

%mend;

%FIND_ERROR( &Combine_x_All., 1.5	, 3.029);
%FIND_ERROR( &Combine_x_All., 2		, 3.029);

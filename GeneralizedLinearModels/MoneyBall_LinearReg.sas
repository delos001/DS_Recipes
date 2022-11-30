


libname mydata '/folders/myfolders/sasuser.v94/Unit01/MoneyBall' access=readonly;

data mbraw;
set mydata.moneyball;
/*rename column headers to fit better in plots*/

proc contents data=mbraw;

data mbraw1;
set mbraw;
BATTING_H = TEAM_BATTING_H;
BATTING_2B = TEAM_BATTING_2B;
BATTING_3B = TEAM_BATTING_3B;
BATTING_HR = TEAM_BATTING_HR;
BATTING_BB = TEAM_BATTING_BB;
BATTING_SO = TEAM_BATTING_SO;
BASERUN_SB = TEAM_BASERUN_SB;
BASERUN_CS = TEAM_BASERUN_CS;
BATTING_HBP = TEAM_BATTING_HBP;
PITCHING_H = TEAM_PITCHING_H;
PITCHING_HR = TEAM_PITCHING_HR;
PITCHING_BB = TEAM_PITCHING_BB;
PITCHING_SO = TEAM_PITCHING_SO;
FIELDING_E = TEAM_FIELDING_E;
FIELDING_DP = TEAM_FIELDING_DP;

drop TEAM_BATTING_H
TEAM_BATTING_2B
TEAM_BATTING_3B
TEAM_BATTING_HR
TEAM_BATTING_BB
TEAM_BATTING_SO
TEAM_BASERUN_SB
TEAM_BASERUN_CS
TEAM_BATTING_HBP
TEAM_PITCHING_H
TEAM_PITCHING_HR
TEAM_PITCHING_BB
TEAM_PITCHING_SO
TEAM_FIELDING_E
TEAM_FIELDING_DP
;
run;
/*note: run mbraw to make sure the code above keeps values the same*/
proc means data=mbraw min mean median max stddev n nmiss;
proc means data=mbraw1 min mean median max stddev n nmiss;
/****************************************************************/
/****************************************************************/
/****************************************************************/
/*EDA START
note: run mbraw to make sure the code above keeps values the same*/
proc contents data=mbraw1;
proc means data=mbraw1 min mean median max stddev n nmiss;

/*Review Target_Wins*/
/*Min and max threshold for minimum wins and maximum
wins (based on 1st and 99th percentile)*/
proc means data=mbraw1 min p1 p5 mean median p95 p99 max;
var target_wins;
run;

data mbraw2;
	set mbraw1;
if Target_Wins=0 then delete;
run;
proc contents data=mbraw2;
proc means data=mbraw2 min p1 p5 mean median p95 p99 max stddev n nmiss;
	var target_wins;
run;

/*CREATE HISTOGRAM FOR VARIABLES WITH MISSING DATA
excludes Team_Batting_HBP due to excessive missing variables*/
ods graphics on;
proc sgplot data=mbraw2;
	histogram BATTING_SO ;
run;
/*resut: bimodal, use mean for now*/

proc sgplot data=mbraw2;
	histogram BASERUN_SB;
run;
/*result: significant right skew, use median*/

proc sgplot data=mbraw2;
	histogram BASERUN_CS;
run;
/*result: moderate right skew, use median*/

proc sgplot data=mbraw2;
	histogram PITCHING_SO;
run;
/*result: significant righ skew and outliers, poosible data entry error*/

proc sgplot data=mbraw2;
	histogram FIELDING_DP;
run;
ods graphics off;
/*result: relatively normal appearing distribution, use mean*/
/*drop the hit by pitch variable due to high missing value
Use mean or median based on histogram plots above*/

data mbraw2;
set mbraw2;
	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =735;
	if missing(BASERUN_SB) then BASERUN_SB =101;
	if missing(BASERUN_CS) then BASERUN_CS =49;
	if missing(PITCHING_SO) then PITCHING_SO =813;
	if missing(FIELDING_DP) then FIELDING_DP =146;
run;
proc means data=mbraw2 min p5  median mean p95 max stddev n nmiss;
run;
/*END MISSING DATA HANDLING*/


/*PROC UNIVARIATE*/
ods graphics on;
proc univariate normal plot data=mbraw2;
	var Target_Wins FIELDING_E;
	histogram Target_Wins FIELDING_E/normal (color=red w=2);
run;

proc univariate normal plot data=mbraw2;
	var BATTING_H
		BATTING_2B
		BATTING_3B
		BATTING_HR
		BATTING_BB
		BATTING_SO
		BASERUN_SB
		BASERUN_CS
		PITCHING_H
		PITCHING_HR
		PITCHING_BB
		PITCHING_SO
		FIELDING_E
		FIELDING_DP;
	histogram 	BATTING_H
				BATTING_2B
				BATTING_3B
				BATTING_HR
				BATTING_BB
				BATTING_SO
				BASERUN_SB
				BASERUN_CS
				PITCHING_H
				PITCHING_HR
				PITCHING_BB
				PITCHING_SO
				FIELDING_E
				FIELDING_DP/normal (color=red w=2);
run;
ods graphics off;

data mbraw2;
set mbraw2;
capTarget_Wins=Target_Wins;
if capTarget_Wins<36 then capTarget_Wins=36;
run;

ods graphics on;
proc univariate normal plot data=mbraw2;
	var capTarget_Wins;
	histogram capTarget_Wins /normal (color=red w=2);
run;

proc univariate normal plot data=mbraw2;
	var Target_Wins;
	histogram Target_Wins /normal (color=red w=2);
run;
ods graphics off;

/*PEARSON COEFFICIENT ALL variables with Target_Wins Excludes 
Team_Batting_HBP due to excessive missing variables*/
ods graphics on;
title "Pearson Coefficient: All Variables with capTarget_Wins";
proc corr data=mbraw2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_SB BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP;
		with capTarget_Wins;
run;

title "Pearson Coefficient: All Variables with Target_Wins";
proc corr data=mbraw2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_SB BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP;
		with Target_Wins;
run;

/*capping target wins has slightly overall negative impact on variable
correlation so capTarget wins is dropped for now*/
data mbraw2;
set mbraw2;
	drop capTarget_Wins;
run;

/*PEARSON COEFFICIENTS and Scatter Plots By Variable Group*/
/*Batting correlation*******************************************************/
title "Proc Corr Matrix Batting vs. Target Wins";
title2 "Batting With Target Wins";
proc corr data=mbraw2 rank  plots(Maxpoints=none)=matrix(histogram nvar=all) ;
 	var BATTING_H BATTING_2B BATTING_3B  ;
	with Target_Wins;
run;
title "Proc Corr Matrix Batting vs. Target Wins";
title2 "Batting With Target Wins";	
proc corr data=mbraw2 rank  plots(Maxpoints=none)=matrix(histogram nvar=all) ;
 	var BATTING_HR BATTING_BB BATTING_SO ;
	with Target_Wins;
run;

title "Scatter Plot Matrix within Variable Grouping";
title2 "Batting";
proc corr data=mbraw2 plot(maxpoints=none)=matrix(histogram nvar=all);
	var BATTING_H BATTING_2B BATTING_3B
		BATTING_HR BATTING_BB BATTING_SO ;
run;

/*Baserun correlation*********************************************************/
title "Proc Corr Matrix";
title2 "Baserun With Target Wins";
proc corr data=mbraw2 rank nosimple plots(Maxpoints=none)=matrix(histogram nvar=all);
 	var BASERUN_SB BASERUN_CS;
	with Target_Wins;
run;

title "Scatter Plot Matrix within Variable Grouping";
title2 "Baserun";
proc corr data=mbraw2 plot(maxpoints=none)=matrix(histogram nvar=all);
	var BASERUN_SB BASERUN_CS ;
run;

/*Pitching correlation*********************************************************/
title "Proc Corr Matrix Pitching vs. Target Wins";
title2 "Pitching With Target Wins";
proc corr data=mbraw2 rank nosimple plots(Maxpoints=none)=matrix(histogram nvar=all);
 	var PITCHING_H PITCHING_HR PITCHING_BB PITCHING_SO;
	with Target_Wins;
run;

title "Scatter Plot Matrix within Variable Grouping";
title2 "Pitching";
proc corr data=mbraw2 plot(maxpoints=none)=matrix(histogram nvar=all);
	var PITCHING_H PITCHING_HR PITCHING_BB PITCHING_SO;
run;

/*Fielding correlation*/
title "Proc Corr Matrix Fielding vs. Target Wins";
title2 "Fielding With Target Wins";
proc corr data=mbraw2 rank nosimple plots(Maxpoints=none)=matrix(histogram nvar=all);
 	var FIELDING_E FIELDING_DP;
	with Target_Wins;
run;

title "Scatter Plot Matrix within Variable Grouping";
title2 "Fielding";
proc corr data=mbraw2 plot(maxpoints=none)=matrix(histogram nvar=all);
	var FIELDING_E FIELDING_DP;
run;
ods graphics off;

/****************************************************************/
/****************************************************************/
/****************************************************************/
/*END EDA*/


/*MODEL 1: STEPWISE SELECTION ON TRANSFORMED DEPENDENT VARIABLE*/
/*transform dependent variable with various transformations for a
stepwise regression check/baseline model*/
data mbmod1a;
set mbraw2;
sqTarget_Wins = (Target_Wins)**2;
logTarget_Wins = log(Target_Wins);
log2Target_Wins = log(Target_Wins)**2;
hlfPTarget_Wins = (Target_Wins)**0.5;
neghlfPTarget_Wins = (Target_Wins)**-0.5;
recipTarget_Wins = (Target_Wins)**-1;
run;
/* note tried multiple transformations: all resulted in more
extreme deivation from normality than the non-transformed 
dependent variable*/

proc means data=mbraw2 min max median mean n nmiss;
run;
ods graphics on;
proc univariate normal plot data=mbmod1a;
	var Target_Wins
		sqTarget_Wins 
		logTarget_Wins
		log2Target_Wins
		hlfPTarget_Wins
		neghlfPTarget_Wins
		recipTarget_Wins;
	histogram 	Target_Wins
				sqTarget_Wins 
				logTarget_Wins
				log2Target_Wins
				hlfPTarget_Wins
				neghlfPTarget_Wins
				recipTarget_Wins/normal (color=red w=2);
run;
ods graphics off;

proc reg data=mbmod1a;
	model 
Target_Wins
			sqTarget_Wins 
			logTarget_Wins
			log2Target_Wins
			hlfPTarget_Wins
			neghlfPTarget_Wins
			recipTarget_Wins
						 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=stepwise vif;
run;
/*note: also tried log square of capped target wins and captarget wins sq'd
but results were poor*/
/*Let SAS find model with best R-sq value:
recip_target_wins had highest adj rsq value of 0.3736 (rsq:0.3766)
BATTING_H	BATTING_2B BATTING_3B BATTING_BB BASERUN_SB	PITCHING_H PITCHING_HR 
PITCHING_BB	PITCHING_SO	FIELDING_E FIELDING_DP

neghPTarget_Wins had second highest adj rsq value of 0.3628 (rsq:3656)
BATTING_H BATTING_2B BATTING_3B BASERUN_SB PITCHING_H PITCHING_HR PITCHING_BB 
PITCHING_SO	FIELDING_E FIELDING_DP*/

proc reg data=mbmod1a;
	model 
			sqTarget_Wins 
			logTarget_Wins
			log2Target_Wins
			hlfPTarget_Wins
			neghlfPTarget_Wins
			recipTarget_Wins
						 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run;  
/*recipTarget_wins gave rsq of 0.3545 with 5 variables:
BATTING_H PITCHING_H PITCHING_BB FIELDING_E FIELDING_DP

neghPTarget_wins gave rsq of 0.3443 with 5 variables (adjrsq=
BATTING_H PITCHING_H PITCHING_BB FIELDING_E FIELDING_DP*/

/*get proc reg stats using the 5 selected from above*/
proc reg data=mbmod1a;
	model recipTarget_Wins=	BATTING_H PITCHING_H PITCHING_BB FIELDING_E FIELDING_DP;
run;

proc reg data=mbmod1a;
	model neghlfPTarget_Wins=BATTING_H PITCHING_H PITCHING_BB FIELDING_E FIELDING_DP;
run;

/*use adjrsq aic and bic as variable selection method*/
proc reg data=mbmod1a outest=rsqestimate;
	model 
		Target_Wins
		recipTarget_Wins
		neghlfPTarget_Wins
						 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection= ADJRSQ aic bic;
run;
/*
recipTargetWins: 0.3737	0.3770 BATTING_H BATTING_2B BATTING_3B BATTING_BB 
BATTING_SO BASERUN_SB PITCHING_H PITCHING_HR PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP

neghPTargetWins:0.3630	0.3661 BATTING_H BATTING_2B BATTING_3B BATTING_BB 
BASERUN_SB PITCHING_H PITCHING_HR PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP
*/

/*print the above model sorted by each variable selector*/
proc sort data=rsqestimate; by _aic_;
proc print data=rsqestimate;
run;
/*lowest aic:-26255.43 
BATTING_H BATTING_2B BATTING_3B BATTING_BB BASERUN_SB PITCHING_H PITCHING_HR PITCHING_BB PITCHING_SO 
FIELDING_E FIELDING_DP*/

proc sort data=rsqestimate; by _bic_;
proc print data=rsqestimate;
run;
/*lowest bic: -27336.18 (corresponds to lowest aic above)
BATTING_H BATTING_2B BATTING_3B BATTING_BB BASERUN_SB PITCHING_H PITCHING_HR PITCHING_BB 
PITCHING_SO FIELDING_E FIELDING_DP*/

/*TEST THE MODELS WITH BEST SELECTION CRITERIA*/
/*1: 
recip_target_wins had highest adj rsq value of 0.3736 (rsq:0.3766)*/
proc reg data=mbmod1a;
	model
		recipTarget_Wins=
							BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_BB
							BASERUN_SB
							PITCHING_H
							PITCHING_HR
							PITCHING_BB	
							PITCHING_SO	
							FIELDING_E 
							FIELDING_DP;
run;

/*2:
neghPTargetWins:0.3630	0.3661*/
proc reg data=mbmod1a;
	model
		neghlfPTarget_Wins=
							BATTING_H
							BATTING_2B
							BATTING_3B
							/*BATTING_BB not sig so removed*/
							BASERUN_SB
							PITCHING_H
							PITCHING_HR
							PITCHING_BB	
							PITCHING_SO	
							FIELDING_E 
							FIELDING_DP;
run;

/*3:
neglfPtargetwins: adj rsq value of 0.3628 (rsq:3656) */
proc reg data=mbmod1a;
	model
		neghlfPTarget_Wins=
							BATTING_H
							BATTING_2B
							BATTING_3B
							BASERUN_SB
							PITCHING_H
							PITCHING_HR
							PITCHING_BB	
							PITCHING_SO	
							FIELDING_E 
							FIELDING_DP;
run;

/*4:
recipTarget_wins: adjrsq 0.3737*/
proc reg data=mbmod1a;
	model
		recipTarget_Wins=
							BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_BB
							/*BATTING_SO *not sig so removed*/
							BASERUN_SB
							PITCHING_H
							PITCHING_HR
							PITCHING_BB	
							PITCHING_SO	
							FIELDING_E 
							FIELDING_DP;
run;

/*5:
rsq best 5: rsq 0.3545 (adjrsq:0.3530)*/
proc reg data=mbmod1a;
	model
		recipTarget_Wins=
							BATTING_H
							PITCHING_H
							PITCHING_BB	
							FIELDING_E 
							FIELDING_DP;
run;


/*DEPLOY MODEL 1*/
/****************************************************************/
/****************************************************************/
/*stand alone data step.  going to use the moneyball_test file
whatever you did with the original data, you have to put in the scoring step too*/

libname mydata '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data scorefilea;
set mydata.moneyball_test;

BATTING_H = TEAM_BATTING_H;
BATTING_2B = TEAM_BATTING_2B;
BATTING_3B = TEAM_BATTING_3B;
BATTING_HR = TEAM_BATTING_HR;
BATTING_BB = TEAM_BATTING_BB;
BATTING_SO = TEAM_BATTING_SO;
BASERUN_SB = TEAM_BASERUN_SB;
BASERUN_CS = TEAM_BASERUN_CS;
BATTING_HBP = TEAM_BATTING_HBP;
PITCHING_H = TEAM_PITCHING_H;
PITCHING_HR = TEAM_PITCHING_HR;
PITCHING_BB = TEAM_PITCHING_BB;
PITCHING_SO = TEAM_PITCHING_SO;
FIELDING_E = TEAM_FIELDING_E;
FIELDING_DP = TEAM_FIELDING_DP;

drop TEAM_BATTING_H
TEAM_BATTING_2B
TEAM_BATTING_3B
TEAM_BATTING_HR
TEAM_BATTING_BB
TEAM_BATTING_SO
TEAM_BASERUN_SB
TEAM_BASERUN_CS
TEAM_BATTING_HBP
TEAM_PITCHING_H
TEAM_PITCHING_HR
TEAM_PITCHING_BB
TEAM_PITCHING_SO
TEAM_FIELDING_E
TEAM_FIELDING_DP
;
	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =735;
	if missing(BASERUN_SB) then BASERUN_SB =101;
	if missing(BASERUN_CS) then BASERUN_CS =49;
	if missing(PITCHING_SO) then PITCHING_SO =813;
	if missing(FIELDING_DP) then FIELDING_DP =146;
	if Target_Wins=0 then delete;

/*this is from the regression model output.  the parameter estimates are added
to each variable from the deployed model*/
P_TARGET_WINS = 
				(0.17299

+  BATTING_H	  *  -0.00005233
+  BATTING_2B	  *  0.00002773
+  BATTING_3B	  *  -0.00004564
+  BATTING_BB	  *  0.00000404	
+  BASERUN_SB	  *  -0.00001628
+  PITCHING_H	  *  0.00000276
+  PITCHING_HR  *  -0.00002901
+  PITCHING_BB	  *  -0.00000934
+  PITCHING_SO	  *  -0.00000237
+  FIELDING_E	  *  0.00002309
+  FIELDING_DP	  *  0.00009946)**-2
;
run;

proc means data=scorefilea min p1 p5 mean p95 p99 max;

/*if there are outliers such as negative wins, from the score file, cap them
based on the p1 and p99 results from the EDA step*/
data scorefiletrim;
set scorefilea;
if P_TARGET_WINS < 38 then P_TARGET_WINS = 38;
if P_TARGET_WINS > 114 then P_TARGET_WINS = 114;

keep index;
keep P_TARGET_WINS;

proc means data=scorefiletrim min p1 p5 mean p95 p99 max;
proc print data=scorefiletrim(obs=5);
run;

libname outfile '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data outfile.DeloshFile;
set scorefiletrim;
run;
proc print data=outfile.DeloshFile;
run;
/*this file should appear in the moneyball folder.  Download it using buttons in top
left pane, then email the file to the Professor*/
/***********************************************************/
/***********************************************************/
/***********************************************************/


/*MODEL 2*/
/****************************************************************/
/****************************************************************/
/*Based on correlation values an potential multicorrelation between 
group variables (batting, fielding, pitching, baseruning), the following
variables were selected*/                         

data mbmod2;
set mbraw1;
/*get rid of the observations that appear to be data entry error*/
if Target_Wins=0 then delete;
if Pitching_BB=0 then delete;
run;
proc means data=mbraw1 min p1 p5 mean p95 p99 max nmiss;
proc means data=mbmod2 min p1 p5 mean p95 p99 max nmiss;
/*look at correlations to find imputation method*/
ods graphics on;
title "Pearson Coefficient: All Variables with BATTING_SO";
proc corr data=mbmod2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BASERUN_SB BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP;
		with BATTING_SO;
run;

title "Pearson Coefficient: All Variables with BASERUN_SB";
proc corr data=mbmod2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP;
		with BASERUN_SB;
run;

title "Pearson Coefficient: All Variables with BASERUN_CS";
proc corr data=mbmod2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_SB PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E FIELDING_DP;
		with BASERUN_CS;
run;

title "Pearson Coefficient: All Variables with PITCHING_SO";
proc corr data=mbmod2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_SB BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB FIELDING_E FIELDING_DP;
		with PITCHING_SO;
run;

title "Pearson Coefficient: All Variables with FIELDING_DP";
proc corr data=mbmod2 nosimple rank;
	var BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_BB
		BATTING_SO BASERUN_SB BASERUN_CS PITCHING_H PITCHING_HR 
		PITCHING_BB PITCHING_SO FIELDING_E ;
		with FIELDING_DP;
run;
ods graphics off;

proc reg data=mbmod2;
	model 
			BATTING_SO	 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run;
/*	BATTING_H BATTING_HR PITCHING_H PITCHING_SO*/
proc reg data=mbmod2;
	model BATTING_SO=BATTING_H BATTING_HR PITCHING_H;
run;

proc reg data=mbmod2;
	model 
			BASERUN_SB	 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run;
/*BATTING_H BATTING_HR BATTING_SO BASERUN_CS FIELDING_E
rsq 0.5730*/
proc reg data=mbmod2;
	model BASERUN_SB=BATTING_H BATTING_HR;
run;

proc reg data=mbmod2;
	model 
			BASERUN_CS	 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run;
/*BATTING_HR BATTING_BB BATTING_SO BASERUN_SB FIELDING_E
rsq 0.6404*/
proc reg data=mbmod2;
	model BASERUN_CS=BATTING_HR BATTING_BB FIELDING_E;
run;

proc reg data=mbmod2;
	model 
			PITCHING_SO	 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run;
/*BATTING_H BATTING_HR BATTING_SO PITCHING_H PITCHING_HR
rsq 0.9973*/
proc reg data=mbmod2;
	model PITCHING_SO=BATTING_H BATTING_HR PITCHING_H;
run;
			
proc reg data=mbmod2;
	model 
			FIELDING_DP	 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							/selection=rsquare start=1 stop=5;
run;
/*BATTING_H BATTING_BB BATTING_SO BASERUN_SB FIELDING_E
rsq 0.1313*/
proc reg data=mbmod2;
	model FIELDING_DP=BATTING_H BATTING_BB FIELDING_E;
run;

data mbmod2a;
set mbmod2;
	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =
										1507.02701
										+BATTING_H 		-0.71604
										+BATTING_HR 	*	2.87977
										+PITCHING_H 	*	-0.00715;
	
	if missing(BASERUN_SB) then BASERUN_SB =
										74.92559
										+BATTING_H 	*	0.08259
										+BATTING_HR 	*	-0.68196;
	
	if missing(BASERUN_CS) then BASERUN_CS =
										91.87993
										+BATTING_HR 	*	-0.22239
										+BATTING_BB 	* 	-0.01175
										+FIELDING_E 	*	-0.02654;
	
	if missing(PITCHING_SO) then PITCHING_SO =
										2539.55121
										+BATTING_H 	*	-1.62578
										+BATTING_HR 	*	2.83261
										+PITCHING_H 	*	0.21497;
	
	if missing(FIELDING_DP) then FIELDING_DP =
										77.85032
										+BATTING_H  	*	0.04393
										+BATTING_BB 	*	0.04053
										+FIELDING_E 	*	-0.08822;
run;


proc means data=mbmod2 min p1 p5 mean p95 p99 max nmiss;
proc means data=mbmod2a min p1 p5 mean p95 p99 max nmiss;

data mbmod2b;
set mbmod2a;

if Batting_2B < 142 then Batting_2B = 142;
if Batting_3B < 17 then Batting_3B = 17;
if Batting_HR < 5 then Batting_HR = 5;
if Batting_BB < 70 then Batting_BB = 70;
if Batting_SO < 72 then Batting_SO = 72;
if Baserun_SB < 24 then Baserun_SB = 24;
if Baserun_CS < 17 then Baserun_CS = 17;
if Pitching_HR < 8 then Pitching_HR = 8;
if Pitching_BB < 241 then Pitching_BB = 241;
if Pitching_SO < 208 then Pitching_SO = 208;
if Fielding_E < 86 then Fielding_E = 86;
if Fielding_DP < 79 then Fielding_DP = 79;

proc means data=mbmod2b min p1 p5 mean p95 p99 max nmiss;


proc reg data=mbmod2b;
	model 
		Target_Wins		 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=stepwise vif;
run;
/*adjRsq 0.3200
BATTING_H
BATTING_2B
BATTING_3B
BATTING_HR
BATTING_BB
BASERUN_SB
PITCHING_SO
FIELDING_E
FIELDING_DP
*/
/*reg model from stepwise selection above**************/
proc reg data=mbmod2b;
	model
			Target_Wins = 	BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BASERUN_SB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP;
run;

/*best five variable model*/
proc reg data=mbmod2b;
	model 
			Target_Wins  =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection=rsquare start=1 stop=5;
run; 
/*0.3088 BATTING_H BASERUN_SB PITCHING_HR FIELDING_E FIELDING_DP*/
/*reg model from best 5 selection above***************************/
proc reg data=mbmod2b;
	model
		Target_Wins = BATTING_H BASERUN_SB PITCHING_HR FIELDING_E FIELDING_DP;
run;

/*adjrq aic bic selection method*/
proc reg data=mbmod2b outest=rsqestimatemod2;
	model 
		Target_Wins		 =  BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							/selection= ADJRSQ aic bic;
run;
/*adjrsq:0.3088	rsq:0.3124	AIC 11691.5306	BIC:11693.7003	
BATTING_H BATTING_2B BATTING_3B BATTING_HR BATTING_SO BASERUN_SB 
PITCHING_H PITCHING_BB FIELDING_E FIELDING_DP*/
/*reg model using the Adjrsq selection method above*************************/
proc reg data=mbmod2b;
	model
		Target_Wins = 	BATTING_H 
						BATTING_2B 
						BATTING_3B 
						BATTING_HR 
						BATTING_SO 
						BASERUN_SB 
						PITCHING_H 
						PITCHING_BB 
						FIELDING_E 
						FIELDING_DP;
run;

/*print the above model sorted by each variable selector*/
proc sort data=rsqestimatemod2; by _aic_;
proc print data=rsqestimatemod2;
run;
/*rsqr:0.3234	AIC:11649.01	BIC:11651.12
Batting_H Batting_2B Batting_3B Batting_HR Baserun_SB Pitching_H
Pitching_BB Fielding_E Fielding_DP*/

proc sort data=rsqestimatemod2; by _bic_;
proc print data=rsqestimatemod2;
run;
/*rsqr:0.3234	AIC:11649.01	BIC:11651.12
same variables as from the max AIC*/

proc reg data=mbmod2b;
	model
		Target_Wins= 	Batting_H 
						Batting_2B 
						Batting_3B 
						Batting_HR 
						Baserun_SB 
						Pitching_H
						Pitching_BB 
						Fielding_E 
						Fielding_DP;
run;



/*DEPLOY MODEL 2*/
/****************************************************************/
/****************************************************************/
/*stand alone data step.  going to use the moneyball_test file
whatever you did with the original data, you have to put in the scoring step too*/

libname mydata '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data scorefile2;
set mydata.moneyball_test;

BATTING_H = TEAM_BATTING_H;
BATTING_2B = TEAM_BATTING_2B;
BATTING_3B = TEAM_BATTING_3B;
BATTING_HR = TEAM_BATTING_HR;
BATTING_BB = TEAM_BATTING_BB;
BATTING_SO = TEAM_BATTING_SO;
BASERUN_SB = TEAM_BASERUN_SB;
BASERUN_CS = TEAM_BASERUN_CS;
BATTING_HBP = TEAM_BATTING_HBP;
PITCHING_H = TEAM_PITCHING_H;
PITCHING_HR = TEAM_PITCHING_HR;
PITCHING_BB = TEAM_PITCHING_BB;
PITCHING_SO = TEAM_PITCHING_SO;
FIELDING_E = TEAM_FIELDING_E;
FIELDING_DP = TEAM_FIELDING_DP;

drop 
TEAM_BATTING_H
TEAM_BATTING_2B
TEAM_BATTING_3B
TEAM_BATTING_HR
TEAM_BATTING_BB
TEAM_BATTING_SO
TEAM_BASERUN_SB
TEAM_BASERUN_CS
TEAM_BATTING_HBP
TEAM_PITCHING_H
TEAM_PITCHING_HR
TEAM_PITCHING_BB
TEAM_PITCHING_SO
TEAM_FIELDING_E
TEAM_FIELDING_DP
;
if Target_Wins=0 then delete;
if Pitching_BB=0 then delete;


	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =
										1507.02701
										+BATTING_H 		-0.71604
										+BATTING_HR 	*	2.87977
										+PITCHING_H 	*	-0.00715;
	
	if missing(BASERUN_SB) then BASERUN_SB =
										74.92559
										+BATTING_H 	*	0.08259
										+BATTING_HR 	*	-0.68196;
	
	if missing(BASERUN_CS) then BASERUN_CS =
										91.87993
										+BATTING_HR 	*	-0.22239
										+BATTING_BB 	* 	-0.01175
										+FIELDING_E 	*	-0.02654;
	
	if missing(PITCHING_SO) then PITCHING_SO =
										2539.55121
										+BATTING_H 	*	-1.62578
										+BATTING_HR 	*	2.83261
										+PITCHING_H 	*	0.21497;
	
	if missing(FIELDING_DP) then FIELDING_DP =
										77.85032
										+BATTING_H  	*	0.04393
										+BATTING_BB 	*	0.04053
										+FIELDING_E 	*	-0.08822;
if Batting_2B < 142 then Batting_2B = 142;
if Batting_3B < 17 then Batting_3B = 17;
if Batting_HR < 5 then Batting_HR = 5;
if Batting_BB < 70 then Batting_BB = 70;
if Batting_SO < 72 then Batting_SO = 72;
if Baserun_SB < 24 then Baserun_SB = 24;
if Baserun_CS < 17 then Baserun_CS = 17;
if Pitching_HR < 8 then Pitching_HR = 8;
if Pitching_BB < 241 then Pitching_BB = 241;
if Pitching_SO < 208 then Pitching_SO = 208;
if Fielding_E < 86 then Fielding_E = 86;
if Fielding_DP < 79 then Fielding_DP = 79;

/*this is from the regression model output.  the parameter estimates are added
to each variable from the deployed model*/
P_TARGET_WINS =	13.39788
				+BATTING_H		* 0.05559
				+BATTING_2B		* -0.03010
				+BATTING_3B		* 0.06328
				+BATTING_HR		* 0.04682
				+BATTING_BB		* 0.01206
				+BASERUN_SB		* 0.03333
				+PITCHING_SO	* 0.00118
				+FIELDING_E		* -0.03183
				+FIELDING_DP	* -0.13140;
run;

proc means data=scorefile2 min p1 p5 mean p95 p99 max;

/*if there are outliers such as negative wins, from the score file, cap them
based on the p1 and p99 results from the EDA step*/
data scorefile2trim;
set scorefile2;
if P_TARGET_WINS < 38 then P_TARGET_WINS = 38;
if P_TARGET_WINS > 114 then P_TARGET_WINS = 114;

keep index;
keep P_TARGET_WINS;

proc means data=scorefile2trim min p1 p5 mean p95 p99 max;
proc print data=scorefile2trim(obs=5);
run;

libname outfile '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data outfile.DeloshFile2;
set scorefile2trim;
run;
proc print data=outfile.DeloshFile2;
run;
/***********************************************************/
/***********************************************************/
/***********************************************************/


/*MODEL 3*/
/****************************************************************/
/****************************************************************/

data mbmod3;
set mbraw1;
/*get rid of the observations that appear to be data entry error*/
if Target_Wins=0 then delete;
if Pitching_BB=0 then delete;
run;

proc means data=mbmod3 min p1 p5 mean p95 p99 max n nmiss;

data mbmod3a;
set mbmod3;

recipTarget_Wins = (Target_Wins)**-1;

	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =735;
	if missing(BASERUN_SB) then BASERUN_SB =101;
	if missing(BASERUN_CS) then BASERUN_CS =49;
	if missing(PITCHING_SO) then PITCHING_SO =813;
	if missing(FIELDING_DP) then FIELDING_DP =146;
run;

proc means data=mbmod3 min p1 p5 mean p95 p99 max n nmiss;
proc means data=mbmod3a min p5 mean p95 max n nmiss;


data mbmod3b;
set mbmod3a;

if Batting_H < 1195 then Batting_H = 1195;
if Batting_H > 1696 then Batting_H = 1696;

if Batting_2B < 167 then Batting_2B = 167;
if Batting_2B > 320 then Batting_2B = 1320;

if Batting_3B < 23 then Batting_3B = 23;
if Batting_3B > 108 then Batting_3B = 108;

if Batting_HR < 14 then Batting_HR = 14;
if Batting_HR > 199 then Batting_HR = 199;

if Batting_BB < 249 then Batting_BB = 249;
if Batting_BB > 671 then Batting_BB = 671;

if Batting_SO < 364 then Batting_SO = 364;
if Batting_SO > 1239 then Batting_SO = 1239;

if Baserun_SB < 36 then Baserun_SB = 36;
if Baserun_SB > 298 then Baserun_SB = 298;

if Baserun_CS < 27 then Baserun_CS = 27;
if Baserun_CS > 83 then Baserun_CS = 83;

if Pitching_H < 1316 then Pitching_H = 1316;
if Pitching_H > 2563 then Pitching_H = 2563;

if Pitching_HR < 18 then Pitching_HR = 18;
if Pitching_HR > 210 then Pitching_HR = 210;

if Pitching_BB < 377 then Pitching_BB = 377;
if Pitching_BB > 757 then Pitching_BB = 757;

if Pitching_SO < 420 then Pitching_SO = 420;
if Pitching_SO > 1169 then Pitching_SO = 1169;

if Fielding_E < 100 then Fielding_E = 100;
if Fielding_E > 716 then Fielding_E = 716;

if Fielding_DP < 87 then Fielding_DP = 87;
if Fielding_DP > 184 then Fielding_DP = 184;

ods graphics on;

proc means data=mbmod3b min p5 mean p95 max n nmiss;

proc princomp data=mbmod3b

	out=pca_output
	outstat=eigenvectors
	plots=scree(unpackpanel);
run;
ods graphics off;

data pcamod3b;
	merge pca_output mbmod3(keep=Target_Wins);
run;

ods graphics on;
proc reg data=pcamod3b;
	model Target_Wins = prin1-prin8 / vif;
	output out=model3_output predicted=Yhat;
	run;
ods graphics off;

data mbmod3c;
set mbmod3b;

HitPerc = Batting_H/(Batting_H+Batting_BB+Batting_SO);
WeightHits = (2*Batting_2B+3*Batting_3B+4*Batting_HR)/Batting_H;
StealPerc = Baserun_SB/(Baserun_CS+Baserun_SB);
PitchEffic = Pitching_SO/(Pitching_SO+Pitching_H+Pitching_BB);
FieldEffic = Fielding_E/Pitching_H;
run;
proc means data=mbmod3c min p1 p5 mean p95 p99 max n nmiss;

/*
OnBasePerc
WeightHits
StealPerc
Bat_Pitch
PitchEffic
FieldEffic
*/

ods graphics on;
proc univariate normal plot data=mbmod3c;
	var HitPerc
		WeightHits
		StealPerc
		PitchEffic
		FieldEffic;
	histogram 	HitPerc
				WeightHits
				StealPerc
				PitchEffic
				FieldEffic/normal (color=red w=2);
run;
ods graphics off;



data mbmod3d;
set mbmod3c;
tHitPerc 	= log(HitPerc); /**/
tWeightHits = log(WeightHits); /**/
tStealPerc  = log(StealPerc); /**/
tPitchEffic = log(PitchEffic); /**/
tFieldEffic = log(FieldEffic);/**/
run;

proc means data=mbmod3d min p1 p5 mean p95 p99 max n nmiss;

ods graphics on;
proc univariate normal plot data=mbmod3d;
	var tHitPerc
		tWeightHits
		tStealPerc
		tPitchEffic
		tFieldEffic;
	histogram 	tHitPerc
				tWeightHits
				tStealPerc
				tPitchEffic
				tFieldEffic/normal (color=red w=2);
run;
ods graphics off;

proc reg data=mbmod3d ;
	model 
		Target_Wins=  		tWeightHits
							tStealPerc
							tPitchEffic
							tFieldEffic
							BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							FIELDING_DP
							/selection=ADJRSQ vif;
run;
/*							tWeightHits
							BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							BATTING_BB
							BATTING_SO
							BASERUN_SB
							BASERUN_CS
							PITCHING_H
							PITCHING_HR
							PITCHING_BB
							PITCHING_SO
							FIELDING_E
							FIELDING_DP
							*/
proc reg data=mbmod3d ;
	model 
		Target_Wins=  		tWeightHits
							tStealPerc
							tPitchEffic
							tFieldEffic
							BATTING_H
							BATTING_2B
							BATTING_3B
							BATTING_HR
							FIELDING_DP;
run;

/*DEPLOY MODEL 3*/
/****************************************************************/
/****************************************************************/
/*stand alone data step.  going to use the moneyball_test file
whatever you did with the original data, you have to put in the scoring step too*/

libname mydata '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data scorefile3;

set mydata.moneyball_test;

BATTING_H = TEAM_BATTING_H;
BATTING_2B = TEAM_BATTING_2B;
BATTING_3B = TEAM_BATTING_3B;
BATTING_HR = TEAM_BATTING_HR;
BATTING_BB = TEAM_BATTING_BB;
BATTING_SO = TEAM_BATTING_SO;
BASERUN_SB = TEAM_BASERUN_SB;
BASERUN_CS = TEAM_BASERUN_CS;
BATTING_HBP = TEAM_BATTING_HBP;
PITCHING_H = TEAM_PITCHING_H;
PITCHING_HR = TEAM_PITCHING_HR;
PITCHING_BB = TEAM_PITCHING_BB;
PITCHING_SO = TEAM_PITCHING_SO;
FIELDING_E = TEAM_FIELDING_E;
FIELDING_DP = TEAM_FIELDING_DP;

drop 
TEAM_BATTING_H
TEAM_BATTING_2B
TEAM_BATTING_3B
TEAM_BATTING_HR
TEAM_BATTING_BB
TEAM_BATTING_SO
TEAM_BASERUN_SB
TEAM_BASERUN_CS
TEAM_BATTING_HBP
TEAM_PITCHING_H
TEAM_PITCHING_HR
TEAM_PITCHING_BB
TEAM_PITCHING_SO
TEAM_FIELDING_E
TEAM_FIELDING_DP
Target_Wins
;

if Target_Wins=0 then delete;
if Pitching_BB=0 then delete;
	drop Batting_HBP;
	if missing(BATTING_SO) then BATTING_SO =735;
	if missing(BASERUN_SB) then BASERUN_SB =101;
	if missing(BASERUN_CS) then BASERUN_CS =49;
	if missing(PITCHING_SO) then PITCHING_SO =813;
	if missing(FIELDING_DP) then FIELDING_DP =146;

if Batting_H < 1195 then Batting_H = 1195;
if Batting_H > 1696 then Batting_H = 1696;

if Batting_2B < 167 then Batting_2B = 167;
if Batting_2B > 320 then Batting_2B = 1320;

if Batting_3B < 23 then Batting_3B = 23;
if Batting_3B > 108 then Batting_3B = 108;

if Batting_HR < 14 then Batting_HR = 14;
if Batting_HR > 199 then Batting_HR = 199;

if Batting_BB < 249 then Batting_BB = 249;
if Batting_BB > 671 then Batting_BB = 671;

if Batting_SO < 364 then Batting_SO = 364;
if Batting_SO > 1239 then Batting_SO = 1239;

if Baserun_SB < 36 then Baserun_SB = 36;
if Baserun_SB > 298 then Baserun_SB = 298;

if Baserun_CS < 27 then Baserun_CS = 27;
if Baserun_CS > 83 then Baserun_CS = 83;

if Pitching_H < 1316 then Pitching_H = 1316;
if Pitching_H > 2563 then Pitching_H = 2563;

if Pitching_HR < 18 then Pitching_HR = 18;
if Pitching_HR > 210 then Pitching_HR = 210;

if Pitching_BB < 377 then Pitching_BB = 377;
if Pitching_BB > 757 then Pitching_BB = 757;

if Pitching_SO < 420 then Pitching_SO = 420;
if Pitching_SO > 1169 then Pitching_SO = 1169;

if Fielding_E < 100 then Fielding_E = 100;
if Fielding_E > 716 then Fielding_E = 716;

if Fielding_DP < 87 then Fielding_DP = 87;
if Fielding_DP > 184 then Fielding_DP = 184;

HitPerc = Batting_H/(Batting_H+Batting_BB+Batting_SO);
WeightHits = (2*Batting_2B+3*Batting_3B+4*Batting_HR)/Batting_H;
StealPerc = Baserun_SB/(Baserun_CS+Baserun_SB);
PitchEffic = Pitching_SO/(Pitching_SO+Pitching_H+Pitching_BB);
FieldEffic = Fielding_E/Pitching_H;

tHitPerc 	= log(HitPerc); /**/
tWeightHits = log(WeightHits); /**/
tStealPerc  = log(StealPerc); /**/
tPitchEffic = log(PitchEffic); /**/
tFieldEffic = log(FieldEffic);/**/

P_TARGET_WINS=
				26.12975
+ tWeightHits	* 18.84694
+ tStealPerc	* 17.17844
+ tPitchEffic	* -7.44992
+ tFieldEffic	* -11.64383
+ BATTING_H		* 0.03339
+ BATTING_2B	* -0.01702
+ BATTING_3B	* 0.13833
+ FIELDING_DP	* -0.12440
;
run;

proc means data=scorefile3 min p1 p5 mean p95 p99 max;

/*if there are outliers such as negative wins, from the score file, cap them
based on the p1 and p99 results from the EDA step*/
data scorefile3trim;
set scorefile3;
if P_TARGET_WINS < 38 then P_TARGET_WINS = 38;
if P_TARGET_WINS > 114 then P_TARGET_WINS = 114;

keep index;
keep P_TARGET_WINS;

proc means data=scorefile3trim min p1 p5 mean p95 p99 max;
proc print data=scorefile3trim(obs=5);
run;

libname outfile '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data outfile.DeloshFile3;
set scorefile3trim;
run;
proc print data=outfile.DeloshFile3;
run;

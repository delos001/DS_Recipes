/* Remember:
stand alone data step. whatever you did with the original data, you have to put in the scoring step too
*/

libname mydata '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';
data scorefile;                                                 /*name data set based on moneyball_test data*/
set mydata.moneyball_test;

  /*we did this in the model so we have to add these here too.  
  Add all the steps, changes, transformations, outlier handling, 
  row deletion, etc that you did in the model need to be done in 
  the test file to actually be able to test your model on test data.*/
	if missing(TEAM_BATTING_SO) then TEAM_BATTING_SO =735;
	if missing(TEAM_BASERUN_SB) then TEAM_BASERUN_SB =101;
	if missing(TEAM_BASERUN_CS) then TEAM_BASERUN_CS =49;
	if missing(TEAM_PITCHING_SO) then TEAM_PITCHING_SO =813;
	if missing(TEAM_FIELDING_DP) then TEAM_FIELDING_DP =146;

  /*this was also done in the original model to deal with outliers*/
	LOG_TEAM_PITCHING_H=log(TEAM_PITCHING_H);
	if TEAM_PITCHING_H < 1244.00 then CAP_TEAM_PITCHING_H=1244.00;
	if TEAM_PITCHING_H > 7000 then CAP_TEAM_PITCHING_H=7000;
	else CAP_TEAM_PITCHING_H = TEAM_PITCHING_H;

P_TARGET_WINS =           /*create new variable P_TARGET_WINS*/
/*this is from the regression model output.  the parameter estimates are added to each variable from the deployed model*/
-14.10547
+	3.46120*	LOG_TEAM_PITCHING_H
+	0.04680*	TEAM_BATTING_H
+	0.01881*	TEAM_BATTING_HR
+	0.04069*	TEAM_BASERUN_SB
+	-0.02589*	TEAM_FIELDING_E
;

if P_TARGET_WINS < 38 then P_TARGET_WINS = 38;
if P_TARGET_WINS > 114 then P_TARGET_WINS = 114;

keep index;                               /*this will keep the index column in the scorefile*/
keep P_TARGET_WINS;                       /*this will keep the P_TARGET_WINS in the score file*/

proc print data=scorefile(obs=5);
run;

libname outfile '/folders/myfolders/sasuser.v94/Unit01/MoneyBall';     /*this will create an outfile to the path specified*/
data outfile.DeloshFile;                                               /*name output file*/
set scorefile;                                                         /*based on scorefile data created using steps above*/
run;
proc print data=outfile.DeloshFile;         
run;

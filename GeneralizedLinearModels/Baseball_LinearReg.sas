
%let PATH = C:\Dropbox\N_NORTHWESTERN\Z_NWU411\U1LINEAR\BASEBALL\DATA;
%let NAME = BB;
%let LIB = &NAME..;

libname &NAME. "&PATH.";

%let INFILE 	= &LIB.MONEYBALL;
%let TEMPFILE 	= TEMPFILE;
%let SCOREDFILE	= SCOREDFILE;


data &TEMPFILE.;
set &INFILE.;
keep 
TARGET_WINS
TEAM_FIELDING_E
TEAM_BATTING_H
TEAM_BATTING_BB
TEAM_BASERUN_SB
TEAM_PITCHING_SO
TEAM_BATTING_SO
;
run;

proc univariate data=&TEMPFILE. plot;
var TEAM_BASERUN_SB;
run;


data &TEMPFILE.;
set &TEMPFILE.;
M_TEAM_BASERUN_SB 		= 0;
IMP_TEAM_BASERUN_SB 	= TEAM_BASERUN_SB;
if  missing(IMP_TEAM_BASERUN_SB) then do;
	IMP_TEAM_BASERUN_SB = 125;
	M_TEAM_BASERUN_SB 	= 1;
end;
drop TEAM_BASERUN_SB;

M_TEAM_PITCHING_SO = 0;
IMP_TEAM_PITCHING_SO = TEAM_PITCHING_SO;
if missing( IMP_TEAM_PITCHING_SO ) then do;
			M_TEAM_PITCHING_SO = 1;

			if TEAM_BATTING_H > 15393 then 
				IMP_TEAM_PITCHING_SO = 6666;
			else do;
				if TEAM_BATTING_SO < 723.5 then
					IMP_TEAM_PITCHING_SO = 608;
				else
					IMP_TEAM_PITCHING_SO = 979;
			end;
end;
drop TEAM_PITCHING_SO TEAM_BATTING_SO;
run;

proc print data=&TEMPFILE.(obs=10);
run;

proc means data=&TEMPFILE. nmiss;
var _numeric_;
run;


proc reg data=&TEMPFILE.;
model TARGET_WINS = 
TEAM_FIELDING_E
TEAM_BATTING_H
TEAM_BATTING_BB
IMP_TEAM_BASERUN_SB
IMP_TEAM_PITCHING_SO
M_TEAM_BASERUN_SB
M_TEAM_PITCHING_SO
/selection=stepwise aic sbc adjrsq;
;
run;
quit;



proc univariate data=&TEMPFILE. plot;
var TARGET_WINS;
run;



proc means data=&TEMPFILE. n nmiss;
run;




proc print data=ESTFILE;
run;

proc print data=&SCOREDFILE.(obs=100);
run;





data SCOREFILE;
set &INFILE.;

M_TEAM_BASERUN_SB 		= 0;
IMP_TEAM_BASERUN_SB 	= TEAM_BASERUN_SB;
if  missing(IMP_TEAM_BASERUN_SB) then do;
	IMP_TEAM_BASERUN_SB = 125;
	M_TEAM_BASERUN_SB 	= 1;
end;
drop TEAM_BASERUN_SB;

M_TEAM_PITCHING_SO = 0;
IMP_TEAM_PITCHING_SO = TEAM_PITCHING_SO;
if missing( IMP_TEAM_PITCHING_SO ) then do;
			M_TEAM_PITCHING_SO = 1;

			if TEAM_BATTING_H > 15393 then 
				IMP_TEAM_PITCHING_SO = 6666;
			else do;
				if TEAM_BATTING_SO < 723.5 then
					IMP_TEAM_PITCHING_SO = 608;
				else
					IMP_TEAM_PITCHING_SO = 979;
			end;
end;
drop TEAM_PITCHING_SO TEAM_BATTING_SO;

P_WINS = 	-10.76933
			+TEAM_FIELDING_E * -0.03840
			+TEAM_BATTING_H * 0.05466
			+TEAM_BATTING_BB * 0.02515
			+IMP_TEAM_BASERUN_SB * 0.04853
			+M_TEAM_BASERUN_SB * 28.48928
			+M_TEAM_PITCHING_SO * 9.07979
			;

if P_WINS < 40 then P_WINS = 40;
if P_WINS > 105 then P_WINS = 105;



run;


proc means data=SCOREFILE min max mean nmiss;
var P_WINS;
run;



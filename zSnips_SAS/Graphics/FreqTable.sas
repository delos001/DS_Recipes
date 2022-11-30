
/*------------------------------------------------------------------
gives a frequency table for the temp4 data set, price_outlier column
*/

proc freq data=temp4;
	table price_outlier;
run;

/*------------------------------------------------------------------
Creating dummy variables from bodyfat data set to get frequencies
*/

DATA bodyfat;
   SET mydata.bodyfat;

if ((age >= 20)&(age <= 29)) then age20s_dummy=1 ;
    else age20s_dummy=0 ;
   if ((age >= 30)&(age <= 39)) then age30s_dummy=1 ;
    else age30s_dummy=0 ;
   if ((age >= 40)&(age <= 49)) then age40s_dummy=1 ;
    else age40s_dummy=0 ;
   if ((age >= 50)&(age <= 59)) then age50s_dummy=1 ;
    else age50s_dummy=0 ;
   if ((age >= 60)&(age <= 69)) then age60s_dummy=1 ;
    else age60s_dummy=0 ;
   if (age >= 70) then age70plus_dummy=1 ;
    else age70plus_dummy=0 ;
  
   if (age20s_dummy=1) then agegroup = 2 ;
   if (age30s_dummy=1) then agegroup = 3 ;
   if (age40s_dummy=1) then agegroup = 4 ;
   if (age50s_dummy=1) then agegroup = 5; 
   if (age60s_dummy=1) then agegroup = 6 ;
   if (age70plus_dummy=1) then agegroup = 7 ;

RUN;

PROC FREQ DATA = bodyfat;
  TABLES  age20s_dummy age30s_dummy age40s_dummy 
  age50s_dummy age60s_dummy age70plus_dummy ;
  

/*------------------------------------------------------------------
FREQUENCY PLOT
use the freq procedure first
freqplot is the command to create the frequency plot
*/

proc freq data=temp1;
	tables Fireplaces / plots=freqplot(twoway=grouphorizontal);
run;

/*------------------------------------------------------------------
FREQUENCY PLOT: STACKED BARS
use the freq procedure first
freqplot is the command to create the frequency plot
*/

proc freq data=temp1;
	tables Fireplaces / plots=freqplot(twoway=stackedl);
run;

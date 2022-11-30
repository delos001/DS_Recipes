/* 
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
*/

TITLE "Read in Body Fat Datafile and Begin Exploratory Data Analysis";
ODS GRAPHICS ON; * to get scatterplots with high-resolution graphics out of SAS procedures;


libname mydata "/scs/wtm926/" access=readonly;


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



PROC CONTENTS DATA = bodyfat;
RUN;


PROC FREQ DATA = bodyfat;
  TABLES  age20s_dummy age30s_dummy age40s_dummy age50s_dummy age60s_dummy age70plus_dummy ;


PROC SORT DATA = bodyfat ;
   BY  agegroup ;


PROC MEANS DATA = bodyfat ;
   By agegroup ;
   VAR  percent_bf ;



PROC REG DATA = bodyfat   PLOTS = FITPLOT ;
   MODEL percent_bf = ab_cir thigh_cir weight ;


PROC REG DATA = bodyfat PLOTS = FITPLOT ;
   MODEL percent_bf = agegroup ;

   
PROC REG DATA = bodyfat;
   MODEL percent_bf = age30s_dummy age40s_dummy age50s_dummy age60s_dummy age70plus_dummy ; 


QUIT;

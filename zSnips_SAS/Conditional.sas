/*
In this file:
basic if statement, 
if statement with delete
if then statements
decision tree example
*/

/*----------------------------------------------------------------------------------------
BASIC EXAMPLES
----------------------------------------------------------------------------------------*/

/* prints the rows where zip is equal to 16802 */
proc print data=sastmp.data1 (where=(zip=16802));
run;

/*
create data s1 and based on temp1 data set, keep rows where there is a 1 in the segment column
*/
data s1;
	set temp1;
	if (segment=1);
run;

/*
goes through each row and if the value is missing, inputs the specified number
*/
data mbraw2;
set mbraw2;
	if missing(BATTING_SO) then BATTING_SO = 735;
	if missing(BASERUN_SB) then BASERUN_SB = 101;
	if missing(BASERUN_CS) then BASERUN_CS = 49;
	if missing(PITCHING_SO) then PITCHING_SO = 813;
	if missing(FIELDING_DP) then FIELDING_DP = 146;
run;

/* deletes a row if the value is a zero */
data mbraw2;
	set mbraw1;
if Target_Wins=0 then delete;
run;


/*----------------------------------------------------------------------------------------
IF THEN
----------------------------------------------------------------------------------------*/

/* Example 1 */
data temp1;
	set temp1;
	w=2*y+1;
	
	if (x<150) then segment=1;        /* creates new variable based on the condition */
	else if (x<250) then segment=2;
	else segement=3;
run;

/* Example 2 */
Data temp4;                                /* creates a new data set named temp4 */
	set temp3;                               /* bases temp4 on existing dataset temp3 */
	keep saleprice grlivarea price_outlier;  /* keep saleprice, grlivarea and CREATES a new variable called price_outlier
		if saleprice = . then delete;          /* if saleprice is empty, there will be a period there and this tells it to delete it */
		if saleprice <=45500 then price_outlier=1;  /* create price_outlier and tag with 1 if <45500
			
			else if saleprice > 129500 & saleprice < 213500 
				then price_outlier=2;
      else if saleprice > 297500 then price_outlier=3;

/* Example 3 */
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

/* EXAMPLE DECISION TREE */

IMP_TEAM_FIELDING_DP = TEAM_FIELDING_DP;
M_TEAM_FIELDING_DP = 0;
if missing(IMP_TEAM_FIELDING_DP = 98;
	if TEAM_FIELDING_E > 159 then
		IMP_TEAM_FIELDING_DP = 98;
	else
		IMP_TEAM_FIELDING_DP = 186;
	M_TEAM_FIELDING_DP = 1;
end;




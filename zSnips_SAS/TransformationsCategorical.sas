*Dummy Variables and Flag Variables;

/*-----------------------------------------------------------------------
Dummy Variables 
-----------------------------------------------------------------------*/

/*-----------------------------------------------------------------------
Example 1
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


/*-----------------------------------------------------------------------
Example 2
creates a new data set named lotconfig1 based on temp1
if the value in the lotconfig column equals "corner" then 
  put a 1 in the lotconfigcode column 
  (not the lotconfigcode column is being created in this step too.
*/

data lotconfig1;
	set temp1;
	if lotconfig='Corner' then lotconfigcode=1;
	if lotconfig='CulDSac' then lotconfigcode=2;
	if lotconfig='FR2' then lotconfigcode=3;
	if lotconfig='FR3' then lotconfigcode=4;
  if lotconfig='Inside' then lotconfigcode=5;


/*-----------------------------------------------------------------------
Example 3
creates new data file called lotconfig2
list all the variables in the column (may need to do proc freq to get them all)
**note the comment here because it it important to leave out one variable as the baseline**
    says that if the cell in the lotconfig column equal 'CulDsac' then 
      it puts a one, else it puts a zero repeat for each
*/

 Data lotconfig2;
 	set lotconfig1;
 	
 	if Lotconfig in ('Corner','CulDSac','FR2','FR3','Inside')
 		then do;
 		/*note you are leaving out 'corner' to create baseline*/
 		lotconfig_cul = (lotconfig eq 'CulDSac');
 		lotconfig_fr2 = (lotconfig eq 'FR2');
 		lotconfig_fr3 = (lotconfig eq 'FR3');
 		lotconfig_ins = (lotconfig eq 'Inside');
 		end;


/*------------------------------------------------------------------------------------
Flag Variables
Many times a category needs to be converted into a series of Flag variables 
	for analytic purposes. 
Things to consider:
If desired, every category may have its own flag variable
If desired, some categories may be ignored (no flag)
If desired, several categories can be combined

Married_YES 	     = Marital_Status 	in (“Married”);
Married_NO 	     = Marital_Status 	in (“Single”);
Married_OTHER        = Marital_Status 	in (“Divorced”,”Widow”);
------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------
Approach 1: group observations based on a business rule
creates a new variable Color_Ro and if Red or Orange are in the Color column, 
	it puts a 1 in the Color_Ro column (or a zero if not)

*/
data XFORM;
set TEMPFILE;
COLOR_RO 	= COLOR in ("RED","ORANGE");
COLOR_YG	= COLOR in ("YELLOW","GREEN");
COLOR_BV 	= COLOR in ("BLUE","VIOLET");
run;

proc freq data=XFORM;
table COLOR_RO COLOR_YG COLOR_BV / plots=freqplot;
run;

/*--------------------------------------------------------------------------
Approach 2: Put large categories into independent groups. 
		Merge small categories into a single group
creates a new variable Color_Ro and if Red or Orange are in the Color column, 
	it puts a 1 in the Color_Ro column (or a zero if not)
*/
data XFORM;
set TEMPFILE;
COLOR_ORANGE 	= COLOR in ("ORANGE");
COLOR_YELLOW 	= COLOR in ("YELLOW");
COLOR_GREEN 	= COLOR in ("GREEN");
COLOR_OTHER 	= COLOR in ("RED","BLUE","VIOLET");
run;

proc freq data=XFORM;
table COLOR_ORANGE COLOR_YELLOW COLOR_GREEN COLOR_OTHER / plots=freqplot;
run;

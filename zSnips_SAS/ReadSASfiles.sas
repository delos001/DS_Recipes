

/*------------------------------------------------------------------------------------------
Basic exmaple
*/

libname mydata "/scs/wtm926/" access=readonly;    /*sets the location for libname and names it 'mydata' */

data temp;                                       /*read SAS data set from mydata library*/
set mydata.building_prices;
run;

data temp2 ;                                     /*read second SAS data set from mydata library*/
set mydata.ames_housing_data;
run;


/*------------------------------------------------------------------------------------------
Example to use variables to get a path to open instead of typing the entire path each time
FOR SAS STUDIO
*/

%let ME = username      /*enter your username here: if you need a username to access a path*/

/*this would be the path of the file you are accessing.  
Notice how %ME is entered where the path would normall use a username
creates a variable for the home work folder (in path above)*/
%let PATH = /home/%ME./my_courses/donald.wedding/c_8888/Pred411/Unit01/HW;
%let NAME = Mydata;
%Let LIB = &NAME..;

libname &Name. "&Path.";

data temp1;                      /*name the new file*/
set mydata.Moneyball

proc print data=HW.Moneyball(obs=10);


/*------------------------------------------------------------------------------------------
Example if you are using VM: you have to use this path (can't use c:\...) 
*/
%let Path = /folders/myfolders/sasuser.v94/Unit02;
%let Name = mydata;
%let LIB = &Name..;

libname &Name. "&Path.";

%let Infile = &LIB.logit_insurance;
%let Tempfile = Tempfile;

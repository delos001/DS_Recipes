/*------------------------------------------------------------------
Basic example
generate a random normal variable set (with mean zero, sd=1)
------------------------------------------------------------------*/

error = normal(0) ;


/*------------------------------------------------------------------
Basic example 2
generates a random normal variate (with mean zero, sd=1)
multiplied by 50 to chagne sd to 50
(will generate one random variable for each observation in the data set)

You should note here that the model is:  Y = -X^2 + 51*X - 50    
This is for future comparison to regression print out!
------------------------------------------------------------------*/

error = 50*normal(0) ;

y = (-1)*(x-1)*(x-50) ;     
error = 50*normal(0) ;
y_final = y + error ;


/*------------------------------------------------------------------
Basic example 3

x is 10 times a randomly generated numb with normal distrib + 10 times 
  randomly generated numb with lognormal distrib - 10 times random numb 
  with uniform distrib
x is reset to the sign of the x value from the line above times absolute 
  value of x value from line above raised to 1.5 power.  
  (note: this is repeated 10000 times from "do" function
------------------------------------------------------------------*/

%let HOWMANY = 10000;       *set variable to be called by macro;
%let SEED = 1;              *set variable to be called by macro;

data TEMPFILE;
call streaminit(&SEED.);    *call function that uses seed value of 1 from above;
do i = 1 to &HOWMANY.;      *do function starts at 1 and goes to 1000
X = 10*rand("normal") + 10*rand("lognormal") - 10*rand("uniform");
X = sign(X)*abs(X)**(1.5);


/*------------------------------------------------------------------
Full example 1
Example Code for creating random numbers for a data set that are 
  manipulated using mathmatical operators
X is a numeric variable
COLOR is a categorical variable
------------------------------------------------------------------*/
%let HOWMANY = 10000;
%let SEED = 1;

data TEMPFILE;
call streaminit(&SEED.);
do i = 1 to &HOWMANY.;
X = 10*rand("normal") + 10*rand("lognormal") - 10*rand("uniform");
X = sign(X)*abs(X)**(1.5);

length COLOR $6;
COLOR = "???";                          *creates new color varialbe and sets values to "???";
if  X < -100 	then 	COLOR = "RED";      *puts colors into each cell based on value of x variable and these rules;
else if X < 0	then 	COLOR = "ORANGE";
else if X < 100	then 	COLOR = "YELLOW";
else if X < 500	then 	COLOR = "GREEN";
else if X < 1000	then 	COLOR = "BLUE";
else 			COLOR = "VIOLET";

output;
end;
drop i;
run;



/*------------------------------------------------------------------
Full example 2
This code generates random data for multiple variables 
    (missing shower example)
------------------------------------------------------------------*/
%let OUTFILE 	= SHOWER;
%let TEMPFILE 	= TEMPFILE;


%let NO_SHOWER = 0.25;
%let AVERAGE 	= 11;
%let HOWMANY 	= 1000;

%let MALE	= M;
%let FEMALE	= F;


%let MIDDLEAGE	= MIDDLEAGE;
%let YOUNG	= YOUNG;
%let ELDERLY	= ELDERLY;

data &OUTFILE.;

length INDEX 		8.;
length SHOWERLENGTH 	8.;

SEED = 1;

do INDEX = 1 to &HOWMANY.;
	AVERAGE	= &AVERAGE.;
	NOSHOWER	= &NO_SHOWER.;

	SEX = "&FEMALE."; 
	if ranuni(1) < 0.5 then SEX = "&MALE.";
	if SEX in ("&FEMALE.") then do;
		AVERAGE 	= AVERAGE + 2;
		NOSHOWER 	= NOSHOWER - 0.1;
	end;

	AGE_RANGE = "&MIDDLEAGE.";
	if ranuni(1) < 0.4 then AGE_RANGE = "&YOUNG.";
	if ranuni(1) < 0.2 then AGE_RANGE = "&ELDERLY.";
	if AGE_RANGE in ("&YOUNG.") then do;
		AVERAGE 	= AVERAGE - 2;
	end;

	if AGE_RANGE in ("&ELDERLY.") then do;
		AVERAGE 	= AVERAGE + 2;
		NOSHOWER 	= NOSHOWER - 0.1;
	end;

	INCOME = 10000 + 50000*ranuni(1);
	if SEX in ("&MALE.") then INCOME = 1.2*INCOME;
	if AGE_RANGE in ("&YOUNG.") 	then INCOME = 0.7*INCOME;
	if AGE_RANGE in ("&ELDERLY.") 	then INCOME = 0.9*INCOME;
	INCOME = round(INCOME, 1000);
	
	AVERAGE = AVERAGE + 0.10 * INCOME/1000.0;
	BUCKET = round( INCOME / 10000,1 );
	NOSHOWER = NOSHOWER - BUCKET/100.0;
	INCOME = INCOME/1000;
	
	call ranpoi(SEED, AVERAGE, ShowerLength); 
	if ranuni(1) < NOSHOWER then ShowerLength = 0;
	
	output;
end;
drop SEED;
drop AVERAGE;
drop NOSHOWER;
drop BUCKET;
run;

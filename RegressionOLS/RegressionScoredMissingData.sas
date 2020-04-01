
/*
Score Example with missing data
Any code that transforms values before the call to PROC REG must be implemented into the score code. 
  ex: if the B variable must be transformed with a natural log transformation, 
        the code would be added to the missing value imputatio code(see example code below for this)
*/


/*
the missing value code assumes the following regression model was run and resulted in following coefficients:
Assume that these were the resulting coefficients
Intercept	=	5
A 		=	4.5
B 		=	-3.2
C 		=	6.1
D 		=	-2.6
D_Missing_Flag	=	13
*/

Proc reg data=INFILE2;
Model Y = A B C D D_Missing_Flag;
Run;

Data INFILE2;                                   /*data step to follow the rules in the regression above*/
Set INFILE1;                                    /*name new file with the "handled" missing value rules*/
if missing(A) then delete;                      /**/
if missing(B) then B = 10;                      
if missing(C) then do;                          
	if A>0 then C=5; else C=10;                   
end;
D_Missing_Flag = 0;                             /*create missing value flag column*/
if missing(D) then do;
	D_Missing_Flag = 1;
	D = 25;
end;
B=log(B)                                        /*a transformation to a variable must be included in the data step*/
run; 

/*This code is now modified to put it in a macro so score it*/

%macro SCORE( INFILE, OUTFILE );

	data &OUTFILE.;                               /*name the new file that will be produced from the macro*/
	set &INFILE.;
		if missing(A) then delete;                  /*this is same code from original data step above that defines missing data handling*/
		if missing(B) then B = 10;
		if missing(C) then do;
			if A>0 then C=5; else C=10;
		end;
		D_Missing_Flag = 0;
		if missing(D) then do;
			D_Missing_Flag = 1;
			D = 25;
		end;
		B=log(B)                                     /*a transformation to a variable must be included in the data step*/
	Y_Hat = 5 + 4.5*A-3.2*B+6.1*C-2.6*D+13*D_Missing_Flag;   /*this is the equation based onthe coefficient results above*/
	run;

%mend;

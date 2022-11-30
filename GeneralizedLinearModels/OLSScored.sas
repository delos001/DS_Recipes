
/*
A SAS Data Step can score new data using the results from the Regression. Here is what the Data Step might look like:
  data NEWFILE;
  set TEMPFILE;
  Y_Hat = 9.12689 + 0.20282*X6 - 0.07239*X8;
  run;

To use this Data Step, simply replace “TEMPFILE” with the name of your file. 
  The results will be stored in a data set called “NEWFILE”.
This is simple enough, but to make this more general purpose, it would be easy to put this Data Step inside of a SAS Macro. 

NOTE: 
Missing values
Any code that handled missing values before the call to PROC REG must be implemented into the score code. (see Missing Values tab)
*/

data TEMPFILE;                             /*step 1: create the data set (or import from a file)*/
input X6 X8 Y;
datalines;
20  35.3  10.98
20  29.7  11.13
23  30.8  12.51
20  58.8  8.40
21  61.4  9.27
22  71.3  8.73
11  74.4  6.36
23  76.7  8.50
21  70.7  7.82
20  57.5  9.14
20  46.4  8.24
21  28.9  12.19
21  28.1  11.88
19  39.1  9.57
23  46.8  10.94
20  48.5  9.58
22  59.3  10.09
22  70.0  8.11
11  70.0  6.83
23  74.5  8.88
20  72.1  7.68
21  58.1  8.47
20  44.6  8.86
20  33.4  10.36
22  28.6  11.08
;
run;

proc reg data=TEMPFILE;                     /*step 2: run the regression*/
model Y = X6 X8;
run;
quit;

%macro SCORE( INFILE, OUTFILE );             /*step 3: Create the macro: The data step is now contianed in a SAS macro */

	data &OUTFILE.;                            /*new outfile name that will be produce from running the macro, based on infile source*/
	set &INFILE.;
	YHAT = 9.12689 + 0.20282*X6 - 0.07239*X8;  /*this is the regression equation from the model you are going to test*/
	run;

%mend;

%SCORE( TEMPFILE, My_New_File);              /*step 4: runs score macro from tempfile data: scores are put in the My_New_File data*/
print the my_new_file so you can see the scores
proc print data=My_New_File(obs=5);
run;

data SomeNewData;                             /*Step 5: get some new data to test the model on*/
input X6 X8;
datalines;
15  25
20  35
25  45
30  50
35  55
;
run;

/*SAS Code to invoke the macro and score the original data set and also the new data set. 
When you call the SAS Macro, pass it the name of the data set and a name of a new data set 
where you want to store the results*/

%SCORE( SomeNewData, NowItsScored );           /*Step 6: run the macro again on the new data to predict the y values (yhat)
proc print data=NowItsScored;
run;

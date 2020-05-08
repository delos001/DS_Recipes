
/* ROUNDING NUMBERS ------------------------------------------------------------------------
data TEMPFILE;
input X6 X8 YTEMP;
Y = round(YTEMP,1);
drop YTEMP; 
datalines;
20  35.3  10.98
20  29.7  11.13
23  30.8  12.51
20  58.8  8.40
61.4  9.27

/* ROUNDING NUMBERS IN PROC MEANS TABLE--------------------------------------------------------------
proc means data=tempfile mean ndec=2    /*ndec=2 will limit decimals to 2*/


/* SPECIFY COLUMN DIMENSIONS ------------------------------------------------------------------------
/* Example 1: Create a table manually and specify column dimensions */

data temp1;                   /*create data called temp1
length dimkey $2;             /*sets the first column as the dimension key and sets its to length of 2
length x 8.0;                 /*sets to length of 8
length y 9.0;                 /*sets to length of 9
input dimkey $ x y;           /*creates column headers for the x and y variables (in the order you place them)
datalines;                    /*allows for user entered data lines
01 100 12.2
02 300 7.45
03 200 10.0
04 500 5.67
05 300 4.55
;
run;

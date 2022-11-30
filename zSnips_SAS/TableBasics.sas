
/* MANUALLY CREATE A TABLE ------------------------------------------------------------------------
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


/* ------------------------------------------------------------------------------------
KEEP ONLY COLUMNS OF INTEREST
Determine which columns of a table to keep
*/
data temp1;
keep a;
keep b;
keep c;

proc print temp1;
run;

/* example2 */
Data temp2;
	set temp1;
	logSalePrice=log(SalePrice);
	logGrLivArea=log(GrLivArea);
keep SalePrice logSalePrice GrLivArea logGrLivArea


/*------------------------------------------------------------------------------------
DROP COLUMNS
based on eigenvectors data set (previously created) 
where=(_Name_ in ("Prin1", "Prin2")));  this says select columns that have name Prin1 and Prin2
drop the _Type_ column (where type is a metadata column)
*/

data pca2;
	set eigenvectors(where=(_NAME_ in ('Prin1','Prin2')));
	drop _TYPE_ ;
run;


/*------------------------------------------------------------------------------------
RENAME A COLUMN
rename COL1=correlation;



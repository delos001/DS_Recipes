/* In this script snip: Inner, Left, Right Joins, Merge and Stack Data:

NOTE: 
Merge: this gets all the rows based on the "by" command parameters 
(as opposed to a join which could only bring in the rows present in one file or the other, 
depending on how you specify: left/right/inner)
*/


/*ALWAYS SORT FIRST*/

/*--------------------------------------------------------------------------------------
INNER JOIN
--------------------------------------------------------------------------------------*/

/* sort both data sets first */
proc sort data=temp1;
	by dimkey;
run;
proc sort data=temp2;
	by dimkey;

/* merge temp1 with temp2  
the a and b code the files to be specified in later row which determines which file is the lead file
merge is based on the dimkey
only gets the rows that are contained in both files 1 means the row is present.  
0 would mean row is not present */

title "Inner Join Output";  /* set title for joined data */
data inner_join;            /* create new data file */
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
	if (a=1) and (b=1);
run;


/*--------------------------------------------------------------------------------------
LEFT JOIN
--------------------------------------------------------------------------------------*/

/* sort both data sets first */
proc sort data=temp1;
	by dimkey;
run;
proc sort data=temp2;
	by dimkey;
run;

/* merge temp1 with temp2  
the a and b code the files to be specified in later row which determines which file is the lead file
merge is based on the dimkey
a 1 means get the rows from temp2 that have a corresponding dimkey value found in temp1
a 0 means get the rows from temp2 that are not found in temp1 */

title "Left Join Output";      /* title for the data set */
data left_join;                /* create new data file */
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
if (a=1);


/*--------------------------------------------------------------------------------------
RIGHT JOIN
--------------------------------------------------------------------------------------*/

/* sort both data sets first */
proc sort data=temp1;
	by dimkey;
run;
proc sort data=temp2;
	by dimkey;
run;

/* merge temp1 with temp2  
the a and b code the files to be specified in later row which determines which file is the lead file
merge is based on the dimkey
a 1 means get the rows from temp1 that have a corresponding dimkey value found in temp2
a 0 means get the rows from temp1 that are not found in temp2 */

title "Right Join Output";     /* title for the data set */
data right_join;               /* create new data file */
	merge temp1 (in=a) temp2 (in=b);
	by dimkey;
	if (b=1);
run;


/*--------------------------------------------------------------------------------------
MERGE
--------------------------------------------------------------------------------------*/

/*Example 1----------------------------------------------------------------------*/
/* based on temp1 and temp2 files (they will be merged)
and merging based on dimkey such that dimkey is a unique record 
(see stacked data example to illustrate difference) */
 
data merged_data;           /* create new data file*/
	merge temp1 temp2;
	by dimkey;
run;

/*Example 2----------------------------------------------------------------------*/
merge pca_output temp(keep=response_VV);    /*merges pca_output file with the temp files response_VV column*/

/*Example 3*/
proc sort data=sector;              /* sort first table */
	by tkr; 
run;

proc sort data=long_correlations;   /* sort second table */
	by tkr; 
run;


data long_correlations;
	merge long_correlations (in=a) sector (in=b);
	by tkr;                       /* merge the two tables off tkr variable*/
	if (a=1) and (b=1);           /* where a=1 and b=1 */
run;

/*Example 4----------------------------------------------------------------------*/
/*model1_error is one table and model2_error is the other.  
the "type" and "freq" columns are dropped from the merged table*/
data error_table;
	merge model1_error(drop= _TYPE_ _FREQ_) 
		model2_error(drop= _TYPE_ _FREQ_);
	by train;                                       /*merge by train column*/
run;

/*--------------------------------------------------------------------------------------
STACKING DATA
--------------------------------------------------------------------------------------*/

/* this will create a new file where data from 2 different data sets is stacked
-matching column heads will be stacked on top of each other
-if a column is present in one but not another, the data will be blank for rows where
the column is not present */

data stacked_data;
	set temp1 temp2;
run;

/* this will do the same as above but in first section, we are sorting by dimkey first
sets temp1 and temp2 as the source files
the "by" statement tells how the files should be stacked.  in this case its by dimkey. */

proc sort data=temp1;
	by dimkey;
run;
proc sort data=temp2;
	by dimkey;
run;

data ordered_stack;
	set temp1 temp2;
	by dimkey;
run;

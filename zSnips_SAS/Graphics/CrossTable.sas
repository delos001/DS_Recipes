
/*
creates cross table using "group" as rows and "clusname" as columns
*/

proc freq data=&outdata.;
table group*clusname / nopercent norow nocol;
run;


proc freq data=tempfile;
table target_flag * impjob /missing;
run;

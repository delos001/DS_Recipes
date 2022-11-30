
/*
Example of how to tell sas to select all variables that are character variables
*/
proc freq data=helocmod;
table _character_ /missing;
run;

/*
examples of how to tell sas to select all variables that are numeric variables
*/

proc corr data=temp1 rank;
	var _numeric_;
	with saleprice;
run;

proc freq data=helocmod;
table _numeric_ /missing;
run;

/*
to run a procedure on all the variables present
note the return_:  this tells it to get every column that begins with return_  and : is a wild card
*/
proc corr data=temp;
var return_:;
	with response_VV;
run; quit;



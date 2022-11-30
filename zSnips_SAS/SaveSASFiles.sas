
/*--------------------------------------------------------------------------------------
To save an output as a sas file
*/
libname outfile '/folders/myfolders/sasuser.v94/Unit01/MoneyBall'  /*identifies the file path for the outfile library*/
data outfile.DeloshFile                                            /*names the output file to be saved*/
set scorefile;                                                     /*based onthe source file*/
run;


/*---------------------------------------------------------------------------------------
Save predicted response values in a SAS dataset called manatee_out
Appends a column to the dataset: Pred is the predicted number of manatee deaths using: 
  proc reg data=manatees; 
  model deaths = boats / P;
*/

Output Out = manatee_out Predicted = Pred;

proc print data=manatee_out;
run;

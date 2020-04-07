/* 
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
*/

TITLE "Read in Body Fat Datafile and Begin Exploratory Data Analysis";
ODS GRAPHICS ON; * to get scatterplots with high-resolution graphics out of SAS procedures;


libname mydata "/scs/wtm926" access=readonly; 


DATA bodyfat;
SET mydata.bodyfat;
RUN;

* show contents of the full data set prior to splitting;
PROC CONTENTS DATA = bodyfat;
RUN;

* print all the data;
PROC PRINT DATA=bodyfat; 
RUN;

* get correlation information to select a good predictor variable for body fat ;
PROC CORR ;
Run ;




TITLE2 "Simple Linear Regression of abdominal circumfrence on body fat";

* simple linear regression;
PROC REG DATA = bodyfat;
MODEL percent_bf = ab_cir / P; 
* save predicted response values in a SAS dataset called learnout;
OUTPUT OUT = learnout PREDICTED = PRED; * PRED is the predicted percent of body fat; 
RUN;

* examine observed and predicted response case by case;
PROC PRINT DATA = learnout; 
VAR percent_bf ab_cir PRED;
RUN;

* correlation of actual and predicted response;
PROC CORR DATA = learnout PLOTS = SCATTER;
VAR PRED; 
WITH ab_cir;
RUN;

QUIT;

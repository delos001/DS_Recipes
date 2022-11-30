

libname mydata'/scs/wtm926/' access=readonly;
proc datasets library=mydata;
run;
Data temp1;
set mydata.ames_housing_data;
proc contents data=temp1;
run;
/*Use the PROC SORT procedure to sort the data by sales price*/
proc sort data=temp1;
by descending saleprice;
proc print data=temp1 (obs=10);
var saleprice GrLivArea;
run;
proc sort data=temp1;
by saleprice;
proc print data=temp1 (obs=10);
var saleprice GrLivArea;
run;
proc sort data=temp1;
by saleprice;
proc print data=temp1 (obs=10);
run;
/*Use the PROC SORT procedure to sort the data by basement SF*/
proc sort data=temp1;
by descending TotalBsmtSF;
proc print data=temp1 (obs=10);
var TotalBsmtSF GrLivArea;
run;
proc sort data=temp1;
by TotalBsmtSF;
proc print data=temp1 (obs=10);
var TotalBsmtSF GrLivArea;
run;
proc print data=temp1 (obs=10);
run;
/*Use the PROC SORT procedure to sort the data by garage area*/
proc sort data=temp1;
by descending GarageArea;
proc print data=temp1 (obs=10);
var GarageArea GarageType;
run;
proc sort data=temp1;
by GarageArea;
proc print data=temp1 (obs=10);
var GarageArea GarageType;
run;
/*Use PROC CORR to produce the Pearson correlation coefficients
and a scatterplot matrix of the potential continuous predictor
variables with the response variable Y (sale price)*/
ods graphics on;
title "Pearson Coefficient: Continuious Variables with Sale Price";
proc corr data=temp1 nosimple rank;
var LotFrontage LotArea MasVnrArea BsmtFinSF1 BsmtFinSF2
BsmtUnfSF TotalBsmtSF FirstFlrSF SecondFlrSF LowQualFinSF GrLivArea
GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch
ScreenPorch PoolArea MiscVal;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
var LotFrontage LotArea MasVnrArea BsmtFinSF1;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
var BsmtFinSF2 BsmtUnfSF TotalBsmtSF FirstFlrSF;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
var SecondFlrSF LowQualFinSF GrLivArea GarageArea;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
var WoodDeckSF OpenPorchSF EnclosedPorch ThreeSsnPorch ;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=100000);
var ScreenPorch PoolArea MiscVal;
with saleprice;
run;
/*make a scatter plot for the X continuous variable with the highest
correlation with Y. Do the same for the X variable that has the
lowest correlation with Y. Finally, make a scatter plot between X
and Y with the correlation closest to 0.5.*/
proc corr data=temp1 rank plots=matrix ;
var GrLivArea;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix ;
var BsmtFinSF2;
with saleprice;
run;
proc corr data=temp1 rank plots=matrix ;
var MasVnrArea;
with saleprice;
run;
/*For the 3 predictor (X) variables you used in Step 4, produce a
scatterplot with a LOESS (Locally Estimated Scatterplot Smoother)
smoother for Y*/
proc sgscatter data=temp1;
compare x=(GrLivArea)
y=Saleprice/loess;
run;
proc sgscatter data=temp1;
compare x=(BsmtFinSF2)
y=Saleprice/loess;
run;
proc sgscatter data=temp1;
compare x=(MasVnrArea)
y=Saleprice/loess;
run;
ods graphics off;
/*Select 3 categorical variables of your choice and use the PROC
FREQ procedure to see the distribution of values for these
variables*/
proc freq data=temp1;
tables MoSold / plots=freqplot(twoway=grouphorizontal);
run;
proc freq data=temp1;
tables GarageCars / plots=freqplot(twoway=grouphorizontal);
run;
proc freq data=temp1;
tables Fireplaces / plots=freqplot(twoway=grouphorizontal);
run;
/*For the 3 categorical variables selected in step 6), do the
following analysis for each variable - one categorical variable
at a time. */
proc sort data=temp1;
by MoSold;
proc means data=temp1;
by MoSold;
var saleprice;
proc sort data=temp1;
by GarageCars;
proc means data=temp1;
by GarageCars;
var saleprice;
proc sort data=temp1;
by Fireplaces;
proc means data=temp1;
by Fireplaces;
var saleprice;
/*For the 3 categorical variables selected in step 6) predictor
variables, use PROC CORR to correlate all of these variables with
the response variable Y */
ods graphics on;
proc corr data=temp1 rank plots=matrix plots(maxpoints=none) ;
var MoSold GarageCars Fireplaces;
with saleprice;
run;
proc sgplot data=temp1;
vbar OverallCond;
run;
proc sgplot data=temp1;
vbar OverallQual;
run;
proc sgplot data=temp1;
hbar HouseStyle;
run;
proc sgplot data=temp1;
histogram LotArea / binwidth=15000;
run;
PROC SGPLOT data=temp1 ;
scatter x=LotArea y=SalePrice ;
run ;
proc sgscatter data=temp1;
compare x=(LotArea) y=SalePrice/loess;
run;
proc corr data=temp1 rank plots=matrix plots(maxpoints=none);
var BsmtFinSF1 BsmtUnfSF FirstFlrSF GarageArea GrLivArea
LotArea LowQualFinSF MasVnrArea OpenPorchSF PoolArea
SecondFlrSF TotalBsmtSF WoodDeckSF;
run;
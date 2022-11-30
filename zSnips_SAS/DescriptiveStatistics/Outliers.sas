
/*-----------------------------------------------------------------------------------
Example 1
In this example:
find IQC and subtract from the Q1 value to get lower threshold for outlier 
    (see univariate page to get IQC) and set a 1 in the price_outlier columns
if it is greater than Q1 and less than Q3 it will set a 2 in the price outlier column
*/

Data temp4;
	set temp3;
	keep saleprice grlivarea price_outlier;
		if saleprice = . then delete;
		if saleprice <=45500 then price_outlier=1;
			
			else if saleprice > 129500 & saleprice < 213500 
				then price_outlier=2;
else if saleprice > 297500 then price_outlier=3;

/*---------------------------------------------------------------------------------
Example 2
same as above but uses an additional else if to identify extreme outliers using 3*IQC
*/
Data temp4;
	set temp3;
	keep saleprice grlivarea price_outlier;
		if saleprice = . then delete;
		if saleprice <=45500 then price_outlier=1;
			else if saleprice > 45500 & saleprice < 297500 
				then price_outlier=2;
			else if saleprice >= 297500 & saleprice < 465500
				then price_outlier=3;
			else if saleprice >=465500 then price_outlier=4;
			
proc freq data=temp4;
	table price_outlier;      *this produces a table for the outlier counts;
run;

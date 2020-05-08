/* Types:
abs, sign, logarithm, standardization(z-trans), trimming
and see binning page for binning examples
*/

/*
The two most likely situations where numeric data needs to be transformed are
Missing Data
Outliers

The two most likely situations where categorical or “Class” data needs to be transformed are
Missing Data
Converting categories to flag variables
*/


/*----------------------------------------------------------------------------------
Absolute value
*/

Y=abs(X);   *absolute value: when operation requires only positive values;


/*----------------------------------------------------------------------------------
sign (not sine)
Returns a +1, 0, -1 depending upon if a value is positive, zero, or negative.
Usually applied with ABS function to return a value back to its original sign 
  after an operation is complete
*/
Y=sign(X);


/*----------------------------------------------------------------------------------
LOGARITHM:
requires X > 0
Base can be any positive value, but usually it is 10 or “e”
	“e” is the natural exponent is approximately 2.71828
Notation:
	LOG10: Logarithm Base 10 (sometimes “LOG”)
	LOG: Logarithm Base “e” (sometimes “LN” … also called natural log)
Logarithms require that X > 0
Example:
	LOG10(100) = 2     because     102=100
	LOG(100) = 4.6052     because     e4.6052=100
Logarithms are used when data sets have outlier values that need to be constrained.
*/

Y=LOG10(X);
Y=LOG(X);

/* Logarithm Example 2
Properties of this transformation:
	Log Transform (0) = 0
	Log Transform (-X) = -1*Log Transform(X)
	A higher logarithm base will give a more tightly grouped set of data points.
The following code with perform the LOG TRANSFORM for:
	Natural Log (LN) which is LOG Base 2.71828
	Log Base 10
note that there usually isn't a noticable difference between the two
*/

data XFORM;
set TEMPFILE;

LN_X 	= sign(X) * log(abs(X)+1);
LOG10_X 	= sign(X) * log10(abs(X)+1);
run;


/*----------------------------------------------------------------------------------
Standardization (Z-trans)
Subtract the Mean and Divide by the Standard Deviation. 
	Usually results in a value +/- 3 (unless there are some serious outliers)
		Example: Assume that Mean=50 Standard Deviation=30
		

Assume example output of PROC MEANS:
Mean is 83 (rounded)
Standard Deviation is 271 (rounded)

As opposed to manually hard coding the Mean and Standard Deviation, the following code will:
	Run a PROC MEANS and store the output into a SAS Data Set named “MEANFILE”
	The variables inside of MEANFILE will be stored in Macro Variables (“call symput”)
	The data will then be “Standardized” using a SAS Data Step
	A second variable is also created that TRIMS the Standardized variable to +/-3
*/

proc means data=TEMPFILE noprint;
output 	out	= MEANFILE 
	mean(X)	= U 
	stddev(X)	= S;
run;

proc print data=MEANFILE;
run;

data;
set MEANFILE;
call symput("U",U);
call symput("S",S);
run;


data XFORM;
set TEMPFILE;
STD_X 	= (X-&U.)/&S.;
T_STD_X	= max(min(STD_X,3),-3);
run;



/*----------------------------------------------------------------------------------
Trimming
When a variable exceeds a certain limit, it is simply truncated so that it cannot exceed the limit.
	Example: Limit X to a range of -5 to +10
	
Assuming example output of PROC MEANS (below):
	95% of the data points are in the range of X < 373 (rounded)
	99% of the data points are in the range of X < 1061 (rounded)
	
As opposed to manually hard coding the limits (which would be perfectly fine), the following code will:
	Run a PROC MEANS and store output into SAS Data Set named “MEANFILE”
	The variables inside of MEANFILE will be stored in Macro Variables (“call symput”)
	The data will then be “Trimmed” using a SAS Data Step
*/

proc means data=TEMPFILE noprint;
output 	out	= MEANFILE 	
	P1(X)	= P01x 
	P5(X)	= P05x 
	P95(X)	= P95x 
	P99(X)	= P99x;
run;

proc print data=MEANFILE;
run;

data;
set MEANFILE;
call symput("P01x",P01x);
call symput("P05x",P05x);
call symput("P95x",P95x);
call symput("P99x",P99x);
run;

data XFORM;
set TEMPFILE;

/*creates new variable T95_X: look at x and first sets T95 to min(x, p95 value)
 	so it doesn't take values less than p5, 
it gets max between the first nested min function and the p05 value */
T95_X 	= max(min(X,&P95x.),&P05x.);
T99_X 	= max(min(X,&P99x.),&P01x.);
run;

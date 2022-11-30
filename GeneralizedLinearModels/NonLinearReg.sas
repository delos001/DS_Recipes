
/* 
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

*/


TITLE "Non-Linear Models - The U Shape ";

/**********************************************************************************************************************************************************/
/* As a statistician / predictive modeler, this is how you believe the data you observe is constructed by the omnipotent god of all statisticians.        */
/*  Data is constructed with an underlying pattern that is mathematically ideal.  Then the statistics god, who is a trickster, adds on a random           */
/*  component to make life difficult for you and funny for those who observe you struggle with randomness and decision making in the face of uncertainty. */
/**********************************************************************************************************************************************************/

DATA statgodview ;
INPUT X ;

y = (-1)*(x-1)*(x-50) ;     /* You should note here that the model is:  Y = -X^2 + 51*X - 50    This is for future comparison to regression print out!   */
error = 50*normal(0) ;
y_final = y + error ;

DATALINES;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50 
; 


PROC PRINT data=statgodview; 
run; 

proc sgplot ;
  scatter x=x y=y ;
  
proc sgplot ;
  histogram error ;

/***********************************************************************************************************/
/*  The stats god is done with their fun at this point and the data gets turned over to you, the modeler.  */  
/*   But, all you get to see is the resultant variables, NOT the intermittant ones used in the constrution. */
/***********************************************************************************************************/

data modelerview ;
   set statgodview ;
   keep x y_final ;
run ;

/*************************************************************************************************************************************************/
/*  You step in here as the Modeler, and dutifully plot your data to observe the cloud of data and discern the underlying pattern to the data.  */
/*************************************************************************************************************************************************/

proc print data=modelerview ;
run ;
   
proc sgplot data=modelerview ;
  scatter x=x y=y_final ;   
   
/************************************************************************************************************************************************/
/*  You note the possible underlying pattern as being that of a parabola, or a U shaped curve that is upside down.  */
/*   So you decide to model the U shaped pattern using OLS regression, even though it is a NON-LINEAR relationship.   This is OK to do!  */
/*  Because the model needs to be linear "IN THE PARAMETERS".   So you ask yourself, what kind of a mathematical function has a U shape.  */
/*   Well it is a function that looks like:   Y = B0 + B1*X + B2*X^2.    The X^2 makes you pause for a second, but then you remember that */
/*  as long as you can create such a variable in the SAS datastep, it is just another variable that the regression model can use.   The trick is  */
/*  you have to be able to create the variable in a SAS datastep.   So, off we go!   */
/***************************************************************************************************************************************************/

data model ;
  set modelerview ;
  
  x_sqr = x*x ;
run ;

proc print data=model ;

prog reg data=model ;
    MODEL y_final = x  x_sqr  / P; 

* save predicted response values in a SAS dataset called modelout;
    OUTPUT OUT = modelout  PREDICTED = PRED; 

* PRED is the predicted value for Y_FINAL ;

proc sgplot data=modelout ;
   scatter x=x y=pred ; 

RUN;

 


quit;

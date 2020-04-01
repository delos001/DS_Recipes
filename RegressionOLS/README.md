## Regression Tutuorials

- Money Ball (SAS example)
  + https://www.youtube.com/watch?v=KGvJp8G4pmE&feature=youtu.be
  + https://www.youtube.com/watch?v=Pqy7jZMLKqk&feature=youtu.be
  + https://www.youtube.com/watch?v=wG58OCVI77U&feature=youtu.be



## Basics:
````
-Independence: All the observations (records) are independent from one another
-Linearity: The target (dependent) variable is a linear combination of the input (independent) variables.
-Multicollinearity: There is no perfect correlation between independent variables.
-Error Terms:
  The error terms have a mean or average value of zero
  The error terms are normally distributed
  There is no observable pattern to the error terms (homoscedastic).
````
---

#### Single Linear Regression
- H0 : B1=0  Null hypothesis where B1 is the slope: 
  + so we are saying for the null hypothesis is that there is no slope to the regression line
- H1 : B1<>0 Alterntaive hypothesis: 
  + says there is a slope to the regression line (which indicates a relationship between the two variables)
  
#### Multiple Linear Regression
- H0 : B1=B2=…=Bk=0  Null hypothesis for multivariable regression
- H1 : Bj<>0 for at least one j  Alternative hypothesis: 
  + slope of at least one of the regressor variables is not equal to zero (and therefore there is a relationship between regressor and response variable)

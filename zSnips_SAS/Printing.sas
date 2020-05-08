

/* Basic example1 */

data temp;                            /* names the data temp
      set mydata.buildings_prices;    /* links the specified data set to temp
run;

proc print data=temp (obs=10);        /* once you have done the data step, this prints the first 10 observations from the temp data set
run;


/* Basic example2 */
proc print data=temp1 (obs=10);
	var saleprice;                  /*specifies to only print the saleprice column*/
run;

/* No printing */

proc means data=&RANKFILE. noprint;   /* tells sas not to print after setting the data name

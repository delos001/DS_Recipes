## SAS Studio
	ods graphics on; 
	ods graphics off; 

## Reset title statement to blank
	title "; 


## Unpack the plot matrix to create single large plot for each plot in the matrix
	proc reg data=temp1 plots(unpack = diagnostics fitplot residualplot);
		model saleprice=masvnrarea;	
	run;



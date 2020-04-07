

libname mydata "/scs/wtm926/" access=readonly;

data temp;
set mydata.european_employment;
run;

/*get file info*/
proc contents data=temp;
run;

/*only 30 observations so print all (not obs=x needed)*/
proc print data=temp; 
run;

/*sort by country to identify duplicates*/
proc sort data=temp;
	by country;
run;

proc print data=temp; 
run;

/*look at data by groups*/
proc means data=temp;
	var _numeric_;
run;
proc means data=temp;
	class country;
	var _numeric_;
run;
proc means data=temp;
	class group;
	var _numeric_;
run;
proc means data=temp;
	class group country;
	var _numeric_;
run;

ods graphics on;
proc sgplot data=temp;
	title 'Scatter Plot: Raw Employment Data';
	scatter y=man x=con / datalabel=country group=group;
run;
/*Part1
Use PROC CORR to produce the Pearson correlation coefficients and
the scatterplot matrix to review each var to var comparision.  
Multiple proc corrs used to produce 3x3 and obtain var to var 
comparison for all variables.*/
proc corr data=temp rank plots=matrix;
	var agr min man;
	with agr min man;
run;

proc corr data=temp rank plots=matrix;
	var agr min man;
	with ps con ser;
run;

proc corr data=temp rank plots=matrix;
	var agr min man;
	with fin sps tc;
run;

proc corr data=temp rank plots=matrix;
	var ps con ser;
	with ps con ser;
run;

proc corr data=temp rank plots=matrix;
	var ps con ser;
	with fin sps tc;
run;

proc corr data=temp rank plots=matrix;
	var fin sps tc;
	with fin sps tc;
run;

/*use two varaibles based on proc corr steps above that produced
best plot that may be able to benefit from dimension reduction*/
ods graphics on;
proc sgplot data=temp;
	title 'Scatter Plot: Raw Employment Data';
	scatter y=tc x=ser / datalabel=country group=group;
run;
ods graphics off;

/*Part 2
Principal component analysis: One method of reducing the 
dimensionality of our data set is to use principal
components analysis*/

ods graphics on;
title Principal Component Analysis using PROC PRINCOMP;
proc princomp data=temp
	out=pca_9components 
	outstat=eigenvectors
	plots=all;
run;
ods graphics off;

/*Part 3
Cluster Analysis.  Make two scatter plots for fin-ser and man-ser*/

ods graphics on;
proc sgplot data=temp;
title "Scatter Plot of Raw Data: FIN*SER";
scatter y=fin x=ser /datalabel=country group=group;
run;

proc sgplot data=temp;
title "Scatter Plot of Raw Data: MAN*SER";
scatter y=man x=ser /datalabel=country group=group;
run;
ods graphics off;

/*Now we will use PROC CLUSTER to create a set of clusters 
algorithmically*/
ods graphics on;
proc cluster data=temp
	method=average
	outtree=tree1
	pseudo ccc plots=all;
	var fin ser;
	id country;
run;
ods graphics off;

/*We can use PROC TREE to assign our data to a set number of 
clusters*/
/*assign to 4 clusters*/
ods graphics on;
proc tree data=tree1 ncl=4 out=_4_clusters;
copy fin ser;
run; quit;
ods graphics off;

/*assign to 3 clusters*/
ods graphics on;
proc tree data=tree1 ncl=3 out=_3_clusters;
copy fin ser;
run; quit;
ods graphics off;

/*use macro to make tables displaying the assignment of the observ
to the determined clusters*/
%macro makeTable(treeout,group,outdata);
data tree_data;
	set &treeout.(rename=(_name_=country));
run;

proc sort data=tree_data; 
	by country; 
run;

data group_affiliation;
	set &group.(keep=group country);
run;

proc sort data=group_affiliation; 
	by country; 
run;

data &outdata.;
	merge tree_data group_affiliation;
	by country;
run;

proc freq data=&outdata.;
table group*clusname / nopercent norow nocol;
run;

%mend makeTable;

/*call the macro for 3 cluster*/
%makeTable(treeout=_3_clusters,
			group=temp,
			outdata=_3_clusters_with_labels);

/*plot the clusters for a visual display for 3 clusters*/
ods graphics on;
proc sgplot data=_3_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 3 Clusters";
scatter y=fin x=ser / datalabel=country group=clusname;
run;
ods graphics off;

/*call the macro for 4 cluster*/
%makeTable(treeout=_4_clusters,
			group=temp,
			outdata=_4_clusters_with_labels);
			
/*plot the clusters for a visual display for 4 clusters*/
ods graphics on;
proc sgplot data=_4_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 4 Clusters";
scatter y=fin x=ser / datalabel=country group=clusname;
run;
ods graphics off;

/*Cluster analysis using the first 2 principal components*/
/*1*/
ods graphics on;
proc cluster data=pca_9components
	method=average
	outtree=tree3
	pseudo ccc
	plots=all;
	var prin1 prin2;
	id country;
run;

/*2*/
proc tree data=tree3
	ncl=4
	out=_4_clusters;
	copy prin1 prin2;
run;

/*3*/
proc tree data=tree3
	ncl=3
	out=_3_clusters;
	copy prin1 prin2;
run;
ods graphics off;

%makeTable(treeout=_3_clusters,
			group=temp,
			outdata=_3_clusters_with_labels);
%makeTable(treeout=_4_clusters,
			group=temp,
			outdata=_4_clusters_with_labels);
			
/*Plot the clusters for a visual display*/
ods graphics on;
/*3 clusters*/
proc sgplot data=_3_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 3 Clusters";
	scatter y=prin2 x=prin1 / datalabel=country group=clusname;
run;
/*4 clusters*/
proc sgplot data=_4_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 4 Clusters";
	scatter y=prin2 x=prin1 / datalabel=country group=clusname;
run;
ods graphics off;

/*using 6 clusters*/
proc tree data=tree3
	ncl=6
	out=_6_clusters;
	copy prin1 prin2;
run;
ods graphics off;

%makeTable(treeout=_6_clusters,
			group=temp,
			outdata=_6_clusters_with_labels);
			
/*Plot the clusters for a visual display*/
ods graphics on;

proc sgplot data=_6_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 6 Clusters";
	scatter y=prin2 x=prin1 / datalabel=country group=clusname;
run;

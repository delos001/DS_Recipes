/*
This is an example to perform cluster analysis (see code directly above) and 
then use a macro to get plot the clusters and color by their cluster.

Note that PROC CLUSTER performs hierarchical clustering (see Chapter 6 in Applied 
Multivariate Data Analysis) so we do not need to specify the number of clusters in advance. 
We will use the SAS procedure PROC TREE to assign observations to a specified number of 
clusters after we have performed the hierarchical clustering
*/

ods graphics on;
title Principal Component Analysis using PROC PRINCOMP;
proc princomp data=temp
	out=pca_9components                     /*create output file*/
	outstat=eigenvectors                    /*put the eigenvectors in the output file*/
	plots=all;
run;

proc cluster data=pca_9components         /*perform cluster analysis using the pca_9components output file*/
	method=average                          /*average is the "average linkage cluster analysis" function*/
	outtree=tree3                           /*create a cluster tree output*/
	pseudo ccc                              /*use the pseudo f and psudo rsquare and the ccc to be able to identify appropriate cluster number*/
	plots=all;
	var prin1 prin2;                        /*use the prin1 and prin2 from the pca_9components output file*/
	id country;
run;

proc tree data=tree3                      /*create a proc tree for 4 clusters*/
	ncl=4                                   /*number of clusters = 4*/
	out=_4_clusters;                        /*out called _4_clusters (to be used for table later)*/
	copy prin1 prin2;                       /*copy the prin1 and prin2 values to the output file*/
run;

proc tree data=tree3                      /*repeat the above with 3 clusters*/
	ncl=3
	out=_3_clusters;
	copy prin1 prin2;
run;
ods graphics off;


%makeTable(treeout=_3_clusters,            /*make a table using the _3_clusters output file*/
	group=temp,                              /*group the table by "temp"*/
	outdata=_3_clusters_with_labels);
%makeTable(treeout=_4_clusters,            /*repeat make table for 4 cluster analysis*/
	group=temp,
	outdata=_4_clusters_with_labels);
	
proc sgplot data=_3_clusters_with_labels;
title "Scatterplot of European Employment Raw Data 3 Clusters";  /*create a scatter plot that will be colored by cluster*/
	scatter y=prin2 x=prin1 / datalabel=country group=clusname;
run;

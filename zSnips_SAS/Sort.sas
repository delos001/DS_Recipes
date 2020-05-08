

Data temp1;
	set mydata.ames_housing_data;

proc sort data=temp1;
  by descending saleprice;

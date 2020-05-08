

proc means data=temp1 min p25 p50 p75 max ndec=2;
class y;
var x1 x2 x3;
run;



%let HOWMANY = 10000;
%let SEED = 1;

data TEMPFILE;
call streaminit(&SEED.);
do i = 1 to &HOWMANY.;
X = 10*rand("normal") + 10*rand("lognormal") - 10*rand("uniform");
X = sign(X)*abs(X)**(1.5);

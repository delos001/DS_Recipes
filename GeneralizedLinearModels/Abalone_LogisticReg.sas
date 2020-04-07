

/***********************************************************************
*                          Model: Score DataStep                       *
***********************************************************************/
%let Path = /folders/myfolders/sasuser.v94/Unit03/Abalone;
%let Name = mydata;
%let LIB = &Name..;

%let scorefile = scorefile;

libname &Name. "&Path.";

%let testfile = &LIB.zip_abalone_test;

proc contents data=&testfile.;
proc print data=&testfile. (obs=10);
proc means data=&testfile. min p1 mean median p99 max std var n nmiss;
run;

data &scorefile.;
set &testfile;

Target_flag = (Target_Rings > 0); /*puts a 1 if >0, else puts a 0*/
Target_Amt = Target_Rings -1;  /*we subtract 1 which will be added back later*/
if Target_flag = 0 then Target_Amt = .; /*puts blank when target_nozero =0*/

*------------------------------------------------------------*;
* TRANSFORM: Diameter , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_Diameter = 'Transformed Diameter';
length OPT_Diameter $36;
if (Diameter eq .) then OPT_Diameter="04:0.3975-high, MISSING";
else
if (Diameter < 0.3025) then
OPT_Diameter = "01:low-0.3025";
else
if (Diameter >= 0.3025 and Diameter < 0.3475) then
OPT_Diameter = "02:0.3025-0.3475";
else
if (Diameter >= 0.3475 and Diameter < 0.3975) then
OPT_Diameter = "03:0.3475-0.3975";
else
if (Diameter >= 0.3975) then
OPT_Diameter = "04:0.3975-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: Height , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_Height = 'Transformed Height';
length OPT_Height $36;
if (Height eq .) then OPT_Height="04:0.1475-high, MISSING";
else
if (Height < 0.0875) then
OPT_Height = "01:low-0.0875";
else
if (Height >= 0.0875 and Height < 0.1025) then
OPT_Height = "02:0.0875-0.1025";
else
if (Height >= 0.1025 and Height < 0.1475) then
OPT_Height = "03:0.1025-0.1475";
else
if (Height >= 0.1475) then
OPT_Height = "04:0.1475-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: Length , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_Length = 'Transformed Length';
length OPT_Length $36;
if (Length eq .) then OPT_Length="04:0.4875-high, MISSING";
else
if (Length < 0.3825) then
OPT_Length = "01:low-0.3825";
else
if (Length >= 0.3825 and Length < 0.4275) then
OPT_Length = "02:0.3825-0.4275";
else
if (Length >= 0.4275 and Length < 0.4875) then
OPT_Length = "03:0.4275-0.4875";
else
if (Length >= 0.4875) then
OPT_Length = "04:0.4875-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: ShellWeight , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_ShellWeight = 'Transformed ShellWeight';
length OPT_ShellWeight $36;
if (ShellWeight eq .) then OPT_ShellWeight="03:0.15425-0.35975, MISSING";
else
if (ShellWeight < 0.08625) then
OPT_ShellWeight = "01:low-0.08625";
else
if (ShellWeight >= 0.08625 and ShellWeight < 0.15425) then
OPT_ShellWeight = "02:0.08625-0.15425";
else
if (ShellWeight >= 0.15425 and ShellWeight < 0.35975) then
OPT_ShellWeight = "03:0.15425-0.35975, MISSING";
else
if (ShellWeight >= 0.35975) then
OPT_ShellWeight = "04:0.35975-high";
*------------------------------------------------------------*;
* TRANSFORM: ShuckedWeight , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_ShuckedWeight = 'Transformed ShuckedWeight';
length OPT_ShuckedWeight $36;
if (ShuckedWeight eq .) then OPT_ShuckedWeight="04:0.23575-high, MISSING";
else
if (ShuckedWeight < 0.11075) then
OPT_ShuckedWeight = "01:low-0.11075";
else
if (ShuckedWeight >= 0.11075 and ShuckedWeight < 0.15775) then
OPT_ShuckedWeight = "02:0.11075-0.15775";
else
if (ShuckedWeight >= 0.15775 and ShuckedWeight < 0.23575) then
OPT_ShuckedWeight = "03:0.15775-0.23575";
else
if (ShuckedWeight >= 0.23575) then
OPT_ShuckedWeight = "04:0.23575-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: VisceraWeight , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_VisceraWeight = 'Transformed VisceraWeight';
length OPT_VisceraWeight $36;
if (VisceraWeight eq .) then OPT_VisceraWeight="04:0.13475-high, MISSING";
else
if (VisceraWeight < 0.05125) then
OPT_VisceraWeight = "01:low-0.05125";
else
if (VisceraWeight >= 0.05125 and VisceraWeight < 0.07525) then
OPT_VisceraWeight = "02:0.05125-0.07525";
else
if (VisceraWeight >= 0.07525 and VisceraWeight < 0.13475) then
OPT_VisceraWeight = "03:0.07525-0.13475";
else
if (VisceraWeight >= 0.13475) then
OPT_VisceraWeight = "04:0.13475-high, MISSING";
*------------------------------------------------------------*;
* TRANSFORM: WholeWeight , Optimal Binning(4);
*------------------------------------------------------------*;
label OPT_WholeWeight = 'Transformed WholeWeight';
length OPT_WholeWeight $36;
if (WholeWeight eq .) then OPT_WholeWeight="04:0.63975-high, MISSING";
else
if (WholeWeight < 0.28275) then
OPT_WholeWeight = "01:low-0.28275";
else
if (WholeWeight >= 0.28275 and WholeWeight < 0.351) then
OPT_WholeWeight = "02:0.28275-0.351";
else
if (WholeWeight >= 0.351 and WholeWeight < 0.63975) then
OPT_WholeWeight = "03:0.351-0.63975";
else
if (WholeWeight >= 0.63975) then
OPT_WholeWeight = "04:0.63975-high, MISSING";
length _DC_Format $200;
_DN_Format=.;
drop _DC_Format _DN_Format;
*------------------------------------------------------------*;
* Dummy for Sex;
*------------------------------------------------------------*;
* Dummy for level F;
label TI_Sex1='Sex:F';
_DC_Format = Sex;
%dmnormip(_DC_Format);
if Sex eq '' then TI_Sex1 = .;
else
if _DC_Format = 'F' then TI_Sex1 = 1;
else TI_Sex1 = 0;
* Dummy for level I;
label TI_Sex2='Sex:I';
_DC_Format = Sex;
%dmnormip(_DC_Format);
if Sex eq '' then TI_Sex2 = .;
else
if _DC_Format = 'I' then TI_Sex2 = 1;
else TI_Sex2 = 0;
* Dummy for level M;
label TI_Sex3='Sex:M';
_DC_Format = Sex;
%dmnormip(_DC_Format);
if Sex eq '' then TI_Sex3 = .;
else
if _DC_Format = 'M' then TI_Sex3 = 1;
else TI_Sex3 = 0;
*------------------------------------------------------------*;
* Trans: Dropping dummy variables used to created interactions;
*------------------------------------------------------------*;
*------------------------------------------------------------*;
* TOOL: Score Node;
* TYPE: ASSESS;
* NODE: Score;
*------------------------------------------------------------*;


P_Logistic = 
24.0206
+ (OPT_Height	in ("01:low-0.0875"))					*	-9.2177
+ (OPT_Height	in ("02:0.0875-0.1025"))				*	-8.3556
+ (OPT_Height	in ("03:0.1025-0.1475"))				*	-6.6355
+ (OPT_ShellWeight	in ("01:low-0.08625"))				*	2.0319
+ (OPT_ShellWeight	in ("02:0.08625-0.15425"))			*	3.0659
+ (OPT_ShellWeight	in ("03:0.15425-0.35975, MISSING"))	*	4.6022
+ (OPT_VisceraWeight	in ("01:low-0.05125"))			*	-12.5921
+ (OPT_VisceraWeight	in ("02:0.05125-0.07525"))		*	-10.8954
+ (OPT_VisceraWeight	in ("03:0.07525-0.13475"))		*	-8.7530
+ (TI_Sex2	in ("0"))						*	0.7568
+ (OPT_ShuckedWeight	in ("01:low-0.11075"))			*	-0.4082
+ (OPT_ShuckedWeight	in ("02:0.11075-0.15775"))		*	-0.8002
+ (OPT_ShuckedWeight	in ("03:0.15775-0.23575"))		*	-0.9712
+ (OPT_Length	in ("01:low-0.3825"))					*	7.3092
+ (OPT_Length	in ("02:0.3825-0.4275"))				*	5.3941
+ (OPT_Length	in ("03:0.4275-0.4875"))				*	3.4068
+ (OPT_Diameter	in ("01:low-0.3025"))				*	-12.8037
+ (OPT_Diameter	in ("02:0.3025-0.3475"))			*	-11.5566
+ (OPT_Diameter	in ("03:0.3475-0.3975"))			*	-8.6841
;
P_Logistic = exp(P_Logistic) / (1+exp(P_Logistic));

P_Genmod = 
2.3899
+ (OPT_ShellWeight	in ("01:low-0.08625"))				*	-0.4788
+ (OPT_ShellWeight	in ("02:0.08625-0.15425"))			*	-0.3728
+ (OPT_ShellWeight	in ("03:0.15425-0.35975, MISSING"))		*	-0.1655
+ (OPT_Height	in ("01:low-0.0875"))					*	-0.4290
+ (OPT_Height	in ("02:0.0875-0.1025"))				*	-0.1304
+ (OPT_Height	in ("03:0.1025-0.1475"))				*	-0.0608
+ (TI_Sex2	in ("0"))							*	0.0823
+ (OPT_ShuckedWeight	in ("01:low-0.11075"))				*	0.4015
+ (OPT_ShuckedWeight	in ("02:0.11075-0.15775"))		*	0.2839
+ (OPT_ShuckedWeight	in ("03:0.15775-0.23575"))		*	0.1724
+ (OPT_VisceraWeight	in ("01:low-0.05125"))			*	-0.0484
+ (OPT_VisceraWeight	in ("02:0.05125-0.07525"))		*	0.0531
+ (OPT_VisceraWeight	in ("03:0.07525-0.13475"))		*	-0.0195
+ (OPT_WholeWeight	in ("01:low-0.28275"))				*	-0.1098
+ (OPT_WholeWeight	in ("02:0.28275-0.351"))			*	-0.1689
+ (OPT_WholeWeight	in ("03:0.351-0.63975"))			*	-0.0834
+ (OPT_Diameter	in ("01:low-0.3025"))				*	-0.0808
+ (OPT_Diameter	in ("02:0.3025-0.3475"))			*	-0.0405
+ (OPT_Diameter	in ("03:0.3475-0.3975"))			*	0.0069
+ (OPT_Length	in ("01:low-0.3825"))					*	-0.1350
+ (OPT_Length	in ("02:0.3825-0.4275"))				*	-0.0425
+ (OPT_Length	in ("03:0.4275-0.4875"))				*	-0.0102
+ (TI_Sex1	in ("0"))							*	-0.0177
;

P_Genmod = exp(P_Genmod)+1;

P_Target = P_Logistic * P_Genmod;

run;
proc means data=&scorefile. min mean max n;
run;

data Modoutput;
set &scorefile.;
keep index;
keep P_Target;

libname outfile '/folders/myfolders/sasuser.v94/Unit03/WineSales';
data outfile.Modoutput;
set Modoutput;
run;

proc print data=Modoutput;
run;

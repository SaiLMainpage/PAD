/*******************************************************************************************************************
*************************************************************************************************************
*** Program Name: create cohort USRDS

*** Author: Sai Liu

*** Project: Lower Extremity Peripheral Arterial Disease in Patients with ESRD on Dialysis

*** Purpose: create cohort

*** OS: Windows 7 Ultimate 64-bit
*** Software: SAS 9.4

*** Created on: 2021/06/02 by Sai Liu 
*** Revised on: 


*************************************************************************************************************
********************************************************************************************************************/


options PAGENO=1 nonumber label nodate nofmterr;
options formdlim=" "; /* for listing output */


*** Format library;
****************************************************************************;
libname library "U:\STANFORDPAD\processed USRDS data\format";

*** Folders for USRDS data input;
****************************************************************************;
libname core "U:\STANFORDPAD\processed USRDS data\core";  
libname payhist "U:\STANFORDPAD\processed USRDS data\payhist";

libname data "C:\Users\sliu\Box\Stanford-FMC PAD project (box admin)\Files created by STANFORD\data";
libname fmc "C:\Users\sliu\Box\Stanford-FMC PAD project (box admin)\files created by FMC";

ods html close;
ods listing;



/************************************************************************************************************
*************************************************************************************************************
** USRDS cohort for Cross-Linkage:

o	Age =67 years at first_se who initiated dialysis between 2007 and 2016. 

o	Restrict to 50 states and the District of Columbia; Puerto Rico will be excluded.  

o	Restrict to patients with Medicare Part A&B as the primary payer starting from day 91 

*************************************************************************************************************
*************************************************************************************************************/


* Age =67 years at first_se who initiated dialysis between 2007 and 2016.;
DATA step1;
	set Core.patients (in=a KEEP=USRDS_ID FIRST_SE INC_AGE INCYEAR race sex died);

	if INC_AGE >= 67;

	* year of ESRD;
	year_ESRD=year(first_se);
 
	*select incident patients between 01/01/2007-12/31/2016, so patients can at least 
	 have chance of getting into Q1;
    if "01JAN2007"d<=first_se<"31DEC2016"d; 
    
run;
*step1 - 514420;
proc sort data=step1 nodupkey;by usrds_id;run;*no dup;
proc freq data=step1;tables incyear;run;
*     Cumulative    Cumulative
                     INCYEAR    Frequency     Percent     Frequency      Percent
                     ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                        2007       49018        9.53         49018         9.53
                        2008       49470        9.62         98488        19.15
                        2009       50879        9.89        149367        29.04
                        2010       51668       10.04        201035        39.08
                        2011       50264        9.77        251299        48.85
                        2012       50279        9.77        301578        58.62
                        2013       50846        9.88        352424        68.51
                        2014       52459       10.20        404883        78.71
                        2015       54335       10.56        459218        89.27
                        2016       55202       10.73        514420       100.00;


*Restrict to 50 states and the District of Columbia, Puerto Rico will be excluded;
proc sort data=core.residenc out=residenc; by usrds_id begres;run;
proc sort data=residenc;by usrds_id;run;
proc sort data=step1;by usrds_id;run;

data step2_pre;
	merge step1(in=a) residenc(in=b keep=usrds_id state zipcode endres begres);

	by usrds_id;

	if a;

	* only keep people with residence record on first_se;
	if state^=' ' and begres<=first_se and (missing(endres) or endres>=first_se);
run;
proc sort data=step2_pre out=step2_pre_uni nodupkey;by usrds_id;run;*nodup;

data step2;
	set step2_pre;

	* Restrict to 50 states and the District of Columbia;
	format state STATECDE.;

	* define census region;
	*'Alaska','California','Hawaii','Oregon','Washington';
	if vvalue(State) in ('Alaska','California','Hawaii','Oregon','Washington') then census_region=1;	
	*'Alabama', 'Kentucky', 'Mississippi', 'Tennessee';
	else if vvalue(State) in ('Alabama', 'Kentucky', 'Mississippi', 'Tennessee') then census_region=2; 
	*'Arkansas', 'Louisiana', 'Oklahoma', 'Texas';
	else if vvalue(State) in ('Arkansas', 'Louisiana', 'Oklahoma', 'Texas') then census_region=3;
	* 'Arizona','Colorado','Idaho','New Mexico','Montana','Utah','Nevada','Wyoming';
	else if vvalue(State) in ('Arizona','Colorado','Idaho','New Mexico','Montana','Utah','Nevada','Wyoming') then census_region=4;
	else if vvalue(State) in ('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont') then census_region=5;
	else if vvalue(State) in ('Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia') then census_region=6;
	else if vvalue(State) in ('Iowa', 'Kansas', 'Minnesota', 'Missouri', 'Nebraska', 'North Dakota', 'South Dakota') then census_region=7;
	else if vvalue(State) in ('Indiana', 'Illinois', 'Michigan', 'Ohio', 'Wisconsin') then census_region=8;
	else if vvalue(State) in ('New Jersey', 'New York', 'Pennsylvania') then census_region=9;
	else if vvalue(State) in ('Puerto Rico', 'Virgin Islands','Guam','Foreign (SSA code)','American Samoa','North Mariana Islands','Pacific Trust Territories') then census_region=10;
	else if vvalue(State) = 'Unknown State' or missing(State) then census_region=.;

	if 1<=census_region<=9;
run;
*step2 - 448,679;

proc freq data=step2;
	tables census_region incyear;
run;
*    Cumulative    Cumulative
                  census_region    Frequency     Percent     Frequency      Percent
                  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                              1       43910        9.79         43910         9.79
                              2       30210        6.73         74120        16.52
                              3       35914        8.00        110034        24.52
                              4      105045       23.41        215079        47.94
                              5       28114        6.27        243193        54.20
                              6       77393       17.25        320586        71.45
                              7       62782       13.99        383368        85.44
                              8       38377        8.55        421745        94.00
                              9       26934        6.00        448679       100.00


                                      Year of first ESRD service

                                                         Cumulative    Cumulative
                     INCYEAR    Frequency     Percent     Frequency      Percent
                     ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                        2007       42927        9.57         42927         9.57
                        2008       43062        9.60         85989        19.16
                        2009       44272        9.87        130261        29.03
                        2010       45099       10.05        175360        39.08
                        2011       43731        9.75        219091        48.83
                        2012       43652        9.73        262743        58.56
                        2013       44455        9.91        307198        68.47
                        2014       45819       10.21        353017        78.68
                        2015       47392       10.56        400409        89.24
                        2016       48270       10.76        448679       100.00
;



*step3 - Restrict to patients with Medicare Part A&B as the primary payer starting from day 91;
PROC SORT DATA=step2 nodupkey; BY USRDS_ID; RUN;
PROC SORT DATA=payhist.Payhist_contmedab_prepost out=Payhist_contmedab_prepost; BY USRDS_ID; RUN;

DATA step3_pre(drop=adj_begdate rename=(adj_enddate=enddate_medAB));
	MERGE step2(in=a) 
          Payhist_contmedab_prepost(in=b);  
	BY USRDS_ID;
	if a and b;   
	if adj_begdate<=first_se and (first_se<=adj_enddate or missing(adj_enddate));
RUN; 
proc sort data=step3_pre;by usrds_id desending enddate_medab;run;
proc sort data=step3_pre out=step3 nodupkey; by usrds_id;run;*281180;
proc freq data=step3;tables incyear;run;
* Cumulative    Cumulative
                     INCYEAR    Frequency     Percent     Frequency      Percent
                     ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                        2007       29479       10.48         29479        10.48
                        2008       29109       10.35         58588        20.84
                        2009       29206       10.39         87794        31.22
                        2010       29448       10.47        117242        41.70
                        2011       28136       10.01        145378        51.70
                        2012       27403        9.75        172781        61.45
                        2013       27139        9.65        199920        71.10
                        2014       27139        9.65        227059        80.75
                        2015       27037        9.62        254096        90.37
                        2016       27084        9.63        281180       100.00
;

proc sort data=step3 out=data.step3;by usrds_id;run;
proc sort data=step3(keep=usrds_id) out=data.USRDSID_for_crosswalk;by usrds_id;run;


proc sort data=fmc.pt out=fmc_pt(keep=usrds_id first_Se) nodupkey;by usrds_id;run;
proc sort data=data.step3 out=step3;by usrds_id;run;

data step4;
	merge fmc_pt(in=a) step3;
	if a;
	by usrds_id;
run;
proc sort data=step4 out=data.step4;by usrds_id;run;

****PART 1 STOPS HERE;



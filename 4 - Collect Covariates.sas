options PAGENO=1 nonumber label nodate nofmterr;
options formdlim=" "; /* for listing output */

libname claims "N:\Data\USRDS_currentdata\claims";
libname inc "N:\Data\USRDS_currentdata\inc";
libname data "C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\data";
libname core "N:\Data\USRDS_currentdata\core";
libname census "N:\Projects\general data or programming\census data\Ready-to-use datasets";
libname como "C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\como";

ods html close;
ods listing;

/*
Demographics and Socioeconomic Indicators.  
•	age, sex, race (white, black, Asian, other race), 
	cause of ESRD and Hispanic ethnicity (patient’s file->2728 form) 
•	patient’s employment status (Using the Medical Evidence Report). 
•	dual Medicaid-Medicare eligibility and socioeconomic status (2728 form & census data). 
•	Modality type prior to indexdate?
•	Dialysis vintage prior to indexdate?

*/
proc sort data=data.step8 out=cohort;by usrds_id;run;
proc sort data=core.patients out=patients(keep=usrds_id inc_age sex race pdis);by usrds_id;run;

data cov1;
	merge cohort(in=a) patients;
	if a;
	by usrds_id;

	/*CAUSE OF ESRD - DM*/
	if PDIS in: ('250') then cause_esrd_DM = 1; else cause_esrd_DM = 0;

	/*CAUSE OF ESRD - HTN*/
	if PDIS in ('4010' '4010Z' '4011' '4011Z' '4019' '4019Z'
				'401Z' '4030Z' '4031Z' '4039' '40391' '40391Y' '4039D' '4039Z'
			    '403Z' '4040Z' '4041Z' '4049' '4049Z' '404Z'
				'4401' '4401A' '4401Y' '4401Z') 
	then cause_esrd_HTN =1; else cause_esrd_HTN = 0;

	/*CAUSE OF ESRD - GD*/
	if PDIS in: ('5829', '5821', '5831', '58321', '58322', '58381',	'58382', '5834', '5800', '5820',
	'7100', '2870', '4460', '4464', '58392', '44620', '44621', '58391') then cause_esrd_GD = 1; else cause_esrd_GD = 0;

	/*CAUSE OF ESRD - OTHER*/
	if cause_esrd_DM ne 1 and cause_esrd_HTN ne 1 and cause_esrd_GD ne 1 then cause_esrd_other = 1; else cause_esrd_other = 0;

	/*CAUSE OF ESRD*/
	if cause_esrd_DM = 1 then cause_esrd = 1;
	else if cause_esrd_HTN = 1 then cause_esrd = 2;
	else if cause_esrd_GD = 1 then cause_esrd = 3;
	else if cause_esrd_other = 1 then cause_esrd = 4;
	if missing(pdis) then cause_esrd=.;

	*RACE;
	if race=1 then racecat=1;*White;
	else if race=2 then racecat=2;*Black;
	else if race=4 then racecat=3;*Asian;
	else racecat=4; *other - Native Amer+Unknown;

	drop pdis cause_esrd_DM cause_esrd_HTN cause_esrd_GD cause_esrd_other;
run;
proc sort data=cov1;by usrds_id;run;


*hispanic - take the closest version;
proc sort data=core.medevid out=medevid (where=(not missing(crdate) and FORMVERSION in (1995,2005,2015)) 
keep=usrds_id crdate ethn EMPCUR FORMVERSION) ;by usrds_id;run;
data hispanic;
	merge cov1(in=a keep=indexdate usrds_id) medevid;
	by usrds_id;
	if a;
	if crdate>indexdate then delete;
	if ethn in ('1' '2' '5') then hispanic=1; *hispanic;
 	else if ethn in ('3') then hispanic=0;*non-hispanic;
	else hispanic=.; *4-unknown and missing;
run;
proc sort data=hispanic; by usrds_id decending crdate; run;
data hispanic_uni; 
 set hispanic;
 by usrds_id;
 if first.usrds_id;
run;
proc sort data=hispanic_uni;by usrds_id;run;
data cov2;
	merge cov1(in=a) hispanic_uni(keep=usrds_id hispanic);
	if a;
	by usrds_id;
run;
proc sort data=cov2;by usrds_id;run;



*dual eligibility;
proc sort data=core.payhist (keep=usrds_id dualelig begdate enddate) out=dualelig;by usrds_id;run;
proc sort data=cov2;by usrds_id;run;
data cov3_dualelig_pre;
	merge cov2(in=a) dualelig;
	if a;
	by usrds_id;
	if begdate<=indexdate;
run;
*n=15580 - with dups;
proc sort data=cov3_dualelig_pre; by usrds_id begdate;run;
proc freq data=cov3_dualelig_pre;
	tables dualelig;
	format dualelig;
run;
data cov3_dualelig;
	set cov3_dualelig_pre(rename=(dualelig=dualelig_char));
	by usrds_id;
	if last.usrds_id;

	if dualelig_char="N" then dualelig=0;
	else if dualelig_char="Y" then dualelig=1;
	else dualelig=.;

	drop begdate enddate dualelig_char;
run;
*n=15190, 2 vars;
proc freq data=cov3_dualelig;
	tables dualelig/missing;
run;
*no missing-correct;

/************************************************************************
*** c. Census data - % unemployment, below poverty, <high school, median rent median income;
*********************************************************************/
data census_allyears_2012; set census.allyears_linearest(where=(year=2012));run;
*
census.allyears_linearest contains ACS 5yr for each year. We chose year=2011 for this project

                                  Cumulative    Cumulative
 Year    Frequency     Percent     Frequency      Percent
 ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
 1990       34729       20.00         34729        20.00
 1995       34729       20.00         69458        40.00
 2000       34729       20.00        104187        60.00
 2011       34729       20.00        138916        80.00
 2012       34729       20.00        173645       100.00
;

data censusdat(drop=ind_letter zipcode year rename=(Census_ZipCode=zipcode));
 set census_allyears_2012;

 * convert zipcode to numeric variable (delete observations with zip codes containing character first);
 if missing(zipcode) then delete;
 ind_letter= indexc(lowcase(zipcode), 'abcdefghijklmnopqrstuvwxyz');
 if ind_letter>0 then delete;
 Census_ZipCode = input(zipcode, 12.);

 label Census_ZipCode="Zipcode (form ACS 5yr 2011)";
run;

proc sort data=cov3_dualelig;by usrds_id;run;

data cov_zip;
	set cov3_dualelig(in=a rename=(zipcode=zipcode_char));
 	zipcode = input(zipcode_char, 5.);
run;

proc sort data=cov_zip; by zipcode; run;
proc sort data=censusdat; by zipcode; run;

data cov4;
	merge cov_zip(in=a) censusdat(in=b);
	by zipcode;
	if a;
	drop total_population zipcode_char;
run;
*15831, 30 vars;



*most recent modality;
proc sort data=core.rxhist60 out=rxhist60(keep=usrds_id rxgroup begdate enddate);by usrds_id desending begdate;run;
proc sort data=cov4;by usrds_id;run;
*30230;
data mostrecentmod;
	merge cov4(in=a) rxhist60(in=b);
	if a;
	by usrds_id;

	vintage=(indexdate-first_se)/365.25;

	if rxgroup in ('1' '2' '3')then modality=1;*HD;
	else if rxgroup in ('5' '7' '9') then modality=0; *PD;
	else modality=.; *missing - uncertain dialysis, discontinued dialysis, LF, recovered function;

	day_diff=abs(indexdate-enddate);

run;

proc sort data=mostrecentmod;by usrds_id day_diff;run;
data cov5;
	set mostrecentmod;
	by usrds_id;
	if first.usrds_id;
	drop day_diff rxgroup begdate enddate;
run;
*15831;
proc freq data=cov5;
	tables modality/missing;
run;
*   Cumulative    Cumulative
            modality    Frequency     Percent     Frequency      Percent
            ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
                   .         405        2.56           405         2.56
                   0         527        3.33           932         5.89
                   1       14899       94.11         15831       100.00
;

data covariates;
	set cov5;
	if vintage/365.25<=2.5 then vintage_cat=1;
	else if 2.5<vintage/365.25<=5 then vintage_cat=2;
	else if 5<vintage/365.25<=9 then vintage_cat=3;
	else if 9<vintage/365.25 then vintage_cat=4;

	age_rev=inc_age + (indexdate-first_se)/365.25;
	drop EMPCUR;
run;


proc sort data=covariates out=data.covariates;by usrds_id;run;
*15187, 35 var;





/*comorbidities*/
*save data to run como;
data forcomo;
	set data.step8;
	indexdate1=indexdate;
	indexdate2=indexdate-1;/*so as to not include indexdate*/
	format indexdate1 indexdate2 mmddyy10.;
run;
proc sort data=forcomo out=como.forcomo(keep=usrds_id indexdate1 indexdate2);by usrds_id;run;

proc sort data=como.como(rename=(idno=usrds_id)) out=como(keep=usrds_id cc01-cc36);by usrds_id;run;
*15182;


/*ascertain indicators of health status*/
data Medevid;
	set core.Medevid;
	keep usrds_id como_inamb como_intrans como_needasst 
	como_inst como_inst_al como_inst_nurs como_inst_oth
	formversion crdate; 
run;
ods listing;
proc freq data=medevid;
	tables formversion como_inamb;
	format como_inamb ;
run;
proc sort data=Medevid;by usrds_id;run;
*to get the record most clost to indexdate;
proc sort data=data.covariates out=ID;by usrds_id;run;
data Medevid_1;
	merge ID(in=a keep=usrds_id indexdate)
		  Medevid;
	if a;
	by usrds_id;
	daydiff=abs(crdate-indexdate);
run;
proc sort data=Medevid_1;by usrds_id daydiff;run;
proc sort data=Medevid_1 out=Medevid_uni nodupkey;by usrds_id;run;





*check people with history of REV 2 years prior to indexdate;
proc sort data=data.step8 out=cohort;by usrds_id;run;
proc sort data=data.HIS_revcpt_detr_2yr(keep=usrds_id clm_from rename=(clm_from=clmfrom_cpt_detr)) out=HIS_revcpt_detr;by usrds_id;run;
data pt_his_revcpt_detr;
	merge cohort(in=a keep=usrds_id first_se indexdate) 
	HIS_revcpt_detr(in=b);
	if a ;
	by usrds_id;
	if indexdate-365*2<=clmfrom_cpt_detr<indexdate;
run;
*47;
proc sort data=pt_his_revcpt_detr;by usrds_id;run;


proc sort data=data.HIS_revcpt_ps_2yr(keep=usrds_id clm_from rename=(clm_from=clmfrom_cpt_ps)) out=HIS_revcpt_ps;by usrds_id;run;
data pt_HIS_revcpt_ps;
	merge cohort(in=a keep=usrds_id first_se indexdate) 
	HIS_revcpt_ps(in=b);
	if a ;
	by usrds_id;
	if indexdate-365*2<=clmfrom_cpt_ps<indexdate;
run;
*256;
proc sort data=pt_HIS_revcpt_ps;by usrds_id;run;


proc sort data=data.HIS_revproc_2yr(keep=usrds_id clm_from rename=(clm_from=clmfrom_proc)) out=HIS_revproc;by usrds_id;run;
data pt_HIS_revproc;
	merge cohort(in=a keep=usrds_id first_se indexdate) 
	HIS_revproc(in=b);
	if a ;
	by usrds_id;
	if indexdate-365*2<=clmfrom_proc<indexdate;
run;
*83;
proc sort data=pt_HIS_revproc;by usrds_id;run;


*check people with history of AMP 2 years prior to indexdate;
proc sort data=data.HIS_ampcpt_detr_2yr out=HIS_ampcpt_detr_pt nodupkey;by usrds_id;run;
proc sort data=data.His_ampcpt_ps_2yr out=His_ampcpt_ps_pt nodupkey;by usrds_id;run;
proc sort data=data.His_ampproc_2yr out=His_ampproc_pt nodupkey;by usrds_id;run;


/**************************************************************
*check people with history of MALE 2 years prior to indexdate
**************************************************************/
proc sort data=data.step8 out=cohort;by usrds_id;run;
data cov_his_male;
	merge cohort(in=a)
		  HIS_ampcpt_detr_pt(in=b)
		  His_ampcpt_ps_pt(in=c)
		  His_ampproc_pt(in=d)
		  pt_his_revcpt_detr(in=e)
		  pt_HIS_revcpt_ps(in=f)
		  pt_HIS_revproc(in=g);
	if a and (b or c or d or e or f or g);
	by usrds_id;
	history_male=1;
run;
proc sort data=cov_his_male(keep=usrds_id history_male) out=cov_his_male_pt nodupkey;by usrds_id;run;
*417;




*putting all covariates together;
proc sort data=data.covariates out=current_cov;by usrds_id;run;
data covariates;
	merge current_cov(in=a)
		  como
		  medevid_uni(
	rename=(como_inamb=como_inamb_char
	como_intrans=como_intrans_char
	como_needasst=como_needasst_char
	como_inst=como_inst_char
	como_inst_al=como_inst_al_char
	como_inst_nurs=como_inst_nurs_char
	como_inst_oth=como_inst_oth_char
	))	
		cov_his_male_pt;
	if a;
	by usrds_id;
	if cc01=. then cc01=0;
	if cc02=. then cc02=0;
	if cc03=. then cc03=0;
	if cc04=. then cc04=0;
	if cc05=. then cc05=0;
	if cc06=. then cc06=0;
	if cc07=. then cc07=0;
	if cc08=. then cc08=0;
	if cc09=. then cc09=0;
	if cc10=. then cc10=0;
	if cc11=. then cc11=0;
	if cc12=. then cc12=0;
	if cc13=. then cc13=0;
	if cc14=. then cc14=0;
	if cc15=. then cc15=0;
	if cc16=. then cc16=0;
	if cc17=. then cc17=0;
	if cc18=. then cc18=0;
	if cc19=. then cc19=0;
	if cc20=. then cc20=0;
	if cc21=. then cc21=0;
	if cc22=. then cc22=0;
	if cc23=. then cc23=0;
	if cc24=. then cc24=0;
	if cc25=. then cc25=0;
	if cc26=. then cc26=0;
	if cc27=. then cc27=0;
	if cc28=. then cc28=0;
	if cc29=. then cc29=0;
	if cc30=. then cc30=0;
	if cc31=. then cc31=0;
	if cc32=. then cc32=0;
	if cc33=. then cc33=0;
	if cc34=. then cc34=0;
	if cc35=. then cc35=0;
	if cc36=. then cc36=0;
	if history_male=. then history_male=0;

	como_inamb=(como_inamb_char="Y");
	como_intrans=(como_intrans_char="Y");
	como_needasst=(como_needasst_char="Y");
	como_inst=(como_inst_char="Y");
	como_inst_al=(como_inst_al_char="Y");
	como_inst_nurs=(como_inst_nurs_char="Y");
	como_inst_oth=(como_inst_oth_char="Y");

	drop daydiff formversion crdate como_inamb_char como_intrans_char
	como_needasst_char como_inst_char como_inst_al_char como_inst_nurs_char como_inst_oth_char;
run;
*15187;


*save the data;
proc sort data=covariates out=data.covariates;by usrds_id;run;
*15187, 79 var;


*****stop here;








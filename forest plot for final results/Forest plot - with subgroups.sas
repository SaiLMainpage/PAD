
ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular';
RUN;
ods graphics off;


/*******************************************************************************************************************
********************************************************************************************************************
*** Program Name: Forest Plot - newer version.SAS

*** Author: Sai Liu and Maria

*** Project: UFR and Afib   

*** Reference:https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3644-2019.pdf

*** OS: Windows 7 Ultimate 64-bit

*** SAS Version: 9.4

*** Created on: 2020/08/04
*** Revised on: 
*****************************************************************************************************
********************************************************************************************************************/

*** Current date;
****************************************************************************;
%let today=%sysfunc(compress(%sysfunc(today(),yymmddd10.),'-'));
%put Today is &today.;

*** Options;
****************************************************************************;
options PAGENO=1 nonumber label nodate nofmterr;
options formdlim=" "; /* for listing output */


proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_main.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_main.csv" 
out=data dbms=csv replace; 
getnames=yes; 
run;

ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS VALUES=(0.75,1,1.25,1.5,1.75,2.0) LABEL='Adjusted HR (95%CI) for surgical vs endovascular';
RUN;
ods graphics off;
ods  graphics on / imagefmt=png imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS VALUES=(0.75,1,1.25,1.5,1.75,2.0) LABEL='Adjusted HR (95%CI) for surgical vs endovascular';
RUN;
ods graphics off;

*MALE;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_male.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_male.csv" 
out=data dbms=csv replace; 
getnames=yes; 
run;
ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular';
RUN;
ods graphics off;
ods  graphics on / imagefmt=png imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular';
RUN;
ods graphics off;



*rev;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_rev.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_rev.csv" 
out=data dbms=csv replace; 
getnames=yes; 
run;

ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;
ods  graphics on / imagefmt=png imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;



*AMP;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_amp.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_amp.csv" 
out=data dbms=csv replace; 
getnames=yes; 
run;

ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0,2.25,2.5,2.75,3.0,3.25,3.5,3.75,4.0,4.25,4.5,4.75,5.0) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;
ods  graphics on / imagefmt=png imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0,2.25,2.5,2.75,3.0,3.25,3.5,3.75,4.0,4.25,4.5,4.75,5.0) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;


*Death;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_death.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_death.csv" 
out=data dbms=csv replace; 
getnames=yes; 
run;

ods  graphics on / imagefmt=pdf imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.50,0.75,1,1.25,1.5,1.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;
ods  graphics on / imagefmt=png imagename='Forest Plot';
PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER
 SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);
 REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);
 SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);
 HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);
 YAXIS REVERSE DISPLAY=none;
 XAXIS TYPE=LOG VALUES=(0.50,0.75,1,1.25,1.5,1.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;





/**/
/**/
/**overall + subgroups/page;*/
/*proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_with subgroups.csv" */
/*out=anno dbms=csv replace; */
/*getnames=yes; */
/*run;*/
/*proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_overall - with subgroups.csv" */
/*out=data dbms=csv replace; */
/*getnames=yes; */
/*run;*/
/**/
/*ods  graphics on / imagefmt=pdf imagename='Forest Plot';*/
/*PROC SGPLOT DATA=data NOCYCLEATTRS NOAUTOLEGEND NOWALL NOBORDER*/
/* SGANNO=anno  PAD=(LEFT=50% BOTTOM=3% TOP=10%);*/
/* REFLINE 1/ AXIS=x LINEATTRS=(PATTERN=2);*/
/* SCATTER Y=varlabel X=AKI_OR / GROUP=varlabel ATTRID=my_id markerattrs=graphdata1(color=black symbol=squarefilled size=6);*/
/* HIGHLOW Y=varlabel HIGH=AKI_UCI LOW=AKI_LCI / HIGHCAP=serif LOWCAP=serif lineattrs=(color=black);*/
/* YAXIS REVERSE DISPLAY=none;*/
/* XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0, 2.25, 2.50, 2.75) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';*/
/*RUN;*/
/*ods graphics off;*/

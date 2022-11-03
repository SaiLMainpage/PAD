

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


proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\annotation_overall.csv" 
out=anno dbms=csv replace; 
getnames=yes; 
run;
proc import datafile="C:\Users\sliu\Box\Stanford-FMC PAD project\Files created by STANFORD\programs\forest plot for final results\data_overall.csv" 
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
 XAXIS TYPE=LOG VALUES=(0.75,1,1.25,1.5,1.75,2.0) LABEL='Adjusted HR (95%CI) for surgical vs endovascular (log-scale)';
RUN;
ods graphics off;




/**********************************************************************************************/
/* Title :  ca_getProperties                                                                  */
/*                                                                                            */ 
/* Description :                                                                              */
/* This program is used to get the properties of a specified repository item.                 */
/*                                                                                            */
/* Macro Parameters :                                                                         */
/*      ca_path         : The path for the item to get properties of                          */
/*      sas_dsname      : Name of the output data set (Default: WORK.CAGETPROPERTIES)         */
/*                                                                                            */
/* Output : 																				  */
/*		Message in the SAS log, SAS data set containing properties information.  			  */
/*                                                                                            */
/* CA REST APIs Used    :                                                                     */
/*  getRepositoryItems                                                                        */
/*    https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems            */
/*                                                                                            */
/* Version  :                                                                                 */
/* Since 2026.09                                                                              */
/*                                                                                            */
/*  YAML File            :                                                             		  */
/*     https://developer.sas.com/rest-apis/clinicalRepository/putRepositoryItemContent 		  */
/*                                                                                     	      */
/* Copyright 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.          	      */
/* SPDX-License-Identifier: Apache-2.0                                                 	      */
/**********************************************************************************************/
%macro ca_getProperties(
  ca_path=,
  sas_dsname=work.caGetProperties
  );

%if "&sas_dsname" EQ "" %then %let sas_dsname=work.caGetProperties;

    /* Base URI for the service call */
%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

/********* get item id *************/
filename item_id temp;
OPTIONS NONOTES; 
proc http
method="GET"
oauth_bearer=sas_services
url="&BASE_URI./clinicalRepository/repository/paths?path=&ca_path"
out=item_id;
run;
libname item_id json;
%let item_id = null;
%let message = ;
%let remediation = ;
data _null_;
    set item_id.alldata;
    if p1 = "id" then do;
    call symputx('item_id', value);
    end;
    if p1 = "remediation" then do;
    call symputx('remediation', value);
    end;
    if p1 = "message" then do;
    call symputx('message', value);
    end;
run;
OPTIONS NOTES;
%if "&item_id" = "null" %then %do;
%put ERROR: SAS Clinical Acceleration Macro: Cannot get properties.;
%put NOTE: SAS Clinical Acceleration Macro: &message;
%put NOTE: SAS Clinical Acceleration Macro: &remediation;
%end;

/********* get properties of item using id **********/
OPTIONS NONOTES;
%if "&item_id" ne "null" %then %do;
data &sas_dsname;
    set item_id.alldata;
    path = "&ca_path";
    rename p1 = name;
    drop p v;
run;
OPTIONS NOTES;
%put NOTE: SAS Clinical Acceleration Macro: Returned properties in &ca_path;
%put NOTE: SAS Clinical Acceleration Macro: Results written to &sas_dsname;
%end;
libname item_id clear;
%mend;
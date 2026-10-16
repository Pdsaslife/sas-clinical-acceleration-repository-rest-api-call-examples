/**********************************************************************************************/
/* Title :  ca_exists                                                                         */
/*                                                                                            */ 
/* Description :                                                                              */
/* Indicates whether a repository item exists.				                                  */
/*                                                                                            */
/* Macro Parameters :                                                                         */
/*      ca_path         : The path for the item to check existence of                         */
/*                                                                                            */
/* Output : 																				  */
/*		Message in the SAS log.																  */
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
%macro ca_exists(
  ca_path=,
  );
 
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
%put NOTE: SAS Clinical Acceleration Macro: &message;
%put NOTE: SAS Clinical Acceleration Macro: &remediation;
%end;
 
/********* print type of item **********/
OPTIONS NONOTES;
%if "&item_id" ne "null" %then %do;
OPTIONS NOTES;
%put NOTE: The item exists: &ca_path;
%end;
libname item_id clear;
%mend;
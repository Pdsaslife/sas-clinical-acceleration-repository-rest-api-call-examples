/**********************************************************************************************/
/* Title :  ca_getChildren                                                                    */
/*                                                                                            */ 
/* Description :                                                                              */
/* This program is used to get the children of a specified repository item.                   */
/*                                                                                            */
/* Macro Parameters :                                                                         */
/*      ca_path         : The path for the item to get children of                            */
/*      sas_dsname      : Name of the output dataset (Default: WORK.CAGETCHILDREN)            */
/*                                                                                            */
/* Output : 																				  */
/*		Message in the SAS log, SAS data set containing children information.  		     	  */
/*                                                                                            */
/* CA REST APIs Used    :                                                                     */
/*  getRepositoryItems                                                                        */
/*    https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems            */
/*  getRepositoryChildrenByParent                                                             */
/*    https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryChildrenByParent */
/*                                                                                            */
/* Version  :                                                                                 */
/* Since 2026.09                                                                              */
/*                                                                                            */
/*  YAML File            :                                                             		  */
/*     https://developer.sas.com/rest-apis/clinicalRepository/putRepositoryItemContent 		  */
/*                                                                                     	      */
/* Copyright 2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                   */
/* SPDX-License-Identifier: Apache-2.0                                                 	      */
/**********************************************************************************************/
%macro ca_getchildren(
  ca_path=,
  sas_dsname=work.caGetChildren
  ) /des='Get a list of the items in a folder in SAS Clinical Acceleration.';

  %if "&sas_dsname" EQ "" %then %let sas_dsname=work.caGetChildren;

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
%put ERROR: SAS Clinical Acceleration Macro: Item not found, get children unsuccessful.;
%put NOTE: SAS Clinical Acceleration Macro: &message;
%put NOTE: SAS Clinical Acceleration Macro: &remediation;
%end;
/********* get children of item using id **********/
filename children temp;
OPTIONS NONOTES;
%if "&item_id" ne "null" %then %do;
proc http 
method="GET"
oauth_bearer=sas_services
url="&BASE_URI./clinicalRepository/repository/items/&item_id./children"
out=children;
run;
libname children json;
data &sas_dsname;
    set children.ALLDATA;
run;
OPTIONS NOTES;
%put NOTE: SAS Clinical Acceleration Macro: Returned a list of items in &ca_path;
%put NOTE: SAS Clinical Acceleration Macro: Results written to &sas_dsname;
%end;
libname item_id clear;
libname children clear;
%mend;
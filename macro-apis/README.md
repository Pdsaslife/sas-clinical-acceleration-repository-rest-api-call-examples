# Clincal Acceleration Macros
These macros are meant to be run in a SAS Clinical Acceleration environment. Macros call the [SAS Clinical Acceleration Repository APIs](https://developer.sas.com/rest-apis/clinicalRepository). Download the macro that you are interested in and compile it. Replace the macro parameters in the macro call with the paths to itmes in your environment and run the macro call. 

Many of these macros act on "repository items," which means they can be used on both containers and files. For more information on repository items, see the [Clinical Acceleration documentation](https://go.documentation.sas.com/doc/en/crccdc/v_006/crcug/n0zi6om569oi6cn1u6crb4p4elyi.htm?requestorId=844267aa-c877-446c-b279-21f39ba385cc).

## ca_delete
### Description:
This macro is used to delete a specified item from the repository. The item is moved to the recycle bin.

### Clinical Acceleration APIs used:
[getRepositoryItems](https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems)

[deleteRepositoryItem](https://developer.sas.com/rest-apis/clinicalRepository-v3/deleteRepositoryItem)
### Macro Parameters:  
ca_path : The path for the item to be deleted
### Output:
Message in the SAS log (examples below).
##### Sucessful log message:
```
NOTE: SAS Clinical Acceleration Macro: Item was deleted: /TopContext/file.sas
```
##### Unsucessful log message:
```
ERROR: SAS Clinical Acceleration Macro: Item not deleted.
NOTE: SAS Clinical Acceleration Macro: No resource with the path "/TopContext/file.sas" was found.
NOTE: SAS Clinical Acceleration Macro: Either the path is incorrect or the desired resource does not exist.
```
### Example Call:
```
%ca_delete(ca_path=/TopContext/file.sas);
```

## ca_exists
### Description:
This macro is used to indicate whether a repository item exists.
### Clinical Acceleration APIs used:
[getRepositoryItems](https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems)
### Macro Parameters:  
ca_path : The path for the item to check existence of
### Output:
Message in the SAS log.
##### Sucessful log message:
```
NOTE: The item exists: /TopContext/file.sas
```
##### Unsucessful log message:
```
NOTE: SAS Clinical Acceleration Macro: No resource with the path "/TopContext/file.sas" was found.
NOTE: SAS Clinical Acceleration Macro: Either the path is incorrect or the desired resource does not exist.
```
### Example Call:
```
%ca_exists(ca_path=/TopContext/file.sas);
```

## ca_getChildren
### Description:
This macro is used to get the children of a specified repository item.
### Clinical Acceleration APIs used:
[getRepositoryItems](https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems)

[getRepositoryChildrenByParent]( https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryChildrenByParent)
### Macro Parameters:  
ca_path : The path for the item to get children of  
sas_dsname : Name of the output dataset (Default: WORK.CAGETCHILDREN)
### Output:
Message in the SAS log, SAS dataset containing children information.
##### Sucessful log message:
```
NOTE: SAS Clinical Acceleration Macro: Returned a list of items in /Top Context
NOTE: SAS Clinical Acceleration Macro: Results written to work.caGetChildren
```
##### Unsucessful log message:
```
ERROR: SAS Clinical Acceleration Macro: Item not found, get children unsuccessful.
NOTE: SAS Clinical Acceleration Macro: No resource with the path "/Top Context" was found.
NOTE: SAS Clinical Acceleration Macro: Either the path is incorrect or the desired resource does not exist.
```
### Example Calls:
```
%ca_getChildren(ca_path=/TopContext/file.sas);  
%ca_getChildren(ca_path=/TopContext/file.sas, sas_dsname=WORK.CHILDREN);
```

## ca_getProperties
### Description:
This macro is used to get the properties of a specified repository item.
### Clinical Acceleration APIs used:
[getRepositoryItems](https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems)
### Macro Parameters:  
ca_path : The path for the item to get properties of   
sas_dsname : Name of the output dataset (Default: WORK.CAGETPROPERTIES)
### Output:
Message in the SAS log, SAS dataset containing properties information.
#### Sucessful log message:
```
NOTE: SAS Clinical Acceleration Macro: Returned properties in /Top Context
NOTE: SAS Clinical Acceleration Macro: Results written to work.caGetProperties
```
##### Unsucessful log message:
```
ERROR: SAS Clinical Acceleration Macro: Cannot get properties.
NOTE: SAS Clinical Acceleration Macro: No resource with the path "/Top Context/" was found.
NOTE: SAS Clinical Acceleration Macro: Either the path is incorrect or the desired resource does not exist.
```
### Example Calls:
```
%ca_getProperties(ca_path=/TopContext/file.sas);  
%ca_getProperties(ca_path=/TopContext/file.sas, sas_dsname=WORK.PROPERTIES);
```

## ca_getType
### Description:
This macro is used to get the type of a specified repository item. 
### Clinical Acceleration APIs used:
[getRepositoryItems](https://developer.sas.com/rest-apis/clinicalRepository-v3/getRepositoryItems)
### Macro Parameters:  
ca_path : The path for the item to get type of
### Output:
Message in the SAS log.
##### Sucessful log message:
```
NOTE: SAS Clinical Acceleration Macro: Returned a type in /Top Context
NOTE: SAS Clinical Acceleration Macro: type: hemlock
```
##### Unsucessful log message:
```
ERROR: SAS Clinical Acceleration Macro: Cannot get type.
NOTE: SAS Clinical Acceleration Macro: No resource with the path "/Top Context" was found.
NOTE: SAS Clinical Acceleration Macro: Either the path is incorrect or the desired resource does not exist.
```
### Example Call:
```
%ca_getType(ca_path= /TopContext);
```

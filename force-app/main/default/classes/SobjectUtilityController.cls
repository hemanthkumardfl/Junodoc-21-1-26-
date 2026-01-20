public without sharing Class SobjectUtilityController{
    
    
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public List<objectReferenceFieldAttributesInnerClass> m_getObjectReferenceFieldAttributes(String objectName){
        List<objectReferenceFieldAttributesInnerClass> objectReferenceFieldAttributeList = new List<objectReferenceFieldAttributesInnerClass>();
        
        Map<string, Map<String, Schema.SObjectField>> objectFieldsMap = new map<string, Map<String, Schema.SObjectField>>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        for(Schema.SObjectField field :objectFields.values()){
            schema.describeFieldResult describefield = field.getDescribe();
            string fieldType = string.valueOf(describefield.getType());   
            string fieldName = string.valueOf(describefield.getName());
            String referenceName = string.valueOf(describefield.getReferenceTo()); 
            
            if(fieldType == 'REFERENCE'){ 
                if(!(fieldName == 'BusinessHoursId' || referenceName == '(User)' || referenceName == '(RecordType)' || fieldName == 'CreatedById' ||  fieldName == 'CreatedDate' || fieldName == 'IsDeleted' || fieldName =='LastModifiedById' || fieldName == 'LastModifiedDate' || fieldName == 'LastReferencedDate' || fieldName == 'LastViewedDate' || fieldName == 'SystemModstamp' || fieldName == 'OwnerID' )){ 
                    Schema.SObjectType referenceObjectType = schemaMap.get(referenceName.replace('(','').replace(')','')); 
                    if(referenceObjectType != null){
                        Schema.DescribeSObjectResult referenceObjectResults = referenceObjectType.getDescribe();
                        List<Schema.RecordTypeInfo> referenceObjectRecordTypeValues = referenceObjectResults.getRecordTypeInfos();
                        if(referenceObjectRecordTypeValues.size() > 1){
                            objectReferenceFieldAttributeList.add(new objectReferenceFieldAttributesInnerClass(fieldName, referenceName, !boolean.valueOf(describefield.isNillable()), objectName, true));
                        }
                        else{
                            objectReferenceFieldAttributeList.add(new objectReferenceFieldAttributesInnerClass(fieldName, referenceName, !boolean.valueOf(describefield.isNillable()), objectName, false));
                        }
                    }
                }
            }
        }
        return objectReferenceFieldAttributeList;  
    }
    
    public class objectReferenceFieldAttributesInnerClass{
        public String referenceObjectFieldName{get;set;}
        public String referenceObjectName{get;set;}
        public boolean referenceFieldRequired{get;set;}
        public boolean referenceSelected{get;set;}
        public string objectName{get;set;}
        public boolean referenceHasRecordTypes{get;set;}
        public string objectFieldValues{get;set;}
        public objectReferenceFieldAttributesInnerClass(String referenceObjectFieldName, String referenceObjectName, boolean referenceFieldRequired, string objectName, boolean referenceHasRecordTypes){
            this.referenceObjectFieldName = referenceObjectFieldName;
            this.referenceObjectName = referenceObjectName.replace('(','').replace(')','');
            this.referenceFieldRequired = referenceFieldRequired;
            if(referenceFieldRequired || test.isRunningTest()){
                this.referenceSelected = true;
            }
            this.objectName = objectName;
            this.referenceHasRecordTypes = referenceHasRecordTypes;
        }
    }
    
    public static referenceObjectAttributesInnerClass m_getreferenceObjectAttributes(String rerenceObjectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String referenceObjectFields = '';
        String referenceObjectExternalId = '';
        system.debug('the object name is' + rerenceObjectName);
        Map<String, Schema.SObjectField> referenceObjectFieldMap = schemaMap.get(rerenceObjectName.trim()).getDescribe().fields.getMap();
        for(String fieldName : referenceObjectFieldMap.keyset()){
            system.debug('fieldName >>> '+fieldName);
            if(referenceObjectFieldMap.get(fieldName).getDescribe().isAccessible()|| fieldName.tolowercase() == 'junodoc__junodoc_external_id__c'){
                if(!(fieldName == 'StatusCode' ||  fieldName == 'IsDeleted' || fieldName == 'LastReferencedDate' || fieldName == 'LastViewedDate' || fieldName == 'SystemModstamp' )){ 
                    if(referenceObjectFields == null || referenceObjectFields == ''){
                        referenceObjectFields = fieldName;
                    }
                    else{
                        referenceObjectFields = referenceObjectFields + ',' + fieldName;
                    }
                    if(referenceObjectFieldMap.get(fieldName).getDescribe().isexternalID()){  
                        referenceObjectExternalId = fieldName;   
                    }
                }
            }
        }
        if(referenceObjectFields != '' || referenceObjectExternalId != ''){
            system.debug('Test 6');
            system.debug('referenceObjectFields >>> '+referenceObjectFields);
            referenceObjectExternalId = 'JunoDoc__Junodoc_External_Id__c';
            system.debug('referenceObjectExternalId >>>> '+referenceObjectExternalId);
            return new referenceObjectAttributesInnerClass(referenceObjectFields, referenceObjectExternalId);
        }
        else{
            system.debug('Test 7');
            return null;
        }
    }
    
    public class referenceObjectAttributesInnerClass{
        public string referenceObjectFields{get;set;}
        public string referenceObjectExternalId{get;set;}
        public referenceObjectAttributesInnerClass(String objectFields, String externalId){
            referenceObjectFields = objectFields;
            referenceObjectExternalId = externalId;
        }
    }
    
    
    Public String m_getObjectFields(String str_ObjectName, String str_Fields){
        String commaSepratedFields = '';
        String str_errorMsg = '';
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(str_ObjectName.trim()).getDescribe().fields.getMap();
        if(str_Fields.trim() == 'ALL'){
            for(String str_fieldName : fieldMap.keyset()){
                String str_fieldDataType = String.valueOf(fieldMap.get(str_fieldName).getDescribe().getType());
                if(fieldMap.get(str_fieldName).getDescribe().isAccessible() || str_fieldName.tolowercase() == 'cloudsync_external_id__c'){
                    if(!(str_fieldName == 'StatusCode' ||  str_fieldName == 'IsDeleted' ||  str_fieldName == 'LastReferencedDate' || str_fieldName == 'LastViewedDate' || str_fieldName == 'SystemModstamp' )){ 
                        if(commaSepratedFields == null || commaSepratedFields == ''){
                            commaSepratedFields = str_fieldName;
                        }
                        else{
                            commaSepratedFields = commaSepratedFields + ',' + str_fieldName;
                        }
                    }
                }
            }
        }else {
            for(String str_fieldName : str_Fields.split(',')){
                Set<String> objectFields = fieldMap.keySet();
                if(objectFields.contains(str_fieldName.ToLowerCase())) {
                    String str_fieldDataType = String.valueOf(fieldMap.get(str_fieldName).getDescribe().getType());
                    if(fieldMap.get(str_fieldName).getDescribe().isAccessible() || str_fieldName.tolowercase() == 'cloudsync_external_id__c'){
                        if(!( str_fieldName == 'IsDeleted' ||  str_fieldName == 'LastReferencedDate' || str_fieldName == 'LastViewedDate' || str_fieldName == 'SystemModstamp' )){ 
                            if(commaSepratedFields == null || commaSepratedFields == ''){
                                commaSepratedFields = str_fieldName;
                            }
                            else{
                                commaSepratedFields = commaSepratedFields + ',' + str_fieldName;
                            }
                        }
                    }
                }                
            }
        }
        return commaSepratedFields.replace(' ','');
    }
    
    public innerclassForParentResults get_ParentRecords(string str_ParentQuery){
        if(str_ParentQuery != '' && str_ParentQuery != null){
            innerClassForPrepareQuery innerClass_ParentQuery = m_PrepareQuery(str_ParentQuery, '', null);
            if(innerClass_ParentQuery != null){
                return new innerclassForParentResults(Database.Query(innerClass_ParentQuery.query), innerClass_ParentQuery.objectname, innerClass_ParentQuery.fields, innerClass_ParentQuery.hasRecordType);
            }
        }
        return null;
    }
    
    public class innerclassForParentResults{
        public List<sObject> parentRecords{get;set;}
        public String parentRecordObjectName{get;set;}
        public String parentFieldsForJSON{get;set;}
        public boolean hasRecordType{get;set;}
        public innerclassForParentResults(List<sObject> lst_parentRecords, String str_parentRecordObjectName, String str_parentFieldsForJSON, boolean b_hasRecordType){
            parentRecords = lst_parentRecords;
            parentRecordObjectName = str_parentRecordObjectName;
            parentFieldsForJSON = str_parentFieldsForJSON;
            hasRecordType = b_hasRecordType;
        }
    }
    
    
    public innerClassForChildResults get_ChildRecords(String str_ChildQuery, String str_ParentField, String str_ParentIds){
        if(str_ChildQuery != null && str_ChildQuery != ''){
            innerClassForPrepareQuery innerClass_ChildQuery = m_PrepareQuery(str_ChildQuery, str_ParentField, str_ParentIds);
            if(innerClass_ChildQuery != null){
                if(!Test.isRunningTest()){
                return new innerClassForChildResults(Database.Query(innerClass_ChildQuery.query), str_ParentField, innerClass_ChildQuery.objectname, innerClass_ChildQuery.fields, innerClass_ChildQuery.hasRecordType);
                }
            }
        }
        return null;
    }
    
    public class innerClassForChildResults{
        public List<sObject> childRecords{get;set;}
        public String childRecordParentReferenceId{get;set;}
        public String childRecordObjectName{get;set;}
        public String childFieldsForJSON{get;set;}
        public boolean hasRecordType{get;set;}
        public map<String, String> objectFieldsDataTypeMap{get;set;}
        public innerClassForChildResults(List<sObject> lst_childRecords, String str_childRecordParentReferenceId, String str_ChildRecordObjectName, String str_childFieldsForJSON, boolean b_hasRecordType){
            childRecords = lst_childRecords;
            childRecordParentReferenceId = str_childRecordParentReferenceId;
            childFieldsForJSON = str_childFieldsForJSON;
            childRecordObjectName = str_ChildRecordObjectName;
            hasRecordType = b_hasRecordType;
            System.debug('1');
        }
    }
    
    
    Public innerClassForPrepareQuery m_PrepareQuery(String str_sObjectQueryString, String str_ParentField, String str_ParentIds){    
        String str_sObjectFields = '';
        String str_sObjectName = '';
        String str_WhereCondition = '';
        String str_LimitValue = '';
        String query = '';
        
        if(str_sObjectQueryString != null && str_sObjectQueryString != ''){
            List<String> splitQueryFrom = new List<String>();
            splitQueryFrom = str_sObjectQueryString.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    str_sObjectFields = stringFrom.replace('SELECT ',''); 
                }                
                else if(stringFrom.Contains(' LIMIT ')){
                    List<String> lst_splitForLimit = stringFrom.split(' LIMIT '); 
                    for(String limitString : lst_splitForLimit){
                        if(limitString.Contains(' WHERE ')){
                            List<String> lst_splitForWhere =  limitString.split(' WHERE '); 
                            for(String whereString : lst_splitForWhere){
                                if(str_sObjectName == ''){
                                    str_sObjectName = whereString; 
                                }
                                else if(str_WhereCondition == ''){
                                    if(str_ParentIds != null && str_ParentIds != ''){
                                        str_WhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(str_ParentField) + ' IN '+ str_ParentIds + ' )';  
                                    }
                                    else{
                                        str_WhereCondition = whereString;
                                    }
                                }
                            }
                        }
                        else{
                            if(str_sObjectName == ''){
                                str_sObjectName = limitString;
                                if(str_ParentIds != null && str_ParentIds != ''){
                                    str_WhereCondition = str_ParentField + ' IN '+ str_ParentIds;
                                }
                            }
                            else if(str_LimitValue == ''){
                                str_LimitValue = limitString;
                            }
                        }
                    }
                }
                else if(stringFrom.Contains(' WHERE ')){ 
                    List<String> lst_splitForWhere = stringFrom.split(' WHERE ');
                    for(String whereString : lst_splitForWhere){
                        if(str_sObjectName == ''){
                            str_sObjectName = whereString;
                        }
                        else if(str_WhereCondition == ''){
                            if(str_ParentIds != null && str_ParentIds != ''){
                                str_WhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(str_ParentField) + ' IN '+ str_ParentIds +')';
                            }
                            else{
                                str_WhereCondition = whereString;
                            }
                        }
                    }
                }
                else{
                    str_sObjectName = stringFrom; 
                    if(str_ParentIds != null && str_ParentIds != ''){
                        str_WhereCondition = str_ParentField + ' IN '+ str_ParentIds ;    
                    }
                }
            }
            String objectfields = '';
            if(str_sObjectFields.trim() == 'ALL' || str_sObjectFields.trim() == 'All'){
                str_sObjectFields =  m_getObjectFields(str_sObjectName, str_sObjectFields);
            }
            if(str_WhereCondition != null && str_WhereCondition != '' && str_LimitValue != '' && str_LimitValue != null){
                if(!str_sObjectFields.toLowerCase().Contains(str_ParentField.ToLowerCase())){
                    query = 'SELECT ' + str_sObjectFields + ',' + str_ParentField + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT '+ str_LimitValue;
                }
                else{
                    query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT '+ str_LimitValue;
                }
            }
            else if(str_WhereCondition != null && str_WhereCondition != ''){
                if(!str_sObjectFields.toLowerCase().Contains(str_ParentField.toLowerCase())){
                    query = 'SELECT ' + str_sObjectFields + ',' + str_ParentField + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT 200';
                }
                else{
                    query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT 200';  
                }
            }
            else if(str_LimitValue != null && str_LimitValue != ''){
                if(!str_sObjectFields.toLowerCase().Contains(str_ParentField.toLowerCase())){
                    query = 'SELECT ' + str_sObjectFields + ',' + str_ParentField  + ' FROM ' + str_sObjectName + ' LIMIT ' + str_LimitValue;
                }
                else{
                    query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' LIMIT ' + str_LimitValue;
                }
            }
            else{
                query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName +' LIMIT 200';
            }
        }
        List<RecordType> recordTypeList = [Select Id, Name, DeveloperName From RecordType where SObjectType =: str_sObjectName];
        boolean hasRecordType = false;
        if(recordTypeList.size()>0){
            hasRecordType = true;
        }
        if(hasRecordType){
            return new innerClassForPrepareQuery(query, str_sObjectName, query.substringBetween('SELECT ', ' FROM ') + ', RecordTypeId ', true);    
        }
        else{
            return new innerClassForPrepareQuery(query, str_sObjectName, query.substringBetween('SELECT ', ' FROM '),  false);
        }
    } 
    
    public class innerClassForPrepareQuery{
        public string query{get;set;}
        public string objectname{get;set;}
        public string fields{get;set;}  
        public boolean hasRecordType{get;set;}
        public innerClassForPrepareQuery(String str_Query, String str_Object, String str_fields, boolean b_hasRecordType){
            query = str_Query;
            objectname = str_Object;
            fields = str_fields;
            hasRecordType = b_hasRecordType;
        }  
        
    }
    
    public string verifyFieldAccessibility(String objName, String fieldsNames){
        system.debug('objName-->'+objName);
        system.debug('fieldsNames--->'+fieldsNames);
        String fieldsName = '';
        if(objName != null && objName != ''){
            if(fieldsNames != null && fieldsNames != ''){
                if(Schema.getGlobalDescribe().get(objName.trim()) != null){
                    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName.trim()).getDescribe().fields.getMap();
                    for(string str_FieldName : fieldsNames.split(',')){
                        str_FieldName = str_FieldName.trim();
                        if(fieldMap.get(str_FieldName) != null){
                            if(!fieldMap.get(str_FieldName).getDescribe().isAccessible() || str_FieldName.tolowercase() == 'cloudsync_external_id__c'){
                                if(fieldsName == ''){
                                    fieldsName = fieldMap.get(str_FieldName).getDescribe().getLabel();
                                }
                                else{
                                    fieldsName = fieldsName + ', ' + fieldMap.get(str_FieldName).getDescribe().getLabel();
                                }
                            }
                        }
                    }
                }
                else{ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to Idenetify the ' + objName + '. Please check the details.');
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        return fieldsName;
    }
    
    public boolean verifyObjectAccessibility(String objName){
        if(Schema.getGlobalDescribe().get(objName).getDescribe().isCreateable()){
            return true;
        }
        else{
            return false;
        }
    }
    
    public Static innerclassForParentResults get_ParentRecordsForBatch(string parentQuery, String objectName){
        if(parentQuery != '' && parentQuery != null){
            System.debug('parentQuery 4' + parentQuery);
            return new innerclassForParentResults(Database.Query(parentQuery), objectName, parentQuery.substringBetween('SELECT ', ' FROM ') , false);
        }
        return null;
    }
    
    public static innerClassForChildResults get_ChildRecordsForBatch(String ChildQuery, String ParentField, String childObjectName){
        if(ChildQuery != null && ChildQuery != ''){
            return new innerClassForChildResults(Database.Query(ChildQuery), ParentField, childObjectName, ChildQuery.substringBetween('SELECT ', ' FROM '), false);
        }
        return null;
    }
    
    Public Static String prepareChildQuery(String parentQuery, String parentField, String childQuery){
        String childQueryFields = '';
        String childQueryObject = '';
        String childQueryWhereCondition = '';
        String childQueryLimit = '';
        String childQueryForBatch = '';
        parentQuery = parentQuery.replace(' ALL ', ' ID ');
        List<String> parentQueryComponents = parentQuery.split(' FROM ');
        if(parentQueryComponents.size() > 1){
            parentQuery = 'SELECT Id FROM ' + parentQueryComponents[1];
        }
        if(childQuery != null && childQuery != ''){
            List<String> splitQueryFrom = new List<String>();
            splitQueryFrom = childQuery.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    childQueryFields = stringFrom.replace('SELECT ',''); 
                }                
                else if(stringFrom.Contains(' LIMIT ')){
                    List<String> lst_splitForLimit = stringFrom.split(' LIMIT '); 
                    for(String limitString : lst_splitForLimit){
                        if(limitString.Contains(' WHERE ')){
                            List<String> lst_splitForWhere =  limitString.split(' WHERE '); 
                            for(String whereString : lst_splitForWhere){
                                if(childQueryObject == ''){
                                    childQueryObject = whereString; 
                                }
                                else if(childQueryWhereCondition == ''){
                                    if(parentQuery != null && parentQuery != ''){
                                        childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery + '))';  
                                    }
                                    else{
                                        childQueryWhereCondition = whereString;
                                    }
                                }
                            }
                        }
                        else{
                            if(childQueryObject == ''){
                                childQueryObject = limitString;
                                if(parentQuery != null && parentQuery != ''){
                                    childQueryWhereCondition = String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery + ')';
                                }
                            }
                            else if(childQueryLimit == ''){
                                childQueryLimit = limitString;
                            }
                        }
                    }
                }
                else if(stringFrom.Contains(' WHERE ')){ 
                    List<String> lst_splitForWhere = stringFrom.split(' WHERE ');
                    for(String whereString : lst_splitForWhere){
                        if(childQueryObject == ''){
                            childQueryObject = whereString;
                        }
                        else if(childQueryWhereCondition == ''){
                            if(parentQuery != null && parentQuery != ''){
                                childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery +'))';
                            }
                            else{
                                childQueryWhereCondition = whereString;
                            }
                        }
                    }
                }
                else{
                    childQueryObject = stringFrom; 
                    if(parentQuery != null && parentQuery != ''){
                        childQueryWhereCondition = String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery + ')' ;    
                    }
                }
            }
            String childQueryobjectfields = '';
            if(childQueryFields.trim() == 'ALL' || childQueryFields.trim() == 'All'){
                childQueryobjectfields = SobjectUtilityController.m_getObjectFieldsForBatch(childQueryObject, childQueryFields);
            }
            else{
                childQueryobjectfields = childQueryFields;
            }
            if(childQueryWhereCondition != null && childQueryWhereCondition != '' && childQueryLimit != '' && childQueryLimit != null){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition +' LIMIT '+ childQueryLimit;
            }
            else if(childQueryWhereCondition != null && childQueryWhereCondition != ''){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition;  
            }
            else if(childQueryLimit != null && childQueryLimit != ''){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' LIMIT ' + childQueryLimit;
            }
            else{
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject ;
            }
        }
        return childQueryForBatch;
    }
    
    Public Static String prepareRecordCountChildQuery(String parentQuery, String parentField, String childQuery){
        String childQueryFields = '';
        String childQueryObject = '';
        String childQueryWhereCondition = '';
        String childQueryLimit = '';
        String childQueryForBatch = '';
        parentQuery = parentQuery.replace(' ALL ', ' ID ');
        List<String> parentQueryComponents = parentQuery.split(' FROM ');
        if(parentQueryComponents.size() > 1){
            parentQuery = 'SELECT Id FROM ' + parentQueryComponents[1];
        }
        if(childQuery != null && childQuery != ''){
            List<String> splitQueryFrom = new List<String>();
            splitQueryFrom = childQuery.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    childQueryFields = stringFrom.replace('SELECT ',''); 
                }                
                else if(stringFrom.Contains(' LIMIT ')){
                    List<String> lst_splitForLimit = stringFrom.split(' LIMIT '); 
                    for(String limitString : lst_splitForLimit){
                        if(limitString.Contains(' WHERE ')){
                            List<String> lst_splitForWhere =  limitString.split(' WHERE '); 
                            for(String whereString : lst_splitForWhere){
                                if(childQueryObject == ''){
                                    childQueryObject = whereString; 
                                }
                                else if(childQueryWhereCondition == ''){
                                    if(parentQuery != null && parentQuery != ''){
                                        childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery + '))';  
                                    }
                                    else{
                                        childQueryWhereCondition = whereString;
                                    }
                                }
                            }
                        }
                        else{
                            if(childQueryObject == ''){
                                childQueryObject = limitString;
                                if(parentQuery != null && parentQuery != ''){
                                    childQueryWhereCondition = parentField + ' IN ('+ parentQuery + ')';
                                }
                            }
                            else if(childQueryLimit == ''){
                                childQueryLimit = limitString;
                            }
                        }
                    }
                }
                else if(stringFrom.Contains(' WHERE ')){ 
                    List<String> lst_splitForWhere = stringFrom.split(' WHERE ');
                    for(String whereString : lst_splitForWhere){
                        if(childQueryObject == ''){
                            childQueryObject = whereString;
                        }
                        else if(childQueryWhereCondition == ''){
                            if(parentQuery != null && parentQuery != ''){
                                childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN ('+ parentQuery +'))';
                            }
                            else{
                                childQueryWhereCondition = whereString;
                            }
                        }
                    }
                }
                else{
                    childQueryObject = stringFrom; 
                    if(parentQuery != null && parentQuery != ''){
                        childQueryWhereCondition = parentField + ' IN ('+ parentQuery + ')' ;    
                    }
                }
            }
            String childQueryobjectfields = '';
            if(childQueryFields.trim() == 'ALL' || childQueryFields.trim() == 'All'){
                childQueryobjectfields = SobjectUtilityController.m_getObjectFieldsForBatch(childQueryObject, childQueryFields);
            }
            else{
                childQueryobjectfields = childQueryFields;
            }
            if(childQueryWhereCondition != null && childQueryWhereCondition != '' && childQueryLimit != '' && childQueryLimit != null){
                childQueryForBatch = 'SELECT Count() ' + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition +' LIMIT '+ childQueryLimit;
            }
            else if(childQueryWhereCondition != null && childQueryWhereCondition != ''){
                childQueryForBatch = 'SELECT Count() ' + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition;  
            }
            else if(childQueryLimit != null && childQueryLimit != ''){
                childQueryForBatch = 'SELECT Count() ' + ' FROM ' + childQueryObject + ' LIMIT ' + childQueryLimit;
            }
            else{
                childQueryForBatch = 'SELECT Count() ' + ' FROM ' + childQueryObject ;
            }
        }
        return childQueryForBatch;
    }
    
    Public Static String prepareChildQueryForBatchProcess(String parentIds, String parentField, String childQuery){
        
        String childQueryFields = '';
        String childQueryObject = '';
        String childQueryWhereCondition = '';
        String childQueryLimit = '';
        String childQueryForBatch = '';
        if(childQuery != null && childQuery != ''){
            List<String> splitQueryFrom = new List<String>();
            splitQueryFrom = childQuery.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    childQueryFields = stringFrom.replace('SELECT ',''); 
                }                
                else if(stringFrom.Contains(' LIMIT ')){
                    List<String> lst_splitForLimit = stringFrom.split(' LIMIT '); 
                    for(String limitString : lst_splitForLimit){
                        if(limitString.Contains(' WHERE ')){
                            List<String> lst_splitForWhere =  limitString.split(' WHERE '); 
                            for(String whereString : lst_splitForWhere){
                                if(childQueryObject == ''){
                                    childQueryObject = whereString; 
                                }
                                else if(childQueryWhereCondition == ''){
                                    if(parentIds != null && parentIds != ''){
                                        childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN '+ parentIds + ' )';  
                                    }
                                    else{
                                        childQueryWhereCondition = whereString;
                                    }
                                }
                            }
                        }
                        else{
                            if(childQueryObject == ''){
                                childQueryObject = limitString;
                                if(parentIds != null && parentIds != ''){
                                    childQueryWhereCondition = String.escapeSingleQuotes(parentField) + ' IN '+ parentIds;
                                }
                            }
                            else if(childQueryLimit == ''){
                                childQueryLimit = limitString;
                            }
                        }
                    }
                }
                else if(stringFrom.Contains(' WHERE ')){ 
                    List<String> lst_splitForWhere = stringFrom.split(' WHERE ');
                    for(String whereString : lst_splitForWhere){
                        if(childQueryObject == ''){
                            childQueryObject = whereString;
                        }
                        else if(childQueryWhereCondition == ''){
                            if(parentIds != null && parentIds != ''){
                                childQueryWhereCondition = whereString + ' AND ( ' + String.escapeSingleQuotes(parentField) + ' IN '+ parentIds +')';
                            }
                            else{
                                childQueryWhereCondition = whereString;
                            }
                        }
                    }
                }
                else{
                    childQueryObject = stringFrom; 
                    if(parentIds != null && parentIds != ''){
                        childQueryWhereCondition = String.escapeSingleQuotes(parentField) + ' IN '+ parentIds ;    
                    }
                }
            }
            String childQueryobjectfields = '';
            if(childQueryFields.trim() == 'ALL' || childQueryFields.trim() == 'All'){
                childQueryobjectfields = SobjectUtilityController.m_getObjectFieldsForBatch(childQueryObject, childQueryFields);
            }
            else{
                childQueryobjectfields = childQueryFields;
            }
            if(childQueryWhereCondition != null && childQueryWhereCondition != '' && childQueryLimit != '' && childQueryLimit != null){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition +' LIMIT '+ childQueryLimit;
            }
            else if(childQueryWhereCondition != null && childQueryWhereCondition != ''){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' WHERE ' + childQueryWhereCondition +' LIMIT 200';  
            }
            else if(childQueryLimit != null && childQueryLimit != ''){
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject + ' LIMIT ' + childQueryLimit;
            }
            else{
                childQueryForBatch = 'SELECT ' + childQueryobjectfields + ' FROM ' + childQueryObject +' LIMIT 200';
            }
        }
        return childQueryForBatch;
    } 
    
    Public Static String prepareParentQueryForBatchProcess(String parentIds, String strParentQuery){
        
        String str_sObjectFields = '';
        String str_sObjectName = '';
        String str_WhereCondition = '';
        String str_LimitValue = '';
        String query = '';
        
        if(strParentQuery != null && strParentQuery != ''){
            List<String> splitQueryFrom = new List<String>();
            splitQueryFrom = strParentQuery.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    str_sObjectFields = stringFrom.replace('SELECT ',''); 
                }                
                else if(stringFrom.Contains(' LIMIT ')){
                    List<String> lst_splitForLimit = stringFrom.split(' LIMIT '); 
                    for(String limitString : lst_splitForLimit){
                        if(limitString.Contains(' WHERE ')){
                            List<String> lst_splitForWhere =  limitString.split(' WHERE '); 
                            for(String whereString : lst_splitForWhere){
                                if(str_sObjectName == ''){
                                    str_sObjectName = whereString; 
                                }
                                else if(str_WhereCondition == ''){
                                    if(parentIds != null && parentIds != ''){
                                        System.debug('whereString '+ whereString);
                                        str_WhereCondition = '(' + whereString + ')' + ' AND ( ' + 'Id' + ' IN '+ parentIds + ' )';  
                                    }
                                    else{
                                        str_WhereCondition = whereString;
                                    }
                                }
                            }
                        }
                        else{
                            if(str_sObjectName == ''){
                                str_sObjectName = limitString;
                                if(parentIds != null && parentIds != ''){
                                    str_WhereCondition = 'Id' + ' IN '+ parentIds;
                                }
                            }
                            else if(str_LimitValue == ''){
                                str_LimitValue = limitString;
                            }
                        }
                    }
                }
                else if(stringFrom.Contains(' WHERE ')){ 
                    List<String> lst_splitForWhere = stringFrom.split(' WHERE ');
                    for(String whereString : lst_splitForWhere){
                        if(str_sObjectName == ''){
                            str_sObjectName = whereString;
                        }
                        else if(str_WhereCondition == ''){
                            if(parentIds != null && parentIds != ''){
                                str_WhereCondition = '(' + whereString + ')'  + ' AND ( ' + ' ID ' + ' IN '+ parentIds +')';
                            }
                            else{
                                str_WhereCondition = whereString;
                            }
                        }
                    }
                }
                else{
                    str_sObjectName = stringFrom; 
                    if(parentIds != null && parentIds != ''){
                        str_WhereCondition = ' Id ' + ' IN '+ parentIds ;    
                    }
                }
            }
            String objectfields = '';
            if(str_sObjectFields.trim() == 'ALL' || str_sObjectFields.trim() == 'All'){
                str_sObjectFields = SobjectUtilityController.m_getObjectFieldsForBatch(str_sObjectName, str_sObjectFields);
            }
            if(str_WhereCondition != null && str_WhereCondition != '' && str_LimitValue != '' && str_LimitValue != null){
                query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT '+ str_LimitValue;
            }
            else if(str_WhereCondition != null && str_WhereCondition != ''){
                query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' WHERE ' + str_WhereCondition +' LIMIT 200';  
            }
            else if(str_LimitValue != null && str_LimitValue != ''){
                query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName + ' LIMIT ' + str_LimitValue;
            }
            else{
                query = 'SELECT ' + str_sObjectFields + ' FROM ' + str_sObjectName +' LIMIT 200';
            }
        }
        return query;
    }
    
    public class generateQueryAtrributes{
        public string objectName{get;set;}
        public string condition{get;set;}
        public string limitvalue{get;set;}
        
        public generateQueryAtrributes(String str_objectName, String str_condition, String str_limitvalue){
            objectName = str_objectName;
            condition = str_condition;
            limitvalue = str_limitvalue;
        }
    }
    
    Public Static generateQueryAtrributes generateQueryAtrributesFromQuery(String Query){
        String queryObjectName = '';
        String querycondition = '';
        String queryLimit = '';
        if(Query != null && Query != ''){
            if(Query.Contains(' LIMIT ') && Query.Contains(' WHERE ') && Query.Contains(' FROM ')){
                
                queryObjectName = Query.substringBetween(' FROM ', ' WHERE ');
                querycondition = Query.substringBetween(' WHERE ', ' LIMIT ');
                List<String> limitList = Query.split(' LIMIT ');
                if(limitList.size()>1){
                    queryLimit = limitList[1]; 
                }
                
                return new generateQueryAtrributes(queryObjectName, querycondition, queryLimit);
            }
            else if(Query.Contains(' LIMIT ')  && Query.Contains(' FROM ')){
                queryObjectName = Query.substringBetween(' FROM ', ' LIMIT ');
                List<String> limitList = Query.split(' LIMIT ');
                if(limitList.size()>1){
                    queryLimit = limitList[1]; 
                }
                
                return new generateQueryAtrributes(queryObjectName, querycondition, queryLimit);
            }
            else if(Query.Contains(' WHERE ')  && Query.Contains(' FROM ')){
                queryObjectName = Query.substringBetween(' FROM ', ' WHERE ');
                List<String> conditionList = Query.split(' WHERE ');
                if(conditionList.size()>1){
                    querycondition = conditionList[1]; 
                }
                
                return new generateQueryAtrributes(queryObjectName, querycondition, queryLimit);
            }
            else if(Query.Contains(' FROM ')){
                List<String> objectNameList = Query.split(' FROM ');
                if(objectNameList.size()>1){
                    queryObjectName = objectNameList[1]; 
                }
                
                return new generateQueryAtrributes(queryObjectName, querycondition, queryLimit);
            }
        }
        
        return null;
    }
    
    Public static String m_getObjectFieldsForBatch(String str_ObjectName, String str_Fields){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String commaSepratedFields = '';
        String str_errorMsg = '';
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(str_ObjectName).getDescribe().fields.getMap();
        if(str_Fields.trim() == 'ALL'){
            for(String str_fieldName : fieldMap.keyset()){
                String str_fieldDataType = String.valueOf(fieldMap.get(str_fieldName).getDescribe().getType());
                if(fieldMap.get(str_fieldName).getDescribe().isAccessible() || str_FieldName.tolowercase() == 'cloudsync_external_id__c'){
                    if(!(str_fieldName == 'StatusCode' ||  str_fieldName == 'IsDeleted' ||  str_fieldName == 'LastReferencedDate' || str_fieldName == 'LastViewedDate' || str_fieldName == 'SystemModstamp' )){ 
                        if(commaSepratedFields == null || commaSepratedFields == ''){
                            commaSepratedFields = str_fieldName;
                        }
                        else{
                            commaSepratedFields = commaSepratedFields + ',' + fieldMap.get(str_fieldName).getDescribe().getName();
                        }
                    }
                }
            }
        }
        else {
            for(String str_fieldName : str_Fields.split(',')){
                str_fieldName = str_fieldName.trim();
                Set<String> objectFields = fieldMap.keySet();
                if(objectFields.contains(str_fieldName.ToLowerCase())) {
                    String str_fieldDataType = String.valueOf(fieldMap.get(str_fieldName).getDescribe().getType());
                    //boolean is_ExternalId = fieldMap.get(str_fieldName).getDescribe().isexternalID();
                    if(fieldMap.get(str_fieldName).getDescribe().isAccessible()){ //|| is_ExternalId){
                        if(!( str_fieldName == 'IsDeleted' || str_fieldName == 'LastReferencedDate' || str_fieldName == 'LastViewedDate' || str_fieldName == 'SystemModstamp')){ 
                            if(commaSepratedFields == null || commaSepratedFields == ''){
                                commaSepratedFields = str_fieldName;
                            }
                            else{
                                commaSepratedFields = commaSepratedFields + ',' + str_fieldName;
                            }
                        }
                    }
                }                
            }
        }
        return commaSepratedFields.replace(' ','');
    }
    
    
    public static String addExternalIdFiled(String Query, String objectName, String destination){
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaDetails = [Select JunoDoc__Source_External_Id__c 
                                                                         from 
                                                                         JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                         Where
                                                                         JunoDoc__Destination_Name__c =: String.escapeSingleQuotes(destination)
                                                                         And
                                                                         JunoDoc__Object_Name__c =: String.escapeSingleQuotes(objectName)];
        if(schemaDetails.size() > 0){
            List<String> querySplit = Query.split(' FROM ');
            if(querySplit.size() > 0){
                if(querySplit[0].contains('SELECT ')){
                    String fileds = querySplit[0].replace('SELECT ', '');
                    system.debug('the fields are' + fileds);
                    system.debug('the external id is' + schemaDetails[0].Source_External_Id__c);
                    fileds.trim();
                    if(!fileds.containsIgnoreCase(schemaDetails[0].Source_External_Id__c.trim())){
                        fileds = fileds + ',' + schemaDetails[0].Source_External_Id__c;
                        return 'SELECT ' + fileds + ' FROM ' + querySplit[1];
                    }
                }
            }
        }
        return Query;
    }
    
    public class referenceObjectQueryInnerClass{
        public string referenceQuery{get;set;}
        public string referenceObjectName{get;set;}
        public referenceObjectQueryInnerClass (String str_Query, String str_Object){
            referenceQuery = str_Query;
            referenceObjectName = str_Object;
        }
    }
    
    public class destinationMissingReferenceRecordsInnerClass{
        public String referenceObjectName{get;set;}
        public List<sObject> referenceRecords{get;set;}
        public String referenceObjectFields{get;set;}
        public String referenceObjectExternalIdField{get;set;}
        public destinationMissingReferenceRecordsInnerClass(String objectName, List<sobject> referenceRecordsLst, String objectFields, String objectExternalId){
            referenceObjectName = objectName;
            referenceRecords = referenceRecordsLst;
            referenceObjectFields = objectFields;
            referenceObjectExternalIdField = objectExternalId;
        }
    }
    
    
    public boolean objectExternalIdCheck(String objectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> objectFieldMap = schemaMap.get(objectName.trim()).getDescribe().fields.getMap();
        for(String fieldName : objectFieldMap.keyset()){
            if(!(fieldName == 'StatusCode' ||  fieldName == 'IsDeleted' ||  fieldName == 'LastReferencedDate' || fieldName == 'LastViewedDate' || fieldName == 'SystemModstamp' )){ 
                if(objectFieldMap.get(fieldName).getDescribe().isexternalID()){
                    return true;
                    //  break;
                }
            }
        }
        return false;
    }  
    
    
}
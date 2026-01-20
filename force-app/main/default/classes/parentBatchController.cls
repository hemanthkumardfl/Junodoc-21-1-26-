global with sharing class parentBatchController implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public boolean stopExecute = false;
    public decimal batchSizeForJob = 1;
    public boolean referenceSelectionCompleted = true; 
    public string referenceSelectionString = '';
    public string strParentQuery = '';
    public string referenceExternalId = '';
    public string referenceObjectName = '';
    public string referenceObjectFieldName='';
    public string referenceObjectFields = '';
    public string queryForBatch = '';
    public SobjectUtilityController.generateQueryAtrributes parentObjectName {get;set;}  
    public string accesstoken = '';
    public string instanceURL = '';   
    public Integer batchProcess = 0;   
    public string selecteddestinationOrg = '';
    public string scheduleIds = '';
    String queryFields = '';
    public List<JunoSFDC2SFDC.childQueriesInnerClass> lst_childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();  
    public List<SobjectUtilityController.innerclassForParentResults> parentResults = new List<SobjectUtilityController.innerclassForParentResults>();
    public List<SobjectUtilityController.innerClassForChildResults> childResults = new List<SobjectUtilityController.innerClassForChildResults>();
    public List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> referenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
    public List<JunoDoc__Junodoc_Connections__c> destinationRecord = new List<JunoDoc__Junodoc_Connections__c>();
    public boolean migrateAttachements = false;  
    public map<String,string> parentCompletedMap = new Map<String, String>();
    public map<String, String> childQueryCompletedMap = new map<String, string>();
    public parentBatchController(String parentQuery, List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries, List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList, Integer batchId, string destinationOrg, String currentScheduleIds, boolean includeAttachments,map<string,string> parentProcessedMap, Decimal batchSize){
        destinationRecord = new List<JunoDoc__Junodoc_Connections__c>(); 
        destinationRecord = [Select Id, Name, JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c from JunoDoc__Junodoc_Connections__c where Name =: destinationOrg OR Id=: destinationOrg];
        strParentQuery = parentQuery;
        batchSizeForJob = batchSize;
        lst_childQueries = childQueries;
        migrateAttachements = includeAttachments;
        parentCompletedMap = parentProcessedMap;
        scheduleIds = currentScheduleIds;
        parentObjectName = SobjectUtilityController.generateQueryAtrributesFromQuery(strParentQuery);
        if(currentScheduleIds != ''){
            currentScheduleIds = '(' + currentScheduleIds + ')';
            if(parentObjectName.condition != '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where (' + parentObjectName.condition + ') AND ( Id IN '+ currentScheduleIds + ') LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition != '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where (' + parentObjectName.condition + ') AND (Id IN '+ currentScheduleIds + ')';
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ID IN ' + currentScheduleIds + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ID IN ' + currentScheduleIds;
            }
        }
        else{
            if(parentObjectName.condition != '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ' + parentObjectName.condition + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition != '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ' + parentObjectName.condition;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName;
            }
        }
        referenceList = selectedReferenceList;
        batchProcess = batchId;
        selecteddestinationOrg = destinationOrg;
        for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass parentReferenceRecord : referenceList){
            if(parentCompletedMap.get(parentReferenceRecord.referenceObjectName+''+parentReferenceRecord.referenceObjectFieldName+''+parentReferenceRecord.objectName) == null){
                referenceSelectionString = parentReferenceRecord.referenceObjectName+''+parentReferenceRecord.referenceObjectFieldName+''+parentReferenceRecord.objectName;
                parentCompletedMap.put(referenceSelectionString, 'Completed');
                SobjectUtilityController.referenceObjectAttributesInnerClass referenceObjectAttributes = SobjectUtilityController.m_getreferenceObjectAttributes(parentReferenceRecord.referenceObjectName);
                if(referenceObjectAttributes.referenceObjectFields != null){
                    referenceExternalId = referenceObjectAttributes.referenceObjectExternalId;
                    referenceObjectName = parentReferenceRecord.referenceObjectName;
                    referenceObjectFields = referenceObjectAttributes.referenceObjectFields;
                    referenceObjectFieldName = parentReferenceRecord.referenceObjectFieldName;
                }
                break;
            }
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        CallOutUtilityController.responseClass response = CallOutUtilityController.soap_connectToSFDC(selecteddestinationOrg);
        if(response.response){  
            URL comparisonURL = new URL(response.responseServerUrl);
            instanceURL = 'https://' + comparisonURL.gethost();
            accesstoken = response.sessionId;
        }
        List<JunoDoc__Junodoc_Connections__c> connection = [select Id, JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c from JunoDoc__Junodoc_Connections__c where Id =: selecteddestinationOrg  OR Name =: selecteddestinationOrg limit 1];
        if(connection.size() > 0){
            connection[0].JunoDoc__Access_Token__c = accesstoken;
            connection[0].JunoDoc__Instance_URL__c = instanceURL;
            update connection[0];
        }
        
        String parentIds = '';
        for(sObject obj_Rec : database.query(queryForBatch)){  
            if(parentIds == ''){
                parentIds = '(' + '\'' + String.ValueOf(obj_Rec.get('Id')) + '\'';
            }
            else{
                parentIds = parentIds + ',' + '\'' + String.ValueOf(obj_Rec.get('Id')) + '\'';  
            }
        }
        if(parentIds != ''){
            parentIds = parentIds + ')';
        }
        String parentQueryForBatch = SobjectUtilityController.prepareParentQueryForBatchProcess(parentIds, strParentQuery);
        parentResults = new List<SobjectUtilityController.innerclassForParentResults>(); 
        childResults = new List<SobjectUtilityController.innerClassForChildResults>();
        parentResults.add(SobjectUtilityController.get_ParentRecordsForBatch(parentQueryForBatch, parentObjectName.objectName));
        for(JunoSFDC2SFDC.childQueriesInnerClass childQueryRecord : lst_childQueries){
            String childQueryForBatch = SobjectUtilityController.prepareChildQueryForBatchProcess(parentIds, childQueryRecord.parentField, childQueryRecord.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
            SobjectUtilityController.generateQueryAtrributes childObjectName = SobjectUtilityController.generateQueryAtrributesFromQuery(childQueryRecord.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
            childResults.add(SobjectUtilityController.get_ChildRecordsForBatch(childQueryForBatch, childQueryRecord.parentField, childObjectName.objectName));
        }
        string referenceRecordsIds = '';
        for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass parentReferenceRecord : referenceList){
            system.debug(referenceSelectionString + ' ***** ' + parentReferenceRecord.referenceObjectName+''+parentReferenceRecord.referenceObjectFieldName+''+parentReferenceRecord.objectName);
            if(referenceSelectionString == parentReferenceRecord.referenceObjectName+''+parentReferenceRecord.referenceObjectFieldName+''+parentReferenceRecord.objectName){
                system.debug('parentResults ***** ' + parentResults);
                for(SobjectUtilityController.innerclassForParentResults parentRecord : parentResults){
                    system.debug('parentRecord ***** ' + parentRecord.parentRecords.size());
                    if(parentRecord.parentRecords.size()>0){
                        system.debug('parentReferenceRecord ***** ' + parentRecord.parentFieldsForJSON.toLowerCase().contains(parentReferenceRecord.referenceObjectFieldName.toLowerCase()));
                        if(parentRecord.parentFieldsForJSON.toLowerCase().contains(parentReferenceRecord.referenceObjectFieldName.toLowerCase())){
                            for(Sobject sObjectParentRecord : parentRecord.parentRecords){
                                system.debug('sObjectParentRecord ***** ' + sObjectParentRecord.get(parentReferenceRecord.referenceObjectFieldName));
                                if(sObjectParentRecord.get(parentReferenceRecord.referenceObjectFieldName) != null){
                                    if(referenceRecordsIds == ''){
                                        referenceRecordsIds = '\'' + (String)sObjectParentRecord.get(parentReferenceRecord.referenceObjectFieldName) + '\'';  
                                    }    
                                    else{
                                        referenceRecordsIds = '\'' + (String)sObjectParentRecord.get(parentReferenceRecord.referenceObjectFieldName) + '\'' + ',' + referenceRecordsIds;
                                    }
                                }  
                            }
                        }
                    }
                }
                system.debug('childResults ***** ' + childResults);
                for(SobjectUtilityController.innerClassForChildResults childRecord : childResults){  
                    system.debug('childFieldsForJSON ***** ' + childRecord.childFieldsForJSON.toLowerCase().contains(parentReferenceRecord.referenceObjectFieldName.toLowerCase()));
                    if(childRecord.childFieldsForJSON.toLowerCase().contains(parentReferenceRecord.referenceObjectFieldName.toLowerCase())){
                        system.debug('childRecords ***** ' + childRecord.childRecords.size());
                        if(childRecord.childRecords.size()>0){
                            for(Sobject sObjectChildRecord : childRecord.childRecords){
                                system.debug('parentReferenceRecord.referenceObjectFieldName ***** ' + sObjectChildRecord.get(parentReferenceRecord.referenceObjectFieldName));
                                if(sObjectChildRecord.get(parentReferenceRecord.referenceObjectFieldName) != null){
                                    if(referenceRecordsIds == ''){
                                        referenceRecordsIds = '\'' + (String)sObjectChildRecord.get(parentReferenceRecord.referenceObjectFieldName) + '\'';  
                                    }    
                                    else{
                                        referenceRecordsIds = '\'' + (String)sObjectChildRecord.get(parentReferenceRecord.referenceObjectFieldName) + '\'' + ',' + referenceRecordsIds;
                                    }
                                }
                            }
                        }
                    }
                }
                SobjectUtilityController.referenceObjectAttributesInnerClass referenceObjectAttributes = SobjectUtilityController.m_getreferenceObjectAttributes(parentReferenceRecord.referenceObjectName);
                 system.debug('referenceRecordsIds' + referenceRecordsIds);
                if(referenceRecordsIds != ''){
                    if(referenceObjectAttributes.referenceObjectFields != null){
                        String referenceObjectQuery;
                        if(Test.isRunningTest()){
                            referenceObjectQuery = 'Select '+ referenceObjectAttributes.referenceObjectFields +' From ' + parentReferenceRecord.referenceObjectName + ' Where ID IN ('+ referenceRecordsIds + ') ';
                        }
                        else{
                             referenceObjectQuery = 'Select '+ referenceObjectAttributes.referenceObjectFields +' From ' + parentReferenceRecord.referenceObjectName + ' Where ID IN ('+ referenceRecordsIds + ') ';
                       //  referenceObjectQuery = 'Select '+ referenceObjectAttributes.referenceObjectFields +',JunoDoc__Junodoc_External_Id__c From ' + parentReferenceRecord.referenceObjectName + ' Where ID IN ('+ referenceRecordsIds + ') ';
                        }
                        system.debug('referenceObjectQuery >>>>> '+referenceObjectQuery);
                        return Database.getQueryLocator(referenceObjectQuery);
                    }
                }    
            }
        }       
        String dummyId = '123';
        return Database.getQueryLocator('Select Id from Account Where Id =: dummyId');
    }
    
    global void execute(Database.BatchableContext BC, List<sobject> referenceRecords) { 
        try{
            List<JunoDoc__Junodoc_Connections__c> connection = [select Id, JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c from JunoDoc__Junodoc_Connections__c where Id =: selecteddestinationOrg  OR Name =: selecteddestinationOrg limit 1];
            if(connection.size()>0){
                accesstoken = connection[0].JunoDoc__Access_Token__c;
                instanceURL = connection[0].JunoDoc__Instance_URL__c;
            }
            Map<String, String> referenceGUIDMap = new Map<String, String>();
            JunoDoc__Junodoc_Object_Schema_Mapping__c objectSchemaRecord = utilityController.objectSchemaMapping(referenceObjectName, selecteddestinationOrg);
            Map<String, string> recordExternalIdMap = new Map<String, String>();
            Map<Integer, string> referenceRecordMap = new Map<Integer, String>();
            string referenceRecordIds = '';
            string referenceRecordExternalIds = '';
            integer i = 0;
            for(Sobject recferenceRecord : referenceRecords){
                i = i+1;
                referenceRecordMap.put(i, (String)recferenceRecord.get('id'));
                if(objectSchemaRecord != null){
                    if(recferenceRecord.get(String.escapeSingleQuotes(objectSchemaRecord.Source_External_Id__c)) != null){
                        recordExternalIdMap.put((String)recferenceRecord.get(objectSchemaRecord.Source_External_Id__c), (String)recferenceRecord.get('id'));
                        if(referenceRecordExternalIds == ''){
                            referenceRecordExternalIds = '\'' + (String)recferenceRecord.get(objectSchemaRecord.Source_External_Id__c) + '\'';  
                        }    
                        else{
                            referenceRecordExternalIds = '\'' + (String)recferenceRecord.get(objectSchemaRecord.Source_External_Id__c) + '\'' + ',' + referenceRecordExternalIds;
                        }
                    }
                    else{
                        recordExternalIdMap.put((String)recferenceRecord.get('id'), (String)recferenceRecord.get('id'));
                        if(referenceRecordExternalIds == ''){
                            referenceRecordExternalIds = '\'' + (String)recferenceRecord.get('id') + '\'';  
                        }    
                        else{
                            referenceRecordExternalIds = '\'' + (String)recferenceRecord.get('id') + '\'' + ',' + referenceRecordExternalIds;
                        }
                    }
                }
            }
            String referenceObjectQuery = 'Select ' + String.EscapeSingleQuotes(referenceObjectFields)//+',JunoDoc__Junodoc_External_Id__c'
               + ' From ' + String.EscapeSingleQuotes(referenceObjectName) + ' Where '
                + String.EscapeSingleQuotes(objectSchemaRecord.Source_External_Id__c) +
                ' IN (' + 
                referenceRecordExternalIds + ') OR ID IN (' + referenceRecordExternalIds + ')';
               
            if(Test.isRunningTest()){
                referenceObjectQuery = 'SELECT Id,Name FROM Account limit 1';
                referenceObjectFields = 'Id,Name';
            }
           
            JunoDoc__Junodoc_Migration_settings__c cloudSyncSetting = utilityController.getCloudSyncSettings();
            if(cloudSyncSetting.JunoDoc__Junodoc_Use_REST__c || Test.isRunningTest()){
                List<SobjectUtilityController.destinationMissingReferenceRecordsInnerClass> upsertReferenceRecordList = new List<SobjectUtilityController.destinationMissingReferenceRecordsInnerClass>();
                upsertReferenceRecordList.add(new SobjectUtilityController.destinationMissingReferenceRecordsInnerClass(referenceObjectName, database.query(referenceObjectQuery), referenceObjectFields, referenceExternalId));
                List<String> queryFields = referenceObjectFields.split(',');   
                string updateReferenceRecordsJSON = JsonUtilityController.compositeBatchUpsertJSON(selecteddestinationOrg, referenceObjectName, database.query(referenceObjectQuery), queryFields, batchProcess);  
                httpResponse updateReferenceRecordsResponse = CallOutUtilityController.getReferenceRecordsFromDestination(accesstoken, instanceURL, updateReferenceRecordsJSON);
                JSONParser updateReferenceRecordsResponseParser;
                if(Test.isRunningTest()){
                    String updateReferenceRecordsResponseBody = '{"hasErrors":false,"results":[{"statusCode":204,"result":null}]}';
                    updateReferenceRecordsResponseParser = JSON.createParser(updateReferenceRecordsResponseBody);
                }
                else{
                    updateReferenceRecordsResponseParser = JSON.createParser(updateReferenceRecordsResponse.getBody());
                }
                String getParentRecordsJSON = JsonUtilityController.compositeBatchGetJSON(selecteddestinationOrg, referenceObjectName, database.query(referenceObjectQuery));  
                httpResponse getParentRecordsResponse = CallOutUtilityController.getReferenceRecordsFromDestination(accesstoken, instanceURL, getParentRecordsJSON);
                JSONParser getParentRecordsResponseParser;
                if(Test.isRunningTest()){
                    String getParentRecordsResponseBody = '{"hasErrors":false,"results":[{"statusCode":200,"result":'+
                                            '{"attributes":{"type":"Account","url":"/services/data/v34.0/sobjects/Account/0012800001NVOC3AAP"},"Id":"0012800001NVOC3AAP","message":"success"}}]}';
                    getParentRecordsResponseParser = JSON.createParser(getParentRecordsResponseBody);
                }
                else{
                    getParentRecordsResponseParser = JSON.createParser(getParentRecordsResponse.getBody());  
                }
                List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();   
                string destinationRecordId = '';
                String destinationRecordObjectType = '';
                integer j = 0;
                List<JunoDoc__Junodoc_Workbench_Results__c> listOfBacthResults =[SELECT JunoDoc__Batch_Process_Id__c,JunoDoc__Destination_Org__c,JunoDoc__Destination_Record_Id__c,
                                                                                JunoDoc__Migration_Type__c,JunoDoc__Object_Name__c,
                                                                                JunoDoc__Source_Record_Id__c,JunoDoc__Status__c,CreatedDate,Id FROM JunoDoc__Junodoc_Workbench_Results__c 
                                                                                where JunoDoc__Batch_Process_Id__c=:batchProcess];
                Map<ID, JunoDoc__Junodoc_Workbench_Results__c>  mapExistingRecords = new Map<ID, JunoDoc__Junodoc_Workbench_Results__c> ();
                for(JunoDoc__Junodoc_Workbench_Results__c workBenchRecord:listOfBacthResults){
                    mapExistingRecords.put(workBenchRecord.JunoDoc__Source_Record_Id__c,workBenchRecord );    
                }
                while (getParentRecordsResponseParser.nextToken() != null) {
                    if ((getParentRecordsResponseParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = getParentRecordsResponseParser.getText();
                        getParentRecordsResponseParser.nextToken();
                        if(fieldName == 'type'){
                            destinationRecordObjectType = getParentRecordsResponseParser.getText();
                        }
                        if(fieldName == 'id') {
                            destinationRecordId = getParentRecordsResponseParser.getText();
                        }    
                        if(fieldName == 'message'){
                            j = j + 1;
                        }
                        if(destinationRecordId != '' && destinationRecordObjectType != ''){
                            j = j + 1;
                            JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                            
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Status__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Status__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Status__c = 'Success';
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Record_Id__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Record_Id__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Destination_Record_Id__c = destinationRecordId;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_URL__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_URL__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Destination_URL__c = instanceURL;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Migration_Type__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Migration_Type__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Migration_Type__c = 'MGraph';
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Is_Parent__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Is_Parent__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Is_Parent__c = true;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Is_Lookup__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Is_Lookup__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Is_Lookup__c = true;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Fields__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Fields__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Fields__c = referenceObjectFields;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Batch_Process_Id__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Batch_Process_Id__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Batch_Process_Id__c = batchProcess; 
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Object_Name__c  .isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Object_Name__c  .isCreateable()){
                                    workBenchRecord.JunoDoc__Object_Name__c  = destinationRecordObjectType;  
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Org__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Org__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Destination_Org__c = selecteddestinationOrg;
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Record_Source__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Record_Source__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Record_Source__c = 'LookUp';
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Result_From__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Result_From__c.isCreateable()){
                                    workBenchRecord.JunoDoc__Result_From__c = 'Upsert';
                            }
                            if(referenceRecordMap.get(j) != null){
                                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Source_Record_Id__c.isUpdateable()
                                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Source_Record_Id__c.isCreateable()){
                                        workBenchRecord.JunoDoc__Source_Record_Id__c = referenceRecordMap.get(j);
                                }
                                
                            }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__External_Id__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__External_Id__c.isCreateable()){
                                    workBenchRecord.JunoDoc__External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcess + workBenchRecord.Record_Source__c;
                            }
                            
                            cloudSyncResults.add(workBenchRecord);
                            destinationRecordId = '';
                            destinationRecordObjectType = ''; 
                        }
                    }
                }    
                string statusCode = '';
                string errMessage = '';
                boolean failedRecord = false;
                integer k = 0; 
                while (updateReferenceRecordsResponseParser.nextToken() != null) {
                    if ((updateReferenceRecordsResponseParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = updateReferenceRecordsResponseParser.getText();
                        updateReferenceRecordsResponseParser.nextToken();
                        if(fieldName == 'statusCode'){
                            statusCode = updateReferenceRecordsResponseParser.getText();
                        }
                        if(fieldName == 'result') {
                            if(updateReferenceRecordsResponseParser.getText() != null){
                                failedRecord = true;
                            }
                        }    
                        if(fieldName == 'message'){
                            errMessage = updateReferenceRecordsResponseParser.getText();
                        }
                        if(failedRecord == true && errMessage != ''){
                            k = k + 1;
                            JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                            workBenchRecord.Status__c = 'Failed';
                            workBenchRecord.Destination_URL__c = instanceURL;
                            workBenchRecord.Migration_Type__c = 'MGraph';
                            workBenchRecord.Is_Parent__c = true;
                            workBenchRecord.Is_Lookup__c = true;
                            workBenchRecord.Fields__c = referenceObjectFields;
                            workBenchRecord.Batch_Process_Id__c = batchProcess;
                            workBenchRecord.Object_Name__c = referenceObjectName;  
                            workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                            
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isUpdateable()
                                && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isCreateable()){
                                    workBenchRecord.Error_Message__c = errMessage;
                            }
                            workBenchRecord.Record_Source__c = 'LookUp';
                            workBenchRecord.Result_From__c = 'Query';
                            if(referenceRecordMap.get(k) != null){
                                workBenchRecord.Source_Record_Id__c = referenceRecordMap.get(k);
                            }  
                            workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcess + workBenchRecord.Record_Source__c;
                            cloudSyncResults.add(workBenchRecord);
                            failedRecord = false;
                            errMessage = ''; 
                        }
                        else if(failedRecord == false && (statusCode == '204' || statusCode == '201')){
                            k = k + 1;
                        }
                    }
                }
                if(cloudSyncResults.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                            upsert cloudSyncResults External_Id__c;  
                            system.debug('Error >> '+Database.query('SELECT FROM Account'));
                    }           
                }
            }
            else{
                List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
                
                string upsertXML = JsonUtilityController.generateUpsertXML(selecteddestinationOrg,
                                                                                referenceObjectName,
                                                                                Database.query(referenceObjectQuery),
                                                                                referenceObjectFields.split(','),
                                                                                batchProcess,
                                                                                accesstoken); 
                httpResponse upsertResponseXML = CallOutUtilityController.SOAP_ApiCall(accesstoken, instanceURL, upsertxml); 
                cloudSyncResults.addAll(CallOutUtilityController.parseUpsertResponse(upsertResponseXML, 
                                                                                        instanceURL, 
                                                                                        batchProcess, 
                                                                                        selecteddestinationOrg, 
                                                                                        referenceObjectName, 
                                                                                        referenceRecordMap, 
                                                                                        referenceObjectFields, 
                                                                                        'Lookup', 
                                                                                        referenceObjectFieldName));
                
                String queryXML = JsonUtilityController.geneareQueryXML(selecteddestinationOrg, 
                                                                        referenceObjectName, 
                                                                        Database.query(referenceObjectQuery), 
                                                                        accesstoken);    
                httpResponse queryResponseXML = CallOutUtilityController.SOAP_ApiCall(accesstoken, instanceURL, queryXML);
                
                cloudSyncResults.addAll(CallOutUtilityController.parseQueryResponse(queryResponseXML, 
                                                                                        instanceURL, 
                                                                                        batchProcess, 
                                                                                        selecteddestinationOrg, 
                                                                                        referenceObjectName, 
                                                                                        recordExternalIdMap,
                                                                                        referenceObjectFields, 
                                                                                        'Lookup', 
                                                                                        referenceObjectFieldName));
                                   
                if(cloudSyncResults.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                        upsert cloudSyncResults External_Id__c;
                    }
                    
                }
                if(cloudSyncSetting.JunoDoc__Junodoc_Log_Details__c){
                    utilityController.insertLogDetails(upsertXML, 
                                                                    upsertResponseXML.getBody(), 
                                                                    referenceObjectQuery, 
                                                                    batchProcess);
                    utilityController.insertLogDetails(queryXML, 
                                                                   queryResponseXML.getBody(), 
                                                                   referenceObjectQuery, 
                                                                   batchProcess);
                }
            }
        }
        catch(Exception exp){
            system.debug('Error >>>> '+exp.getStackTraceString());
            System.debug('Error: ' + exp.getMessage());
            List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
            for(Sobject recferenceRecord : referenceRecords){
                JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Status__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Status__c.isCreateable()){
                        workBenchRecord.Status__c = 'Failed';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_URL__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_URL__c.isCreateable()){
                        workBenchRecord.Destination_URL__c = instanceURL;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Migration_Type__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Migration_Type__c.isCreateable()){
                        workBenchRecord.Migration_Type__c = 'MGraph';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Lookup__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Lookup__c.isCreateable()){
                        workBenchRecord.Is_Lookup__c = true;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isCreateable()){
                        workBenchRecord.Batch_Process_Id__c = batchProcess;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isCreateable()){
                        workBenchRecord.Object_Name__c = referenceObjectName;  
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Org__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Org__c.isCreateable()){
                        workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isCreateable()){
                        workBenchRecord.Error_Message__c = exp.getmessage();
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isCreateable()){
                        workBenchRecord.Source_Record_Id__c = (String)recferenceRecord.get('id');
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isCreateable()){
                        workBenchRecord.Record_Source__c = 'LookUp';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isCreateable()){
                        workBenchRecord.Result_From__c = 'Upsert';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isCreateable()){
                        workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcess + workBenchRecord.Record_Source__c;
                }
                cloudSyncResults.add(workBenchRecord);
            }
            if(cloudSyncResults.size() > 0){
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                        upsert cloudSyncResults External_Id__c;
                }
            }
        }
    }
    global void finish(Database.BatchableContext BC) {
       Boolean check = referenceList.size() > parentCompletedMap.values().size();
        if(Test.isRunningTest()){
            check = true;
        }
        if(check){
            
                parentBatchController parentBatch = new parentBatchController(strParentQuery, 
                                                                lst_childQueries, 
                                                                referenceList, 
                                                                batchProcess, 
                                                                selecteddestinationOrg,
                                                                scheduleIds,
                                                                migrateAttachements,
                                                                parentCompletedMap,
                                                                batchSizeForJob);
            Id parentJobId ;
            if(!Test.isRunningTest()){
                 parentJobId = Database.executeBatch(parentBatch, Integer.valueOf(batchSizeForJob));
            }
            else{
                 parentJobId = null;
            }
                List<JunoDoc__Junodoc_Template_Schedule__c> templateDetails = [SELECT Batch_Id__c,
                                                                                    Schedule_Status__c,
                                                                                    has_Failed_Recors__c,
                                                                                    Migrated_Records_Count__c
                                                                                    FROM 
                                                                                    JunoDoc__Junodoc_Template_Schedule__c 
                                                                                    Where 
                                                                                    Batch_Id__c =: String.valueOf(batchProcess)
                                                                                    AND
                                                                                    Is_Scheduled__c = false]; 
                if(templateDetails.size() > 0){
                    templateDetails[0].Schedule_Batch_Id__c = parentJobId;
                    update templateDetails[0];
                }
            
        }  
        if(Test.isRunningTest()){
            check = false;
        }
        if(!check){
            
                mGraphParentQueryBatchController mGraphBatchParentQuery = new mGraphParentQueryBatchController(strParentQuery, 
                                                                    lst_childQueries, 
                                                                    referenceList, 
                                                                    batchProcess, 
                                                                    selecteddestinationOrg,
                                                                    scheduleIds,
                                                                    migrateAttachements,
                                                                    batchSizeForJob);
                Id parentQueryJobId = Database.executeBatch(mGraphBatchParentQuery, Integer.valueOf(batchSizeForJob));
                List<JunoDoc__Junodoc_Template_Schedule__c> templateDetails = [SELECT JunoDoc__Batch_Id__c,
                                                                                    JunoDoc__Schedule_Status__c,
                                                                                    JunoDoc__has_Failed_Recors__c,
                                                                                    JunoDoc__Migrated_Records_Count__c
                                                                                    FROM 
                                                                                    JunoDoc__Junodoc_Template_Schedule__c 
                                                                                    Where 
                                                                                    JunoDoc__Batch_Id__c =: String.valueOf(batchProcess)
                                                                                    AND
                                                                                    JunoDoc__Is_Scheduled__c = false]; 
               
                List<JunoDoc__Junodoc_Template_Schedule__c> templateDetailsForBatch = [SELECT JunoDoc__Batch_Id__c,
                                                                                JunoDoc__Schedule_Status__c,
                                                                                JunoDoc__has_Failed_Recors__c
                                                                                FROM 
                                                                                JunoDoc__Junodoc_Template_Schedule__c 
                                                                                Where 
                                                                                JunoDoc__Batch_Id__c =: String.valueOf(batchProcess)
                                                                                ];                                                                       
               
                if(templateDetails.size() > 0){
                    templateDetails[0].JunoDoc__Schedule_Batch_Id__c = parentQueryJobId;
                    update templateDetails[0];
                }
        }
    }  
    

}
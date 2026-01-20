global with sharing class mGraphParentQueryBatchController implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public string strParentQuery = '';
    public decimal batchSizeForJob = 1;
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
    public map<String, String> childQueryCompletedMap = new map<String, string>();
    public mGraphParentQueryBatchController(String parentQuery, List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries, List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList, Integer batchId, string destinationOrg, String currentScheduleIds, boolean includeAttachments, Decimal batchSize){
        destinationRecord = new List<JunoDoc__Junodoc_Connections__c>(); 
        destinationRecord = [Select Id, Name, JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c from JunoDoc__Junodoc_Connections__c where Name =: destinationOrg OR Id=: destinationOrg];
        strParentQuery = parentQuery;
        lst_childQueries = childQueries;   
        migrateAttachements = includeAttachments;
        batchSizeForJob = batchSize;
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
        system.debug('destinationOrg--->'+destinationOrg);
        selecteddestinationOrg = destinationOrg;
        system.debug('selecteddestinationOrg--->'+selecteddestinationOrg);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        CallOutUtilityController.responseClass response = CallOutUtilityController.soap_connectToSFDC(selecteddestinationOrg);
        if(response.response){  
            URL comparisonURL = new URL(response.responseServerUrl);
            instanceURL = 'https://' + comparisonURL.gethost();
            accesstoken = response.sessionId;
        }
        List<JunoDoc__Junodoc_Connections__c> connection = [select Id, JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c    from JunoDoc__Junodoc_Connections__c where Id =: selecteddestinationOrg  OR Name =: selecteddestinationOrg limit 1];
        if(connection.size() > 0){
            connection[0].JunoDoc__Access_Token__c   = accesstoken;
            connection[0].JunoDoc__Instance_URL__c = instanceURL;
            update connection[0];
        }
        system.debug('queryForBatch--->'+queryForBatch);
        return Database.getQueryLocator(queryForBatch);
    }
    
    global void execute(Database.BatchableContext BC, List<sobject> scope) {  
        try { 
            List<JunoDoc__Junodoc_Connections__c> connection = [select Id, JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c from JunoDoc__Junodoc_Connections__c where Id =: selecteddestinationOrg  OR Name =: selecteddestinationOrg limit 1];
            if(connection.size()>0){
                accesstoken = connection[0].JunoDoc__Access_Token__c    ;
                instanceURL = connection[0].JunoDoc__Instance_URL__c;
            }
            String parentIds = '';
            for(sObject obj_Rec : scope){  
                if(parentIds == ''){
                    parentIds = '(' + '\'' + String.escapeSingleQuotes(String.ValueOf(obj_Rec.get('Id'))) + '\'';
                }
                else{
                    parentIds = parentIds + ',' + '\'' + String.escapeSingleQuotes(String.ValueOf(obj_Rec.get('Id'))) + '\'';  
                }
            }
            parentIds = parentIds + ')';
            String parentQueryForBatch = SobjectUtilityController.prepareParentQueryForBatchProcess(parentIds, strParentQuery);
            parentQueryForBatch = SobjectUtilityController.addExternalIdFiled(parentQueryForBatch, parentObjectName.objectName, selecteddestinationOrg);
            //String queryFields = ''; 
            queryFields = '';
            List<String> splitQueryFrom = parentQueryForBatch.split(' FROM ');
            for(String stringFrom : splitQueryFrom){ 
                if(stringFrom.contains('SELECT ')){
                    queryFields = stringFrom.replace('SELECT ',''); 
                }  
            }
            system.debug('parentObjectName.objectName--->'+parentObjectName.objectName);
            SobjectUtilityController.referenceObjectAttributesInnerClass objectAttributes = SobjectUtilityController.m_getreferenceObjectAttributes(parentObjectName.objectName);
            parentResults.add(SobjectUtilityController.get_ParentRecordsForBatch(parentQueryForBatch, parentObjectName.objectName));
            JunoDoc__Junodoc_Object_Schema_Mapping__c objectSchemaRecord = utilityController.objectSchemaMapping(parentObjectName.objectName, selecteddestinationOrg);
            Map<String, String> GUIDExternalIdMap = new Map<String, String>();
            Map<Integer, string> recordMap = new Map<Integer, String>();
            Map<String, string> recordExternalIdMap = new Map<String, String>();
            integer i = 0;
            for(Sobject record : parentResults[0].parentRecords){
                i = i+1;
                recordMap.put(i, (String)record.get('id'));
                if(objectSchemaRecord != null){ // && string.valueof(objectSchemaRecord) != 'JunoDoc__Junodoc_Object_Schema_Mapping__c:{}'){
                    system.debug('objectSchemaRecord---->'+objectSchemaRecord);
                    if(record.get(objectSchemaRecord.Source_External_Id__c) == null){
                        recordExternalIdMap.put((String)record.get('id'), (String)record.get('id'));
                    }
                    else{
                        recordExternalIdMap.put((String)record.get(objectSchemaRecord.Source_External_Id__c), (String)record.get('id'));
                    }
                }
            }
            JunoDoc__Junodoc_Migration_settings__c cloudSyncSetting = utilityController.getCloudSyncSettings();
            if(cloudSyncSetting.JunoDoc__Junodoc_Use_REST__c || Test.isRunningTest()){
                String getRecordsJSON = JsonUtilityController.compositeBatchGetJSON(selecteddestinationOrg, parentObjectName.objectName, database.query(parentQueryForBatch));  
                httpResponse geRecordsResponse = CallOutUtilityController.getReferenceRecordsFromDestination(accesstoken, instanceURL, getRecordsJSON);
                JSONParser getRecordsResponseParser;
                if(Test.isRunningTest()){
                    String getRecordResponseBody = '{"hasErrors":false,"results":[{"statusCode":200,"result":'+
                        '{"attributes":{"type":"Contact","url":"/services/data/v34.0/sobjects/Contact/00328000015ioHTAAY"},"Id":"00328000015ioHTAAY","message":"success"}}]}';
                    getRecordsResponseParser = JSON.createParser(getRecordResponseBody);
                }
                else{
                    getRecordsResponseParser = JSON.createParser(geRecordsResponse.getBody());
                }
                Map<String, String> exisitngRecords = new Map<String, String>(); 
                string destinationRecordId = '';
                String destinationRecordObjectType = '';
                integer j = 0;
                while (getRecordsResponseParser.nextToken() != null) {
                    if ((getRecordsResponseParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = getRecordsResponseParser.getText();
                        getRecordsResponseParser.nextToken();
                        if(fieldName == 'type'){
                            destinationRecordObjectType = getRecordsResponseParser.getText();
                        }
                        if(fieldName == 'id') {
                            destinationRecordId = getRecordsResponseParser.getText();
                        }    
                        if(fieldName == 'message'){
                            j = j + 1;
                        }
                        if(destinationRecordId != '' && destinationRecordObjectType != ''){
                            j = j + 1;
                            exisitngRecords.put(recordMap.get(j), destinationRecordId);
                            destinationRecordId = '';
                            destinationRecordObjectType = ''; 
                            
                        }
                    }
                }
                string upsertJSON = JsonUtilityController.compositeBatchUpsertJSON(selecteddestinationOrg,
                                                                                   parentObjectName.objectName,
                                                                                   parentResults[0].parentRecords,
                                                                                   queryFields.split(','),
                                                                                   batchProcess);   
                httpResponse upsertRecordsResponse = CallOutUtilityController.getReferenceRecordsFromDestination(accesstoken, instanceURL, upsertJSON); 
                List<JunoDoc__Junodoc_Workbench_Results__c  > cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c >();
                JSONParser upsertRecordsResponseParser ;
                if(Test.isRunningTest()){
                    String upsertRecordsResponseBody = '{"hasErrors":false,"results":[{"statusCode":204,"result":null,"message":"success"}]}';
                    upsertRecordsResponseParser = JSON.createParser(upsertRecordsResponseBody);
                }
                else{
                    upsertRecordsResponseParser = JSON.createParser(upsertRecordsResponse.getBody());
                }
                map<String, string> failedRecordsMap = new map<String, string>();
                string statusCode = '';
                string errMessage = '';
                boolean failedRecord = false;
                integer k = 0; 
                while (upsertRecordsResponseParser.nextToken() != null) {
                    if ((upsertRecordsResponseParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = upsertRecordsResponseParser.getText();
                        upsertRecordsResponseParser.nextToken();
                        if(fieldName == 'statusCode'){
                            statusCode = upsertRecordsResponseParser.getText();
                        }
                        if(fieldName == 'result') {
                            if(upsertRecordsResponseParser.getText() != null){
                                failedRecord = true;
                            }
                        }    
                        if(fieldName == 'message'){
                            errMessage = upsertRecordsResponseParser.getText();
                        } 
                        if(failedRecord == true && errMessage != ''){
                            k = k + 1;
                            JunoDoc__Junodoc_Workbench_Results__c    workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c    ();
                            
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Fields__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Fields__c.isCreateable()){
                                   workBenchRecord.Fields__c = queryFields;
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Status__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Status__c.isCreateable()){
                                   workBenchRecord.Status__c = 'Failed';
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Destination_URL__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Destination_URL__c.isCreateable()){
                                   workBenchRecord.Destination_URL__c = instanceURL;
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Migration_Type__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Migration_Type__c.isCreateable()){
                                   workBenchRecord.Migration_Type__c = 'MGraph';
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Batch_Process_Id__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Batch_Process_Id__c.isCreateable()){
                                   workBenchRecord.Batch_Process_Id__c = batchProcess; 
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Object_Name__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Object_Name__c.isCreateable()){
                                   workBenchRecord.Object_Name__c = parentObjectName.objectName;  
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Destination_Org__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Destination_Org__c.isCreateable()){
                                   workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Error_Message__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Error_Message__c.isCreateable()){
                                   workBenchRecord.Error_Message__c = errMessage;
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Record_Source__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c  .fields.Record_Source__c.isCreateable()){
                                   workBenchRecord.Record_Source__c = 'Parent';
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.Result_From__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isCreateable()){
                                   workBenchRecord.Result_From__c = 'Upsert';
                               }
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isCreateable()){
                                   workBenchRecord.Is_Parent__c = true;
                               }
                            if(recordMap.get(k) != null){
                                
                                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isUpdateable()
                                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isCreateable()){
                                       workBenchRecord.Source_Record_Id__c = recordMap.get(k);
                                   }
                                failedRecordsMap.put(recordMap.get(k), recordMap.get(k));
                            }  
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isCreateable()){
                                   workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcess + workBenchRecord.Record_Source__c;
                               }
                            
                            cloudSyncResults.add(workBenchRecord);
                            failedRecord = false;
                            errMessage = '';   
                        }
                        else if(failedRecord == false && (statusCode == '204' || statusCode == '201')){
                            k = k + 1;
                        }
                    }
                }  
                String getParentRecordsJSON = JsonUtilityController.compositeBatchGetJSON(selecteddestinationOrg, parentObjectName.objectName, database.query(parentQueryForBatch) );  
                httpResponse getParentRecordsResponse = CallOutUtilityController.getReferenceRecordsFromDestination(accesstoken, instanceURL, getParentRecordsJSON);
                JSONParser getParentRecordsResponseParser ;
                if(Test.isRunningTest()){
                    String getParentRecordsResponseBody = '{"hasErrors":false,"results":[{"statusCode":200,"result":'+
                        '{"attributes":{"type":"Contact","url":"/services/data/v34.0/sobjects/Contact/00328000015ioHTAAY"},"Id":"00328000015ioHTAAY","message":"success"}}]}';
                    getParentRecordsResponseParser = JSON.createParser(getParentRecordsResponseBody);
                }
                else{
                    getParentRecordsResponseParser = JSON.createParser(getParentRecordsResponse.getBody());
                }     
                string destinationRecordId1 = '';
                String destinationRecordObjectType1 = '';
                integer p = 0;
                while (getParentRecordsResponseParser.nextToken() != null) {
                    if ((getParentRecordsResponseParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                        String fieldName = getParentRecordsResponseParser.getText();
                        getParentRecordsResponseParser.nextToken();
                        if(fieldName == 'type'){
                            destinationRecordObjectType1 = getParentRecordsResponseParser.getText();
                        }
                        if(fieldName == 'id') {
                            destinationRecordId1 = getParentRecordsResponseParser.getText();
                        }    
                        if(fieldName == 'message'){
                            p = p + 1;
                        }
                        if(destinationRecordId1 != '' && destinationRecordObjectType1 != ''){
                            p = p + 1;
                            JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                            workBenchRecord.Status__c = 'Success';
                            System.debug('>>>>'+queryFields);
                            // Added By Prasad
                            workBenchRecord.Is_Parent__c = true;
                            workBenchRecord.Fields__c = queryFields;
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Record_Id__c.isUpdateable()
                               && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Record_Id__c.isCreateable()){
                                   workBenchRecord.Destination_Record_Id__c = destinationRecordId1;
                               }
                            
                            workBenchRecord.Destination_URL__c = instanceURL;
                            workBenchRecord.Migration_Type__c = 'MGraph';
                            workBenchRecord.Batch_Process_Id__c = batchProcess;
                            workBenchRecord.Object_Name__c = destinationRecordObjectType1;  
                            workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                            workBenchRecord.Record_Source__c = 'Parent';
                            workBenchRecord.Result_From__c = 'Query';
                            if(recordMap.get(p) != null){
                                workBenchRecord.Source_Record_Id__c = recordMap.get(p);
                            }
                            workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcess + workBenchRecord.Record_Source__c;
                            cloudSyncResults.add(workBenchRecord);
                            destinationRecordId1 = '';
                            destinationRecordObjectType1 = ''; 
                        }
                    }
                }
                if(cloudSyncResults.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isUpdateable()
                       && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                           upsert cloudSyncResults External_Id__c;
                       }
                    
                }
                if(cloudSyncSetting.JunoDoc__Junodoc_Log_Details__c){
                    utilityController.insertLogDetails(upsertJSON, upsertRecordsResponse.getBody(), '', batchProcess);
                }
            }
            else{
                string upsertXML = JsonUtilityController.generateUpsertXML(selecteddestinationOrg,
                                                                           parentObjectName.objectName,
                                                                           parentResults[0].parentRecords,
                                                                           queryFields.split(','),
                                                                           batchProcess,
                                                                           accesstoken); 
                system.debug(';selecteddestinationOrg >>> '+selecteddestinationOrg);
                system.debug('parentObjectName.objectName >>> '+parentObjectName.objectName);
                system.debug('parentResults[0].parentRecords >>> '+parentResults[0].parentRecords);
                system.debug('queryFields >>> '+queryFields);
                system.debug('batchProcessId >>> '+batchProcess);
                system.debug('accesstoken >>> '+accesstoken);
                system.debug('instanceURL >>> '+instanceURL);
                system.debug('upsertxml >>> '+upsertxml);
                httpResponse upsertResponseXML = CallOutUtilityController.SOAP_ApiCall(accesstoken, instanceURL, upsertxml);  
                List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
                cloudSyncResults.addAll(CallOutUtilityController.parseUpsertResponse(upsertResponseXML, 
                                                                                     instanceURL, 
                                                                                     batchProcess, 
                                                                                     selecteddestinationOrg, 
                                                                                     parentObjectName.objectName, 
                                                                                     recordMap, 
                                                                                     queryFields, 
                                                                                     'Parent', ''));
                
                String queryXML = JsonUtilityController.geneareQueryXML(selecteddestinationOrg, 
                                                                        parentObjectName.objectName, 
                                                                        database.query(parentQueryForBatch), 
                                                                        accesstoken);    
                httpResponse queryResponseXML = CallOutUtilityController.SOAP_ApiCall(accesstoken, instanceURL, queryXML);
                cloudSyncResults.addAll(CallOutUtilityController.parseQueryResponse(queryResponseXML, 
                                                                                    instanceURL, 
                                                                                    batchProcess, 
                                                                                    selecteddestinationOrg, 
                                                                                    parentObjectName.objectName, 
                                                                                    recordExternalIdMap, 
                                                                                    queryFields,
                                                                                    'Parent',
                                                                                    ''));
                if(cloudSyncResults.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isUpdateable()
                       && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                           upsert cloudSyncResults External_Id__c;
                       }
                    
                }
                if(cloudSyncSetting.JunoDoc__Junodoc_Log_Details__c){
                    utilityController.insertLogDetails(upsertXML, upsertResponseXML.getBody(), '', batchProcess);
                    utilityController.insertLogDetails(queryXML, queryResponseXML.getBody(), '', batchProcess);
                }
            }
        }
        catch(Exception exp){
            System.debug('ex ' + exp.getMessage() + ' at line ' + exp.getLineNumber() + ' cause ' + exp.getCause() + ' class ' + exp.getStackTraceString());
            List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
            for(Sobject record : scope){
                JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Fields__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Fields__c.isCreateable()){
                       workBenchRecord.Fields__c=queryFields;
                   }
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
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isCreateable()){
                       workBenchRecord.Is_Parent__c = true;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isCreateable()){
                       workBenchRecord.Record_Source__c = 'Parent';
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isCreateable()){
                       workBenchRecord.Result_From__c = 'Upsert';
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isCreateable()){
                       workBenchRecord.Batch_Process_Id__c = batchProcess;
                   } 
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isCreateable()){
                       workBenchRecord.Object_Name__c = parentObjectName.objectName; 
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
                       workBenchRecord.Source_Record_Id__c = (String)record.get('id');
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
        if(lst_childQueries.size() > 0){
            String failedStatus = 'Failed';
            String successStatus = 'Success';
            String recordSource = 'Parent';
            String resultsFrom = 'Upsert';
            List<JunoDoc__Junodoc_Template_Schedule__c> templateDetails = [SELECT  Batch_Id__c,
                                                                           Schedule_Status__c,
                                                                           has_Failed_Recors__c,
                                                                           Migrated_Records_Count__c
                                                                           FROM 
                                                                           JunoDoc__Junodoc_Template_Schedule__c 
                                                                           Where 
                                                                           Batch_Id__c =: String.valueOf(batchProcess)
                                                                           AND
                                                                           Is_Scheduled__c = false]; 
            system.debug('************************mGraphChildQueryBatchController*************************');
            system.debug('strParentQuery >>> '+strParentQuery);
            system.debug('lst_childQueries >>>> '+lst_childQueries);
            system.debug('referenceList >>>> '+referenceList);
            system.debug('batchProcess >>>> '+batchProcess);
            system.debug('selecteddestinationOrg >>> '+selecteddestinationOrg);
            system.debug('scheduleIds >>>> '+scheduleIds);
            system.debug('migrateAttachements >>>> '+migrateAttachements);
            system.debug('childQueryCompletedMap >>>> '+childQueryCompletedMap);
            system.debug('batchSizeForJob >>>>>  '+batchSizeForJob);
            mGraphChildQueryBatchController mGraphBatchChildQuery = new mGraphChildQueryBatchController(strParentQuery, 
                                                                                                        lst_childQueries, 
                                                                                                        referenceList, 
                                                                                                        batchProcess, 
                                                                                                        selecteddestinationOrg,
                                                                                                        scheduleIds,
                                                                                                        migrateAttachements,    
                                                                                                        childQueryCompletedMap,
                                                                                                        batchSizeForJob);
            Id childQueryJobId = Database.executeBatch(mGraphBatchChildQuery, Integer.valueOf(batchSizeForJob));
            Integer migratedRecordCount = Database.countQuery('SELECT count() FROM JunoDoc__Junodoc_Workbench_Results__c WHERE Batch_Process_Id__c =: batchProcess AND (Status__c =: failedStatus OR Status__c =: successStatus) AND Record_Source__c =: recordSource and Result_From__c =: resultsFrom');
            if(templateDetails.size() > 0){
                templateDetails[0].Migrated_Records_Count__c = migratedRecordCount;
                templateDetails[0].Schedule_Batch_Id__c = childQueryJobId;
                update templateDetails[0];
            }
        }
        else{
            
            String failedStatus = 'Failed';
            String successStatus = 'Success';
            String recordSource = 'Parent';
            String resultsFrom = 'Upsert';
            
            List<JunoDoc__Junodoc_Template_Schedule__c> templateDetails = [SELECT Batch_Id__c,
                                                                           Schedule_Status__c,
                                                                           has_Failed_Recors__c,
                                                                           Migrated_Records_Count__c,
                                                                           Schedule_Batch_Status__c
                                                                           FROM 
                                                                           JunoDoc__Junodoc_Template_Schedule__c 
                                                                           Where 
                                                                           Batch_Id__c =: String.valueOf(batchProcess)
                                                                           AND
                                                                           Is_Scheduled__c = false]; 
            
            List<JunoDoc__Junodoc_Template_Schedule__c> templateDetailsForBatch = [SELECT Batch_Id__c,
                                                                                   Schedule_Status__c,
                                                                                   has_Failed_Recors__c,
                                                                                   Schedule_Batch_Status__c
                                                                                   FROM 
                                                                                   JunoDoc__Junodoc_Template_Schedule__c 
                                                                                   Where 
                                                                                   Batch_Id__c =: String.valueOf(batchProcess)
                                                                                  ];  
            
            List<JunoDoc__Junodoc_Workbench_Results__c> failedRecords = [SELECT Id, Batch_Process_Id__c,
                                                                         Status__c 
                                                                         FROM 
                                                                         JunoDoc__Junodoc_Workbench_Results__c
                                                                         WHERE 
                                                                         Batch_Process_Id__c =: batchProcess 
                                                                         AND
                                                                         Status__c = 'Failed'
                                                                         LIMIT 1];
            
            Integer migratedRecordCount = Database.countQuery('SELECT count() FROM JunoDoc__Junodoc_Workbench_Results__c WHERE Batch_Process_Id__c =: batchProcess AND (Status__c =: failedStatus OR Status__c =: successStatus) AND Record_Source__c =: recordSource and Result_From__c =: resultsFrom');
            if(templateDetails.size() > 0){
                templateDetails[0].Schedule_Status__c = 'Completed';
                templateDetails[0].Migrated_Records_Count__c = migratedRecordCount;
                if(failedRecords.size() > 0){
                    templateDetails[0].has_Failed_Recors__c = true;
                }
                update templateDetails[0];
            }
            if(templateDetailsForBatch.size() > 0){
                templateDetailsForBatch[0].Schedule_Batch_Status__c = 'Completed';
                update templateDetailsForBatch[0];
            }
        }
    } 
}
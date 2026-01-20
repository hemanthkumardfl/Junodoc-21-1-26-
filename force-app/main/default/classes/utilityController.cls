public class utilityController {

     public static map<String, String> prepareCloudSyncFieldMapForjson(){
        Map<string, string> cloudSyncFieldMap = new map<String, String>();
        cloudSyncFieldMap.put('caseOrg_Id__c','CloudSync1__Org_Id__c');
        return cloudSyncFieldMap;
    }   
    
    public static void createExternalIdField(String objectName, String sessionId, String endpointURL){
        List<metadataServiceController.Metadata> objectExternalIdMetaDataLst = new List<metadataServiceController.Metadata>();
        metadataServiceController.CustomField externalIdField = new metadataServiceController.CustomField();   
        externalIdField.fullName = objectName + '.Junodoc_External_Id__c';
        externalIdField.label = 'Junodoc External Id';
        externalIdField.type_x = 'Text';
        externalIdField.externalId = true;   
        externalIdField.length = 100;
        objectExternalIdMetaDataLst.add(externalIdField);
        if(objectExternalIdMetaDataLst.size()>0){
            metadataServiceController.MetadataPort createExternalIdService = new metadataServiceController.MetadataPort();
            system.debug('the external id service is' + createExternalIdService);
            createExternalIdService.SessionHeader = new metadataServiceController.SessionHeader_element();
            createExternalIdService.SessionHeader.sessionId = sessionId;
            createExternalIdService.endpoint_x = endpointURL;
            List<metadataServiceController.SaveResult> results = createExternalIdService.createMetadata(objectExternalIdMetaDataLst);
            metadataServiceController.Profile admin = new metadataServiceController.Profile();
            admin.fullName = 'Admin';
            admin.custom = false;
            metadataServiceController.ProfileFieldLevelSecurity fieldSec = new metadataServiceController.ProfileFieldLevelSecurity();
            fieldSec.field = objectName + '.Junodoc_External_Id__c';  
            fieldSec.editable = true;
            admin.fieldPermissions = new metadataServiceController.ProfileFieldLevelSecurity[] {fieldSec}; 
            List<metadataServiceController.SaveResult> permissionresults = createExternalIdService.updateMetadata(new metadataServiceController.Metadata[] {admin});
            system.debug('permissionresults >>> '+permissionresults);
        } 
    } 
    
    /*WorkBenchUtilityController*/
    
       public Static JunoDoc__Junodoc_Object_Schema_Mapping__c objectSchemaMapping(String objectName, String destination){
           system.debug('objectName--->'+objectName+'---destination--->'+destination);
        JunoDoc__Junodoc_Object_Schema_Mapping__c objectSchemaMappingRecord = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> objectSchemaMappingList = [Select Id, JunoDoc__Missing_Fields__c, JunoDoc__Source_External_Id__c, JunoDoc__Destination_External_Id__c, JunoDoc__Object_Name__c
                                                                  from JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                  where JunoDoc__Object_Name__c =: objectName AND JunoDoc__Destination_Name__c =: destination];
        if(objectSchemaMappingList.size() > 0){
            return objectSchemaMappingList[0];
        }
        return objectSchemaMappingRecord;
    }
    
    public static Map<String, String> userMappings(String destination){
        List<JunoDoc__Junodoc_User_Mappings__c> userMappingLst = [Select Id, 
                                                 JunoDoc__Source_User__r.Id, 
                                                JunoDoc__Source_User__c,
                                                JunoDoc__Junodoc_Destination_User__r.JunoDoc__User_Id__c
                                                from JunoDoc__Junodoc_User_Mappings__c 
                                                where 
                                                JunoDoc__Destination_Name__c =: destination];
        Map<String, String> userMappingMap = new Map<String, String>();
        for(JunoDoc__Junodoc_User_Mappings__c userMapRec : userMappingLst){
            userMappingMap.put(userMapRec.JunoDoc__Source_User_Id__c, userMapRec.JunoDoc__Junodoc_Destination_User__r.JunoDoc__User_Id__c);
        }
        return userMappingMap;
    }
    
    public static Map<String, String> resultMappings(Integer batchNumber, Set<Id> lookupIds){
        List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = [Select Id,   
                                                                  JunoDoc__Source_Record_Id__c, 
                                                                  JunoDoc__Destination_Record_Id__c,
                                                                  JunoDoc__Result_From__c
                                                                  from 
                                                                  JunoDoc__Junodoc_Workbench_Results__c
                                                                  where 
                                                                  JunoDoc__Batch_Process_Id__c =: batchNumber
                                                                  And
                                                                  JunoDoc__Source_Record_Id__c IN: lookupIds];
        Map<String, String> resultMap = new Map<String, String>();
        for(JunoDoc__Junodoc_Workbench_Results__c cloudSyncRecord : cloudSyncResults){
            if(cloudSyncRecord.JunoDoc__Destination_Record_Id__c != null){
                if(cloudSyncRecord.JunoDoc__Result_From__c == 'Query'){
                    resultMap.put(cloudSyncRecord.JunoDoc__Source_Record_Id__c, cloudSyncRecord.JunoDoc__Destination_Record_Id__c);
                }
            }
            //if()
        }
        return resultMap;
    }
    
    public Static JunoDoc__Junodoc_Migration_settings__c getCloudSyncSettings(){
        List<JunoDoc__Junodoc_Migration_settings__c> cloudSyncCustomSettingList = [Select Id, Name,
                                                                  JunoDoc__Junodoc_Insert_Batch_Size__c,
                                                                  JunoDoc__Junodoc_Log_Details__c,
                                                                  JunoDoc__Junodoc_Upsert_Batch_Size__c,
                                                                  JunoDoc__Junodoc_Use_REST__c,
                                                                  JunoDoc__Delete_Migration_Logs_Period_In_Days__c
                                                                  From JunoDoc__Junodoc_Migration_settings__c LIMIT 1];
        if(cloudSyncCustomSettingList.size() > 0){
            return cloudSyncCustomSettingList[0];
        }
        else{
            JunoDoc__Junodoc_Migration_settings__c cloudSyncSetting = new JunoDoc__Junodoc_Migration_settings__c();
            
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.Name.isCreateable()){
               cloudSyncSetting.Name = 'CloudSync Workebench Settings';
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.JunoDoc__Junodoc_Upsert_Batch_Size__c.isCreateable()){
               cloudSyncSetting.JunoDoc__Junodoc_Upsert_Batch_Size__c = 10;
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.JunoDoc__Junodoc_Insert_Batch_Size__c.isCreateable()){
               cloudSyncSetting.JunoDoc__Junodoc_Insert_Batch_Size__c = 10;
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.JunoDoc__Junodoc_Log_Details__c.isCreateable()){
               cloudSyncSetting.JunoDoc__Junodoc_Log_Details__c = false;
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.JunoDoc__Junodoc_Use_REST__c.isCreateable()){
                cloudSyncSetting.JunoDoc__Junodoc_Use_REST__c = false;
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.fields.JunoDoc__Delete_Migration_Logs_Period_In_Days__c.isCreateable()){
                cloudSyncSetting.JunoDoc__Delete_Migration_Logs_Period_In_Days__c = 5;
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Migration_settings__c.isCreateable()){
                insert cloudSyncSetting;
            }
            
            return cloudSyncSetting;
        }
    }
    
    public static void insertLogDetails(String request, String response, String query, Integer batchNumber){
        JunoDoc__Junodoc_Log__c SyncLog = new JunoDoc__Junodoc_Log__c();
        
        if(Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Request_Body__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Request_Body__c.isCreateable()){
               if(request.length() > 131072){
                   SyncLog.JunoDoc__Request_Body__c = request.substring(0, 131072);
               }
               else{
                   SyncLog.JunoDoc__Request_Body__c = request;
               }
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Response__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Response__c.isCreateable()){
               if(response.length() > 131072){
                   SyncLog.Response__c = response.substring(0, 131072);
               }
               else{
                   SyncLog.Response__c = response;
               }
           }
        
        if(Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Parent_Query__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Parent_Query__c.isCreateable()){
               SyncLog.JunoDoc__Parent_Query__c = query;
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Batch_Number__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Log__c.fields.JunoDoc__Batch_Number__c.isCreateable()){
               SyncLog.JunoDoc__Batch_Number__c = String.valueOf(batchNumber);
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Log__c.isCreateable()){
            insert SyncLog;
        }
        
    }
    
    public static void insertBatchDetails(Integer batchProcessId){
        JunoDoc__Junodoc_Batch_Job_Details__c batJobRec = new JunoDoc__Junodoc_Batch_Job_Details__c();
        
        if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Status__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Status__c.isCreateable()){
               batJobRec.Status__c = 'In Progress';
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Batch_Job_Id__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Batch_Job_Id__c.isCreateable()){
               batJobRec.JunoDoc__Batch_Job_Id__c = batchProcessId;
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Initiated_By__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Initiated_By__c.isCreateable()){
               batJobRec.JunoDoc__Initiated_By__c = UserInfo.getUserId();
           }
        if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Job_Details__c.fields.JunoDoc__Initiated_By__c.isCreateable()){
            insert batJobRec;
        } 
    }
    
    public class reprocessRecords {
        public String recordIdToProcess {get; set;}
        public boolean compleated {get; set;}
        public String recordType {get; set;}
        public String query {get; set;}
    } 
}
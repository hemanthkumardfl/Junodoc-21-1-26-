public without sharing class JsonUtilityController{  
    CallOutUtilityController calloutInstance = new CallOutUtilityController();  
    
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    public static string compositeBatchUpsertJSON(string destinationName, string objectName, List<Sobject> sObjectRecords, List<String> fields, Integer batchNumber){
        List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = [Select Id, 
                                                                            JunoDoc__Source_Record_Id__c, 
                                                                            JunoDoc__Destination_Record_Id__c   
                                                                            from 
                                                                            JunoDoc__Junodoc_Workbench_Results__c
                                                                            where 
                                                                            JunoDoc__Batch_Process_Id__c =: batchNumber];
        
        boolean auditFieldsEnabled = false;
        List<JunoDoc__Junodoc_Connections__c> endPoint = [Select Id, 
                                                                            JunoDoc__Set_Audit_Fields__c
                                                                            from
                                                                            JunoDoc__Junodoc_Connections__c
                                                                            Where
                                                                            Id =: destinationName
                                                                            OR
                                                                            Name =: destinationName];
        if(!endPoint.isempty()){
            auditFieldsEnabled = endPoint[0].Set_Audit_Fields__c;
        }      
                                                                            
        Map<String, String> userMapping = new Map<String, String>();
        for(JunoDoc__Junodoc_User_Mappings__c userMapRec : [Select Id, JunoDoc__Source_User__c, JunoDoc__Source_User_Id__c, JunoDoc__Junodoc_Destination_User__c,JunoDoc__Junodoc_Destination_User__r.JunoDoc__User_Id__c from JunoDoc__Junodoc_User_Mappings__c where JunoDoc__Destination_Name__c =: destinationName]){
            userMapping.put(userMapRec.JunoDoc__Source_User_Id__c, userMapRec.JunoDoc__Junodoc_Destination_User__r.JunoDoc__User_Id__c);
        }
        
        Map<String, String> resultMap = new Map<String, String>();
        for(JunoDoc__Junodoc_Workbench_Results__c cloudSyncRecord : cloudSyncResults){
            resultMap.put(cloudSyncRecord.JunoDoc__Source_Record_Id__c, cloudSyncRecord.JunoDoc__Destination_Record_Id__c);
        }
        
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaRecords = [Select Id, 
                                                                JunoDoc__Missing_Fields__c, 
                                                                JunoDoc__Schema_External_ID__c, 
                                                                JunoDoc__Destination_External_Id__c,
                                                                JunoDoc__Object_Name__c,
                                                                         JunoDoc__Source_External_Id__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                JunoDoc__Object_Name__c =: objectName
                                                                AND
                                                                JunoDoc__Destination_Name__c =: destinationName];
        List<JunoDoc__Junodoc_Object_RecordType_Mapping__c> recordTypeMappingRecords = [Select Id, 
                                                                    JunoDoc__Destination_Record_Type_Id__c, 
                                                                    JunoDoc__Source_Record_Type_Id__c
                                                                    from
                                                                    JunoDoc__Junodoc_Object_RecordType_Mapping__c
                                                                    where
                                                                    JunoDoc__Object__c =: schemaRecords];
                                                                    
        List<JunoDoc__Junodoc_PriceBookEntry_Map__c> priceBookEntryList = [Select Id, JunoDoc__Source_PBE_Id__c, 
                                                                                JunoDoc__Destination_PBE_Id__c  
                                                                                From
                                                                                JunoDoc__Junodoc_PriceBookEntry_Map__c
                                                                                Where
                                                                                JunoDoc__Destination__c =: destinationName];
                            
        
        String sourceExternalId = schemaRecords[0].Source_External_Id__c;
        String destinationExternalId = schemaRecords[0].Destination_External_Id__c;
                                                                    
        Map<String, String> missingObjectSchema = new Map<String, String>();
        for(JunoDoc__Junodoc_Object_Schema_Mapping__c schemaRec : schemaRecords){
            if(schemaRec.JunoDoc__Missing_Fields__c != null){
                List<String> missingFields = schemaRec.JunoDoc__Missing_Fields__c.split(',');
                for(String missingField : missingFields){
                    missingObjectSchema.put(schemaRec.JunoDoc__Object_Name__c.toLowerCase()+missingField.toLowerCase(), missingField);
                }
            }
        }
        
        map<String, string> recordTypeMapping = new map<String, String>();
        for(JunoDoc__Junodoc_Object_RecordType_Mapping__c recTypeMapRec : recordTypeMappingRecords){
            if(recTypeMapRec.JunoDoc__Source_Record_Type_Id__c != null && recTypeMapRec.JunoDoc__Destination_Record_Type_Id__c != null){
                recordTypeMapping.put(recTypeMapRec.JunoDoc__Source_Record_Type_Id__c, recTypeMapRec.JunoDoc__Destination_Record_Type_Id__c);
            }
        }
        
        map<Id,Id> priceBookEntryMap = new map<Id,Id>();
        for(JunoDoc__Junodoc_PriceBookEntry_Map__c priceBookEntryRec : priceBookEntryList){
            priceBookEntryMap.put(priceBookEntryRec.JunoDoc__Source_PBE_Id__c, priceBookEntryRec.JunoDoc__Destination_PBE_Id__c);
        }
        
        List<RecordType> recordTypeList = [Select Id from RecordType where sobjectType =: objectName]; 
        List<Attachment> attachments = new List<Attachment>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        map<string, string> cloudSyncJSONFieldMap = new map<string, string>();
        cloudSyncJSONFieldMap = utilityController.prepareCloudSyncFieldMapForjson();  
        
        if(true){
            List<String> recordIds = new List<String>();
            for(sObject sObjectRec : sObjectRecords){
                recordIds.add(sObjectRec.Id);
            }
            attachments = [SELECT Body, BodyLength, ContentType, Id, Name, ParentId FROM Attachment where ParentId IN: recordIds ORDER BY LastModifiedDate DESC];
        }
        integer i = 0;
        if(sObjectRecords.size()>0){  
            JSONGenerator jSon_gen = JSON.createGenerator(true);   
            jSon_gen.writeStartObject();
            jSon_gen.writeFieldName('batchRequests');
            jSon_gen.writeStartArray();  
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName.replace(' ','')).getDescribe().fields.getMap();
            for(sobject record : sObjectRecords){
                jSon_gen.writeStartObject();
                jSon_gen.writeStringField('method', 'PATCH'); 
                string externalIdValue = '';
                //if(setExternalIdAs == 'External Id As Source SFDC Id'){
                if(record.get(sourceExternalId) != null){
                    externalIdValue = (string)record.get(sourceExternalId);
                }
                else{
                    externalIdValue = (string)record.get('id');
                }
               
                
                String endURL = 'v34.0/sobjects/'+ objectName + '/' + destinationExternalId + '/' + externalIdValue;
                jSon_gen.writeStringField('url', endURL );
                jSon_gen.writeFieldName('richInput');
                jSon_gen.writeStartObject();
                for(string field : fields){
                    if(missingObjectSchema.get(objectName.toLowerCase().trim()+field.toLowerCase().trim()) == null){
                        if(record.get(field.replace(' ','')) != null){
                            string fieldNameForjson = '';
                            if(cloudSyncJSONFieldMap.get(objectName + field) == null){
                                fieldNameForjson = field;
                            }
                            else{
                                fieldNameForjson = cloudSyncJSONFieldMap.get(objectName + field);
                            }
                            field = field.replace(' ','');
                            string DataType = '';
                            boolean isExternalId = false;
                            boolean isUpdatable = false;
                            if(fieldMap.get(field) != null){
                                DataType = string.valueOf(fieldMap.get(field).getDescribe().getType());  
                                isUpdatable = fieldMap.get(field).getDescribe().isUpdateable();
                            }
                            else{
                                DataType = string.valueOf(fieldMap.get(field.replace('CloudSync1__','')).getDescribe().getType());
                                isUpdatable = fieldMap.get(field.replace('CloudSync1__','')).getDescribe().isUpdateable();
                            }
                            if(field == 'Subject'){
                            }
                            if(isUpdatable){
                                if(field.toLowerCase() != sourceExternalId.toLowerCase() && field != 'PhotoUrl'){
                                    if(DataType == 'STRING' || DataType == 'COMBOBOX' || DataType == 'PICKLIST' || DataType == 'TEXTAREA' || DataType == 'PHONE' || DataType == 'PICKLIST' || DataType == 'URL' || DataType == 'EMAIL' || DataType == 'MULTIPICKLIST'){
                                        if(record.get(field) != null){
                                            jSon_gen.writeStringField(fieldNameForjson, string.valueOf(record.get(field)));
                                        }
                                    }    
                                    else if(DataType == 'BOOLEAN' && field.trim() != 'UseStandardPrice'){
                                        if(record.get(field) != null){
                                            jSon_gen.writeBooleanField(fieldNameForjson, boolean.valueOf(record.get(field)));
                                        }
                                    }
                                    else if(DataType == 'DOUBLE' || DataType == 'CURRENCY'){
                                        if(record.get(field) != null){
                                            jSon_gen.writeNumberField(fieldNameForjson, Double.valueOf(record.get(field)));
                                        }
                                    }
                                    else if(DataType == 'DATETIME'){
                                        if(field.toLowerCase() != 'createdbyid' || field.toLowerCase() != 'lastmodifiedbyid'){
                                            if(record.get(field) != null){
                                                jSon_gen.writeDateTimeField(fieldNameForjson, DATETIME.valueOf(record.get(field)));
                                            }
                                        }
                                    }
                                    else if(DataType == 'DATE'){
                                        if(record.get(field) != null){
                                            jSon_gen.writeDateField(fieldNameForjson, DATE.valueOf(record.get(field)));
                                        }
                                    }
                                    if(DataType == 'REFERENCE'){
                                        if(field.toLowerCase() != 'createddate' || field.toLowerCase() != 'lastmodifieddate'){
                                            if(resultMap.get(string.valueOf(record.get(field))) != null){
                                                jSon_gen.writeStringField(fieldNameForjson, resultMap.get(string.valueOf(record.get(field))));    
                                            }
                                            else if(userMapping.get(string.valueOf(record.get(field))) != null){
                                                jSon_gen.writeStringField(fieldNameForjson, userMapping.get(string.valueOf(record.get(field))));
                                            }
                                        }
                                    }
                                }   
                            }
                            else if(DataType == 'REFERENCE'){
                                if(objectName.toLowerCase() != 'task' && fieldNameForjson.toLowerCase() != 'accountid'){
                                   
                                    if(userMapping.get(string.valueOf(record.get(field))) != null){
                                        jSon_gen.writeStringField(fieldNameForjson, userMapping.get(string.valueOf(record.get(field))));
                                    }
                                }
                            }
                            
                            if(auditFieldsEnabled){
                                if(field.toLowerCase() == 'createddate' || field.toLowerCase() == 'lastmodifieddate'){
                                   
                                    if(record.get(field) != null){
                                        jSon_gen.writeDateTimeField(fieldNameForjson, DATETIME.valueOf(record.get(field)));
                                    }
                                }
                                if(field.toLowerCase() == 'createdbyid' || field.toLowerCase() == 'lastmodifiedbyid'){
                                    if(userMapping.get(string.valueOf(record.get(field))) != null){
                                        jSon_gen.writeStringField(fieldNameForjson, userMapping.get(string.valueOf(record.get(field))));
                                    }
                                }
                            }
                        }
                    }
                    if(field.toLowerCase() == 'recordtypeid'){ 
                        if(recordTypeMapping.get(string.valueOf(record.get('RecordTypeId'))) != null){
                            String sourceRecordTypeValue = recordTypeMapping.get(string.valueOf(record.get('RecordTypeId')));
                            //if(destinationRecordType.get(sourceRecordTypeValue) != null){
                                jSon_gen.writeStringField('RecordTypeId', sourceRecordTypeValue);    
                            //}
                        }
                    }
                    //if(field.toLowerCase() == 'opportunityid'){   
                        
                    //}
                }
                jSon_gen.writeEndObject();
                jSon_gen.writeEndObject();
            }
            jSon_gen.writeEndArray();
            jSon_gen.writeEndObject();
            return jSon_gen.getAsString();
        }
        return null;
    }
    
    public static string compositeBatchGetJSON(string destinationName, string objectName, List<Sobject> sObjectRecords){
        if(sObjectRecords.size()>0){ 
            
            List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaRecords = [Select Id, 
                                                                JunoDoc__Source_External_Id__c, 
                                                                JunoDoc__Destination_External_Id__c,
                                                                JunoDoc__Object_Name__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                JunoDoc__Object_Name__c =: objectName
                                                                AND
                                                                JunoDoc__Destination_Name__c =: destinationName];
                                                                
            String sourceExternalId = '';
            string destinationExternalId = '';
            if(schemaRecords.size()>0){
                sourceExternalId = schemaRecords[0].JunoDoc__Source_External_Id__c;
                destinationExternalId = schemaRecords[0].JunoDoc__Destination_External_Id__c;
            }
            JSONGenerator jSon_gen = JSON.createGenerator(true);   
            jSon_gen.writeStartObject();
            jSon_gen.writeFieldName('batchRequests'); 
            jSon_gen.writeStartArray();  
            for(sObject record : sObjectRecords){
                string externalIdValue = '';
                //if(setExternalIdAs == 'External Id As Source SFDC Id'){
                if(sourceExternalId != null){
                if(record.get(sourceExternalId) != null){
                    externalIdValue = (string)record.get(sourceExternalId);
                }
                else{
                    externalIdValue = (string)record.get('id');
                }
                }
                
                String endURL = 'v34.0/sobjects/'+ objectName + '/' + destinationExternalId + '/' + externalIdValue;
                jSon_gen.writeStartObject();
                jSon_gen.writeStringField('method', 'GET');
                jSon_gen.writeStringField('url', endURL+'?fields=id');
                jSon_gen.writeEndObject();
            }
            jSon_gen.writeEndArray();
            jSon_gen.writeEndObject();
            return jSon_gen.getAsString();
       }
       return null;
    }
    
    public Static string objectSchemaValidationJSON(List<String> objects){
        system.debug('objects--->'+objects);
        JSONGenerator jSon_gen = JSON.createGenerator(true);
        jSon_gen.writeStartObject();
        jSon_gen.writeFieldName('batchRequests');
        jSon_gen.writeStartArray();
        for(String objectName : objects){
            String endURL = '/services/data/v34.0/sobjects/'+ objectName + '/describe/';
            jSon_gen.writeStartObject();
            jSon_gen.writeStringField('method', 'GET');
            jSon_gen.writeStringField('url',endURL );
            jSon_gen.writeEndObject();
        }
        jSon_gen.writeEndArray();
        jSon_gen.writeEndObject();
        return jSon_gen.getAsString();
    }
    
    public class mtreeBatchAttributes{
        public Map<String, String> sourceObjectMap{get;set;}
        public Map<String, String> sourceRecordIdMap{get;set;}  
        public String MtreeJSONRequestBody{get;set;}
        
        public mtreeBatchAttributes(Map<String, String> map_sourceObjectMap, Map<String, String> map_sourceRecordIdMap, String str_MtreeJSONRequestBody){
            sourceObjectMap = map_sourceObjectMap;
            sourceRecordIdMap = map_sourceRecordIdMap;
            MtreeJSONRequestBody = str_MtreeJSONRequestBody; 
        }
    }
    
    public static mtreeBatchAttributes prepareMtreeBatchJSON(string destinationName, List<SobjectUtilityController.innerclassForParentResults> parentList, List<SobjectUtilityController.innerClassForChildResults> childList, boolean includeAttachments, Map<String,String> priceBookEntryMap){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        List<Attachment> attachments = new List<Attachment>();       
        Map<String, String> quoteMap = new Map<String, String>();
        Map<String, sobject> quoteLineItemMap = new Map<String, sobject>();
        Map<String, string> objectMap = new Map<String, String>();
        Map<String, String> recordMap = new Map<String, String>();   
        map<string, string> cloudSyncJSONFieldMap = new map<string, string>();   
        cloudSyncJSONFieldMap = utilityController.prepareCloudSyncFieldMapForjson();
        for(SobjectUtilityController.innerClassForChildResults obj_ChildRec : childList){
            if(obj_ChildRec.childRecordObjectName.toLowerCase() == ('QuoteLineItem').toLowerCase()){
                for(sObject sObj_childRecord : obj_ChildRec.childRecords){
                    quoteMap.put((string)sObj_childRecord.get('QuoteId'), (string)sObj_childRecord.get('PricebookEntryId'));
                }
            }
        }        
        if(includeAttachments){
            List<String> parentIdsForAttachments = new List<String>();
            for(SobjectUtilityController.innerclassForParentResults obj_ParentRec : parentList){
                for(sObject sObj_ParentRecord : obj_ParentRec.parentRecords){
                    parentIdsForAttachments.add(sObj_ParentRecord.Id);
                }
            }
            attachments = [SELECT Body, BodyLength, ContentType, Id, Name, ParentId FROM Attachment where ParentId IN: parentIdsForAttachments ORDER BY LastModifiedDate DESC];
        }   
        
        List<String> mtreeObjectList = new List<String>();
        for(SobjectUtilityController.innerclassForParentResults obj_ParentRec : parentList){
            mtreeObjectList.add(obj_ParentRec.parentRecordObjectName.replace(' ',''));
        }
        for(SobjectUtilityController.innerClassForChildResults obj_ChildRec : childList){
            mtreeObjectList.add(obj_ChildRec.childRecordObjectName.replace(' ',''));
        }
        
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c  > schemaRecords = [Select Id, 
                                                                JunoDoc__Missing_Fields__c, 
                                                                JunoDoc__Schema_External_ID__c, 
                                                                JunoDoc__Destination_External_Id__c,
                                                                JunoDoc__Object_Name__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                JunoDoc__Object_Name__c IN: mtreeObjectList
                                                                and 
                                                                JunoDoc__Destination_Name__c =: destinationName];
        List<JunoDoc__Junodoc_Object_RecordType_Mapping__c> recordTypeMappingRecords = [Select Id, 
                                                                    JunoDoc__Destination_Record_Type_Id__c, 
                                                                    JunoDoc__Source_Record_Type_Id__c
                                                                    from
                                                                    JunoDoc__Junodoc_Object_RecordType_Mapping__c
                                                                    where
                                                                    JunoDoc__Object__c IN: schemaRecords];   
        
        
                                                                    
        Map<String, String> missingObjectSchema = new Map<String, String>();
        for(JunoDoc__Junodoc_Object_Schema_Mapping__c schemaRec : schemaRecords){
            if(schemaRec.JunoDoc__Missing_Fields__c != null){
                List<String> missingFields = schemaRec.JunoDoc__Missing_Fields__c.split(',');
                for(String missingField : missingFields){
                    missingObjectSchema.put(schemaRec.JunoDoc__Object_Name__c.toLowerCase()+missingField.toLowerCase(), missingField);
                }
            }
        }
        
        map<String, string> recordTypeMapping = new map<String, String>();
        for(JunoDoc__Junodoc_Object_RecordType_Mapping__c recTypeMapRec : recordTypeMappingRecords){
            if(recTypeMapRec.JunoDoc__Source_Record_Type_Id__c != null && recTypeMapRec.JunoDoc__Destination_Record_Type_Id__c != null){
                recordTypeMapping.put(recTypeMapRec.JunoDoc__Source_Record_Type_Id__c, recTypeMapRec.JunoDoc__Destination_Record_Type_Id__c);
            }
        }
        
        
        if(parentList.size()>0){
            Map<String,String> attachmentParentMap = new Map<String,String>(); 
            integer i = 0;
            Map<String, String> objectRelationShipMap = new Map<String, String>();
            for(Schema.ChildRelationship cr : schemaMap.get(parentList[0].parentRecordObjectName.replace(' ','')).getDescribe().getChildRelationships()){
                if(cr.getRelationshipName() != null){
                    string objectName = string.valueOf(cr.getChildSObject()).toLowerCase();
                    string objectFiled = string.valueOf(cr.getField()).toLowerCase();
                    string relationShipName = cr.getRelationshipName().toLowerCase();
                    objectRelationShipMap.put(objectName + '.' + objectFiled, relationShipName);
                }
            }
            JSONGenerator jSon_gen = JSON.createGenerator(true);
            jSon_gen.writeStartObject();
            jSon_gen.writeFieldName('records');
            jSon_gen.writeStartArray();
            system.debug('parentList--->'+parentList);
            for(SobjectUtilityController.innerclassForParentResults obj_ParentRec : parentList){
                system.debug('obj_ParentRec--->'+obj_ParentRec);
                for(sObject sObj_ParentRecord : obj_ParentRec.parentRecords){
                    Map<String, Schema.SObjectField> fieldMap = schemaMap.get(obj_ParentRec.parentRecordObjectName.replace(' ','')).getDescribe().fields.getMap();
                    i = i+1;
                    paraserGeneratorUtilityController parentUtil = new paraserGeneratorUtilityController();
                    obj_ParentRec.parentRecordObjectName = obj_ParentRec.parentRecordObjectName.trim();
                    parentUtil.type = obj_ParentRec.parentRecordObjectName;
                    parentUtil.referenceid = 'ref'+i;
                    objectMap.put('ref'+i, obj_ParentRec.parentRecordObjectName.trim());
                    recordMap.put('ref'+i, string.valueOf(sObj_ParentRecord.get('Id')));
                    jSon_gen.writeStartObject();
                    jSon_gen.writeFieldName('attributes');
                    jSon_gen.writeObject(parentUtil);
                    for(string str_ParentObjectField : obj_ParentRec.parentFieldsForJSON.split(',')){
                        string fieldNameForjson = '';
                        if(cloudSyncJSONFieldMap.get(obj_ParentRec.parentRecordObjectName+str_ParentObjectField) == null){
                            fieldNameForjson = str_ParentObjectField;
                        }
                        else{
                            fieldNameForjson = cloudSyncJSONFieldMap.get(obj_ParentRec.parentRecordObjectName+str_ParentObjectField);
                        }
                        if(sObj_ParentRecord.get(str_ParentObjectField.replace(' ','').trim()) != null){
                            str_ParentObjectField = str_ParentObjectField.replace(' ','');
                            if(missingObjectSchema.get(obj_ParentRec.parentRecordObjectName.toLowerCase().trim()+str_ParentObjectField.toLowerCase().trim()) == null){
                                string str_fieldDataType = '';
                                boolean isExternalId = false;
                                boolean isUpdatable = false;
                                if(fieldMap.get(str_ParentObjectField) != null){
                                    str_fieldDataType = string.valueOf(fieldMap.get(str_ParentObjectField).getDescribe().getType());
                                    isExternalId = fieldMap.get(str_ParentObjectField).getDescribe().isexternalID();
                                    isUpdatable = fieldMap.get(str_ParentObjectField).getDescribe().isUpdateable();
                                }
                                else{
                                    str_fieldDataType = string.valueOf(fieldMap.get(str_ParentObjectField.replace('CloudSync1__','')).getDescribe().getType());
                                    isExternalId = fieldMap.get(str_ParentObjectField.replace('CloudSync1__','')).getDescribe().isexternalID();
                                    isUpdatable = fieldMap.get(str_ParentObjectField.replace('CloudSync1__','')).getDescribe().isUpdateable();
                                }
                                if(isUpdatable || str_fieldDataType == 'REFERENCE'){ 
                                        if(str_fieldDataType == 'STRING' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'TEXTAREA' || str_fieldDataType == 'PHONE' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'URL' || str_fieldDataType == 'EMAIL' || str_fieldDataType == 'MULTIPICKLIST'){
                                            jSon_gen.writeStringField(fieldNameForjson, string.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                        }    
                                        else if(str_fieldDataType == 'BOOLEAN'){
                                            jSon_gen.writeBooleanField(fieldNameForjson, boolean.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                        }
                                        else if(str_fieldDataType == 'DOUBLE'){
                                            jSon_gen.writeNumberField(fieldNameForjson, Double.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                        }
                                        else if(str_fieldDataType == 'DATETIME'){
                                            jSon_gen.writeDateTimeField(fieldNameForjson, DATETIME.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                        }
                                        else if(str_fieldDataType == 'DATE'){
                                            jSon_gen.writeDateField(fieldNameForjson, DATE.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                        }
                                        if(str_ParentObjectField == 'RecordTypeId'){
                                            if(recordTypeMapping.get(string.valueOf(sObj_ParentRecord.get(str_ParentObjectField))) != null){
                                                String sourceRecordTypeMapValue = recordTypeMapping.get(string.valueOf(sObj_ParentRecord.get(str_ParentObjectField)));
                                                //if(destinationRecordTypeMap.get(sourceRecordTypeMapValue) != null){
                                                    jSon_gen.writeStringField(fieldNameForjson, sourceRecordTypeMapValue);    
                                                //}
                                            }
                                        }
                                        if(str_ParentObjectField.toLowerCase() == ('pricebook2id').toLowerCase()){
                                            if(quoteMap.get((String)sObj_ParentRecord.get('id')) != null){
                                                if(priceBookEntryMap.get(quoteMap.get((String)sObj_ParentRecord.get('id'))) != null){
                                                    List<String> priceBookAndProductId = priceBookEntryMap.get(quoteMap.get((String)sObj_ParentRecord.get('id'))).split(':');
                                                    if(priceBookAndProductId.size()>=1){
                                                        jSon_gen.writeStringField('pricebook2id', priceBookAndProductId[1]);
                                                    }
                                                }
                                            }
                                        }
                                    //}
                                }
                            }
                            else{
                                boolean externalId = boolean.valueOf(fieldMap.get(str_ParentObjectField).getDescribe().isexternalID());
                                if(externalId){
                                    if((String)sObj_ParentRecord.get(str_ParentObjectField) != null){
                                        jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ParentRecord.get(str_ParentObjectField));
                                    }
                                    else{
                                        jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ParentRecord.get('id'));
                                    }
                                }
                            }
                        }
                        else{
                            if(str_ParentObjectField != null && str_ParentObjectField != ''){
                                str_ParentObjectField = str_ParentObjectField.replace(' ','');
                                if(fieldMap.get(str_ParentObjectField) != null){
                                    boolean externalId = boolean.valueOf(fieldMap.get(str_ParentObjectField).getDescribe().isexternalID());
                                    if(externalId){
                                        jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ParentRecord.get('id'));  
                                    }
                                }
                            }
                        }
                    }
                    if(includeAttachments){
                        jSon_gen.writeFieldName(schemaMap.get('Attachment').getDescribe().getLabelPlural());
                        jSon_gen.writeStartObject();
                        jSon_gen.writeFieldName('records');
                        jSon_gen.writeStartArray();
                        for(Attachment attachmentsRec : attachments){
                            if(sObj_ParentRecord.get('Id') == attachmentsRec.ParentId){
                                if(attachmentParentMap.get(attachmentsRec.ParentId) == null){
                                    attachmentParentMap.put(attachmentsRec.ParentId, attachmentsRec.ParentId);
                                    paraserGeneratorUtilityController AttachmentchildUtil = new paraserGeneratorUtilityController();
                                    i = i+1;
                                    AttachmentchildUtil.type = 'Attachment';
                                    AttachmentchildUtil.referenceid = 'ref'+i;
                                    objectMap.put('ref'+i, 'Attachment');
                                    recordMap.put('ref'+i, string.valueOf(attachmentsRec.get('Id')));
                                    jSon_gen.writeStartObject();
                                    jSon_gen.writeFieldName('attributes');
                                    jSon_gen.writeObject(AttachmentchildUtil);
                                    jSon_gen.writeBlobField('Body', attachmentsRec.Body);
                                    jSon_gen.writeStringField('Name', attachmentsRec.Name);
                                    if(attachmentsRec.ContentType != null){
                                        jSon_gen.writeStringField('ContentType', attachmentsRec.ContentType);
                                    }
                                    jSon_gen.writeEndObject();
                                }
                            }
                        }
                        jSon_gen.writeEndArray();
                        jSon_gen.writeEndObject();
                    }
                    
                    for(SobjectUtilityController.innerClassForChildResults obj_ChildRec : childList){
                        Map<String, Schema.SObjectField> childfieldMap = schemaMap.get(obj_ChildRec.childRecordObjectName.replace(' ','')).getDescribe().fields.getMap();
                        if(obj_ChildRec.childRecords != null){
                            if(obj_ChildRec.childRecords.size()>0){
                                if(obj_ChildRec.childRecordObjectName.toLowerCase() == ('OpportunityLineItem').toLowerCase() || obj_ChildRec.childRecordObjectName.toLowerCase() == ('QuoteLineItem').toLowerCase()){
                                    if(obj_ChildRec.childRecordObjectName.toLowerCase() == ('OpportunityLineItem').toLowerCase()){
                                        jSon_gen.writeFieldName('OpportunityLineItems');    
                                    }
                                    else {
                                        jSon_gen.writeFieldName('QuoteLineItems');
                                    }
                                    jSon_gen.writeStartObject();
                                    jSon_gen.writeFieldName('records');
                                    jSon_gen.writeStartArray();
                                    for(sObject sObj_ChildRec : obj_ChildRec.childRecords){
                                        if(sObj_ParentRecord.get('Id') == sObj_ChildRec.get(obj_ChildRec.childRecordParentReferenceId)){
                                            i = i+1;
                                            paraserGeneratorUtilityController childUtil1 = new paraserGeneratorUtilityController();
                                            if(obj_ChildRec.childRecordObjectName.toLowerCase() == ('OpportunityLineItem').toLowerCase()){
                                                childUtil1.type = 'OpportunityLineItem';   
                                            }
                                            else {
                                                childUtil1.type = 'QuoteLineItem';
                                            }
                                            childUtil1.referenceid = 'ref'+i;
                                            objectMap.put('ref'+i, childUtil1.type);
                                            recordMap.put('ref'+i, string.valueOf(sObj_ChildRec.get('Id')));
                                            jSon_gen.writeStartObject();
                                            jSon_gen.writeFieldName('attributes');
                                            jSon_gen.writeObject(childUtil1);
                                            for(string str_childObjectField : obj_ChildRec.childFieldsForJSON.split(',')){
                                                
                                                if(sObj_ChildRec.get(str_childObjectField.replace(' ','').trim()) != null){
                                                    str_childObjectField = str_childObjectField.replace(' ','');
                                                    if(missingObjectSchema.get(('OpportunityLineItem').toLowerCase().trim()+str_childObjectField.toLowerCase().trim()) == null){
                                                        string str_fieldDataType = string.valueOf(childfieldMap.get(str_childObjectField).getDescribe().getType());
                                                        boolean b_isUpdatable = boolean.valueOf(childfieldMap.get(str_childObjectField).getDescribe().isUpdateable());
                                                        if(sObj_ChildRec.get(str_childObjectField) != null){
                                                            if(str_fieldDataType == 'STRING' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'TEXTAREA' || str_fieldDataType == 'PHONE' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'URL' || str_fieldDataType == 'EMAIL' || str_fieldDataType == 'MULTIPICKLIST'){
                                                                if(sObj_ChildRec.get(str_childObjectField) != null && b_isUpdatable){
                                                                    jSon_gen.writeStringField(str_childObjectField, string.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                                }
                                                            }   
                                                            else if(str_fieldDataType == 'BOOLEAN' && b_isUpdatable){
                                                                jSon_gen.writeBooleanField(str_childObjectField, boolean.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if((str_fieldDataType == 'DOUBLE' || str_fieldDataType == 'CURRENCY') && b_isUpdatable){
                                                                jSon_gen.writeNumberField(str_childObjectField, Double.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if(str_fieldDataType == 'DATETIME' && b_isUpdatable){
                                                                jSon_gen.writeDateTimeField(str_childObjectField, DATETIME.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if(str_fieldDataType == 'DATE' && b_isUpdatable){
                                                                jSon_gen.writeDateField(str_childObjectField, DATE.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            
                                                            if(str_childObjectField == 'RecordTypeId'){
                                                                if(recordTypeMapping.get(string.valueOf(sObj_ChildRec.get(str_childObjectField))) != null){
                                                                    String sourceRecordTypeMapValue = recordTypeMapping.get(string.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                                    //if(destinationRecordTypeMap.get(sourceRecordTypeMapValue) != null){
                                                                        jSon_gen.writeStringField(str_childObjectField, sourceRecordTypeMapValue);    
                                                                    //}
                                                                }
                                                            }
                                                        }
                                                        if(str_childObjectField.toLowerCase() == ('PricebookEntryId').toLowerCase()){
                                                            if(sObj_ChildRec.get('PricebookEntryId') != null){
                                                                if(priceBookEntryMap.get((String)sObj_ChildRec.get('PricebookEntryId')) != null){
                                                                    List<String> priceBookAndProductId = priceBookEntryMap.get((String)sObj_ChildRec.get('PricebookEntryId')).split(':');
                                                                    if(priceBookAndProductId.size()>0){
                                                                        jSon_gen.writeStringField('PricebookEntryId', priceBookAndProductId[0]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        if(fieldMap.get(str_childObjectField.replace(' ','')) != null){
                                                            boolean externalId = boolean.valueOf(fieldMap.get(str_childObjectField.replace(' ','')).getDescribe().isexternalID());
                                                            if(externalId){
                                                                if((String)sObj_ParentRecord.get(str_childObjectField) != null){
                                                                    jSon_gen.writeStringField(str_childObjectField, (String)sObj_ParentRecord.get(str_childObjectField));
                                                                }
                                                                else{
                                                                    jSon_gen.writeStringField(str_childObjectField, (String)sObj_ParentRecord.get('id'));
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    //if(missingObjectSchema.get(('OpportunityLineItem').toLowerCase().trim()+str_childObjectField.toLowerCase().trim()) == null){
                                                        str_childObjectField = str_childObjectField.replace(' ','');
                                                        if(childfieldMap.get(str_childObjectField) != null){
                                                            boolean externalId = boolean.valueOf(childfieldMap.get(str_childObjectField).getDescribe().isexternalID());
                                                            if(externalId){
                                                                jSon_gen.writeStringField(str_childObjectField, (String)sObj_ChildRec.get('id'));
                                                            }
                                                        }
                                                    //}
                                                }
                                            }
                                            jSon_gen.writeEndObject();
                                        }
                                    }
                                    jSon_gen.writeEndArray();
                                    jSon_gen.writeEndObject();
                                }
                                else{
                                    if(schemaMap.get(obj_ChildRec.childRecordObjectName).getDescribe().isCustom()){
                                        string objectName = obj_ChildRec.childRecordObjectName.toLowerCase();
                                        string fieldName = obj_ChildRec.childRecordParentReferenceId.toLowerCase();
                                        jSon_gen.writeFieldName(objectRelationShipMap.get(objectName+'.'+fieldName));
  
                                    }
                                    else{
                                        string objectName = obj_ChildRec.childRecordObjectName.toLowerCase();
                                        string fieldName = obj_ChildRec.childRecordParentReferenceId.toLowerCase();
                                        jSon_gen.writeFieldName(objectRelationShipMap.get(objectName+'.'+fieldName));
                                    }
                                    jSon_gen.writeStartObject();
                                    jSon_gen.writeFieldName('records');
                                    jSon_gen.writeStartArray();
                                    for(sObject sObj_ChildRec : obj_ChildRec.childRecords){
                                        if(sObj_ParentRecord.get('Id') == sObj_ChildRec.get(obj_ChildRec.childRecordParentReferenceId)){
                                            i = i+1;
                                            paraserGeneratorUtilityController childUtil = new paraserGeneratorUtilityController();
                                            obj_ChildRec.childRecordObjectName = obj_ChildRec.childRecordObjectName.replace('\r\n', '');
                                            obj_ChildRec.childRecordObjectName = obj_ChildRec.childRecordObjectName.replace('\n', '');
                                            obj_ChildRec.childRecordObjectName = obj_ChildRec.childRecordObjectName.replace('\r', '');
                                            obj_ChildRec.childRecordObjectName = obj_ChildRec.childRecordObjectName.trim();
                                            childUtil.type = obj_ChildRec.childRecordObjectName;
                                            childUtil.referenceid = 'ref'+i;
                                            objectMap.put('ref'+i, childUtil.type);
                                            recordMap.put('ref'+i, string.valueOf(sObj_ChildRec.get('Id')));
                                            jSon_gen.writeStartObject();
                                            jSon_gen.writeFieldName('attributes');
                                            jSon_gen.writeObject(childUtil);
                                            for(string str_childObjectField : obj_ChildRec.childFieldsForJSON.split(',')){
                                                str_childObjectField = str_childObjectField.replace('\r\n', '');
                                                str_childObjectField = str_childObjectField.replace('\n', '');
                                                str_childObjectField = str_childObjectField.replace('\r', ''); 
                                                string fieldNameForjson = '';
                                                if(cloudSyncJSONFieldMap.get(obj_ChildRec.childRecordObjectName+str_childObjectField) == null){
                                                    fieldNameForjson = str_childObjectField;
                                                }
                                                else{
                                                    fieldNameForjson = cloudSyncJSONFieldMap.get(obj_ChildRec.childRecordObjectName+str_childObjectField);
                                                }
                                                if(missingObjectSchema.get(obj_ChildRec.childRecordObjectName.toLowerCase().trim()+str_childObjectField.toLowerCase().trim()) == null){
                                                    if(sObj_ChildRec.get(str_childObjectField.replace(' ','').trim()) != null){
                                                        str_childObjectField = str_childObjectField.replace(' ','');
                                                        string str_fieldDataType = string.valueOf(childfieldMap.get(str_childObjectField).getDescribe().getType());
                                                        if(childfieldMap.get(str_childObjectField).getDescribe().isUpdateable()){
                                                            if(str_fieldDataType == 'STRING' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'TEXTAREA' || str_fieldDataType == 'PHONE' || str_fieldDataType == 'PICKLIST' || str_fieldDataType == 'URL' || str_fieldDataType == 'EMAIL' || str_fieldDataType == 'MULTIPICKLIST'){
                                                                jSon_gen.writeStringField(fieldNameForjson, string.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }   
                                                            else if(str_fieldDataType == 'BOOLEAN'){
                                                                jSon_gen.writeBooleanField(fieldNameForjson, boolean.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if(str_fieldDataType == 'DOUBLE'){
                                                                jSon_gen.writeNumberField(fieldNameForjson, Double.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if(str_fieldDataType == 'DATETIME'){
                                                                jSon_gen.writeDateTimeField(fieldNameForjson, DATETIME.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                            else if(str_fieldDataType == 'DATE'){
                                                                jSon_gen.writeDateField(fieldNameForjson, DATE.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                            }
                                                        
                                                        }
                                                        if(str_childObjectField == 'RecordTypeId'){
                                                            if(recordTypeMapping.get(string.valueOf(sObj_ChildRec.get(str_childObjectField))) != null){
                                                                String sourceRecordTypeMapValue = recordTypeMapping.get(string.valueOf(sObj_ChildRec.get(str_childObjectField)));
                                                                //if(destinationRecordTypeMap.get(sourceRecordTypeMapValue) != null){
                                                                    jSon_gen.writeStringField(fieldNameForjson, sourceRecordTypeMapValue);      
                                                                //}
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        if(fieldMap.get(str_childObjectField.replace(' ','')) != null){
                                                            boolean externalId = boolean.valueOf(fieldMap.get(str_childObjectField.replace(' ','')).getDescribe().isexternalID());
                                                            if(externalId){
                                                                jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ParentRecord.get('id'));
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    str_childObjectField = str_childObjectField.replace(' ','');
                                                    if(childfieldMap.get(str_childObjectField) != null){
                                                        boolean externalId = boolean.valueOf(childfieldMap.get(str_childObjectField).getDescribe().isexternalID());
                                                        if(externalId){
                                                            if((String)sObj_ChildRec.get(str_childObjectField) != null){
                                                                jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ChildRec.get(str_childObjectField));
                                                            }
                                                            else{
                                                                jSon_gen.writeStringField(fieldNameForjson, (String)sObj_ChildRec.get('id'));
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            jSon_gen.writeEndObject();
                                        }
                                    }
                                    jSon_gen.writeEndArray();
                                    jSon_gen.writeEndObject();
                                }
                            }
                        }
                    }
                    jSon_gen.writeEndObject();
                }
            }
            jSon_gen.writeEndArray();
            jSon_gen.writeEndObject();
            return new mtreeBatchAttributes(objectMap, recordMap, jSon_gen.getAsString());
        }
        return null;
    } 
    
    
    // XMLUtilityController 
 
    
    private static final set<String> skipFields = new set<String> {''};
    private static final String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
    private static final String urn = 'urn:enterprise.soap.sforce.com';
    private static final  String urn1 = 'urn:sobject.enterprise.soap.sforce.com';
    private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String NS_SF = 'urn:partner.soap.sforce.com';
    
    
    public static String generateUpsertXML(string destination, string objectName, List<Sobject> sObjectRecords, List<String> fields, 
                                            Integer batchNumber, String SessionIdFromRes){
        
        
        //CloudSync_Settings__c cloudSyncSetting = utilityController.getCloudSyncSettings();
        boolean auditFieldsEnabled = false;
        List<JunoDoc__Junodoc_Connections__c> endPoint = [Select Id, 
        JunoDoc__Set_Audit_Fields__c
                                                                            from
                                                                            JunoDoc__Junodoc_Connections__c
                                                                            Where
                                                                            Id =: destination
                                                                            OR
                                                                            Name =: destination];
        if(!endPoint.isempty()){
            auditFieldsEnabled = endPoint[0].JunoDoc__Set_Audit_Fields__c;
        }                                                                    
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName.replace(' ','')).getDescribe().fields.getMap();
        Set<Id> lookupIds = new Set<Id>();
        Set<String> lookupFields = new Set<String>();
        for(string field : fields){
            if(fieldMap.get(field) != null){
                String DataType = string.valueOf(fieldMap.get(field).getDescribe().getType()); 
                if(DataType == 'REFERENCE'){
                    lookupFields.add(field);
                }
            }
        }
        
        for(Sobject record : sObjectRecords){
            for(String lookupField : lookupFields){
                if(record.get(lookupField) != null)
                lookupIds.add(String.valueOf(record.get(lookupField)));
            }
        }
        
        DOM.Document doc = new DOM.Document();
        Map<String, String> userMappingMap = utilityController.userMappings(destination);
        Map<String, String> resultMap = utilityController.resultMappings(batchNumber, lookupIds);
        
        //if(cloudSyncSetting.Log_Details__c){
            //utilityController.insertLogDetails(resultMap + 'result map size is' + resultMap.keySet().size(), lookupIds + 'size is' + lookupIds.size() + lookupFields + 'Scope Records are' + sObjectRecords, '' , batchNumber);
        //}
        
        List<Attachment> attachments = new List<Attachment>();
        map<string, string> cloudSyncJSONFieldMap = new map<string, string>();
        cloudSyncJSONFieldMap = utilityController.prepareCloudSyncFieldMapForjson();  
        
        if(true){
            List<String> recordIds = new List<String>();
            for(sObject sObjectRec : sObjectRecords){
                recordIds.add(sObjectRec.Id);
            }
            attachments = [SELECT Body, BodyLength, ContentType, Id, Name, ParentId FROM Attachment where ParentId IN: recordIds ORDER BY LastModifiedDate DESC];
        }
        
        
        List<JunoDoc__Junodoc_PriceBookEntry_Map__c> priceBookEntryList = [Select Id, JunoDoc__Source_PBE_Id__c, 
        JunoDoc__Destination_PBE_Id__c
                                                                                From
                                                                                JunoDoc__Junodoc_PriceBookEntry_Map__c
                                                                                Where
                                                                                JunoDoc__Destination__c =: destination];
                            
        
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaRecords = [Select Id, 
        JunoDoc__Missing_Fields__c, 
        JunoDoc__Source_External_Id__c, 
        JunoDoc__Destination_External_Id__c,
        JunoDoc__Object_Name__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                JunoDoc__Object_Name__c =: objectName
                                                                AND
                                                                JunoDoc__Destination_Name__c =: destination];
                                                                
        List<JunoDoc__Junodoc_Object_RecordType_Mapping__c> recordTypeMappingRecords = [Select Id, 
        JunoDoc__Destination_Record_Type_Id__c, 
        JunoDoc__Source_Record_Type__c
                                                                    from
                                                                    JunoDoc__Junodoc_Object_RecordType_Mapping__c
                                                                    where
                                                                    JunoDoc__Object__c =: schemaRecords];
                                                                    
        String sourceExternalId = schemaRecords[0].JunoDoc__Source_External_Id__c;
        system.debug('sourceExternalId >>> '+sourceExternalId);
        String destinationExternalId = schemaRecords[0].JunoDoc__Destination_External_Id__c;
        
        map<Id,Id> priceBookEntryMap = new map<Id,Id>();
        for(JunoDoc__Junodoc_PriceBookEntry_Map__c priceBookEntryRec : priceBookEntryList){
            priceBookEntryMap.put(priceBookEntryRec.JunoDoc__Source_PBE_Id__c, priceBookEntryRec.JunoDoc__Destination_PBE_Id__c);
        }
        
        Map<String, String> missingObjectSchema = new Map<String, String>();
        for(JunoDoc__Junodoc_Object_Schema_Mapping__c schemaRec : schemaRecords){
            if(schemaRec.JunoDoc__Missing_Fields__c != null){
                List<String> missingFields = schemaRec.JunoDoc__Missing_Fields__c.split(',');
                for(String missingField : missingFields){
                    missingObjectSchema.put(schemaRec.JunoDoc__Object_Name__c.toLowerCase()+missingField.toLowerCase(), missingField);
                }
            }
        }
        
        map<String, string> recordTypeMapping = new map<String, String>();
        for(JunoDoc__Junodoc_Object_RecordType_Mapping__c recTypeMapRec : recordTypeMappingRecords){
            if(recTypeMapRec.Source_Record_Type_Id__c != null && recTypeMapRec.Destination_Record_Type_Id__c != null){
                recordTypeMapping.put(recTypeMapRec.Source_Record_Type_Id__c, recTypeMapRec.Destination_Record_Type_Id__c);
            }
        }
        
        Map<String, String> fieldMapping = new Map<String, String>();
        List<JunoDoc__Junodoc_Field_Mapping__c> fieldMappingLst = [Select JunoDoc__Source_Field_API__c, 
        JunoDoc__Destination_Field_API__c 
                                                                        From 
                                                                        JunoDoc__Junodoc_Field_Mapping__c
                                                                        Where
                                                                        JunoDoc__Object_Name__c =: objectName
                                                                        And
                                                                        JunoDoc__Destination__c =: destination];
        for(JunoDoc__Junodoc_Field_Mapping__c fieldMappingRec : fieldMappingLst){
            fieldMapping.put(fieldMappingRec.JunoDoc__Source_Field_API__c.toLowerCase(), fieldMappingRec.JunoDoc__Destination_Field_API__c);
        }
        
        // Create the request envelope
        Dom.XmlNode envelope= doc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('urn', urn);
        envelope.setNamespace('urn1', urn1);
        envelope.setNamespace('xsi', xsi);
            
        Dom.Xmlnode Header = envelope.addChildElement('soapenv:Header', null, null);
        Dom.Xmlnode SessionHeader = Header.addChildElement('urn:SessionHeader', null, null);
        Dom.Xmlnode sessionId = SessionHeader.addChildElement('urn:sessionId', null, null);
        sessionId.addTextNode(string.valueOf(SessionIdFromRes));
        //Body create 
        Dom.XmlNode bodyRoot = doc.getRootElement();
        Dom.Xmlnode body = bodyRoot.addChildElement('soapenv:Body',null,null);
    
        Dom.Xmlnode create = body.addChildElement('urn:upsert',null,null);
        Dom.Xmlnode ExternalID = create.addChildElement('urn:externalIDFieldName',null,null);
                                                if(ExternalID != null && destinationExternalId != null){
        ExternalID.addTextNode(destinationExternalId);
                                                }
        for(sobject record : sObjectRecords){
            Dom.Xmlnode sObjectsCreate = create.addChildElement('urn:sObjects',null,null);
            sObjectsCreate.setAttribute('xsi:type', 'urn1:'+objectName);
            string externalIdValue = '';
            system.debug('sourceExternalId 2 >>> '+sourceExternalId);
            system.debug('record >>> '+record);
            if(record.get(sourceExternalId) != null){
                externalIdValue = (string)record.get(sourceExternalId);
            }
            else{
                externalIdValue = (string)record.get('id');
            }
            Dom.Xmlnode xmlExternalfield = sObjectsCreate.addChildElement(destinationExternalId ,null,null);
            xmlExternalfield.addTextNode(externalIdValue);
            for(string field : fields){
                
                system.debug('the field is' + field);
                system.debug('the field mapping is' + fieldMapping);
                
                if(missingObjectSchema.get(objectName.toLowerCase().trim() + field.toLowerCase().trim()) == null && !skipFields.contains(field.toLowerCase().trim())){
                    if(record.get(field.replace(' ','')) != null){
                        string fieldNameForjson = '';
                        if(fieldMapping.get(field.trim().toLowerCase()) != null){
                            fieldNameForjson = fieldMapping.get(field.trim().toLowerCase());
                        }
                        else{
                            if(cloudSyncJSONFieldMap.get(objectName + field) == null){
                                fieldNameForjson = field.trim();
                            }
                            else{
                                fieldNameForjson = cloudSyncJSONFieldMap.get(objectName + field).trim();
                            }
                        }
                        field = field.replace(' ','');
                        string DataType = '';
                        boolean isExternalId = false;
                        boolean isUpdatable = false;
                        if(fieldMap.get(field) != null){
                            DataType = string.valueOf(fieldMap.get(field).getDescribe().getType()); 
                            isUpdatable = fieldMap.get(field).getDescribe().isUpdateable();
                        }
                        else{
                            DataType = string.valueOf(fieldMap.get(field.replace('','')).getDescribe().getType());
                            isUpdatable = fieldMap.get(field.replace('','')).getDescribe().isUpdateable();
                        }
                        if(field == 'NumberOfEmployees'){
                            system.debug('the data type is' + DataType);
                            system.debug('is Updatable is' + isUpdatable);
                        }
                        if(isUpdatable){
                            if(field != 'PhotoUrl' && sourceExternalId.toLowerCase() != field.toLowerCase()){
                                if(fieldNameForjson.toLowerCase() == 'type'){
                                    fieldNameForjson = 'Type';
                                }
                                if(DataType == 'STRING' || DataType == 'PICKLIST' || DataType == 'TEXTAREA' || DataType == 'PHONE' || DataType == 'PICKLIST' || DataType == 'URL' || DataType == 'EMAIL' || DataType == 'MULTIPICKLIST'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        xmlfield.addTextNode(string.valueOf(record.get(field)));
                                    }
                                }    
                                else if(DataType == 'BOOLEAN' && field.trim() != 'UseStandardPrice'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        xmlfield.addTextNode(String.valueOF(record.get(field)));
                                    }
                                }
                                else if(DataType == 'DOUBLE' || DataType == 'CURRENCY'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode  xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        xmlfield.addTextNode(string.valueOf(record.get(field)));
                                    }
                                }
                                else if(DataType == 'DATETIME'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        DATETIME dateTimeValue = DATETIME.valueOf(record.get(field));
                                        xmlfield.addTextNode(dateTimeValue.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
                                    }
                                }
                                else if(DataType == 'DATE'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        xmlfield.addTextNode(string.valueOf(record.get(field)));
                                    }
                                }
                                else if(DataType == 'INTEGER'){
                                    if(record.get(field) != null){
                                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                        xmlfield.addTextNode(string.valueOf(record.get(field)));
                                    }
                                }
                                if(DataType == 'REFERENCE' && sObjectsCreate.getChildElement(fieldNameForjson,sObjectsCreate.getNamespace()) == null){
                                    if(field.toLowerCase() != 'createddate' || field.toLowerCase() != 'lastmodifieddate'){
                                        if(resultMap.get(string.valueOf(record.get(field))) != null){
                                            Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                            xmlfield.addTextNode(string.valueOf(resultMap.get(string.valueOf(record.get(field)))));
                                        }
                                        else if(userMappingMap.get(string.valueOf(record.get(field))) != null){
                                            Dom.Xmlnode  xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                            xmlfield.addTextNode(string.valueOf(userMappingMap.get(string.valueOf(record.get(field)))));
                                        }
                                    }
                                }
                            }
                        }
                        if(DataType == 'REFERENCE' && sObjectsCreate.getChildElement(fieldNameForjson,sObjectsCreate.getNamespace()) == null){
                            if(field.toLowerCase() != 'createdbyid' && field.toLowerCase() != 'lastmodifiedbyid'){
                                if((objectName.toLowerCase() != 'task' || objectName.toLowerCase() != 'event') && field.toLowerCase() != 'accountid'){
                                    if(field.toLowerCase() == 'pricebookentryid'){
                                        if(priceBookEntryMap.values().size() > 0){
                                            if(priceBookEntryMap.get(string.valueOf(record.get(field))) != null){
                                                Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                                xmlfield.addTextNode(string.valueOf(priceBookEntryMap.get(string.valueOf(record.get(field)))));
                                            }
                                        }
                                        else{
                                            if(resultMap.get(string.valueOf(record.get(field))) != null){
                                                Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                                xmlfield.addTextNode(string.valueOf(resultMap.get(string.valueOf(record.get(field)))));
                                            }
                                        }
                                    }
                                    else{
                                        if(resultMap.get(string.valueOf(record.get(field))) != null){
                                            Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                            xmlfield.addTextNode(string.valueOf(resultMap.get(string.valueOf(record.get(field)))));
                                        }
                                        else if(userMappingMap.get(string.valueOf(record.get(field))) != null){
                                            Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                            xmlfield.addTextNode(string.valueOf(userMappingMap.get(string.valueOf(record.get(field)))));
                                        }
                                    }
                                }
                            }
                          
                        }
                        else if((objectName.toLowerCase() == 'task' || objectName.toLowerCase() == 'event') && field.toLowerCase() == 'subject'){
                            if(record.get(field) != null){
                                Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                xmlfield.addTextNode(string.valueOf(record.get(field)));
                            }
                        }
                        if(auditFieldsEnabled){
                            if(field.toLowerCase() == 'createddate' || field.toLowerCase() == 'lastmodifieddate'){
                                Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(field ,null,null);
                                DATETIME dateTimeValue = DATETIME.valueOf(record.get(field));
                                xmlfield.addTextNode(dateTimeValue.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
                            }
                            if(field.toLowerCase() == 'createdbyid' || field.toLowerCase() == 'lastmodifiedbyid'){
                                if(userMappingMap.get(string.valueOf(record.get(field))) != null){
                                    Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                    xmlfield.addTextNode(string.valueOf(userMappingMap.get(string.valueOf(record.get(field)))));
                                }
                            }
                            if(field.toLowerCase() == 'isconverted'){
                                if(record.get(field) == true){
                                    Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement(fieldNameForjson ,null,null);
                                    xmlfield.addTextNode(String.valueOF(record.get(field)));
                                }
                            }
                        }
                    }
                }
                if(field.toLowerCase() == 'recordtypeid'){ 
                    if(recordTypeMapping.get(string.valueOf(record.get('RecordTypeId'))) != null){
                        String sourceRecordTypeValue = recordTypeMapping.get(string.valueOf(record.get('RecordTypeId')));
                        Dom.Xmlnode xmlfield = sObjectsCreate.addChildElement('RecordTypeId' ,null,null);
                        xmlfield.addTextNode(sourceRecordTypeValue);
                    }
                }
              
            }
        }
        system.debug('the xml is' + doc.toXmlString());
        return doc.toXmlString();    
    }
    
    public static string geneareQueryXMLForMetadata(string destination, string objectName, List<Sobject> sObjectRecords, string SessionIdFromRes){
        system.debug('SessionIdFromRes-->'+SessionIdFromRes);
        DOM.Document doc = new DOM.Document();
        if(sObjectRecords.size()>0){ 
            List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaRecords = [Select Id, 
                                                                Missing_Fields__c, 
                                                                Source_External_Id__c, 
                                                                Destination_External_Id__c,
                                                                Object_Name__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                Object_Name__c =: objectName
                                                                AND
                                                                Destination_Name__c =: destination];
            string sourceExternalId = schemaRecords[0].Source_External_Id__c;
            string destinationExternalId = schemaRecords[0].Destination_External_Id__c;
            // Create the request envelope
            Dom.XmlNode envelope= doc.createRootElement('Envelope', soapNS, 'soapenv');
            envelope.setNamespace('urn', urn);
            
            Dom.Xmlnode Header = envelope.addChildElement('soapenv:Header', null, null);
            Dom.Xmlnode SessionHeader = Header.addChildElement('urn:SessionHeader', null, null);
            Dom.Xmlnode sessionId = SessionHeader.addChildElement('urn:sessionId', null, null);
            sessionId.addTextNode(SessionIdFromRes);
            //Body create 
            Dom.XmlNode bodyRoot = doc.getRootElement();
            Dom.Xmlnode body = bodyRoot.addChildElement('soapenv:Body', null, null);
    
            Dom.Xmlnode query = body.addChildElement('urn:query', null, null);
            Dom.Xmlnode queryStringNode = query.addChildElement('urn:queryString', null, null);
            String QueryString = 'Select Id,' + destinationExternalId +' FROM ' + objectName + ' where '+ destinationExternalId +' in (';
            for(sObject record : sObjectRecords){
                string externalIdValue = '';
                if(record.get(sourceExternalId) != null){
                    externalIdValue = (string)record.get(sourceExternalId);
                }
                else{
                    externalIdValue = (string)record.get('id');
                }
                QueryString = QueryString + '\'' + externalIdValue + '\',';
            }
            if(queryString!=null ){
                queryString = queryString.removeend(',')+')';
            }
            queryStringNode.addTextNode(QueryString);
            return doc.toXmlString();    
       }
       return null;
    }
    
    public static string geneareMetadataQueryXML(string destination, string objectName, List<Sobject> sObjectRecords, string SessionIdFromRes, String metadataQueryFields, String destinationExternalId, String sourceExternalId){
        
     
        
        DOM.Document doc = new DOM.Document();
        if(sObjectRecords.size()>0){ 
          
            
            // Create the request envelope
            Dom.XmlNode envelope= doc.createRootElement('Envelope', soapNS, 'soapenv');
            envelope.setNamespace('urn', urn);
            
            Dom.Xmlnode Header = envelope.addChildElement('soapenv:Header', null, null);
            Dom.Xmlnode SessionHeader = Header.addChildElement('urn:SessionHeader', null, null);
            Dom.Xmlnode sessionId = SessionHeader.addChildElement('urn:sessionId', null, null);
            sessionId.addTextNode(SessionIdFromRes);
            //Body create 
            Dom.XmlNode bodyRoot = doc.getRootElement();
            Dom.Xmlnode body = bodyRoot.addChildElement('soapenv:Body', null, null);
    
            Dom.Xmlnode query = body.addChildElement('urn:query', null, null);
            Dom.Xmlnode queryStringNode = query.addChildElement('urn:queryString', null, null);
            String QueryString = 'Select ' + metadataQueryFields +' FROM ' + objectName + ' where '+ destinationExternalId +' in (';
            for(sObject record : sObjectRecords){
                string externalIdValue = '';
                if(record.get(sourceExternalId) != null){
                    externalIdValue = (string)record.get(sourceExternalId);
                }
                else{
                    externalIdValue = (string)record.get('id');
                }
                QueryString = QueryString + '\'' + externalIdValue + '\',';
            }
            if(queryString!=null ){
                queryString = queryString.removeend(',')+')';
            }
            queryStringNode.addTextNode(QueryString);
            return doc.toXmlString();    
       }
       return null;
    }
    
    public static string geneareQueryXML(string destination, string objectName, List<Sobject> sObjectRecords, string SessionIdFromRes){
        system.debug('SessionIdFromRes--->'+SessionIdFromRes);
        DOM.Document doc = new DOM.Document();
        if(sObjectRecords.size()>0){ 
            List<JunoDoc__Junodoc_Object_Schema_Mapping__c> schemaRecords = [Select Id, 
                                                                Missing_Fields__c, 
                                                                Source_External_Id__c, 
                                                                Destination_External_Id__c,
                                                                Object_Name__c
                                                                from
                                                                JunoDoc__Junodoc_Object_Schema_Mapping__c
                                                                where 
                                                                Object_Name__c =: objectName
                                                                AND
                                                                Destination_Name__c =: destination];
            string sourceExternalId = schemaRecords[0].Source_External_Id__c;
            string destinationExternalId = schemaRecords[0].Destination_External_Id__c;
            // Create the request envelope
            Dom.XmlNode envelope= doc.createRootElement('Envelope', soapNS, 'soapenv');
            envelope.setNamespace('urn', urn);
            
            Dom.Xmlnode Header = envelope.addChildElement('soapenv:Header', null, null);
            Dom.Xmlnode SessionHeader = Header.addChildElement('urn:SessionHeader', null, null);
            Dom.Xmlnode sessionId = SessionHeader.addChildElement('urn:sessionId', null, null);
            sessionId.addTextNode(SessionIdFromRes);
            //Body create 
            Dom.XmlNode bodyRoot = doc.getRootElement();
            Dom.Xmlnode body = bodyRoot.addChildElement('soapenv:Body', null, null);
    
            Dom.Xmlnode query = body.addChildElement('urn:query', null, null);
            Dom.Xmlnode queryStringNode = query.addChildElement('urn:queryString', null, null);
            String QueryString = 'Select Id,' + destinationExternalId +' FROM ' + objectName + ' where '+ destinationExternalId +' in (';
            for(sObject record : sObjectRecords){
                string externalIdValue = '';
                if(record.get(sourceExternalId) != null){
                    externalIdValue = (string)record.get(sourceExternalId);
                }
                else{
                    externalIdValue = (string)record.get('id');
                }
                QueryString = QueryString + '\'' + externalIdValue + '\',';
            }
            if(queryString!=null ){
                queryString = queryString.removeend(',')+')';
            }
            queryStringNode.addTextNode(QueryString);
            return doc.toXmlString();    
       }
       return null;
    }
    
    public class paraserGeneratorUtilityController{
        public String type;
    public String referenceId;  
    } 
    
    
}
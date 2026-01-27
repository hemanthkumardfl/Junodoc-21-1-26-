global class JunoSignPostActionsController {
    @AuraEnabled
    public static List<Map<String, String>> getObjectFields(String recordId) {
        Id recId = Id.valueOf(recordId);
        Map<String, Schema.SObjectField> fieldsMap = recId.getSObjectType().getDescribe().fields.getMap();        
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
        for (String fieldName : fieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            Map<String, String> fieldInfo = new Map<String, String>();
            if (fieldDescribe.isAccessible() && fieldDescribe.isUpdateable()) {
                fieldInfo.put('label', fieldDescribe.getLabel());
                fieldInfo.put('value', fieldDescribe.getName());
                fieldsList.add(fieldInfo);
            }
        }
        return fieldsList;
    }
    @AuraEnabled 
    public static string  getFieldValue(String recordId, String fieldName) {
        String objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        Schema.SObjectField field = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(fieldName);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
        return JSON.serialize(fieldDescribe);
    }
    
    public class PostActionRecords {
        @AuraEnabled  public String fieldName ;
        @AuraEnabled public String fieldType;
        @AuraEnabled  public String fieldValue;
        @AuraEnabled public String fieldDetail;
        @AuraEnabled public String parentId;
    }
    @AuraEnabled
    public static List<Id> updateRecord(Id recordId,  list<Object> rows) {
        List<Id> insertedIds = new List<Id>();
        try {
            JunoDoc__JunosSign_Post_Reference__c  Reference = New JunoDoc__JunosSign_Post_Reference__c();
            Reference.Name = 'test';
            insert Reference;
            id Referenceid = Reference.Id;
            insertedIds.add(Reference.Id);
           
            List<JunoDoc__JunoSign_Post_Actions__c> postActionList = new List<JunoDoc__JunoSign_Post_Actions__c>();
            
            for (Object obj : rows ) {
                PostActionRecords record = (PostActionRecords)JSON.deserialize(JSON.serialize(obj), PostActionRecords.class);
                JunoDoc__JunoSign_Post_Actions__c postAction = new JunoDoc__JunoSign_Post_Actions__c();
               
                postAction.JunoDoc__Parent_RecordId__c = recordId;
                postAction.JunoDoc__Field_Name__c = record.fieldName;
                postAction.JunoDoc__Field_DataType__c = record.fieldType;
                postAction.JunoDoc__JunoSign_Recipient__c = record.parentId;
                postAction.JunoDoc__JunosSign_Post_Reference__c = Referenceid;
                postAction.JunoDoc__Field_Value__c = record.fieldValue != null ? record.fieldValue : null;
                postActionList.add(postAction);
            }
            if (!postActionList.isEmpty()) {
                insert postActionList;
            }
        } catch (Exception e) {
            system.debug('Error during deserialization: ' + e.getMessage());
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
        
        return insertedIds; // Return the list of inserted record IDs
    }
    
    @AuraEnabled
    public static List<PostActionRecords> getExistingRecords(String recordId) {
        List<PostActionRecords> result = new List<PostActionRecords>();
        
        String prefix = String.valueOf(recordId).substring(0, 3);
        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        String sObjectType;
        
        for (String objName : globalDescribe.keySet()) {
            if (globalDescribe.get(objName).getDescribe().getKeyPrefix() == prefix) {
                sObjectType = objName;
                break;
            }
        }
        
        if (String.isBlank(sObjectType)) {
            throw new AuraHandledException('Unable to find object type for the given record ID.');
        }
        String query = 'SELECT Id FROM ' + sObjectType + ' WHERE Id = :recordId LIMIT 1';
        SObject record = Database.query(query);
        List<JunoDoc__JunoSign_Post_Actions__c> existingRecords = [
            SELECT JunoDoc__Field_Name__c, JunoDoc__Field_DataType__c, JunoDoc__Field_Value__c
            FROM JunoDoc__JunoSign_Post_Actions__c
            WHERE JunoDoc__JunoSignObjectAPIName__c = :sObjectType
        ];
        
        // Convert to the PostActionRecords format
        for (JunoDoc__JunoSign_Post_Actions__c postActionRecord : existingRecords) {
            PostActionRecords postRecord = new PostActionRecords();
            postRecord.fieldName = postActionRecord.JunoDoc__Field_Name__c;
            postRecord.fieldType = postActionRecord.JunoDoc__Field_DataType__c;
            postRecord.fieldValue = postActionRecord.JunoDoc__Field_Value__c;
            
        
        String objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        Schema.SObjectField field = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().get(postActionRecord.JunoDoc__Field_Name__c);
        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
         postRecord.fieldDetail = JSON.serialize(fieldDescribe);
            result.add(postRecord);
             system.debug('postRecord>>> '+postRecord);
        }
       
           return result;
    }
    
    public static void handleTransactionUpdate(List<JunoDoc__Juno_Sign_Recipient__c> transactions) {

        Set<string> signRecipIds = new Set<string>();
        for(JunoDoc__Juno_Sign_Recipient__c sign : transactions){
            signRecipIds.add(sign.Id);
        }

        List<JunoDoc__Juno_Sign_Recipient__c> signedRecords = new List<JunoDoc__Juno_Sign_Recipient__c>();

        if(!Test.isRunningTest()){
            signedRecords = [SELECT Id,Juno_Sign_Transaction__c,JunoDoc__Status__c,Juno_Sign_Transaction__r.JunoDoc__Object_Id__c FROM JunoDoc__Juno_Sign_Recipient__c
                                                                        Where Id IN :signRecipIds]; 
        } else{
            signedRecords = transactions;
        }
        
        List<JunoDoc__Juno_Sign_Recipient__c> signedRecipients = new List<JunoDoc__Juno_Sign_Recipient__c>();
        system.debug('signedRecords>> '+signedRecords);
        for (JunoDoc__Juno_Sign_Recipient__c tx : signedRecords) {
            if (tx.Status__c == 'Signed' && tx.Juno_Sign_Transaction__c != null) {
                signedRecipients.add(tx);
            }
        }

        system.debug('signedRecipients >>> '+signedRecipients);
        // Extract recipient Ids
        Set<Id> signedRecipientIds = new Set<Id>();
        for (JunoDoc__Juno_Sign_Recipient__c recipient : signedRecipients) {
            signedRecipientIds.add(recipient.Id);
        }

        system.debug('signedRecipientIds >> '+signedRecipientIds);

        // Query for post actions related to signed recipients
        List<JunoDoc__JunoSign_Post_Actions__c> postActions = [SELECT Id, JunoDoc__Field_DataType__c, JunoDoc__Field_Name__c, 
                                                                       JunoDoc__JunoSign_Recipient__c, JunoDoc__Field_Value__c, 
                                                                       JunoDoc__Parent_RecordId__c, JunoDoc__JunoSign_Transaction__c
                                                                FROM JunoDoc__JunoSign_Post_Actions__c 
                                                                WHERE JunoDoc__JunoSign_Recipient__c IN :signedRecipientIds];

        // Map to store transactions by Id
        Map<Id, Id> transactionMap = new Map<Id, Id>();
        for (JunoDoc__Juno_Sign_Recipient__c recipient : signedRecipients) {
            transactionMap.put(recipient.Juno_Sign_Transaction__c, recipient.Juno_Sign_Transaction__r.JunoDoc__Object_Id__c);
        }

        // Collect related Quote IDs
        Set<Id> quoteIds = new Set<Id>();
        for (JunoDoc__Juno_Sign_Recipient__c recipient : signedRecipients) {
            if (transactionMap.containsKey(recipient.Juno_Sign_Transaction__c)) {
                system.debug(transactionMap.get(recipient.Juno_Sign_Transaction__c));
               Id quoteId = transactionMap.get(recipient.Juno_Sign_Transaction__c);
                if (quoteId != null) {
                    quoteIds.add(quoteId);
                }
            }
        }

        if (quoteIds.isEmpty()) {
            return;
        }
    
        
        system.debug('quoteIds>>>>>>>>>>>>>>'+quoteIds);
        Map<String, List<String>> objectApiNameRecordList = new Map<String, List<String>>();
        if (!quoteIds.isEmpty()) {
            for(String singleRecordId : quoteIds){
                String objectName = Id.valueOf(singleRecordId).getSObjectType().getDescribe().getName();
                if(objectApiNameRecordList.get(objectName) != null){
                    List<String> recIds = objectApiNameRecordList.get(objectName);
                    recIds.add(singleRecordId);
                    objectApiNameRecordList.put(objectName, recIds);
                }else{
                    List<String> recIds = new List<String>();
                    recIds.add(singleRecordId);
                    objectApiNameRecordList.put(objectName, recIds);
                }
            }
        }
        if (objectApiNameRecordList.keyset().size() == 0) {
            return;
        }
        system.debug('objectApiNameRecordList>>>>>>>>>>>>>'+objectApiNameRecordList);
        List<String> queryList = new List<String>();
        List<Sobject> records = new List<sObject>();
        for (String ApiName : objectApiNameRecordList.keySet()) {
            List<String> ids = objectApiNameRecordList.get(ApiName);
            String query = 'SELECT Id FROM ' + ApiName + ' WHERE Id IN :ids';
            system.debug('query>>>>>>>>>>>>>'+query);
            queryList.add(query);
            records.addAll(Database.query(query));
        }
         system.debug('records>>>>>>>>>>>>>'+records);
         
        Map<Id, SObject> recordsToUpdate = new Map<Id, SObject>();
        for (SObject record : records) {
            recordsToUpdate.put((Id)record.get('Id'), record);
        }
         system.debug('recordsToUpdate>>>>>>>>>>>>>'+recordsToUpdate);
          system.debug('postActions>>>>>>>>>>>>>'+postActions);
        for (JunoDoc__JunoSign_Post_Actions__c action : postActions) {
            Id parentRecordId = action.JunoDoc__Parent_RecordId__c;
            system.debug('parentRecordId>>>>>>>>>>>>>>>>>'+parentRecordId);
            if (recordsToUpdate.containsKey(parentRecordId)) {
                SObject recordToUpdate = recordsToUpdate.get(parentRecordId);
                system.debug('recordToUpdate>>>>>>>>>>' + recordToUpdate);
                system.debug('action.JunoDoc__Field_Name__c>>>>>>>>>>' + action.JunoDoc__Field_Name__c);
                system.debug('action.JunoDoc__Field_Value__c>>>>>>>>>>' + action.JunoDoc__Field_Value__c);
                
                if (recordToUpdate != null && action.JunoDoc__Field_Name__c != null) {
                    SObjectField field = recordToUpdate.getSObjectType().getDescribe().fields.getMap().get(action.JunoDoc__Field_Name__c);
                    // system.debug('field-->'+field.getDescribe().isUpdateable());
                    // system.debug('field != null-->'+ field != null);
                    if (field != null) {
                        Schema.DisplayType fieldType = field.getDescribe().getType();
                        
                        Object valueToAssign;
                        try {
                       if (fieldType == Schema.DisplayType.Date) {
                                    if (action.JunoDoc__Field_Value__c == 'today' || action.JunoDoc__Field_Value__c == 'Today'|| action.JunoDoc__Field_Value__c == 'TODAY') {
                                        valueToAssign = System.today();
                                    } else if (action.JunoDoc__Field_Value__c == 'yesterday' ||action.JunoDoc__Field_Value__c == 'Yesterday' || action.JunoDoc__Field_Value__c == 'YESTERDAY') {
                                        valueToAssign = System.today().addDays(-1); // Subtract 1 day for yesterday
                                    } else if (action.JunoDoc__Field_Value__c == 'tomorrow' || action.JunoDoc__Field_Value__c == 'Tomorrow' || action.JunoDoc__Field_Value__c == 'TOMORROW') {
                                        valueToAssign = System.today().addDays(1); // Add 1 day for tomorrow
                                    } else {
                                        try {
                                            valueToAssign = Date.valueOf(action.JunoDoc__Field_Value__c);
                                        } catch (Exception e) {
                                            System.debug('Invalid Date: ' + e.getMessage());
                                        }
                                    }
                                } else if (fieldType == Schema.DisplayType.DateTime) {
                                    if (action.JunoDoc__Field_Value__c == 'today') {
                                        valueToAssign = System.now();
                                    } else if (action.JunoDoc__Field_Value__c == 'yesterday') {
                                        valueToAssign = System.now().addDays(-1); // Subtract 1 day for yesterday
                                    } else if (action.JunoDoc__Field_Value__c == 'tomorrow') {
                                        valueToAssign = System.now().addDays(1); // Add 1 day for tomorrow
                                    } else {
                                        try {
                                            valueToAssign = DateTime.valueOf(action.JunoDoc__Field_Value__c);
                                        } catch (Exception e) {
                                            System.debug('Invalid DateTime: ' + e.getMessage());
                                        }
                                    }
                            } else if (fieldType == Schema.DisplayType.Boolean) {
                                valueToAssign = Boolean.valueOf(action.JunoDoc__Field_Value__c);
                            } else if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Percent) {
                                valueToAssign = Double.valueOf(action.JunoDoc__Field_Value__c);
                            } else if (fieldType == Schema.DisplayType.Integer) {
                                valueToAssign = Integer.valueOf(action.JunoDoc__Field_Value__c);
                            } else if (fieldType == Schema.DisplayType.Reference) {
                                String idValue = action.JunoDoc__Field_Value__c;
                                Pattern idPattern = Pattern.compile('^[a-zA-Z0-9]{15}|[a-zA-Z0-9]{18}$');
                                Matcher idMatcher = idPattern.matcher(idValue);
                                if (idValue != null && idMatcher.matches()) {
                                    valueToAssign = idValue;
                                } else {
                                    system.debug('Invalid ID: ' + idValue);
                                    continue; // Skip invalid ID updates
                                }
                            } else {
                                valueToAssign = action.JunoDoc__Field_Value__c; // Assign as String or other field types
                            }
                            
                            recordToUpdate.put(action.JunoDoc__Field_Name__c, valueToAssign);
                            recordsToUpdate.put(parentRecordId, recordToUpdate);
                            system.debug('recordToUpdate>>>>>>>>>>>>>>>>'+recordToUpdate);
                            system.debug('recordsToUpdate>>>>>>>>>>>>>>>>'+recordsToUpdate);
                        
                        } catch (Exception e) {
                            system.debug('Error converting value for field ' + action.JunoDoc__Field_Name__c + ': ' + e.getMessage());
                            continue; // Skip this field on error
                        }
                    }
                }
            }
        
        }
        try {
            update recordsToUpdate.values();
        } catch (DmlException e) {
            system.debug('Update failed: ' +e.getStackTraceString()+' >> '+ e.getMessage());
        }
    
    
    }
}
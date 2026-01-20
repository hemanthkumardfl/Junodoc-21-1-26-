global class JunoSignObjectPostActionsController {
    
    @AuraEnabled
    public static List<Map<String, String>> getObjectFields(String objectApiName) {
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectApiName);
        if (sObjectType == null) {
            throw new AuraHandledException('Invalid object API name: ' + objectApiName);
        }
        
        Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
        
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
    public static string getFieldValue(String objectApiName, String fieldName) {
        system.debug('objectApiName>>> '+objectApiName);
        system.debug('fieldName >>> '+fieldName);
        // Get the object describe information using the object API name
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName.toLowerCase());
        
        if (objectType != null) {
            // Get the field describe information using the field name
            Schema.SObjectField field = objectType.getDescribe().fields.getMap().get(fieldName);
            
            if (field != null) {
                // Get the describe result for the field
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                system.debug('fieldDescribe >>>'+fieldDescribe);
                // Serialize the field describe result to JSON and return it
                return JSON.serialize(fieldDescribe);
            } else {
                return 'Field not found';
            }
        } else {
            return 'Object not found';
        }
    }
    
    public class PostActionRecords {
        @AuraEnabled public String fieldName;
        @AuraEnabled public String fieldType;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String fieldDetail;
    }
    
    /* @AuraEnabled
public static void updateRecord(String ObjectAPIName, String rows) {
try {
// Deserialize the incoming rows
List<PostActionRecords> recordsList = (List<PostActionRecords>)JSON.deserialize(rows, List<PostActionRecords>.class);
List<JunoDoc__JunoSign_Post_Actions__c> recordsToInsert = new List<JunoDoc__JunoSign_Post_Actions__c>();
List<JunoDoc__JunoSign_Post_Actions__c> recordsToUpdate = new List<JunoDoc__JunoSign_Post_Actions__c>();
List<JunoDoc__JunoSign_Post_Actions__c> recordsToDelete = new List<JunoDoc__JunoSign_Post_Actions__c>();

// Collect the field names from the incoming data
Set<String> incomingFieldNames = new Set<String>();
for (PostActionRecords record : recordsList) {
incomingFieldNames.add(record.fieldName);
}

// Query for existing records matching the ObjectAPIName
Map<String, JunoDoc__JunoSign_Post_Actions__c> existingRecordsMap = new Map<String, JunoDoc__JunoSign_Post_Actions__c>();
for (JunoDoc__JunoSign_Post_Actions__c existingRecord : [
SELECT Id, JunoDoc__JunoSignObjectAPIName__c, JunoDoc__Field_Name__c, JunoDoc__Field_Value__c
FROM JunoDoc__JunoSign_Post_Actions__c
WHERE JunoDoc__JunoSignObjectAPIName__c = :ObjectAPIName
]) {
existingRecordsMap.put(existingRecord.JunoDoc__Field_Name__c, existingRecord);
}

// Process incoming records (for insert and update)
for (PostActionRecords obj : recordsList) {
String key = obj.fieldName;
if (existingRecordsMap.containsKey(key)) {
// Update the existing record
JunoDoc__JunoSign_Post_Actions__c existingRecord = existingRecordsMap.get(key);
existingRecord.JunoDoc__Field_Value__c = obj.fieldValue != null ? String.valueOf(obj.fieldValue) : null;
recordsToUpdate.add(existingRecord);
// Remove from map to track for deletion later
existingRecordsMap.remove(key);
} else {
// Insert new record
JunoDoc__JunoSign_Post_Actions__c newRecord = new JunoDoc__JunoSign_Post_Actions__c();
newRecord.JunoDoc__JunoSignObjectAPIName__c = ObjectAPIName;
newRecord.JunoDoc__Field_Name__c = obj.fieldName;
newRecord.JunoDoc__Field_DataType__c = obj.fieldType;
newRecord.JunoDoc__Field_Value__c = obj.fieldValue != null ? String.valueOf(obj.fieldValue) : null;
recordsToInsert.add(newRecord);
}
}

// Any records left in existingRecordsMap are excess and should be deleted
recordsToDelete.addAll(existingRecordsMap.values());

// Perform DML operations
if (!recordsToInsert.isEmpty()) {
insert recordsToInsert;

}
if (!recordsToUpdate.isEmpty()) {
update recordsToUpdate;
}
if (!recordsToDelete.isEmpty()) {
delete recordsToDelete;
}

} catch (Exception e) {
system.debug('Error during update/insert/delete: ' + e.getMessage());
throw new AuraHandledException('Error: ' + e.getMessage());
}
}*/
    @AuraEnabled
    public static void updateRecord(String ObjectAPIName, List<Map<String, Object>> rows) {
        system.debug('rows>>>>>>>>>>>'+rows);
        try {
            List<JunoDoc__JunoSign_Post_Actions__c> recordsToInsert = new List<JunoDoc__JunoSign_Post_Actions__c>();
            List<JunoDoc__JunoSign_Post_Actions__c> recordsToUpdate = new List<JunoDoc__JunoSign_Post_Actions__c>();
            List<JunoDoc__JunoSign_Post_Actions__c> recordsToDelete = new List<JunoDoc__JunoSign_Post_Actions__c>();
            
            // Collect the field names from the incoming data
            Set<String> incomingFieldNames = new Set<String>();
            for (Map<String, Object> record : rows) {
                incomingFieldNames.add((String) record.get('fieldName'));
            }
            
            // Query for existing records matching the ObjectAPIName
            Map<String, JunoDoc__JunoSign_Post_Actions__c> existingRecordsMap = new Map<String, JunoDoc__JunoSign_Post_Actions__c>();
            for (JunoDoc__JunoSign_Post_Actions__c existingRecord : [
                SELECT Id, JunoDoc__JunoSignObjectAPIName__c, JunoDoc__Field_Name__c, JunoDoc__Field_Value__c
                FROM JunoDoc__JunoSign_Post_Actions__c
                WHERE JunoDoc__JunoSignObjectAPIName__c = :ObjectAPIName
            ]) {
                existingRecordsMap.put(existingRecord.JunoDoc__Field_Name__c, existingRecord);
            }
            
            // Process incoming records (for insert and update)
            for (Map<String, Object> obj : rows) {
                String fieldName = (String) obj.get('fieldName');
                String fieldType = (String) obj.get('fieldType');
                Object fieldValue = obj.get('fieldValue');
                
                if (existingRecordsMap.containsKey(fieldName)) {
                    // Update the existing record
                    JunoDoc__JunoSign_Post_Actions__c existingRecord = existingRecordsMap.get(fieldName);
                    existingRecord.JunoDoc__Field_Value__c = fieldValue != null ? String.valueOf(fieldValue) : null;
                    recordsToUpdate.add(existingRecord);
                    existingRecordsMap.remove(fieldName);
                } else {
                    // Insert new record
                    JunoDoc__JunoSign_Post_Actions__c newRecord = new JunoDoc__JunoSign_Post_Actions__c();
                    newRecord.JunoDoc__JunoSignObjectAPIName__c = ObjectAPIName;
                    newRecord.JunoDoc__Field_Name__c = fieldName;
                    newRecord.JunoDoc__Field_DataType__c = fieldType;
                    newRecord.JunoDoc__Field_Value__c = fieldValue != null ? String.valueOf(fieldValue) : null;
                    recordsToInsert.add(newRecord);
                }
            }
            
            // Any records left in existingRecordsMap are excess and should be deleted
            recordsToDelete.addAll(existingRecordsMap.values());
            
            // Perform DML operations
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
            if (!recordsToDelete.isEmpty()) {
                delete recordsToDelete;
            }
            
        } catch (Exception e) {
            System.debug('Error during update/insert/delete: ' + e.getMessage());
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateRecords(String ObjectAPIName, List<Map<String, Object>> rows) {
        system.debug('rows>>>>>>>>>>>'+rows);
        try {
            List<JunoDoc__JunoSign_Immediate_Actions__c> recordsToInsert = new List<JunoDoc__JunoSign_Immediate_Actions__c>();
            List<JunoDoc__JunoSign_Immediate_Actions__c> recordsToUpdate = new List<JunoDoc__JunoSign_Immediate_Actions__c>();
            List<JunoDoc__JunoSign_Immediate_Actions__c> recordsToDelete = new List<JunoDoc__JunoSign_Immediate_Actions__c>();
            
            // Collect the field names from the incoming data
            Set<String> incomingFieldNames = new Set<String>();
            for (Map<String, Object> record : rows) {
                incomingFieldNames.add((String) record.get('fieldName'));
            }
            
            // Query for existing records matching the ObjectAPIName
            Map<String, JunoDoc__JunoSign_Immediate_Actions__c> existingRecordsMap = new Map<String, JunoDoc__JunoSign_Immediate_Actions__c>();
            for (JunoDoc__JunoSign_Immediate_Actions__c existingRecord : [
                SELECT Id, JunoDoc__JunoSignObjectAPIName__c, JunoDoc__Field_Name__c, JunoDoc__Field_Value__c
                FROM JunoDoc__JunoSign_Immediate_Actions__c
                WHERE JunoDoc__JunoSignObjectAPIName__c = :ObjectAPIName
            ]) {
                existingRecordsMap.put(existingRecord.JunoDoc__Field_Name__c, existingRecord);
            }
            
            // Process incoming records (for insert and update)
            for (Map<String, Object> obj : rows) {
                String fieldName = (String) obj.get('fieldName');
                String fieldType = (String) obj.get('fieldType');
                Object fieldValue = obj.get('fieldValue');
                
                if (existingRecordsMap.containsKey(fieldName)) {
                    // Update the existing record
                    JunoDoc__JunoSign_Immediate_Actions__c existingRecord = existingRecordsMap.get(fieldName);
                    existingRecord.JunoDoc__Field_Value__c = fieldValue != null ? String.valueOf(fieldValue) : null;
                    recordsToUpdate.add(existingRecord);
                    existingRecordsMap.remove(fieldName);
                } else {
                    // Insert new record
                    JunoDoc__JunoSign_Immediate_Actions__c newRecord = new JunoDoc__JunoSign_Immediate_Actions__c();
                    newRecord.JunoDoc__JunoSignObjectAPIName__c = ObjectAPIName;
                    newRecord.JunoDoc__Field_Name__c = fieldName;
                    newRecord.JunoDoc__Field_DataType__c = fieldType;
                    newRecord.JunoDoc__Field_Value__c = fieldValue != null ? String.valueOf(fieldValue) : null;
                    recordsToInsert.add(newRecord);
                }
            }
            
            // Any records left in existingRecordsMap are excess and should be deleted
            recordsToDelete.addAll(existingRecordsMap.values());
            
            // Perform DML operations
            if (!recordsToInsert.isEmpty()) {
                insert recordsToInsert;
            }
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
            if (!recordsToDelete.isEmpty()) {
                delete recordsToDelete;
            }
            
        } catch (Exception e) {
            System.debug('Error during update/insert/delete: ' + e.getMessage());
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static List<PostActionRecords> getExistingRecords(String ObjectAPIName) {
        List<PostActionRecords> result = new List<PostActionRecords>();
        
        // Query for existing records based on ObjectAPIName
        List<JunoDoc__JunoSign_Post_Actions__c> existingRecords = [
            SELECT JunoDoc__Field_Name__c, JunoDoc__Field_DataType__c, JunoDoc__Field_Value__c
            FROM JunoDoc__JunoSign_Post_Actions__c
            WHERE JunoDoc__JunoSignObjectAPIName__c = :ObjectAPIName
        ];
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(ObjectAPIName.toLowerCase());
        
        
        for (JunoDoc__JunoSign_Post_Actions__c record : existingRecords) {
            PostActionRecords postRecord = new PostActionRecords();
            postRecord.fieldName = record.JunoDoc__Field_Name__c;
            postRecord.fieldType = record.JunoDoc__Field_DataType__c;
            postRecord.fieldValue = record.JunoDoc__Field_Value__c;
            if (objectType != null) {
                // Get the field describe information using the field name
                Schema.SObjectField field = objectType.getDescribe().fields.getMap().get(record.JunoDoc__Field_Name__c);
                
                if (field != null) {
                    // Get the describe result for the field
                    Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                    system.debug('fieldDescribe >>>'+fieldDescribe);
                    postRecord.fieldDetail = JSON.serialize(fieldDescribe);
                    // Convert to the PostActionRecords format
                }
            } 
            
            result.add(postRecord);
            system.debug('postRecord>>> '+postRecord);
        }
        
        return result;
    }  
    
    @AuraEnabled
    public static List<PostActionRecords> getExistingRecordsUpdate(String ObjectAPIName) {
        List<PostActionRecords> result = new List<PostActionRecords>();
        
        // Query for existing records based on ObjectAPIName
        List<JunoDoc__JunoSign_Immediate_Actions__c> existingRecords = [
            SELECT JunoDoc__Field_Name__c, JunoDoc__Field_DataType__c, JunoDoc__Field_Value__c
            FROM JunoDoc__JunoSign_Immediate_Actions__c
            WHERE JunoDoc__JunoSignObjectAPIName__c = :ObjectAPIName
        ];
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(ObjectAPIName.toLowerCase());
        
        
        for (JunoDoc__JunoSign_Immediate_Actions__c record : existingRecords) {
            PostActionRecords postRecord = new PostActionRecords();
            postRecord.fieldName = record.JunoDoc__Field_Name__c;
            postRecord.fieldType = record.JunoDoc__Field_DataType__c;
            postRecord.fieldValue = record.JunoDoc__Field_Value__c;
            if (objectType != null) {
                // Get the field describe information using the field name
                Schema.SObjectField field = objectType.getDescribe().fields.getMap().get(record.JunoDoc__Field_Name__c);
                
                if (field != null) {
                    // Get the describe result for the field
                    Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                    system.debug('fieldDescribe >>>'+fieldDescribe);
                    postRecord.fieldDetail = JSON.serialize(fieldDescribe);
                    // Convert to the PostActionRecords format
                }
            } 
            
            result.add(postRecord);
            system.debug('postRecord>>> '+postRecord);
        }
        
        return result;
    }  
}
public with sharing class JunoSignRemindersController {

    
     @AuraEnabled(cacheable=true)
    public static List<JunoDoc__JunoSign_Reminder__c> getExistingReminders(Id recordId) {
        return [
            SELECT Id, Name, JunoDoc__Reminder_Day__c, JunoDoc__Reminder__c,
                   JunoDoc__Reminder_Type__c, JunoDoc__JunoSignObjectAPIName__c,
                   JunoDoc__Parent_RecordId__c
            FROM JunoDoc__JunoSign_Reminder__c
            WHERE JunoDoc__Parent_RecordId__c = :recordId
        ];
    }

    @AuraEnabled
    public static void saveReminders(String objectApiName, String remindersJson) {
        // Deserialize input JSON into list of maps
        List<Object> rawList = (List<Object>) JSON.deserializeUntyped(remindersJson);
        List<JunoDoc__JunoSign_Reminder__c> reminders = new List<JunoDoc__JunoSign_Reminder__c>();
        
        for (Object obj : rawList) {
            Map<String, Object> row = (Map<String, Object>) obj;
            JunoDoc__JunoSign_Reminder__c rem = new JunoDoc__JunoSign_Reminder__c();
            
            // For Reminder Day
            if (row.containsKey('JunoDoc__Reminder_Day__c') && row.get('JunoDoc__Reminder_Day__c') != null) {
                rem.JunoDoc__Reminder_Day__c = Integer.valueOf(String.valueOf(row.get('JunoDoc__Reminder_Day__c')));
            }
            
            // For Recurring Days
            if (row.containsKey('JunoDoc__Recurring_Days__c') && row.get('JunoDoc__Recurring_Days__c') != null) {
                rem.JunoDoc__Recurring_Days__c = String.valueOf(row.get('JunoDoc__Recurring_Days__c'));
            }
            
            // Reminder type: Before, Every, or Both
            if (row.containsKey('JunoDoc__Reminder__c') && row.get('JunoDoc__Reminder__c') != null) {
                rem.JunoDoc__Reminder__c = String.valueOf(row.get('JunoDoc__Reminder__c'));
            }
            
            // Object linkage
            rem.JunoDoc__JunoSignObjectAPIName__c = objectApiName;
            
            reminders.add(rem);
        }
        
        // Remove old reminders for this objectApiName
        List<JunoDoc__JunoSign_Reminder__c> existing = [
            SELECT Id
            FROM JunoDoc__JunoSign_Reminder__c
            WHERE JunoDoc__JunoSignObjectAPIName__c = :objectApiName
        ];
        if (!existing.isEmpty()) {
            delete existing;
        }
        
        // Insert the new ones
        if (!reminders.isEmpty()) {
            insert reminders;
        }
    }


}
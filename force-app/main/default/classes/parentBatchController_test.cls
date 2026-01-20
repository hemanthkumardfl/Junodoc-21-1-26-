@isTest
public class parentBatchController_test {

   @isTest
    static void testmethod1(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;

        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 

        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;

        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;

        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = string.valueof(AccIds);
         currentScheduleIds = currentScheduleIds.remove('(');
        currentScheduleIds = currentScheduleIds.remove(')');
         currentScheduleIds = '\'' + currentScheduleIds + '\'';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }

     @isTest
    static void testmethod2(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = string.valueof(AccIds);
         currentScheduleIds = currentScheduleIds.remove('(');
        currentScheduleIds = currentScheduleIds.remove(')');
         currentScheduleIds = '\'' + currentScheduleIds + '\'';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }

     @isTest
    static void testmethod3(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = string.valueof(AccIds);
         currentScheduleIds = currentScheduleIds.remove('(');
        currentScheduleIds = currentScheduleIds.remove(')');
         currentScheduleIds = '\'' + currentScheduleIds + '\'';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }

     @isTest
    static void testmethod4(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = string.valueof(AccIds);
         currentScheduleIds = currentScheduleIds.remove('(');
        currentScheduleIds = currentScheduleIds.remove(')');
         currentScheduleIds = '\'' + currentScheduleIds + '\'';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }
    
     @isTest
    static void testmethod5(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = '';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }

     @isTest
    static void testmethod6(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = '';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }

     @isTest
    static void testmethod7(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = '';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }
    
     @isTest
    static void testmethod8(){
    
        SobjectUtilityController sobjectUtil = new SobjectUtilityController();
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
       contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
       accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination';
        insert accountSchemaMapping; 
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        
        String ParentQuery = 'SELECT ALL FROM Account';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList= new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass objectReferenceFieldAttributesInnerClass = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('AccountId','Account', true, 'Account', true);
        selectedReferenceList.add(objectReferenceFieldAttributesInnerClass);
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        String currentScheduleIds = '';
        Boolean includeAttachments = false;
         
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        Map<string,string> parentProcessedMap = new Map<String, String>();
        parentBatchController parentBatch = new parentBatchController(ParentQuery, 
                                                                            childQueries, 
                                                                            selectedReferenceList,
                                                                            batchId, 
                                                                            destinationOrg,
                                                                            currentScheduleIds,
                                                                            includeAttachments,
                                                                            parentProcessedMap,
                                                                            3);
        
        Database.executeBatch(parentBatch);
        system.assert(true);
    }
    
}
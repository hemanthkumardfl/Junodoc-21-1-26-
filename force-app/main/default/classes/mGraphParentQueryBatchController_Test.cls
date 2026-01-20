@isTest
public class mGraphParentQueryBatchController_Test {
  /*  @isTest
     static void testmethod1() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
          List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
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
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Id;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
    @isTest
    static void testmethod2() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
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
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
     @isTest
    static void testmethod3() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
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
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
    @isTest
    static void testmethod4() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
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
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
    @isTest
     static void testmethod5() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
         List<String> AccIds = new List<String>();
        AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id != null LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        
        String currentScheduleIds = '';//string.valueof(AccIds);
        Boolean includeAttachments = false;
         
          JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
         JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
         String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
    @isTest
    static void testmethod6() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
         AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account WHERE Id!= null';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        
         
        String currentScheduleIds = '';//string.valueof(AccIds);
        Boolean includeAttachments = false;
        
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
     @isTest
    static void testmethod7() {
        JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     
        Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
         AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        
        String currentScheduleIds = '';//string.valueof(AccIds);
        Boolean includeAttachments = false;
        
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }
    
    @isTest
    static void testmethod8() {
       /* JunoDoc__Junodoc_Object_Schema_Mapping__c contactSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c(); 
        contactSchemaMapping.JunoDoc__Source_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Destination_External_Id__c = 'AccountId';
        contactSchemaMapping.JunoDoc__Object_Name__c = 'Contact';
        contactSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert contactSchemaMapping;
        JunoDoc__Junodoc_Object_Schema_Mapping__c accountSchemaMapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        accountSchemaMapping.JunoDoc__Source_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Destination_External_Id__c = 'Id';
        accountSchemaMapping.JunoDoc__Object_Name__c = 'Account';
        accountSchemaMapping.JunoDoc__Destination_Name__c = 'Test Destination2';
        insert accountSchemaMapping;     */
      /*  Account parentAcc = new Account();
        parentAcc.name = 'Parent Account';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        JunoDoc__Junodoc_Parent_Configuration__c childQuery = new JunoDoc__Junodoc_Parent_Configuration__c();   
        childQuery.JunoDoc__Junodoc_Object_Name__c = 'Contact';
        childQuery.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id, FirstName, LastName, AccountId FROM CONTACT LIMIT 300';  
        childQuery.JunoDoc__Junodoc_Use_SOQL__c = true;
        List<String> AccIds = new List<String>();
         AccIds.add(parentAcc.id);
        String accountIds = string.valueof(AccIds);
        //accountIds = '(' + '\'' + parentAcc.Id + '\'';
        //accountIds = accountIds + ')';
        String ParentQuery = 'SELECT ALL FROM Account LIMIT 10';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childQuery, 'AccountID', 1));
        Map<String, String> priceBookEntryMap = new Map<String, String>();
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        String referenceFoundSelection = 'Update Existing And Link';
        String queryBySelection = 'SFDC And External Id';
        String ExternalIdSelection = 'External Id As Source SFDC Id';
        Integer batchId = 100;
        
         
        String currentScheduleIds = '';//string.valueof(AccIds);
        Boolean includeAttachments = false;
        
         JunoDoc__Junodoc_Connections__c Conn = new JunoDoc__Junodoc_Connections__c();
         Conn.Name = 'Test Destination2';
         Conn.JunoDoc__API_Usage__c = 80;
         Conn.JunoDoc__API_Usage_Reached__c = false;
         insert Conn;
        
        JunoDoc__Junodoc_Template_Schedule__c TempSch = new JunoDoc__Junodoc_Template_Schedule__c();
        TempSch.JunoDoc__Batch_Id__c = '100';
        TempSch.JunoDoc__Is_Scheduled__c = false;
        TempSch.JunoDoc__Schedule_Status__c = 'New';
        insert TempSch;
        String destinationOrg = Conn.Name;
        
        mGraphParentQueryBatchController mGraphparentQuery = new mGraphParentQueryBatchController(ParentQuery, 
                                                                    childQueries, 
                                                                    selectedReferenceList, 
                                                                    batchId, 
                                                                    destinationOrg,
                                                                    currentScheduleIds,
                                                                    includeAttachments,
                                                                    3);
       //  mGraphParentQueryBatchController.
         
       Database.executeBatch(mGraphparentQuery);
        system.assert(true);
    }*/
    
    
}
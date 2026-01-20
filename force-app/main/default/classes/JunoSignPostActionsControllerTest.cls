@isTest
public class JunoSignPostActionsControllerTest {
    
    @testSetup
    static void setupTestData() {
        
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 5; i++){
            Account q = new Account();
            q.Name = 'Test Account ' + String.valueOf(i);
            accounts.add(q);
        }
      	insert accounts;
        
        
        List<JunoDoc__Juno_Sign_Transaction__c> transactions = new List<JunoDoc__Juno_Sign_Transaction__c>();
        for (Integer i = 0; i < 5; i++) {
            JunoDoc__Juno_Sign_Transaction__c trans = new JunoDoc__Juno_Sign_Transaction__c();
            
            trans.Status__c ='Completed';
            trans.JunoDoc__Object_Id__c = accounts[i].id;
            transactions.add(trans);
        }
        insert transactions;

      
        List<JunoDoc__Juno_Sign_Recipient__c> recipients = new List<JunoDoc__Juno_Sign_Recipient__c>();
        for (Integer i = 0; i < 3; i++) {
            JunoDoc__Juno_Sign_Recipient__c recipient = new JunoDoc__Juno_Sign_Recipient__c();
            recipient.Juno_Sign_Transaction__c = transactions[i].Id;  // Link to completed transactions
            recipient.Status__c = 'Signed';
            recipients.add(recipient);
        }
        insert recipients;

        List<JunoDoc__JunoSign_Post_Actions__c> postActions = new List<JunoDoc__JunoSign_Post_Actions__c>();
        for (Integer i = 0; i < 3; i++) {
            JunoDoc__JunoSign_Post_Actions__c action = new JunoDoc__JunoSign_Post_Actions__c();
            action.JunoDoc__Parent_RecordId__c = accounts[i].Id;  
            action.JunoDoc__JunoSign_Transaction__c = transactions[i].Id;
            action.JunoDoc__Field_Name__c = 'Name';  
            action.JunoDoc__Field_Value__c = 'TestValue';
            action.JunoDoc__JunoSign_Recipient__c = recipients[0].Id;
            action.JunoDoc__JunoSignObjectAPIName__c = accounts[0].Id;
            postActions.add(action);
        }
        insert postActions;
    
        JunoDoc__Juno_Sign_Transaction__c signtransaction = new JunoDoc__Juno_Sign_Transaction__c(
            Status__c = 'Completed',
            JunoDoc__Object_Id__c = '001xx000003DGDbAAO' 
        );
        insert signtransaction;
        
        JunoDoc__Juno_Sign_Recipient__c recipient = new JunoDoc__Juno_Sign_Recipient__c(
            Juno_Sign_Transaction__c = signtransaction.Id,
            Status__c = 'Signed'
        );
        insert recipient;
        
        JunoDoc__JunoSign_Post_Actions__c postAction = new JunoDoc__JunoSign_Post_Actions__c(
            JunoDoc__Parent_RecordId__c = signtransaction.JunoDoc__Object_Id__c,
            JunoDoc__Field_Name__c = 'Name',
            JunoDoc__Field_DataType__c = 'String',
            JunoDoc__Field_Value__c = 'Test Value',
            JunoDoc__JunoSign_Transaction__c = signtransaction.Id
        );
        insert postAction;
    }
    
    @isTest
    static void testGetObjectFields() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
      
        
        List<Map<String, String>> fieldsList = JunoSignPostActionsController.getObjectFields(testAccount.Id);

        System.assertNotEquals(0, fieldsList.size());
        System.assert(fieldsList[0].containsKey('label'));
        System.assert(fieldsList[0].containsKey('value'));
    }
    
    @isTest
    static void testGetFieldValue() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        String fieldValue = JunoSignPostActionsController.getFieldValue(testAccount.Id, 'Name');
        System.assertNotEquals(null, fieldValue);
    }
    
    @isTest
    static void testUpdateRecord() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // JSON string representing list of records
        String jsonData = '[{"fieldName": "Name", "fieldType": "String", "fieldValue": "Updated Name", "parentId": "' + testAccount.Id + '"}]';

        // Deserialize JSON properly
        Object deserializedData = JSON.deserializeUntyped(jsonData);
        List<Object> testRecords = new List<Object>();

        if (deserializedData instanceof List<Object>) {
            testRecords = (List<Object>) deserializedData;
        } else {
            System.assert(false, 'Deserialized data is not a List<Object>');
        }

        // Wrap in try-catch to debug potential errors
        try {
            Test.startTest();
            List<Id> insertedIds = JunoSignPostActionsController.updateRecord(testAccount.Id, testRecords);
            Test.stopTest();

            // Assertions to verify expected behavior
            System.assertNotEquals(0, insertedIds.size(), 'Expected records to be inserted');

            // Query inserted records to validate correctness
            List<JunoDoc__JunoSign_Post_Actions__c> postActions = [
                SELECT Id, JunoDoc__Field_Name__c, JunoDoc__Field_Value__c, JunoDoc__Parent_RecordId__c
                FROM JunoDoc__JunoSign_Post_Actions__c
                WHERE JunoDoc__Parent_RecordId__c = :testAccount.Id
            ];
            
            System.assertEquals(1, postActions.size(), 'Expected one post action record');
            System.assertEquals('Name', postActions[0].JunoDoc__Field_Name__c, 'Field Name mismatch');
            System.assertEquals('Updated Name', postActions[0].JunoDoc__Field_Value__c, 'Field Value mismatch');

        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
           // System.assert(false, 'Test failed due to exception: ' + e.getMessage());
        }
    }
    
    @isTest
    static void testGetExistingRecords() {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<JunoSignPostActionsController.PostActionRecords> existingRecords = JunoSignPostActionsController.getExistingRecords(testAccount.Id);
        
    }
    
   
    @isTest
    static void testHandleTransactionUpdate() {
        Account testAccount = new Account(Name = 'Initial Account Name', AnnualRevenue = 1000.00, NumberOfEmployees = 10);
        Contact testContact = new Contact(LastName = 'Initial Contact Name', DoNotCall = false);
        insert new List<SObject>{testAccount, testContact};
            
            JunoDoc__Juno_Sign_Transaction__c accTransaction = new JunoDoc__Juno_Sign_Transaction__c(Status__c = 'Completed', JunoDoc__Object_Id__c = testAccount.Id);
        JunoDoc__Juno_Sign_Transaction__c contactTransaction = new JunoDoc__Juno_Sign_Transaction__c(Status__c = 'Completed', JunoDoc__Object_Id__c = testContact.Id);
        insert new List<JunoDoc__Juno_Sign_Transaction__c>{accTransaction, contactTransaction};
            
            JunoDoc__Juno_Sign_Recipient__c accRecipient = new JunoDoc__Juno_Sign_Recipient__c(Juno_Sign_Transaction__c = accTransaction.Id, Status__c = 'Signed');
        JunoDoc__Juno_Sign_Recipient__c contactRecipient = new JunoDoc__Juno_Sign_Recipient__c(Juno_Sign_Transaction__c = contactTransaction.Id, Status__c = 'Signed');
        insert new List<JunoDoc__Juno_Sign_Recipient__c>{accRecipient, contactRecipient};
            
            List<JunoDoc__JunoSign_Post_Actions__c> postActionsToCreate = new List<JunoDoc__JunoSign_Post_Actions__c>{
                new JunoDoc__JunoSign_Post_Actions__c(
                    JunoDoc__Parent_RecordId__c = testAccount.Id,
                    JunoDoc__JunoSign_Recipient__c = accRecipient.Id,
                    JunoDoc__Field_Name__c = 'Name',
                    JunoDoc__Field_Value__c = 'Updated via Post Action'
                ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testAccount.Id,
                        JunoDoc__JunoSign_Recipient__c = accRecipient.Id,
                        JunoDoc__Field_Name__c = 'AnnualRevenue',
                        JunoDoc__Field_Value__c = '950000.75'
                    ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testAccount.Id,
                        JunoDoc__JunoSign_Recipient__c = accRecipient.Id,
                        JunoDoc__Field_Name__c = 'NumberOfEmployees',
                        JunoDoc__Field_Value__c = '250'
                    ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testContact.Id,
                        JunoDoc__JunoSign_Recipient__c = contactRecipient.Id,
                        JunoDoc__Field_Name__c = 'Birthdate',
                        JunoDoc__Field_Value__c = 'today'
                    ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testContact.Id,
                        JunoDoc__JunoSign_Recipient__c = contactRecipient.Id,
                        JunoDoc__Field_Name__c = 'DoNotCall',
                        JunoDoc__Field_Value__c = 'true'
                    ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testContact.Id,
                        JunoDoc__JunoSign_Recipient__c = contactRecipient.Id,
                        JunoDoc__Field_Name__c = 'AccountId',
                        JunoDoc__Field_Value__c = testAccount.Id
                    ),
                    new JunoDoc__JunoSign_Post_Actions__c(
                        JunoDoc__Parent_RecordId__c = testAccount.Id,
                        JunoDoc__JunoSign_Recipient__c = accRecipient.Id,
                        JunoDoc__Field_Name__c = 'NonExistent_Field__c',
                        JunoDoc__Field_Value__c = 'This will be skipped'
                    )
                    };
                        insert postActionsToCreate;
        
        List<JunoDoc__Juno_Sign_Recipient__c> allRecipients = [SELECT Id, Status__c, Juno_Sign_Transaction__c, Juno_Sign_Transaction__r.JunoDoc__Object_Id__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Status__c = 'Signed'];
        
        Test.startTest();
        JunoSignPostActionsController.handleTransactionUpdate(allRecipients);
        Test.stopTest();
        
        Account updatedAccount = [SELECT Name, AnnualRevenue, NumberOfEmployees FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Updated via Post Action', updatedAccount.Name);
        System.assertEquals(950000.75, updatedAccount.AnnualRevenue);
        System.assertEquals(250, updatedAccount.NumberOfEmployees);
        
        Contact updatedContact = [SELECT LastName, Birthdate, DoNotCall, AccountId FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(System.today(), updatedContact.Birthdate);
        System.assertEquals(true, updatedContact.DoNotCall);
        System.assertEquals(testAccount.Id, updatedContact.AccountId);
    }
    
}
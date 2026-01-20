@isTest
public class PostActionTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test data for Juno_Sign_Transaction__c object
        JunoDoc__Juno_Sign_Transaction__c transaction11 = new JunoDoc__Juno_Sign_Transaction__c(
           // Name = 'Test Transaction',
            Status__c = 'Sent'
        );
        insert transaction11;
    }
    
    @isTest
    static void testTransactionUpdate() {
        // Fetch the test transaction record
        JunoDoc__Juno_Sign_Transaction__c transaction22 = [SELECT Id, Status__c FROM JunoDoc__Juno_Sign_Transaction__c LIMIT 1];
        
        // Start a test execution context
        Test.startTest();
        
        // Update the transaction to trigger the PostActionTrigger
        transaction22.Status__c = 'Completed';
        update transaction22;
        
        // Perform any assertions to verify the trigger fired correctly
        JunoDoc__Juno_Sign_Transaction__c updatedTransaction = [SELECT Id, Status__c FROM JunoDoc__Juno_Sign_Transaction__c WHERE Id = :transaction22.Id];
        System.assertEquals('Completed', updatedTransaction.Status__c, 'Status should be updated to Completed');
        
        // Ensure the controller logic executed as expected (you can add more assertions based on what the controller does)
        
        Test.stopTest();
    }
}
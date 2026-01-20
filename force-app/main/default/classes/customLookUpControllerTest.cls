@isTest
private class customLookUpControllerTest {
    
    @isTest
    static void testFetchLookUpValues() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account One');
        Account testAccount2 = new Account(Name = 'Test Account Two');
        Account testAccount3 = new Account(Name = 'Another Account');
        
        // Insert test data
        insert new List<Account>{ testAccount1, testAccount2, testAccount3 };
        
        // Test the fetchLookUpValues method
        Test.startTest();
        List<sObject> results = customLookUpController.fetchLookUpValues('Test', 'Account');
        Test.stopTest();
        
        // Verify the results
        System.assertEquals(2, results.size(), 'Expected 2 records to be returned');
       // System.assertEquals(testAccount1.Id, (results[0] as Account).Id, 'The first record should be Test Account One');
       // System.assertEquals(testAccount2.Id, (results[1] as Account).Id, 'The second record should be Test Account Two');
    }
    
    @isTest
    static void testFetchLookUpValues_NoResults() {
        // Test the fetchLookUpValues method with no matching records
        Test.startTest();
        List<sObject> results = customLookUpController.fetchLookUpValues('Nonexistent', 'Account');
        Test.stopTest();
        
        // Verify that no records are returned
        System.assertEquals(0, results.size(), 'Expected 0 records to be returned');
    }
}
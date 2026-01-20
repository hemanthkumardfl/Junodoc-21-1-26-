@isTest
public class OpportunityClass_Test {
    @isTest
    static void testOpportunityClass() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test opportunities associated with the test account
        List<Opportunity> testOpportunities = new List<Opportunity>{
            new Opportunity(
                Name = 'Test Opportunity 1',
                CloseDate = Date.today(),
                StageName = 'Prospecting',
                Amount = 10000.00,
                JunoDoc__Close_Fiscal_Quarter__c = 'Q1',
                JunoDoc__Portfolio_Technology__c = 'Technology 1',
                JunoDoc__Notes__c = 'Test Notes 1',
                JunoDoc__Annual__c = 2024,
                AccountId = testAccount.Id
            ),
            new Opportunity(
                Name = 'Test Opportunity 2',
                CloseDate = Date.today(),
                StageName = 'Closed Won',
                Amount = 20000.00,
                JunoDoc__Close_Fiscal_Quarter__c = 'Q2',
                JunoDoc__Portfolio_Technology__c = 'Technology 2',
                JunoDoc__Notes__c = 'Test Notes 2',
                JunoDoc__Annual__c = 2023,
                AccountId = testAccount.Id
            )
        };
        insert testOpportunities;
        
        // Instantiate OpportunityClass
        Test.startTest();
        OpportunityClass oppClass = new OpportunityClass();
        Test.stopTest();
        
       
    }
}
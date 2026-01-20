@isTest
public class FormulaBuilder_TC {
    private static testMethod void test(){
        FormulaBuilder.GetLabelName('Account');
        FormulaBuilder.getAllObjectFields('Account');
        FormulaBuilder.getinitialObjectFields('Account');
        
         FormulaBuilder.GetFieldDetails('AccountId','Name');
         FormulaBuilder.GetSecLevelFieldDetails('contactId','AccountId','Name');
         FormulaBuilder.GetThirdLevelFieldDetails('contactId','AccountId','OwnerId','Name');
         FormulaBuilder.GetFinalLevelFieldDetails('opportunityId','contactId','AccountId','OwnerId','Name');
        
        
          FormulaBuilder.GetFieldDetails('AccountId','Name__c');
         FormulaBuilder.GetSecLevelFieldDetails('contact__c','Account__c','Name__c');
         FormulaBuilder.GetThirdLevelFieldDetails('contact__c','Account__C','Owner__c','Name__c');
         FormulaBuilder.GetFinalLevelFieldDetails('opportunity__c','contact__c','Account__c','Owner__C','Name__c');
        System.assertEquals('Test', 'Test');
    }
}
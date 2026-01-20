@isTest 
public class EmailTemplate_TC {
    
    @isTest
    public static void method1(){
         Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        JunoDoc__Email_Template__c Emtemp = new JunoDoc__Email_Template__c();
        Emtemp.Name = 'testEm';
        EmTemp.JunoDoc__Parent_Object__c = 'Account';
        EmTemp.JunoDoc__Parent_Fields__c = 'Name,Industry,Owner.Name';
        insert EmTemp;
        
        JunoDoc__Email_Template_Item__c EmItem = new JunoDoc__Email_Template_Item__c();
        EmItem.JunoDoc__Email_Template__c = EmTemp.Id;
        EmItem.JunoDoc__Subject__c = 'Test----{!Today()}{!Name}';
        EmItem.JunoDoc__Template_Body__c = '{!Today()}{!Name}{!NOW()}{!CreatedDate}{!Type}{!Industry}';
        insert EmItem;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('recordId', acc.Id);
         ApexPages.currentPage().getParameters().put('SObjectName', 'Account');
        ApexPages.currentPage().getParameters().put('EmailTemplateId', EmTemp.id);
        EmailTemplate_AC Em = new EmailTemplate_AC();
        Em.getEmailBody();
        Test.stopTest();
    }
}
@isTest
public class EmailTemplateFullpage_TC {
    @isTest static void method1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        JunoDoc__Email_Template__c Emtemp = new JunoDoc__Email_Template__c();
        Emtemp.Name = 'testEm';
       EmTemp.JunoDoc__Parent_Object__c = 'Account';
       EmTemp.JunoDoc__Parent_Fields__c = 'Name.Industry,Owner.Name';
       insert EmTemp;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('recordId', acc.Id);
        ApexPages.currentPage().getParameters().put('SObjectName', 'Account');
        ApexPages.currentPage().getParameters().put('EmailTemplateId', EmTemp.id);
        EmailTemplateFullpage_AC Em = new EmailTemplateFullpage_AC();
       Test.stopTest();
    }
}
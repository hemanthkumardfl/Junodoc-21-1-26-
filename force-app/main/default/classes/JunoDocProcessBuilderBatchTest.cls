@isTest
public class JunoDocProcessBuilderBatchTest {
    @testSetup
    static void setup() {
       EmailTemplate email = new EmailTemplate ();
        email.developerName = 'test';  
        email.FolderId = UserInfo.getUserId();
        email.TemplateType= 'Text'; 
        email.Name = 'test';
        email.Body = 'JunoDoc Dummy Contact';
        email.Subject ='Hi';
        insert email;
       
    }
    
    testmethod static void testBatch(){
                
        Account acc = new Account(Name='Test1',Type ='Prospect');
        insert acc;
        Contact con1 = new Contact(LastName='John', AccountId=acc.Id, Email = 'john@sfdc.com');
        insert con1;
        Contact con2 = new Contact(LastName='Jess', AccountId=acc.Id, Email = 'jess@sfdc.com');
        insert con2;
        List<SObject> triggerNewOrders = new List<SObject>();
        triggerNewOrders.add(con1);
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c(Name='Test',Object_Name__c='Contact',IsActive__c=true);
        insert JunoDocTriggerRec;
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test' limit 1];
        system.debug('Email***'+email);
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Doc';
        insert docTemplate;
        Doc_Template__c junoDoc = new Doc_Template__c();
        junoDoc.Name = 'Test Juno Doc';
        insert junoDoc;    
        
        Doc_Template_Item__c DocItem = new Doc_Template_Item__c();
        DocItem.Template_Body__c = 'Test Juno Doc';
        DocItem.Doc_Template__c =  junoDoc.Id;
        insert DocItem;
        
        Email_Template__c junoEmail = new Email_Template__c();
        junoEmail.Name = 'Test Juno Doc';
        //junoEmail.Body__c = 'Test Juno Doc';
       // junoEmail.Subject__c = 'Test Juno Doc';
        insert junoEmail; 
        
        Email_Template_Item__c EmailItem = new Email_Template_Item__c();
        EmailItem.Template_Body__c = 'Test Juno Doc';
        EmailItem.Subject__c = 'Test Juno Doc';
        EmailItem.Email_Template__c =  EmailItem.Id;
        insert EmailItem;
        System.assertEquals('John', con1.LastName);
        test.startTest();
        JunoDocProcessBuilderBatch callBatch = new JunoDocProcessBuilderBatch(triggerNewOrders, 'Contact',docTemplate.Id,junoEmail.Id,'test@gmail.com','contact.owner.Email;Contact.Email',true,'','test@gmail.com','contact.owner.Email','test@gmail.com','contact.owner.Email');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
        
    }
}
@isTest
public class JunoDocTriggerActionsBatchTest {
    
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
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test'limit 1];
        system.debug('Email***'+email);
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Doc';
        insert docTemplate;
        Doc_Template__c junoDoc = new Doc_Template__c();
        junoDoc.Name = 'Test Juno Doc';
        insert junoDoc;    
        
        Juno_Doc_Trigger_Action__c JunoDocTriggerActionRec = new Juno_Doc_Trigger_Action__c();
        JunoDocTriggerActionRec.Juno_Doc_Trigger__c = JunoDocTriggerRec.Id ;
        JunoDocTriggerActionRec.Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        JunoDocTriggerActionRec.Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        JunoDocTriggerActionRec.Email_Addresses__c = 'juno@yahoo.com';
        JunoDocTriggerActionRec.From_Email_Address__c = '';
        JunoDocTriggerActionRec.Set_Reply_To__c = 'test@gmail.com';
        JunoDocTriggerActionRec.Set_Sender_Display_Name__c = 'Test';
        JunoDocTriggerActionRec.Email_Fields__c = 'Email~Email';
        JunoDocTriggerActionRec.Save_as_Activitiy__c = TRUE;
        JunoDocTriggerActionRec.Available_Doc_Template__c = docTemplate.Id;
        JunoDocTriggerActionRec.Standard_Email_Template__c = email.Id;
        JunoDocTriggerActionRec.Email_Subject__c = 'Test Template';
        JunoDocTriggerActionRec.Juno_Doc_Email_Template__c = junoDoc.Id;
        insert JunoDocTriggerActionRec;
        
        JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip.JunoDoc__Juno_Doc_Trigger_Action__c = JunoDocTriggerActionRec.Id;
        EmRecip.JunoDoc__Row_Number__c = 1;
        EmRecip.JunoDoc__To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip2 = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip2.JunoDoc__Juno_Doc_Trigger_Action__c = JunoDocTriggerActionRec.Id;
        EmRecip2.JunoDoc__Row_Number__c = 2;
        EmRecip2.JunoDoc__To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Email_Label_Values__c = '';
        insert EmRecip2;
        
         JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip5 = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip5.JunoDoc__Juno_Doc_Trigger_Action__c = JunoDocTriggerActionRec.Id;
        EmRecip5.JunoDoc__Row_Number__c = 5;
        EmRecip5.JunoDoc__To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip3 = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip3.JunoDoc__Juno_Doc_Trigger_Action__c = JunoDocTriggerActionRec.Id;
        EmRecip3.JunoDoc__Row_Number__c = 3;
        EmRecip3.JunoDoc__To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
          
          JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip4 = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip4.JunoDoc__Juno_Doc_Trigger_Action__c = JunoDocTriggerActionRec.Id;
        EmRecip4.JunoDoc__Row_Number__c = 4;
        EmRecip4.JunoDoc__To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Email_API_Name_Values__c = 'owner.email';
        EmRecip4.JunoDoc__Email_Label_Values__c = '';
        insert EmRecip4;
        
        
        Juno_Doc_Post_Trigger_Action__c defaultValueRec =new Juno_Doc_Post_Trigger_Action__c();
        //defaultValueRec.Name = 'test';
        defaultValueRec.Field__c = 'MailingPostalCode';
        defaultValueRec.Value__c = 'Test';
        defaultValueRec.Juno_Doc_Trigger__c = JunoDocTriggerRec.Id ;
        insert defaultValueRec;        
        System.assertEquals('John', con1.LastName);
        test.startTest();
        JunoDocTriggerActionsBatch callBatch = new JunoDocTriggerActionsBatch(triggerNewOrders, 'Contact','Test');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
        
    }
    
    
    

}
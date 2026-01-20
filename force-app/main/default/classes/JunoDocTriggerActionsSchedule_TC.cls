@isTest
public class JunoDocTriggerActionsSchedule_TC {
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
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c(Name='Test',Trigger_Conditions_Formula__c = '1 AND 2',Object_Name__c='Contact',IsActive__c=true);
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
        
        JunoDoc__Juno_Doc_Trigger_Condition__c triigercondition = new JunoDoc__Juno_Doc_Trigger_Condition__c();
        triigercondition.JunoDoc__Field__c = 'Name';
        triigercondition.JunoDoc__Operator__c = 'Equals';
        triigercondition.JunoDoc__Value__c = 'Test';
        triigercondition.JunoDoc__RowNumber__c = 1;
        triigercondition.JunoDoc__Juno_Doc_Trigger__c = JunoDocTriggerRec.Id;
        insert triigercondition;
        
         JunoDoc__Juno_Doc_Trigger_Condition__c triigercondition1 = new JunoDoc__Juno_Doc_Trigger_Condition__c();
        triigercondition1.JunoDoc__Field__c = 'Createddate';
        triigercondition1.JunoDoc__Operator__c = 'Greater Than';
        triigercondition1.JunoDoc__Value__c = 'Today';
        triigercondition1.JunoDoc__RowNumber__c = 2;
        triigercondition1.JunoDoc__Juno_Doc_Trigger__c = JunoDocTriggerRec.Id;
        insert triigercondition1;
        
        Juno_Doc_Post_Trigger_Action__c defaultValueRec =new Juno_Doc_Post_Trigger_Action__c();
        //defaultValueRec.Name = 'test';
        defaultValueRec.Field__c = 'MailingPostalCode';
        defaultValueRec.Value__c = 'Test';
        defaultValueRec.Juno_Doc_Trigger__c = JunoDocTriggerRec.Id ;
        insert defaultValueRec;        
        System.assertEquals('John', con1.LastName);
        test.startTest();
            list<JunoDocTriggerActionsScheduleController.SendEmailClass> SendEmailClasslist = new list<JunoDocTriggerActionsScheduleController.SendEmailClass>();
            JunoDocTriggerActionsScheduleController.SendEmailClass sends = new JunoDocTriggerActionsScheduleController.SendEmailClass();
            sends.recordIds = con1.Id;
            sends.EmailTemplateId = email.Id;
            sends.DocTemplateId = docTemplate.Id;
            sends.TextEmails = 'test@gmail.com';
            sends.EmailFields = '';
            sends.FromEmailAddress = '';
            sends.SaveAsActivity = true;
            SendEmailClasslist.add(sends);
            JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsProcessBuilderHelper(SendEmailClasslist);
            JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsScheduleHelper();
            JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Contact','Test');
            JunoDocTriggerActionsScheduleController.upsertTriggerLogs('Contact',con1.Id);
        test.stopTest();
        
    }
}
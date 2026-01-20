/*@isTest
public class JunoDocScheduleActionsBatchTest {
    @testSetup
    static void setup() {
       EmailTemplate email = new EmailTemplate ();
        email.developerName = 'test22';
        email.FolderId = UserInfo.getUserId();
        email.TemplateType= 'Text'; 
        email.Name = 'test22';
        email.Body = 'JunoDoc Dummy Quote2222';
        email.Subject ='Hi';
        insert email;
    }
    
    testmethod static void method1(){
        
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con1@gmail.com';
        insert Con1;
        
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Test_Opp';
        Opp.AccountId = Acc.Id;
        Opp.CloseDate = system.today()+20;
        Opp.ContactId = Con1.Id;
        Opp.Type = 'New Customer';
        Opp.StageName = 'Prospecting';
        insert Opp;
        
       
        
        List<SObject> scheduleNewOrders = new List<SObject>();
        scheduleNewOrders.add(Opp);
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        
        Doc_Template__c DocTemp = new Doc_Template__c();
        DocTemp.Name = 'TestAcc';
        DocTemp.JunoDoc__Parent_Object__c = 'Opportunity';
        DocTemp.JunoDoc__Parent_Fields__c = 'Phone';
        //DocTemp.JunoDoc__Parent_Fields__c = 'JunoDoc__SLAExpirationDate__c';
        insert DocTemp;
        
        Email_Template__c EmTemp = new Email_Template__c();
        EmTemp.Name = 'TestEmQuo';
        EmTemp.JunoDoc__Parent_Object__c = 'Account';
        insert EmTemp;
        
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Acc_Sch2';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Account';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = false;
        SchAct.JunoDoc__Junodoc_Is_Send__c = true;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = DocTemp.Id;
        SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'Account.Name';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'Account.Owner.Name';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;*/
        
      /*  Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'quote.contact.owner.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;*/
        
       /* List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'Phone';
        PostAct2.JunoDoc__Junodoc_Value__c = '7777777777';
        PostActs.add(PostAct2);
        
       
        insert PostActs;

        test.startTest();
        JunoDocScheduleActionsBatch callBatch = new JunoDocScheduleActionsBatch(scheduleNewOrders, 'Account','Acc_Sch2');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
    }*/
    
  /*  testmethod static void method2(){
        
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con1@gmail.com';
        insert Con1;
        
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Test_Opp';
        Opp.AccountId = Acc.Id;
        Opp.CloseDate = system.today()+20;
        Opp.ContactId = Con1.Id;
        Opp.Type = 'New Customer';
        Opp.StageName = 'Prospecting';
        insert Opp;
        
        Quote Quo = new Quote();
        Quo.Name = 'Test_Quote22222';
        Quo.OpportunityId = Opp.Id;
        Quo.ContactId = Con1.Id;
        insert Quo;
        
        List<SObject> scheduleNewOrders = new List<SObject>();
        scheduleNewOrders.add(Quo);
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        
        Doc_Template__c DocTemp = new Doc_Template__c();
        DocTemp.Name = 'TestQuo';
        DocTemp.JunoDoc__Parent_Object__c = 'Quote';
        DocTemp.JunoDoc__Parent_Fields__c = 'Status,ExpirationDate';
        insert DocTemp;
        
        Email_Template__c EmTemp = new Email_Template__c();
        EmTemp.Name = 'TestEmQuo';
        EmTemp.JunoDoc__Parent_Object__c = 'Quote';
        insert EmTemp;
        
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Quo_Sch2';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = true;
        SchAct.JunoDoc__Junodoc_Is_Send__c = false;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = DocTemp.Id;
        SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'opportunity.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct.Junodoc__Junodoc_Field__c = 'Status';
        PostAct.JunoDoc__Junodoc_Value__c = 'Draft';
        PostActs.add(PostAct);
        
        
        
        insert PostActs;

        test.startTest();
        JunoDocScheduleActionsBatch callBatch = new JunoDocScheduleActionsBatch(scheduleNewOrders, 'Quote','Quo_Sch2');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
    }
    
    testmethod static void method3(){
        
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con1@gmail.com';
        insert Con1;
        
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Test_Opp';
        Opp.AccountId = Acc.Id;
        Opp.CloseDate = system.today()+20;
        Opp.ContactId = Con1.Id;
        Opp.Type = 'New Customer';
        Opp.StageName = 'Prospecting';
        insert Opp;
        
        Quote Quo = new Quote();
        Quo.Name = 'Test_Quote22222';
        Quo.OpportunityId = Opp.Id;
        Quo.ContactId = Con1.Id;
        insert Quo;
        
        List<SObject> scheduleNewOrders = new List<SObject>();
        scheduleNewOrders.add(Quo);
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        
        Doc_Template__c DocTemp = new Doc_Template__c();
        DocTemp.Name = 'TestQuo';
        DocTemp.JunoDoc__Parent_Object__c = 'Quote';
        DocTemp.JunoDoc__Parent_Fields__c = 'Status,ExpirationDate';
        insert DocTemp;
        
        Email_Template__c EmTemp = new Email_Template__c();
        EmTemp.Name = 'TestEmQuo';
        EmTemp.JunoDoc__Parent_Object__c = 'Quote';
        insert EmTemp;
        
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Quo_Sch2';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = true;
        SchAct.JunoDoc__Junodoc_Is_Send__c = true;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = DocTemp.Id;
        SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct3 = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct3.Junodoc__Junodoc_Field__c = 'JunoDoc__Duration__c';
        PostAct3.JunoDoc__Junodoc_Value__c = '20';
        PostActs.add(PostAct3);
        
        
        
        insert PostActs;

        test.startTest();
        JunoDocScheduleActionsBatch callBatch = new JunoDocScheduleActionsBatch(scheduleNewOrders, 'Quote','Quo_Sch2');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
    }
    
    testmethod static void method4(){
        
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con1@gmail.com';
        insert Con1;
        
        Opportunity Opp = new Opportunity();
        Opp.Name = 'Test_Opp';
        Opp.AccountId = Acc.Id;
        Opp.CloseDate = system.today()+20;
        Opp.ContactId = Con1.Id;
        Opp.Type = 'New Customer';
        Opp.StageName = 'Prospecting';
        insert Opp;
        
        Quote Quo = new Quote();
        Quo.Name = 'Test_Quote22222';
        Quo.OpportunityId = Opp.Id;
        Quo.ContactId = Con1.Id;
        insert Quo;
        
        List<SObject> scheduleNewOrders = new List<SObject>();
        scheduleNewOrders.add(Quo);
        
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        
        Doc_Template__c DocTemp = new Doc_Template__c();
        DocTemp.Name = 'TestQuo';
        DocTemp.JunoDoc__Parent_Object__c = 'Quote';
        DocTemp.JunoDoc__Parent_Fields__c = 'Status,ExpirationDate';
        insert DocTemp;
        
        Email_Template__c EmTemp = new Email_Template__c();
        EmTemp.Name = 'TestEmQuo';
        EmTemp.JunoDoc__Parent_Object__c = 'Quote';
        insert EmTemp;
        
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Quo_Sch2';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = true;
        SchAct.JunoDoc__Junodoc_Is_Send__c = true;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = DocTemp.Id;
        SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct4 = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct4.Junodoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        PostAct4.JunoDoc__Junodoc_Value__c = 'true';
        PostActs.add(PostAct4);
        
        insert PostActs;
        
        test.startTest();
        JunoDocScheduleActionsBatch callBatch = new JunoDocScheduleActionsBatch(scheduleNewOrders, 'Quote','Quo_Sch2');
        DataBase.executeBatch(callBatch,1);
        test.stopTest();
    }
}*/
@isTest
public class JunoDocScheduleActionsBatchTest {
    
    @testSetup
    static void setup() {
       EmailTemplate email = new EmailTemplate ();
        email.developerName = 'test22';
        email.FolderId = UserInfo.getUserId();
        email.TemplateType= 'Text'; 
        email.Name = 'test';
        email.Body = 'JunoDoc Dummy Contact';
        email.Subject ='Hi';
        insert email;
       
    }
    
    testmethod static void testBatch(){
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con144@gmail.com';
        insert Con1;
        Contact con2 = new Contact(LastName='Jess', AccountId=acc.Id, Email = 'jess144@sfdc.com');
        insert con2;
        List<SObject> triggerNewOrders = new List<SObject>();
        triggerNewOrders.add(con1);
        triggerNewOrders.add(con2);
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Test';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Contact';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
         Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Doc';
        insert docTemplate;
        Doc_Template__c junoDoc = new Doc_Template__c();
        junoDoc.Name = 'Test Juno Doc';
        insert junoDoc;    
         
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = true;
        SchAct.JunoDoc__Junodoc_Is_Send__c = true;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = docTemplate.Id;
       // SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        
       
        
        
      
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
         Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
        
        /*
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
       
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;*/
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct4 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct4.Junodoc__Junodoc_Field__c = 'MobilePhone';
        PostAct4.JunoDoc__Junodoc_Value__c = '7777777777';
        PostActs.add(PostAct4);
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct3 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct3.Junodoc__Junodoc_Field__c = 'JunoDoc__Doc_Sent__c';
        PostAct3.JunoDoc__Junodoc_Value__c = 'false';
        PostActs.add(PostAct3);
        
       Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'Birthdate';
        PostAct2.JunoDoc__Junodoc_Value__c = '12/01/1998';
        PostActs.add(PostAct2);
        
        insert PostActs;        
        test.startTest();
        JunoDocScheduleActionsBatch callBatch2 = new JunoDocScheduleActionsBatch(triggerNewOrders, 'Contact','Test');
        
        ID batchID=DataBase.executeBatch(callBatch2);
        //System.abortJob(batchID);
        test.stopTest();
        
    }
    
      testmethod static void testBatch2(){
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con144@gmail.com';
        insert Con1;
        Contact con2 = new Contact(LastName='Jess', AccountId=acc.Id, Email = 'jess144@sfdc.com');
        insert con2;
        List<SObject> triggerNewOrders = new List<SObject>();
        triggerNewOrders.add(con1);
        triggerNewOrders.add(con2);
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Test';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Contact';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
         Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Doc';
          docTemplate.JunoDoc__Parent_Object__c = 'Contact';
          docTemplate.JunoDoc__Parent_Fields__c = 'LastName,Email';
        insert docTemplate;
        Doc_Template__c junoDoc = new Doc_Template__c();
        junoDoc.Name = 'Test Juno Doc';
        insert junoDoc;    
         
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = false;
        SchAct.JunoDoc__Junodoc_Is_Send__c = true;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = docTemplate.Id;
       // SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        
       
        
        
      
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
         Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
          
          Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        /*
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
       
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;*/
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct4 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct4.Junodoc__Junodoc_Field__c = 'MobilePhone';
        PostAct4.JunoDoc__Junodoc_Value__c = '7777777777';
        PostActs.add(PostAct4);
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct3 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct3.Junodoc__Junodoc_Field__c = 'JunoDoc__Doc_Sent__c';
        PostAct3.JunoDoc__Junodoc_Value__c = 'false';
        PostActs.add(PostAct3);
        
       Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'Birthdate';
        PostAct2.JunoDoc__Junodoc_Value__c = '12/01/1998';
        PostActs.add(PostAct2);
        
        insert PostActs;        
        test.startTest();
        JunoDocScheduleActionsBatch callBatch2 = new JunoDocScheduleActionsBatch(triggerNewOrders, 'Contact','Test');
        
        ID batchID=DataBase.executeBatch(callBatch2);
        //System.abortJob(batchID);
        test.stopTest();
        
    }
    
    testmethod static void testBatch3(){
        EmailTemplate email = [select id, name, body, subject from EmailTemplate  where developerName='test22' limit 1];
        Account Acc = new Account();
        Acc.Name = 'Test_Acc';
        Acc.Type = 'Prospect';
        insert Acc;
        
        Contact Con1 = new Contact();
        Con1.AccountId = Acc.Id;
        Con1.LastName = 'Test_Con1';
        Con1.Email = 'test_Con144@gmail.com';
        insert Con1;
        Contact con2 = new Contact(LastName='Jess', AccountId=acc.Id, Email = 'jess144@sfdc.com');
        insert con2;
        List<SObject> triggerNewOrders = new List<SObject>();
        triggerNewOrders.add(con1);
        triggerNewOrders.add(con2);
        JunoDoc__Junodoc_Schedule_Template_Setting__c JunoTemp = new JunoDoc__Junodoc_Schedule_Template_Setting__c();
        JunoTemp.Name = 'Test';
        JunoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Contact';
        JunoTemp.JunoDoc__Junodoc_IsActive__c = true;
        insert JunoTemp;
        
         Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Doc';
          docTemplate.JunoDoc__Parent_Object__c = 'Contact';
          docTemplate.JunoDoc__Parent_Fields__c = 'LastName,Email';
        insert docTemplate;
        Doc_Template__c junoDoc = new Doc_Template__c();
        junoDoc.Name = 'Test Juno Doc';
        insert junoDoc;    
         
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        JunoDoc__Junodoc_Schedule_Action__c SchAct = new JunoDoc__Junodoc_Schedule_Action__c();
        SchAct.JunoDoc__Junodoc_Save_as_Activity__c = false;
        SchAct.JunoDoc__Junodoc_Is_Attach__c = true;
        SchAct.JunoDoc__Junodoc_Is_Send__c = false;
        SchAct.JunoDoc__Junodoc_Email_Subject__c = '';
        SchAct.JunoDoc__Junodoc_Available_Doc_Template__c = docTemplate.Id;
       // SchAct.JunoDoc__Junodoc_Doc_Email_Template__c = EmTemp.Id;
        SchAct.JunoDoc__Junodoc_From_Email_Address__c = orgWide[0].Id;
        SchAct.JunoDoc__Junodoc_Email_Addresses__c = 'testEm@gmail.com';
        SchAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = JunoTemp.Id;
        SchAct.JunoDoc__Junodoc_Standard_Email_Template__c = email.Id;
        SchAct.JunoDoc__Junodoc_Users_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Contacts_Email_Addresses__c = 'Test~testing@gmail.com;Test2~testing2@gmail.com;';
        SchAct.JunoDoc__Junodoc_Set_Reply_To__c = 'testJun@gmail.com';
        SchAct.JunoDoc__Junodoc_Set_Sender_Display_Name__c = 'test';
        SchAct.JunoDoc__Junodoc_Email_Fields__c = 'Owner~Email;';
        insert SchAct;
        
        
       
        
        
      
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip.JunoDoc__Junodoc_Row_Number__c = 1;
        EmRecip.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno@gmail.com';
        insert EmRecip;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip2 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip2.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip2.JunoDoc__Junodoc_Row_Number__c = 2;
        EmRecip2.JunoDoc__Junodoc_To_Cc_Bcc__c = 'To';
        EmRecip2.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip2.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip2.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip2;
        
         Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip5 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip5.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip5.JunoDoc__Junodoc_Row_Number__c = 5;
        EmRecip5.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip5.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip5.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip5.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno3@gmail.com';
        insert EmRecip5;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip3 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip3.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip3.JunoDoc__Junodoc_Row_Number__c = 3;
        EmRecip3.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip3.JunoDoc__Junodoc_Reference_Type__c = 'Text';
        EmRecip3.JunoDoc__Junodoc_Email_API_Name_Values__c = '';
        EmRecip3.JunoDoc__Junodoc_Email_Label_Values__c = 'testjuno2@gmail.com';
        insert EmRecip3;
          
          Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
        /*
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip4 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip4.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip4.JunoDoc__Junodoc_Row_Number__c = 4;
        EmRecip4.JunoDoc__Junodoc_To_Cc_Bcc__c = 'CC';
        EmRecip4.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip4.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.owner.email';
        EmRecip4.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip4;
        
       
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip6 = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip6.JunoDoc__Junodoc_Schedule_Action__c = SchAct.Id;
        EmRecip6.JunoDoc__Junodoc_Row_Number__c = 6;
        EmRecip6.JunoDoc__Junodoc_To_Cc_Bcc__c = 'BCC';
        EmRecip6.JunoDoc__Junodoc_Reference_Type__c = 'Reference';
        EmRecip6.JunoDoc__Junodoc_Email_API_Name_Values__c = 'contact.email';
        EmRecip6.JunoDoc__Junodoc_Email_Label_Values__c = '';
        insert EmRecip6;*/
        
        List<Junodoc__Junodoc_Post_Schedule_Action__c> PostActs = new List<Junodoc__Junodoc_Post_Schedule_Action__c>();
        
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct4 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct4.Junodoc__Junodoc_Field__c = 'MobilePhone';
        PostAct4.JunoDoc__Junodoc_Value__c = '7777777777';
        PostActs.add(PostAct4);
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct3 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct3.Junodoc__Junodoc_Field__c = 'JunoDoc__Doc_Sent__c';
        PostAct3.JunoDoc__Junodoc_Value__c = 'false';
        PostActs.add(PostAct3);
        
       Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 =new Junodoc__Junodoc_Post_Schedule_Action__c();
        //defaultValueRec.Name = 'test';
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'Birthdate';
        PostAct2.JunoDoc__Junodoc_Value__c = '12/01/1998';
        PostActs.add(PostAct2);
        
        insert PostActs;        
        test.startTest();
        JunoDocScheduleActionsBatch callBatch2 = new JunoDocScheduleActionsBatch(triggerNewOrders, 'Contact','Test');
        
        ID batchID=DataBase.executeBatch(callBatch2);
        //System.abortJob(batchID);
        test.stopTest();
        
    }
    
    

}
@isTest
public class JunoDocTriggerActionsScheduleCtrlTest {
    @testSetup
    static void setup() {
        Account acc = new Account();
        acc.Name='Acc1';
        acc.Type = 'Prospect';
        acc.NumberOfEmployees=2;
        insert acc;
        
        Juno_Doc_Trigger_Log__c TriggerLogRec = new Juno_Doc_Trigger_Log__c(Executed_Date__c=system.today()-1,
                                                                            Trigger_Object__c='Account',
                                                                            Record_Ids__c='test');
        insert TriggerLogRec;

        Juno_Doc_Trigger_Log__c TriggerLogRec1 = new Juno_Doc_Trigger_Log__c(Executed_Date__c=system.today(),
                                                                            Trigger_Object__c='Account',
                                                                            Record_Ids__c='test');
        insert TriggerLogRec1;
        
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c(Name='Test',
                                                                 Object_Name__c='Account',
                                                                 Trigger_Conditions_Formula__c='(1 AND 2 AND 3)',
                                                                 IsActive__c=true);
        insert JunoDocTriggerRec;
        
         
    }
    
    
    
    static testMethod void TriggerActionHelperEqualsTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND 2 AND 3)';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = '04/04/2023';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Equals';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '1,000';
        insert obj3;
        
        Juno_Doc_Trigger_Condition__c obj4 = new Juno_Doc_Trigger_Condition__c();
        obj4.Juno_Doc_Trigger__c = triggerrec.id;
        obj4.RowNumber__c = 3;
        obj4.Field__c = 'OwnerId';
        obj4.Operator__c = 'Not Equal to';
        obj4.Value__c = 'null';
        insert obj4;
        
        Juno_Doc_Post_Trigger_Action__c PostAct = new Juno_Doc_Post_Trigger_Action__c();
        PostAct.JunoDoc__Field__c = 'NumberOfEmployees';
        PostAct.JunoDoc__Value__c = '1500';
        PostAct.JunoDoc__Juno_Doc_Trigger__c = triggerrec.id;
        insert PostAct;
        
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsScheduleHelper();
        test.stopTest();        
    }    
    
    
    static testMethod void TriggerActionHelperEqualsTest2() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND 2 AND 3)';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Equals';
        obj2.Value__c = 'Prospect,New Customer';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    
    static testMethod void TriggerActionHelperNotEqualsTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Not Equal to';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    static testMethod void TriggerActionHelperNotEqualsTest2() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Not Equal to';
        obj2.Value__c = 'Prospect,New Customer';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    
    static testMethod void TriggerActionHelperContainsTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Contains';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    static testMethod void TriggerActionHelperContainsTest2() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Contains';
        obj2.Value__c = 'Prospect, New Customer';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    

    static testMethod void TriggerActionHelperDoesNotContainsTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    static testMethod void TriggerActionHelperDoesNotContainsTest2() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'New Customer, Other';
        insert obj2; 
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Equals';
        obj3.Value__c = '0';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    

    static testMethod void TriggerActionHelperGreaterTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Greater than';
        obj3.Value__c = '1';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    static testMethod void TriggerActionHelperGreaterOrEqualTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Greater or equal';
        obj3.Value__c = '2';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    

    static testMethod void TriggerActionHelperLessTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Less than';
        obj3.Value__c = '3';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    static testMethod void TriggerActionHelperLessOrEqualTest() {
        test.startTest();
       
        Juno_Doc_Trigger__c triggerrec = new Juno_Doc_Trigger__c();
        triggerrec.Name = 'AccountTrigger';
        triggerrec.Object_Name__c = 'Account';
        triggerrec.Trigger_Conditions_Formula__c = '(1 AND (2 OR 3))';
        triggerrec.IsActive__c = true;
        insert triggerrec;

        Juno_Doc_Trigger_Condition__c obj1 = new Juno_Doc_Trigger_Condition__c();
        obj1.Juno_Doc_Trigger__c = triggerrec.id;
        obj1.RowNumber__c = 1;
        obj1.Field__c = 'CreatedDate';
        obj1.Operator__c = 'Not Equal to';
        obj1.Value__c = 'null';
        insert obj1;
        
        Juno_Doc_Trigger_Condition__c obj2 = new Juno_Doc_Trigger_Condition__c();
        obj2.Juno_Doc_Trigger__c = triggerrec.id;
        obj2.RowNumber__c = 2;
        obj2.Field__c = 'Type';
        obj2.Operator__c = 'Does not contain';
        obj2.Value__c = 'Prospect';
        insert obj2;
                
        Juno_Doc_Trigger_Condition__c obj3 = new Juno_Doc_Trigger_Condition__c();
        obj3.Juno_Doc_Trigger__c = triggerrec.id;
        obj3.RowNumber__c = 3;
        obj3.Field__c = 'NumberOfEmployees';
        obj3.Operator__c = 'Less or equal';
        obj3.Value__c = '2';
        insert obj3;                       
        JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account','AccountTrigger');    
        test.stopTest();        
    }    
    
    
    static testMethod void test() {
        test.startTest();
        JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsScheduleHelper();
        //JunoDocTriggerActionsScheduleController.getFilterRecordsHelper('Account');
        JunoDocTriggerActionsScheduleController.upsertTriggerLogs('Account','');
        test.stopTest();
    }
     
    static testMethod void TriggerActionsScheduleTest() {
        test.startTest();
        System.assertEquals('Test', 'Test');
        JunoDocTriggerActionsSchedule Schedule = new JunoDocTriggerActionsSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, Schedule);
        test.stopTest();
        
    }
    
    @isTest static void Test1(){
        Account ac = new Account();
        ac.Name='Acc1';
        ac.Type = 'Prospect';
        ac.NumberOfEmployees=2;
        insert ac;
        Email_Template__c emailTemplate = new Email_Template__c();
        emailTemplate.Name = 'Test Template';
        emailTemplate.Parent_Object__c = 'Account';
        emailTemplate.Parent_Fields__c = 'Name';
        insert emailTemplate;
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Account';
        //docTemplate.Doc_Template_Header__c = Headers[0].Id;
        //docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode';
        insert docTemplate;
        
       
        List<JunoDocTriggerActionsScheduleController.SendEmailClass> innlist= new List<JunoDocTriggerActionsScheduleController.SendEmailClass>();
       JunoDocTriggerActionsScheduleController.SendEmailClass juno = new JunoDocTriggerActionsScheduleController.SendEmailClass();
        juno.recordIds=ac.id;
        juno.EmailTemplateId=emailTemplate.id;
        juno.DocTemplateId=docTemplate.id;
        juno.TextEmails='test@gmail.com';
        juno.SaveAsActivity=true;
        innlist.add(juno);
        JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsProcessBuilderHelper(innlist);

    }
   // JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsProcessBuilderHelper(innlist);
}
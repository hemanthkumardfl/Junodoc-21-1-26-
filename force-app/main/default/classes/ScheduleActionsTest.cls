@isTest
public class ScheduleActionsTest {
    
    @isTest
    public static void method1(){
        
        Doc_Template__c DocTemp = new Doc_Template__c();
        DocTemp.Name = 'TestQuo';
        DocTemp.JunoDoc__Parent_Object__c = 'Quote';
        DocTemp.JunoDoc__Parent_Fields__c = 'Status,ExpirationDate';
        insert DocTemp;
        
        Email_Template__c EmTemp = new Email_Template__c();
        EmTemp.Name = 'TestEmQuo';
        EmTemp.JunoDoc__Parent_Object__c = 'Quote';
        insert EmTemp;
        
        list<Object> records = new list<Object>();
        map<Object,Object> RecordMap = new map<Object,Object>();
        RecordMap.put('field','Status');
        RecordMap.put('RowNumber',1);
        RecordMap.put('fieldValue','Presented');
        RecordMap.put('Operator','Equals');
        records.add(RecordMap);
        
        list<Object> PostActRecords = new list<Object>();
        map<Object,Object> PostActRecordMap = new map<Object,Object>();
        PostActRecordMap.put('Field','Status');
        PostActRecordMap.put('Value','Accepted');
        PostActRecords.add(PostActRecordMap);
        
        list<Object> RecipRecords = new list<Object>();
        map<Object,Object> RecipRecordMap = new map<Object,Object>();
        RecipRecordMap.put('indx','1');
        RecipRecordMap.put('ToCCBCC','To');
        RecipRecordMap.put('ReferenceType','Text');
        RecipRecordMap.put('EmailValue','test@gmail.com');
        RecipRecordMap.put('FinalFieldDetails','');
        RecipRecords.add(RecipRecordMap);
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        Junodoc_Details__c JDet = new Junodoc_Details__c();
        JDET.Selected_object__c = 'Quote';
        insert JDET;
        
        Junodoc__Junodoc_Schedule_Action__c SchAction = new Junodoc__Junodoc_Schedule_Action__c();
        SchAction.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        insert SchAction;
        
        Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c EmRecip = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
        EmRecip.JunoDoc__Junodoc_Schedule_Action__c = SchAction.Id;
        insert EmRecip;
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct.Junodoc__Junodoc_Field__c = 'Status';
        PostAct.JunoDoc__Junodoc_Value__c = 'Draft';
        insert PostAct;
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'ExpirationDate';
        PostAct2.JunoDoc__Junodoc_Value__c = string.ValueOf(System.today()+20);
        insert PostAct2;
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Daily';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = '5';
        insert SchSet;
        
        List<String> ScheduleDates = new List<String> ();
        List<String> ScheduleDays = new List<String> ();
        List<String> ScheduleMonths = new List<String> ();
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        ScheduleActions.ScheduleActionsTabClick();
        ScheduleActions.saveScheduleActionConditions('Quote_testclass','Quote','(1)',records);
        ScheduleActions.getSelectedPicklistValues('Quote', 'Status');
        ScheduleActions.getJunodocObjectsettings('Quote');
        ScheduleActions.getScheduleAction('Quote','Quote_testclass');
        ScheduleActions.getPostScheduleAction('Quote','Quote_testclass');
        ScheduleActions.getScheduleSetup('Quote_testclass');
        ScheduleActions.saveScheduleSetup('Quote_testclass','Daily','4',ScheduleDates,ScheduleDays,ScheduleMonths,'A.M.');
        ScheduleActions.savePostScheduleActions('Quote', 'Quote_testclass', PostActRecords);
        ScheduleActions.saveScheduleAction('Quote','Quote_testclass','', '', '', orgWide[0].Id,'', '','','','','','Test_Subject','false', 'false', 'true', RecipRecords);
        ScheduleActions.updateScheduleStatus('true','Quote_testclass');
        ScheduleActions.deleteJunoDocSchedule('Quote_testclass');
    }
    
    @isTest
    public static void method2(){
        
        list<Object> records = new list<Object>();
       
        
        map<Object,Object> RecordMap2 = new map<Object,Object>();
        RecordMap2.put('field','Status');
        RecordMap2.put('RowNumber',1);
        RecordMap2.put('fieldValue','Presented');
        RecordMap2.put('Operator','Equals');
        records.add(RecordMap2);
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Monthly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Date__c = '1;2';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Month__c = '1;2';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = '5';
        insert SchSet;
        
        List<String> ScheduleDates = new List<String> ();
        ScheduleDates.add('1');
        ScheduleDates.add('8');
        List<String> ScheduleDays = new List<String> ();
        List<String> ScheduleMonths = new List<String> ();
        ScheduleMonths.add('1');
        ScheduleMonths.add('8');
        
        ScheduleActions.getScheduleConditions('Quote','Quote_testclass2');
        ScheduleActions.saveScheduleActionConditions('Quote_testclass24','Quote','(1 AND 2)',records);
        ScheduleActions.getScheduleSetup('Quote_testclass2');
        ScheduleActions.updateScheduleStatus('false','Quote_testclass2');
        ScheduleActions.saveScheduleSetup('Quote_testclass2','Monthly','6',ScheduleDates,ScheduleDays,ScheduleMonths,'A.M.');
    }
    
    @isTest
    public static void method3(){
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass3';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Weekly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Day__c = 'Monday;Tuesday';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = '5';
        insert SchSet;
        
        List<String> ScheduleDates = new List<String> ();
        List<String> ScheduleDays = new List<String> ();
        ScheduleDays.add('Monday');
        ScheduleDays.add('Friday');
        List<String> ScheduleMonths = new List<String> ();
        
        ScheduleActions.getScheduleSetup('Quote_testclass3');
        ScheduleActions.saveScheduleSetup('Quote_testclass3','Weekly','9',ScheduleDates,ScheduleDays,ScheduleMonths,'A.M.');
    }
}
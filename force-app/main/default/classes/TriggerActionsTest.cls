@isTest
public class TriggerActionsTest {
    
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
        
        Juno_Doc_Trigger__c junoTemp = new Juno_Doc_Trigger__c();
        junoTemp.JunoDoc__Trigger_Conditions_Formula__c = '(1)';
        junoTemp.IsActive__c = true;
        junoTemp.JunoDoc__Object_Name__c = 'Quote';
        junoTemp.Name = 'Quote_testclass';
        insert junoTemp;
        
        Juno_Doc_Trigger_Condition__c SchCond = new Juno_Doc_Trigger_Condition__c();
        SchCond.Field__c = 'Status';
        SchCond.Operator__c = 'Equals';
        SchCond.RowNumber__c = 1;
        SchCond.Juno_Doc_Trigger__c = junoTemp.Id;
        SchCond.Value__c = 'Presented';
        insert SchCond;
        
        Junodoc_Details__c JDet = new Junodoc_Details__c();
        JDET.Selected_object__c = 'Quote';
        insert JDET;
        
        Juno_Doc_Trigger_Action__c SchAction = new Juno_Doc_Trigger_Action__c();
        SchAction.Juno_Doc_Trigger__c = junoTemp.Id;
        insert SchAction;
        
        JunoDoc__Junodoc_Add_Email_Recipient__c EmRecip = new JunoDoc__Junodoc_Add_Email_Recipient__c();
        EmRecip.Juno_Doc_Trigger_Action__c = SchAction.Id;
        insert EmRecip;
        
        Juno_Doc_Post_Trigger_Action__c PostAct = new Juno_Doc_Post_Trigger_Action__c();
        PostAct.Juno_Doc_Trigger__c = junoTemp.Id;
        PostAct.Field__c = 'Status';
        PostAct.Value__c = 'Draft';
        insert PostAct;
        
        Juno_Doc_Post_Trigger_Action__c PostAct2 = new Juno_Doc_Post_Trigger_Action__c();
        PostAct2.Juno_Doc_Trigger__c = junoTemp.Id;
        PostAct2.Field__c = 'ExpirationDate';
        PostAct2.Value__c = string.ValueOf(System.today()+20);
        insert PostAct2;
        
       
        
        List<OrgWideEmailAddress> orgWide = [Select Id from OrgWideEmailAddress];
        
        TriggerActions.TriggerActionsTabClick();
        TriggerActions.saveTriggerActionConditions('Quote_testclass','Quote','(1)',records);
        TriggerActions.getSelectedPicklistValues('Quote', 'Status');
        TriggerActions.getTriggerAction('Quote','Quote_testclass');
        //TriggerActions.getPostTriggerAction('Quote','Quote_testclass');
        TriggerActions.savePostTriggerActions('Quote', 'Quote_testclass', PostActRecords);
        TriggerActions.saveTriggerAction('Quote','Quote_testclass','', '', '', orgWide[0].Id,'', '','','','','','Test_Subject','false', RecipRecords);
        TriggerActions.updateTriggerStatus('true','Quote_testclass');
        TriggerActions.deleteJunoDocTrigger('Quote_testclass');
    }
    
  /*  @isTest
    public static void method2(){
        
        list<Object> records = new list<Object>();
        map<Object,Object> RecordMap = new map<Object,Object>();
        RecordMap.put('field','JunoDoc__Medicare__c');
        RecordMap.put('RowNumber',2);
        RecordMap.put('fieldValue','false');
        RecordMap.put('Operator','Equals');
        records.add(RecordMap);
        
        map<Object,Object> RecordMap2 = new map<Object,Object>();
        RecordMap2.put('field','Status');
        RecordMap2.put('RowNumber',1);
        RecordMap2.put('fieldValue','Presented');
        RecordMap2.put('Operator','Equals');
        records.add(RecordMap2);
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2)';
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
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'false';
        insert SchCond2;
        
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
        
        TriggerActions.getScheduleConditions('Quote','Quote_testclass2');
        TriggerActions.saveScheduleActionConditions('Quote_testclass24','Quote','(1 AND 2)',records);
        TriggerActions.getScheduleSetup('Quote_testclass2');
        TriggerActions.updateScheduleStatus('false','Quote_testclass2');
        TriggerActions.saveScheduleSetup('Quote_testclass2','Monthly','6',ScheduleDates,ScheduleDays,ScheduleMonths,'A.M.');
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
        
        TriggerActions.getScheduleSetup('Quote_testclass3');
        TriggerActions.saveScheduleSetup('Quote_testclass3','Weekly','9',ScheduleDates,ScheduleDays,ScheduleMonths,'A.M.');
    }*/
}
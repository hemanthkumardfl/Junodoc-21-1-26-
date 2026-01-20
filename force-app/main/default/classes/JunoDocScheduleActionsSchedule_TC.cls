@isTest
public class JunoDocScheduleActionsSchedule_TC {
    
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
        
        Account  Quo = new Account();
        Quo.Name = 'Test_Quote22222';
        Quo.Rating = 'Hot';
        Quo.AnnualRevenue = 1300000;
        Quo.NumberOfEmployees = 16;
       /* Quo.OpportunityId = Opp.Id;
        Quo.ContactId = Con1.Id;
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = false;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.Email = 'testquo@gmail.com';
        Quo.ExpirationDate = system.today()-30; */
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Account';
        junoTemp.Name = 'Acc_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Rating';
        SchCond.JunoDoc__Junodoc_Operator__c = 'contains';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Hot';
        insert SchCond;
        
       /* Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Email';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'testquo@gmail.com';
        insert SchCond3;*/
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Rating';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Warm';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'AnnualRevenue';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Greater or equal';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '13,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'NumberOfEmployees';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'less or equal';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '16';
        insert SchCond6;
        
       /* Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'CreatedDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = 'NOW';
        insert SchCond8;*/
        
        Junodoc__Junodoc_Post_Schedule_Action__c PostAct = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct.Junodoc__Junodoc_Field__c = 'Rating';
        PostAct.JunoDoc__Junodoc_Value__c = 'Cold';
        insert PostAct;
        
       /* Junodoc__Junodoc_Post_Schedule_Action__c PostAct2 = new Junodoc__Junodoc_Post_Schedule_Action__c();
        PostAct2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        PostAct2.Junodoc__Junodoc_Field__c = 'ExpirationDate';
        PostAct2.JunoDoc__Junodoc_Value__c = string.ValueOf(System.today()+20);
        insert PostAct2;*/
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Daily';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Account','Acc_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
        test.stopTest();
    }
    
   /* testmethod static void method2(){
        
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = system.today()-7;
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'contains';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Email';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'testquo@gmail.com';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Greater than';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '12,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Less than';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '18';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'today';
        insert SchCond7;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = 'last week';
        insert SchCond8;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Monthly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Date__c = todaydate;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Month__c = todaymonth;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = system.today()+4;
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'contains';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Email';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'testquo@gmail.com';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Greater than';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '12,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Less than';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '18';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'now';
        insert SchCond7;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = 'next week';
        insert SchCond8;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'P.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Monthly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Date__c = todaydate;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Month__c = todaymonth;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = system.today()+1;
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8)';
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
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Email';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'testquo@gmail.com';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Greater than';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '12,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Less than';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '18';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'this week';
        insert SchCond7;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = 'Tomorrow';
        insert SchCond8;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Weekly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Day__c = dayOfWeek;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
        test.stopTest();
    }
    
    testmethod static void method5(){
        
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = system.today()+30;
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Quote Quo2 = new Quote();
        Quo2.Name = 'Test_Quote22222';
        Quo2.OpportunityId = Opp.Id;
        Quo2.Status = 'Approved';
        Quo2.JunoDoc__Medicare__c = true;
        Quo2.Tax = 1300000;
        Quo2.ShippingHandling = 12;
        Quo2.ExpirationDate = system.today()+30;
        //Quo.Email = 'testquo@gmail.com';
        insert Quo2;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented,Approved';
        insert SchCond;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'In Review,Approved';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '13,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Contains';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '12';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'this month';
        insert SchCond7;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = 'next month';
        insert SchCond8;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond9 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond9.JunoDoc__Junodoc_Field__c = 'ContactId';
        SchCond9.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond9.JunoDoc__Junodoc_RowNumber__c = 9;
        SchCond9.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond9.JunoDoc__Junodoc_Value__c = Con1.Id;
        insert SchCond9;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'P.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Weekly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Day__c = dayOfWeek;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
        test.stopTest();
    }
    
    testmethod static void method6(){
        
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = date.parse('12/5/2023');
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'Contains';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'Approved';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Not equal to';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '12,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Contains';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '12';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Not equal to';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'Yesterday';
        insert SchCond7; 
            
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = '12/5/2023';
        insert SchCond8;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond9 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond9.JunoDoc__Junodoc_Field__c = 'ContactId';
        SchCond9.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond9.JunoDoc__Junodoc_RowNumber__c = 9;
        SchCond9.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond9.JunoDoc__Junodoc_Value__c = Con1.Id;
        insert SchCond9;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
        string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'A.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Weekly';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Day__c = dayOfWeek;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
        test.stopTest();
    }
    
     testmethod static void method7(){
        
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
        Quo.Status = 'Presented';
        Quo.JunoDoc__Medicare__c = true;
        Quo.Tax = 1300000;
        Quo.ShippingHandling = 12;
        Quo.ExpirationDate = date.parse('12/12/2023');
        //Quo.Email = 'testquo@gmail.com';
        insert Quo;
        
        Junodoc__Junodoc_Schedule_Template_Setting__c junoTemp = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        junoTemp.JunoDoc__Junodoc_Selected_Criteria__c = '(1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9)';
        junoTemp.JunoDoc__Junodoc_IsActive__c = true;
        junoTemp.JunoDoc__Junodoc_Selected_Object__c = 'Quote';
        junoTemp.Name = 'Quote_testclass2';
        insert junoTemp;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond.JunoDoc__Junodoc_Operator__c = 'Contains';
        SchCond.JunoDoc__Junodoc_RowNumber__c = 1;
        SchCond.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond.JunoDoc__Junodoc_Value__c = 'Presented';
        insert SchCond;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond2 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond2.JunoDoc__Junodoc_Field__c = 'JunoDoc__Medicare__c';
        SchCond2.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond2.JunoDoc__Junodoc_RowNumber__c = 2;
        SchCond2.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond2.JunoDoc__Junodoc_Value__c = 'true';
        insert SchCond2;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond3 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond3.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond3.JunoDoc__Junodoc_Operator__c = 'Not Equal to';
        SchCond3.JunoDoc__Junodoc_RowNumber__c = 3;
        SchCond3.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond3.JunoDoc__Junodoc_Value__c = 'Approved';
        insert SchCond3;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond4 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond4.JunoDoc__Junodoc_Field__c = 'Status';
        SchCond4.JunoDoc__Junodoc_Operator__c = 'Does not contain';
        SchCond4.JunoDoc__Junodoc_RowNumber__c = 4;
        SchCond4.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond4.JunoDoc__Junodoc_Value__c = 'Draft';
        insert SchCond4;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond5 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond5.JunoDoc__Junodoc_Field__c = 'Tax';
        SchCond5.JunoDoc__Junodoc_Operator__c = 'Not equal to';
        SchCond5.JunoDoc__Junodoc_RowNumber__c = 5;
        SchCond5.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond5.JunoDoc__Junodoc_Value__c = '12,00,000';
        insert SchCond5;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond6 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond6.JunoDoc__Junodoc_Field__c = 'ShippingHandling';
        SchCond6.JunoDoc__Junodoc_Operator__c = 'Contains';
        SchCond6.JunoDoc__Junodoc_RowNumber__c = 6;
        SchCond6.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond6.JunoDoc__Junodoc_Value__c = '12';
        insert SchCond6;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond7 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond7.JunoDoc__Junodoc_Field__c = 'createddate';
        SchCond7.JunoDoc__Junodoc_Operator__c = 'Not equal to';
        SchCond7.JunoDoc__Junodoc_RowNumber__c = 7;
        SchCond7.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond7.JunoDoc__Junodoc_Value__c = 'Yesterday';
        insert SchCond7; 
            
        Junodoc__Junodoc_Schedule_Condition__c SchCond8 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond8.JunoDoc__Junodoc_Field__c = 'ExpirationDate';
        SchCond8.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond8.JunoDoc__Junodoc_RowNumber__c = 8;
        SchCond8.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond8.JunoDoc__Junodoc_Value__c = '12/12/2023';
        insert SchCond8;
        
        Junodoc__Junodoc_Schedule_Condition__c SchCond9 = new Junodoc__Junodoc_Schedule_Condition__c();
        SchCond9.JunoDoc__Junodoc_Field__c = 'ContactId';
        SchCond9.JunoDoc__Junodoc_Operator__c = 'Equals';
        SchCond9.JunoDoc__Junodoc_RowNumber__c = 9;
        SchCond9.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchCond9.JunoDoc__Junodoc_Value__c = Con1.Id;
        insert SchCond9;
        
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
        
        TimeZone tz = UserInfo.getTimeZone();
        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
        ////system.debug('TimeZone-ID------>' + tz.getID());
        
        Datetime currentTime = Datetime.now();
        //system.debug('currentTime--->'+currentTime);
        
        String timeZone = String.valueof(tz.getID());
        //system.debug('timeZone--->'+timeZone);
        
        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
        //system.debug('dt--->'+dt);
        
         string todayhr = '';
         if(dt.hour() > 12){
             todayhr = string.valueof(dt.hour()-12);
         }
         else if(dt.hour() == 0){
             todayhr = string.valueof(12);
         }
         else{
             todayhr = string.valueof(dt.hour());
         }
        
        //system.debug('todayhr---->'+todayhr);
        
        string todaydate = string.valueof(dt.day());
        //system.debug('todaydate---->'+todaydate);
        
        string todaymonth = string.valueof(dt.month());
        //system.debug('todaymonth---->'+todaymonth);
        
        String dayOfWeek = dt.format('EEEE');
        
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSet = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        SchSet.JunoDoc__Junodoc_Clock_Format__c = 'P.M.';
        SchSet.JunoDoc__Junodoc_Schedule_Template_Setting__c = junoTemp.Id;
        SchSet.JunoDoc__Junodoc_Scheduler_Type__c = 'Daily';
        SchSet.JunoDoc__Junodoc_Selected_Schedule_Hour__c = todayhr;
        insert SchSet;
        
        test.startTest();
        JunoDocScheduleActionsScheduleController.getFilterRecordsHelper('Quote','Quote_testclass2');
        JunoDocScheduleActionsScheduleController.JunoDocScheduleActionsScheduleHelper();
        test.stopTest();
    }*/
}
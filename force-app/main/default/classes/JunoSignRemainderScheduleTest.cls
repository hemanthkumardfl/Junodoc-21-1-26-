@isTest
private class JunoSignRemainderScheduleTest {

    @isTest
    static void testScheduleJobWithValidTime() {
        // Step 1: Insert custom setting with a valid time
        JunoDoc__JunoSign_Reminder_Time__c setting = new JunoDoc__JunoSign_Reminder_Time__c(
            Name = 'Test',
            JunoDoc__Time__c = '12:45 PM' // should result in 0 45 12 * * ?
        );
        insert setting;
        
        JunoDoc__Default_Settings__c defaultSetting = new JunoDoc__Default_Settings__c();
        defaultSetting.Name='Default Settings';
        defaultSetting.JunoDoc__JunoSign_Schedule_Trigger__c = true;
        defaultSetting.JunoDoc__Schedule_Reminder_Time__c= '12:30 AM';
        defaultSetting.JunoDoc__Schedule_Triggers__c =true;
        defaultSetting.JunoDoc__Schedule_Reminder__c = true;
        insert defaultSetting;

        // Step 2: Call the schedule method
        Test.startTest();
        JunoSignRemainderSchedule.scheduleJob();
        Test.stopTest();

        // Optional: Assert something if needed, like querying CronTrigger
        List<CronTrigger> jobs = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'JunoSign Expiration Batch'
        ];

        System.assert(!jobs.isEmpty(), 'Scheduled job should exist');
    }

    @isTest
    static void testScheduleJobWithInvalidTime() {
        // Insert with invalid format to make sure it uses default
        JunoDoc__JunoSign_Reminder_Time__c setting = new JunoDoc__JunoSign_Reminder_Time__c(
            Name = 'Test2',
            JunoDoc__Time__c = 'invalid_time'
        );
        insert setting;
        
        JunoDoc__Default_Settings__c defaultSetting = new JunoDoc__Default_Settings__c();
        defaultSetting.Name='Default Settings';
        defaultSetting.JunoDoc__JunoSign_Schedule_Trigger__c = true;
        defaultSetting.JunoDoc__Schedule_Reminder_Time__c= '12:30 AM';
        defaultSetting.JunoDoc__Schedule_Triggers__c =true;
        defaultSetting.JunoDoc__Schedule_Reminder__c = true;
        insert defaultSetting;

        Test.startTest();
        JunoSignRemainderSchedule.scheduleJob();
        Test.stopTest();

        List<CronTrigger> jobs = [
            SELECT Id, CronExpression
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'JunoSign Expiration Batch'
        ];

        System.assert(!jobs.isEmpty(), 'Scheduled job should exist');
        System.debug('Scheduled Cron: ' + jobs[0].CronExpression);
    }

    @isTest
    static void testExecuteMethod() {
        Test.startTest();
        // Directly test execute method (simulates what scheduler does)
        JunoSignRemainderSchedule scheduler = new JunoSignRemainderSchedule();
        scheduler.execute(null);
        Test.stopTest();

        // You could assert something in the batch itself if needed
    }
}
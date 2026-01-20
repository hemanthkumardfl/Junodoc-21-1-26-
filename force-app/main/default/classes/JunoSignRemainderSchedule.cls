global class JunoSignRemainderSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new JunoSignReminderBatch(), 200);
    }
    
    global static void scheduleJob() {
        
        list<Default_Settings__c> settings = [select id, name,JunoDoc__Schedule_Reminder__c,JunoDoc__Schedule_Reminder_Time__c,JunoDoc__JunoSign_Schedule_Trigger__c from JunoDoc__Default_Settings__c where JunoDoc__Schedule_Reminder__c = true  limit 1];
        
        if (settings.isEmpty() || String.isBlank(settings[0].JunoDoc__Schedule_Reminder_Time__c)) {
            System.debug('No reminder time set — job will not be scheduled.');
            return; // Exit the method early
        }
        
        
        String timeStr = settings[0].JunoDoc__Schedule_Reminder_Time__c.trim().toUpperCase(); // e.g., "12:30 AM"
        
        Pattern timePattern = Pattern.compile('(\\d{1,2}):(\\d{2})\\s*(AM|PM)');
        Matcher m = timePattern.matcher(timeStr);
        
        if (m.matches()) {
            Integer hour = Integer.valueOf(m.group(1));
            String minute = m.group(2);
            String ampm = m.group(3);
            
            // Convert to 24-hour format
            if (ampm == 'PM' && hour != 12) {
                hour += 12;
            } else if (ampm == 'AM' && hour == 12) {
                hour = 0;
            }
            
            String cronExp = '0 ' + minute + ' ' + String.valueOf(hour) + ' * * ?';
            System.schedule('JunoSign Expiration Batch', cronExp, new JunoSignRemainderSchedule());
        } else {
            System.debug('Invalid time format in JunoDoc__Time__c: ' + timeStr);
        }
    }
}
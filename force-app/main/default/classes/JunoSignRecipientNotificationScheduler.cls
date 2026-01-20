public class JunoSignRecipientNotificationScheduler implements Schedulable {
    private Set<Id> recipientIds;
    private String reminderType; // '1 Day Before', '2 Days Before', or 'Every Day'
    
    public JunoSignRecipientNotificationScheduler(Set<Id> recipientIds, String reminderType) {
        this.recipientIds = recipientIds;
        this.reminderType = reminderType;
    }
    
    public void execute(SchedulableContext sc) {
        List<JunoDoc__Juno_Sign_Recipient__c> recipients = [SELECT Id, Name, JunoDoc__Recipient_Email__c, JunoDoc__JunoSign_Expiration_Date__c 
                                                            FROM JunoDoc__Juno_Sign_Recipient__c 
                                                            WHERE Id IN :recipientIds AND JunoDoc__Status__c = 'Pending'];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (JunoDoc__Juno_Sign_Recipient__c recipient : recipients) {
            Date expirationDate = recipient.JunoDoc__JunoSign_Expiration_Date__c;
            Date today = Date.today();
            if (reminderType == '1 Day Before' && expirationDate == today.addDays(1)) {
                emails.add(createEmail(recipient, '1 Day Before'));
            } else if (reminderType == '2 Days Before' && expirationDate == today.addDays(2)) {
                emails.add(createEmail(recipient, '2 Days Before'));
            } else if (reminderType == 'Every Day' && expirationDate > today) {
                emails.add(createEmail(recipient, 'Every Day'));
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
        
        // Reschedule for 'Every Day' reminders
        if (reminderType == 'Every Day') {
            scheduleNextDayJob(recipientIds);
        }
    }
    
    private Messaging.SingleEmailMessage createEmail(JunoDoc__Juno_Sign_Recipient__c recipient, String reminderType) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        system.debug('recipient.JunoDoc__Recipient_Email__c >>>>>>>>>>>>'+recipient.JunoDoc__Recipient_Email__c);
        email.setToAddresses(new String[] {'siddarth.alla@diligentforcelabs.com'});
        email.setSubject('Reminder: JunoSign Document Expiring Soon');
        email.setPlainTextBody('Dear ' + recipient.Name + ',\n\nYour JunoSign document is expiring in ' + reminderType + '. Please take the necessary action.\n\nBest regards,\nYour Company');
        return email;
    }
    
    private void scheduleNextDayJob(Set<Id> recipientIds) {
        Date nextDay = Date.today().addDays(1);
        String cronExpression = getCronExpression(nextDay);
        
        String jobName = 'JunoSignRecipientNotification_EveryDay_' + System.now().getTime();
        System.schedule(jobName, cronExpression, new JunoSignRecipientNotificationScheduler(recipientIds, 'Every Day'));
    }
    
    private static String getCronExpression(Date scheduleDate) {
        Datetime dt = Datetime.newInstance(scheduleDate.year(), scheduleDate.month(), scheduleDate.day(), 11, 55, 0); // Schedule at 9:00 AM
        return dt.format('ss mm HH dd MM ? yyyy');
    }
}
public class JunoSignRecipientTriggerHandler {
    
    public static void notificationRemainder(List<JunoDoc__Juno_Sign_Recipient__c> recipientList) {
        Set<Id> recipientIds1DayBefore = new Set<Id>();
        Set<Id> recipientIds2DaysBefore = new Set<Id>();
        Set<Id> recipientIdsEveryDay = new Set<Id>();

        for (JunoDoc__Juno_Sign_Recipient__c recipient : recipientList) {
            if (recipient.JunoDoc__Status__c == 'Pending' && recipient.JunoDoc__JunoSign_Expiration_Date__c != null && recipient.JunoDoc__JunoSign_Expiration_Date__c > Date.today()) {
                if (recipient.JunoDoc__JunoSign_Remainder__c == '1 Day Before') {
                    recipientIds1DayBefore.add(recipient.Id);
                } else if (recipient.JunoDoc__JunoSign_Remainder__c == '2 Days Before') {
                    recipientIds2DaysBefore.add(recipient.Id);
                } else if (recipient.JunoDoc__JunoSign_Remainder__c == 'Every Day') {
                    recipientIdsEveryDay.add(recipient.Id);
                }
            }
        }

        // Schedule jobs based on reminder type
        if (!recipientIds1DayBefore.isEmpty()) {
            scheduleJob(recipientIds1DayBefore, '1 Day Before');
        }
        if (!recipientIds2DaysBefore.isEmpty()) {
            scheduleJob(recipientIds2DaysBefore, '2 Days Before');
        }
        if (!recipientIdsEveryDay.isEmpty()) {
            scheduleJob(recipientIdsEveryDay, 'Every Day');
        }
    }

    private static void scheduleJob(Set<Id> recipientIds, String reminderType) {
        for (Id recipientId : recipientIds) {
            JunoDoc__Juno_Sign_Recipient__c recipient = [SELECT Id, JunoDoc__JunoSign_Expiration_Date__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Id = :recipientId LIMIT 1];
            Date expirationDate = recipient.JunoDoc__JunoSign_Expiration_Date__c;
            Date today = Date.today();

            if (reminderType == '1 Day Before') {
                // Schedule 1 day before expiration
                Date scheduleDate = expirationDate.addDays(-1);
                String cronExpression = getCronExpression(scheduleDate);
                String jobName = 'JunoSignRecipientNotification_' + reminderType.replace(' ', '_') + '_' + System.now().getTime();
                System.schedule(jobName, cronExpression, new JunoSignRecipientNotificationScheduler(new Set<Id>{recipientId}, reminderType));
            } else if (reminderType == '2 Days Before') {
                // Schedule 2 days before expiration
                Date scheduleDate = expirationDate.addDays(-2);
                String cronExpression = getCronExpression(scheduleDate);
                String jobName = 'JunoSignRecipientNotification_' + reminderType.replace(' ', '_') + '_' + System.now().getTime();
                System.schedule(jobName, cronExpression, new JunoSignRecipientNotificationScheduler(new Set<Id>{recipientId}, reminderType));
            } else if (reminderType == 'Every Day') {
                // Schedule every day from today up to the expiration date
                Date currentDate = today;
                while (currentDate <= expirationDate) {
                    String cronExpression = getCronExpression(currentDate);
                    String jobName = 'JunoSignRecipientNotification_' + reminderType.replace(' ', '_') + '_' + System.now().getTime() + '_' + currentDate;
                    System.schedule(jobName, cronExpression, new JunoSignRecipientNotificationScheduler(new Set<Id>{recipientId}, reminderType));
                    currentDate = currentDate.addDays(1);
                }
            }
        }
    }

    private static String getCronExpression(Date scheduleDate) {
        Datetime dt = Datetime.newInstance(scheduleDate.year(), scheduleDate.month(), scheduleDate.day(), 11, 55, 0); // Schedule at 9:00 AM
        return dt.format('ss mm HH dd MM ? yyyy');
    }
}
global class JunoSignReminderBatch implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date today = Date.today();
        
        return Database.getQueryLocator([
            SELECT
            (SELECT Id, Name, JunoDoc__Status__c, JunoDoc__Sort_Order__c, JunoDoc__Recipient_Email__c,
             JunoDoc__JunoSign_Expiration_Date__c, JunoDoc__Daily__c, JunoDoc__Days_Before__c, 
             JunoDoc__Before_Day_Number__c, JunoDoc__Recipient_Name__c, JunoDoc__signUrl__c,
            JunoSign_Recurring__c, junoSign_Recurring_Number__c, CreatedDate
             FROM JunoSign_Recipients__r
             WHERE JunoDoc__JunoSign_Expiration_Date__c >= :today
             AND JunoDoc__Status__c != 'Signed' and CreatedDate != today
             ORDER BY JunoDoc__Sort_Order__c ASC
             LIMIT 1)
            FROM JunoDoc__Juno_Sign_Transaction__c
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<JunoDoc__Juno_Sign_Transaction__c> transactions) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        // Fetch the Email Template
        EmailTemplate emailTempRec = [SELECT Id, HtmlValue, Subject 
                                     FROM EmailTemplate 
                                     WHERE DeveloperName = 'JunoSign_Remainder_template' 
                                     LIMIT 1];
        String templateHtmlValue = emailTempRec.HtmlValue;
        String templateSubject = emailTempRec.Subject;
        
        for (JunoDoc__Juno_Sign_Transaction__c transaction111 : transactions) {
            if (transaction111.JunoSign_Recipients__r.isEmpty()) {
                continue;
            }
            
            JunoDoc__Juno_Sign_Recipient__c recipient = transaction111.JunoSign_Recipients__r[0];
            if (recipient.JunoDoc__Recipient_Email__c == null || recipient.JunoDoc__JunoSign_Expiration_Date__c == null || recipient.JunoDoc__signUrl__c == null) {
                continue;
            }
            
            Boolean shouldSendEmail = false;
            String emailBody = '';
            Integer daysUntilExpiration = 0;
            
            // Existing "Days Before" condition
            if (recipient.JunoDoc__Days_Before__c && String.isNotBlank(recipient.JunoDoc__Before_Day_Number__c)) {
                List<String> dayValues = recipient.JunoDoc__Before_Day_Number__c.split(',');
                for (String dayStr : dayValues) {
                    dayStr = dayStr.trim();
                    if (Pattern.matches('^\\d+$', dayStr)) {
                        Integer daysBefore = Integer.valueOf(dayStr);
                        Date targetDate = recipient.JunoDoc__JunoSign_Expiration_Date__c.addDays(-daysBefore);
                        if (targetDate == Date.today()) {
                            shouldSendEmail = true;
                            emailBody = 'Reminder: Your JunoSign document will expire in ' +
                                daysBefore + ' days on ' +
                                recipient.JunoDoc__JunoSign_Expiration_Date__c.format();
                            daysUntilExpiration = daysBefore;
                            break;
                        }
                    }
                }
            }
            
            // Existing "Daily" condition
            if (recipient.JunoDoc__Daily__c) {
                shouldSendEmail = true;
                daysUntilExpiration = Math.abs(Date.today().daysBetween(recipient.JunoDoc__JunoSign_Expiration_Date__c));
                emailBody = 'Daily reminder: Your JunoSign document will expire in ' + 
                    daysUntilExpiration + ' days on ' + 
                    recipient.JunoDoc__JunoSign_Expiration_Date__c.format();
            }
            
            // Existing Recursive condition  JunoSign_Recurring__c, junoSign_Recurring_Number__c
            if (recipient.JunoSign_Recurring__c && String.isNotBlank(recipient.junoSign_Recurring_Number__c)) {
                List<String> recursiveIntervals = recipient.junoSign_Recurring_Number__c.split(',');
                Integer daysSinceCreated = recipient.CreatedDate.date().daysBetween(Date.today());
                
                // Check if CreatedDate is on the 1st (or adjust condition as needed)
                if (recipient.CreatedDate.day() == 1) {
                    for (String intervalStr : recursiveIntervals) {
                        intervalStr = intervalStr.trim();
                        if (Pattern.matches('^\\d+$', intervalStr)) {
                            Integer interval = Integer.valueOf(intervalStr);
                            if (daysSinceCreated == interval || daysSinceCreated == interval * 2 || 
                                daysSinceCreated == interval * 2 + 1 || daysSinceCreated == interval * 3 || 
                                daysSinceCreated == interval * 4 || daysSinceCreated == interval * 5) {
                                shouldSendEmail = true;
                                daysUntilExpiration = Math.abs(recipient.JunoDoc__JunoSign_Expiration_Date__c.daysBetween(Date.today()));
                                emailBody = 'Recursive reminder: Your JunoSign document is due. ' +
                                    interval + ' days since creation on ' + 
                                    recipient.CreatedDate.date().format();
                                break;
                            }
                        }
                    }
                } else {
                    // General recursive logic for any CreatedDate
                    for (String intervalStr : recursiveIntervals) {
                        intervalStr = intervalStr.trim();
                        if (Pattern.matches('^\\d+$', intervalStr)) {
                            Integer interval = Integer.valueOf(intervalStr);
                            if (Math.mod(daysSinceCreated, interval) == 0) {
                                shouldSendEmail = true;
                                daysUntilExpiration = Math.abs(recipient.JunoDoc__JunoSign_Expiration_Date__c.daysBetween(Date.today()));
                                emailBody = 'Recursive reminder: Your JunoSign document is due every ' +
                                    interval + ' days since creation on ' + 
                                    recipient.CreatedDate.date().format();
                                break;
                            }
                        }
                    }
                }
            }
            
            if (shouldSendEmail) {
                // Replace placeholders in the template
                String htmlContent = templateHtmlValue;
                htmlContent = htmlContent.replace('{!recipient.JunoDoc__Recipient_Name__c}', recipient.JunoDoc__Recipient_Name__c != null ? recipient.JunoDoc__Recipient_Name__c : '');
                htmlContent = htmlContent.replace('{!recipient.JunoDoc__signUrl__c}', recipient.JunoDoc__signUrl__c != null ? recipient.JunoDoc__signUrl__c : '');
                String expirationText = (daysUntilExpiration == 0) ? 'Two day' : String.valueOf(daysUntilExpiration) +''+ ' days left';
                htmlContent = htmlContent.replace('{!recipient.JunoDoc__Days_Until_Expiration__c}', expirationText);
                //htmlContent = htmlContent.replace('{!recipient.JunoDoc__Days_Until_Expiration__c}', String.valueOf(daysUntilExpiration));
                //htmlContent = htmlContent.replace('{!relatedTo.JunoDoc__Document_Name__c}', transaction.JunoDoc__Document_Name__c != null ? transaction.JunoDoc__Document_Name__c : 'N/A');//
                //htmlContent = htmlContent.replace('{!relatedTo.JunoDoc__Sent_By__c}', transaction.JunoDoc__Sent_By__c != null ? transaction.JunoDoc__Sent_By__c : 'N/A');
               // htmlContent = htmlContent.replace('{!relatedTo.JunoDoc__Pages__c}', transaction.JunoDoc__Pages__c != null ? String.valueOf(transaction.JunoDoc__Pages__c) : 'N/A');
                htmlContent = htmlContent.replace('{!recipient.JunoDoc__JunoSign_Expiration_Date__c}', recipient.JunoDoc__JunoSign_Expiration_Date__c != null ? recipient.JunoDoc__JunoSign_Expiration_Date__c.format() : '');

                // Create and send email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { recipient.JunoDoc__Recipient_Email__c });
                email.setSubject(templateSubject);
                email.setHtmlBody(htmlContent);
                email.setSaveAsActivity(false);
                
                emails.add(email);
            }
        }
        
        if (!emails.isEmpty()) {
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
                for (Messaging.SendEmailResult result : results) {
                    if (result.isSuccess()) {
                        System.debug('Email sent successfully');
                    } else {
                        System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
                    }
                }
            } catch (Exception e) {
                System.debug('Exception: ' + e.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('JunoSign Expiration Batch Completed.');
    }
}
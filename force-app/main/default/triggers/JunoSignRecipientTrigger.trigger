trigger JunoSignRecipientTrigger on JunoDoc__Juno_Sign_Recipient__c (after update) {
    JunoSignPostActionsController.handleTransactionUpdate(Trigger.new);
    //ExpiredDateEmailController.sendExpiredStatusEmail(Trigger.new,Trigger.oldMap);
}
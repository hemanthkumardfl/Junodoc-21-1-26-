public with sharing class junoSignTransactionsController {
    public class InnerClass{
        @AuraEnabled public boolean isopen{get;set;}
        @AuraEnabled public Integer rowNumber{get;set;}
        @AuraEnabled public Juno_Sign_Transaction__c transactionRecord{get;set;}
        @AuraEnabled public list<Juno_Sign_Recipient__c> recipientList{get;set;}
    }
        
      
    @AuraEnabled(cacheable=true)
    public static list<InnerClass>/*list<Juno_Sign_Transaction__c>*/ getAllTransactions(string recordId){
        list<InnerClass> parentWrapperList = new list<InnerClass>();
        list<Juno_Sign_Transaction__c> transactionsList = [select id,Name,Object_Id__c,Original_Document_Id__c,JunoDoc__Original_File_Id__c,Final_Document_Id__c,Final_Document_Link__c,Status__c,Sender_Name__c,Sender_Email__c
                                                            from Juno_Sign_Transaction__c
                                                            where Object_Id__c =: recordId order by Name DESC];
        list<Juno_Sign_Recipient__c> recipientsList = [select id,Name,Signed_File_Id_Link__c,Signed_File_Id__c,Juno_Sign_Transaction__c,Status__c,Recipient_Name__c,Recipient_Email__c
                                                        from Juno_Sign_Recipient__c
                                                        where Juno_Sign_Transaction__c!=null order by Name DESC];
                                                        
        map<string,list<Juno_Sign_Recipient__c>> transactionWithAllRecipientsMap = new map<string,list<Juno_Sign_Recipient__c>>();
        for(Juno_Sign_Recipient__c recipient:recipientsList){
            if(transactionWithAllRecipientsMap.get(recipient.Juno_Sign_Transaction__c)!=null){
                transactionWithAllRecipientsMap.get(recipient.Juno_Sign_Transaction__c).add(recipient);
            }else{
                transactionWithAllRecipientsMap.put(recipient.Juno_Sign_Transaction__c,new list<Juno_Sign_Recipient__c>{recipient});
            }
        }
       Integer i=0;
        for(Juno_Sign_Transaction__c trans:transactionsList){
            InnerClass innerC = new InnerClass();
            innerC.isopen = false;
            innerC.rowNumber = i+1;
            innerC.transactionRecord = trans;
            innerC.recipientList = transactionWithAllRecipientsMap.get(trans.Id);
            parentWrapperList.add(innerC);
            i++;
        }
       /* list<Juno_Sign_Transaction__c> transactionsList = [select id,Name,Object_Id__c,Original_Document_Id__c,Final_Document_Id__c,Final_Document_Link__c,Status__c,Sender_Name__c,Sender_Email__c,(select id,Name,Signed_File_Id_Link__c,Signed_File_Id__c,Juno_Sign_Transaction__c,Status__c,Recipient_Name__c,Recipient_Email__c
                                                            from Juno_Sign_Recipients__r)
                                                            from Juno_Sign_Transaction__c
                                                            where Object_Id__c =: recordId ];
        return transactionsList;*/
        return parentWrapperList;
    }
}
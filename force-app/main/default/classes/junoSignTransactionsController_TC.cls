@isTest
public class junoSignTransactionsController_TC {
    static testMethod void test1(){
    
        Opportunity opp = new Opportunity();
        opp.Name = 'opp test';
        opp.CloseDate = System.Today();
        opp.StageName = 'Closed Won';
        insert opp;
        
        
        
        list<Juno_Sign_Transaction__c> junoTranList = new list<Juno_Sign_Transaction__c>();
        Juno_Sign_Transaction__c Tran = new Juno_Sign_Transaction__c();
        Tran.Object_Id__c = opp.Id;
        Tran.Status__c = 'Sent';
        junoTranList.add(Tran);
        Juno_Sign_Transaction__c Tran1 = new Juno_Sign_Transaction__c();
        Tran1.Status__c = 'Sent';
        Tran1.Object_Id__c = opp.Id;
        junoTranList.add(Tran1);
        insert junoTranList;
        
        list<Juno_Sign_Recipient__c> junoRecipList = new list<Juno_Sign_Recipient__c>();
        Juno_Sign_Recipient__c rec = new Juno_Sign_Recipient__c();
        rec.Status__c = 'Rejected';
        rec.Juno_Sign_Transaction__c = Tran.Id;
        junoRecipList.add(rec);
        Juno_Sign_Recipient__c rec1 = new Juno_Sign_Recipient__c();
        rec1.Status__c = 'Rejected';
        rec1.Juno_Sign_Transaction__c = Tran1.Id;
        junoRecipList.add(rec1);
        insert junoRecipList;
        
        //junoSignTransactionsController junoSign = new junoSignTransactionsController();
        junoSignTransactionsController.getAllTransactions(opp.Id);
        
    }
}
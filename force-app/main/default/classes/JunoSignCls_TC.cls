@isTest
public class JunoSignCls_TC {
    private static testMethod void testClass() {
        
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        contact con = new contact();
        con.lastname='test';
        con.firstname='test1';
        con.email='test@gmail.com';
        insert con;
        
        Blob bodyblob = Blob.valueOf('test file');
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Juno_Sign_Transaction__c j = new Juno_Sign_Transaction__c();
        j.Expiration_Date__c = system.today();
        j.Original_Document_Id__c = conDocId;
        j.Object_Id__c = acc.Id;
        insert j;
        
        Juno_Sign_Recipient__c js = new Juno_Sign_Recipient__c();
        js.Juno_Sign_Transaction__c = j.id;
        js.Recipient_Name__c = 'test name';
        js.status__c = 'pending';
        js.Recipient_Email__c = 'Test@gmail.com';
        insert js;
        
        ApexPages.currentPage().getParameters().put('id',conDocId);
        ApexPages.currentPage().getParameters().put('recid',Js.Id);  
        JunoSignCls JUno = new JunoSignCls();
        Juno.callApexFunction();
        Juno.strImageBlob = 'test file';
        Juno.Reference();
        Juno.RejectMethod();
        Juno.CancelMethod();
    }
}
@isTest
public class signature_Controller_TC {
    private static testMethod void testClass() {
        Test.startTest();
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
        
        signature_Controller.innerClass inn = new signature_Controller.innerClass();
       
        signature_Controller.innclass inncl = new signature_Controller.innclass();
         inncl.Name = 'test';
        inncl.Email = 'test@gmail.com';
        list<signature_Controller.innclass> innclasslist = new list<signature_Controller.innclass>();
        innclasslist.add(inncl);
        signature_Controller.getFileDeatils(acc.id);
        signature_Controller.getEmail();
        signature_Controller.createrecord(''+conDocId,system.today().adddays(2),'Test','Test',innclasslist,'Parallel',''+acc.Id);
        signature_Controller.createrecord(''+conDocId,system.today().adddays(2),'Test','Test',innclasslist,'Sequential',''+acc.Id);
        Test.stopTest();
    }
}
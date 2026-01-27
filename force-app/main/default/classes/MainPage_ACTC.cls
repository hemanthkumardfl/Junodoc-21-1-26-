@isTest
public class MainPage_ACTC {
    public static testMethod void Test(){
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
        
        JunoDoc__Doc_Template__c juno = new JunoDoc__Doc_Template__c();
        juno.JunoDoc__Parent_Fields__c = 'test';
        juno.JunoDoc__Parent_Object__c = 'test2';
        juno.Name = 'teff';
        insert juno;
        
        Doc_Template__c doc = new Doc_Template__c();
        doc.JunoDoc__Parent_Fields__c = juno.id;
        doc.JunoDoc__Parent_Object__c = 'Contact';
       // doc.Id = juno.id;
        doc.JunoDoc__PDF_Name__c = '{!Name} - {!Account.Name} - {!Account.owner.Name} {!Account.owner.CreatedBy.Name} {!TODAY()} {!NOW()}';
      //  doc.PDF_Name__c = '{!PreviewPDF';
        insert doc;
        
        
        string single='single';
       // String  DocTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));   
          ApexPages.currentPage().getParameters().put('id',con.Id);
          ApexPages.currentPage().getParameters().put('DocTemplateId',doc.id);
        ApexPages.currentPage().getParameters().put('Type',single);
        //ApexPages.currentPage().getParameters().put('Type','multiple');
        ApexPages.currentPage().getParameters().get('id');
       
        MainPage_AC main = new MainPage_AC();
       // main.MainPage_AC();
         main.body = 'test';
        main.secondbody = 'test2';
        main.PDFValue = 'tes';
        
       
        
        
        
        
    }
    public static testMethod void testmultiple(){
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
        
        JunoDoc__Doc_Template__c juno = new JunoDoc__Doc_Template__c();
        juno.JunoDoc__Parent_Fields__c = 'test';
        juno.JunoDoc__Parent_Object__c = 'test2';
        juno.JunoDoc__PDF_Name__c = '{!PreviewPDF';
        insert juno;
        
        Doc_Template__c doc = new Doc_Template__c();
        doc.JunoDoc__Parent_Fields__c = juno.id;
        doc.JunoDoc__Parent_Object__c = juno.id;
       // doc.Id = juno.id;
        doc.JunoDoc__PDF_Name__c = '{!PreviewPDF';
        doc.PDF_Name__c = '{!PreviewPDF';
        insert doc;
        
        
        string single='single';
       // String  DocTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));   
          ApexPages.currentPage().getParameters().put('id',conDocId);
          ApexPages.currentPage().getParameters().put('DocTemplateId',doc.id);
        //ApexPages.currentPage().getParameters().put('Type',single);
        ApexPages.currentPage().getParameters().put('Type','multiple');
        ApexPages.currentPage().getParameters().get('id');
       
        MainPage_AC main = new MainPage_AC();
       // main.MainPage_AC();
       main.body = 'test';
        main.secondbody = 'test2';
        main.PDFValue = 'tes';
        
        
        
       
    }
}
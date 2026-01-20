@isTest
public class JunoUsersignContrl_TC {
    
    public static testmethod void Test1(){
        Account acc = new Account();
        acc.name = 'test';
        acc.AnnualRevenue = 100;
        acc.NumberOfEmployees = 100;
        insert acc;
        
        contact con = new contact();
        con.lastname='test';
        con.firstname='test1';
        con.email='test@gmail.com';
        con.AccountId = acc.Id;
        insert con;
        
        opportunity opp = new opportunity();
        opp.name = 'test_opp';
        opp.ContactId = con.id;
        opp.AccountId = acc.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today()+30;
        opp.TotalOpportunityQuantity = 100;
        insert opp;
        
        EmailTemplate temp = new EmailTemplate();
        temp.Body = 'textbody';
        temp.Subject = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Account.Owner.Createdby.Name} {}{!Account.Name}{!Account.Owner.IsActive}{!Account.Createddate} {!IsClosed}}{!Account.AnnualRevenue}';
        temp.DeveloperName = 'JunoSign_Completed_Signature_For_Owner';
        //insert temp;
        
        JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Opportunity';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.JunoDoc__Currency_Format__c = '###,###.00';
        JET.JunoDoc__Date_Format__c = 'MM/dd/yyyy';
        JET.JunoDoc__Number_Format__c = '###,###.00';
        
        JET.Name = 'Test';
        insert JET;
        
        JunoDoc__Email_Template__c JETt = new JunoDoc__Email_Template__c();
        JETt.JunoDoc__Parent_Object__c = 'Opportunity';
        JETt.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JETt.JunoDoc__Currency_Format__c = '###,###.00';
        JETt.JunoDoc__Date_Format__c = 'MM/dd/yyyy';
        JETt.JunoDoc__Number_Format__c = '100';
        JETt.Name = 'Test';
        insert JETt;
        
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c();
        JETI.JunoDoc__Template_Body__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Account.Owner.Createdby.Name} {}{!Account.Name}{!Account.Owner.IsActive}{!Account.Createddate} {!IsClosed}}{!Account.AnnualRevenue}';
        JETI.JunoDoc__Subject__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Account.Owner.Createdby.Name} {}{!Account.Name}{!Account.Owner.IsActive}{!Account.Createddate} {!IsClosed}}{!Account.AnnualRevenue}';
        JETI.JunoDoc__Email_Template__c = JET.Id;
        insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Opportunity';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        JunoDoc__Doc_Template__c tem = new JunoDoc__Doc_Template__c();
        tem.Name = 'Sequential test';
        tem.JunoDoc__Template_Type__c='PDF';
        tem.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        tem.JunoDoc__Currency_Format__c = '###,###.00';
        tem.JunoDoc__Date_Format__c = 'MM/dd/yyyy';
        tem.JunoDoc__Number_Format__c = '100';  
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='test';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c=tem.Id;
        Contact conrecord = new Contact();
        conrecord.LastName = 'test contact';
        insert conrecord;
        
        tr.JunoDoc__Object_Id__c  = conrecord.Id;
        tr.JunoDoc__Status__c='Sent';
        insert tr;
        
        list<JunoDoc__Juno_Sign_Recipient__c> recdata = new list<JunoDoc__Juno_Sign_Recipient__c>();
        JunoDoc__Juno_Sign_Recipient__c recd = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        recd.JunoDoc__Juno_Sign_Transaction__c = tr.Id;
        //rec.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c = tem.Id;
        recd.JunoDoc__Recipient_Name__c='JRN-00140';
        recd.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        recd.JunoDoc__JunoSign_Expiration_Date__c = system.today()-1;
        recd.JunoDoc__Status__c='pending';
        recd.JunoDoc__Sort_Order__c=1;
        recdata.add(recd);
        insert recdata;
        
        
        
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Juno_Sign_Transaction__c = tr.Id;
        //rec.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c = tem.Id;
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__JunoSign_Expiration_Date__c = system.today()-1;
        rec.JunoDoc__Status__c='Rejected';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
        
        JunoDoc__Juno_Sign_Recipient__c rec2 = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec2.JunoDoc__Juno_Sign_Transaction__c = tr.Id;
        //rec.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c = tem.Id;
        rec2.JunoDoc__Recipient_Name__c='Test';
        rec2.JunoDoc__Recipient_Email__c='sainadh.kuntsam@diligentforcelabs.com';
        rec2.JunoDoc__Status__c='Not Sent';
        rec2.JunoDoc__Sort_Order__c=1;
        insert rec2;
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name='text';
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;
        
        Blob bodyblob = Blob.valueOf('UNIT.TEST');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        //PageReference p1=page.p;
        PageReference pagePDF = new PageReference('/apex/Junodoc__JunodocPDF');    
        //Test.setCurrentPage(pagePDF);
        
        pagePdf.getParameters().put('id', opp.Id); 
        pagePdf.getParameters().put('DocTemplateId', cv.Id);
        
        
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='test';
        pt.JunoDoc__Pos_Top__c='signature';
        pt.JunoDoc__Sign_Completed__c=false;
        pt.JunoDoc__Type__c='test';
        pt.JunoDoc__Linked_To__c=tr.Id;
        pt.JunoDoc__Recipient_Sort_Order__c=rec.JunoDoc__Sort_Order__c;
        insert pt;
        
        Boolean Allowpage = true;
        JunoDoc__Doc_Template_Item__c c =  new JunoDoc__Doc_Template_Item__c();
        JunoDoc__Doc_Template_Item__c docTempItem = c.clone(false, true);
        docTempItem.JunoDoc__Doc_Template__c = tem.Id;
        docTempItem.JunoDoc__Template_Body__c ='';
        docTempItem.JunoDoc__Page_Render__c = '';
        docTempItem.JunoDoc__Junodoc_External_Id__c = '36763232';
        insert docTempItem;
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='5px';
        pt1.JunoDoc__Pos_Top__c='5px';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='signature';
        pt1.JunoDoc__Linked_To__c=tr.Id;
        pt1.JunoDoc__Recipient_Sort_Order__c=rec.JunoDoc__Sort_Order__c;
        insert pt1;
        
        list<string> signnot = new list<string>();
        signnot.add(string.valueof(pt1));
        signnot.add(string.valueof(pt));
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='https://junodoc-developer-edition.na111.force.com';
        insert s;
        
        PageReference signPage = new PageReference('');    
        ApexPages.currentPage().getParameters().put('id',tem.Id);
        ApexPages.currentPage().getParameters().put('recid',rec.Id);
        ApexPages.currentPage().getParameters().put('conid',opp.Id);
        ApexPages.currentPage().getParameters().put('trancid',tr.Id);
        ApexPages.currentPage().getParameters().put('orgTempRecordId',tem.Id);
        ApexPages.currentPage().getParameters().put('conDocID','');
        ApexPages.currentPage().getParameters().put('showattachment','false');
        JunoUsersignContrl Juno = new JunoUsersignContrl();
        Juno.signNotCompletedIds = '[]';
        Juno.getpositionsTabs();
        
        ContentVersion cv1 = new ContentVersion();
        cv1.Title = 'sampletitle';
        cv1.PathOnClient = 'sampletitle.jpg';
        cv1.VersionData = bodyblob;
        cv1.Origin = 'H';
        insert cv1;
        List<ContentVersion> contentVersionList =[select id from ContentVersion where id=: cv1.id];
        
        system.assertEquals(1,contentVersionList.size());
        Juno.signNotCompletedIds = '[]';
        Juno.strImageBlob = 'UNITTEST';
        Juno.pdfPageBlobForAttachment = Blob.valueOf('UNIT.TEST');
        Juno.updateStatus();
        Juno.logoUrl = '';
        Juno.getBarcodes('test');
        Juno.Reference();  
        
        /*ApexPages.currentPage().getParameters().put('id',tem.Id);
ApexPages.currentPage().getParameters().put('recid',rec2.Id);
ApexPages.currentPage().getParameters().put('conid',con.Id);
ApexPages.currentPage().getParameters().put('trancid',tr.Id);
ApexPages.currentPage().getParameters().put('orgTempRecordId',tem.Id);*/
        
        String cloneName= tem.Name+'-Cloned-'+ tem.Id+'-transid-'+tr.Id;
        JunoDoc__Doc_Template__c tem2 = new JunoDoc__Doc_Template__c();
        tem2.Name = cloneName;
        tem2.JunoDoc__Template_Type__c='PDF';
        generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem2;
        
        List<JunoDoc__Calculated_Fields__c> docTempCalcList =  new List<JunoDoc__Calculated_Fields__c>();
        JunoDoc__Calculated_Fields__c doc =  new JunoDoc__Calculated_Fields__c();
        JunoDoc__Calculated_Fields__c docTempCalcItem = doc.clone(false, true);
        docTempCalcItem.JunoDoc__Junodoc_Templates__c = tem2.Id;
        docTempCalcList.add(docTempCalcItem);
        insert docTempCalcList;
        
        
        
        
        ApexPages.currentPage().getParameters().put('id',tem2.Id);
        ApexPages.currentPage().getParameters().put('recid',rec2.Id);
        ApexPages.currentPage().getParameters().put('conid',opp.Id);
        ApexPages.currentPage().getParameters().put('trancid',tr.Id);
        ApexPages.currentPage().getParameters().put('orgTempRecordId',tem.Id);
        
        Juno.signNotCompletedIds = '[]';
        Juno.strImageBlob = 'UNITTEST';
        Juno.updateStatus();
        Juno.logoUrl = '';
        Juno.Reference(); 
        system.debug('template Id : '+ApexPages.currentPage().getParameters().get('orgTempRecordId'));
        JunoDoc__Doc_Template__c test23 = new JunoDoc__Doc_Template__c();
        test23.Name = 'Sequential test';
        test23.JunoDoc__Template_Type__c='PDF';
        insert test23;
        
       /* List<JunoDoc__Doc_Template_Child__c> templ = new List<JunoDoc__Doc_Template_Child__c>();
        JunoDoc__Doc_Template_Child__c templates = new JunoDoc__Doc_Template_Child__c();
        templates.JunoDoc__Font_Size__c = '35';
        templates.JunoDoc__Doc_Template__c = test23.Id;
        templates.JunoDoc__Rollup_groupby__c = true;
        templ.add(templates);
        insert templ; 
        JunoDoc__Doc_Template_Child__c templates2 = templates.clone();
        insert templates2;*/
        Test.startTest();
        Juno.deleteDocument(); 
        Test.stopTest();
        // Juno.GetNumbervalues('33,333.0');
    }
    
    public static testmethod void Test2(){
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        
        contact con = new contact();
        con.lastname='test';
        con.firstname='test1';
        con.email='test@gmail.com';
        insert con;
        
        
        
        JunoDoc__Doc_Template__c tem = new JunoDoc__Doc_Template__c();
        tem.Name = 'Sequential test';
        tem.JunoDoc__Template_Type__c='PDF';
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
        List<JunoDoc__Calculated_Fields__c> docTempCalcList =  new List<JunoDoc__Calculated_Fields__c>();
        /* JunoDoc__Calculated_Fields__c docTempCalc =  new JunoDoc__Calculated_Fields__c();
docTempCalc.JunoDoc__Junodoc_Templates__c = tem.Id;
insert docTempCalc;*/
        JunoDoc__Calculated_Fields__c doc =  new JunoDoc__Calculated_Fields__c();
        JunoDoc__Calculated_Fields__c docTempCalcItem = doc.clone(false, true);
        docTempCalcItem.JunoDoc__Junodoc_Templates__c = tem.Id;
        docTempCalcList.add(docTempCalcItem);
        //  docTempCalcList.add(docTempCalc);
        insert docTempCalcList;
        
        Boolean Allowpage = false;
        JunoDoc__Doc_Template_Item__c docTempItem =  new JunoDoc__Doc_Template_Item__c();
       // JunoDoc__Doc_Template_Item__c docTempItem = c.clone(false, true);
        docTempItem.JunoDoc__Doc_Template__c = tem.Id;
        docTempItem.JunoDoc__Template_Body__c ='test body';
        docTempItem.JunoDoc__Page_Render__c = 'test render';
        insert docTempItem;
        
        List<JunoDoc__Doc_Template_Child__c> templ = new List<JunoDoc__Doc_Template_Child__c>();
        JunoDoc__Doc_Template_Child__c templates = new JunoDoc__Doc_Template_Child__c();
        templates.JunoDoc__Font_Size__c = '35';
        templates.JunoDoc__Doc_Template__c = tem.Id;
        templates.JunoDoc__Rollup_groupby__c = true;
        templates.JunoDoc__Border_Color__c = 'white';
        templates.JunoDoc__Aggregate_Query__c = 'test';
        templates.JunoDoc__Available_Fields__c = 'test';
        templates.JunoDoc__Border__c = '3';
        templates.JunoDoc__Border_Style__c = '4';
        templates.JunoDoc__Calculation_Fields__c = 'test';
        templates.JunoDoc__Child_object__c = 'jhvjv';
       // insert templates;
        templ.add(templates);
       insert templ; 
       /* JunoDoc__Doc_Template_Child__c templates2 = templates.clone();
        templates2.JunoDoc__Font_Size__c = '35';
        templates2.JunoDoc__Doc_Template__c = tem.Id;
        templates2.JunoDoc__Rollup_groupby__c = true;
        templates2.JunoDoc__Border_Color__c = 'white';
        templ.add(templates2);
        insert templ;*/
        
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='test';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test@gmail.com';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c=tem.Id;
        tr.JunoDoc__Status__c='Completed';
        
        
        Contact conrecord = new Contact();
        conrecord.LastName = 'test contact';
        insert conrecord;
        
        JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Contact';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.JunoDoc__Date_Format__c = '';
        JET.JunoDoc__Number_Format__c = '';
        JET.JunoDoc__Currency_Format__c = '';
        JET.JunoDoc__Currency_Symbol__c = '';
        JET.Name = 'Test';
        insert JET;
        
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c();
        JETI.JunoDoc__Template_Body__c = 'test{!TODAY()}{!NOW()}';
        JETI.JunoDoc__Subject__c = 'test{!TODAY()}{!NOW()}';
        JETI.JunoDoc__Email_Template__c = JET.Id;
        insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Contact';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        
        tr.JunoDoc__Object_Id__c  = conrecord.Id;
        insert tr;
        
        JunoDoc__Juno_Sign_Transaction__c trans = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='test';
        trans.JunoDoc__Email_Subject__c='Test';
        trans.JunoDoc__Object_Id__c='test';
        trans.JunoDoc__Final_Document_Id__c='test';
        trans.JunoDoc__Sender_Email__c='test@gmail.com';
        trans.JunoDoc__Sender_Name__c='test';
        trans.JunoDoc__Date_Completed__c=System.today();
        //trans.JunoDoc__Original_Document_Id__c=tem.Id;
        trans.JunoDoc__Status__c='Completed';
        insert trans;
        
        List<JunoDoc__Juno_Sign_Recipient__c> reclist = new List<JunoDoc__Juno_Sign_Recipient__c>();
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        rec.JunoDoc__Juno_Sign_Transaction__c = tr.Id;
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Pending';
        rec.JunoDoc__Sort_Order__c= 1;
        // rec.JunoDoc__Juno_Sign_Transaction__c = trans.Id;
        reclist.add(rec);
        insert reclist;
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name= rec.Name;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        at.Date__c = system.today();
        insert at;
        
        Blob bodyblob = Blob.valueOf('test file');
        
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation='S';
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        List<ContentVersion> contentVersionList =[select id from ContentVersion where id=: cv.id];
        
        /**ContentVersion cv1 = new ContentVersion();
cv1.ContentLocation='S';
cv1.Title = 'sampletitle';
cv1.PathOnClient = 'sampletitle.jpg';
cv1.VersionData = bodyblob;
cv1.Origin = 'H';
cv1.OwnerId= rec.OwnerId;
insert cv;**/
        
        system.assertEquals(1,contentVersionList.size());
        
        //PageReference p1=page.p;
        PageReference pagePDF = Page.Junodoc__JunodocPDF;    
        //Test.setCurrentPage(pagePDF);
        
        
        pagePdf.getParameters().put('id', con.Id); 
        pagePdf.getParameters().put('DocTemplateId', tem.Id);
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        List<ContentDocument> cont = new  List<ContentDocument>();
        ContentDocument conte = new ContentDocument();
        //conte.Description = 'Blob';
        cont.add(conte);
        
        
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='10px';
        pt.JunoDoc__Pos_Top__c='10px';
        pt.JunoDoc__Sign_Completed__c=false;
        pt.JunoDoc__Type__c='signature';
        pt.JunoDoc__Linked_To__c=tr.Id;
        pt.JunoDoc__Recipient_Sort_Order__c=rec.JunoDoc__Sort_Order__c;
        insert pt;
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='5px';
        pt1.JunoDoc__Pos_Top__c='5px';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='signature';
        pt1.JunoDoc__Linked_To__c=tr.Id;
        pt1.JunoDoc__Recipient_Sort_Order__c=rec.JunoDoc__Sort_Order__c;
        insert pt1;
        
        list<string> signnot = new list<string>();
        signnot.add(string.valueof(pt1));
        signnot.add(string.valueof(pt));
        
        
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='https://junodoc-developer-edition.na111.force.com';
        insert s;
        
        ApexPages.currentPage().getParameters().put('id',tem.Id);
        ApexPages.currentPage().getParameters().put('recid',rec.Id);
        ApexPages.currentPage().getParameters().put('conid',con.Id);
        ApexPages.currentPage().getParameters().put('trancid',tr.Id);
        ApexPages.currentPage().getParameters().put('orgDocid',tem.Id);
        ApexPages.currentPage().getParameters().put('conDocID','');
        ApexPages.currentPage().getParameters().put('showattachment','false');
        
        JunoDoc__Doc_Template__c test23 = new JunoDoc__Doc_Template__c();
        test23.Name = 'Cloned-'+ tem.Id+'-tranid-'+tr.Id;
        test23.JunoDoc__Template_Type__c='PDF';
        insert test23;
        JunoUsersignContrl Juno = new JunoUsersignContrl();
        Juno.docList = '[{"Name":"by1_signedImage_0","Value":"iVBORw0KGgoAAAANSUhEUgAAAEwAAAAyCAYAAAD2vz2aAAAAAXNSR0IArs4c6QAAA4tJREFUaEPt2FvIbVMYxvHfjghJDpukKCkUiV0Ubtyg5JyUU45tRDmUHEo5SzmFQkTORMSdxA0XlKQIuXJFRCFJOfXUmDWb1vq+NdZa397mboz6Lr7WO8cc4z+f932fMdZpo4rAuqroFqwBqxRBA9aAVRKoDG8Ka8AqCVSGN4U1YJUEKsObwjYTsF1xOk7FUWUNH+B1vIYfK9f1vw1fVGHb4mLcil2m7PIbXIU3lkBha1xd/q7By/hnCfPOPMUiwHbEHbhyhrc9Vjb5+wyxK4XsixdwBJY1Z9WS5gUWZQXWteVtL+JxfIKfESUciAtwMh7Bg/iranX/DR6twg4vKbYnrse9+HNBGKN4fF6FpY7chy9wBj4fxW6XsMhFgWUJz5SU+xq/bulKmxdYPyUnfbfUsvfwBL5cpZPtjfNwGg5Fuuo7eAofDj7AejyEPXB+iV2CbmafYl5gKb6X4k6kW04bUVyK/d34bRCUOS7B7StYkgdwI7ruun+xEofgaMTrbdIxL7AsMs8egLNwQlHHtMUPG0NgpcMG5ErjaVzRg70BbyHNZnTAJm00IOL645Mux3El6Fucgo/K/8fi1aLOnwq45/Edtsc9uAw347bei3KKeB+Z70R8vEnlVVSyVu+MVzsH9xcwSa27sAMe7tWgC0u96xx7gCWNc4LI8wHZjQ7YpzgTX63V4qfNu0hKzrLW1LeY1nN7znwvvISkV9IyQPvHm53xbEnzIbBAyrNbLLDtCpCNPWCHlbQK8El1qP/MENjZeG5MwLq2nlpz04TON1Rd1BS1HFO6XVKyS6tpwLYqdeuGCSk5OmD9zSbNUl+m3Rbk9iJdMNahX/TTWV/BwaVOPTkht7uTRG4kkrLdGB2wfcptwZHF1ecAHgVFcX9jG0RVJ+GiAiWbzVkzivwDu5Vnji+pdR3eLQZ1p9JZ0yDitYa2YnTAki756mn7s44ATXH/oTyQRhMFBeJqY2hHRgcsG5zl0jBx8Vdx8Y/2nHoHKEebHHFycF9txIfdUq6GRt0ldy9mNAYyKZqalXNgzn9vF0f+/Qo04sdyV5ZaOLzWfhMHFeCpd91d2n4lTT9DUvmX1Wgv+/e19mHLXu9mn68Bq/wEDVgDVkmgMrwprAGrJFAZ3hTWgFUSqAxvCmvAKglUhjeFNWCVBCrDm8IasEoCleFNYQ1YJYHK8KawBqySQGV4U1gDVkmgMvxfg6K4M8p8zbMAAAAASUVORK5CYII=","Height":40,"Width":76,"PageNo":"0"}]';
        Juno.textContentList = '[{"Name":"textcontent1_text_0","Value":"type1","PageNo":"0"},{"Name":"textcontent1_text_1","Value":"tetst","PageNo":"0"}]';    
        Juno.initialList = '[{"Name":"initialsigned1_initial_0","Value":"inita","PageNo":"0"}]';
        Juno.dateContentList = '[{"Name":"datesigned1_date_0","Value":"05/03/2022","PageNo":"0"}]';
        Juno.attachmentListTableHtml = '';
        Juno.attachmentInitialStr  = '';
        Juno.createDocs();
        Juno.getPdfBlob();
        Juno.signNotCompletedIds = json.serialize(signnot);
        Juno.pdfPageBlobForAttachment = Blob.valueOf('UNIT.TEST');
        Juno.orgTempRecordId = tem.Id;
        Juno.getpositionsTabs();
        Juno.deleteDocument();
        Juno.strImageBlob = 'UNITTEST';
        Juno.updateStatus();
        Juno.logoUrl = '';
        Juno.Reference();
        Juno.deleteDocTemplate();
        Juno.rejectStatus();
        Juno.GetNumbervalues('33333.00');
        //\Juno.GetNumbervalues('33,333');
        Juno.GetNumbervalues(null);
        Juno.getBarcodes('testing');
        Juno.errorMessage = 'test error';
        Juno.downloadURL = 'www.com';
        Juno.downloadURLs = 'example.com';
        Juno.attachmentListInUI = 'testing';
        Juno.docidList = 'test2';
        Juno.secondbody = 'test3';
        Juno.signNotCompletedIds = '[]';
        Juno.shouldCheckDigit = true;
        Juno.blankasZeroes = true;
        
        JunoUsersignContrl.doFormatting(0.1, 0, 'tSep', 'dSep');
        //JunoUsersignContrl.blankasZeroes = true;

        
    }
    
}
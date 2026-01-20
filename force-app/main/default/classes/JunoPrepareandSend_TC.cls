@isTest
public class JunoPrepareandSend_TC {
    private static testMethod void testClass() {
        
        
        Account acc = new Account();
        acc.name = 'test';
        acc.AnnualRevenue = 100;
        acc.NumberOfEmployees = 100;
        insert acc;
        JunoDoc__JunosSign_Post_Reference__c REFOBJ = NEW JunoDoc__JunosSign_Post_Reference__c();
        REFOBJ.Name =' TEST';
        INSERT REFOBJ;
        
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
        
         Account quo = new Account();
        quo.name = 'test_quo';
       // quo.ContactId = con.id;
       // quo.OpportunityId = opp.id;
        insert quo;
        
        JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Account';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.Name = 'Test';
        insert JET;
        
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c();
        JETI.JunoDoc__Template_Body__c = 'Test';
        JETI.JunoDoc__Subject__c = 'Test';
        //JETI.JunoDoc__Template_Body__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        //JETI.JunoDoc__Subject__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        JETI.JunoDoc__Email_Template__c = JET.Id;
        insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Account';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        JunoDoc__Doc_Template__c tem = new JunoDoc__Doc_Template__c();
        tem.Name = 'Sequential test';
        tem.JunoDoc__Template_Type__c='PDF';
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
        List<id> listofids = new list<id>();
        listofids.add(tem.id);
        
        
        list<JunoDoc__Junodoc_Page_Tab__c> createpage = new list<JunoDoc__Junodoc_Page_Tab__c>();
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='Junosign Logo';
        pt.JunoDoc__Pos_Left__c='test';
        pt.JunoDoc__Pos_Top__c='test';
        pt.JunoDoc__Sign_Completed__c=true;
        pt.JunoDoc__Type__c='test';
        pt.JunoDoc__Linked_To__c='test';
        pt.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt);
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='test';
        pt1.JunoDoc__Pos_Top__c='test';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='test';
        pt1.JunoDoc__Linked_To__c='test';
        pt1.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt1);
        insert createpage;
        
        JunoPrepareandSend.posTabs pts= new JunoPrepareandSend.posTabs();
        pts.top = '376.097px';  //376.097px
        pts.left= '613.01px';
        pts.type='signature';
        pts.Name='dd';
        pts.recipientOrder=1;
        string ptsd = '[{"top":"376.097px","left":"613.01px","type": "signature","Name":"dd"}]';
        
        //user newuser = [select name,email from user limit 1];
        
        JunoPrepareandSend.recipentInner recp = new JunoPrepareandSend.recipentInner();
        recp.name= 'dtat';
        recp.email = 'dd@gmail.com';
        string reclist = '[{"Name":"Sainadh kuntsam33", "Description":"siva","email":"sainadh.kuntsam@diligentforcelabs.com","emailType": "To"}]';        
        
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Signed';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c='test';
        tr.JunoDoc__Status__c='Sent';
        
        insert tr;
        
        JunoDoc__JunoSign_Post_Actions__c POSTOBJ = NEW JunoDoc__JunoSign_Post_Actions__c();
        POSTOBJ.JunoDoc__JunosSign_Post_Reference__c = REFOBJ.Id;
        POSTOBJ.JunoDoc__JunoSign_Transaction__c  = tr.Id;
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;
        
        Blob bodyblob = Blob.valueOf('test file');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='https://www.testurl.com';
        insert s;
        
        
        
        Document doc = new Document();
        doc.Name = 'Test Doc';
        doc.DeveloperName = 'Junosign_logo1';
        //insert doc;
        
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test con Template';
        docTemplate.Parent_Object__c = 'Contact';
        
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, Contact.owner.Name'; //, Account.owner.isActive, Account.AnnualRevenue';
        insert docTemplate;
        
        string conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        String jsonData = '';
        list<JunoPrepareandSend.InnerClass> JunoInners = new list<JunoPrepareandSend.InnerClass>();
        JunoPrepareandSend.InnerClass JunoInner = new JunoPrepareandSend.InnerClass();
        JunoInner.name = 'test';
        JunoInner.fileContents = conDocId;
        JunoInners.add(JunoInner);
        
         list<string> acclist = new list<string>();
       string a1 = 'test1';
        acclist.add(a1);
        string a2 = 'test1';
        acclist.add(a2);
        
        list<string>  refflist = new  list<string>();  
        refflist.add(REFOBJ.Id);
       
        
        // System.debug('jsonData--'+jsonData);
        ApexPages.currentPage().getParameters().put('FileList', JSON.serialize(JunoInners));
        ApexPages.currentPage().getParameters().put('docidList', docTemplate.id);
        ApexPages.currentPage().getParameters().put('recordId',quo.Id);
        ApexPages.currentPage().getParameters().put('receiverList',reclist);
        ApexPages.currentPage().getParameters().put('id', conDocId);
        ApexPages.currentPage().getParameters().put('isInPerson', 'true');
        ApexPages.currentPage().getParameters().put('showAttachmentSetting', 'false');
        ApexPages.currentPage().getParameters().put('insertedIds', JSON.serialize(refflist));
        ApexPages.currentPage().getParameters().put('showattachment', 'false');
        
        JunoPrepareandSend Juno = new JunoPrepareandSend();
        //Juno.receiverList=jsonData ;
        Juno.pageTabPosListVal =ptsd; 
        String SiteURL = '';
        List<JunoDoc__Junodoc_Setting__c> listurl = [Select JunoDoc__Site_URL__c FROM JunoDoc__Junodoc_Setting__c LIMIT 1];
        if(listurl.size() > 0){
            SiteURL = listurl[0].JunoDoc__Site_URL__c; 
        }
        string domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
        SiteURL = SiteURL.replace('http://', 'https://');
        Juno.signUrl = SiteURL+'?id='+tem.Id+'&recid='+rec.id+'&trancid='+tr.id+'&conid='+con.Id+'&isInPerson='+true+'&domainName='+domainName;
        
        List<Document> docRecod= [Select Id,Name from Document where DeveloperName = 'Junosign_logo'];
        system.debug(System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com',''));
        domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
        String OrgId = ''+UserInfo.getOrganizationId();
        Juno.logoUrl = '';
        if(docRecod.size()>0){
            Juno.logoUrl = 'https://'+domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docRecod[0].Id+'&oid='+OrgId; 
        }
        
         Juno.callUserSignpage();
       // Juno.createrecord();
        
       
        
       
        
        
    }
    private static testMethod void testClass1() {
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        JunoDoc__JunosSign_Post_Reference__c REFOBJ = NEW JunoDoc__JunosSign_Post_Reference__c();
        REFOBJ.Name =' TEST';
        INSERT REFOBJ;
        
        contact con = new contact();
        con.lastname='test';
        con.firstname='test1';
        con.email='test@gmail.com';
        insert con;
        
        opportunity opp = new opportunity();
        opp.name = 'test_opp';
        opp.ContactId = con.id;
        opp.AccountId = acc.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today()+30;
        opp.TotalOpportunityQuantity = 100;
        insert opp;
        
         Account quo = new Account();
        quo.name = 'test_quo1';
       // quo.ContactId = con.id;
        //quo.OpportunityId = opp.id;
        insert quo;
        
         JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Account';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.Name = 'Test';
        insert JET;
        
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c();
        JETI.JunoDoc__Template_Body__c = 'Test';
        JETI.JunoDoc__Subject__c = 'Test';
        //JETI.JunoDoc__Template_Body__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        //JETI.JunoDoc__Subject__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        JETI.JunoDoc__Email_Template__c = JET.Id;
        insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Account';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        JunoDoc__Doc_Template__c tem = new JunoDoc__Doc_Template__c();
        tem.Name = 'Sequential test';
        tem.JunoDoc__Template_Type__c='PDF';
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
        List<id> listofids = new list<id>();
        listofids.add(tem.id);
        
        
        list<JunoDoc__Junodoc_Page_Tab__c> createpage = new list<JunoDoc__Junodoc_Page_Tab__c>();
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='test';
        pt.JunoDoc__Pos_Top__c='test';
        pt.JunoDoc__Sign_Completed__c=true;
        pt.JunoDoc__Type__c='test';
        pt.JunoDoc__Linked_To__c='test';
        pt.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt);
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='test';
        pt1.JunoDoc__Pos_Top__c='test';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='test';
        pt1.JunoDoc__Linked_To__c='test';
        pt1.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt1);
        insert createpage;
        
        JunoPrepareandSend.posTabs pts= new JunoPrepareandSend.posTabs();
        pts.top = '376.097px';  //376.097px
        pts.left= '613.01px';
        pts.type='signature';
        pts.Name='dd';
        pts.recipientOrder=1;
        string ptsd = Json.serialize(pts);
        System.debug('ptsd----'+ptsd);
        
        
        user newuser = [select name,email from user limit 1];
        
        JunoPrepareandSend.recipentInner recp = new JunoPrepareandSend.recipentInner();
        recp.name= newuser.name;
        recp.email = newuser.Email;
        //string reclist = Json.serialize(recp);        
        string reclist = '[{"Name":"Sainadh kuntsam44","Description":"siva", "email":"sainadh.kuntsam@diligentforcelabs.com","emailType": "To"}]';        
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Signed';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c='test';
        tr.JunoDoc__Status__c='Sent';
        insert tr;
        
        JunoDoc__JunoSign_Post_Actions__c POSTOBJ = NEW JunoDoc__JunoSign_Post_Actions__c();
        POSTOBJ.JunoDoc__JunosSign_Post_Reference__c = REFOBJ.Id;
        POSTOBJ.JunoDoc__JunoSign_Transaction__c  = tr.Id;
        
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='test';
        insert s;
        
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;
        
        Blob bodyblob = Blob.valueOf('test file');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        string conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test con Template';
        docTemplate.Parent_Object__c = 'Contact';
        
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, Account.owner.Name, Account.owner.isActive, Account.AnnualRevenue';
        insert docTemplate;
        
        list<string> acclist = new list<string>();
       string a1 = 'test1';
        acclist.add(a1);
        string a2 = 'test1';
        acclist.add(a2);
        
        ApexPages.currentPage().getParameters().put('docidList', cv.id);
        ApexPages.currentPage().getParameters().put('recordId',quo.Id);
        ApexPages.currentPage().getParameters().put('receiverList',reclist);
        ApexPages.currentPage().getParameters().put('isInPerson', 'true');
        ApexPages.currentPage().getParameters().put('showAttachmentSetting', 'false');
         ApexPages.currentPage().getParameters().put('REFOBJ', REFOBJ.id);
        ApexPages.currentPage().getParameters().put('showattachment', 'false');
        JunoPrepareandSend Juno = new JunoPrepareandSend();
        
        //  Juno.getHtmlContentForSignPositionMethod();
        
        
    }
    private static testMethod void testClass2() {
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        JunoDoc__JunosSign_Post_Reference__c REFOBJ = NEW JunoDoc__JunosSign_Post_Reference__c();
        REFOBJ.Name =' TEST';
        INSERT REFOBJ;
        contact con = new contact();
        con.lastname='test';
        con.firstname='test1';
        con.email='test@gmail.com';
        insert con;
        
        opportunity opp = new opportunity();
        opp.name = 'test_opp';
        opp.ContactId = con.id;
        opp.AccountId = acc.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today()+30;
        opp.TotalOpportunityQuantity = 100;
        insert opp;
        
        Account quo = new Account();
        quo.name = 'test_quo1';
        //quo.ContactId = con.id;
        //quo.OpportunityId = opp.id;
        insert quo;
        
        
        JunoDoc__Doc_Template__c tem = new JunoDoc__Doc_Template__c();
        tem.Name = 'Sequential test';
        tem.JunoDoc__Template_Type__c='PDF';
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
         JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Account';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.Name = 'Test';
        insert JET;
        
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c();
        JETI.JunoDoc__Template_Body__c = 'Test';
        JETI.JunoDoc__Subject__c = 'Test';
        //JETI.JunoDoc__Template_Body__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        //JETI.JunoDoc__Subject__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        JETI.JunoDoc__Email_Template__c = JET.Id;
        insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Account';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        List<id> listofids = new list<id>();
        listofids.add(tem.id);
        
        
        list<JunoDoc__Junodoc_Page_Tab__c> createpage = new list<JunoDoc__Junodoc_Page_Tab__c>();
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='test';
        pt.JunoDoc__Pos_Top__c='test';
        pt.JunoDoc__Sign_Completed__c=true;
        pt.JunoDoc__Type__c='test';
        pt.JunoDoc__Linked_To__c='test';
        pt.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt);
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='613.01px';
        pt1.JunoDoc__Pos_Top__c='376.097px';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='signature';
        pt1.JunoDoc__Linked_To__c='test';
        pt1.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt1);
        insert createpage;
        
        JunoPrepareandSend.posTabs pts= new JunoPrepareandSend.posTabs();
        pts.top = '376.097px';  //376.097px
        pts.left= '613.01px';
        pts.type='signature';
        pts.Name='dd';
        pts.recipientOrder=1;
        string ptsd = '[{"top":"376.097px","left":"613.01px","type": "signature","Name":"dd"}]';
        
        
        user newuser = [select name,email from user limit 1];
       // newuser.
        JunoPrepareandSend.recipentInner recp = new JunoPrepareandSend.recipentInner();
        recp.name= newuser.name;
        recp.email = newuser.Email;
       // recp.description =  newuser.name ;
        string reclist = '[{"Name":"Sainadh kuntsam55", "Description":"siva", "email":"sainadh.kuntsam@diligentforcelabs.com","emailType":"To"}]';       
        
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Signed';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
        
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c='test';
        tr.JunoDoc__Status__c='Sent';
        insert tr;
        
        
        JunoDoc__JunoSign_Post_Actions__c POSTOBJ = NEW JunoDoc__JunoSign_Post_Actions__c();
        POSTOBJ.JunoDoc__JunosSign_Post_Reference__c = REFOBJ.Id;
        POSTOBJ.JunoDoc__JunoSign_Transaction__c  = tr.Id;
        
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='test';
        insert s;
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;
        
        Blob bodyblob = Blob.valueOf('test file');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        string conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        Doc_Template__c docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test con Template';
        docTemplate.Parent_Object__c = 'Contact';
        
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, Account.owner.Name, Account.owner.isActive, Account.AnnualRevenue';
        insert docTemplate;
        
        list<JunoPrepareandSend.InnerClass> JunoInners = new list<JunoPrepareandSend.InnerClass>();
        JunoPrepareandSend.InnerClass JunoInner = new JunoPrepareandSend.InnerClass();
        JunoInner.name = 'test';
        JunoInner.fileContents = conDocId;
        JunoInners.add(JunoInner);
        
        list<string> refflist = new list<string>();
        refflist.add(REFOBJ.id);
        
        // System.debug('jsonData--'+jsonData);
        ApexPages.currentPage().getParameters().put('FileList', JSON.serialize(JunoInners));
        ApexPages.currentPage().getParameters().put('docidList', docTemplate.id);
        ApexPages.currentPage().getParameters().put('recordId',quo.Id);
        ApexPages.currentPage().getParameters().put('receiverList',reclist);
        ApexPages.currentPage().getParameters().put('id', conDocId);
        ApexPages.currentPage().getParameters().put('isInPerson', 'true');
        ApexPages.currentPage().getParameters().put('showAttachmentSetting', 'false');
        ApexPages.currentPage().getParameters().put('insertedIds',JSON.serialize(refflist));
        ApexPages.currentPage().getParameters().put('showattachment', 'false');
        // String jsonData = '{"posTabs":{ptsd}}';
        // System.debug('jsonData--'+jsonData);
        JunoPrepareandSend Juno = new JunoPrepareandSend();
        Juno.pageTabPosListVal =ptsd; 
        Juno.logoUrl = '';
        Juno.savePageTabsVal();
               
        
        
    }
    private static testMethod void testClass3() {
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        
         JunoDoc__JunosSign_Post_Reference__c  refobj = New JunoDoc__JunosSign_Post_Reference__c();
            REFOBJ.Name = 'test';
            insert refobj;
        
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
        
        List<id> listofids = new list<id>();
        listofids.add(tem.id);
        
        
        list<JunoDoc__Junodoc_Page_Tab__c> createpage = new list<JunoDoc__Junodoc_Page_Tab__c>();
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='10px';
        pt.JunoDoc__Pos_Top__c='10px';
        pt.JunoDoc__Sign_Completed__c=true;
        pt.JunoDoc__Type__c='signature';
        pt.JunoDoc__Linked_To__c='test';
        pt.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt);
        
        JunoDoc__Junodoc_Page_Tab__c pt1 = new JunoDoc__Junodoc_Page_Tab__c();
        pt1.Name='test';
        pt1.JunoDoc__Pos_Left__c='10px';
        pt1.JunoDoc__Pos_Top__c='10px';
        pt1.JunoDoc__Sign_Completed__c=false;
        pt1.JunoDoc__Type__c='signature';
        pt1.JunoDoc__Linked_To__c='test';
        pt1.JunoDoc__Recipient_Sort_Order__c=5;
        createpage.add(pt1);
        insert createpage;
        
        JunoPrepareandSend.posTabs pts= new JunoPrepareandSend.posTabs();
        pts.top = '376.097px';  //376.097px
        pts.left= '613.01px';
        pts.type='signature';
        pts.Name='dd';
        pts.recipientOrder=1;
        string ptsd = Json.serialize(pts);
        
        user newuser = [select name,email from user limit 1];
        
        JunoPrepareandSend.recipentInner recp = new JunoPrepareandSend.recipentInner();
        recp.name= newuser.name;
        recp.email = newuser.Email;
        //string reclist = Json.serialize(recp);        
        string reclist = '[{"Name":"Sainadh kuntsam11", "Description":"siva","email":"sainadh.kuntsam@diligentforcelabs.com","emailType": "To"},{"Name":"Sainadh kuntsam22", "Description":"siva","email":"sainadh.kuntsam@diligentforcelabs.com","emailType": "CC"}]';        
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Signed';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
        
        JunoDoc__Juno_Sign_Transaction__c tr = new JunoDoc__Juno_Sign_Transaction__c();
        // tr.Name ='';
        tr.JunoDoc__Email_Subject__c='Test';
        tr.JunoDoc__Object_Id__c='test';
        tr.JunoDoc__Final_Document_Id__c='test';
        tr.JunoDoc__Sender_Email__c='test@gmail.com';
        tr.JunoDoc__Sender_Name__c='test';
        tr.JunoDoc__Date_Completed__c=System.today();
        tr.JunoDoc__Original_Document_Id__c='test';
        tr.JunoDoc__Status__c='Sent';
        insert tr;
       
        
        JunoDoc__JunoSign_Post_Actions__c POSTOBJ = NEW JunoDoc__JunoSign_Post_Actions__c();
        POSTOBJ.JunoDoc__JunosSign_Post_Reference__c = REFOBJ.Id;
        POSTOBJ.JunoDoc__JunoSign_Transaction__c  = tr.Id;
        
        JunoDoc__Junodoc_Setting__c s= new JunoDoc__Junodoc_Setting__c();
        s.JunoDoc__Site_URL__c='test';
        insert s;
        
        JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;
        
        Blob bodyblob = Blob.valueOf('test file');
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        string conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        list<string> acclist = new list<string>();
       string a1 = 'test1';
        acclist.add(a1);
        string a2 = 'test1';
        acclist.add(a2);
        
        ApexPages.currentPage().getParameters().put('docidList', cv.id);
        ApexPages.currentPage().getParameters().put('recordId',con.Id);
        ApexPages.currentPage().getParameters().put('receiverList',reclist);
        ApexPages.currentPage().getParameters().put('id', conDocId);
        ApexPages.currentPage().getParameters().put('isInPerson', 'true');
        ApexPages.currentPage().getParameters().put('showAttachmentSetting', 'false');
        ApexPages.currentPage().getParameters().put('refobj', refobj.id);
        ApexPages.currentPage().getParameters().put('showattachment', 'false');
        JunoPrepareandSend Juno = new JunoPrepareandSend();
        Juno.getpositionsTabs();
        Juno.pageReferencecall();
        
    }
}
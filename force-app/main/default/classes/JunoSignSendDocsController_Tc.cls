@isTest
global class JunoSignSendDocsController_Tc{
    global static testMethod void testClass() { 
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
        tem.Parent_Object__c = con.Id;
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem;
        
 
        Blob bodyblob = Blob.valueOf('UNIT.TEST');
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        
        
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        List<Id> docidlist=new List<Id>();
        docidlist.add(conDocId);
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        JunoDoc__Juno_Sign_Recipient__c rec = new JunoDoc__Juno_Sign_Recipient__c();
        //rec.OwnerId='';
        rec.JunoDoc__Recipient_Name__c='JRN-00140';
        rec.JunoDoc__Recipient_Email__c='goutham.devavarapu@diligentforcelabs.com';
        rec.JunoDoc__Status__c='Signed';
        rec.JunoDoc__Sort_Order__c=1;
        insert rec;
       
        JunoDoc__Junosign_Object_Setting__c juno = new JunoDoc__Junosign_Object_Setting__c(); 
        //juno.Selected_object__c='Contact';
        juno.JunoDoc__Junodoc_Default_Template__c = tem.Id;     
        juno.JunoDoc__Selected_object__c = 'Contact';
        juno.JunoDoc__Set_Reply_To_Value__c = 'testcon@gmail.com';
        insert juno;
         
         JunoDoc__Email_Details__c jemail = new JunoDoc__Email_Details__c();
         jemail.JunoDoc__To_Value__c='To';
         jemail.JunoDoc__Text_Ref_Value__c= '';
         jemail.JunoDoc__field_Details__c='Email';
         jemail.JunoDoc__Name__c = 'Test';
         jemail.JunoDoc__Email__c='Test@gmail.com';
         jemail.JunoDoc__Junosign_Object_Setting__c=juno.id;
         insert jemail;
        
        JunoDoc__Email_Details__c jemail1 = new JunoDoc__Email_Details__c();
         jemail1.JunoDoc__To_Value__c='To';
         jemail1.JunoDoc__Text_Ref_Value__c= '';
         jemail1.JunoDoc__field_Details__c='Contact.Owner.Email';
         jemail1.JunoDoc__Name__c = 'Test';
         jemail1.JunoDoc__Email__c='Test@gmail.com';
         jemail1.JunoDoc__Junosign_Object_Setting__c=juno.id;
         insert jemail1;  
        
        JunoDoc__Email_Details__c jemail2 = new JunoDoc__Email_Details__c();
         jemail2.JunoDoc__To_Value__c='To';
         jemail2.JunoDoc__Text_Ref_Value__c= '';
         jemail2.JunoDoc__field_Details__c='Contact.Account.Owner.Email';
         jemail2.JunoDoc__Name__c = 'Test';
         jemail2.JunoDoc__Email__c='Test@gmail.com';
         jemail2.JunoDoc__Junosign_Object_Setting__c=juno.id;
         insert jemail2; 
        
         JunoDoc__Email_Details__c jemail3 = new JunoDoc__Email_Details__c();
         jemail3.JunoDoc__To_Value__c='To';
         jemail3.JunoDoc__Text_Ref_Value__c= 'Text';
         jemail3.JunoDoc__field_Details__c='Email';
         jemail3.JunoDoc__Name__c = 'Test';
         jemail3.JunoDoc__Email__c='Test@gmail.com';
         jemail3.JunoDoc__Junosign_Object_Setting__c=juno.id;
         insert jemail3;
        
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

         JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        
        insert at;
        
         JunoDoc__Email_Template__c JET2 = new JunoDoc__Email_Template__c();
        JET2.JunoDoc__Parent_Object__c = 'Account';
        JET2.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET2.JunoDoc__Number_Format__c = '.00';
        JET2.JunoDoc__Currency_Format__c = '.00';
        JET2.JunoDoc__Currency_Symbol__c = '$';
        JET2.Junodoc__Date_Format__c = 'dd-MM-yyyy';

        JET2.Name = 'Test';
        insert JET2;
        
        
        list<JunoSignSendDocsController.FilesInner> JunoInners = new list<JunoSignSendDocsController.FilesInner>();
        JunoSignSendDocsController.FilesInner JunoInner = new JunoSignSendDocsController.FilesInner();
        JunoInner.name = 'test';
        JunoInner.fileContents = conDocId;
        JunoInners.add(JunoInner);
        
        list<JunoSignSendDocsController.LookUpInner> JunoLookUpInners = new list<JunoSignSendDocsController.LookUpInner>();
        JunoSignSendDocsController.LookUpInner JunoLookUpInner = new JunoSignSendDocsController.LookUpInner();
        JunoLookUpInner.Name = 'test';
        JunoLookUpInner.Message = 'Error';
        JunoLookUpInner.Mail = 'test@gmail.com';
        JunoLookUpInners.add(JunoLookUpInner);
        
        list<JunoSignSendDocsController.emailListWrap> JunoemailLists = new list<JunoSignSendDocsController.emailListWrap>();
        JunoSignSendDocsController.emailListWrap JunoemailList = new JunoSignSendDocsController.emailListWrap();
        JunoemailList.lable = 'test';
        JunoemailList.value = 'test';
        JunoemailLists.add(JunoemailList);
        
        list<Junodoc_Setting__c> JunoSettings = new list<Junodoc_Setting__c>();
        Junodoc_Setting__c JunoSetting = new Junodoc_Setting__c();
        JunoSetting.JunoDoc__JunoSign_Default_From_Address__c = 'test@gmail.com';
        JunoSettings.add(JunoSetting);
        insert JunoSettings;
        
        JunoDoc__Doc_Template__c tem10 = new JunoDoc__Doc_Template__c();
        tem10.Name = 'Sequential test';
        tem10.JunoDoc__Template_Type__c='PDF';
        string generate1 = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        insert tem10;
        
         List<JunoDoc__Junosign_Object_Setting__c> junolist = New List<JunoDoc__Junosign_Object_Setting__c>();
         JunoDoc__Junosign_Object_Setting__c juno1 = new JunoDoc__Junosign_Object_Setting__c(); 
        //juno.Selected_object__c='Contact';
        juno1.JunoDoc__Junodoc_Default_Template__c = tem.Id;     
        juno1.JunoDoc__Selected_object__c = 'JunoDoc__Audit_Trail__c';
        junolist.add(juno1);
        insert junolist;
        
       

       List<string> emailist=new List<String>();
        JunoSignSendDocsController.ObjectClass obj= new JunoSignSendDocsController.ObjectClass();
        obj.Name = 'test';
        JunoSignSendDocsController jsdc = new JunoSignSendDocsController();
        JunoSignSendDocsController.sendDocEnv(cv.Id,docidlist, emailist,emailist, tem.Id);
        JunoSignSendDocsController.getDocuments(con.Id);
        JunoSignSendDocsController.getAvailableDocTemplates(tem.Id);
        JunoSignSendDocsController.getCurrentObjectDetails(con.Id);
        JunoSignSendDocsController.getDefaultEmailListFromJunoObjectSettings(con.Id);
        JunoSignSendDocsController.getDefaultDoctemplate(Con.Id);
        JunoSignSendDocsController.shouldCheckDigit = true;
        //jsdc.sendDocEnv(recordId, SelectedDoc, emailList, recipentNameList, DocTemplateId);
        JunoSignSendDocsController.GetSecLevelFieldDetailscontroller('JunoDoc__Email_Template__c', 'FirstName', 'LastName');
        JunoSignSendDocsController.getObjectLabelName(at.Id);
        JunoSignSendDocsController.getinitialObjectFields(at.Id);
        JunoSignSendDocsController.getClassicEmailTemplates();
       
        JunoSignSendDocsController.GetFieldDetails('JunoDoc__Audit_Trail__c', 'JunoDoc__Email_Subject__c');
        JunoSignSendDocsController.GetEmailFieldValue(con.id, 'Email', True, 'OwnerId.Email');
        JunoSignSendDocsController.GetEmailFieldValue(con.id, 'Email', True, 'AccountId.OwnerId.Email');
       JunoSignSendDocsController.GetEmailFieldValue(con.id, 'Email', True, 'Contact.Account.owner.Email');
        JunoSignSendDocsController.getAllObjectFields('Contact');
        JunoSignSendDocsController.GetThirdLevelFieldDetails('PBSI__PBSI_Purchase_Order__c','PBSI__Delivery_Account__c','Billing_Contact__c','Email');
        JunoSignSendDocsController.GetFinalLevelFieldDetails('PBSI__PBSI_Purchase_Order__c','PBSI__Company_Account__r','ParentId','Billing_Contact__c','Email');
        JunoSignSendDocsController.orgwideEmail();
        JunoSignSendDocsController.getFinalObjectFields('TestAccount');
         JunoSignSendDocsController.getFinalObjectFields('Contact');
        JunoSignSendDocsController.getConUserRec('Contact','');
        JunoSignSendDocsController.getObjectAPIName(at.Id);
        JunoSignSendDocsController.getLookUpMail(at.Id,'JunoDoc__Audit_Trail__c.JunoDoc__JunoSign_Transaction__r.Owner.Email');
        JunoSignSendDocsController.deleteUploadedFiles(JSON.serialize(JunoInners));
        JunoSignSendDocsController.SaveFromEmailAddress(at.Id, 'test@gmail.com');
        JunoSignSendDocsController.getFromEmailAddress();
         JunoSignSendDocsController.getObjectFields(acc.id);   
        JunoSignSendDocsController.getEnableAttachmentSetting();
        JunoSignSendDocsController.getSetReplyTo(con.id);
        JunoSignSendDocsController.getAccountFieldValue();
        //JunoSignSendDocsController.orgwideEmail();
        //JunoSignSendDocsController.GetCurrencyvalues('3');
        JunoSignSendDocsController.doFormatting(1.0, 3, 'test', 'nov');
      //  JunoSignSendDocsController.GetNumbervalues('678');
             
    }
    private static testMethod void testClass1() { 
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
        
 
        Blob bodyblob = Blob.valueOf('UNIT.TEST');
        
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'sampletitle';
        cv.PathOnClient = 'sampletitle.jpg';
        cv.VersionData = bodyblob;
        cv.Origin = 'H';
        insert cv;
        List<JunoDoc__Junosign_Object_Setting__c> junolist = New List<JunoDoc__Junosign_Object_Setting__c>();
         JunoDoc__Junosign_Object_Setting__c juno = new JunoDoc__Junosign_Object_Setting__c(); 
        //juno.Selected_object__c='Contact';
        juno.JunoDoc__Junodoc_Default_Template__c = tem.Id;     
        juno.JunoDoc__Selected_object__c = 'JunoDoc__Audit_Trail__c';
        junolist.add(juno);
        insert junolist;
        
        
         JunoDoc__Email_Details__c jemail2 = new JunoDoc__Email_Details__c();
         jemail2.JunoDoc__To_Value__c='To';
         jemail2.JunoDoc__Text_Ref_Value__c= '';
         jemail2.JunoDoc__field_Details__c='Contact.Account.Owner.Email';
         jemail2.JunoDoc__Name__c = 'Test';
         jemail2.JunoDoc__Email__c='Test@gmail.com';
         jemail2.JunoDoc__Junosign_Object_Setting__c=junolist[0].id;
         insert jemail2; 
        
         JunoDoc__Email_Details__c jemail3 = new JunoDoc__Email_Details__c();
         jemail3.JunoDoc__To_Value__c='To';
         jemail3.JunoDoc__Text_Ref_Value__c= 'Text';
         jemail3.JunoDoc__field_Details__c='Email';
         jemail3.JunoDoc__Name__c = 'Test';
         jemail3.JunoDoc__Email__c='Test@gmail.com';
         jemail3.JunoDoc__Junosign_Object_Setting__c= junolist[0].id;
         insert jemail3;
        
        
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        List<Id> docidlist=new List<Id>();
        docidlist.add(conDocId);
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
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

         JunoDoc__Audit_Trail__c at= new JunoDoc__Audit_Trail__c();
        at.Name=rec.JunoDoc__Recipient_Name__c;
        at.JunoDoc__Status__c='Pending';
        at.JunoDoc__IP_Address__c='103.49.54.114';
        at.JunoDoc__Date__c=System.today();
        at.JunoDoc__JunoSign_Transaction__c=tr.Id;
        insert at;


         JunoDoc__Junosign_Object_Setting__c juno2 = new JunoDoc__Junosign_Object_Setting__c(); 
        //juno.Selected_object__c='Contact';
        juno2.JunoDoc__Junodoc_Default_Template__c = tem.Id;     
        juno2.JunoDoc__Selected_object__c = 'Account';
        insert juno2;
        
        
       List<string> emailist=new List<String>();
        JunoSignSendDocsController jsdc = new JunoSignSendDocsController();
        JunoSignSendDocsController.sendDocEnv(cv.Id,docidlist, emailist,emailist, tem.Id);
        JunoSignSendDocsController.getDocuments(acc.Id);
        JunoSignSendDocsController.getAvailableDocTemplates(tem.Id);
        JunoSignSendDocsController.getCurrentObjectDetails(acc.Id);
        JunoSignSendDocsController.getDefaultEmailListFromJunoObjectSettings(acc.Id);
        JunoSignSendDocsController.getDefaultDoctemplate(acc.Id);
        JunoSignSendDocsController.generateEmailTemplateValuesEmail(acc.Id,tem.Id);
        //jsdc.sendDocEnv(recordId, SelectedDoc, emailList, recipentNameList, DocTemplateId);
        JunoSignSendDocsController.GetSecLevelFieldDetailscontroller('JunoDoc__Junosign_Object_Setting__c', 'FirstName', 'LastName');
        JunoSignSendDocsController.getObjectLabelName(at.Id);
        JunoSignSendDocsController.getinitialObjectFields(at.Id);
        JunoSignSendDocsController.GetFieldDetails('JunoDoc__Audit_Trail__c', 'JunoDoc__Email_Subject__c');
        JunoSignSendDocsController.GetEmailFieldValue(con.id, 'Email', false, 'Account.ownerId.Email');
        JunoSignSendDocsController.GetEmailFieldValue(con.id, 'Email', true, 'Account.JunoDoc__Doc_Template__c.ownerId.Email');
        JunoSignSendDocsController.getContactName(con.id);
        JunoSignSendDocsController.getEmail();
        JunoSignSendDocsController.fetchContact(con.id);
        JunoSignSendDocsController.getAllObjectFields('Account');
        JunoSignSendDocsController.getAllObjectFields('Accountest');
        JunoSignSendDocsController.getObjectFields(acc.id);   
        JunoSignSendDocsController.getLookUpMail(at.Id,'JunoDoc__Audit_Trail__c.Owner.Email');
              //  JunoSignSendDocsController.GetCurrencyvalues('3');
        JunoSignSendDocsController.doFormatting(1.0, 3, 'test', 'nov');
      //  JunoSignSendDocsController.GetNumbervalues('678');
          

        
    }
    private static testmethod void testclass2(){
        Account acc2 = new Account();
        acc2.name = 'test';
        acc2.AnnualRevenue = 100;
        acc2.NumberOfEmployees = 100;
        insert acc2;
        
        contact con2 = new contact();
        con2.lastname='test';
        con2.firstname='test1';
        con2.email='test@gmail.com';
        con2.AccountId = acc2.Id;
        insert con2;
        
        opportunity opp = new opportunity();
        opp.name = 'test_opp';
        opp.ContactId = con2.id;
        opp.AccountId = acc2.id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today()+30;
        opp.TotalOpportunityQuantity = 100;
        insert opp;
        
        Account quo = new Account(
        Name = 'Test Company XYZ',
        AnnualRevenue = 1250000.75,           // NUMBER / CURRENCY
       // BillingLatitude = 16.5062,             // to test NUMBER
        Description = 'This is a test account',
        NumberOfEmployees = 42           // INTEGE
    );
    insert quo;
        list< JunoDoc__Junodoc_Currency__c> JunoCurrencylist  = new  List<JunoDoc__Junodoc_Currency__c>();
        JunoDoc__Junodoc_Currency__c JunoCurrency = new JunoDoc__Junodoc_Currency__c();
        JunoCurrency.Name = 'test';
        JunoCurrency.JunoDoc__Currency_Code__c = 'USD';
        JunoCurrency.JunoDoc__Currency_Symbol__c = '$';
        JunoCurrencylist.add(JunoCurrency);
        insert JunoCurrencylist;
        
        JunoDoc__Doc_Template__c Doc = new JunoDoc__Doc_Template__c();
        Doc.JunoDoc__Show_Page_Number__c = false;
        Doc.Name = 'test';
        Doc.JunoDoc__Parent_Object__c = 'Account';
        Doc.JunoDoc__Parent_Fields__c = 'Name';
        insert Doc;
       
        JunoDoc__Email_Template__c JET = new JunoDoc__Email_Template__c();
        JET.JunoDoc__Parent_Object__c = 'Account';
        JET.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET.JunoDoc__Number_Format__c = ',00';
        JET.JunoDoc__Currency_Format__c = ',00';
       // JET.JunoDoc__Currency_Symbol__c = '$';
        JET.Junodoc__Date_Format__c = 'dd-MM-yyyy';
        JET.Name = 'Test';
        insert JET;
        
      
        JunoDoc__Email_Template_Item__c JETI = new JunoDoc__Email_Template_Item__c(
        JunoDoc__Email_Template__c = JET.Id,
            JunoDoc__Subject__c = 'Review documents for {!Name} {!Owner.Name} {!Owner.LastName} {!Owner.FirstName} {!Owner.CreatedBy.LastName} - {!TODAY()} - {!#User.Name}',
        JunoDoc__Template_Body__c = String.join(new List<String>{
            '<h2>Account: {!Name} {!Owner.Name}</h2>',
            '<p>Revenue: {!AnnualRevenue} | Currency: </p>',  // test currency
            '<p>Employees: {!NumberOfEmployees}</p>',
            '<p>Created Date: {!CreatedDate}</p>',
            '<p>Checkbox example: </p>',           // add real boolean field if exists
            '{URL}'                                                        // test URL placeholder
        }, '\n')
    );
    insert JETI;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs.JunoDoc__Selected_object__c = 'Account';
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET.Id;
        JunoObs.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET.Id;
        insert JunoObs;
        
        JunoSignSendDocsController.doFormatting(0, 3, 'test', 'nov');
        
        JunoSignSendDocsController.generateEmailTemplateValues(quo.Id);
        JunoSignSendDocsController.getAvailableDocTemplates(quo.Id);
        JunoSignSendDocsController.getDefaultDoctemplate(JunoObs.Id);
        JunoSignSendDocsController.getBarcodes('Test');
        JunoSignSendDocsController.getchilType('Contact','Account');
        JunoSignSendDocsController.getRelType('Contact','Account','Name');
                JunoSignSendDocsController.GetCurrencyvalues('30');
                    JunoSignSendDocsController.GetCurrencyvalues('.0');
        
        JunoSignSendDocsController.NumberFormat = '0,00';
        JunoSignSendDocsController.NumberFormat = '0.00';
        JunoSignSendDocsController.NumberFormat = 'Plain';
       // JunoSignSendDocsController.GetNumbervalues('6.780');
        JunoSignSendDocsController.GetCurrencyvalues(null);
        
        JunoDoc__Email_Template__c JET2 = new JunoDoc__Email_Template__c();
        JET2.JunoDoc__Parent_Object__c = 'Account';
        JET2.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        JET2.JunoDoc__Number_Format__c = '.00';
        JET2.JunoDoc__Currency_Format__c = '.00';
        JET2.JunoDoc__Currency_Symbol__c = '$';
        JET2.Junodoc__Date_Format__c = 'dd-MM-yyyy';

        JET2.Name = 'Test';
        insert JET2;
        
        JunoDoc__Email_Template_Item__c JETI2 = new JunoDoc__Email_Template_Item__c();
        JETI2.JunoDoc__Subject__c = 'Test{URL}test{!TODAY()} {!NOW()}{!Name} {!#User.Signature}{!Owner.IsActive}{!owner.Name}{!AnnualRevenue}';
        JETI2.JunoDoc__Template_Body__c = 'Test{URL}test{!TODAY()} {!NOW()} {!Name}{!#User.Signature}{!Owner.IsActive}{!owner.Name}{!AnnualRevenue}';
       // JETI.JunoDoc__Template_Body__c = '{URL}test{!TODAY()} {!NOW()} {!#User.Signature}{!Contact.Email} {!Email} {!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate}{!opportunity.Account.owner.Name} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        //JETI.JunoDoc__Subject__c = 'test{!TODAY()} {!NOW()} {!#User.Signature} {!Email} {!Contact.Email}{!Contact.Name}{!Contact.Account.Name}{!Contact.Account.Owner.IsActive}{!opportunity.CloseDate}{!opportunity.Account.owner.Name} {!opportunity.IsClosed}{!opportunity.TotalOpportunityQuantity}{!Account.AnnualRevenue}';
        JETI2.JunoDoc__Email_Template__c = JET2.Id;
       // JETI2.JunoDoc__Currency_Symbol__c = '$';
        insert JETI2;
        
        JunoDoc__Junosign_Object_Setting__c JunoObs2 = new JunoDoc__Junosign_Object_Setting__c();
        JunoObs2.JunoDoc__Selected_object__c = 'Account';
        JunoObs2.JunoDoc__Junodoc_Default_EmailTemplate__c = JET2.Id;
        JunoObs2.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = JET2.Id;
        JunoObs2.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = JET2.Id;
        insert JunoObs2;

        List<JunoSignSendDocsController.PostActionRecords> postActionList = new List<JunoSignSendDocsController.PostActionRecords>();
        JunoSignSendDocsController.PostActionRecords act1 = new JunoSignSendDocsController.PostActionRecords();
        act1.fieldName  = 'Name';
        act1.fieldValue = 'Test';
        postActionList.add(act1);
        
        JunoSignSendDocsController.GetCurrencyvalues('300.00');
        JunoSignSendDocsController.GetNumbervalues('678.00');
        JunoSignSendDocsController.doFormatting(0, 0, '', '');
        JunoSignSendDocsController.getObjectFields(acc2.id);        
        JunoSignSendDocsController.GetSecLevelFieldDetailscontroller('JunoDoc__Email_Template_Item__c', 'AccountId', 'OwnerId');
        JunoSignSendDocsController.GetSecLevelFieldDetailscontroller('Contact', 'JunoDoc__Doc_Sent__c', 'JunoDoc__Doc_Sent__c');
        JunoSignSendDocsController.getRecordName(JETI2.Id);
        JunoSignSendDocsController.performImmediateUpdate(JET.Id,JSON.serialize(postActionList));
        
        JunoSignSendDocsController.DefaultEmailList emaillist = new JunoSignSendDocsController.DefaultEmailList();
        emaillist.Email = 'test';
        emaillist.EmailType = 'test';
        emaillist.ispostChecked = true;
        emaillist.Name = 'test';
        
    }
    
}
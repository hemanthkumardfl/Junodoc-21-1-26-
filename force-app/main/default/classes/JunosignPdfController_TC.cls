@IsTest
private class JunosignPdfController_TC {

    @TestSetup
    static void setupTestData() {
        // Create custom setting if needed
        Junodoc_Setting__c setting = new Junodoc_Setting__c(
            Enable_To_Send_Email__c = true
        );
        insert setting;

        // Create test Document (for logo)
        Document logoDoc = new Document(
            Name = 'Junosign_logo',
            DeveloperName = 'Junosign_logo',
            Body = Blob.valueOf('fake logo'),
            ContentType = 'image/png',
            FolderId = UserInfo.getUserId()
        );
        insert logoDoc;

        // Create test ContentVersion (simulating uploaded PDF)
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document.pdf',
            PathOnClient = 'Test Document.pdf',
            VersionData = Blob.valueOf('%PDF-1. test pdf content'),
            IsMajorVersion = true
        );
        insert cv;

        // Re-query to get ContentDocumentId
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        // Create test record (using Account as example parent object)
        Account testAcc = new Account(Name = 'Test Signing Account');
        insert testAcc;

        // Create Juno_Sign_Transaction__c
        JunoDoc__Juno_Sign_Transaction__c trans = new JunoDoc__Juno_Sign_Transaction__c(
            JunoDoc__Object_Id__c = testAcc.Id,
            JunoDoc__Status__c = 'Completed',
            JunoDoc__Sender_Name__c = 'Test Sender',
            JunoDoc__Sender_Email__c = 'sender@example.com',
            JunoDoc__CC_Address__c = 'cc@example.com',
            JunoDoc__BCC_Address__c = 'bcc@example.com'
        );
        insert trans;

        // Create Recipient
        JunoDoc__Juno_Sign_Recipient__c recipient = new JunoDoc__Juno_Sign_Recipient__c(
            JunoDoc__Juno_Sign_Transaction__c = trans.Id,
            JunoDoc__Recipient_Name__c = 'Test Signer',
            JunoDoc__Recipient_Email__c = 'signer@example.test',
            JunoDoc__Status__c = 'Pending',
            JunoDoc__Sort_Order__c = 1,
            JunoDoc__JunoSign_Expiration_Date__c = Date.today().addDays(7)
        );
        insert recipient;

        JunoDoc__Juno_Sign_Recipient__c recipient2 = new JunoDoc__Juno_Sign_Recipient__c(
            JunoDoc__Juno_Sign_Transaction__c = trans.Id,
            JunoDoc__Recipient_Name__c = 'Test Signer',
            JunoDoc__Recipient_Email__c = 'signer@example.test',
            JunoDoc__Status__c = 'Not Sent',
            JunoDoc__Sort_Order__c = 1,
            JunoDoc__JunoSign_Expiration_Date__c = Date.today().addDays(7)
        );
        insert recipient2;

        // Create some page tabs
        JunoDoc__Junodoc_Page_Tab__c tab1 = new JunoDoc__Junodoc_Page_Tab__c(
            JunoDoc__Linked_To__c = trans.Id,
            JunoDoc__Recipient_Sort_Order__c = 1,
            JunoDoc__Type__c = 'Signature',
            JunoDoc__Pos_Left__c = '100',
            JunoDoc__Pos_Top__c = '200',
            JunoDoc__Page_Height__c = '842',
            JunoDoc__Page_Width__c = '595',
            JunoDoc__Sign_Completed__c = false
        );
        insert tab1;

        Doc_Template__c temp = new Doc_Template__c();
        temp.Name = 'test';
        temp.Parent_Object__c = 'Contact';
        temp.Parent_Fields__c = 'LastName';
        temp.JunoDoc__Show_Templates__c = false;
        insert temp;
                
        JunoDoc__Email_Template__c jemailtemplate = new JunoDoc__Email_Template__c();
        jemailtemplate.Name='testtemplate';
        jemailtemplate.JunoDoc__Parent_Object__c='Account';
        jemailtemplate.JunoDoc__Parent_Fields__c='Name';
        jemailtemplate.JunoDoc__Blank_Fields_As_Zeroes__c = true;
        jemailtemplate.JunoDoc__Number_Format__c = '.00';
        jemailtemplate.JunoDoc__Currency_Format__c = '.00';
        jemailtemplate.JunoDoc__Currency_Symbol__c = '';
        jemailtemplate.Junodoc__Date_Format__c = 'dd-MM-yyyy';
        insert jemailtemplate;
        
        JunoDoc__Junosign_Object_Setting__c juno = new JunoDoc__Junosign_Object_Setting__c(); 
        juno.Selected_object__c='Account';
        juno.JunoDoc__Junodoc_Default_EmailTemplate__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Doc_Template__c = temp.Id;
        insert juno;
        
        JunoDoc__Email_Template_Item__c EmItem = new JunoDoc__Email_Template_Item__c();
        EmItem.JunoDoc__Email_Template__c = jemailtemplate.Id;
        EmItem.JunoDoc__Subject__c = 'Test----{!Name} {!NOW()} {!#User.Name}';
        EmItem.JunoDoc__Template_Body__c = '{!Name} {!TODAY()} {!NOW()} {!#User.Name}';
        insert EmItem;
    }

    // -------------------------------------------------------------------------
    //   Test getPDFById - template path
    // -------------------------------------------------------------------------
    @IsTest
    static void test_getPDFById_TemplatePath() {

        JunoDoc__Juno_Sign_Recipient__c rec = [
            SELECT Id, JunoDoc__Juno_Sign_Transaction__c
            FROM JunoDoc__Juno_Sign_Recipient__c
            WHERE JunoDoc__Status__c = 'Pending'
            LIMIT 1
        ];

        JunoDoc__Doc_Template__c template = new JunoDoc__Doc_Template__c(
            Name = 'Test Template'
        );
        insert template;

        Test.startTest();
        String base64 = JunosignPdfController.getPDFById(
            template.Id,
            '001xxxxxxxxxxxxxxx',   // fake conId (won't be used in template path)
            rec.Id
        );
        Test.stopTest();

        System.assertNotEquals(null, base64, 'Should return base64 string');
      //  System.assert(base64.length() > 20, 'Should be valid base64 content');
    }

    // -------------------------------------------------------------------------
    //   Test getPDFById - ContentVersion path + expiration check
    // -------------------------------------------------------------------------
    @IsTest
    static void test_getPDFById_ContentVersion_Expired() {

        JunoDoc__Juno_Sign_Recipient__c rec = [
            SELECT Id, JunoDoc__Juno_Sign_Transaction__c,
                   JunoDoc__JunoSign_Expiration_Date__c
            FROM JunoDoc__Juno_Sign_Recipient__c
            WHERE JunoDoc__Status__c = 'Pending'
            LIMIT 1
        ];

        // Make it expired
        rec.JunoDoc__JunoSign_Expiration_Date__c = Date.today().addDays(-2);
        update rec;

        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];

        Test.startTest();
        String base64 = JunosignPdfController.getPDFById(
            cv.ContentDocumentId,
            '001xxxxxxxxxxxxxxx',
            rec.Id
        );
        Test.stopTest();

        JunoDoc__Juno_Sign_Recipient__c updatedRec = [
            SELECT JunoDoc__Status__c
            FROM JunoDoc__Juno_Sign_Recipient__c
            WHERE Id = :rec.Id
        ];

        System.assertEquals('Expired', updatedRec.JunoDoc__Status__c);
        System.assertNotEquals(null, base64);
    }

    // -------------------------------------------------------------------------
    //   Test getPageTabs
    // -------------------------------------------------------------------------
    @IsTest
    static void test_getPageTabs() {

        JunoDoc__Juno_Sign_Recipient__c rec = [SELECT Id FROM JunoDoc__Juno_Sign_Recipient__c LIMIT 1];

        // Controller needs these parameters
        ApexPages.currentPage().getParameters().put('recid', rec.Id);

        JunosignPdfController ctrl = new JunosignPdfController();

        Test.startTest();
        ctrl.getPageTabs();
        String jsonTabs = ctrl.pageTabsstring;
        Test.stopTest();

        System.assertNotEquals(null, jsonTabs);
      //  System.assert(jsonTabs.contains('"type":"Signature"'), 'Should contain page tab data');
    }

    // -------------------------------------------------------------------------
    //   Test savePDFToSalesforce - happy path (one signer → completed)
    // -------------------------------------------------------------------------
    @IsTest
    static void test_savePDFToSalesforce_SingleSigner() {

        JunoDoc__Juno_Sign_Recipient__c rec = [
            SELECT Id, JunoDoc__Juno_Sign_Transaction__c,
                   JunoDoc__Recipient_Name__c, JunoDoc__Recipient_Email__c
            FROM JunoDoc__Juno_Sign_Recipient__c 
            WHERE JunoDoc__Status__c = 'Pending'
            LIMIT 1
        ];

        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        Account acc = [SELECT Id From Account LIMIT 1];

        String fakeBase64 = EncodingUtil.base64Encode(Blob.valueOf('%PDF- fake signed document'));

        List<String> completedTabIds = new List<String>(); // empty → no tabs to update
        for(JunoDoc__Junodoc_Page_Tab__c tab : [SELECT Id FROM JunoDoc__Junodoc_Page_Tab__c]){
            completedTabIds.add(tab.Id);
        }

        Test.startTest();
        String result = JunosignPdfController.savePDFToSalesforce(
            'Signed_Test_Document',
            'data:application/pdf;base64,' + fakeBase64,
            rec.Id,
            acc.Id,
            // cv.ContentDocumentId,   // using as conId
            completedTabIds
        );
        Test.stopTest();

        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(result);
       // System.assertEquals('success', resp.get('status'));
    }

    @IsTest
    static void test_savePDFToSalesforce_SingleSigner2() {

        JunoDoc__Juno_Sign_Recipient__c rec = [
            SELECT Id, JunoDoc__Juno_Sign_Transaction__c,
                   JunoDoc__Recipient_Name__c, JunoDoc__Recipient_Email__c
            FROM JunoDoc__Juno_Sign_Recipient__c 
            WHERE JunoDoc__Status__c = 'Not Sent'
            LIMIT 1
        ];

        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];
        Account acc = [SELECT Id From Account LIMIT 1];

        String fakeBase64 = EncodingUtil.base64Encode(Blob.valueOf('%PDF- fake signed document'));

        List<String> completedTabIds = new List<String>(); // empty → no tabs to update
        for(JunoDoc__Junodoc_Page_Tab__c tab : [SELECT Id FROM JunoDoc__Junodoc_Page_Tab__c]){
            completedTabIds.add(tab.Id);
        }

        Test.startTest();
        String result = JunosignPdfController.savePDFToSalesforce(
            'Signed_Test_Document',
            'data:application/pdf;base64,' + fakeBase64,
            rec.Id,
            acc.Id,
            // cv.ContentDocumentId,   // using as conId
            completedTabIds
        );
        Test.stopTest();

        Map<String, Object> resp = (Map<String, Object>) JSON.deserializeUntyped(result);
       // System.assertEquals('success', resp.get('status'));
    }

    // -------------------------------------------------------------------------
    //   Test rejectDocument
    // -------------------------------------------------------------------------
    @IsTest
    static void test_rejectDocument() {

        JunoDoc__Juno_Sign_Recipient__c rec = [SELECT Id FROM JunoDoc__Juno_Sign_Recipient__c LIMIT 1];
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1];

        Test.startTest();
        String msg = JunosignPdfController.rejectDocument(
            cv.ContentDocumentId,    // fake templateId / doc id
            cv.ContentDocumentId,    // conId
            rec.Id
        );
        Test.stopTest();

        System.assertEquals('Document rejected successfully', msg);

        JunoDoc__Juno_Sign_Recipient__c updated = [
            SELECT JunoDoc__Status__c
            FROM JunoDoc__Juno_Sign_Recipient__c
            WHERE Id = :rec.Id
        ];
        System.assertEquals('Rejected', updated.JunoDoc__Status__c);
    }
}
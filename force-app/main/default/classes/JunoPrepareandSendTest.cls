@isTest
private class JunoPrepareandSendTest {
    
    // Setup method to create test data
    @TestSetup
    static void setupTestData() {
        // Create a test Document for logo
        Document doc = new Document();
        doc.Name = 'Junosign_logo';
        doc.DeveloperName = 'Junosign_logo';
        doc.FolderId = UserInfo.getUserId();
        insert doc;
        
        // Create a test JunoDoc__Junodoc_Setting__c record
        JunoDoc__Junodoc_Setting__c setting = new JunoDoc__Junodoc_Setting__c(
            JunoDoc__Site_URL__c = 'https://testsite.com',
            JunoDoc__JunoSign_Default_From_Address__c = 'test@junodoc.com',
            JunoDoc__Enable_JunoSign__c = true
        );
        insert setting;
        
        // Create a test Account record
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create a test JunoDoc__Doc_Template__c record
        JunoDoc__Doc_Template__c docTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Test Template'
        );
        insert docTemplate;
        
        // Create a test ContentVersion for file attachment
        ContentVersion cv = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test Content'),
            ContentLocation = 'S'
        );
        insert cv;
        
        // Create a ContentDocumentLink
        ContentDocument cd = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = acc.Id,
            ContentDocumentId = cd.Id,
            ShareType = 'I',
            Visibility = 'AllUsers'
        );
        insert cdl;
        
        // Create a JunoDoc__Junosign_Object_Setting__c record
        JunoDoc__Junosign_Object_Setting__c objSetting = new JunoDoc__Junosign_Object_Setting__c(
            JunoDoc__Selected_object__c = 'Account',
            JunoDoc__FromEmailAddress__c = 'test@junodoc.com'
        );
        insert objSetting;
        
        // Create a test Email Template
       /* EmailTemplate emailTemplate = new EmailTemplate(
            DeveloperName = 'Junosign_Email_Template1',
            Name = 'Junosign Email Template',
            TemplateType = 'custom',
            FolderId = UserInfo.getOrganizationId(),
            Subject = 'Test Subject',
            HtmlValue = '<p>Test {Name}, {ExpirationDate}, {URL}, {Description}, {logoURL}</p>',
            IsActive = true
        );
        insert emailTemplate;*/
        
        // Create a JunoDoc__Email_Template__c record
        JunoDoc__Email_Template__c junoEmailTemplate = new JunoDoc__Email_Template__c(
            JunoDoc__Junodoc_generated_template_body__c = '<p>Test {Name}, {ExpirationDate}, {URL}, {Description}, {logoURL}</p>',
            JunoDoc__Junodoc_generated_template_subject__c = 'Test Subject'
        );
        insert junoEmailTemplate;
        
        // Update object setting with email template
        objSetting.JunoDoc__Junodoc_Default_EmailTemplate__c = junoEmailTemplate.Id;
        update objSetting;
    }
    
    @isTest
    static void testConstructor() {
        // Set page parameters
        ApexPages.currentPage().getParameters().put('docList', 'a0A000000000001');
        ApexPages.currentPage().getParameters().put('docidList', '069000000000001');
        ApexPages.currentPage().getParameters().put('FileList', '[]');
        ApexPages.currentPage().getParameters().put('receiverList', 'test@junodoc.com');
        ApexPages.currentPage().getParameters().put('TransactionIds', 'a0B000000000001');
        ApexPages.currentPage().getParameters().put('recordId', [SELECT Id FROM Account LIMIT 1].Id);
        ApexPages.currentPage().getParameters().put('isInPerson', 'false');
        ApexPages.currentPage().getParameters().put('showattachment', 'true');
        ApexPages.currentPage().getParameters().put('SetReplyTo', 'reply@junodoc.com');
        ApexPages.currentPage().getParameters().put('insertedIds', '["003000000000001"]');
        
        // Instantiate the class
        Test.startTest();
        JunoPrepareandSend juno = new JunoPrepareandSend();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, juno.docList, 'docList should be set from page parameters');
        System.assertNotEquals(null, juno.docidList, 'docidList should be set from page parameters');
        System.assertEquals(false, juno.isInPerson, 'isInPerson should be false');
        System.assertEquals(true, juno.showattachment, 'showattachment should be true');
        System.assertNotEquals(null, juno.logoUrl, 'logoUrl should be generated');
        System.assertEquals('Account', juno.sObjName, 'sObjName should be Account');
        System.assertNotEquals(null, juno.emailAddressinObjectSettings, 'emailAddressinObjectSettings should be set');
    }
    
    @isTest
    static void testInsertRecipientsAndRows() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        JunoDoc__Doc_Template__c docTemplate = [SELECT Id FROM JunoDoc__Doc_Template__c LIMIT 1];
        ContentDocument cd = [SELECT Id FROM ContentDocument LIMIT 1];
        
        // Prepare recipient JSON
        List<JunoPrepareandSend.EmailTyperecipentInner> recipients = new List<JunoPrepareandSend.EmailTyperecipentInner>();
        JunoPrepareandSend.EmailTyperecipentInner rec = new JunoPrepareandSend.EmailTyperecipentInner();
        rec.name = 'Test Recipient';
        rec.email = 'test@junodoc.com';
        rec.ExpirationDate = String.valueOf(Date.today().addDays(7));
        //rec.description = 'Test Description';
        //rec.selectedWeekdays = true;
        //rec.selectedBeforeDays = false;
        //rec.selectedDays = new List<String>{'1', '2'};
        //rec.selectedRecurringDay = false;
        //rec.selectedRecurringDays = new List<String>{'Mon', 'Tue'};
        rec.EmailType = 'To';
        //rec.childRows = new List<JunoPrepareandSend.PostActionRecords>();
        JunoPrepareandSend.PostActionRecords postAction = new JunoPrepareandSend.PostActionRecords();
        postAction.fieldName = 'TestField';
        postAction.fieldType = 'String';
        postAction.fieldValue = 'TestValue';
        //rec.childRows.add(postAction);
        recipients.add(rec);
        
        String receiverJson = JSON.serialize(recipients);
        
        // Prepare other parameters
        String docList = docTemplate.Id;
        String filesJson = '[{"name":"TestFile","fileContents":"' + cd.Id + '"}]';
        String setReplyTo = 'reply@junodoc.com';
        String showAttachment = 'true';
        String isInPerson = 'false';
        String recordId = acc.Id;
        String docidList = docTemplate.Id;
        
        // Mock PDF generation
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        JunoPrepareandSend.responseData response = JunoPrepareandSend.insertRecipientsAndRows(
            receiverJson, recordId, docList, filesJson, setReplyTo, showAttachment, isInPerson, recordId, docidList
        );
        Test.stopTest();
        
        // Assertions
       // System.assertNotEquals(null, response, 'Response should not be null');
        //System.assertNotEquals(null, response.TransactionId, 'TransactionId should be set');
        
        // Verify transaction record
        JunoDoc__Juno_Sign_Transaction__c transaction11 = [SELECT Id, JunoDoc__Status__c, JunoDoc__Object_Id__c FROM JunoDoc__Juno_Sign_Transaction__c LIMIT 1];
        System.assertEquals('Sent', transaction11.JunoDoc__Status__c, 'Transaction status should be Sent');
        System.assertEquals(recordId, transaction11.JunoDoc__Object_Id__c, 'Transaction Object Id should match');
        
        // Verify recipient record
        JunoDoc__Juno_Sign_Recipient__c recipient = [SELECT JunoDoc__Recipient_Email__c, JunoDoc__Status__c FROM JunoDoc__Juno_Sign_Recipient__c LIMIT 1];
        System.assertEquals('test@junodoc.com', recipient.JunoDoc__Recipient_Email__c, 'Recipient email should match');
        System.assertEquals('Pending', recipient.JunoDoc__Status__c, 'Recipient status should be Pending');
    }
    
    @isTest
    static void testGetPositionsTabs() {
        // Create test data
        Account acc = [SELECT Id FROM Account LIMIT 1];
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        JunoDoc__Juno_Sign_Transaction__c trans = new JunoDoc__Juno_Sign_Transaction__c(
            JunoDoc__Object_Id__c = acc.Id,
            JunoDoc__Date_Sent__c = Date.today(),
            JunoDoc__Status__c = 'Sent'
        );
        insert trans;
        
        JunoDoc__Junodoc_Page_Tab__c pageTab = new JunoDoc__Junodoc_Page_Tab__c(
            JunoDoc__Linked_To__c = trans.Id,
            JunoDoc__Sign_Completed__c = false,
            JunoDoc__Pos_Left__c = '100px',
            JunoDoc__Pos_Top__c = '200px',
            JunoDoc__Type__c = 'signature'
        );
        insert pageTab;
        
        // Set page parameters
        ApexPages.currentPage().getParameters().put('trancid', trans.Id);
        ApexPages.currentPage().getParameters().put('id', cv.ContentDocumentId);
        ApexPages.currentPage().getParameters().put('docList', 'a0A000000000001');
        ApexPages.currentPage().getParameters().put('docidList', '069000000000001');
        ApexPages.currentPage().getParameters().put('FileList', '[]');
        ApexPages.currentPage().getParameters().put('receiverList', 'test@junodoc.com');
        ApexPages.currentPage().getParameters().put('TransactionIds', 'a0B000000000001');
        ApexPages.currentPage().getParameters().put('recordId', [SELECT Id FROM Account LIMIT 1].Id);
        ApexPages.currentPage().getParameters().put('isInPerson', 'false');
        ApexPages.currentPage().getParameters().put('showattachment', 'true');
        ApexPages.currentPage().getParameters().put('SetReplyTo', 'reply@junodoc.com');
        ApexPages.currentPage().getParameters().put('insertedIds', '["003000000000001"]');
        
        // Instantiate the class
        JunoPrepareandSend juno = new JunoPrepareandSend();
        
        Test.startTest();
        juno.getpositionsTabs();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, juno.usersidepageTab, 'usersidepageTab should be set');
        System.assertNotEquals(null, juno.body, 'body should contain base64 encoded PDF');
    }
    
    @isTest
    static void testPageReferenceCall() {
        // Set recordId
        Account acc = [SELECT Id FROM Account LIMIT 1];
        ApexPages.currentPage().getParameters().put('recordId', acc.Id);
        ApexPages.currentPage().getParameters().put('docList', 'a0A000000000001');
        ApexPages.currentPage().getParameters().put('docidList', '069000000000001');
        ApexPages.currentPage().getParameters().put('FileList', '[]');
        ApexPages.currentPage().getParameters().put('receiverList', 'test@junodoc.com');
        ApexPages.currentPage().getParameters().put('TransactionIds', 'a0B000000000001');
        ApexPages.currentPage().getParameters().put('isInPerson', 'false');
        ApexPages.currentPage().getParameters().put('showattachment', 'true');
        ApexPages.currentPage().getParameters().put('SetReplyTo', 'reply@junodoc.com');
        ApexPages.currentPage().getParameters().put('insertedIds', '["003000000000001"]');
        // Instantiate the class
        JunoPrepareandSend juno = new JunoPrepareandSend();
        
        Test.startTest();
        PageReference pr = juno.pageReferencecall();
        Test.stopTest();
        
        // Assertions
        System.assertEquals('/' + acc.Id, pr.getUrl(), 'PageReference should redirect to recordId');
        System.assertEquals(true, pr.getRedirect(), 'PageReference should be a redirect');
    }
    
    @isTest
    static void testCallUserSignPage() {
        // Set signUrl
        ApexPages.currentPage().getParameters().put('recordId', [SELECT Id FROM Account LIMIT 1].Id);
        ApexPages.currentPage().getParameters().put('docList', 'a0A000000000001');
        ApexPages.currentPage().getParameters().put('docidList', '069000000000001');
        ApexPages.currentPage().getParameters().put('FileList', '[]');
        ApexPages.currentPage().getParameters().put('receiverList', 'test@junodoc.com');
        ApexPages.currentPage().getParameters().put('TransactionIds', 'a0B000000000001');
        ApexPages.currentPage().getParameters().put('isInPerson', 'false');
        ApexPages.currentPage().getParameters().put('showattachment', 'true');
        ApexPages.currentPage().getParameters().put('SetReplyTo', 'reply@junodoc.com');
        ApexPages.currentPage().getParameters().put('insertedIds', '["003000000000001"]');
        JunoPrepareandSend juno = new JunoPrepareandSend();
        juno.signUrl = 'https://testsite.com/sign';
        
        Test.startTest();
        String url = juno.callUserSignpage();
        Test.stopTest();
        
        // Assertions
        System.assertEquals('https://testsite.com/sign', url, 'callUserSignpage should return signUrl');
    }
    
    // Mock HTTP response for PDF generation
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setBody('Mock PDF Content');
            res.setStatusCode(200);
            return res;
        }
    }
}
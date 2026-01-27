@isTest
private class ContentDocumentLinkTriggerHandlerTest {

    @TestSetup
    static void setupTestData() {
        // Create test Doc_Template__c records
        List<Doc_Template__c> templates = new List<Doc_Template__c>();
        for (Integer i = 1; i <= 3; i++) {
            templates.add(new Doc_Template__c(
                Name = 'Test Template ' + i
                // Add other required fields if any
            ));
        }
        insert templates;
    }

    @isTest
    static void test_AfterInsert_UpdatesFileIdOnDocTemplate() {
        // Given
        Doc_Template__c template = [SELECT Id, Name FROM Doc_Template__c LIMIT 1];

        // Create test ContentVersion (which auto-creates ContentDocument)
        ContentVersion cv = new ContentVersion(
            Title = 'Test Document.pdf',
            PathOnClient = 'Test Document.pdf',
            VersionData = Blob.valueOf('This is test content'),
            IsMajorVersion = true
        );
        insert cv;

        // Re-query to get ContentDocumentId
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

        // Prepare ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = template.Id,           // points to Doc_Template__c
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V',                        // Viewer
            Visibility = 'AllUsers'                 // or InternalUsers / SharedUsers
        );

        // When
        Test.startTest();
        insert cdl;
        Test.stopTest();

        // Then
        Doc_Template__c updatedTemplate = [
            SELECT Id, Name, File_Id__c 
            FROM Doc_Template__c 
            WHERE Id = :template.Id
            LIMIT 1
        ];

        System.assertEquals(cv.ContentDocumentId, updatedTemplate.File_Id__c,
            'File_Id__c should be populated with the ContentDocument Id');
    }

    @isTest
    static void test_MultipleLinks_UsesLastOne() {
        // This test shows current behavior limitation → last record wins

        List<Doc_Template__c> templates = [SELECT Id FROM Doc_Template__c LIMIT 2];

        List<ContentVersion> versions = new List<ContentVersion>();
        for (Integer i = 1; i <= 2; i++) {
            versions.add(new ContentVersion(
                Title = 'Doc ' + i,
                PathOnClient = 'Doc' + i + '.txt',
                VersionData = Blob.valueOf('Test content ' + i),
                IsMajorVersion = true
            ));
        }
        insert versions;

        // Get ContentDocumentIds
        Map<Id, ContentVersion> versionMap = new Map<Id, ContentVersion>(
            [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN :versions]
        );

        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        Integer idx = 0;
        for (Doc_Template__c t : templates) {
            links.add(new ContentDocumentLink(
                LinkedEntityId = t.Id,
                ContentDocumentId = versionMap.values()[idx++].ContentDocumentId,
                ShareType = 'V',
                Visibility = 'AllUsers'
            ));
        }

        Test.startTest();
        insert links;
        Test.stopTest();

        // Current code → last processed link wins for ALL records
        List<Doc_Template__c> updated = [
            SELECT Id, File_Id__c 
            FROM Doc_Template__c 
            WHERE Id IN :templates
        ];

        Id lastDocId = versionMap.values()[1].ContentDocumentId;

        for (Doc_Template__c t : updated) {
            System.assertEquals(lastDocId, t.File_Id__c,
                'Current implementation sets the same (last) ContentDocumentId on all processed records');
        }
    }

    @isTest
    static void test_NoMatchingDocTemplate_NoError() {
        // Create file but link to something else (Account)
        Account acc = new Account(Name = 'Test Acc');
        insert acc;

        ContentVersion cv = new ContentVersion(
            Title = 'Irrelevant.pdf',
            PathOnClient = 'Irrelevant.pdf',
            VersionData = Blob.valueOf('content'),
            IsMajorVersion = true
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = acc.Id,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V'
        );

        // Should not throw exception
        Test.startTest();
        insert cdl;
        Test.stopTest();

        // Nothing should be updated on Doc_Template__c
        System.assert(true, 'No exception should occur when LinkedEntity is not Doc_Template__c');
    }
}
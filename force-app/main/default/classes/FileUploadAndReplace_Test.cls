@isTest
public class FileUploadAndReplace_Test {

    @TestSetup
    static void makeData(){
        Account testAccount = new Account(Name = 'Test Corp', Industry = 'Technology');
        insert testAccount;
        
        //Create Opportunity
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            AccountId = testAccount.Id
        );
        insert testOpp;
        
        //Create Contact
        Contact testContact = new Contact(
            LastName = 'Smith',
            Email = 'test.smith@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        //Create Quote
        Quote testQuote = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpp.Id,
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert testQuote;
    }

    @isTest
    static void testConstructor() {
        FileUploadAndReplace controller = new FileUploadAndReplace();
        System.assertNotEquals(null, controller.xmlText, 'The xmlText should not be null after construction.');
        System.assert(controller.xmlText.startsWith('<?xml'), 'The xmlText should be a valid XML string.');
    }

    @isTest
    static void testGetObjectData() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Corp' LIMIT 1];
        List<String> fields = new List<String>{'Name', 'Industry'};

        Test.startTest();
        SObject result = FileUploadAndReplace.getObjectData(acc.Id, fields);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The returned SObject should not be null.');
        System.assertEquals('Test Corp', result.get('Name'), 'The Account Name should match.');
        System.assertEquals('Technology', result.get('Industry'), 'The Account Industry should match.');
        
        SObject resultEmpty = FileUploadAndReplace.getObjectData(acc.Id, new List<String>());
        System.assertNotEquals(null, resultEmpty, 'Should still return a record even with no fields.');
    }

    @isTest
    static void testGetObjectDatas() {
        Account acc = [SELECT Id, Owner.Profile.Name FROM Account WHERE Name = 'Test Corp' LIMIT 1];
        List<String> fields = new List<String>{'Name', 'Owner.Name', 'Owner.Profile.Name'};

        Test.startTest();
        FileUploadAndReplace.parentClass resultWrapper = FileUploadAndReplace.getObjectDatas(acc.Id, fields);
        Test.stopTest();
        
        System.assertNotEquals(null, resultWrapper, 'The result wrapper should not be null.');
        System.assertEquals(null, resultWrapper.errorMessage, 'There should be no error message on a successful call.');
        System.assertNotEquals(null, resultWrapper.sObjectRecord, 'The SObject record in the wrapper should not be null.');
        System.assertEquals('Test Corp', resultWrapper.sObjectRecord.get('Name'), 'The record name should match.');
        
        System.assert(resultWrapper.fieldMap.containsKey('Name'), 'Field map should contain Name.');
        System.assertEquals('STRING', resultWrapper.fieldMap.get('Name'), 'Type for Name should be STRING.');
        System.assertEquals('STRING', resultWrapper.fieldMap.get('Owner.Name'), 'Type for Owner.Name should be STRING.');
        System.assertEquals('STRING', resultWrapper.fieldMap.get('Owner.Profile.Name'), 'Type for Owner.Profile.Name should be STRING.');
        
        FileUploadAndReplace.parentClass errorWrapper = FileUploadAndReplace.getObjectDatas('001000000000000AAA', fields);
        System.assertNotEquals(null, errorWrapper.errorMessage, 'An error message should be returned for a bad Id.');
    }

    @isTest
    static void testGetChildObjectData() {
        Quote testQuote = [SELECT Id FROM Quote WHERE Name = 'Test Quote' LIMIT 1];
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prod.Id, UnitPrice = 100, IsActive = true);
        insert pbe;
        QuoteLineItem qli = new QuoteLineItem(QuoteId = testQuote.Id, PricebookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100);
        insert qli;

        Test.startTest();
        List<FileUploadAndReplace.childClass> resultList = FileUploadAndReplace.getChildObjectData(testQuote.Id, new List<String>{'QuoteLineItem.Quantity', 'QuoteLineItem.UnitPrice'});
        Test.stopTest();

        System.assertNotEquals(null, resultList, 'The result list should not be null.');
        System.assertEquals(1, resultList.size(), 'Should return one wrapper for the QuoteLineItems relationship.');
        System.assertEquals(1, resultList[0].sObjectRecords.size(), 'Should have one child record.');
        System.assertEquals(1, (Decimal)resultList[0].sObjectRecords[0].get('Quantity'), 'Quantity should be 1.');
    }

    @isTest
    static void testGetChildObjectDatas() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Corp' LIMIT 1];
        List<String> fields = new List<String>{'AccountId.Contact.LastName', 'AccountId.Contact.Email'};

        Test.startTest();
        List<FileUploadAndReplace.childClass> resultList = FileUploadAndReplace.getChildObjectDatas(acc.Id, fields);
        Test.stopTest();

        System.assertNotEquals(null, resultList, 'Result list should not be null.');
        System.assertEquals(null, resultList[0].errorMessage, 'There should be no error message.');
        System.assertEquals(1, resultList.size(), 'Should return one wrapper for the Contacts relationship.');
        System.assertEquals('AccountId.Contact', resultList[0].objectName, 'Object name in wrapper should be correct.');
        
        System.assertEquals(1, resultList[0].sObjectRecords.size(), 'Should be one contact record.');
        System.assertEquals('Smith', resultList[0].sObjectRecords[0].get('LastName'), 'Contact last name should be correct.');
        
        System.assertEquals('STRING', resultList[0].fieldMap.get('LastName'), 'Type for LastName should be STRING.');
        System.assertEquals('EMAIL', resultList[0].fieldMap.get('Email'), 'Type for Email should be EMAIL.');
        
        List<FileUploadAndReplace.childClass> errorResult = FileUploadAndReplace.getChildObjectDatas(acc.Id, new List<String>{'AccountId.Contacts.InvalidField__c'});
        System.assertNotEquals(null, errorResult[0].errorMessage, 'An error message should be returned for an invalid field.');
    }

    @isTest
    static void testGetGlobalValues() {
        List<String> globalsToTest = new List<String>{
            '$User.FirstName',
            '$Organization.Name',
            'Today()',
            'Now()',
            'Yesterday()',
            'Tomorrow()'
        };
        User runningUser = [SELECT FirstName FROM User WHERE Id = :UserInfo.getUserId()];
        Organization org = [SELECT Name FROM Organization LIMIT 1];
        
        Test.startTest();
        List<FileUploadAndReplace.globalMap> resultList = FileUploadAndReplace.getGlobalValues(globalsToTest);
        Test.stopTest();
        
        System.assertEquals(globalsToTest.size(), resultList.size(), 'The list should have a result for each requested global.');

        for (FileUploadAndReplace.globalMap item : resultList) {
            if (item.label == '$User.FirstName') {
                System.assertEquals(runningUser.FirstName, item.value, 'User FirstName should match.');
            } else if (item.label == '$Organization.Name') {
                System.assertEquals(org.Name, item.value, 'Organization Name should match.');
            } else if (item.label == 'Today()') {
                System.assertEquals(String.valueOf(System.today()), item.value, 'Today() should return today date.');
            }
        }
    }
}
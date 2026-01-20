@isTest
public class MultiSelectLookupControllerTest {
    @testSetup
    static void setup() {
        Account accRec = new Account(Name='Test');
        insert accRec;
        
        Contact conRec = new Contact(LastName='TestCon',AccountId=accRec.id,Email='test@emai.com');
        insert conRec;
    }
    static testMethod void test() {
        test.startTest();
        Contact conRecords =[select id,LastName,AccountId,Email from Contact];
        MultiSelectLookupController.retrieveRecords('Contact','LastName,AccountId','LastName','');
        test.stopTest();
    }
}
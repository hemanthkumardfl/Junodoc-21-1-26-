@isTest
public class AutoCompleteEmail_TC {
    private static Account acc;
    private static Contact con;
    private static List<Contact> contactList;
    private static testMethod void test(){
        insertAccounts();
        insertContacts();
        List<String> liststring = new List<String>();
        liststring.add(contactList[0].Id);
        AutoCompleteEmail ACE = new AutoCompleteEmail();
        String myJSON = JSON.serialize(liststring);
        Test.startTest();
        AutoCompleteEmail.fetchRecords('Contact', 'Email', 'FirstName', 'Test', myJSON);
        Test.stopTest();
    }
    
    public static void insertAccounts(){
        acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        System.assertEquals('Test Account', acc.Name);
    }
    
    public static void insertContacts(){
        contactList = new List<Contact>();
        con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'test@test.com';
        contactList.add(con);
        insert contactList;
        System.assertEquals('test@test.com', contactList[0].Email);
    }
}
@isTest
public class MergeFieldsController_TC {
    private static Account acc;
    private static Contact con;
    private static List<Contact> contactList;
    private static testMethod void test(){
        insertAccounts();
        insertContacts();
        Test.startTest();
        MergeFieldsController MF = new MergeFieldsController();
        MF.recordId = acc.Id;
        MF.SobjectName = 'Account';
        MF.m_MergeData('{!Owner.Contact.LastName}'); 
       
        MergeFieldsController MFs = new MergeFieldsController();
        MFs.recordId = con.Id;
        MFs.SobjectName = 'Contact';
        MFs.m_MergeData('{!Account.Name}{!Account.Owner.Name}{!Account.Owner.Createddate}{!#User.Email}{!LastName}'); 
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
    
    private static testMethod void test2(){
         acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'testOpp';
        opp.CloseDate = system.today()+30;
        opp.StageName = 'In Review';
        insert opp;
         

        Test.startTest();
       
        MergeFieldsController MFs = new MergeFieldsController();
        MFs.recordId = opp.Id;
        MFs.SobjectName = 'Opportunity';
        MFs.m_MergeData('{!Account.Name}{!Account.Owner.Name}{!Account.Owner.Createddate}{!Account.Owner.CreatedBy.Name}{!#User.Email}{!Name}'); 
        Test.stopTest();
    }
}
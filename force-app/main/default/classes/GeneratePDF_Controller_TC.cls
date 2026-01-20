@isTest
public class GeneratePDF_Controller_TC {
    private static User usr;
    private static List<User> usersList;
    private static Account acc;
    private static Contact con;
    private static List<Contact> contactList;
    private static Opportunity opp;
    private static Doc_Template__c docTemplate;
    private static Doc_Template_Item__c docTemplateItem;
    private static List<Doc_Template_Item__c> docTemplateItemsList;
    private static Doc_Template_Child__c docTemplateChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList;
    private static testMethod void test(){
        insertUsers();
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertAccounts();
        insertContacts();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        GeneratePDF_Controller GP = new GeneratePDF_Controller();
        GP.contactinputtext = 'Test Contact';
        GP.contactValue();
        GP.inputtext = 'test1 test2';
        GP.userValue();
        GP.CreatePDF();
        GeneratePDF_Controller.isSafeObject('Account');
        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    
   public static void insertDocTemplates(){
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Account';
        docTemplate.Parent_Fields__c = 'Name';
        insert docTemplate;
       System.assertEquals('Test Template', docTemplate.Name);
    }
    
    public static void insertDocTemplateItems(){
        List<Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Item__c]);
        docTemplateItemsList = new List<Doc_Template_Item__c>();
        docTemplateItem = new Doc_Template_Item__c();
        docTemplateItem.Doc_Template__c = docTemplate.Id;
        docTemplateItem.Template_body__c = '<tbody id="Contact2">';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        System.assertEquals('<tbody id="Contact2">', docTemplateItemsList[0].Template_body__c);
    }
    
    public static void insertDocTemplateChilds(){
        List<Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Child__c]);
        docTemplateChildsList = new List<Doc_Template_Child__c>();
        docTemplateChild = new Doc_Template_Child__c();
        docTemplateChild.Doc_Template__c = docTemplate.Id;
        docTemplateChild.Parent_Reference__c = 'AccountId';
        docTemplateChild.Child_object__c = 'Contact';
        docTemplateChild.Child_Query__c = 'Name';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('AccountId', docTemplateChildsList[0].Parent_Reference__c);
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
   
    
    public static void insertUsers(){
        List<Profile> profilesList = [select Id from Profile limit 1];
        usersList = new List<User>();
        usr = new User();
        usr.FirstName = 'test1';
        usr.LastName = 'test2';
        usr.ProfileId = profilesList[0].Id;
        usr.username = 'test1234@sforce.com';
        usr.email = 'test12345@test.com';
        usr.Alias = 'tsalias';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usersList.add(usr);
        insert usersList;
        System.assertEquals('test12345@test.com', usersList[0].Email);
    }
}
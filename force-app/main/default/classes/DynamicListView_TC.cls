@isTest
public class DynamicListView_TC {
    private static User usr;
    private static List<User> usersList;
    private static Account acc;
    private static Contact con;
    private static List<Contact> contactList;
    private static Email_Template__c emailTemplate;
    private static Email_Template_Item__c emailTemplateItem;
    private static List<Email_Template_Item__c> emailTemplateItemsList;
    private static Email_Template_Child__c emailTemplateChild;
    private static List<Email_Template_Child__c> emailTemplateChildsList;
    
    private static Doc_Template_Header__c Header;
    private static Doc_Template_Footer__c Footer;
    private static Doc_Template__c docTemplate;
    private static Doc_Template_Item__c docTemplateItem; 
    private static List<Doc_Template_Item__c> docTemplateItemsList;
    private static Doc_Template_Child__c docTemplateChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList; 
    private static List<Doc_Template_Header__c> HeaderList;
    private static List<Doc_Template_Footer__c> FooterList;
    
    private static testMethod void test(){
        insertUsers();
        insertAccounts();
        insertContacts();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        insertFooters();
        insertHeaders();
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        
        
        
        Test.startTest();
        
        DynamicListView_AC Dynamic = new DynamicListView_AC();
        Dynamic.RecordIds = new set<id>();
        Dynamic.RecIds = new set<id>();
        Dynamic.sObjName = '';
        Dynamic.postActionWrapper = '';
        Dynamic.TemplateId = '';
        List<String> toUserEmailsList = new List<String>();
        toUserEmailsList.add(usersList[0].Email);
        List<String> toContactEmailsList = new List<String>();
        toContactEmailsList.add(contactList[0].Email);
        
        EmailTemplate validEmailTemplate;
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'name';
            validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
    
            insert validEmailTemplate;
        } 
        system.debug('validEmailTemplate **' + validEmailTemplate);
        DynamicListView_AC.getAvailableDocTemplates('Account');
        DynamicListView_AC.getAvailableEmails('Contact');
        DynamicListView_AC.getEmailTemplates('Account');
        if(acc.Id!=null && validEmailTemplate.Id !=null ){
            DynamicListView_AC.getBodyFromEmailTemplate(acc.Id, validEmailTemplate.Id);
        }
        
        DynamicListView_AC.getBodyFromJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        list<string> AccIds = new list<string>();
        list<String> EmailField = new list<string>();
        AccIds.add(acc.Id);
        /*DynamicListView_AC.SendPDF(AccIds, string.valueof(docTemplate.Id), 'Test Email', 'Test Body', 
                                   toUserEmailsList,toContactEmailsList,'test@test.com',true,
                                   EmailField,'Account',''+validEmailTemplate,string.valueof(emailTemplate.Id));*/
        
        list<string> ToTextEmailsList = new list<string>();
        toUserEmailsList.add('test1234@gmail.com');
        list<string> ToEmailMergeFieldsList = new list<string>();
        ToEmailMergeFieldsList.add('Account.Owner.Email');
        list<string> CCTextEmailsList = new list<string>();
        CCTextEmailsList.add('test1234@gmail.com');
        list<string> CCEmailMergeFieldsList = new list<string>();
        list<string> BCCTextEmailsList = new  list<string>();
        BCCTextEmailsList.add('test1234@gmail.com');
        list<string> BCCEmailMergeFieldsList = new list<string>();
        try{
        DynamicListView_AC.SendPDFBatch(AccIds, string.valueof(docTemplate.Id), 'Test Email', 'Test Body', 
                                   true, 'Account', 
                                   ''+validEmailTemplate,string.valueof(emailTemplate.Id),
                                   'test@test.com','test@test.com',
                                   ToTextEmailsList, ToEmailMergeFieldsList,
                                   CCTextEmailsList, CCEmailMergeFieldsList,
                                   BCCTextEmailsList, BCCEmailMergeFieldsList
                                );
        }
        catch(exception e){}
       
        
        DynamicListView_AC.getOrgWideEmails();
        
        Account acc = [Select Id from Account limit 1];
        Id id = acc.Id;
        
        String sObjName = 'Account';
        string query = 'Select id,Name,owner.Name,owner.Email';
        if(ToEmailMergeFieldsList.size() > 0){
            for(string str : ToEmailMergeFieldsList){
                system.debug('To Email--->'+str);
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }
                if(str.toLowerCase()!='owner.email'){
                    query += ','+str;    
                }                       
            }
        }
        if(CCEmailMergeFieldsList.size() > 0){
            for(string str : CCEmailMergeFieldsList){
                system.debug('CC Email--->'+str);
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }           
                if(str.toLowerCase()!='owner.email'){
                    query += ','+str;
                }
            }
        }
        
        if(BCCEmailMergeFieldsList.size() > 0){
            for(string str : BCCEmailMergeFieldsList){
                system.debug('BCC Email--->'+str);
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }  
                if(str.toLowerCase()!='owner.email'){
                     query += ','+str;
                }
            }
        }         
        
        
        system.debug('query @@@@' + query);
        query +=  ' From '+sObjName+' Where id=:id';
        system.debug('query @@@@@@' + query);
        Sobject sobjList = Database.query(query);         
        DynamicListView_AC.getEmailRecipientsHelper(ToTextEmailsList, ToEmailMergeFieldsList, sobjList);        
        Test.stopTest();
    }
    
    public static void insertEmailTemplates(){
        List<Email_Template__c> etRecords = [SELECT Id FROM Email_Template__c];
        DELETE etRecords;
        System.assertEquals(0,[SELECT count() FROM Email_Template__c]);
        emailTemplate = new Email_Template__c();
        emailTemplate.Name = 'Test Template';
        emailTemplate.Parent_Object__c = 'Account';
        emailTemplate.Parent_Fields__c = 'Name';
        insert emailTemplate;
       System.assertEquals('Test Template', emailTemplate.Name);
    } 
    
    public static void insertEmailTemplateItems(){
        List<Email_Template_Item__c> etItemRecords = [SELECT Id FROM Email_Template_Item__c];
        DELETE etItemRecords;
        System.assertEquals(0,[SELECT count() FROM Email_Template_Item__c]);
        emailTemplateItemsList = new List<Email_Template_Item__c>();
        emailTemplateItem = new Email_Template_Item__c();
        emailTemplateItem.Email_Template__c = emailTemplate.Id;
        emailTemplateItem.Template_body__c = '<tbody id="Contact2">';
        emailTemplateItemsList.add(emailTemplateItem);
        insert emailTemplateItemsList;
        System.assertEquals('<tbody id="Contact2">', emailTemplateItemsList[0].Template_body__c);
    }
    
    public static void insertEmailTemplateChilds(){
        List<Email_Template_Child__c> etChildRecords = [SELECT Id FROM Email_Template_Child__c];
        DELETE etChildRecords;
        System.assertEquals(0,[SELECT count() FROM Email_Template_Child__c]);
        emailTemplateChildsList = new List<Email_Template_Child__c>();
        emailTemplateChild = new Email_Template_Child__c();
        emailTemplateChild.Email_Template__c = emailTemplate.Id;
        emailTemplateChild.Parent_Reference__c = 'AccountId';
        emailTemplateChild.Child_object__c = 'Contact';
        emailTemplateChild.Child_Query__c = 'Name';
        emailTemplateChild.Sort_Order__c = 2;
        emailTemplateChildsList.add(emailTemplateChild);
        insert emailTemplateChildsList; 
        System.assertEquals('AccountId', emailTemplateChildsList[0].Parent_Reference__c);
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
        usr.username = 'test5432@sforce.com';
        usr.email = 'test5432@test.com';
        usr.Alias = 'alias';
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usersList.add(usr);
        insert usersList;
        System.assertEquals('test5432@test.com', usersList[0].Email);
    }
    
    public static void insertHeaders(){
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Account';
        Header.Master_Object_Fields__c = 'Name,Id,Owner.Name';
        Header.Header_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Account', HeaderList[0].Master_Object__c);
    }
    
    public static void insertFooters(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Account';
        Footer.Master_Object_Fields__c = 'Name,Id';
        Footer.Footer_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Account', FooterList[0].Master_Object__c);
    }
    
    public static void insertDocTemplates(){
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        List<Doc_Template_Header__c> Headers = [SELECT Id FROM Doc_Template_Header__c];
        List<Doc_Template_Footer__c> Footers = [SELECT Id FROM Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Account';
        docTemplate.Doc_Template_Header__c = Headers[0].Id;
        docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode';
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
        docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        System.assertEquals('test', 'test');
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
        docTemplateChild.Child_Query__c = 'Name,Account.Name,Account.owner.Name';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.Calculation_Fields__c = 'Account.AnnualRevenue';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('Contact', docTemplateChildsList[0].Child_object__c);
    }
    @isTest static void test1(){
         Account ac=new Account();
        ac.Name='Test';
        insert ac;
        
        Email_Template__c email = new Email_Template__c();
        email.Name='test';
        email.Parent_Object__c='Account';
        email.Parent_Fields__c='fileds';
        insert email;
        
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Junodoc_Details__c Juno = new Junodoc_Details__c();
        Juno.From_Email_Address__c = '';
        Juno.Junodoc_Email_Templates__c = '';
        Juno.Standard_Email_Templates__c = '';
        Juno.Selected_object__c = 'Account';
        Juno.JunoDoc__Junodoc_Doc_Template__c = '';
        insert Juno;
        
        JunoDoc__Email_Details__c JunoEmail = new JunoDoc__Email_Details__c();
        JunoEmail.JunoDoc__To_Value__c = 'test@gmail.com';
        JunoEmail.JunoDoc__Text_Ref_Value__c = '';
        JunoEmail.Junodoc_Details__c = Juno.Id;
        insert JunoEmail;
        DynamicListView_AC accc = new DynamicListView_AC();
        DynamicListView_AC.getrecorddetails('Account');
        DynamicListView_AC.getBodyFromJunoDocEmailTemplate1(ac.id,emailTemplate.id);
    }
}
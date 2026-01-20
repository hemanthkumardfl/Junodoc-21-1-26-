@isTest
public class PreviewTemplatePDF_AC_TC {
        private static Doc_Template__c docTemplate;
    private static Doc_Template_Item__c docTemplateItem;
    private static List<Doc_Template_Item__c> docTemplateItemsList;
    private static Doc_Template_Child__c docTemplateChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList;
    private static Email_Template__c emailTemplate;
    private static Email_Template_Item__c emailTemplateItem;
    private static List<Email_Template_Item__c> emailTemplateItemsList;
    private static Email_Template_Child__c emailTemplateChild;
    private static List<Email_Template_Child__c> emailTemplateChildsList;
    private static List<Doc_Template_Header__c> HeaderList;
    private static List<Doc_Template_Footer__c> FooterList;
    private static Doc_Template_Header__c Header;
    private static Doc_Template_Footer__c Footer;
    @isTest static void Test1(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        //getPrintView();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test2(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'A3';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test3(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
         docTemplate.page_size__c = 'A4 Letter';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test4(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'A4 Legal';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test5(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'Label 4x6';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
    @isTest static void Test6(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'Landscape';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
    @isTest static void Test7(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'A5';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
    @isTest static void Test8(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'US Letter';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test9(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'A3 New';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();

    }
     @isTest static void Test10(){
        insertFooters();
        insertHeaders();
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName   ='closed won';
        opp.CloseDate= system.today();
        insert opp;
        
        Account Acc = new Account();
        Acc.Name = 'LastName';
        insert Acc;
        docTemplate.page_size__c = 'A4 New';
         docTemplate.JunoDoc__Show_Page_Number__c = true;
         docTemplate.JunoDoc__Hide_Header__c = true;
         docTemplate.JunoDoc__Hide_Footer__c = true;
         docTemplate.JunoDoc__Background_Image_URL__c = 'test';
         docTemplate.Junodoc__Date_Format__c = 'MM/DD/YYYY';
        update docTemplate;
        ApexPages.currentPage().getParameters().put('id',opp.id);
        ApexPages.currentPage().getParameters().put('DocTemplateId',docTemplate.id);
        PreviewTemplatePDF_AC pre = new PreviewTemplatePDF_AC();
        pre.methodone();
        pre.methodtwo();
         pre.methodthree();

    }
     public static void insertDocTemplates(){
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
         List<Doc_Template_Header__c> Headers = [SELECT Id FROM Doc_Template_Header__c];
        List<Doc_Template_Footer__c> Footers = [SELECT Id FROM Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Opportunity';
         docTemplate.Doc_Template_Header__c = Headers[0].Id;
        docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.PDF_Name__c = 'Test {!Name}-Test {!Owner.Name}-{!TODAY()}-{!NOW()}';
        docTemplate.Parent_Fields__c = 'Name,ShippingStreet,ShippingState,ShippingCity,ShippingPostalcode,ShippingCountry';
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
        docTemplateChild.Filter__c = 'Lastname != sszTestssz';
        docTemplateChild.render_condition__c = '{{Lastname}} != sszTestssz';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('AccountId', docTemplateChildsList[0].Parent_Reference__c);
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
        emailTemplateChild.Filter__c = 'Lastname != sszTestssz';
        emailTemplateChild.render_condition__c = '{{Lastname}} != sszTestssz';
        emailTemplateChildsList.add(emailTemplateChild);
        insert emailTemplateChildsList; 
        System.assertEquals('AccountId', emailTemplateChildsList[0].Parent_Reference__c);
    }
    
    
      public static void insertHeaders(){
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Opportunity';
        Header.Master_Object_Fields__c = 'Name,Id,Owner.Name';
        Header.Header_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Opportunity', HeaderList[0].Master_Object__c);
    }
    
    public static void insertFooters(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Opportunity';
        Footer.Master_Object_Fields__c = 'Name,Id';
        Footer.Footer_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Opportunity', FooterList[0].Master_Object__c);
    }
    
    
     public static void insertconHeaders(){
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Contact';
        Header.Master_Object_Fields__c = 'Name,Id,Owner.Name,Account.owner.Name';
        Header.Header_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Contact', HeaderList[0].Master_Object__c);
    }
    
    public static void insertconFooters(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Contact';
        Footer.Master_Object_Fields__c = 'Name,Id,Account.owner.isActive';
        Footer.Footer_Body__c = '<div><div>{!Name}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Contact', FooterList[0].Master_Object__c);
    }
    
    
        

}
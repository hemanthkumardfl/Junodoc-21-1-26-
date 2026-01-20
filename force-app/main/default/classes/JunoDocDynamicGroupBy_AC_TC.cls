@isTest
public class JunoDocDynamicGroupBy_AC_TC {
     private static Account acc;
    private static Contact con;
    private static Doc_Template_Header__c Header;
    private static Doc_Template_Footer__c Footer;  
    private static List<Contact> contactList;
    private static Doc_Template__c docTemplate;
    private static JunoDoc__Email_Template__c EmailTemplate;
    private static Doc_Template_Item__c docTemplateItem; 
    private static List<Doc_Template_Item__c> docTemplateItemsList;
    private static Doc_Template_Child__c docTemplateChild;
    private static JunoDoc__Email_Template_Child__c DocChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList;
    private static List<JunoDoc__Email_Template_Child__c> docChildsList;
    private static List<Doc_Template_Header__c> HeaderList;

    private static List<Doc_Template_Footer__c> FooterList;

    @isTest static void test1(){
        Account acc = new Account();
        acc.Name='test';
        document d= new Document();
        d.Body = Blob.valueOf('Some Text');
        d.ContentType = 'application/pdf';
        d.DeveloperName = 'my_document';
        d.IsPublic = true;
        d.Name = 'Juno Doc Templates';
        d.FolderId = [select id from folder where name = 'Juno Doc Templates'].id;
        insert d;
        map<string,string> mp=new map<string,string>();
        mp.put('firstnamecontact','STRING');
        mp.put('lastnamecontact','STRING');
        mp.put('createddatecontact','DATETIME');
        insert acc;
        
       
        contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        insert con;
        
        insertconFooters();
        insertconHeaders();
        insertconDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertconEmailTemplates();
        insertEmailTemplateChilds();
        insertAccounts();
        insertContacts();
        JunoDocDynamicGroupBy_AC.GetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.NumberOfEmployees,Account.AnnualRevenue','AccountId',acc.id,'FirstName = \'Test\'','LastName','Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.AnnualRevenue','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',false,'Account');
        JunoDocDynamicGroupBy_AC.GetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','LastName','Lastname,firstname,createddate,Account.Name,Account.owner.Name,[[Name]],[[top]],[[bottom]]','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',true,'Account');
        JunoDocDynamicGroupBy_AC.ChildGetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','LastName','Lastname,firstname,createddate,Account.Name,Account.owner.Name','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email','Account');
        JunoDocDynamicGroupBy_AC.doFormatting(4,32,'dsep','tesep');
        JunoDocDynamicGroupBy_AC.GetCurrencyvalues('',',0');  
        JunoDocDynamicGroupBy_AC.getRelType('Contact','Account','Name');
        JunoDocDynamicGroupBy_AC.getchilType('Contact','Account');
        JunoDocDynamicGroupBy_AC.GetEmailDataDynamically('Contact', 'Name', 'Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.NumberOfEmployees,Account.AnnualRevenue', 'AccountId', acc.id, 'FirstName = \'Test\'', 'LastName', 'Lastname,firstname,createddate,Account.Name,Account.owner.NameAccount.AnnualRevenue', 'white','ariam', 'test', 'test2','5', mp, DocChild, 'dd/mm/yyyy', 'URL', d,d,'UK','$',false);
        JunoDocDynamicGroupBy_AC.GetEmailDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','LastName','Lastname,firstname,createddate,Account.Name,Account.owner.Name,[[Name]],[[top]],[[bottom]]','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$',true);
        JunoDocDynamicGroupBy_AC.ChildGetEmailDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','LastName','Lastname,firstname,createddate,Account.Name,Account.owner.Name','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email');

    }
    @isTest static void test2(){
        Account acc = new Account();
        acc.Name='test';
        document d= new Document();
        d.Body = Blob.valueOf('Some Text');
        d.ContentType = 'application/pdf';
        d.DeveloperName = 'my_document';
        d.IsPublic = true;
        d.Name = 'Juno Doc Templates';
        d.FolderId = [select id from folder where name = 'Juno Doc Templates'].id;
        insert d;
        map<string,string> mp=new map<string,string>();
        mp.put('firstnamecontact','STRING');
        mp.put('lastnamecontact','STRING');
        mp.put('createddatecontact','DATETIME');
        insert acc;
        
       
        contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        insert con;
        
        insertconFooters();
        insertconHeaders();
        insertconDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertconEmailTemplates();
        insertEmailTemplateChilds();
        insertAccounts();
        insertContacts();
        JunoDocDynamicGroupBy_AC.GetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.AnnualRevenue,Account.CreatedDate,Account.NumberOfEmployees,Account.IsCustomerPortal','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.AnnualRevenue,Account.owner.Name,[[top]]','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',false,'Account');
        JunoDocDynamicGroupBy_AC.GetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.AnnualRevenue,Account.CreatedDate,Account.NumberOfEmployees,Account.IsCustomerPortal','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.AnnualRevenue,Account.owner.Name','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',true,'Account');
        JunoDocDynamicGroupBy_AC.ChildGetDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.owner.Name','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email','Account');
        JunoDocDynamicGroupBy_AC.doFormatting(1.00,0,'1','2');
        JunoDocDynamicGroupBy_AC.GetCurrencyvalues('99.00','00.00');  
        JunoDocDynamicGroupBy_AC.getRelType('Contact','Account','Name');
        JunoDocDynamicGroupBy_AC.getchilType('Contact','Account');
        JunoDocDynamicGroupBy_AC.GetEmailDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.AnnualRevenue,Account.CreatedDate,Account.NumberOfEmployees,Account.IsCustomerPortal','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.AnnualRevenue,Account.owner.Name','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$',false);
        JunoDocDynamicGroupBy_AC.GetEmailDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name,Account.AnnualRevenue,Account.CreatedDate,Account.NumberOfEmployees,Account.IsCustomerPortal','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.AnnualRevenue,Account.owner.Name','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$',true);
        JunoDocDynamicGroupBy_AC.ChildGetEmailDataDynamically('Contact','Name','Name,Lastname,firstname,createddate,Account.Name,Account.owner.Name','AccountId',acc.id,'FirstName = \'Test\'','','Lastname,firstname,createddate,Account.Name,Account.owner.Name','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email');
        
        
    }
   /*  @isTest static void test3(){
         
         product2 prod = new product2();
         prod.Name = 'testProd';
         insert prod;
         

         pricebookentry pricebook = new pricebookentry();
         pricebook.Product2Id = prod.Id;
         pricebook.UnitPrice = 100.50;
         pricebook.IsActive = true;
         pricebook.Pricebook2Id = Test.getStandardPricebookId();
         insert pricebook;
         
         Account Ac = new Account();
         Ac.Name = 'testAcc';
         insert Ac;
         
         Opportunity opp = new Opportunity();
         opp.AccountId = Ac.Id;
         opp.CloseDate = system.today()+30;
         opp.StageName = 'In Review';
         opp.Name = 'testOpp';
         insert opp;
         
        Quote quo = new Quote();
        quo.Name='test';
        quo.OpportunityId = opp.Id;
         quo.Pricebook2Id = Test.getStandardPricebookId();
        document d= new Document();
        d.Body = Blob.valueOf('Some Text');
        d.ContentType = 'application/pdf';
        d.DeveloperName = 'my_document';
        d.IsPublic = true;
        d.Name = 'Juno Doc Templates';
        d.FolderId = [select id from folder where name = 'Juno Doc Templates'].id;
        insert d;
        map<string,string> mp=new map<string,string>();
        mp.put('QuantityQuoteLineItem','Number');
        mp.put('SubtotalQuoteLineItem','Currency');
        mp.put('createddateQuoteLineItem','DATETIME');
        insert quo;
        
       
        QuoteLineItem quolin = new QuoteLineItem();
        quolin.QuoteId = quo.Id;
        quolin.Discount = 10;
        quolin.Quantity = 2;
         quolin.UnitPrice = 11;
         quolin.Product2Id = prod.Id;
         quolin.PricebookEntryId = pricebook.Id;
        insert quolin;
         
         List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        List<Doc_Template_Header__c> Headers = [SELECT Id FROM Doc_Template_Header__c];
        List<Doc_Template_Footer__c> Footers = [SELECT Id FROM Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Quote';
        docTemplate.Doc_Template_Header__c = Headers[0].Id;
        docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, QuoteToName, ShippingName, ShippingHandling, Status,createddate,owner.isActive,ExpirationDate';
        insert docTemplate;
        System.assertEquals('Test Template', docTemplate.Name);
         
         List<Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Child__c]);
        docTemplateChildsList = new List<Doc_Template_Child__c>();
        docTemplateChild = new Doc_Template_Child__c();
        docTemplateChild.Doc_Template__c = docTemplate.Id;
        docTemplateChild.Parent_Reference__c = 'QuoteId';
        docTemplateChild.Child_object__c = 'QuoteLineItem';
        docTemplateChild.Child_Query__c = 'Discount,LineNumber,ListPrice,Product2Id,Quantity,UnitPrice,Subtotal,TotalPrice,ServiceDate';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Group_By_Calculation__c = 'Quantity';
        docTemplateChild.Calculation_Fields__c = 'TotalPrice';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('QuoteLineItem', docTemplateChildsList[0].Child_object__c);
        
        
        JunoDocDynamicGroupBy_AC.GetDataDynamically('QuoteLineItem','Name','Discount,LineNumber,ListPrice,Product2Id,Quantity,UnitPrice,Subtotal,TotalPrice,ServiceDate','QuoteId',quo.id,'Discount = \'10\'','','ListPrice,LineNumber,createddate,Quote.Name,Quote.ShippingHandling,Quote.Account.Name','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',true);
        
    }*/
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
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode,createddate,owner.isActive,AnnualRevenue';
        insert docTemplate;
        System.assertEquals('Test Template', docTemplate.Name);
    }
    
     public static void insertconEmailTemplates(){
        List<JunoDoc__Email_Template__c > dtRecords = [SELECT Id FROM JunoDoc__Email_Template__c];
        DELETE dtRecords;
                System.assertEquals(0,[SELECT count() FROM JunoDoc__Email_Template__c   ]);
        EmailTemplate = new JunoDoc__Email_Template__c();
        EmailTemplate.Name = 'Test con Template';
        EmailTemplate.Parent_Object__c = 'Contact';
        
        EmailTemplate.Parent_Fields__c = 'Name,Owner.Name, Account.owner.Name, Account.owner.isActive, Account.AnnualRevenue';
        insert EmailTemplate;
        System.assertEquals('Test con Template', EmailTemplate.Name);
    }
    
    public static void insertconDocTemplates(){
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        List<Doc_Template_Header__c> Headers = [SELECT Id FROM Doc_Template_Header__c];
        List<Doc_Template_Footer__c> Footers = [SELECT Id FROM Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test con Template';
        docTemplate.Parent_Object__c = 'Contact';
        docTemplate.Doc_Template_Header__c = Headers[0].Id;
        docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, Account.owner.Name, Account.owner.isActive, Account.AnnualRevenue';
        insert docTemplate;
        System.assertEquals('Test con Template', docTemplate.Name);
    }
    
    public static void insertDocTemplateItems(){
        List<Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Item__c]);
        docTemplateItemsList = new List<Doc_Template_Item__c>();
        docTemplateItem = new Doc_Template_Item__c();
        docTemplateItem.Doc_Template__c = docTemplate.Id;
        docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!CreatedDate}{!#User.Name}';
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
        docTemplateChild.Child_Query__c = 'Name,Account.Name,Account.owner.Name,Account.Createddate,createddate,Account.owner.isActive,Account.AnnualRevenue';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Account.AnnualRevenue ASC';
        docTemplateChild.Calculation_Fields__c = 'Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        //docTemplateChild.JunoDoc__Group_By_Calculation__c = '';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('Contact', docTemplateChildsList[0].Child_object__c);
    }
    
    public static void insertEmailTemplateChilds(){
        List<JunoDoc__Email_Template_Child__c> dtChildRecords = [SELECT Id FROM JunoDoc__Email_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Email_Template_Child__c]);
        DocChildsList = new List<JunoDoc__Email_Template_Child__c>();
        DocChild = new JunoDoc__Email_Template_Child__c();
        DocChild.JunoDoc__Email_Template__c = EmailTemplate.Id;
        DocChild.Parent_Reference__c = 'AccountId';
        DocChild.Child_object__c = 'Contact';
        DocChild.Child_Query__c = 'Name,Account.Name,Account.owner.Name,Account.Createddate,createddate,Account.owner.isActive,Account.AnnualRevenue';
        DocChild.Sort_Order__c = 2;
        DocChild.JunoDoc__Filter__c = 'Id!= null';
        DocChild.JunoDoc__Order_By__c = 'Account.AnnualRevenue ASC';
        DocChild.Calculation_Fields__c = 'Account.AnnualRevenue';
        DocChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        //DocChild.JunoDoc__Group_By_Calculation__c = '';
        DocChildsList.add(DocChild);
        insert DocChild; 
        System.assertEquals('Contact', DocChildsList[0].Child_object__c);
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
        contactList.add(con);
        insert contactList;
        System.assertEquals('Test', contactList[0].FirstName);
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
    @isTest
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
    
     private static testMethod void testtwo(){
         document d= new Document();
        d.Body = Blob.valueOf('Some Text');
        d.ContentType = 'application/pdf';
        d.DeveloperName = 'my_document';
        d.IsPublic = true;
        d.Name = 'Juno Doc Templates';
        d.FolderId = [select id from folder where name = 'Juno Doc Templates'].id;
        insert d;
         
         map<string,string> mp=new map<string,string>();
        mp.put('BillingNameQuote','String');
        mp.put('SubtotalQuote','Currency');
        mp.put('createddateQuote','DATETIME');
         
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Quote';
        Footer.Master_Object_Fields__c = 'Name,subtotal,Owner.Name, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Footer.Footer_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
       
        FooterList.add(Footer);
        insert FooterList;
        
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Quote';
        Header.Master_Object_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Header.Header_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        List<Doc_Template_Header__c> Headers = [SELECT Id FROM Doc_Template_Header__c];
        List<Doc_Template_Footer__c> Footers = [SELECT Id FROM Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test quo Template';
        docTemplate.Parent_Object__c = 'Quote';
        docTemplate.Doc_Template_Header__c = Headers[0].Id;
        docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.Parent_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert docTemplate;
        
        List<Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Item__c]);
        docTemplateItemsList = new List<Doc_Template_Item__c>();
        docTemplateItem = new Doc_Template_Item__c();
        docTemplateItem.Doc_Template__c = docTemplate.Id;
        docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        
        List<Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Child__c]);
        docTemplateChildsList = new List<Doc_Template_Child__c>();
        docTemplateChild = new Doc_Template_Child__c();
        docTemplateChild.Doc_Template__c = docTemplate.Id;
        docTemplateChild.Parent_Reference__c = 'OpportunityId';
        docTemplateChild.Child_object__c = 'Quote';
        docTemplateChild.Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        docTemplateChild.Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        docTemplateChild.JunoDoc__Related_Object_Labels__c = 'Product Name,Product Description[[Right]],Subtotal ,Total Price';
        //docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT Product2.Name Product,SUM(Quantity),SUM(unitPrice) unitPrices, SUM(TotalPrice) TotalPrices from quotelineitem group by  Product2.Name';
        docTemplateChild.JunoDoc__Group_By__c = 'linenumber';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        
         
         List<JunoDoc__Email_Template__c    > dtEmRecords = [SELECT Id FROM JunoDoc__Email_Template__c];
        DELETE dtEmRecords;
                System.assertEquals(0,[SELECT count() FROM JunoDoc__Email_Template__c   ]);
        EmailTemplate = new JunoDoc__Email_Template__c();
        EmailTemplate.Name = 'Test quo Template';
        EmailTemplate.Parent_Object__c = 'Quote';
        
        EmailTemplate.Parent_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert EmailTemplate;
        System.assertEquals('Test quo Template', EmailTemplate.Name);
         
         List<JunoDoc__Email_Template_Child__c> dtEmailChildRecords = [SELECT Id FROM JunoDoc__Email_Template_Child__c];
        DELETE dtEmailChildRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Email_Template_Child__c]);
        DocChildsList = new List<JunoDoc__Email_Template_Child__c>();
        DocChild = new JunoDoc__Email_Template_Child__c();
        DocChild.JunoDoc__Email_Template__c = EmailTemplate.Id;
        DocChild.Parent_Reference__c = 'OpportunityId';
        DocChild.Child_object__c = 'Quote';
        DocChild.Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        DocChild.Sort_Order__c = 2;
        DocChild.JunoDoc__Filter__c = 'Id!= null';
        DocChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        DocChild.Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        DocChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        DocChild.JunoDoc__Related_Object_Labels__c = 'Product Name,Product Description[[Right]],Subtotal ,Total Price';
        //DocChild.JunoDoc__Aggregate_Query__c = 'SELECT Product2.Name Product,SUM(Quantity),SUM(unitPrice) unitPrices, SUM(TotalPrice) TotalPrices from quotelineitem group by  Product2.Name';
        DocChild.JunoDoc__Group_By__c = 'linenumber';
        DocChildsList.add(DocChild);
        insert DocChild; 
         
        System.assertEquals('Quote', DocChildsList[0].Child_object__c);
        acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'testOpp';
        opp.CloseDate = system.today()+30;
        opp.StageName = 'In Review';
        insert opp;
        
        quote quo = new quote();
        quo.Name = 'testQuo';
        quo.OpportunityId = opp.id;
        insert quo;
        
        docTemplate.JunoDoc__Currency_Format__c = '###,###.00';
         docTemplate.JunoDoc__Number_Format__c = '###,###.00';
         docTemplate.Junodoc__Date_Format__c = 'MM/dd/yyyy';
         update docTemplate;
         
         EmailTemplate.JunoDoc__Currency_Format__c = '###,###.00';
         EmailTemplate.JunoDoc__Number_Format__c = '###,###.00';
         EmailTemplate.Junodoc__Date_Format__c = 'MM/dd/yyyy';
         update EmailTemplate;
         
         
        
         JunoDocDynamicGroupBy_AC.GetDataDynamically('Quote','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','OpportunityId',opp.id,'Subtotal = 10','','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$',true,'Account');
         JunoDocDynamicGroupBy_AC.ChildGetDataDynamically('Quote','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','OpportunityId',opp.id,'Subtotal = 10','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','white','ariam','test','test2','5',mp,docTemplateChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email','Account');
         JunoDocDynamicGroupBy_AC.GetEmailDataDynamically('Quote','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','OpportunityId',opp.id,'Subtotal = 10','','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$',true);
         JunoDocDynamicGroupBy_AC.ChildGetEmailDataDynamically('Quote','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','OpportunityId',opp.id,'Subtotal = 10','QuoteNumber','Name,subtotal,ShippingHandling,Owner.Name, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal','white','ariam','test','test2','5',mp,DocChild,'dd/mm/yyyy','URL',d,d,'UK','$','Email');
         
     }
    
}
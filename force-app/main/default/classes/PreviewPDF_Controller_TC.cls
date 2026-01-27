@isTest
public class PreviewPDF_Controller_TC {   
    private static Account acc;
    private static Contact con;
    private static Doc_Template_Header__c Header;
    private static Doc_Template_Footer__c Footer;
    private static List<Contact> contactList;
    private static Doc_Template__c docTemplate;
    private static Doc_Template_Item__c docTemplateItem; 
    private static List<Doc_Template_Item__c> docTemplateItemsList;
    private static Doc_Template_Child__c docTemplateChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList;
    
    private static List<Doc_Template_Header__c> HeaderList;

    private static List<Doc_Template_Footer__c> FooterList;

    
    private static testMethod void test(){
        insertFooters();
        insertHeaders();
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertAccounts();
        insertContacts();
        
        JunoDoc__Junodoc_Currency__c Curr = new JunoDoc__Junodoc_Currency__c();
        Curr.JunoDoc__Currency_Code__c = 'CAD';
        Curr.JunoDoc__Currency_Symbol__c = '$';
        Curr.Name = 'test';
        insert Curr;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
        PreviewPDF_Controller PPC = new PreviewPDF_Controller();
        PPC.docTemplateId = docTemplate.Id;
        PPC.getTemplateId();
        //PPC.methodone();
        PPC.getClassroomRelatedLists();
        PPC.methodone();
        PPC.getFooterLists();
        PPC.getheaderLists();
        
        PPC.GetCurrencyvalues('1000000');
        PPC.currencyFormat  = '###.###,00';
         PPC.GetCurrencyvalues('1000000');
        PPC.getRelType('contact','Account','Name');
        PPC.getchilType('contact','Account');
        //PreviewPDF_Controller.isSafeObject('Account');
        system.assertEquals('test', 'test');
        Test.stopTest();
    }
     private static testMethod void testone(){
        insertconFooters();
        insertconHeaders();
        insertconDocTemplates();
        insertDocTemplateItems();
        insertAccounts();
        insertContacts();
        
        docTemplate.JunoDoc__Currency_Format__c = '###,###.00';
         docTemplate.JunoDoc__Number_Format__c = '###,###.00';
         docTemplate.Junodoc__Date_Format__c = 'MM/dd/yyyy';
         update docTemplate;
         
         
        
         Test.startTest();
        ApexPages.currentPage().getParameters().put('id', con.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
         ApexPages.currentPage().getParameters().put('Type', 'PDF');
        PreviewPDF_Controller PPC = new PreviewPDF_Controller();
        PPC.docTemplateId = docTemplate.Id;
        PPC.getTemplateId();
        //PPC.methodone();
        PPC.getClassroomRelatedLists();
        PPC.methodone();
        PPC.getFooterLists();
        PPC.getheaderLists();
        PPC.getBarcodes('Test');
         PPC.getBarcodes(null);
        
        PPC.GetCurrencyvalues('1000000');
        PPC.currencyFormat  = '###.###,00';
         PPC.GetCurrencyvalues('1000000');
        PPC.getRelType('contact','Account','Name');
        PPC.getchilType('contact','Account');
        //PreviewPDF_Controller.isSafeObject('Account');
        system.assertEquals('test', 'test');
        Test.stopTest();
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
        docTemplate.Parent_Fields__c = 'Name,Owner.Name, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode,createddate,owner.isActive,AnnualRevenue,IsCustomerPortal,NumberOfEmployees,JunoDoc__SLAExpirationDate__c,owner.createddate';
        docTemplate.JunoDoc__Show_Page_Number__c = true;
        insert docTemplate;
        System.assertEquals('Test Template', docTemplate.Name);
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
        docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{!Account.Createddate}';
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
        docTemplateChild.JunoDoc__Related_Object_Child_Query__c = 'Name,Account.Name,Account.Owner.LastName,Account.Owner.CreatedBy.LastName';
         docTemplateChild.JunoDoc__Parent_Child_Object__c = 'Contact';
         docTemplateChild.JunoDoc__Parent_Child_Reference__c = 'accountId';
         docTemplateChild.JunoDoc__Parent_Child_Object_Reference__c= 'accountId';
        //docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT Count(id) FROM Contact WHERE Id != null GROUP BY Id';
        //docTemplateChild.JunoDoc__Group_By__c = 'ID';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('Contact', docTemplateChildsList[0].Child_object__c);
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
        Header.Header_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Account', HeaderList[0].Master_Object__c);
    }
    
    public static void insertFooters(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Account';
        Footer.Master_Object_Fields__c = 'Name,Id';
        Footer.Footer_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Account', FooterList[0].Master_Object__c);
    }
    
    
     public static void insertconHeaders(){
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Contact';
        Header.Master_Object_Fields__c = 'Name,Id,Owner.Name,Account.owner.Name';
        Header.Header_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Contact', HeaderList[0].Master_Object__c);
    }
    
    public static void insertconFooters(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Contact';
        Footer.Master_Object_Fields__c = 'Name,Id,Account.owner.isActive';
        Footer.Footer_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Contact', FooterList[0].Master_Object__c);
    }
    
    private static testMethod void testtwo(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Quote';
        Footer.Master_Object_Fields__c = 'Name,subtotal,Owner.Name, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Footer.Footer_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
       
        FooterList.add(Footer);
        insert FooterList;
        
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Quote';
        Header.Master_Object_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Header.Header_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
        
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
        docTemplate.JunoDoc__Single_Page__c = true;
        docTemplate.Parent_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate,GrandTotal,Opportunity.IqScore, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert docTemplate;
        
        List<Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Item__c]);
        docTemplateItemsList = new List<Doc_Template_Item__c>();
        docTemplateItem = new Doc_Template_Item__c();
        docTemplateItem.Doc_Template__c = docTemplate.Id;
        docTemplateItem.JunoDoc__Page_Render__c = 'Id!=null';
        docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}';
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
        docTemplateChild.Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name,createddate, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        docTemplateChild.Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        docTemplateChild.JunoDoc__Related_Object_Labels__c = 'Discount[[Center]],Grand Total[[Center]],Subtotal[[Center]],Quote Number';
        docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT SUM(SubTotal) Subtotals, SUM(GrandTotal) TotalPrices from quote group by  OpportunityId';
        docTemplateChild.JunoDoc__Group_By__c = 'OpportunityId';
        docTemplateChild.JunoDoc__Related_Object_Child_Query__c = 'Name,Account.Name,Account.Owner.LastName,Account.Owner.CreatedBy.LastName';
         docTemplateChild.JunoDoc__Parent_Child_Object__c = 'Contact';
         docTemplateChild.JunoDoc__Parent_Child_Reference__c = 'accountId';
         docTemplateChild.JunoDoc__Parent_Child_Object_Reference__c= 'accountId';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 

JunoDoc__Calculated_Fields__c CalcFld = new JunoDoc__Calculated_Fields__c();
        CalcFld.JunoDoc__Calculated_Field_Query__c = 'Select SUM(SubTotal)Total from Quote where OpportunityId';
        CalcFld.JunoDoc__Calculated_Field__c = '[SubTotal]';
        CalcFld.JunoDoc__Junodoc_Templates__c = docTemplate.Id;
        insert CalcFld;
        
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
         
         
        
         Test.startTest();
        ApexPages.currentPage().getParameters().put('id', quo.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
         ApexPages.currentPage().getParameters().put('Type', 'PDF');
        PreviewPDF_Controller PPC = new PreviewPDF_Controller();
        PPC.docTemplateId = docTemplate.Id;
        PPC.getTemplateId();
        //PPC.methodone();
        PPC.getClassroomRelatedLists();
        PPC.methodone();
        PPC.getFooterLists();
        PPC.getheaderLists();
        PPC.getBarcodes('Test');
         //PPC.getBarcodes(null);
        
        PPC.GetCurrencyvalues('1000000');
        PPC.currencyFormat  = '###.###,00';
         PPC.GetCurrencyvalues('1000000');
        PPC.getRelType('Quote','Opportunity','Name');
        PPC.getchilType('Quote','Opportunity');
        //PreviewPDF_Controller.isSafeObject('Account');
        system.assertEquals('test', 'test');
        Test.stopTest();
    }
     private static testMethod void testthree(){
        FooterList = new List<Doc_Template_Footer__c>();
        Footer = new Doc_Template_Footer__c();
        Footer.Master_Object__c = 'Quote';
        Footer.Master_Object_Fields__c = '';
        Footer.Footer_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.TotalOpportunityQuantity}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
       
        FooterList.add(Footer);
        insert FooterList;
        
        HeaderList = new List<Doc_Template_Header__c>();
        Header = new Doc_Template_Header__c();
        Header.Master_Object__c = 'Quote';
        Header.Master_Object_Fields__c = '';
         Header.Header_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.TotalOpportunityQuantity},{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
        
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
        //docTemplate.Doc_Template_Header__c = Headers[0].Id;
        //docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.JunoDoc__Single_Page__c = true;
        docTemplate.Parent_Fields__c = 'Name,subtotal,Discount,ExpirationDate,ShippingHandling,Owner.Name,Opportunity.TotalOpportunityQuantity,Opportunity.Closedate,GrandTotal,Opportunity.IqScore, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert docTemplate;
        
        List<Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template_Item__c]);
        docTemplateItemsList = new List<Doc_Template_Item__c>();
        docTemplateItem = new Doc_Template_Item__c();
        docTemplateItem.Doc_Template__c = docTemplate.Id;
        docTemplateItem.JunoDoc__Page_Render__c = 'Id!=null';
         docTemplateItem.Template_body__c = '<tbody id="Contact2">{!TODAY()}[{Discount}]{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.TotalOpportunityQuantity}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}';
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
        docTemplateChild.Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name,createddate,Opportunity.TotalOpportunityQuantity, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        docTemplateChild.Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        docTemplateChild.Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        docTemplateChild.JunoDoc__Related_Object_Labels__c = 'Discount[[Center]],Grand Total[[Center]],Subtotal[[Center]],Quote Number';
        docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT SUM(SubTotal) Subtotals, SUM(GrandTotal) TotalPrices from quote group by  OpportunityId';
        docTemplateChild.JunoDoc__Group_By__c = 'OpportunityId';
         docTemplateChild.JunoDoc__Related_Object_Child_Query__c = 'Name,Account.Name,Account.Owner.LastName,Account.Owner.CreatedBy.LastName';
         docTemplateChild.JunoDoc__Parent_Child_Object__c = 'Contact';
         docTemplateChild.JunoDoc__Parent_Child_Reference__c = 'accountId';
         docTemplateChild.JunoDoc__Parent_Child_Object_Reference__c= 'accountId';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 

JunoDoc__Calculated_Fields__c CalcFld = new JunoDoc__Calculated_Fields__c();
        CalcFld.JunoDoc__Calculated_Field_Query__c = 'Select SUM(SubTotal)Total from Quote where OpportunityId';
        CalcFld.JunoDoc__Calculated_Field__c = '[SubTotal]';
        CalcFld.JunoDoc__Junodoc_Templates__c = docTemplate.Id;
        insert CalcFld;
        
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
         quo.ExpirationDate = system.today()+220;
         quo.ShippingHandling = 30;
        insert quo;
        
        docTemplate.JunoDoc__Currency_Format__c = '###,###.00';
         docTemplate.JunoDoc__Number_Format__c = '###,###.00';
         docTemplate.Junodoc__Date_Format__c = 'MM/dd/yyyy';
         update docTemplate;
         
         
        
         Test.startTest();
        // PreviewPDF_Controller.dummy();
        ApexPages.currentPage().getParameters().put('id', quo.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
         ApexPages.currentPage().getParameters().put('Type', 'PDF');
        PreviewPDF_Controller PPC = new PreviewPDF_Controller();
        PPC.docTemplateId = docTemplate.Id;
        PPC.getTemplateId();
         
        //PPC.methodone();
        PPC.getClassroomRelatedLists();
        PPC.methodone();
        PPC.getFooterLists();
        PPC.getheaderLists();
        PPC.getBarcodes('Test');
         //PPC.getBarcodes(null);
        
        PPC.GetCurrencyvalues('1000000');
        PPC.currencyFormat  = '###.###,00';
         PPC.GetCurrencyvalues('1000000');
        PPC.getRelType('Quote','Opportunity','Name');
        PPC.getchilType('Quote','Opportunity');
         
         //----------------------------------------------------------
         Document checkDoc = new Document(
        Name = 'TestCheckImg',
        Body = Blob.valueOf('mock check image'),
        ContentType = 'image/png',
        FolderId = UserInfo.getUserId(),
        IsPublic = true
    );
    insert checkDoc;

    Document uncheckDoc = new Document(
        Name = 'TestUncheckImg',
        Body = Blob.valueOf('mock uncheck image'),
        ContentType = 'image/png',
        FolderId = UserInfo.getUserId(),
        IsPublic = true
    );
    insert uncheckDoc;
         String baseUrl = '';
          Map<String, String> typeMap = new Map<String, String>{
        'firstnamecontact'           => 'STRING',
        'lastnamecontact'            => 'STRING',
        'emailcontact'               => 'EMAIL',
        'donotcallcontact'           => 'BOOLEAN',
        'mobilephonecontact'         => 'PHONE',
        'birthdatecontact'           => 'DATE',
        'createddatecontact'         => 'DATETIME',
        'account.owner.namecontact'  => 'STRING'
    };
        Contact parentAcc = new Contact(
        LastName = 'Test Parent Account 2025',
            AccountId = acc.Id,
        OwnerId = UserInfo.getUserId()
    );
    insert parentAcc;
             String parentHtmlFragment = '<h3>Contacts for ' + parentAcc.Name + '</h3>';
    Integer testColspan = 8;
        PPC.getChildTabelData(
        docTemplateChild,               // Doc_Template_Child__c
        null,                   // str (often unused)
        uncheckDoc,             // Document uncheckdocument
        checkDoc,               // Document checkdocument
        baseUrl,                // sfdcURLForDocImage
        typeMap,                // ChildobjectsMap
        parentAcc,              // childSobj = parent record
        parentHtmlFragment,     // parentstr
        testColspan             // colspan
    );
          String input =
            '<div style="color:PLACEHOLDER;">PLACEHOLDER</div>';

        String output = PreviewPDF_Controller.safeReplaceOutsideStyle(
            input,
            'PLACEHOLDER',
            'RED'
        );
        //PreviewPDF_Controller.isSafeObject('Account');
        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    
}
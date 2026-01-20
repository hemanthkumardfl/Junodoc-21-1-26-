@isTest
public class PreviewPDFGenerator_Test {
    private static Account acc;
    private static Contact con;
    private static JunoDoc__Doc_Template_Header__c Header;
    private static JunoDoc__Doc_Template_Footer__c Footer;
    private static List<Contact> contactList;
    private static JunoDoc__Doc_Template__c docTemplate;
    private static JunoDoc__Doc_Template_Item__c docTemplateItem; 
    private static List<JunoDoc__Doc_Template_Item__c> docTemplateItemsList;
    private static JunoDoc__Doc_Template_Child__c docTemplateChild;
    private static List<JunoDoc__Doc_Template_Child__c> docTemplateChildsList;
    
    private static List<JunoDoc__Doc_Template_Header__c> HeaderList;

    private static List<JunoDoc__Doc_Template_Footer__c> FooterList;
    
    static testMethod void testGetData() {
        Account accRecord = new Account();
        accRecord.Name = 'test Testament Apparel';
        insert accRecord;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'test opportunity';
        oppRec.CloseDate = system.today();
        oppRec.StageName = 'Prospecting';
        insert oppRec;
          
            
        Quote  quoteRec = new Quote();
        quoteRec.Name = 'test quote';
        quoteRec.OpportunityId = oppRec.Id;
        //quoteRec.OpportunityId = '0063h00000KC6gmAAD';
        insert quoteRec;   
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.pdf'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.ShareType= 'V';
        contentlink.LinkedEntityId = quoteRec.Id; //quote id
        contentlink.Visibility = 'AllUsers';
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        insert contentlink;
        
       
        /*************************************************************************************/
        
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
        ApexPages.currentPage().getParameters().put('id', quoteRec.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
        ApexPages.currentPage().getParameters().put('ParentId', accRecord.Id);
        ApexPages.currentPage().getParameters().put('isLatest', 'true');
        PreviewPDFGenerator.getData();
        Test.stopTest();
    }
    static testMethod void testGetData2() {
        Account accRecord = new Account();
        accRecord.Name = 'test Testament Apparel';
        insert accRecord;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'test opportunity';
        oppRec.CloseDate = system.today();
        oppRec.StageName = 'Prospecting';
        insert oppRec;
          
            
        Quote  quoteRec = new Quote();
        quoteRec.Name = 'test quote';
        quoteRec.OpportunityId = oppRec.Id;
        //quoteRec.OpportunityId = '0063h00000KC6gmAAD';
        insert quoteRec;   
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.pdf'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.ShareType= 'V';
        contentlink.LinkedEntityId = quoteRec.Id; //quote id
        contentlink.Visibility = 'AllUsers';
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        insert contentlink;
        
       
        /*************************************************************************************/
        
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
        ApexPages.currentPage().getParameters().put('id', quoteRec.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
        ApexPages.currentPage().getParameters().put('ParentId', accRecord.Id);
        ApexPages.currentPage().getParameters().put('isLatest', 'false');
        PreviewPDFGenerator.getData();
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
        ApexPages.currentPage().getParameters().put('id', con.Id);
        ApexPages.currentPage().getParameters().put('DocTemplateId', docTemplate.id);
        ApexPages.currentPage().getParameters().put('Type', 'PDF');
      
    }
    public static void insertDocTemplates(){
        List<JunoDoc__Doc_Template__c> dtRecords = [SELECT Id FROM JunoDoc__Doc_Template__c];
        DELETE dtRecords;
        List<JunoDoc__Doc_Template_Header__c> Headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c];
        List<JunoDoc__Doc_Template_Footer__c> Footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template__c]);
        docTemplate = new JunoDoc__Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.JunoDoc__Parent_Object__c = 'Account';
        docTemplate.JunoDoc__Doc_Template_Header__c = Headers[0].Id;
        docTemplate.JunoDoc__Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.JunoDoc__Parent_Fields__c = 'Name,Owner.Name, ShippingState, ShippingCity, ShippingCountry, ShippingPostalCode,createddate,owner.isActive,AnnualRevenue,IsCustomerPortal,NumberOfEmployees,JunoDoc__SLAExpirationDate__c,owner.createddate';
        docTemplate.JunoDoc__Show_Page_Number__c = true;
        insert docTemplate;
        System.assertEquals('Test Template', docTemplate.Name);
    }
    
     public static void insertconDocTemplates(){
        List<JunoDoc__Doc_Template__c> dtRecords = [SELECT Id FROM JunoDoc__Doc_Template__c];
        DELETE dtRecords;
        List<JunoDoc__Doc_Template_Header__c> Headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c];
        List<JunoDoc__Doc_Template_Footer__c> Footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template__c]);
        docTemplate = new JunoDoc__Doc_Template__c();
        docTemplate.Name = 'Test con Template';
        docTemplate.JunoDoc__Parent_Object__c = 'Contact';
        docTemplate.JunoDoc__Doc_Template_Header__c = Headers[0].Id;
        docTemplate.JunoDoc__Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.JunoDoc__Parent_Fields__c = 'Name,Owner.Name, Account.owner.Name, Account.owner.isActive, Account.AnnualRevenue';
        insert docTemplate;
        System.assertEquals('Test con Template', docTemplate.Name);
    }
    
    public static void insertDocTemplateItems(){
        List<JunoDoc__Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM JunoDoc__Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Item__c]);
        docTemplateItemsList = new List<JunoDoc__Doc_Template_Item__c>();
        docTemplateItem = new JunoDoc__Doc_Template_Item__c();
        docTemplateItem.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateItem.JunoDoc__Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{!Account.Createddate}';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        System.assertEquals('test', 'test');
    }
    
    public static void insertDocTemplateChilds(){
        List<JunoDoc__Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM JunoDoc__Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Child__c]);
        docTemplateChildsList = new List<JunoDoc__Doc_Template_Child__c>();
        docTemplateChild = new JunoDoc__Doc_Template_Child__c();
        docTemplateChild.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateChild.JunoDoc__Parent_Reference__c = 'AccountId';
        docTemplateChild.JunoDoc__Child_object__c = 'Contact';
        docTemplateChild.JunoDoc__Child_Query__c = 'Name,Account.Name,Account.owner.Name,Account.Createddate,createddate,Account.owner.isActive,Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Account.AnnualRevenue ASC';
        docTemplateChild.JunoDoc__Calculation_Fields__c = 'Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        //docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT Count(id) FROM Contact WHERE Id != null GROUP BY Id';
        //docTemplateChild.JunoDoc__Group_By__c = 'ID';
        docTemplateChildsList.add(docTemplateChild);
        insert docTemplateChildsList; 
        System.assertEquals('Contact', docTemplateChildsList[0].JunoDoc__Child_object__c);
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
        HeaderList = new List<JunoDoc__Doc_Template_Header__c>();
        Header = new JunoDoc__Doc_Template_Header__c();
        Header.JunoDoc__Master_Object__c = 'Account';
        Header.JunoDoc__Master_Object_Fields__c = 'Name,Id,Owner.Name';
        Header.JunoDoc__Header_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Account', HeaderList[0].JunoDoc__Master_Object__c);
    }
    
    public static void insertFooters(){
        FooterList = new List<JunoDoc__Doc_Template_Footer__c>();
        Footer = new JunoDoc__Doc_Template_Footer__c();
        Footer.JunoDoc__Master_Object__c = 'Account';
        Footer.JunoDoc__Master_Object_Fields__c = 'Name,Id';
        Footer.JunoDoc__Footer_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Account', FooterList[0].JunoDoc__Master_Object__c);
    }
    
    
     public static void insertconHeaders(){
        HeaderList = new List<JunoDoc__Doc_Template_Header__c>();
        Header = new JunoDoc__Doc_Template_Header__c();
        Header.JunoDoc__Master_Object__c = 'Contact';
        Header.JunoDoc__Master_Object_Fields__c = 'Name,Id,Owner.Name,Account.owner.Name';
        Header.JunoDoc__Header_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        System.assertEquals('Contact', HeaderList[0].JunoDoc__Master_Object__c);
    }
    
    public static void insertconFooters(){
        FooterList = new List<JunoDoc__Doc_Template_Footer__c>();
        Footer = new JunoDoc__Doc_Template_Footer__c();
        Footer.JunoDoc__Master_Object__c = 'Contact';
        Footer.JunoDoc__Master_Object_Fields__c = 'Name,Id,Account.owner.isActive';
        Footer.JunoDoc__Footer_Body__c = '<div><div>{!Name}</div><div>{!TODAY()}</div><div>{!NOW()}</div><div>{!Id}</div></div>';
       
        FooterList.add(Footer);
        insert FooterList;
        System.assertEquals('Contact', FooterList[0].JunoDoc__Master_Object__c);
    }
    
    private static testMethod void testtwo(){
        FooterList = new List<JunoDoc__Doc_Template_Footer__c>();
        Footer = new JunoDoc__Doc_Template_Footer__c();
        Footer.JunoDoc__Master_Object__c = 'Quote';
        Footer.JunoDoc__Master_Object_Fields__c = 'Name,subtotal,Owner.Name, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Footer.JunoDoc__Footer_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
       
        FooterList.add(Footer);
        insert FooterList;
        
        HeaderList = new List<JunoDoc__Doc_Template_Header__c>();
        Header = new JunoDoc__Doc_Template_Header__c();
        Header.JunoDoc__Master_Object__c = 'Quote';
        Header.JunoDoc__Master_Object_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        Header.JunoDoc__Header_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        
        List<JunoDoc__Doc_Template__c> dtRecords = [SELECT Id FROM JunoDoc__Doc_Template__c];
        DELETE dtRecords;
        List<JunoDoc__Doc_Template_Header__c> Headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c];
        List<JunoDoc__Doc_Template_Footer__c> Footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template__c]);
        docTemplate = new JunoDoc__Doc_Template__c();
        docTemplate.Name = 'Test quo Template';
        docTemplate.JunoDoc__Parent_Object__c = 'Quote';
        docTemplate.JunoDoc__Doc_Template_Header__c = Headers[0].Id;
        docTemplate.JunoDoc__Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.JunoDoc__Single_Page__c = true;
        docTemplate.JunoDoc__Parent_Fields__c = 'Name,subtotal,ShippingHandling,Owner.Name,Opportunity.Closedate,GrandTotal,Opportunity.IqScore, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert docTemplate;
        
        List<JunoDoc__Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM JunoDoc__Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Item__c]);
        docTemplateItemsList = new List<JunoDoc__Doc_Template_Item__c>();
        docTemplateItem = new JunoDoc__Doc_Template_Item__c();
        docTemplateItem.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateItem.JunoDoc__Page_Render__c = 'Id!=null';
        docTemplateItem.JunoDoc__Template_body__c = '<tbody id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        
        List<JunoDoc__Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM JunoDoc__Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Child__c]);
        docTemplateChildsList = new List<JunoDoc__Doc_Template_Child__c>();
        docTemplateChild = new JunoDoc__Doc_Template_Child__c();
        docTemplateChild.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateChild.JunoDoc__Parent_Reference__c = 'OpportunityId';
        docTemplateChild.JunoDoc__Child_object__c = 'Quote';
        docTemplateChild.JunoDoc__Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name,createddate, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        docTemplateChild.JunoDoc__Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        docTemplateChild.JunoDoc__Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        docTemplateChild.JunoDoc__Related_Object_Labels__c = 'Discount[[Center]],Grand Total[[Center]],Subtotal[[Center]],Quote Number';
        docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT SUM(SubTotal) Subtotals, SUM(GrandTotal) TotalPrices from quote group by  OpportunityId';
        docTemplateChild.JunoDoc__Group_By__c = 'OpportunityId';
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
         
    }
     private static testMethod void testthree(){
        FooterList = new List<JunoDoc__Doc_Template_Footer__c>();
        Footer = new JunoDoc__Doc_Template_Footer__c();
        Footer.JunoDoc__Master_Object__c = 'Quote';
        Footer.JunoDoc__Master_Object_Fields__c = '';
        Footer.JunoDoc__Footer_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.Closedate}{!Opportunity.TotalOpportunityQuantity}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
       
        FooterList.add(Footer);
        insert FooterList;
        
        HeaderList = new List<JunoDoc__Doc_Template_Header__c>();
        Header = new JunoDoc__Doc_Template_Header__c();
        Header.JunoDoc__Master_Object__c = 'Quote';
        Header.JunoDoc__Master_Object_Fields__c = '';
        Header.JunoDoc__Header_Body__c = '<div id="Contact2">{!TODAY()}{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.TotalOpportunityQuantity},{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}</div>';
        
        HeaderList.add(Header);
        insert HeaderList;
        
        List<JunoDoc__Doc_Template__c> dtRecords = [SELECT Id FROM JunoDoc__Doc_Template__c];
        DELETE dtRecords;
        List<JunoDoc__Doc_Template_Header__c> Headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c];
        List<JunoDoc__Doc_Template_Footer__c> Footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c];
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template__c]);
        docTemplate = new JunoDoc__Doc_Template__c();
        docTemplate.Name = 'Test quo Template';
        docTemplate.JunoDoc__Parent_Object__c = 'Quote';
        //docTemplate.Doc_Template_Header__c = Headers[0].Id;
        //docTemplate.Doc_Template_Footer__c = Footers[0].Id;
        docTemplate.JunoDoc__Single_Page__c = true;
        docTemplate.JunoDoc__Parent_Fields__c = 'Name,subtotal,Discount,ExpirationDate,ShippingHandling,Owner.Name,Opportunity.TotalOpportunityQuantity,Opportunity.Closedate,GrandTotal,Opportunity.IqScore, Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees';
        insert docTemplate;
        
        List<JunoDoc__Doc_Template_Item__c> dtItemRecords = [SELECT Id FROM JunoDoc__Doc_Template_Item__c];
        DELETE dtItemRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Item__c]);
        docTemplateItemsList = new List<JunoDoc__Doc_Template_Item__c>();
        docTemplateItem = new JunoDoc__Doc_Template_Item__c();
        docTemplateItem.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateItem.JunoDoc__Page_Render__c = 'Id!=null';
         docTemplateItem.JunoDoc__Template_body__c = '<tbody id="Contact2">{!TODAY()}[{Discount}]{!NOW()}{!#User.Name}{{QuoteNumber}}{!Opportunity.TotalOpportunityQuantity}{!Opportunity.Closedate}{!Opportunity.Createddate}{!Opportunity.owner.Name}{!Opportunity.Account.NumberOfEmployees}{!Opportunity.Account.owner.createdDate}';
        docTemplateItemsList.add(docTemplateItem);
        insert docTemplateItemsList;
        
        List<JunoDoc__Doc_Template_Child__c> dtChildRecords = [SELECT Id FROM JunoDoc__Doc_Template_Child__c];
        DELETE dtChildRecords;
        System.assertEquals(0,[SELECT count() FROM JunoDoc__Doc_Template_Child__c]);
        docTemplateChildsList = new List<JunoDoc__Doc_Template_Child__c>();
        docTemplateChild = new JunoDoc__Doc_Template_Child__c();
        docTemplateChild.JunoDoc__Doc_Template__c = docTemplate.Id;
        docTemplateChild.JunoDoc__Parent_Reference__c = 'OpportunityId';
        docTemplateChild.JunoDoc__Child_object__c = 'Quote';
        docTemplateChild.JunoDoc__Child_Query__c = 'Name,subtotal,ShippingHandling,Owner.Name,createddate,Opportunity.TotalOpportunityQuantity, Opportunity.Closedate,Opportunity.owner.Name, Opportunity.Account.owner.isActive,Opportunity.Account.owner.createdDate, Opportunity.Account.NumberOfEmployees, Opportunity.Account.IsCustomerPortal';
        docTemplateChild.JunoDoc__Sort_Order__c = 2;
        docTemplateChild.JunoDoc__Filter__c = 'Id!= null';
        docTemplateChild.JunoDoc__Order_By__c = 'Opportunity.Account.NumberOfEmployees ASC';
        docTemplateChild.JunoDoc__Calculation_Fields__c = 'Opportunity.Account.AnnualRevenue';
        docTemplateChild.JunoDoc__Render_Condition__c = '{{Id}} != NULL';
        docTemplateChild.JunoDoc__Related_Object_Labels__c = 'Discount[[Center]],Grand Total[[Center]],Subtotal[[Center]],Quote Number';
        docTemplateChild.JunoDoc__Aggregate_Query__c = 'SELECT SUM(SubTotal) Subtotals, SUM(GrandTotal) TotalPrices from quote group by  OpportunityId';
        docTemplateChild.JunoDoc__Group_By__c = 'OpportunityId';
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

    }
}
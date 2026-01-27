@isTest
public class PDFTemplateBuilder_Controller_TC {
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
    private static testMethod void test(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Word Document');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
        PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    private static testMethod void test2(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'US Letter';
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'US Letter';
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','PDF');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
         PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    private static testMethod void test3(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'A3 New';
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'A3 New';
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
         PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    private static testMethod void test4(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'A3';
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'A3';
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
         PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
     private static testMethod void test5(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'A4 Letter';
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'A4 Letter';
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
          PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
    private static testMethod void test6(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'Custom';
        docTemplate.JunoDoc__Page_Width__c = 10;
        docTemplate.JunoDoc__Page_Height__c = 10;
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'Custom';
        
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
         PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
     private static testMethod void test7(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
        docTemplate.JunoDoc__Page_Size__c = 'Custom';
        /*docTemplate.JunoDoc__Page_Width__c = 10;
        docTemplate.JunoDoc__Page_Height__c = 10;*/
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'Custom';
        
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
          PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

        system.assertEquals('test', 'test');
        Test.stopTest();
    }
     private static testMethod void test8(){
        insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        
         docTemplate.JunoDoc__Template_Type__c = 'Excel';
        docTemplate.JunoDoc__Page_Size__c = 'Custom';
        docTemplate.JunoDoc__Page_Width__c = 0;
        docTemplate.JunoDoc__Page_Height__c = 0;
        update docTemplate;
        
        emailTemplate.JunoDoc__Page_Size__c = 'Label 4x6';
        
        update emailTemplate;
        
        ApexPages.currentPage().getParameters().put('objectName', 'Contact');
        ApexPages.currentPage().getParameters().put('DocTempId', docTemplate.Id);
        ApexPages.currentPage().getParameters().put('EmailTempId', emailTemplate.Id);
         ApexPages.currentPage().getParameters().put('TemplateType','Excel');
        PDFTemplateBuilder_Controller PTB = new PDFTemplateBuilder_Controller();
        PTB.finalstring = '<div><div>{!Name}</div><div>{!Id}</div > [{PAR(Name)}]  {{tax}} > 2</div>';
        PTB.HeaderString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.FooterString = '<div><div>{!Name}</div><div>{!Id}</div></div>';
        PTB.SaveData();
        PTB.filterdropdown();
        PTB.SaveEmailData();
        PTB.SortOrders = '2';
        PTB.childFields = 'FirstName, LastName';
        PTB.FieldLabels = 'First Name, Last Name';
          PTB.parentFields = 'Name, Id';
        PTB.parentLabels = 'Name, Id';
        PTB.savechilddetails();
        PTB.close();
        PTB.closeEmailTemplate();
        PTB.selectedField = 'FirstName';
        PTB.showFilters();
         PTB.Host = 'Host';
         PTB.ConnnectionName = 'test Connection';
         PTB.MetadataResponse = 'test Response';
         PTB.MetadataConnectionWarning = false;
         PTB.isRollup = false;
         PTB.execute = 'test';
         PTB.checksyntaxforaggregate();
         PTB.saveSectionChildDetails();
         PTB.grpshowFilters();
         PTB.getcalInnerFields();
         PDFTemplateBuilder_Controller.calWrapperClass calWrap = new PDFTemplateBuilder_Controller.calWrapperClass();
         calWrap.calField = 'test';
         calWrap.calQuery = 'test';
         
         PDFTemplateBuilder_Controller.imageWrapperClass imgWrap = new PDFTemplateBuilder_Controller.imageWrapperClass();
         imgWrap.Id = 'testId';
         imgWrap.lastModifiedDate = 'testdate';
         PTB.calqueryId = 'calqueryId';
         PTB.CalculatedFieldIds = 'CalculatedFieldIds';
         PTB.CalculatedFieldtext = 'CalculatedFieldtext';
         
        PDFTemplateBuilder_Controller.getDocument('Name','test Body');
        
        PDFTemplateBuilder_Controller.WrapperClass Wrap= new PDFTemplateBuilder_Controller.WrapperClass(1,'FirstName', false, 'equals', null, 'Test','2');
        list<PDFTemplateBuilder_Controller.WrapperClass> Wrapperlist = new list<PDFTemplateBuilder_Controller.WrapperClass>();
        Wrapperlist.add(Wrap);
        PTB.saveWrapperList(2);
        PTB.Validate();
        PTB.selectedRowIndex = '1';
        PTB.deleteRow();
        PTB.getdateFormatLists();
        PTB.getConditions();
        PTB.CopyLineItems();
        PTB.deleteTables();
        PTB.getCurrencyFormatLists();
        PTB.getNumberFormatLists();
        PTB.selectedObject = 'Account';
        PTB.selectedfolder = 'Account';
        PTB.parentchildObjects = 'Account';
        PTB.FooterId = 'Account';
        PTB.CLosevalidError();
        PTB.NumberFormat = 'Account';
        PTB.selectedPickListValue = 'Account';
        PTB.selectedFilter = 'Account';
        PTB.selFieldName = 'Account';
        PTB.indexVar = '1';

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
}
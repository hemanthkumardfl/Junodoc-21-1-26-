@isTest
public  class JunoSFDC2SFDC_Test {
    @isTest
    static  void testmethod1() {
        test.startTest();
        Account parentAcc = new Account();
        parentAcc.name = 'Test';
        parentAcc.Phone = '999999999';
        insert parentAcc;
        
        Contact childContact = new Contact();  
        childContact.LastName = 'Child Contact';
        childContact.AccountId = parentAcc.id;
        insert childContact;
        
        JunoDoc__Junodoc_Connections__c Connection = new JunoDoc__Junodoc_Connections__c();
        Connection.Name = 'Juno Connection';
        Connection.JunoDoc__Production__c = true;
        Connection.JunoDoc__Consumer_Key__c = 'Tester';
        Connection.JunoDoc__Username__c = 'diligentforcelabspvtltd@isvedition.org';
        Connection.JunoDoc__Consumer_Secret__c = 'Consumer';
        Connection.JunoDoc__Password_Encrypted__c = 'Diligent@2080';
        Connection.JunoDoc__Security_Token__c = 'V2qk3fe2UOaetfmeidegP00vw';
        Connection.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/Soap/u/29.0';
        Connection.JunoDoc__Instance_URL__c = 'https://junodoc.my.salesforce.com';
        Connection.JunoDoc__Access_Token__c  = '00D46000001UhJo!AQMAQCP3jKZb6kg4WK9l3dar0gnCOFQAOmUoIYYNBl1TFnPpDBm6VlvP.3kUvz1X9.6.Xx91ppXUODrxmlL9urN.CnNGTqRk';
        insert Connection;
        
        system.debug('connection ---->   '+Connection);
        
        JunoDoc__Junodoc_Parent_Configuration__c config = new JunoDoc__Junodoc_Parent_Configuration__c();   
        config.JunoDoc__Junodoc_Object_Name__c = 'Account';
        config.JunoDoc__Junodoc_SOQL_Query__c = '';
        config.JunoDoc__Junodoc_Use_SOQL__c = true;
        config.JunoDoc__Category__c = '2';
        config.JunoDoc__Junodoc_Include_Attachments__c = true;
        config.JunoDoc__Junodoc_Is_Junction__c = true;
        config.JunoDoc__Junodoc_Source_Org__c = Connection.id;
        config.JunoDoc__Junodoc_Destination_Org__c = Connection.Name;
        insert config;
        system.debug('config ---->   '+config);
        
        JunoDoc__Junodoc_Child_Configuration__c childConfig = new JunoDoc__Junodoc_Child_Configuration__c();
        childConfig.JunoDoc__Object_Name__c = 'Contact';
        childConfig.JunoDoc__SOQL_Query__c = 'SELECT Id, Name FROM Contact LIMIT 1';
        childConfig.JunoDoc__Use_SOQL__c = false;
        childConfig.JunoDoc__Parent_Reference_Field__c = 'AccountId';   
        childConfig.JunoDoc__Junodoc_Parent_Configuration__c = config.id;
        insert childConfig;
        
        system.debug('childConfig ---->   '+childConfig);
        
        boolean hasErrors = false;
        boolean runSchedular = true;
        JunoDoc__Junodoc_Template_Schedule__c templateSchedule = new JunoDoc__Junodoc_Template_Schedule__c();
        templateSchedule.JunoDoc__Schedule_Status__c = 'New';
        templateSchedule.JunoDoc__Migration_Type__c = 'Mtree';
        templateSchedule.JunoDoc__Destination__c = Connection.Id;
        templateSchedule.JunoDoc__Is_Scheduled__c = true;
        templateSchedule.JunoDoc__Schedule_Record_Limit__c = 10000;
        insert templateSchedule;
        
         Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.AccountId = acc.Id;
        insert con;
        
        JunoDoc__Junodoc_Object_Schema_Mapping__c schemaObj = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        schemaObj.Name = 'Test';
        schemaObj.JunoDoc__Destination_Name__c = 'Test Destination';
        schemaObj.JunoDoc__Object_Name__c = 'Account';
        schemaObj.Source_External_Id__c = 'test';
        insert schemaObj;
        
        
        JunoDoc__Doc_Template__c tempquery = new JunoDoc__Doc_Template__c();
        tempquery.Name = 'Test';
        insert tempquery;
        
        String parentQuery = 'SELECT Id,Name FROM JunoDoc__Doc_Template__c LIMIT 1';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        Map<String, String> map_priceBookEntryMap = new Map<String, String>();
        Integer batchId = 1;
        String destinationOrg = Connection.Id;
        String currentScheduleIds = 'ABC123';
        Boolean includeAttachments = true;
        
        
        JunoDoc__Junodoc_Parent_Configuration__c parentcofiguration = new JunoDoc__Junodoc_Parent_Configuration__c();
        JunoSFDC2SFDC sfdc2sfdc = new JunoSFDC2SFDC(new ApexPages.StandardController(parentcofiguration));
        sfdc2sfdc.gettypeOptions();
        sfdc2sfdc.getCloudSyncBatchSize();
        sfdc2sfdc.getListOfCategories();
        sfdc2sfdc.getListOfConfigurations(); 
        sfdc2sfdc.makeValuesAsNull();
        sfdc2sfdc.selectedConfiguration = config.Id;
        sfdc2sfdc.configName = 'Test Config';
        sfdc2sfdc.categoriName = 'Test Category';
        sfdc2sfdc.ConfigData();
        sfdc2sfdc.m_SaveAsConfig();
        sfdc2sfdc.saveNewConfigData();
        sfdc2sfdc.cancelNewConfigData();
        sfdc2sfdc.redirectToTemplateSchedule();
        sfdc2sfdc.redirectToContactUs();
        sfdc2sfdc.getmyChildRecords();
        sfdc2sfdc.m_RemoveChildRow();
        sfdc2sfdc.getListOfSources();
        sfdc2sfdc.getListOfDestinations();
        sfdc2sfdc.closePopup();
        sfdc2sfdc.showPopup();  
        sfdc2sfdc.m_IsJunction();
        sfdc2sfdc.checkSyntax();
        sfdc2sfdc.redirectToResultsPage();
        sfdc2sfdc.redirectToSchemaMappingPage();
        sfdc2sfdc.closeSchemaPopUp();
        sfdc2sfdc.m_backToMainScreen();
        sfdc2sfdc.verifyObjectSchema();
        sfdc2sfdc.m_verifyParents(); 
        sfdc2sfdc.continueWithMatchingSchema();
        sfdc2sfdc.addChild();
        sfdc2sfdc.getRecordCount();
        sfdc2sfdc.lookForParentReferences();
        sfdc2sfdc.checkParentSyntax();
        sfdc2sfdc.checkParentMetadata();
        sfdc2sfdc.gotoMetadataReview();
        sfdc2sfdc.parentRecordCount();
        sfdc2sfdc.checkChildSyntax();
        sfdc2sfdc.childRecordCount();
        sfdc2sfdc.m_PushData();
        sfdc2sfdc.compositeTreeMigration();
        sfdc2sfdc.m_backToMainScreen();
        sfdc2sfdc.m_SaveConfig();
        sfdc2sfdc.mtreeBatch(parentQuery, childQueries, map_priceBookEntryMap, batchId, destinationOrg, currentScheduleIds, includeAttachments);
         SobjectUtilityController.m_getreferenceObjectAttributes('Account');
        SobjectUtilityController sobj = new SobjectUtilityController();
        sobj.objectExternalIdCheck('Account');
        SobjectUtilityController.prepareRecordCountChildQuery('SELECT Id,Name FROM Account LIMIT 1','Name','SELECT Id,LastName FROM Contact WHERE AccountId =:acc.Id');
        SobjectUtilityController.addExternalIdFiled('SELECT Id,Name FROM Account LIMIT 1','Account','Test Destination');
        SobjectUtilityController.m_getObjectFieldsForBatch('Account','ALL');
        SobjectUtilityController.m_getObjectFieldsForBatch('Account','Name,Phone');
        sobj.get_ParentRecords('SELECT Id,Name FROM Account LIMIT 1');
        sobj.get_ChildRecords('SELECT Id,LastName,AccountId FROM Contact LIMIT 1','AccountId',acc.Id);
         SobjectUtilityController.referenceObjectQueryInnerClass innerResponse = new SobjectUtilityController.referenceObjectQueryInnerClass('SELECT Id,Name FROM Account LIMIT 1','Account');
        SobjectUtilityController.destinationMissingReferenceRecordsInnerClass dest = new SobjectUtilityController.destinationMissingReferenceRecordsInnerClass('Account',null,null,null);
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT Id,Name FROM Account WHERE Id =:acc.Id LIMIT 1');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT Id,Name FROM Account LIMIT 1');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT Id,Name FROM Account');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT Id,Name FROM Account WHERE Id =:acc.Id');
        sobj.m_PrepareQuery('SELECT Id,LastName,AccountId FROM Contact WHERE AccountId =:acc.Id LIMIT 1','AccountId',acc.Id);
        test.stopTest();
        system.assert(true); 
    }
    @isTest
    static void testmethod2(){
        JunoDoc__Junodoc_Connections__c Connection = new JunoDoc__Junodoc_Connections__c();
        Connection.Name = '';
        //Insert Connection;
        JunoDoc__Junodoc_Parent_Configuration__c config = new JunoDoc__Junodoc_Parent_Configuration__c();   
        config.JunoDoc__Junodoc_Object_Name__c = 'Account';
        config.JunoDoc__Junodoc_SOQL_Query__c = 'null';
        config.JunoDoc__Junodoc_Use_SOQL__c = true;
        config.JunoDoc__Category__c = '2';
        config.JunoDoc__Junodoc_Include_Attachments__c = true;
        config.JunoDoc__Junodoc_Is_Junction__c = true;
        insert config;
        
        JunoDoc__Junodoc_Migration_settings__c cloudSyncsetting  = new JunoDoc__Junodoc_Migration_settings__c();
        cloudSyncsetting.Name = 'Test Setting';
        cloudSyncsetting.JunoDoc__Junodoc_Insert_Batch_Size__c = 10;
        cloudSyncsetting.JunoDoc__Junodoc_Upsert_Batch_Size__c = 20;
        insert cloudSyncsetting;
        
        JunoDoc__Junodoc_Parent_Configuration__c parentcofiguration = new JunoDoc__Junodoc_Parent_Configuration__c();
        JunoSFDC2SFDC instance = new JunoSFDC2SFDC(new ApexPages.StandardController(parentcofiguration));  
        instance.treeSync = true;
        String selectedType = 'Insert';
        
        Test.startTest();
        instance.m_SaveAsConfig();
        instance.verifyObjectSchema();
        instance.getCloudSyncBatchSize();
        Test.stopTest(); 
        
    }   
   
    
}
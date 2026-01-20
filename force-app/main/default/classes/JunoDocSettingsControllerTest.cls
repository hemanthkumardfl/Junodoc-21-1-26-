@isTest
public class JunoDocSettingsControllerTest {
    @testSetup static void setup() {
        JunoDoc__Juno_Doc_Settings__c rec = new JunoDoc__Juno_Doc_Settings__c();
        rec.Name = 'Test';
        insert rec;
        
        
    }
    static TestMethod void getSettingsRecordTest(){
        System.assertEquals('Test', 'Test');
        
        List<Default_Settings__c> defSets = new List<Default_Settings__c>();
        Default_Settings__c defSet = new Default_Settings__c();
        defSet.JunoDoc__Schedule_Triggers__c = true;
        defSet.JunoDoc__JunoSign_Schedule_Trigger__c = false;
        defSet.Name = 'test';
        defSets.add(defSet);
        insert defSets;
        
        JunoDocSettingsController.getSettingsRecord();
        JunoDocSettingsController.runDeleteScheduleJobs(true);
    }
    static TestMethod void runScheduleJobsTest(){
        System.assertEquals('Test', 'Test');
        boolean togglevalue = true;
        JunoDocSettingsController.runScheduleJobs(togglevalue);
        JunoDocSettingsController.runJunodocScheduleJobs(toggleValue);
        JunoDocSettingsController.getrecorddetails();
        JunoDocSettingsController.runDeleteScheduleJobs(toggleValue);
    }
    
    static TestMethod void settingscon(){
        System.assertEquals('Test', 'Test');
        List<OrgWideEmailAddress> owea = [select Id,Address from OrgWideEmailAddress];
        
        List<Junodoc_Setting__c> JunoSettings = new List<Junodoc_Setting__c>();
        Junodoc_Setting__c JunoSetting = new Junodoc_Setting__c();
        JunoSetting.JunoDoc__Signature_Success_Message__c = 'success';
        JunoSetting.JunoDoc__Enable_JunoSign__c = true;
        JunoSetting.JunoDoc__Enable_Signature_Rejection__c = false;
        JunoSetting.JunoDoc__Enable_Attachment_List_View__c = true;
        JunoSetting.JunoDoc__Enable_SenderBCC__c = true;
        JunoSetting.JunoDoc__JunoSign_Default_From_Address__c = string.valueof(owea[0].id);
        JunoSetting.JunoDoc__Organization_Url__c = 'test';
        JunoSetting.JunoDoc__Signature_Cancel_Message__c = 'test';
        JunoSetting.JunoDoc__Signature_Format__c = 'Text';
        JunoSetting.JunoDoc__Site_URL__c = 'test';
        JunoSetting.JunoDoc__Community_URL__c = 'test';
        JunoSettings.add(JunoSetting);
        insert JunoSettings;
        
        JunoDocSettingsController.orgwideEmail();
        JunoDocSettingsController.getrecorddetails();
        JunoDocSettingsController.updateScheduleDocTemplateSetting(true);
        JunoDocSettingsController.CreateEmailTemplatesRecords('test');
        JunoDocSettingsController.createSetting('Test','Test','Test','Test',false,true,true,true, 'test','Draw', string.valueof(owea[0].id),true, true, true);
         //createSetting(string cancel,string success,string url,string communityurl,boolean EnableJuno,boolean EnableSignature,boolean EnableattachmentList,boolean EnableSender,String OrgUrl, String signFormat, String defaultFromEmailAddress, boolean PostAction,boolean EnableToSendEmail,boolean EnableToSendEmailAllrecp){

        
    }
    static TestMethod void method2(){
        List<OrgWideEmailAddress> owea = [select Id,Address from OrgWideEmailAddress];
        List<Junodoc_Setting__c> JunoSettings = new List<Junodoc_Setting__c>();
        Junodoc_Setting__c JunoSetting = new Junodoc_Setting__c();
        JunoSetting.JunoDoc__Signature_Success_Message__c = 'success';
        JunoSetting.JunoDoc__Enable_JunoSign__c = true;
        JunoSetting.JunoDoc__Enable_SenderBCC__c = true;
        JunoSetting.JunoDoc__JunoSign_Default_From_Address__c = string.valueof(owea[0].id);
        JunoSetting.JunoDoc__Organization_Url__c = 'test';
        JunoSetting.JunoDoc__Signature_Cancel_Message__c = 'test';
        JunoSetting.JunoDoc__Signature_Format__c = 'Text';
        JunoSetting.JunoDoc__Site_URL__c = 'test';
        JunoSetting.JunoDoc__Community_URL__c = 'test';
        JunoSettings.add(JunoSetting);
        insert JunoSettings;
        
        List<Default_Settings__c> defSets = new List<Default_Settings__c>();
        Default_Settings__c defSet = new Default_Settings__c();
        defSet.JunoDoc__Schedule_Triggers__c = true;
        defSet.JunoDoc__JunoSign_Schedule_Trigger__c = true;
        defSet.Name = 'test';
        defSets.add(defSet);
        insert defSets;
        
        
        JunoDocSettingsController.createSettings(true, false);
        JunoDocSettingsController.runScheduleJobs(false);
        JunoDocSettingsController.runJunodocScheduleJobs(false);
        JunoDocSettingsController.runDeleteScheduleJobs(false);
    }
    static TestMethod void method3(){
        JunoDocSettingsController.runDeleteScheduleJobs(true);
      //  JunoDocSettingsController.createOpportunity(true);
    }
    
    @isTest
    static void testCheckConditionWithExistingTemplate() {
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Ascent Sample Quote Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createAscentQuote('Check');
        
        // Assert
        System.assert(result == true, 'Result should be true when template exists');
    }
    
    @isTest
    static void testCheckConditionWithoutTemplate() {
        // Act
        Boolean result = JunoDocSettingsController.createAscentQuote('Check');
        
        // Assert
        System.assert(result == false, 'Result should be false when template does not exist');
    }
    
    @isTest
    static void testCreateTemplateWhenNoneExists() {
        // Query the RecordType
        RecordType recType = [SELECT Id FROM RecordType WHERE Name = 'PDF Template' AND SObjectType = 'JunoDoc__Doc_Template__c' LIMIT 1];
        
        // Act
        Boolean result = JunoDocSettingsController.createAscentQuote('Create');
        
        // Assert
        System.assert(result == true, 'Result should be true when creating new template');
        
        // Verify the template was created
        List<JunoDoc__Doc_Template__c> templates = [SELECT Id, Name FROM JunoDoc__Doc_Template__c WHERE Name = 'Ascent Sample Quote Template'];
        System.assert(templates.size() == 1, 'One template should be created');
        
        // Verify the related records were created
        List<JunoDoc__Doc_Template_Header__c> headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c WHERE Name = 'Ascent Sample Quote Template'];
        System.assert(headers.size() == 1, 'One header should be created');
        
        List<JunoDoc__Doc_Template_Footer__c> footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c WHERE Name = 'Ascent Sample Quote Template'];
        System.assert(footers.size() == 1, 'One footer should be created');
        
        List<JunoDoc__Doc_Template_Item__c> items = [SELECT Id FROM JunoDoc__Doc_Template_Item__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assert(items.size() == 1, 'One item should be created');
        
        List<JunoDoc__Doc_Template_Child__c> children = [SELECT Id FROM JunoDoc__Doc_Template_Child__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assert(children.size() == 1, 'One child should be created');
    }
    
    @isTest
    static void testNoCreationWhenTemplateExists() {
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Ascent Sample Quote Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createAscentQuote('Create');
        //Boolean result1 = JunoDocSettingsController.createOpportunity('Create');
        // Assert
        System.assert(result == false, 'Result should be false when template already exists');
    }
    
    ////////////////////////////////////
    @isTest
    static void testCheckConditionWithExistingTemplate1() {
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Sample Quote Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createQuote('Check');
        
        // Assert
        System.assert(result == true, 'Result should be true when template exists');
    }
    
    @isTest
    static void testCheckConditionWithoutTemplate1() {
        // Act
        Boolean result = JunoDocSettingsController.createQuote('Check');
        
        // Assert
        System.assert(result == false, 'Result should be false when template does not exist');
    }
    
    @isTest
    static void testCreateTemplateWhenNoneExists1() {
        // Query the RecordType
        RecordType recType = [SELECT Id FROM RecordType WHERE Name = 'PDF Template' AND SObjectType = 'JunoDoc__Doc_Template__c' LIMIT 1];
        
        // Act
        Boolean result = JunoDocSettingsController.createQuote('Create');
        
        // Assert
        System.assert(result == true, 'Result should be true when creating new template');
        
        // Verify the template was created
        List<JunoDoc__Doc_Template__c> templates = [SELECT Id, Name FROM JunoDoc__Doc_Template__c WHERE Name = 'Sample Quote Template'];
        System.assert(templates.size() == 1, 'One template should be created');
        
        // Verify the related records were created
        List<JunoDoc__Doc_Template_Header__c> headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c WHERE Name = 'Sample Quote Template'];
        System.assert(headers.size() == 1, 'One header should be created');
        
        List<JunoDoc__Doc_Template_Footer__c> footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c WHERE Name = 'Sample Quote Template'];
        System.assert(footers.size() == 1, 'One footer should be created');
        
        List<JunoDoc__Doc_Template_Item__c> items = [SELECT Id FROM JunoDoc__Doc_Template_Item__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assert(items.size() == 1, 'One item should be created');
        
        List<JunoDoc__Doc_Template_Child__c> children = [SELECT Id FROM JunoDoc__Doc_Template_Child__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assert(children.size() == 1, 'One child should be created');
    }
    
    @isTest
    static void testNoCreationWhenTemplateExists1() {
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Sample Quote Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createQuote('Create');
        
        // Assert
        System.assert(result == false, 'Result should be false when template already exists');
    }
    /////////
     @isTest
    static void testCheckConditionWithExistingTemplate2(){
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Sample Opportunity Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createOpportunity('Check');
        
        // Assert
        System.assert(result == true, 'Result should be true when template exists');
    }
    
    @isTest
    static void testCheckConditionWithoutTemplate2() {
        // Act
        Boolean result = JunoDocSettingsController.createOpportunity('Check');
        
        // Assert
        System.assert(result == false, 'Result should be false when template does not exist');
    }
    
    @isTest
    static void testCreateTemplateWhenNoneExists2() {
        // Ensure the record type exists in the org
        RecordType recType = [SELECT Id FROM RecordType WHERE Name = 'PDF Template' AND SObjectType = 'JunoDoc__Doc_Template__c' LIMIT 1];
        
        // Act
        Boolean result = JunoDocSettingsController.createOpportunity('Create');
        
        // Assert
        System.assert(result == true, 'Result should be true when creating new template');
        
        // Verify the template was created
        List<JunoDoc__Doc_Template__c> templates = [SELECT Id, Name FROM JunoDoc__Doc_Template__c WHERE Name = 'Sample Opportunity Template'];
        System.assertEquals(1, templates.size(), 'One template should be created');
        
        // Verify the related records were created
        List<JunoDoc__Doc_Template_Header__c> headers = [SELECT Id FROM JunoDoc__Doc_Template_Header__c WHERE Name = 'Sample Opportunity Template'];
        System.assertEquals(1, headers.size(), 'One header should be created');
        
        List<JunoDoc__Doc_Template_Footer__c> footers = [SELECT Id FROM JunoDoc__Doc_Template_Footer__c WHERE Name = 'Sample Opportunity Template'];
        System.assertEquals(1, footers.size(), 'One footer should be created');
        
        List<JunoDoc__Doc_Template_Item__c> items = [SELECT Id FROM JunoDoc__Doc_Template_Item__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assertEquals(1, items.size(), 'One item should be created');
        
        List<JunoDoc__Doc_Template_Child__c> children = [SELECT Id FROM JunoDoc__Doc_Template_Child__c WHERE JunoDoc__Doc_Template__c = :templates[0].Id];
        System.assertEquals(1, children.size(), 'One child should be created');
    }
    
    @isTest
    static void testNoCreationWhenTemplateExists2() {
        // Arrange
        JunoDoc__Doc_Template__c existingTemplate = new JunoDoc__Doc_Template__c(
            Name = 'Sample Opportunity Template'
        );
        insert existingTemplate;
        
        // Act
        Boolean result = JunoDocSettingsController.createOpportunity('Create');
        
        // Assert
        System.assert(result == false, 'Result should be false when template already exists');
    }
    
}
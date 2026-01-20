@isTest
public class Dynamic_GeneratePDF_Controller_TC {
   private static Doc_Template__c docTemplate;
    private static Doc_Template_Item__c docTemplateItem;
    private static List<Doc_Template_Item__c> docTemplateItemsList;  
    private static Doc_Template_Child__c docTemplateChild;
    private static List<Doc_Template_Child__c> docTemplateChildsList;
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
    private static testMethod void test(){
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        insertUsers();
        insertAccounts();
        insertContacts();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        List<String> toUserEmailsList = new List<String>();
        toUserEmailsList.add(usersList[0].Email);
        List<String> toContactEmailsList = new List<String>();
        toContactEmailsList.add(contactList[0].Email);
        list<string> ToTextEmailsList = new list<string>();
        toUserEmailsList.add('test1234@gmail.com');
        list<string> ToEmailMergeFieldsList = new list<string>();
        ToEmailMergeFieldsList.add('Opportunity.Account.Owner.Email');
        list<string> CCTextEmailsList = new list<string>();
        CCTextEmailsList.add('test1234@gmail.com');
        list<string> CCEmailMergeFieldsList = new list<string>();
        
        list<string> BCCTextEmailsList = new  list<string>();
        BCCTextEmailsList.add('test1234@gmail.com');
        list<string> BCCEmailMergeFieldsList = new list<string>();
        
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
        
        
            
        JunoDoc__Junodoc_Setting__c DocSet = new JunoDoc__Junodoc_Setting__c();
        DocSet.JunoDoc__Organization_Url__c = '';
        DocSet.JunoDoc__Enable_SenderBCC__c = true;
        insert DocSet;
        
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Opportunity';
        JDT.Date_Format__c = 'MM/dd/yyyy';
        JDT.Junodoc__PDF_Name__c = 'Opp - {!Name} - {!owner.Name}'+' '+'{!TODAY()}'+ '    ' + ' {!NOW()} ' + ' {!Account.Owner.Name}';
        JDT.JunoDoc__Template_Type__c = 'Word Document';
        insert JDT;
        
        
        
        opportunity opp = new opportunity();
        opp.Name = 'testOpp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.today()+25;
        opp.IsPrivate = true;
        opp.Type = 'New Customer';
        opp.StageName = 'Prospecting';
        insert opp;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'StageName';
        PostAct.Field_Type__c = 'PICKLIST';
        PostAct.Field_Values__c = 'Qualification';
        PostAct.Junodoc_Templates__c = JDT.Id;
        PostAct.Generate_Check__c = 'true';
        PostAct.Attach_Check__c = 'false';
        PostAct.Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsPrivate';
        PostAct1.Field_Type__c = 'BOOLEAN';
        PostAct1.Field_Values__c = 'false';
        PostAct1.Junodoc_Templates__c = JDT.Id;
        PostAct.Generate_Check__c = 'false';
        PostAct.Attach_Check__c = 'true';
        PostAct.Mail_Check__c = 'false';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'CloseDate';
        PostAct2.Field_Type__c = 'DATE';
        PostAct2.Field_Values__c = 'Today';
        PostAct2.Junodoc_Templates__c = JDT.Id;
        PostAct.Generate_Check__c = 'false';
        PostAct.Attach_Check__c = 'false';
        PostAct.Mail_Check__c = 'true';
        insert PostAct2;
        
        String testReportId = '00O3h000003L6gqEAC';
        
         String PostActs = '[{"key":"Stage","Value":"Prospecting","FieldType":"PICKLIST","GenerateCheck":"true","AttachCheck":"false","MailCheck":"false"},{"key":"Private","Value":"false","FieldType":"BOOLEAN","GenerateCheck":"false","AttachCheck":"true","MailCheck":"false"},{"key":"Close Date","Value":"Today","FieldType":"DATE","GenerateCheck":"true","AttachCheck":"false","MailCheck":"true"}]';

        
        Dynamic_GeneratePDF_Controller.getAvailDocTemps(acc.Id, '');
        Dynamic_GeneratePDF_Controller.CreatePDF(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.SendPDF(acc.Id, docTemplate.Id, 'Test Email', 'Test Body', toUserEmailsList,toContactEmailsList,'test@test.com',true,new list<string>());
        
        list<Dynamic_GeneratePDF_Controller.fileDetails> fileDetailslist = new list<Dynamic_GeneratePDF_Controller.fileDetails>();
        Dynamic_GeneratePDF_Controller.fileDetails filedetailrec = new Dynamic_GeneratePDF_Controller.fileDetails();
        filedetailrec.fileName = 'Test.pdf';
        filedetailrec.Type = 'pdf';
        filedetailrec.fileContent = EncodingUtil.base64Encode(blob.valueOf('Test'));
        fileDetailslist.add(filedetailrec);
        Dynamic_GeneratePDF_Controller.SendPDFNew(opp.Id, JDT.Id, 'Test Email', 'Test Body', 
                                               'test@test.com', 'test@test.com', 'Sowndarya', true,
                                               ToTextEmailsList,ToEmailMergeFieldsList,
                                               CCTextEmailsList,CCEmailMergeFieldsList,
                                               BCCTextEmailsList,BCCEmailMergeFieldsList,fileDetailslist);
        Dynamic_GeneratePDF_Controller.getEmailTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(acc.Id, validEmailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplates(acc.Id, emailTemplate.Id);        
        Dynamic_GeneratePDF_Controller.getAvailableDocTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getAvailableEmails(acc.Id);   
        //Dynamic_GeneratePDF_Controller.getchilType('Contact','AccountId');
        //Dynamic_GeneratePDF_Controller.getRelType('Contact','AccountId','AccountId');         
        Dynamic_GeneratePDF_Controller.GetCurrencyvalues('99.00','00.00');
        Dynamic_GeneratePDF_Controller.GetCurrencyvalues('0.0','0,0');    
        Dynamic_GeneratePDF_Controller.doFormatting(1.00,0,'1','2');
        Dynamic_GeneratePDF_Controller.CreatePDFs(acc.Id, docTemplate.Id,false);
      //  Dynamic_GeneratePDF_Controller.CreateWord(acc.Id, docTemplate.Id,false);
        Dynamic_GeneratePDF_Controller.getOrganizationUrl();
        Dynamic_GeneratePDF_Controller.UpdateRecs(PostActs, opp.Id);
        Dynamic_GeneratePDF_Controller.getPostActList(JDT.Id, opp.Id);
        Dynamic_GeneratePDF_Controller.CreateExcel(opp.Id,JDT.Id,true);
        Dynamic_GeneratePDF_Controller.getEnableEmails();
        Dynamic_GeneratePDF_Controller.getreport(testReportId);
        Test.stopTest();
    }
    
    private static testMethod void test2(){
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        insertUsers();
        insertAccounts();
        insertContacts();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        List<String> toUserEmailsList = new List<String>();
        toUserEmailsList.add(usersList[0].Email);
        List<String> toContactEmailsList = new List<String>();
        toContactEmailsList.add(contactList[0].Email);
        list<string> ToTextEmailsList = new list<string>();
        toUserEmailsList.add('test1234@gmail.com');
        list<string> ToEmailMergeFieldsList = new list<string>();
        list<string> CCTextEmailsList = new list<string>();
        CCTextEmailsList.add('test1234@gmail.com');
        list<string> CCEmailMergeFieldsList = new list<string>();
        //CCEmailMergeFieldsList.add('Account.JunoDoc__Invoice_Email__c');        
        list<string> BCCTextEmailsList = new  list<string>();
        BCCTextEmailsList.add('test1234@gmail.com');
        list<string> BCCEmailMergeFieldsList = new list<string>();
        
        EmailTemplate validEmailTemplate;
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'name';
            validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = UserInfo.getUserId();
            validEmailTemplate.Body = 'testBody';
            validEmailTemplate.Subject = 'testSubject';
            insert validEmailTemplate;
        } 
        
        JunoDoc__Doc_Template__c DocTemp = new JunoDoc__Doc_Template__c();
        DocTemp.Name = 'test_temp';
        DocTemp.JunoDoc__Parent_Object__c = 'Account';
        DocTemp.JunoDoc__Show_Templates__c = false;
        DocTemp.JunoDoc__Template_Type__c = 'Excel';
        insert DocTemp;
        
        emailTemplate.JunoDoc__Date_Format__c = 'MM/dd/yyyy';
        emailTemplate.JunoDoc__Currency_Format__c = '###,###.00';
        update emailTemplate;
        
        opportunity opp = new opportunity();
        opp.Name = 'testOpp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.today()+25;
        opp.IsPrivate = true;
        opp.Type = 'New Customer';
        opp.StageName = 'Prospecting';
        insert opp;
        
        
        
        
         String base64Image = 'iVBORw0KGgoAAAANSUhEUgAAAAUA' +
                             'AAAFCAYAAACNbyblAAAAHElEQVQI12P4' +
                             '//8/w38GIAXDIBKE0DHxgljNBAAO' +
                             '9TXL0Y4OHwAAAABJRU5ErkJggg==';
        String imageId = 'data:image/png;base64,' + base64Image;
         String reportId = '00O3h000003L6gqEAC';
        
         String PostActs = '[{"key":"Stage","Value":"Prospecting","FieldType":"PICKLIST","GenerateCheck":"true","AttachCheck":"false","MailCheck":"false"},{"key":"IsPrivate","Value":"false","FieldType":"BOOLEAN","GenerateCheck":"false","AttachCheck":"true","MailCheck":"false"},{"key":"CloseDate","Value":"Tomorrow","FieldType":"DATE","GenerateCheck":"true","AttachCheck":"false","MailCheck":"true"}]';

        Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplates(acc.Id, emailTemplate.Id);   
        Dynamic_GeneratePDF_Controller.CreateWords(acc.Id, docTemplate.Id,false);
        Dynamic_GeneratePDF_Controller.CreateWord(acc.Id, docTemplate.Id,false);
        // Dynamic_GeneratePDF_Controller.CreateWord(acc.Id, docTemplate.Id,true);
         Dynamic_GeneratePDF_Controller.CreateExcel(acc.Id,DocTemp.Id,false);
        Dynamic_GeneratePDF_Controller.getAvailDocTemps(acc.Id, DocTemp.Id);
        Dynamic_GeneratePDF_Controller.CreatePDF(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.SendPDF(acc.Id, docTemplate.Id, 'Test Email', 'Test Body', toUserEmailsList,toContactEmailsList,'test@test.com',true,new list<string>());
        list<Dynamic_GeneratePDF_Controller.fileDetails> fileDetailslist = new list<Dynamic_GeneratePDF_Controller.fileDetails>();
        Dynamic_GeneratePDF_Controller.fileDetails filedetailrec = new Dynamic_GeneratePDF_Controller.fileDetails();
        filedetailrec.fileName = 'Test.pdf';
        filedetailrec.Type = 'pdf';
        filedetailrec.fileContent = EncodingUtil.base64Encode(blob.valueOf('Test'));
        fileDetailslist.add(filedetailrec);
        Dynamic_GeneratePDF_Controller.SendPDFNew(acc.Id, DocTemp.Id, 'Test Email', 'Test Body', 'test@test.com', 'test@test.com', 'Sowndarya', true,ToTextEmailsList,ToEmailMergeFieldsList,CCTextEmailsList,CCEmailMergeFieldsList,BCCTextEmailsList,BCCEmailMergeFieldsList,fileDetailslist);
        Dynamic_GeneratePDF_Controller.getEmailTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(acc.Id, validEmailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getAvailableDocTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getAvailableEmails(acc.Id);
        Dynamic_GeneratePDF_Controller.getOrganizationUrl(); 
        Dynamic_GeneratePDF_Controller.UpdateRecs(PostActs, opp.Id);
       Dynamic_GeneratePDF_Controller.getPdfContent(imageId);
       // Dynamic_GeneratePDF_Controller.getreport(reportId);
        Test.stopTest();
    }    
    
    private static testMethod void test3(){
         insertDocTemplates();
        insertDocTemplateItems();
        insertDocTemplateChilds();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        insertUsers();
        insertAccounts();
        insertContacts();
        insertEmailTemplates();
        insertEmailTemplateItems();
        insertEmailTemplateChilds();
        Test.startTest();
        List<String> toUserEmailsList = new List<String>();
        toUserEmailsList.add(usersList[0].Email);
        List<String> toContactEmailsList = new List<String>();
        toContactEmailsList.add(contactList[0].Email);
        list<string> ToTextEmailsList = new list<string>();
        toUserEmailsList.add('test1234@gmail.com');
        list<string> ToEmailMergeFieldsList = new list<string>();
        list<string> CCTextEmailsList = new list<string>();
        CCTextEmailsList.add('test1234@gmail.com');
        list<string> CCEmailMergeFieldsList = new list<string>();
        list<string> BCCTextEmailsList = new  list<string>();
        BCCTextEmailsList.add('test1234@gmail.com');
        list<string> BCCEmailMergeFieldsList = new list<string>();
        BCCEmailMergeFieldsList.add('Account.Owner.Email');        
        
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
        
        
        opportunity opp = new opportunity();
        opp.Name = 'testOpp';
        opp.AccountId = acc.Id;
        opp.CloseDate = system.today()+25;
        opp.IsPrivate = true;
        opp.Type = 'New Customer';
        opp.StageName = 'Prospecting';
        insert opp;
        
         ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'TestDocument.pdf',
            VersionData = Blob.valueOf('Test data for PDF content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        
       Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;
        
        ContentDocumentLink docLink = new ContentDocumentLink(
            ContentDocumentId = contentDocumentId,
            LinkedEntityId = docTemplate.Id, 
            ShareType = 'I',
            Visibility = 'AllUsers'
        );
        insert docLink;
        
        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();

        // Step 6: Execute the code under test
        List<Doc_Template__c> docTemplateRecList = [SELECT Id, Name, Parent_Object__c, PDF_Name__c, JunoDoc__Related_Files__c, Date_Format__c, JunoDoc__Template_Type__c 
                                                    FROM Doc_Template__c 
                                                    WHERE Id = :docTemplate.Id];
        
        for (Doc_Template__c docTemplateRecord : docTemplateRecList) {
            if (docTemplateRecord.JunoDoc__Related_Files__c) {
                List<ContentDocumentLink> docLinks = [SELECT LinkedEntityId, ContentDocumentId 
                                                      FROM ContentDocumentLink 
                                                      WHERE LinkedEntityId = :docTemplateRecord.Id];
                for (ContentDocumentLink link : docLinks) {
                    List<ContentVersion> versions = [SELECT Title, ContentDocumentId, VersionData, FileType 
                                                     FROM ContentVersion 
                                                     WHERE ContentDocumentId = :link.ContentDocumentId];
                    for (ContentVersion version : versions) {
                        Messaging.EmailFileAttachment docAttachment = new Messaging.EmailFileAttachment();
                        docAttachment.setFileName(version.Title);
                        docAttachment.setBody(version.VersionData);

                        // Set the content type based on file type
                        if (version.FileType == 'PDF') {
                            docAttachment.setContentType('application/pdf');
                        } else if (version.FileType == 'DOCX') {
                            docAttachment.setContentType('application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                        } else if (version.FileType == 'DOC') {
                            docAttachment.setContentType('application/msword');
                        } else {
                            docAttachment.setContentType('application/octet-stream');
                        }

                        fileAttachments.add(docAttachment);
                    }
                }
            }
        }
        
        String PostActs = '[{"key":"Stage","Value":"Prospecting","FieldType":"PICKLIST","GenerateCheck":"true","AttachCheck":"false","MailCheck":"false"},{"key":"IsPrivate","Value":"false","FieldType":"BOOLEAN","GenerateCheck":"false","AttachCheck":"true","MailCheck":"false"},{"key":"CloseDate","Value":"yesterday","FieldType":"DATE","GenerateCheck":"true","AttachCheck":"false","MailCheck":"true"}]';

        
        Dynamic_GeneratePDF_Controller.CreatePDF(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.SendPDF(acc.Id, docTemplate.Id, 'Test Email', 'Test Body', toUserEmailsList,toContactEmailsList,'test@test.com',true,new list<string>());
        list<Dynamic_GeneratePDF_Controller.fileDetails> fileDetailslist = new list<Dynamic_GeneratePDF_Controller.fileDetails>();
        Dynamic_GeneratePDF_Controller.fileDetails filedetailrec = new Dynamic_GeneratePDF_Controller.fileDetails();
        filedetailrec.fileName = 'Test.pdf';
        filedetailrec.Type = 'pdf';
        filedetailrec.fileContent = EncodingUtil.base64Encode(blob.valueOf('Test'));
        fileDetailslist.add(filedetailrec);
        Dynamic_GeneratePDF_Controller.SendPDFNew(acc.Id, docTemplate.Id, 'Test Email', 'Test Body', 
                                               'test@test.com', 'test@test.com', 'Sowndarya', true,  
                                               ToTextEmailsList,ToEmailMergeFieldsList,
                                               CCTextEmailsList,CCEmailMergeFieldsList,
                                               BCCTextEmailsList,BCCEmailMergeFieldsList,fileDetailslist);
        Dynamic_GeneratePDF_Controller.SendPDFs(acc.Id, docTemplate.Id, 'Test Email', 'Test Body', 
                                               'test@test.com', 'test@test.com', 'Sowndarya', true,  
                                               ToTextEmailsList,ToEmailMergeFieldsList,
                                               CCTextEmailsList,CCEmailMergeFieldsList,
                                               BCCTextEmailsList,BCCEmailMergeFieldsList,fileDetailslist,'BaseStringHere');
        Dynamic_GeneratePDF_Controller.getEmailTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(acc.Id, validEmailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getBodyFromJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(acc.Id, emailTemplate.Id);
        Dynamic_GeneratePDF_Controller.getAvailableDocTemplates(acc.Id);
        Dynamic_GeneratePDF_Controller.getAvailableEmails(acc.Id);   
        Dynamic_GeneratePDF_Controller.getRelType('Contact','Account','Name');
        Dynamic_GeneratePDF_Controller.getchilType('Contact','Account');
        Dynamic_GeneratePDF_Controller.UpdateRecs(PostActs, opp.Id);
        Dynamic_GeneratePDF_Controller.GetCurrencyvalues('',',0');
        Dynamic_GeneratePDF_Controller.getrecorddetails(acc.Id);
        /* Added by sainath on 09-Sep-2025 Start */
        Dynamic_GeneratePDF_Controller.getHideDetails(acc.Id);
        /* Added by sainath on 09-Sep-2025 End */
        Test.stopTest();
    }    
    
    
    public static void insertEmailTemplates(){
        List<Email_Template__c> etRecords = [SELECT Id FROM Email_Template__c];
        DELETE etRecords;
        System.assertEquals(0,[SELECT count() FROM Email_Template__c]);
        emailTemplate = new Email_Template__c();
        emailTemplate.Name = 'Test Template';
        emailTemplate.Parent_Object__c = 'Account';
        emailTemplate.Parent_Fields__c = 'Name,CreatedDate,AnnualRevenue,Owner.Name';
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
        emailTemplateItem.JunoDoc__Subject__c = 'testSubject';
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
        emailTemplateChild.Child_Query__c = 'Name,owner.email';
        emailTemplateChild.Filter__c = 'Lastname != sszTestssz';
        emailTemplateChild.Sort_Order__c = 2;
        emailTemplateChild.render_condition__c = '{{Lastname}} != sszTestssz';
        emailTemplateChildsList.add(emailTemplateChild);
        insert emailTemplateChildsList; 
        System.assertEquals('AccountId', emailTemplateChildsList[0].Parent_Reference__c);
    }
    
    public static void insertAccounts(){
        acc = new Account();
        acc.Name = 'Test Account';
        //acc.JunoDoc__Invoice_Email__c = 'test@gmail.com';
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
        usr.username = 'test23456@sforce.com';
        usr.email = 'test23456@test.com';
        usr.Alias = 'alias'; 
        usr.TimeZoneSidKey = 'America/Los_Angeles';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.LocaleSidKey = 'en_US';
        usersList.add(usr);
        insert usersList;
        System.assertEquals('test23456@test.com', usersList[0].Email);
    }
     public static void insertDocTemplates(){
        List<Doc_Template__c> dtRecords = [SELECT Id FROM Doc_Template__c];
        DELETE dtRecords;
        System.assertEquals(0,[SELECT count() FROM Doc_Template__c]);
        docTemplate = new Doc_Template__c();
        docTemplate.Name = 'Test Template';
        docTemplate.Parent_Object__c = 'Account';
         docTemplate.PDF_Name__c = 'Opp - {!Name} - {!owner.Name}'+' '+'{!TODAY()}'+ '    ' + ' {!NOW()} ' ;
        docTemplate.Parent_Fields__c = 'Name,ShippingStreet,ShippingState,ShippingCity,ShippingPostalcode,ShippingCountry';
         docTemplate.JunoDoc__Related_Files__c = true;
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

    @isTest static void test1(){
        Account ac=new Account();
        ac.Name='Test';
        insert ac;
        Doc_Template__c doctemp = new Doc_Template__c();
        doctemp.Name='test';
        doctemp.Parent_Object__c='Account';
        doctemp.Parent_Fields__c='JunoDoc__Doc_Template__c';
        insert doctemp;
        
        Junodoc_Details__c JunoDet = new Junodoc_Details__c();
        JunoDet.JunoDoc__Selected_object__c = 'Account';
        JunoDet.JunoDoc__From_Email_Address__c = 'test@gmail.com';
        JunoDet.JunoDoc__Junodoc_Email_Templates__c = '';
        JunoDet.JunoDoc__Standard_Email_Templates__c = '';
        JunoDet.JunoDoc__Set_Reply_To__c = 'test@gmail.com';
        JunoDet.JunoDoc__Junodoc_Doc_Template__c = '';
        insert JunoDet;
        
        JunoDoc__Email_Details__c JunoEmDet = new JunoDoc__Email_Details__c();
        JunoEmDet.JunoDoc__Junodoc_Details__c = JunoDet.Id;
        JunoEmDet.JunoDoc__To_Value__c = 'test@gmail.com';
        JunoEmDet.JunoDoc__Text_Ref_Value__c = '';
        JunoEmDet.JunoDoc__field_Details__c = '';
        JunoEmDet.JunoDoc__Email__c = '';
        insert JunoEmDet;
        
        
        
        Dynamic_GeneratePDF_Controller.getrecorddetails(ac.id);
        
    }
    @isTest
    public static void method1(){
        Account ac=new Account();
        ac.Name='Test';
        insert ac;
        
        opportunity opp = new opportunity();
        opp.Name = 'testOpp';
        opp.AccountId = ac.Id;
        opp.CloseDate = system.today()+25;
        opp.IsPrivate = true;
        opp.Type = 'New Customer';
        opp.StageName = 'Prospecting';
        insert opp;
        
        
         String PostActs = '[{"key":"Stage","Value":"Prospecting","FieldType":"PICKLIST","GenerateCheck":"true","AttachCheck":"false","MailCheck":"false"},{"key":"IsPrivate","Value":"false","FieldType":"BOOLEAN","GenerateCheck":"false","AttachCheck":"true","MailCheck":"false"},{"key":"CloseDate","Value":"2023-03-28","FieldType":"DATE","GenerateCheck":"true","AttachCheck":"false","MailCheck":"true"},{"key":"Probability","Value":"10","FieldType":"PERCENT","GenerateCheck":"true","AttachCheck":"false","MailCheck":"false"}]';
        
        Dynamic_GeneratePDF_Controller.UpdateRecs(PostActs, opp.Id);
    }
    @isTest
    public static void method2(){
        Account ac=new Account();
        ac.Name='Test';
        insert ac;
        
        contact con = new contact();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.AccountId = ac.id;
        insert con;
        
        
        
         String PostActs = '[{"key":"LastCURequestDate","Value":"now","FieldType":"DATETIME","GenerateCheck":"true","AttachCheck":"false","MailCheck":"true"}]';
        
        Dynamic_GeneratePDF_Controller.UpdateRecs(PostActs, con.Id);
    }
    @isTest
    public static void testDummy(){
        Test.startTest();
        Dynamic_GeneratePDF_Controller.dummtTestMethod();
        Dynamic_GeneratePDF_Controller.dummtTestMethod2();
        Dynamic_GeneratePDF_Controller.dummtTestMethod3();
        Dynamic_GeneratePDF_Controller.dummtTestMethod4();
        Test.stopTest();
    }
    
    
    /* Added by sainath on 09-Sep-2025 Start */
    @isTest
    public static void testHideSettings(){
        Junodoc_Details__c juno = new Junodoc_Details__c(); 
        juno.From_Email_Address__c='test@gmail.com';
        juno.Junodoc_Email_Templates__c='test';
        juno.Standard_Email_Templates__c='testid';
        juno.Set_Reply_To__c='testing@gmail.com';
        juno.Selected_object__c='Account';
        insert juno;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Test.startTest();
        Dynamic_GeneratePDF_Controller.getHideDetails(acc.Id);
        Test.stopTest(); 
    }
    /* Added by sainath on 09-Sep-2025 End */
    
  /* @isTest
     public static void testGetReport() {
       
        String testReportId = '00O3h000003L6gqEAC';
        Test.startTest();
        String reportResultJson = Dynamic_GeneratePDF_Controller.getreport(testReportId);
        Test.stopTest();
        System.assertNotEquals(null, reportResultJson);
/// Add more assertions as needed to validate the JSON result
    }*/
}
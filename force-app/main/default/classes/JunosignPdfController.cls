public class JunosignPdfController {
    public string isExpirationdate {get; set;}
    public string isRejected {get; set;}
    public transient string body {get; set;} 
    public transient string secondbody {get; set;} 
    public string docidList  {get;set;} 
    public string domainUrl {get;set;}
    //public string usersidepageTab {get;set;}
    // public string fileid {get;set;}
    public string transcid {get;set;}
    public string recid {get;set;}
    public string conid {get;set;}
    public string conDocIDs {get;set;}
    //public List<Page_Tab__c> pageTabsList {get;set;} 
    public string pageTabsstring {get;set;}   
    public string todayDateValue {get; set;}
    public string selectedDocId {get;set;}
    public static string ipaddress {get;set;}
    
    public JunosignPdfController(){
        isRejected = 'false';
        isExpirationdate = 'false';
        //currentRecordId = ApexPages.currentPage().getParameters().get('id');
        selectedDocId  = ApexPages.currentPage().getParameters().get('id');
        transcid = ApexPages.currentPage().getParameters().get('trancid');
        recid = ApexPages.currentPage().getParameters().get('recid');
        domainUrl = System.Url.getOrgDomainUrl().toExternalForm();
        conid = ApexPages.currentPage().getParameters().get('conid');
        //isInPerson = ApexPages.currentPage().getParameters().get('isInPerson');
        //domainName = ApexPages.currentPage().getParameters().get('domainName');
        //orgTempRecordId = ApexPages.currentPage().getParameters().get('orgDocid');
        conDocIDs = ApexPages.currentPage().getParameters().get('conDocID');
        //showAttachments = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showattachment'));
        DateTime dt = DateTime.now();
        String dateTimeStr = dt.format('MM/dd/yyyy');
        System.debug('>>>>' + dateTimeStr);
        todayDateValue = dateTimeStr;
        ipaddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        
        getPageTabs();
    }
    
    @RemoteAction
    public Static String getPDFById(String selectedDocId, String conId, String recid) {
        
        system.debug('templateId>>>>>>>>>>>>>>>'+selectedDocId+'conId>>>>>>>>>>>>>>>>'+conId +'recid>>>>>>>>>>>'+recid);
        try {
            // Check if we have a template ID and related record ID
            if (String.isBlank(selectedDocId) || String.isBlank(conId) || String.isBlank(recid)) {
                throw new AuraHandledException('Template ID and related record ID are required');
            }
            
            Schema.SObjectType sobjectType = Id.valueOf(selectedDocId).getSObjectType();
            String objectName = sobjectType.getDescribe().getName();
            Blob pdfBlob;
            if(objectName == 'JunoDoc__Doc_Template__c'){
                PageReference pagePdf = new PageReference('/apex/Junodoc__JunodocPDF'); 
                system.debug('pagePdf>>>>>>>>>>>>>'+pagePdf);
                pagePdf.getParameters().put('id', conId); 
                pagePdf.getParameters().put('DocTemplateId', selectedDocId); 
                
                if(Test.IsRunningTest()){
                    pdfBlob = Blob.valueOf('UNIT.TEST');
                }
                else{
                    pdfBlob = pagePdf.getContentAsPDF(); 
                }
                
            }else{
                ContentVersion  cont = [select id,VersionData,title from ContentVersion where ContentDocumentId =: selectedDocId];
                pdfBlob = cont.VersionData;
            }
            
            // Generate the PDF using the JunoDoc PDF page
            /* PageReference pdfPage = new PageReference('/apex/JunoDoc__JunodocPDF');
pdfPage.getParameters().put('id', conId);
pdfPage.getParameters().put('DocTemplateId', id);*/
            
            
            // Convert the PDF blob to base64
            
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                             ownerId,
                                                             JunoDoc__Recipient_Name__c,
                                                             JunoDoc__Recipient_Email__c,
                                                             JunoDoc__Status__c,
                                                             JunoDoc__Sort_Order__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                             JunoDoc__Juno_Sign_Transaction__c,
                                                             JunoDoc__JunoSign_Expiration_Date__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Status__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c
                                                             from JunoDoc__Juno_Sign_Recipient__c 
                                                             where id=: recid]; 
            system.debug('recdata-->'+recdata);
            if(recdata.size() > 0 ){
                system.debug('recdata[0]-->'+recdata[0]);
                if(recdata[0].JunoDoc__JunoSign_Expiration_Date__c < system.today()){
                    system.debug('recdata[0]-->'+recdata[0]);
                    recdata[0].JunoDoc__Status__c = 'Expired';
                    update recdata[0];
                    JunoDoc__Juno_Sign_Transaction__c junoSignTransaction = new JunoDoc__Juno_Sign_Transaction__c();
                    junoSignTransaction.Id = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                    junoSignTransaction.JunoDoc__Status__c ='Expired';
                    update junoSignTransaction;
                    JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                    audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                    audit.JunoDoc__Date__c = system.today();
                    audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                    audit.JunoDoc__IP_Address__c = ipaddress; //ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                    audit.JunoDoc__Status__c    = 'Expired';
                    insert audit;
                }
                else if(recdata[0].JunoDoc__Status__c == 'Pending'){
                    system.debug('JunoDoc__Juno_Sign_Transaction__c[0]-->'+recdata[0]);
                    recdata[0].JunoDoc__Status__c = 'Viewed';
                    update recdata[0];
                    system.debug('JunoDoc__Juno_Sign_Transaction__c[0]-->'+recdata[0]);
                    JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                    audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                    audit.JunoDoc__Date__c = system.today();
                    audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                    audit.JunoDoc__IP_Address__c = ipaddress; //ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                    audit.JunoDoc__Status__c    = 'Viewed';
                    insert audit;
                    system.debug('audit-->'+audit);
                }
                system.debug('pdfBlob-->'+pdfBlob);
            }
            
            String base64Data = EncodingUtil.base64Encode(pdfBlob);
            system.debug('base64Data-->'+base64Data);
            return base64Data;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error generating PDF: ' + e.getMessage()+ ' '+e.getLineNumber());
        }
    }
    
    public void getPageTabs(){
        
        list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                         ownerId,
                                                         JunoDoc__Recipient_Name__c,
                                                         JunoDoc__Recipient_Email__c,
                                                         JunoDoc__Status__c,
                                                         JunoDoc__Sort_Order__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                         JunoDoc__Juno_Sign_Transaction__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c
                                                         from JunoDoc__Juno_Sign_Recipient__c 
                                                         where id=:recid ]; 
        
        //String trancId =  transcid;
        List<JunoDoc__Junodoc_Page_Tab__c> pageTabsList = [select Id,Name, JunoDoc__Pos_Left__c, JunoDoc__Pos_Top__c, 
                                                           JunoDoc__Sign_Completed__c,JunoDoc__Type__c,JunoDoc__Linked_To__c,
                                                           JunoDoc__Recipient_Sort_Order__c ,JunoDoc__Page_Height__c,JunoDoc__Page_Width__c
                                                           from JunoDoc__Junodoc_Page_Tab__c 
                                                           where JunoDoc__Sign_Completed__c = false 
                                                           AND JunoDoc__Linked_To__c=:transcid 
                                                           AND JunoDoc__Recipient_Sort_Order__c=:recdata[0].JunoDoc__Sort_Order__c 
                                                           order By Id ASC];
        //system.assert(false,recdata[0].JunoDoc__Sort_Order__c +'--pageTabsList-->'+pageTabsList);
        //pageTabsstring = JSON.serialize(pageTabsList);
        
        List<JunoDocPageTabWrapper> result = new List<JunoDocPageTabWrapper>();
        if(!pageTabsList.isEmpty()){
            for (JunoDoc__Junodoc_Page_Tab__c rec : pageTabsList) {
                result.add(new JunoDocPageTabWrapper(rec));
            }
        }
        
        
        pageTabsstring = JSON.serialize(result);
        //return pageTabsstring;
    }
    
    public class JunoDocPageTabWrapper {
        public String Id { get; set; }
        public String Name { get; set; }
        public String left { get; set; }         // Will be like '120px'
        public String top { get; set; }          // Will be like '240px'
        public String pageHeight { get; set; }   // Will be like '800px'
        public String pageWidth { get; set; }    // Will be like '600px'
        public String type { get; set; }
        public Boolean signCompleted { get; set; }
        public String linkedTo { get; set; }
        public Decimal recipientSortOrder { get; set; }
        
        public JunoDocPageTabWrapper(JunoDoc__Junodoc_Page_Tab__c tab) {
            Id = tab.Id;
            Name = tab.Name;
            left = tab.JunoDoc__Pos_Left__c != null ? tab.JunoDoc__Pos_Left__c + 'px' : '0px';
            top = tab.JunoDoc__Pos_Top__c != null ? tab.JunoDoc__Pos_Top__c + 'px' : '0px';
            pageHeight = tab.JunoDoc__Page_Height__c != null ? tab.JunoDoc__Page_Height__c + 'px' : '0px';
            pageWidth = tab.JunoDoc__Page_Width__c != null ? tab.JunoDoc__Page_Width__c + 'px' : '0px';
            type = tab.JunoDoc__Type__c;
            signCompleted = tab.JunoDoc__Sign_Completed__c;
            linkedTo = String.valueOf(tab.JunoDoc__Linked_To__c);
            recipientSortOrder = tab.JunoDoc__Recipient_Sort_Order__c;
        }
    }
    
    @RemoteAction
    public static String rejectDocument(String id, String conId, String recid ) {
        try {
            // Validate input parameters
            if (String.isBlank(id) || String.isBlank(conId) || String.isBlank(recid)) {
                //  throw new CustomException('Missing required parameters: templateId, conId, orrecid ');
            }
            
            // Find the related document record (adjust object and field names as per your schema)
            // Example: Assuming you have a custom object for document recipients
            List<JunoDoc__Juno_Sign_Recipient__c> recipients = [
                SELECT Id, JunoDoc__Status__c
                FROM Juno_Sign_Recipient__c
                WHERE Id = :recid
                LIMIT 1
            ];
            
            if (recipients.isEmpty()) {
                // throw new CustomException('No matching document recipient found.');
            }
            
            // Update the recipient status to 'Rejected'
            Juno_Sign_Recipient__c recipient = recipients[0];
            recipient.JunoDoc__Status__c = 'Rejected';
            update recipient;
            
            // Optionally, update the main document status if needed
            // Document__c document = [SELECT Id, Status__c FROM Document__c WHERE Id = :templateId LIMIT 1];
            // document.Status__c = 'Rejected';
            // update document;
            
            // Return success message
            return 'Document rejected successfully';
        } catch (Exception e) {
            // Log the error for debugging
            System.debug('Error rejecting document: ' + e.getMessage());
            throw new AuraHandledException('Error rejecting document: ' + e.getMessage());
        }
    }
    
    // Remote action to save PDF to Salesforce
    
    /*  public static String savePDFToSalesforce(String fileName, String base64Data, String recordId) {
system.debug('recordId>>>>>>>>>'+recordId);
try {
// Extract the base64 data (remove the data URI prefix if present)
String base64String = base64Data;
if (base64Data.startsWith('data:application/pdf;base64,')) {
base64String = base64Data.substringAfter('data:application/pdf;base64,');
}

// Decode the base64 string to a blob
Blob pdfBlob = EncodingUtil.base64Decode(base64String);

// Create a new ContentVersion record
ContentVersion contentVersion = new ContentVersion();
contentVersion.Title = fileName;
contentVersion.PathOnClient = fileName;
contentVersion.VersionData = pdfBlob;
contentVersion.IsMajorVersion = true;

// If a recordId is provided, link the file to that record
if (String.isNotBlank(recordId)) {
contentVersion.FirstPublishLocationId = recordId;
}

// Insert the ContentVersion
insert contentVersion;

// Return the ContentVersion ID
return contentVersion.Id;
} catch (Exception e) {
throw new AuraHandledException('Error saving PDF to Salesforce: ' + e.getMessage());
}
}*/
    @RemoteAction
    public static String savePDFToSalesforce(String fileName, String base64Data, String recordId, String conId, List<String> completedIds) {
        system.debug('recipient>>>>>>>>>>>>>>>'+recordId);
        
        try {
            // Extract base64 data
            String base64String = base64Data;
            if (base64Data.startsWith('data:application/pdf;base64,')) {
                base64String = base64Data.substringAfter('data:application/pdf;base64,');
            }
            Blob pdfBlob = EncodingUtil.base64Decode(base64String);
            
            
            //String trancId =  transcid;
            List<JunoDoc__Junodoc_Page_Tab__c> pageTabsList = new List<JunoDoc__Junodoc_Page_Tab__c>();
            for(String completedId : completedIds){
                JunoDoc__Junodoc_Page_Tab__c pageTabRec = new JunoDoc__Junodoc_Page_Tab__c();
                pageTabRec.Id = completedId;
                pageTabRec.JunoDoc__Sign_Completed__c = true;
                pageTabsList.add(pageTabRec);
            }
            
            update pageTabsList;
            
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                             ownerId,
                                                             JunoDoc__Recipient_Name__c,
                                                             JunoDoc__Recipient_Email__c,
                                                             JunoDoc__Sort_Order__c,
                                                             JunoDoc__JunoSign_Expiration_Date__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                             JunoDoc__Juno_Sign_Transaction__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c
                                                             from JunoDoc__Juno_Sign_Recipient__c 
                                                             where id=:recordId ];  //'a0ye000000AUtfHAAT'
            
            Boolean isAllRecipientEmail = false;
            List<Junodoc_Setting__c> settings = [SELECT Enable_To_Send_Email__c FROM Junodoc_Setting__c LIMIT 1];
            if (!settings.isEmpty()) {
                isAllRecipientEmail = settings[0].Enable_To_Send_Email__c; 
            }
            
            
            
            // Query recipient data assuming recordId is JunoDoc__Juno_Sign_Recipient__c
            JunoDoc__Juno_Sign_Recipient__c recipient = [
                SELECT Id, JunoDoc__Recipient_Name__c, JunoDoc__Recipient_Email__c, 
                JunoDoc__Juno_Sign_Transaction__c, JunoDoc__Sort_Order__c, 
                JunoDoc__Status__c
                FROM JunoDoc__Juno_Sign_Recipient__c 
                WHERE Id = :recordId LIMIT 1
            ];
            system.debug('recipient>>>>>>>>>>>>>>>'+recipient);
            
            // Create ContentVersion
            ContentVersion contVersion = new ContentVersion();
            contVersion.Title = fileName + '_' + recipient.JunoDoc__Recipient_Name__c + '_' + DateTime.now().format('yyyy-MM-dd');
            contVersion.PathOnClient = fileName + '.pdf';
            contVersion.VersionData = pdfBlob;
            contVersion.IsMajorVersion = true;
            contVersion.FirstPublishLocationId = conid; // Link to parent object
            insert contVersion;
            
            // Query ContentDocumentId
            contVersion = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contVersion.Id LIMIT 1];
            
            // Create ContentDocumentLink for recipient
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId =recipient.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = contVersion.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
            conDocLink.shareType = 'I';
            conDocLink.Visibility = 'AllUsers'; 
            insert conDocLink;
            
            // Update recipient status
            recipient.JunoDoc__Status__c = 'Signed';
            update recipient;
            
            // Create Audit Trail
            JunoDoc__Audit_Trail__c auditTrail = new JunoDoc__Audit_Trail__c();
            auditTrail.JunoDoc__Status__c = 'Signed';
            auditTrail.Name = recipient.JunoDoc__Recipient_Name__c;
            auditTrail.JunoDoc__JunoSign_Transaction__c = recipient.JunoDoc__Juno_Sign_Transaction__c;
            auditTrail.JunoDoc__IP_Address__c = ipaddress; //ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            auditTrail.JunoDoc__Date__c = System.today();
            insert auditTrail;
            
            // Check if all recipients have signed
            List<JunoDoc__Juno_Sign_Recipient__c> allRecipients = [
                SELECT Id, JunoDoc__Status__c,JunoDoc__Recipient_Email__c
                FROM JunoDoc__Juno_Sign_Recipient__c 
                WHERE JunoDoc__Juno_Sign_Transaction__c = :recipient.JunoDoc__Juno_Sign_Transaction__c
            ];
            Boolean allSigned = true;
            for (JunoDoc__Juno_Sign_Recipient__c r : allRecipients) {
                if (r.JunoDoc__Status__c != 'Signed') {
                    allSigned = false;
                    break;
                }
            }
            
            // Update transaction status
            JunoDoc__Juno_Sign_Transaction__c transactions = [
                SELECT Id, JunoDoc__Status__c 
                FROM JunoDoc__Juno_Sign_Transaction__c 
                WHERE Id = :recipient.JunoDoc__Juno_Sign_Transaction__c LIMIT 1
            ];
            
            
            if (allSigned) {
                transactions.JunoDoc__Status__c = 'Completed';
                update transactions;
                
             if (isAllRecipientEmail == true && allSigned == true) {
                    EmailTemplate emailTemplate = [
                        SELECT HtmlValue, Subject 
                        FROM EmailTemplate 
                        WHERE DeveloperName = 'JunoSign_Completed_Signature_For_Signees' 
                        LIMIT 1
                    ];
                    
                    String emailBody1 = emailTemplate.HtmlValue.replace('{!TODAY()}', Date.today().format());
                    String emailSubject1 = emailTemplate.Subject.replace('{!JunoDoc__Juno_Sign_Recipient__c.JunoDoc__Recipient_Name__c}', 'All Signees');
                    
                    List<String> toAddresses = new List<String>();
                 
                    for (JunoDoc__Juno_Sign_Recipient__c r : allRecipients) {
                        toAddresses.add(r.JunoDoc__Recipient_Email__c);
                    }
                    
                    Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();
                    email1.setToAddresses(toAddresses);
                    email1.setSubject(emailSubject1);
                    email1.setHtmlBody(emailBody1);
                    email1.setSaveAsActivity(true);
                    
                    Messaging.EmailFileAttachment attachment1 = new Messaging.EmailFileAttachment();
                    attachment1.setFileName(fileName + '.pdf');
                    attachment1.setBody(pdfBlob);
                    email1.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment1});
                    
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email1});
                    System.debug('@@@ Group Mail Enabled: ' + isAllRecipientEmail);
                }   
                
            }
            
            // Send email notification
            EmailTemplate emailTemplates = [
                SELECT Id, Htmlvalue, Subject
                FROM EmailTemplate 
                WHERE DeveloperName = 'JunoSign_Completed_Signature_For_Signees' LIMIT 1
            ];
            
            String emailBody = emailTemplates.Htmlvalue
                .replace('{!TODAY()}', DateTime.now().format('MM/dd/yyyy'))
                .replace('{!JunoDoc__Juno_Sign_Recipient__c.JunoDoc__Recipient_Name__c}', recipient.JunoDoc__Recipient_Name__c);
            String emailSubject = emailTemplates.Subject
                .replace('{!JunoDoc__Juno_Sign_Recipient__c.JunoDoc__Recipient_Name__c}', recipient.JunoDoc__Recipient_Name__c);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{recipient.JunoDoc__Recipient_Email__c});
            email.setSubject(emailSubject);
            email.setHtmlBody(emailBody);
            email.setSaveAsActivity(true);
            
            // Attach PDF
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName(fileName + '.pdf');
            attachment.setBody(pdfBlob);
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            
            
            
            String SiteURL = '';
            List<JunoDoc__Junodoc_Setting__c> listurl = [Select JunoDoc__Site_URL__c FROM JunoDoc__Junodoc_Setting__c LIMIT 1];
            if(listurl.size() > 0){
                SiteURL = listurl[0].JunoDoc__Site_URL__c; 
            }
            
            List<Document> docRecod= [Select Id,Name from Document where DeveloperName = 'Junosign_logo'];
            string domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
            String OrgId = ''+UserInfo.getOrganizationId();
            // StaticResource static_resource = [SELECT Id, SystemModStamp  FROM StaticResource  WHERE Name = 'JunoSign'   LIMIT 1];
            String logoUrl;
            if(docRecod.size()>0){
                logoUrl = 'https://'+domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docRecod[0].Id+'&oid='+OrgId; 
            }
            
            String sObjName = Id.valueOf(conid).getSObjectType().getDescribe().getName();
            
            list <JunoDoc__Junosign_Object_Setting__c> fromadd = new list<JunoDoc__Junosign_Object_Setting__c>();
            fromadd=[select JunoDoc__FromEmailAddress__c,JunoDoc__Selected_object__c 
                     from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName ];
            
            string emailAddressinObjectSettings;
            if(fromadd.size() > 0){
                emailAddressinObjectSettings =fromadd[0].JunoDoc__FromEmailAddress__c;
            }
            
            List<string> paralleldata = new List<string>();
            list<JunoDoc__Juno_Sign_Recipient__c> JunorecList;
            List<JunoDoc__Juno_Sign_Recipient__c> parallellist = [select id,JunoDoc__Status__c ,JunoSign_Expiration_Date__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c];
            for(JunoDoc__Juno_Sign_Recipient__c j :parallellist){
                paralleldata.add(j.JunoDoc__Status__c);
            }
            
            
            
            system.debug('paralleldata'+paralleldata);
            if(!paralleldata.contains('Not Sent')){
                JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Status__c='Pending' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1]; 
            }else{
                JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Status__c='Not Sent' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1];
            }
            system.debug('JunorecList===='+JunorecList);
            if(paralleldata.contains('Not Sent')){
                system.debug('sequential operation');
                if(JunorecList.size() > 0){
                    for(JunoDoc__Juno_Sign_Recipient__c juno: JunorecList){
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        message.toAddresses = new String[] { juno.JunoDoc__Recipient_Email__c };
                            message.setOrgWideEmailAddressId(emailAddressinObjectSettings);
                        
                        
                        //EmailTemplate emailTemplateRec = [Select Id,Subject,Htmlvalue from EmailTemplate where DeveloperName = 'Junosign_Email_Template'];
                        
                        /********* SAIRAM 21-02-2023 ***********/
                        String templateHtmlValue = '';
                        String templateSubject = '';
                        JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName];
                        
                        /*if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c != null){
JunoDoc__Email_Template_Item__c emailTemplateRec = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c];
JunoDoc__Email_Template__c emailTemp = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRec.JunoDoc__Email_Template__c];
templateHtmlValue = emailTemplateRec.JunoDoc__Template_Body__c; //emailTemplateRec.Htmlvalue;
templateSubject = emailTemplateRec.JunoDoc__Subject__c;
system.debug('templateHtmlValue-->'+templateHtmlValue);



String SobjectApiName = emailTemp.JunoDoc__Parent_Object__c;

if(emailTemp.Junodoc__Date_Format__c != null && emailTemp.Junodoc__Date_Format__c != ''){
DateFormats = emailTemp.Junodoc__Date_Format__c;
}
else{
DateFormats = 'MM/dd/yyyy';
}
if(emailTemp.Junodoc__Currency_Format__c != null && emailTemp.Junodoc__Currency_Format__c != ''){
CurrencyFormat = emailTemp.Junodoc__Currency_Format__c;
}
else{
CurrencyFormat = '###,###.00';
}

if(emailTemp.JunoDoc__Number_Format__c != null && emailTemp.JunoDoc__Number_Format__c != ''){
NumberFormat = emailTemp.JunoDoc__Number_Format__c;
}
else{
NumberFormat = '###,###.00';
}

currencySymbolMap = new map<string,string>();
list<JunoDoc__Junodoc_Currency__c> currencylist = [select Id,JunoDoc__Currency_Code__c,JunoDoc__Currency_Symbol__c from JunoDoc__Junodoc_Currency__c];
if(!currencylist.isEmpty()){
for(JunoDoc__Junodoc_Currency__c currencys : currencylist){
currencySymbolMap.put(currencys.JunoDoc__Currency_Code__c,currencys.JunoDoc__Currency_Symbol__c);   
}
}

currencysymbols = '$';
//system.debug('861-->'+UserInfo.getDefaultCurrency());
if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
}
Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
// if(multiCurrencyEnabled){
if(emailTemp.JunoDoc__Currency_Symbol__c != null && emailTemp.JunoDoc__Currency_Symbol__c != ''){
emailTemp.JunoDoc__Currency_Symbol__c = emailTemp.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
Sobject Sobj = Database.query('select id,'+ emailTemp.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:conid');
currencysymbols = currencySymbolMap.get(''+Sobj.get(emailTemp.JunoDoc__Currency_Symbol__c));
}

if(templateHtmlValue.contains('{!TODAY()}')){
Date Datestr = system.Today();
string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
templateHtmlValue = templateHtmlValue.replace('{!TODAY()}',Parentvalues); 

}
if(templateHtmlValue.contains('{!NOW()}')){
string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
templateHtmlValue = templateHtmlValue.replace('{!NOW()}',Parentvalues);  
}

if(templateHtmlValue.contains('{!#User.')){
string qry = 'select ';
templateHtmlValue = templateHtmlValue.replace('{!#User.','##user##');
string[] strlist = templateHtmlValue.split('##user##');
list<string> userfields = new list<string>();
integer z = 0;
for(string newstr : strlist){
if(z >= 1){
string[] userstr = newstr.split('}');
qry += userstr[0] + ',';
userfields.add(userstr[0]);

}
z = z+1;
}
string userId = userinfo.getUserId();
qry += 'Id from user where id=: userId';
user users = Database.query(qry);
if(!userfields.isEmpty()){
for(string str : userfields){
templateHtmlValue = templateHtmlValue.replace('##user##'+str+'}',''+users.get(str));  
}
}
}

blankasZeroes =  emailTemp.JunoDoc__Blank_Fields_As_Zeroes__c;


SObject parentRef;
string[] TempBdylist = templateHtmlValue.replace('{!','#####').split('#####');
list <String> convertlst = new list<string>();
for(string str : TempBdylist){
convertlst.add(str.split('}')[0]);
}
system.debug('convertlst-->'+convertlst);

List <String> Fldlst = new list<string>();
for(integer a=1;a<convertlst.size();a++){
Fldlst.add(convertlst[a]);
}

if(Fldlst.size()>0){

system.debug('Fldlst-->'+Fldlst);
string qury = 'select ' + string.join(Fldlst,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
system.debug('qury-->'+qury);

parentRef = Database.query(qury);
system.debug('parentRef--->'+parentRef);
}
for(String strs: Fldlst){
string str = strs.replace(' ','');
string Parentvalues = '';
if(!str.contains('.')){
if(parentRef.get(str) != null){
Parentvalues = ''+ parentRef.get(str);
}
else{
Parentvalues = '';
}
}
else{
string Stringobjct = str.replace('.',',');
string[] Stringobjcts = Stringobjct.split(',');
if(Stringobjcts.size() > 3){
if(parentRef.getsobject(Stringobjcts[0]) != null){
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {  
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
string firstchild = getchilType(SobjectApiName,Stringobjcts[0]);
string secchild = getchilType(firstchild,Stringobjcts[1]);
string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);

if(Types == 'CURRENCY'){
Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
}

else if(Types == 'DATE'){
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
}
}

else if(Types == 'DATETIME'){
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
}
}

else if(Types == 'BOOLEAN'){
boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));

if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}

else{ 
Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
}
}
}
}
}
else if(Stringobjcts.size() > 2){
if(parentRef.getsobject(Stringobjcts[0]) != null){
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
string secchild = getchilType(SobjectApiName,Stringobjcts[0]);
string Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);

if(Types == 'CURRENCY'){
Parentvalues = GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues = GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
}

else if(Types == 'DATE'){
Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
}

else if(Types == 'DATETIME'){
Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
}

else if(Types == 'BOOLEAN'){
boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}

else{ 
Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
}
}
}
}
}
else{
if(parentRef.getsobject(Stringobjcts[0]) != null){    
if(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
string Types = getRelType(SobjectApiName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);

if(Types == 'CURRENCY'){
Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
}

else if(Types == 'DATE'){
Date Datestr = Date.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
}

else if(Types == 'DATETIME'){
Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
}

else if(Types == 'BOOLEAN'){

boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}

else{ 
Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
}

}
}
}
}
if(Parentvalues != ''){
if(templateHtmlValue.contains('Barcode[{!'+Str+'}]')){
templateHtmlValue = templateHtmlValue.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
}
else{
templateHtmlValue = templateHtmlValue.replace('{!'+Str+'}',Parentvalues); 
}

}
else{
templateHtmlValue = templateHtmlValue.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
}

}

if(templateSubject.contains('{!TODAY()}')){
Date Datestr = system.Today();
string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
templateSubject = templateSubject.replace('{!TODAY()}',Parentvalues); 

}
if(templateSubject.contains('{!NOW()}')){
string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
templateSubject = templateSubject.replace('{!NOW()}',Parentvalues);  
}

if(templateSubject.contains('{!#User.')){
string qry = 'select ';
templateSubject = templateSubject.replace('{!#User.','##user##');
string[] strlist = templateSubject.split('##user##');
list<string> userfields = new list<string>();
integer z = 0;
for(string newstr : strlist){
if(z >= 1){
string[] userstr = newstr.split('}');
qry += userstr[0] + ',';
userfields.add(userstr[0]);

}
z = z+1;
}
string userId = userinfo.getUserId();
qry += 'Id from user where id=: userId';
user users = Database.query(qry);
if(!userfields.isEmpty()){
for(string str : userfields){
templateSubject = templateSubject.replace('##user##'+str+'}',''+users.get(str));  
}
}
}

string[] TempSublist = templateSubject.replace('{!','#####').split('#####');
list <String> convertSublst = new list<string>();
for(string str : TempSublist){
convertSublst.add(str.split('}')[0]);
}
system.debug('convertSublst-->'+convertSublst);

List <String> FldSublst = new list<string>();
for(integer a=1;a<convertSublst.size();a++){
FldSublst.add(convertSublst[a]);
}
system.debug('FldSublst-->'+FldSublst);
SObject parentSubRef;
if(FldSublst.size()>0){
string qurySub = 'select ' + string.join(FldSublst,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
system.debug('qurySub-->'+qurySub);

parentSubRef = Database.query(qurySub);
system.debug('parentSubRef--->'+parentSubRef);
}
for(String strs: FldSublst){
string str = strs.replace(' ','');
string Parentvalues = '';
if(!str.contains('.')){
if(parentSubRef.get(str) != null){
Parentvalues = ''+ parentSubRef.get(str);
}
else{
Parentvalues = '';
}
}
else{
string Stringobjct = str.replace('.',',');
string[] Stringobjcts = Stringobjct.split(',');
if(Stringobjcts.size() > 3){
if(parentSubRef.getsobject(Stringobjcts[0]) != null){
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {  
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
string firstchild = getchilType(SobjectApiName,Stringobjcts[0]);
string secchild = getchilType(firstchild,Stringobjcts[1]);
string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);

if(Types == 'CURRENCY'){
Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
}

else if(Types == 'DATE'){
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
Date Datestr = Date.valueof(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
}
}

else if(Types == 'DATETIME'){
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
}
}

else if(Types == 'BOOLEAN'){
boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));

if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}
else{ 
Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
}
}
}
}
}
else if(Stringobjcts.size() > 2){
if(parentSubRef.getsobject(Stringobjcts[0]) != null){
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
string secchild = getchilType(SobjectApiName,Stringobjcts[0]);
string Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);  

if(Types == 'CURRENCY'){
Parentvalues = GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues = GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
}

else if(Types == 'DATE'){
Date Datestr = Date.valueof(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
}

else if(Types == 'DATETIME'){
Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
}

else if(Types == 'BOOLEAN'){
boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}
else{ 
Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
}
}
}
}
}
else{
if(parentSubRef.getsobject(Stringobjcts[0]) != null){    
if(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
string Types = getRelType(SobjectApiName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);

if(Types == 'CURRENCY'){
Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
}

else if(Types == 'NUMBER' || Types == 'DOUBLE'){
Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
}

else if(Types == 'DATE'){
Date Datestr = Date.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
string DateInt = ''+ Datestr.month();
if(Datestr.month() < 10){
DateInt = '0'+Datestr.month();
}
Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
}

else if(Types == 'DATETIME'){
Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
}

else if(Types == 'BOOLEAN'){

boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
if(textbool == true){
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
else{
Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
}
}
else{ 
Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
}

}
}
}
}
if(Parentvalues != ''){
if(templateSubject.contains('Barcode[{!'+Str+'}]')){
templateSubject = templateSubject.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
}
else{
templateSubject = templateSubject.replace('{!'+Str+'}',Parentvalues); 
}

}
else{
templateSubject = templateSubject.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
}

}
//templateHtmlValue += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';

}
else{*/
                        
                        EmailTemplate emailTempRec = [Select Id,Subject,Htmlvalue from EmailTemplate where DeveloperName = 'Junosign_Email_Templates'];
                        templateHtmlValue = emailTempRec.Htmlvalue;
                        templateSubject = emailTempRec.Subject;
                        //}
                        
                        /********* SAIRAM 21-02-2023 ***********/
                        
                        templateHtmlValue = templateHtmlValue.replace('{Name}', juno.JunoDoc__Recipient_Name__c);
                        if (templateHtmlValue != null) {
                            String expirationDateStr = juno.JunoSign_Expiration_Date__c != null
                                ? String.valueOf(juno.JunoSign_Expiration_Date__c)
                                : '';
                            templateHtmlValue = templateHtmlValue.replace('{ExpirationDate}', expirationDateStr);
                        }
                        //templateHtmlValue = templateHtmlValue.replace('{ExpirationDate}',String.valueOf(juno.JunoSign_Expiration_Date__c));
                        //String reviewDocumemtUrl = SiteURL+'?id='+con.id+'&recid='+juno.id+'&trancid='+juno.JunoDoc__Juno_Sign_Transaction__c+'&conid='+conid+'&orgDocid='+orgTempRecordId;
                        String orgTempRecordId = '';
                        String conDocIDs= '';
                        String reviewDocumemtUrl = SiteURL+'?id='+contVersion.ContentDocumentId+'&recid='+juno.id+'&trancid='+juno.JunoDoc__Juno_Sign_Transaction__c+'&conid='+conid+'&orgDocid='+orgTempRecordId+'&conDocID='+conDocIDs+'&showattachment=false';
                        system.debug('reviewDocumemtUrl-->'+reviewDocumemtUrl);
                        templateHtmlValue = templateHtmlValue.replace('{URL}', reviewDocumemtUrl);
                        system.debug('templateHtmlValue-->'+templateHtmlValue);
                        //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
                        templateHtmlValue = templateHtmlValue.replace('{logoURL}', logoUrl);
                        system.debug('templateHtmlValue-->'+templateHtmlValue);
                        
                        message.HTMLBody = templateHtmlValue;
                        message.subject = templateSubject;
                        
                        
                        
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            if(!Test.IsRunningTest()){
                                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            }
                        
                        
                        JunoDoc__Juno_Sign_Recipient__c jn = new JunoDoc__Juno_Sign_Recipient__c();
                        jn.id = juno.id;
                        jn.JunoDoc__signUrl__c = reviewDocumemtUrl;
                        jn.JunoDoc__Status__c = 'Pending';
                        update jn;
                    }
                }
                else{
                    JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                       Name,
                                                                       JunoDoc__CC_Address__c,
                                                                       JunoDoc__BCC_Address__c,
                                                                       JunoDoc__Set_Reply_To__c,
                                                                       JunoDoc__Final_Document_Id__c,
                                                                       JunoDoc__Date_Completed__c,
                                                                       JunoDoc__Status__c
                                                                       from JunoDoc__Juno_Sign_Transaction__c
                                                                       where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                    
                    JunoSignTrans.JunoDoc__Final_Document_Id__c = contVersion.ContentDocumentId;
                    JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                    JunoSignTrans.JunoDoc__Status__c = 'Completed';
                    update JunoSignTrans;
                    system.debug('@@@@JunoSignTrans'+JunoSignTrans);        
                }
            }
            
            
            
            // signee template                
            //EmailTemplate emailTemplateRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signee'];
            
            /********* SAIRAM 21-02-2023 ***********/
            string DateFormats;
            string CurrencyFormat;
            string NumberFormat;
            string currencysymbols;
            boolean blankasZeroes;
            map<string,string> currencySymbolMap;
            
            String templateHtmlValueForSignee = '';
            String templateSubjectForSignee = '';
            JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName  limit 1];
            
            if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c != null){
                JunoDoc__Email_Template_Item__c emailTemplateRecSignee = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c];
                JunoDoc__Email_Template__c emailTempForSignee = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRecSignee.JunoDoc__Email_Template__c];
                templateHtmlValueForSignee = emailTemplateRecSignee.JunoDoc__Template_Body__c; //emailTemplateRec.Htmlvalue;
                templateSubjectForSignee = emailTemplateRecSignee.JunoDoc__Subject__c;
                system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
                
                String SobjectApiName = emailTempForSignee.JunoDoc__Parent_Object__c;
                
                if(emailTempForSignee.Junodoc__Date_Format__c != null && emailTempForSignee.Junodoc__Date_Format__c != ''){
                    DateFormats = emailTempForSignee.Junodoc__Date_Format__c;
                }
                else{
                    DateFormats = 'MM/dd/yyyy';
                }
                if(emailTempForSignee.Junodoc__Currency_Format__c != null && emailTempForSignee.Junodoc__Currency_Format__c != ''){
                    CurrencyFormat = emailTempForSignee.Junodoc__Currency_Format__c;
                }
                else{
                    CurrencyFormat = '###,###.00';
                }
                
                if(emailTempForSignee.JunoDoc__Number_Format__c != null && emailTempForSignee.JunoDoc__Number_Format__c != ''){
                    NumberFormat = emailTempForSignee.JunoDoc__Number_Format__c;
                }
                else{
                    NumberFormat = '###,###.00';
                }
                
                
                currencysymbols = '$';
                system.debug(UserInfo.getDefaultCurrency());
                system.debug(currencySymbolMap);
                if(UserInfo.getDefaultCurrency() != null && currencySymbolMap != null && currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                    currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
                }
                Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
                // if(multiCurrencyEnabled){
                if(emailTempForSignee.JunoDoc__Currency_Symbol__c != null && emailTempForSignee.JunoDoc__Currency_Symbol__c != ''){
                    emailTempForSignee.JunoDoc__Currency_Symbol__c = emailTempForSignee.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                    Sobject Sobj = Database.query('select id,'+ emailTempForSignee.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:conid');
                    currencysymbols = currencySymbolMap.get(''+Sobj.get(emailTempForSignee.JunoDoc__Currency_Symbol__c));
                }
                
                if(templateHtmlValueForSignee.contains('{!TODAY()}')){
                    Date Datestr = system.Today();
                    string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                    templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!TODAY()}',Parentvalues); 
                    
                }
                if(templateHtmlValueForSignee.contains('{!NOW()}')){
                    string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                    templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!NOW()}',Parentvalues);  
                }
                
                if(templateHtmlValueForSignee.contains('{!#User.')){
                    string qry = 'select ';
                    templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!#User.','##user##');
                    string[] strlist = templateHtmlValueForSignee.split('##user##');
                    list<string> userfields = new list<string>();
                    integer z = 0;
                    for(string newstr : strlist){
                        if(z >= 1){
                            string[] userstr = newstr.split('}');
                            qry += userstr[0] + ',';
                            userfields.add(userstr[0]);
                            
                        }
                        z = z+1;
                    }
                    string userId = userinfo.getUserId();
                    qry += 'Id from user where id=: userId';
                    user users = Database.query(qry);
                    if(!userfields.isEmpty()){
                        for(string str : userfields){
                            templateHtmlValueForSignee = templateHtmlValueForSignee.replace('##user##'+str+'}',''+users.get(str));  
                        }
                    }
                }
                
                blankasZeroes =  emailTempForSignee.JunoDoc__Blank_Fields_As_Zeroes__c;
                
                
                SObject parentRef;
                string[] TempBdylist = templateHtmlValueForSignee.replace('{!','#####').split('#####');
                list <String> convertlstForSignee = new list<string>();
                for(string str : TempBdylist){
                    convertlstForSignee.add(str.split('}')[0]);
                }
                system.debug('convertlstForSignee-->'+convertlstForSignee);
                
                List <String> FldlstForSignee = new list<string>();
                for(integer a=1;a<convertlstForSignee.size();a++){
                    FldlstForSignee.add(convertlstForSignee[a]);
                }
                
                if(templateSubjectForSignee.contains('{!NOW()}')){
                    string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                    templateSubjectForSignee = templateSubjectForSignee.replace('{!NOW()}',Parentvalues);  
                }
                
                if(templateSubjectForSignee.contains('{!#User.')){
                    string qry = 'select ';
                    templateSubjectForSignee = templateSubjectForSignee.replace('{!#User.','##user##');
                    string[] strlist = templateSubjectForSignee.split('##user##');
                    list<string> userfields = new list<string>();
                    integer z = 0;
                    for(string newstr : strlist){
                        if(z >= 1){
                            string[] userstr = newstr.split('}');
                            qry += userstr[0] + ',';
                            userfields.add(userstr[0]);
                            
                        }
                        z = z+1;
                    }
                    string userId = userinfo.getUserId();
                    qry += 'Id from user where id=: userId';
                    user users = Database.query(qry);
                    if(!userfields.isEmpty()){
                        for(string str : userfields){
                            templateSubjectForSignee = templateSubjectForSignee.replace('##user##'+str+'}',''+users.get(str));  
                        }
                    }
                }
                
                string[] TempSublist = templateSubjectForSignee.replace('{!','#####').split('#####');
                list <String> convertSublstForSignee = new list<string>();
                for(string str : TempSublist){
                    convertSublstForSignee.add(str.split('}')[0]);
                }
                system.debug('convertSublstForSignee-->'+convertSublstForSignee);
                
                List <String> FldSublstForSignee = new list<string>();
                for(integer a=1;a<convertSublstForSignee.size();a++){
                    FldSublstForSignee.add(convertSublstForSignee[a]);
                }
                system.debug('FldSublstForSignee-->'+FldSublstForSignee);
                SObject parentSubRef;
                if(FldSublstForSignee.size()>0){
                    string qurySub = 'select ' + string.join(FldSublstForSignee,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                    system.debug('qurySub-->'+qurySub);
                    
                    parentSubRef = Database.query(qurySub);
                    system.debug('parentSubRef--->'+parentSubRef);
                }
              
                //templateHtmlValueForSignee += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';
                system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
            }
            else{
                EmailTemplate emailTempRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signees'];
                templateHtmlValueForSignee = emailTempRecSignee.HtmlValue;
                templateSubjectForSignee = emailTempRecSignee.Subject;
            }
            
            /********* SAIRAM 21-02-2023 ***********/
            
            templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{Name}', recdata[0].JunoDoc__Recipient_Name__c);
            system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
            //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
            templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{logoURL}', logoUrl);
            system.debug('templateHtmlValue-->'+templateHtmlValueForSignee);
            
            
            Messaging.SingleEmailMessage Signeemessage2 = new Messaging.SingleEmailMessage();
            Signeemessage2.toAddresses = new String[] { recdata[0].JunoDoc__Recipient_Email__c };
                //Signeemessage2.subject = 'Signature completed successfully';
                Signeemessage2.subject = templateSubjectForSignee;
            /* Signeemessage2.HTMLBody = '<html>Hi '+ recdata[0].JunoDoc__Recipient_Name__c+',<br></br>Your signature has been completed successfully, your signature has been attached.<br></br>Thank you.</html>';
*/
            if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != null){
                Signeemessage2.setReplyTo(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c);
            }
            Signeemessage2.setOrgWideEmailAddressId(emailAddressinObjectSettings);
            Signeemessage2.HTMLBody = templateHtmlValueForSignee;
            
            Messaging.SingleEmailMessage sendermessage2 = new Messaging.SingleEmailMessage();
            //send mail to record owner after signatures completion
            
            //query record from where mail has sent
            string mailsentFromrecordId = conid;
            String sobjectTypeString = Id.valueOf(mailsentFromrecordId).getSObjectType().getDescribe().getName();
            system.debug('mailsentFromrecordId--->'+mailsentFromrecordId);
            List<String> emailList = new List<String>();
            String orgRecordQuery = 'Select Id,Name,Owner.Email,Owner.Id from '+sobjectTypeString+' where Id=:mailsentFromrecordId';
            system.debug('orgRecordQuery-->'+orgRecordQuery);
            sObject rec = Database.query(orgRecordQuery);
            String UserEmail = UserInfo.getUserEmail(); //Returns the current user's email address.
            //System.debug( 'UserEmail-' + UserEmail);
            //system.debug('OwnerEmail->'+''+rec.getSobject('Owner').get('Email'));
            system.debug('OwnerEmail->'+''+rec.getSobject('Owner'));
            // if(rec.getSobject('Owner').get('Type') == 'User'){
            if(rec.getSobject('Owner') != null && string.valueOf(rec.getSobject('Owner').get('Id')).startsWith('005')){
                emailList.add(''+rec.getSobject('Owner').get('Email'));
            }
            //else if(rec.getSobject('Owner').get('Type') == 'Queue'){
            else if(rec.getSobject('Owner') != null && string.valueOf(rec.getSobject('Owner').get('Id')).startsWith('00G')){
                // if owner is queue
                String recOwnerId = ''+rec.getSobject('Owner').get('Id');
                // get members of queue
                Group queueRec = [SELECT Id,Type,RelatedId,(select userOrGroupId from groupMembers) FROM group WHERE Id =: recOwnerId];
                set<string> idList = new set<string>();
                for (GroupMember gm : queueRec.groupMembers) {
                    system.debug('type'+queueRec.Type);
                    idList.add(gm.userOrGroupId);
                    system.debug(gm.userOrGroupId);
                }
                
                // if queue members of queue are group/role user
                List<Group> innerGrpMem = [SELECT Id,Type,RelatedId,(select userOrGroupId from groupMembers) FROM group WHERE Id IN: idList];
                for(Group g: innerGrpMem){
                    system.debug('type'+g.Type);
                    if(g.Type == 'Role'){
                        system.debug('type1'+g.Type);
                        User roleuser = [SELECT Id, Name, Email, isActive, Profile.Name, UserRole.Id, UserRole.Name, UserType FROM User WHERE UserRole.Id=:g.RelatedId ];
                        system.debug('');
                        if(roleuser != null){
                            idList.add(roleuser.Id);
                            system.debug(roleuser.Id);
                        }
                    }else{
                        if(g.groupMembers != null){
                            for (GroupMember gm : g.groupMembers) {
                                if(gm.userOrGroupId != null){
                                    idList.add(gm.userOrGroupId);
                                    system.debug(gm.userOrGroupId);
                                }
                            } 
                        }
                    }
                }
                User[] usr = [SELECT email FROM user WHERE id IN :idList];
                system.debug('usr--?'+usr);
                for(User u : usr) {
                    //emailList.add(u.Email);
                }
                
            }
            
            System.debug( 'EmailList-->' + emailList);
            
            /*String email = 'sainadhmanohar@gmail.com';
emailList.add(email);*/
            
            //EmailTemplate emailTemplateRecOwner = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Owner'];
            //
            /********* SAIRAM 21-02-2023 ***********/
            String templateHtmlValueForOwner = '';
            String templateSubjectForOwner = '';
            
            ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName];
            
            EmailTemplate emailTemplateRecOwner = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Owner'];
            templateHtmlValueForOwner = emailTemplateRecOwner.Htmlvalue;
            templateSubjectForOwner = emailTemplateRecOwner.Subject;
            
            
            /********* SAIRAM 21-02-2023 ***********/
            
            templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{Name}', recdata[0].JunoDoc__Recipient_Name__c);
            system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
            //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
            templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{logoURL}', logoUrl);
            system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
            
            List<String> ccAddressList = new List<String>();
            if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c != null){
                ccAddressList = recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c.split(',');
            }
            List<String> bccAddressList = new List<String>();
            if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c != null){
                system.debug('bcc--->'+recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c);
                bccAddressList = recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c.split(',');
            }
            sendermessage2.toAddresses = emailList;
            sendermessage2.setOrgWideEmailAddressId(emailAddressinObjectSettings);
            if(ccAddressList.size() > 0){
                sendermessage2.ccAddresses = ccAddressList;
            }
            if(bccAddressList.size() > 0){
                sendermessage2.bccAddresses = bccAddressList;
            }
            if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != null){
                sendermessage2.setReplyTo(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c);
            }
            sendermessage2.subject = templateSubjectForOwner;
            //sendermessage2.toAddresses = new String[] {'sainadhmanohar@gmail.com'};//{ 'sriramsree004@gmail.com'};
            // sendermessage2.subject = 'Signature has been completed by Signee'; commented by sai 19th
            // sendermessage2.HTMLBody ='<html>Hi '+ recdata[0].JunoDoc__Juno_Sign_Transaction__r.Sender_Name__c+',<br></br>Your Signature has been signed by '+recdata[0].JunoDoc__Recipient_Name__c+ '<br></br>Thank you.</html>'; 
            
            sendermessage2.HTMLBody = templateHtmlValueForOwner;
            List<Messaging.Emailfileattachment> signeefileAttachments = new List<Messaging.Emailfileattachment>();
            List<Messaging.Emailfileattachment> senderfileAttachments = new List<Messaging.Emailfileattachment>();
            string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
            Attachment a = new Attachment(); 
            if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
               && Schema.sObjectType.Attachment.fields.Name.isCreateable() /*&& Schema.sObjectType.Attachment.fields.Description.isCreateable()*/
               && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                   a.Body = pdfBlob;//pdfPageBlobForAttachment; //Encodingutil.base64decode(strImageBlob); 
                   a.ParentID = recdata[0].id; 
                   
                   a.Name =  fileName+'-'+recdata[0].JunoDoc__Recipient_Name__c +' - ' + generate +' - Signed.pdf';
                   a.ContentType = 'application/pdf';
                   insert a;
                   
                   Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                   efa.setFileName(a.Name); 
                   efa.setBody(a.body); 
                   signeefileAttachments.add(efa);
                   senderfileAttachments.add(efa);
                   delete a;
               }
            /********* SAIRAM 22-02-2023 ***********/
            EmailTemplate emailTempRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signees'];
            /********* SAIRAM 22-02-2023 ***********/
            Id checkObjNameId =  Id.valueOf(mailsentFromrecordId);
            sObjName = checkObjNameId.getSObjectType().getDescribe().getName();
            Task Taskhistory = new Task();
            if(sObjName.toLowerCase()=='lead' || sObjName.toLowerCase()=='contact'){
                Taskhistory.WhoId   = Id.valueOf(mailsentFromrecordId);//recdata[0].id;    
            }else{
                Taskhistory.WhatId = Id.valueOf(mailsentFromrecordId);//recdata[0].id;    
            }                           
            Taskhistory.Status='Completed';
            Taskhistory.Subject = 'Signature has been completed by Signee';
            Taskhistory.JunoDoc__To_Email_Addresses__c = emailList+''; 
            Taskhistory.ActivityDate = System.Today();
            Taskhistory.Description = templateHtmlValueForOwner; //emailTempRecSignee.Htmlvalue; 
            insert Taskhistory;
            
            
            Attachment att = new Attachment();
            att.Body = pdfBlob; //Encodingutil.base64decode(strImageBlob); 
            att.ParentID = Taskhistory.Id; 
            att.Name =  fileName+'-'+recdata[0].JunoDoc__Recipient_Name__c +' - ' + generate +' - Signed.pdf';
            att.ContentType = 'application/pdf';
            insert att;
            
            Signeemessage2.setFileAttachments(signeefileAttachments);
            sendermessage2.setFileAttachments(senderfileAttachments);
            Messaging.SingleEmailMessage[] Signeemessages2 =   new List<Messaging.SingleEmailMessage> {Signeemessage2};
                Messaging.SingleEmailMessage[] Sendermessages2 =   new List<Messaging.SingleEmailMessage> {sendermessage2};
                    if(!Test.isRunningTest()) {
                        if (isAllRecipientEmail == false) {
                            Messaging.SendEmailResult[] Signresults2 = Messaging.sendEmail(Signeemessages2);
                           // Messaging.SendEmailResult[] Senderresults2 = Messaging.sendEmail(Sendermessages2);
                        }
                    }
            
            recdata[0].JunoDoc__Status__c = 'Signed';
            recdata[0].JunoDoc__Signed_On__c = system.today();
            recdata[0].JunoDoc__Signed_File_Id__c = contVersion.ContentDocumentId;
            update recdata;
            
            system.debug(paralleldata);
            if(!paralleldata.contains('Not Sent')){
                List<JunoDoc__Juno_Sign_Recipient__c> JunoSign = [select id,JunoDoc__Status__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')];
                system.debug('NewJunoSign'+JunoSign);
                if(JunoSign.isEmpty()){
                    system.debug('JunoSign is empty');
                    JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                       Name,
                                                                       JunoDoc__CC_Address__c,
                                                                       JunoDoc__BCC_Address__c,
                                                                       JunoDoc__Set_Reply_To__c,
                                                                       JunoDoc__Final_Document_Id__c,
                                                                       JunoDoc__Date_Completed__c,
                                                                       JunoDoc__Status__c
                                                                       from JunoDoc__Juno_Sign_Transaction__c
                                                                       where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                    JunoSignTrans.JunoDoc__Final_Document_Id__c = contVersion.ContentDocumentId;
                    JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                    JunoSignTrans.JunoDoc__Status__c = 'Completed';
                    update JunoSignTrans;
                    system.debug('@@@@JunoSignTrans'+JunoSignTrans);
                    JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                    audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                    audit.JunoDoc__Date__c = system.today();
                    audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                    audit.JunoDoc__IP_Address__c = ipaddress;//ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                    audit.JunoDoc__Status__c    = 'Signed';
                    insert audit;
                    
                    
                }
                
                
            }else{
                JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                audit.JunoDoc__Date__c = system.today();
                audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                audit.JunoDoc__IP_Address__c = ipaddress;//ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                audit.JunoDoc__Status__c    = 'Signed';
                insert audit;
                
                // audit trail for sending mail to remaining persons
                JunoDoc__Audit_Trail__c audit1 = new JunoDoc__Audit_Trail__c();
                audit1.Name = JunorecList[0].JunoDoc__Recipient_Name__c; 
                audit1.JunoDoc__Date__c = system.today();
                audit1.JunoDoc__JunoSign_Transaction__c = JunorecList[0].JunoDoc__Juno_Sign_Transaction__c;
                audit1.JunoDoc__IP_Address__c = ipaddress; //ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');    
                audit1.JunoDoc__Status__c    = 'Pending';
                insert audit1;
            }
            List<JunoDoc__Juno_Sign_Recipient__c> JunoSignRecList = [select id,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =: recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')];
            system.debug('JunoSignRecList'+JunoSignRecList);
            /* List<JunoDoc__Doc_Template__c> checkForClonedDocTemplate = [Select Id,Name,CreatedDate from JunoDoc__Doc_Template__c where Name =:cloneName Order By CreatedDate DESC];
if(checkForClonedDocTemplate.size() > 0 && JunoSignRecList.isEmpty()){
deleteDocTemplate();
} */
            
            List<JunoDoc__Juno_Sign_Recipient__c> signedRecipients = [SELECT Id, Juno_Sign_Transaction__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c AND Status__c = 'Signed'];
            List<JunoDoc__Juno_Sign_Recipient__c> AllRecipient = [SELECT Id, Juno_Sign_Transaction__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c];
            if(signedRecipients.size() == AllRecipient.size()){
                JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                   Name,
                                                                   JunoDoc__CC_Address__c,
                                                                   JunoDoc__BCC_Address__c,
                                                                   JunoDoc__Set_Reply_To__c,
                                                                   JunoDoc__Final_Document_Id__c,
                                                                   JunoDoc__Date_Completed__c,
                                                                   JunoDoc__Status__c
                                                                   from JunoDoc__Juno_Sign_Transaction__c
                                                                   where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                
                JunoSignTrans.JunoDoc__Final_Document_Id__c = contVersion.ContentDocumentId;
                JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                JunoSignTrans.JunoDoc__Status__c = 'Completed';
                update JunoSignTrans;
                system.debug('@@@@JunoSignTrans'+JunoSignTrans); 
                
                
                
            }
            
            // Return success response
            return JSON.serialize(new Map<String, Object>{
                'status' => 'success',
                    'contentVersionId' => contVersion.Id
                    });
        } catch (Exception e) {
            // Return error response
            return JSON.serialize(new Map<String, Object>{
                'status' => 'error',
                    'message' => 'Error processing PDF: ' + e.getMessage() + ' at line ' + e.getLineNumber()
                    });
        }
    }
}
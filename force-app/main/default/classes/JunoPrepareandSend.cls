public class JunoPrepareandSend {
    public transient string body {get; set;} 
    public transient string secondbody {get; set;}
    public string docList  {get;set;}
    public string docidList  {get;set;}
    public string UploadedFilesList{get;set;}
    public string pageTabPosListVal {get;set;}
    public string TransactionIds {get;set;}
    public string domainUrl {get;set;}
    public string receiverList {get;set;}
    public string usersidepageTab {get;set;}
    public string recordId  {get;set;}
    public Boolean isInPerson  {get;set;}
    public string signUrl {get;set;}
    public string DocTemplateId  {get;set;}
    public string htmlForSign  {get;set;}
    public List<recipentInner> recpList {get;set;}
    public String ccReceiverAddresses {get;set;}
    public String bccReceiverAddresses {get;set;}
    public string emailAddressinObjectSettings {get;set;}
    public Boolean showattachment {get;set;}
    public string setReplyTo{get;set;}
    public string serializedData{get;set;}
    public string sObjName {get;set;}
    public list<string> deserializedData {get;set;}
    
    public string logoUrl {get;set;}
    public JunoPrepareandSend(){
        docList = ApexPages.currentPage().getParameters().get('docList');
        docidList = ApexPages.currentPage().getParameters().get('docidList');
        UploadedFilesList = ApexPages.currentPage().getParameters().get('FileList');
        domainUrl = System.Url.getOrgDomainUrl().toExternalForm();
        receiverList = ApexPages.currentPage().getParameters().get('receiverList');
        TransactionIds = ApexPages.currentPage().getParameters().get('TransactionIds');
        recordId  = ApexPages.currentPage().getParameters().get('recordId');
        isInPerson =Boolean.valueOf(ApexPages.currentPage().getParameters().get('isInPerson')) ;
        showattachment = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showattachment')) ;
        setReplyTo = ApexPages.currentPage().getParameters().get('SetReplyTo');
        serializedData = ApexPages.currentPage().getParameters().get('insertedIds');
        
        if (serializedData != null)  {
            deserializedData = (List<String>) JSON.deserialize(serializedData, List<Id>.class);
        } else {
            System.debug('Serialized data is null or empty');
        }
        
        List<Document> docRecod= [Select Id,Name from Document where DeveloperName = 'Junosign_logo'];
        system.debug(System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com',''));
        string domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
        String OrgId = ''+UserInfo.getOrganizationId();
        if(docRecod.size()>0){
            logoUrl = 'https://'+domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docRecod[0].Id+'&oid='+OrgId; 
        }
        system.debug('logoUrl--->'+logoUrl);
        
        system.debug('receiverList-->'+receiverList);
        system.debug('docList-->'+docidList);
        
        sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        SYSTEM.debug('sObjName>>>>>>>>>>>>>>>>>'+sObjName);
        
        list <JunoDoc__Junosign_Object_Setting__c> fromadd = new list<JunoDoc__Junosign_Object_Setting__c>();
        fromadd=[select JunoDoc__FromEmailAddress__c,JunoDoc__Selected_object__c 
                 from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName ];
        SYSTEM.debug('fromadd>>>>>>>>>>>>>>>>>'+fromadd);
        List<Junodoc_Setting__c> setlist = [SELECT Id, JunoDoc__Signature_Cancel_Message__c, JunoDoc__Signature_Success_Message__c, JunoDoc__Site_URL__c, JunoDoc__Enable_JunoSign__c, JunoDoc__Signature_Format__c, JunoDoc__JunoSign_Default_From_Address__c, JunoDoc__Enable_Attachment_List_View__c, JunoDoc__Enable_Signature_Rejection__c, JunoDoc__Disable_Email_Template_Body__c, JunoDoc__Enable_JunoSign_Post_Actions__c FROM JunoDoc__Junodoc_Setting__c];
        
        if (fromadd.size() > 0 && fromadd[0].JunoDoc__FromEmailAddress__c != null) {
            emailAddressinObjectSettings = fromadd[0].JunoDoc__FromEmailAddress__c;
        } else if (setlist.size() > 0) {
            emailAddressinObjectSettings = setlist[0].JunoDoc__JunoSign_Default_From_Address__c;
        }
    }
    
    public void savePageTabsVal(){
        // createrecord();
    }
    
    public string callUserSignpage(){
        String SiteURL = '';
        PageReference vfPage1 = new PageReference(signUrl);
        return vfPage1.getUrl();
    }
    
    public PageReference pageReferencecall(){
        System.debug('Entered');
        PageReference nextPage = new PageReference('/'+recordId);
        nextPage.setRedirect(true);
        return nextPage;
    }
    
    public class posTabs{
        public String top;
        public String left;
        public String type;
        public String Name;
        public Integer recipientOrder;
    }
    
    public class recipentInnerPostActionList{
        public List<recipentInner> recipient ;
    }
    
    public class PostActionRecords {
        @AuraEnabled  public String fieldName ;
        @AuraEnabled  public String fieldType;
        @AuraEnabled  public String fieldValue;
        @AuraEnabled  public String  parentId;
    }
    
    public class recipentInner{
        @AuraEnabled  public String name;	
        @AuraEnabled  public String email;
        @AuraEnabled  public date ExpirationDate;
        @AuraEnabled  public String description;
        @AuraEnabled  public List<PostActionRecords> childRows ;
        @AuraEnabled public Boolean selectedWeekdays;
        @AuraEnabled public Boolean selectedBeforeDays;
        @AuraEnabled public  list<String> selectedDays;
        @AuraEnabled public Boolean selectedRecurringDay;
        @AuraEnabled public  list<String> selectedRecurringDays;
    }
    
    public class EmailTyperecipentInner{
        public String name;	
        public String email;	
        public String emailType;	
        public String ExpirationDate;
        public String textValue;
        public string Remainder;
    }
    
    public class InnerClass{
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public string fileContents {get;set;}
    }
    
    public class responseData{
        @AuraEnabled public String SiteURLLink  {get;set;}
        @AuraEnabled public Id TransactionId {get;set;}
    }
    
    public void getpositionsTabs (){
        String trancId =  ApexPages.currentPage().getParameters().get('trancid');
        List<JunoDoc__Junodoc_Page_Tab__c> junousersign = [select Id,Name, JunoDoc__Pos_Left__c, JunoDoc__Pos_Top__c, JunoDoc__Sign_Completed__c,JunoDoc__Type__c,JunoDoc__Linked_To__c  from JunoDoc__Junodoc_Page_Tab__c where JunoDoc__Sign_Completed__c =: false AND JunoDoc__Linked_To__c=:trancId];
        usersidepageTab = JSON.serialize(junousersign);
        String  fileid = ApexPages.currentPage().getParameters().get('id');
        ContentVersion  cont = [select id,VersionData,title from ContentVersion where ContentDocumentId =: fileid];
        if(Encodingutil.base64encode(cont.VersionData).length() <= 5999950){
            body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData));
        }
        else{
            body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData)).substring(0,5999950);
            secondbody= (Encodingutil.base64encode(cont.VersionData)).substring(5999950,Encodingutil.base64encode(cont.VersionData).length());
        }
    }
    
    @AuraEnabled
    public static responseData insertRecipientsAndRows(String receiverJson , String recId, string docList ,string Files, string SetReplyTo ,string showattachment, string isInPersons ,string  recordId , string docidList) {
        ResponseData response = new ResponseData();
        Boolean  isInPerson = Boolean.valueOf(isInPersons);
        string reminderSignUrl  = '';
        string sObjName = '';
        string ObjName = '';
        string logoUrl = '';
        string signUrl = '';
        List<PostActionRecords> updatedChildRows = new List<PostActionRecords>();
        
        string emailAddressinObjectSettings = '';
        List<Document> docRecod= [Select Id,Name from Document where DeveloperName = 'Junosign_logo'];
        string domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
        String OrgId = ''+UserInfo.getOrganizationId();
        if(docRecod.size()>0){
            logoUrl = 'https://'+domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docRecod[0].Id+'&oid='+OrgId; 
        }
        
        List<string> fileIDS = new List<String>();
        if(!String.isBlank(docList)){
            fileIDS = docList.split(',');
        }
        
        string fileid = docidList;
        List<InnerClass> AttachedFiles = (List<InnerClass>)System.JSON.deserialize(Files, List<InnerClass>.class);
        
        List<string> AttachedIDs = new List<string>();
        for(InnerClass att : AttachedFiles){
            AttachedIDs.add(att.fileContents);
            fileIDS.add(att.fileContents);            
        }
        
        if(docList != null && docList != ''){
            Id checkObjNameId =  Id.valueOf(docList);
            ObjName = checkObjNameId.getSObjectType().getDescribe().getName();
        }
        
        sObjName = Id.valueOf(recId).getSObjectType().getDescribe().getName();
        list <JunoDoc__Junosign_Object_Setting__c> fromadd = new list<JunoDoc__Junosign_Object_Setting__c>();
        fromadd=[select JunoDoc__FromEmailAddress__c,JunoDoc__Selected_object__c 
                 from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName ];
        SYSTEM.debug('fromadd>>>>>>>>>>>>>>>>>'+fromadd);
        List<Junodoc_Setting__c> setlist = [SELECT Id, JunoDoc__Signature_Cancel_Message__c, JunoDoc__Signature_Success_Message__c, JunoDoc__Site_URL__c, JunoDoc__Enable_JunoSign__c, JunoDoc__Signature_Format__c, JunoDoc__JunoSign_Default_From_Address__c, JunoDoc__Enable_Attachment_List_View__c, JunoDoc__Enable_Signature_Rejection__c, JunoDoc__Disable_Email_Template_Body__c, JunoDoc__Enable_JunoSign_Post_Actions__c FROM JunoDoc__Junodoc_Setting__c];
        
        if (fromadd.size() > 0 && fromadd[0].JunoDoc__FromEmailAddress__c != null) {
            emailAddressinObjectSettings = fromadd[0].JunoDoc__FromEmailAddress__c;
        } else if (setlist.size() > 0) {
            emailAddressinObjectSettings = setlist[0].JunoDoc__JunoSign_Default_From_Address__c;
        }
        
        // NEW: Parse recipients including groups
        List<RecipientWrapperJSON> recipientsRaw = (List<RecipientWrapperJSON>)JSON.deserialize(receiverJson, List<RecipientWrapperJSON>.class);
        List<RecipientWrapper> recipientWrappers = new List<RecipientWrapper>();
        
        for(RecipientWrapperJSON jsonWrapper : recipientsRaw) {
            RecipientWrapper wrapper = new RecipientWrapper();
            wrapper.name = jsonWrapper.Name;
            wrapper.email = jsonWrapper.Email;
            wrapper.emailType = jsonWrapper.EmailType;
            wrapper.isGroup = jsonWrapper.isGroup != null ? jsonWrapper.isGroup : false;
            wrapper.memberCount = jsonWrapper.memberCount != null ? jsonWrapper.memberCount : 0;
            wrapper.expirationDate = jsonWrapper.ExpirationDate != null ? Date.valueOf(jsonWrapper.ExpirationDate) : null;
            wrapper.textValue = jsonWrapper.textValue;
            wrapper.groupMembers = jsonWrapper.groupMembers != null ? jsonWrapper.groupMembers : new List<GroupMember>();
            wrapper.childRows = jsonWrapper.childRows != null ? jsonWrapper.childRows : new List<PostActionRecords>();
            recipientWrappers.add(wrapper);
        }
        
        Schema.SObjectType sobjectType = Id.valueOf(fileid).getSObjectType();
        String objectName = sobjectType.getDescribe().getName();
        string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
        Blob pdfPageBlob; 
        Id conDocid;
        
        if(objectName == 'JunoDoc__Doc_Template__c'){
            PageReference pagePdf = new PageReference('/apex/Junodoc__JunodocPDF'); 
            pagePdf.getParameters().put('id', recordId); 
            pagePdf.getParameters().put('DocTemplateId', fileid); 
            
            if(Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            }
            else{
                pdfPageBlob = pagePdf.getContentAsPDF(); 
            }
            
            JunoDoc__Doc_Template__c DocTemplates = [select id,Name from JunoDoc__Doc_Template__c where Id=: fileid];
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S';
            conVer.PathOnClient = DocTemplates.Name+' - '+ generate + ' - Sent .pdf';
            conVer.Title = DocTemplates.Name+' - '+generate + ' - Sent';
            conVer.VersionData = pdfPageBlob;
            insert conVer; 
            
            conDocid = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentVersion con = [select id,OwnerId,contentdocumentid from ContentVersion where id=:conVer.id];
            con.ownerId = userinfo.getUserId();
            update con;
            
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId =recId;
            conDocLink.ContentDocumentId = conDocid;
            conDocLink.shareType = 'I';
            conDocLink.Visibility = 'AllUsers'; 
            insert conDocLink;
        }else{
            conDocid = fileid;
            
            ContentVersion con = [select id,OwnerId,contentdocumentid from ContentVersion where contentdocumentid=:fileid];
            con.ownerId = userinfo.getUserId();
            update con;
        }
        
        JunoDoc__Juno_Sign_Transaction__c junoSign = new JunoDoc__Juno_Sign_Transaction__c();
        junoSign.JunoDoc__Object_Id__c = recordId;
        junoSign.JunoDoc__Date_Sent__c = system.today();
        junoSign.JunoDoc__Original_Document_Id__c = fileid;
        junoSign.JunoDoc__Original_File_Id__c = conDocid;
        junoSign.JunoDoc__Email_Subject__c = 'Document via JunoSign';
        junoSign.JunoDoc__Sender_Name__c = UserInfo.getName();
        junoSign.JunoDoc__Sender_Email__c = Userinfo.getUserEmail();
        junoSign.JunoDoc__Status__c = 'Sent';
        
        if(setReplyTo != null && setReplyTo != '' && setReplyTo != 'undefined'){
            junoSign.JunoDoc__Set_Reply_To__c = setReplyTo;
        }
        insert junoSign;
        Id Transactionid = junoSign.Id;
        response.TransactionId = Transactionid;
        
        // NEW: Insert recipients with group handling
        Integer sortOrder = 1;
        List<JunoDoc__Juno_Sign_Recipient__c> recipientRecordList = new List<JunoDoc__Juno_Sign_Recipient__c>();
        Map<Id, List<GroupMember>> groupIdToMembersMap = new Map<Id, List<GroupMember>>();
        Map<String, List<PostActionRecords>> emailToIdMapChild = new Map<String, List<PostActionRecords>>();
        Map<String, Id> emailToIdMap = new Map<String, Id>();
        
        for(RecipientWrapper wrapper : recipientWrappers) {
            if(wrapper.emailType == 'To') {
                if(wrapper.isGroup) {
                    // Create group recipient
                    JunoDoc__Juno_Sign_Recipient__c groupRecipient = new JunoDoc__Juno_Sign_Recipient__c(
                        JunoDoc__Recipient_Email__c = wrapper.email,
                        JunoDoc__Recipient_Name__c = wrapper.name,
                        JunoDoc__JunoSign_Expiration_Date__c = wrapper.expirationDate,
                        JunoDoc__Description__c = wrapper.textValue,
                        JunoDoc__Juno_Sign_Transaction__c = junoSign.id,
                        JunoDoc__Status__c = 'Not Sent',
                        JunoDoc__JunoSign_Recipient_Type__c = 'Group',
                        JunoDoc__junoSign_MemberCount__c = wrapper.memberCount,
                        JunoDoc__Sort_Order__c = sortOrder
                    );
                    recipientRecordList.add(groupRecipient);
                    groupIdToMembersMap.put(null, wrapper.groupMembers);
                    emailToIdMapChild.put(wrapper.email, wrapper.childRows);
                } else {
                    // Create individual recipient
                    JunoDoc__Juno_Sign_Recipient__c individualRecipient = new JunoDoc__Juno_Sign_Recipient__c(
                        JunoDoc__Recipient_Email__c = wrapper.email,
                        JunoDoc__Recipient_Name__c = wrapper.name,
                        JunoDoc__JunoSign_Expiration_Date__c = wrapper.expirationDate,
                        JunoDoc__Description__c = wrapper.textValue,
                        JunoDoc__Juno_Sign_Transaction__c = junoSign.id,
                        JunoDoc__Status__c = 'Not Sent',
                        JunoDoc__JunoSign_Recipient_Type__c = 'Individual',
                        JunoDoc__Sort_Order__c = sortOrder
                    );
                    recipientRecordList.add(individualRecipient);
                    emailToIdMap.put(wrapper.email, null);
                    emailToIdMapChild.put(wrapper.email, wrapper.childRows);
                }
                sortOrder++;
            }
        }
        
        if (!recipientRecordList.isEmpty()) {
            insert recipientRecordList;
            
            // Update emailToIdMap and groupIdToMembersMap with actual IDs
            for (JunoDoc__Juno_Sign_Recipient__c rec : recipientRecordList) {
                if(rec.JunoDoc__JunoSign_Recipient_Type__c == 'Individual') {
                    emailToIdMap.put(rec.JunoDoc__Recipient_Email__c, rec.Id);
                } else if(rec.JunoDoc__JunoSign_Recipient_Type__c == 'Group') {
                    List<GroupMember> members = groupIdToMembersMap.get(null);
                    groupIdToMembersMap.remove(null);
                    groupIdToMembersMap.put(rec.Id, members);
                }
            }
            
            // NEW: Create group member recipients
            List<JunoDoc__Juno_Sign_Recipient__c> groupMemberRecipients = new List<JunoDoc__Juno_Sign_Recipient__c>();
            
            for(JunoDoc__Juno_Sign_Recipient__c recipient : recipientRecordList) {
                if(recipient.JunoDoc__JunoSign_Recipient_Type__c == 'Group') {
                    List<GroupMember> members = groupIdToMembersMap.get(recipient.Id);
                    if(members != null) {
                        for(GroupMember member : members) {
                            JunoDoc__Juno_Sign_Recipient__c memberRecipient = new JunoDoc__Juno_Sign_Recipient__c(
                                JunoDoc__Recipient_Email__c = member.email,
                                JunoDoc__Recipient_Name__c = member.name,
                                JunoDoc__JunoSign_Expiration_Date__c = recipient.JunoDoc__JunoSign_Expiration_Date__c,
                                JunoDoc__Description__c = recipient.JunoDoc__Description__c,
                               // JunoDoc__Juno_Sign_Transaction__c = junoSign.id,
                                JunoDoc__Status__c = 'Not Sent',
                                JunoDoc__JunoSign_Recipient_Type__c = 'Group Member',
                                JunoDoc__JunoSign_Group_Parent_Recipient__c = recipient.Id,
                                JunoDoc__Sort_Order__c = recipient.JunoDoc__Sort_Order__c
                            );
                            groupMemberRecipients.add(memberRecipient);
                            emailToIdMap.put(member.email, null);
                        }
                    }
                }
            }
            
            if(!groupMemberRecipients.isEmpty()) {
                insert groupMemberRecipients;
                
                // Update emailToIdMap with group member IDs
                for (JunoDoc__Juno_Sign_Recipient__c rec : groupMemberRecipients) {
                    emailToIdMap.put(rec.JunoDoc__Recipient_Email__c, rec.Id);
                }
            }
        }
        
        // Process post actions
        List<PostActionRecords> childRowlist = new List<PostActionRecords>();
        for (String email : emailToIdMapChild.keySet()) {
            if (emailToIdMap.containsKey(email)) {
                childRowlist = emailToIdMapChild.get(email);
                if (childRowlist != null && !childRowlist.isEmpty()) {
                    for (PostActionRecords record : childRowlist) {
                        record.parentId = emailToIdMap.get(email);
                        updatedChildRows.add(record);
                    }
                }
            }
        }
        if (childRowlist == null) {
            childRowlist = new List<PostActionRecords>();
        }
        childRowlist.addAll(updatedChildRows);
        if (childRowlist != null && !childRowlist.isEmpty()) {
            JunoSignPostActionsController.updateRecord((Id)recId, childRowlist);
        }
        
        String SiteURL = '';
        List<JunoDoc__Junodoc_Setting__c> listurl = [Select JunoDoc__Site_URL__c FROM JunoDoc__Junodoc_Setting__c LIMIT 1];
        if(listurl.size() > 0){
            SiteURL = listurl[0].JunoDoc__Site_URL__c; 
        }
        
        // UPDATED: Send emails to recipients with group handling
        for(JunoDoc__Juno_Sign_Recipient__c juno:[
            select id, JunoDoc__Recipient_Email__c, JunoSign_Expiration_Date__c, 
                   JunoDoc__Recipient_Name__c, JunoDoc__Status__c, JunoDoc__Juno_Sign_Transaction__c, 
                   JunoDoc__Description__c, JunoDoc__JunoSign_Recipient_Type__c,
                   JunoDoc__JunoSign_Group_Parent_Recipient__c 
            from JunoDoc__Juno_Sign_Recipient__c 
            where JunoDoc__Sort_Order__c=1 And JunoDoc__Juno_Sign_Transaction__c =: junoSign.id
            AND JunoDoc__JunoSign_Recipient_Type__c != 'Group Member'
        ]){
            
            // Get all recipients that should receive emails for this sort order
            List<JunoDoc__Juno_Sign_Recipient__c> recipientsToEmail = new List<JunoDoc__Juno_Sign_Recipient__c>();
            
            if(juno.JunoDoc__JunoSign_Recipient_Type__c == 'Group') {
                // If it's a group, get all group members
                recipientsToEmail = [
                    select id, JunoDoc__Recipient_Email__c, JunoSign_Expiration_Date__c, 
                           JunoDoc__Recipient_Name__c, JunoDoc__Status__c, JunoDoc__Description__c, JunoDoc__Juno_Sign_Transaction__c
                    from JunoDoc__Juno_Sign_Recipient__c 
                    where JunoDoc__JunoSign_Group_Parent_Recipient__c = :juno.Id
                    AND JunoDoc__JunoSign_Recipient_Type__c = 'Group Member'
                ];
            } else {
                // If it's an individual, just add this recipient
                recipientsToEmail.add(juno);
            }
            
            // Process each recipient that needs to receive an email
            for(JunoDoc__Juno_Sign_Recipient__c recipient : recipientsToEmail) {
                
                String templateHtmlValue = '';
                String templateSubject = '';
                
                JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName limit 1];
                
                if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c != null){
                    JunoDoc__Email_Template__c emailTemp = [Select Id, JunoDoc__Junodoc_generated_template_body__c, JunoDoc__Junodoc_generated_template_subject__c from JunoDoc__Email_Template__c where Id=: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c];
                    if(emailTemp.JunoDoc__Junodoc_generated_template_body__c != null && emailTemp.JunoDoc__Junodoc_generated_template_body__c != ''){
                        templateHtmlValue = emailTemp.JunoDoc__Junodoc_generated_template_body__c;
                    }
                    if(emailTemp.JunoDoc__Junodoc_generated_template_subject__c != null && emailTemp.JunoDoc__Junodoc_generated_template_subject__c != ''){
                        templateSubject = emailTemp.JunoDoc__Junodoc_generated_template_subject__c;
                    }
                } else {
                    EmailTemplate emailTempRec = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'Junosign_Email_Templates'];
                    templateHtmlValue = emailTempRec.Htmlvalue;
                    templateSubject = emailTempRec.Subject;
                }
                
                templateHtmlValue = templateHtmlValue.replace('{Name}', recipient.JunoDoc__Recipient_Name__c);
                templateHtmlValue = templateHtmlValue.replace('{ExpirationDate}', String.valueOf(recipient.JunoSign_Expiration_Date__c));
                string fileIdList = string.join(fileIDS,',');
                
                String reviewDocumemtUrl = SiteURL+'?id='+fileid+'&recid='+recipient.id+'&trancid='+junoSign.id+'&conid='+recordId+'&orgDocid='+fileid+'&conDocID='+fileIdList+'&showAttachment='+showAttachment;
                
                templateHtmlValue = templateHtmlValue.replace('{URL}', reviewDocumemtUrl);
                templateHtmlValue = templateHtmlValue.replace('junodoc__review_document_url', reviewDocumemtUrl);
                templateHtmlValue = templateHtmlValue.replace('{logoURL}', logoUrl);
                
                if (recipient.JunoDoc__Description__c != null) {
                    templateHtmlValue = templateHtmlValue.replace('{Description}', recipient.JunoDoc__Description__c);
                } else {
                    templateHtmlValue = templateHtmlValue.replace('{Description}', '');
                }
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { recipient.JunoDoc__Recipient_Email__c };
                
                if(setReplyTo != null && setReplyTo != '' && setReplyTo != 'undefined'){
                    message.setReplyTo(setReplyTo);
                }

                system.debug('emailAddressinObjectSettings >> '+emailAddressinObjectSettings);
                
                if(!String.isBlank(emailAddressinObjectSettings)){
                    message.setOrgWideEmailAddressId(emailAddressinObjectSettings);
                }
                
                message.subject = templateSubject;
                message.HTMLBody = templateHtmlValue;
                
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                if(!fileIDS.isEmpty()){
                    if(!Test.IsRunningTest()){
                        for (ContentDocumentLink a : [SELECT id,ContentDocument.Title,ContentDocument.FileType,ContentDocument.FileExtension,
                                                    ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.VersionData
                                                    FROM ContentDocumentLink Where ContentDocumentID IN :fileIDS]) {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.ContentDocument.Title+'.'+a.ContentDocument.FileExtension);
                            String blobValue = EncodingUtil.base64Encode(a.ContentDocument.LatestPublishedVersion.VersionData);
                            efa.setBody(EncodingUtil.base64Decode(blobValue));
                            fileAttachments.add(efa);
                        }
                    }
                    if(!fileAttachments.isEmpty()){
                        message.setFileAttachments(fileAttachments);
                    }
                }
                
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                
                if(isInPerson == false){
                    if(!Test.IsRunningTest()){
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    }
                    if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c != null){
                        JunoDoc__Email_Template__c junoEmail = new JunoDoc__Email_Template__c();
                        junoEmail.Id = ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c;
                        junoEmail.JunoDoc__Junodoc_generated_template_body__c = '';
                        junoEmail.JunoDoc__Junodoc_generated_template_subject__c = '';
                        update junoEmail;
                    }
                } else {
                    domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
                    SiteURL = SiteURL.replace('http://', 'https://');
                    signUrl = SiteURL+'?id='+fileid+'&recid='+recipient.id+'&trancid='+junoSign.id+'&conid='+recordId+'&isInPerson='+true+'&domainName='+domainName+'&orgDocid='+fileid+'&conDocID='+fileIdList+'&showattachment='+showattachment;
                    response.SiteURLLink = signUrl;
                    reminderSignUrl = signUrl;
                }
                
                List<AuthSession> auth = [SELECT Id,UsersId, SourceIp FROM AuthSession];
                JunoDoc__Juno_Sign_Recipient__c jn = new JunoDoc__Juno_Sign_Recipient__c();
                jn.id = recipient.id;
                jn.JunoDoc__signUrl__c = reviewDocumemtUrl;
                jn.JunoDoc__Status__c = 'Pending';
                update jn;
                
                JunoDoc__Audit_Trail__c at = new JunoDoc__Audit_Trail__c();
                at.Name = recipient.JunoDoc__Recipient_Name__c;
                at.JunoDoc__Status__c = 'Pending';
                at.JunoDoc__Date__c = system.today();
                at.JunoDoc__JunoSign_Transaction__c = recipient.JunoDoc__Juno_Sign_Transaction__c;
                at.JunoDoc__IP_Address__c = auth[0].SourceIp;
                
                if(isInPerson == false){
                    insert at;
                }
            }
            
            // UPDATE THE GROUP STATUS AFTER PROCESSING ALL MEMBERS
            if (juno.JunoDoc__JunoSign_Recipient_Type__c == 'Group') {
                List<AuthSession> auth = [SELECT Id,UsersId, SourceIp FROM AuthSession];
                
                JunoDoc__Juno_Sign_Recipient__c groupJn = new JunoDoc__Juno_Sign_Recipient__c();
                groupJn.id = juno.id;
                groupJn.JunoDoc__Status__c = 'Pending';
                update groupJn;
                
                JunoDoc__Audit_Trail__c groupAt = new JunoDoc__Audit_Trail__c();
                groupAt.Name = juno.JunoDoc__Recipient_Name__c;
                groupAt.JunoDoc__Status__c = 'Pending';
                groupAt.JunoDoc__Date__c = system.today();
                groupAt.JunoDoc__JunoSign_Transaction__c = juno.JunoDoc__Juno_Sign_Transaction__c;
                groupAt.JunoDoc__IP_Address__c = auth[0].SourceIp;
                
                if(isInPerson == false){
                    insert groupAt;
                }
            }
        }
        
        if(recipientWrappers.size()==1){
            JunoDoc__Juno_Sign_Transaction__c junoTran = new JunoDoc__Juno_Sign_Transaction__c();
            junoTran.id=junoSign.id;
            junoTran.JunoDoc__Status__c='Sent'; 
            update junoTran;
        }
        
        return response;
    }
    
    // NEW: Helper classes for group handling
    public class RecipientWrapper {
        public String name {get; set;}
        public String email {get; set;}
        public String emailType {get; set;}
        public Boolean isGroup {get; set;}
        public Integer memberCount {get; set;}
        public Date expirationDate {get; set;}
        public String textValue {get; set;}
        public List<GroupMember> groupMembers {get; set;}
        public List<PostActionRecords> childRows {get; set;}
    }
    
    public class RecipientWrapperJSON {
        public String Name {get; set;}
        public String Email {get; set;}
        public String EmailType {get; set;}
        public Boolean isGroup {get; set;}
        public Integer memberCount {get; set;}
        public String ExpirationDate {get; set;}
        public String textValue {get; set;}
        public List<GroupMember> groupMembers {get; set;}
        public List<PostActionRecords> childRows {get; set;}
    }
    
    public class GroupMember {
        public String name {get; set;}
        public String email {get; set;}
    }
}
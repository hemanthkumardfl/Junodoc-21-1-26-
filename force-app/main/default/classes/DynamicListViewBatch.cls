global with sharing class DynamicListViewBatch implements Database.Batchable<sObject> {
    
    global string DocTemplateId;
    global list<string> Id;
    global String Subject;
    global String Body;
    global list<String> toUserEmailsList;
    global list<String> toContactEmailsList;
    global String toEmails;
    global boolean SaveAsActivity;
    global list<string> EmailField;
    global string soqlquery;
    global string objectNames;
    global string StandardEmailTemplateSelectedValues;
    global string JunoDocEmailTemplateSelectedValues;
    public list<string> ToTextEmailsList;
    public list<string> ToEmailMergeFieldsList;    
    public list<string> CCTextEmailsList;
    public list<string> CCEmailMergeFieldsList;    
    public list<string> BCCTextEmailsList;
    public list<string> BCCEmailMergeFieldsList;
    public string FromEmailAddress;
    public string SetReplyTo;
    
    global DynamicListViewBatch(list<string> RecIds,string DocTemplateIds, string Subjects,string Bodys,
                                list<string> toUserEmailsLists,
                                list<string> toContactEmailsLists,String toEmail,
                                boolean SaveAsActivitys,list<String> EmailFields,string objectName,
                                string StandardEmailTemplateSelectedValue,
                                string JunoDocEmailTemplateSelectedValue) {
                                    this.Id = new list<string>();
                                    for(string str : RecIds){
                                        system.debug('str'+str);
                                        String[] Strlist = str.split(',');
                                        for(string strs : Strlist){
                                            this.Id.add(strs.trim().replace('[','').replace(']','').replace('(','').replace(')',''));     
                                        }
                                    } 
                                    system.debug('ThisId '+ this.Id.size());
                                    //this.Id = RecIds;
                                    DocTemplateId = DocTemplateIds;
                                    Subject = Subjects;
                                    Body = Bodys;
                                    toUserEmailsList = toUserEmailsLists;
                                    toContactEmailsList = toContactEmailsLists;
                                    toEmails = toEmail;
                                    SaveAsActivity = SaveAsActivitys;
                                    EmailField = EmailFields;
                                    this.objectNames = objectName;
                                    StandardEmailTemplateSelectedValues = StandardEmailTemplateSelectedValue;
                                    JunoDocEmailTemplateSelectedValues = JunoDocEmailTemplateSelectedValue;  
                                    this.soqlquery = 'select id from '+ this.objectNames + ' where Id IN: Id';
                                    system.debug('objectNames '+ objectNames + ' Id'+  this.soqlquery);
                                }
    
    public DynamicListViewBatch(list<string> RecIds,string DocTemplateIds, string Subjects,string Bodys,
                                boolean SaveAsActivitys,string objectName,
                                string StandardEmailTemplateSelectedValue,
                                string JunoDocEmailTemplateSelectedValue,
                                string FromEmailAddress1, string SetReplyTo1, 
                                list<string> ToTextEmailsList1, list<string> ToEmailMergeFieldsList1,
                                list<string> CCTextEmailsList1, list<string> CCEmailMergeFieldsList1,
                                list<string> BCCTextEmailsList1, list<string> BCCEmailMergeFieldsList1                                
                               ) {
                                   this.Id = new list<string>();
                                   for(string str : RecIds){
                                       system.debug('str'+str);
                                       String[] Strlist = str.split(',');
                                       for(string strs : Strlist){
                                           this.Id.add(strs.trim().replace('[','').replace(']','').replace('"','').replace('"',''));     
                                       }
                                   } 
                                   system.debug('ThisId '+ this.Id.size());
                                   system.debug('ThisId '+ this.Id);
                                   //this.Id = RecIds;
                                   DocTemplateId = DocTemplateIds;
                                   Subject = Subjects;
                                   Body = Bodys;
                                   SaveAsActivity = SaveAsActivitys;
                                   this.objectNames = objectName;
                                   StandardEmailTemplateSelectedValues = StandardEmailTemplateSelectedValue;
                                   JunoDocEmailTemplateSelectedValues = JunoDocEmailTemplateSelectedValue;  
                                   ToTextEmailsList = ToTextEmailsList1;
                                   ToEmailMergeFieldsList = ToEmailMergeFieldsList1;
                                   CCTextEmailsList = CCTextEmailsList1;
                                   CCEmailMergeFieldsList = CCEmailMergeFieldsList1;
                                   BCCTextEmailsList = BCCTextEmailsList1;
                                   BCCEmailMergeFieldsList = BCCEmailMergeFieldsList1;     
                                   FromEmailAddress = FromEmailAddress1;
                                   SetReplyTo = SetReplyTo1;  
                                   system.debug('objectNames '+ objectNames + ' Id'+  Id);
                                   this.soqlquery = 'select id from '+ this.objectNames + ' where Id IN: Id';
                                   system.debug('objectNames '+ objectNames + ' Id'+  this.soqlquery);
                               }    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('thisId--->'+Id);
        system.debug('thisId--->'+Id[0]);
        system.debug('soqlquery--->'+soqlquery);
        String query = this.soqlquery;
        system.debug('query--->'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        map<string,string> storeEmailSubject = New map<string,string>();
        map<string,string> storeEmailBody = New map<string,string>();
        list<string> stroeListofString = New List<string>();
        list<Attachment> Attachmentlist = New list<Attachment>();
        map<id,list<string>> ToEmailAdressesMap = New map<id,list<string>>();
        map<id,list<string>> CCEmailAdressesMap = New map<id,list<string>>();
        map<id,list<string>> BCCEmailAdressesMap = New map<id,list<string>>();
        Map<Id,Sobject> recordMap;
        Map<Id,Blob> recordBlobMap = new Map<Id,Blob>();
        list<Attachment>  newAttachmentlist = New list<Attachment>();
        list<Task> TaskHistrylist = New list<Task>();
        List<Messaging.SingleEmailMessage> emailMessageslist = new List<Messaging.SingleEmailMessage>();
        for(Sobject scc :scope){
            string recId = ''+scc.get('Id'); 
            stroeListofString.add(recId);
            string emailSubject='';
            string emailBody=''; 
            string SubjectAndBody='';
            if(JunoDocEmailTemplateSelectedValues != '' && JunoDocEmailTemplateSelectedValues != null){
                SubjectAndBody = DynamicListview_AC.getBodyFromJunoDocEmailTemplate(recId,JunoDocEmailTemplateSelectedValues);
            }
            else if(StandardEmailTemplateSelectedValues != '' && StandardEmailTemplateSelectedValues != null){
                SubjectAndBody = DynamicListview_AC.getBodyFromEmailTemplate(recId,StandardEmailTemplateSelectedValues);
            }
            else{
                SubjectAndBody = Subject+'~'+body;
            }
            emailSubject = SubjectAndBody.split('~')[0];
            emailBody = SubjectAndBody.split('~')[1];     
            if(emailBody.length() >= 32000){
                emailBody = emailBody.substring(0,31800); 
            } 
            storeEmailBody.put(recId,emailBody);
            storeEmailSubject.put(recId,emailSubject);
        }
        
        // Body = emailBody;
        String sObjName = objectNames;
        string PDFName = 'Name';
        string query = '';
        if(sObjName == 'Product2'){
            query += 'Select id,Name';
        }
        else if(sObjName == 'Case'){
            query += 'Select id,CaseNumber'; 
            PDFName = 'CaseNumber';
        }
        else{
            query += 'Select id,Name';
        }
        if(ToEmailMergeFieldsList.size() > 0){
            for(string str : ToEmailMergeFieldsList){
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }
                query += ','+str;    
            }
        }
        if(CCEmailMergeFieldsList.size() > 0){
            for(string str : CCEmailMergeFieldsList){
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }           
                query += ','+str;
            }
        }
        
        if(BCCEmailMergeFieldsList.size() > 0){
            for(string str : BCCEmailMergeFieldsList){
                if(str.contains(sObjName+'.')){
                    str = str.replace(sObjName+'.','');
                }  
                query += ','+str;
            }
        }         
        
        query +=  ' From '+sObjName+' Where id IN:stroeListofString';
        system.debug(query);
        List<Sobject> sobjList = Database.query(query);   
        recordMap = new Map<Id,Sobject>(sobjList);
        system.debug(sobjList);
        string setReplyToEmail ='';
        if(!((SetReplyTo=='' || SetReplyTo==null) && sObjName != 'Product2')){
            setReplyToEmail = SetReplyTo;
        }
        string SenderDisplayName = '';
        List<Attachment> attlist  = New list<Attachment>();
        for(Sobject so :sobjList){
            list<string> ToEmailAdresses = DynamicListview_AC.getEmailRecipientsHelper(ToTextEmailsList, ToEmailMergeFieldsList,so);
            ToEmailAdressesMap.put(so.Id,ToEmailAdresses);
            list<string>  CCEmailAdresses = DynamicListview_AC.getEmailRecipientsHelper(CCTextEmailsList, CCEmailMergeFieldsList,so);
            CCEmailAdressesMap.put(so.Id,CCEmailAdresses);
            list<string> BCCEmailAdresses = DynamicListview_AC.getEmailRecipientsHelper(BCCTextEmailsList, BCCEmailMergeFieldsList,so);
            BCCEmailAdressesMap.put(so.Id,BCCEmailAdresses);
            Attachment a = new Attachment(); 
            Blob pdfPageBlob; 
            if(DocTemplateId != null && DocTemplateId != ''){
                PageReference pagePdf = new PageReference('/apex/JunoDoc__PreviewPDF'); 
                pagePdf.getParameters().put('id', so.id); 
                pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                if (Test.IsRunningTest()){
                    pdfPageBlob = Blob.valueOf('UNIT.TEST');
                }
                else{
                    pdfPageBlob = pagePdf.getContentAsPDF(); 
                }
                recordBlobMap.put(so.Id,pdfPageBlob);
                if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                   && Schema.sObjectType.Attachment.fields.Name.isCreateable() 
                   && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                       
                       a.Body = pdfPageBlob; 
                       a.ParentID = so.id; 
                       a.Name =  so.get(PDFName)+'.pdf';
                       a.ContentType = 'application/pdf';
                       attlist.add(a);
                   } 
            }
        }
        if(attlist.size()>0){
            insert attlist;
            system.debug('attlist-----------------------------'+attlist);
        }
        // map<id,Attachment> Attachmentmap = New map<id,Attachment>(attlist);
        map<id,Attachment> Attachmentmap = New map<id,Attachment>();
        for(Attachment attac:attlist ){
            Attachmentmap.put(attac.ParentId,attac);
        }
        list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
        if(FromEmailAddress!='' && FromEmailAddress!=null){
            owea = [select Id,Address from OrgWideEmailAddress where Id =:FromEmailAddress];          
        }  
        
        for(Sobject sob :sobjList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(setReplyToEmail != null && setReplyToEmail != ''){
                setReplyToEmail = setReplyToEmail;
                mail.setReplyTo(setReplyToEmail);
            }
            
            if ( owea.size() == 0 ) {
                mail.setSenderDisplayName(SenderDisplayName);
            }
            
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }        
            
            mail.setToAddresses(ToEmailAdressesMap.get(sob.id));
            if(CCEmailAdressesMap.containsKey(sob.id) && CCEmailAdressesMap.get(sob.id).size()>0){
                mail.setCcAddresses(CCEmailAdressesMap.get(sob.id));                
            }
            if(BCCEmailAdressesMap.containsKey(sob.id) && BCCEmailAdressesMap.get(sob.id).size()>0){
                mail.setBccAddresses(BCCEmailAdressesMap.get(sob.id));               
            }  
            
            mail.setSubject(storeEmailSubject.get(sob.id));
            mail.setHtmlBody(storeEmailBody.get(sob.Id));
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            if(DocTemplateId != null && DocTemplateId != ''){
                if (Schema.sObjectType.Attachment.fields.Name.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()
                    && Schema.sObjectType.Attachment.fields.BodyLength.isAccessible()){
                        for (Attachment at : [select Name,Body,BodyLength from Attachment where id =:Attachmentmap.get(sob.id).Id]) 
                            
                        {   
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                            efa.setFileName(at.Name); 
                            efa.setBody(at.body); 
                            fileAttachments.add(efa);
                        }
                    }
                 /*------------- Siddhu-------------*/                           
                                                    system.debug('DocTemplateId>>>>>>>>>>>>>>>>'+ DocTemplateId);
                                                    List<Doc_Template__c> DocTemplateRec1 = [SELECT Id, Name, Parent_Object__c, PDF_Name__c, JunoDoc__Related_Files__c,Date_Format__c, JunoDoc__Template_Type__c FROM Doc_Template__c WHERE Id = :DocTemplateId ];
                                                for (Doc_Template__c docTemplate : DocTemplateRec1) {
                                                     if (docTemplate.JunoDoc__Related_Files__c) {
                                                 List<ContentDocumentLink> docLinks = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = : docTemplate.Id];
                                              for (ContentDocumentLink docLink : docLinks) {
                                             List<ContentVersion> versions = [SELECT Title,ContentDocumentId, VersionData, FileType FROM ContentVersion WHERE ContentDocumentId = : docLink.ContentDocumentId];
                                                     for (ContentVersion version : versions) {
                                         Messaging.EmailFileAttachment docAttachment = new Messaging.EmailFileAttachment();
                                            docAttachment.setFileName(version.Title);
                                            docAttachment.setBody(version.VersionData);
                                            //docAttachment.setContentType('application/pdf');
                                            if (version.FileType == 'PDF') {
                                                docAttachment.setContentType('application/pdf');
                                            } else if (version.FileType == 'DOCX') {
                                                docAttachment.setContentType('application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                                            } else if (version.FileType == 'DOC') {
                                                docAttachment.setContentType('application/msword');
                                            } else {
                                                docAttachment.setContentType('application/octet-stream'); // Default type if unknown
                                            }
                                            fileAttachments.add(docAttachment);
                                      }
                                    }
                                   }
                                 }  
                
                
                mail.setFileAttachments(fileAttachments);
                
            }
            system.debug('fileAttachments>>>>>>>>>>>>>>>>>'+fileAttachments.size());
            emailMessageslist.add(mail);
            system.debug('mail------------------------'+mail);
        }
                 
        
        // List<Messaging.SendEmailResult> sendResults = NEW List<Messaging.SendEmailResult>();
        //if(!Test.isRunningTest())
        try{
        List<Messaging.SendEmailResult> sendResults = Messaging.sendEmail(emailMessageslist);
        for(Messaging.SendEmailResult result : sendResults) {
            if (result.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                System.debug('Error sending email: ' + result.getErrors()[0].getMessage());
            }
        }
        }
        catch(exception e){
            
        }
        
        
        if(SaveAsActivity){
            Set<Schema.SObjectType> objectsWithActivitiesEnabled = new Set<Schema.SObjectType>();
            String objectNames = '';
            boolean Activities = false;
            for (Schema.SObjectType objectType : Task.WhatId.getDescribe().getReferenceTo()) {
                if(sObjName.toLowerCase() == (''+objectType).toLowerCase()){
                    Activities = true;
                }
            }
            
            if(Activities == true)
                
                
                for(Sobject sobj :sobjList){
                    Task Taskhistory = new Task();
                    if(sObjName.toLowerCase()=='lead' || sObjName.toLowerCase()=='contact'){
                        Taskhistory.whoId =sobj.id;  
                    }else{
                        Taskhistory.whatId = sobj.id;
                    }
                    
                    Taskhistory.Status='Completed';
                    Taskhistory.Subject = Subject;
                    Taskhistory.To_Email_Addresses__c = ToEmailAdressesMap.get(sobj.id)+''; 
                    Taskhistory.ActivityDate = System.Today();
                    Taskhistory.Description =body;
                    TaskHistrylist.add(Taskhistory);
                }
            if(Schema.sObjectType.Task.fields.whoId.isCreateable() && 
               Schema.sObjectType.Task.fields.whatId.isCreateable() && Schema.sObjectType.Task.fields.Status.isCreateable()
               && Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.To_Email_Addresses__c.isCreateable()
               && Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.Description.isCreateable()){
                   if(TaskHistrylist.size()>0){
                   insert TaskHistrylist;
                   }
               }
            
            for(Task tak:TaskHistrylist){
                Attachment att = new Attachment();
                if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable()
                   && Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                   && Schema.sObjectType.Attachment.fields.Body.isCreateable() && DocTemplateId != null && DocTemplateId != ''){
                       
                       att.Body = recordBlobMap.get(tak.whatId); 
                       att.ParentID = tak.Id; 
                       att.Name = recordMap.get(tak.whatId).get(PDFName) + '.pdf';
                       att.ContentType = 'application/pdf';
                       newAttachmentlist.add(att);
                   }
            }
            if(newAttachmentlist.size()>0){
                insert newAttachmentlist;
            }
        }
        if(Attachment.sObjectType.getDescribe().isDeletable() && DocTemplateId != null && DocTemplateId != ''){
            delete[Select id From Attachment Where id=:Attachmentmap.keyset()];
        }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}
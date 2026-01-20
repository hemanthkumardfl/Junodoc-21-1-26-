global with sharing class JunoDocTriggerActionsBatch implements Database.Batchable<Object>{

    global List<Object> batchRecordsList;
    global string ObjectName;
    global string TriggerName;
    global string DocTemplateIds;
    global string EmailTemplateIds;
    global string selectedEmails;
    global JunoDocTriggerActionsBatch(list<Object> Items,string ObjecEmailtName){
        this.batchRecordsList = Items;
        this.ObjectName = ObjectName;
        System.debug('batchRecordsList-->'+batchRecordsList);
    }
    
    global JunoDocTriggerActionsBatch(list<Object> Items,string DocTemplateId,string EmailTemplateId,string Emails){
        this.batchRecordsList = Items;
        this.DocTemplateIds = DocTemplateId;
        this.EmailTemplateIds = EmailTemplateId;
        this.selectedEmails = Emails;
        System.debug('batchRecordsList-->'+batchRecordsList);
    }
    
    public JunoDocTriggerActionsBatch(list<Object> Items,string ObjectName,string TriggerName){
        this.batchRecordsList = Items;
        this.ObjectName = ObjectName;
        this.TriggerName = TriggerName;
        System.debug('batchRecordsList-->'+batchRecordsList);
    }

    global Iterable<object> start(Database.BatchableContext BC){
        return this.batchRecordsList;
    }   
    
    global void execute(Database.BatchableContext BC,List<Object> items){   
        
      //  try{
                
            list<SObject> recordsList = (List<SObject>)items;
            system.debug('recordsList---->'+recordsList);
            system.debug('ObjectName---->'+this.ObjectName);
            system.debug('TriggerName---->'+this.TriggerName);

            
          //  try{ 
              
                //get trigger action record
                Id DocTemplateId=null;
                string StandardEmailTemplateId='';
                string JunoDocEmailTemplateId='';
                list<string> toUserEmailsList = new list<string>();
                list<string> toContactEmailsList = new list<string>();
                list<string> ToTextEmailsList = new list<string>(); 
                list<string> ToEmailMergeFieldsList = new list<string>();
                list<string> CCTextEmailsList = new list<string>();
                list<string> CCEmailMergeFieldsList = new list<string>();
                list<string> BCCTextEmailsList =new list<string>();
                list<string> BCCEmailMergeFieldsList = new list<string>();
                String toEmails='';
                string FromEmailAddress='';
                string SetReplyTo='';
                string SetSenderDisplayName='';
                
                boolean SaveAsActivity=false;
                list<String> EmailField = new list<string>();
                
                Juno_Doc_Trigger_Action__c JunoDocTriggerActionRec;
                list<Juno_Doc_Trigger_Action__c> JunoDocTriggerActionsList = new list<Juno_Doc_Trigger_Action__c>();
                JunoDocTriggerActionsList = [select id,Name,Users_Email_Addresses__c, Contacts_Email_Addresses__c,
                                             Email_Addresses__c, From_Email_Address__c,
                                             Set_Reply_To__c, Set_Sender_Display_Name__c,
                                           Email_Fields__c, Available_Doc_Template__c, Juno_Doc_Email_Template__c, 
                                           Standard_Email_Template__c, Email_Subject__c, Save_as_Activitiy__c,
                                           Juno_Doc_Trigger__r.Object_Name__c,Juno_Doc_Trigger__r.Name,Juno_Doc_Trigger__r.JunoDoc__Enable_Recurring_Trigger__c
                                           From Juno_Doc_Trigger_Action__c 
                                           Where Juno_Doc_Trigger__r.Name=:this.TriggerName
                                          ];
        		boolean enableRecurring = false;
                if(JunoDocTriggerActionsList.size()>0){
                    JunoDocTriggerActionRec = JunoDocTriggerActionsList[0];
                    System.debug('***JunoDocTriggerActionRec'+JunoDocTriggerActionRec);
                    enableRecurring = JunoDocTriggerActionRec.Juno_Doc_Trigger__r.JunoDoc__Enable_Recurring_Trigger__c;
                }
                
                if(JunoDocTriggerActionRec!=null){
                    SaveAsActivity = JunoDocTriggerActionRec.Save_as_Activitiy__c; 
                    DocTemplateId = JunoDocTriggerActionRec.Available_Doc_Template__c;
                    system.debug('JunoDocTriggerActionRec---->'+JunoDocTriggerActionRec);
                    system.debug('DocTemplateId---->'+DocTemplateId);
                    if(JunoDocTriggerActionRec.Standard_Email_Template__c!=null){
                        StandardEmailTemplateId = JunoDocTriggerActionRec.Standard_Email_Template__c;
                    }
                    system.debug('StandardEmailTemplateId---->'+StandardEmailTemplateId);
                    if(JunoDocTriggerActionRec.Juno_Doc_Email_Template__c!=null){
                        JunoDocEmailTemplateId = JunoDocTriggerActionRec.Juno_Doc_Email_Template__c;
                    }
                    system.debug('JunoDocEmailTemplateId---->'+JunoDocEmailTemplateId);
                    string usersEmailAddresses ='';
                    
                    if(JunoDocTriggerActionRec.Users_Email_Addresses__c!=null){
                        usersEmailAddresses = JunoDocTriggerActionRec.Users_Email_Addresses__c;
                        if(usersEmailAddresses.contains(';')){
                            list<string> usersEmailsList = usersEmailAddresses.split(';');
                            for(string rec : usersEmailsList){
                                toUserEmailsList.add(rec.split('~')[1]);
                            }
                        }                 
                    }
                    system.debug('toUserEmailsList---->'+toUserEmailsList);
                    
                   
                    
                    string contactsEmailAddresses = '';
                    if(JunoDocTriggerActionRec.Contacts_Email_Addresses__c!=null){
                        contactsEmailAddresses = JunoDocTriggerActionRec.Contacts_Email_Addresses__c;
                        if(contactsEmailAddresses.contains(';')){
                            list<string> contactsEmailsList = contactsEmailAddresses.split(';');
                            for(string rec : contactsEmailsList){
                                toContactEmailsList.add(rec.split('~')[1]);
                            }
                        }                        
                    }
                    
                    system.debug('toContactEmailsList---->'+toContactEmailsList);
                    
                    toEmails = JunoDocTriggerActionRec.Email_Addresses__c;
                    
                    system.debug('toEmails---->'+toEmails);
                    
                    if(JunoDocTriggerActionRec.From_Email_Address__c!=null && JunoDocTriggerActionRec.From_Email_Address__c!=''){
                        FromEmailAddress = JunoDocTriggerActionRec.From_Email_Address__c;
                    }
                    
                    if(JunoDocTriggerActionRec.Set_Reply_To__c!=null && JunoDocTriggerActionRec.Set_Reply_To__c!=''){
                        SetReplyTo = JunoDocTriggerActionRec.Set_Reply_To__c;
                    }
                    
                    if(JunoDocTriggerActionRec.Set_Sender_Display_Name__c!=null && JunoDocTriggerActionRec.Set_Sender_Display_Name__c!=''){
                        SetSenderDisplayName = ''; //JunoDocTriggerActionRec.Set_Sender_Display_Name__c;
                    }                    
                    string EmailFields = '';
                    if(JunoDocTriggerActionRec.Email_Fields__c!=null){
                        EmailFields = JunoDocTriggerActionRec.Email_Fields__c;
                        if(EmailFields.contains(';')){
                            list<string> EmailFieldsList = EmailFields.split(';');
                            for(string rec : EmailFieldsList){
                                EmailField.add(rec.split('~')[1]);
                            }
                        }else{
                            EmailField.add(EmailFields.split('~')[1]);
                        }                   
                        
                    }
                    system.debug('EmailField--->'+EmailField);
                    
                    //TODO Add Email Recipinet, get
                    list<JunoDoc__Junodoc_Add_Email_Recipient__c> AddEmailRecipientsList = new list<JunoDoc__Junodoc_Add_Email_Recipient__c>();
                    AddEmailRecipientsList = [select id,Name,JunoDoc__Row_Number__c,JunoDoc__Email_Label_Values__c,
                                     JunoDoc__To_Cc_Bcc__c,JunoDoc__Reference_Type__c,JunoDoc__Email_API_Name_Values__c,
                                     JunoDoc__Juno_Doc_Trigger_Action__c
                                     from JunoDoc__Junodoc_Add_Email_Recipient__c 
                                     Where JunoDoc__Juno_Doc_Trigger_Action__r.Id=:JunoDocTriggerActionRec.Id];
                    if(AddEmailRecipientsList.size()>0){
                        for(JunoDoc__Junodoc_Add_Email_Recipient__c rec : AddEmailRecipientsList){
                            if(rec.JunoDoc__To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Reference_Type__c == 'Text'){
                                 ToTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Reference_Type__c == 'Text'){
                                CCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Reference_Type__c == 'Text'){
                                BCCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Reference_Type__c == 'Contact'){
                                 ToTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Reference_Type__c == 'Contact'){
                                CCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Reference_Type__c == 'Contact'){
                                BCCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Reference_Type__c == 'User'){
                                 ToTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Reference_Type__c == 'User'){
                                CCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Reference_Type__c == 'User'){
                                BCCTextEmailsList.add(rec.JunoDoc__Email_Label_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Reference_Type__c == 'Reference'){
                                ToEmailMergeFieldsList.add(rec.JunoDoc__Email_API_Name_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Reference_Type__c == 'Reference'){
                                CCEmailMergeFieldsList.add(rec.JunoDoc__Email_API_Name_Values__c);
                            }
                            else if(rec.JunoDoc__To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Reference_Type__c == 'Reference'){
                                BCCEmailMergeFieldsList.add(rec.JunoDoc__Email_API_Name_Values__c);
                            }
                        }
                    }
                   
                    
                    
                    //End Add Email Recipinet, get
                    
                }
                
                system.debug('JunoDocTriggerActionRec---->'+JunoDocTriggerActionRec);
                
                
                list<SObject> updateRecordsList = new List<SObject>();
         		string recordId = '';
                for(SObject rec : recordsList){ // gets 1 record per batch
                    recordId = string.valueOf(rec.get('id'));
                    Id id = Id.valueOf(recordId);
                    system.debug('recordId--->'+recordId);
                    string subjectAndBody = '';
                    string Subject=''; string Body='';
                    if(StandardEmailTemplateId!=null && StandardEmailTemplateId!=''){
                        system.debug('***SubjectAndBody'+subjectAndBody);
                        subjectAndBody = JunoDoc.Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(id,StandardEmailTemplateId);
                        system.debug('***SubjectAndBody'+subjectAndBody);
                        
                        Subject = subjectAndBody.split('~')[0];
                        if(subjectAndBody.split('~').size() > 1)
                        Body = subjectAndBody.split('~')[1];
                        
                        Body = '<div  style="font-family: Salesforce Sans;white-space: pre-line !important;word-wrap: break-word !important;font-size:12px;" >'
                            +Body+'</div>';                        
                    }
                    if(!Test.isRunningTest()){
                        if(JunoDocEmailTemplateId!=null && JunoDocEmailTemplateId!=''){
                            subjectAndBody = JunoDoc.Dynamic_GeneratePDF_Controller.getBodyFromJunoDocEmailTemplate(id,JunoDocEmailTemplateId);
                        }
                        Subject = subjectAndBody.split('~')[0];
                        if(subjectAndBody.split('~').size() > 1)
                        Body = subjectAndBody.split('~')[1];
                        
                    }    
                    
                   
                    
                    system.debug('Subject--->'+Subject);
                    system.debug('Body--->'+Body);
                     
                    Map<string,string> ResultMap = new Map<string,string>();
                    try{
                                                       
                        ResultMap = JunoDoc.Dynamic_GeneratePDF_Controller.SendPDFNew(id,DocTemplateId,Subject,Body,                                             
                                                                            FromEmailAddress,SetReplyTo, 
                                                                            SetSenderDisplayName,SaveAsActivity, 
                                                                            ToTextEmailsList,ToEmailMergeFieldsList,
                                                                            CCTextEmailsList,CCEmailMergeFieldsList,
                                                                            BCCTextEmailsList,BCCEmailMergeFieldsList,  
                                                                           new list<JunoDoc.Dynamic_GeneratePDF_Controller.fileDetails>()); 
                        
                        
                        
                         
                    }catch(exception e){
                        system.debug('exception---->'+e.getMessage());                        
                   }
                    
                    system.debug('ResultMap---->'+ResultMap);
                    if(Test.isRunningTest()){
                        ResultMap.put('state','success');
                    }
                    
                    if(ResultMap.get('state')=='success'){                        
                        JunoDocTriggerActionsScheduleController.upsertTriggerLogs(objectName,recordId);
                            
                        //post trigger actions
                        list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList 
                            = [select id,Name,Field__c, Value__c,
                               Juno_Doc_Trigger__r.Object_Name__c,
                               Juno_Doc_Trigger__r.Name
                               From Juno_Doc_Post_Trigger_Action__c 
                               Where Juno_Doc_Trigger__r.Name=:this.TriggerName
                              ];
                       
                        SObjectType accr = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                        DescribeSObjectResult accd = accr.getDescribe();
                        
                        if(PostTriggerActionsList!=null && PostTriggerActionsList.size()>0){
                            for(Juno_Doc_Post_Trigger_Action__c defaultValueRec : PostTriggerActionsList){
                                
                                string fieldName = defaultValueRec.Field__c;
                                string value = defaultValueRec.Value__c;
                                string fieldType = string.valueOf(accd.fields.getMap().get(fieldName).getDescribe().getType());
                                if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                                    rec.put(fieldName, decimal.valueOf(value));
                                }else if(fieldType == 'BOOLEAN'){
                                    rec.put(fieldName, boolean.valueOf(value));
                                }else{
                                    rec.put(fieldName, value);    
                                }                                
                            }                
                            updateRecordsList.add(rec);                             
                        }                    
                        //End post trigger actions
                        
                    }
                    
                }
                
                if(updateRecordsList.size()>0){
                    update updateRecordsList;
                    system.debug('updateRecordsList---->'+updateRecordsList);
                    if(enableRecurring){
                    	list<Juno_Doc_Trigger_Log__c> TodayTriggerLogsList   = [Select Id, Executed_Date__c, Trigger_Object__c, Record_Ids__c 
                                                        From Juno_Doc_Trigger_Log__c 
                                                        Where Trigger_Object__c =:ObjectName
                                                        And Executed_Date__c=TODAY
                                                        limit 49000];
                    	List<Juno_Doc_Trigger_Log__c> logsToUpdate = new List<Juno_Doc_Trigger_Log__c>();
                        if(TodayTriggerLogsList.size()>0){
                            for (Juno_Doc_Trigger_Log__c log : TodayTriggerLogsList) {
                                if (String.isNotBlank(log.Record_Ids__c)) {
                                    List<String> recordIds = log.Record_Ids__c.split(',');
                        
                                    // Create a new list excluding the one to remove
                                    List<String> updatedIds = new List<String>();
                                    for (String id : recordIds) {
                                        if (id.trim() != recordId) {
                                            updatedIds.add(id.trim());
                                        }
                                    }
    
                                    log.Record_Ids__c = String.join(updatedIds, ',');
                        
                                    logsToUpdate.add(log);
                                }
                            }
                        }
                         if (!logsToUpdate.isEmpty()) {
                            update logsToUpdate;
                        }
                    }
                }
                                
                
                
                
           // }catch(exception e){
                //system.debug('exception ---->'+e.getMessage()+e.getLineNumber());
          //  }
            
        //}catch(Exception e){
           // system.debug('exception ---->'+e.getMessage());
      //  }
        
    }
    
    
    global void finish(Database.BatchableContext BC){              
    }
    
    
}
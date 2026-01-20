global with sharing class JunoDocProcessBuilderBatch implements Database.Batchable<Object>{

    global List<Object> batchRecordsList;
    global string ObjectName;
    global string TriggerName;
    global string DocTemplateIds;
    global string EmailTemplateIds;
    global string selectedEmails;
    global string selectedEmailFields;
    
    global string BCCselectedEmails;
    global string BCCselectedEmailFields;
    
    global string CCselectedEmails;
    global string CCselectedEmailFields;
    global boolean SaveAsActivities;
    global string FromEmailAdd;
    global JunoDocProcessBuilderBatch(list<Object> Items,string ObjecEmailtName){
        this.batchRecordsList = Items;
        this.ObjectName = ObjecEmailtName;
        System.debug('batchRecordsList-->'+batchRecordsList);
    }
    
    global JunoDocProcessBuilderBatch(list<Object> Items,string ObjecEmailtName,string DocTemplateId,string EmailTemplateId,string Emails,string EmailFields){
       /* this.batchRecordsList = Items;
        this.DocTemplateIds = DocTemplateId;
        this.EmailTemplateIds = EmailTemplateId;
        this.selectedEmails = Emails;
        this.selectedEmailFields = EmailFields;
        //this.SaveAsActivities = SaveAsActivities;
        System.debug('batchRecordsList-->'+batchRecordsList);*/
    }
    
    global JunoDocProcessBuilderBatch(list<Object> Items,string ObjecEmailtName,string DocTemplateId,string EmailTemplateId,string Emails,string EmailFields,boolean SaveAsActivities){
       /* this.batchRecordsList = Items;
        this.DocTemplateIds = DocTemplateId;
        this.EmailTemplateIds = EmailTemplateId;
        this.selectedEmails = Emails;
        this.selectedEmailFields = EmailFields;
        this.SaveAsActivities = SaveAsActivities;
        System.debug('batchRecordsList-->'+batchRecordsList); */
    }
    
    
    global JunoDocProcessBuilderBatch(list<Object> Items,string ObjecEmailtName,string DocTemplateId,string EmailTemplateId,string Emails,string EmailFields,boolean SaveAsActivities,string FromEmailAddress){
       /* this.batchRecordsList = Items;
        this.DocTemplateIds = DocTemplateId;
        this.EmailTemplateIds = EmailTemplateId;
        this.selectedEmails = Emails;
        this.selectedEmailFields = EmailFields;
        this.SaveAsActivities = SaveAsActivities;
        this.FromEmailAdd = FromEmailAddress;
        System.debug('batchRecordsList-->'+batchRecordsList); */
    }
    
    global JunoDocProcessBuilderBatch(list<Object> Items,string ObjecEmailtName,string DocTemplateId,string EmailTemplateId,string Emails,string EmailFields,boolean SaveAsActivities,string FromEmailAddress,string BCCEmails,string BCCEmailFields,string CCEmails,string CCEmailFields){
        this.batchRecordsList = Items;
        this.DocTemplateIds = DocTemplateId;
        this.EmailTemplateIds = EmailTemplateId;
        this.selectedEmails = Emails;
        this.selectedEmailFields = EmailFields;
        
        this.BCCselectedEmails = BCCEmails;
        this.BCCselectedEmailFields = BCCEmailFields;
        
        this.CCselectedEmails = CCEmails;
        this.CCselectedEmailFields = CCEmailFields;
        
        this.SaveAsActivities = SaveAsActivities;
        this.FromEmailAdd = FromEmailAddress;
        System.debug('batchRecordsList-->'+batchRecordsList); 
    }
    

    global Iterable<object> start(Database.BatchableContext BC){
        return this.batchRecordsList;
    }   
    
    global void execute(Database.BatchableContext BC,List<Object> items){ 
      //  try{   
            list<SObject> recordsList = (List<SObject>)items;
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
                string FromEmailAddress= this.FromEmailAdd;
                string SetReplyTo='';
                string SetSenderDisplayName='';
                
                boolean SaveAsActivity=this.SaveAsActivities;
                list<String> EmailField = new list<string>();
                if(selectedEmails != null && selectedEmails != ''){
                    string[] selectedEmailslist = selectedEmails.split(';');
                    for(string sel : selectedEmailslist){
                         ToTextEmailsList.add(sel);
                    }
                }
        
                if(selectedEmailFields != null && selectedEmailFields != ''){
                    string[] selectedEmailFieldslist = selectedEmailFields.split(';');
                    for(string sel : selectedEmailFieldslist){
                         ToEmailMergeFieldsList.add(sel);
                    }
                }
        
                if(BCCselectedEmails != null && BCCselectedEmails != ''){
                    string[] BCCselectedEmailslist = BCCselectedEmails.split(';');
                    for(string sel : BCCselectedEmailslist){
                         BCCTextEmailsList.add(sel);
                    }
                }
        
                if(BCCselectedEmailFields != null && BCCselectedEmailFields != ''){
                    string[] BCCselectedEmailFieldslist = BCCselectedEmailFields.split(';');
                    for(string sel : BCCselectedEmailFieldslist){
                         BCCEmailMergeFieldsList.add(sel);
                    }
                }
        
                if(CCselectedEmails != null && CCselectedEmails != ''){
                    string[] CCselectedEmailslist = CCselectedEmails.split(';');
                    for(string sel : CCselectedEmailslist){
                         CCTextEmailsList.add(sel);
                    }
                }
        
                if(CCselectedEmailFields != null && CCselectedEmailFields != ''){
                    string[] CCselectedEmailFieldslist = CCselectedEmailFields.split(';');
                    for(string sel : CCselectedEmailFieldslist){
                         CCEmailMergeFieldsList.add(sel);
                    }
                }
        
                
               
                //ToEmailMergeFieldsList
                DocTemplateId = DocTemplateIds;
                JunoDocEmailTemplateId = EmailTemplateIds;
                string usersEmailAddresses ='';
                string contactsEmailAddresses = '';
                toEmails = '';        
                string EmailFields = '';
                   /* if(JunoDocTriggerActionRec.Email_Fields__c!=null){
                        EmailFields = JunoDocTriggerActionRec.Email_Fields__c;
                        if(EmailFields.contains(';')){
                            list<string> EmailFieldsList = EmailFields.split(';');
                            for(string rec : EmailFieldsList){
                                EmailField.add(rec.split('~')[1]);
                            }
                        }else{
                            EmailField.add(EmailFields.split('~')[1]);
                        }                   
                        
                    } */
                    system.debug('EmailField--->'+EmailField);
                    
                    //End Add Email Recipinet, get
                    
                
                
                
                list<SObject> updateRecordsList = new List<SObject>();
                for(SObject rec : recordsList){ // gets 1 record per batch
                    string recordId = string.valueOf(rec.get('id'));
                    Id id = Id.valueOf(recordId);
                    system.debug('recordId--->'+recordId);
                    string subjectAndBody = '';
                    string Subject=''; string Body='';
                    if(StandardEmailTemplateId!=null && StandardEmailTemplateId!=''){
                        system.debug('***SubjectAndBody'+subjectAndBody);
                        subjectAndBody = JunoDoc.Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(id,StandardEmailTemplateId);
                        system.debug('***SubjectAndBody'+subjectAndBody);
                        
                        Subject = subjectAndBody.split('~')[0];
                        Body = subjectAndBody.split('~')[1];
                        
                        Body = '<div  style="font-family: Salesforce Sans;white-space: pre-line !important;word-wrap: break-word !important;font-size:12px;" >'
                            +Body+'</div>';                        
                    }
                    if(!Test.isRunningTest()){
                        system.debug(JunoDocEmailTemplateId + '**** JunoDocEmailTemplateId');
                        if(JunoDocEmailTemplateId !=null && JunoDocEmailTemplateId!=''){
                            subjectAndBody = JunoDoc.Dynamic_GeneratePDF_Controller.getBodyFromJunoDocEmailTemplate(id,JunoDocEmailTemplateId);
                        }
                        system.debug('Subject--->'+subjectAndBody);
                        Subject = subjectAndBody.split('~')[0];
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
                    
               
                }  
    }
    global void finish(Database.BatchableContext BC){              
    }
    
    
}
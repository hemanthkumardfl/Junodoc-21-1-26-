global with sharing class JunoDocScheduleActionsBatch implements Database.Batchable<Object>{
    
    global List<Object> batchRecordsList;
    global string ObjectName;
    global string ScheduleName;
    public JunoDocScheduleActionsBatch(list<Object> Items,string ObjectName, String ScheduleName){
        this.batchRecordsList = Items;
        this.ObjectName = ObjectName;
        this.ScheduleName = ScheduleName;
        //System.debug('batchRecordsList-->'+batchRecordsList);
    }
    
    global Iterable<object> start(Database.BatchableContext BC){
        return this.batchRecordsList;
    }   
    
    global void execute(Database.BatchableContext BC,List<Object> items){   
        
        
        
        list<SObject> recordsList = (List<SObject>)items;
        //system.debug('recordsList---->'+recordsList);
        //system.debug('ObjectName---->'+this.ObjectName);
        
        boolean IsSendEmail = false;
        boolean IsAttachEmail = false;
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
        map<id,sobject> recs = new map<id,sobject>();
        boolean SaveAsActivity=false;
        list<String> EmailField = new list<string>();
        
        
        
        
        JunoDoc__Junodoc_Schedule_Action__c JunoDocScheduleActionRec;
        list<JunoDoc__Junodoc_Schedule_Action__c> JunoDocScheduleActionsList = new list<JunoDoc__Junodoc_Schedule_Action__c>();
        JunoDocScheduleActionsList = [select id,Name,JunoDoc__Junodoc_Users_Email_Addresses__c, JunoDoc__Junodoc_Contacts_Email_Addresses__c, JunoDoc__Junodoc_Email_Addresses__c,
                                      JunoDoc__Junodoc_Email_Fields__c, JunoDoc__Junodoc_Available_Doc_Template__c, JunoDoc__Junodoc_Doc_Email_Template__c, JunoDoc__Junodoc_Is_Attach__c, JunoDoc__Junodoc_Is_Send__c,
                                      JunoDoc__Junodoc_Standard_Email_Template__c, JunoDoc__Junodoc_Email_Subject__c, JunoDoc__Junodoc_Save_as_Activity__c,JunoDoc__Junodoc_From_Email_Address__c,JunoDoc__Junodoc_Set_Reply_To__c,JunoDoc__Junodoc_Set_Sender_Display_Name__c,
                                      JunoDoc__Junodoc_Schedule_Template_Setting__r.JunoDoc__Junodoc_Selected_Object__c
                                      From JunoDoc__Junodoc_Schedule_Action__c 
                                      Where JunoDoc__Junodoc_Schedule_Template_Setting__r.JunoDoc__Junodoc_Selected_Object__c=:this.ObjectName AND JunoDoc__Junodoc_Schedule_Template_Setting__r.Name =: this.ScheduleName
                                     ];
        if(JunoDocScheduleActionsList.size()>0){
            JunoDocScheduleActionRec = JunoDocScheduleActionsList[0];
            //System.debug('***JunoDocScheduleActionRec'+JunoDocScheduleActionRec);
            
        }
        
        if(JunoDocScheduleActionRec!=null){
            IsSendEmail = JunoDocScheduleActionRec.JunoDoc__Junodoc_Is_Send__c;
            IsAttachEmail = JunoDocScheduleActionRec.JunoDoc__Junodoc_Is_Attach__c;
            SaveAsActivity = JunoDocScheduleActionRec.JunoDoc__Junodoc_Save_as_Activity__c; 
            DocTemplateId = JunoDocScheduleActionRec.JunoDoc__Junodoc_Available_Doc_Template__c;
            //system.debug('JunoDocScheduleActionRec---->'+JunoDocScheduleActionRec);
            //system.debug('DocTemplateId---->'+DocTemplateId);
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Standard_Email_Template__c!=null){
                StandardEmailTemplateId = JunoDocScheduleActionRec.JunoDoc__Junodoc_Standard_Email_Template__c;
            }
            //system.debug('StandardEmailTemplateId---->'+StandardEmailTemplateId);
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Doc_Email_Template__c!=null){
                JunoDocEmailTemplateId = JunoDocScheduleActionRec.JunoDoc__Junodoc_Doc_Email_Template__c;
            }
            //system.debug('JunoDocEmailTemplateId---->'+JunoDocEmailTemplateId);
            string usersEmailAddresses ='';
            
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Users_Email_Addresses__c!=null){
                usersEmailAddresses = JunoDocScheduleActionRec.JunoDoc__Junodoc_Users_Email_Addresses__c;
                if(usersEmailAddresses.contains(';')){
                    list<string> usersEmailsList = usersEmailAddresses.split(';');
                    for(string rec : usersEmailsList){
                        toUserEmailsList.add(rec.split('~')[1]);
                    }
                }                 
            }
            //system.debug('toUserEmailsList---->'+toUserEmailsList);
            
            
            
            string contactsEmailAddresses = '';
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Contacts_Email_Addresses__c!=null){
                contactsEmailAddresses = JunoDocScheduleActionRec.JunoDoc__Junodoc_Contacts_Email_Addresses__c;
                if(contactsEmailAddresses.contains(';')){
                    list<string> contactsEmailsList = contactsEmailAddresses.split(';');
                    for(string rec : contactsEmailsList){
                        toContactEmailsList.add(rec.split('~')[1]);
                    }
                }                        
            }
            
            //system.debug('toContactEmailsList---->'+toContactEmailsList);
            
            toEmails = JunoDocScheduleActionRec.JunoDoc__Junodoc_Email_Addresses__c;
            
            //system.debug('toEmails---->'+toEmails);
            
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_From_Email_Address__c!=null && JunoDocScheduleActionRec.JunoDoc__Junodoc_From_Email_Address__c!=''){
                FromEmailAddress = JunoDocScheduleActionRec.JunoDoc__Junodoc_From_Email_Address__c;
            }
            
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Set_Reply_To__c!=null && JunoDocScheduleActionRec.JunoDoc__Junodoc_Set_Reply_To__c!=''){
                SetReplyTo = JunoDocScheduleActionRec.JunoDoc__Junodoc_Set_Reply_To__c;
            }
            
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Set_Sender_Display_Name__c!=null && JunoDocScheduleActionRec.JunoDoc__Junodoc_Set_Sender_Display_Name__c!=''){
                SetSenderDisplayName = ''; //JunoDocScheduleActionRec.Set_Sender_Display_Name__c;
            }                    
            string EmailFields = '';
            if(JunoDocScheduleActionRec.JunoDoc__Junodoc_Email_Fields__c!=null){
                EmailFields = JunoDocScheduleActionRec.JunoDoc__Junodoc_Email_Fields__c;
                if(EmailFields.contains(';')){
                    list<string> EmailFieldsList = EmailFields.split(';');
                    for(string rec : EmailFieldsList){
                        EmailField.add(rec.split('~')[1]);
                    }
                }else{
                    EmailField.add(EmailFields.split('~')[1]);
                }                   
                
            }
            //system.debug('EmailField--->'+EmailField);
            
            //TODO Add Email Recipinet, get
            list<JunoDoc__Junodoc_Add_Email_Recipient_For_Schedule__c> AddEmailRecipientsList = new list<JunoDoc__Junodoc_Add_Email_Recipient_For_Schedule__c>();
            AddEmailRecipientsList = [select id,Name,JunoDoc__Junodoc_Row_Number__c,JunoDoc__Junodoc_Email_Label_Values__c,
                                      JunoDoc__Junodoc_To_Cc_Bcc__c,JunoDoc__Junodoc_Reference_Type__c,JunoDoc__Junodoc_Email_API_Name_Values__c,
                                      JunoDoc__Junodoc_Schedule_Action__c
                                      from JunoDoc__Junodoc_Add_Email_Recipient_For_Schedule__c 
                                      Where JunoDoc__Junodoc_Schedule_Action__r.Id=:JunoDocScheduleActionRec.Id];
            //system.debug('AddEmailRecipientsList--->'+AddEmailRecipientsList);
            if(AddEmailRecipientsList.size()>0){
                for(JunoDoc__Junodoc_Add_Email_Recipient_For_Schedule__c rec : AddEmailRecipientsList){
                   
                    if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Text'){
                        ToTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Text'){
                        CCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Text'){
                        BCCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Contact'){
                        ToTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Contact'){
                        CCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Contact'){
                        BCCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Junodoc_Reference_Type__c == 'User'){
                        ToTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'User'){
                        CCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'User'){
                        BCCTextEmailsList.add(rec.JunoDoc__Junodoc_Email_Label_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'TO' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Reference'){
                        ToEmailMergeFieldsList.add(rec.JunoDoc__Junodoc_Email_API_Name_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'CC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Reference'){
                        CCEmailMergeFieldsList.add(rec.JunoDoc__Junodoc_Email_API_Name_Values__c);
                    }
                    else if(rec.JunoDoc__Junodoc_To_Cc_Bcc__c == 'BCC' && rec.JunoDoc__Junodoc_Reference_Type__c == 'Reference'){
                        BCCEmailMergeFieldsList.add(rec.JunoDoc__Junodoc_Email_API_Name_Values__c);
                    }
                }
            }
            
            
            
            //End Add Email Recipinet, get
            
        }
        
        //system.debug('JunoDocScheduleActionRec---->'+JunoDocScheduleActionRec);
        
        
        list<SObject> updateRecordsList = new List<SObject>();
        system.debug('recordsList--->'+recordsList);
        for(SObject rec : recordsList){ // gets 1 record per batch
            system.debug('rec--->'+rec);
            string recordId = string.valueOf(rec.get('id'));
            Id id = Id.valueOf(recordId);
            system.debug('recordId--->'+recordId);
            string subjectAndBody = '';
            string Subject=''; string Body='';
            if(StandardEmailTemplateId!=null && StandardEmailTemplateId!=''){
                //system.debug('***SubjectAndBody'+subjectAndBody);
                subjectAndBody = JunoDoc.Dynamic_GeneratePDF_Controller.getBodyFromEmailTemplate(id,StandardEmailTemplateId);
                //system.debug('***SubjectAndBody'+subjectAndBody);
                
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
            
            //system.debug('Subject--->'+Subject);
            //system.debug('Body--->'+Body);
            
            
            Map<string,string> ResultMap = new Map<string,string>();
            try{
                
                if(IsSendEmail == true){
                    if(IsAttachEmail == false){
                        ResultMap = JunoDoc.Dynamic_GeneratePDF_Controller.SendPDFNew(id,DocTemplateId,Subject,Body,                                             
                                                                                   FromEmailAddress,SetReplyTo, 
                                                                                   SetSenderDisplayName,SaveAsActivity, 
                                                                                   ToTextEmailsList,ToEmailMergeFieldsList,
                                                                                   CCTextEmailsList,CCEmailMergeFieldsList,
                                                                                   BCCTextEmailsList,BCCEmailMergeFieldsList,  
                                                                                   new list<JunoDoc.Dynamic_GeneratePDF_Controller.fileDetails>());
                        
                        
                    }
                    
                    if(IsAttachEmail == true ){
                        SaveAsActivity = false;
                        ResultMap = JunoDoc.Dynamic_GeneratePDF_Controller.SendPDFNew(id,DocTemplateId,Subject,Body,                                             
                                                                                   FromEmailAddress,SetReplyTo, 
                                                                                   SetSenderDisplayName,SaveAsActivity, 
                                                                                   ToTextEmailsList,ToEmailMergeFieldsList,
                                                                                   CCTextEmailsList,CCEmailMergeFieldsList,
                                                                                   BCCTextEmailsList,BCCEmailMergeFieldsList,  
                                                                                   new list<JunoDoc.Dynamic_GeneratePDF_Controller.fileDetails>());
                        String sObjName = id.getSObjectType().getDescribe().getName();
                        string query = 'Select id,Name,owner.Name,owner.Email';
                        
                        if(ToEmailMergeFieldsList.size() > 0){
                            for(string str : ToEmailMergeFieldsList){
                                //system.debug('To Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;    
                                }                       
                            }
                        }
                        if(CCEmailMergeFieldsList.size() > 0){
                            for(string str : CCEmailMergeFieldsList){
                                //system.debug('CC Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }   
                                
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;
                                }
                            }
                        }
                        
                        if(BCCEmailMergeFieldsList.size() > 0){
                            for(string str : BCCEmailMergeFieldsList){
                                //system.debug('BCC Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }  
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;
                                }
                            }
                        }
                        //system.debug('query--->'+query);
                        query +=  ' From '+sObjName+' Where id=:id';
                        Sobject sobjList = Database.query(String.escapeSingleQuotes(query));
                        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c,PDF_Name__c
                                                                  from Doc_Template__c 
                                                                  where Parent_Object__c =: sObjName AND id=:DocTemplateId limit 1];
                        String vfpage = '';   
                        PageReference pagePdf;
                        if(availableDocList.size()>0){
                            if(availableDocList[0].PDF_Name__c!='' && availableDocList[0].PDF_Name__c!= null){
                                vfpage = availableDocList[0].PDF_Name__c;
                                pagePdf = new PageReference('/'+Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/'+vfpage+'?id='+id); 
                            }else{
                                pagePdf = new PageReference('/'+Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/DocTemplatePDF_VF'); 
                                pagePdf.getParameters().put('id', id); 
                                pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                            }
                        }
                        
                        Blob pdfPageBlob; 
                        if(Test.IsRunningTest()){
                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                        }
                        else{
                            pdfPageBlob = pagePdf.getContentAsPDF(); 
                        }
                        
                        //system.debug('sobjList ---->'+sobjList);
                        
                        Attachment a = new Attachment(); 
                        if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                           && Schema.sObjectType.Attachment.fields.Name.isCreateable() 
                           && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                               a.Body = pdfPageBlob; 
                               a.ParentID = id; 
                               //system.debug('pdf name ---->'+sobjList.get('Name'));
                               a.Name =  sobjList.get('Name')+ '.pdf';
                               a.ContentType = 'application/pdf';
                               insert a; 
                               
                           }
                        ResultMap.put('state','success');
                        ResultMap.put('Message','Attachment attached Successfully. You will be redirected to record page');
                    }
                }
                else{
                     if(IsAttachEmail == true ){
                        String sObjName = id.getSObjectType().getDescribe().getName();
                        string query = 'Select id,Name,owner.Name,owner.Email';
                        
                        if(ToEmailMergeFieldsList.size() > 0){
                            for(string str : ToEmailMergeFieldsList){
                                //system.debug('To Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;    
                                }                       
                            }
                        }
                        if(CCEmailMergeFieldsList.size() > 0){
                            for(string str : CCEmailMergeFieldsList){
                                //system.debug('CC Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }   
                                
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;
                                }
                            }
                        }
                        
                        if(BCCEmailMergeFieldsList.size() > 0){
                            for(string str : BCCEmailMergeFieldsList){
                                //system.debug('BCC Email--->'+str);
                                if(str.contains(sObjName+'.')){
                                    str = str.replace(sObjName+'.','');
                                }  
                                if(str.toLowerCase()!='owner.email'){
                                    query += ','+str;
                                }
                            }
                        }
                        //system.debug('query--->'+query);
                        query +=  ' From '+sObjName+' Where id=:id';
                        Sobject sobjList = Database.query(String.escapeSingleQuotes(query));
                        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c,PDF_Name__c
                                                                  from Doc_Template__c 
                                                                  where Parent_Object__c =: sObjName AND id=:DocTemplateId limit 1];
                        String vfpage = '';   
                        PageReference pagePdf;
                        if(availableDocList.size()>0){
                            if(availableDocList[0].PDF_Name__c!='' && availableDocList[0].PDF_Name__c!= null){
                                vfpage = availableDocList[0].PDF_Name__c;
                                pagePdf = new PageReference('/'+Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/'+vfpage+'?id='+id); 
                            }else{
                                pagePdf = new PageReference('/'+Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/DocTemplatePDF_VF'); 
                                pagePdf.getParameters().put('id', id); 
                                pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                            }
                        }
                        
                        Blob pdfPageBlob; 
                        if(Test.IsRunningTest()){
                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                        }
                        else{
                            pdfPageBlob = pagePdf.getContentAsPDF(); 
                        }
                        
                        //system.debug('sobjList ---->'+sobjList);
                        
                        Attachment a = new Attachment(); 
                        if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                           && Schema.sObjectType.Attachment.fields.Name.isCreateable() 
                           && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                               a.Body = pdfPageBlob; 
                               a.ParentID = id; 
                               //system.debug('pdf name ---->'+sobjList.get('Name'));
                               a.Name =  sobjList.get('Name')+ '.pdf';
                               a.ContentType = 'application/pdf';
                               insert a; 
                               
                           }
                        ResultMap.put('state','success');
                        ResultMap.put('Message','Attachment attached Successfully. You will be redirected to record page');
                    }
                }
                
            }catch(exception e){
                system.debug('exception---->'+e.getMessage());
            }
            
            
            
            
            //system.debug('ResultMap---->'+ResultMap);
            
            if(ResultMap.get('state')=='success'){
                //JunoDocScheduleActionsScheduleController.upsertScheduleLogs(objectName,recordId);
                
                //post trigger actions
                list<JunoDoc__Junodoc_Post_Schedule_Action__c> PostScheduleActionsList 
                    = [select id,Name,JunoDoc__Junodoc_Field__c, JunoDoc__Junodoc_Value__c,
                       JunoDoc__Junodoc_Schedule_Template_Setting__r.JunoDoc__Junodoc_Selected_Object__c, JunoDoc__Junodoc_Schedule_Template_Setting__r.Name
                       From JunoDoc__Junodoc_Post_Schedule_Action__c 
                       Where JunoDoc__Junodoc_Schedule_Template_Setting__r.JunoDoc__Junodoc_Selected_Object__c=:ObjectName AND JunoDoc__Junodoc_Schedule_Template_Setting__r.Name =:ScheduleName 
                      ];
                SObjectType accr = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                DescribeSObjectResult accd = accr.getDescribe();
                
                if(PostScheduleActionsList!=null && PostScheduleActionsList.size()>0){
                    for(JunoDoc__Junodoc_Post_Schedule_Action__c defaultValueRec : PostScheduleActionsList){
                        string fieldName = defaultValueRec.JunoDoc__Junodoc_Field__c;
                        //system.debug('fieldName----->'+fieldName);
                        string value = defaultValueRec.JunoDoc__Junodoc_Value__c;
                        //system.debug('value----->'+value);
                        string fieldType = string.valueOf(accd.fields.getMap().get(fieldName).getDescribe().getType());
                        if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                            rec.put(fieldName, decimal.valueOf(value));
                            //system.debug('rec----->'+rec);
                        }else if(fieldType == 'BOOLEAN'){
                            rec.put(fieldName, boolean.valueOf(value));
                            //system.debug('rec----->'+rec);
                        }else if(fieldType == 'DATE' || fieldType == 'DATETIME'){
                            //system.debug('value----->'+value);
                            if(value.toLowerCase() == 'today'){
                                //system.debug('inn-1');
                                rec.put(fieldName,System.today());
                                system.debug(rec);
                            }
                            else if(value.toLowerCase() == 'tomorrow'){
                                // system.debug('inn-2');
                                rec.put(fieldName,System.today().addDays(1));
                            }
                            else if(value.toLowerCase() == 'yesterday'){
                                //system.debug('inn-3');
                                rec.put(fieldName,System.today().addDays(-1));
                            }
                            else if(value.toLowerCase() == 'now'){
                                //system.debug('inn-3');
                                rec.put(fieldName,System.now());
                            }
                            else{
                                date dateformat = date.parse(value);
                                //system.debug('dateformat----->'+dateformat);
                                string year = dateformat.year()+'';
                                string month = '';
                                if(dateformat.month()<10){ month = '0'+dateformat.month()+'';}
                                else{ month = dateformat.month()+''; }
                                //system.debug('year----->'+year);
                                //system.debug('month----->'+month);
                                string day = '';
                                if(dateformat.day()<10){ day = '0'+dateformat.day()+'';  }
                                else{ day = dateformat.day()+''; }
                                //system.debug('day----->'+day);
                                value = year +'-' + month + '-' +day;
                                //system.debug('value----->'+value);
                                rec.put(fieldName, date.valueOf(value));
                                //system.debug('rec----->'+rec);
                            }
                        }else{
                            rec.put(fieldName, value);
                            //system.debug('rec----->'+rec);
                        }            
                        //rec.put(defaultValueRec.JunoDoc__Junodoc_Field__c, defaultValueRec.JunoDoc__Junodoc_Value__c);
                        system.debug('rec487----->'+rec);
                        system.debug('updateRecordsList488----->'+updateRecordsList);
                        
                    }   
                    updateRecordsList.add(rec);
                }                    
                //End post trigger actions
                
            }
            
        }
        system.debug('updateRecordsList488----->'+updateRecordsList);
        if(updateRecordsList.size()>0){
            update updateRecordsList;
            //system.debug('updateRecordsList---->'+updateRecordsList);
        }
        
    }
    
    
    global void finish(Database.BatchableContext BC){
        
        
    }
    
    
}
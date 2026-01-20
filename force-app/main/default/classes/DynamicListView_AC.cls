global class DynamicListView_AC {
    global static ApexPages.StandardSetController setRFQ;
    global set<id> RecIds{get;set;}
    global string sObjName{get;set;}
    global set<id> RecordIds{get;set;}
    global string ObjectName{get;set;}
    global string recId{get;set;}
    global string batchId{get;set;}
    global string postActionWrapper{get;set;}
    global string TemplateId{get;set;}
    global boolean Isvisual{get;set;}
    global DynamicListView_AC(ApexPages.StandardSetController controller){
        setRFQ = controller;
        RecIds = new set<id>();
        for(Integer i=0;i<setRFQ.getSelected().size();i++){
            RecIds.add(setRFQ.getSelected()[i].id); 
            ObjectName = setRFQ.getSelected()[i].getSObjectType().getDescribe().getName();
        }
    }
     global DynamicListView_AC(){
         System.debug('recId ');
         ObjectName = Apexpages.currentPage().getparameters().get('objectName'); 
         recId = Apexpages.currentPage().getparameters().get('records'); 
         batchId = Apexpages.currentPage().getparameters().get('batchId'); 
         Isvisual = false;
         if(Apexpages.currentPage().getparameters().get('visualpage') != null){
             Isvisual = boolean.valueOf(Apexpages.currentPage().getparameters().get('visualpage'));
         }
         /*postActionWrapper = Apexpages.currentPage().getparameters().get('postActionWrapper'); 
         TemplateId = Apexpages.currentPage().getparameters().get('TemplateId');*/
         System.debug('recId '+recId);
         
     }

    @AuraEnabled
    global static InnerDocTemplates getAvailableDocTemplates(string sObjName){
      
        //String sObjName = recordId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Doc_Template__c 
                                                  where Parent_Object__c =: sObjName];
        if(availableDocList.size()>0){
            for(Doc_Template__c rec : availableDocList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                AvailableDocTemplatesList.add(obj);
            }            
        }
        
         list<DocTemplatesWrap> orgWideEmailsList = new list<DocTemplatesWrap>();
        list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address from OrgWideEmailAddress Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Address;
                obj.value = rec.id; 
                orgWideEmailsList.add(obj); 
            }
        }    
        
        InnerDocTemplates inn = new InnerDocTemplates();
        inn.AvailableDocTemplatesList = AvailableDocTemplatesList;
        inn.DocTemplateId = TemplateID;
        inn.OrgwideEmailAddressList = orgWideEmailsList;
       /* if(batchId!='' && batchId!=null){
            list<Junodoc_Batch_Settings__c> JunosettingsList = [select id,
                                                      Doc_Template__c,Junodoc_Batch__c,
                                                      Doc_Template__r.parent_Object__c,
                                                      SOQL_Query__c,
                                                      Report_ID__c
                                                      from Junodoc_Batch_Settings__c
                                                      where Junodoc_Batch__c =: batchId order by CreatedDate desc limit 1];
            if(JunosettingsList.size()>0){
                list<Junodoc_Post_Trigger_Actions__c> TriggerActions = [select id,Field_Name__c,Row_Number__c,Value__c,Junodoc_Batch_Settings__c
                                                                        from Junodoc_Post_Trigger_Actions__c 
                                                                        where Junodoc_Batch_Settings__c=:JunosettingsList[0].Id];
                list<PostActionWrapper> PostActionWrapperList = new list<PostActionWrapper>();
                for(Junodoc_Post_Trigger_Actions__c action:TriggerActions){
                    PostActionWrapper wrapper = new PostActionWrapper();
                    wrapper.Field = action.Field_Name__c;
                    wrapper.Value = action.Value__c;
                    wrapper.RowNumber = Integer.valueOf(action.Row_Number__c);
                    PostActionWrapperList.add(wrapper);
                }
                inn.batchSettingsRecord = JunosettingsList[0];
                inn.PostActionWrapperList = PostActionWrapperList;
            }
           
        }*/
        
        
        return inn;        
    }
     @AuraEnabled
    global static string SendPDFBatch(list<string> ids,string DocTemplateId, string Subject,string Body, 
                                 boolean SaveAsActivity,string objectName,
                                 string StandardEmailTemplateSelectedValue,
                                 string JunoDocEmailTemplateSelectedValue,
                                 string FromEmailAddress, string SetReplyTo,
                                 list<string> ToTextEmailsList,list<string> ToEmailMergeFieldsList,
                                 list<string> CCTextEmailsList,list<string> CCEmailMergeFieldsList,
                                 list<string> BCCTextEmailsList,list<string> BCCEmailMergeFieldsList
                                ){  
                                    system.debug('ids---->'+ids);
                                    system.debug('DocTemplateId---->'+DocTemplateId);
                                    system.debug('Subject---->'+Subject);
                                    system.debug('SaveAsActivity---->'+SaveAsActivity);
                                    system.debug('objectName---->'+objectName);
                                    system.debug('StandardEmailTemplateSelectedValue---->'+StandardEmailTemplateSelectedValue);
                                    system.debug('JunoDocEmailTemplateSelectedValue---->'+JunoDocEmailTemplateSelectedValue);
                                    system.debug('FromEmailAddress---->'+FromEmailAddress);
                                    system.debug('ToTextEmailsList---->'+ToTextEmailsList);
                                    system.debug('ToEmailMergeFieldsList---->'+ToEmailMergeFieldsList);
                                    system.debug('CCTextEmailsList---->'+CCTextEmailsList);
                                    system.debug('CCEmailMergeFieldsList---->'+CCEmailMergeFieldsList);
                                    system.debug('BCCTextEmailsList---->'+BCCTextEmailsList);
                                    system.debug('BCCEmailMergeFieldsList---->'+BCCEmailMergeFieldsList);
                                    
        DynamicListViewBatch shn = new DynamicListViewBatch(ids,DocTemplateId,Subject,Body,
                                                            SaveAsActivity,objectName,
                                                            StandardEmailTemplateSelectedValue,
                                                            JunoDocEmailTemplateSelectedValue, FromEmailAddress,SetReplyTo, 
                                                             ToTextEmailsList,ToEmailMergeFieldsList,
                                                             CCTextEmailsList,CCEmailMergeFieldsList,
                                                             BCCTextEmailsList,BCCEmailMergeFieldsList
                                                           ); 
                                    
        database.executeBatch(shn,10); 
                                    
    
        return null;
        
    }
    global static List<string> getEmailRecipientsHelper(list<string> ToTextEmailsList, list<string> ToEmailMergeFieldsList,Sobject sobjList){
        List<string> ToAdresses = new List<string>();
        list<string> ToEmailAdresses = new list<string>();
        
        try{
            
            if(ToTextEmailsList!=null){
                for(String str:ToTextEmailsList){
                    if(str != null && str != ''){
                        ToAdresses.add(str); 
                    }
                }                                                     
            }
            
            if(ToEmailMergeFieldsList.size() > 0){
                for(string toEmailField : ToEmailMergeFieldsList){
                    system.debug('toEmailField--->'+toEmailField);
                    List<String> toEmailFieldSplit = toEmailField.split('\\.'); 
                    system.debug('toEmailFieldSplit--->'+toEmailFieldSplit);
                    system.debug('toEmailFieldSplit size --->'+toEmailFieldSplit.size());
                    string ReleationField = '';
                    if(toEmailFieldSplit.size()==5){
                        if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                            if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2])!=null){
                                if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3])!=null){
                                    if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3]).get(toEmailFieldSplit[4])!=null){
                                        string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3]).get(toEmailFieldSplit[4]));
                                        system.debug('level5---->'+email);
                                        ToAdresses.add(email);
                                    }                                    
                                }
                            }
                        } 
                    }else if(toEmailFieldSplit.size()==4){ //Quote.Account.Owner.Email
                        if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                            if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2])!=null){
                                if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).get(toEmailFieldSplit[3])!=null){
                                    string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).get(toEmailFieldSplit[3]));
                                    system.debug('level4---->'+email);
                                    ToAdresses.add(email);
                                }                                                              
                            } 
                        }
                    }else if(toEmailFieldSplit.size()==3){ //Quote.Contact.Email
                        if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                            if(sobjList.getSobject(toEmailFieldSplit[1]).get(toEmailFieldSplit[2])!=null){
                                string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).get(toEmailFieldSplit[2]));
                                system.debug('level3---->'+email);
                                ToAdresses.add(email);                            
                            }                            
                        }
                    }else if(toEmailFieldSplit.size()==2){ //Quote.Email
                        if(sobjList.get(toEmailFieldSplit[1])!=null){
                            string email = String.valueOf(sobjList.get(toEmailFieldSplit[1]));
                            system.debug('level2---->'+email);
                            ToAdresses.add(email);                            
                        }                        
                    }                    
                }
            }
            
            
            //remove duplicate email ids
            map<string,string> toEmailmap = new map<string,string>();
            for(string toEmailAddress: ToAdresses) {
                toEmailmap.put(toEmailAddress,toEmailAddress);
            }            
            for(string toEmail : toEmailmap.keySet()){
                ToEmailAdresses.add(toEmail);
            }
            //End remove duplicate email ids
            
        }catch(Exception e){
            system.debug('exception--->'+e.getMessage()+'---line number--->'+e.getLineNumber());
        }       
        
        return ToEmailAdresses;
      }
    
    @AuraEnabled
    global static list<DocTemplatesWrap> getAvailableEmails(string sObjName){
      
        //String sObjName = recordId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjName).getDescribe().fields.getMap();
       
        list<DocTemplatesWrap> DocTemplatesWraplist = new list<DocTemplatesWrap>();
        for(string dfield:fieldMap.keyset()){      
              if(fieldMap.get(dfield).getDescribe().getType()+'' == 'Email'){
                DocTemplatesWrap DocTemplatesWraprec = new DocTemplatesWrap();
                DocTemplatesWraprec.label = fieldMap.get(dfield).getDescribe().getLabel();
                DocTemplatesWraprec.value = fieldMap.get(dfield).getDescribe().getName();
                DocTemplatesWraplist.add(DocTemplatesWraprec);
              }
        }   
        return DocTemplatesWraplist; 
    } 
    
    global class InnerDocTemplates{
        @AuraEnabled
        global list<DocTemplatesWrap> AvailableDocTemplatesList;
        @AuraEnabled
        global string DocTemplateId;
        @AuraEnabled
        global Junodoc_Batch_Settings__c batchSettingsRecord;
         @AuraEnabled
        public list<DocTemplatesWrap> OrgwideEmailAddressList;  
        @AuraEnabled
        global list<PostActionWrapper> PostActionWrapperList;
    }  
    
    global class PostActionWrapper{
        @AuraEnabled global Integer RowNumber;
        @AuraEnabled global String Field;
        @AuraEnabled global String Value;
    } 
    global class DocTemplatesWrap{
        @AuraEnabled
        global String label;
        @AuraEnabled
        global String value;    
    }    
    
    
    
    @AuraEnabled
    global static string SendPDF(list<string> ids,string DocTemplateId, string Subject,string Body, 
                                             list<string> toUserEmailsList,
                                             list<string> toContactEmailsList,String toEmails,
                                            boolean SaveAsActivity,list<String> EmailField,string objectName,
                                            string StandardEmailTemplateSelectedValue,
                                            string JunoDocEmailTemplateSelectedValue){  
        system.debug('SaveAsActivity--->');
        DynamicListViewBatch shn = new DynamicListViewBatch(ids,DocTemplateId,Subject,Body,
                                             toUserEmailsList,
                                             toContactEmailsList,toEmails,
                                            SaveAsActivity,EmailField,objectName,
                                            StandardEmailTemplateSelectedValue,
                                            JunoDocEmailTemplateSelectedValue); 
        database.executeBatch(shn,1);
        return null;
        
    }
    
    
  /*  @AuraEnabled
    global static InnerEmailTemplates getEmailTemplates(string sObjName) { 
        
    //    String sObjName = id.getSObjectType().getDescribe().getName();
        sObjName = sObjName.toUpperCase();
        
        list<EmailTemplateWrap> StandardEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<EmailTemplate> eTempList = [SELECT Id,Name,Body,Subject 
                                         From EmailTemplate 
                                         Where IsActive = true
                                         Order By Name
                                         Limit 5000];
        if(!Test.isRunningTest()){
            for(EmailTemplate rec:eTempList){            
                string body = rec.Body;
                string Subject = rec.Subject;
                
                if(body !=null && Subject !=null)
                {
                    if(Subject.toUpperCase().contains(sObjName) || body.toUpperCase().contains(sObjName) 
                       || Subject.toUpperCase().contains('{!'+sObjName+'.') || body.toUpperCase().contains('{!'+sObjName+'.')){
                        EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
                        objSettings.label=rec.Name;
                        objSettings.value=rec.Id;
                        StandardEmailTemplatesList.add(objSettings);                        
                    }                
                }            
            }  
        }
        
        
        list<EmailTemplateWrap> JunoDocEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<Email_Template__c> JunoDocETempList = [SELECT Id,Name
                                         From Email_Template__c 
                                         Where Parent_Object__c =:sObjName
                                         Order By Name
                                         Limit 5000];
        for(Email_Template__c rec:JunoDocETempList){            
            EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
            objSettings.label=rec.Name;
            objSettings.value=rec.Id;
            JunoDocEmailTemplatesList.add(objSettings);                        
        }  
                
        
        InnerEmailTemplates Inn = new InnerEmailTemplates();
        Inn.StandardEmailTemplatesList = StandardEmailTemplatesList;
        Inn.JunoDocEmailTemplatesList = JunoDocEmailTemplatesList;
                
        return Inn;
    }    
    */
      @AuraEnabled
    global static InnerEmailTemplates getEmailTemplates(string sObjName) { 
        
        /*String sObjName = id.getSObjectType().getDescribe().getName();*/
        sObjName = sObjName.toUpperCase();
        
        list<EmailTemplateWrap> StandardEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<EmailTemplate> eTempList = [SELECT Id,Name,Body,Subject 
                                         From EmailTemplate 
                                         Where IsActive = true
                                         Order By Name
                                         Limit 5000];
        //if(!Test.isRunningTest()){
            for(EmailTemplate rec:eTempList){            
                string body = rec.Body;
                string Subject = rec.Subject;
                
                if(body !=null && Subject !=null)
                {
                    if(Subject.toUpperCase().contains(sObjName) || body.toUpperCase().contains(sObjName) 
                       || Subject.toUpperCase().contains('{!'+sObjName+'.') || body.toUpperCase().contains('{!'+sObjName+'.')){
                        EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
                        objSettings.label=rec.Name;
                        objSettings.value=rec.Id;
                        StandardEmailTemplatesList.add(objSettings);                        
                    }                
                }            
            }  
        //}
        
        
        list<EmailTemplateWrap> JunoDocEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<Email_Template__c> JunoDocETempList = [SELECT Id,Name
                                         From Email_Template__c 
                                         Where Parent_Object__c =:sObjName
                                         Order By Name
                                         Limit 5000];
        for(Email_Template__c rec:JunoDocETempList){            
            EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
            objSettings.label=rec.Name;
            objSettings.value=rec.Id;
            JunoDocEmailTemplatesList.add(objSettings);                        
        }  
                
        
        InnerEmailTemplates Inn = new InnerEmailTemplates();
        Inn.StandardEmailTemplatesList = StandardEmailTemplatesList;
        Inn.JunoDocEmailTemplatesList = JunoDocEmailTemplatesList;
                
        return Inn;
    }   
  
      
    
    global class InnerEmailTemplates{
        @AuraEnabled
        global list<EmailTemplateWrap> StandardEmailTemplatesList;
        @AuraEnabled
        global list<EmailTemplateWrap> JunoDocEmailTemplatesList;        
    }
    
    global class EmailTemplateWrap{
        @AuraEnabled
        global String label;
        @AuraEnabled
        global String value;    
    }
    
    
    @AuraEnabled
     global static String getBodyFromEmailTemplate(id recordId, 
                                                  /*list<string> toUserEmailsList,
                                                  list<string> toContactEmailsList,String toEmails,*/
                                                  string EmailTemplateId) 
    { 
        
        String CaseEmailAddress=''; 
        String plainTextBody='';
        String Subject='';
        
        if(EmailTemplateId !='' && EmailTemplateId != null)
        {                        
                     
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            
            
            EmailTemplate eTempRec = [SELECT Id,Name,Body,Subject 
                                             From EmailTemplate 
                                             Where Id=:EmailTemplateId];
            if(eTempRec!=null){
                Subject = eTempRec.Subject;     
            }            
            
            string TargetObjectId = '';
                        
            Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
            system.debug('objectFields--->'+objectFieldsMap); 
            
            
            string query = 'Select id,Name,OwnerId,owner.Name,owner.Email  From '+sObjName+' Where id=:recordId';
            
            if(objectFieldsMap.get('ContactId')!=null){
                query = 'Select id,Name,OwnerId,owner.Name,owner.Email,ContactId From '+sObjName+' Where id=:recordId';
            }
            Sobject sobjList = Database.query(query);    
            
            
            
            string setReplyToEmail = sobjList.getsobject('owner').get('Email')+'';
            string SenderDisplayName = sobjList.getsobject('owner').get('Name')+'';
            if(objectFieldsMap.get('ContactId')!=null){
                TargetObjectId = sobjList.get('ContactId')+'';
            }            
            
            List<string> ToAdresses = new List<string>();
            /*List<string> ToAdresses = new List<string>();
            if(toEmails != null && toEmails != ''){
                if(toEmails.contains(',')){
                    ToAdresses = toEmails.split(',');                                                    
                }else{
                    ToAdresses.add(toEmails);
                }
            }
            
            if(toUserEmailsList!=null){
                for(String str:toUserEmailsList){
                    if(str != null && str != ''){
                        ToAdresses.add(str); 
                    }
                    
                }                                                     
            }
            
            if(toContactEmailsList!=null){
                for(String str:toContactEmailsList){
                    if(str != null && str != ''){
                        ToAdresses.add(str); 
                    }
                }                
            }           */                                               
            
            Savepoint sp = Database.setSavepoint();
            system.debug('TargetObjectId--->'+TargetObjectId);
            if(TargetObjectId=='' || TargetObjectId==null || TargetObjectId=='null'){
                system.debug('TargetObjectId--->'+TargetObjectId);
                //dummy Account & Contact are creating to get TargetObjectId and will be rollbacked
                Account acct = new Account(Name='JunoDoc Dummy Account');
                insert acct;
                
                // Add a contact to this account.
                Contact con = new Contact(
                    FirstName='JunoDoc',
                    LastName='Dummy Contact',
                    Phone='111111',
                    Email='satyasowndarya@gmail.com',
                    AccountId=acct.id);
                insert con;
                //End dummy Account & Contact are creating to get TargetObjectId and will be rollbacked
                
                TargetObjectId = con.Id;                
            }
                        
            ToAdresses.add('satyasowndarya@gmail.com');
            
            list<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(EmailTemplateId);
            
            if(sObjName.toLowerCase()=='lead' || sObjName.toLowerCase()=='contact'){
                email.setWhatId( [select id from Account limit 1].id);
            }else{
                email.setWhatId(recordId);
            }
            email.setTargetObjectId(TargetObjectId);
            email.setSaveAsActivity(false);
            email.setToAddresses(ToAdresses);
            email.setReplyTo(setReplyToEmail); 
            if(!Test.isRunningTest()){
                msgList.add(email); 
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});            
            }
            Database.rollback(sp);  //rollback rollback rollback rollback rollback
            plainTextBody = email.getPlainTextBody();     
            Subject = email.getSubject();
        }
        if(plainTextBody != null)
        plainTextBody = plainTextBody.replace('JunoDoc Dummy Contact', '');

        return Subject+'~'+plainTextBody;
        
        
    }
     @AuraEnabled
    global static String getBodyFromJunoDocEmailTemplate1(id recordId,                                                  
                                                  string EmailTemplateId) 
    { 
        
        String CaseEmailAddress='';  
        String Body='';
        String Subject='';
        system.debug('********** EmailTemplateId ' + EmailTemplateId);
        if(EmailTemplateId !='' && EmailTemplateId != null )
        {                                             
            
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            MergeFieldsController md = new MergeFieldsController();
            md.SObjectName = sObjName;
            md.recordId = recordId;
            
            Email_Template__c DocTemplates = [select id,
                                            Parent_Object__c,
                                            Parent_Fields__c 
                                            From Email_Template__c 
                                            where id =: EmailTemplateId];
            
            integer itemcount= database.countQuery('select count() from Email_Template_Item__c Where Email_Template__c=:EmailTemplateId limit 1');
            if(itemcount>0){
                
                list<Email_Template_Item__c> eTemplateItemRec = Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(recordId, EmailTemplateId);
                if(eTemplateItemRec[0].Subject__c!=null){
                    Subject = md.m_MergeData(eTemplateItemRec[0].Subject__c);    
                }
                
                if(eTemplateItemRec[0].Template_Body__c!=null){
                    Body = md.m_MergeData(eTemplateItemRec[0].Template_Body__c);
                }
                Body = '<table style="position: relative;" ><tr><td>'+Body+'</td></tr></table>';
                system.debug(Body + '*********Body');
                System.debug('/'+DynamicListView_AC.getJunodocUrl()+'/JunoDoc__EmailTemplate_VF?SObjectName='+sObjName+'&EmailTemplateId='+EmailTemplateId+'&recordId='+recordId);
                PageReference ref = new PageReference('/'+DynamicListView_AC.getJunodocUrl()+'/JunoDoc__EmailTemplate_VF?SObjectName='+sObjName+'&EmailTemplateId='+EmailTemplateId+'&recordId='+recordId);
                
                if(!Test.isRunningTest()){
                    Body  = string.valueof( ref.getcontent().tostring().trim() + '');   
                }
                else{
                    Body = '<div>Test</div>';
                }
                system.debug(Body + '*********Body');
                Body  = Body.unescapeHtml4(); 
                Body  = Body.replace('<div style="font-size: 0px;">"</div>','');
                
                                 
            }
            
        }
        
        return Subject+'~'+Body;
        
    }
     global static string getJunodocUrl(){
        string JunodocUrl='apex';
        if(Network.getNetworkId()!=null){
            JunodocUrl='junodoc';
        }
        return JunodocUrl;
     }
   
      global class GetDetailsInner{
        @AuraEnabled 
        global List<Junodoc_Details__c> junodoc{get;set;}
        
        @AuraEnabled
        global List<returnEmailDetails> junoEmailList {get;set;}
    } 
    
    
    global class returnEmailDetails{
        @AuraEnabled
        global string Tovalue;
        @AuraEnabled
        global string TextRefVal;
        @AuraEnabled
        global string Email;
        @AuraEnabled
        global string fieldDetails;
    }
   
    @AuraEnabled
    global static String getBodyFromJunoDocEmailTemplate(id recordId,                                                  
                                                  string EmailTemplateId) 
    { 
        
        String CaseEmailAddress=''; 
        String Body='';
        String Subject='';
        
        if(EmailTemplateId !='')
        {                                             
            
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            MergeFieldsController md = new MergeFieldsController();
            md.SObjectName = sObjName;
            md.recordId = recordId;
            
            Email_Template__c DocTemplates = [select id,
                                            Parent_Object__c,
                                            Parent_Fields__c 
                                            From Email_Template__c 
                                            where id =: EmailTemplateId];
            
            integer itemcount= database.countQuery('select count() from Email_Template_Item__c Where Email_Template__c=:EmailTemplateId limit 1');
            if(itemcount>0){
                
                list<Email_Template_Item__c> eTemplateItemRec = Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(recordId, EmailTemplateId);
                if(eTemplateItemRec[0].Subject__c!=null){
                    Subject = md.m_MergeData(eTemplateItemRec[0].Subject__c);    
                }
                
                if(eTemplateItemRec[0].Template_Body__c!=null){
                    Body = md.m_MergeData(eTemplateItemRec[0].Template_Body__c);
                }
                Body = '<table style="position: relative;" ><tr><td>'+Body+'</td></tr></table>';
                system.debug(Body + '*********Body');
                PageReference ref = new PageReference('/apex/JunoDoc__EmailTemplate_VF?SObjectName='+sObjName+'&EmailTemplateId='+EmailTemplateId+'&recordId='+recordId);
                
                if(!Test.isRunningTest()){
                    Body  = string.valueof( ref.getcontent().tostring().trim() + '');   
                }
                else{
                    Body = '<div>Test</div>';
                }
                system.debug(Body + '*********Body');
                Body  = Body.unescapeHtml4(); 
                Body  = Body.replace('<div style="font-size: 0px;">"</div>','');
                
                                 
            }
            
        }
        
        return Subject+'~'+Body;
        
    }
    
    
     @AuraEnabled
    public static GetDetailsInner  getrecorddetails(string recordId){
        system.debug('@@@');
        string selectedobject = recordId;
        string selectedobjID;
        List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
        juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,
                                             Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c
                                          from Junodoc_Details__c 
                                          where Selected_object__c =: selectedobject];
        GetDetailsInner getInner = new GetDetailsInner();
        if(!juno.isEmpty()){
        List<JunoDoc__Email_Details__c> junoEmailList = [select JunoDoc__To_Value__c,JunoDoc__Text_Ref_Value__c,JunoDoc__Email__c,JunoDoc__field_Details__c 
                                                        from JunoDoc__Email_Details__c where JunoDoc__Junodoc_Details__c=:juno[0].Id];
        
        
        getInner.junodoc=juno;
        list<returnEmailDetails> returnEmailDetailslist = new list<returnEmailDetails>();
        for(JunoDoc__Email_Details__c jumoEmil : junoEmailList){
            returnEmailDetails returnEmailDetailsrec = new returnEmailDetails();
            returnEmailDetailsrec.Tovalue = jumoEmil.JunoDoc__To_Value__c;
            returnEmailDetailsrec.TextRefVal = jumoEmil.JunoDoc__Text_Ref_Value__c;
            returnEmailDetailsrec.Email = jumoEmil.JunoDoc__Email__c;
            returnEmailDetailsrec.fieldDetails = jumoEmil.JunoDoc__field_Details__c;
            returnEmailDetailslist.add(returnEmailDetailsrec);
        }
        
        getInner.junoEmailList=returnEmailDetailslist;
        }
        
       
        if(!juno.isEmpty()){
            return getInner;     
        }else{
            return null;
        }
       
          
    }
    
    @AuraEnabled(cacheable=true)
    public static List<pickListValuesWrapper> getOrgWideEmails(){
        List<pickListValuesWrapper>  orgWideEmailsList = new  List<pickListValuesWrapper>();
         list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address from OrgWideEmailAddress Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                pickListValuesWrapper obj = new pickListValuesWrapper();
                obj.label = rec.Address;
                obj.value = rec.id; 
                orgWideEmailsList.add(obj); 
            }
            return orgWideEmailsList;
        }  
        else{
            return null;
        }
    }
    
    
    public class pickListValuesWrapper{        
        @AuraEnabled public String label; 
        @AuraEnabled public String value;         
    }    
   
    
    
    
   
}
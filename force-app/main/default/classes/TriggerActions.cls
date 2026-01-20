public class TriggerActions {

    
    @AuraEnabled(cacheable=true)
    public static TriggerActionsWrapper TriggerActionsTabClick(){
        TriggerActionsWrapper wrapper = new TriggerActionsWrapper();
        system.debug('pageload');
        try{
                
            list<pickListValuesWrapper> ObjectsList=new list<pickListValuesWrapper>();
            list<string> apiName = new list<string>();
            for(Schema.SObjectType o : Schema.getGlobalDescribe().values()){
                Schema.DescribeSObjectResult objResult = o.getDescribe();
                apiName.add(objResult.getLabel()+'@!@'+objResult.getName());
            }
            apiName.sort();
            map<string,string> allObjects = new map<string,string>();
            for(string s : apiName){
                list<string> objName = s.split('@!@');
                system.debug(objName);
                pickListValuesWrapper pw = new pickListValuesWrapper();
                pw.value = objName[1];
                pw.label = objName[0];
                ObjectsList.add(pw);                                
            }            
            
            /*for ( Schema.SObjectType obj : Schema.getGlobalDescribe().values() ){
                pickListValuesWrapper pw = new pickListValuesWrapper();
                Schema.DescribeSObjectResult objResult = obj.getDescribe();
                pw.value = objResult.getName();
                pw.label = objResult.getLabel();
                ObjectsList.add(pw);                
            } */           
            system.debug('ObjectsList---->'+ObjectsList);
            wrapper.ObjectsList = ObjectsList;
            wrapper.TriggerActionsList = TriggerActions.getTriggerActions();
        }catch(Exception e){
            system.debug('exception e--->'+e.getMessage());
        }
        return wrapper;
    }
    
    public class pickListValuesWrapper{        
        @AuraEnabled public String label; 
        @AuraEnabled public String value;         
    }    
    
    public class TriggerActionsWrapper{        
        @AuraEnabled public List<pickListValuesWrapper> ObjectsList;     
        @AuraEnabled public list<Juno_Doc_Trigger__c>  TriggerActionsList;        
    }
    
    
    public static list<Juno_Doc_Trigger__c> getTriggerActions(){
        //list<JunoDocTriggerWrapper> JunoDocTriggersList = new list<JunoDocTriggerWrapper>();
        list<Juno_Doc_Trigger__c> TriggerActionsList = [select id,Name,Object_Name__c,
                                                      Trigger_Conditions_Formula__c, IsActive__c,JunoDoc__Enable_Recurring_Trigger__c
                                                      from Juno_Doc_Trigger__c 
                                                      limit 49000
                                                     ];        
        
        if(TriggerActionsList.size()>0){
            /*for(Juno_Doc_Trigger__c rec : TriggerActionsList){
                JunoDocTriggerWrapper obj = new JunoDocTriggerWrapper();
                obj.TriggerName = rec.Name;
                obj.ObjectName = rec.Object_Name__c;
                obj.IsActive = rec.IsActive__c;
                JunoDocTriggersList.add(obj);
            }*/
        }
        
        return TriggerActionsList;
        //return JunoDocTriggersList;
    }
     
    public class JunoDocTriggerWrapper{
        @AuraEnabled public String TriggerName;
        @AuraEnabled public String ObjectName;
        @AuraEnabled public boolean IsActive;
    }   
    
    public class FieldWrapper{        
        @AuraEnabled public String value;
        @AuraEnabled public String label;  
        @AuraEnabled public String type;
        @AuraEnabled public boolean isPicklist=false;
        @AuraEnabled public boolean isBoolean =false;
        @AuraEnabled public list<pickListValuesWrapper> picklistValues;
    }   
    
    @AuraEnabled
    public static JunoDoc__Junodoc_Details__c getJunodocObjectsettings(string ObjectName){
        List<JunoDoc__Junodoc_Details__c> jdlist = [select id,JunoDoc__From_Email_Address__c,JunoDoc__Junodoc_Email_Templates__c,
                                                    JunoDoc__Standard_Email_Templates__c,JunoDoc__Set_Reply_To__c,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junodoc_Details__c where JunoDoc__Selected_object__c =: ObjectName];
        return jdlist[0];
    }
    
    public static list<FieldWrapper> getSelectOptionFields(string ObjectName){
        
        list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
        
        try{
                system.debug('ObjectName--->'+ObjectName);
            
                FieldWrapper obj1 = new FieldWrapper();
                obj1.value = '';
                obj1.label = '--Select Field--';
                SelectOptionFieldsList.add(obj1);         
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> AccountfieldsMap = schemaMap.get(ObjectName).getDescribe().fields.getMap();
                for(Schema.SObjectField sfield : AccountfieldsMap.Values()){
                    schema.describefieldresult dfield = sfield.getDescribe();
                    //if(dfield.isUpdateable()) {
                        FieldWrapper obj = new FieldWrapper();
                        string fieldName = dfield.getName();
                        obj.value = fieldName;
                        obj.label = dfield.getLabel();
                    
                        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
                        obj.type = fieldType;
                        if(fieldType=='PICKLIST'){
                            obj.isPicklist = true;
                            obj.picklistValues = TriggerActions.getSelectedPicklistValues(ObjectName,fieldName);                            
                        }else{
                            obj.isPicklist = false;
                        }
                        if(fieldType=='BOOLEAN'){
                            obj.isBoolean = true;
                        }else{
                            obj.isBoolean = false;
                        }
                    
                        SelectOptionFieldsList.add(obj); 
                    
                    //}
                }    
            
            system.debug('SelectOptionFieldsList--->'+SelectOptionFieldsList);
            
        }catch(exception e){ 
            system.debug('error--->'+e.getMessage());
        }
        
        return SelectOptionFieldsList;
    }       
    
    
    @AuraEnabled
    public static TriggerActionWrapper getTriggerAction(string ObjectName, string TriggerName) {
        TriggerActionWrapper TriggerActionWrapper = new TriggerActionWrapper();
        
        // to display picklist values 
            list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
            SelectOptionFieldsList=TriggerActions.getSelectOptionFields(ObjectName);
        //End to display picklist values 
            
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjectName).getDescribe().fields.getMap();
            
            list<pickListValuesWrapper> EmailFieldsList = new list<pickListValuesWrapper>();
            for(string dfield:fieldMap.keyset()){      
                if(fieldMap.get(dfield).getDescribe().getType()+'' == 'Email'){
                    pickListValuesWrapper picklistWrap = new pickListValuesWrapper();
                    picklistWrap.label = fieldMap.get(dfield).getDescribe().getLabel();
                    picklistWrap.value = fieldMap.get(dfield).getDescribe().getName();
                    EmailFieldsList.add(picklistWrap);
                }
            }   
            system.debug('EmailFieldsList--->'+EmailFieldsList);
        
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c();
        list<Juno_Doc_Trigger__c> TriggerRecordsList = [select id,Name,Object_Name__c,
                                                       Trigger_Conditions_Formula__c, IsActive__c                                                                       
                                                       from Juno_Doc_Trigger__c 
                                                       Where Name =:TriggerName
                                                      ];
        if(TriggerRecordsList.size()>0){
            JunoDocTriggerRec = TriggerRecordsList[0];
        } 
        
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        List<ConditionWrapper> TriggerConditionsWrapper = new List<ConditionWrapper>();        
        list<Juno_Doc_Trigger_Condition__c> TriggerConidtionsList = [select id,Name,Field__c, Operator__c, Value__c,
                                                                     Juno_Doc_Trigger__r.Name,
                                                                     Juno_Doc_Trigger__r.Object_Name__c,
                                                                     RowNumber__c
                                                                     From Juno_Doc_Trigger_Condition__c 
                                                                     Where Juno_Doc_Trigger__r.Name=:TriggerName
                                                                     limit 49000
                                                                    ];
        if(TriggerConidtionsList.size() > 0){
            for(Juno_Doc_Trigger_Condition__c TriggerConditionRec : TriggerConidtionsList){
                ConditionWrapper obj = new ConditionWrapper();
                string fieldName = TriggerConditionRec.Field__c;
                obj.RowNumber = Integer.valueOf(TriggerConditionRec.RowNumber__c);
                obj.field = fieldName;
                obj.Operator = TriggerConditionRec.Operator__c;
                obj.fieldValue = TriggerConditionRec.Value__c;
                                
                for(string dfield:fieldMap.keyset()){
                    if(dfield==fieldName){
                        obj.label=fieldMap.get(fieldName).getDescribe().getLabel();
                        break;
                    }                    
                }                
                
                string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
                obj.type = fieldType;
                if(fieldType=='PICKLIST'){
                    obj.isPicklist = true;
                }else{
                    obj.isPicklist = false;
                }
                if(fieldType=='BOOLEAN'){
                    obj.isBoolean = true;
                }else{
                    obj.isBoolean = false;
                }
                
                TriggerConditionsWrapper.add(obj);          
                
            }
        }         
        
        
        
        Juno_Doc_Trigger_Action__c TriggerActionRec = new Juno_Doc_Trigger_Action__c();
        list<Juno_Doc_Trigger_Action__c> TriggerActionsList =  [select id,Name,Users_Email_Addresses__c, Contacts_Email_Addresses__c, 
                                                        Email_Addresses__c, From_Email_Address__c,
                                                        Set_Reply_To__c, Set_Sender_Display_Name__c,
                                                        Email_Fields__c, Available_Doc_Template__c, Juno_Doc_Email_Template__c, 
                                                        Standard_Email_Template__c, Email_Subject__c, Save_as_Activitiy__c,
                                                        Juno_Doc_Trigger__r.Object_Name__c, Juno_Doc_Trigger__r.Name
                                                        From Juno_Doc_Trigger_Action__c 
                                                        Where Juno_Doc_Trigger__r.Name=:TriggerName
                                                       ];
        if(TriggerActionsList.size()>0){
            TriggerActionRec = TriggerActionsList[0];
        }             
        
        
        
        List<PostActionWrapper> PostTriggerActionsWrapper = new List<PostActionWrapper>();        
        list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList = [select id,Name,Field__c, Value__c,
                                                                   Juno_Doc_Trigger__r.Object_Name__c,
                                                                   Juno_Doc_Trigger__r.Name
                                                                   From Juno_Doc_Post_Trigger_Action__c 
                                                                   Where Juno_Doc_Trigger__r.Name=:TriggerName
                                                                   limit 49000
                                                                  ];
        if(PostTriggerActionsList.size() > 0){
            for(integer i=0;i<PostTriggerActionsList.size();i++){
                PostActionWrapper obj = new PostActionWrapper();
                string fieldName = PostTriggerActionsList[i].Field__c;
                obj.RowNumber = (i+1);
                obj.Field = fieldName;
                obj.Value =PostTriggerActionsList[i].Value__c;  
                
                string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
                obj.type = fieldType;
                if(fieldType=='PICKLIST'){
                    obj.isPicklist = true;
                    obj.picklistValues = TriggerActions.getSelectedPicklistValues(ObjectName,fieldName);
                }else{
                    obj.isPicklist = false;
                }                
                
                
                PostTriggerActionsWrapper.add(obj);                
            }
        }         
        List<EmailWrapper> AddEmailRecipientsList = new List<EmailWrapper>();  
        list<JunoDoc__Junodoc_Add_Email_Recipient__c> junodocAddEmailRecipientsList = [select id,JunoDoc__Row_Number__c,JunoDoc__To_Cc_Bcc__c,
                                                                               JunoDoc__Reference_Type__c,JunoDoc__Email_Label_Values__c,JunoDoc__Email_API_Name_Values__c
                                                                               From JunoDoc__Junodoc_Add_Email_Recipient__c 
                                                                               Where JunoDoc__Juno_Doc_Trigger_Action__r.Id=:TriggerActionRec.Id
                                                                               limit 49000
                                                                               ];
        if(junodocAddEmailRecipientsList.size() > 0){
            for(JunoDoc__Junodoc_Add_Email_Recipient__c rec : junodocAddEmailRecipientsList){
                EmailWrapper wrapper = new EmailWrapper();
                wrapper.indx = Integer.valueOf(rec.JunoDoc__Row_Number__c);
                wrapper.ToCCBCC = rec.JunoDoc__To_Cc_Bcc__c;
                wrapper.ReferenceType = rec.JunoDoc__Reference_Type__c;
                wrapper.EmailValue = rec.JunoDoc__Email_Label_Values__c;
                wrapper.FinalFieldDetails = rec.JunoDoc__Email_API_Name_Values__c;
                AddEmailRecipientsList.add(wrapper);
            }
        }
        
        
        list<pickListValuesWrapper> orgWideEmailsList = new list<pickListValuesWrapper>();
        pickListValuesWrapper obj1 = new pickListValuesWrapper();
        obj1.label = 'None';
        obj1.value = 'None';
        //orgWideEmailsList.add(obj1); 

        list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address from OrgWideEmailAddress Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                pickListValuesWrapper obj = new pickListValuesWrapper();
                obj.label = rec.Address;
                obj.value = rec.id; 
                orgWideEmailsList.add(obj); 
            }
        }  
        
        InnerEmailTemplates EmailTemplatesInn = getEmailTemplates(ObjectName);
        
        
        TriggerActionWrapper.JunoDocTriggerRec = JunoDocTriggerRec;
        TriggerActionWrapper.TriggerConditionsList = TriggerConditionsWrapper;
        TriggerActionWrapper.TriggerActionRec = TriggerActionRec;
        TriggerActionWrapper.PostTriggerActionsList = PostTriggerActionsWrapper;
        TriggerActionWrapper.ObjectFieldsWrapper = SelectOptionFieldsList;
        TriggerActionWrapper.EmailFields = EmailFieldsList;
        TriggerActionWrapper.AvailableDocTemplatesList = EmailTemplatesInn.AvailableDocTemplatesList;
        TriggerActionWrapper.StandardEmailTemplatesList = EmailTemplatesInn.StandardEmailTemplatesList;
        TriggerActionWrapper.JunoDocEmailTemplatesList = EmailTemplatesInn.JunoDocEmailTemplatesList;
        TriggerActionWrapper.AddEmailRecipientsList = AddEmailRecipientsList;
        TriggerActionWrapper.OrgwideEmailAddressList = orgWideEmailsList;
            
        return TriggerActionWrapper;
        
    }
    
    
        
    public class TriggerActionWrapper{
        @AuraEnabled public Juno_Doc_Trigger__c JunoDocTriggerRec;
        @AuraEnabled public list<ConditionWrapper> TriggerConditionsList;
        @AuraEnabled public list<PostActionWrapper>PostTriggerActionsList;
        @AuraEnabled public Juno_Doc_Trigger_Action__c TriggerActionRec;
        @AuraEnabled public list<EmailWrapper> AddEmailRecipientsList;
        //@AuraEnabled public list<ConditionWrapper> TriggerConditionsList;        
        @AuraEnabled public List<FieldWrapper> ObjectFieldsWrapper;
        @AuraEnabled public list<pickListValuesWrapper> EmailFields;
        @AuraEnabled public list<pickListValuesWrapper> AvailableDocTemplatesList;
        @AuraEnabled public list<pickListValuesWrapper> StandardEmailTemplatesList;
        @AuraEnabled public list<pickListValuesWrapper> JunoDocEmailTemplatesList;
        @AuraEnabled public list<pickListValuesWrapper> OrgwideEmailAddressList;
        
    }
    
    public class ConditionWrapper{
        @AuraEnabled public Integer RowNumber;
        @AuraEnabled public String field;
        @AuraEnabled public String Operator;
        @AuraEnabled public String fieldValue;
        @AuraEnabled public String label;
        @AuraEnabled public String type;
        @AuraEnabled public boolean isPicklist=false;
        @AuraEnabled public boolean isBoolean =false;
    }           
    public class EmailWrapper{
        @AuraEnabled public Integer indx;
        @AuraEnabled public String ToCCBCC;
        @AuraEnabled public String ReferenceType;
        @AuraEnabled public String EmailValue;
        @AuraEnabled public String FinalFieldDetails;
       
    }   
    public class PostActionWrapper{
        @AuraEnabled public Integer RowNumber;
        @AuraEnabled public String Field;
        @AuraEnabled public String Value;
        @AuraEnabled public String type;        
        @AuraEnabled public boolean isPicklist=false;  
        @AuraEnabled public list<pickListValuesWrapper> picklistValues;
    }           
    
    @AuraEnabled(cacheable=true)
    public static list<pickListValuesWrapper> getSelectedPicklistValues(string ObjectName, string picklistField){
        
        system.debug('ObjectName--->'+ObjectName);
        system.debug('picklistField--->'+picklistField);
        
        list<pickListValuesWrapper> pickListValuesList = new list<pickListValuesWrapper>();
        
        String fieldName = picklistField;          
        Schema.SObjectType s = Schema.getGlobalDescribe().get(ObjectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesWrapper wrap = new pickListValuesWrapper();            
            wrap.label = pickListVal.getLabel();
            wrap.value = pickListVal.getValue();
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            pickListValuesList.add(wrap);
        }     
        system.debug('pickListValuesList--->'+pickListValuesList);
        return pickListValuesList;
    }    
 
    
    @AuraEnabled
    public static InnerEmailTemplates getEmailTemplates(string sObjName) { 
        
        sObjName = sObjName.toUpperCase();
        
        list<pickListValuesWrapper> AvailableDocTemplatesList = new list<pickListValuesWrapper>();
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Doc_Template__c 
                                                  where Parent_Object__c =: sObjName];
        if(availableDocList.size()>0){
            for(Doc_Template__c rec : availableDocList){
                pickListValuesWrapper obj = new pickListValuesWrapper();
                obj.label = rec.Name;
                obj.value = rec.id; 
                AvailableDocTemplatesList.add(obj);
            }            
        }
           
        
        list<pickListValuesWrapper> StandardEmailTemplatesList = new list<pickListValuesWrapper>();
        
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
                        pickListValuesWrapper objSettings = new pickListValuesWrapper();                    
                        objSettings.label=rec.Name;
                        objSettings.value=rec.Id;
                        StandardEmailTemplatesList.add(objSettings);                        
                    }                
                }            
            }  
        }
        
        
        list<pickListValuesWrapper> JunoDocEmailTemplatesList = new list<pickListValuesWrapper>();
        
        list<Email_Template__c> JunoDocETempList = [SELECT Id,Name
                                         From Email_Template__c 
                                         Where Parent_Object__c =:sObjName
                                         Order By Name
                                         Limit 5000];
        for(Email_Template__c rec:JunoDocETempList){            
            pickListValuesWrapper objSettings = new pickListValuesWrapper();
            objSettings.label=rec.Name;
            objSettings.value=rec.Id;
            JunoDocEmailTemplatesList.add(objSettings);                        
        }  
                
        
        InnerEmailTemplates Inn = new InnerEmailTemplates();
        Inn.AvailableDocTemplatesList = AvailableDocTemplatesList;        
        Inn.StandardEmailTemplatesList = StandardEmailTemplatesList;
        Inn.JunoDocEmailTemplatesList = JunoDocEmailTemplatesList;
                
        return Inn;
    }    
    
    
    public class InnerEmailTemplates{
        @AuraEnabled
        public list<pickListValuesWrapper> AvailableDocTemplatesList;
        @AuraEnabled
        public list<pickListValuesWrapper> StandardEmailTemplatesList;
        @AuraEnabled
        public list<pickListValuesWrapper> JunoDocEmailTemplatesList;        
    }
    
    
   /*
     * usage : 
     * 
     * 
     */      
    @AuraEnabled
    public static string saveTriggerActionConditions(string TriggerName,
                                                  string ObjectName, 
                                                  string TriggerConditionsFormula,
                                                  list<Object> records){
        system.debug('TriggerName---->'+TriggerName);
        system.debug('TriggerConditionsFormula---->'+TriggerConditionsFormula);
        system.debug('records---->'+records);
        string message='';
        string insertOrUpdateMessage = '';               
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c();
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c                                                                         
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name=:TriggerName
                                                           ];
        if(JunoDocTriggersList.size()>0){
            JunoDocTriggerRec = JunoDocTriggersList[0];
            //JunoDocTriggerRec.Name = TriggerName;
            JunoDocTriggerRec.Object_Name__c = ObjectName;
            JunoDocTriggerRec.Trigger_Conditions_Formula__c = TriggerConditionsFormula; 
            update JunoDocTriggerRec;
            insertOrUpdateMessage = 'Trigger Action updated successfully!';
        }else{
            JunoDocTriggerRec.Name = TriggerName;
            JunoDocTriggerRec.Object_Name__c = ObjectName;
            JunoDocTriggerRec.Trigger_Conditions_Formula__c = TriggerConditionsFormula; 
            insert JunoDocTriggerRec;
            insertOrUpdateMessage = 'Trigger Action created successfully!';
        }
        system.debug('insertOrUpdateMessage---'+insertOrUpdateMessage);
        
        id JunoDocTriggerId = JunoDocTriggerRec.Id;             
        if(JunoDocTriggerId!=null){            
            list<Juno_Doc_Trigger_Condition__c> deleteTriggerConditionsList = new list<Juno_Doc_Trigger_Condition__c>();
            deleteTriggerConditionsList = [select id,Name,Field__c, Operator__c, Value__c,
                                           Juno_Doc_Trigger__r.Object_Name__c,RowNumber__c
                                           From Juno_Doc_Trigger_Condition__c 
                                           Where Juno_Doc_Trigger__C=:JunoDocTriggerId
                                          ];
            if(deleteTriggerConditionsList.size()>0){
                delete deleteTriggerConditionsList;
            }
            
            list<Juno_Doc_Trigger_Condition__c> TriggerConditionsList = new list<Juno_Doc_Trigger_Condition__c>();
            for(Object Item : records){            
                Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                Integer RowNumber = Integer.valueOf(String.Valueof(ItemMap.get('RowNumber')));
                string field = String.Valueof(ItemMap.get('field'));
                string Operator = String.Valueof(ItemMap.get('Operator'));
                string fieldValue = String.Valueof(ItemMap.get('fieldValue'));                
                Juno_Doc_Trigger_Condition__c obj = new Juno_Doc_Trigger_Condition__c();
                obj.Juno_Doc_Trigger__c = JunoDocTriggerId;
                obj.RowNumber__c = RowNumber;
                obj.Field__c = field;
                obj.Operator__c = Operator;
                obj.Value__c = fieldValue;
                TriggerConditionsList.add(obj);                
            }            
            
            try{                
                system.debug('TriggerConditionsList--->'+TriggerConditionsList);
                insert TriggerConditionsList;
                message = insertOrUpdateMessage;               
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            }               
        }
                                                 
        
        return message;
     
                                                 
    }
 
    
    
    
    /*
     * usage : 
     * 
     * 
     */      
    @AuraEnabled
    public static string saveTriggerAction(string ObjectName, string TriggerName,
                                           string UsersEmailAddresses, string ContactsEmailAddresses,
                                           string EmailAddresses, string FromEmailAddress,
                                           string SetReplyTo, string SetSenderDisplayName, 
                                           string EmailFields, string AvailableDocTemplate,
                                           string StandardEmailTemplate, string JunoDocEmailTemplate, string EmailSubject,
                                           string SaveAsActivity,list<Object> AddEmailRecipientsList
                                           ){
        system.debug('ObjectName---->'+ObjectName); 
        system.debug('UsersEmailAddresses---->'+UsersEmailAddresses);
        system.debug('ContactsEmailAddresses---->'+ContactsEmailAddresses);
        system.debug('EmailAddresses---->'+EmailAddresses);
        system.debug('EmailFields---->'+EmailFields);
        system.debug('AvailableDocTemplate---->'+AvailableDocTemplate);
        system.debug('StandardEmailTemplate---->'+StandardEmailTemplate);
        system.debug('JunoDocEmailTemplate---->'+JunoDocEmailTemplate);
        system.debug('EmailSubject---->'+EmailSubject);
        system.debug('AddEmailRecipientsList---->'+AddEmailRecipientsList);

        string message='';
                                                                            
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c();
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c                                                                         
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name =:TriggerName
                                                           ];
        if(JunoDocTriggersList.size()>0){
            JunoDocTriggerRec = JunoDocTriggersList[0];
        }
        
        id JunoDocTriggerId = JunoDocTriggerRec.Id;
                                               
                                                      
        if(JunoDocTriggerId!=null){            
            list<Juno_Doc_Trigger_Action__c> deleteTriggerActionList = new list<Juno_Doc_Trigger_Action__c>();
            deleteTriggerActionList = [select id,Name,Users_Email_Addresses__c, Contacts_Email_Addresses__c, 
                                           Email_Addresses__c,From_Email_Address__c,
                                           Set_Reply_To__c, Set_Sender_Display_Name__c,
                                           Email_Fields__c, Available_Doc_Template__c, Juno_Doc_Email_Template__c, 
                                           Standard_Email_Template__c, Email_Subject__c, Save_as_Activitiy__c,
                                           Juno_Doc_Trigger__r.Object_Name__c, Juno_Doc_Trigger__r.Name
                                           From Juno_Doc_Trigger_Action__c 
                                           Where Juno_Doc_Trigger__r.Name=:TriggerName
                                          ];
            if(deleteTriggerActionList.size()>0){
                delete deleteTriggerActionList;
            }
            
            list<Juno_Doc_Trigger_Action__c> TriggerActionsList = new list<Juno_Doc_Trigger_Action__c>();
            Juno_Doc_Trigger_Action__c obj = new Juno_Doc_Trigger_Action__c();
            obj.Juno_Doc_Trigger__c = JunoDocTriggerId;
            obj.Users_Email_Addresses__c = UsersEmailAddresses;
            obj.Contacts_Email_Addresses__c = ContactsEmailAddresses;
            obj.Email_Addresses__c = EmailAddresses;
            obj.From_Email_Address__c = FromEmailAddress;
            obj.JunoDoc__Set_Reply_To__c = SetReplyTo;
            obj.JunoDoc__Set_Sender_Display_Name__c = SetSenderDisplayName;
            obj.Email_Fields__c = EmailFields;
            obj.Available_Doc_Template__c = AvailableDocTemplate;
            obj.Juno_Doc_Email_Template__c = JunoDocEmailTemplate;
            obj.Standard_Email_Template__c = StandardEmailTemplate;
            obj.Email_Subject__c = EmailSubject;
            obj.Save_as_Activitiy__c = Boolean.valueOf(SaveAsActivity);
            TriggerActionsList.add(obj);
            
            try{                
                system.debug('TriggerActionsList--->'+TriggerActionsList);
                insert TriggerActionsList;
                message = 'Trigger Updated with Action!';
                
                 list<JunoDoc__Junodoc_Add_Email_Recipient__c> junodocAddEmailRecipientsList = new list<JunoDoc__Junodoc_Add_Email_Recipient__c>();
            for(Object record : AddEmailRecipientsList){ 
                Map<Object, Object> recordMap = (Map<Object, Object>) record;
                System.debug('record  '+recordMap);
                JunoDoc__Junodoc_Add_Email_Recipient__c rec = new JunoDoc__Junodoc_Add_Email_Recipient__c();
                rec.JunoDoc__Row_Number__c = Integer.Valueof(recordMap.get('indx'));
                rec.JunoDoc__To_Cc_Bcc__c = String.Valueof(recordMap.get('ToCCBCC'));
                rec.JunoDoc__Reference_Type__c = String.Valueof(recordMap.get('ReferenceType'));
                rec.JunoDoc__Email_Label_Values__c = String.Valueof(recordMap.get('EmailValue'));
                rec.JunoDoc__Email_API_Name_Values__c = String.Valueof(recordMap.get('FinalFieldDetails'));
                rec.JunoDoc__Juno_Doc_Trigger_Action__c = TriggerActionsList[0].Id;
                junodocAddEmailRecipientsList.add(rec);
            }
            try{
                if(TriggerActionsList[0].Id!=null){            
                list<JunoDoc__Junodoc_Add_Email_Recipient__c> deleteAddEmailRecipientList = new list<JunoDoc__Junodoc_Add_Email_Recipient__c>();
                deleteAddEmailRecipientList = [select id,Name,JunoDoc__Row_Number__c,JunoDoc__Email_Label_Values__c,
                                     JunoDoc__To_Cc_Bcc__c,JunoDoc__Reference_Type__c,JunoDoc__Email_API_Name_Values__c,
                                     JunoDoc__Juno_Doc_Trigger_Action__c
                                     from JunoDoc__Junodoc_Add_Email_Recipient__c 
                                     Where JunoDoc__Juno_Doc_Trigger_Action__r.Id=:JunoDocTriggerRec.Id
                                     ];
                    if(deleteAddEmailRecipientList.size()>0){
                        delete deleteAddEmailRecipientList;
                    }
                }
                
                insert junodocAddEmailRecipientsList;
                System.debug('junodocAddEmailRecipientsList '+junodocAddEmailRecipientsList);
            }
            catch(Exception e){
                System.debug(e.getMessage());
            }

                
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            }               
        }
        
        return message;
                                                      
    }
    
    
        
    /*
     * usage : 
     * 
     * 
     */      
    @AuraEnabled
    public static string savePostTriggerActions(string ObjectName,  string TriggerName,
                                                list<Object> records){
        system.debug('ObjectName---->'+ObjectName);
        system.debug('records---->'+records);
        string message='';
        Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c();
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c                                                                         
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name =:TriggerName
                                                           ];
        if(JunoDocTriggersList.size()>0){
            JunoDocTriggerRec = JunoDocTriggersList[0];
        } 
        id JunoDocTriggerId = JunoDocTriggerRec.Id;             
        if(JunoDocTriggerId!=null){            
            list<Juno_Doc_Post_Trigger_Action__c> deleteRecordsList = new list<Juno_Doc_Post_Trigger_Action__c>();
            deleteRecordsList = [select id,Name,Field__c, Value__c,
                                           Juno_Doc_Trigger__r.Name,
                                           Juno_Doc_Trigger__r.Object_Name__c
                                           From Juno_Doc_Post_Trigger_Action__c 
                                           Where Juno_Doc_Trigger__r.Name=:TriggerName
                                          ];
            if(deleteRecordsList.size()>0){
                delete deleteRecordsList;
            }
            
            list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList = new list<Juno_Doc_Post_Trigger_Action__c>();
            for(Object Item : records){            
                Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                string field = String.Valueof(ItemMap.get('Field'));
                string fieldValue = String.Valueof(ItemMap.get('Value'));                
                Juno_Doc_Post_Trigger_Action__c obj = new Juno_Doc_Post_Trigger_Action__c();
                obj.Juno_Doc_Trigger__c = JunoDocTriggerId;
                obj.Field__c = field;
                obj.Value__c = fieldValue;
                PostTriggerActionsList.add(obj);                
            }            
            
            try{                
                system.debug('PostTriggerActionsList--->'+PostTriggerActionsList);
                insert PostTriggerActionsList;
                message = 'Trigger updated with post trigger action values!';               
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            }               
        }                    
        
        return message;                                                 
    }
 

    
   @AuraEnabled
    public static string deleteJunoDocTrigger(string TriggerName){
        system.debug('TriggerName---->'+TriggerName);
        string message='';
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c                                                                         
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name =:TriggerName
                                                           ];
    
        try{                
            if(JunoDocTriggersList.size()>0){
                    delete JunoDocTriggersList;
            } 
            message = 'Trigger Deleted Successfully!';
        }catch(exception e){
            system.debug('error--->'+e.getMessage());
        }                                           
        
        return message; 
        
    }
     
    @AuraEnabled
    public static string updateTriggerStatus(string toogleValue, string TriggerName){
        system.debug('TriggerName---->'+TriggerName);
        string message='';
        Juno_Doc_Trigger__c JunoDocTriggerrec;
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c,IsActive__c                                                                       
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name =:TriggerName
                                                           ];
    
        try{                
            if(JunoDocTriggersList.size()>0){
                JunoDocTriggerrec = JunoDocTriggersList[0];
                JunoDocTriggerrec.IsActive__c = Boolean.valueOf(toogleValue);
                update JunoDocTriggerrec; 
                if(toogleValue=='true'){
                    message = 'Trigger is activated successfully!';    
                }else{
                    message = 'Trigger is deactivated successfully!';    
                }
                
                /*List<CronTrigger> abort_job = [SELECT ID, CronExpression, CronJobDetail.Name, 
                                               NextFireTime, PreviousFireTime, StartTime, State, TimesTriggered 
                                               FROM CronTrigger 
                                               Where NextFireTime != null 
                                               And CronJobDetail.Name like 'JunoDocTriggerActionsSchedule%'
                                              ];
                for (CronTrigger t : abort_job) { //for each record
                    System.abortJob(t.Id); //abort the job
                }
          
                System.schedule('JunoDocTriggerActionsSchedule job1', '0 0 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job2', '0 5 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job3', '0 10 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job4', '0 15 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job5', '0 20 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job6', '0 25 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job7', '0 30 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job8', '0 35 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job9', '0 40 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job10', '0 45 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job11', '0 50 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                System.schedule('JunoDocTriggerActionsSchedule job12', '0 55 * * * ?', new JunoDoc.JunoDocTriggerActionsSchedule());
                */
                system.abortJob('message--->'+message);
            } 
            
        }catch(exception e){
            system.debug('error--->'+e.getMessage());
        }                                           
        
        return message; 
        
    }
         
      @AuraEnabled
    public static string updateRecurringTrigger(string recurringTrigger, string TriggerName){
        system.debug('TriggerName---->'+TriggerName);
        string message='';
        Juno_Doc_Trigger__c JunoDocTriggerrec;
        list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                            Trigger_Conditions_Formula__c,IsActive__c,Enable_Recurring_Trigger__c                                                                       
                                                            from Juno_Doc_Trigger__c 
                                                            Where Name =:TriggerName
                                                           ];
    
        try{                
            if(JunoDocTriggersList.size()>0){
                JunoDocTriggerrec = JunoDocTriggersList[0];
                JunoDocTriggerrec.Enable_Recurring_Trigger__c = Boolean.valueOf(recurringTrigger);
                update JunoDocTriggerrec; 
                if(recurringTrigger == 'true'){
                    message = 'Recurring Trigger is activated successfully!';    
                }else{
                    message = 'Recurring Trigger is deactivated successfully!';    
                }
                
                system.abortJob('message--->'+message);
            } 
            
        }catch(exception e){
            system.debug('error--->'+e.getMessage());
        }                                           
        
        return message; 
        
    }
        
    
}
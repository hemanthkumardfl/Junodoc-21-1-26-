public class ScheduleActions {
    
    
    @AuraEnabled(cacheable=true)
    public static ScheduleActionsWrapper ScheduleActionsTabClick(){
        ScheduleActionsWrapper wrapper = new ScheduleActionsWrapper();
        //system.debug('pageload');
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
                //system.debug(objName);
                pickListValuesWrapper pw = new pickListValuesWrapper();
                pw.value = objName[1];
                pw.label = objName[0];
                ObjectsList.add(pw);                                
            }            
            
            
            //system.debug('ObjectsList---->'+ObjectsList);
            wrapper.ObjectsList = ObjectsList;
            wrapper.ScheduleActionsList = ScheduleActions.getScheduleActions();
        }catch(Exception e){
            system.debug('exception e--->'+e.getMessage());
        }
        return wrapper;
    }
    
    public class pickListValuesWrapper{        
        @AuraEnabled public String label; 
        @AuraEnabled public String value;         
    }    
    
    public class ScheduleActionsWrapper{        
        @AuraEnabled public List<pickListValuesWrapper> ObjectsList;     
        @AuraEnabled public list<Junodoc__Junodoc_Schedule_Template_Setting__c>  ScheduleActionsList;        
    }
    
    public static list<Junodoc__Junodoc_Schedule_Template_Setting__c> getScheduleActions(){
        //list<JunoDocTriggerWrapper> JunoDocTriggersList = new list<JunoDocTriggerWrapper>();
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> ScheduleActionsList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                   Junodoc__Junodoc_Selected_Criteria__c, Junodoc__Junodoc_IsActive__c
                                                                                   from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                   limit 49000
                                                                                  ];        
        
        if(ScheduleActionsList.size()>0){
            
        }
        
        return ScheduleActionsList;
        //return JunoDocTriggersList;
    }
    @AuraEnabled
    public static string saveScheduleActionConditions(string ScheduleName,string ObjectName, string ScheduleConditionsFormula,list<Object> records){
        //system.debug('ScheduleName---->'+ScheduleName);
        //system.debug('ScheduleConditionsFormula---->'+ScheduleConditionsFormula);
        //system.debug('records---->'+records);
        string message='';
        string insertOrUpdateMessage = '';               
        Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                    Junodoc__Junodoc_Selected_Criteria__c                                                                         
                                                                                    from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                    Where Name=:ScheduleName
                                                                                   ];
        if(JunoDocSchedulesList.size()>0){
            JunoDocScheduleRec = JunoDocSchedulesList[0];
            //JunoDocTriggerRec.Name = TriggerName;
            JunoDocScheduleRec.Junodoc__Junodoc_Selected_Object__c = ObjectName;
            JunoDocScheduleRec.Junodoc__Junodoc_Selected_Criteria__c = ScheduleConditionsFormula; 
            update JunoDocScheduleRec;
            insertOrUpdateMessage = 'Schedule Filter Conditions updated successfully!';
        }else{
            JunoDocScheduleRec.Name = ScheduleName;
            JunoDocScheduleRec.Junodoc__Junodoc_Selected_Object__c = ObjectName;
            JunoDocScheduleRec.Junodoc__Junodoc_Selected_Criteria__c = ScheduleConditionsFormula; 
            insert JunoDocScheduleRec;
            insertOrUpdateMessage = 'Schedule Filter Conditions created successfully!';
        }
        //system.debug('insertOrUpdateMessage---'+insertOrUpdateMessage);
        
        id JunoDocScheduleId = JunoDocScheduleRec.Id;             
        if(JunoDocScheduleId!=null){            
            list<Junodoc__Junodoc_Schedule_Condition__c> deleteScheduleConditionsList = new list<Junodoc__Junodoc_Schedule_Condition__c>();
            deleteScheduleConditionsList = [select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Operator__c, Junodoc__Junodoc_Value__c,
                                            Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,Junodoc__Junodoc_RowNumber__c
                                            From Junodoc__Junodoc_Schedule_Condition__c 
                                            Where Junodoc__Junodoc_Schedule_Template_Setting__c=:JunoDocScheduleId
                                           ];
            if(deleteScheduleConditionsList.size()>0){
                delete deleteScheduleConditionsList;
            }
            
            list<Junodoc__Junodoc_Schedule_Condition__c> ScheduleConditionsList = new list<Junodoc__Junodoc_Schedule_Condition__c>();
            for(Object Item : records){            
                Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                Integer RowNumber = Integer.valueOf(String.Valueof(ItemMap.get('RowNumber')));
                string field = String.Valueof(ItemMap.get('field'));
                string Operator = String.Valueof(ItemMap.get('Operator'));
                string fieldValue = String.Valueof(ItemMap.get('fieldValue'));                
                Junodoc__Junodoc_Schedule_Condition__c obj = new Junodoc__Junodoc_Schedule_Condition__c();
                obj.Junodoc__Junodoc_Schedule_Template_Setting__c = JunoDocScheduleId;
                obj.Junodoc__Junodoc_RowNumber__c = RowNumber;
                obj.Junodoc__Junodoc_Field__c = field;
                obj.Junodoc__Junodoc_Operator__c = Operator;
                obj.Junodoc__Junodoc_Value__c = fieldValue;
                ScheduleConditionsList.add(obj);                
            }            
            
            try{                
                //system.debug('ScheduleConditionsList--->'+ScheduleConditionsList);
                insert ScheduleConditionsList;
                message = insertOrUpdateMessage;               
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            }               
        }
        
        
        return message;
        
        
    }
    @AuraEnabled(cacheable=true)
    public static list<pickListValuesWrapper> getSelectedPicklistValues(string ObjectName, string picklistField){
        
        //system.debug('ObjectName--->'+ObjectName);
        //system.debug('picklistField--->'+picklistField);
        
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
            //System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            pickListValuesList.add(wrap);
        }     
        //system.debug('pickListValuesList--->'+pickListValuesList);
        return pickListValuesList;
    }  
    
    @AuraEnabled
    public static ScheduleConditionWrapper getScheduleConditions(string ObjectName, string ScheduleName) {
        //system.debug('ScheduleName-------->'+ScheduleName);
        ScheduleConditionWrapper ScheduleConditionWrapper = new ScheduleConditionWrapper();
        
        // to display picklist values 
        list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
        SelectOptionFieldsList=ScheduleActions.getSelectOptionFields(ObjectName);
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
        //system.debug('EmailFieldsList--->'+EmailFieldsList);
        
        Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> ScheduleRecordsList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                   Junodoc__Junodoc_Selected_Criteria__c, Junodoc__Junodoc_IsActive__c                                                                       
                                                                                   from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                   Where Name =:ScheduleName
                                                                                  ];
        //system.debug('ScheduleRecordsList--->'+ScheduleRecordsList);
        if(ScheduleRecordsList.size()>0){
            JunoDocScheduleRec = ScheduleRecordsList[0];
            //system.debug('JunoDocScheduleRec--->'+JunoDocScheduleRec);
        } 
        
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        List<ConditionWrapper> ScheduleConditionsWrapper = new List<ConditionWrapper>();        
        list<Junodoc__Junodoc_Schedule_Condition__c> ScheduleConditionsList = [select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Operator__c, Junodoc__Junodoc_Value__c,
                                                                               Junodoc__Junodoc_Schedule_Template_Setting__r.Name,
                                                                               Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,
                                                                               Junodoc__Junodoc_RowNumber__c
                                                                               From Junodoc__Junodoc_Schedule_Condition__c 
                                                                               Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                                                               limit 49000
                                                                              ];
        if(ScheduleConditionsList.size() > 0){
            for(Junodoc__Junodoc_Schedule_Condition__c ScheduleConditionRec : ScheduleConditionsList){
                ConditionWrapper obj = new ConditionWrapper();
                string fieldName = ScheduleConditionRec.Junodoc__Junodoc_Field__c;
                obj.RowNumber = Integer.valueOf(ScheduleConditionRec.Junodoc__Junodoc_RowNumber__c);
                obj.field = fieldName;
                obj.Operator = ScheduleConditionRec.Junodoc__Junodoc_Operator__c;
                obj.fieldValue = ScheduleConditionRec.Junodoc__Junodoc_Value__c;
                for(string dfield:fieldMap.keyset()){
                    system.debug('dfield--->'+fieldMap.get(fieldName));
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
                
                ScheduleConditionsWrapper.add(obj);          
                
            }
        }         
        
        ScheduleConditionWrapper.JunoDocScheduleRec = JunoDocScheduleRec;
        ScheduleConditionWrapper.ObjectFieldsWrapper = SelectOptionFieldsList;
        ScheduleConditionWrapper.ScheduleConditionsList = ScheduleConditionsWrapper;
        
        return ScheduleConditionWrapper;
    }
    
    @AuraEnabled
    public static JunoDoc__Junodoc_Details__c getJunodocObjectsettings(string ObjectName){
        List<JunoDoc__Junodoc_Details__c> jdlist = [select id,JunoDoc__From_Email_Address__c,JunoDoc__Junodoc_Email_Templates__c,
                                                    JunoDoc__Standard_Email_Templates__c,JunoDoc__Set_Reply_To__c,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junodoc_Details__c where JunoDoc__Selected_object__c =: ObjectName];
        return jdlist[0];
    }
    
    @AuraEnabled
    public static ScheduleActionWrapper getScheduleAction(string ObjectName, string ScheduleName) {
        ScheduleActionWrapper ScheduleActionWrapper = new ScheduleActionWrapper();
        
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
        //system.debug('EmailFieldsList--->'+EmailFieldsList);
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        Junodoc__Junodoc_Schedule_Action__c ScheduleActionRec = new Junodoc__Junodoc_Schedule_Action__c();
        list<Junodoc__Junodoc_Schedule_Action__c> ScheduleActionsList =  [select id,Name,Junodoc__Junodoc_Users_Email_Addresses__c, Junodoc__Junodoc_Contacts_Email_Addresses__c, 
                                                                          Junodoc__Junodoc_Email_Addresses__c, Junodoc__Junodoc_From_Email_Address__c,
                                                                          Junodoc__Junodoc_Set_Reply_To__c, Junodoc__Junodoc_Set_Sender_Display_Name__c, Junodoc__Junodoc_Is_Send__c, Junodoc__Junodoc_Is_Attach__c,
                                                                          Junodoc__Junodoc_Email_Fields__c, Junodoc__Junodoc_Available_Doc_Template__c, Junodoc__Junodoc_Doc_Email_Template__c, 
                                                                          Junodoc__Junodoc_Standard_Email_Template__c, Junodoc__Junodoc_Email_Subject__c, Junodoc__Junodoc_Save_as_Activity__c,
                                                                          Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c, Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                                                          From Junodoc__Junodoc_Schedule_Action__c 
                                                                          Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                                                         ];
        if(ScheduleActionsList.size()>0){
            ScheduleActionRec = ScheduleActionsList[0];
            //system.debug('ScheduleActionRec--->'+ScheduleActionRec);
        }             
        
        
        
        List<EmailWrapper> AddEmailRecipientsList = new List<EmailWrapper>();  
        list<Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c> junodocAddEmailRecipientsList = [select id,Junodoc__Junodoc_Row_Number__c,Junodoc__Junodoc_To_Cc_Bcc__c,
                                                                                                    Junodoc__Junodoc_Reference_Type__c,Junodoc__Junodoc_Email_Label_Values__c,Junodoc__Junodoc_Email_API_Name_Values__c
                                                                                                    From Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c 
                                                                                                    Where Junodoc__Junodoc_Schedule_Action__r.Id=:ScheduleActionRec.Id
                                                                                                   ];
        if(junodocAddEmailRecipientsList.size() > 0){
            for(Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c rec : junodocAddEmailRecipientsList){
                EmailWrapper wrapper = new EmailWrapper();
                wrapper.indx = Integer.valueOf(rec.Junodoc__Junodoc_Row_Number__c);
                wrapper.ToCCBCC = rec.Junodoc__Junodoc_To_Cc_Bcc__c;
                wrapper.ReferenceType = rec.Junodoc__Junodoc_Reference_Type__c;
                wrapper.EmailValue = rec.Junodoc__Junodoc_Email_Label_Values__c;
                wrapper.FinalFieldDetails = rec.Junodoc__Junodoc_Email_API_Name_Values__c;
                AddEmailRecipientsList.add(wrapper);
                //system.debug('AddEmailRecipientsList--->'+AddEmailRecipientsList);  
            }
        }
        
        
        list<pickListValuesWrapper> orgWideEmailsList = new list<pickListValuesWrapper>();
        pickListValuesWrapper obj1 = new pickListValuesWrapper();
        obj1.label = 'None';
        obj1.value = '';
        orgWideEmailsList.add(obj1); 
        
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
        
        
        
        ScheduleActionWrapper.ScheduleActionRec = ScheduleActionRec;
        ScheduleActionWrapper.EmailFields = EmailFieldsList;
        ScheduleActionWrapper.AvailableDocTemplatesList = EmailTemplatesInn.AvailableDocTemplatesList;
        ScheduleActionWrapper.StandardEmailTemplatesList = EmailTemplatesInn.StandardEmailTemplatesList;
        ScheduleActionWrapper.JunoDocEmailTemplatesList = EmailTemplatesInn.JunoDocEmailTemplatesList;
        ScheduleActionWrapper.AddEmailRecipientsList = AddEmailRecipientsList;
        ScheduleActionWrapper.OrgwideEmailAddressList = orgWideEmailsList;
        return ScheduleActionWrapper;
        
    }
    
    @AuraEnabled
    public static List<PostActionWrapper> getPostScheduleAction(string ObjectName, string ScheduleName) {
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        
        List<PostActionWrapper> PostScheduleActionsWrapper = new List<PostActionWrapper>();        
        list<Junodoc__Junodoc_Post_Schedule_Action__c> PostScheduleActionsList = [select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Value__c,
                                                                                  Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,
                                                                                  Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                                                                  From Junodoc__Junodoc_Post_Schedule_Action__c 
                                                                                  Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                                                                  limit 49000
                                                                                 ];
        if(PostScheduleActionsList.size() > 0){
            for(integer i=0;i<PostScheduleActionsList.size();i++){
                PostActionWrapper obj = new PostActionWrapper();
                string fieldName = PostScheduleActionsList[i].Junodoc__Junodoc_Field__c;
                obj.RowNumber = (i+1);
                obj.Field = fieldName;
                obj.Value =PostScheduleActionsList[i].Junodoc__Junodoc_Value__c;  
                
                string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
                obj.type = fieldType;
                if(fieldType=='BOOLEAN'){
                    obj.isPicklist = false;
                    obj.isBoolean = true;
                    obj.isText = false;
                }
                else if(fieldType=='PICKLIST'){
                    obj.isPicklist = true;
                    obj.isBoolean = false;
                    obj.isText = false;
                    obj.picklistValues = ScheduleActions.getSelectedPicklistValues(ObjectName,fieldName);
                }else{
                    obj.isPicklist = false;
                    obj.isBoolean = false;
                    obj.isText = true;
                }                
                
                PostScheduleActionsWrapper.add(obj);                
            }
        }
        return PostScheduleActionsWrapper;
    }
    
    public class InnerEmailTemplates{
        @AuraEnabled
        public list<pickListValuesWrapper> AvailableDocTemplatesList;
        @AuraEnabled
        public list<pickListValuesWrapper> StandardEmailTemplatesList;
        @AuraEnabled
        public list<pickListValuesWrapper> JunoDocEmailTemplatesList;        
    }
    
    public class FieldWrapper{        
        @AuraEnabled public String value;
        @AuraEnabled public String label;  
        @AuraEnabled public String type;
        @AuraEnabled public boolean isPicklist=false;
        @AuraEnabled public boolean isBoolean =false;
        @AuraEnabled public list<pickListValuesWrapper> picklistValues;
    }
    
    public class ScheduleConditionWrapper{
        @AuraEnabled public Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec;
        @AuraEnabled public list<ConditionWrapper> ScheduleConditionsList;
        @AuraEnabled public List<FieldWrapper> ObjectFieldsWrapper;
    }
    public class ScheduleActionWrapper{
        @AuraEnabled public list<PostActionWrapper>PostScheduleActionsList;
        @AuraEnabled public Junodoc__Junodoc_Schedule_Action__c ScheduleActionRec;
        @AuraEnabled public list<EmailWrapper> AddEmailRecipientsList;
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
        @AuraEnabled public boolean isBoolean=false;
        @AuraEnabled public boolean isText = false;
        @AuraEnabled public list<pickListValuesWrapper> picklistValues;
    }
    
    public class ScheduleSetUpWrapper{
        @AuraEnabled public Junodoc__Junodoc_Schedule_Scheduler_Setup__c ScheduleSetUpRec;
        @AuraEnabled public list<string> ScheduledDays;
        @AuraEnabled public list<string> ScheduledDates;
        @AuraEnabled public list<string> ScheduledMonths;
        @AuraEnabled public string UserGMT;
        @AuraEnabled public list<pickListValuesWrapper> SchedulerTypeList;
        @AuraEnabled public list<pickListValuesWrapper> SchedulerDatesList;
        @AuraEnabled public list<pickListValuesWrapper> SchedulerWeekDays;
        @AuraEnabled public list<pickListValuesWrapper> SchedulerHoursList;
        @AuraEnabled public list<pickListValuesWrapper> ScheduleClockFormats;
        @AuraEnabled public list<pickListValuesWrapper> SchedulerMonthsList;
    }
    
    @AuraEnabled
    public static ScheduleSetUpWrapper getScheduleSetup(String ScheduleName){
        Junodoc__Junodoc_Schedule_Scheduler_Setup__c ScheduleSetUpRec = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
        list<string> ScheduledDays = new list<string> ();
        list<string> ScheduledDates = new list<string> ();
        list<string> ScheduledMonths = new list<string> ();
        List<Junodoc__Junodoc_Schedule_Scheduler_Setup__c> ScheduleSetUpRecList = [Select Id, Name, Junodoc__Junodoc_Scheduler_Type__c, Junodoc__Junodoc_Selected_Schedule_Day__c,
                                                                                   Junodoc__Junodoc_Selected_Schedule_Date__c, Junodoc__Junodoc_Selected_Schedule_Hour__c,
                                                                                   Junodoc__Junodoc_Clock_Format__c,Junodoc__Junodoc_Selected_Schedule_Month__c,
                                                                                   Junodoc__Junodoc_Schedule_Template_Setting__r.Name from Junodoc__Junodoc_Schedule_Scheduler_Setup__c
                                                                                   where Junodoc__Junodoc_Schedule_Template_Setting__r.Name =: ScheduleName];
        
        if(ScheduleSetUpRecList.size()>0){
            ScheduleSetUpRec = ScheduleSetUpRecList[0];
            
            String SchDays = ScheduleSetUpRec.Junodoc__Junodoc_Selected_Schedule_Day__c;
            if(SchDays != '' && SchDays != null){
                ScheduledDays = SchDays.split(';');
            }
            
            String SchDates = ScheduleSetUpRec.Junodoc__Junodoc_Selected_Schedule_Date__c;
            if(SchDates != '' && SchDates != null){
                ScheduledDates = SchDates.split(';');
            }
            String SchMonths = ScheduleSetUpRec.Junodoc__Junodoc_Selected_Schedule_Month__c;
            if(SchMonths != '' && SchMonths != null){
                ScheduledMonths = SchMonths.split(';');
            }
        }
        ScheduleSetUpWrapper ScheduleSetUpWrapper = new ScheduleSetUpWrapper(); 
        List<pickListValuesWrapper> SchedulerTypeList = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult1 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Scheduler_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        
        for( Schema.PicklistEntry f1 : ple1)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f1.getLabel();
            obj.value = f1.getValue();
            SchedulerTypeList.add(obj);
        }
        
        List<pickListValuesWrapper> SchedulerWeekDays = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult2 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Selected_Schedule_Day__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        
        for( Schema.PicklistEntry f2 : ple2)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f2.getLabel();
            obj.value = f2.getValue();
            SchedulerWeekDays.add(obj);
        }
        
        List<pickListValuesWrapper> SchedulerDatesList = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult3 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Selected_Schedule_Date__c.getDescribe();
        List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
        
        for( Schema.PicklistEntry f3 : ple3)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f3.getLabel();
            obj.value = f3.getValue();
            SchedulerDatesList.add(obj);
        }
        
        List<pickListValuesWrapper> SchedulerHoursList = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult4 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Selected_Schedule_Hour__c.getDescribe();
        List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
        
        for( Schema.PicklistEntry f4 : ple4)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f4.getLabel();
            obj.value = f4.getValue();
            SchedulerHoursList.add(obj);
        }
        List<pickListValuesWrapper> ScheduleClockFormats = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult5 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Clock_Format__c.getDescribe();
        List<Schema.PicklistEntry> ple5 = fieldResult5.getPicklistValues();
        
        for( Schema.PicklistEntry f5 : ple5)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f5.getLabel();
            obj.value = f5.getValue();
            ScheduleClockFormats.add(obj);
        }
        
        List<pickListValuesWrapper> SchedulerMonthsList = new List<pickListValuesWrapper>();
        Schema.DescribeFieldResult fieldResult6 = Junodoc__Junodoc_Schedule_Scheduler_Setup__c.Junodoc__Junodoc_Selected_Schedule_Month__c.getDescribe();
        List<Schema.PicklistEntry> ple6 = fieldResult6.getPicklistValues();
        
        for( Schema.PicklistEntry f6 : ple6)
        {
            pickListValuesWrapper obj = new pickListValuesWrapper();
            obj.label = f6.getLabel();
            obj.value = f6.getValue();
            SchedulerMonthsList.add(obj);
        }
        
        TimeZone tz = UserInfo.getTimeZone();
        //System.debug('Display name: ' +  tz.getDisplayName());
        //System.debug('ID: ' +  tz.getID());
        String UserGMT = tz.getDisplayName();
        
        //system.debug('ScheduleSetUpRec----->'+ScheduleSetUpRec);
        //system.debug('SchedulerTypeList--->'+SchedulerTypeList);
        //system.debug('SchedulerWeekDays--->'+SchedulerWeekDays);
        //system.debug('SchedulerDatesList--->'+SchedulerDatesList);
        //system.debug('SchedulerHoursList--->'+SchedulerHoursList);
        //system.debug('SchedulerMonthsList--->'+SchedulerMonthsList);
        //system.debug('UserGMT--->'+UserGMT);
        
        ScheduleSetUpWrapper.ScheduleSetUpRec = ScheduleSetUpRec;
        ScheduleSetUpWrapper.ScheduledDates = ScheduledDates;
        ScheduleSetUpWrapper.ScheduledDays = ScheduledDays;
        ScheduleSetUpWrapper.ScheduledMonths = ScheduledMonths;
        ScheduleSetUpWrapper.UserGMT = UserGMT;
        ScheduleSetUpWrapper.SchedulerTypeList = SchedulerTypeList;
        ScheduleSetUpWrapper.SchedulerWeekDays = SchedulerWeekDays;
        ScheduleSetUpWrapper.SchedulerHoursList = SchedulerHoursList;
        ScheduleSetUpWrapper.SchedulerDatesList = SchedulerDatesList;
        ScheduleSetUpWrapper.ScheduleClockFormats = ScheduleClockFormats;
        ScheduleSetUpWrapper.SchedulerMonthsList = SchedulerMonthsList;
        return ScheduleSetUpWrapper;
        
    }
    
    public static list<FieldWrapper> getSelectOptionFields(string ObjectName){
        
        list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
        
        try{
            //system.debug('ObjectName--->'+ObjectName);
            
            
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
                    obj.picklistValues = ScheduleActions.getSelectedPicklistValues(ObjectName,fieldName);                            
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
            
            //system.debug('SelectOptionFieldsList--->'+SelectOptionFieldsList);
            
        }catch(exception e){ 
            system.debug('error--->'+e.getMessage());
        }
        
        return SelectOptionFieldsList;
    }
    
    @AuraEnabled
    public static InnerEmailTemplates getEmailTemplates(string sObjName) { 
        
        sObjName = sObjName.toUpperCase();
        
        list<pickListValuesWrapper> AvailableDocTemplatesList = new list<pickListValuesWrapper>();
        pickListValuesWrapper obj1 = new pickListValuesWrapper();
        obj1.label = 'None';
        obj1.value = ''; 
        AvailableDocTemplatesList.add(obj1);
        
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
        pickListValuesWrapper objSettings1 = new pickListValuesWrapper();                    
        objSettings1.label='None';
        objSettings1.value='';
        StandardEmailTemplatesList.add(objSettings1);
        
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
        pickListValuesWrapper objSettings2 = new pickListValuesWrapper();
        objSettings2.label='None';
        objSettings2.value='';
        JunoDocEmailTemplatesList.add(objSettings2);
        
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
    
    @AuraEnabled
    public static string saveScheduleAction(string ObjectName, string ScheduleName,
                                            string UsersEmailAddresses, string ContactsEmailAddresses,
                                            string EmailAddresses, string FromEmailAddress,
                                            string SetReplyTo, string SetSenderDisplayName, 
                                            string EmailFields, string AvailableDocTemplate,
                                            string StandardEmailTemplate, string JunoDocEmailTemplate, string EmailSubject,
                                            string SaveAsActivity, string IsSendEmail, string IsAttachEmail, list<Object> AddEmailRecipientsList
                                           ){
                                               //system.debug('ObjectName---->'+ObjectName); 
                                               //system.debug('UsersEmailAddresses---->'+UsersEmailAddresses);
                                               //system.debug('ContactsEmailAddresses---->'+ContactsEmailAddresses);
                                               //system.debug('EmailAddresses---->'+EmailAddresses);
                                               //system.debug('EmailFields---->'+EmailFields);
                                               //system.debug('AvailableDocTemplate---->'+AvailableDocTemplate);
                                               //system.debug('StandardEmailTemplate---->'+StandardEmailTemplate);
                                               //system.debug('JunoDocEmailTemplate---->'+JunoDocEmailTemplate);
                                               //system.debug('EmailSubject---->'+EmailSubject);
                                               //system.debug('AddEmailRecipientsList---->'+AddEmailRecipientsList);
                                               
                                               string message='';
                                               
                                               Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec = new Junodoc__Junodoc_Schedule_Template_Setting__c();
                                               list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                                                           Junodoc__Junodoc_Selected_Criteria__c                                                                         
                                                                                                                           from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                                                           Where Name =:ScheduleName
                                                                                                                          ];
                                               //system.debug('JunoDocSchedulesList------>'+JunoDocSchedulesList);
                                               if(JunoDocSchedulesList.size()>0){
                                                   JunoDocScheduleRec = JunoDocSchedulesList[0];
                                                   //system.debug('JunoDocScheduleRec------>'+JunoDocScheduleRec);
                                               }
                                               
                                               id JunoDocScheduleId = JunoDocScheduleRec.Id;
                                               
                                               //system.debug('JunoDocScheduleId------>'+JunoDocScheduleId);
                                               if(JunoDocScheduleId!=null){            
                                                   list<Junodoc__Junodoc_Schedule_Action__c> deleteScheduleActionList = new list<Junodoc__Junodoc_Schedule_Action__c>();
                                                   deleteScheduleActionList = [select id,Name,Junodoc__Junodoc_Users_Email_Addresses__c, Junodoc__Junodoc_Contacts_Email_Addresses__c, 
                                                                               Junodoc__Junodoc_Email_Addresses__c, Junodoc__Junodoc_From_Email_Address__c,
                                                                               Junodoc__Junodoc_Set_Reply_To__c, Junodoc__Junodoc_Set_Sender_Display_Name__c,
                                                                               Junodoc__Junodoc_Email_Fields__c, Junodoc__Junodoc_Available_Doc_Template__c, Junodoc__Junodoc_Doc_Email_Template__c, 
                                                                               Junodoc__Junodoc_Standard_Email_Template__c, Junodoc__Junodoc_Email_Subject__c, Junodoc__Junodoc_Save_as_Activity__c, Junodoc__Junodoc_Is_Send__c, Junodoc__Junodoc_Is_Attach__c,
                                                                               Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c, Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                                                               From Junodoc__Junodoc_Schedule_Action__c 
                                                                               Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                                                              ];
                                                   if(deleteScheduleActionList.size()>0){
                                                       delete deleteScheduleActionList;
                                                   }
                                                   
                                                   list<Junodoc__Junodoc_Schedule_Action__c> ScheduleActionsList = new list<Junodoc__Junodoc_Schedule_Action__c>();
                                                   Junodoc__Junodoc_Schedule_Action__c obj = new Junodoc__Junodoc_Schedule_Action__c();
                                                   obj.Junodoc__Junodoc_Schedule_Template_Setting__c = JunoDocScheduleId;
                                                   obj.Junodoc__Junodoc_Users_Email_Addresses__c = UsersEmailAddresses;
                                                   obj.Junodoc__Junodoc_Contacts_Email_Addresses__c = ContactsEmailAddresses;
                                                   obj.Junodoc__Junodoc_Email_Addresses__c = EmailAddresses;
                                                   obj.Junodoc__Junodoc_From_Email_Address__c = FromEmailAddress;
                                                   obj.Junodoc__Junodoc_Set_Reply_To__c = SetReplyTo;
                                                   obj.Junodoc__Junodoc_Set_Sender_Display_Name__c = SetSenderDisplayName;
                                                   obj.Junodoc__Junodoc_Email_Fields__c = EmailFields;
                                                   obj.Junodoc__Junodoc_Available_Doc_Template__c = AvailableDocTemplate;
                                                   obj.Junodoc__Junodoc_Doc_Email_Template__c = JunoDocEmailTemplate;
                                                   obj.Junodoc__Junodoc_Standard_Email_Template__c = StandardEmailTemplate;
                                                   obj.Junodoc__Junodoc_Email_Subject__c = EmailSubject;
                                                   obj.Junodoc__Junodoc_Save_as_Activity__c = Boolean.valueOf(SaveAsActivity);
                                                   obj.Junodoc__Junodoc_Is_Send__c = Boolean.valueOf(IsSendEmail);
                                                   obj.Junodoc__Junodoc_Is_Attach__c = Boolean.valueOf(IsAttachEmail);
                                                   ScheduleActionsList.add(obj);
                                                   
                                                   try{                
                                                       //system.debug('ScheduleActionsList--->'+ScheduleActionsList);
                                                       insert ScheduleActionsList;
                                                       message = 'Schedule Updated with Action!';
                                                       
                                                       list<Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c> junodocAddEmailRecipientsList = new list<Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c>();
                                                       for(Object record : AddEmailRecipientsList){ 
                                                           Map<Object, Object> recordMap = (Map<Object, Object>) record;
                                                           //System.debug('record  '+recordMap);
                                                           Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c rec = new Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c();
                                                           rec.Junodoc__Junodoc_Row_Number__c = Integer.Valueof(recordMap.get('indx'));
                                                           rec.Junodoc__Junodoc_To_Cc_Bcc__c = String.Valueof(recordMap.get('ToCCBCC'));
                                                           rec.Junodoc__Junodoc_Reference_Type__c = String.Valueof(recordMap.get('ReferenceType'));
                                                           rec.Junodoc__Junodoc_Email_Label_Values__c = String.Valueof(recordMap.get('EmailValue'));
                                                           rec.Junodoc__Junodoc_Email_API_Name_Values__c = String.Valueof(recordMap.get('FinalFieldDetails'));
                                                           rec.Junodoc__Junodoc_Schedule_Action__c = ScheduleActionsList[0].Id;
                                                           junodocAddEmailRecipientsList.add(rec);
                                                           
                                                       }
                                                       
                                                       try{
                                                           if(ScheduleActionsList[0].Id!=null){            
                                                               list<Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c> deleteAddEmailRecipientList = new list<Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c>();
                                                               deleteAddEmailRecipientList = [select id,Name,Junodoc__Junodoc_Row_Number__c,Junodoc__Junodoc_Email_Label_Values__c,
                                                                                              Junodoc__Junodoc_To_Cc_Bcc__c,Junodoc__Junodoc_Reference_Type__c, Junodoc__Junodoc_Schedule_Action__c
                                                                                              from Junodoc__Junodoc_Add_Email_Recipient_For_Schedule__c 
                                                                                              Where Junodoc__Junodoc_Schedule_Action__r.Id=:JunoDocScheduleRec.Id
                                                                                             ];
                                                               if(deleteAddEmailRecipientList.size()>0){
                                                                   delete deleteAddEmailRecipientList;
                                                                   
                                                               }
                                                           }
                                                           
                                                           insert junodocAddEmailRecipientsList;
                                                           //System.debug('junodocAddEmailRecipientsList '+junodocAddEmailRecipientsList);
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
    
    
    @AuraEnabled
    public static string saveScheduleSetup(string ScheduleName, String SchedulerType, String ScheduleHour, List<String> ScheduleDates, List<String> ScheduleDays,List<String>ScheduleMonths, String ScheduledClockFormat){
        //System.debug('ScheduleName----->'+ScheduleName);
        //System.debug('SchedulerType----->'+SchedulerType);
        //System.debug('ScheduleHour----->'+ScheduleHour);
        //System.debug('ScheduleDates----->'+ScheduleDates);
        //System.debug('ScheduleDays----->'+ScheduleDays);
        //system.debug('ScheduleMonths----->'+ScheduleMonths);
        //System.debug('ScheduledClockFormat------>'+ScheduledClockFormat);
        
        String SchDays = '';
        if(SchedulerType == 'Weekly'){
            Boolean Start = true;
            if(!ScheduleDays.isEmpty()) {
                for(String Str : ScheduleDays){
                    if(Start) {
                        SchDays = Str;
                        Start = false;
                    }
                    else{
                        SchDays = SchDays + ';' + Str;
                    }
                }
            }
        }
        
        String SchDates = '';
        String SchMonths = '';
        if(SchedulerType == 'Monthly'){
            Boolean Start2 = true;
            if(!ScheduleDates.isEmpty()) {
                for(String Str : ScheduleDates){
                    if(Start2) {
                        SchDates = Str;
                        Start2 = false;
                    }
                    else{
                        SchDates = SchDates + ';' + Str;
                    }
                }
            }
            
            Boolean Start3 = true;
            if(!ScheduleMonths.isEmpty()) {
                for(String Str : ScheduleMonths){
                    if(Start3) {
                        SchMonths = Str;
                        Start3 = false;
                    }
                    else{
                        SchMonths = SchMonths + ';' + Str;
                    }
                }
            }
        }
        
        
        string message='';
        
        Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                    Junodoc__Junodoc_Selected_Criteria__c,Junodoc__Junodoc_IsActive__c                                                                    
                                                                                    from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                    Where Name =:ScheduleName
                                                                                   ];
        if(JunoDocSchedulesList.size()>0){
            JunoDocScheduleRec = JunoDocSchedulesList[0];
        }
        
        id JunoDocScheduleId = JunoDocScheduleRec.Id;
        
        if(JunoDocScheduleId!=null){
            list<Junodoc__Junodoc_Schedule_Scheduler_Setup__c> deleteScheduleSetUpList = new list<Junodoc__Junodoc_Schedule_Scheduler_Setup__c>();
            deleteScheduleSetUpList = [select id,Name,Junodoc__Junodoc_Scheduler_Type__c,Junodoc__Junodoc_Selected_Schedule_Date__c,
                                       Junodoc__Junodoc_Selected_Schedule_Day__c,Junodoc__Junodoc_Selected_Schedule_Hour__c,Junodoc__Junodoc_Selected_Schedule_Month__c, Junodoc__Junodoc_Clock_Format__c, Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                       From Junodoc__Junodoc_Schedule_Scheduler_Setup__c 
                                       Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                      ];
            if(deleteScheduleSetUpList.size()>0){
                delete deleteScheduleSetUpList;
            }
            list<Junodoc__Junodoc_Schedule_Scheduler_Setup__c> ScheduleSetUpList = new list<Junodoc__Junodoc_Schedule_Scheduler_Setup__c>();
            
            Junodoc__Junodoc_Schedule_Scheduler_Setup__c ScheduleSetup = new Junodoc__Junodoc_Schedule_Scheduler_Setup__c();
            ScheduleSetup.Junodoc__Junodoc_Scheduler_Type__c = SchedulerType;
            ScheduleSetup.Junodoc__Junodoc_Selected_Schedule_Date__c = SchDates;
            ScheduleSetup.Junodoc__Junodoc_Selected_Schedule_Day__c = SchDays;
            ScheduleSetup.Junodoc__Junodoc_Selected_Schedule_Month__c = SchMonths;
            ScheduleSetup.Junodoc__Junodoc_Selected_Schedule_Hour__c = ScheduleHour;
            ScheduleSetup.Junodoc__Junodoc_Schedule_Template_Setting__c = JunoDocScheduleId;
            ScheduleSetup.Junodoc__Junodoc_Clock_Format__c= ScheduledClockFormat;
            ScheduleSetUpList.add(ScheduleSetup);
            try{                
                //system.debug('ScheduleSetUpList--->'+ScheduleSetUpList);
                insert ScheduleSetUpList;
                
                message = 'Schedule Updated with Schedule SetUp!';
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            } 
        }
        return message;
    }
    
    
    @AuraEnabled
    public static string savePostScheduleActions(string ObjectName, string ScheduleName, list<Object> records){
        
        //system.debug('ObjectName---->'+ObjectName);
        //system.debug('records---->'+records);
        
        string message='';
        Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocScheduleRec = new Junodoc__Junodoc_Schedule_Template_Setting__c();
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                    Junodoc__Junodoc_Selected_Criteria__c,Junodoc__Junodoc_IsActive__c                                                                       
                                                                                    from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                    Where Name =:ScheduleName
                                                                                   ];
        if(JunoDocSchedulesList.size()>0){
            JunoDocScheduleRec = JunoDocSchedulesList[0];
        } 
        id JunoDocScheduleId = JunoDocScheduleRec.Id;             
        if(JunoDocScheduleId!=null){            
            list<Junodoc__Junodoc_Post_Schedule_Action__c> deleteRecordsList = new list<Junodoc__Junodoc_Post_Schedule_Action__c>();
            deleteRecordsList = [select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Value__c,
                                 Junodoc__Junodoc_Schedule_Template_Setting__r.Name,
                                 Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c
                                 From Junodoc__Junodoc_Post_Schedule_Action__c 
                                 Where Junodoc__Junodoc_Schedule_Template_Setting__r.Name=:ScheduleName
                                ];
            if(deleteRecordsList.size()>0){
                delete deleteRecordsList;
            }
            list<Junodoc__Junodoc_Post_Schedule_Action__c> PostScheduleActionsList = new list<Junodoc__Junodoc_Post_Schedule_Action__c>();
            for(Object Item : records){            
                Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                string field = String.Valueof(ItemMap.get('Field'));
                string fieldValue = String.Valueof(ItemMap.get('Value'));                
                Junodoc__Junodoc_Post_Schedule_Action__c obj = new Junodoc__Junodoc_Post_Schedule_Action__c();
                obj.Junodoc__Junodoc_Schedule_Template_Setting__c = JunoDocScheduleId;
                obj.Junodoc__Junodoc_Field__c = field;
                obj.Junodoc__Junodoc_Value__c = fieldValue;
                PostScheduleActionsList.add(obj);                
            }
            
            
            try{                
                //system.debug('PostScheduleActionsList--->'+PostScheduleActionsList);
                insert PostScheduleActionsList;
                message = 'Schedule updated with post schedule action values!';               
            }catch(exception e){
                system.debug('error--->'+e.getMessage());
            }               
        }                    
        
        return message;                                                 
    }
    
    
    
    @AuraEnabled
    public static string deleteJunoDocSchedule(string ScheduleName){
        //system.debug('ScheduleName---->'+ScheduleName);
        string message='';
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                    Junodoc__Junodoc_Selected_Criteria__c                                                                         
                                                                                    from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                    Where Name =:ScheduleName
                                                                                   ];
        
        try{                
            if(JunoDocSchedulesList.size()>0){
                delete JunoDocSchedulesList;
            } 
            message = 'Schedule Deleted Successfully!';
        }catch(exception e){
            system.debug('error--->'+e.getMessage());
        }                                           
        
        return message; 
        
    }
    
    @AuraEnabled
    public static string updateScheduleStatus(string toogleValue, string ScheduleName){
        //system.debug('ScheduleName---->'+ScheduleName);
        string message='';
        Junodoc__Junodoc_Schedule_Template_Setting__c JunoDocSchedulerec;
        list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                    Junodoc__Junodoc_Selected_Criteria__c,Junodoc__Junodoc_IsActive__c                                                                        
                                                                                    from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                    Where Name =:ScheduleName
                                                                                   ];
        
        try{
            if(JunoDocSchedulesList.size()>0){
                JunoDocSchedulerec = JunoDocSchedulesList[0];
                JunoDocSchedulerec.Junodoc__Junodoc_IsActive__c = Boolean.valueOf(toogleValue);
                update JunoDocSchedulerec;
                if(toogleValue=='true'){
                    message = 'Schedule is activated successfully!';    
                }else{
                    message = 'Schedule is deactivated successfully!';    
                }
                
            } 
            
        }catch(exception e){
            system.debug('error--->'+e.getMessage());
        }                                          
        
        return message; 
        
    }
}
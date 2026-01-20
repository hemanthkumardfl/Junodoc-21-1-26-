public class JunodocBatchController {
     public class TriggerActionWrapper{
        @AuraEnabled public Juno_Doc_Trigger__c JunoDocTriggerRec;
        @AuraEnabled public list<ConditionWrapper> TriggerConditionsList;
        @AuraEnabled public list<PostActionWrapper>PostTriggerActionsList;
        @AuraEnabled public Juno_Doc_Trigger_Action__c TriggerActionRec;
        //@AuraEnabled public list<ConditionWrapper> TriggerConditionsList;        
        @AuraEnabled public List<FieldWrapper> ObjectFieldsWrapper;
        @AuraEnabled public list<pickListValuesWrapper> EmailFields;
        @AuraEnabled public list<pickListValuesWrapper> AvailableDocTemplatesList;
        @AuraEnabled public list<pickListValuesWrapper> StandardEmailTemplatesList;
        @AuraEnabled public list<pickListValuesWrapper> JunoDocEmailTemplatesList;
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
    
    public class PostActionWrapper{
        @AuraEnabled public Integer RowNumber;
        @AuraEnabled public String Field;
        @AuraEnabled public String Value;
        @AuraEnabled public String type;
        @AuraEnabled public boolean isPicklist=false;
        @AuraEnabled public boolean isBoolean =false;
        
    }           
    @AuraEnabled
    public static TriggerActionWrapper getTriggerAction(string ObjectName) {
        TriggerActionWrapper TriggerActionWrapper = new TriggerActionWrapper();
        
        // to display picklist values 
        list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
        SelectOptionFieldsList=JunodocBatchController.getSelectOptionFields(ObjectName);
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
        list<Juno_Doc_Trigger__c> TriggerRecordsList  = New list<Juno_Doc_Trigger__c>();
        if(Schema.SObjectType.Juno_Doc_Trigger__c.fields.Name.isAccessible()){
        TriggerRecordsList = [select id,Name,Object_Name__c,
                                                        Trigger_Conditions_Formula__c, IsActive__c                                                                       
                                                        from Juno_Doc_Trigger__c 
                                                        Where Object_Name__c =: ObjectName
                                                       ];
        }
        if(TriggerRecordsList.size()>0){
            JunoDocTriggerRec = TriggerRecordsList[0];
        } 
        
        
        
        List<ConditionWrapper> TriggerConditionsWrapper = new List<ConditionWrapper>();        
        list<Juno_Doc_Trigger_Condition__c> TriggerConidtionsList = [select id,Name,Field__c, Operator__c, Value__c,
                                                                     Juno_Doc_Trigger__r.Object_Name__c,
                                                                     RowNumber__c
                                                                     From Juno_Doc_Trigger_Condition__c 
                                                                     Where Juno_Doc_Trigger__r.Object_Name__c=:ObjectName
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
                
                SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
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
        list<Juno_Doc_Trigger_Action__c> TriggerActionsList =  [select id,Name,Users_Email_Addresses__c, Contacts_Email_Addresses__c, Email_Addresses__c,
                                                                Email_Fields__c, Available_Doc_Template__c, Juno_Doc_Email_Template__c, 
                                                                Standard_Email_Template__c, Email_Subject__c, Save_as_Activitiy__c,
                                                                Juno_Doc_Trigger__r.Object_Name__c
                                                                From Juno_Doc_Trigger_Action__c 
                                                                Where Juno_Doc_Trigger__r.Object_Name__c=:ObjectName
                                                               ];
        if(TriggerActionsList.size()>0){
            TriggerActionRec = TriggerActionsList[0];
        }             
        
        
        
        List<PostActionWrapper> PostTriggerActionsWrapper = new List<PostActionWrapper>();        
        list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList = [select id,Name,Field__c, Value__c,
                                                                        Juno_Doc_Trigger__r.Object_Name__c
                                                                        From Juno_Doc_Post_Trigger_Action__c 
                                                                        Where Juno_Doc_Trigger__r.Object_Name__c=:ObjectName
                                                                        limit 49000
                                                                       ];
        if(PostTriggerActionsList.size() > 0){
            for(integer i=0;i<PostTriggerActionsList.size();i++){
                PostActionWrapper obj = new PostActionWrapper();
                string fieldName = PostTriggerActionsList[i].Field__c;
                SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()); 
                System.debug('****fieldType****'+fieldType);
                obj.RowNumber = (i+1);
                obj.Field = fieldName;
                obj.Value = PostTriggerActionsList[i].Value__c; 
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
                PostTriggerActionsWrapper.add(obj);                
            }
        }         
        
        
        
        
        
        
        
        TriggerActionWrapper.JunoDocTriggerRec = JunoDocTriggerRec;
        TriggerActionWrapper.TriggerConditionsList = TriggerConditionsWrapper;
        TriggerActionWrapper.TriggerActionRec = TriggerActionRec;
        TriggerActionWrapper.PostTriggerActionsList = PostTriggerActionsWrapper;
        TriggerActionWrapper.ObjectFieldsWrapper = SelectOptionFieldsList;
        
        return TriggerActionWrapper;
        
    }
    @AuraEnabled
    public static string savePostTriggerActions(string ObjectName, 
                                                list<Object> records,list<string> selectedRecordIds){
                                                    system.debug('ObjectName---->'+ObjectName);
                                                    system.debug('records---->'+records);
                                                    string message='';
                                                    Juno_Doc_Trigger__c JunoDocTriggerRec = new Juno_Doc_Trigger__c();
                                                    list<Juno_Doc_Trigger__c> JunoDocTriggersList = [select id,Name,Object_Name__c,
                                                                                                     Trigger_Conditions_Formula__c                                                                         
                                                                                                     from Juno_Doc_Trigger__c 
                                                                                                     Where Object_Name__c =: ObjectName
                                                                                                    ];
                                                    if(JunoDocTriggersList.size()>0){
                                                        JunoDocTriggerRec = JunoDocTriggersList[0];
                                                    } 
                                                    id JunoDocTriggerId = JunoDocTriggerRec.Id;             
                                                    if(JunoDocTriggerId!=null){            
                                                        list<Juno_Doc_Post_Trigger_Action__c> deleteRecordsList = new list<Juno_Doc_Post_Trigger_Action__c>();
                                                        deleteRecordsList = [select id,Name,Field__c, Value__c,
                                                                             Juno_Doc_Trigger__r.Object_Name__c
                                                                             From Juno_Doc_Post_Trigger_Action__c 
                                                                             Where Juno_Doc_Trigger__r.Object_Name__c=:ObjectName
                                                                            ];
                                                        if(deleteRecordsList.size()>0){
                                                            delete deleteRecordsList;
                                                        }
                                                    }   
                                                        list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList = new list<Juno_Doc_Post_Trigger_Action__c>();
                                                        set<string> fieldsList = new set<string>();
                                                        list<sObject> sobjectList = new list<sObject>();
                                                        string fields = '';
                                                        for(Object Item : records){
                                                            Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                                                            string field = String.Valueof(ItemMap.get('Field')); 
                                                            fields = fields + field+',';     
                                                            fieldsList.add(field);
                                                            /* Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
string field = String.Valueof(ItemMap.get('Field'));
string fieldValue = String.Valueof(ItemMap.get('Value'));                
Juno_Doc_Post_Trigger_Action__c obj = new Juno_Doc_Post_Trigger_Action__c();
obj.Juno_Doc_Trigger__c = JunoDocTriggerId;
obj.Field__c = field;
obj.Value__c = fieldValue;
sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject();
sObj.put(field, fieldValue) ;
sobjectList.add(sObj);
PostTriggerActionsList.add(obj);       */         
                                                        }
                                                        System.debug(selectedRecordIds);
                                                        String strQuery = 'select '+fields+'id' +' from '+ObjectName+' where id IN: selectedRecordIds ';
                                                        System.debug(strQuery);
                                                        List<sObject> sobjListt = database.query(strQuery);
                                                        List<sObject> newSObjectList = new List<sObject>();
                                                        System.debug(sobjListt);
                                                        for(SObject obj: sobjListt){
                                                            for(Object Item : records){
                                                                Map<Object, Object> ItemMap = (Map<Object, Object>) Item;
                                                                string field = String.Valueof(ItemMap.get('Field')); 
                                                                string fieldValue = String.Valueof(ItemMap.get('Value'));  
                                                                SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectName).newInstance())).getSObjectType();
                                                                DescribeSObjectResult d = r.getDescribe();
                                                                string fieldType = string.valueOf(d.fields.getMap().get(field).getDescribe().getType());      
                                                                fieldsList.add(field);
                                                                if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY'){
                                                                    if(fieldValue.contains(',')){
                                                                        fieldValue = fieldValue.replaceAll(',', '');
                                                                    }  
                                                                    obj.put(field, Decimal.valueOf(fieldValue));
                                                                }else if(fieldType == 'INTEGER'){
                                                                    if(fieldValue.contains(',')){
                                                                        fieldValue = fieldValue.replaceAll(',', '');
                                                                    }  
                                                                    obj.put(field, Integer.valueOf(fieldValue));
                                                                }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                                                                    if(fieldValue!=null && fieldValue!='' && fieldValue!='null'){
                                                                        try{
                                                                            if(fieldValue.contains('day')==true || fieldValue.contains('DAY')==true){
                                                                                if(fieldValue=='today' || fieldValue=='TODAY' || fieldValue=='Today'){
                                                                                   obj.put(field, System.Today());
                                                                                }
                                                                                else if(fieldValue=='yesterday' || fieldValue=='YESTERDAY'){
                                                                                   obj.put(field, System.Today()-1);
                                                                                }
                                                                                   
                                                                            }else{
                                                                                date dateformat = date.parse(fieldValue);
                                                                                obj.put(field, dateformat );  
                                                                            }

                                                                        }catch(Exception e){
                                                                            system.debug('exception--->'+e.getMessage());
                                                                        }
                                                                    }
                                                                    
                                                                }else if(fieldType == 'ID'){
                                                                    if(fieldValue=='null'){
                                                                        fieldValue = null+'';
                                                                    }
                                                                    System.debug(fieldValue);
                                                                    obj.put(field, fieldValue);
                                                                }else if(fieldType == 'BOOLEAN'){
                                                                    Boolean b = Boolean.valueOf(fieldValue);
                                                                    obj.put(field, b);
                                                                    
                                                                }else{
                                                                    obj.put(field, fieldValue);
                                                                }
                                                                System.debug(obj);
                                                                
                                                            }
                                                            newSObjectList.add(obj);
                                                        }
                                                        
                                                        
                                                        try{      
                                                            update newSObjectList;               
                                                            system.debug('sobjectlist--->'+newSObjectList);
                                                            //insert PostTriggerActionsList;
                                                            message = 'Successfully updated fields!';               
                                                        }catch(exception e){
                                                            system.debug('error--->'+e.getMessage());
                                                        }               
                                                                       
                                                    
                                                    return message;                                                 
                                                }
    
    
    
    
    @AuraEnabled(cacheable=true)
    public static  list<pickListValuesWrapper> getPageloadDataHelper(){
        list<pickListValuesWrapper> ObjectsList=new list<pickListValuesWrapper>();
        try{
            
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
                try{
                    if(!objName[0].contains('not found')){
                        pw.label = objName[0]; 
                        ObjectsList.add(pw); 
                    }
                }
                catch(Exception e){
                    system.debug('exception e--->'+e.getMessage()); 
                }
            }            
            
            system.debug('ObjectsList---->'+ObjectsList);
        }catch(Exception e){
            system.debug('exception e--->'+e.getMessage());
        }
        return ObjectsList;
    }
    
    public class pickListValuesWrapper{        
        @AuraEnabled public String label; 
        @AuraEnabled public String value;         
    }    
    
    public class FieldWrapper{        
        @AuraEnabled public String value;
        @AuraEnabled public String label;  
        @AuraEnabled public String type;
        @AuraEnabled public boolean isPicklist=false;
        @AuraEnabled public boolean isBoolean =false;
    }   
    
    
    @AuraEnabled
    public static list<FieldWrapper> getObjectDataHelper(string ObjectName) {
        list<FieldWrapper> SelectOptionFieldsList=new list<FieldWrapper>();
        SelectOptionFieldsList=JunodocBatchController.getSelectOptionFields(ObjectName);
        return SelectOptionFieldsList;
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
    
    public class filterConditionWrapper{
        @AuraEnabled public String field{get;set;}
        @AuraEnabled public String Operator{get;set;}
        @AuraEnabled public String fieldValue{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public Integer RowNumber{get;set;}
        
        /*public filterConditionWrapper(String field,String Operator,String fieldValue,String type,Integer RowNumber){
this.field=field;
this.Operator=Operator;
this.fieldValue=fieldValue;
this.type=type;
this.RowNumber=RowNumber;
}*/
    }
    
    @AuraEnabled 
    public static batchWrapper getAllRecords(String selectedObject,String listOfRecords,String filterCons){
        system.debug('selectedObject--->'+selectedObject);
        system.debug('listOfRecords--->'+listOfRecords);
        system.debug('filterCons--->'+filterCons);
        List<filterConditionWrapper> lstOfFilterConditions = (List<filterConditionWrapper>)System.JSON.deserialize(listOfRecords, List<filterConditionWrapper>.class);
        system.debug('lstOfFilterConditions '+lstOfFilterConditions);
        String filterQuery='';
        Boolean isWhere=false;
        integer index=1; 
        String Query = '';
        for(filterConditionWrapper condition:lstOfFilterConditions){
            system.debug('row number--->'+condition.RowNumber);
            filterCons = filterCons.replace(condition.RowNumber+'','@$$'+index);                                        
            index++;
        }
        index=1;                
        system.debug('filterCons--->'+filterCons);
        for(filterConditionWrapper condition : lstOfFilterConditions){
            string fieldName = condition.field;
            string Operator = condition.Operator;
            string fieldValue = condition.fieldValue;
            System.debug('****Operator****'+Operator);
            SObjectType r = ((SObject)(Type.forName('Schema.'+selectedObject).newInstance())).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()); 
            System.debug('****fieldType****'+fieldType);
            if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                if(fieldValue.contains(',')){
                    fieldValue = fieldValue.replaceAll(',', '');
                }  
            }
            else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                if(fieldValue!=null && fieldValue!='' && fieldValue!='null'){
                    try{
                        date dateformat = date.parse(fieldValue);
                        string year = dateformat.year()+'';
                        string month = '';
                        if(dateformat.month()<10){ month = '0'+dateformat.month()+'';}
                        else{ month = dateformat.month()+''; }
                        
                        string day = '';
                        if(dateformat.day()<10){ day = '0'+dateformat.day()+'';  }
                        else{ day = dateformat.day()+''; }
                        fieldValue = year +'-' + month + '-' +day;                                
                    }catch(Exception e){
                        system.debug('exception--->'+e.getMessage());
                    }
                }
            }
            else if(fieldType == 'ID'){
                if(fieldValue=='null'){
                    fieldValue = null+'';
                }
                System.debug(fieldValue);
            }else if(fieldType == 'REFERENCE' ){ 
                if(fieldValue=='null' && fieldValue=='Null'){
                    fieldValue = null+'';
                }
                System.debug(fieldValue);  
            }
            list<string> valuesList = new list<string>();
            if(fieldValue.contains(',')){
                valuesList = fieldValue.split(',');
            } 
            if(fieldName!=null && Operator!=null &&
               fieldName.trim()!='' && Operator.trim()!='' ){
                   if(Operator=='Equals'){
                       if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                           if(fieldValue=='null'){
                               string str = 'null';
                               filterQuery=' '+fieldName+' = '+str;
                           }else{
                               filterQuery=' '+fieldName+' = '+decimal.valueOf(fieldValue); 
                           }
                           
                       }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                           filterQuery=' '+fieldName+' = '+fieldValue;
                       }else if(fieldType == 'BOOLEAN'){
                           filterQuery=' '+fieldName+' = '+fieldValue;
                       }else if(fieldType == 'PICKLIST' ){
                           if(fieldValue.contains(',')){
                               if(valuesList.size()>0){  
                                   string picklistEqualsQry ='';
                                   for(string pickListVal : valuesList){
                                       if(picklistEqualsQry==''){
                                           picklistEqualsQry = ' '+fieldName+' = \''+pickListVal+'\'';
                                       }else{
                                           picklistEqualsQry = picklistEqualsQry+' OR '+fieldName+' = \''+pickListVal+'\'';
                                       }
                                   }
                                   picklistEqualsQry = '( '+ picklistEqualsQry+' )';
                                   filterQuery=' '+picklistEqualsQry;
                               } 
                           }else{
                               filterQuery=' '+fieldName+' = \''+fieldValue+'\'';                                       
                           }                                    
                       }else if(fieldType == 'REFERENCE' ){ 
                           if(fieldValue!='null' && fieldValue!='Null'){
                               filterQuery=' '+fieldName+' = null'; 
                           }else{
                               filterQuery=' '+fieldName+' ='+fieldValue;  
                           }
                           
                       }else if(fieldType == 'ID'){
                           if(fieldValue=='null'){
                              string str = 'null';
                               filterQuery=' '+fieldName+' = '+str;
                           }
                            
                           System.debug(fieldValue);
                       }else{
                           filterQuery=' '+fieldName+' = \''+fieldValue+'\'';                                    
                       }          
                   }
                   else if(Operator=='Not Equal to'){
                       system.debug('**fieldType***'+fieldType);
                       if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                           if(fieldValue=='null'){
                               filterQuery=' '+fieldName+' !='+fieldValue;
                           }else{
                               filterQuery=' '+fieldName+' != '+decimal.valueOf(fieldValue); 
                           }
                           
                       }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                           filterQuery=' '+fieldName+' != '+fieldValue;
                       }else if(fieldType == 'BOOLEAN'){
                           filterQuery=' '+fieldName+' != '+fieldValue; 
                       }
                       else if(fieldType == 'PICKLIST' ){
                           system.debug('*****string***'+filterQuery);
                           if(fieldValue.contains(',')){
                               if(valuesList.size()>0){  
                                   string picklistEqualsQry ='';
                                   for(string pickListVal : valuesList){
                                       if(picklistEqualsQry==''){
                                           picklistEqualsQry = ' '+fieldName+' != \''+pickListVal+'\'';
                                       }else{
                                           picklistEqualsQry = picklistEqualsQry+' AND '+fieldName+' != \''+pickListVal+'\'';
                                       }
                                   }
                                   picklistEqualsQry = '( '+ picklistEqualsQry+' )';
                                   filterQuery=' '+picklistEqualsQry;
                               } 
                               
                           }else{
                               
                               filterQuery=' '+fieldName+' != \''+fieldValue+'\'';                                       
                           }
                           system.debug('*****query***'+filterQuery);
                       }
                       else if(fieldType == 'REFERENCE' ){ 
                           if(fieldValue!='null' && fieldValue!='Null'){
                               string str = 'null';
                               filterQuery=' '+fieldName+' != '+str; 
                           }else{
                               filterQuery=' '+fieldName+' !='+fieldValue;  
                           } system.debug('*****fieldValue***'+fieldValue);
                       }
                       else if(fieldType == 'ID'){
                           if(fieldValue=='null'){
                              string str = 'null';
                               filterQuery=' '+fieldName+' != '+str;
                           }
                            
                           System.debug(fieldValue);
                       } else{
                           system.debug('*****string***'+filterQuery);
                           filterQuery=' '+fieldName+' != \''+fieldValue+'\'';                                    
                       }
                       
                   }else if(Operator=='Contains'){
                       if(fieldValue.contains(',')){
                           if(valuesList.size()>0){  
                               string picklistEqualsQry ='';
                               for(string pickListVal : valuesList){
                                   if(picklistEqualsQry==''){
                                       picklistEqualsQry = ' '+fieldName+' Like \'%'+pickListVal+'%\'';
                                   }else{
                                       picklistEqualsQry = picklistEqualsQry+' OR '+' '+fieldName+' Like \'%'+pickListVal+'%\'';
                                   }
                               }
                               picklistEqualsQry = '( '+ picklistEqualsQry+' )';
                               filterQuery=' '+picklistEqualsQry;
                           }else{
                               filterQuery=' '+fieldName+' Like \'%'+fieldValue+'%\'';
                           } 
                       }else{
                           filterQuery=' '+fieldName+' Like \'%'+fieldValue+'%\'';
                       }                                
                   }else if(Operator=='Does not contain'){
                       if(fieldValue.contains(',')){
                           if(valuesList.size()>0){  
                               string picklistEqualsQry ='';
                               for(string pickListVal : valuesList){
                                   if(picklistEqualsQry==''){
                                       picklistEqualsQry = '(Not '+fieldName+' Like \'%'+pickListVal+'%\')';
                                   }else{
                                       picklistEqualsQry = picklistEqualsQry+' AND '+' (Not '+fieldName+' Like \'%'+pickListVal+'%\')';
                                   }
                               }
                               picklistEqualsQry = '( '+ picklistEqualsQry+' )';
                               filterQuery=' '+picklistEqualsQry;
                           }else{
                               filterQuery='(Not '+fieldName+' Like \'%'+fieldValue+'%\')';
                           } 
                       }else{
                           filterQuery='(Not '+fieldName+' Like \'%'+fieldValue+'%\')';      
                       }
                   }else if(Operator=='Greater than'){
                       filterQuery=' '+fieldName+' > '+fieldValue;
                   }else if(Operator=='Less than'){
                       filterQuery=' '+fieldName+' < '+fieldValue;
                   }else if(Operator=='Greater or equal'){
                       filterQuery=' '+fieldName+' >= '+fieldValue;
                   }else if(Operator=='Less or equal'){
                       filterQuery=' '+fieldName+' <= '+fieldValue;
                   }
                   
                   filterCons= filterCons.replace('@$$'+index,filterQuery);
                   index++;                            
               }
        }
        if(filterCons.trim()!=''){
            system.debug('Add Filter @@@@@@@ '+filterCons);
            if(filterCons.contains('null')){
                //filterCons = filterCons.replaceAll('\'','');
            }
            Query=' Where '+filterCons+' ';
        }
        system.debug('Query--->'+Query);
        String strQuery='';
        if(selectedObject=='Case'){
            strQuery = 'select id,CaseNumber,LastModifiedDate,createdDate from '+selectedObject+''+Query+' order by LastModifiedDate desc limit 500';  
        }else if(selectedObject == 'WorkOrder'){
            strQuery = 'select id,WorkOrderNumber,LastModifiedDate,createdDate from '+selectedObject+''+Query+' order by LastModifiedDate desc limit 500';  
        }else if(selectedObject == 'OpportunityContactRole'){
            strQuery = 'select id,LastModifiedDate,createdDate from '+selectedObject+''+Query+' order by LastModifiedDate desc limit 500';  
        }
        else{
            strQuery = 'select id,Name,LastModifiedDate,createdDate from '+selectedObject+''+Query+' order by LastModifiedDate desc limit 500';  
        }
        system.debug('Query--->'+strQuery);
        list<Object> recordsList = new list<Object>();
        recordsList= Database.query(strQuery);
        system.debug('recordsList--->'+recordsList);
        batchWrapper wrapper = new batchWrapper();
        wrapper.query = strQuery;
        wrapper.recordsList = recordsList;
        system.debug('wrapper.query-->'+wrapper.query);
        System.debug('wrapper  '+wrapper);
        return wrapper;
    }
    public class batchWrapper{
        @AuraEnabled public String query{get; set;}   
        @AuraEnabled public list<Object> recordsList{get; set;} 
        @AuraEnabled public Junodoc_Batch__c batchRecord{get; set;}
        @AuraEnabled public String message{get; set;}  
    }
    @AuraEnabled
    public static batchWrapper SaveQueryToObject(String batchId,String objectName,String query,string filterConditions,string filterCons,string type,string batchName){
        String msg = '';
        batchWrapper wrapper = new batchWrapper();
        List<filterConditionWrapper> lstOfFilterConditions = (List<filterConditionWrapper>)System.JSON.deserialize(filterConditions, List<filterConditionWrapper>.class);
        system.debug('lstOfFilterConditions '+lstOfFilterConditions);
        try{
            if(filterCons.trim()!=''){
                system.debug('Add Filter @@@@@@@ '+filterCons);
                if(filterCons.contains('null')){
                    filterCons = filterCons.replaceAll('\'','');
                }
            }
            list<Junodoc_Batch_Filter_Conditions__c> filterConditionList = new list<Junodoc_Batch_Filter_Conditions__c>();
            
            if(type=='Save'){
                list<Junodoc_Batch__c> batchList = [select id,name from Junodoc_Batch__c where name =:batchName];
                if(batchList.size()==0){
                    Junodoc_Batch__c batch = new Junodoc_Batch__c();
                    batch.Name = batchName;
                    batch.Object__c = objectName;
                    batch.Query__c = query;
                    batch.Filter_Conditions__c = filterCons;
                    insert batch; 
                    wrapper.batchRecord = batch;
                    msg = 'inserted record';
                    wrapper.message = msg;
                    for(filterConditionWrapper condition:lstOfFilterConditions){
                        system.debug('row number--->'+condition.RowNumber);
                        Junodoc_Batch_Filter_Conditions__c rec = new Junodoc_Batch_Filter_Conditions__c();
                        rec.Row_Number__c = condition.RowNumber;
                        rec.Junodoc_Batch__c = batch.Id;
                        rec.Field__c = condition.field;
                        rec.Field_Value__c = condition.fieldValue;
                        rec.Operator__c = condition.Operator;
                        rec.Type__c = condition.type;
                        filterConditionList.add(rec);
                    }
                    insert filterConditionList;
                    //return batch;
                }
                else{
                    msg=batchList+'Duplicate Batch Name'+batchName;
                    wrapper.message = msg;
                    // return null;
                }
            }
            else if(type=='Update'){
                Junodoc_Batch__c batchRec = [select id,Name,Object__c,Query__c,Filter_Conditions__c from Junodoc_Batch__c where id=:batchId limit 1];
                batchRec.Name = batchName;
                batchRec.Object__c = objectName;
                batchRec.Query__c = query;
                batchRec.Filter_Conditions__c = filterCons;
                update batchRec; 
                msg = 'updated record';
                wrapper.batchRecord = batchRec;
                wrapper.message = msg;
                list<Junodoc_Batch_Filter_Conditions__c> filterList = [select id,Row_Number__c,Junodoc_Batch__c,Field__c,Field_Value__c,Operator__c,Type__c from Junodoc_Batch_Filter_Conditions__c
                                                                       where Junodoc_Batch__c=:batchId];
                delete filterList;
                for(filterConditionWrapper condition:lstOfFilterConditions){
                    system.debug('row number--->'+condition.RowNumber);
                    Junodoc_Batch_Filter_Conditions__c rec = new Junodoc_Batch_Filter_Conditions__c();
                    rec.Row_Number__c = condition.RowNumber;
                    rec.Junodoc_Batch__c = batchRec.Id;
                    rec.Field__c = condition.field;
                    rec.Field_Value__c = condition.fieldValue;
                    rec.Operator__c = condition.Operator;
                    rec.Type__c = condition.type;
                    filterConditionList.add(rec);
                }
                insert filterConditionList;
                //return batchRec;
            }
            
        }
 
    catch(exception e){
        System.debug(e.getmessage());
        msg = e.getmessage();
        wrapper.message = msg;
    }
    return wrapper;
}
@AuraEnabled
public static list<pickListValuesWrapper> getQueryBatch(String objectName){
    list<pickListValuesWrapper> JunodocBatchNamesList = new list<pickListValuesWrapper>();
    list<String> namesList = new list<String>();
    list<Junodoc_Batch__c> junodocBatchList = new list<Junodoc_Batch__c>([select Name,Object__c from Junodoc_Batch__c where Object__c =: objectName]);
    pickListValuesWrapper op = new pickListValuesWrapper();
    op.label = '--None--';
    op.value = '--None--';
    JunodocBatchNamesList.add(op);
    for(Junodoc_Batch__c rec:junodocBatchList){
        pickListValuesWrapper wrapper = new pickListValuesWrapper();
        wrapper.label = rec.Name;
        wrapper.value = rec.Id;
        JunodocBatchNamesList.add(wrapper);
    }
    return JunodocBatchNamesList;
}
public class ExecuteSearchWrapper{
    @AuraEnabled public list<Object> recordsList {get;set;}
    @AuraEnabled public list<filterConditionWrapper> filterConditionWrapperList {get;set;}
    @AuraEnabled public Junodoc_Batch__c batchRecord {get;set;}
}
@AuraEnabled
public static ExecuteSearchWrapper ExecuteSearchQuery(String batchId){
    System.debug('batchId'+batchId);
    ExecuteSearchWrapper wrapper = new ExecuteSearchWrapper();
    Junodoc_Batch__c batch = new Junodoc_Batch__c();
    batch = [select id,Name,Query__c,Filter_Conditions__c from Junodoc_Batch__c where id =: batchId];
    string strQuery = batch.Query__c;
    wrapper.batchRecord = batch;
    list<Object> recordsList = new list<Object>();
    recordsList= Database.query(strQuery);
    system.debug('recordsList--->'+recordsList);
    list<Junodoc_Batch_Filter_Conditions__c> filterConditions = [select id,Field__c,Field_Value__c,Operator__c,Row_Number__c,Type__c,Junodoc_Batch__c
                                                                 from Junodoc_Batch_Filter_Conditions__c
                                                                 where Junodoc_Batch__c =: batch.Id];
    list<filterConditionWrapper> conditionWrapperList = new list<filterConditionWrapper>();
    for(Junodoc_Batch_Filter_Conditions__c filter : filterConditions){
        filterConditionWrapper wrap = new filterConditionWrapper();
        wrap.RowNumber = Integer.valueOf(filter.Row_Number__c);
        wrap.field = filter.Field__c;
        wrap.fieldValue = filter.Field_Value__c;
        wrap.Operator = filter.Operator__c;
        wrap.type = filter.Type__c;                                                                                                                                                                                                                                     
        conditionWrapperList.add(wrap);
        
    }
    wrapper.recordsList = recordsList;
    wrapper.filterConditionWrapperList = conditionWrapperList;
    return wrapper;
}
@AuraEnabled
public static InnerDocTemplates getAvailableDocTemplates(string sObjName,Id recordId,string batchId){
    string TemplateID = '';
    Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
    
    string DocTemplateField = '' ;
    
    DocTemplateField = string.valueOf(objectFieldsMap.get('JunoDoc__Doc_Template__c'));
    if(DocTemplateField == null || DocTemplateField == ''){
        DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
    }
    System.debug('DocTemplateField ' + DocTemplateField);  
    if(DocTemplateField=='JunoDoc__Doc_Template__c' || DocTemplateField=='Doc_Template__c'){
        string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: recordId' ;
        sobject NewQuote = Database.query(Newqueries);
        System.debug('NewQuote ' + NewQuote); 
        TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
        System.debug('TemplateID ' + TemplateID);  
        if(TemplateID==null){
            TemplateID='';
        }            
    }
    
    list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
    list<Doc_Template__c> availableDocList = New list<Doc_Template__c> ();
    if(Schema.sObjectType.Doc_Template__c.fields.Parent_Object__c.isAccessible() && Schema.sObjectType.Doc_Template__c.fields.Parent_Fields__c.isAccessible()
              && Schema.sObjectType.Doc_Template__c.fields.Name.isAccessible() && Schema.sObjectType.Doc_Template__c.fields.Template_Type__c.isAccessible()){
    availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c,Template_Type__c
                                              from Doc_Template__c 
                                              where Parent_Object__c =: sObjName];
              }
    /*New Code start
list<Email_Template__c> availableEmailList = [select id,Name,Parent_Object__c,Parent_Fields__c 
from Email_Template__c 
where Parent_Object__c =: sObjName];
//New Code End */
    if(availableDocList.size()>0){
        for(Doc_Template__c rec : availableDocList){
            DocTemplatesWrap obj = new DocTemplatesWrap();
            obj.label = rec.Name;
            obj.value = rec.id; 
            obj.type= rec.Template_Type__c;
            AvailableDocTemplatesList.add(obj);
        }            
    }
    InnerDocTemplates inn = new InnerDocTemplates();
    inn.AvailableDocTemplatesList = AvailableDocTemplatesList;
    inn.DocTemplateId = TemplateID;
    
    if(batchId!='' && batchId!=null){
        list<Junodoc_Batch_Settings__c> JunosettingsList = new list<Junodoc_Batch_Settings__c>();
         if(Schema.sObjectType.Junodoc_Batch_Settings__c.fields.JunoDoc__Junodoc_Templates__c.isAccessible() && Schema.sObjectType.Junodoc_Batch_Settings__c.fields.Junodoc_Batch__c.isAccessible()
              && Schema.sObjectType.Junodoc_Batch_Settings__c.fields.SOQL_Query__c.isAccessible() && Schema.sObjectType.Junodoc_Batch_Settings__c.fields.Report_ID__c.isAccessible()){
                              JunosettingsList = [select id,
                                                            JunoDoc__Junodoc_Templates__c,Junodoc_Batch__c,
                                                            JunoDoc__Junodoc_Templates__r.parent_Object__c,
                                                            SOQL_Query__c,
                                                            Report_ID__c
                                                            from Junodoc_Batch_Settings__c
                                                            where Junodoc_Batch__c =: batchId order by CreatedDate desc limit 1];
              }
        if(JunosettingsList.size()>0){
            list<Junodoc_Post_Trigger_Actions__c> TriggerActions = New list<Junodoc_Post_Trigger_Actions__c> ();
            if(Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Field_Name__c.isAccessible() && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Row_Number__c.isAccessible()
              && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Value__c.isAccessible() && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Junodoc_Batch_Settings__c.isAccessible()){
            TriggerActions = [select id,Field_Name__c,Row_Number__c,Value__c,Junodoc_Batch_Settings__c
                                                                    from Junodoc_Post_Trigger_Actions__c 
                                                                    where Junodoc_Batch_Settings__c=:JunosettingsList[0].Id];
            }
            list<PostActionWrapper> PostActionWrapperList = new list<PostActionWrapper>();
            for(Junodoc_Post_Trigger_Actions__c action:TriggerActions){
                string fieldName = action.Field_Name__c;
                string fieldValue = action.Value__c;
                SObjectType r = ((SObject)(Type.forName('Schema.'+sObjName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType()); 
                System.debug('****fieldType****'+fieldType);
                PostActionWrapper wrapper = new PostActionWrapper();
                wrapper.Field = action.Field_Name__c;
                wrapper.Value = action.Value__c;
                wrapper.RowNumber = Integer.valueOf(action.Row_Number__c);
                wrapper.type = fieldType;
                if(fieldType=='PICKLIST'){
                    wrapper.isPicklist = true;
                }else{
                    wrapper.isPicklist = false; 
                }
                PostActionWrapperList.add(wrapper);
            }
            inn.batchSettingsRecord = JunosettingsList[0];
            inn.PostActionWrapperList = PostActionWrapperList;
        }
        
    }
    
    
    return inn;
}
@AuraEnabled
public static void SaveTemplateAndPostActions(string ObjectName,string templateId,string postActionWrapper,string batchId) {
    System.debug('batchId=='+batchId);
    list<PostActionWrapper> postActionWrapperList = (List<PostActionWrapper>)JSON.deserialize(postActionWrapper, List<PostActionWrapper>.class);
    Junodoc_Batch_Settings__c Junosettings = new Junodoc_Batch_Settings__c();
    Junosettings.JunoDoc__Junodoc_Templates__c = templateId;
    if(batchId!='' && batchId!=null){
        Junosettings.Junodoc_Batch__c = batchId;
    }
    insert Junosettings;
    if(Junosettings!=null){
        list<Junodoc_Post_Trigger_Actions__c> TriggerActions = new list<Junodoc_Post_Trigger_Actions__c>();
        for(PostActionWrapper wrapper:postActionWrapperList){
            Junodoc_Post_Trigger_Actions__c action = new Junodoc_Post_Trigger_Actions__c();
            action.Field_Name__c = wrapper.Field;
            action.Value__c = wrapper.Value;
            action.Row_Number__c     = wrapper.RowNumber;
            action.Junodoc_Batch_Settings__c = Junosettings.Id;
            TriggerActions.add(action);
        }  
        if(Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Field_Name__c.iscreateable() && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Value__c.iscreateable()
          && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Row_Number__c.iscreateable() && Schema.sObjectType.Junodoc_Post_Trigger_Actions__c.fields.Junodoc_Batch_Settings__c.iscreateable()){
        insert TriggerActions;
        }
    }
    
}
public class InnerDocTemplates{
    @AuraEnabled
    public list<DocTemplatesWrap> AvailableDocTemplatesList;
    @AuraEnabled
    public string DocTemplateId;
    @AuraEnabled
    public string ObjectAPIName;  
    @AuraEnabled
    public Junodoc_Batch_Settings__c batchSettingsRecord;
    @AuraEnabled
    public list<PostActionWrapper> PostActionWrapperList;
}  

public class DocTemplatesWrap{
    @AuraEnabled
    public String label;
    @AuraEnabled
    public String value; 
    // New Code Start
    @AuraEnabled
    public String type;
    // New Code End
}    
}
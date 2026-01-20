global with sharing class JunoDocTriggerActionsScheduleController {
    global class SendEmailClass {
        @InvocableVariable
        global string recordIds;
        
        @InvocableVariable
        global string EmailTemplateId;  
        
        @InvocableVariable
        global String DocTemplateId;
        
        @InvocableVariable
        global String TextEmails;
        
        @InvocableVariable
        global String EmailFields;
        
        @InvocableVariable
        global String BCCTextEmails;
        
        @InvocableVariable
        global String BCCEmailFields;
        
        @InvocableVariable
        global String CCTextEmails;
        
        @InvocableVariable
        global String CCEmailFields;
        
        @InvocableVariable
        global String FromEmailAddress;
        
        
        @InvocableVariable
        global boolean SaveAsActivity;
    }
  @InvocableMethod(label='Send Junodoc Email')
  global static void JunoDocTriggerActionsProcessBuilderHelper(SendEmailClass[] sendEmails){        
      try{
          list<id> NewrecordIds = new list<id>();
         string DocTemplateId = '';
          string EmailTemplateId = '';
          string Emails = '';
          string EmailFields = '';
          string BCCEmails = '';
          string BCCEmailFields = '';
          string CCEmails = '';
          string CCEmailFields = '';
          boolean SaveAsActivity;
          string FromEmailAddress = '';
          for(SendEmailClass send : sendEmails){
              NewrecordIds.add(send.recordIds);
              DocTemplateId = send.DocTemplateId;
              EmailTemplateId = send.EmailTemplateId;
              Emails = send.TextEmails;
              EmailFields = send.EmailFields;
              BCCEmails = send.BCCTextEmails;
              BCCEmailFields = send.BCCEmailFields;
              CCEmails = send.CCTextEmails;
              CCEmailFields = send.CCEmailFields;
              SaveAsActivity = send.SaveAsActivity;
              FromEmailAddress = send.FromEmailAddress;   
          }
          
          Id recordId = Id.valueOf(string.valueOf(NewrecordIds[0]));
          String objectName = recordId.getSObjectType().getDescribe().getName();                        
          system.debug('recordId--->'+recordId);        
          list<SObject> batchRecordsList = new list<SObject>();
          string query='Select Id ';            
          query = query+' From '+ObjectName+
              //' Where (createdDate = TODAY or LastModifiedDate = TODAY) '+
              ' Where Id In:NewrecordIds  ';
          system.debug('query--->'+query);
          list<SObject> recordsList= Database.query(query);
          system.debug('recordsList--->'+recordsList);
          system.debug('recordsList size--->'+recordsList.size());
          if(recordsList.size()>0){
              JunoDocProcessBuilderBatch batch = new JunoDocProcessBuilderBatch(recordsList,ObjectName,DocTemplateId,EmailTemplateId,Emails,EmailFields,SaveAsActivity,FromEmailAddress,BCCEmails,BCCEmailFields,CCEmails,CCEmailFields);
              Id batchJobId = Database.executeBatch(batch,1);
          }
          
          
          
      }catch(Exception e){
          system.debug('exception---->'+e.getMessage());            
      } 

        
  }  
    
 
    
  
  public static void JunoDocTriggerActionsScheduleHelper(){        
        try{
            if (Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Id.isAccessible()
                && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Executed_Date__c.isAccessible()
                && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Trigger_Object__c.isAccessible()
                && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Record_Ids__c.isAccessible()
                && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Executed_Date__c.isAccessible()
                ) {
                    list<Juno_Doc_Trigger_Log__c> DeleteTriggerLogsList =[Select Id, Executed_Date__c, Trigger_Object__c, Record_Ids__c 
                                                                          From Juno_Doc_Trigger_Log__c 
                                                                          Where Executed_Date__c<=YESTERDAY
                                                                         limit 49000 ];
                    if(DeleteTriggerLogsList.size()>0){
                        if(Doc_Template_Child__c.sObjectType.getDescribe().isDeletable()) {
                            delete DeleteTriggerLogsList;
                        } 
                    }
                }
            
            
            set<string> objectsList = new set<string>();
            list<Juno_Doc_Trigger__c> JunoDocTriggersList   = [select id,Name,Object_Name__c,
                                                               Trigger_Conditions_Formula__c, IsActive__c,JunoDoc__Enable_Recurring_Trigger__c
                                                               from Juno_Doc_Trigger__c 
                                                               Where IsActive__c = true
                                                               order by Name asc
                                                               limit 49000];
            if(JunoDocTriggersList.size()>0){
                /*for(Juno_Doc_Trigger__c rec : JunoDocTriggersList){
                    objectsList.add(rec.Object_Name__c);
                }*/

                //for(string ObjectName : objectsList){
                for(Juno_Doc_Trigger__c triggerrec : JunoDocTriggersList){
                    system.debug('triggerrec--->'+triggerrec.id);
                    string ObjectName = triggerrec.Object_Name__c;
                    //get fields from trigger conditions
                    string objectFields = '';
                    set<string> fields = new set<string>();
                    list<Juno_Doc_Trigger_Condition__c> TriggerConditionsList =[select id,Name,Field__c, Operator__c, Value__c,
                                                                            Juno_Doc_Trigger__r.Name,
                                                                            Juno_Doc_Trigger__r.Object_Name__c,RowNumber__c
                                                                            From Juno_Doc_Trigger_Condition__c 
                                                                            Where Juno_Doc_Trigger__r.Name=:triggerrec.Name
                                                                            limit 49000 
                                                                            ];
                    if(TriggerConditionsList!=null && TriggerConditionsList.size()>0){
                        for(Juno_Doc_Trigger_Condition__c rec : TriggerConditionsList){
                            fields.add(rec.Field__c);                    
                            //objectFields +=', '+rec.Field__c;
                        }                
                    }         
                    
                    list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList 
                                = [select id,Name,Field__c, Value__c,
                                Juno_Doc_Trigger__r.Object_Name__c,Juno_Doc_Trigger__r.Name
                                From Juno_Doc_Post_Trigger_Action__c 
                                Where Juno_Doc_Trigger__r.Name=:triggerrec.Name
                                limit 49000 
                                ];
                    if(PostTriggerActionsList!=null && PostTriggerActionsList.size()>0){
                        for(Juno_Doc_Post_Trigger_Action__c rec : PostTriggerActionsList){                    
                            //objectFields +=', '+rec.Field__c;
                            fields.add(rec.Field__c);
                        }                
                    }         
                    
                    if(fields.size()>0){
                        for(string field:fields){
                            objectFields +=', '+field;
                        }
                    }
                    
                    //End get fields from trigger conditions
                    
                    list<string> recordIdsList  = new list<string>();
                    Juno_Doc_Trigger_Log__c triggerLogRec;
                    list<Juno_Doc_Trigger_Log__c> TodayTriggerLogsList   = [Select Id, Executed_Date__c, Trigger_Object__c, Record_Ids__c 
                                                                            From Juno_Doc_Trigger_Log__c 
                                                                            Where Trigger_Object__c =:ObjectName
                                                                           // And Executed_Date__c=TODAY
                                                                        limit 49000];
                    if(TodayTriggerLogsList.size()>0){
                        triggerLogRec = TodayTriggerLogsList[0];
                        string recordIds = triggerLogRec.Record_Ids__c;   
                        if(recordIds != null){
                            if(recordIds.contains(',')){
                                recordIdsList = recordIds.split(',');
                            }else{
                                recordIdsList.add(recordIds);
                            }  
                        }
                    }            
                    string query='Select Id '+objectFields;            
                    query = query+' From '+ObjectName;
                    system.debug('triggerrec.Name--->'+triggerrec.Name);
                    string filterQuery = JunoDocTriggerActionsScheduleController.getFilterRecordsHelper(ObjectName,triggerrec.Name);  
                    query =query+filterQuery+
                        ' And Id Not In:recordIdsList  '+
                        ' And (Createddate = today or lastmodifieddate = today) '+
                        ' Order by lastmodifieddate desc limit 90 '
                        ;                
                    list<SObject> recordsList= Database.query(query);
                    
                    system.debug('recordsList--->'+recordsList);
                    system.debug('recordsList size--->'+recordsList.size());
                    if(recordsList.size()>0){                        
                        JunoDocTriggerActionsBatch batch = new JunoDocTriggerActionsBatch(recordsList,ObjectName,triggerrec.Name);
                        Id batchJobId = Database.executeBatch(batch,1);
                    }
                } 

            } 
            
             
        }catch(Exception e){
            system.debug('exception---->'+e.getMessage());            
        }
        
  }
    
    
    
  public static string getFilterRecordsHelper(string objectName, string TriggerName){
        string Query='';        
        try{
             
            boolean isTriggerActive = false; 
            string triggerConditionsFormula='';
            string triggerConditionsFormulaTmp='';
            Juno_Doc_Trigger__c TriggerRec; 
            list<Juno_Doc_Trigger__c> TriggerRecordsList = [select id,Name,IsActive__c, Trigger_Conditions_Formula__c
                                                            from Juno_Doc_Trigger__c  
                                                            Where Name =:TriggerName 
                                                            limit 49000
                                                           ]; 
            if(TriggerRecordsList.size()>0){             
                TriggerRec = TriggerRecordsList[0];
                triggerConditionsFormula = TriggerRec.Trigger_Conditions_Formula__c;
                triggerConditionsFormulaTmp = TriggerRec.Trigger_Conditions_Formula__c;                
                isTriggerActive = TriggerRec.IsActive__c;
            }
            
            if(isTriggerActive){
                integer index=1;  
                list<Juno_Doc_Trigger_Condition__c> TriggerConditionsList = [
                                                            Select Field__c, Operator__c, Value__c,RowNumber__c,
                                                            Juno_Doc_Trigger__r.Name,Juno_Doc_Trigger__r.Object_Name__c
                                                            From Juno_Doc_Trigger_Condition__c
                                                            Where Juno_Doc_Trigger__r.Name =:TriggerName     
                                                            Order by RowNumber__c asc
                                                            limit 49000
                                                        ];             
                triggerConditionsFormulaTmp =  triggerConditionsFormula;
                system.debug('triggerConditionsFormulaTmp--->'+triggerConditionsFormulaTmp);
                for(Juno_Doc_Trigger_Condition__c condition:TriggerConditionsList){
                    system.debug('row number--->'+condition.RowNumber__c);
                    triggerConditionsFormulaTmp = triggerConditionsFormulaTmp.replace(condition.RowNumber__c+'','@$$'+index);                                        
                    index++;
                }
                index=1;                
                system.debug('triggerConditionsFormulaTmp--->'+triggerConditionsFormulaTmp);
                String filterQuery='';
                for(Juno_Doc_Trigger_Condition__c condition : TriggerConditionsList){
                    string fieldName = condition.Field__c;
                    string Operator = condition.Operator__c;
                    string Value = condition.Value__c;
                    SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());                     
                    system.debug('fieldType--->'+fieldType);
                    if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                      if(Value.contains(',')){
                            Value = Value.replaceAll(',', '');
                      }  
                    }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                        if(Value!=null && Value!='' && Value!='null'){
                            try{
                                date dateformat = date.parse(Value);
                                string year = dateformat.year()+'';
                                string month = '';
                                if(dateformat.month()<10){ month = '0'+dateformat.month()+'';}
                                else{ month = dateformat.month()+''; }
                                
                                string day = '';
                                if(dateformat.day()<10){ day = '0'+dateformat.day()+'';  }
                                else{ day = dateformat.day()+''; }
                                Value = year +'-' + month + '-' +day;                                
                            }catch(Exception e){
                                system.debug('exception--->'+e.getMessage());
                            }
                        }
                    }    
                    list<string> valuesList = new list<string>();
                    if(Value.contains(',')){
                        valuesList = Value.split(',');
                    }                    
                    
                    if(fieldName!=null && Operator!=null &&
                       fieldName.trim()!='' && Operator.trim()!='' ){
                           if(Operator=='Equals'){
                               if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                                   filterQuery=' '+fieldName+' = '+decimal.valueOf(Value); 
                               }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                                   filterQuery=' '+fieldName+' = '+Value;
                               }else if(fieldType == 'BOOLEAN'){
                                   filterQuery=' '+fieldName+' = '+Value;
                               }else if(fieldType == 'PICKLIST' ){ 
                                   if(Value.contains(',')){
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
                                        filterQuery=' '+fieldName+' = \''+Value+'\'';                                       
                                   }                                    
                               }else if(fieldType == 'REFERENCE' ){ 
                                   filterQuery=' '+fieldName+' = \''+Value+'\'';                                 
                               }else{
                                   filterQuery=' '+fieldName+' = \''+Value+'\'';                                    
                               }          
                           }else if(Operator=='Not Equal to'){
                               if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                                   filterQuery=' '+fieldName+' != '+decimal.valueOf(Value); 
                               }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                                   filterQuery=' '+fieldName+' != '+Value;
                               }else if(fieldType == 'BOOLEAN'){
                                   filterQuery=' '+fieldName+' != '+Value; 
                               }else if(fieldType == 'PICKLIST' ){ 
                                   if(Value.contains(',')){ 
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
                                        filterQuery=' '+fieldName+' != \''+Value+'\'';                                       
                                   }                                    
                               }else if(fieldType == 'REFERENCE' ){ 
                                   filterQuery=' '+fieldName+' != \''+Value+'\'';                              
                               }else{ 
                                   filterQuery=' '+fieldName+' != \''+Value+'\'';                                    
                               }          
                           }else if(Operator=='Contains'){
                               if(Value.contains(',')){
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
                                       filterQuery=' '+fieldName+' Like \'%'+Value+'%\'';
                                   } 
                               }else{
                                   filterQuery=' '+fieldName+' Like \'%'+Value+'%\'';
                               }                                
                           }else if(Operator=='Does not contain'){
                                if(Value.contains(',')){
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
                                        filterQuery='(Not '+fieldName+' Like \'%'+Value+'%\')';
                                   } 
                              }else{
                                filterQuery='(Not '+fieldName+' Like \'%'+Value+'%\')';      
                              }
                           }else if(Operator=='Greater than'){
                               filterQuery=' '+fieldName+' > '+Value;
                           }else if(Operator=='Less than'){
                               filterQuery=' '+fieldName+' < '+Value;
                           }else if(Operator=='Greater or equal'){
                               filterQuery=' '+fieldName+' >= '+Value;
                           }else if(Operator=='Less or equal'){
                               filterQuery=' '+fieldName+' <= '+Value;
                           }
                        
                           triggerConditionsFormulaTmp= triggerConditionsFormulaTmp.replace('@$$'+index,filterQuery);
                           index++;                            
                    }
                }
                            
                if(triggerConditionsFormulaTmp.trim()!=''){
                    system.debug('Add Filter @@@@@@@ '+triggerConditionsFormulaTmp);
                    Query=' Where '+triggerConditionsFormulaTmp+' ';
                }
                
                system.debug('Query--->'+Query);
            }
        
        }catch(Exception e){
            system.debug('exception e---->'+e.getMessage());            
        }
        
        
        return Query;
        
    }
    
 
    
  public static void upsertTriggerLogs(string ObjectName,string recordId){
        
        Juno_Doc_Trigger_Log__c triggerLogRec;
        list<Juno_Doc_Trigger_Log__c> TodayTriggerLogsList   = [Select Id, Executed_Date__c, Trigger_Object__c, Record_Ids__c 
                                                        From Juno_Doc_Trigger_Log__c 
                                                        Where Trigger_Object__c =:ObjectName
                                                        And Executed_Date__c=TODAY
                                                        limit 49000];
        if(TodayTriggerLogsList.size()>0){
            system.debug('1');
            triggerLogRec = TodayTriggerLogsList[0];
            String recordIds = triggerLogRec.Record_Ids__c != null ? triggerLogRec.Record_Ids__c : '';
            system.debug('recordIds--->'+recordIds);
            if(recordIds==''){
                system.debug('11');
                recordIds = recordId;
            }else{
                system.debug('22');
                recordIds +=','+recordId;
            }
            system.debug('recordIds--->'+recordIds);
            TodayTriggerLogsList[0].Record_Ids__c = recordIds;
        }else{
            system.debug('2');
            Juno_Doc_Trigger_Log__c rec = new Juno_Doc_Trigger_Log__c();
            rec.Executed_Date__c = system.now();
            rec.Trigger_Object__c = ObjectName;
            rec.Record_Ids__c = recordId;            
            TodayTriggerLogsList.add(rec);
        }
        
        if(TodayTriggerLogsList.size()>0){
            if(Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Executed_Date__c.isCreateable()
               && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Trigger_Object__c.isCreateable()
               && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Record_Ids__c.isCreateable()
               && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Executed_Date__c.isUpdateable()
               && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Trigger_Object__c.isUpdateable()
               && Schema.sObjectType.Juno_Doc_Trigger_Log__c.fields.Record_Ids__c.isUpdateable()){
                   upsert TodayTriggerLogsList;
            }
        }
       
      



      
      
    }
    
    
      
    
        
}
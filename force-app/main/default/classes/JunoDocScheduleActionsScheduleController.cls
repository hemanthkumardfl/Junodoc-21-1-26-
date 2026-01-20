public class JunoDocScheduleActionsScheduleController {
    
    public static void JunoDocScheduleActionsScheduleHelper(){        
        try{
            
            
            
            set<string> objectsList = new set<string>();
            list<Junodoc__Junodoc_Schedule_Template_Setting__c> JunoDocSchedulesList   = [select id,Name,Junodoc__Junodoc_Selected_Object__c,
                                                                                          Junodoc__Junodoc_Selected_Criteria__c, Junodoc__Junodoc_IsActive__c
                                                                                          from Junodoc__Junodoc_Schedule_Template_Setting__c 
                                                                                          Where Junodoc__Junodoc_IsActive__c = true
                                                                                          limit 49000];
            if(JunoDocSchedulesList.size()>0){
                
                //system.debug('objectsList--->'+objectsList);
                
                for(Junodoc__Junodoc_Schedule_Template_Setting__c SchRec : JunoDocSchedulesList){
                    //get fields from schedule conditions
                    string ObjectName = SchRec.Junodoc__Junodoc_Selected_Object__c;
                    string objectFields = '';
                    set<string> fields = new set<string>();
                    list<Junodoc__Junodoc_Schedule_Condition__c> ScheduleConditionsList =[select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Operator__c,
                                                                                          Junodoc__Junodoc_Value__c,
                                                                                          Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,
                                                                                          Junodoc__Junodoc_RowNumber__c From Junodoc__Junodoc_Schedule_Condition__c 
                                                                                          Where Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c=:ObjectName
                                                                                         ];
                    if(ScheduleConditionsList!=null && ScheduleConditionsList.size()>0){
                        for(Junodoc__Junodoc_Schedule_Condition__c rec : ScheduleConditionsList){
                            if(rec.Junodoc__Junodoc_Field__c != 'id'){
                                fields.add(rec.Junodoc__Junodoc_Field__c);
                            }
                            //objectFields +=', '+rec.Field__c;
                        }                
                    }         
                    
                    list<Junodoc__Junodoc_Post_Schedule_Action__c> PostScheduleActionsList = [select id,Name,Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Value__c,
                                                                                              Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,
                                                                                              Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                                                                              From Junodoc__Junodoc_Post_Schedule_Action__c 
                                                                                              Where Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c=:ObjectName
                                                                                             ];
                    if(PostScheduleActionsList!=null && PostScheduleActionsList.size()>0){
                        for(Junodoc__Junodoc_Post_Schedule_Action__c rec : PostScheduleActionsList){                    
                            //objectFields +=', '+rec.Field__c;
                            fields.add(rec.Junodoc__Junodoc_Field__c);
                        }                
                    }         
                    
                    if(fields.size()>0){
                        for(string field:fields){
                            objectFields +=', '+field;
                        }
                    }
                    
                    
                    string query='Select Id'+objectFields;            
                    query = query+' From '+ObjectName ;
                    //system.debug('SchRec.Name--->'+SchRec.Name);
                    string filterQuery = JunoDocScheduleActionsScheduleController.getFilterRecordsHelper(ObjectName,SchRec.Name);  
                    query =query+filterQuery;
                    //system.debug('query--->'+query);
                    //+
                    //' And Id Not In:recordIdsList  '+
                    //' And (Createddate = today or lastmodifieddate = today) '+
                    //' Order by lastmodifieddate desc limit 90 ';                
                    list<SObject> recordsList= Database.query(query);
                    //system.debug('recordsList--->'+recordsList);
                    
                    system.debug('batchRecordsList--->'+recordsList);
                    system.debug('batchRecordsList size--->'+recordsList.size());
                    if(recordsList.size()>0){
                        TimeZone tz = UserInfo.getTimeZone();
                        ////system.debug('TimeZone-Display name----->'+ tz.getDisplayName());
                        ////system.debug('TimeZone-ID------>' + tz.getID());
                        
                        Datetime currentTime = Datetime.now();
                        //system.debug('currentTime--->'+currentTime);
                        
                        String timeZone = String.valueof(tz.getID());
                        //system.debug('timeZone--->'+timeZone);
                        
                        Datetime dt = Datetime.valueof(currentTime.format('yyyy-MM-dd HH:mm:ss', timeZone));
                        //system.debug('dt--->'+dt);
                        
                        string todayhr = string.valueof(dt.hour());
                        //system.debug('todayhr---->'+todayhr);
                        
                        string todaydate = string.valueof(dt.day());
                        //system.debug('todaydate---->'+todaydate);
                        
                        string todaymonth = string.valueof(dt.month());
                        //system.debug('todaymonth---->'+todaymonth);
                        
                        String dayOfWeek = dt.format('EEEE');
                        //system.debug('dayOfWeek----->'+dayOfWeek);
                        
                        
                        List<Junodoc__Junodoc_Schedule_Scheduler_Setup__c> ScheduleSetupList = [Select Id, Name, Junodoc__Junodoc_Scheduler_Type__c,
                                                                                                Junodoc__Junodoc_Selected_Schedule_Day__c, Junodoc__Junodoc_Selected_Schedule_Hour__c,
                                                                                                Junodoc__Junodoc_Selected_Schedule_Date__c,Junodoc__Junodoc_Clock_Format__c,
                                                                                                Junodoc__Junodoc_Selected_Schedule_Month__c from Junodoc__Junodoc_Schedule_Scheduler_Setup__c
                                                                                                where Junodoc__Junodoc_Schedule_Template_Setting__r.Name =: SchRec.Name
                                                                                                AND Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_IsActive__c = true];
                        Junodoc__Junodoc_Schedule_Scheduler_Setup__c SchSetup = ScheduleSetupList[0];
                        
                        if(SchSetup.Junodoc__Junodoc_Scheduler_Type__c == 'Monthly'){
                            String SchFormat = SchSetup.Junodoc__Junodoc_Clock_Format__c;
                            //system.debug('SchFormat---->'+SchFormat);
                            
                            String SchDate = SchSetup.Junodoc__Junodoc_Selected_Schedule_Date__c;
                            //system.debug('SchDate---->'+SchDate);
                            
                            String SchMonth = SchSetup.Junodoc__Junodoc_Selected_Schedule_Month__c;
                            //system.debug('SchMonth---->'+SchMonth);
                            
                            String SchHour = SchSetup.Junodoc__Junodoc_Selected_Schedule_Hour__c;
                            //system.debug('SchHour---->'+SchHour);
                            
                            integer ScHR = integer.valueOf(SchHour);
                            //system.debug('ScHR---->'+ScHR);
                            
                            if(SchFormat == 'P.M.' && ScHR < 12){
                                ScHR = ScHR + 12;
                                SchHour = String.ValueOf(ScHR);
                            }
                            else if(SchFormat == 'A.M.' && SchHour == '12'){
                                SchHour = '0';
                            }
                            else{
                                SchHour = SchHour;
                            }
                            
                            if(SchHour == todayhr && SchDate.contains(todaydate) && SchMonth.contains(todaymonth)){
                                JunoDocScheduleActionsBatch batch = new JunoDocScheduleActionsBatch(recordsList,ObjectName,SchRec.Name);
                                Id batchJobId = Database.executeBatch(batch,1);
                            }
                        }
                        if(SchSetup.Junodoc__Junodoc_Scheduler_Type__c == 'Daily'){
                            String SchFormat = SchSetup.Junodoc__Junodoc_Clock_Format__c;
                            //system.debug('SchFormat---->'+SchFormat);
                            
                            String SchHour = SchSetup.Junodoc__Junodoc_Selected_Schedule_Hour__c;
                            //system.debug('SchHour---->'+SchHour);
                            
                            string todaymin = string.valueof(dt.minute());
                            system.debug('todaymin---->'+todaymin);

                            integer ScHR = integer.valueOf(SchHour);
                            //system.debug('ScHR---->'+ScHR);
                            
                            if(SchFormat == 'P.M.' && ScHR < 12){
                                ScHR = ScHR + 12;
                                SchHour = String.ValueOf(ScHR);
                            }
                            else if(SchFormat == 'A.M.' && SchHour == '12'){
                                SchHour = '0';
                            }
                            else{
                                SchHour = SchHour;
                            }
                            
                            if(SchHour == todayhr){ //&& todaymin == '26'){
                                JunoDocScheduleActionsBatch batch = new JunoDocScheduleActionsBatch(recordsList,ObjectName,SchRec.Name);
                                Id batchJobId = Database.executeBatch(batch,1);
                            }
                        }
                        
                        if(SchSetup.Junodoc__Junodoc_Scheduler_Type__c == 'Weekly'){
                            String SchFormat = SchSetup.Junodoc__Junodoc_Clock_Format__c;
                            //system.debug('SchFormat---->'+SchFormat);
                            
                            String SchDay = SchSetup.Junodoc__Junodoc_Selected_Schedule_Day__c;
                            //system.debug('SchDate---->'+SchDay);
                            
                            String SchHour = SchSetup.Junodoc__Junodoc_Selected_Schedule_Hour__c;
                            //system.debug('SchHour---->'+SchHour);
                            
                            integer ScHR = integer.valueOf(SchHour);
                            //system.debug('ScHR---->'+ScHR);
                            
                            if(SchFormat == 'P.M.' && ScHR < 12){
                                ScHR = ScHR + 12;
                                SchHour = String.ValueOf(ScHR);
                            }
                            else if(SchFormat == 'A.M.' && SchHour == '12'){
                                SchHour = '0';
                            }
                            else{
                                SchHour = SchHour;
                            }
                            
                            if(SchHour == todayhr && SchDay.contains(dayOfWeek)){
                                JunoDocScheduleActionsBatch batch = new JunoDocScheduleActionsBatch(recordsList,ObjectName,SchRec.Name);
                                Id batchJobId = Database.executeBatch(batch,1);
                            }
                        }
                        
                    }
                    
                }
            }
            
            
        }catch(Exception e){
            system.debug('exception---->'+e.getMessage());            
        }
        
    }
    
    
    
    public static string getFilterRecordsHelper(string ObjectName, String ScheduleName){
        string Query='';
        try{
            
            boolean isScheduleActive = false; 
            string ScheduleConditionsFormula='';
            string ScheduleConditionsFormulaTmp='';
            Junodoc__Junodoc_Schedule_Template_Setting__c ScheduleRec; 
            list<Junodoc__Junodoc_Schedule_Template_Setting__c> ScheduleRecordsList = [select id,Name,Junodoc__Junodoc_IsActive__c, Junodoc__Junodoc_Selected_Criteria__c
                                                                                       from Junodoc__Junodoc_Schedule_Template_Setting__c  
                                                                                       Where Junodoc__Junodoc_Selected_Object__c =: ObjectName AND Name =: ScheduleName limit 49000
                                                                                      ]; 
            if(ScheduleRecordsList.size()>0){             
                ScheduleRec = ScheduleRecordsList[0];
                ScheduleConditionsFormula = ScheduleRec.Junodoc__Junodoc_Selected_Criteria__c;
                ScheduleConditionsFormulaTmp = ScheduleRec.Junodoc__Junodoc_Selected_Criteria__c;                
                isScheduleActive = ScheduleRec.Junodoc__Junodoc_IsActive__c;
            }
            
            if(isScheduleActive){
                integer index=1;                
                list<Junodoc__Junodoc_Schedule_Condition__c> ScheduleConditionsList = [Select Junodoc__Junodoc_Field__c, Junodoc__Junodoc_Operator__c,
                                                                                       Junodoc__Junodoc_Value__c,Junodoc__Junodoc_RowNumber__c,
                                                                                       Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c,
                                                                                       Junodoc__Junodoc_Schedule_Template_Setting__r.Name
                                                                                       From Junodoc__Junodoc_Schedule_Condition__c
                                                                                       Where Junodoc__Junodoc_Schedule_Template_Setting__r.Junodoc__Junodoc_Selected_Object__c =:ObjectName
                                                                                       AND Junodoc__Junodoc_Schedule_Template_Setting__r.Name =: ScheduleName
                                                                                       Order by Junodoc__Junodoc_RowNumber__c asc limit 49000
                                                                                      ];
                
                ScheduleConditionsFormulaTmp = ScheduleConditionsFormula;
                system.debug('ScheduleConditionsFormulaTmp--->'+ScheduleConditionsFormulaTmp);
                for(Junodoc__Junodoc_Schedule_Condition__c condition:ScheduleConditionsList){
                    system.debug('row number--->'+condition.Junodoc__Junodoc_RowNumber__c);
                    ScheduleConditionsFormulaTmp = ScheduleConditionsFormulaTmp.replace(condition.Junodoc__Junodoc_RowNumber__c+'','@$$'+index);                                        
                    index++;
                }
                index=1;                
                system.debug('ScheduleConditionsFormulaTmp---250---->'+ScheduleConditionsFormulaTmp);
                String filterQuery='';
                for(Junodoc__Junodoc_Schedule_Condition__c condition : ScheduleConditionsList){
                    string fieldName = condition.Junodoc__Junodoc_Field__c;
                    string Operator = condition.Junodoc__Junodoc_Operator__c;
                    string Value = condition.Junodoc__Junodoc_Value__c;
                    SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    string fieldType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());                     
                    //system.debug('fieldType--->'+fieldType);
                    if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                        if(Value.contains(',')){
                            Value = Value.replaceAll(',', '');
                        }  
                    }else if(fieldType == 'DATETIME' || fieldType == 'DATE'){
                        if(Value!=null && Value!='' && Value!='null'){
                            try{
                                if(Value.toLowerCase()== 'today'){
                                    //Value = string.valueof(System.today());
                                    Value = 'TODAY';
                                }
                                else if(Value.toLowerCase()== 'now'){
                                    //Value = string.valueof(System.now());
                                    Value = 'NOW';
                                }
                                else if(Value.toLowerCase()== 'tomorrow'){
                                    //Value = string.valueof(System.today().addDays(1));
                                    Value = 'TOMORROW';
                                }
                                else if(Value.toLowerCase()== 'yesterday'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'YESTERDAY';
                                }
                                else if(Value.toLowerCase()== 'last week'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'LAST_WEEK';
                                }
                                else if(Value.toLowerCase()== 'this week'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'THIS_WEEK';
                                }
                                else if(Value.toLowerCase()== 'next week'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'NEXT_WEEK';
                                }
                                else if(Value.toLowerCase()== 'last month'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'LAST_MONTH';
                                }
                                else if(Value.toLowerCase()== 'this month'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'THIS_MONTH';
                                }
                                else if(Value.toLowerCase()== 'next month'){
                                    //Value = string.valueof(System.today().addDays(-1));
                                    Value = 'NEXT_MONTH';
                                }
                                else{
                                    date dateformat = date.parse(Value);
                                    string year = dateformat.year()+'';
                                    string month = '';
                                    if(dateformat.month()<10){ month = '0'+dateformat.month()+'';}
                                    else{ month = dateformat.month()+''; }
                                    
                                    string day = '';
                                    if(dateformat.day()<10){ day = '0'+dateformat.day()+'';  }
                                    else{ day = dateformat.day()+''; }
                                    Value = year +'-' + month + '-' +day;  
                                }
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
                           
                           ScheduleConditionsFormulaTmp= ScheduleConditionsFormulaTmp.replace('@$$'+index,filterQuery);
                           system.debug('438 '+ScheduleConditionsFormulaTmp);
                           index++;                            
                       }
                }
                
                if(ScheduleConditionsFormulaTmp.trim()!=''){
                    system.debug('4444---Add Filter @@@@@@@ '+ScheduleConditionsFormulaTmp);
                    Query=' Where '+ScheduleConditionsFormulaTmp+' ';
                }
                system.debug('Query--->'+Query);
            }
            
        }catch(Exception e){
            system.debug('exception e---->'+e.getMessage());            
        }
        
        
        return Query;
        
    }
    
}
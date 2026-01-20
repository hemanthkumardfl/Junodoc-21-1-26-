public class JunodocLaunchBatch {
    
    public class Junobatchinnerclass{
        @AuraEnabled public string DocTemplateId;
        @AuraEnabled public string objectName;
        @AuraEnabled public list<sobject> sobjectRecords;
        @AuraEnabled public list<Junodoc_Post_Trigger_Actions__c> TriggerActions;
    }
    @AuraEnabled
    public static Junobatchinnerclass JunobatchData(string recordId){
        Junodoc_Batch_Settings__c Junosettings = [select id,
                                                                JunoDoc__Junodoc_Templates__c,
                                                                JunoDoc__Junodoc_Templates__r.parent_Object__c,
                                                                SOQL_Query__c,
                                                                Report_ID__c,
                                                                (select id,Field_Name__c,Value__c from Junodoc_Post_Trigger_Actions__r)
                                                                from Junodoc_Batch_Settings__c
                                                                where id=: recordId];
        Junobatchinnerclass Junobatchinner = new Junobatchinnerclass();
        string selectedObject = Junosettings.JunoDoc__Junodoc_Templates__r.parent_Object__c;
        Junobatchinner.objectName = selectedObject;
        Junobatchinner.DocTemplateId = Junosettings.JunoDoc__Junodoc_Templates__c;
        list<string> objIds = new list<string>();
        if(Junosettings.SOQL_Query__c != null && Junosettings.SOQL_Query__c != ''){
            list<sobject> sobjectlist = Database.query(Junosettings.SOQL_Query__c);
            for(sobject sobj  : sobjectlist){
                objIds.add(''+sobj.get('Id'));
            }
        }
        else{
            AnalyticsUtils analytic = new AnalyticsUtils();
            analytic.sobjectName = selectedObject;
            analytic.reportId = Junosettings.Report_ID__c;
            objIds = analytic.ReportResponse();  
        }
        system.debug('****** objIds ' + objIds.size());
        if(!objIds.isEmpty()){
            String strQuery='';
            if(selectedObject=='Case'){
                strQuery = 'select id,CaseNumber,LastModifiedDate,createdDate from '+selectedObject+' where id IN: objIds order by LastModifiedDate desc limit 90';  
            }else if(selectedObject == 'WorkOrder'){
                strQuery = 'select id,WorkOrderNumber,LastModifiedDate,createdDate from '+selectedObject+' where id IN: objIds order by LastModifiedDate desc limit 90';  
            }else{
                strQuery = 'select id,Name,LastModifiedDate,createdDate from '+selectedObject+' where id IN: objIds order by LastModifiedDate desc limit 90';  
            }
            Junobatchinner.sobjectRecords = Database.query(strQuery);
        }
        else{
            Junobatchinner.sobjectRecords = new list<sobject>();
        }
        
        system.debug('****** ' + Junobatchinner.sobjectRecords);
        Junobatchinner.TriggerActions = Junosettings.Junodoc_Post_Trigger_Actions__r;
        return Junobatchinner;
    }
    
    public class responseclass{
        @AuraEnabled public string Errormesssage;
        @AuraEnabled public boolean isSuccess;
    }
    
    @AuraEnabled
    public static responseclass junoActionUpdate(string recordIds,list<Junodoc_Post_Trigger_Actions__c> childrecords){
        responseclass responseinn = new responseclass();
        try{
            list<string> records = 
          (List<string>)JSON.deserialize(recordIds, List<string>.class);
            
            list<sobject> sobjectlist = new list<sobject>();
            for(string rec : records){
                String sObjName = Id.valueof(rec).getSObjectType().getDescribe().getName();
                sObject sObj = Schema.getGlobalDescribe().get(sObjName).newSObject() ;
                sObj.put('Id',rec);
                for(Junodoc_Post_Trigger_Actions__c childs : childrecords){
                    SObjectType r = ((SObject)(Type.forName('Schema.'+sObjName).newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    string fieldType = string.valueOf(d.fields.getMap().get(childs.Field_Name__c).getDescribe().getType()); 
                    if(fieldType == 'DOUBLE' || fieldType == 'CURRENCY' || fieldType == 'INTEGER'){
                        sObj.put(childs.Field_Name__c, decimal.valueof(childs.Value__c));
                    }
                    else if(fieldType == 'BOOLEAN'){
                        sObj.put(childs.Field_Name__c, boolean.valueof(childs.Value__c));
                    }
                    else if(fieldType == 'DATE'){
                        if(childs.Value__c.tolowercase() == 'today'){
                            sObj.put(childs.Field_Name__c, system.today()); 
                        }
                        else if(childs.Value__c.tolowercase() == 'now'){
                            sObj.put(childs.Field_Name__c, system.today()); 
                        }
                        else{
                            sObj.put(childs.Field_Name__c, date.valueof(childs.Value__c)); 
                        }
                       
                    }
                    else if(fieldType == 'DATETIME'){
                        if(childs.Value__c.tolowercase() == 'now'){
                            sObj.put(childs.Field_Name__c, system.Now());   
                        }
                        else if(childs.Value__c.tolowercase() == 'today'){
                            sObj.put(childs.Field_Name__c, system.Now());
                        }
                        else{
                            sObj.put(childs.Field_Name__c, datetime.valueof(childs.Value__c)); 
                        }
                        
                    }
                    else{
                        sObj.put(childs.Field_Name__c, childs.Value__c);
                    }
                    
                }
                sobjectlist.add(sObj);
            }
            
            if(!sobjectlist.isEmpty()){
                update sobjectlist;
            }
            responseinn.isSuccess = true;
            responseinn.Errormesssage = '';
            return responseinn;
       }
        catch(Exception e){
        responseinn.isSuccess = false;
            responseinn.Errormesssage = e.getMessage();  
            return responseinn;
       }
       
    }
    
    @AuraEnabled
    public static string getMultiPDFData(string recordId,string TemplateId,string sessionId){
        string output = '';
        PageReference ref = new PageReference('/apex/JunoDoc__PreviewTemplatePDF?id=' + recordId + '&DocTemplateId=' + TemplateId);
        output = ref.getContent().toString().trim();
         output = output.unescapeHtml4().replace('<div style="font-size: 0px;">"</div>', '').replace('<div class="content">null', '<div class="content">');
        JunoDoc__Consolidate_Records__c ConsolidateRecords = new JunoDoc__Consolidate_Records__c();
        ConsolidateRecords.Output__c = output;
        ConsolidateRecords.JunoDoc__Session_Id__c = sessionId;
        insert ConsolidateRecords; 
        JunoDoc__Consolidate_Records__c ConsolidateRecord = [select id from JunoDoc__Consolidate_Records__c where id =:ConsolidateRecords.Id];
        return ConsolidateRecord.Id;
    }
    
    @AuraEnabled
    public static integer getConsolidatedData(string sessionId){
        list<JunoDoc__Consolidate_Records__c> ConsolidateRecord = [select id from JunoDoc__Consolidate_Records__c where JunoDoc__Session_Id__c =: sessionId];
        return ConsolidateRecord.size();
    }
    
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
    
    
}
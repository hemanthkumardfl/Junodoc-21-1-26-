public class JunodocLwcAddEmailRecipientController {
    @AuraEnabled
    public static String getObjectLabelName(string ObjAPIName){
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjAPIName}); 
        String objectLabel = describeSobjectsResult[0].getLabel();
        System.debug(objectLabel);
        return objectLabel;
    }
    
    @AuraEnabled
    public static list<JunoDoc__Email_Details__c> getJunodocObjectsettings(string ObjAPIName){
        List<Junodoc_Details__c> jdlist = [select id,JunoDoc__From_Email_Address__c,JunoDoc__Junodoc_Email_Templates__c,
                                           JunoDoc__Standard_Email_Templates__c,JunoDoc__Set_Reply_To__c,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junodoc_Details__c where JunoDoc__Selected_object__c =: ObjAPIName];
        list<JunoDoc__Email_Details__c> JunoDoEmailDetails = new list<JunoDoc__Email_Details__c>();
        if(jdlist.size()>0){
            JunoDoEmailDetails = [select id, JunoDoc__Email__c, JunoDoc__Text_Ref_Value__c, JunoDoc__To_Value__c, JunoDoc__field_Details__c, JunoDoc__Junodoc_Details__c from JunoDoc__Email_Details__c where JunoDoc__Junodoc_Details__c=: jdlist[0].Id];
        }
        return JunoDoEmailDetails;
    }
    
    @AuraEnabled
    public static List<sObject> getConUserRec(String selectedObj,String matchStr){
        //List<conUserWrapCls> conUserWrap = new List<conUserWrapCls>();
        String filterName = '%'+matchStr+'%';
        system.debug('filterName-->'+filterName);
        String quereStr = 'Select Id,Name,Email from '+selectedObj + ' Where Name Like: filterName  ORDER BY Name LIMIT 20';
        system.debug('queryStr-->'+quereStr);
        List<sObject> objRecList = Database.query(quereStr); 
        return objRecList;
    }
    
    @AuraEnabled
    public static ResultWrapper getinitialObjectFields(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'REFERENCE' || String.ValueOf(dfield.getType()) == 'EMAIL'){
                    if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
                        wrapper.label = string.valueOf(dfield.getLabel())+'>'; 
                        wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();              
                    }else{
                        wrapper.label = string.valueOf(dfield.getLabel()); 
                        wrapper.LookUpAPIName = '';      
                    }
                    wrapper.value = dfield.getName(); 
                    ObjectWrapperList.Add(wrapper);
                }
            }
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = true;
            Result.Message = 'Success';
            Result.WrapperList = ObjectWrapperList;
            return Result;
        }catch(Exception ex){
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = false;
            Result.Message = ex.getMessage();
            return Result;
        }
    }
    @AuraEnabled
    public static ResultWrapper getOnlyEmailFields(string ObjAPIName){
         Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'EMAIL'){
                    wrapper.label = string.valueOf(dfield.getLabel()); 
                    wrapper.LookUpAPIName = '';      
                    wrapper.value = dfield.getName(); 
                    ObjectWrapperList.Add(wrapper);
                }
            }
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = true;
            Result.Message = 'Success';
            Result.WrapperList = ObjectWrapperList;
            return Result;
        }catch(Exception ex){
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = false;
            Result.Message = ex.getMessage();
            return Result;
        }
    }
    @AuraEnabled
    public static level1Wrapper getFirstLevelObjectFields(string ObjectName,String FirstFieldValue){
        /*List<string> FieldAPI = FirstField.split('-');
        string FieldToReturn = FieldAPI[0];
        return FieldToReturn;*/
        level1Wrapper level1Wrapper=new level1Wrapper();
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(ObjectName)
            .getDescribe()
            .fields
            .getMap()
            .get(FirstFieldValue)
            .getDescribe();
        System.debug('f '+f);
        String parentObject ='';
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            parentObject = reference.getDescribe().getName();
            System.debug('Lookup reference object name:  '+parentObject);
        }
        ResultWrapper wrapper = JunodocLwcAddEmailRecipientController.getinitialObjectFields(parentObject);
        level1Wrapper.WrapperList = wrapper.WrapperList;
        level1Wrapper.lookUpObject = parentObject;
        String FieldToReturn = '';
        FieldToReturn = FirstFieldValue;
        return level1Wrapper;
    }
     @AuraEnabled
    public static level1Wrapper getSecondLevelObjectFields(string ObjectName,String FirstFieldValue,String SecondFieldValue){
       
        String FieldToReturn = '';
        level1Wrapper level1Wrapper=new level1Wrapper();
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(ObjectName)
            .getDescribe()
            .fields
            .getMap()
            .get(SecondFieldValue)
            .getDescribe();
        System.debug('f '+f);
        String parentObject ='';
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            parentObject = reference.getDescribe().getName();
            System.debug('Lookup reference object name:  '+parentObject);
        }
        ResultWrapper wrapper = JunodocLwcAddEmailRecipientController.getinitialObjectFields(parentObject);
        level1Wrapper.WrapperList = wrapper.WrapperList;
        level1Wrapper.lookUpObject = parentObject;
        FieldToReturn = FirstFieldValue+'.'+SecondFieldValue;
        return level1Wrapper;
    }
    
      @AuraEnabled
    public static level1Wrapper getThirdLevelObjectFields(string ObjectName,String FirstFieldValue,String SecondFieldValue,String ThirdFieldValue){
        
        String FieldToReturn = '';
        level1Wrapper level1Wrapper=new level1Wrapper();
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(ObjectName)
            .getDescribe()
            .fields
            .getMap()
            .get(ThirdFieldValue)
            .getDescribe();
        System.debug('f '+f);
        String parentObject ='';
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            parentObject = reference.getDescribe().getName();
            System.debug('Lookup reference object name:  '+parentObject);
        }
        ResultWrapper wrapper = JunodocLwcAddEmailRecipientController.getOnlyEmailFields(parentObject);
        level1Wrapper.WrapperList = wrapper.WrapperList;
        level1Wrapper.lookUpObject = parentObject;
        FieldToReturn = FirstFieldValue+'.'+SecondFieldValue+'.'+ThirdFieldValue;
        return level1Wrapper;
    }
      /*@AuraEnabled
    public static String getFinalLevelObjectFields(string ObjectName,String FirstFieldValue,String SecondFieldValue,String ThirdFieldValue,String FourthFieldValue){
        String FieldToReturn = '';
        FieldToReturn = FirstFieldValue+'.'+SecondFieldValue+'.'+ThirdFieldValue+'.'+FourthFieldValue;
        System.debug('FieldToReturn '+FieldToReturn);
        return FieldToReturn;
    }*/
    
    public class ObjectWrapper{
        @AuraEnabled
        public string label{get;set;}
        @AuraEnabled
        public string value{get;set;}
        @AuraEnabled
        public string LookUpAPIName{get;set;}
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public List<ObjectWrapper> WrapperList{get;set;}
        @AuraEnabled
        public boolean IsSuccess{get;set;}
        @AuraEnabled
        public string Message{get;set;}
    }
    public class level1Wrapper{
        @AuraEnabled
        public List<ObjectWrapper> WrapperList{get;set;}
        @AuraEnabled
        public string lookUpObject{get;set;} 
        @AuraEnabled
        public List<ObjectWrapper> BreadcrumbCollection{get;set;}
    }
}
global class FormulaBuilder {
    
    @AuraEnabled
    global static string GetLabelName(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        system.debug(schemaMap.get(ObjAPIName).getDescribe().getLabel());
        string LabelName = schemaMap.get(ObjAPIName).getDescribe().getLabel();
        return LabelName;
    }
    
    @AuraEnabled
    global static ResultWrapper getAllObjectFields(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
                    wrapper.Label = string.valueOf(dfield.getLabel())+'>';
                    wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();
                }else{
                    wrapper.Label = string.valueOf(dfield.getLabel());
                    wrapper.LookUpAPIName = string.valueOf(dfield.getName());
                }
                wrapper.APIName = dfield.getName(); 
                ObjectWrapperList.Add(wrapper);
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
    global static ResultWrapper getinitialObjectFields(string ObjAPIName){
        string strObj = ObjAPIName;
            if(ObjAPIName.contains('[')){
                strObj = ObjAPIName.replace('[','---').split('---')[0];
            }
        ObjAPIName =  strObj;
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
                    wrapper.Label = string.valueOf(dfield.getLabel())+'>'; 
                    wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();              
                    wrapper.APIName = dfield.getName(); 
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
    
    global class ObjectWrapper{
        @AuraEnabled
        global string Label{get;set;}
        @AuraEnabled
        global string APIName{get;set;}
        @AuraEnabled
        global string LookUpAPIName{get;set;}
    }
    
    global class ResultWrapper{
        @AuraEnabled
        global List<ObjectWrapper> WrapperList{get;set;}
        @AuraEnabled
        global boolean IsSuccess{get;set;}
        @AuraEnabled
        global string Message{get;set;}
    }
    
    @AuraEnabled
    global static string GetFieldDetails(string ObjectName,string FirstField){
        system.debug('GetFieldDetails ***' + FirstField);
        List<string> FieldAPI = FirstField.split('@@@');
        //string FieldToReturn = ObjectName+'.'+FieldAPI[0];
        string FieldToReturn = FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    global static string GetSecLevelFieldDetails(string ObjectName,string FirstField, string SecondField){
        system.debug(FirstField + ' **** '+ SecondField);
        List<string> FieldAPI = SecondField.split('@@@');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    global static string GetThirdLevelFieldDetails(string ObjectName,string FirstField, string SecondField, string ThirdField){
        List<string> FieldAPI = ThirdField.split('@@@');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        if(SecondField.substring(SecondField.length()-3,SecondField.length()) == '__c'){
            SecondField = SecondField.substring(0,SecondField.length()-3);
            SecondField = SecondField+'__r';
        }else if(SecondField.substring(SecondField.length()-2, SecondField.length()) == 'Id'){
            SecondField = SecondField.substring(0, SecondField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+SecondField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+SecondField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    global static string GetFinalLevelFieldDetails(string ObjectName,string FirstField, string SecondField, string ThirdField, string FinalField){
        List<string> FieldAPI = FinalField.split('@@@');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        if(SecondField.substring(SecondField.length()-3,SecondField.length()) == '__c'){
            SecondField = SecondField.substring(0,SecondField.length()-3);
            SecondField = SecondField+'__r';
        }else if(SecondField.substring(SecondField.length()-2, SecondField.length()) == 'Id'){
            SecondField = SecondField.substring(0, SecondField.length()-2);
        }
        
        if(ThirdField.substring(ThirdField.length()-3,ThirdField.length()) == '__c'){
            ThirdField = ThirdField.substring(0,ThirdField.length()-3);
            ThirdField = ThirdField+'__r';
        }else if(ThirdField.substring(ThirdField.length()-2, ThirdField.length()) == 'Id'){
            ThirdField = ThirdField.substring(0, ThirdField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+SecondField+'.'+ThirdField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+SecondField+'.'+ThirdField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
}
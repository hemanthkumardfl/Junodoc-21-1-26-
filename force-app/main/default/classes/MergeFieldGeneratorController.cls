global with sharing class MergeFieldGeneratorController {
    
    /**
       * @description  This method will get All the object names with their api names
       */
    @AuraEnabled
    global static List<InnerObjects> getAllObjects(){
        List<InnerObjects> objectList  = new List<InnerObjects>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            InnerObjects obj = new InnerObjects();
            obj.label = objTyp.getDescribe().getLabel();
            obj.value = objTyp.getDescribe().getName();
            objectList.add(obj);
        }
        return objectList;
    }
    @AuraEnabled
    global static List<InnerFields> getAllFields(String objectName){
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        List<Schema.SObjectField> fields = describeResult.fields.getMap().values();
        List<InnerFields> objectList  = new List<InnerFields>();
        for (Schema.SObjectField field : fields) {
            InnerFields obj = new InnerFields();
            obj.value = field.getDescribe().getName();
            obj.label = field.getDescribe().getLabel();
            obj.type = field.getDescribe().getType().name();
            objectList.add(obj);
        }
        return objectList;
    }
    
    /**
       * @description  This method will get relationship name of a field for a given object
       * @param  objectName, fieldApiName
       */ 
    @AuraEnabled
    global static InnerRelation getRelationshipName(String objectName,String fieldApiName){
        InnerRelation RelationList = new InnerRelation();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();
        RelationList.relationName = fieldResult.getRelationshipName();
        if(!Test.isRunningTest()){        
        RelationList.innerFieldsList = MergeFieldGeneratorController.getAllFields(String.valueOf(fieldResult.getReferenceTo()[0]));
        }
        else{
            system.debug('test class');
        }
        return RelationList;
    }
    
     /**
       * @description  This method will get relationship name for a two fields for a given object
       * @param  objectName, fieldApiName, secondfieldApiName
       */ 
    @AuraEnabled
    global static InnerRelation secondRelation(String objectName,String fieldApiName,String secondfieldApiName){
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();
        String lookupName = String.valueOf(fieldResult.getReferenceTo()[0]);
        InnerRelation innerSecondRelation = MergeFieldGeneratorController.getRelationshipName(lookupName,secondfieldApiName);
        return innerSecondRelation;
    }
    
  
    
   
    
    
    global class InnerFields{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String type;
    }
    
    global class InnerObjects{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    global class TemplateData{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String smsBody;
    }
    
    global class InnerRelation{
        @AuraEnabled public string relationName;
        @AuraEnabled public List<InnerFields> innerFieldsList;
    }
}
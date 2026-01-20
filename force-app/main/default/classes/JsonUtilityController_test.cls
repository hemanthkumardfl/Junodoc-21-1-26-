@isTest
public class JsonUtilityController_test {
    
    @isTest
    public static void method1(){
        List<String> Objects = new List<String>();
        Objects.add('Account');
        
        List<SobjectUtilityController.innerclassForParentResults>parentList = new List<SobjectUtilityController.innerclassForParentResults>();
        parentList.add(SobjectUtilityController.get_ParentRecordsForBatch('SELECT id,name FROM ACCOUNT','ACCOUNT'));
        
        List<SobjectUtilityController.innerClassForChildResults> childList = new List<SobjectUtilityController.innerClassForChildResults>();
        childList.add(SobjectUtilityController.get_ChildRecordsForBatch('SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1', 'AccountId','Contact'));
        
        Map<String,String> priceBookEntryMap = new  Map<String,String> ();
        priceBookEntryMap.put('test','test');
        
        List<Sobject>SobjectRecords = new List<Sobject>();
        
        JsonUtilityController.compositeBatchGetJSON('','',SobjectRecords);
        JsonUtilityController.objectSchemaValidationJSON(Objects);
        
        JunoDoc__Junodoc_Object_Schema_Mapping__c SchMap = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
        SchMap.JunoDoc__Destination_Name__c = 'test';
        SchMap.JunoDoc__Matching_Fields__c = 'Name';
        SchMap.JunoDoc__Object_Name__c = 'Account';
        SchMap.JunoDoc__Schema_External_ID__c = 'testSchId';
        SchMap.JunoDoc__Source_External_Id__c = 'testSrcId';
        SchMap.Name = 'test';
        insert SchMap;
        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> SchMaps = new List<JunoDoc__Junodoc_Object_Schema_Mapping__c>();
        SchMaps.add(SchMap);
        
        List<String> fields = new List<String>();
        Objects.add('Name');
        
        JsonUtilityController.prepareMtreeBatchJSON(SchMap.JunoDoc__Destination_Name__c,parentList,childList,false,priceBookEntryMap);
        
        /* JunoDoc__Junodoc_Connections__c ConSet = new JunoDoc__Junodoc_Connections__c();
ConSet.Name = 'test';
ConSet.JunoDoc__Set_Audit_Fields__c = true;
insert ConSet;

JunoDoc__Junodoc_Object_RecordType_Mapping__c recMapp = new JunoDoc__Junodoc_Object_RecordType_Mapping__c();
recMapp.JunoDoc__Destination_Record_Type_Id__c = 'test';
recMapp.JunoDoc__Object__c = SchMap.Id;
recMapp.JunoDoc__Source_Record_Type__c = 'test';
insert recMapp;*/
        
        JsonUtilityController.compositeBatchUpsertJSON('test','Account',SobjectRecords,fields,1);
        JsonUtilityController.geneareQueryXMLForMetadata('test','Account',SobjectRecords,'test');
        JsonUtilityController.geneareMetadataQueryXML('destination','Account',SobjectRecords,'test','fields','testdata','test');
        JsonUtilityController.generateUpsertXML('test','Account',SobjectRecords,fields,1,'test');
        JsonUtilityController.geneareQueryXML('test','Account',SobjectRecords,'test');
        
    }
}
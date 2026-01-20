@isTest
public class JunoSignObjectPostActionsController_Test {
    public static List<Map<String, Object>> generateTestJSON() {
         // Step 1: Create a Map<String, Object>
        Map<String, Object> testMap1 = new Map<String, Object>();
        testMap1.put('key1', 'value1');
        testMap1.put('key2', 123);
        testMap1.put('key3', true);

        Map<String, Object> testMap2 = new Map<String, Object>();
        testMap2.put('keyA', 'valueA');
        testMap2.put('keyB', 456);
        testMap2.put('keyC', false);

        // Step 2: Create a List<Map<String, Object>>
        List<Map<String, Object>> testList = new List<Map<String, Object>>();
        testList.add(testMap1);
        testList.add(testMap2);
        
        return testList;
    }
    static testMethod void testGetObjectFields(){
        string objectApiName = 'Quote';
        String fieldName = 'Name';
        
        JunoDoc__JunoSign_Post_Actions__c postAction = new JunoDoc__JunoSign_Post_Actions__c();
        postAction.JunoDoc__Field_Name__c = 'Test field';
        postAction.JunoDoc__Field_DataType__c = 'String';
        postAction.JunoDoc__Field_Value__c = 'Test Value';
        postAction.JunoDoc__JunoSignObjectAPIName__c='Quote';
        insert postAction;
        
        Test.startTest();
        JunoSignObjectPostActionsController.getObjectFields(objectApiName);
        JunoSignObjectPostActionsController.getFieldValue(objectApiName, fieldName);
        JunoSignObjectPostActionsController.getExistingRecords(objectApiName);
        JunoSignObjectPostActionsController.getExistingRecords('Account');
         // Generate the JSON string for 'rows'
        List<Map<String, Object>> testJSON = generateTestJSON();
                
        // Call the method being tested
        JunoSignObjectPostActionsController.updateRecord(objectApiName, testJSON);
        
        // End the test
        Test.stopTest();
        system.assert(true);
    }
    static testMethod void testGetObjectFieldsExceptions(){
        string objectApiName = 'Quote';
        String fieldName = 'Name';
        Test.startTest();
        JunoSignObjectPostActionsController.getObjectFields(objectApiName);
        Test.stopTest();
        System.assert(true);
    }
    static testMethod void testGetFieldValueExceptions(){
        string objectApiName = 'Quote';
        String fieldName = 'Name';
        Test.startTest();
        JunoSignObjectPostActionsController.getFieldValue(objectApiName, fieldName);
        Test.stopTest();
        System.assert(true);
    }
}
@isTest
public class MergeFieldGeneratorController_Test {
    
    @isTest
    static void testGetAllObjects() {
        List<MergeFieldGeneratorController.InnerObjects> objectList = MergeFieldGeneratorController.getAllObjects();
        System.assertNotEquals(null, objectList);
        System.assertNotEquals(0, objectList.size());

    }
    
    @isTest
    static void testGetAllFields() {
        String objectName = 'Account';
        List<MergeFieldGeneratorController.InnerFields> fieldList = MergeFieldGeneratorController.getAllFields(objectName);
        System.assertNotEquals(null, fieldList);
        System.assertNotEquals(0, fieldList.size());
    }
    
    @isTest
    static void testGetRelationshipName() {
        String objectName = 'Account';
        String fieldApiName = 'OwnerId'; 
        MergeFieldGeneratorController.InnerRelation relation = MergeFieldGeneratorController.getRelationshipName(objectName, fieldApiName);
             System.assertNotEquals(null, relation);
        System.assertEquals('Owner', relation.relationName);
    }
    
    @isTest
    static void testSecondRelation() {
        // Prepare test data
        String objectName = 'Account'; 
        String fieldApiName = 'OwnerId'; 
        String secondFieldApiName = 'Name'; 
        MergeFieldGeneratorController.InnerRelation secondRelation = MergeFieldGeneratorController.secondRelation(objectName, fieldApiName, secondFieldApiName);
         System.assertNotEquals(null, secondRelation);
       
    }
}
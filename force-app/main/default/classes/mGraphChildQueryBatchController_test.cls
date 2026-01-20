@isTest
public class mGraphChildQueryBatchController_test {
    
    @isTest
    static void testBatchClass() {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test con';
        con.AccountId = acc.Id;
        insert con;
        
        JunoDoc__Junodoc_Parent_Configuration__c childConfig = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        childConfig.Junodoc_SOQL_Query__c = 'SELECT ALL FROM JunoDoc__Doc_Template_Item__c';
        String parentQuery =  'SELECT ALL FROM JUNODOC__DOC_TEMPLATE__C WHERE ID != null';
        List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();
        childQueries.add(new JunoSFDC2SFDC.childQueriesInnerClass(childConfig, 'JunoDoc__Doc_Template__c', 1));
        
        string referList = '[objectFieldValues=null, objectName=JUNODOC__DOC_TEMPLATE__C, referenceFieldRequired=false, referenceHasRecordTypes=false, referenceObjectFieldName=JunoDoc__Doc_Template_Footer__c, referenceObjectName=JunoDoc__Doc_Template_Footer__c, referenceSelected=true]';
        List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
        
        SobjectUtilityController.objectReferenceFieldAttributesInnerClass dot = new SobjectUtilityController.objectReferenceFieldAttributesInnerClass('JunoDoc__Doc_Template_Footer__c','JunoDoc__Doc_Template_Footer__c',false,'JUNODOC__DOC_TEMPLATE__C',false);
        
        selectedReferenceList.add(dot);         
        Integer batchId = 116;
        String destinationOrg = 'Test Destination';
        String currentScheduleIds = '';
        Boolean includeAttachments = false;
        Map<String, String> childQueryCompletedMap = new Map<String, String>();
        Decimal batchSize =30;
        
        mGraphChildQueryBatchController batchClassInstance = new mGraphChildQueryBatchController(
            parentQuery,
            childQueries,
            selectedReferenceList,
            batchId,
            destinationOrg,
            currentScheduleIds,             
            includeAttachments,
            childQueryCompletedMap,
            batchSize
        );
        batchClassInstance.stopExecute = false;
        
        Database.executeBatch(batchClassInstance); 
    }
    
    
    
}
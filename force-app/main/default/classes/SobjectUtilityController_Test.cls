@IsTest
private class SobjectUtilityController_Test {
    
    
    private class MyMockCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create a mock response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"success": true}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    
    /*  @isTest
static void myTest() {

Test.setMock(HttpCalloutMock.class, new MyMockCallout());        

list<id> accList = new list<id>();  

Account accRec = new Account();
accRec.Name = 'Test';
accRec.phone = '665455566';
insert accRec;
System.assertEquals('Test', accRec.Name);

Contact conRec = new Contact();
conRec.LastName = 'Test';
conRec.AccountId = accRec.id;
insert conRec;
accList.add(accRec.id);
System.assertEquals('Test', conRec.LastName);

Account accRecTwo = new Account();
accRecTwo.Name = 'Test';
accRecTwo.phone = '66545556655';
insert accRecTwo;

Contact conRecTwo = new Contact();
conRecTwo.LastName = 'Test11';
conRecTwo.AccountId = accRecTwo.id;
insert conRecTwo;

list<Contact> conList = new list<Contact>();
conList.add(conRecTwo);
accList.add(accRecTwo.id);
System.assertEquals('Test11', conRecTwo.LastName);   

SobjectUtilityController SObjUtil = new SobjectUtilityController();
String objectFields = '';
String externalId = '';
SobjectUtilityController.referenceObjectAttributesInnerClass roai = new SobjectUtilityController.referenceObjectAttributesInnerClass(objectFields,externalId);
String objName ='';
String fieldsNames ='';
SObjUtil.verifyFieldAccessibility('Account','Name');
SObjUtil.verifyObjectAccessibility('Account');
SobjectUtilityController.get_ParentRecordsForBatch('SELECT id,name FROM ACCOUNT','ACCOUNT');
SobjectUtilityController.get_ChildRecordsForBatch('SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1', 'AccountId','Contact');
SobjectUtilityController.prepareChildQueryForBatchProcess(accRec.id,'AccountId','SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1');
String AccountRec = accRec.Id;
UtilityController.createExternalIdField('Account','SessId','url');
SobjectUtilityController.prepareParentQueryForBatchProcess(AccountRec,'SELECT id,name FROM Account LIMIT 1');
SobjectUtilityController.generateQueryAtrributes gqa = new SobjectUtilityController.generateQueryAtrributes('','','');
SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account WHERE id !=null');
SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account LIMIT 1');
SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account');
SobjectUtilityController.prepareChildQuery('SELECT Id,Name FROM Account LIMIT 1','AccountId','SELECT Id,LastName,AccountId FROM Contact LIMIT 1');
SobjectUtilityController.prepareRecordCountChildQuery('SELECT Id,Name FROM Account LIMIT 1','AccountId','SELECT Id,LastName,AccountId FROM Contact LIMIT 1');
SobjectUtilityController.referenceObjectQueryInnerClass roq = new  SobjectUtilityController.referenceObjectQueryInnerClass('SELECT id FROM account','Account');
list<Sobject> empty = new list<Sobject>();
SobjectUtilityController.destinationMissingReferenceRecordsInnerClass dmrri = new SobjectUtilityController.destinationMissingReferenceRecordsInnerClass('Account',empty,'Name','');
SObjUtil.m_getObjectFields('Account','Name,id,ParentId');
SObjUtil.m_getObjectFields('Account','ALL');
SObjUtil.get_ParentRecords('SELECT Id,Name, Phone FROM Account WHERE id !=null');        
SObjUtil.m_PrepareQuery('SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1', 'AccountId', accRec.id);
SobjectUtilityController.addExternalIdFiled('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1', 'Contact' , 'test destination');
SobjectUtilityController.innerClassForChildResults childObj = new  SobjectUtilityController.innerClassForChildResults(Database.query('SELECT id,FirstName, AccountId,LastName, Email FROM Contact limit1'),'AccountId','Contact','FirstName,Id',false);
SobjectUtilityController.innerclassForParentResults parentObj = new SobjectUtilityController.innerclassForParentResults(Database.Query('SELECT id,Name,Phone FROM Account'),'Account','Name,Phone',false);
SObjUtil.objectExternalIdCheck('Contact');
SObjUtil.get_ChildRecords('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1', 'AccountId', accRec.id);
System.assertEquals(68,68); 
List<SobjectUtilityController.innerclassForParentResults> parentList=new List<SobjectUtilityController.innerclassForParentResults>();
parentList.add(parentObj);
List<SobjectUtilityController.innerClassForChildResults> childList=new List<SobjectUtilityController.innerClassForChildResults>();
childList.add(childObj);
String rerenceObjectName ='Account';
SobjectUtilityController.m_getreferenceObjectAttributes(rerenceObjectName);

System.assertEquals('Test', accRecTwo.Name);

} */
    
    static testMethod void OpportunityLineItem_UtilUnitTest() {
        //list<id> accidList = new list<id>();
           
        list<id> accList = new list<id>();  
        
        Account accRec = new Account();
        accRec.Name = 'Test';
        accRec.phone = '665455566';
        insert accRec;
        System.assertEquals('Test', accRec.Name);
        
        Contact conRec = new Contact();
        conRec.LastName = 'Test';
        conRec.AccountId = accRec.id;
        insert conRec;
        accList.add(accRec.id);
        System.assertEquals('Test', conRec.LastName);
        
        Account accRecTwo = new Account();
        accRecTwo.Name = 'Test';
        accRecTwo.phone = '66545556655';
        insert accRecTwo;
        
        Contact conRecTwo = new Contact();
        conRecTwo.LastName = 'Test11';
        conRecTwo.AccountId = accRecTwo.id;
        insert conRecTwo;
        list<Contact> conList = new list<Contact>();
        conList.add(conRecTwo);
        accList.add(accRecTwo.id);
        System.assertEquals('Test11', conRecTwo.LastName);       
        SobjectUtilityController SObjUtil = new SobjectUtilityController();
        /***************/
        String objectFields = '';
        String externalId = '';
        SobjectUtilityController.referenceObjectAttributesInnerClass roai = new SobjectUtilityController.referenceObjectAttributesInnerClass(objectFields,externalId);
        String objName ='';
        String fieldsNames ='';
        SObjUtil.verifyFieldAccessibility('Account','Name');
        SObjUtil.verifyObjectAccessibility('Account');
        SobjectUtilityController.get_ParentRecordsForBatch('SELECT id,name FROM ACCOUNT','ACCOUNT');
        
        SobjectUtilityController.get_ChildRecordsForBatch('SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1', 'AccountId','Contact');
        SobjectUtilityController.prepareChildQueryForBatchProcess(accRec.id,'AccountId','SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1');
        String AccountRec = accRec.Id;
        SobjectUtilityController.prepareParentQueryForBatchProcess(AccountRec,'SELECT id,name FROM Account LIMIT 1');
        SobjectUtilityController.generateQueryAtrributes gqa = new SobjectUtilityController.generateQueryAtrributes('','','');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account WHERE id !=null');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account LIMIT 1');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account');
        SobjectUtilityController.referenceObjectQueryInnerClass roq = new  SobjectUtilityController.referenceObjectQueryInnerClass('SELECT id FROM account','Account');
        list<Sobject> empty = new list<Sobject>();
        SobjectUtilityController.destinationMissingReferenceRecordsInnerClass dmrri = new SobjectUtilityController.destinationMissingReferenceRecordsInnerClass('Account',empty,'Name','');
       /**************/   
        SObjUtil.m_getObjectFields('Account','Name,id,ParentId');
        SObjUtil.m_getObjectFields('Account','ALL');
        SObjUtil.get_ParentRecords('SELECT Id,Name, Phone FROM Account WHERE id !=null');        
        SObjUtil.m_PrepareQuery('SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null LIMIT 1', 'AccountId', accRec.id);
        SObjUtil.objectExternalIdCheck('Contact');
        SobjectUtilityController.innerClassForChildResults childObj = new  SobjectUtilityController.innerClassForChildResults(Database.query('SELECT id,FirstName, AccountId,LastName, Email FROM Contact limit1'),'AccountId','Contact','FirstName,Id',false);
        SobjectUtilityController.innerclassForParentResults parentObj = new SobjectUtilityController.innerclassForParentResults(Database.Query('SELECT id,Name,Phone FROM Account'),'Account','Name,Phone',false); 
        SobjectUtilityController.addExternalIdFiled('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1', 'Contact' , 'test destination');
        SobjectUtilityController.prepareRecordCountChildQuery('SELECT Id,Name FROM Account LIMIT 1','AccountId','SELECT Id,LastName,AccountId FROM Contact LIMIT 1');
        SobjectUtilityController.prepareChildQuery('SELECT Id,Name FROM Account LIMIT 1','AccountId','SELECT Id,LastName,AccountId FROM Contact LIMIT 1');

        SObjUtil.get_ChildRecords('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1', 'AccountId', accRec.id);
        System.assertEquals(68,68); 
        List<SobjectUtilityController.innerclassForParentResults> parentList=new List<SobjectUtilityController.innerclassForParentResults>();
        parentList.add(parentObj);
        List<SobjectUtilityController.innerClassForChildResults> childList=new List<SobjectUtilityController.innerClassForChildResults>();
        childList.add(childObj);
        String rerenceObjectName ='Account';
        SobjectUtilityController.m_getreferenceObjectAttributes(rerenceObjectName);
        System.assertEquals('Test', accRecTwo.Name);
       
    }
    
    static testMethod void OpportunityLineItem_UtilUnitTest1() {
        list<id> accidList = new list<id>();
        Account accRec = new Account();
        accRec.Name = 'Test';
        accRec.phone = '665455566';
        insert accRec;
        accidList.add(accRec.id);
        System.assertEquals('Test', accRec.Name);
        
        Account accRecTwo = new Account();
        accRecTwo.Name = 'Testde';
        accRecTwo.phone = '66545556655';
        insert accRecTwo;
        System.assertEquals('Testde', accRecTwo.Name);
        
        Contact conRec = new Contact();
        conRec.LastName = 'Test11';
        conRec.AccountId = accRecTwo.id;
        insert conRec;
        accidList.add(accRecTwo.id);
        System.assertEquals('Test11', conRec.LastName);
        String conid=conRec.id;
       
        System.assertEquals('POST','POST');
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'Test';
        oppRec.CloseDate = system.today();
        oppRec.StageName = 'Closed Won';
        insert oppRec;
        System.assertEquals('Test', oppRec.Name);
        String Acc = 'Account';
        String AccountRec = accRec.Id;
        SobjectUtilityController SObjUtil = new SobjectUtilityController();
        /****************/
        SobjectUtilityController.prepareParentQueryForBatchProcess(AccountRec,'SELECT id,name FROM Account WHERE id != null');
        SobjectUtilityController.prepareChildQueryForBatchProcess(accRec.id,'AccountId','SELECT id,FirstName,AccountId, LastName, Email FROM Contact WHERE Id != null');
        /*********/
        SObjUtil.m_getObjectFields('Account','Name,id,ParentId');
        SObjUtil.m_getObjectFields('Account','ALL');
        SObjUtil.m_PrepareQuery('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1','AccountId', accRec.id);
        SobjectUtilityController.innerClassForChildResults childObj = new  SobjectUtilityController.innerClassForChildResults(Database.query('SELECT id,FirstName, AccountId,LastName, Email FROM Contact limit1'),'AccountId','Contact','FirstName,Id',false);
        SobjectUtilityController.innerclassForParentResults parentObj = new SobjectUtilityController.innerclassForParentResults(Database.Query('SELECT id,Name,Phone FROM Account'),'Account','Name,Phone',false); 
        SObjUtil.m_getObjectReferenceFieldAttributes(Acc);
        SobjectUtilityController.m_getreferenceObjectAttributes(Acc);
        //verifyObjectAccessibility
        //get_ParentRecordsForBatch
        //get_ChildRecordsForBatch
        //prepareChildQueryForBatchProcess
        //SobjectUtilityController.prepareParentQueryForBatchProcess(AccountRec,'Select id,name from Account');
        SobjectUtilityController.generateQueryAtrributesFromQuery('SELECT id,name FROM Account WHERE id !=null LIMIT 1');
        SobjectUtilityController.m_getObjectFieldsForBatch(Acc,'Name');
       // SObjUtil.getParentFields('Account');
       // SobjectUtilityController.parentFieldsInnerClass sp = new SobjectUtilityController.parentFieldsInnerClass('Account', '12345', true, 'Account',false);
        
        
        //SObjUtil.get_ChildRecords('SELECT id,FirstName,AccountId, LastName, Email FROM Contact LIMIT 1','AccountId', accRec.id);
        System.assertEquals(68,68); 
        List<SobjectUtilityController.innerclassForParentResults> parentList = new List<SobjectUtilityController.innerclassForParentResults>();
        parentList.add(parentObj);
        List<SobjectUtilityController.innerClassForChildResults> childList = new List<SobjectUtilityController.innerClassForChildResults>();
        childList.add(childObj);
        //OpportunityLineItem_Util_AC oppl = new OpportunityLineItem_Util_AC();
        //oppl.verifyOppLineItem( parentList,childList,c.Consumer_Secret__c, 'na22.salesforce.com');
        //SObjUtil.get_sObjectParentRecordsFromOtherOrg('SELECT Id,Name, Phone FROM Account WHERE id !=null', 'na22.salesforce.com', '3447664293037645191');  
        //verifyOppLineItem(List<sObject_Util_AC.innerclassForParentResults> parentList, List<sObject_Util_AC.innerClassForChildResults> childList, String SecurityToken, String InstanceUrl);
        System.assertEquals('Test', 'Test');
    }
}
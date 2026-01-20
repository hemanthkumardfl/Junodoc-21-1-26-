@isTest
public class JunodocBatchController_TC {
    @testSetup
    static void setup() {
        Junodoc_Batch__c juno = new Junodoc_Batch__c();
        juno.Name = 'Test';
        juno.Object__c = 'Account';
        juno.Query__c = 'select id,Name,createdDate,LastModifiedDate from Account Where ( Name != null)  order by LastModifiedDate desc limit 90';
        insert juno;
        
        Account acc = new Account();
        acc.Name = 'Testing';
        acc.type = 'Customer';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Testing2';
        insert acc1;
        
         Doc_Template__c doc = new Doc_Template__c();
        doc.Name = 'Test Doc';
        doc.Parent_Object__c = 'Account';
        insert doc;
        
        Junodoc_Batch_Settings__c settings = new Junodoc_Batch_Settings__c();
        settings.Junodoc_Templates__c = doc.Id;
        settings.Junodoc_Batch__c = juno.Id;
        settings.SOQL_Query__c = juno.Query__c;
        insert settings;
        
         Juno_Doc_Trigger__c junodoc = new Juno_Doc_Trigger__c();
        junodoc.IsActive__c = true;
        junodoc.Name = 'test trigger';
        junodoc.Object_Name__c = 'Account';
        insert junodoc;
        
        Juno_Doc_Trigger_Action__c  action = new Juno_Doc_Trigger_Action__c();
        action.Users_Email_Addresses__c = 'dfl@testing.com';
        action.Juno_Doc_Trigger__c = junodoc.Id;
        insert action;
        
        Junodoc_Post_Trigger_Actions__c post = new Junodoc_Post_Trigger_Actions__c();
        post.Field_Name__c = 'Name';
        post.Value__c = 'null';
        post.Row_Number__c = 1;
        post.Junodoc_Batch_Settings__c = settings.Id;
        insert post;
        
        Juno_Doc_Post_Trigger_Action__c postTrigger = new Juno_Doc_Post_Trigger_Action__c();
        postTrigger.Field__c = 'Name';
        postTrigger.Value__c = 'Test';
        postTrigger.Juno_Doc_Trigger__c = junodoc.Id;
        insert postTrigger;
        
            Juno_Doc_Trigger_Condition__c triggerCond = new Juno_Doc_Trigger_Condition__c();
        triggerCond.Field__c = 'Name';
        triggerCond.Value__c = 'null';
        triggerCond.Operator__c = 'Not Equal to';
        triggerCond.RowNumber__c = 1;
        triggerCond.Juno_Doc_Trigger__c = junodoc.Id;
        insert triggerCond;
    }
    
      static testMethod void test() {
         JunodocBatchController.getPageloadDataHelper();
         JunodocBatchController.getObjectDataHelper('Account');
         //JunodocBatchController.TriggerActionsTabClick();
         list<Account> accRecords = [select id,name from Account limit 1];
         String objName = 'Account';
         list<Juno_Doc_Trigger_Condition__c> TriggerConidtionsList = [select id,Name,Field__c, Operator__c, Value__c,
                                                                     Juno_Doc_Trigger__r.Object_Name__c,
                                                                     RowNumber__c
                                                                     From Juno_Doc_Trigger_Condition__c 
                                                                     Where Juno_Doc_Trigger__r.Object_Name__c='Account'
                                                                     limit 49000
                                                                    ];
         JunodocBatchController.getSelectOptionFields(objName);
         String obj = 'Opportunity';
         String picklistField = 'stageName';
         JunodocBatchController.getSelectedPicklistValues(obj,picklistField);
         JunodocBatchController.getQueryBatch(objName);
         list<Junodoc_Batch__c> batchList = [select Id,name from Junodoc_Batch__c];
         String batchId = batchList[0].Id;
         list<Junodoc_Batch_Filter_Conditions__c> filterConditions = [select id,Field__c,Field_Value__c,Operator__c,Row_Number__c,Type__c,Junodoc_Batch__c
                                                                 from Junodoc_Batch_Filter_Conditions__c
                                                                 where Junodoc_Batch__c =: batchList[0].Id];

         JunodocBatchController.ExecuteSearchQuery(batchId);
         
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c,Template_Type__c
                                                  from Doc_Template__c 
                                                  where Parent_Object__c = 'Account'];
        list<Junodoc_Batch_Settings__c> JunosettingsList = [select id,
                                                            Junodoc_Templates__c,Junodoc_Batch__c,
                                                            Junodoc_Templates__r.parent_Object__c,
                                                            SOQL_Query__c,
                                                            Report_ID__c
                                                            from Junodoc_Batch_Settings__c
                                                            where Junodoc_Batch__c =: batchId order by CreatedDate desc limit 1];    
         list<Junodoc_Post_Trigger_Actions__c> TriggerActions = [select id,Field_Name__c,Row_Number__c,Value__c,Junodoc_Batch_Settings__c
                                                                    from Junodoc_Post_Trigger_Actions__c 
                                                                    where Junodoc_Batch_Settings__c=:JunosettingsList[0].Id];   
         JunodocBatchController.getAvailableDocTemplates('Account',accRecords[0].Id,batchId);
        
         list<JunodocBatchController.PostActionWrapper> wrapperList = new list<JunodocBatchController.PostActionWrapper>();
         JunodocBatchController.PostActionWrapper wrapper= new JunodocBatchController.PostActionWrapper();
         wrapper.Field = 'Name';
         wrapper.Value = 'Test';
         wrapper.RowNumber = 1;
         wrapperList.add(wrapper);
         JunodocBatchController.SaveTemplateAndPostActions('Account',availableDocList[0].Id,JSON.serialize(wrapperList),batchId);
         List<Object> records = new List<Object>();
         //(List<Object>)JSON.deserializeUntyped('[{"Field":"Name","Value":"Test"},{"Field":"Type","Value":"Customer"}]');
         list<string> selectedRecordIds = new list<string>();
         for(Account acc:accRecords){
             selectedRecordIds.add(acc.Id);
         }
         JunodocBatchController.savePostTriggerActions('Account',records,selectedRecordIds);
         JunodocBatchController.getPageloadDataHelper();
     }
      static testMethod void SaveQueryToObjectTest() {
          list<Junodoc_Batch__c> batchList = [select Id,name,Query__c,Object__c from Junodoc_Batch__c];
          String Qry = 'select id,Name,createdDate,LastModifiedDate from Account Where ( Type = Customer)  order by LastModifiedDate desc limit 90';
          String recordsList = '[{"RowNumber":1,"field":"Type","Operator":"Equals","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
          String filterCons = '(1)';
          JunodocBatchController.SaveQueryToObject(batchList[0].Id,'Account',Qry,recordsList,filterCons,'Save','Test1');
          list<Juno_Doc_Trigger_Action__c> TriggerActionsList =  [select id,Name,Users_Email_Addresses__c, Contacts_Email_Addresses__c, Email_Addresses__c,
                                                                Email_Fields__c, Available_Doc_Template__c, Juno_Doc_Email_Template__c, 
                                                                Standard_Email_Template__c, Email_Subject__c, Save_as_Activitiy__c,
                                                                Juno_Doc_Trigger__r.Object_Name__c
                                                                From Juno_Doc_Trigger_Action__c 
                                                                Where Juno_Doc_Trigger__r.Object_Name__c='Account'
                                                               ];
          list<Juno_Doc_Post_Trigger_Action__c> PostTriggerActionsList = [select id,Name,Field__c, Value__c,
                                                                        Juno_Doc_Trigger__r.Object_Name__c
                                                                        From Juno_Doc_Post_Trigger_Action__c 
                                                                        Where Juno_Doc_Trigger__r.Object_Name__c='Account'
                                                                        ];
           JunodocBatchController.getTriggerAction('Account');
      }
    
    static testMethod void UpdateQueryToObjectTest() {
          list<Junodoc_Batch__c> batchList = [select Id,name,Query__c,Object__c from Junodoc_Batch__c];
          String recordsList = '[{"RowNumber":1,"field":"Type","Operator":"Equals","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
          String Qry = 'select id,Name,createdDate,LastModifiedDate from Account Where ( Type = Customer)  order by LastModifiedDate desc limit 90';
           String filterCons = '(1)';
          JunodocBatchController.SaveQueryToObject(batchList[0].Id,'Account',Qry,recordsList,filterCons,'Update','');
      }
     static testMethod void getAllRecordTest() {
         String Obj = 'Account';
         String filterCons = '(1)';
         String recordsList = '[{"RowNumber":1,"field":"Type","Operator":"Equals","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList,filterCons);
         String recordsList1 = '[{"RowNumber":1,"field":"Type","Operator":"Not Equal to","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList1,filterCons);
         String recordsList2 = '[{"RowNumber":1,"field":"Type","Operator":"Contains","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList2,filterCons);
         String recordsList3 = '[{"RowNumber":1,"field":"Type","Operator":"Does not contain","fieldValue":"Customer","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList3,filterCons);
         String recordsList4 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Greater than","fieldValue":"3","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList4,filterCons);
         String recordsList5 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Less than","fieldValue":"3","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList5,filterCons);
         String recordsList6 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Greater or equal","fieldValue":"3","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList6,filterCons);
         String recordsList7 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Less or equal","fieldValue":"2","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList7,filterCons);
         String recordsList8 = '[{"RowNumber":1,"field":"CreatedDate","Operator":"Not Equal to","fieldValue":"null","type":"DATETIME","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList8,filterCons);
         String recordsList9 = '[{"RowNumber":1,"field":"Name","Operator":"Contains","fieldValue":"test","type":"STRING","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList9,filterCons);
         String recordsList10 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Not Equal to","fieldValue":"2","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList10,filterCons);
         String recordsList11 = '[{"RowNumber":1,"field":"NumberOfEmployees","Operator":"Not Equal to","fieldValue":"10,00","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList11,filterCons);         
         String recordsList12 = '[{"RowNumber":1,"field":"CreatedDate","Operator":"Not Equal to","fieldValue":"null","type":"INTEGER","isPicklist":false,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList12,filterCons);                  
         String recordsList13 = '[{"RowNumber":1,"field":"Type","Operator":"Equals","fieldValue":"Customer,Other","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList13,filterCons);         
         String recordsList14 = '[{"RowNumber":1,"field":"CreatedDate","Operator":"Equals","fieldValue":"TODAY","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList14,filterCons);   
         String recordsList15 = '[{"RowNumber":1,"field":"Type","Operator":"Not Equal to","fieldValue":"Customer,Other","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList15,filterCons);    
         String recordsList16 = '[{"RowNumber":1,"field":"Type","Operator":"Contains","fieldValue":"Customer,Other","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList16,filterCons);         
         String recordsList17 = '[{"RowNumber":1,"field":"Type","Operator":"Does not contain","fieldValue":"Customer,Other","type":"PICKLIST","isPicklist":true,"isBoolean":false}]';
         JunodocBatchController.getAllRecords(Obj,recordsList17,filterCons);
        
     }
}
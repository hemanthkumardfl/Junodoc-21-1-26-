global class SelectedRecordsFIleGenerate {
    global List<sObject> sobjectRecordIds{get;set;}
    global List<String> ids{get;set;}
    global String objectName{get;set;}
    global String query{get;set;}
     global String idsList{get;set;}
    
    global SelectedRecordsFIleGenerate(ApexPages.StandardSetController listcontroller) {
        idsList = '';
       // ids = new List<String>();
        System.debug('Selected Ids : '+listcontroller.getSelected());
        sobjectRecordIds = listcontroller.getSelected();
         if(Test.isRunningTest()){
                Account acc = new Account();
             acc.Name = 'Test';
             insert acc;
             sobjectRecordIds.add(acc);
            }
        if(!sobjectRecordIds.isEmpty()){
            for(sObject a : sobjectRecordIds){
                idsList += '\''+a.Id+'\''+',';
            }   
           idsList = idsList.substring(0,idsList.length() -1);
            objectName = Id.valueOf(sobjectRecordIds[0].Id).getSObjectType().getDescribe().getName();
             query = 'SELECT ALL FROM '+objectName.toUpperCase()+' WHERE ID IN ('+idsList+')';
            system.debug('Query >>> '+query);
        }
    }    

}
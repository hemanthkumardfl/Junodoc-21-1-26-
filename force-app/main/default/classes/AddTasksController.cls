public class AddTasksController {
    @AuraEnabled
    public static List<String> getPriority(sObject EngagementTask, String priority){
        List <String> priorityeOpts = new list <String>();
        Schema.sObjectType objType = EngagementTask.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String,Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(priority).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            priorityeOpts.add(a.getValue());
        }
        system.debug('TypeOpts ---->' + priorityeOpts);
        priorityeOpts.sort();
        return priorityeOpts;
    }
    
    @AuraEnabled
    public static List<String> getStatus(sObject EngagementTask, String status){
        List <String> statusOpts = new list <String>();
        Schema.sObjectType objType = EngagementTask.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String,Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(status).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            statusOpts.add(a.getValue());
        }
        system.debug('TypeOpts ---->' + statusOpts);
        statusOpts.sort();
        return statusOpts;
    }
    
    @AuraEnabled
    public static List<String> getType(sObject EngagementTask, String fieldname){
        List <String> TypeOpts = new list <String>();
        Schema.sObjectType objType = EngagementTask.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String,Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fieldname).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            TypeOpts.add(a.getValue());
        }
        system.debug('TypeOpts ---->' + TypeOpts);
        TypeOpts.sort();
        return TypeOpts;
    }
    
    @AuraEnabled
	public static String getreport(){
    //Using report id for example purpose
    Report reportRec = [SELECT
                                    Id
                            FROM Report
                            WHERE Id = '00O3h000003L6gqEAC'];

    Reports.ReportResults reportResult =
            Reports.ReportManager.runReport(reportRec.Id, true);

    return JSON.serialize(reportResult);
}
    
    @AuraEnabled
    public static String getPdfContent(String imageId){
        Account acc = new Account();
        acc.Name = 'Test Account Today';
        insert acc;

        imageId = imageId.substring(imageId.indexOf(',')+1,imageId.length());
        blob fileContent = EncodingUtil.base64Decode(imageId);
    
        Attachment att = new Attachment();
        att.Name = 'Report Chart';
        att.ParentId = acc.Id;
        att.Body = fileContent;
        att.contentType = 'image/png';
        insert att;
        return att.Id;
    }
    
    
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content = visualforcePage.getContent().toString();
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
    
}
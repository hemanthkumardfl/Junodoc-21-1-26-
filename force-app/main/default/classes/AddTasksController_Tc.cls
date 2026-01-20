@istest
public class AddTasksController_Tc {
    
    public static testMethod void Test(){
       
        Account acc = new Account();
        acc.Name = 'Test Account Today';
        acc.Rating = 'Hot';
        insert acc;
       
        string priority = 'priority';
       /* Attachment att = new Attachment();
        att.Name = 'Report Chart';
        att.ParentId = acc.Id;
       // att.Body = fileContent;
        att.contentType = 'image/png';
        insert att;*/
        
        /*EngagementTask__c testEngagementTask = new EngagementTask__c(Status__c = 'InProgress');
        insert testEngagementTask;*/
        
        
        AddTasksController.getPdfContent(acc.id);
        AddTasksController.getPriority(acc, 'Rating');
        AddTasksController.getStatus(acc, 'Rating');
        AddTasksController.getType(acc, 'Name');
        //AddTasksController.getreport();
    }

}
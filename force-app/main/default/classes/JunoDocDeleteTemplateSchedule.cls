global with sharing class JunoDocDeleteTemplateSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        JunoDocDeleteTemplateController.JunoDocDeleteTemplateControllerHelper();    
        
    }
    
}
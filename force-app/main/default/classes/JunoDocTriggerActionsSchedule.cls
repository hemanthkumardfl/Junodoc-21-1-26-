global with sharing class JunoDocTriggerActionsSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {    
        JunoDocTriggerActionsScheduleController.JunoDocTriggerActionsScheduleHelper();        
    }
    
}
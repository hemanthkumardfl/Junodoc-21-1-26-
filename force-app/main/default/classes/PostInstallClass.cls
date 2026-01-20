global class PostInstallClass implements InstallHandler {
    
  global void onInstall(InstallContext context) {   
      
      //if(context.previousVersion() == null) {
      

            /*List<CronTrigger> abort_job = [SELECT ID, CronExpression, CronJobDetail.Name, 
                                           NextFireTime, PreviousFireTime, StartTime, State, TimesTriggered 
                                           FROM CronTrigger 
                                           Where NextFireTime != null 
                                           And CronJobDetail.Name like 'JunoDocTriggerActionsSchedule%'
                                          ];
            for (CronTrigger t : abort_job) { //for each record
                System.abortJob(t.Id); //abort the job
            }
      
            System.schedule('JunoDocTriggerActionsSchedule job1', '0 0 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job2', '0 5 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job3', '0 10 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job4', '0 15 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job5', '0 20 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job6', '0 25 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job7', '0 30 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job8', '0 35 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job9', '0 40 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job10', '0 45 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job11', '0 50 * * * ?', new JunoDocTriggerActionsSchedule());
            System.schedule('JunoDocTriggerActionsSchedule job12', '0 55 * * * ?', new JunoDocTriggerActionsSchedule());*/
      
      
      //}
            
      
  }
    
     
  
}
public class AuditData {
     @AuraEnabled
    public static List<Audit_Trail__c> getAudit(string AuditId)
   {
       system.debug('AuditId'+AuditId);
        return new List<Audit_Trail__c>([Select id,Name,JunoDoc__Date__c,Date_Time__c,IP_Address__c,JunoSign_Transaction__r.name,Status__c from Audit_Trail__c 
                                         where JunoSign_Transaction__c=:AuditId
                                         order by  JunoDoc__Date__c ASC]); //orderby Date_Time__c
    }
}
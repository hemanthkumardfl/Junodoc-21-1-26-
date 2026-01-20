@isTest
public class AuditData_Test {
    public static testMethod void getAudits(){
   Audit_Trail__c adit = new Audit_Trail__c();
      insert adit;
       AuditData.getAudit (adit.Id);
        }
}
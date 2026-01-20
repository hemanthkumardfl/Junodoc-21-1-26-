@isTest
public class JunoDocDeleteTemplateTest {
    @isTest
        public static void setup(){
            
            JunoDoc__Doc_Template__c JunoDocTemp = new JunoDoc__Doc_Template__c ();
            JunoDocTemp.Name = 'Demo Junodoc';
            //JunoDocTemp.JunoDoc__PDF_Name__c = 'Junodoc - {!Name} - {!Account.Name} - {!TODAY()}';
            insert JunoDocTemp;
            
            JunoDoc__Juno_Sign_Transaction__c JunoDocTrans = new JunoDoc__Juno_Sign_Transaction__c();
            JunoDocTrans.Status__c = 'Sent';
            JunoDocTrans.JunoDoc__Original_Document_Id__c = JunoDocTemp.id;
            insert JunoDocTrans;

            JunoDoc__Juno_Sign_Recipient__c  Junoreci = new JunoDoc__Juno_Sign_Recipient__c ();
            Junoreci.JunoDoc__JunoSign_Expiration_Date__c = date.newInstance(2023, 1, 1);
            Junoreci.JunoDoc__Recipient_Name__c = 'Mac Wright'; 
            Junoreci.JunoDoc__Juno_Sign_Transaction__c =  JunoDocTrans.id; 
            insert Junoreci;
            
            list<JunoDoc__Juno_Sign_Recipient__c> Junoreclist = new  list<JunoDoc__Juno_Sign_Recipient__c>();
            Junoreclist = [select Id, Name,JunoDoc__JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c From JunoDoc__Juno_Sign_Recipient__c];
            
            JunoDoc__Doc_Template__c JunoDocTempNew = new JunoDoc__Doc_Template__c  ();
            JunoDocTempNew.Name = 'Cloned-'+JunoDocTemp.id  +'-tranid-'+Junoreci.JunoDoc__Juno_Sign_Transaction__c;
            insert JunoDocTempNew;
            
            list<JunoDoc__Doc_Template__c> JunoDocTemplateList = new list<JunoDoc__Doc_Template__c>();
            JunoDocTemplateList = [select id,name From JunoDoc__Doc_Template__c];
           
            JunoDocDeleteTemplateController.JunoDocDeleteTemplateControllerHelper();
            /*Test.startTest();
            
            JunoDocDeleteTemplateSchedule JDT = new JunoDocDeleteTemplateSchedule();            
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Territory Check', sch, JDT);    
            
            Test.stopTest();*/
        }
}
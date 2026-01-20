public class JunoDocDeleteTemplateController {
    
    public static void JunoDocDeleteTemplateControllerHelper(){
        
        date todayDate = system.today();
        System.debug('todaydate--->'+todayDate);
        
        list<JunoDoc__Juno_Sign_Recipient__c> JunoRecipientList = new list<JunoDoc__Juno_Sign_Recipient__c>();
        JunoRecipientList = [select Id, Name,JunoDoc__JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c From JunoDoc__Juno_Sign_Recipient__c Where JunoDoc__JunoSign_Expiration_Date__c < TODAY]; 
        List<JunoDoc__Juno_Sign_Recipient__c> UpdatedJunoRecipientList = new  List<JunoDoc__Juno_Sign_Recipient__c>();
        system.debug('JunoRecipientList--->'+JunoRecipientList);
        List<String> updatestring = new  List<String>();
        List<JunoDoc__Juno_Sign_Recipient__c> Recipienttoupdate = new  List<JunoDoc__Juno_Sign_Recipient__c>();
        if(JunoRecipientList.size()>0){
            for(JunoDoc__Juno_Sign_Recipient__c rec :JunoRecipientList ){
                JunoDoc__Juno_Sign_Recipient__c recipientNeedToUpdate = new JunoDoc__Juno_Sign_Recipient__c();
                recipientNeedToUpdate.Id = rec.Id;
                recipientNeedToUpdate.JunoDoc__Status__c = 'Expired';
                Recipienttoupdate.add(recipientNeedToUpdate);             
                String str = 'Cloned-'+rec.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c   +'-tranid-'+rec.JunoDoc__Juno_Sign_Transaction__c ;                   
                updatestring.add(str);
                system.debug('updatestring--->'+updatestring);
                
            }
        }
        
        if(updatestring.size() > 0){
            list<JunoDoc__Doc_Template__c> JunoDocTemplateList = new list<JunoDoc__Doc_Template__c>();
            JunoDocTemplateList = [select id,name From JunoDoc__Doc_Template__c Where Name IN :updatestring];
            system.debug('JunoDocTemplateList--->'+JunoDocTemplateList);
            
            if(JunoDocTemplateList.size()>0){
                delete JunoDocTemplateList;
            }
        }
        
        if(Recipienttoupdate.size() > 0){
            update Recipienttoupdate;
        }
    }
}
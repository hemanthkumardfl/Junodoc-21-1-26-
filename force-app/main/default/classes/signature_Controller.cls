global class signature_Controller {
    @AuraEnabled
    global static List<innerClass> getFileDeatils(string recordId){
        List<innerClass> innclsdata = new List<innerClass>();
        List<id> contids = new List<id>();
        Map<id,string> idTitlemap = new Map<id,string>();
        List<ContentDocumentLink> conlink = [select id,ContentDocumentId from ContentDocumentLink where LinkedEntityId=: recordId];
        for(ContentDocumentLink con:conlink){
            contids.add(con.ContentDocumentId);
        }
        
        List<contentversion> ves = [select title,ContentDocumentId from contentversion where ContentDocumentId In:contids];
        for(contentversion contves:ves){
            //idTitlemap.put(contves.ContentDocumentId,contves.title); 
            innerClass obc = new innerClass();
            obc.tit = contves.title;
            obc.fileid = contves.ContentDocumentId;
            innclsdata.add(obc);
            
        }
        return innclsdata;  
        
    }
    global class innerClass{
        @AuraEnabled
        global string tit;
        @AuraEnabled
        public string fileid;
        
    }
    @AuraEnabled
    public static void createrecord(string fileid,date expdate,string emailbody,string emailsub,List<innclass> recipent,string selectedProcess,string recordId){
       
                //system.debug('recipients number'+recipent.size());
                //system.debug('@@@@'+recipent);
                List<Juno_Sign_Recipient__c> recipentRecList = new List<Juno_Sign_Recipient__c>(); 
                Juno_Sign_Transaction__c junoSign = new Juno_Sign_Transaction__c();
                //junoSign.Name = 'test';
                
                junoSign.Object_Id__c = recordId;
                junoSign.Expiration_Date__c = expdate;
                junoSign.Email_Body__c  = emailbody;
                junoSign.Date_Sent__c = system.today();
                junoSign.Original_Document_Id__c = fileid;   // + '069e0000001lCCvAAM';
                junoSign.Email_Body__c  = emailbody;
                junoSign.Email_Subject__c = emailsub;
                junoSign.Sender_Name__c = UserInfo.getName();
                junoSign.Sender_Email__c = Userinfo.getUserEmail();
                junoSign.Status__c = 'Sent';
                insert junoSign;
                system.debug(junoSign);
                Integer i = 1;
                for(innclass jn:recipent){
                    Juno_Sign_Recipient__c juno = new Juno_Sign_Recipient__c();
                    juno.Recipient_Email__c = jn.Email;
                    juno.Recipient_Name__c = jn.Name;   
                    juno.Juno_Sign_Transaction__c = junoSign.id;
                    juno.Status__c = 'Not Sent';
                    juno.Sort_Order__c = i;
                    recipentRecList.add(juno);
                    i = i+1;
                }
                insert recipentRecList;
                system.debug('reciepent list-------------->'+recipentRecList);
                
                String SiteURL = '';
                List<Junodoc_Setting__c> listurl = [Select Site_URL__c FROM Junodoc_Setting__c LIMIT 1];
                if(listurl.size() > 0){
                    SiteURL = listurl[0].Site_URL__c; 
                }
                
                if(selectedProcess == 'Parallel'){
                    for(Juno_Sign_Recipient__c juno:[select id,Recipient_Email__c,Recipient_Name__c,Status__c,Juno_Sign_Transaction__c from Juno_Sign_Recipient__c where Juno_Sign_Transaction__c =: junoSign.id]){
                            system.debug('recipient data for ------>'+juno);
                            system.debug('@@@@--->'+juno.Status__c);
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { juno.Recipient_Email__c,UserInfo.getUserEmail() };
                                message.subject = junoSign.Email_Subject__c.Replace('{Name}',juno.Recipient_Name__c);
                            message.HTMLBody = junoSign.Email_Body__c.Replace('{URL}','<a href="'+SiteURL+'?id='+fileid+'&recid='+juno.id+'">Click Here</a>');
                            system.debug('message.HTMLBody'+message.HTMLBody);
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            
                            try{
                                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            }
                            catch(Exception e){
                                    
                            }
                            
                    Juno_Sign_Recipient__c jn = new Juno_Sign_Recipient__c();
                    jn.id = juno.id;
                    jn.Status__c = 'Pending';
                    update jn;
                        List<AuthSession> auth = [SELECT Id,UsersId, SourceIp FROM AuthSession];
                         Audit_Trail__c at = new Audit_Trail__c();
                        at.Name = juno.Recipient_Name__c;
                        at.Status__c = 'Pending';
                        at.Date_Time__c = DateTime.now();
                        at.JunoSign_Transaction__c =juno.Juno_Sign_Transaction__c;
                        at.IP_Address__c =auth[0].SourceIp;
                        insert at;
                }
            }
            else{
            
             for(Juno_Sign_Recipient__c juno:[select id,Recipient_Email__c,Recipient_Name__c,Status__c,Juno_Sign_Transaction__c from Juno_Sign_Recipient__c where Sort_Order__c=1 And Juno_Sign_Transaction__c =: junoSign.id]){
                system.debug('recipient data for ------>'+juno);
                system.debug('@@@@--->'+juno.Status__c);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { juno.Recipient_Email__c,UserInfo.getUserEmail() };
                if(juno.Recipient_Name__c != null && juno.Recipient_Name__c != ''){
                    message.subject = junoSign.Email_Subject__c.Replace('{Name}',juno.Recipient_Name__c);
                }
                else{
                    message.subject = junoSign.Email_Subject__c.Replace('{Name}',''); 
                }
                message.HTMLBody = junoSign.Email_Body__c.Replace('{URL}','<a href="'+SiteURL+'?id='+fileid+'&recid='+juno.id+'">Click Here</a>');
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                try{
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
                catch(Exception e){
                        
                }
                
                 List<AuthSession> auth = [SELECT Id,UsersId, SourceIp FROM AuthSession];
                Juno_Sign_Recipient__c jn = new Juno_Sign_Recipient__c();
                jn.id = juno.id;
                jn.Status__c = 'Pending';
                update jn;
                 Audit_Trail__c at = new Audit_Trail__c();
                    at.Name = juno.Recipient_Name__c;
                    at.Status__c = 'Pending';
                    at.Date_Time__c= DateTime.now();
                    at.JunoSign_Transaction__c =juno.Juno_Sign_Transaction__c;
                  at.IP_Address__c = auth[0].SourceIp;
                    insert at;
            }
        }
        
        /*if(recipent.size()==1){
            JunoDoc__Juno_Sign_Transaction__c juno = new JunoDoc__Juno_Sign_Transaction__c();
            juno.id=junoSign.id;
            juno.JunoDoc__Status__c ='completed';
            juno.JunoDoc__Date_Completed__c  = system.today();
            update juno;         
        }*/
        
        
    }
    
    
    /* @AuraEnabled
public static void sendEmail(){
for(Juno_Sign_Recipient__c juno:[select id,Recipient_Email__c,Recipient_Name__c,Status__c from Juno_Sign_Recipient__c where Status__c='Not Sent' ORDER BY Sort_Order__c limit 1]){
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
message.toAddresses = new String[] { juno.Recipient_Email__c };
message.subject = 'Opt Out Test Message';
message.plainTextBody = 'https://partial-dflpvtltd.cs15.force.com/JunoSignature/?id=069e0000001lCCvAAM&recid='+juno.id;
Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

Juno_Sign_Recipient__c jn = new Juno_Sign_Recipient__c();
jn.id = juno.id;
jn.Status__c = 'Pending';
update jn;
}

}*/
    /* @AuraEnabled
public static PageReference cancel(string recordId){
PageReference p = new PageReference('/'+recordId);
return p;
} */
    @AuraEnabled
    global static List<innclass> getEmail(){
        List<innclass> innList = new List<innclass>();
        List<ObjectClass> objContactList = new List<ObjectClass>();
        List<ObjectClass> objUserList = new List<ObjectClass>();
        List<Contact> Condata = [select id,Name,Email from contact where Email != null limit 500];
        for(Contact con:Condata){
            ObjectClass obj = new ObjectClass();
            obj.Name = con.Name;
            obj.Email = con.Email;
            objContactList.add(obj);
        }
        system.debug('Object Contact List'+objContactList);
        List<User> userData = [select id,Name,Email from User];
        for(User u:userData){
            ObjectClass obj = new ObjectClass();
            obj.Name = u.Name;
            obj.Email = u.Email;
            objUserList.add(obj);
        }
        system.debug('Object User List'+objUserList);
        innclass inn = new innclass();
        inn.ContactList = objContactList;
        inn.UserList = objUserList;
        inn.showEmail = true;
        inn.showContact = false;
        inn.showUser = false;
        inn.showEmaildrop = false;
        inn.showUserdrop = false;
        inn.Selectedvalue = 'Email';
        inn.Name = '';
        inn.Email = '';
        innList.add(inn);
        system.debug(''+innList);
        return innList;
       
    }
    
    
    global class ObjectClass{
        @AuraEnabled global String Name;
        @AuraEnabled global String Email;
        @AuraEnabled global List<ObjectClass> ContactList;
        @AuraEnabled global List<ObjectClass> UserList;
        
    }
    
    global class innclass{
        @AuraEnabled global String Name{get;set;}
        @AuraEnabled global String Email{get;set;}
        @AuraEnabled global String Selectedvalue{get;set;}
        @AuraEnabled global boolean showContact{get;set;}
        @AuraEnabled global boolean showEmail{get;set;}
        @AuraEnabled global boolean showUser{get;set;}
        
        @AuraEnabled global boolean showEmaildrop{get;set;}
        @AuraEnabled global boolean showUserdrop{get;set;}
        @AuraEnabled global List<ObjectClass> ContactList;
        @AuraEnabled global List<ObjectClass> UserList;
        
    }
    
    
    
}
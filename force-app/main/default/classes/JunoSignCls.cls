global without sharing class JunoSignCls {
    global string currentRecordId {get;set;}
    global string strImageBlob {get;set;}
    global boolean showSucessMessage{get;set;}
    global string showErrorMessage{get;set;}
    global boolean showRejError{get;set;}
    global string showMessage{get;set;}
    global boolean showError{get;set;}
    global transient string body {get;set;} 
    global transient string secondbody {get;set;} 
    global string filetitle {get;set;}
    global list<JunoDoc__JunoDoc_Setting__c> JunoSetting{get;set;}
    global JunoDoc__Juno_Sign_Recipient__c recipient{get;set;}
    global transient contentversion cont {get;set;}
    global string receipientid  {get;set;}
    
    //JunoDoc__Juno_Sign_Recipient__c recdata = [select id,JunoDoc__Recipient_Name__c,JunoDoc__Recipient_Email__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where id=:receipientid];
    global JunoSignCls(){ 
        system.debug('NewTest');
        reload = '';
        showSucessMessage = false;
        showRejError = false;
        showError = false;
        currentRecordId=ApexPages.currentPage().getParameters().get('id');
        receipientid=ApexPages.currentPage().getParameters().get('recid');  
        
         recipient = [select id,JunoDoc__Recipient_Name__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c,JunoDoc__status__c from JunoDoc__Juno_Sign_Recipient__c where id=:receipientid];
        JunoSetting = new list<JunoDoc__JunoDoc_Setting__c>();
        JunoSetting = [select id,JunoDoc__Signature_Success_Message__c,JunoDoc__Signature_Cancel_Message__c,JunoDoc__Site_URL__c from JunoDoc__JunoDoc_Setting__c limit 1];
        
        showMessage = 'Thank you for using Signature. Your Document has been attached to the Mail.';
        if(JunoSetting.size() > 0){
            
            if(JunoSetting[0].JunoDoc__Signature_Success_Message__c != '' && JunoSetting[0].JunoDoc__Signature_Success_Message__c != ''){
                showMessage = JunoSetting[0].JunoDoc__Signature_Success_Message__c;
            }
        }
      if(recipient.JunoDoc__status__c!='Rejected'){
        if(recipient.JunoDoc__status__c!='Signed'){ 
            if(recipient.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c >= system.today() || recipient.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c==null){

                if(currentRecordId != null && currentRecordId != ''){
                    cont = [select id,VersionData,title from contentversion where contentdocumentid =: currentRecordId];
                    //system.debug(cont.VersionData);
                    if(Encodingutil.base64encode(cont.VersionData).length() <= 5999950){
                        body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData));
                    }
                    else{
                        body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData)).substring(0,5999950);
                        secondbody= (Encodingutil.base64encode(cont.VersionData)).substring(5999950,Encodingutil.base64encode(cont.VersionData).length());
                    }
                    filetitle=cont.title;
                }
            }
            else{
                showRejError = true;
                showErrorMessage = 'Link has Expired';
                
            }
        }
    
        else{
            showRejError = true;
            showErrorMessage = 'You have already signed';
        }
    }else{
        showRejError = true;
        showErrorMessage = 'You have already rejected';
    }
    }
    
    global void callApexFunction(){
        //string testId = ApexPages.currentPage().getParameters().get('testId');
        /*if(testId != null && testId != ''){
            reload = '<script>setTimeout(function(){window.open("'+JunoSetting[0].JunoDoc__Site_URL__c+'?id='+currentRecordId+'&recid='+receipientid+'","_self");},100);</script>';
        } */
        if(receipientid != null && receipientid != ''){
            list<JunoDoc__Juno_Sign_Recipient__c> sign = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoDoc__status__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__status__c='Pending' and id=: receipientid];
            system.debug('@@@@@'+sign);
            if(!sign.isEmpty()){
                sign[0].JunoDoc__status__c = 'Viewed'; 
                if(sign[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c < system.today()){                   
                    sign[0].JunoDoc__status__c = 'Expired';                 
                }
                update sign[0];
                JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                             audit.Name = sign[0].JunoDoc__Recipient_Name__c;   
                             audit.JunoDoc__Date_Time__c = DateTime.now();
                             audit.JunoDoc__JunoSign_Transaction__c =sign[0].JunoDoc__Juno_Sign_Transaction__c;
                             audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');   
                             audit.JunoDoc__status__c   = sign[0].JunoDoc__status__c;
                             insert audit; 
            }
        }
    }
    
    global void Reference(){
        body = '';
        try{
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                    ownerId,
                                                    JunoDoc__Recipient_Name__c,
                                                    JunoDoc__Recipient_Email__c,
                                                    JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                    JunoDoc__Juno_Sign_Transaction__c,
                                                    JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                    JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                    JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c
                                                    from JunoDoc__Juno_Sign_Recipient__c 
                                                    where id=:receipientid];  
            if(recdata.size() > 0){
                contentVersion Conversion = [select title from contentVersion where ContentDocumentId=: recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c];
                string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
                PageReference p;
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient =Conversion.title+'-'+recdata[0].JunoDoc__Recipient_Name__c + generate +'.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = Conversion.title+'-'+recdata[0].JunoDoc__Recipient_Name__c + generate; // Display name of the files
                conVer.VersionData = Encodingutil.base64decode(strImageBlob); // converting your binary string to Blog
                system.debug('OwnerId ***'+ recdata[0].ownerId);
               // conVer.firstPublishLocationId= userinfo.getUserId();
               // conVer.OwnerId = recdata[0].ownerId; 
                insert conVer; 
                
                system.debug('@@@conVer'+conVer);
                ContentVersion con = [select id,OwnerId,contentdocumentid from ContentVersion where id=:conVer.id];
                con.ownerId = recdata[0].ownerId;
               update con;
                system.debug('@@@@conVer'+conVer);
                //Insert ContentVersion
                // First get the Content Document Id from ContentVersion Object
                Id conDocid = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conver.Id].ContentDocumentId;
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =:currentRecordId].ContentDocumentId;
                List<ContentDocumentLink> linkedlist=[select LinkedEntityId from ContentDocumentLink where ContentDocumentId=:conDoc ];
                
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId =recdata[0].id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                conDocLink.ContentDocumentId = conDocid;  //ContentDocumentId Id from ContentVersion
                conDocLink.shareType = 'I';
                conDocLink.Visibility = 'AllUsers'; 
                insert conDocLink;
                
                ContentDocumentLink parentconDocLink = New ContentDocumentLink();
                parentconDocLink.LinkedEntityId =recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                parentconDocLink.ContentDocumentId = conDocid;  //ContentDocumentId Id from ContentVersion
                parentconDocLink.shareType = 'I';
                parentconDocLink.Visibility = 'AllUsers'; 
                insert parentconDocLink;
                showSucessMessage = false;
                String SiteURL = '';
                List<JunoDoc__JunoDoc_Setting__c> listurl = [Select JunoDoc__Site_URL__c FROM JunoDoc__JunoDoc_Setting__c LIMIT 1];
                if(listurl.size() > 0){
                    SiteURL = listurl[0].JunoDoc__Site_URL__c; 
                }
                /*@@@@@*/
                List<string> paralleldata = new List<string>();
                list<JunoDoc__Juno_Sign_Recipient__c> JunorecList;
                List<JunoDoc__Juno_Sign_Recipient__c> parallellist = [select id,JunoDoc__status__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                
                for(JunoDoc__Juno_Sign_Recipient__c j :parallellist){
                    paralleldata.add(j.JunoDoc__status__c);
                }
                system.debug('paralleldata'+paralleldata);
                if(!paralleldata.contains('Not Sent')){
                    JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__status__c='Pending' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1]; 
                }else{
                    JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__status__c='Not Sent' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1];
                }
                system.debug('JunorecList===='+JunorecList);
                if(paralleldata.contains('Not Sent')){
                    system.debug('sequential operation');
                    if(JunorecList.size() > 0){
                        for(JunoDoc__Juno_Sign_Recipient__c juno: JunorecList){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { juno.JunoDoc__Recipient_Email__c };
                            message.subject = juno.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c;
                            message.HTMLBody =juno.JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c.Replace('{URL}','<a href="'+SiteURL+'?id='+conDocid+'&recid='+juno.id+'">Click Here</a>');
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            
                            JunoDoc__Juno_Sign_Recipient__c jn = new JunoDoc__Juno_Sign_Recipient__c();
                            jn.id = juno.id;
                            jn.JunoDoc__status__c = 'Pending';
                            update jn;
                            
                            JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                            audit.Name = JunorecList[0].JunoDoc__Recipient_Name__c; 
                            audit.JunoDoc__Date_Time__c = DateTime.now().addseconds(6);
                            audit.JunoDoc__JunoSign_Transaction__c = JunorecList[0].JunoDoc__Juno_Sign_Transaction__c;
                            audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');    
                            audit.JunoDoc__status__c    = 'Pending';
                                insert audit;
                        }
                    }
                    else{
                        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                  Name,
                                                                  JunoDoc__Final_Document_Id__c,
                                                                  JunoDoc__Date_Completed__c,
                                                                  JunoDoc__status__c
                                                                  from JunoDoc__Juno_Sign_Transaction__c
                                                                  where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                        
                        JunoSignTrans.JunoDoc__Final_Document_Id__c = conDocid;
                        JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                        JunoSignTrans.JunoDoc__status__c = 'Completed';
                        update JunoSignTrans;
                        system.debug('@@@@JunoSignTrans'+JunoSignTrans);                   
                    }
                }
                List<EmailTemplate> sender = [Select id,Name,Body,Subject from EmailTemplate where name='sender template' limit 1];
                List<EmailTemplate> signee = [Select id,Name,Body,Subject from EmailTemplate where name='signee template' limit 1];
                Messaging.SingleEmailMessage Signeemessage2 = new Messaging.SingleEmailMessage();
                Signeemessage2.toAddresses = new String[] { recdata[0].JunoDoc__Recipient_Email__c };
                Signeemessage2.subject = 'Signature completed successfully';
                Signeemessage2.HTMLBody = '<html>Hi,<br></br>'+ recdata[0].JunoDoc__Recipient_Name__c+'<br></br>Your signature has been completed successfully, your signature has been attached.<br></br>Thank you.</html>';
                
                Messaging.SingleEmailMessage sendermessage2 = new Messaging.SingleEmailMessage();
                sendermessage2.toAddresses = new String[] { 'sriramsree004@gmail.com'};
                sendermessage2.subject = 'Signature has been completed by Signee';
                sendermessage2.HTMLBody ='<html>Hi,'+ recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c+'<br></br>Your Signature has been signed by '+recdata[0].JunoDoc__Recipient_Name__c+ '<br></br>Thank you.</html>'; 
                
                List<Messaging.Emailfileattachment> signeefileAttachments = new List<Messaging.Emailfileattachment>();
                List<Messaging.Emailfileattachment> senderfileAttachments = new List<Messaging.Emailfileattachment>();
                Attachment a = new Attachment(); 
                if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                   && Schema.sObjectType.Attachment.fields.Name.isCreateable() /*&& Schema.sObjectType.Attachment.fields.Description.isCreateable()*/
                   && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                       a.Body = Encodingutil.base64decode(strImageBlob); 
                       a.ParentID = recdata[0].id; 
                       a.Name =  Conversion.title+'-'+recdata[0].JunoDoc__Recipient_Name__c + generate +'.pdf';
                       a.ContentType = 'application/pdf';
                       insert a; 
                       Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                       efa.setFileName(a.Name); 
                       efa.setBody(a.body); 
                       signeefileAttachments.add(efa);
                       senderfileAttachments.add(efa);
                       delete a;
                   }
                Signeemessage2.setFileAttachments(signeefileAttachments);
                sendermessage2.setFileAttachments(senderfileAttachments);
                Messaging.SingleEmailMessage[] Signeemessages2 =   new List<Messaging.SingleEmailMessage> {Signeemessage2};
                Messaging.SingleEmailMessage[] Sendermessages2 =   new List<Messaging.SingleEmailMessage> {sendermessage2};
                Messaging.SendEmailResult[] Signresults2 = Messaging.sendEmail(Signeemessages2);
                Messaging.SendEmailResult[] Senderresults2 = Messaging.sendEmail(Sendermessages2);               
                
                recdata[0].JunoDoc__status__c = 'Signed';
                recdata[0].JunoDoc__Signed_On__c=system.today();
                recdata[0].JunoDoc__Signed_File_Id__c= conDocid;
                update recdata;
                system.debug(paralleldata);
                if(!paralleldata.contains('Not Sent')){
                   List<JunoDoc__Juno_Sign_Recipient__c> JunoSign = [select id,JunoDoc__status__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__status__c = 'pending' or JunoDoc__status__c ='Viewed')];
                    system.debug('NewJunoSign'+JunoSign);
                    if(JunoSign.isEmpty()){
                        system.debug('JunoSign is empty');
                        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                              Name,
                                                              JunoDoc__Final_Document_Id__c,
                                                              JunoDoc__Date_Completed__c,
                                                              JunoDoc__status__c
                                                              from JunoDoc__Juno_Sign_Transaction__c
                                                              where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                         JunoSignTrans.JunoDoc__Final_Document_Id__c = conDocid;
                        JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                        JunoSignTrans.JunoDoc__status__c = 'Completed';
                        update JunoSignTrans;
                        system.debug('@@@@JunoSignTrans'+JunoSignTrans);
                    }
                    
                }
                
                
                JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                audit.JunoDoc__Date_Time__c = DateTime.now();
                audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                audit.JunoDoc__status__c    = 'Signed';
                insert audit;

                
            }       
            strImageBlob = ''; 
            showSucessMessage = true;   
            showErrorMessage = '';
        }
        Catch(Exception e){
            strImageBlob = ''; 
            showError = true;
            showSucessMessage = false;
            showErrorMessage = e.getMessage();
        }
    }
    
    global string reload{get;set;}
    global void RejectMethod(){
          
        showRejError = true;
        showErrorMessage = 'Signature is Rejected';
        body = '';
        secondbody = '';
        if(JunoSetting.size() > 0){
            if(JunoSetting[0].JunoDoc__Signature_Cancel_Message__c != '' && JunoSetting[0].JunoDoc__Signature_Cancel_Message__c != ''){
                showErrorMessage = JunoSetting[0].JunoDoc__Signature_Cancel_Message__c;
            }
        }
        JunoDoc__Juno_Sign_Recipient__c recipient = [select id,JunoDoc__Recipient_Name__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Expiration_Date__c,JunoDoc__status__c from JunoDoc__Juno_Sign_Recipient__c where id=:receipientid];
        recipient.JunoDoc__status__c = 'Rejected';
        update recipient;
        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                  Name,
                                                  JunoDoc__status__c
                                                  from JunoDoc__Juno_Sign_Transaction__c
                                                  where id =: recipient.JunoDoc__Juno_Sign_Transaction__c];
        
        JunoSignTrans.JunoDoc__status__c = 'Rejected';
        update JunoSignTrans;
                    
        JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
        audit.Name = recipient.JunoDoc__Recipient_Name__c;  
        audit.JunoDoc__Date_Time__c =DateTime.now();
        audit.JunoDoc__JunoSign_Transaction__c = recipient.JunoDoc__Juno_Sign_Transaction__c;
        audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        audit.JunoDoc__status__c    = 'Rejected';
        insert audit;
          
       // reload = '<script>setTimeout(function(){window.open("'+JunoSetting[0].JunoDoc__Site_URL__c+'?id='+currentRecordId+'&recid='+receipientid+'&testId=refresh","_self");},100);</script>';
       // system.debug('reloads '+ reload);  
    }
    global void CancelMethod(){
        showRejError = true;
        showErrorMessage = 'Your Signature is Canceled';  
        body = '';
        secondbody = '';
    }
}
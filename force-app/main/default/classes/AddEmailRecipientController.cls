Global class AddEmailRecipientController {
    
    @AuraEnabled
    public static String getObjectLabelName(string ObjAPIName){
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{ObjAPIName}); 
        String objectLabel = describeSobjectsResult[0].getLabel();
        System.debug(objectLabel);
        return objectLabel;
    }
    
    @AuraEnabled
    public static ResultWrapper getinitialObjectFields(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'REFERENCE' || String.ValueOf(dfield.getType()) == 'EMAIL'){
                    if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
                        wrapper.Label = string.valueOf(dfield.getLabel())+'>'; 
                        wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();              
                    }else{
                        wrapper.Label = string.valueOf(dfield.getLabel()); 
                        wrapper.LookUpAPIName = '';      
                    }
                    wrapper.APIName = dfield.getName(); 
                    ObjectWrapperList.Add(wrapper);
                }
            }
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = true;
            Result.Message = 'Success';
            Result.WrapperList = ObjectWrapperList;
            return Result;
        }catch(Exception ex){
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = false;
            Result.Message = ex.getMessage();
            return Result;
        }
    }
    
    @AuraEnabled
    public static ResultWrapper getAllObjectFields(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(String.ValueOf(dfield.getType()) == 'REFERENCE' || String.ValueOf(dfield.getType()) == 'EMAIL'){
                    if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
                        wrapper.Label = string.valueOf(dfield.getLabel())+'>';
                        wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();
                    }else{
                        wrapper.Label = string.valueOf(dfield.getLabel());
                        wrapper.LookUpAPIName = string.valueOf(dfield.getName());
                    }
                    wrapper.APIName = dfield.getName(); 
                    ObjectWrapperList.Add(wrapper);
                }
            }
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = true;
            Result.Message = 'Success';
            Result.WrapperList = ObjectWrapperList;
            return Result;
        }catch(Exception ex){
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = false;
            Result.Message = ex.getMessage();
            return Result;
        }
    }
    
    // @AuraEnabled
    /* public static  map<string,string>  orgwideEmail(){
map<string,string> emails = new  map<string,string>  ();
List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();    
list<orgwideemailaddress> getmailaddress =[select id, Address from orgwideemailaddress ];
for(orgwideemailaddress oea : getmailaddress){
emails.put(oea.id,oea.Address);
}
// string address = oea.Id;
/* try{
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
message.toAddresses = new String[] {'ganithorati19@gmail.com'};  
message.setSubject('Report');
message.setOrgWideEmailAddressId(address);
message.setHtmlBody('Test');
messageList.add(message);
Savepoint sp = Database.setSavepoint();

Messaging.sendEmail(messageList);

Database.rollback(sp);
emails.put(oea.Address,address); 
system.debug('emails-->'+emails);
}
catch(exception ex){
system.debug('ex-->'+ex);
}}
system.debug('emails-->'+emails);
return emails;
}

public class emailListWrap{
@AuraEnabled
public String lable{get;set;}

@AuraEnabled
public string value{get;set;}
}*/
    
    @AuraEnabled
    public static string GetSecLevelFieldDetailscontroller(string ObjectName,string FirstField, string SecondField){
        List<string> FieldAPI = SecondField.split('-');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    public static string GetThirdLevelFieldDetails(string ObjectName,string FirstField, string SecondField, string ThirdField){
        List<string> FieldAPI = ThirdField.split('-');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        if(SecondField.substring(SecondField.length()-3,SecondField.length()) == '__c'){
            SecondField = SecondField.substring(0,SecondField.length()-3);
            SecondField = SecondField+'__r';
        }else if(SecondField.substring(SecondField.length()-2, SecondField.length()) == 'Id'){
            SecondField = SecondField.substring(0, SecondField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+SecondField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+SecondField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    public static string GetFinalLevelFieldDetails(string ObjectName,string FirstField, string SecondField, string ThirdField, string FinalField){
        List<string> FieldAPI = FinalField.split('-');
        if(ObjectName.substring(ObjectName.length()-3,ObjectName.length()) == '__c'){
            ObjectName = ObjectName.substring(0,ObjectName.length()-3);
            ObjectName = ObjectName+'__r';
        }else if(ObjectName.substring(ObjectName.length()-2, ObjectName.length()) == 'Id'){
            ObjectName = ObjectName.substring(0, ObjectName.length()-2);
        }
        
        if(FirstField.substring(FirstField.length()-3,FirstField.length()) == '__c'){
            FirstField = FirstField.substring(0,FirstField.length()-3);
            FirstField = FirstField+'__r';
        }else if(FirstField.substring(FirstField.length()-2, FirstField.length()) == 'Id'){
            FirstField = FirstField.substring(0, FirstField.length()-2);
        }
        
        if(SecondField.substring(SecondField.length()-3,SecondField.length()) == '__c'){
            SecondField = SecondField.substring(0,SecondField.length()-3);
            SecondField = SecondField+'__r';
        }else if(SecondField.substring(SecondField.length()-2, SecondField.length()) == 'Id'){
            SecondField = SecondField.substring(0, SecondField.length()-2);
        }
        
        if(ThirdField.substring(ThirdField.length()-3,ThirdField.length()) == '__c'){
            ThirdField = ThirdField.substring(0,ThirdField.length()-3);
            ThirdField = ThirdField+'__r';
        }else if(ThirdField.substring(ThirdField.length()-2, ThirdField.length()) == 'Id'){
            ThirdField = ThirdField.substring(0, ThirdField.length()-2);
        }
        
        //string FieldToReturn = ObjectName+'.'+FirstField+'.'+SecondField+'.'+ThirdField+'.'+FieldAPI[0];
        string FieldToReturn = FirstField+'.'+SecondField+'.'+ThirdField+'.'+FieldAPI[0];
        return FieldToReturn;
    }
    
    @AuraEnabled
    public static ResultWrapper getFinalObjectFields(string ObjAPIName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        try{
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(ObjAPIName).getDescribe().fields.getMap();
            List<ObjectWrapper> ObjectWrapperList = new List<ObjectWrapper>();
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                system.debug(dfield.getLabel()+'-------'+dfield.getType());
                ObjectWrapper wrapper = new ObjectWrapper();
                if(/*String.ValueOf(dfield.getType()) == 'REFERENCE' || */String.ValueOf(dfield.getType()) == 'EMAIL'){
                    /*if(String.ValueOf(dfield.getType()) == 'REFERENCE'){
wrapper.Label = string.valueOf(dfield.getLabel())+'>';
wrapper.LookUpAPIName = dfield.getReferenceTo()[0].getDescribe().getName();
}else{*/
                    wrapper.Label = string.valueOf(dfield.getLabel());
                    wrapper.LookUpAPIName = string.valueOf(dfield.getName());
                    //}
                    wrapper.APIName = dfield.getName(); 
                    ObjectWrapperList.Add(wrapper);
                }
            }
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = true;
            Result.Message = 'Success';
            Result.WrapperList = ObjectWrapperList;
            return Result;
        }catch(Exception ex){
            ResultWrapper Result = new ResultWrapper();
            Result.IsSuccess = false;
            Result.Message = ex.getMessage();
            return Result;
        }
    }
    
    @AuraEnabled
    public static string GetFieldDetails(string ObjectName,string FirstField){
        List<string> FieldAPI = FirstField.split('-');
        //string FieldToReturn = ObjectName+'.'+FieldAPI[0];
        string FieldToReturn = FieldAPI[0];
        return FieldToReturn;
    }
    
    public class ObjectWrapper{
        @AuraEnabled
        public string Label{get;set;}
        @AuraEnabled
        public string APIName{get;set;}
        @AuraEnabled
        public string LookUpAPIName{get;set;}
    }
    
    public class ResultWrapper{
        @AuraEnabled
        public List<ObjectWrapper> WrapperList{get;set;}
        @AuraEnabled
        public boolean IsSuccess{get;set;}
        @AuraEnabled
        public string Message{get;set;}
    }
    /*   @AuraEnabled 
public static void createrecordSetReplyTo(string selectedobject,string SetReplyTo){//,string docvalue){

system.debug(selectedobject);
system.debug(SetReplyTo);


List<JunoDoc__Junosign_Object_Setting__c> jdlist = [select id,Selected_object__c,JunoDoc__Set_Reply_To_Value__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
JunoDoc__Junosign_Object_Setting__c jd = new JunoDoc__Junosign_Object_Setting__c();
jd.JunoDoc__Set_Reply_To_Value__c=SetReplyTo;
jd.Selected_object__c=selectedobject;
if(!jdlist.isEmpty()){
jd.Id = jdlist[0].Id;
}        
upsert jd;
system.debug(jd);
}*/
    @AuraEnabled 
    public static void createrecord(string selectedobject,string emaillist){//,string docvalue){
        
        system.debug(selectedobject);
        system.debug(emaillist);
        
        
        List<JunoDoc__Junosign_Object_Setting__c> jdlist = [select id,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        JunoDoc__Junosign_Object_Setting__c jd = new JunoDoc__Junosign_Object_Setting__c();
        //jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;
        jd.Selected_object__c=selectedobject;
        if(!jdlist.isEmpty()){
            jd.Id = jdlist[0].Id;
        }        
        upsert jd;
        system.debug(jd);
        list<JunoDoc__Email_Details__c> delJunoDoEmailDetails = [select id from JunoDoc__Email_Details__c where JunoDoc__Junosign_Object_Setting__c=: jd.Id];
        delete delJunoDoEmailDetails;
        
        List<JunoDoc__Email_Details__c> jelist = new List<JunoDoc__Email_Details__c>();
        system.debug('check');
        list<returnEmailDetails> EmailInnerClass = (List<returnEmailDetails>)System.JSON.deserialize(emaillist, List<returnEmailDetails>.class);
        system.debug('-->EmailInnerClass ---> : '+EmailInnerClass);
        for(returnEmailDetails je:EmailInnerClass){
            JunoDoc__Email_Details__c jemail= new JunoDoc__Email_Details__c(); 
            jemail.JunoDoc__To_Value__c=je.Tovalue;
            jemail.JunoDoc__Text_Ref_Value__c=je.TextRefVal;
            jemail.JunoDoc__field_Details__c=je.fieldDetails;
            jemail.JunoDoc__Name__c = je.TextName;
            jemail.JunoDoc__Email__c=je.Email;
            jemail.JunoDoc__Junosign_Object_Setting__c=jd.id;
            jelist.add(jemail);
            system.debug('!@!@@@!@!@!@!@'+jemail);
        } 
        insert jelist;
    }
    
    
    /***** Juno DocTemplate - methods *****/
    
    @AuraEnabled
    public static InnerDocTemplates getAvailableDocTemplates(String selectedobject){
        system.debug(selectedobject);
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Doc_Template__c 
                                                  where Parent_Object__c =: selectedobject and JunoDoc__Show_Templates__c = false];
        DocTemplatesWrap obj1 = new DocTemplatesWrap();
        obj1.label = 'None';
        obj1.value = ''; 
        obj1.type= 'DocTemplate';
        AvailableDocTemplatesList.add(obj1);
        //New Code End
        if(availableDocList.size()>0){
            for(Doc_Template__c rec : availableDocList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= 'DocTemplate';
                AvailableDocTemplatesList.add(obj);
            }            
        }
        
        InnerDocTemplates inn = new InnerDocTemplates();
        inn.AvailableDocTemplatesList = AvailableDocTemplatesList;
        // inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = selectedobject;   
        return inn; 
    }
    @AuraEnabled
    public static void setDefaultTemplate(String selectedobject, String DocTemplate){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject AND JunoDoc__Junodoc_Default_Template__r.JunoDoc__Show_Templates__c =: false];
        if(dflist.size()>0){
            for(JunoDoc__Junosign_Object_Setting__c doc:dflist){
                if(DocTemplate != ''){
                    doc.JunoDoc__Junodoc_Default_Template__c = Id.valueOf(DocTemplate);
                }
                else{
                    doc.JunoDoc__Junodoc_Default_Template__c = null;
                }
            }
            update dflist;
        }
        
    }
    @AuraEnabled
    public static defaultDocTemplatesWrap getDefaultTemplate(String selectedobject){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c,JunoDoc__Junodoc_Default_Template__r.Name from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        defaultDocTemplatesWrap tempWrap = new defaultDocTemplatesWrap();
        if(dflist.size()>0){
            tempWrap.label =dflist[0].JunoDoc__Junodoc_Default_Template__r.Name;
            tempWrap.value =dflist[0].JunoDoc__Junodoc_Default_Template__c;
            return tempWrap; 
        }else{
            return tempWrap;
        }
    }
    
    @AuraEnabled
    public static string getSetReplyTo(String selectedobject){
        String SetReplyTo = '';
        List<JunoDoc__Junosign_Object_Setting__c> ObjSetList = [select id,Selected_object__c,JunoDoc__Set_Reply_To_Value__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        if(ObjSetList.size()>0){
            if(ObjSetList[0].JunoDoc__Set_Reply_To_Value__c != null){
                SetReplyTo =ObjSetList[0].JunoDoc__Set_Reply_To_Value__c;
                return SetReplyTo; 
            }
            else{
                SetReplyTo = '';
                return SetReplyTo;
            }
            
        }else{
            return SetReplyTo;
        }
    }
    
    /************* SaiRam 21-02-2023 *************/
    /***** Juno EmailTemplate - methods *****/
    
    @AuraEnabled
    public static InnerEmailTemplates getJunoEmailTemplates(String selectedobject){
        system.debug(selectedobject);
        list<EmailTemplatesWrap> JunoEmailTemplatesList = new list<EmailTemplatesWrap>();
        
        list<JunoDoc__Email_Template__c> availableEmailTempList = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c 
                                                                   from JunoDoc__Email_Template__c 
                                                                   where JunoDoc__Parent_Object__c =: selectedobject];
        EmailTemplatesWrap obj1 = new EmailTemplatesWrap();
        obj1.label = 'None';
        obj1.value = ''; 
        obj1.type= 'EmailTemplate';
        JunoEmailTemplatesList.add(obj1);
        //New Code End
        if(availableEmailTempList.size()>0){
            for(JunoDoc__Email_Template__c rec : availableEmailTempList){
                EmailTemplatesWrap obj = new EmailTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= 'EmailTemplate';
                JunoEmailTemplatesList.add(obj);
            }            
        }
        
        InnerEmailTemplates inn = new InnerEmailTemplates();
        inn.JunoEmailTemplatesList = JunoEmailTemplatesList;
        // inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = selectedobject;   
        return inn; 
    }
    @AuraEnabled
    public static void setJunoEmailTemplate(String selectedobject, String EmailTemplate){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        
        if(dflist.size()>0){
            for(JunoDoc__Junosign_Object_Setting__c doc:dflist){
                if(EmailTemplate != ''){
                    doc.JunoDoc__Junodoc_Default_EmailTemplate__c = Id.valueOf(EmailTemplate);
                }
                else{
                    doc.JunoDoc__Junodoc_Default_EmailTemplate__c = null;
                }
            }
            update dflist;
        }
        
    }
    @AuraEnabled
    public static defaultEmailTemplatesWrap getJunoEmailTemplate(String selectedobject){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate__c,JunoDoc__Junodoc_Default_EmailTemplate__r.Name from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        defaultEmailTemplatesWrap tempWrap = new defaultEmailTemplatesWrap();
        if(dflist.size()>0){
            tempWrap.label =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate__r.Name;
            tempWrap.value =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate__c;
            return tempWrap; 
        }else{
            return tempWrap;
        }
    }
    
    /***** Juno EmailTemplate For Owner - methods *****/
    
    @AuraEnabled
    public static InnerEmailTemplatesForOwner getJunoEmailTemplatesForOwner(String selectedobject){
        system.debug(selectedobject);
        list<EmailTemplatesWrapForOwner> JunoEmailTemplatesForOwnerList = new list<EmailTemplatesWrapForOwner>();
        
        list<JunoDoc__Email_Template__c> availableEmailTempListForOwner = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c 
                                                                           from JunoDoc__Email_Template__c 
                                                                           where JunoDoc__Parent_Object__c =: selectedobject];
        EmailTemplatesWrapForOwner obj1 = new EmailTemplatesWrapForOwner();
        obj1.label = 'None';
        obj1.value = ''; 
        obj1.type= 'EmailTemplate';
        JunoEmailTemplatesForOwnerList.add(obj1);
        //New Code End
        if(availableEmailTempListForOwner.size()>0){
            for(JunoDoc__Email_Template__c rec : availableEmailTempListForOwner){
                EmailTemplatesWrapForOwner obj = new EmailTemplatesWrapForOwner();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= 'EmailTemplate';
                JunoEmailTemplatesForOwnerList.add(obj);
            }            
        }
        
        InnerEmailTemplatesForOwner inn = new InnerEmailTemplatesForOwner();
        inn.JunoEmailTemplatesForOwnerList = JunoEmailTemplatesForOwnerList;
        // inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = selectedobject;   
        return inn; 
    }
    @AuraEnabled
    public static void setJunoEmailTemplateForOwner(String selectedobject, String EmailTemplate){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        if(dflist.size()>0){
            for(JunoDoc__Junosign_Object_Setting__c doc:dflist){
                if(EmailTemplate != ''){
                    doc.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = Id.valueOf(EmailTemplate);
                }
                else{
                    doc.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = null;
                }
            }
            update dflist;
        }
        
    }
    @AuraEnabled
    public static defaultEmailTemplatesWrapForOwner getJunoEmailTemplateForOwner(String selectedobject){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__r.Name from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        defaultEmailTemplatesWrapForOwner tempWrap = new defaultEmailTemplatesWrapForOwner();
        if(dflist.size()>0){
            tempWrap.label =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__r.Name;
            tempWrap.value =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c;
            return tempWrap; 
        }else{
            return tempWrap;
        }
    }
    
    
    /***** Juno EmailTemplate For Signee - methods *****/
    
    @AuraEnabled
    public static InnerEmailTemplatesForSignee getJunoEmailTemplatesForSignee(String selectedobject){
        system.debug(selectedobject);
        list<EmailTemplatesWrapForSignee> JunoEmailTemplatesForSigneeList = new list<EmailTemplatesWrapForSignee>();
        
        list<JunoDoc__Email_Template__c> availableEmailTempListForSignee = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c 
                                                                            from JunoDoc__Email_Template__c 
                                                                            where JunoDoc__Parent_Object__c =: selectedobject];
        EmailTemplatesWrapForSignee obj1 = new EmailTemplatesWrapForSignee();
        obj1.label = 'None';
        obj1.value = ''; 
        obj1.type= 'EmailTemplate';
        JunoEmailTemplatesForSigneeList.add(obj1);
        //New Code End
        if(availableEmailTempListForSignee.size()>0){
            for(JunoDoc__Email_Template__c rec : availableEmailTempListForSignee){
                EmailTemplatesWrapForSignee obj = new EmailTemplatesWrapForSignee();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= 'EmailTemplate';
                JunoEmailTemplatesForSigneeList.add(obj);
            }            
        }
        
        InnerEmailTemplatesForSignee inn = new InnerEmailTemplatesForSignee();
        inn.JunoEmailTemplatesForSigneeList = JunoEmailTemplatesForSigneeList;
        // inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = selectedobject;   
        return inn; 
    }
    @AuraEnabled
    public static void setJunoEmailTemplateForSignee(String selectedobject, String EmailTemplate){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        if(dflist.size()>0){
            for(JunoDoc__Junosign_Object_Setting__c doc:dflist){
                if(EmailTemplate != ''){
                    doc.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = Id.valueOf(EmailTemplate);
                }
                else{
                    doc.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = null;
                }
            }
            update dflist;
        }
        
    }
    @AuraEnabled
    public static defaultEmailTemplatesWrapForSignee getJunoEmailTemplateForSignee(String selectedobject){
        List<JunoDoc__Junosign_Object_Setting__c> dflist = [select id,Selected_object__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c,JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__r.Name from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        defaultEmailTemplatesWrapForSignee tempWrap = new defaultEmailTemplatesWrapForSignee();
        if(dflist.size()>0){
            tempWrap.label =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__r.Name;
            tempWrap.value =dflist[0].JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c;
            return tempWrap; 
        }else{
            return tempWrap;
        }
    } 
    /************* SaiRam 21-02-2023 *************/
    
    /************* SaiRam 09-03-2023 *************/
    @AuraEnabled 
    public static void createrecord2(string selectedobject,string docvalue,string SetReplyTo, string emaillist, string DocTemplateId, string EmailTemplateId, string EmailTemplateIdForOwner, string EmailTemplateIdForSignee){
        
        system.debug(selectedobject);
        system.debug(emaillist);
        
        
        List<JunoDoc__Junosign_Object_Setting__c> jdlist = [select id,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c, JunoDoc__FromEmailAddress__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        JunoDoc__Junosign_Object_Setting__c jd = new JunoDoc__Junosign_Object_Setting__c();
        jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;
        jd.Selected_object__c=selectedobject;
        jd.JunoDoc__Set_Reply_To_Value__c = SetReplyTo;
        if(!jdlist.isEmpty()){
            jd.Id = jdlist[0].Id;
        }        
        upsert jd;
        system.debug(jd);
        list<JunoDoc__Email_Details__c> delJunoDoEmailDetails = [select id from JunoDoc__Email_Details__c where JunoDoc__Junosign_Object_Setting__c=: jd.Id];
        delete delJunoDoEmailDetails;
        
        List<JunoDoc__Email_Details__c> jelist = new List<JunoDoc__Email_Details__c>();
        list<returnEmailDetails> EmailInnerClass = (List<returnEmailDetails>)System.JSON.deserialize(emaillist, List<returnEmailDetails>.class);
        for(returnEmailDetails je:EmailInnerClass){
            JunoDoc__Email_Details__c jemail= new JunoDoc__Email_Details__c(); 
            jemail.JunoDoc__To_Value__c=je.Tovalue;
            jemail.JunoDoc__Text_Ref_Value__c=je.TextRefVal;
            jemail.JunoDoc__field_Details__c=je.fieldDetails;
            jemail.JunoDoc__Name__c = je.TextName;
            jemail.JunoDoc__Email__c=je.Email;
            jemail.JunoDoc__Junosign_Object_Setting__c=jd.id;
            jelist.add(jemail);
            system.debug('!@!@@@!@!@!@!@'+jemail);
        } 
        insert jelist;
        AddEmailRecipientController.setDefaultTemplate(selectedobject, DocTemplateId);
        AddEmailRecipientController.setJunoEmailTemplate(selectedobject, EmailTemplateId);
        AddEmailRecipientController.setJunoEmailTemplateForOwner(selectedobject, EmailTemplateIdForOwner);
        AddEmailRecipientController.setJunoEmailTemplateForSignee(selectedobject, EmailTemplateIdForSignee);
    }
    /************* SaiRam 09-03-2023 *************/
    
    @AuraEnabled
    public static List<sObject> getConUserRec(String selectedObj,String matchStr){
        //List<conUserWrapCls> conUserWrap = new List<conUserWrapCls>();
        String filterName = '%'+matchStr+'%';
        system.debug('filterName-->'+filterName);
        String quereStr = 'Select Id,Name,Email from '+selectedObj + ' Where Name Like: filterName  ORDER BY Name LIMIT 20';
        system.debug('queryStr-->'+quereStr);
        List<sObject> objRecList = Database.query(quereStr); 
        return objRecList;
    }
    
    @AuraEnabled
    public static List<sObject> getSelectedConUserRecEmail(String selectedRecId,String selectedObj){
        String quereStr = 'Select Id,Name,Email from '+selectedObj + ' where Id=:selectedRecId';
        system.debug('queryStr-->'+quereStr);
        List<sObject> objRecList = Database.query(quereStr); 
        return objRecList;
    }
    
      @AuraEnabled
    public static Boolean getAccountFieldValue() {
        Junodoc_Setting__c acc = [SELECT Id, JunoDoc__Enable_JunoSign_Post_Actions__c FROM JunoDoc__Junodoc_Setting__c Limit 1];
        return acc.JunoDoc__Enable_JunoSign_Post_Actions__c;
    }
    
    Global class returnEmailDetails{
        @AuraEnabled
        public string Tovalue;
        @AuraEnabled
        public string TextName;
        @AuraEnabled
        public string TextRefVal;
        @AuraEnabled
        public string Email;
        @AuraEnabled
        public string fieldDetails;
    }
    
    /************* SaiRam 21-02-2023 *************/
    /***** Junodoc Email InnerClasses*****/
    
    public class InnerEmailTemplates{
        @AuraEnabled
        public list<EmailTemplatesWrap> JunoEmailTemplatesList;
        @AuraEnabled
        public string EmailTemplateId;
        @AuraEnabled
        public string ObjectAPIName;        
        
    }  
    public class EmailTemplatesWrap{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value; 
        // New Code Start
        @AuraEnabled
        public String type;
        // New Code End
    }
    public class defaultEmailTemplatesWrap{
        @AuraEnabled
        public String label; 
        @AuraEnabled
        public String value; 
    }
    
    /***** Junodoc EmailTemplates InnerClasses For Owner*****/
    
    public class InnerEmailTemplatesForOwner{
        @AuraEnabled
        public list<EmailTemplatesWrapForOwner> JunoEmailTemplatesForOwnerList;
        @AuraEnabled
        public string EmailTemplateForOwnerId;
        @AuraEnabled
        public string ObjectAPIName;        
        
    }  
    
    public class EmailTemplatesWrapForOwner{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value; 
        // New Code Start
        @AuraEnabled
        public String type;
        // New Code End
    }
    public class defaultEmailTemplatesWrapForOwner{
        @AuraEnabled
        public String label; 
        @AuraEnabled
        public String value; 
    }
    
    /***** Junodoc EmailTemplates InnerClasses For Signee*****/
    
    public class InnerEmailTemplatesForSignee{
        @AuraEnabled
        public list<EmailTemplatesWrapForSignee> JunoEmailTemplatesForSigneeList;
        @AuraEnabled
        public string EmailTemplateForSigneeId;
        @AuraEnabled
        public string ObjectAPIName;        
        
    }  
    public class EmailTemplatesWrapForSignee{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value; 
        // New Code Start
        @AuraEnabled
        public String type;
        // New Code End
    }
    public class defaultEmailTemplatesWrapForSignee{
        @AuraEnabled
        public String label; 
        @AuraEnabled
        public String value; 
    }
    /************* SaiRam 21-02-2023 *************/
    
    /***** Junodoc DocTemplates InnerClasses*****/
    
    public class InnerDocTemplates{
        @AuraEnabled
        public list<DocTemplatesWrap> AvailableDocTemplatesList;
        @AuraEnabled
        public string DocTemplateId;
        @AuraEnabled
        public string ObjectAPIName;        
        
    }  
    
    public class DocTemplatesWrap{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value; 
        // New Code Start
        @AuraEnabled
        public String type;
        // New Code End
    }
    public class defaultDocTemplatesWrap{
        @AuraEnabled
        public String label; 
        @AuraEnabled
        public String value; 
    }
    
}
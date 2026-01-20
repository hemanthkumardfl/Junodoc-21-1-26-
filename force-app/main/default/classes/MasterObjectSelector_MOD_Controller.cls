global with sharing class MasterObjectSelector_MOD_Controller {
   /*     @AuraEnabled
        global static List<ObjectClass> getObjectName(){
            List<String> objects=new List<String>();
            Map<String, String> objectNameMap = new Map<String, String>();
            List<ObjectClass> ObjectClassList = new List<ObjectClass>();
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values(); 
            for(SObjectType sot : gd){
                objects.add(sot.getDescribe().getName());
                objects.sort();  
                objectNameMap.put(sot.getDescribe().getName(), sot.getDescribe().getLabel());
            }
            for(String objLabel : objects){
                ObjectClassList.add(new ObjectClass(objLabel,objectNameMap.get(objLabel)));     
            }
            return ObjectClassList;
        }
        
        global class ObjectClass{
            @AuraEnabled global String objectName;
            @AuraEnabled global String objectLabel;
            global ObjectClass(String objectName, String objectLabel){
                this.objectName = objectName;
                this.objectLabel = objectLabel;
            }
        }
    
        @AuraEnabled
        public static string getJunodocUrl(){
            string JunodocUrl='apex';
            if(Network.getNetworkId()!=null){
                JunodocUrl='junodoc';
            }
            return JunodocUrl;
        }
    
    
    //new methods//
     @AuraEnabled
    global static InnerDocTemplates getAvailableDoc(string sObjName){
      
        string TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        string DocTemplateField = '' ;
        
        DocTemplateField = string.valueOf(objectFieldsMap.get('JunoDoc__Doc_Template__c'));
        if(DocTemplateField == null || DocTemplateField == ''){
            DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
        }
        System.debug('DocTemplateField ' + DocTemplateField);  
        if(DocTemplateField=='JunoDoc__Doc_Template__c' || DocTemplateField=='Doc_Template__c'){
           // string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: recordId' ;
            //sobject NewQuote = Database.query(Newqueries);
            //System.debug('NewQuote ' + NewQuote); 
            //TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
           // System.debug('TemplateID ' + TemplateID);  
            if(TemplateID==null){
                TemplateID='';
            }            
        }
        
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Doc_Template__c 
                                                  where Parent_Object__c =: sObjName];
        //New Code start
        list<Email_Template__c> availableEmailList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Email_Template__c 
                                                  where Parent_Object__c =: sObjName];
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
        //New Code Start 
        if(availableEmailList.size() > 0){
            for(Email_Template__c rec : availableEmailList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= 'EmailTemplate';
                AvailableDocTemplatesList.add(obj);
            }  
        }
        //New Code End
        list<DocTemplatesWrap> orgWideEmailsList = new list<DocTemplatesWrap>();
        list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address from OrgWideEmailAddress Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Address;
                obj.value = rec.id; 
                orgWideEmailsList.add(obj); 
            }
        }        
        InnerDocTemplates inn = new InnerDocTemplates();
        inn.AvailableDocTemplatesList = AvailableDocTemplatesList;
        inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = sObjName;   
        inn.OrgwideEmailAddressList = orgWideEmailsList;
        inn.JunodocUrl = Dynamic_GeneratePDF_Controller.getJunodocUrl();
         
        
        return inn;        
    }
     global class InnerDocTemplates{
        @AuraEnabled
        global list<DocTemplatesWrap> AvailableDocTemplatesList;
        @AuraEnabled
        global string DocTemplateId;
        @AuraEnabled
        public string ObjectAPIName;        
        @AuraEnabled
        public list<DocTemplatesWrap> OrgwideEmailAddressList;  
        @AuraEnabled
        public string JunodocUrl;        
        
    }  
   global class DocTemplatesWrap{
        @AuraEnabled
        global String label;
        @AuraEnabled
        global String value; 
        // New Code Start
        @AuraEnabled
        global String type;
        // New Code End
    }    
    
    @AuraEnabled
    global static InnerEmailTemplates getEmailTemplates(string sObjName) { 
        
       // String sObjName = id.getSObjectType().getDescribe().getName();
        sObjName = sObjName.toUpperCase();
        
        list<EmailTemplateWrap> StandardEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<EmailTemplate> eTempList = [SELECT Id,Name,Body,Subject 
                                         From EmailTemplate 
                                         Where IsActive = true
                                         Order By Name
                                         Limit 5000];
        //if(!Test.isRunningTest()){
            for(EmailTemplate rec:eTempList){            
                string body = rec.Body;
                string Subject = rec.Subject;
                
                if(body !=null && Subject !=null)
                {
                    if(Subject.toUpperCase().contains(sObjName) || body.toUpperCase().contains(sObjName) 
                       || Subject.toUpperCase().contains('{!'+sObjName+'.') || body.toUpperCase().contains('{!'+sObjName+'.')){
                        EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
                        objSettings.label=rec.Name;
                        objSettings.value=rec.Id;
                        StandardEmailTemplatesList.add(objSettings);                        
                    }                
                }            
            }  
        //}
        
        
        list<EmailTemplateWrap> JunoDocEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<Email_Template__c> JunoDocETempList = [SELECT Id,Name
                                         From Email_Template__c 
                                         Where Parent_Object__c =:sObjName
                                         Order By Name
                                         Limit 5000];
        for(Email_Template__c rec:JunoDocETempList){            
            EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
            objSettings.label=rec.Name;
            objSettings.value=rec.Id;
            JunoDocEmailTemplatesList.add(objSettings);                        
        }  
                
        list<EmailTemplateWrap> JunoDocPDFTemplatesList = new list<EmailTemplateWrap>();
        
        list<Doc_Template__c> JunoDocPDFTempList = [SELECT Id,Name
                                         From Doc_Template__c 
                                         Where Parent_Object__c =:sObjName
                                         Order By Name
                                         Limit 5000];
        for(Doc_Template__c rec:JunoDocPDFTempList){            
            EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
            objSettings.label=rec.Name;
            objSettings.value=rec.Id;
            JunoDocPDFTemplatesList.add(objSettings);                        
        }  
         list<DocTemplatesWrap> orgWideEmailsList = new list<DocTemplatesWrap>();
        list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address from OrgWideEmailAddress Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Address;
                obj.value = rec.id; 
                orgWideEmailsList.add(obj); 
            }
        }       
        InnerEmailTemplates Inn = new InnerEmailTemplates();
        Inn.StandardEmailTemplatesList = StandardEmailTemplatesList;
        Inn.JunoDocEmailTemplatesList = JunoDocEmailTemplatesList;
        Inn.JunoDocPDFTemplatesList = JunoDocPDFTemplatesList;
        Inn.OrgwideEmailAddressList = orgWideEmailsList; 
        return Inn;
    }    
    
    global class InnerEmailTemplates{
        @AuraEnabled
        global list<EmailTemplateWrap> StandardEmailTemplatesList;
        @AuraEnabled
        global list<EmailTemplateWrap> JunoDocEmailTemplatesList;  
        @AuraEnabled    
        global list<DocTemplatesWrap> OrgwideEmailAddressList;      
        @AuraEnabled    
        global list<EmailTemplateWrap> JunoDocPDFTemplatesList;   
    }
    
    global class EmailTemplateWrap{
        @AuraEnabled 
        global String label;
        @AuraEnabled
        global String value;    
    }

     
    @AuraEnabled
    public static list<DocTemplatesWrap> getAvailableEmails(string sObjName){
      
        //String sObjName = recordId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjName).getDescribe().fields.getMap();
       
        list<DocTemplatesWrap> DocTemplatesWraplist = new list<DocTemplatesWrap>();
        for(string dfield:fieldMap.keyset()){      
              if(fieldMap.get(dfield).getDescribe().getType()+'' == 'Email'){
                DocTemplatesWrap DocTemplatesWraprec = new DocTemplatesWrap();
                DocTemplatesWraprec.label = fieldMap.get(dfield).getDescribe().getLabel();
                DocTemplatesWraprec.value = fieldMap.get(dfield).getDescribe().getName();
                DocTemplatesWraplist.add(DocTemplatesWraprec);
              }
            system.debug('&&&&&&'+DocTemplatesWraplist);
        }   
        return DocTemplatesWraplist; 
        
    } 
    
    @AuraEnabled
    
    public static void createrecord(string fromEmailAddress,string setReplyTo,string standardEmailtemplates,string junoDocEmailtemplates,string selectedobject,string emaillist,string docvalue){
        system.debug(fromEmailAddress);
        system.debug(setReplyTo);
        system.debug(standardEmailtemplates);
        system.debug(junoDocEmailtemplates);
        system.debug(selectedobject);
        
        List<Junodoc_Details__c> jdlist = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,  
                                           Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c from Junodoc_Details__c where Selected_object__c =: selectedobject]; 
        Junodoc_Details__c jd = new Junodoc_Details__c();   
        jd.From_Email_Address__c=fromEmailAddress;  
        jd.Junodoc_Email_Templates__c=junoDocEmailtemplates;    
        jd.Standard_Email_Templates__c=standardEmailtemplates;  
        jd.Set_Reply_To__c=setReplyTo;  
        jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;   
        jd.Selected_object__c=selectedobject;
            if(!jdlist.isEmpty()){
              jd.Id = jdlist[0].Id;
           }        
        upsert jd;
        system.debug(jd);
        
        list<JunoDoc__Email_Details__c> delJunoDoEmailDetails = [select id from JunoDoc__Email_Details__c where JunoDoc__Junodoc_Details__c=: jd.Id];   
        delete delJunoDoEmailDetails;   
            
        List<JunoDoc__Email_Details__c> jelist = new List<JunoDoc__Email_Details__c>(); 
        list<returnEmailDetails> EmailInnerClass = (List<returnEmailDetails>)System.JSON.deserialize(emaillist, List<returnEmailDetails>.class);    
        for(returnEmailDetails je:EmailInnerClass){ 
          JunoDoc__Email_Details__c jemail= new JunoDoc__Email_Details__c();    
            jemail.JunoDoc__To_Value__c=je.Tovalue; 
            jemail.JunoDoc__Text_Ref_Value__c=je.TextRefVal;    
            jemail.JunoDoc__field_Details__c=je.fieldDetails;   
            jemail.JunoDoc__Email__c=je.Email;  
            jemail.JunoDoc__Junodoc_Details__c=jd.id;   
            jelist.add(jemail); 
            system.debug('!@!@@@!@!@!@!@'+jemail);  
        }   
        insert jelist;  

    }
    @AuraEnabled
    public static GetDetailsInner  getrecorddetails(string selectedobject){
        system.debug('@@@');
        string selectedobjID;
        List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
        juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,
                                             Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c
                                          from Junodoc_Details__c 
                                          where Selected_object__c =: selectedobject];
        GetDetailsInner getInner = new GetDetailsInner();
        If(juno.size()>0){  
        List<JunoDoc__Email_Details__c> junoEmailList = [select JunoDoc__To_Value__c,JunoDoc__Text_Ref_Value__c,JunoDoc__Email__c,JunoDoc__field_Details__c 
                                                        from JunoDoc__Email_Details__c where JunoDoc__Junodoc_Details__c=:juno[0].Id];
        
        
        getInner.junodoc=juno;
        list<returnEmailDetails> returnEmailDetailslist = new list<returnEmailDetails>();
        for(JunoDoc__Email_Details__c jumoEmil : junoEmailList){
            returnEmailDetails returnEmailDetailsrec = new returnEmailDetails();
            returnEmailDetailsrec.Tovalue = jumoEmil.JunoDoc__To_Value__c;
            returnEmailDetailsrec.TextRefVal = jumoEmil.JunoDoc__Text_Ref_Value__c;
            returnEmailDetailsrec.Email = jumoEmil.JunoDoc__Email__c;
            returnEmailDetailsrec.fieldDetails = jumoEmil.JunoDoc__field_Details__c;
            returnEmailDetailslist.add(returnEmailDetailsrec);
        }
        
        getInner.junoEmailList=returnEmailDetailslist;
        
        
        }
        if(juno.size() > 0){
            return getInner;     
        }else{
            return null;
        }
       
        
    }
    public class GetDetailsInner{   
        @AuraEnabled    
        public List<Junodoc_Details__c> junodoc{get;set;}   
            
        @AuraEnabled    
        public List<returnEmailDetails> junoEmailList {get;set;}    
    } 
    global class returnEmailDetails{    
        @AuraEnabled    
        public string Tovalue;  
        @AuraEnabled    
        public string TextRefVal;   
        @AuraEnabled    
        public string Email;    
        @AuraEnabled    
        public string fieldDetails; 
    }   
            
    @AuraEnabled    
    public static string getOrgUrl(){   
        try{    
            List<JunoDoc__Junodoc_Setting__c> junosettings    = [SELECT Id,JunoDoc__Organization_Url__c from JunoDoc__Junodoc_Setting__c];  
            if(!junosettings.isEmpty()){    
                return junosettings[0].JunoDoc__Organization_Url__c;    
            }   
            else{   
                system.debug('Org Url is null in JunoDoc Settings');    
                return null;    
            }   
        }   
        catch(Exception e){ 
            system.debug('Error Line ----> '+e.getLineNumber());    
            system.debug('Error Message -----> '+e.getMessage());   
            return null;    
        }   
    }   
        
        

  /*   @AuraEnabled
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
                if(String.ValueOf(dfield.getType()) == 'EMAIL'){
                    
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
    
    @AuraEnabled
    public static void createemaildatarecord(string junodetail,string JsonString,string emailaddress ){
        system.debug('@@@JsonString'+JsonString);
        List<Wrapper> WrapperList = (List<Wrapper>) JSON.deserialize(JsonString, List<Wrapper>.class);
        system.debug(WrapperList+'----->'+WrapperList.size());
        List<Email_Details__c> EmailDetailList = new List<Email_Details__c>(); 
        Junodoc_Details__c jd=[select id from Junodoc_Details__c where Selected_object__c=:junodetail];
        for(Wrapper Wrp:WrapperList){
            Email_Details__c emaildetails= new Email_Details__c();
            emaildetails.Junodoc_Details__c=jd.id;
            emaildetails.JunoDoc__To_Value__c=Wrp.Tovalue;
            emaildetails.JunoDoc__Text_Ref_Value__c=Wrp.TextRefVal;
            emaildetails.JunoDoc__Email__c=Wrp.Email;
            EmailDetailList.Add(emaildetails);
        }
        
        if(!EmailDetailList.isEmpty()){
            insert EmailDetailList;
        }
        
    
    }
    
    
    public class Wrapper {
        @AuraEnabled
        public String Tovalue;  //CC
        @AuraEnabled
        public String TextRefVal;   //Text
        @AuraEnabled
        public String Email;    //sdfghjk@test.com
        @AuraEnabled
        public String fieldDetails; //undefined.undefined
    }*/
    
    
        
    
    
    }
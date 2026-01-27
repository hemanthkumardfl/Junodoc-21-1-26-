global class JunoSignSendDocsController {
    @AuraEnabled
    public Static String sendDocEnv (Id recordId, List<String> SelectedDoc, List<String> emailList, List<String> recipentNameList,string DocTemplateId){
        
        String ObjName = recordId.getSObjectType().getDescribe().getName();
        system.debug(ObjName);
        
        
        List<ContentVersion> selectedDocuments;
        
        selectedDocuments =   [SELECT ContentDocumentId,VersionData, Title FROM ContentVersion  where ContentDocumentId IN: SelectedDoc];      
        
        system.debug(selectedDocuments.Size());
        system.debug(selectedDocuments);
        
        /* SendToJunoSignController signC = new SendToJunoSignController();
         
signC.SendNow('','', selectedDocuments, recordId, emailList, recipentNameList,DocTemplateId); */
        
        
        return null;
        
        
        
        /* 
// Code To Create Template

CreateTemplateApi Sign = New CreateTemplateApi(); 
Sign.sendEnvelope(contactDetails[0].CustomerSigned.Email,contactDetails[0].CustomerSigned.Name, SelectedDoc, recordId);  */
        
    }
    
    @AuraEnabled
    public static object getDocuments(String recordId){
        
        system.debug(recordId);
        List<ContentDocumentClass> MasterBudgetsClassList = new List<ContentDocumentClass>();
        List<ContentDocumentLink> rfqList;
        If(Schema.sObjectType.ContentDocument.fields.Id.isAccessible() &&
           Schema.sObjectType.ContentDocument.fields.Title.isAccessible()){
               
               rfqList = [SELECT ContentDocumentId,ContentDocument.Title, LinkedEntityId  
                          FROM ContentDocumentLink 
                          where LinkedEntityId =: recordId];
           }
        
        system.debug(rfqList);
        
        for(ContentDocumentLink bud : rfqList){
            ContentDocumentClass MasterBudgetsClassRecord = new ContentDocumentClass(); 
            MasterBudgetsClassRecord.budgetRecord = bud;
            MasterBudgetsClassRecord.budgetCheck = false;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        return  MasterBudgetsClassList;                                               
    } 
    
    
    public class ContentDocumentClass{
        @AuraEnabled
        public ContentDocumentLink budgetRecord {get;set;}
        
        @AuraEnabled
        public boolean budgetCheck {get;set;}
    }
    
    
    @AuraEnabled
    public static Contact getContactName(String recordId){
        system.debug('recordId>>>>>>>>>>>>>>>>>>>>'+recordId);
        Contact con = [select Id, Name from Contact where Id =: recordId LIMIT 1];
        return con;
    }
    
     @AuraEnabled
    public static void generateEmailTemplateValuesEmail(String recordId ,string templateId){
        
            String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            System.debug('Object Name : '+sObjName);
              System.debug('templateId: '+templateId);
            List<JunoDoc__Junosign_Object_Setting__c> signSettinglist =  new List<JunoDoc__Junosign_Object_Setting__c>();
            JunoDoc__Junosign_Object_Setting__c Junosign_Object_Setting = new JunoDoc__Junosign_Object_Setting__c();
            signSettinglist = [select Id,Name,createdDate,lastmodifieddate,JunoDoc__Selected_object__c, JunoDoc__FromEmailAddress__c 
                               from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c=:sObjName limit 1]; 
            if(signSettinglist.size() >0){
                Junosign_Object_Setting.Id = signSettinglist[0].Id;
                Junosign_Object_Setting.JunoDoc__FromEmailAddress__c = templateId;
                system.debug(' signSettinglist[0].JunoDoc__FromEmailAddress__c>>>>>'+ Junosign_Object_Setting.JunoDoc__FromEmailAddress__c);
                update Junosign_Object_Setting;
            }else{
                Junosign_Object_Setting.JunoDoc__FromEmailAddress__c = templateId;
                Junosign_Object_Setting.JunoDoc__Selected_object__c = sObjName;
                insert Junosign_Object_Setting;
            }
    }
    
   
    
    @AuraEnabled
    public static recipentList fetchContact(String recordId) {
        
        Id checkObjNameId =  Id.valueOf(recordId);
        string ObjName = checkObjNameId.getSObjectType().getDescribe().getName();
        
        system.debug(ObjName);    
        recipentList recipeint = new recipentList();
        if(ObjName == 'Contact'){
            Contact mainContact = [select Id, Name, Email from Contact Where Id =:recordId];
            //recipentList recipeint = new recipentList();
            recipeint.Id = mainContact.Id;
            recipeint.Name = mainContact.Name;
            recipeint.Email = mainContact.Email;
        }
        
        
        
        return recipeint;
    }
    
    
    
    public class recipentList {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Email; 
    }
    
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
    
    
    @AuraEnabled
    public static InnerDocTemplates getAvailableDocTemplates(id recordId){
        System.debug('recordId ' + recordId);
        
        system.debug('test--->'+Network.getNetworkId());
        
        
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        string DocTemplateField = '' ;
        
        DocTemplateField = string.valueOf(objectFieldsMap.get('JunoDoc__Doc_Template__c'));
        if(DocTemplateField == null || DocTemplateField == ''){
            DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
        }
        System.debug('DocTemplateField ' + DocTemplateField);  
        if(DocTemplateField=='JunoDoc__Doc_Template__c' || DocTemplateField=='Doc_Template__c'){
            string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: recordId' ;
            sobject NewQuote = Database.query(Newqueries);
            System.debug('NewQuote ' + NewQuote); 
            TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
            System.debug('TemplateID ' + TemplateID);  
            if(TemplateID==null){
                TemplateID='';
            }            
        }
        
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        list<Doc_Template__c> availableDocList = [select id,Name,Parent_Object__c,Parent_Fields__c 
                                                  from Doc_Template__c 
                                                  where Parent_Object__c =: sObjName and JunoDoc__Show_Templates__c = false];
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
        inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = sObjName;   
        return inn;        
    }
    
    
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
    @auraEnabled 
    public static ObjectDetails getCurrentObjectDetails(string recordId){
        String objectname = Id.valueof(recordId).getSObjectType().getDescribe().getName();
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{objectname}); 
        String objectLabel = describeSobjectsResult[0].getLabel();
        system.debug('objectLabel'+objectLabel);
        
        ObjectDetails obj = new ObjectDetails();
        obj.ObjectName = objectname ;
        obj.ObjectLabel = objectLabel;
        return obj;
    }
    public class ObjectDetails{
        @AuraEnabled public String ObjectName;
        @AuraEnabled public String ObjectLabel;
    }
    @auraEnabled 
    public static String getSetReplyTo(string recordId){
        String objectname = Id.valueof(recordId).getSObjectType().getDescribe().getName();
        String SetReplyTo = '';
        List<JunoDoc__Junosign_Object_Setting__c> jdlist = [select id,Selected_object__c,JunoDoc__Set_Reply_To_Value__c,JunoDoc__Junodoc_Doc_Template__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: objectname];
        if(jdlist.size()>0){
            if(jdlist[0].JunoDoc__Set_Reply_To_Value__c != '' && jdlist[0].JunoDoc__Set_Reply_To_Value__c != null && jdlist[0].JunoDoc__Set_Reply_To_Value__c != 'undefined'){
                SetReplyTo = jdlist[0].JunoDoc__Set_Reply_To_Value__c;
            }
        }
        return SetReplyTo;
    }
    
    @AuraEnabled
    public static List<EmailTemplate> getClassicEmailTemplates() {
        return [SELECT Id, Name FROM EmailTemplate WHERE TemplateType = 'text' OR TemplateType = 'html' ORDER BY Name];
    }
    
    
    
    @AuraEnabled
    public static SelectedReceipient GetEmailFieldValue(Id recordId,string FieldName,Boolean isparent,string parentObj){
        string objName;
        string ParentName = '';
        system.debug(isparent);
        List<String> emaillist = new List<string>();
        List<String> FieldList = new List<string>();
        try{
            sObject accList ;
            string Emailfield = ''; 
            if(isparent == true){
                string[] Parentobjs = parentObj.split('\\.');
                integer k = 1;
                for(string str : Parentobjs){
                    if(k < Parentobjs.size()){
                        if(str.contains('__')){
                            string ParentNames = str.substring(0,str.length()-3);
                            ParentName += ParentNames+'__r.';
                        }else{
                            ParentName += str.substring(0,str.length()-2)+'.';
                        }
                    }
                    else{
                        Emailfield = str;
                    }
                    k++;
                }
                
                string NewEmailfield = ParentName+''+ Emailfield; 
                Parentobjs = NewEmailfield.split('\\.');
                if(FieldName != null && FieldName !=''){
                    String objectName = recordId.getSObjectType().getDescribe().getName();
                    
                    system.debug('ParentName--->'+ParentName);
                    
                    string query = 'select Id,'+ParentName+''+Emailfield + ','+ParentName+'Name from ' +  objectName +' Where Id =:recordId';
                    system.debug(query+'query');
                    
                    accList = Database.query(query);
                    system.debug('accList-->'+accList);
                    if(Parentobjs.size()==4){ //Quote.Account.Owner.Email
                        if(accList.getSobject(Parentobjs[0])!=null){
                            if(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1])!=null){
                                if(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).getSobject(Parentobjs[2])!=null){
                                    if(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).getSobject(Parentobjs[2]).get(Parentobjs[3]) !=null){
                                        
                                        string email = String.valueOf(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).getSobject(Parentobjs[2]).get(Parentobjs[3])); 
                                        string Names = String.valueOf(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).getSobject(Parentobjs[2]).get('Name')); 
                                        FieldList.add(Names);
                                        emaillist.add(email);
                                        
                                    } 
                                }
                            }                            
                        }
                    }
                    else if(Parentobjs.size()==3){ //Quote.Contact.Email
                        if(accList.getSobject(Parentobjs[0])!=null){
                            if(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1])!=null){
                                if(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).get(Parentobjs[2])!=null){
                                    string email = String.valueOf(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).get(Parentobjs[2])); 
                                    string Names = String.valueOf(accList.getSobject(Parentobjs[0]).getSobject(Parentobjs[1]).get('Name')); 
                                    FieldList.add(Names);
                                    emaillist.add(email);
                                }  
                            }                            
                        }
                    }
                    else if(Parentobjs.size()==2){ //Quote.Email
                        if(accList.getSobject(Parentobjs[0])!=null){
                            if(accList.getSobject(Parentobjs[0]).get(Parentobjs[1])!=null){
                                string email = String.valueOf(accList.getSobject(Parentobjs[0]).get(Parentobjs[1])); 
                                string Names = String.valueOf(accList.getSobject(Parentobjs[0]).get('Name')); 
                                FieldList.add(Names);
                                emaillist.add(email);
                                
                            }                            
                        }                       
                    }   
                    
                    
                }
                
            } else{
                String objectName = recordId.getSObjectType().getDescribe().getName();
                system.debug('FieldName--->'+FieldName);
                if(FieldName != null && FieldName !=''){
                    string query = 'select Id,Name, ' + FieldName + ' from ' +  objectName +' Where Id =:recordId';
                    system.debug('query--->'+query);
                    system.debug(query);
                    accList = Database.query(query);
                    system.debug(accList);
                    if(accList.get(FieldName) != null){
                        emaillist.add(''+accList.get(FieldName));
                        FieldList.add(''+accList.get('Name'));
                    } 
                }
            }
            SelectedReceipient receipientItem= new SelectedReceipient();
            if(isparent == true){
                receipientItem.Name = FieldList[0];
                receipientItem.Email = emaillist[0];
            }else{
                receipientItem.Name = FieldList[0];
                receipientItem.Email = emaillist[0];
            }
            
            return receipientItem;
        }
        catch(exception e){
            SelectedReceipient receipientItem= new SelectedReceipient();
            return receipientItem;
            //return 'error';
        }
    }
    
    @AuraEnabled
    public static DefaultTemplateInnCls getDefaultDoctemplate(String recordId){
        String defaultTemplate = '';
        DefaultTemplateInnCls template = new DefaultTemplateInnCls();
        
        // dynamic object
        String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        List<String> reqFields = new List<String>();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(sObjName);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        
        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            reqFields.add(String.valueOf(field));
        }
        System.debug('reqFields--->'+reqFields);
        
        //get fields in JunoSign Object Settings
        List<String> junoSignObjectFields = new List<String>();
        gd = Schema.getGlobalDescribe();
        sobjType = gd.get('JunoDoc__Junosign_Object_Setting__c');
        r = sobjType.getDescribe();
        MapofField = r.fields.getMap();
        
        for(String fieldName : MapofField.keySet()) {
            Schema.SObjectField field = MapofField.get(fieldName);
            Schema.DescribeFieldResult F = field.getDescribe();
            junoSignObjectFields.add(String.valueOf(field));
        }
        
        System.debug('junoSignObjectFields--->'+junoSignObjectFields);
        
        System.debug(reqFields.contains('JunoDoc__Junodoc_Default_Template__c'));
        System.debug(reqFields.contains('Junodoc_Default_Template__c'));
        
        if(reqFields.contains('JunoDoc__Junodoc_Default_Template__c')){
            string query = 'select Id,JunoDoc__Junodoc_Default_Template__c from ' +  sObjName +' Where Id =:recordId';
            system.debug(query);
            sObject accList = Database.query(query);
            system.debug(accList);
            if(accList.get('JunoDoc__Junodoc_Default_Template__c') != null){
                System.debug('1--->'+junoSignObjectFields);
                defaultTemplate = ''+accList.get('JunoDoc__Junodoc_Default_Template__c');
                JunoDoc__Doc_Template__c templateRec = [select Id,Name from JunoDoc__Doc_Template__c where Id=:defaultTemplate];
                //DefaultTemplateInnCls template = new DefaultTemplateInnCls();
                template.temId = defaultTemplate;
                template.tempName = templateRec.Name;//''+accList.get('JunoDoc__Junodoc_Default_Template__r.Name');
                return template;
            }else{
                // get selected template from junosign object settings
                System.debug('638--->'+junoSignObjectFields);
                List<JunoDoc__Junosign_Object_Setting__c> junosignObject = [select id,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Default_Template__c,
                                                                            JunoDoc__Junodoc_Default_Template__r.Name from JunoDoc__Junosign_Object_Setting__c 
                                                                            where JunoDoc__Selected_object__c =: sObjName];
                
                if(junosignObject.size() > 0){
                    template.temId = junosignObject[0].JunoDoc__Junodoc_Default_Template__c;
                    template.tempName = junosignObject[0].JunoDoc__Junodoc_Default_Template__r.Name;
                    return template;
                }
                
            }
        }else if(reqFields.contains('Junodoc_Default_Template__c')){
            string query = 'select Id,Junodoc_Default_Template__c from ' +  sObjName +' Where Id =:recordId';
            system.debug(query);
            sObject accList = Database.query(query);
            system.debug(accList);
            if(accList.get('Junodoc_Default_Template__c') != null){
                System.debug('656--->'+junoSignObjectFields);
                defaultTemplate = ''+accList.get('Junodoc_Default_Template__c');
                JunoDoc__Doc_Template__c templateRec = [select Id,Name from JunoDoc__Doc_Template__c where Id=:defaultTemplate];
                //DefaultTemplateInnCls template = new DefaultTemplateInnCls();
                template.temId = defaultTemplate;
                template.tempName = templateRec.Name;//''+accList.get('Junodoc_Default_Template__r.Name');
                return template;
            }else{
                List<JunoDoc__Junosign_Object_Setting__c> junosignObject = [select id,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Default_Template__c,
                                                                            JunoDoc__Junodoc_Default_Template__r.Name from JunoDoc__Junosign_Object_Setting__c 
                                                                            where JunoDoc__Selected_object__c =: sObjName];
                System.debug('667--->'+junoSignObjectFields);
                if(junosignObject.size() > 0){
                    template.temId = junosignObject[0].JunoDoc__Junodoc_Default_Template__c;
                    template.tempName = junosignObject[0].JunoDoc__Junodoc_Default_Template__r.Name;
                    return template;
                }
            }
        }else{
            // get selected template from junosign object settings
            List<JunoDoc__Junosign_Object_Setting__c> junosignObject = [select id,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Default_Template__c,
                                                                        JunoDoc__Junodoc_Default_Template__r.Name from JunoDoc__Junosign_Object_Setting__c 
                                                                        where JunoDoc__Selected_object__c =: sObjName];
            System.debug('679--->'+junoSignObjectFields);
            if(junosignObject.size() > 0){
                template.temId = junosignObject[0].JunoDoc__Junodoc_Default_Template__c;
                template.tempName = junosignObject[0].JunoDoc__Junodoc_Default_Template__r.Name;
                return template;
            }
            
        }
        
        
        
        
        return template;
    }
    
    
    @AuraEnabled
    public static List<DefaultEmailList> getDefaultEmailListFromJunoObjectSettings(String recordId){
        List<DefaultEmailList> defaultEmailDataList = new List<DefaultEmailList>();
        
        string sobjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
        system.debug(sobjName);
        List<JunoDoc__Junosign_Object_Setting__c> defaultList = [Select Id,Name,JunoDoc__Junodoc_Doc_Template__c,JunoDoc__Selected_object__c From JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =:sobjName ];
        if(defaultList.size() > 0){
            List<JunoDoc__Email_Details__c> emailDetailList = [select id,Name,JunoDoc__Name__c,JunoDoc__Email__c,JunoDoc__field_Details__c,JunoDoc__Text_Ref_Value__c,JunoDoc__To_Value__c,JunoDoc__Junosign_Object_Setting__c from JunoDoc__Email_Details__c where JunoDoc__Junosign_Object_Setting__c =: defaultList[0].Id];
            if(emailDetailList.size() > 0){
                for(JunoDoc__Email_Details__c emailItem : emailDetailList){
                    if(emailItem.JunoDoc__Text_Ref_Value__c == 'Text' || emailItem.JunoDoc__Text_Ref_Value__c =='Contact' || emailItem.JunoDoc__Text_Ref_Value__c == 'User'){
                        DefaultEmailList defaultEmailDataItem = new DefaultEmailList();
                        defaultEmailDataItem.Name = emailItem.JunoDoc__Name__c;
                        defaultEmailDataItem.Email = emailItem.JunoDoc__Email__c;
                        defaultEmailDataItem.EmailType = emailItem.JunoDoc__To_Value__c;
                        defaultEmailDataItem.ispostChecked = false;
                        defaultEmailDataList.add(defaultEmailDataItem);
                        system.debug('defaultEmailDataItem-->'+defaultEmailDataItem);
                    }else{
                        system.debug('emailItem-->'+emailItem);
                        String queryField = emailItem.JunoDoc__field_Details__c;//.replace(sobjName+'.','');
                        system.debug('queryField-->'+queryField);
                        string[] queryFields = queryField.split('\\.');
                        string field = '';
                        integer i= 1;
                        String newQueryList = '';
                        system.debug('queryField-->'+queryFields);
                        for(string str : queryFields){  
                            system.debug(String.valueOf(sobjName) != str);
                            if(i > 1 && i < queryFields.size()){
                                field += str + '.';
                                // newQueryList +=str + '.';
                            }
                            i++;
                        }
                        system.debug('field-->'+field);
                        field += 'Name'; 
                        String query  = '';
                        //  string[] newqueryFields = newQueryList.split('\\.');
                        query = 'Select Id,'+queryField +','+ field + '  from '+sobjName +' Where Id=:recordId';
                        /*  if(queryFields.size() == 1 && queryFields.contains('Name')){
query = 'Select Id,'+ field + '  from '+sobjName +' Where Id=:recordId'; 
}else{
if(newqueryFields.size() == 1 && newqueryFields.contains('Owner')){
query = 'Select Id,'+ field + '  from '+sobjName +' Where Id=:recordId';
}else {

}

}*/
                        
                        
                        
                        system.debug('queryStr-->'+query);
                        List<sObject> objectDetails =  Database.query(query);
                        system.debug('objectDetails-->'+objectDetails);
                        
                        DefaultEmailList defaultEmailDataItem = new DefaultEmailList();
                        defaultEmailDataItem.Name = emailItem.JunoDoc__Name__c;
                        
                        List<String> splittedValues = queryField.split('\\.'); 
                        List<String> fieldValue = field.split('\\.'); 
                        system.debug('toEmailFieldSplit--->'+queryField.split('.'));
                        system.debug('toEmailFieldSplit--->'+splittedValues);
                        system.debug('toEmailFieldSplit--->'+splittedValues);
                        system.debug('toEmailFieldSplit size --->'+splittedValues.size());
                        string ReleationField = '';
                        if(splittedValues.size()==5){
                            if(objectDetails[0].getSobject(splittedValues[1])!=null){
                                if(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2])!=null){
                                    if(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2]).getSobject(splittedValues[3])!=null){
                                        if(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2]).getSobject(splittedValues[3]).get(splittedValues[4])!=null){
                                            string email = String.valueOf(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2]).getSobject(splittedValues[3]).get(splittedValues[4]));
                                            string Names = String.valueOf(objectDetails[0].getSobject(fieldValue[0]).getSobject(fieldValue[1]).getSobject(fieldValue[2]).get(fieldValue[3]));
                                            defaultEmailDataItem.Email = email;
                                            defaultEmailDataItem.Name = Names;
                                            system.debug('level5---->'+email);
                                            //ToAdresses.add(email);
                                        }                                    
                                    }
                                }
                            } 
                        }
                        else if(splittedValues.size()==4){ //Quote.Account.Owner.Email
                            if(objectDetails[0].getSobject(splittedValues[1])!=null){
                                if(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2])!=null){
                                    if(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2]).get(splittedValues[3])!=null){
                                        string email = String.valueOf(objectDetails[0].getSobject(splittedValues[1]).getSobject(splittedValues[2]).get(splittedValues[3]));
                                        
                                        string Names = String.valueOf(objectDetails[0].getSobject(fieldValue[0]).getSobject(fieldValue[1]).get(fieldValue[2]));
                                        defaultEmailDataItem.Email = email;
                                        defaultEmailDataItem.Name = Names;
                                    }                                                              
                                } 
                            }
                        }
                        else if(splittedValues.size()==3){ //Quote.Contact.Email
                            Boolean isContactReference = false;
                            if(splittedValues.contains('Contact')){
                                isContactReference = true;
                            }
                            if(objectDetails[0].getSobject(splittedValues[1])!=null){
                                if(objectDetails[0].getSobject(splittedValues[1]).get(splittedValues[2])!=null){
                                    string email = String.valueOf(objectDetails[0].getSobject(splittedValues[1]).get(splittedValues[2]));
                                    string Names = String.valueOf(objectDetails[0].getSobject(fieldValue[0]).get(fieldValue[1]));
                                    defaultEmailDataItem.Email = email;
                                    defaultEmailDataItem.Name = Names;
                                    
                                }                            
                            }
                        }
                        else if(splittedValues.size()==2){ //Quote.Email
                            if(objectDetails[0].get(splittedValues[1])!=null){
                                string email = String.valueOf(objectDetails[0].get(splittedValues[1]));
                                string Names = String.valueOf(objectDetails[0].get(fieldValue[0]));
                                defaultEmailDataItem.Email = email;
                                defaultEmailDataItem.Name = Names;                        
                            }                        
                        }   
                        /* String emailvalue = ''+objectDetails[0].get(queryField);
system.debug('emailvalue-->'+emailvalue);
DefaultEmailList defaultEmailDataItem = new DefaultEmailList();
defaultEmailDataItem.Name = emailItem.JunoDoc__Name__c;
defaultEmailDataItem.Email = emailvalue;
defaultEmailDataList.add(defaultEmailDataItem);*/
                        defaultEmailDataItem.EmailType = emailItem.JunoDoc__To_Value__c;
                        if(defaultEmailDataItem.Email != '' && defaultEmailDataItem.Email != null){
                            defaultEmailDataList.add(defaultEmailDataItem);
                        }
                        
                        //system.debug('defaultEmailDataItem-->'+defaultEmailDataItem);
                    }
                }
                system.debug('defaultEmailDataList-->'+defaultEmailDataList);
                return defaultEmailDataList;
            }
        }else{
            /*DefaultEmailList defaultEmailDataItem = new DefaultEmailList();
defaultEmailDataList.add(defaultEmailDataItem);*/
            return defaultEmailDataList;
        }
        return defaultEmailDataList;
    }
    
    @AuraEnabled
    global static string SaveFromEmailAddress(String recordId,string FromAddress){
        String sMessage = '';
        try{
            String sObjName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            System.debug('Object Name : '+sObjName);
            List<JunoDoc__Junosign_Object_Setting__c> signSettinglist =  new List<JunoDoc__Junosign_Object_Setting__c>();
            JunoDoc__Junosign_Object_Setting__c Junosign_Object_Setting = new JunoDoc__Junosign_Object_Setting__c();
            signSettinglist = [select Id,Name,createdDate,lastmodifieddate,JunoDoc__Selected_object__c, JunoDoc__FromEmailAddress__c 
                               from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c=:sObjName]; 
            if(signSettinglist.size() >0){
                Junosign_Object_Setting.Id = signSettinglist[0].Id;
                Junosign_Object_Setting.JunoDoc__FromEmailAddress__c = FromAddress;
                system.debug('FromAddress>>>>>>>>>>>>>>>>'+FromAddress);
                
            }else{
                Junosign_Object_Setting.JunoDoc__FromEmailAddress__c = FromAddress;
                Junosign_Object_Setting.JunoDoc__Selected_object__c = sObjName;
                system.debug('FromAddress>>>>>>>>>>>>>>>>'+FromAddress);
            }
            
            
            upsert Junosign_Object_Setting;
            system.debug('test---->'+Junosign_Object_Setting.Id);
            sMessage = 'Success';
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getMessage();
        }
        return sMessage;
    }
    
    @AuraEnabled
    global static string getFromEmailAddress(){
        String emailAdd='';
        List<Junodoc_Setting__c> setlist = [select id,JunoDoc__JunoSign_Default_From_Address__c from Junodoc_Setting__c Limit 1];
        if(!setlist.isEmpty()){
            emailAdd = setlist[0].JunoDoc__JunoSign_Default_From_Address__c;
        }
        return emailAdd;
    }
    
    @AuraEnabled
    global static Boolean getEnableAttachmentSetting(){
        Boolean isEnabled= false;
        List<Junodoc_Setting__c> setlist = [select id,JunoDoc__Enable_Attachment_List_View__c from Junodoc_Setting__c Limit 1];
        if(!setlist.isEmpty()){
            isEnabled = setlist[0].JunoDoc__Enable_Attachment_List_View__c;
        }
        return isEnabled;
    }
    
    
    public class DefaultEmailList{
        @AuraEnabled
        public string Name;
        @AuraEnabled 
        public string Email;
        @AuraEnabled 
        public string EmailType;
        @AuraEnabled 
        public Boolean ispostChecked;
        
    }
    public class DefaultTemplateInnCls{
        @AuraEnabled
        public string temId;
        @AuraEnabled 
        public string tempName;
    }
    
    public class SelectedReceipient{
        @AuraEnabled
        public string Name;
        @AuraEnabled 
        public string Email;
    }
    
    @AuraEnabled
    public static  map<string,string>  orgwideEmail(){
        map<string,string> emails = new  map<string,string>();
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();    
        
        list<OrgWideEmailAddress> OrgEmailAddressList = new list<OrgWideEmailAddress>();
        OrgEmailAddressList = [select Id,Address,IsAllowAllProfiles from OrgWideEmailAddress  where IsAllowAllProfiles = true Order by Address asc limit 100]; 
        if(OrgEmailAddressList.size()>0){
            for(OrgWideEmailAddress rec : OrgEmailAddressList){
                emails.put(rec.id,rec.Address);
            }
        }
        
        system.debug('emails-->'+emails);
        return emails;
    }
    
    
    @AuraEnabled
    public static ResultWrapper getinitialObjectFields(Id recId){
        String ObjAPIName = recId.getSObjectType().getDescribe().getName();
        system.debug('ObjAPIName--->'+ObjAPIName);
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
                if(/*String.ValueOf(dfield.getType()) == 'REFERENCE' || */String.ValueOf(dfield.getType()) == 'EMAIL'){
                    
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
        system.debug('ObjectName--->'+ObjectName+ ' ---> FirstField--->'+FirstField);
        List<string> FieldAPI = FirstField.split('-');
        //string FieldToReturn = ObjectName+'.'+FieldAPI[0];
        string FieldToReturn = FieldAPI[0];
        return FieldToReturn;
    }
    @AuraEnabled
    public static List<sObject> getConUserRec(String selectedObj,String matchStr){
        //List<conUserWrapCls> conUserWrap = new List<conUserWrapCls>();
        String filterName = '%'+matchStr+'%';
        String quereStr = 'Select Id,Name,Email from '+selectedObj + ' Where Name Like: filterName  ORDER BY Name LIMIT 20';
        system.debug('queryStr-->'+quereStr);
        List<sObject> objRecList = Database.query(quereStr); 
        return objRecList;
    }
    
    @AuraEnabled
    public static String getObjectAPIName(id rid){
        String sObjName = rid.getSObjectType().getDescribe().getName();
        system.debug(rid + '----->'+sObjName);
        return sObjName;
    }
    @AuraEnabled
    public static String getObjectLabelName(string rid){
        system.debug('rid1111111>>>>>>>>>>>>'+rid);
        String sObjName =Id.valueOf(rid).getSObjectType().getDescribe().getName();
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{sObjName}); 
        String objectLabel = describeSobjectsResult[0].getLabel();
        System.debug(objectLabel);
        return objectLabel;
    }
    
    @AuraEnabled
    public static LookUpInner getLookUpMail(string recId, String LookUp_Value){
        List<string> Objs = LookUp_Value.split('\\.');
        
        integer Objs_Length = Objs.size();
        
        
        String objName = Objs[0];    
        String ParentName = '';
        String EmailField = '';
        String NameField = '';
        String NameRepl = '';
        for(integer k=1;k<Objs.size();k++){
            ParentName = Objs[k];
            EmailField += ParentName +'.';
            
            if(!Objs[k].Contains('Email')){
                NameRepl = Objs[k];
            }
            else{
                NameRepl = 'Name';
            }
            NameField += NameRepl +'.';
            
        }
        NameField = NameField.substring(0,NameField.length()-1);
        EmailField = EmailField.substring(0,EmailField.length()-1);
        string query = 'select ';
        query += EmailField + ' ,'+ NameField +' ,id from ' + objName + ' where id =: recId';
        system.debug('query------>'+query);
        sObject sObj = Database.query(query);
        system.debug('sObj------>'+sObj);
        String[] EmailFields = EmailField.split('\\.');
        system.debug('EmailFields.size()--->'+EmailFields.size());
        //List<LookUpInner> LookUPS = new List<LookUpInner>();
        string email = '';
        string Names = '';
        
        if(EmailFields.size()==4){
            if(sObj.getSobject(EmailFields[0]) != null){
                if(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]) != null){
                    if(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).getSobject(EmailFields[2]) != null){
                        if(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).getSobject(EmailFields[2]).get(EmailFields[3]) != null){
                            email = String.valueOf(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).getSobject(EmailFields[2]).get(EmailFields[3]));
                            system.debug('level4---->'+email);
                            Names = String.valueOf(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).getSobject(EmailFields[2]).get('Name'));
                            system.debug('level4---->'+email);
                        }
                    }
                }
            }
        }
        else if(EmailFields.size()==3){ //Quote.Account.Owner.Email
            if(sObj.getSobject(EmailFields[0]) != null){
                if(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]) != null){
                    if(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).get(EmailFields[2]) != null){
                        email = String.valueOf(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).get(EmailFields[2]));
                        Names = String.valueOf(sObj.getSobject(EmailFields[0]).getSobject(EmailFields[1]).get('Name'));
                        system.debug('level3---->'+email);
                    }
                }
            }
        }
        else if(EmailFields.size()==2){ //Quote.Contact.Email
            Boolean isContactReference = false;
            if(EmailFields.contains('Contact')){
                isContactReference = true;
            }
            if(sObj.getSobject(EmailFields[0]) != null){
                if(sObj.getSobject(EmailFields[0]).get(EmailFields[1]) != null){
                    email = String.valueOf(sObj.getSobject(EmailFields[0]).get(EmailFields[1]));
                    Names = String.valueOf(sObj.getSobject(EmailFields[0]).get('Name'));
                    system.debug('level2---->'+email);
                }
            }
        }                            
        
        else if(EmailFields.size()==1){ //Quote.Email
            if(sObj.get(EmailFields[0]) != null){
                email = String.valueOf(sObj.get(EmailFields[0]));
                Names = String.valueOf(sObj.get('Name'));
                system.debug('level1---->'+email);
            }
        }
        LookUpInner LookUP = new LookUpInner();
        if(email != '' && email != null && Names != null && Names != ''){
            LookUP.Mail = email;
            LookUP.Name = Names;
            LookUP.Message = 'Success';
        }
        else{
            LookUP.Message = 'Error';
        }
        
        system.debug('LookUP----->'+LookUP);
        return LookUP;
        //LookUPS.add(LookUP);
        //system.debug('LookUPS----->'+LookUPS);
        //system.debug('mail------->'+sObj.get('contact.email'));
    }
    
    @AuraEnabled
    public static void deleteUploadedFiles(string tempFileList){
        List<FilesInner> tempFiles = (List<FilesInner>)JSON.deserialize(tempFileList, List<FilesInner>.class);
        string tempFile = '';
        for(FilesInner tempf: tempFiles){
            tempFile = tempf.fileContents;
        }
        ContentDocument Attachs = [SELECT id FROM ContentDocument Where id = :tempFile];
        delete Attachs;
    }
    
    /********* SAIRAM 13-03-2023 ***********/
    public static string DateFormats{get;set;}
    public static string CurrencyFormat{get;set;}
    public static string NumberFormat{get;set;}
    public static string currencysymbols{get;set;}
    public static boolean blankasZeroes{get;set;}
    public static map<string,string> currencySymbolMap{ get; set; }
    
    @AuraEnabled
    public static void generateEmailTemplateValues(id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        system.debug('sObjName---->'+sObjName);
        
        currencySymbolMap = new map<string,string>();
        list<JunoDoc__Junodoc_Currency__c> currencylist = [select Id,JunoDoc__Currency_Code__c,JunoDoc__Currency_Symbol__c from JunoDoc__Junodoc_Currency__c];
        if(!currencylist.isEmpty()){
            for(JunoDoc__Junodoc_Currency__c currencys : currencylist){
                currencySymbolMap.put(currencys.JunoDoc__Currency_Code__c,currencys.JunoDoc__Currency_Symbol__c);   
            }
        }
        
        Document uncheckdocument = new Document();
        Document  checkdocument = new Document();
        list<Document>  uncheckdocumentlist =[SELECT Name,Type,id 
                                              FROM Document 
                                              where Folder.name='JunoDoc Checkbox Folder' 
                                              and Name = 'unchecked002.png'
                                              and IsPublic = true and (Type='png' or Type='jpg' or Type = 'svg')];
        
        list<Document>  checkdocumentlist =[SELECT Name,Type,id 
                                            FROM Document 
                                            where Folder.name='JunoDoc Checkbox Folder' 
                                            and Name = 'checked.png'
                                            and IsPublic = true and (Type='png' or Type='jpg' or Type = 'svg')];
        if(uncheckdocumentlist.size() > 0)
            uncheckdocument = uncheckdocumentlist[0];
        
        if(checkdocumentlist.size() > 0)
            checkdocument = checkdocumentlist[0];
        
        string sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        sfdcURL = sfdcURL.replace('visualforce','documentforce');
        sfdcURL = sfdcURL.replace('junodoc.','c.');
        sfdcURL = sfdcURL.replace('visual.force','content.force');
        
        String templateHTMLValue = '';
        String templateSubject = '';
        JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName limit 1];
        // if(ObjSet != null){
        if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c != null){
            JunoDoc__Email_Template_Item__c emailTemplateRec = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c];
            JunoDoc__Email_Template__c emailTemp = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRec.JunoDoc__Email_Template__c];
            templateHtmlValue = emailTemplateRec.JunoDoc__Template_Body__c;
            templateSubject = emailTemplateRec.JunoDoc__Subject__c;
            system.debug('templateHtmlValue-->'+templateHtmlValue);
            
            String SobjectApiName = emailTemp.JunoDoc__Parent_Object__c;
            
            if(emailTemp.Junodoc__Date_Format__c != null && emailTemp.Junodoc__Date_Format__c != ''){
                DateFormats = emailTemp.Junodoc__Date_Format__c;
            }
            else{
                DateFormats = 'MM/dd/yyyy';
            }
            if(emailTemp.Junodoc__Currency_Format__c != null && emailTemp.Junodoc__Currency_Format__c != ''){
                CurrencyFormat = emailTemp.Junodoc__Currency_Format__c;
            }
            else{
                CurrencyFormat = '###,###.00';
            }
            
            if(emailTemp.JunoDoc__Number_Format__c != null && emailTemp.JunoDoc__Number_Format__c != ''){
                NumberFormat = emailTemp.JunoDoc__Number_Format__c;
            }
            else{
                NumberFormat = '###,###.00';
            }
            
            
            currencysymbols = '$';
            if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
            }
            Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
            // if(multiCurrencyEnabled){
            if(emailTemp.JunoDoc__Currency_Symbol__c != null && emailTemp.JunoDoc__Currency_Symbol__c != ''){
                emailTemp.JunoDoc__Currency_Symbol__c = emailTemp.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                Sobject Sobj = Database.query('select id,'+ emailTemp.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:recordId');
                currencysymbols = currencySymbolMap.get(''+Sobj.get(emailTemp.JunoDoc__Currency_Symbol__c));
            }
            
            if(templateHtmlValue.contains('{!TODAY()}')){
                Date Datestr = system.Today();
                string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                templateHtmlValue = templateHtmlValue.replace('{!TODAY()}',Parentvalues); 
                
            }
            if(templateHtmlValue.contains('{!NOW()}')){
                string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                templateHtmlValue = templateHtmlValue.replace('{!NOW()}',Parentvalues);  
            }
            if(templateHtmlValue.contains('{URL}')){
                string Parentvalues = 'junodoc__review_document_url';
                templateHtmlValue = templateHtmlValue.replace('{URL}',Parentvalues);  
            }
            
            if(templateHtmlValue.contains('{!#User.')){
                string qry = 'select ';
                templateHtmlValue = templateHtmlValue.replace('{!#User.','##user##');
                string[] strlist = templateHtmlValue.split('##user##');
                list<string> userfields = new list<string>();
                integer z = 0;
                for(string newstr : strlist){
                    if(z >= 1){
                        string[] userstr = newstr.split('}');
                        qry += userstr[0] + ',';
                        userfields.add(userstr[0]);
                        
                    }
                    z = z+1;
                }
                string userId = userinfo.getUserId();
                qry += 'Id from user where id=: userId';
                user users = Database.query(qry);
                if(!userfields.isEmpty()){
                    for(string str : userfields){
                        templateHtmlValue = templateHtmlValue.replace('##user##'+str+'}',''+users.get(str));  
                    }
                }
            }
            
            blankasZeroes =  emailTemp.JunoDoc__Blank_Fields_As_Zeroes__c;
            
            
            SObject parentRef;
            string[] TempBdylist = templateHtmlValue.replace('{!','#####').split('#####');
            list <String> convertlst = new list<string>();
            for(string str : TempBdylist){
                convertlst.add(str.split('}')[0]);
            }
            system.debug('convertlst-->'+convertlst);
            
            List <String> Fldlst = new list<string>();
            for(integer a=1;a<convertlst.size();a++){
                Fldlst.add(convertlst[a]);
            }
            
            if(Fldlst.size()>0){
                
                system.debug('Fldlst-->'+Fldlst);
                string qury = 'select ' + string.join(Fldlst,',') + ' from ' + SobjectApiName + ' where Id =\''+recordId +'\'';
                system.debug('qury-->'+qury);
                //   if(Test.isRunningTest()){
                //qury = 'Select Id,Name from Account';
               system.debug('qury-->'+qury);
                //'+' where Id =\''+recordId +'\'';
                //   }
                parentRef = Database.query(qury);
                system.debug('parentRef--->'+parentRef);
            }
            for(String strs: Fldlst){
                string str = strs.replace(' ','');
                string Parentvalues = '';
                if(!str.contains('.')){
                    if(parentRef.get(str) != null){
                        Parentvalues = ''+ parentRef.get(str);
                    }
                    else{
                        Parentvalues = '';
                    }
                }
                else{
                    string Stringobjct = str.replace('.',',');
                    string[] Stringobjcts = Stringobjct.split(',');
                    if(Stringobjcts.size() > 3){
                        if(parentRef.getsobject(Stringobjcts[0]) != null){
                            if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {  
                                if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                    string firstchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                    
                                    if(Types == 'CURRENCY'){
                                        Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                    }
                                    
                                    else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                        Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                    }
                                    
                                    else if(Types == 'DATE'){
                                        if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                            Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            string DateInt = ''+ Datestr.month();
                                            if(Datestr.month() < 10){
                                                DateInt = '0'+Datestr.month();
                                            }
                                        }
                                    }
                                    
                                    else if(Types == 'DATETIME'){
                                        if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                            Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
                                        }
                                    }
                                    
                                    else if(Types == 'BOOLEAN'){
                                        boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                        
                                        if(textbool == true){
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                        else{
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                    }
                                    
                                    else{ 
                                        Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                    }
                                }
                            }
                        }
                    }
                    else if(Stringobjcts.size() > 2){
                        if(parentRef.getsobject(Stringobjcts[0]) != null){
                            if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                    string secchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                    string Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);
                                    
                                    if(Types == 'CURRENCY'){
                                        Parentvalues = GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                    }
                                    
                                    else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                        Parentvalues = GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                    }
                                    
                                    else if(Types == 'DATE'){
                                        Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                        string DateInt = ''+ Datestr.month();
                                        if(Datestr.month() < 10){
                                            DateInt = '0'+Datestr.month();
                                        }
                                        Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                    }
                                    
                                    else if(Types == 'DATETIME'){
                                        Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
                                    }
                                    
                                    else if(Types == 'BOOLEAN'){
                                        boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                        if(textbool == true){
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                        else{
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                    }
                                    
                                    else{ 
                                        Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                    }
                                }
                            }
                        }
                    }
                    else{
                        if(parentRef.getsobject(Stringobjcts[0]) != null){    
                            if(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                string Types = getRelType(SobjectApiName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                
                                if(Types == 'CURRENCY'){
                                    Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                                
                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                    Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                                
                                else if(Types == 'DATE'){
                                    Date Datestr = Date.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                    string DateInt = ''+ Datestr.month();
                                    if(Datestr.month() < 10){
                                        DateInt = '0'+Datestr.month();
                                    }
                                    Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                }
                                
                                else if(Types == 'DATETIME'){
                                    Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
                                }
                                
                                else if(Types == 'BOOLEAN'){
                                    
                                    boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                    if(textbool == true){
                                        Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                    else{
                                        Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                }
                                
                                else{ 
                                    Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                }
                                
                            }
                        }
                    }
                }
                if(Parentvalues != ''){
                    if(templateHtmlValue.contains('Barcode[{!'+Str+'}]')){
                        templateHtmlValue = templateHtmlValue.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                    }
                    else{
                        templateHtmlValue = templateHtmlValue.replace('{!'+Str+'}',Parentvalues); 
                    }
                    
                }
                else{
                    templateHtmlValue = templateHtmlValue.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                }
                
            }
            
            if(templateSubject.contains('{!TODAY()}')){
                Date Datestr = system.Today();
                string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                templateSubject = templateSubject.replace('{!TODAY()}',Parentvalues); 
                
            }
            if(templateSubject.contains('{!NOW()}')){
                string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                templateSubject = templateSubject.replace('{!NOW()}',Parentvalues);  
            }
            
            if(templateSubject.contains('{!#User.')){
                string qry = 'select ';
                templateSubject = templateSubject.replace('{!#User.','##user##');
                string[] strlist = templateSubject.split('##user##');
                list<string> userfields = new list<string>();
                integer z = 0;
                for(string newstr : strlist){
                    if(z >= 1){
                        string[] userstr = newstr.split('}');
                        qry += userstr[0] + ',';
                        userfields.add(userstr[0]);
                        
                    }
                    z = z+1;
                }
                string userId = userinfo.getUserId();
                qry += 'Id from user where id=: userId';
                user users = Database.query(qry);
                if(!userfields.isEmpty()){
                    for(string str : userfields){
                        templateSubject = templateSubject.replace('##user##'+str+'}',''+users.get(str));  
                    }
                }
            }
            
            string[] TempSublist = templateSubject.replace('{!','#####').split('#####');
            list <String> convertSublst = new list<string>();
            for(string str : TempSublist){
                convertSublst.add(str.split('}')[0]);
            }
            system.debug('convertSublst-->'+convertSublst);
            
            List <String> FldSublst = new list<string>();
            for(integer a=1;a<convertSublst.size();a++){
                FldSublst.add(convertSublst[a]);
            }
            system.debug('FldSublst-->'+FldSublst);
            SObject parentSubRef;
            if(FldSublst.size()>0){
                string qurySub = 'select ' + string.join(FldSublst,',') + ' from ' + SobjectApiName + ' where Id =\''+recordId +'\'';
                system.debug('qurySub-->'+qurySub);
                
                parentSubRef = Database.query(qurySub);
                system.debug('parentSubRef--->'+parentSubRef);
            }
            for(String strs: FldSublst){
                system.debug('Strrs >>> '+strs);
                string str = strs.replace(' ','');
                string Parentvalues = '';
                if(!str.contains('.')){
                    if(parentSubRef.get(str) != null){
                        Parentvalues = ''+ parentSubRef.get(str);
                    }
                    else{
                        Parentvalues = '';
                    }
                }
                else{
                    string Stringobjct = str.replace('.',',');
                    string[] Stringobjcts = Stringobjct.split(',');
                    if(Stringobjcts.size() > 3){
                        if(parentSubRef.getsobject(Stringobjcts[0]) != null){
                            if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {  
                                if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                    string firstchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                    
                                    if(Types == 'CURRENCY'){
                                        Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                    }
                                    
                                    else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                        Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                    }
                                    
                                    else if(Types == 'DATE'){
                                        if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                            Date Datestr = Date.valueof(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            string DateInt = ''+ Datestr.month();
                                            if(Datestr.month() < 10){
                                                DateInt = '0'+Datestr.month();
                                            }
                                        }
                                    }
                                    
                                    else if(Types == 'DATETIME'){
                                        if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                            Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
                                        }
                                    }
                                    
                                    else if(Types == 'BOOLEAN'){
                                        boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                        
                                        if(textbool == true){
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                        else{
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                    }
                                    else{ 
                                        Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                    }
                                }
                            }
                        }
                    }
                    else if(Stringobjcts.size() > 2){
                        if(parentSubRef.getsobject(Stringobjcts[0]) != null){
                            if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                if(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                    string secchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                    string Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);  
                                    
                                    if(Types == 'CURRENCY'){
                                        Parentvalues = GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                    }
                                    
                                    else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                        Parentvalues = GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                    }
                                    
                                    else if(Types == 'DATE'){
                                        Date Datestr = Date.valueof(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                        string DateInt = ''+ Datestr.month();
                                        if(Datestr.month() < 10){
                                            DateInt = '0'+Datestr.month();
                                        }
                                        Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                    }
                                    
                                    else if(Types == 'DATETIME'){
                                        Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
                                    }
                                    
                                    else if(Types == 'BOOLEAN'){
                                        boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                        if(textbool == true){
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                        else{
                                            Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                    }
                                    else{ 
                                        Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                    }
                                }
                            }
                        }
                    }
                    else{
                        if(parentSubRef.getsobject(Stringobjcts[0]) != null){    
                            if(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                string Types = getRelType(SobjectApiName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                
                                if(Types == 'CURRENCY'){
                                    Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                                
                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                    Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                                
                                
                                /*if (parentRef != null && Stringobjcts != null && Stringobjcts.size() >= 2) {
    Object obj = parentRef.getsobject(Stringobjcts[0]);
    if (obj != null) {
        Object fieldValue = obj.get(Stringobjcts[1]);
        if (fieldValue != null && fieldValue instanceOf Date) {
            Date Datestr = (Date)fieldValue;
            String DateInt = String.valueOf(Datestr.month());
            if (Datestr.month() < 10) {
                DateInt = '0' + Datestr.month();
            }
            // Further processing with DateInt
        } else {
            System.debug('Field value is null or not a Date type');
        }
    } else {
        System.debug('Object is null for given parent reference and object name');
    }
} else {
    System.debug('Parent reference or String objects array is null or does not contain enough elements');
}*/
                                else if(Types == 'DATE' && parentRef != null && Stringobjcts != null && Stringobjcts.size() >= 2){
                                  SObject obj = parentRef.getsobject(Stringobjcts[0]);
    if (obj != null) {
        Object fieldValue = obj.get(Stringobjcts[1]);
        if (fieldValue != null && fieldValue instanceOf Date) {
            Date Datestr = (Date)fieldValue;
            String DateInt = String.valueOf(Datestr.month());
            if (Datestr.month() < 10) {
                DateInt = '0' + Datestr.month();
            }
                                        }
                                    }
                                    Date Datestr = Date.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                    string DateInt = ''+ Datestr.month();
                                    if(Datestr.month() < 10){
                                        DateInt = '0'+Datestr.month();
                                    }
                                    Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                }
                                
                                else if(Types == 'DATETIME'){
                                    Parentvalues = Datetime.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
                                }
                                
                                else if(Types == 'BOOLEAN'){
                                    
                                    boolean textbool = boolean.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                    if(textbool == true){
                                        Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                    else{
                                        Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                }
                                else{ 
                                    Parentvalues = ''+parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                }
                                
                            }
                        }
                    }
                }
                if(Parentvalues != ''){
                    if(templateSubject.contains('Barcode[{!'+Str+'}]')){
                        templateSubject = templateSubject.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                    }
                    else{
                        templateSubject = templateSubject.replace('{!'+Str+'}',Parentvalues); 
                    }
                    
                }
                else{
                    templateSubject = templateSubject.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                }
                
            }
            
            
            JunoDoc__Email_Template__c junoEmail = new JunoDoc__Email_Template__c();
            junoEmail.Id = ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c;
            junoEmail.JunoDoc__Junodoc_generated_template_body__c = templateHTMLValue;
            junoEmail.JunoDoc__Junodoc_generated_template_subject__c = templateSubject;
            update junoEmail;
            // templateHtmlValue += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';
        }
        
        system.debug('templateHTMLValue---->'+templateHTMLValue);
        system.debug('templateSubject---->'+templateSubject);
        
    }
    
    
    public static String getRelType(string ObjectName,String FieldName,String parfieldName){
        // system.debug(ObjectName + '***** '+ FieldName);
        if(FieldName.contains('__r')){
            FieldName = FieldName.replace('__r','__c');
        }
        else{
            FieldName = FieldName+'Id';
        }
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields
            .getMap()
            .get(fieldName)
            .getDescribe();
        string parObjectName = '';
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            parObjectName = reference.getDescribe().getName();
        }
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(parObjectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        string Types = ''+ fieldMap.get(parfieldName).getDescribe().getType();
        //debug('Types ' + Types);
        return Types;
        
    }
    public static String getchilType(string ObjectName,String FieldName){
        // system.debug(ObjectName + '***** '+ FieldName);
        if(FieldName.contains('__r')){
            FieldName = FieldName.replace('__r','__c');
        }
        else{
            FieldName = FieldName+'Id';
        }
        Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields
            .getMap()
            .get(fieldName)
            .getDescribe();
        string parObjectName = '';
        for(Schema.SObjectType reference : f.getReferenceTo()) {
            parObjectName = reference.getDescribe().getName();
        }
        return parObjectName;
    }
    public static Boolean shouldCheckDigit { get; set; }
    public static string getBarcodes(string sourceCodeValue){
        shouldCheckDigit = false;
        list<string> barcodelist = generateCode39(sourceCodeValue, shouldCheckDigit).split('');
        string barcodes = '<div style="display: inline-block; border: 0px solid black;">';
        barcodes += '<div >';
        for(integer barc = 0;barc< barcodelist.size();barc++){
            if(barcodelist[barc] == '1'){
                barcodes += '<h3  style="margin-left: -2.4px;font-weight:bold;background-color: black;display: inline-block;padding: 0;width: 1px;height: 1.5cm;display: inline-block;" />';
            }
            else{
                barcodes += '<h3  style="margin-left: -2.4px;font-weight:bold;background-color: white;display: inline-block;padding: 0;width: 1px;height: 1.5cm;display: inline-block;" />';
            }
        }
        barcodes += '</div>';
        barcodes += '<div style="text-align: center">';
        barcodes += sourceCodeValue;
        barcodes += '</div>';
        barcodes += '</div>';
        return barcodes;
    }
    public static String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';
    public static String[] values = new String[] {
        '1010001110111010', '1110100010101110', '1011100010101110', '1110111000101010',
            '1010001110101110', '1110100011101010', '1011100011101010', '1010001011101110',
            '1110100010111010', '1011100010111010', '1110101000101110', '1011101000101110',
            '1110111010001010', '1010111000101110', '1110101110001010', '1011101110001010',
            '1010100011101110', '1110101000111010', '1011101000111010', '1010111000111010',
            '1110101010001110', '1011101010001110', '1110111010100010', '1010111010001110',
            '1110101110100010', '1011101110100010', '1010101110001110', '1110101011100010',
            '1011101011100010', '1010111011100010', '1110001010101110', '1000111010101110',
            '1110001110101010', '1000101110101110', '1110001011101010', '1000111011101010',
            '1000101011101110', '1110001010111010', '1000111010111010', '1000100010001010',
            '1000100010100010', '1000101000100010', '1010001000100010', '1000101110111010' };
                public static String generateCode39(String source, Boolean checkDigit) {        
                    // Output
                    String[] result = new String[0];
                    Integer index,      // Temp variable
                        total = 0;  // Checksum calculation
                    source = source == null? '': source;
                    result.add(values[keys.indexOf('*')]);
                    for(String sourceChar: source.toUpperCase().split('')) {
                        if((index = keys.indexOf(sourceChar)) > -1) {
                            result.add(values[index]);
                            total += index;
                        }
                    }
                    if(checkDigit) {
                        result.add(values[Math.mod(total, 43)]);
                    }
                    result.add(values[keys.indexOf('*')]);
                    return String.join(result,'');
                }
    public static string GetCurrencyvalues(string currencyvalue){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
        //  system.debug('CurrencyFormat' + CurrencyFormat);
        if(CurrencyFormat.contains('.0')){
            CurrList = CurrencyFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
        }
        if(CurrencyFormat.contains(',0')){
            CurrList = CurrencyFormat.replace(',','xx').split('xx');
            // system.debug('CurrList' + CurrList);
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
        // system.debug(currencyvalue + ' currencyvalue');
        string currencies = '';
        
        string currencysymbol = '$';
        
        if(currencysymbols != null && currencysymbols != ''){
            currencysymbol = currencysymbols;
        }
        if(currencyvalue != '' && currencyvalue != null){
            if(decimal.valueof(''+currencyvalue) > 0){
                currencies =  currencysymbol +  doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
            }
            else if(blankasZeroes == true){
                currencies = currencysymbol + doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
            }
        }
        else if(blankasZeroes == true){
            currencies = currencysymbol +  doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
        
    }
    
    public static string GetNumbervalues(string currencyvalue){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
        boolean showcurrency = false;
        // system.debug(currencyvalue + ' CurrencyFormat ' + NumberFormat);
        if(NumberFormat.contains('.0')){
            CurrList = NumberFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
        }
        else if(NumberFormat.contains(',0')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
            //  system.debug('CurrList' + CurrList);
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
        else if(NumberFormat.contains(',')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
            //  system.debug('CurrList' + CurrList);
            currlength = 0;
            firstcol = ',';
        }
        else if(NumberFormat.contains('.')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
            //  system.debug('CurrList' + CurrList);
            currlength = 0;
            firstcol = '.';
        }
        else{
            showcurrency = true;
        }
        // system.debug(currencyvalue + ' currencyvalue');
        string currencies = '';
        
        if(currencyvalue != '' && currencyvalue != null){
            if(showcurrency == false){
                if(decimal.valueof(''+currencyvalue) > 0){
                    currencies =  doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
                }
                else if(blankasZeroes == true){
                    currencies = doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
                }
            }
            else{
                currencies = ''+integer.valueof(''+currencyvalue);
            }
        }
        else if(blankasZeroes == true){
            currencies = doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
        
    }
    public static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
        String s, tmp;
        Integer i = 4 + dec;
        //    system.debug(i + ' ****** ' + dec);
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
        //system.debug(i + ' ******new ');
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        // system.debug(s + ' ******s ');
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
        // system.debug(s + ' ******tmp ');
        
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
        //system.debug(s + ' ******last5 ');
        return s;
    }
    
    
     @AuraEnabled
    public static Boolean getAccountFieldValue() {
        JunoDoc__Junodoc_Setting__c acc = [SELECT Id, JunoDoc__Enable_JunoSign_Post_Actions__c FROM JunoDoc__Junodoc_Setting__c Limit 1];
        return acc.JunoDoc__Enable_JunoSign_Post_Actions__c;
    }
    
    /********* SAIRAM 13-03-2023 ***********/
    
    public class FilesInner{
        @AuraEnabled
        public string name {get;set;}
        @AuraEnabled
        public string fileContents {get;set;}
    }
    
    public Class LookUpInner{
        @AuraEnabled
        public string Message{get;set;}
        @AuraEnabled
        public string Name{get;set;}
        @AuraEnabled
        public string Mail{get;set;}
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
    
    public class emailListWrap{
        @AuraEnabled
        public String lable{get;set;}
        
        @AuraEnabled
        public string value{get;set;}
    }
      @AuraEnabled
    public static List<Map<String, String>> getObjectFields(String recordId) {
        Id recId = Id.valueOf(recordId);
        Map<String, Schema.SObjectField> fieldsMap = recId.getSObjectType().getDescribe().fields.getMap();        
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
        for (String fieldName : fieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(fieldName).getDescribe();
            Map<String, String> fieldInfo = new Map<String, String>();            
            fieldInfo.put('label', fieldDescribe.getLabel());
            fieldInfo.put('value', fieldDescribe.getName());            
            fieldsList.add(fieldInfo);
        }
        return fieldsList;
    }

    @AuraEnabled
    public static String getRecordName(String recordId) {
        try {
            if (String.isBlank(recordId)) {
                return '';
            }
            // Determine the object type dynamically
            Id recId = (Id)recordId;
            String sObjectName = recId.getSObjectType().getDescribe().getName();
            String query = 'SELECT Name FROM ' + sObjectName + ' WHERE Id = :recordId LIMIT 1';
            sObject record = Database.query(query);
            return (String)record.get('Name');
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching record name: ' + e.getMessage());
        }
    }
    
    /*public static void performImmediateUpdate(String recordId, List<Object> actionsToPerform) {
        try {
            List<JunoSignPostActionsController.PostActionRecords> typedActions = 
                (List<JunoSignPostActionsController.PostActionRecords>)JSON.deserialize(JSON.serialize(actionsToPerform), List<JunoSignPostActionsController.PostActionRecords>.class);
            
            String objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            
            sObject recordToUpdate = (sObject)Type.forName('Schema.' + objectName).newInstance();
            recordToUpdate.put('Id', recordId);
            
            Boolean hasUpdates = false;
            
            for (JunoSignPostActionsController.PostActionRecords action : typedActions) {
                if (String.isNotBlank(action.fieldName) && action.fieldValue != null) {
                    
                    SObjectField field = fieldMap.get(action.fieldName);
                    if (field == null) {
                        continue; 
                    }
                    
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    Object valueToAssign;
                    
                    try {
                        if (fieldType == Schema.DisplayType.Date) {
                            if (action.fieldValue.equalsIgnoreCase('today')) {
                                valueToAssign = System.today();
                            } else if (action.fieldValue.equalsIgnoreCase('yesterday')) {
                                valueToAssign = System.today().addDays(-1);
                            } else if (action.fieldValue.equalsIgnoreCase('tomorrow')) {
                                valueToAssign = System.today().addDays(1);
                            } else {
                                valueToAssign = Date.valueOf(action.fieldValue);
                            }
                        } else if (fieldType == Schema.DisplayType.DateTime) {
                            if (action.fieldValue.equalsIgnoreCase('today')) {
                                valueToAssign = System.now();
                            } else if (action.fieldValue.equalsIgnoreCase('yesterday')) {
                                valueToAssign = System.now().addDays(-1);
                            } else if (action.fieldValue.equalsIgnoreCase('tomorrow')) {
                                valueToAssign = System.now().addDays(1);
                            } else {
                                valueToAssign = DateTime.valueOf(action.fieldValue);
                            }
                        } else if (fieldType == Schema.DisplayType.Boolean) {
                            valueToAssign = Boolean.valueOf(action.fieldValue);
                        } else if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Percent) {
                            valueToAssign = Double.valueOf(action.fieldValue);
                        } else if (fieldType == Schema.DisplayType.Integer) {
                            valueToAssign = Integer.valueOf(action.fieldValue);
                        } else {
                            valueToAssign = action.fieldValue;
                        }
                        
                        recordToUpdate.put(action.fieldName, valueToAssign);
                        hasUpdates = true;
                        
                    } catch (Exception e) {
                        System.debug('Could not convert value "' + action.fieldValue + '" for field ' + action.fieldName + '. Error: ' + e.getMessage());
                        continue;
                    }
                }
            }
            
            if (hasUpdates) {
                update recordToUpdate;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException('Error updating record: ' + e.getMessage());
        }
    }*/
    
     @AuraEnabled
    public static void performImmediateUpdate(String recordId, string actionsToPerform) {
        try {
            List<PostActionRecords> typedActions = 
                (List<PostActionRecords>)JSON.deserialize(actionsToPerform, List<PostActionRecords>.class);
            String objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            
            sObject recordToUpdate = (sObject)Type.forName('Schema.' + objectName).newInstance();
            recordToUpdate.put('Id', recordId);
            
            Boolean hasUpdates = false;
            
            for (PostActionRecords action : typedActions) {
                if (String.isNotBlank(action.fieldName) && action.fieldValue != null) {
                    
                    SObjectField field = fieldMap.get(action.fieldName);
                    if (field == null) {
                        continue; 
                    }
                    
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    Object valueToAssign;
                    
                    try {
                        if (fieldType == Schema.DisplayType.Date) {
                            if (action.fieldValue.equalsIgnoreCase('today')) {
                                valueToAssign = System.today();
                            } else if (action.fieldValue.equalsIgnoreCase('yesterday')) {
                                valueToAssign = System.today().addDays(-1);
                            } else if (action.fieldValue.equalsIgnoreCase('tomorrow')) {
                                valueToAssign = System.today().addDays(1);
                            } else {
                                valueToAssign = Date.valueOf(action.fieldValue);
                            }
                        } else if (fieldType == Schema.DisplayType.DateTime) {
                            if (action.fieldValue.equalsIgnoreCase('today')) {
                                valueToAssign = System.now();
                            } else if (action.fieldValue.equalsIgnoreCase('yesterday')) {
                                valueToAssign = System.now().addDays(-1);
                            } else if (action.fieldValue.equalsIgnoreCase('tomorrow')) {
                                valueToAssign = System.now().addDays(1);
                            } else {
                                valueToAssign = DateTime.valueOf(action.fieldValue);
                            }
                        } else if (fieldType == Schema.DisplayType.Boolean) {
                            valueToAssign = Boolean.valueOf(action.fieldValue);
                        } else if (fieldType == Schema.DisplayType.Double || fieldType == Schema.DisplayType.Currency || fieldType == Schema.DisplayType.Percent) {
                            valueToAssign = Double.valueOf(action.fieldValue);
                        } else if (fieldType == Schema.DisplayType.Integer) {
                            valueToAssign = Integer.valueOf(action.fieldValue);
                        } else {
                            valueToAssign = action.fieldValue;
                        }
                        
                        recordToUpdate.put(action.fieldName, valueToAssign);
                        hasUpdates = true;
                        
                    } catch (Exception e) {
                        System.debug('Could not convert value "' + action.fieldValue + '" for field ' + action.fieldName + '. Error: ' + e.getMessage());
                        continue;
                    }
                }
            }
            
            if (hasUpdates) {
                update recordToUpdate;
            }
            
        } catch (Exception e) {
            system.debug('Error updating record: ' + e.getMessage()+' bbbbbb '+e.getStackTraceString());
            throw new AuraHandledException('Error updating record: ' + e.getMessage()+' bbbbbb '+e.getStackTraceString());
        }
    }
    
        public class PostActionRecords {
        @AuraEnabled  public String fieldName ;
        @AuraEnabled public String fieldType;
        @AuraEnabled  public String fieldValue;
       // @AuraEnabled public String fieldDetail;
        //@AuraEnabled public String parentId;
    }
}
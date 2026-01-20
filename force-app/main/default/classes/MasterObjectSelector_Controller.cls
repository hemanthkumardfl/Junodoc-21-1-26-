global without sharing class MasterObjectSelector_Controller {
    
    @AuraEnabled
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
        system.debug('objects ----' + objects.size());
        for(String objLabel : objects){
            system.debug(objLabel + 'objects Names' + objectNameMap.get(objLabel));
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
        //Inn.attachAsPdfOptions = getPicklistFieldValues('JunoDoc__Junodoc_Details__c', 'JunoDoc__Attach_as_PDF__c');
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
        @AuraEnabled
        global list<DocTemplatesWrap> attachAsPdfOptions;
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
    public static void createrecord(string fromEmailAddress,string setReplyTo,string standardEmailtemplates,string junoDocEmailtemplates,
                                    string selectedobject,string emaillist,string docvalue,string globalParentId,string parentObjectName,
                                    string childObjectName,string childObjectFieldName,string parentObjectFieldName,
                                    string childObjectReplaceFieldName){
                                        system.debug(fromEmailAddress);
                                        system.debug(setReplyTo);
                                        system.debug(standardEmailtemplates);
                                        system.debug(junoDocEmailtemplates);
                                        system.debug(selectedobject);
                                        system.debug(emaillist);
                                        
                                        //Add the below two as parameters and update PDFselector
                                        string attachAsPdf; 
                                        string attachAsPdfParent;
                                        
                                        
                                        List<Junodoc_Details__c> jdlist = [select id,From_Email_Address__c,Junodoc_Email_Templates__c, 
                                                                           Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c,
                                                                           JunoDoc__Global_Activity_Parent_Record_ID__c from Junodoc_Details__c where Selected_object__c =: selectedobject];
                                        // JunoDoc__Attach_as_PDF_Parent__c, ,JunoDoc__Attach_as_PDF__c, add these back later if need attach as pdf functionality
                                        Junodoc_Details__c jd = new Junodoc_Details__c();
                                        jd.From_Email_Address__c=fromEmailAddress;
                                        jd.Junodoc_Email_Templates__c=junoDocEmailtemplates;
                                        jd.Standard_Email_Templates__c=standardEmailtemplates;
                                        jd.Set_Reply_To__c=setReplyTo;
                                        jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;
                                        jd.Selected_object__c=selectedobject;
                                        jd.JunoDoc__Global_Activity_Parent_Record_ID__c = globalParentId;
                                        jd.JunoDoc__Parent_Object_Name__c = parentObjectName;
                                        jd.JunoDoc__Child_Object_Name__c = childObjectName;
                                        jd.JunoDoc__Child_Object_Field_Name__c = childObjectFieldName;
                                        jd.JunoDoc__Parent_Object_Field_Name__c = parentObjectFieldName;
                                        jd.JunoDoc__Child_Object_Replace_Field_Name__c = childObjectReplaceFieldName;
                                        //jd.JunoDoc__Attach_as_PDF__c = attachAsPdf;
                                        //jd.JunoDoc__Attach_as_PDF_Parent__c = attachAsPdfParent;
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
        system.debug('selectedobject---------> '+selectedobject);
        string selectedobjID;
        List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
        juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,JunoDoc__Global_Activity_Parent_Record_ID__c,JunoDoc__Parent_Object_Name__c,
                JunoDoc__Child_Object_Name__c,JunoDoc__Child_Object_Replace_Field_Name__c,Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,
                JunoDoc__Junodoc_Doc_Template__c,JunoDoc__Child_Object_Field_Name__c,JunoDoc__Parent_Object_Field_Name__c,
                JunoDoc__Hide_Attach_as_PDF__c, JunoDoc__Hide_Save_as_Activity__c,JunoDoc__Parent_Object__c 
                from Junodoc_Details__c where Selected_object__c =: selectedobject]; // ,JunoDoc__Attach_as_PDF_Parent__c, JunoDoc__Attach_as_PDF__c
        GetDetailsInner getInner = new GetDetailsInner();
        If(juno.size()>0){  
            List<JunoDoc__Email_Details__c> junoEmailList = [select JunoDoc__To_Value__c,JunoDoc__Text_Ref_Value__c,JunoDoc__Email__c,JunoDoc__field_Details__c 
                                                             from JunoDoc__Email_Details__c where JunoDoc__Junodoc_Details__c=:juno[0].Id];
            
            
            getInner.junodoc=juno;
            getInner.attachAsPdfOptions = getPicklistFieldValues('JunoDoc__Junodoc_Details__c', 'JunoDoc__Attach_as_PDF__c');
            
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
            system.debug('getInner----------> '+getInner);
            
            
        }
        if(juno.size() > 0){
            return getInner;     
        }else{
            return null;
        }
        
        
    }
    
    public static List<DocTemplatesWrap> getPicklistFieldValues(string objectApiName, string fieldName){
        List<DocTemplatesWrap> PicklistValuesList = new List<DocTemplatesWrap>();
        
        try{  
            system.debug('objectApiName => ' + objectApiName);
            system.debug('fieldName => ' + fieldName);
            // Get the global describe map
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectType = globalDescribe.get(objectApiName);
            // Get the describe result for the object
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
            
            // Get a map of field API names to field descriptors
            Map<String, Schema.SObjectField> fields = describeResult.fields.getMap();
            
            Schema.SObjectField field = fields.get(fieldName);
            system.debug('field Name => ' + fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            system.debug('fieldDescribe.getType().name() => ' + fieldDescribe.getType().name());
            if(fieldDescribe.getType().name() == 'PICKLIST' || fieldDescribe.getType().name() == 'MULTIPICKLIST'){
                List<Schema.PicklistEntry> picklistEntries = fieldDescribe.getPicklistValues();
                
                for (Schema.PicklistEntry entry : picklistEntries) {
                    system.debug('wrap => ' + fieldDescribe.getType().name());
                    DocTemplatesWrap wrap = new DocTemplatesWrap();
                    wrap.label = entry.getLabel();
                    wrap.value = entry.getValue();
                    PicklistValuesList.add(wrap);
                }
            }
        } catch(Exception ex){
            string err = 'Error at Line Number :: ' + ex.getLineNumber() + ' ==> ' + ex.getMessage();
            system.debug(err);
        }
        return PicklistValuesList;
    }
    
    
    /*  @AuraEnabled
public static GetDetailsInner  getrecorddetails(string selectedobject){
system.debug('@@@');
List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,
Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c
from Junodoc_Details__c 
where Selected_object__c =: selectedobject];

system.debug(juno);
system.debug(juno[0].Junodoc_Email_Templates__c);
system.debug(juno[0].Standard_Email_Templates__c);
GetDetailsInner get = new GetDetailsInner();
get.junodoc = juno;
get.emailDetailslist = emailDetailslistquery;

if(GetDetailsInner != null){
return GetDetailsInner;     
}else{
return null;
}


}
*/ 
    
    
    public class GetDetailsInner{
        @AuraEnabled 
        public List<Junodoc_Details__c> junodoc{get;set;}
        
        @AuraEnabled
        public List<returnEmailDetails> junoEmailList {get;set;}
        
        @AuraEnabled
        public List<DocTemplatesWrap> attachAsPdfOptions{get;set;}
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
    
    /* Added By Sainath on 09-Sep-2025 for Hide Attach as PDF and Save as Activity functionality */
    @AuraEnabled
    public static string saveSettings(string fromEmailAddress,string setReplyTo,string standardEmailtemplates,string junoDocEmailtemplates,
                                    string selectedobject,string emaillist,string docvalue,string globalParentId,string parentObjectName,
                                    string childObjectName,string childObjectFieldName,string parentObjectFieldName,
                                    string childObjectReplaceFieldName, Boolean hideAttachAsPDF, Boolean hideSaveAsActivity,string parentObjects)
    {
        system.debug(fromEmailAddress);
        system.debug(setReplyTo);
        system.debug(standardEmailtemplates);
        system.debug(junoDocEmailtemplates);
        system.debug(selectedobject);
        system.debug(emaillist);
        
        system.debug('hideAttachAsPDF => ' + hideAttachAsPDF);
        system.debug('hideSaveAsActivity => ' + hideSaveAsActivity);
        system.debug('parentObjects >> '+parentObjects);
        
        //Add the below two as parameters and update PDFselector
        string attachAsPdf; 
        string attachAsPdfParent;
        
        
        List<Junodoc_Details__c> jdlist = [SELECT id,From_Email_Address__c,Junodoc_Email_Templates__c, 
                                           Standard_Email_Templates__c,Set_Reply_To__c,JunoDoc__Selected_object__c,JunoDoc__Junodoc_Doc_Template__c,
                                           JunoDoc__Global_Activity_Parent_Record_ID__c, JunoDoc__Hide_Attach_as_PDF__c, JunoDoc__Hide_Save_as_Activity__c 
                                           FROM Junodoc_Details__c WHERE JunoDoc__Selected_object__c = :selectedobject];
        // JunoDoc__Attach_as_PDF_Parent__c, ,JunoDoc__Attach_as_PDF__c, add these back later if need attach as pdf functionality
        Junodoc_Details__c jd = new Junodoc_Details__c();
        jd.From_Email_Address__c=fromEmailAddress;
        jd.Junodoc_Email_Templates__c=junoDocEmailtemplates;
        jd.Standard_Email_Templates__c=standardEmailtemplates;
        jd.Set_Reply_To__c=setReplyTo;
        jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;
        jd.Selected_object__c=selectedobject;
        jd.JunoDoc__Global_Activity_Parent_Record_ID__c = globalParentId;
        jd.JunoDoc__Parent_Object_Name__c = parentObjectName;
        jd.JunoDoc__Child_Object_Name__c = childObjectName;
        jd.JunoDoc__Child_Object_Field_Name__c = childObjectFieldName;
        jd.JunoDoc__Parent_Object_Field_Name__c = parentObjectFieldName;
        jd.JunoDoc__Child_Object_Replace_Field_Name__c = childObjectReplaceFieldName;
        
        //jd.JunoDoc__Attach_as_PDF__c = attachAsPdf;
        //jd.JunoDoc__Attach_as_PDF_Parent__c = attachAsPdfParent;
        
        jd.JunoDoc__Hide_Attach_as_PDF__c = hideAttachAsPDF;
        jd.JunoDoc__Hide_Save_as_Activity__c = hideSaveAsActivity;
        jd.JunoDoc__Parent_Object__c = parentObjects;
        
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
        return parentObjects;
    }
    
    
    public class ParentInfo {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public ParentInfo(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    @AuraEnabled
    public static List<ParentInfo> getParentObjects(String childObjectApiName) {
        List<ParentInfo> parents = new List<ParentInfo>();
        Set<String> uniqueParents = new Set<String>(); // to avoid duplicates
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(childObjectApiName);
        if (objType == null) return parents;
        
        Schema.DescribeSObjectResult describe = objType.getDescribe();
        Map<String, Schema.SObjectField> fields = describe.fields.getMap();
        
        for (String fieldName : fields.keySet()) {
            Schema.DescribeFieldResult f = fields.get(fieldName).getDescribe();
            
            if (f.getReferenceTo().size() > 0) {
                for (Schema.SObjectType parent : f.getReferenceTo()) {
                    String parentApiName = parent.getDescribe().getName();
                    
                    // Only add if not already added
                    if (!uniqueParents.contains(parentApiName)) {
                        uniqueParents.add(parentApiName);
                        
                        parents.add(
                            new ParentInfo(
                                parent.getDescribe().getLabel(),
                                parentApiName
                            )
                        );
                    }
                }
            }
        }
        
        return parents;
    }
    
    
    
}
Global class JunosignObjectSettings {
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
       
        Inn.JunoDocPDFTemplatesList = JunoDocPDFTemplatesList;
        Inn.OrgwideEmailAddressList = orgWideEmailsList;
        return Inn;
    }    
    
    global class InnerEmailTemplates{
       
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
    public static void createrecord(string selectedobject,string emaillist,string docvalue, string orgemailId){
       
        system.debug(selectedobject);
        system.debug(emaillist);
        
        
        List<JunoDoc__Junosign_Object_Setting__c> jdlist = [select id,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c, JunoDoc__FromEmailAddress__c from JunoDoc__Junosign_Object_Setting__c where Selected_object__c =: selectedobject];
        JunoDoc__Junosign_Object_Setting__c jd = new JunoDoc__Junosign_Object_Setting__c();
        jd.JunoDoc__Junodoc_Doc_Template__c=docvalue;
        jd.Selected_object__c=selectedobject;
        jd.JunoDoc__FromEmailAddress__c = orgemailId;
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
    }
    @AuraEnabled
    public static GetDetailsInner getrecorddetails(string selectedobject){
        system.debug('@@@');
        string selectedobjID;
        List<JunoDoc__Junosign_Object_Setting__c> juno =  new List<JunoDoc__Junosign_Object_Setting__c>();
        juno = [select id,
                                            JunoDoc__Selected_object__c,JunoDoc__Junodoc_Doc_Template__c
                                          from JunoDoc__Junosign_Object_Setting__c 
                                          where JunoDoc__Selected_object__c =: selectedobject];
        GetDetailsInner getInner = new GetDetailsInner();
        If(juno.size()>0){  
        List<JunoDoc__Email_Details__c> junoEmailList = [select JunoDoc__Name__c,JunoDoc__To_Value__c,JunoDoc__Text_Ref_Value__c,JunoDoc__Email__c,JunoDoc__field_Details__c    
                                                        from JunoDoc__Email_Details__c where JunoDoc__Junosign_Object_Setting__c=:juno[0].Id];
        
        
        getInner.junodoc=juno;
        list<returnEmailDetails> returnEmailDetailslist = new list<returnEmailDetails>();
        for(JunoDoc__Email_Details__c jumoEmil : junoEmailList){
            returnEmailDetails returnEmailDetailsrec = new returnEmailDetails();
            returnEmailDetailsrec.Tovalue = jumoEmil.JunoDoc__To_Value__c;
            returnEmailDetailsrec.TextRefVal = jumoEmil.JunoDoc__Text_Ref_Value__c;
            returnEmailDetailsrec.Email = jumoEmil.JunoDoc__Email__c;
            returnEmailDetailsrec.TextName = jumoEmil.JunoDoc__Name__c;
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
    
    @AuraEnabled
    public static string getAttachmentData(){
        JunoDoc__Junodoc_Page_Tab__c checkobj = [select id,Name from JunoDoc__Junodoc_Page_Tab__c where Name = 'Junosign Logo'];
        Attachment Att = [select id,Name from attachment where parentId =: checkobj.id];
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@'+Att);
        return Att.id;
    }
    
    
     @AuraEnabled
    public static Id saveChunks(String fileName, String base64Data, String contentType) {
        list<JunoDoc__Junodoc_Page_Tab__c> checkobjlist = [select id,Name from JunoDoc__Junodoc_Page_Tab__c where Name = 'Junosign Logo'];
        string parentId = '';
        string filesId = '';
        if(!checkobjlist.isEmpty()){
            list<attachment> attlist = [select id from attachment where name = 'JunosignLogo'];
            parentId = checkobjlist[0].id;
            if(!attlist.isEmpty()){
                delete attlist;
            }
            saveTheFile(parentId, fileName, base64Data, contentType);
        }
        else{
            JunoDoc__Junodoc_Page_Tab__c Objs = new JunoDoc__Junodoc_Page_Tab__c();
            Objs.Name = 'Junosign Logo';
            insert Objs;
            parentId = Objs.id;
        }
        string fileId = '';
        if (checkobjlist.isEmpty()) {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        }
        return Id.valueOf(parentId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        system.debug(EncodingUtil.base64Decode(base64Data));
        system.debug(base64Data);
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = 'JunosignLogo';
        oAttachment.ContentType = contentType;
        insert oAttachment;
        return oAttachment.Id;
    }
        

    public class GetDetailsInner{
        @AuraEnabled 
        public List<JunoDoc__Junosign_Object_Setting__c> junodoc{get;set;}
        
        @AuraEnabled
        public List<returnEmailDetails> junoEmailList {get;set;}
    } 
    
    
    global class returnEmailDetails{
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
    
        
    
}
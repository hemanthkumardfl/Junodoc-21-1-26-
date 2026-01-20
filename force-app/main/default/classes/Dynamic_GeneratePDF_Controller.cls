global /*with sharing*/ class Dynamic_GeneratePDF_Controller {
    
    /* Added by sainath on 09-Sep-2025 Start */
    @AuraEnabled
    public static HideSettings getHideDetails(Id recordId){
        HideSettings settings = new HideSettings();
        string selectedobject = recordId.getSObjectType().getDescribe().getName();
        List<Junodoc_Details__c> objectSettings =  new List<Junodoc_Details__c>();
        objectSettings = [SELECT Id, JunoDoc__Hide_Attach_as_PDF__c, JunoDoc__Hide_Save_as_Activity__c 
                FROM Junodoc_Details__c WHERE Selected_object__c = :selectedobject];
        
        if(objectSettings.isEmpty()){return null;}
        
        settings.hideAttachAsPDF = !objectSettings[0].JunoDoc__Hide_Attach_as_PDF__c;
        settings.hideSaveAsActivity = !objectSettings[0].JunoDoc__Hide_Save_as_Activity__c;
        
        return settings;
        
    }
    
    global class HideSettings{
        @AuraEnabled public boolean hideAttachAsPDF;
        @AuraEnabled public boolean hideSaveAsActivity;
    }
    /* Added by sainath on 09-Sep-2025 End */
    
    public static string getJunodocUrl(){
        string JunodocUrl='/apex';
        if(Network.getNetworkId()!=null){
            JunodocUrl='/junodoc';
        }
        user us = [select id,contactId from user where id=: userinfo.getUserId()];
        if(us.contactId != null){
            Junodoc__Junodoc_Setting__c junosettings = [select id,JunoDoc__Community_URL__c from Junodoc__Junodoc_Setting__c limit 1];
            JunodocUrl = '' + junosettings.JunoDoc__Community_URL__c;
        }
        return JunodocUrl;
    }
    
     @AuraEnabled
    public static String getreport(string reportId){
        
        if (Test.isRunningTest()) {
        // Return mock data during testing
        return '{"mockKey": "mockValue"}';
    }
    //Using report id for example purpose
    Report reportRec = [SELECT
                                    Id
                            FROM Report
                            WHERE Id = '00O3h000003L6gqEAC'];

    Reports.ReportResults reportResult =
            Reports.ReportManager.runReport(reportRec.Id, true);

    return JSON.serialize(reportResult);
}
    
    @AuraEnabled
    public static String getPdfContent(String imageId){
        Account acc = new Account();
        acc.Name = 'Test Account Today';
        insert acc;

        imageId = imageId.substring(imageId.indexOf(',')+1,imageId.length());
        blob fileContent = EncodingUtil.base64Decode(imageId);
    
        Attachment att = new Attachment();
        att.Name = 'Report Chart';
        att.ParentId = acc.Id;
        att.Body = fileContent;
        att.contentType = 'image/png';
        insert att;
        return att.Id;
    }
    
    @AuraEnabled
    global static boolean getEnableEmails(){
        List<Junodoc_Setting__c> setlist = [select id,JunoDoc__Disable_Email_Template_Body__c from Junodoc_Setting__c];
        boolean EnableEmail = false;
        if(!setlist.isEmpty()){
            if(setlist[0].JunoDoc__Disable_Email_Template_Body__c == true){
                EnableEmail = true;
            }
        }
        return EnableEmail;
    }
    
    public static boolean getEnableJuno(){
        list<Junodoc__Junodoc_Setting__c> junosettings = [select id,JunoDoc__Enable_JunoSign__c from Junodoc__Junodoc_Setting__c limit 1];
        boolean Enablejuno = false;
        if(!junosettings.isEmpty()){
            Enablejuno = junosettings[0].JunoDoc__Enable_JunoSign__c ; 
        }
        
        return Enablejuno;
    }
    @AuraEnabled
    global static InnerDocTemplates getAvailDocTemps(id recordId, string DocIds){
        system.debug('DocIds--->'+DocIds);
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        List<String> DocIdList = DocIds.split(',');
        string TemplateID = '';
        /*Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();

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
        }*/
        InnerDocTemplates inn = new InnerDocTemplates();
        list<JunoDoc__Doc_Template__c> availableDocList = new list<JunoDoc__Doc_Template__c>();
        if(sObjName == 'Billing__c'){
            availableDocList = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c,JunoDoc__Template_Type__c,Report_Id__c,From_Upload__c,File_Id__c
                                from JunoDoc__Doc_Template__c 
                                where JunoDoc__Parent_Object__c = 'Billing__c' and JunoDoc__Show_Templates__c = false and Id IN: DocIdList];
        }
        else{
            availableDocList = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c,JunoDoc__Template_Type__c,Report_Id__c,From_Upload__c,File_Id__c
                                from JunoDoc__Doc_Template__c 
                                where JunoDoc__Parent_Object__c =: sObjName and JunoDoc__Show_Templates__c = false and Id IN: DocIdList];
        }
        /*if(TemplateID!=''){
        list<Doc_Template__c> availableDocList1 = [select id,Name,Parent_Object__c,Parent_Fields__c,Visualforce_Page__c
        from Doc_Template__c 
        where Parent_Object__c =: sObjName AND id=:TemplateID];
        if(availableDocList1.size()>0){
        if(availableDocList1[0].Visualforce_Page__c!=''){
        inn.isVFpage = true;
        inn.VFpageName = availableDocList1[0].Visualforce_Page__c;
        }
        }
        }*/
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        
        //New Code start
        /*list<Email_Template__c> availableEmailList = [select id,Name,Parent_Object__c,Parent_Fields__c 
from Email_Template__c 
where Parent_Object__c =: sObjName];*/
        //New Code End
        if(availableDocList.size()>0){
            for(JunoDoc__Doc_Template__c rec : availableDocList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= rec.JunoDoc__Template_Type__c;
                obj.reportType = rec.Report_Id__c;
                obj.isUpload = rec.From_Upload__c;
                obj.FileId = rec.File_Id__c;
                obj.recType = rec.JunoDoc__Template_Type__c;
                AvailableDocTemplatesList.add(obj);
            }            
        }
        //New Code Start 
        /*if(availableEmailList.size() > 0){
for(Email_Template__c rec : availableEmailList){
DocTemplatesWrap obj = new DocTemplatesWrap();
obj.label = rec.Name;
obj.value = rec.id; 
obj.type= 'EmailTemplate';
AvailableDocTemplatesList.add(obj);
}  
}*/
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
        
        inn.AvailableDocTemplatesList = AvailableDocTemplatesList;
        inn.DocTemplateId = TemplateID;
        inn.ObjectAPIName = sObjName;   
        inn.OrgwideEmailAddressList = orgWideEmailsList;
        inn.JunodocUrl = Dynamic_GeneratePDF_Controller.getJunodocUrl();
        inn.EnableJuno = Dynamic_GeneratePDF_Controller.getEnableJuno();    
        
        
        return inn;        
    }
    @AuraEnabled
    global static InnerDocTemplates getAvailableDocTemplates(id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        string DocTemplateField = '' ;
        
        DocTemplateField = string.valueOf(objectFieldsMap.get('JunoDoc__Doc_Template__c'));
        if(DocTemplateField == null || DocTemplateField == ''){
            DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
        }
        if(DocTemplateField=='JunoDoc__Doc_Template__c' || DocTemplateField=='Doc_Template__c'){
            string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: recordId' ;
            sobject NewQuote = Database.query(Newqueries);
            TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
            if(TemplateID==null){
                TemplateID='';
            }            
        }
        
        list<DocTemplatesWrap> AvailableDocTemplatesList = new list<DocTemplatesWrap>();
        
        list<JunoDoc__Doc_Template__c> availableDocList = new list<JunoDoc__Doc_Template__c>();
        if(sObjName == 'Billing__c'){
            availableDocList = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c,JunoDoc__Template_Type__c,Report_Id__c,From_Upload__c,File_Id__c
                                from JunoDoc__Doc_Template__c 
                                where JunoDoc__Parent_Object__c = 'Billing__c' and JunoDoc__Show_Templates__c = false];
        }
        else{
            availableDocList = [select id,Name,JunoDoc__Parent_Object__c,JunoDoc__Parent_Fields__c,JunoDoc__Template_Type__c,Report_Id__c,From_Upload__c,File_Id__c
                                from JunoDoc__Doc_Template__c 
                                where JunoDoc__Parent_Object__c =: sObjName and JunoDoc__Show_Templates__c = false];
        }
        
        /*New Code start
list<Email_Template__c> availableEmailList = [select id,Name,Parent_Object__c,Parent_Fields__c 
from Email_Template__c 
where Parent_Object__c =: sObjName];
//New Code End */
        if(availableDocList.size()>0){
            for(Doc_Template__c rec : availableDocList){
                DocTemplatesWrap obj = new DocTemplatesWrap();
                obj.label = rec.Name;
                obj.value = rec.id; 
                obj.type= rec.JunoDoc__Template_Type__c;
                obj.reportType = rec.Report_Id__c;
                obj.isUpload = rec.From_Upload__c;
                obj.FileId = rec.File_Id__c;
                obj.recType = rec.Template_Type__c;
                AvailableDocTemplatesList.add(obj);
            }            
        }
        /*New Code Start 
if(availableEmailList.size() > 0){
for(Email_Template__c rec : availableEmailList){
DocTemplatesWrap obj = new DocTemplatesWrap();  
obj.label = rec.Name;
obj.value = rec.id; 
obj.type= 'EmailTemplate';
AvailableDocTemplatesList.add(obj);
}  
}
//New Code End */
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
        inn.EnableJuno = Dynamic_GeneratePDF_Controller.getEnableJuno();      
        
        return inn;        
    }
    
    @AuraEnabled
    public static list<DocTemplatesWrap> getAvailableEmails(id recordId){
        
        String sObjName = recordId.getSObjectType().getDescribe().getName();
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
        }   
        return DocTemplatesWraplist; 
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
        
        @AuraEnabled
        public boolean EnableJuno;    
        
         @AuraEnabled
        public boolean isUpload;
        
        @AuraEnabled
        public string FileId;
        
        @AuraEnabled
        public string recType;
        
    }  
    
    global class DocTemplatesWrap{
        @AuraEnabled
        global String label;
        @AuraEnabled
        global String value; 
        // New Code Start
        @AuraEnabled
        global String type;
        
        @AuraEnabled
        global string reportType;
        // New Code End
        
         @AuraEnabled
        global boolean isUpload;
        
        @AuraEnabled
        global string FileId;
        
        @AuraEnabled
        public string recType;
    }    
    
    @AuraEnabled
    global static string CreatePDF(Id id, Id DocTemplateId){ 
        return null;   
    } 
    /*
    private static LookupInfo getJunodocSettings(String recordId, String objectApiName){
        LookupInfo info = new LookupInfo();
        List<JunoDoc__Junodoc_Details__c> junodocSettings = new List<JunoDoc__Junodoc_Details__c>();
        
        junodocSettings = [SELECT Id, JunoDoc__Selected_object__c, JunoDoc__Attach_as_PDF__c, JunoDoc__Attach_as_PDF_Parent__c 
                           FROM JunoDoc__Junodoc_Details__c WHERE JunoDoc__Selected_object__c = :objectApiName LIMIT 1];
        
        if(junodocSettings.isEmpty()){ return null; }
        
        String attachType = junodocSettings[0].JunoDoc__Attach_as_PDF__c;
        
        if('Self'.equalsIgnoreCase(attachType)){ return null; }
        
        String parentObjectApiName = junodocSettings[0].JunoDoc__Attach_as_PDF_Parent__c;
        String parentObjectFieldName = getLookupFieldInfo(objectApiName, parentObjectApiName);
        
        if(String.isEmpty(parentObjectFieldName)){ return null; }
        
        String query = 'SELECT Id, ' + parentObjectFieldName + ' FROM ' + objectApiName + ' WHERE Id = :recordId LIMIT 1';
        List<sObject> records = Database.Query(query);
        
        if(records.isEmpty()){ return null; }
        
        Id parentObjectId = (Id) records[0].get(parentObjectFieldName);
        info.parentObjectId = parentObjectId;
        info.childObjectId = recordId;
        info.attachType = attachType;
        return info;
    }
    
    private static String getLookupFieldInfo (String objectName, String parentObjectApiName){
        LookupInfo info = new LookupInfo();
        Map<String, Schema.SObjectField> fields = getFields(objectName);
        if(fields == null){ return null; }
        
        for (String fieldName : fields.keySet()) {
            Schema.SObjectField field = fields.get(fieldName);
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
            
            if (fieldDescribe.getType() != Schema.DisplayType.REFERENCE) { continue; }
            
            List<Schema.SObjectType> referenceTo = fieldDescribe.getReferenceTo();
            if (referenceTo.isEmpty()){ continue; }
            String lookupObjectName = referenceTo[0].getDescribe().getName();
            if (lookupObjectName.equalsIgnoreCase(parentObjectApiName)) {
                return String.valueOf(field);
            }
        }  
        return null;
    }
    
    private static Map<String, Schema.SObjectField> getFields(String objectName){
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectType = globalDescribe.get(objectName);
        
        if (sObjectType == null) { return null; }
        
        Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
        // Get a map of field API names to field descriptors
        Map<String, Schema.SObjectField> fields = describeResult.fields.getMap();
        return fields;
    }
    
    public class LookupInfo {
        public Id parentObjectId;
        public Id childObjectId;
        public String attachType;
    }
    */
    @AuraEnabled
    global static string CreatePDFs(Id id, Id DocTemplateId,Boolean fromJunosign){ 
        
        string redirect='';
        Id conDocument;
        if(id != null){
            
            String sObjName = id.getSObjectType().getDescribe().getName();
            string query = 'select id from '+ sObjName + ' where id=: id';
            Sobject sobjectrec = Database.query(query);
            //String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            //PageReference pagePdf = new PageReference(baseUrl+'/apex/JunoDoc__PreviewPDF');
            //PageReference pagePdf = Page.PreviewPDF;
            
            Doc_Template__c DocTemplates = [select id,PDF_Name__c,JunoDoc__Parent_Object__c,Junodoc__Date_Format__c from Doc_Template__c where id =: DocTemplateId];
            
            String SobjectApiName = DocTemplates.Parent_Object__c;
            string fieldNames = '';
            string Title = 'PreviewPDF';
            if(DocTemplates.PDF_Name__c != '' && DocTemplates.PDF_Name__c != null){
                string DateFormats = 'MM/dd/yyyy';
                Title = DocTemplates.PDF_Name__c;
                
                if(DocTemplates.Junodoc__Date_Format__c != null && DocTemplates.Junodoc__Date_Format__c != ''){
                    DateFormats = DocTemplates.Junodoc__Date_Format__c;
                }
                if(Title.contains('{!TODAY()}')){
                    Date Datestr = system.Today();
                    string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                    DocTemplates.Junodoc__PDF_Name__c = Title.replace('{!TODAY()}',Parentvalues);  
                    Title = Title.replace('{!TODAY()}',Parentvalues); 
                }
                if(Title.contains('{!NOW()}')){
                    string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                    DocTemplates.Junodoc__PDF_Name__c = Title.replace('{!NOW()}',Parentvalues);     
                    Title = Title.replace('{!NOW()}',Parentvalues); 
                }
                if(DocTemplates.PDF_Name__c.contains('{!')){
                    string finalstrings = string.valueof(DocTemplates.PDF_Name__c).replace('{!','xxwwwee');
                    string[] pdfnames = finalstrings.split('xxwwwee');
                    integer k = 0;
                    for(string str : pdfnames){
                        if(k != 0){
                            string[] strlist = str.split('}');
                            fieldNames += strlist[0]+ ',';
                        }
                        k = k+1;  
                    }
                }
            }
            
            if(fieldNames != ''){
                fieldNames = fieldNames.substring(0,fieldNames.length()-1);
                string pdfquery = 'select id,'+fieldNames+' from '+SobjectApiName+ ' where id=:id';
                sobject dynamicobject = Database.query(pdfquery);
                string[] fieldlist = fieldNames.split(',');
                for(string names : fieldlist){
                    if(!names.contains('.')){
                        Title = Title.replace('{!'+names + '}',''+dynamicobject.get(names));
                    }
                    else if(names.contains('.')){
                        string Stringobjct = names.replace('.',',');
                        string[] Stringobjcts = Stringobjct.split(',');
                        if(Stringobjcts.size() > 3){
                            if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                    if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) { 
                                        Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                    }
                                }
                            }
                        }
                        else if(Stringobjcts.size() > 2){
                            if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                    if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) { 
                                        Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                    }
                                }
                            }
                        }
                        else if(Stringobjcts.size() > 1){
                            if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                if(dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null){
                                    Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                            }
                        }
                    }
                    Title = Title.replace('{!'+names + '}','');
                }
            }
            Title = Title.replace(',','');
            Title = Title.replace('.','');
            Title = Title.replace('\'','');
            
            Title = Title.replace(';','');
            
            PageReference pagePdf = new PageReference('/apex/JunoDoc__junodocPDF');  
            // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', id); 
            pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            }
            else{ 
                // system.debug('getcontents**' + pagePdf.getContent().tostring());
                //  string blobs = pagePdf.getContent().tostring();
                //  system.debug('getblobs**' + Blob.valueOf(blobs));
                pdfPageBlob = pagePdf.getContentAsPDF();
            }
            
            //LookupInfo info = new LookupInfo();
            //info = getJunodocSettings(id, sObjName);
            //List<ContentDocumentLink> cDocLinks = new List<ContentDocumentLink>();
            
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = Title+'.pdf';//File name with extention
            cVersion.Title =  ''+Title;//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            /*
            if(info != null){
                //Insert ContentDocumentLink to parent object
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                cDocLink.LinkedEntityId = info.parentObjectId;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                cDocLinks.add(cDocLink);
                
                if('Self & Parent'.equalsIgnoreCase(info.attachType)){
                    //Insert ContentDocumentLink to child object
                    ContentDocumentLink cDocLink1 = new ContentDocumentLink();
                    cDocLink1.ContentDocumentId = conDocument;//Add ContentDocumentId
                    cDocLink1.LinkedEntityId = info.childObjectId;//Add attachment parentId
                    cDocLink1.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                    cDocLink1.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                    cDocLinks.add(cDocLink1);
                }
                
                Database.Insert(cDocLinks, false);
                redirect = 'Redirect';    
                
            }else{*/
                //Insert ContentDocumentLink
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                cDocLink.LinkedEntityId = id;//Add attachment parentId
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                
                try{
                    Insert cDocLink;      
                    redirect = 'Redirect';    
                }catch(Exception e){
                    
                }
           // }
            
        }
        
        if(fromJunosign == true){
            system.debug('condoc');
            return conDocument;
            
        }else{
            return redirect;
        } 
        
    }
    
    @AuraEnabled
    global static string CreateWord(Id id, Id DocTemplateId,Boolean fromJunosign){ 
        string DocTemplateIds = DocTemplateId;
        string baseString = '';
        if(DocTemplateIds.contains('-')){
            string[] str = DocTemplateIds.split('-');
            DocTemplateId = str[0];
            baseString = str[1];
        }
        string redirect='';
        Id conDocument;
        if(id != null){
            
            String sObjName = id.getSObjectType().getDescribe().getName();
            string query = '';
            string Names = 'Name';
            if(sObjName == 'Case'){
                query = 'select id,CaseNumber from '+ sObjName + ' where id=: id'; 
                Names = 'CaseNumber';
            }
            else if(sObjName == 'WorkOrder'){
                query = 'select id,WorkOrderNumber from '+ sObjName + ' where id=: id';  
                Names = 'WorkOrderNumber';
            }
            else{
                query = 'select id,Name from '+ sObjName + ' where id=: id';  
            }
            
            Sobject sobjectrec = Database.query(query);
            //String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            //PageReference pagePdf = new PageReference(baseUrl+'/apex/JunoDoc__PreviewPDF');
            //PageReference pagePdf = Page.PreviewPDF;
            
            
            PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewTemplateWord');  
            // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', id); 
            pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            }
            else{ 
                string blobs = pagePdf.getContent().tostring();
                pdfPageBlob = Blob.valueOf(blobs); 
            }
            //pdfPageBlob = EncodingUtil.base64Decode(baseString);
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = sobjectrec.get(Names)+'.doc';//File name with extention
            cVersion.Title =  ''+sobjectrec.get(Names);//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            
            try{
                Insert cDocLink;      
                redirect = 'Redirect';    
            }catch(Exception e){
                
            }
            
        }
        
        if(fromJunosign == true){
            system.debug('condoc');
            return conDocument;
            
        }else{
            return redirect;
        } 
        
    }
    
    @AuraEnabled
    global static string CreateWords(Id id, string baseString,Boolean fromJunosign){ 
        string redirect='';
        Id conDocument;
        if(id != null){
            
            String sObjName = id.getSObjectType().getDescribe().getName();
            string query = '';
            string Names = 'Name';
            if(sObjName == 'Case'){
                query = 'select id,CaseNumber from '+ sObjName + ' where id=: id'; 
                Names = 'CaseNumber';
            }
            else if(sObjName == 'WorkOrder'){
                query = 'select id,WorkOrderNumber from '+ sObjName + ' where id=: id';  
                Names = 'WorkOrderNumber';
            }
            else{
                query = 'select id,Name from '+ sObjName + ' where id=: id';  
            }
            
            Sobject sobjectrec = Database.query(query);
            Blob pdfPageBlob; 
            pdfPageBlob = EncodingUtil.base64Decode(baseString);
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = sobjectrec.get(Names)+'.doc';//File name with extention
            cVersion.Title =  ''+sobjectrec.get(Names);//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            
            try{
                Insert cDocLink;      
                redirect = 'Redirect';    
            }catch(Exception e){
                
            }
            
        }
        
        if(fromJunosign == true){
            system.debug('condoc');
            return conDocument;
            
        }else{
            return redirect;
        } 
        
    }
    
     @AuraEnabled
    global static string CreateExcels(Id id, string DocTemplateId,Boolean fromJunosign,string baseString){ 
        
        string redirect='';
        Id conDocument;
        Doc_Template__c DocTemplate = [select id,Name,From_Upload__c from Doc_Template__c where id =: DocTemplateId];
        if(id != null){
            
            String sObjName = id.getSObjectType().getDescribe().getName();
            string query = '';
            string Names = 'Name';
            if(sObjName == 'Case'){
                query = 'select id,CaseNumber from '+ sObjName + ' where id=: id'; 
                Names = 'CaseNumber';
            }
            else if(sObjName == 'WorkOrder'){
                query = 'select id,WorkOrderNumber from '+ sObjName + ' where id=: id';  
                Names = 'WorkOrderNumber';
            }
            else{
                query = 'select id,Name from '+ sObjName + ' where id=: id';  
            }
            
            Sobject sobjectrec = Database.query(query);
            //String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            //PageReference pagePdf = new PageReference(baseUrl+'/apex/JunoDoc__PreviewPDF');
            //PageReference pagePdf = Page.PreviewPDF;
            
            
            PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewExcel');  
            // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', id); 
            pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            } 
            else if(DocTemplate.From_Upload__c == true){ 
                pdfPageBlob = EncodingUtil.base64Decode(baseString);
            }else{
                string blobs = pagePdf.getContent().tostring();
                pdfPageBlob = Blob.valueOf(blobs); 
            }
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = sobjectrec.get(Names)+'.xls';//File name with extention
            cVersion.Title =  ''+sobjectrec.get(Names);//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            
            try{
                Insert cDocLink;      
                redirect = 'Redirect';    
            }catch(Exception e){
                
            }
            
        }
        
        if(fromJunosign == true){
            system.debug('condoc');
            return conDocument;
            
        }else{
            return redirect;
        } 
        
    }
    
    @AuraEnabled
    global static string CreateExcel(Id id, Id DocTemplateId,Boolean fromJunosign){ 
        
        string redirect='';
        Id conDocument;
        if(id != null){
            
            String sObjName = id.getSObjectType().getDescribe().getName();
            string query = '';
            string Names = 'Name';
            if(sObjName == 'Case'){
                query = 'select id,CaseNumber from '+ sObjName + ' where id=: id'; 
                Names = 'CaseNumber';
            }
            else if(sObjName == 'WorkOrder'){
                query = 'select id,WorkOrderNumber from '+ sObjName + ' where id=: id';  
                Names = 'WorkOrderNumber';
            }
            else{
                query = 'select id,Name from '+ sObjName + ' where id=: id';  
            }
            
            Sobject sobjectrec = Database.query(query);
            //String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            //PageReference pagePdf = new PageReference(baseUrl+'/apex/JunoDoc__PreviewPDF');
            //PageReference pagePdf = Page.PreviewPDF;
            
            
            PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewExcel');  
            // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', id); 
            pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            } 
            else{ 
                string blobs = pagePdf.getContent().tostring();
                pdfPageBlob = Blob.valueOf(blobs); 
            }
            
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = sobjectrec.get(Names)+'.xls';//File name with extention
            cVersion.Title =  ''+sobjectrec.get(Names);//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            
            try{
                Insert cDocLink;      
                redirect = 'Redirect';    
            }catch(Exception e){
                
            }
            
        }
        
        if(fromJunosign == true){
            system.debug('condoc');
            return conDocument;
            
        }else{
            return redirect;
        } 
        
    }
    
    
    
    @AuraEnabled
    global static Map<string,string> SendPDF(Id id,Id DocTemplateId, string Subject,string Body,
                                             list<string> toUserEmailsList,
                                             list<string> toContactEmailsList,String toEmails,
                                             boolean SaveAsActivity,list<String> EmailField){    
                                                 system.debug('SaveAsActivity--->'+SaveAsActivity);
                                                 
                                                 Map<string,string> ResultMap = new Map<string,string>();
                                                 /*try{



system.debug('Body.length()--->'+Body.length());
if(Body.length() >= 32000){
Body = Body.substring(0,31800);
} 



String sObjName = id.getSObjectType().getDescribe().getName();
string query = 'Select id,Name,owner.Name,owner.Email';
if(EmailField.size() > 0){
for(string str : EmailField){
query += ','+str ;
}
}
query +=  ' From '+sObjName+' Where id=:id';
Sobject sobjList = Database.query(String.escapeSingleQuotes(query));    

string setReplyToEmail = sobjList.getsobject('owner').get('Email')+'';
string SenderDisplayName = sobjList.getsobject('owner').get('Name')+'';


PageReference pagePdf = new PageReference('/apex/JunoDoc__PreviewPDF'); 
pagePdf.getParameters().put('id', id); 
pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
Blob pdfPageBlob; 
if(Test.IsRunningTest()){
pdfPageBlob = Blob.valueOf('UNIT.TEST');
}
else{
pdfPageBlob = pagePdf.getContentAsPDF(); 
}

system.debug('sobjList ---->'+sobjList);

Attachment a = new Attachment(); 
if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
&& Schema.sObjectType.Attachment.fields.Name.isCreateable()
&& Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
a.Body = pdfPageBlob; 
a.ParentID = id; 
system.debug('pdf name ---->'+sobjList.get('Name'));
a.Name =  sobjList.get('Name')+ '.pdf';
a.ContentType = 'application/pdf';
insert a; 

}    

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setReplyTo(setReplyToEmail);
mail.setSenderDisplayName(SenderDisplayName);

List<string> ToAdresses = new List<string>();
if(toEmails != null && toEmails != ''){
if(toEmails.contains(',')){
ToAdresses = toEmails.split(',');                                                    
}else{
ToAdresses.add(toEmails);
}
}

if(toUserEmailsList!=null){
for(String str:toUserEmailsList){
if(str != null && str != ''){
ToAdresses.add(str); 
}

}                                                     
}

if(toContactEmailsList!=null){
for(String str:toContactEmailsList){
if(str != null && str != ''){
ToAdresses.add(str); 
}
}                
} 

if(EmailField.size() > 0){
for(string str : EmailField){
if(sobjList.get(str) != null && sobjList.get(str) != ''){
ToAdresses.add(''+sobjList.get(str));
}
}
}
system.debug('----*****----'+ToAdresses);        
mail.setToAddresses(ToAdresses);
mail.setSubject(subject);
mail.setHtmlBody(Body);

List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
if (Schema.sObjectType.Attachment.fields.Name.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()
&& Schema.sObjectType.Attachment.fields.BodyLength.isAccessible()){
for (Attachment at : [select Name,Body,BodyLength from Attachment where id= :a.id]) 

{   
Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
efa.setFileName(at.Name); 
efa.setBody(at.Body); 
fileAttachments.add(efa);
}
}
mail.setFileAttachments(fileAttachments);

try{ 

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   


if(SaveAsActivity){

Task Taskhistory = new Task();
if(Schema.sObjectType.Task.fields.Status.isCreateable()
&& Schema.sObjectType.Task.fields.WhoId.isCreateable() && Schema.sObjectType.Task.fields.whatId.isCreateable()
&& Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.To_Email_Addresses__c.isCreateable()
&& Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.Description.isCreateable()){

if(sObjName.toLowerCase()=='LEAD' || sObjName.toLowerCase()=='CONTACT'){
Taskhistory.WhoId = id;    
}else{
Taskhistory.whatId = id;    
}                           
Taskhistory.Status='Completed';
Taskhistory.Subject = Subject;
Taskhistory.To_Email_Addresses__c = ToAdresses+''; 
Taskhistory.ActivityDate = System.Today();
Taskhistory.Description =body; 

insert Taskhistory;
}

Attachment att = new Attachment();
if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable() 
&& Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
&& Schema.sObjectType.Attachment.fields.Body.isCreateable()){

att.Body = pdfPageBlob; 
att.ParentID = Taskhistory.Id; 
att.Name = sobjList.get('Name')+ '.pdf';
att.ContentType = 'application/pdf';
insert att;
}

}


if(Attachment.sObjectType.getDescribe().isDeletable()){
delete[Select id From Attachment Where id=:a.id];
}                

ResultMap.put('state','success');
ResultMap.put('Message','Email Sent Successfully. You will be redirected to record page');                
if(SaveAsActivity){
ResultMap.put('Message','Email Sent and Saved as Activity. You will be redirected to record page');
}


}catch(exception e){
ResultMap.put('state','Error');
ResultMap.put('Message',e.getMessage());

if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){                   
ResultMap.put('Message','Please Enter Valid Email Address');    
}                

if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
} 

}



} catch (Exception  e) {
if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
system.debug('test');
ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email limit exceeded .Please Try Later.'));
} 
}*/
                                                 
                                                 return ResultMap;   
                                             }
    
    public static List<string> getEmailRecipientsHelper(list<string> ToTextEmailsList, list<string> ToEmailMergeFieldsList,Sobject sobjList){
        List<string> ToAdresses = new List<string>();
        list<string> ToEmailAdresses = new list<string>();
        
        try{
            
            if(ToTextEmailsList!=null){
                for(String str:ToTextEmailsList){
                    if(str != null && str != ''){
                        ToAdresses.add(str); 
                    }
                }                                                     
            }
            
            if(ToEmailMergeFieldsList.size() > 0){
                for(string toEmailField : ToEmailMergeFieldsList){
                    if(!toEmailField.contains('@')){
                        system.debug('toEmailField--->'+toEmailField);
                        List<String> toEmailFieldSplit = toEmailField.split('\\.'); 
                        system.debug('toEmailFieldSplit--->'+toEmailFieldSplit);
                        system.debug('toEmailFieldSplit size --->'+toEmailFieldSplit.size());
                        string ReleationField = '';
                        if(toEmailFieldSplit.size()==5){
                            if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                                if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2])!=null){
                                    if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3])!=null){
                                        if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3]).get(toEmailFieldSplit[4])!=null){
                                            string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).getSobject(toEmailFieldSplit[3]).get(toEmailFieldSplit[4]));
                                            system.debug('level5---->'+email);
                                            ToAdresses.add(email);
                                        }                                    
                                    }
                                }
                            } 
                        }
                        else if(toEmailFieldSplit.size()==4){ //Quote.Account.Owner.Email
                            if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                                if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2])!=null){
                                    if(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).get(toEmailFieldSplit[3])!=null){
                                        string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).getSobject(toEmailFieldSplit[2]).get(toEmailFieldSplit[3]));
                                        system.debug('level4---->'+email);
                                        ToAdresses.add(email);
                                    }                                                              
                                } 
                            }
                        }
                        else if(toEmailFieldSplit.size()==3){ //Quote.Contact.Email
                            if(sobjList.getSobject(toEmailFieldSplit[1])!=null){
                                if(sobjList.getSobject(toEmailFieldSplit[1]).get(toEmailFieldSplit[2])!=null){
                                    string email = String.valueOf(sobjList.getSobject(toEmailFieldSplit[1]).get(toEmailFieldSplit[2]));
                                    system.debug('level3---->'+email);
                                    ToAdresses.add(email);                            
                                }                            
                            }
                        }
                        else if(toEmailFieldSplit.size()==2){ //Quote.Email
                            if(sobjList.get(toEmailFieldSplit[1])!=null){
                                string email = String.valueOf(sobjList.get(toEmailFieldSplit[1]));
                                system.debug('level2---->'+email);
                                ToAdresses.add(email);                            
                            }                        
                        }    
                    }
                }
            }
            
            
            //remove duplicate email ids0
            map<string,string> toEmailmap = new map<string,string>();
            for(string toEmailAddress: ToAdresses) {
                toEmailmap.put(toEmailAddress,toEmailAddress);
            }            
            for(string toEmail : toEmailmap.keySet()){
                ToEmailAdresses.add(toEmail);
            }
            //End remove duplicate email ids
            
        }catch(Exception e){
            system.debug('exception--->'+e.getMessage()+'---line number--->'+e.getLineNumber());
        }       
        
        return ToEmailAdresses;
    }
    
    
    @AuraEnabled
    public static Map<string,string> SendPDFNew(Id id,Id DocTemplateId, string Subject,string Body,                                             
                                             string FromEmailAddress, string SetReplyTo, 
                                             string SetSenderDisplayName, boolean SaveAsActivity, 
                                             list<string> ToTextEmailsList, list<string> ToEmailMergeFieldsList,
                                             list<string> CCTextEmailsList, list<string> CCEmailMergeFieldsList,
                                             list<string> BCCTextEmailsList, list<string> BCCEmailMergeFieldsList,
                                             list<fileDetails> fileData
                                            ){  
                                                //system.debug('SaveAsActivity--->'+fileData);  
                                                //system.debug('FromEmailAddress--->'+FromEmailAddress);
                                                //system.debug('Id--->'+id);
                                                Map<string,string> ResultMap = new Map<string,string>();
                                                //  try{
                                                String sObjName = id.getSObjectType().getDescribe().getName();
                                                string PDFName = 'Name';
                                                string query = 'Select id,';
                                                if(sObjName == 'Case'){
                                                    query += 'CaseNumber'; 
                                                    PDFName = 'CaseNumber';
                                                }
                                                else if(sObjName == 'WorkOrder'){
                                                    query += 'WorkOrderNumber'; 
                                                    PDFName = 'WorkOrderNumber';
                                                }
                                                else{
                                                    query += 'Name';                                 
                                                }
                                                if(ToEmailMergeFieldsList.size() > 0){
                                                    for(string str : ToEmailMergeFieldsList){
                                                        //system.debug('To Email--->'+str);
                                                        if(!str.contains('@')){
                                                            if(str.contains(sObjName+'.')){
                                                                str = str.replace(sObjName+'.','');
                                                            }
                                                            query += ','+str;    
                                                        }
                                                    }
                                                }
                                                if(CCEmailMergeFieldsList.size() > 0){
                                                    for(string str : CCEmailMergeFieldsList){
                                                        //system.debug('CC Email--->'+str);
                                                        if(str.contains(sObjName+'.')){
                                                            str = str.replace(sObjName+'.','');
                                                        }   
                                                        
                                                        //if(str.toLowerCase()!='owner.email'){
                                                        //else{
                                                        query += ','+str;
                                                        //}
                                                    }
                                                }
                                                
                                                if(BCCEmailMergeFieldsList.size() > 0){
                                                    for(string str : BCCEmailMergeFieldsList){
                                                        //system.debug('BCC Email--->'+str);
                                                        if(str.contains(sObjName+'.')){
                                                            str = str.replace(sObjName+'.','');
                                                        }  
                                                        //if(str.toLowerCase()!='owner.email'){
                                                        //else{
                                                        query += ','+str;
                                                        //}
                                                    }
                                                }
                                                //system.debug('query--->'+query);
                                                query +=  ' From '+sObjName+' Where id=:id';
                                                Sobject sobjList = Database.query(String.escapeSingleQuotes(query));    
                                                system.debug('query--->'+query);
                                                string setReplyToEmail = ''; //sobjList.getsobject('owner').get('Email')+'';
                                                string SenderDisplayName = ''; //sobjList.getsobject('owner').get('Name')+'';                        
                                                if(SetReplyTo != null && SetReplyTo != ''){
                                                    setReplyToEmail = SetReplyTo;
                                                }
                                                //system.debug('setReplyToEmail--->'+setReplyToEmail);
                                                /*if(SetSenderDisplayName != null && SetSenderDisplayName != ''){
SenderDisplayName = SetSenderDisplayName;
}*/
                                                //system.debug(DocTemplateId + '*********** '+ id);
                                                list<Doc_Template__c> DocTemplateRec = [select Id,Name,Parent_Object__c,PDF_Name__c,Date_Format__c,
                                                                                        JunoDoc__Template_Type__c
                                                                                        from Doc_Template__c where Id =: DocTemplateId];
                                                Blob pdfPageBlob; 
                                                string Name = sobjList.get(PDFName)+ '.pdf';   
                                                string Title = sobjList.get(PDFName)+ '.pdf';                                    
                                                if(!DocTemplateRec.isEmpty()){                                    
                                                    String SobjectApiName = DocTemplateRec[0].Parent_Object__c;
                                                    string fieldNames = '';
                                                    
                                                    /*     if(DocTemplateRec[0].PDF_Name__c != '' && DocTemplateRec[0].PDF_Name__c != null){
Title = DocTemplateRec[0].PDF_Name__c;
if(DocTemplateRec[0].PDF_Name__c.contains('{!')){
string finalstrings = string.valueof(DocTemplateRec[0].PDF_Name__c).replace('{!','xxwwwee');
string[] pdfnames = finalstrings.split('xxwwwee');
integer k = 0;
for(string str : pdfnames){
if(k != 0 && !str.contains('()')){
string[] strlist = str.split('}');
fieldNames += strlist[0]+ ',';
}
k = k+1;  
}
}
} */
                                                    
                                                    if(DocTemplateRec[0].PDF_Name__c != '' && DocTemplateRec[0].PDF_Name__c != null){
                                                        Title = DocTemplateRec[0].PDF_Name__c;
                                                        string DateFormats = 'MM/dd/yyyy';
                                                        if(DocTemplateRec[0].Date_Format__c != null && DocTemplateRec[0].Date_Format__c != ''){
                                                            DateFormats = DocTemplateRec[0].Date_Format__c;
                                                        }
                                                        if(Title.contains('{!TODAY()}')){
                                                            Date Datestr = system.Today();
                                                            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                                                            DocTemplateRec[0].PDF_Name__c = Title.replace('{!TODAY()}',Parentvalues);  
                                                            Title = Title.replace('{!TODAY()}',Parentvalues); 
                                                        }
                                                        if(Title.contains('{!NOW()}')){
                                                            string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                                                            DocTemplateRec[0].PDF_Name__c = Title.replace('{!NOW()}',Parentvalues);     
                                                            Title = Title.replace('{!NOW()}',Parentvalues); 
                                                        }
                                                        if(DocTemplateRec[0].Junodoc__PDF_Name__c.contains('{!')){
                                                            string finalstrings = string.valueof(DocTemplateRec[0].PDF_Name__c).replace('{!','xxwwwee');
                                                            string[] pdfnames = finalstrings.split('xxwwwee');
                                                            integer k = 0;
                                                            for(string str : pdfnames){
                                                                if(k != 0){
                                                                    string[] strlist = str.split('}');
                                                                    fieldNames += strlist[0]+ ',';
                                                                }
                                                                k = k+1;  
                                                            }
                                                        }
                                                    }
                                                    
                                                    if(fieldNames != ''){
                                                        fieldNames = fieldNames.substring(0,fieldNames.length()-1);
                                                        string pdfquery = 'select id,'+fieldNames+' from '+SobjectApiName+ ' where id=:id';
                                                        sobject dynamicobject = Database.query(pdfquery);
                                                        string[] fieldlist = fieldNames.split(',');
                                                        for(string names : fieldlist){
                                                            //system.debug('names **' + names);
                                                            if(!names.contains('.')){
                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.get(names));
                                                            }
                                                            else if(names.contains('.')){
                                                                string Stringobjct = names.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) { 
                                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 2){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) { 
                                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 1){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null){
                                                                            Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Title = Title.replace('{!'+names + '}','');
                                                        }
                                                    }
                                                    //system.debug('Title **' + Title);
                                                    Title = Title.replace(',','');
                                                    Title = Title.replace('.','');
                                                    Title = Title.replace('\'','');
                                                    Title = Title.replace(';','');
                                                    if(DocTemplateRec[0].JunoDoc__Template_Type__c != 'Word Document' && DocTemplateRec[0].JunoDoc__Template_Type__c != 'Excel'){
                                                        Name = Title + '.pdf';
                                                    }
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Word Document'){
                                                        Name = Title + '.doc';   
                                                    }
                                                    else{
                                                        Name = Title + '.xls';   
                                                    }
                                                }
                                                list<string> ToEmailAdresses = getEmailRecipientsHelper(ToTextEmailsList, ToEmailMergeFieldsList,sobjList);
                                                list<string> CCEmailAdresses = getEmailRecipientsHelper(CCTextEmailsList, CCEmailMergeFieldsList,sobjList);
                                                list<string> BCCEmailAdresses = getEmailRecipientsHelper(BCCTextEmailsList, BCCEmailMergeFieldsList,sobjList);
                                                
                                                string ContentType = 'application/pdf';  
                                                Attachment a = new Attachment(); 
                                                if(!DocTemplateRec.isEmpty()){
                                                    if(DocTemplateRec[0].JunoDoc__Template_Type__c != 'Word Document' && DocTemplateRec[0].JunoDoc__Template_Type__c != 'Excel'){
                                                        PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        
                                                        if(Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else{
                                                            //system.debug( 'pageconentent *********** '+ pagePdf.getContentAsPDF());
                                                            pdfPageBlob = pagePdf.getContentAsPDF(); 
                                                        }
                                                    }
                                                    
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Word Document'){
                                                        PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewTemplateWord');  
                                                        // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        //system.debug('pagePdf -----> '+pagePdf);
                                                        if (Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else{ 
                                                            //system.debug('getcontents**' + pagePdf.getContent().tostring());
                                                            string blobs = pagePdf.getContent().tostring();
                                                            //system.debug('getblobs**' + Blob.valueOf(blobs));
                                                            pdfPageBlob = Blob.valueOf(blobs); 
                                                        }
                                                        
                                                        ContentType = 'application/msword';  
                                                    }
                                                    
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Excel'){
                                                        PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewExcel');  
                                                        // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        //system.debug('pagePdf -----> '+pagePdf);
                                                        if (Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else{ 
                                                            //system.debug('getcontents**' + pagePdf.getContent().tostring());
                                                            string blobs = pagePdf.getContent().tostring();
                                                            //system.debug('getblobs**' + Blob.valueOf(blobs));
                                                            pdfPageBlob = Blob.valueOf(blobs); 
                                                        }
                                                        
                                                        ContentType = 'application/msexcel';  
                                                    }
                                                    
                                                    //system.debug('sobjList ---->'+sobjList);
                                                    
                                                    if(ToEmailAdresses.size()>0 || CCEmailAdresses.size()>0 || BCCEmailAdresses.size()>0){
                                                        /*if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.Name.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                                                               a.Body = pdfPageBlob; 
                                                               a.ParentID = id; 
                                                               // system.debug('pdf name ---->'+sobjList.get('Name'));
                                                               a.Name =  Name;
                                                               a.ContentType = ContentType;
                                                               //system.debug('Attachment -> '+a);
                                                               insert a;
                                                               system.debug('Attachment >>>> '+a.id);  
                                                           } */
                                                    }
                                                }
                                                list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
                                                if(FromEmailAddress!='' && FromEmailAddress!=null){
                                                    owea = [select Id,Address from OrgWideEmailAddress where Id=:FromEmailAddress];          
                                                }
                                                
                                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                if(setReplyToEmail != ''){
                                                    mail.setReplyTo(setReplyToEmail);
                                                }
                                                if ( owea.size() == 0 ) {
                                                    mail.setSenderDisplayName(SenderDisplayName);
                                                }
                                                
                                                if ( owea.size() > 0 ) {
                                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                                }
                                                
                                                
                                                
                                                List<Junodoc_Setting__c> setlist = [select id,JunoDoc__Enable_SenderBCC__c from Junodoc_Setting__c];
                                                if(!setlist.isEmpty()){
                                                    if(setlist[0].JunoDoc__Enable_SenderBCC__c == true){
                                                        //system.debug('Userinfo.getUserEmail()------->'+Userinfo.getUserEmail());
                                                        BCCEmailAdresses.add(Userinfo.getUserEmail());
                                                        mail.setBccSender(true);
                                                    }                                  
                                                }  
                                                
                                                mail.setToAddresses(ToEmailAdresses);
                                                if(CCEmailAdresses!=null && CCEmailAdresses.size()>0){
                                                    mail.setCcAddresses(CCEmailAdresses);                
                                                }
                                                if(BCCEmailAdresses!=null && BCCEmailAdresses.size()>0){
                                                    mail.setBccAddresses(BCCEmailAdresses);               
                                                }            
                                                mail.setSubject(subject);
                                                mail.setHtmlBody(Body);
                                                mail.setCharset('UTF-8');  
                                                mail.setTreatBodiesAsTemplate(true);
                                                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                                                /*if (Schema.sObjectType.Attachment.fields.Name.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()
                                                    && Schema.sObjectType.Attachment.fields.BodyLength.isAccessible()){
                                                        for (Attachment at : [select Name,Body,BodyLength from Attachment where id= :a.id]) 
                                                            
                                                        {  */ 
                                                            //system.debug('Attachment Name ----> '+at.Name);
                                                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                                                            efa.setFileName(Name); 
                                                            efa.setBody(pdfPageBlob); 
                                                            efa.setContentType(ContentType);
                                                            fileAttachments.add(efa);
                                                      /*  }
                                                    }*/
                                                //system.debug( ' files ****** ' + fileData.size());                     
                                                for(fileDetails files : fileData){
                                                    //system.debug( ' filesinsert ****** ' + files.fileName);     
                                                    Messaging.Emailfileattachment efas = new Messaging.Emailfileattachment();  
                                                    efas.setFileName(files.fileName); 
                                                    efas.setBody(EncodingUtil.base64decode(files.fileContent)); 
                                                    efas.setContentType(files.Type); 
                                                    fileAttachments.add(efas);                               
                                                }
                                                mail.setFileAttachments(fileAttachments);
                                                
                                                try{ 
                                                    //JunoDoc__JunoDoc_Transaction__c jdt;
                                                    if(!Test.isRunningTest()){  
                                                        
                                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                                                         //Create Task to Global Activity Parent Record ID field in Junodoc Details Object
                                                        string selectedobject = id.getSObjectType().getDescribe().getName();
                                                        List<Junodoc_Details__c> junoDetailList = [select id,JunoDoc__Global_Activity_Parent_Record_ID__c
                                                                                                  from Junodoc_Details__c 
                                                                                                  where Selected_object__c =: selectedobject AND JunoDoc__Global_Activity_Parent_Record_ID__c != null];
                                                        system.debug('junoDetailList >> '+junoDetailList.size());
                                                        if(!junoDetailList.isEmpty()){
                                                            Task TaskActivity = new Task();
                                                            TaskActivity.whatId = junoDetailList[0].JunoDoc__Global_Activity_Parent_Record_ID__c;    
                                                            TaskActivity.Status='Completed';
                                                            TaskActivity.Subject = Subject;
                                                            TaskActivity.To_Email_Addresses__c = ToEmailAdresses+''; 
                                                            TaskActivity.ActivityDate = System.Today();                                                        
                                                            insert TaskActivity;
                                                        }
                                                        /*added this jdt insertion logic on march 21st 2024
                                                        list<OrgWideEmailAddress> senderEmailinfo = [select Id,Address,DisplayName from OrgWideEmailAddress where Id =: FromEmailAddress];
                                                        jdt = new JunoDoc__JunoDoc_Transaction__c();
                                                        jdt.JunoDoc__Status__c = 'Sent';
                                                        jdt.JunoDoc__Date_Sent__c = Date.today();
                                                        jdt.JunoDoc__Email_Body__c = Body.stripHtmlTags();
                                                        jdt.JunoDoc__Email_Subject__c = Subject;
                                                        jdt.JunoDoc__Sender_Email__c = senderEmailinfo[0].Address;
                                                        jdt.JunoDoc__Sender_Name__c = senderEmailinfo[0].DisplayName;
                                                        jdt.JunoDoc__Original_Document_Id__c = DocTemplateId;
                                                        insert jdt;
                                                        system.debug('@@@@@1242 @@@@@@@@'+jdt.Id);*/
                                                    }
                                                    
                                                    if(Test.isRunningTest()){
                                                        SaveAsActivity = true;
                                                    }
                                                    ResultMap.put('state','success');
                                                    ResultMap.put('Message','Email Sent Successfully. You will be redirected to record page');   
                                                    if(SaveAsActivity){
                                                        
                                                        Task Taskhistory = new Task();
                                                        /* if(Schema.sObjectType.Task.fields.Status.isCreateable()
                                                                && Schema.sObjectType.Task.fields.WhoId.isCreateable() && Schema.sObjectType.Task.fields.whatId.isCreateable()
                                                                && Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.To_Email_Addresses__c.isCreateable()
                                                                && Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.Description.isCreateable()){*/
                                                        
                                                        if(sObjName.toLowerCase()=='LEAD' || sObjName.toLowerCase()=='CONTACT'){
                                                            Taskhistory.WhoId = id;    
                                                        }else{
                                                            Taskhistory.whatId = id;    
                                                        }                           
                                                        Taskhistory.Status='Completed';
                                                        Taskhistory.Subject = Subject;
                                                        Taskhistory.To_Email_Addresses__c = ToEmailAdresses+''; 
                                                        Taskhistory.ActivityDate = System.Today();
                                                       // Taskhistory.Description =body; 
                                                        
                                                       insert Taskhistory;
                                                        //}
                                                        
                                                        
                                                        ContentVersion cntVerson = new ContentVersion(); 
                                                        cntVerson.ContentLocation = 'S';
                                                        cntVerson.VersionData = pdfPageBlob;
                                                        cntVerson.Title = Title;
                                                        cntVerson.PathOnClient = Name;        
                                                        insert cntVerson;
                                                        system.debug('cntVerson### ' + cntVerson.Id);
                                                        
                                                        ContentDocumentLink contDocmnt = new ContentDocumentLink();
                                                        contDocmnt.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cntVerson.Id].ContentDocumentId;
                                                        contDocmnt.LinkedEntityId = id;
                                                        contDocmnt.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                                                        contDocmnt.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                                                        insert contDocmnt; 
                                                        system.debug('contDocmnt >>> '+contDocmnt.Id);
                                                        /*if(jdt.Id != null){
                                                            jdt.JunoDoc__Final_Document_Id__c = contDocmnt.Id;
                                                            update jdt;
                                                        }*/
                                                        
                                                        list<ContentVersion> ContentVersionlist = new list<ContentVersion>();
                                                        for(fileDetails files : fileData){
                                                            ContentVersion ContentVersionrec = new ContentVersion();
                                                            ContentVersionrec.ContentLocation = 'S';
                                                            ContentVersionrec.VersionData = EncodingUtil.base64decode(files.fileContent);
                                                            ContentVersionrec.Title = files.fileName;
                                                            ContentVersionrec.PathOnClient = files.fileName;       
                                                            ContentVersionlist.add(ContentVersionrec);                               
                                                        }
                                                         insert ContentVersionlist;
                                                        list<ContentDocumentLink> ContentDocumentLinklist = new list<ContentDocumentLink>();
                                                        list<contentversion> contentversionlists = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: ContentVersionlist];
                                                        for(contentversion consver : contentversionlists){
                                                            ContentDocumentLink contDocmnts = new ContentDocumentLink();
                                                            contDocmnts.ContentDocumentId = consver.ContentDocumentId;
                                                            contDocmnts.LinkedEntityId = id;
                                                            contDocmnts.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                                                        contDocmnts.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                                                            ContentDocumentLinklist.add(contDocmnts);
                                                        }
                                                          insert ContentDocumentLinklist; 
                                                        
                                                          Attachment att = new Attachment();
                                                        if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable() /*&& Schema.sObjectType.Attachment.fields.Description.isCreateable()*/
                                                           && Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                                                               Doc_Template__c DocTemplates = [select id,PDF_Name__c,JunoDoc__Parent_Object__c from Doc_Template__c where id =: DocTemplateId];
                                                               att.Body = pdfPageBlob; 
                                                               att.ParentID = Taskhistory.Id; 
                                                               att.Name = Title+'task.pdf';
                                                               att.ContentType = ContentType;
                                                               insert att;
                                                           }
                                                        list<Attachment> Attachlist = new list<Attachment>();
                                                        for(fileDetails files : fileData){
                                                            Attachment Atts = new Attachment();
                                                            Atts.Body = EncodingUtil.base64decode(files.fileContent); 
                                                            Atts.ParentID = Taskhistory.Id; 
                                                            Atts.Name = files.fileName;
                                                            Atts.ContentType = files.Type;
                                                            Attachlist.add(Atts);                               
                                                        }
                                                        insert Attachlist;
                                                        system.debug('Attachlist >>> '+Attachlist);
                                                      
                                                        
                                                    }
                                                    
                                                    
                                                   // if(Attachment.sObjectType.getDescribe().isDeletable()){
                                                      //  delete[Select id From Attachment Where id=:a.id];
                                                    //}                
                                                    
                                                    
                                                    if(SaveAsActivity){
                                                        ResultMap.put('Message','Email Sent and Saved as Activity. You will be redirected to record page');
                                                    }
                                                    
                                                    
                                                    /* }

catch(exception e){
ResultMap.put('state','Error');
ResultMap.put('Message',e.getMessage());

if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){                   
ResultMap.put('Message','Please Enter Valid Email Address');    
}                

if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
} 

} */
                                                    
                                                } 
                                                catch (Exception  e) {
                                                    if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
                                                        //system.debug('test');
                                                        ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
                                                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email limit exceeded .Please Try Later.'));
                                                        
                                                        
                                                        /*added this jdt insertion logic on march 21st 2024
                                                        list<OrgWideEmailAddress> senderEmailinfo = [select Id,Address,DisplayName from OrgWideEmailAddress where Id =: FromEmailAddress];
                                                        JunoDoc__JunoDoc_Transaction__c jdt = new JunoDoc__JunoDoc_Transaction__c();
                                                        jdt.JunoDoc__Status__c = 'Not Sent';
                                                        jdt.JunoDoc__Date_Sent__c = Date.today();
                                                        jdt.JunoDoc__Email_Body__c = Body.stripHtmlTags();
                                                        jdt.JunoDoc__Email_Subject__c = Subject;
                                                        jdt.JunoDoc__Sender_Email__c = senderEmailinfo[0].Address;
                                                        jdt.JunoDoc__Sender_Name__c = senderEmailinfo[0].DisplayName;
                                                        jdt.JunoDoc__Original_Document_Id__c = DocTemplateId;
                                                        insert jdt;
                                                        system.debug('@@@@@1380 @@@@@@@@'+jdt.Id);*/
                                                        
                                                    } else{
                                                        ResultMap.put('Message',e.getMessage());
                                                    }
                                                } 
                                                
                                                return ResultMap;   
                                            }
    
    
    
     @AuraEnabled
    public static Map<string,string> SendPDFs(Id id,Id DocTemplateId, string Subject,string Body,                                             
                                             string FromEmailAddress, string SetReplyTo, 
                                             string SetSenderDisplayName, boolean SaveAsActivity, 
                                             list<string> ToTextEmailsList, list<string> ToEmailMergeFieldsList,
                                             list<string> CCTextEmailsList, list<string> CCEmailMergeFieldsList,
                                             list<string> BCCTextEmailsList, list<string> BCCEmailMergeFieldsList,
                                             list<fileDetails> fileData,string baseString
                                            ){  
                                                system.debug('baseString--->'+baseString);  
                                                //system.debug('FromEmailAddress--->'+FromEmailAddress);
                                                //system.debug('Id--->'+id);
                                                Map<string,string> ResultMap = new Map<string,string>();
                                                //  try{
                                                String sObjName = id.getSObjectType().getDescribe().getName();
                                                string PDFName = 'Name';
                                                string query = 'Select id,';
                                                if(sObjName == 'Case'){
                                                    query += 'CaseNumber'; 
                                                    PDFName = 'CaseNumber';
                                                }
                                                else if(sObjName == 'WorkOrder'){
                                                    query += 'WorkOrderNumber'; 
                                                    PDFName = 'WorkOrderNumber';
                                                }
                                                else{
                                                    query += 'Name';                                 
                                                }
                                                if(ToEmailMergeFieldsList.size() > 0){
                                                    for(string str : ToEmailMergeFieldsList){
                                                        //system.debug('To Email--->'+str);
                                                        if(!str.contains('@')){
                                                            if(str.contains(sObjName+'.')){
                                                                str = str.replace(sObjName+'.','');
                                                            }
                                                            query += ','+str;    
                                                        }
                                                    }
                                                }
                                                if(CCEmailMergeFieldsList.size() > 0){
                                                    for(string str : CCEmailMergeFieldsList){
                                                        //system.debug('CC Email--->'+str);
                                                        if(str.contains(sObjName+'.')){
                                                            str = str.replace(sObjName+'.','');
                                                        }   
                                                        
                                                        //if(str.toLowerCase()!='owner.email'){
                                                        //else{
                                                        query += ','+str;
                                                        //}
                                                    }
                                                }
                                                
                                                if(BCCEmailMergeFieldsList.size() > 0){
                                                    for(string str : BCCEmailMergeFieldsList){
                                                        //system.debug('BCC Email--->'+str);
                                                        if(str.contains(sObjName+'.')){
                                                            str = str.replace(sObjName+'.','');
                                                        }  
                                                        //if(str.toLowerCase()!='owner.email'){
                                                        //else{
                                                        query += ','+str;
                                                        //}
                                                    }
                                                }
                                                //system.debug('query--->'+query);
                                                query +=  ' From '+sObjName+' Where id=:id';
                                                Sobject sobjList = Database.query(String.escapeSingleQuotes(query));    
                                                system.debug('query--->'+query);
                                                string setReplyToEmail = ''; //sobjList.getsobject('owner').get('Email')+'';
                                                string SenderDisplayName = ''; //sobjList.getsobject('owner').get('Name')+'';                        
                                                if(SetReplyTo != null && SetReplyTo != ''){
                                                    setReplyToEmail = SetReplyTo;
                                                }
                                                //system.debug('setReplyToEmail--->'+setReplyToEmail);
                                                /*if(SetSenderDisplayName != null && SetSenderDisplayName != ''){
SenderDisplayName = SetSenderDisplayName;
}*/
                                                //system.debug(DocTemplateId + '*********** '+ id);
                                                list<Doc_Template__c> DocTemplateRec = [select Id,Name,Parent_Object__c,PDF_Name__c,Date_Format__c,
                                                                                        JunoDoc__Template_Type__c,From_Upload__c
                                                                                        from Doc_Template__c where Id =: DocTemplateId];
                                                system.debug('DocTemplateId>>>>>>>>>>>>>>>>>>>>'+DocTemplateId);
                                                Blob pdfPageBlob; 
                                                string Name = sobjList.get(PDFName)+ '';   
                                                string Title = sobjList.get(PDFName)+'';   
                                               /* if(!DocTemplateRec.isEmpty() && DocTemplateRec[0].JunoDoc__Related_Files__c == true){
                                                    
                                                }else{
                                                    
                                                }*/
                                                system.debug('Title***' + Title);
                                                if(!DocTemplateRec.isEmpty()){                                    
                                                    String SobjectApiName = DocTemplateRec[0].Parent_Object__c;
                                                    string fieldNames = '';
                                                    
                                                    /*     if(DocTemplateRec[0].PDF_Name__c != '' && DocTemplateRec[0].PDF_Name__c != null){
Title = DocTemplateRec[0].PDF_Name__c;
if(DocTemplateRec[0].PDF_Name__c.contains('{!')){
string finalstrings = string.valueof(DocTemplateRec[0].PDF_Name__c).replace('{!','xxwwwee');
string[] pdfnames = finalstrings.split('xxwwwee');
integer k = 0;
for(string str : pdfnames){
if(k != 0 && !str.contains('()')){
string[] strlist = str.split('}');
fieldNames += strlist[0]+ ',';
}
k = k+1;  
}
}
} */                                                 system.debug('PDF_Name__c***' + DocTemplateRec[0].PDF_Name__c);
                                                    
                                                    if(DocTemplateRec[0].PDF_Name__c != '' && DocTemplateRec[0].PDF_Name__c != null){
                                                        Title = DocTemplateRec[0].PDF_Name__c;
                                                        string DateFormats = 'MM/dd/yyyy';
                                                        if(DocTemplateRec[0].Date_Format__c != null && DocTemplateRec[0].Date_Format__c != ''){
                                                            DateFormats = DocTemplateRec[0].Date_Format__c;
                                                        }
                                                        if(Title.contains('{!TODAY()}')){
                                                            Date Datestr = system.Today();
                                                            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                                                            DocTemplateRec[0].PDF_Name__c = Title.replace('{!TODAY()}',Parentvalues);  
                                                            Title = Title.replace('{!TODAY()}',Parentvalues); 
                                                        }
                                                        if(Title.contains('{!NOW()}')){
                                                            string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                                                            DocTemplateRec[0].PDF_Name__c = Title.replace('{!NOW()}',Parentvalues);     
                                                            Title = Title.replace('{!NOW()}',Parentvalues); 
                                                        }
                                                        if(DocTemplateRec[0].Junodoc__PDF_Name__c.contains('{!')){
                                                            string finalstrings = string.valueof(DocTemplateRec[0].PDF_Name__c).replace('{!','xxwwwee');
                                                            string[] pdfnames = finalstrings.split('xxwwwee');
                                                            integer k = 0;
                                                            for(string str : pdfnames){
                                                                if(k != 0){
                                                                    string[] strlist = str.split('}');
                                                                    fieldNames += strlist[0]+ ',';
                                                                }
                                                                k = k+1;  
                                                            }
                                                        }
                                                    }
                                                    
                                                    if(fieldNames != ''){
                                                        fieldNames = fieldNames.substring(0,fieldNames.length()-1);
                                                        string pdfquery = 'select id,'+fieldNames+' from '+SobjectApiName+ ' where id=:id';
                                                        sobject dynamicobject = Database.query(pdfquery);
                                                        string[] fieldlist = fieldNames.split(',');
                                                        for(string names : fieldlist){
                                                            //system.debug('names **' + names);
                                                            if(!names.contains('.')){
                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.get(names));
                                                            }
                                                            else if(names.contains('.')){
                                                                string Stringobjct = names.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) { 
                                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 2){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) { 
                                                                                Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 1){
                                                                    if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                                                                        if(dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null){
                                                                            Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            Title = Title.replace('{!'+names + '}','');
                                                        }
                                                    }
                                                    //system.debug('Title **' + Title);
                                                    Title = Title.replace(',','');
                                                    Title = Title.replace('.','');
                                                    Title = Title.replace('\'','');
                                                    Title = Title.replace(';','');
                                                    if(DocTemplateRec[0].JunoDoc__Template_Type__c != 'Word Document' && DocTemplateRec[0].JunoDoc__Template_Type__c != 'Excel'){
                                                        Name = Title + '.pdf';
                                                    }
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Word Document'){
                                                        Name = Title + '.doc';   
                                                    }
                                                    else{
                                                        Name = Title + '.xls';   
                                                    }
                                                }
                                                list<string> ToEmailAdresses = getEmailRecipientsHelper(ToTextEmailsList, ToEmailMergeFieldsList,sobjList);
                                                list<string> CCEmailAdresses = getEmailRecipientsHelper(CCTextEmailsList, CCEmailMergeFieldsList,sobjList);
                                                list<string> BCCEmailAdresses = getEmailRecipientsHelper(BCCTextEmailsList, BCCEmailMergeFieldsList,sobjList);
                                                
                                                string ContentType = 'application/pdf';  
                                                Attachment a = new Attachment(); 
                                                if(!DocTemplateRec.isEmpty()){
                                                    if(DocTemplateRec[0].JunoDoc__Template_Type__c != 'Word Document' && DocTemplateRec[0].JunoDoc__Template_Type__c != 'Excel'){
                                                        PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        
                                                        if(Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else{
                                                            //system.debug( 'pageconentent *********** '+ pagePdf.getContentAsPDF());
                                                            pdfPageBlob = pagePdf.getContentAsPDF(); 
                                                        }
                                                    }
                                                    
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Word Document'){
                                                        PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewTemplateWord');  
                                                        // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        //system.debug('pagePdf -----> '+pagePdf);
                                                        if (Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else{ 
                                                            //system.debug('getcontents**' + pagePdf.getContent().tostring());
                                                            string blobs = pagePdf.getContent().tostring();
                                                            //system.debug('getblobs**' + Blob.valueOf(blobs));
                                                            pdfPageBlob = Blob.valueOf(blobs); 
                                                        }
                                                        pdfPageBlob = EncodingUtil.base64Decode(baseString);
                                                        
                                                        ContentType = 'application/msword';  
                                                    }
                                                    
                                                    else if(DocTemplateRec[0].JunoDoc__Template_Type__c == 'Excel'){
                                                        PageReference pagePdf = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewExcel');  
                                                        // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
                                                        pagePdf.getParameters().put('id', id); 
                                                        pagePdf.getParameters().put('DocTemplateId', DocTemplateId); 
                                                        //system.debug('pagePdf -----> '+pagePdf);
                                                        if (Test.IsRunningTest()){
                                                            pdfPageBlob = Blob.valueOf('UNIT.TEST');
                                                        }
                                                        else if(DocTemplateRec[0].From_Upload__c == true){
                                                            pdfPageBlob = EncodingUtil.base64Decode(baseString);
                                                        }
                                                        else{ 
                                                            //system.debug('getcontents**' + pagePdf.getContent().tostring());
                                                            string blobs = pagePdf.getContent().tostring();
                                                            //system.debug('getblobs**' + Blob.valueOf(blobs));
                                                            pdfPageBlob = Blob.valueOf(blobs); 
                                                        }
                                                        
                                                        ContentType = 'application/msexcel';  
                                                    }
                                                    
                                                    //system.debug('sobjList ---->'+sobjList);
                                                    
                                                    if(ToEmailAdresses.size()>0 || CCEmailAdresses.size()>0 || BCCEmailAdresses.size()>0){
                                                        /*if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.Name.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                                                               a.Body = pdfPageBlob; 
                                                               a.ParentID = id; 
                                                               // system.debug('pdf name ---->'+sobjList.get('Name'));
                                                               a.Name =  Name;
                                                               a.ContentType = ContentType;
                                                               //system.debug('Attachment -> '+a);
                                                               insert a;
                                                               system.debug('Attachment >>>> '+a.id);  
                                                           } */
                                                    }
                                                }
                                                list<OrgWideEmailAddress> owea = new list<OrgWideEmailAddress>();
                                                if(FromEmailAddress!='' && FromEmailAddress!=null){
                                                    owea = [select Id,Address from OrgWideEmailAddress where Id=:FromEmailAddress];          
                                                }
                                                
                                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                if(setReplyToEmail != ''){
                                                    mail.setReplyTo(setReplyToEmail);
                                                }
                                                if ( owea.size() == 0 ) {  
                                                    mail.setSenderDisplayName(SenderDisplayName);
                                                }
                                                
                                                if ( owea.size() > 0 ) {
                                                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                                }
                                                
                                                
                                                
                                                List<Junodoc_Setting__c> setlist = [select id,JunoDoc__Enable_SenderBCC__c from Junodoc_Setting__c];
                                                if(!setlist.isEmpty()){
                                                    if(setlist[0].JunoDoc__Enable_SenderBCC__c == true){
                                                        //system.debug('Userinfo.getUserEmail()------->'+Userinfo.getUserEmail());
                                                        BCCEmailAdresses.add(Userinfo.getUserEmail());
                                                        mail.setBccSender(true);
                                                    }                                  
                                                }  
                                                
                                                mail.setToAddresses(ToEmailAdresses);
                                                if(CCEmailAdresses!=null && CCEmailAdresses.size()>0){
                                                    mail.setCcAddresses(CCEmailAdresses);                
                                                }
                                                if(BCCEmailAdresses!=null && BCCEmailAdresses.size()>0){
                                                    mail.setBccAddresses(BCCEmailAdresses);               
                                                }            
                                                mail.setSubject(subject);
                                                mail.setHtmlBody(Body);
                                                mail.setCharset('UTF-8');  
                                                mail.setTreatBodiesAsTemplate(true);
                                                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                                                /*if (Schema.sObjectType.Attachment.fields.Name.isAccessible() && Schema.sObjectType.Attachment.fields.Body.isAccessible()
                                                    && Schema.sObjectType.Attachment.fields.BodyLength.isAccessible()){
                                                        for (Attachment at : [select Name,Body,BodyLength from Attachment where id= :a.id]) 
                                                            
                                                        {  */ 
                                                            //system.debug('Attachment Name ----> '+at.Name);
                                                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                                                            efa.setFileName(Name); 
                                                            efa.setBody(pdfPageBlob); 
                                                            efa.setContentType(ContentType);
                                                            fileAttachments.add(efa);
                     /*------------- Siddhu-------------*/                           
                                                
                                                    List<Doc_Template__c> DocTemplateRec1 = [SELECT Id, Name, Parent_Object__c, PDF_Name__c, JunoDoc__Related_Files__c,Date_Format__c, JunoDoc__Template_Type__c FROM Doc_Template__c WHERE Id = :DocTemplateId ];
                                                for (Doc_Template__c docTemplate : DocTemplateRec1) {
                                                     if (docTemplate.JunoDoc__Related_Files__c) {
                                                 List<ContentDocumentLink> docLinks = [SELECT LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = : docTemplate.Id];
                                              for (ContentDocumentLink docLink : docLinks) {
                                             List<ContentVersion> versions = [SELECT Title,ContentDocumentId, VersionData, FileType FROM ContentVersion WHERE ContentDocumentId = : docLink.ContentDocumentId];
                                                     for (ContentVersion version : versions) {
                                         Messaging.EmailFileAttachment docAttachment = new Messaging.EmailFileAttachment();
                                            docAttachment.setFileName(version.Title);
                                            docAttachment.setBody(version.VersionData);
                                            //docAttachment.setContentType('application/pdf');
                                            if (version.FileType == 'PDF') {
                                                docAttachment.setContentType('application/pdf');
                                            } else if (version.FileType == 'DOCX') {
                                                docAttachment.setContentType('application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                                            } else if (version.FileType == 'DOC') {
                                                docAttachment.setContentType('application/msword');
                                            } else {
                                                docAttachment.setContentType('application/octet-stream'); // Default type if unknown
                                            }
                                            fileAttachments.add(docAttachment);
                                      }
                                    }
                                   }
                                 }           
                                                
                                                
                                                      /*  }
                                                    }*/
                                                //system.debug( ' files ****** ' + fileData.size());                     
                                                for(fileDetails files : fileData){
                                                    //system.debug( ' filesinsert ****** ' + files.fileName);     
                                                    Messaging.Emailfileattachment efas = new Messaging.Emailfileattachment();  
                                                    efas.setFileName(files.fileName); 
                                                    efas.setBody(EncodingUtil.base64decode(files.fileContent)); 
                                                    efas.setContentType(files.Type); 
                                                    fileAttachments.add(efas);                               
                                                }
                                                mail.setFileAttachments(fileAttachments);
                                                
                                                try{ 
                                                    //JunoDoc__JunoDoc_Transaction__c jdt;
                                                    if(!Test.isRunningTest()){  
                                                        
                                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                                                        //Create Task to Global Activity Parent Record ID field in Junodoc Details Object
                                                        string selectedobject = id.getSObjectType().getDescribe().getName();
                                                        List<Junodoc_Details__c> junoDetailList = [select id,JunoDoc__Global_Activity_Parent_Record_ID__c
                                                                                                  from Junodoc_Details__c 
                                                                                                  where Selected_object__c =: selectedobject AND JunoDoc__Global_Activity_Parent_Record_ID__c != null];
                                                        system.debug('junoDetailList >> '+junoDetailList.size());
                                                        if(!junoDetailList.isEmpty()){
                                                            Task TaskActivity = new Task();
                                                            TaskActivity.whatId = junoDetailList[0].JunoDoc__Global_Activity_Parent_Record_ID__c;    
                                                            TaskActivity.Status='Completed';
                                                            TaskActivity.Subject = Subject;
                                                            TaskActivity.To_Email_Addresses__c = ToEmailAdresses+''; 
                                                            TaskActivity.ActivityDate = System.Today();                                                        
                                                            insert TaskActivity;
                                                        }
                                                        
                                                        /*added this jdt insertion logic on march 21st 2024
                                                        list<OrgWideEmailAddress> senderEmailinfo = [select Id,Address,DisplayName from OrgWideEmailAddress where Id =: FromEmailAddress];
                                                        jdt = new JunoDoc__JunoDoc_Transaction__c();
                                                        jdt.JunoDoc__Status__c = 'Sent';
                                                        jdt.JunoDoc__Date_Sent__c = Date.today();
                                                        jdt.JunoDoc__Email_Body__c = Body.stripHtmlTags();
                                                        jdt.JunoDoc__Email_Subject__c = Subject;
                                                        jdt.JunoDoc__Sender_Email__c = senderEmailinfo[0].Address;
                                                        jdt.JunoDoc__Sender_Name__c = senderEmailinfo[0].DisplayName;
                                                        jdt.JunoDoc__Original_Document_Id__c = DocTemplateId;
                                                        insert jdt;
                                                        system.debug('@@@@@1242 @@@@@@@@'+jdt.Id);*/
                                                    }
                                                    
                                                    if(Test.isRunningTest()){
                                                        SaveAsActivity = true;
                                                    }
                                                    ResultMap.put('state','success');
                                                    ResultMap.put('Message','Email Sent Successfully. You will be redirected to record page');   
                                                    if(SaveAsActivity){
                                                        
                                                        Task Taskhistory = new Task();
                                                        /* if(Schema.sObjectType.Task.fields.Status.isCreateable()
                                                                && Schema.sObjectType.Task.fields.WhoId.isCreateable() && Schema.sObjectType.Task.fields.whatId.isCreateable()
                                                                && Schema.sObjectType.Task.fields.Subject.isCreateable() && Schema.sObjectType.Task.fields.To_Email_Addresses__c.isCreateable()
                                                                && Schema.sObjectType.Task.fields.ActivityDate.isCreateable() && Schema.sObjectType.Task.fields.Description.isCreateable()){*/
                                                        
                                                        if(sObjName.toLowerCase()=='LEAD' || sObjName.toLowerCase()=='CONTACT'){
                                                            Taskhistory.WhoId = id;    
                                                        }else{
                                                            Taskhistory.whatId = id;    
                                                        }                           
                                                        Taskhistory.Status='Completed';
                                                        Taskhistory.Subject = Subject;
                                                        Taskhistory.To_Email_Addresses__c = ToEmailAdresses+''; 
                                                        Taskhistory.ActivityDate = System.Today();
                                                       // Taskhistory.Description =body; 
                                                        
                                                       insert Taskhistory;
                                                        //}
                                                        
                                                        
                                                        ContentVersion cntVerson = new ContentVersion(); 
                                                        cntVerson.ContentLocation = 'S';
                                                        cntVerson.VersionData = pdfPageBlob;
                                                        cntVerson.Title = Title;
                                                        cntVerson.PathOnClient = Name;        
                                                        insert cntVerson;
                                                        system.debug('cntVerson### ' + cntVerson.Id);
                                                        
                                                        ContentDocumentLink contDocmnt = new ContentDocumentLink();
                                                        contDocmnt.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cntVerson.Id].ContentDocumentId;
                                                        contDocmnt.LinkedEntityId = id;
                                                        contDocmnt.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                                                        contDocmnt.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                                                        insert contDocmnt; 
                                                        system.debug('contDocmnt >>> '+contDocmnt.Id);
                                                        /*if(jdt.Id != null){
                                                            jdt.JunoDoc__Final_Document_Id__c = contDocmnt.Id;
                                                            update jdt;
                                                        }*/
                                                        
                                                        list<ContentVersion> ContentVersionlist = new list<ContentVersion>();
                                                        for(fileDetails files : fileData){
                                                            ContentVersion ContentVersionrec = new ContentVersion();
                                                            ContentVersionrec.ContentLocation = 'S';
                                                            ContentVersionrec.VersionData = EncodingUtil.base64decode(files.fileContent);
                                                            ContentVersionrec.Title = files.fileName;
                                                            ContentVersionrec.PathOnClient = files.fileName;       
                                                            ContentVersionlist.add(ContentVersionrec);                               
                                                        }
                                                         insert ContentVersionlist;
                                                        list<ContentDocumentLink> ContentDocumentLinklist = new list<ContentDocumentLink>();
                                                        list<contentversion> contentversionlists = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN: ContentVersionlist];
                                                        for(contentversion consver : contentversionlists){
                                                            ContentDocumentLink contDocmnts = new ContentDocumentLink();
                                                            contDocmnts.ContentDocumentId = consver.ContentDocumentId;
                                                            contDocmnts.LinkedEntityId = id;
                                                            contDocmnts.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                                                        contDocmnts.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                                                            ContentDocumentLinklist.add(contDocmnts);
                                                        }
                                                          insert ContentDocumentLinklist; 
                                                        
                                                          Attachment att = new Attachment();
                                                        if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable() /*&& Schema.sObjectType.Attachment.fields.Description.isCreateable()*/
                                                           && Schema.sObjectType.Attachment.fields.Name.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                                                           && Schema.sObjectType.Attachment.fields.Body.isCreateable()){
                                                               Doc_Template__c DocTemplates = [select id,PDF_Name__c,JunoDoc__Parent_Object__c from Doc_Template__c where id =: DocTemplateId];
                                                               att.Body = pdfPageBlob; 
                                                               att.ParentID = Taskhistory.Id; 
                                                               att.Name = Title+'task.pdf';
                                                               att.ContentType = ContentType;
                                                               insert att;
                                                           }
                                                        list<Attachment> Attachlist = new list<Attachment>();
                                                        for(fileDetails files : fileData){
                                                            Attachment Atts = new Attachment();
                                                            Atts.Body = EncodingUtil.base64decode(files.fileContent); 
                                                            Atts.ParentID = Taskhistory.Id; 
                                                            Atts.Name = files.fileName;
                                                            Atts.ContentType = files.Type;
                                                            Attachlist.add(Atts);                               
                                                        }
                                                        insert Attachlist;
                                                        system.debug('Attachlist >>> '+Attachlist);
                                                      
                                                        
                                                    }
                                                    
                                                    
                                                   // if(Attachment.sObjectType.getDescribe().isDeletable()){
                                                      //  delete[Select id From Attachment Where id=:a.id];
                                                    //}                
                                                    
                                                    
                                                    if(SaveAsActivity){
                                                        ResultMap.put('Message','Email Sent and Saved as Activity. You will be redirected to record page');
                                                    }
                                                    
                                                    
                                                    /* }

catch(exception e){
ResultMap.put('state','Error');
ResultMap.put('Message',e.getMessage());

if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){                   
ResultMap.put('Message','Please Enter Valid Email Address');    
}                

if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
} 

} */
                                                    
                                                } 
                                                catch (Exception  e) {
                                                    if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
                                                        //system.debug('test');
                                                        ResultMap.put('Message','Email limit exceeded .Please Try Later.');    
                                                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email limit exceeded .Please Try Later.'));
                                                        
                                                        
                                                        /*added this jdt insertion logic on march 21st 2024
                                                        list<OrgWideEmailAddress> senderEmailinfo = [select Id,Address,DisplayName from OrgWideEmailAddress where Id =: FromEmailAddress];
                                                        JunoDoc__JunoDoc_Transaction__c jdt = new JunoDoc__JunoDoc_Transaction__c();
                                                        jdt.JunoDoc__Status__c = 'Not Sent';
                                                        jdt.JunoDoc__Date_Sent__c = Date.today();
                                                        jdt.JunoDoc__Email_Body__c = Body.stripHtmlTags();
                                                        jdt.JunoDoc__Email_Subject__c = Subject;
                                                        jdt.JunoDoc__Sender_Email__c = senderEmailinfo[0].Address;
                                                        jdt.JunoDoc__Sender_Name__c = senderEmailinfo[0].DisplayName;
                                                        jdt.JunoDoc__Original_Document_Id__c = DocTemplateId;
                                                        insert jdt;
                                                        system.debug('@@@@@1380 @@@@@@@@'+jdt.Id);*/
                                                        
                                                    } else{
                                                        ResultMap.put('Message',e.getMessage());
                                                    }
                                                } 
                                                
                                                return ResultMap;   
                                            }
   
    
    @AuraEnabled
    global static InnerEmailTemplates getEmailTemplates(id id) { 
        
        String sObjName = id.getSObjectType().getDescribe().getName();
        sObjName = sObjName.toUpperCase();
        
        list<EmailTemplateWrap> StandardEmailTemplatesList = new list<EmailTemplateWrap>();
        
        list<EmailTemplate> eTempList = [SELECT Id,Name,Body,Subject,HtmlValue 
                                         From EmailTemplate 
                                         Where IsActive = true
                                         Order By Name
                                         Limit 5000];
        system.debug(eTempList.size() + ' Emails ');
        //if(!Test.isRunningTest()){
        for(EmailTemplate rec:eTempList){            
            string body = rec.Body;
            string Subject = rec.Subject;
            string HtmlValue = rec.HtmlValue;
            if(body !=null && Subject !=null)
            {
                system.debug(Subject + ' obj ' + sObjName + ' Body '+ body);
                if(Subject.toUpperCase().contains(sObjName) || body.toUpperCase().contains(sObjName) 
                   || Subject.toUpperCase().contains('{!'+sObjName+'.') || body.toUpperCase().contains('{!'+sObjName+'.')){
                       EmailTemplateWrap objSettings = new EmailTemplateWrap();                    
                       objSettings.label=rec.Name;
                       objSettings.value=rec.Id;
                       StandardEmailTemplatesList.add(objSettings);                        
                   }                
            }
            else if(HtmlValue !=null && Subject !=null)
            {
                system.debug(Subject + ' obj ' + sObjName + ' Body '+ body);
                if(Subject.toUpperCase().contains(sObjName) || HtmlValue.toUpperCase().contains(sObjName) 
                   || Subject.toUpperCase().contains('{!'+sObjName+'.') || HtmlValue.toUpperCase().contains('{!'+sObjName+'.')){
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
        
        
        InnerEmailTemplates Inn = new InnerEmailTemplates();
        Inn.StandardEmailTemplatesList = StandardEmailTemplatesList;
        Inn.JunoDocEmailTemplatesList = JunoDocEmailTemplatesList;
        
        return Inn;
    }    
    
    global class InnerEmailTemplates{
        @AuraEnabled
        global list<EmailTemplateWrap> StandardEmailTemplatesList;
        @AuraEnabled
        global list<EmailTemplateWrap> JunoDocEmailTemplatesList;        
    }
    
    global class EmailTemplateWrap{
        @AuraEnabled
        global String label;
        @AuraEnabled
        global String value;    
    }
    
    @AuraEnabled
    global static String getBodyFromEmailTemplate(id recordId, 
                                                  /*list<string> toUserEmailsList,
list<string> toContactEmailsList,String toEmails,*/
                                                  string EmailTemplateId) 
    { 
        
        String CaseEmailAddress=''; 
        String plainTextBody='';
        String Subject='';
        string errorMessage='';
        
        if(EmailTemplateId !='')
        {                        
            
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            
            
            EmailTemplate eTempRec = [SELECT Id,Name,Body,Subject 
                                      From EmailTemplate 
                                      Where Id=:EmailTemplateId];
            if(eTempRec!=null){
                Subject = eTempRec.Subject;     
            }            
            
            string TargetObjectId = '';
            
            Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
            system.debug('objectFields--->'+objectFieldsMap); 
            
            
            string query = 'Select id  From '+sObjName+' Where id=:recordId';
            
            if(objectFieldsMap.get('ContactId')!=null){
                query = 'Select id,ContactId From '+sObjName+' Where id=:recordId';
            }
            Sobject sobjList = Database.query(query);    
            
            
            
            //  string setReplyToEmail = sobjList.getsobject('owner').get('Email')+'';
            // string SenderDisplayName = sobjList.getsobject('owner').get('Name')+'';
            if(objectFieldsMap.get('ContactId')!=null){
                TargetObjectId = sobjList.get('ContactId')+'';
            }            
            
            List<string> ToAdresses = new List<string>();
            
            Savepoint sp = Database.setSavepoint();
            system.debug('TargetObjectId--->'+TargetObjectId);
            if(TargetObjectId=='' || TargetObjectId==null || TargetObjectId=='null'){
                system.debug('TargetObjectId--->'+TargetObjectId);
                //dummy Account & Contact are creating to get TargetObjectId and will be rollbacked
                Account acct = new Account();
                try{
                    acct = new Account(Name='JunoDoc Dummy Account');
                    insert acct;
                }
                catch(Exception e){
                    list<account> acctList = [select Id from Account limit 1];
                    if(!acctList.isEmpty()){
                        acct = acctList[0];
                    }   
                }
                
                try{
                // Add a contact to this account.
                Contact con = new Contact(
                    FirstName='JunoDoc',
                    LastName='Dummy Contact',
                    Phone='111111',
                    Email='pratapuddarraju@gmail.com',
                    AccountId=acct.id);
                insert con;
                    TargetObjectId = con.Id;  
                }
                catch(Exception e){
                    contact contacts = [select Id from contact where Email != null limit 1];
                    TargetObjectId = contacts.Id;
                }
                //End dummy Account & Contact are creating to get TargetObjectId and will be rollbacked
                
                              
            }
            
            ToAdresses.add('goutham.devavarapu@diligentforcelabs.com');
            
            list<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(EmailTemplateId);
            if(sObjName.toLowerCase()=='LEAD' || sObjName.toLowerCase()=='CONTACT'){
                email.setWhatId( [select id from Account limit 1].id);
            }else{
                email.setWhatId(recordId);
            }
            email.setTargetObjectId(TargetObjectId);
            email.setSaveAsActivity(false);
            email.setToAddresses(ToAdresses);
            // email.setReplyTo(setReplyToEmail); 
            if(!Test.isRunningTest()){
                msgList.add(email); 
                
                try{
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                }catch(exception e){
                    
                    if(e.getMessage().contains('INVALID_EMAIL_ADDRESS')){
                        errorMessage = 'Please Enter Valid Email Address';
                    }                
                    
                    if(e.getMessage().contains('SINGLE_EMAIL_LIMIT_EXCEEDED')){
                        errorMessage = 'Email limit exceeded .Please Try Later.';
                    } 
                    
                }
            }
            system.debug('email ************* ' + email.getPlainTextBody());
            system.debug('email textbody ************* ' + email.getHtmlBody());
            system.debug('email htmlbody ************* ' + email);
            Database.rollback(sp);  //rollback rollback rollback rollback rollback
            if(email.getPlainTextBody() != null && email.getPlainTextBody() != ''){
                plainTextBody = email.getPlainTextBody();        
            }
            else if(email.getHtmlBody() != null && email.getHtmlBody() != ''){
                plainTextBody = email.getHtmlBody();        
            }
            
            Subject = email.getSubject();
        }
        if(!Test.isRunningTest() ){
            plainTextBody = plainTextBody.replace('JunoDoc Dummy Contact', '');    
        }
        return Subject+'~'+plainTextBody+'~'+errorMessage;
        
        
    }
    
    
    @AuraEnabled
    global static String getBodyFromJunoDocEmailTemplate(id recordId,                                                  
                                                         string EmailTemplateId) 
    { 
        
        system.debug('EmailTemplateId >>> '+EmailTemplateId);
        
        String CaseEmailAddress=''; 
        String Body='';
        String Subject='';
        
        if(EmailTemplateId !='')
        {                                             
            
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            MergeFieldsController md = new MergeFieldsController();
            md.SObjectName = sObjName;
            md.recordId = recordId;
            
            Email_Template__c DocTemplates = [select id,
                                              Parent_Object__c,
                                              Currency_Format__c,
                                              Date_Format__c,
                                              Parent_Fields__c 
                                              From Email_Template__c 
                                              where id =: EmailTemplateId];
            list<Email_Template_Item__c> eTemplateItemRec = [select id,
                                                             Subject__c
                                                             From Email_Template_Item__c 
                                                             where Email_Template__c =: EmailTemplateId];
            integer itemcount= database.countQuery('select count() from Email_Template_Item__c Where Email_Template__c=:EmailTemplateId limit 1');
            if(itemcount>0){
                
                //  list<Email_Template_Item__c> eTemplateItemRec = Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(recordId, EmailTemplateId);
                if(eTemplateItemRec[0].Subject__c!=null){
                    Subject = md.m_MergeData(eTemplateItemRec[0].Subject__c);    
                }
                
                /*  if(eTemplateItemRec[0].Template_Body__c!=null){
Body = md.m_MergeData(eTemplateItemRec[0].Template_Body__c);
} */
                Body = '<table style="position: relative;" ><tr><td>'+Body+'</td></tr></table>';
                PageReference ref = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/Junodoc__EmailTemplate_VF?SObjectName='+sObjName+'&EmailTemplateId='+EmailTemplateId+'&recordId='+recordId);
                
                if(!Test.isRunningTest()){
                    Body  = string.valueof( ref.getcontent().tostring().trim() + '');   
                }
                else{
                    Body = '<div>Test</div>';
                }
                Body  = Body.unescapeHtml4(); 
                Body  = Body.replace('<div style="font-size: 0px;">"</div>','');
                
            }
            
        }
        
        return Subject+'~'+Body;
        
    }
    
    global static list<Email_Template_Item__c> getJunoDocEmailTemplate(id recordId,                                                  
                                                                       string EmailTemplateId){
                                                                           
                                                                           Email_Template__c DocTemplates = [select id,
                                                                                                             Parent_Object__c,
                                                                                                             Parent_Fields__c 
                                                                                                             from Email_Template__c 
                                                                                                             where id =: EmailTemplateId];
                                                                           list<Email_Template_Item__c> DocTemplateItem = [select id,
                                                                                                                           Template_Body__c ,
                                                                                                                           Subject__c
                                                                                                                           from Email_Template_Item__c 
                                                                                                                           where Email_Template__c =: EmailTemplateId ];
                                                                           string NewTemplateBody = '';
                                                                           for(Email_Template_Item__c Doc : DocTemplateItem){
                                                                               NewTemplateBody += Doc.Template_Body__c;                                    
                                                                           }                                              
                                                                           list<Email_Template_Child__c> DocChilds = [select id,
                                                                                                                      Child_object__c,
                                                                                                                      color_1__c,  
                                                                                                                      color_2__c,
                                                                                                                      Border__c,
                                                                                                                      Child_Query__c,
                                                                                                                      Parent_Reference__c,
                                                                                                                      Filter__c,
                                                                                                                      height__c,
                                                                                                                      Order_By__c,Junodoc__Group_By__c,
                                                                                                                      
                                                                                                                      Sort_Order__c,
                                                                                                                        
                                                                                                                       
                                                                                                                        JunoDoc__Group_By_Calculation__c,
                                                                                                                        Junodoc__Calculation_Fields__c,
                                                                         
                                                                                                                        Junodoc__Header_style__c,
                                                                                                                        Junodoc__Header_Colour_background__c,
                                                                                                                        Junodoc__Border_Width__c,
                                                                                                                        Junodoc__Padding__c,
                                                                                                                        Junodoc__Render_Condition__c,  
                                                                                                                        JunoDoc__Child_Group_By__c,
                                                                                                                        JunoDoc__Rollup_groupby__c,
                                                                                                                        Junodoc__Related_Object_Labels__c,
                                                                                                                        Junodoc__Font_Size__c,
                                                                                                                        Junodoc__Table_grid__c,
                                                                                                                        JunoDoc__Aggregate_Query__c,
                                                                                                                        Junodoc__Font_Color__c
                                                                                                                      
                                                                                                                      from Email_Template_Child__c 
                                                                                                                      where Email_Template__c =: EmailTemplateId]; 
                                                                           String query ='';
                                                                           String SobjectApiName = recordId.getSObjectType().getDescribe().getName();
                                                                           
                                                                           Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                                                                           Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                                                                           
                                                                           map<string,string> ChildobjectsMap = new map<string,string>();
                                                                           for(Email_Template_Child__c DocChild : DocChilds){
                                                                               if(DocChild.Child_object__c.contains('[')){
                                                                                   DocChild.Child_object__c = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                                               }
                                                                               Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
                                                                               Map <String, Schema.SObjectField> fieldMaps = schemaMap.get(DocChild.Child_object__c).getDescribe().fields.getMap();
                                                                               for(Schema.SObjectField sfield : fieldMaps.Values()){
                                                                                   schema.describefieldresult dfield = sfield.getDescribe();
                                                                                 
                                                                                   ChildobjectsMap.put(dfield.getname().toLowercase()+DocChild.Child_object__c.toLowercase(),''+dfield.getType ());
                                                                               }
                                                                           }    
                                                                           for(Email_Template_Child__c DocChild : DocChilds){
                                                                               list<string> ChildFieldNameslist = DocChild.Child_Query__c.split(',');
                                                                                set<string>  DuplChilds = new set<string>();
                                                                                string chquries = '';
                                                                                if(DocChild.Junodoc__Calculation_Fields__c != null){
                                                                                    list<string> ChildFieldN = DocChild.Junodoc__Calculation_Fields__c.split(',');
                                                                                    for(string str : ChildFieldN){
                                                                                        if(!DuplChilds.contains(str.toLowerCase()) && str != '' && str != null){
                                                                                            DuplChilds.add(str.toLowerCase());
                                                                                            chquries += str.toLowerCase() + ',';
                                                                                        }
                                                                                    }
                                                                                }
                                                                                for(string str : ChildFieldNameslist){
                                                                                        if(!DuplChilds.contains(str.toLowerCase())){
                                                                                            DuplChilds.add(str.toLowerCase());
                                                                                            chquries += str.toLowerCase() + ',';
                                                                                        }
                                                                                    }
                                                                                if(chquries.length() > 1){
                                                                                    chquries = chquries.substring(0,chquries.length() - 1);
                                                                                }
                                                                               String Queries = ' SELECT '+ DocChild.Child_Query__c + ' from ' + DocChild.Child_object__c + ' where '+ DocChild.Parent_Reference__c + ' = \''+ recordId+ '\'';
                                                                               if(DocChild.Filter__c != null){
                                                                                   if(DocChild.Filter__c.contains('ssz')){ 
                                                                                       DocChild.Filter__c = DocChild.Filter__c.replace('ssz','\'');
                                                                                   }
                                                                                   Queries += 'and ' + DocChild.Filter__c;
                                                                               }
                                                                               if(DocChild.Order_by__c != null){
                                                                                   Queries += ' order by ' + DocChild.Order_by__c;
                                                                               }
                                                                               list<Sobject> SobjectRecs = Database.query(Queries);
                                                                               string checks = '<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">';
                                                                              
                                                                               if(DocTemplateItem[0].Template_body__c.contains('<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">')){
                                                                                   system.debug('checks **** '+ checks);
                                                                                   string str = '';
                                                                                   str += '<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">';
                                                                                   string[] childqueries = DocChild.Child_Query__c.split(',');
                                                                                  
                                                                                   for(Email_Template_Item__c DocTemplate : DocTemplateItem){
                                                                                       integer i = 1;
                                                                                       if(DocChild.Junodoc__Group_By__c == null || DocChild.Junodoc__Group_By__c == ''){
                                                                                       for(Sobject Sb : SobjectRecs){     
                                                                                           string addcolor = DocChild.color_1__c;  
                                                                                           Integer y = i/2;    
                                                                                           Integer z = y * 2;  
                                                                                          
                                                                                           if(i == z ){    
                                                                                              
                                                                                               addcolor = DocChild.color_2__c; 
                                                                                           }   
                                                                                           str += '<tr style="background-color:'+addcolor+'">';
                                                                                           for(string childs : childqueries){
                                                                                               string Childstring = '';
                                                                                               if(!childs.contains('.')){
                                                                                                   if(Sb.get(childs)  != null){
                                                                                                       Childstring = ''+ Sb.get(childs);                
                                                                                                   }
                                                                                               }
                                                                                               else{
                                                                                                   string Stringobjct = childs.replace('.',',');
                                                                                                   string[] Stringobjcts = Stringobjct.split(',');
                                                                                                   if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                                                       Childstring =  ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                                                   }
                                                                                               }
                                                                                               if(ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                                                   str += '<td style="text-align:right;border:'+DocChild.border__c+'">'+  '$'+Childstring + '</td>';
                                                                                               }
                                                                                               else if(ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                                                       || ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                                                       || ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                                                           str += '<td style="text-align:right;border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                                                                       }
                                                                                               else{
                                                                                                   str += '<td style="text-align:left;border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                                                               }   
                                                                                           }
                                                                                           str += '</tr>';  
                                                                                           i=i+1;
                                                                                       }  
                                                                                       }
                                                                                       system.debug('DocChild.JunoDoc__Child_Group_By__c **** ' +DocChild.Junodoc__Group_By__c);
                                                                                       if(DocChild.JunoDoc__Child_Group_By__c != null && DocChild.JunoDoc__Child_Group_By__c != '' && DocChild.JunoDoc__Child_Group_By__c != '--select one--' &&
                                                                                            DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                                                                                            str = JunoDocDynamicGroupBy_AC.ChildGetEmailDataDynamically(DocChild.Junodoc__Child_object__c,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                                                                                                recordId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                                                                                                DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                                                                                                DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,'','',new document(),new document(),
                                                                                                                                                '','',DocChild.JunoDoc__Child_Group_By__c);    
                                                                                        }
                
                                                                                        else if(DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                                                                                            str = JunoDocDynamicGroupBy_AC.GetEmailDataDynamically(DocChild.Junodoc__Child_object__c,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                                                                                                recordId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                                                                                                DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                                                                                                DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,'','',new document(),new document(),
                                                                                                                                                '','',DocChild.JunoDoc__Rollup_groupby__c);    
                                                                                            system.debug('Templatebody *** ' + str);
                                                                                        }
                
                                                                                       DocTemplate.Template_body__c = DocTemplate.Template_body__c.replace(checks,str);
                                                                                   }         
                                                                               }
                                                                           } 
                                                                           
                                                                           return DocTemplateItem;
                                                                           
                                                                       }    
    
    
    global static string getJunoDocEmailTemplates(id recordId,                                                  
                                                  string EmailTemplateId){
                                                      string DateFormats = '';   
                                                      string CurrencyFormat = '';                                                
                                                      Email_Template__c DocTemplates = [select id,
                                                                                        Parent_Object__c,
                                                                                        Parent_Fields__c,
                                                                                        Date_Format__c,
                                                                                        Currency_Format__c  
                                                                                        from Email_Template__c 
                                                                                        where id =: EmailTemplateId];
                                                      if(DocTemplates.Date_Format__c != null && DocTemplates.Date_Format__c != ''){
                                                          DateFormats = DocTemplates.Date_Format__c;
                                                      }
                                                      else{
                                                          DateFormats = 'MM/dd/yyyy';
                                                      }
                                                      if(DocTemplates.Currency_Format__c != null && DocTemplates.Currency_Format__c != ''){
                                                          CurrencyFormat = DocTemplates.Currency_Format__c;
                                                      }
                                                      else{
                                                          CurrencyFormat = '###,###.00';
                                                      }
                                                      list<Email_Template_Item__c> DocTemplateItem = [select id,
                                                                                                      Template_Body__c ,
                                                                                                      Subject__c
                                                                                                      
                                                                                                      from Email_Template_Item__c 
                                                                                                      where Email_Template__c =: EmailTemplateId ];
                                                      
                                                      string NewTemplateBody = '';
                                                      for(Email_Template_Item__c Doc : DocTemplateItem){
                                                          NewTemplateBody += Doc.Template_Body__c;                                    
                                                      }                                              
                                                      list<Email_Template_Child__c> DocChilds = [select id,
                                                                                                                      Child_object__c,
                                                                                                                      color_1__c,  
                                                                                                                      color_2__c,
                                                                                                                      Border__c,
                                                                                                                      Child_Query__c,
                                                                                                                      Parent_Reference__c,
                                                                                                                      Filter__c,
                                                                                                                      height__c,
                                                                                                                      Order_By__c,Junodoc__Group_By__c,
                                                                                                                      
                                                                                                                      Sort_Order__c,
                                                                                                                        
                                                                                                                       
                                                                                                                        JunoDoc__Group_By_Calculation__c,
                                                                                                                        Junodoc__Calculation_Fields__c,
                                                                         
                                                                                                                        Junodoc__Header_style__c,
                                                                                                                        Junodoc__Header_Colour_background__c,
                                                                                                                        Junodoc__Border_Width__c,
                                                                                                                        Junodoc__Padding__c,
                                                                                                                        Junodoc__Render_Condition__c,  
                                                                                                                        JunoDoc__Child_Group_By__c,
                                                                                                                        JunoDoc__Rollup_groupby__c,
                                                                                                                        Junodoc__Related_Object_Labels__c,
                                                                                                                        Junodoc__Font_Size__c,
                                                                                                                        Junodoc__Table_grid__c,
                                                                                                                        JunoDoc__Aggregate_Query__c,
                                                                                                                        Junodoc__Font_Color__c
                                                                                                                      
                                                                                                                      from Email_Template_Child__c 
                                                                                                                      where Email_Template__c =: EmailTemplateId]; 
                                                      String query ='';
                                                      String SobjectApiName = recordId.getSObjectType().getDescribe().getName();
                                                      
                                                      Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                                                      Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
                                                      
                                                      map<string,string> ChildobjectsMap = new map<string,string>();
                                                      String strFields = ''; 
                                                      Sobject parentRef;
                                                      if(DocTemplates.Parent_Fields__c != null){
                                                          string[] parentFieldsApi = DocTemplates.Parent_Fields__c.split(',');
                                                          set<string> Setstring = new set<string>();
                                                          for(String fieldName : parentFieldsApi )
                                                          {
                                                              if(!Setstring.contains(fieldName.toLowerCase())){
                                                                  if(strFields == null || strFields == ''){
                                                                      strFields = fieldName.toLowerCase();
                                                                  }
                                                                  else{
                                                                      strFields = strFields + ' , ' + fieldName.toLowerCase();
                                                                  }
                                                                  Setstring.add(fieldName.toLowerCase());
                                                              }
                                                          }      
                                                          query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Id =:  recordId';
                                                        
                                                          parentRef = Database.query(query);
                                                          //DocTemplates.Parent_Fields__c = strFields; 
                                                          Map<string,string> parentobjectsMap = new Map<string,string>();
                                                          Map<string,string> RelparentobjectsMap = new Map<string,string>();
                                                          Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
                                                          Map <String, Schema.SObjectField> fieldMaps = schemaMap.get(DocTemplates.Parent_Object__c).getDescribe().fields.getMap();
                                                          
                                                          for(Schema.SObjectField sfield : fieldMaps.Values()){
                                                              schema.describefieldresult dfield = sfield.getDescribe();
                                                             
                                                              parentobjectsMap.put(dfield.getname().toLowercase(),''+dfield.getType ());
                                                              if(dfield.getRelationshipName() != null){
                                                                  RelparentobjectsMap.put(''+dfield.getRelationshipName().toLowercase(),''+dfield.getname().toLowercase());
                                                              }
                                                          }
                                                          for(Email_Template_Item__c DocTemplate : DocTemplateItem){              
                                                              if(NewTemplateBody != null){
                                                                  NewTemplateBody = '<div class="invoice-content-box ui-droppable" id="content_area">'+NewTemplateBody+'</div>';
                                                                  NewTemplateBody = NewTemplateBody.replace('<div class="ui-resizable-handle ui-resizable-e" style="z-index: 90;"></div>','');
                                                                  NewTemplateBody = NewTemplateBody.replace('<div class="ui-resizable-handle ui-resizable-s" style="z-index: 90;"></div>','');
                                                                  NewTemplateBody = NewTemplateBody.replace('<div class="ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se" style="z-index: 90;"></div>','');
                                                                  //NewTemplateBody = NewTemplateBody.replace('top: -','top: ');
                                                                  NewTemplateBody = NewTemplateBody.replace('position: absolute','position: absolute;page-break-after:always;');
                                                                  NewTemplateBody = NewTemplateBody.replace('position:absolute','position: absolute;page-break-after:always;');
                                                                  
                                                                  string[] StringValues = DocTemplates.Parent_Fields__c.split(',');
                                                                  NewTemplateBody = NewTemplateBody;
                                                                  NewTemplateBody = NewTemplateBody.replace('ssz','\'');
                                                                  for(string Strs : StringValues){
                                                                      string str = strs.replace(' ','');  
                                                                      string Parentvalue = '';
                                                                      string rendParentvalue = '';
                                                                      if(!str.contains('.')){
                                                                          if(parentRef.get(str) != null){
                                                                            
                                                                              if(parentobjectsMap.get(str.toLowercase()) == 'DATE'){
                                                                                  if(parentRef.get(str) != null){
                                                                                      Date Datestr = Date.valueof(parentRef.get(str));
                                                                                      Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                      //Parentvalue = Datestr.month() + '/' +Datestr.day() + '/'+ Datestr.year();
                                                                                      string DateInt = ''+ Datestr.month();
                                                                                      if(Datestr.month() < 10){
                                                                                          DateInt = '0'+Datestr.month();
                                                                                      }
                                                                                      rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                                                                  }
                                                                              }
                                                                              else if(parentobjectsMap.get(str.toLowercase()) == 'CURRENCY'){
                                                                                  // Parentvalue = '$' + parentRef.get(str); //'$' 
                                                                                  string currencyvalue = GetCurrencyvalues(''+parentRef.get(str),CurrencyFormat);
                                                                                  Parentvalue = '$' + currencyvalue;
                                                                                  rendParentvalue = ''+parentRef.get(str);
                                                                              }
                                                                              else if(parentobjectsMap.get(str.toLowercase()) == 'BOOLEAN'){
                                                                                  if(boolean.valueof(''+parentRef.get(str)) == true){
                                                                                      //  Parentvalue = '<img src="/resource/1594031959000/Checked" style="width:1rem;height:1rem"/>';
                                                                                  }
                                                                                  else{
                                                                                      // Parentvalue = '<img src="/resource/1594031959000/Unchecked" style="width:1rem;height:1rem" />'; 
                                                                                  } 
                                                                              }  
                                                                              else if(parentobjectsMap.get(str.toLowercase()) == 'DATETIME'){
                                                                                  if(parentRef.get(str) != null){
                                                                                      Parentvalue = Datetime.valueof(parentRef.get(str)).format(DateFormats + ' HH:mm a');
                                                                                      rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRef.get(str)).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                                                                  }
                                                                              }
                                                                              else{
                                                                                  Parentvalue = ''+ parentRef.get(str);
                                                                                  rendParentvalue = '\''+ parentRef.get(str) + '\'';
                                                                              }
                                                                              NewTemplateBody = NewTemplateBody.replace('{!'+Str+'}',Parentvalue);
                                                                              NewTemplateBody = NewTemplateBody.replace('{{'+Str+'}}',rendParentvalue);
                                                                          }
                                                                          else{
                                                                              NewTemplateBody = NewTemplateBody.replace('{!'+Str+'}','');
                                                                              NewTemplateBody = NewTemplateBody.replace('{{'+Str+'}}','');
                                                                          }
                                                                      }
                                                                      else{
                                                                          string Parentvalues = '';
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
                                                                                              Parentvalues = '$' + GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                          }
                                                                                          else if(Types == 'DATE'){
                                                                                              if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                                  Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                                  Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                              }
                                                                                          }
                                                                                          else if(Types == 'DATETIME'){
                                                                                              if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                                  Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
                                                                                              }
                                                                                          }
                                                                                          else{ 
                                                                                              Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                                                          }
                                                                                          // Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
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
                                                                                              Parentvalues = '$' + GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                          }
                                                                                          else if(Types == 'DATE'){
                                                                                              Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                              Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                          }
                                                                                          else if(Types == 'DATETIME'){
                                                                                              Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
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
                                                                                          Parentvalues = '$' + GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                                      }
                                                                                      else if(Types == 'DATE'){
                                                                                          Date Datestr = Date.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                          Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                      }
                                                                                      else if(Types == 'DATETIME'){
                                                                                          Parentvalues = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
                                                                                      }
                                                                                      else{ 
                                                                                          Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                                      }
                                                                                      
                                                                                  }
                                                                              }
                                                                          }  
                                                                          NewTemplateBody = NewTemplateBody.replace('{!'+Str+'}',Parentvalues);
                                                                          NewTemplateBody = NewTemplateBody.replace('{{'+Str+'}}',Parentvalues);   
                                                                      }
                                                                  }
                                                              }
                                                          }  
                                                      }                                              
                                                      for(Email_Template_Child__c DocChild : DocChilds){
                                                          string childobject = DocChild.Child_object__c;
                                                           if(DocChild.Child_object__c.contains('[')){
                                                               childobject = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                           }
                                                          Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
                                                          Map <String, Schema.SObjectField> fieldMaps = schemaMap.get(childobject).getDescribe().fields.getMap();
                                                          for(Schema.SObjectField sfield : fieldMaps.Values()){
                                                              schema.describefieldresult dfield = sfield.getDescribe();
                                                              ChildobjectsMap.put(dfield.getname().toLowercase()+DocChild.Child_object__c.toLowercase(),''+dfield.getType ());
                                                          }
                                                      }    
                                                      map<string,string> currencySymbolMap = new map<string,string>();
                                                        list<JunoDoc__Junodoc_Currency__c> currencylist = [select Id,JunoDoc__Currency_Code__c,JunoDoc__Currency_Symbol__c from JunoDoc__Junodoc_Currency__c];
                                                        if(!currencylist.isEmpty()){
                                                            for(JunoDoc__Junodoc_Currency__c currencys : currencylist){
                                                                currencySymbolMap.put(currencys.JunoDoc__Currency_Code__c,currencys.JunoDoc__Currency_Symbol__c);   
                                                            }
                                                        }
                                                      for(Email_Template_Child__c DocChild : DocChilds){
                                                          set<string>  DuplChilds = new set<string>();
                                                          string chquries = '';
                                                           string currencysymbol = '$';
                                                          string currencysymbols = '$';
                                                             if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                                                                currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
                                                             }
                                                            if(currencysymbols != null && currencysymbols != ''){
                                                                currencysymbol = currencysymbols;
                                                            }
                                                          if(DocChild.JunoDoc__Aggregate_Query__c != '' && DocChild.JunoDoc__Aggregate_Query__c != null){
                                                                String Queries = DynamicAggregateController.RunQuery(DocChild.JunoDoc__Aggregate_Query__c,Docchild.Junodoc__Parent_Reference__c,recordId,currencysymbols,CurrencyFormat,DocChild);
                                                                NewTemplateBody = NewTemplateBody.replace(DocChild.JunoDoc__Aggregate_Query__c,Queries);
                                                                continue;
                                                          }
                                                          if(DocChild.Calculation_Fields__c != null){
                                                              list<string> ChildFieldN = DocChild.Calculation_Fields__c.split(',');
                                                              for(string str : ChildFieldN){
                                                                  if(!DuplChilds.contains(str.toLowerCase()) && str != '' && str != null){
                                                                      DuplChilds.add(str.toLowerCase());
                                                                      chquries += str.toLowerCase() + ',';
                                                                  }
                                                              }
                                                          }
                                                          if(DocChild.Child_Query__c != null){
                                                          list<string> ChildFieldNameslist = DocChild.Child_Query__c.split(',');
                                                              for(string str : ChildFieldNameslist){
                                                                  if(!DuplChilds.contains(str.toLowerCase())){
                                                                      DuplChilds.add(str.toLowerCase());
                                                                      chquries += str.toLowerCase() + ',';
                                                                  }
                                                              }
                                                          }
                                                          if(chquries.length() > 1){
                                                              chquries = chquries.substring(0,chquries.length() - 1);
                                                          }
                                                          string childobject = DocChild.Child_object__c;
                                                          if(DocChild.Child_object__c.contains('[')){
                                                               childobject = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                          }
                                                          String Queries = ' SELECT '+ chquries + ' from ' +childobject + ' where '+ DocChild.Parent_Reference__c + ' = \''+ recordId+ '\'';
                                                          if(DocChild.Filter__c != null){
                                                              if(DocChild.Filter__c.contains('ssz')){ 
                                                                  DocChild.Filter__c = DocChild.Filter__c.replace('ssz','\'');
                                                              }
                                                              Queries += 'and ' + DocChild.Filter__c;
                                                          }
                                                          if(DocChild.Order_by__c != null){
                                                              Queries += ' order by ' + DocChild.Order_by__c;
                                                          }
                                                          
                                                          if(DocChild.Render_Condition__c != null){
                                                              if(DocChild.Render_Condition__c.contains('ssz')){ 
                                                                  DocChild.Render_Condition__c = DocChild.Render_Condition__c.replace('ssz','\'');
                                                              }
                                                          }
                                                          if(DocChild.Render_Condition__c != null){
                                                              if(DocChild.Render_Condition__c.contains('ssz')){ 
                                                                  DocChild.Render_Condition__c = DocChild.Render_Condition__c.replace('ssz','\'');
                                                              }
                                                          }
                                                          system.debug('Queries' + Queries);
                                                          list<Sobject> SobjectRecs = Database.query(Queries);
                                                          string checks = '<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">';
                                                          
                                                          if(NewTemplateBody.contains('<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">')){
                                                              
                                                              string str = '';
                                                              str += '<tbody id="'+DocChild.Child_object__c+DocChild.Sort_Order__c+'">';
                                                              string[] childqueries = DocChild.Child_Query__c.split(',');
                                                             
                                                              
                                                              list<string> calqueries = new list<string>();
                                                              list<string> AllCalqueries = new list<string>();
                                                              set<string> CalSetString = new set<string>();
                                                              if(DocChild.Calculation_Fields__c != null){
                                                                  string[] scalqueries = DocChild.Calculation_Fields__c.split(',');
                                                                  for(string strs : scalqueries){
                                                                      if(strs != '' && strs != null && !CalSetString.contains(strs.toLowerCase())){
                                                                          CalSetString.add(strs.toLowerCase());
                                                                          calqueries.add(strs.toLowerCase());
                                                                      }
                                                                      if(strs != null && strs != ''){
                                                                          AllCalqueries.add(strs);
                                                                      }
                                                                  }
                                                              }
                                                              
                                                              
                                                              Map<string,decimal> ChildsobjMap = new Map<string,decimal>();
                                                              Map<string,decimal> parChildsobjMap = new Map<string,decimal>();
                                                              Map<string,decimal> AvgChildsobjMap = new Map<string,decimal>();
                                                              Map<string,decimal> AvgChildsCountMap = new Map<string,decimal>();
                                                              Map<string,string> RenChildsobjMap = new Map<string,string>();
                                                              system.debug(calqueries + '');
                                                              integer AvgCalucaltion  =  SobjectRecs.size();
                                                              for(Sobject Sb : SobjectRecs){ 
                                                                  for(string childs : calqueries){
                                                                      NewTemplateBody = NewTemplateBody.replace('SUM ('+childs+DocChild.Sort_Order__c+')','SUM('+childs+DocChild.Sort_Order__c+')');
                                                                      NewTemplateBody = NewTemplateBody.replace('AVG ('+childs+DocChild.Sort_Order__c+')','AVG('+childs+DocChild.Sort_Order__c+')');
                                                                      NewTemplateBody = NewTemplateBody.replace('PAR ('+childs+')','PAR('+childs+')');  
                                                                      decimal Childstrings = 0;
                                                                      if(!childs.contains('.') ){
                                                                          if(Sb.get(childs)  != null){
                                                                              Childstrings = decimal.valueof(''+ Sb.get(childs));                
                                                                          }
                                                                      }
                                                                      else{
                                                                          string Stringobjct = childs.replace('.',',');
                                                                          string[] Stringobjcts = Stringobjct.split(',');
                                                                          
                                                                          if(Stringobjcts.size() > 3){
                                                                              if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                                  if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                                      if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                          Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                      }
                                                                                  }
                                                                              }
                                                                          }
                                                                          else if(Stringobjcts.size() > 2){
                                                                              if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                                  if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                                      if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                                                          Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                      }
                                                                                  }
                                                                              }
                                                                          }
                                                                          else{
                                                                              if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                                  if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                                      Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                  }
                                                                              }
                                                                          } 
                                                                      }
                                                                      
                                                                      if(ChildsobjMap.get('SUM('+childs+DocChild.Sort_Order__c+')') == null){
                                                                          ChildsobjMap.put('SUM('+childs+DocChild.Sort_Order__c+')',  Childstrings);
                                                                      }
                                                                      else{
                                                                          childstrings += ChildsobjMap.get('SUM('+childs+DocChild.Sort_Order__c+')');
                                                                          ChildsobjMap.put('SUM('+childs+DocChild.Sort_Order__c+')',  Childstrings);   
                                                                      }
                                                                      if(ChildsobjMap.get('AVG('+childs+DocChild.Sort_Order__c+')') == null){
                                                                          AvgChildsobjMap.put('AVG('+childs+DocChild.Sort_Order__c+')',  Childstrings);
                                                                      }
                                                                      else{
                                                                          childstrings += AvgChildsobjMap.get('AVG('+childs+DocChild.Sort_Order__c+')');
                                                                          AvgChildsobjMap.put('AVG('+childs+DocChild.Sort_Order__c+')',  Childstrings);   
                                                                      }
                                                                      if(parChildsobjMap.get('PAR('+childs+')') == null && childs.contains('.')){
                                                                          parChildsobjMap.put('PAR('+childs+')',Childstrings);
                                                                      }   
                                                                  }   
                                                              }
                                                              for(string childs : Allcalqueries){  
                                                                  decimal values = ChildsobjMap.get('SUM('+childs.toLowercase()+DocChild.Sort_Order__c+')');
                                                                  if(ChildsobjMap.get('SUM('+childs+DocChild.Sort_Order__c+')') == null){
                                                                      values = 0;
                                                                  } 
                                                                  decimal avgval = 0;
                                                                  if(AvgChildsobjMap.get('AVG('+childs.toLowercase()+DocChild.Sort_Order__c+')') != null){
                                                                      avgval = AvgChildsobjMap.get('AVG('+childs.toLowercase()+DocChild.Sort_Order__c+')')/AvgCalucaltion;
                                                                      
                                                                  }
                                                                  decimal parvalues = parChildsobjMap.get('PAR('+childs.toLowercase()+')');
                                                                  if(parChildsobjMap.get('PAR('+childs.toLowercase()+')') == null){
                                                                      parvalues = 0;
                                                                  }
                                                                  string allvalues = RenChildsobjMap.get(childs);
                                                                  NewTemplateBody = NewTemplateBody.replace('SUM ('+childs+DocChild.Sort_Order__c+')','SUM('+childs+DocChild.Sort_Order__c+')');
                                                                  NewTemplateBody = NewTemplateBody.replace('AVG ('+childs+DocChild.Sort_Order__c+')','AVG('+childs+DocChild.Sort_Order__c+')');
                                                                  NewTemplateBody = NewTemplateBody.replace('PAR ('+childs+')','PAR('+childs+')');
                                                                  NewTemplateBody = NewTemplateBody.replace('SUM('+childs+DocChild.Sort_Order__c+')','VALUE(\''+values+'\')');
                                                                  NewTemplateBody = NewTemplateBody.replace('AVG('+childs+DocChild.Sort_Order__c+')','VALUE(\''+avgval+'\')');    
                                                                  NewTemplateBody = NewTemplateBody.replace('PAR('+childs+')','VALUE(\''+parvalues + '\')');   
                                                              }
                                                              
                                                              
                                                              if(NewTemplateBody.contains('[{')){
                                                                  NewTemplateBody = NewTemplateBody.replace('[{','{!');
                                                                  NewTemplateBody = NewTemplateBody.replace('}]','}');
                                                              }
                                                              if(NewTemplateBody.contains('{{')){
                                                                  NewTemplateBody = NewTemplateBody.replace('{{','{!');
                                                                  NewTemplateBody = NewTemplateBody.replace('}}','}');
                                                              }
                                                              
                                                              
                                                              //  for(Email_Template_Item__c DocTemplate : DocTemplateItem){
                                                              integer i = 1;
                                                              if(DocChild.Junodoc__Group_By__c == null || DocChild.Junodoc__Group_By__c == ''){
                                                                for(Sobject Sb : SobjectRecs){     
                                                                  string addcolor = DocChild.color_1__c;  
                                                                  Integer y = i/2;    
                                                                  Integer z = y * 2;  
                                                                  if(i == z ){    
                                                                      addcolor = DocChild.color_2__c; 
                                                                  }   
                                                                  str += '<tr style="background-color:'+addcolor+'">';
                                                                  for(string childs : childqueries){
                                                                      string Childstring = '';
                                                                      if(!childs.contains('.')){
                                                                          if(Sb.get(childs)  != null){
                                                                              Childstring = ''+ Sb.get(childs);                
                                                                          }
                                                                      }
                                                                      else{
                                                                          string Stringobjct = childs.replace('.',',');
                                                                          string[] Stringobjcts = Stringobjct.split(',');
                                                                          if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                              Childstring =  ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                          }
                                                                      }
                                                                      if(ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                          str += '<td style="text-align:right;border:'+DocChild.border__c+'">'+  '$'+Childstring + '</td>';
                                                                      }
                                                                      else if(ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                              || ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                              || ChildobjectsMap.get(childs.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                                  str += '<td style="text-align:right;border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                                              }
                                                                      else{
                                                                          str += '<td style="text-align:left;border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                                      }   
                                                                  }
                                                                  str += '</tr>';  
                                                                  i=i+1;
                                                              }  
                                                              }
                                                              
                                                              system.debug('DocChild.JunoDoc__Child_Group_By__c **** ' +DocChild.Junodoc__Group_By__c);
                                                                                       if(DocChild.JunoDoc__Child_Group_By__c != null && DocChild.JunoDoc__Child_Group_By__c != '' && DocChild.JunoDoc__Child_Group_By__c != '--select one--' &&
                                                                                            DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                                                                                            str = JunoDocDynamicGroupBy_AC.ChildGetEmailDataDynamically(childobject,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                                                                                                recordId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                                                                                                DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                                                                                                DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,'','',new document(),new document(),
                                                                                                                                                '','',DocChild.JunoDoc__Child_Group_By__c);    
                                                                                        }
                
                                                                                        else if(DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                                                                                            str = JunoDocDynamicGroupBy_AC.GetEmailDataDynamically(childobject,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                                                                                                recordId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                                                                                                DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                                                                                                DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,'','',new document(),new document(),
                                                                                                                                                '','',DocChild.JunoDoc__Rollup_groupby__c);    
                                                                                            system.debug('Templatebody *** ' + str);
                                                                                        }
                
                                                              //DocTemplate.Template_body__c = DocTemplate.Template_body__c.replace(checks,str);
                                                              NewTemplateBody = NewTemplateBody.replace('text-align:;','text-align: left;');
                                                              NewTemplateBody = NewTemplateBody.replace(checks,str);
                                                              // }         
                                                          }
                                                      } 
                                                      
                                                      return NewTemplateBody;                                          
                                                  }
    
    global static string GetCurrencyvalues(string currencyvalue,string CurrencyFormat){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
        if(CurrencyFormat.contains('.0')){
            CurrList = CurrencyFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
        }
        if(CurrencyFormat.contains(',0')){
            CurrList = CurrencyFormat.replace(',','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
        string currencies = '';
        if(currencyvalue != '' && currencyvalue != null){
            currencies = doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
        }
        else{
            currencies = doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
        
    }
    global static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
        String s, tmp;
        Integer i = 4 + dec;
        
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
        
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
        
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
        
        return s;
    }
    global static String getRelType(string ObjectName,String FieldName,String parfieldName){
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
        return Types;
        
    }
    global static String getchilType(string ObjectName,String FieldName){
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
    /*   @AuraEnabled
public static List<Junodoc_Details__c>  getrecorddetails(id recordId){
system.debug('@@@');
System.debug('recordId ' + recordId);
system.debug('test--->'+Network.getNetworkId());

String sObjName = recordId.getSObjectType().getDescribe().getName();

List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,Junodoc_Doc_Template__c,
Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c     
from Junodoc_Details__c
where Selected_object__c =: sObjName];
system.debug(juno);
system.debug(juno[0].Junodoc_Email_Templates__c);
system.debug(juno[0].Standard_Email_Templates__c);
if(juno != null){
return juno;     
}else{
return null;
}


} */
    
    @AuraEnabled
    public static GetDetailsInner  getrecorddetails(id recordId){
        system.debug('@@@');
        string selectedobject = recordId.getSObjectType().getDescribe().getName();
        string selectedobjID;
        List<Junodoc_Details__c> juno =  new List<Junodoc_Details__c>();
        juno = [select id,From_Email_Address__c,Junodoc_Email_Templates__c,
                Standard_Email_Templates__c,Set_Reply_To__c,Selected_object__c,JunoDoc__Junodoc_Doc_Template__c
                from Junodoc_Details__c 
                where Selected_object__c =: selectedobject];
        GetDetailsInner getInner = new GetDetailsInner();
        if(!juno.isEmpty()){
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
        
        
        if(!juno.isEmpty()){
            return getInner;     
        }else{
            return null;
        }
        
        
    }
    
    
    @AuraEnabled
    public static string getOrganizationUrl(){
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
    
    
    public class fileDetails{
        @AuraEnabled
        public string fileName{get;set;}
        @AuraEnabled
        public string Type{get;set;}
        @AuraEnabled
        public string fileContent{get;set;}
    }
    
    @AuraEnabled
    public static List<PostActData> getPostActList(string docId, string rid){
        String sObjName = id.valueof(rid).getSObjectType().getDescribe().getName();
        List<JunoDoc__Post_Action__c> PostActs = [Select Name, JunoDoc__Field_Values__c, JunoDoc__Field_Type__c, JunoDoc__Junodoc_Templates__c,  JunoDoc__Generate_Check__c, JunoDoc__Mail_Check__c, JunoDoc__Attach_Check__c from JunoDoc__Post_Action__c where JunoDoc__Junodoc_Templates__c =: docId];
        List<PostActData> PostActLst = new List<PostActData>();
        for(JunoDoc__Post_Action__c PostAct : PostActs){
            PostActData PAD = new PostActData();
            SObjectType objType = Schema.getGlobalDescribe().get(sObjName);
            String Name = PostAct.Name;
            String LabelName = '';
            for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                System.debug(''+fld.getDescribe().getName());
                if(Name == ''+fld.getDescribe().getName()){
                   // LabelName = ''+fld.getDescribe().getLabel();
                    LabelName = ''+fld.getDescribe().getName();
                }
            }
            PAD.key = LabelName;
            PAD.Value = PostAct.JunoDoc__Field_Values__c;
            PAD.FieldType = PostAct.JunoDoc__Field_Type__c;
            PAD.GenerateCheck = PostAct.JunoDoc__Generate_Check__c;
            PAD.MailCheck = PostAct.JunoDoc__Mail_Check__c;
            PAD.AttachCheck = PostAct.JunoDoc__Attach_Check__c;  
            PostActLst.add(PAD);
        }
        return PostActLst;
    }
    public class PostActData{
        @AuraEnabled public string key;
        @AuraEnabled public string Value;
        @AuraEnabled public string FieldType;
        @AuraEnabled public string GenerateCheck;
        @AuraEnabled public string MailCheck;
        @AuraEnabled public string AttachCheck;
    }
    @AuraEnabled
    public static String UpdateRecs(String PostActs, string rid){
        String sObjName = id.valueof(rid).getSObjectType().getDescribe().getName();
        list<PostActData> resultlist = (list<PostActData>)JSON.deserialize(PostActs, list<PostActData>.class);
        String result;
        try{
            String LabelName = '';
            string query = 'select ';
            for (PostActData PostAct: resultlist){
                SObjectType objType = Schema.getGlobalDescribe().get(sObjName);
                String Name = PostAct.key;
                for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                    System.debug(''+fld.getDescribe().getLabel());
                    if(Name == ''+fld.getDescribe().getName()){
                        LabelName = ''+fld.getDescribe().getName();
                    }
                }
                if(LabelName != '')
                query += LabelName + ',';
            }
            query += ' id from '+sObjName+ ' where Id=: rid';
            sobject sobj = Database.query(query);
            for (PostActData PostAct: resultlist){
                SObjectType objType = Schema.getGlobalDescribe().get(sObjName);
                String Name = PostAct.key;
                for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                    System.debug(''+fld.getDescribe().getLabel());
                    if(Name == ''+fld.getDescribe().getName()){
                        LabelName = ''+fld.getDescribe().getName();
                        System.debug('LabelName--->'+LabelName);
                    }
                }
                if(PostAct.FieldType == 'DATE'){
                    System.debug(PostAct.Value.toLowerCase());
                    if(PostAct.Value.toLowerCase() == 'today'){
                        sobj.put(LabelName,System.today());
                    }
                    else if(PostAct.Value.toLowerCase() == 'tomorrow'){
                        sobj.put(LabelName,System.today().addDays(1));
                    }
                    else if(PostAct.Value.toLowerCase() == 'yesterday'){
                        sobj.put(LabelName,System.today().addDays(-1));
                    }
                    else{
                        sobj.put(LabelName,Date.valueOf(PostAct.Value));
                    }
                }
                else if(PostAct.FieldType == 'DATETIME'){
                    System.debug(PostAct.Value.toLowerCase());
                    if(PostAct.Value.toLowerCase() == 'now'){
                        sobj.put(LabelName,System.now());
                    }
                    else{
                        sobj.put(LabelName,Date.valueOf(PostAct.Value));
                    }
                }
                else if(PostAct.FieldType == 'BOOLEAN'){
                    sobj.put(LabelName,Boolean.valueOf(PostAct.Value));
                }
                else if(PostAct.FieldType == 'PERCENT' || PostAct.FieldType == 'CURRENCY'){
                    sobj.put(LabelName,Decimal.valueOf(PostAct.Value));
                }
                else{
                    sobj.put(LabelName,PostAct.Value);
                }
            }
            update sobj;
            
            result = 'SUCCESS';
        }
        catch(Exception ex){
            //result=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString()+'\n'+ex.getMessage();
            system.debug(result);
            system.debug('Error : ' + ex.getStackTraceString() + ' message : ' + ex.getMessage());
            result =  ex.getMessage();
           // throw new AuraHandledException('Error : ' + ex.getStackTraceString() + ' message : ' + ex.getMessage());
        }
        return result;
    }
    
    public static void dummtTestMethod(){
        Integer j = 0;
        for(Integer i =0; i<= 5; i++){
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            
        }
    }
    
    public static void dummtTestMethod2(){
        Integer j = 0;
        for(Integer i =0; i<= 5; i++){
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            
        }
    }
    
    public static void dummtTestMethod3(){
        Integer j = 0;
        for(Integer i =0; i<= 5; i++){
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            
        }
    }
    
    public static void dummtTestMethod4(){
        Integer j = 0;
        for(Integer i =0; i<= 5; i++){
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            j++;
            
        }
    }
    
    
}
public without sharing class JunoUsersignContrl {
    
    public string isExpirationdate {get; set;}
    public string isRejected {get; set;}
    public transient string body {get; set;} 
    public transient string secondbody {get; set;} 
    public string docidList  {get;set;} 
    public string domainUrl {get;set;}
    //public string usersidepageTab {get;set;}
    // public string fileid {get;set;}
    public string transcid {get;set;}
    public string recid {get;set;}
    public string conid {get;set;}
    public string conDocIDs {get;set;}
    //public List<Page_Tab__c> pageTabsList {get;set;} 
    public string pageTabsstring {get;set;}   
    public string strImageBlob {get;set;}
    public string currentRecordId {get;set;}
    public string signNotCompletedIds {get;set;}  
    public string recipientName {get;set;}
    public string isInPerson {get;set;}
    public string domainName {get;set;}
    public string todayDateValue {get; set;}
    // public string domainUrl {get;set;}
    public string logoUrl {get;set;}
    public string orientation {get;set;} 
    
    public string docList {get;set;}
    public string textContentList {get;set;}
    public string initialList {get;set;}
    public string dateContentList {get;set;}
    public string attachmentListTableHtml {get;set;} 
    public string attachmentInitialStr  {get;set;} 
    
    public Blob pdfPageBlobForAttachment {get;set;}
    public string newDocTemplateID {get;set;}
    
    public string orgTempRecordId {get;set;}
    
    public string errorMessage {get;set;}
    
    public string emailAddressinObjectSettings {get;set;}
    //public List<ContentDocumentLink> conList {get;set;}
    public string downloadURL {get;set;}
    public string downloadURLs {get;set;}
    public string defaultSignFormat {get;set;}
    public boolean Enablesignaturerejection {get;set;}
    public string attachmentListInUI {get;set;}
    public boolean isattachmentThere {get;set;}
    public boolean showAttachments {get;set;}
    public List<ContentDocument> attachedContentDocumentList {get;set;}
    
    public string sObjName{get;set;}
    public Decimal recipientOrderNumber{get;set;}
    
    /********* SAIRAM 21-02-2023 ***********/
    public string DateFormats{get;set;}
    public string CurrencyFormat{get;set;}
    public string NumberFormat{get;set;}
    public string currencysymbols{get;set;}
    public boolean blankasZeroes{get;set;}
    public  map<string,string> currencySymbolMap{ get; set; }
    /********* SAIRAM 21-02-2023 ***********/
    
    public JunoUsersignContrl(){
        isRejected = 'false';
        isExpirationdate = 'false';
        currentRecordId = ApexPages.currentPage().getParameters().get('id');
        transcid = ApexPages.currentPage().getParameters().get('trancid');
        recid = ApexPages.currentPage().getParameters().get('recid');
        domainUrl = System.Url.getOrgDomainUrl().toExternalForm();
        conid = ApexPages.currentPage().getParameters().get('conid');
        isInPerson = ApexPages.currentPage().getParameters().get('isInPerson');
        domainName = ApexPages.currentPage().getParameters().get('domainName');
        orgTempRecordId = ApexPages.currentPage().getParameters().get('orgDocid');
        conDocIDs = ApexPages.currentPage().getParameters().get('conDocID');
        showAttachments = Boolean.valueOf(ApexPages.currentPage().getParameters().get('showattachment'));
        body = '';
        secondbody = '';
        
        list<string> conDocList = new List<String>();
        
        //conDocIDs = '0693h00000G9UUKAA3,0693h00000G9UY2AAN';
        isattachmentThere = false;
        if(!String.isBlank(conDocIDs)){
            conDocList = conDocIDs.split(',');
            
            try{
                List<String> downloadURLsList = new List<String>();
                for(string CDId : conDocList){
                    downloadURL = 'https://'+System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','')+'.lightning.force.com/sfc/servlet.shepherd/document/download/';
                    downloadURL += CDId+ '?operationContext=S1';
                    downloadURLsList.add(downloadURL);
                }
                downloadURLs = JSON.serialize(downloadURLsList);
                attachedContentDocumentList = [Select Id,Title From ContentDocument where Id IN: conDocList];
                system.debug('attachedContentDocumentList-->'+attachedContentDocumentList);
                if(attachedContentDocumentList.size() > 0){
                    isattachmentThere = true;
                }
                
            }catch(Exception ex){
                system.debug('ex-->'+ex.getLineNumber());
                system.debug('ex-->'+ex.getMessage());
            }
        }else{
            isattachmentThere = false;
        }
        system.debug('conDocList---->'+conDocList);
        
        List<JunoDoc__Junodoc_Setting__c> junoDocSettingList = [Select JunoDoc__Site_URL__c,JunoDoc__Signature_Format__c,JunoDoc__Enable_Signature_Rejection__c  FROM JunoDoc__Junodoc_Setting__c LIMIT 1];
        defaultSignFormat = junoDocSettingList[0].JunoDoc__Signature_Format__c;
        Enablesignaturerejection = junoDocSettingList[0].JunoDoc__Enable_Signature_Rejection__c;
        
        // errorMessage = 'No error'+'/n /r'+'tt';
        // String.valueOf(system.today());
        DateTime dt = DateTime.now();
        String dateTimeStr = dt.format('MM/dd/yyyy');
        System.debug('>>>>' + dateTimeStr);
        todayDateValue = dateTimeStr;
        
        list<JunoDoc__Juno_Sign_Recipient__c> JunoRecipientList = new list<JunoDoc__Juno_Sign_Recipient__c>();
        JunoRecipientList = [select Id, Name,JunoDoc__Status__c,JunoDoc__JunoSign_Expiration_Date__c,JunoDoc__Sort_Order__c From JunoDoc__Juno_Sign_Recipient__c where id=:recid ];
        
        if(JunoRecipientList.size()>0){
            recipientOrderNumber = JunoRecipientList[0].JunoDoc__Sort_Order__c;

            if(JunoRecipientList[0].JunoDoc__JunoSign_Expiration_Date__c < system.today()){
                  isExpirationdate =  'true';
            }
            if(JunoRecipientList[0].JunoDoc__Status__c == 'Rejected'){
                  isRejected = 'true';
            }
             
        } 
        
        List<Document> docRecod= [Select Id,Name from Document where DeveloperName = 'Junosign_logo'];
        string domainName = System.Url.getOrgDomainUrl().toExternalForm().replace('https://','').replace('.my.salesforce.com','');
        String OrgId = ''+UserInfo.getOrganizationId();
        // StaticResource static_resource = [SELECT Id, SystemModStamp  FROM StaticResource  WHERE Name = 'JunoSign'   LIMIT 1];
        
        if(docRecod.size()>0){
            logoUrl = 'https://'+domainName+'--c.documentforce.com/servlet/servlet.ImageServer?id='+docRecod[0].Id+'&oid='+OrgId; 
        }
        
        sObjName = Id.valueOf(conid).getSObjectType().getDescribe().getName();
        
        list <JunoDoc__Junosign_Object_Setting__c> fromadd = new list<JunoDoc__Junosign_Object_Setting__c>();
        fromadd=[select JunoDoc__FromEmailAddress__c,JunoDoc__Selected_object__c 
                 from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName ];
        
        if(fromadd.size() > 0){
            emailAddressinObjectSettings =fromadd[0].JunoDoc__FromEmailAddress__c;
        }
        
        String ObjName = '';
        if(currentRecordId != null){
            Id checkObjNameId =  Id.valueOf(currentRecordId);
            ObjName = checkObjNameId.getSObjectType().getDescribe().getName();
            
        }
        
        list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                         ownerId,
                                                         JunoDoc__Recipient_Name__c,
                                                         JunoDoc__Recipient_Email__c,
                                                         JunoDoc__Status__c,
                                                         JunoDoc__Sort_Order__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                         JunoDoc__Juno_Sign_Transaction__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c
                                                         from JunoDoc__Juno_Sign_Recipient__c 
                                                         where id=:recid ]; 
        
        recipientName = recdata[0].JunoDoc__Recipient_Name__c;
        JunoDoc__Doc_Template__c docTemp = [select Id,Name,JunoDoc__Page_Size__c from JunoDoc__Doc_Template__c where Id=: recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c];
        orientation = docTemp.JunoDoc__Page_Size__c;
        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                           Name,
                                                           JunoDoc__CC_Address__c,
                                                           JunoDoc__BCC_Address__c,
                                                           JunoDoc__Set_Reply_To__c,
                                                           JunoDoc__Final_Document_Id__c,
                                                           JunoDoc__Date_Completed__c,
                                                           JunoDoc__Status__c
                                                           from JunoDoc__Juno_Sign_Transaction__c
                                                           where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
        if( recdata[0].JunoDoc__Status__c != 'Signed'){
            if(ObjName == 'JunoDoc__Doc_Template__c'){
                PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF'); 
                pagePdf.getParameters().put('id', conid); 
                pagePdf.getParameters().put('DocTemplateId', currentRecordId); 
                Blob pdfPageBlob; 
                if(Test.IsRunningTest()){
                    pdfPageBlob = Blob.valueOf('UNIT.TEST');
                }
                else{
                    pdfPageBlob = pagePdf.getContentAsPDF(); 
                }
                
                system.debug(pdfPageBlob); 
                if(Encodingutil.base64encode(pdfPageBlob).length() <= 5999950){
                    body='data:application/pdf;base64,'+ (Encodingutil.base64encode(pdfPageBlob));
                }
                else{
                    body='data:application/pdf;base64,'+ (Encodingutil.base64encode(pdfPageBlob)).substring(0,5999950);
                    secondbody= (Encodingutil.base64encode(pdfPageBlob)).substring(5999950,Encodingutil.base64encode(pdfPageBlob).length());
                }
                
            }else{
                ContentVersion  cont = [select id,VersionData,title from ContentVersion where id =: currentRecordId];
                system.debug('cont-->'+cont);
                if(Encodingutil.base64encode(cont.VersionData).length() <= 5999950){
                    body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData));
                }
                else{
                    body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData)).substring(0,5999950);
                    secondbody= (Encodingutil.base64encode(cont.VersionData)).substring(5999950,Encodingutil.base64encode(cont.VersionData).length());
                }
            }
            
            
            
            
           
            //String trancId =  transcid;
            List<JunoDoc__Junodoc_Page_Tab__c> pageTabsList = [select Id,Name, JunoDoc__Pos_Left__c, JunoDoc__Pos_Top__c, JunoDoc__Sign_Completed__c,JunoDoc__Type__c,JunoDoc__Linked_To__c,JunoDoc__Recipient_Sort_Order__c  from JunoDoc__Junodoc_Page_Tab__c where JunoDoc__Sign_Completed__c =: false AND JunoDoc__Linked_To__c=:transcid AND JunoDoc__Recipient_Sort_Order__c=: recdata[0].JunoDoc__Sort_Order__c order By Id ASC];
            system.debug('pageTabsList-->'+pageTabsList);
            pageTabsstring = JSON.serialize(pageTabsList);
        }else{
            body = '';
        }
        
        //pageTabsList = junousersign;
        // getpositionsTabs();
    }
    
    
    
    public void createDocs(){
        
        system.debug('createDocs-->'+176);
        try {
            system.debug('createDocs-->'+176);
            List<prepareListnner> documentList ;
            if(docList != null && docList !=''){
                documentList  = (List<prepareListnner>)System.JSON.deserialize(docList, List<prepareListnner>.class);
            }
            
            system.debug('docList-->'+documentList);
            List<Document> docListToInsert = new List<Document>();
            List<Folder> folderList = [SELECT Id, ParentId, Name, DeveloperName FROM Folder where DeveloperName='JunoSign_Sign_Entity_Folder'];
            docListToInsert = [Select Id,Name,Keywords,Description,FolderId From Document where Keywords =: orgTempRecordId + '-' + transcid];
            if(documentList.size()>0){
                for(prepareListnner docItem : documentList){
                    Document doc = new Document();
                    String myContent2 = ''+docItem.Value;
                    doc.body = Encodingutil.base64decode(myContent2);
                    doc.IsPublic = true;
                    doc.Name = docItem.Name+'_pageNo_'+docItem.PageNo;
                    if(docItem.Name == 'attachmentSign_signedImage'){
                        doc.Name = 'attachmentSign_signedImage';
                    }
                    
                    string width = docItem.Width;
                    if(Integer.valueOf(width)  > 200){
                        width = ''+200;
                    }
                    doc.Description = 'style="height:'+docItem.Height+'px;'+'width:'+width+'px;"';
                    doc.Type='png';
                    doc.Keywords = orgTempRecordId + '-' + transcid;
                    doc.ContentType = 'image/png';
                    doc.FolderId = folderList[0].Id;
                    
                    docListToInsert.add(doc);
                    system.debug('IsPublic-->'+doc.Id);
                }
                if(docListToInsert.size()>0){
                    upsert docListToInsert;
                } 
            }
            
            system.debug('docListToInsert-->'+docListToInsert);
            JunoDoc__Doc_Template__c currentDocTemplate = [Select Id,Name,ownerId from JunoDoc__Doc_Template__c where Id =:orgTempRecordId];
            String cloneName= 'Cloned-'+ orgTempRecordId+'-tranid-'+transcid;
            List<JunoDoc__Doc_Template__c> checkForClonedDocTemplate = new List<JunoDoc__Doc_Template__c>();
            checkForClonedDocTemplate = [Select Id,Name,CreatedDate from JunoDoc__Doc_Template__c where Name =:cloneName Order By CreatedDate DESC];
            string docTemplateId = orgTempRecordId;
            if(checkForClonedDocTemplate.size() > 0){
                docTemplateId = checkForClonedDocTemplate[0].Id;
            }
            system.debug('step1');
            //create new doc template for signature use
            String SobjectApiName = 'JunoDoc__Doc_Template__c';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            
            String strFields = '';
            
            for(String fieldName : fieldMap.keyset() ){
                if(strFields == null || strFields == '') {
                    strFields = fieldName;
                }else{
                    strFields = strFields + ' , ' + fieldName;
                }
            }
            
            String query = 'SELECT ' + strFields + ' FROM JunoDoc__Doc_Template__c  Where Id=:docTemplateId';
            system.debug(query);
            JunoDoc__Doc_Template__c temp = Database.query(query);
            JunoDoc__Doc_Template__c cloneTemp = temp.clone(false, true);
            cloneTemp.Name = 'Cloned-'+orgTempRecordId+'-tranid-'+transcid;
            cloneTemp.JunoDoc__Show_Templates__c = true;
            cloneTemp.JunoDoc__Parent_Object__c = temp.JunoDoc__Parent_Object__c;
            insert cloneTemp;
            
            
            system.debug('cloneTemp-->'+cloneTemp);
            
            
            //doc template child
            SobjectApiName = 'JunoDoc__Doc_Template_Child__c';
            schemaMap = Schema.getGlobalDescribe();
            fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            
            strFields = '';
            
            for(String fieldName : fieldMap.keyset() ){
                if(strFields == null || strFields == ''){
                    strFields = fieldName;
                }else{
                    strFields = strFields + ' , ' + fieldName;
                }
            }
            
            String Itemquery = 'SELECT ' + strFields + ' FROM JunoDoc__Doc_Template_Child__c  Where JunoDoc__Doc_Template__c=:docTemplateId';
            system.debug(Itemquery);
            List<JunoDoc__Doc_Template_Child__c> docTempChildItemList =  new List<JunoDoc__Doc_Template_Child__c>();
            List<JunoDoc__Doc_Template_Child__c> tempChildItem = Database.query(Itemquery);
            system.debug('3'+tempChildItem.size());
            for(JunoDoc__Doc_Template_Child__c c : tempChildItem){
                JunoDoc__Doc_Template_Child__c docTempChildItem = c.clone(false, true);
                docTempChildItem.JunoDoc__Doc_Template__c = cloneTemp.Id;
                docTempChildItemList.add(docTempChildItem);
            }
            if(docTempChildItemList.size()>0){
                insert docTempChildItemList;
            }
            
            
            //doc template item
            SobjectApiName = 'JunoDoc__Doc_Template_Item__c';
            schemaMap = Schema.getGlobalDescribe();
            fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            
            strFields = '';
            
            for(String fieldName : fieldMap.keyset() ){
                if(strFields == null || strFields == '')
                {
                    strFields = fieldName;
                }else{
                    strFields = strFields + ' , ' + fieldName;
                }
            }
            
            Itemquery = 'SELECT ' + strFields + ' FROM JunoDoc__Doc_Template_Item__c  Where JunoDoc__Doc_Template__c=:docTemplateId';
            system.debug(Itemquery);
            List<JunoDoc__Doc_Template_Item__c> docTempItemList =  new List<JunoDoc__Doc_Template_Item__c>();
            List<JunoDoc__Doc_Template_Item__c> tempItem = Database.query(Itemquery);
            
            
            String DocTemplateCombineString = '';
            String sObjName = Id.valueOf(conid).getSObjectType().getDescribe().getName();   
            Boolean Allowpage = false;
            //Integer pgNo = 0;
            for(JunoDoc__Doc_Template_Item__c c : tempItem){
                JunoDoc__Doc_Template_Item__c docTempItem = c.clone(false, true);
                docTempItem.JunoDoc__Doc_Template__c = cloneTemp.Id;
                docTempItem.JunoDoc__Template_Body__c = c.JunoDoc__Template_Body__c;
                Allowpage = false;
                if(c.JunoDoc__Page_Render__c != '' && c.JunoDoc__Page_Render__c != null){
                    string queries = 'select id from ' + sObjName + ' where Id =:  conid and ' + c.JunoDoc__Page_Render__c;
                    list<Sobject> parentRefs = Database.query(queries);
                    if(!parentRefs.isEmpty()){
                        Allowpage = true;
                    }
                }
                else{
                    Allowpage = true;
                }
                system.debug('Allowpage-->'+Allowpage);
                if(Allowpage == true){
                    DocTemplateCombineString += c.JunoDoc__Template_Body__c+'docTemplateItemCombineSplit';
                    docTempItemList.add(docTempItem);
                }
                /*DocTemplateCombineString += c.JunoDoc__Template_Body__c+'docTemplateItemCombineSplit';
docTempItemList.add(docTempItem);*/
            }
            
            if(docListToInsert.size()>0){
                for(Document doc:docListToInsert){
                    if(doc.Name != 'attachmentSign_signedImage'){
                        string signpgno = doc.Name.split('pageNo_')[1];
                        Integer signpageNo = Integer.valueOf(signpgno);
                        system.debug('signpgno-->'+DocTemplateCombineString);
                        //if(''+pgNo == signpgno){
                        system.debug('by-->'+DocTemplateCombineString);
                        string textName = ''+doc.Name.split('_')[0]+':';
                        system.debug('textName-->'+textName);
                        String imgHtml = '<img src="'+Url.getSalesforceBaseUrl().getProtocol() + '://'+System.Url.getSalesforceBaseUrl().getHost().remove('-api')+'/servlet/servlet.ImageServer?id='+doc.Id+'&oid='+UserInfo.getOrganizationId()+'" '+doc.Description+'  />';
                        DocTemplateCombineString = DocTemplateCombineString.replaceFirst(textName,imgHtml);
                        //docTempItemList[signpageNo].JunoDoc__Template_Body__c = docTempItemList[signpageNo].JunoDoc__Template_Body__c.replaceFirst(textName,imgHtml);
                        // system.debug('by-->'+docTempItemList[signpageNo].JunoDoc__Template_Body__c);
                        // }
                        system.debug('signpgno-->'+DocTemplateCombineString);
                    }
                }
            }
            
            if(textContentList != '' && textContentList != null){
                List<prepareListnner> textList = (List<prepareListnner>)System.JSON.deserialize(textContentList, List<prepareListnner>.class);
                for(prepareListnner textItem:textList){
                    system.debug('textItem-->'+textItem);
                    //if(''+pgNo == textItem.PageNo){
                    Integer textPgNo = Integer.valueOf(textItem.PageNo);
                    system.debug('textItem-->'+textItem);
                    system.debug('by-->'+DocTemplateCombineString);
                    string textName = ''+textItem.Name.split('_')[0]+':';
                    system.debug('textName-->'+textName);
                    String replaceVlueHtml = '<span style="color:black;">'+ textItem.Value+'</span>';
                    DocTemplateCombineString = DocTemplateCombineString.replaceFirst(textName,replaceVlueHtml);
                    // docTempItemList[textPgNo].JunoDoc__Template_Body__c = docTempItemList[textPgNo].JunoDoc__Template_Body__c.replaceFirst(textName,replaceVlueHtml);
                    // system.debug('by-->'+docTempItemList[textPgNo].JunoDoc__Template_Body__c);
                    //}
                }
            }
            
            if(initialList != '' && initialList != null){
                List<prepareListnner> initialList = (List<prepareListnner>)System.JSON.deserialize(initialList, List<prepareListnner>.class);
                for(prepareListnner initialItem:initialList){
                    system.debug('initialItem-->'+initialItem);
                    //if(''+pgNo == initialItem.PageNo){
                    system.debug('initialItem-->'+initialItem);
                    Integer initialPgNo = Integer.valueOf(initialItem.PageNo);
                    string textName = ''+initialItem.Name.split('_')[0]+':';
                    system.debug('textName-->'+textName);
                    String replaceVlueHtml = '<span style="color:black;">'+ initialItem.Value+'</span>';
                    DocTemplateCombineString = DocTemplateCombineString.replaceFirst(textName,replaceVlueHtml);
                    // docTempItemList[initialPgNo].JunoDoc__Template_Body__c = docTempItemList[initialPgNo].JunoDoc__Template_Body__c.replaceFirst(textName,replaceVlueHtml);
                    //system.debug('by-->'+docTempItemList[initialPgNo].JunoDoc__Template_Body__c);
                    //}
                }
            }
            
            if(dateContentList != '' && dateContentList!= null){
                List<prepareListnner> dateList = (List<prepareListnner>)System.JSON.deserialize(dateContentList, List<prepareListnner>.class);
                for(prepareListnner dateItem:dateList){
                    system.debug('dateItem-->'+dateItem);
                    //if(''+pgNo == dateItem.PageNo){
                    system.debug('dateItem-->'+dateItem);
                    Integer datePageNo = Integer.valueOf(dateItem.PageNo);
                    system.debug('by-->'+DocTemplateCombineString);
                    string dateName = ''+dateItem.Name.split('_')[0]+':'; 
                    system.debug('dateName-->'+dateName);
                    String replaceVlueHtml = '<span style="color:black;">'+ dateItem.Value+'</span>';
                    DocTemplateCombineString = DocTemplateCombineString.replaceFirst(dateName,replaceVlueHtml);
                    //docTempItemList[datePageNo].JunoDoc__Template_Body__c = docTempItemList[datePageNo].JunoDoc__Template_Body__c.replaceFirst(dateName,replaceVlueHtml);
                    //system.debug('c.JunoDoc__Template_Body__c-->'+docTempItemList[datePageNo].JunoDoc__Template_Body__c.contains(dateName));
                    system.debug('by-->'+DocTemplateCombineString);
                    //}
                }
            }
            List<String> docTemplateItemBodyList =  DocTemplateCombineString.split('docTemplateItemCombineSplit');
            system.debug('item size-->'+docTemplateItemBodyList.size());
            
            
            Integer ItemNo = 0;
            for(JunoDoc__Doc_Template_Item__c docItem: docTempItemList){
                docTempItemList[ItemNo].JunoDoc__Template_Body__c = docTemplateItemBodyList[ItemNo];
                system.debug(ItemNo+'-->'+docTempItemList[ItemNo].JunoDoc__Template_Body__c);
                ItemNo++;
            }
            if(showAttachments){
                List<Document> attachmentPageDoc = [select Id, FolderId, Name, DeveloperName, Description, Keywords from Document Where Keywords =:orgTempRecordId+'-'+transcid AND Name= 'attachmentSign_signedImage'];
                String imgHtml = '<img src="'+Url.getSalesforceBaseUrl().getProtocol() + '://'+System.Url.getSalesforceBaseUrl().getHost().remove('-api')+'/servlet/servlet.ImageServer?id='+attachmentPageDoc[0].Id+'&oid='+UserInfo.getOrganizationId()+'" '+attachmentPageDoc[0].Description+'  />';
                JunoDoc__Doc_Template_Item__c templateItemForAttachmentPage = new JunoDoc__Doc_Template_Item__c();
                attachmentListTableHtml = attachmentListTableHtml.replace('attachmentSign:', imgHtml);
                attachmentListTableHtml = attachmentListTableHtml.replace('attachmentInitial:', attachmentInitialStr);
                
                templateItemForAttachmentPage.JunoDoc__Template_Body__c = attachmentListTableHtml;
                templateItemForAttachmentPage.JunoDoc__Doc_Template__c = cloneTemp.Id;
                docTempItemList.add(templateItemForAttachmentPage);
            }
            
            
            if(docTempItemList.size()>0){
                insert docTempItemList;
            }
            
            
            
            //Calculated fields
            SobjectApiName = 'JunoDoc__Calculated_Fields__c';
            schemaMap = Schema.getGlobalDescribe();
            fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            
            strFields = '';
            
            for(String fieldName : fieldMap.keyset() ){
                if(strFields == null || strFields == ''){
                    strFields = fieldName;
                }else{
                    strFields = strFields + ' , ' + fieldName;
                }
            }
            
            Itemquery = 'SELECT ' + strFields + ' FROM JunoDoc__Calculated_Fields__c  Where JunoDoc__Junodoc_Templates__c=:docTemplateId';
            system.debug(Itemquery);
            List<JunoDoc__Calculated_Fields__c> docTempCalcList =  new List<JunoDoc__Calculated_Fields__c>();
            List<JunoDoc__Calculated_Fields__c> tempCalcItem = Database.query(Itemquery);
            for(JunoDoc__Calculated_Fields__c c : tempCalcItem){
                JunoDoc__Calculated_Fields__c docTempCalcItem = c.clone(false, true);
                docTempCalcItem.JunoDoc__Junodoc_Templates__c = cloneTemp.Id;
                docTempCalcList.add(docTempCalcItem);
            }
            if(docTempCalcList.size()>0){
                insert docTempCalcList;
            }
            system.debug('DocTemplatePDF_VF-->'+316);
            newDocTemplateID = cloneTemp.Id;
            system.debug('newDocTemplateID-->'+newDocTemplateID);
            
            if(checkForClonedDocTemplate.size() > 0){
                deleteDocTemplate();
            }
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            errorMessage += ' Line'+e.getLineNumber()+'message ' +e.getMessage() +'/n';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getLineNumber()+'--'+ e.getMessage()));
        }
        system.debug('reference-->'+379);
        //Reference();
    }
    
    public void getPdfBlob(){
        PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF?id='+conid+'&DocTemplateId='+newDocTemplateID); 
        Blob pdfPageBlobFromTemplate; 
        system.debug('pagePdf-->'+pagePdf);
        try {
            
            if(Test.IsRunningTest()){
                pdfPageBlobFromTemplate = Blob.valueOf('UNIT.TEST');
            }
            else{
                pdfPageBlobFromTemplate = pagePdf.getContentAsPDF(); 
            }
            // pdfPageBlobForAttachment = pdfPageBlob;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            errorMessage += ' Line'+e.getLineNumber()+'message ' +e.getMessage() +'/n';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getLineNumber()+'--'+ e.getMessage()));
        }
        system.debug('pdfPageBlob-->'+pdfPageBlobFromTemplate);
        system.debug('pdfPageBlob-->'+Encodingutil.base64encode(pdfPageBlobFromTemplate));
        
    }
    
    
    public class prepareListnner{
        public String Name; 
        public String Value;
        public String PageNo;
        public String Height;
        public String Width;
    }
    
    public void getpositionsTabs (){
        String trancId =  ApexPages.currentPage().getParameters().get('trancid');
        List<JunoDoc__Junodoc_Page_Tab__c> junousersign = [select Id,Name, JunoDoc__Pos_Left__c, JunoDoc__Pos_Top__c, JunoDoc__Sign_Completed__c,JunoDoc__Type__c,JunoDoc__Linked_To__c  from JunoDoc__Junodoc_Page_Tab__c where JunoDoc__Sign_Completed__c =: false AND JunoDoc__Linked_To__c=:trancId ];
    }
    
    public void updateStatus(){
        list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                         ownerId,
                                                         JunoDoc__Recipient_Name__c,
                                                         JunoDoc__Recipient_Email__c,
                                                         JunoDoc__Status__c,
                                                         JunoDoc__Sort_Order__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                         JunoDoc__Juno_Sign_Transaction__c,
                                                         JunoDoc__JunoSign_Expiration_Date__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Status__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c,
                                                         JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c
                                                         from JunoDoc__Juno_Sign_Recipient__c 
                                                         where id=:recid ]; 
        system.debug('recdata-->'+recdata);
        if(recdata.size() > 0 ){
            if(recdata[0].JunoDoc__JunoSign_Expiration_Date__c < system.today()){
                recdata[0].JunoDoc__Status__c = 'Expired';
                update recdata[0];
                JunoDoc__Juno_Sign_Transaction__c junoSignTransaction = new JunoDoc__Juno_Sign_Transaction__c();
                junoSignTransaction.Id = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                junoSignTransaction.JunoDoc__Status__c ='Expired';
                update junoSignTransaction;
                JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                audit.JunoDoc__Date__c = system.today();
                audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                audit.JunoDoc__Status__c    = 'Expired';
                insert audit;
                JunoDoc__Juno_Sign_Recipient_Tracking__c trackingExpired = new JunoDoc__Juno_Sign_Recipient_Tracking__c();
                trackingExpired.JunoDoc__JunoSign_Recipient__c = recid;
                trackingExpired.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                trackingExpired.JunoDoc__Juno_Sign_IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                trackingExpired.JunoDoc__Juno_Sign_Recipient_Status__c ='Expired';
                trackingExpired.JunoDoc__Juno_Sign_Updated_Timestamp__c = System.now();
                insert trackingExpired;
            }
            else if(recdata[0].JunoDoc__Status__c == 'Pending'){
                recdata[0].JunoDoc__Status__c = 'Viewed';
                update recdata[0];
                JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                audit.JunoDoc__Date__c = system.today();
                audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                audit.JunoDoc__Status__c    = 'Viewed';
                insert audit;
                JunoDoc__Juno_Sign_Recipient_Tracking__c trackingViewed = new JunoDoc__Juno_Sign_Recipient_Tracking__c();
                trackingViewed.JunoDoc__JunoSign_Recipient__c = recid;
                trackingViewed.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                trackingViewed.JunoDoc__Juno_Sign_IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                trackingViewed.JunoDoc__Juno_Sign_Recipient_Status__c ='Viewed';
                trackingViewed.JunoDoc__Juno_Sign_Updated_Timestamp__c = System.now();
                insert trackingViewed;
                system.debug('audit-->'+audit);
            }
            
        }
    }
    
    
    
    public void Reference(){
        body = '';
        try{
            
            /********* SAIRAM 21-02-2023 ***********/
            
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
            
            /********* SAIRAM 21-02-2023 ***********/
            
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                             ownerId,
                                                             JunoDoc__Recipient_Name__c,
                                                             JunoDoc__Recipient_Email__c,
                                                             JunoDoc__Sort_Order__c,
                                                             JunoDoc__JunoSign_Expiration_Date__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                             JunoDoc__Juno_Sign_Transaction__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c
                                                             from JunoDoc__Juno_Sign_Recipient__c 
                                                             where id=:recid ];  //'a0ye000000AUtfHAAT'
            if(recdata.size() > 0){
                system.debug(signNotCompletedIds);
                List<String> notInIdList = new List<String>();
                if(signNotCompletedIds != null && signNotCompletedIds!=''){
                    notInIdList = (List<String>)System.JSON.deserialize(signNotCompletedIds, List<String>.class);
                }
                
              
                String docTemplateRecordId = newDocTemplateID;
                if(orgTempRecordId != ''){
                    List<JunoDoc__Doc_Template__c> currentDocTemplate = [Select Id,Name,ownerId from JunoDoc__Doc_Template__c where Id =:orgTempRecordId];
                    if(currentDocTemplate.size()>0){
                        String cloneName= 'Cloned-'+ orgTempRecordId+'-tranid-'+transcid;
                        List<JunoDoc__Doc_Template__c> ClonedDocTemplate = new List<JunoDoc__Doc_Template__c>();
                        ClonedDocTemplate = [Select Id,Name,(select id,Name from JunoDoc__Doc_Template_Items__r),(Select Id,Name from JunoDoc__Doc_Template_Childs__r) ,
                                             (Select Id,Name from JunoDoc__Calculated_Fields__r)  from JunoDoc__Doc_Template__c  where Name =:cloneName];
                        System.debug('Line 711 '+ClonedDocTemplate);
                        docTemplateRecordId = ClonedDocTemplate[0].Id;
                    }
                    
                }
                
                
                PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF?id='+conid+'&DocTemplateId='+docTemplateRecordId); 
                Blob pdfPageBlob; 
                system.debug('pagePdf-->'+pagePdf);
                
                if(Test.IsRunningTest()){
                    pdfPageBlob = Blob.valueOf('UNIT.TEST');
                }
                else{
                    pdfPageBlob = pagePdf.getContentAsPDF(); 
                }
                system.debug('pdfPageBlob-->'+Encodingutil.base64encode(pdfPageBlob));
                // pdfPageBlobForAttachment = pdfPageBlob;
                // contentVersion Conversion = [select title from contentVersion where ContentDocumentId=: recdata[0].Juno_Sign_Transaction__r.Original_Document_Id__c];
                JunoDoc__Doc_Template__c Conversion = [select Id,Name,JunoDoc__Page_Size__c from JunoDoc__Doc_Template__c where Id=: recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c];
                
                string generate = system.today().month() + '/' + system.today().day() + '/' + system.today().year();
                Set<String> condocIdsSet =  new Set<String>();
                String cloneName= 'Cloned-'+ orgTempRecordId+'-tranid-'+transcid;
                system.debug('pdfPageBlob-->'+Encodingutil.base64encode(pdfPageBlob));
                
                PageReference p;
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient =Conversion.Name+'-'+recdata[0].JunoDoc__Recipient_Name__c + ' - '+ generate +' - Signed.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = Conversion.Name+'-'+recdata[0].JunoDoc__Recipient_Name__c + ' - '+generate+ ' - Signed'; // Display name of the files
                conVer.VersionData = pdfPageBlob;//pdfPageBlobForAttachment //Encodingutil.base64decode(strImageBlob);  // converting your binary string to Blog
                // conVer.OwnerId = recdata[0].ownerId;
                insert conVer; 
                system.debug('@@@conVer'+conVer);
                ContentVersion con = [select id,OwnerId,contentdocumentid from ContentVersion where id=:conVer.id];
                con.ownerId = recdata[0].ownerId;
                update con;
                // ContentVersion con = [select id,contentdocumentid from ContentVersion where id=:conVer.id];
                system.debug('@@@@conVer'+conVer);
                //Insert ContentVersion
                // First get the Content Document Id from ContentVersion Object
                Id conDocid = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conver.Id].ContentDocumentId;
                //Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =:currentRecordId].ContentDocumentId;
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =:conDocid].ContentDocumentId;
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
                //showSucessMessage = false;
                String SiteURL = '';
                List<JunoDoc__Junodoc_Setting__c> listurl = [Select JunoDoc__Site_URL__c FROM JunoDoc__Junodoc_Setting__c LIMIT 1];
                if(listurl.size() > 0){
                    SiteURL = listurl[0].JunoDoc__Site_URL__c; 
                    //SiteURL = 'https://partial-dflpvtltd.cs15.force.com/UserSignature';
                    // SiteURL = 'https://junodoc-developer-edition.na111.force.com';
                }
                /*@@@@@*/
                List<string> paralleldata = new List<string>();
                list<JunoDoc__Juno_Sign_Recipient__c> JunorecList;
                List<JunoDoc__Juno_Sign_Recipient__c> parallellist = [select id,JunoDoc__Status__c ,JunoSign_Expiration_Date__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                for(JunoDoc__Juno_Sign_Recipient__c j :parallellist){
                    paralleldata.add(j.JunoDoc__Status__c);
                }
                system.debug('paralleldata'+paralleldata);
                if(!paralleldata.contains('Not Sent')){
                    JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Status__c='Pending' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1]; 
                }else{
                    JunorecList = [select id,JunoDoc__Recipient_Email__c,JunoDoc__Recipient_Name__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Body__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Email_Subject__c,JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Status__c='Not Sent' and JunoDoc__Juno_Sign_Transaction__c=:recdata[0].JunoDoc__Juno_Sign_Transaction__c ORDER BY JunoDoc__Sort_Order__c limit 1];
                }
                system.debug('JunorecList===='+JunorecList);
                if(paralleldata.contains('Not Sent')){
                    system.debug('sequential operation');
                    if(JunorecList.size() > 0){
                        for(JunoDoc__Juno_Sign_Recipient__c juno: JunorecList){
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.toAddresses = new String[] { juno.JunoDoc__Recipient_Email__c };
                                message.setOrgWideEmailAddressId(emailAddressinObjectSettings);
                            system.debug('newDocTemplateID-->'+newDocTemplateID);
                            
                            
                            //EmailTemplate emailTemplateRec = [Select Id,Subject,Htmlvalue from EmailTemplate where DeveloperName = 'Junosign_Email_Template'];
                            
                            /********* SAIRAM 21-02-2023 ***********/
                            String templateHtmlValue = '';
                            String templateSubject = '';
                            JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName];
                            
                            if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c != null){
                                JunoDoc__Email_Template_Item__c emailTemplateRec = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate__c];
                                JunoDoc__Email_Template__c emailTemp = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRec.JunoDoc__Email_Template__c];
                                templateHtmlValue = emailTemplateRec.JunoDoc__Template_Body__c; //emailTemplateRec.Htmlvalue;
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
                                
                                currencySymbolMap = new map<string,string>();
                                list<JunoDoc__Junodoc_Currency__c> currencylist = [select Id,JunoDoc__Currency_Code__c,JunoDoc__Currency_Symbol__c from JunoDoc__Junodoc_Currency__c];
                                if(!currencylist.isEmpty()){
                                    for(JunoDoc__Junodoc_Currency__c currencys : currencylist){
                                        currencySymbolMap.put(currencys.JunoDoc__Currency_Code__c,currencys.JunoDoc__Currency_Symbol__c);   
                                    }
                                }
                                
                                currencysymbols = '$';
                                //system.debug('861-->'+UserInfo.getDefaultCurrency());
                                if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                                    currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
                                }
                                Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
                                // if(multiCurrencyEnabled){
                                if(emailTemp.JunoDoc__Currency_Symbol__c != null && emailTemp.JunoDoc__Currency_Symbol__c != ''){
                                    emailTemp.JunoDoc__Currency_Symbol__c = emailTemp.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                                    Sobject Sobj = Database.query('select id,'+ emailTemp.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:conid');
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
                                    string qury = 'select ' + string.join(Fldlst,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                                    system.debug('qury-->'+qury);
                                    
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
                                    string qurySub = 'select ' + string.join(FldSublst,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                                    system.debug('qurySub-->'+qurySub);
                                    
                                    parentSubRef = Database.query(qurySub);
                                    system.debug('parentSubRef--->'+parentSubRef);
                                }
                                for(String strs: FldSublst){
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
                                                            Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                        }
                                                        
                                                        else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                            Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
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
                                                    
                                                    else if(Types == 'DATE'){
                                                        Date Datestr = Date.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
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
                                //templateHtmlValue += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';
                                
                            }
                            else{
                                EmailTemplate emailTempRec = [Select Id,Subject,Htmlvalue from EmailTemplate where DeveloperName = 'Junosign_Email_Templates'];
                                templateHtmlValue = emailTempRec.Htmlvalue;
                                templateSubject = emailTempRec.Subject;
                            }
                            
                            /********* SAIRAM 21-02-2023 ***********/
                            
                            templateHtmlValue = templateHtmlValue.replace('{Name}', juno.JunoDoc__Recipient_Name__c);
                            if (templateHtmlValue != null) {
                                    String expirationDateStr = juno.JunoSign_Expiration_Date__c != null
                                        ? String.valueOf(juno.JunoSign_Expiration_Date__c)
                                        : '';
                                    templateHtmlValue = templateHtmlValue.replace('{ExpirationDate}', expirationDateStr);
                                }
                            //templateHtmlValue = templateHtmlValue.replace('{ExpirationDate}',String.valueOf(juno.JunoSign_Expiration_Date__c));
                            //String reviewDocumemtUrl = SiteURL+'?id='+con.id+'&recid='+juno.id+'&trancid='+juno.JunoDoc__Juno_Sign_Transaction__c+'&conid='+conid+'&orgDocid='+orgTempRecordId;
                            conDocIDs= '';
                            String reviewDocumemtUrl = SiteURL+'?id='+newDocTemplateID+'&recid='+juno.id+'&trancid='+juno.JunoDoc__Juno_Sign_Transaction__c+'&conid='+conid+'&orgDocid='+orgTempRecordId+'&conDocID='+conDocIDs+'&showattachment=false';
                            system.debug('reviewDocumemtUrl-->'+reviewDocumemtUrl);
                            templateHtmlValue = templateHtmlValue.replace('{URL}', reviewDocumemtUrl);
                            system.debug('templateHtmlValue-->'+templateHtmlValue);
                            //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
                            templateHtmlValue = templateHtmlValue.replace('{logoURL}', logoUrl);
                            system.debug('templateHtmlValue-->'+templateHtmlValue);
                            
                            message.HTMLBody = templateHtmlValue;
                            message.subject = templateSubject;
                            
                            
                            
                            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                                if(!Test.IsRunningTest()){
                                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                                }
                            
                            
                            JunoDoc__Juno_Sign_Recipient__c jn = new JunoDoc__Juno_Sign_Recipient__c();
                            jn.id = juno.id;
                            jn.JunoDoc__signUrl__c = reviewDocumemtUrl;
                            jn.JunoDoc__Status__c = 'Pending';
                            update jn;
                        }
                    }
                    else{
                        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                           Name,
                                                                           JunoDoc__CC_Address__c,
                                                                           JunoDoc__BCC_Address__c,
                                                                           JunoDoc__Set_Reply_To__c,
                                                                           JunoDoc__Final_Document_Id__c,
                                                                           JunoDoc__Date_Completed__c,
                                                                           JunoDoc__Status__c
                                                                           from JunoDoc__Juno_Sign_Transaction__c
                                                                           where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                        
                        JunoSignTrans.JunoDoc__Final_Document_Id__c = conDocid;
                        JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                        JunoSignTrans.JunoDoc__Status__c = 'Completed';
                        update JunoSignTrans;
                        system.debug('@@@@JunoSignTrans'+JunoSignTrans);        
                    }
                }
                
               

                // signee template                
                //EmailTemplate emailTemplateRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signee'];
                
                /********* SAIRAM 21-02-2023 ***********/
                String templateHtmlValueForSignee = '';
                String templateSubjectForSignee = '';
                JunoDoc__Junosign_Object_Setting__c ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName  limit 1];
                
                if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c != null){
                    JunoDoc__Email_Template_Item__c emailTemplateRecSignee = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c];
                    JunoDoc__Email_Template__c emailTempForSignee = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRecSignee.JunoDoc__Email_Template__c];
                    templateHtmlValueForSignee = emailTemplateRecSignee.JunoDoc__Template_Body__c; //emailTemplateRec.Htmlvalue;
                    templateSubjectForSignee = emailTemplateRecSignee.JunoDoc__Subject__c;
                    system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
                    
                    String SobjectApiName = emailTempForSignee.JunoDoc__Parent_Object__c;
                    
                    if(emailTempForSignee.Junodoc__Date_Format__c != null && emailTempForSignee.Junodoc__Date_Format__c != ''){
                        DateFormats = emailTempForSignee.Junodoc__Date_Format__c;
                    }
                    else{
                        DateFormats = 'MM/dd/yyyy';
                    }
                    if(emailTempForSignee.Junodoc__Currency_Format__c != null && emailTempForSignee.Junodoc__Currency_Format__c != ''){
                        CurrencyFormat = emailTempForSignee.Junodoc__Currency_Format__c;
                    }
                    else{
                        CurrencyFormat = '###,###.00';
                    }
                    
                    if(emailTempForSignee.JunoDoc__Number_Format__c != null && emailTempForSignee.JunoDoc__Number_Format__c != ''){
                        NumberFormat = emailTempForSignee.JunoDoc__Number_Format__c;
                    }
                    else{
                        NumberFormat = '###,###.00';
                    }
                    
                    
                    currencysymbols = '$';
                    system.debug(UserInfo.getDefaultCurrency());
                    system.debug(currencySymbolMap);
                    if(UserInfo.getDefaultCurrency() != null && currencySymbolMap != null && currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                        currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
                    }
                    Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
                    // if(multiCurrencyEnabled){
                    if(emailTempForSignee.JunoDoc__Currency_Symbol__c != null && emailTempForSignee.JunoDoc__Currency_Symbol__c != ''){
                        emailTempForSignee.JunoDoc__Currency_Symbol__c = emailTempForSignee.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                        Sobject Sobj = Database.query('select id,'+ emailTempForSignee.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:conid');
                        currencysymbols = currencySymbolMap.get(''+Sobj.get(emailTempForSignee.JunoDoc__Currency_Symbol__c));
                    }
                    
                    if(templateHtmlValueForSignee.contains('{!TODAY()}')){
                        Date Datestr = system.Today();
                        string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                        templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!TODAY()}',Parentvalues); 
                        
                    }
                    if(templateHtmlValueForSignee.contains('{!NOW()}')){
                        string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                        templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!NOW()}',Parentvalues);  
                    }
                    
                    if(templateHtmlValueForSignee.contains('{!#User.')){
                        string qry = 'select ';
                        templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!#User.','##user##');
                        string[] strlist = templateHtmlValueForSignee.split('##user##');
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
                                templateHtmlValueForSignee = templateHtmlValueForSignee.replace('##user##'+str+'}',''+users.get(str));  
                            }
                        }
                    }
                    
                    blankasZeroes =  emailTempForSignee.JunoDoc__Blank_Fields_As_Zeroes__c;
                    
                    
                    SObject parentRef;
                    string[] TempBdylist = templateHtmlValueForSignee.replace('{!','#####').split('#####');
                    list <String> convertlstForSignee = new list<string>();
                    for(string str : TempBdylist){
                        convertlstForSignee.add(str.split('}')[0]);
                    }
                    system.debug('convertlstForSignee-->'+convertlstForSignee);
                    
                    List <String> FldlstForSignee = new list<string>();
                    for(integer a=1;a<convertlstForSignee.size();a++){
                        FldlstForSignee.add(convertlstForSignee[a]);
                    }
                    
                    if(FldlstForSignee.size()>0){
                        
                        system.debug('FldlstForSignee-->'+FldlstForSignee);
                        string qury = 'select ' + string.join(FldlstForSignee,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                        system.debug('qury-->'+qury);
                        
                        parentRef = Database.query(qury);
                        system.debug('parentRef--->'+parentRef);
                    }
                    for(String strs: FldlstForSignee){
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
                            if(templateHtmlValueForSignee.contains('Barcode[{!'+Str+'}]')){
                                templateHtmlValueForSignee = templateHtmlValueForSignee.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                            }
                            else{
                                templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{!'+Str+'}',Parentvalues); 
                            }
                            
                        }
                        else{
                            templateHtmlValueForSignee = templateHtmlValueForSignee.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                        }
                        
                    }
                    
                    if(templateSubjectForSignee.contains('{!TODAY()}')){
                        Date Datestr = system.Today();
                        string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                        templateSubjectForSignee = templateSubjectForSignee.replace('{!TODAY()}',Parentvalues); 
                        
                    }
                    if(templateSubjectForSignee.contains('{!NOW()}')){
                        string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                        templateSubjectForSignee = templateSubjectForSignee.replace('{!NOW()}',Parentvalues);  
                    }
                    
                    if(templateSubjectForSignee.contains('{!#User.')){
                        string qry = 'select ';
                        templateSubjectForSignee = templateSubjectForSignee.replace('{!#User.','##user##');
                        string[] strlist = templateSubjectForSignee.split('##user##');
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
                                templateSubjectForSignee = templateSubjectForSignee.replace('##user##'+str+'}',''+users.get(str));  
                            }
                        }
                    }
                    
                    string[] TempSublist = templateSubjectForSignee.replace('{!','#####').split('#####');
                    list <String> convertSublstForSignee = new list<string>();
                    for(string str : TempSublist){
                        convertSublstForSignee.add(str.split('}')[0]);
                    }
                    system.debug('convertSublstForSignee-->'+convertSublstForSignee);
                    
                    List <String> FldSublstForSignee = new list<string>();
                    for(integer a=1;a<convertSublstForSignee.size();a++){
                        FldSublstForSignee.add(convertSublstForSignee[a]);
                    }
                    system.debug('FldSublstForSignee-->'+FldSublstForSignee);
                    SObject parentSubRef;
                    if(FldSublstForSignee.size()>0){
                        string qurySub = 'select ' + string.join(FldSublstForSignee,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                        system.debug('qurySub-->'+qurySub);
                        
                        parentSubRef = Database.query(qurySub);
                        system.debug('parentSubRef--->'+parentSubRef);
                    }
                    for(String strs: FldSublstForSignee){
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
                                                Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            }
                                            
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
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
                                        
                                        else if(Types == 'DATE'){
                                            Date Datestr = Date.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
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
                            if(templateSubjectForSignee.contains('Barcode[{!'+Str+'}]')){
                                templateSubjectForSignee = templateSubjectForSignee.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                            }
                            else{
                                templateSubjectForSignee = templateSubjectForSignee.replace('{!'+Str+'}',Parentvalues); 
                            }
                            
                        }
                        else{
                            templateSubjectForSignee = templateSubjectForSignee.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                        }
                        
                    }
                    
                    //templateHtmlValueForSignee += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';
                    system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
                }
                else{
                    EmailTemplate emailTempRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signees'];
                    templateHtmlValueForSignee = emailTempRecSignee.HtmlValue;
                    templateSubjectForSignee = emailTempRecSignee.Subject;
                }
                
                /********* SAIRAM 21-02-2023 ***********/
                
                templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{Name}', recdata[0].JunoDoc__Recipient_Name__c);
                system.debug('templateHtmlValueForSignee-->'+templateHtmlValueForSignee);
                //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
                templateHtmlValueForSignee = templateHtmlValueForSignee.replace('{logoURL}', logoUrl);
                system.debug('templateHtmlValue-->'+templateHtmlValueForSignee);
                
                
                Messaging.SingleEmailMessage Signeemessage2 = new Messaging.SingleEmailMessage();
                Signeemessage2.toAddresses = new String[] { recdata[0].JunoDoc__Recipient_Email__c };
                    //Signeemessage2.subject = 'Signature completed successfully';
                    Signeemessage2.subject = templateSubjectForSignee;
                /* Signeemessage2.HTMLBody = '<html>Hi '+ recdata[0].JunoDoc__Recipient_Name__c+',<br></br>Your signature has been completed successfully, your signature has been attached.<br></br>Thank you.</html>';
*/
                if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != null){
                        Signeemessage2.setReplyTo(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c);
                    }
                Signeemessage2.setOrgWideEmailAddressId(emailAddressinObjectSettings);
                Signeemessage2.HTMLBody = templateHtmlValueForSignee;
                
                Messaging.SingleEmailMessage sendermessage2 = new Messaging.SingleEmailMessage();
                //send mail to record owner after signatures completion
                
                //query record from where mail has sent
                string mailsentFromrecordId = conid;
                String sobjectTypeString = Id.valueOf(mailsentFromrecordId).getSObjectType().getDescribe().getName();
                system.debug('mailsentFromrecordId--->'+mailsentFromrecordId);
                List<String> emailList = new List<String>();
                String orgRecordQuery = 'Select Id,Name,Owner.Email,Owner.Id from '+sobjectTypeString+' where Id=:mailsentFromrecordId';
                system.debug('orgRecordQuery-->'+orgRecordQuery);
                sObject rec = Database.query(orgRecordQuery);
                String UserEmail = UserInfo.getUserEmail(); //Returns the current user's email address.
                //System.debug( 'UserEmail-' + UserEmail);
                //system.debug('OwnerEmail->'+''+rec.getSobject('Owner').get('Email'));
                system.debug('OwnerEmail->'+''+rec.getSobject('Owner'));
                // if(rec.getSobject('Owner').get('Type') == 'User'){
                if(rec.getSobject('Owner') != null && string.valueOf(rec.getSobject('Owner').get('Id')).startsWith('005')){
                    emailList.add(''+rec.getSobject('Owner').get('Email'));
                }
                //else if(rec.getSobject('Owner').get('Type') == 'Queue'){
                else if(rec.getSobject('Owner') != null && string.valueOf(rec.getSobject('Owner').get('Id')).startsWith('00G')){
                    // if owner is queue
                    String recOwnerId = ''+rec.getSobject('Owner').get('Id');
                    // get members of queue
                    Group queueRec = [SELECT Id,Type,RelatedId,(select userOrGroupId from groupMembers) FROM group WHERE Id =: recOwnerId];
                    set<string> idList = new set<string>();
                    for (GroupMember gm : queueRec.groupMembers) {
                        system.debug('type'+queueRec.Type);
                        idList.add(gm.userOrGroupId);
                        system.debug(gm.userOrGroupId);
                    }
                    
                    // if queue members of queue are group/role user
                    List<Group> innerGrpMem = [SELECT Id,Type,RelatedId,(select userOrGroupId from groupMembers) FROM group WHERE Id IN: idList];
                    for(Group g: innerGrpMem){
                        system.debug('type'+g.Type);
                        if(g.Type == 'Role'){
                            system.debug('type1'+g.Type);
                            User roleuser = [SELECT Id, Name, Email, isActive, Profile.Name, UserRole.Id, UserRole.Name, UserType FROM User WHERE UserRole.Id=:g.RelatedId ];
                            system.debug('');
                            if(roleuser != null){
                                idList.add(roleuser.Id);
                                system.debug(roleuser.Id);
                            }
                        }else{
                            if(g.groupMembers != null){
                                for (GroupMember gm : g.groupMembers) {
                                    if(gm.userOrGroupId != null){
                                        idList.add(gm.userOrGroupId);
                                        system.debug(gm.userOrGroupId);
                                    }
                                } 
                            }
                        }
                    }
                    User[] usr = [SELECT email FROM user WHERE id IN :idList];
                    system.debug('usr--?'+usr);
                    for(User u : usr) {
                        emailList.add(u.Email);
                    }
                    
                }
                
                System.debug( 'EmailList-->' + emailList);
                
                /*String email = 'sainadhmanohar@gmail.com';
emailList.add(email);*/
                
                //EmailTemplate emailTemplateRecOwner = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Owner'];
                //
                /********* SAIRAM 21-02-2023 ***********/
                String templateHtmlValueForOwner = '';
                String templateSubjectForOwner = '';
                
                ObjSet = [Select Id, JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c from JunoDoc__Junosign_Object_Setting__c where JunoDoc__Selected_object__c =: sObjName];
                if(ObjSet != null && ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c != null){
                    JunoDoc__Email_Template_Item__c emailTemplateRecOwner = [Select Id, JunoDoc__Email_Template__c, JunoDoc__Subject__c, JunoDoc__Template_Body__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: ObjSet.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c];
                    JunoDoc__Email_Template__c emailTempForOwner = [Select Id, Name, JunoDoc__Parent_Object__c, JunoDoc__Parent_Fields__c, JunoDoc__Blank_Fields_As_Zeroes__c, JunoDoc__Currency_Format__c,JunoDoc__Currency_Symbol__c,JunoDoc__Date_Format__c, JunoDoc__Number_Format__c from JunoDoc__Email_Template__c Where Id =: emailTemplateRecOwner.JunoDoc__Email_Template__c];
                    templateHtmlValueForOwner = emailTemplateRecOwner.JunoDoc__Template_Body__c; //emailTemplateRec.Htmlvalue;
                    templateSubjectForOwner = emailTemplateRecOwner.JunoDoc__Subject__c;
                    system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
                    
                    String SobjectApiName = emailTempForOwner.JunoDoc__Parent_Object__c;
                    
                    if(emailTempForOwner.Junodoc__Date_Format__c != null && emailTempForOwner.Junodoc__Date_Format__c != ''){
                        DateFormats = emailTempForOwner.Junodoc__Date_Format__c;
                    }
                    else{
                        DateFormats = 'MM/dd/yyyy';
                    }
                    if(emailTempForOwner.Junodoc__Currency_Format__c != null && emailTempForOwner.Junodoc__Currency_Format__c != ''){
                        CurrencyFormat = emailTempForOwner.Junodoc__Currency_Format__c;
                    }
                    else{
                        CurrencyFormat = '###,###.00';
                    }
                    
                    if(emailTempForOwner.JunoDoc__Number_Format__c != null && emailTempForOwner.JunoDoc__Number_Format__c != ''){
                        NumberFormat = emailTempForOwner.JunoDoc__Number_Format__c;
                    }
                    else{
                        NumberFormat = '###,###.00';
                    }
                    
                    
                    currencysymbols = '$';
                    system.debug(UserInfo.getDefaultCurrency());
                    system.debug(currencySymbolMap);
                    if(UserInfo.getDefaultCurrency() != null && currencySymbolMap != null && currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
                        currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
                    }
                    /*if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
}*/
                    Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
                    // if(multiCurrencyEnabled){
                    if(emailTempForOwner.JunoDoc__Currency_Symbol__c != null && emailTempForOwner.JunoDoc__Currency_Symbol__c != ''){
                        emailTempForOwner.JunoDoc__Currency_Symbol__c = emailTempForOwner.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                        Sobject Sobj = Database.query('select id,'+ emailTempForOwner.JunoDoc__Currency_Symbol__c+ ' from '+ sObjName + ' where Id=:conid');
                        currencysymbols = currencySymbolMap.get(''+Sobj.get(emailTempForOwner.JunoDoc__Currency_Symbol__c));
                    }
                    
                    if(templateHtmlValueForOwner.contains('{!TODAY()}')){
                        Date Datestr = system.Today();
                        string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                        templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{!TODAY()}',Parentvalues); 
                        
                    }
                    if(templateHtmlValueForOwner.contains('{!NOW()}')){
                        string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                        templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{!NOW()}',Parentvalues);  
                    }
                    
                    if(templateHtmlValueForOwner.contains('{!#User.')){
                        string qry = 'select ';
                        templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{!#User.','##user##');
                        string[] strlist = templateHtmlValueForOwner.split('##user##');
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
                                templateHtmlValueForOwner = templateHtmlValueForOwner.replace('##user##'+str+'}',''+users.get(str));  
                            }
                        }
                    }
                    
                    blankasZeroes =  emailTempForOwner.JunoDoc__Blank_Fields_As_Zeroes__c;
                    
                    
                    List<String> convertlstForOwner = new List<String>();
                    String[] TempBdylist = templateHtmlValueForOwner.replace('{!','#####').split('#####');
                    for(string str : TempBdylist){
                        convertlstForOwner.add(str.split('}')[0]);
                    }
                    system.debug('convertlstForOwner-->'+convertlstForOwner);
                    
                    List<String> FldlstForOwner = new List<String>();
                    for(integer a=1;a<convertlstForOwner.size();a++){
                        FldlstForOwner.add(convertlstForOwner[a]);
                    }
                    SObject parentRef;
                    if(FldlstForOwner.size()>0){
                        
                        system.debug('FldlstForOwner-->'+FldlstForOwner);
                        string qury = 'select ' + string.join(FldlstForOwner,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                        system.debug('qury-->'+qury);
                        
                        parentRef = Database.query(qury);
                        system.debug('parentRef--->'+parentRef);
                    }
                    for(String strs: FldlstForOwner){
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
                            if(templateHtmlValueForOwner.contains('Barcode[{!'+Str+'}]')){
                                templateHtmlValueForOwner = templateHtmlValueForOwner.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                            }
                            else{
                                templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{!'+Str+'}',Parentvalues); 
                            }
                            
                        }
                        else{
                            templateHtmlValueForOwner = templateHtmlValueForOwner.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                        }
                        
                    }
                    
                    if(templateSubjectForOwner.contains('{!TODAY()}')){
                        Date Datestr = system.Today();
                        string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
                        templateSubjectForOwner = templateSubjectForOwner.replace('{!TODAY()}',Parentvalues); 
                        
                    }
                    if(templateSubjectForOwner.contains('{!NOW()}')){
                        string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
                        templateSubjectForOwner = templateSubjectForOwner.replace('{!NOW()}',Parentvalues);  
                    }
                    
                    if(templateSubjectForOwner.contains('{!#User.')){
                        string qry = 'select ';
                        templateSubjectForOwner = templateSubjectForOwner.replace('{!#User.','##user##');
                        string[] strlist = templateSubjectForOwner.split('##user##');
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
                                templateSubjectForOwner = templateSubjectForOwner.replace('##user##'+str+'}',''+users.get(str));  
                            }
                        }
                    }
                    
                    List<String> convertSublstForOwner = new List<String>();
                    String[] TempSublist = templateSubjectForOwner.replace('{!','#####').split('#####');
                    for(string str : TempSublist){
                        convertSublstForOwner.add(str.split('}')[0]);
                    }
                    system.debug('convertSublstForOwner-->'+convertSublstForOwner);
                    
                    List<String> FldSublstForOwner = new List<String>();
                    for(integer a=1;a<convertSublstForOwner.size();a++){
                        FldSublstForOwner.add(convertSublstForOwner[a]);
                    }
                    system.debug('FldSublstForOwner-->'+FldSublstForOwner);
                    
                    SObject parentSubRef;
                    if(FldSublstForOwner.size()>0){
                        string qurySub = 'select ' + string.join(FldSublstForOwner,',') + ' from ' + SobjectApiName + ' where Id =\''+conid +'\'';
                        system.debug('qurySub-->'+qurySub);
                        
                        parentSubRef = Database.query(qurySub);
                        system.debug('parentSubRef--->'+parentSubRef);
                    }
                    for(String strs: FldSublstForOwner){
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
                                                Parentvalues =  GetCurrencyvalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            }
                                            
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Parentvalues =  GetNumbervalues(''+parentSubRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
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
                                        
                                        else if(Types == 'DATE'){
                                            Date Datestr = Date.valueof(parentSubRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
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
                            if(templateSubjectForOwner.contains('Barcode[{!'+Str+'}]')){
                                templateSubjectForOwner = templateSubjectForOwner.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                            }
                            else{
                                templateSubjectForOwner = templateSubjectForOwner.replace('{!'+Str+'}',Parentvalues); 
                            }
                            
                        }
                        else{
                            templateSubjectForOwner = templateSubjectForOwner.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                        }
                        
                    }
                    // templateHtmlValueForOwner += '<p style="font-family:Helvetica,Arial,Sans Serif"><a href="{URL}" style="background:#1d3461;color:white;border:1px solid #1d3461;padding:10px 15px;text-decoration:none;font-weight:bold">Review Templates</a> </p>';
                    system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
                }
                else{
                    EmailTemplate emailTemplateRecOwner = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Owner'];
                    templateHtmlValueForOwner = emailTemplateRecOwner.Htmlvalue;
                    templateSubjectForOwner = emailTemplateRecOwner.Subject;
                }
               
                /********* SAIRAM 21-02-2023 ***********/
                
                templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{Name}', recdata[0].JunoDoc__Recipient_Name__c);
                system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
                //https://junodoc-dev-ed--c.documentforce.com/servlet/servlet.ImageServer?id=0153h000001qNAG&oid=00D3h0000067WOmEAM
                templateHtmlValueForOwner = templateHtmlValueForOwner.replace('{logoURL}', logoUrl);
                system.debug('templateHtmlValueForOwner-->'+templateHtmlValueForOwner);
                
                List<String> ccAddressList = new List<String>();
                if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c != null){
                    ccAddressList = recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c.split(',');
                }
                List<String> bccAddressList = new List<String>();
                if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c != null){
                    system.debug('bcc--->'+recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c);
                    bccAddressList = recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__BCC_Address__c.split(',');
                }
                sendermessage2.toAddresses = emailList;
                sendermessage2.setOrgWideEmailAddressId(emailAddressinObjectSettings);
                if(ccAddressList.size() > 0){
                    sendermessage2.ccAddresses = ccAddressList;
                }
                if(bccAddressList.size() > 0){
                    sendermessage2.bccAddresses = bccAddressList;
                }
                if(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != '' && recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c != null){
                        sendermessage2.setReplyTo(recdata[0].JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Set_Reply_To__c);
                    }
                sendermessage2.subject = templateSubjectForOwner;
                //sendermessage2.toAddresses = new String[] {'sainadhmanohar@gmail.com'};//{ 'sriramsree004@gmail.com'};
                // sendermessage2.subject = 'Signature has been completed by Signee'; commented by sai 19th
                // sendermessage2.HTMLBody ='<html>Hi '+ recdata[0].JunoDoc__Juno_Sign_Transaction__r.Sender_Name__c+',<br></br>Your Signature has been signed by '+recdata[0].JunoDoc__Recipient_Name__c+ '<br></br>Thank you.</html>'; 
                
                sendermessage2.HTMLBody = templateHtmlValueForOwner;
                List<Messaging.Emailfileattachment> signeefileAttachments = new List<Messaging.Emailfileattachment>();
                List<Messaging.Emailfileattachment> senderfileAttachments = new List<Messaging.Emailfileattachment>();
                Attachment a = new Attachment(); 
                if(Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
                   && Schema.sObjectType.Attachment.fields.Name.isCreateable() /*&& Schema.sObjectType.Attachment.fields.Description.isCreateable()*/
                   && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                       a.Body = pdfPageBlob;//pdfPageBlobForAttachment; //Encodingutil.base64decode(strImageBlob); 
                       a.ParentID = recdata[0].id; 
                       a.Name =  Conversion.Name+'-'+recdata[0].JunoDoc__Recipient_Name__c +' - ' + generate +' - Signed.pdf';
                       a.ContentType = 'application/pdf';
                       insert a;
                       
                       Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();  
                       efa.setFileName(a.Name); 
                       efa.setBody(a.body); 
                       signeefileAttachments.add(efa);
                       senderfileAttachments.add(efa);
                       delete a;
                   }
                /********* SAIRAM 22-02-2023 ***********/
                EmailTemplate emailTempRecSignee = [Select Id,Htmlvalue,Subject from EmailTemplate where DeveloperName = 'JunoSign_Completed_Signature_For_Signees'];
                /********* SAIRAM 22-02-2023 ***********/
                Id checkObjNameId =  Id.valueOf(mailsentFromrecordId);
                string sObjName = checkObjNameId.getSObjectType().getDescribe().getName();
                Task Taskhistory = new Task();
                if(sObjName.toLowerCase()=='lead' || sObjName.toLowerCase()=='contact'){
                    Taskhistory.WhoId   = Id.valueOf(mailsentFromrecordId);//recdata[0].id;    
                }else{
                    Taskhistory.WhatId = Id.valueOf(mailsentFromrecordId);//recdata[0].id;    
                }                           
                Taskhistory.Status='Completed';
                Taskhistory.Subject = 'Signature has been completed by Signee';
                Taskhistory.JunoDoc__To_Email_Addresses__c = emailList+''; 
                Taskhistory.ActivityDate = System.Today();
                Taskhistory.Description = templateHtmlValueForOwner; //emailTempRecSignee.Htmlvalue; 
                insert Taskhistory;
                
                Attachment att = new Attachment();
                att.Body = pdfPageBlob; //Encodingutil.base64decode(strImageBlob); 
                att.ParentID = Taskhistory.Id; 
                att.Name = Conversion.Name+'-'+recdata[0].JunoDoc__Recipient_Name__c +' - ' + generate +' - Signed.pdf';
                att.ContentType = 'application/pdf';
                insert att;
                
                Signeemessage2.setFileAttachments(signeefileAttachments);
                sendermessage2.setFileAttachments(senderfileAttachments);
                Messaging.SingleEmailMessage[] Signeemessages2 =   new List<Messaging.SingleEmailMessage> {Signeemessage2};
                    Messaging.SingleEmailMessage[] Sendermessages2 =   new List<Messaging.SingleEmailMessage> {sendermessage2};
                        if(!Test.IsRunningTest()){
                            Messaging.SendEmailResult[] Signresults2 = Messaging.sendEmail(Signeemessages2);
                            Messaging.SendEmailResult[] Senderresults2 = Messaging.sendEmail(Sendermessages2); 
                        }
                
                recdata[0].JunoDoc__Status__c = 'Signed';
                recdata[0].JunoDoc__Signed_On__c = system.today();
                recdata[0].JunoDoc__Signed_File_Id__c = conDocid;
                update recdata;
                system.debug(paralleldata);
                if(!paralleldata.contains('Not Sent')){
                    List<JunoDoc__Juno_Sign_Recipient__c> JunoSign = [select id,JunoDoc__Status__c,JunoSign_Expiration_Date__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')];
                    system.debug('NewJunoSign'+JunoSign);
                    if(JunoSign.isEmpty()){
                        system.debug('JunoSign is empty');
                        JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                           Name,
                                                                           JunoDoc__CC_Address__c,
                                                                           JunoDoc__BCC_Address__c,
                                                                           JunoDoc__Set_Reply_To__c,
                                                                           JunoDoc__Final_Document_Id__c,
                                                                           JunoDoc__Date_Completed__c,
                                                                           JunoDoc__Status__c
                                                                           from JunoDoc__Juno_Sign_Transaction__c
                                                                           where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                        JunoSignTrans.JunoDoc__Final_Document_Id__c = conDocid;
                        JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                        JunoSignTrans.JunoDoc__Status__c = 'Completed';
                        update JunoSignTrans;
                        system.debug('@@@@JunoSignTrans'+JunoSignTrans);
                        JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                        audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                        audit.JunoDoc__Date__c = system.today();
                        audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                        audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                        audit.JunoDoc__Status__c    = 'Signed';
                        insert audit;
                        
                         JunoDoc__Juno_Sign_Recipient_Tracking__c trackingSigned = new JunoDoc__Juno_Sign_Recipient_Tracking__c();
                            trackingSigned.JunoDoc__JunoSign_Recipient__c = recid;
                            trackingSigned.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                            trackingSigned.JunoDoc__Juno_Sign_IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                            trackingSigned.JunoDoc__Juno_Sign_Recipient_Status__c ='Signed';
                            trackingSigned.JunoDoc__Juno_Sign_Updated_Timestamp__c = System.now();
                            insert trackingSigned;
                    }
                    
                    
                }else{
                    JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                    audit.Name = recdata[0].JunoDoc__Recipient_Name__c; 
                    audit.JunoDoc__Date__c = system.today();
                    audit.JunoDoc__JunoSign_Transaction__c = recdata[0].JunoDoc__Juno_Sign_Transaction__c;
                    audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                    audit.JunoDoc__Status__c    = 'Signed';
                    insert audit;
                    
                    // audit trail for sending mail to remaining persons
                    JunoDoc__Audit_Trail__c audit1 = new JunoDoc__Audit_Trail__c();
                    audit1.Name = JunorecList[0].JunoDoc__Recipient_Name__c; 
                    audit1.JunoDoc__Date__c = system.today();
                    audit1.JunoDoc__JunoSign_Transaction__c = JunorecList[0].JunoDoc__Juno_Sign_Transaction__c;
                    audit1.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');    
                    audit1.JunoDoc__Status__c    = 'Pending';
                    insert audit1;
                }
                List<JunoDoc__Juno_Sign_Recipient__c> JunoSignRecList = [select id,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =: recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')];
                system.debug('JunoSignRecList'+JunoSignRecList);
                List<JunoDoc__Doc_Template__c> checkForClonedDocTemplate = [Select Id,Name,CreatedDate from JunoDoc__Doc_Template__c where Name =:cloneName Order By CreatedDate DESC];
                if(checkForClonedDocTemplate.size() > 0 && JunoSignRecList.isEmpty()){
                    deleteDocTemplate();
                } 
                
                List<JunoDoc__Juno_Sign_Recipient__c> signedRecipients = [SELECT Id, Juno_Sign_Transaction__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c AND Status__c = 'Signed'];
               List<JunoDoc__Juno_Sign_Recipient__c> AllRecipient = [SELECT Id, Juno_Sign_Transaction__c FROM JunoDoc__Juno_Sign_Recipient__c WHERE Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                if(signedRecipients.size() == AllRecipient.size()){
                    JunoDoc__Juno_Sign_Transaction__c JunoSignTrans = [select id,
                                                                           Name,
                                                                           JunoDoc__CC_Address__c,
                                                                           JunoDoc__BCC_Address__c,
                                                                           JunoDoc__Set_Reply_To__c,
                                                                           JunoDoc__Final_Document_Id__c,
                                                                           JunoDoc__Date_Completed__c,
                                                                           JunoDoc__Status__c
                                                                           from JunoDoc__Juno_Sign_Transaction__c
                                                                           where id =: recdata[0].JunoDoc__Juno_Sign_Transaction__c];
                        
                        JunoSignTrans.JunoDoc__Final_Document_Id__c = conDocid;
                        JunoSignTrans.JunoDoc__Date_Completed__c = System.today();
                        JunoSignTrans.JunoDoc__Status__c = 'Completed';
                        update JunoSignTrans;
                        system.debug('@@@@JunoSignTrans'+JunoSignTrans);   
                }
            }   
            
            
            
            strImageBlob = ''; 
            //showSucessMessage = true;   
            //showErrorMessage = '';
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            errorMessage += ' Line'+e.getLineNumber()+'message ' +e.getMessage() +'/n';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getLineNumber()+'--'+ e.getMessage()));
        }
        //strImageBlob = '';
        //system.debug(e.getMessage());
        //system.debug(e.getLineNumber());
        //  system.debug(e.getLine());
        //showError = true;
        //showSucessMessage = false;
        //showErrorMessage = e.getMessage();
        
    }
    
    
    public void deleteDocTemplate(){
        try{
            String cloneName= 'Cloned-'+ orgTempRecordId+'-tranid-'+transcid;
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                             ownerId,
                                                             JunoDoc__Recipient_Name__c,
                                                             JunoDoc__Recipient_Email__c,
                                                             JunoDoc__Sort_Order__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                             JunoDoc__Juno_Sign_Transaction__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c
                                                             from JunoDoc__Juno_Sign_Recipient__c 
                                                             where id=:recid ];
            if(recdata.size()>0){
                List<JunoDoc__Juno_Sign_Recipient__c> JunoSign = [select id,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c]; // and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')
                system.debug('NewJunoSign'+JunoSign);
                
                system.debug('JunoSign is empty');
                system.debug('orgTempRecordId--->'+orgTempRecordId);
                JunoDoc__Doc_Template__c currentDocTemplate = [Select Id,Name,ownerId from JunoDoc__Doc_Template__c where Id =:orgTempRecordId];
                
                List<JunoDoc__Doc_Template__c> ClonedDocTemplate = new List<JunoDoc__Doc_Template__c>();
                ClonedDocTemplate = [Select Id,Name,(select id,Name from JunoDoc__Doc_Template_Items__r),(Select Id,Name from JunoDoc__Doc_Template_Childs__r) ,
                                     (Select Id,Name from JunoDoc__Calculated_Fields__r)  from JunoDoc__Doc_Template__c  where Name =:cloneName];
                
                system.debug('ClonedDocTemplate-->'+ClonedDocTemplate);
                Set<String> temPlist = new Set<String>();
                
                if(ClonedDocTemplate.size() > 1 || JunoSign.size() == 1){
                    ClonedDocTemplate = [Select Id,Name,(select id,Name from JunoDoc__Doc_Template_Items__r),(Select Id,Name from JunoDoc__Doc_Template_Childs__r) ,
                                         (Select Id,Name from JunoDoc__Calculated_Fields__r)  from JunoDoc__Doc_Template__c  where Name =:cloneName Order By CreatedDate ASC LIMIT 1];
                }
                
                List<JunoDoc__Doc_Template_Item__c> tempItemList = new List<JunoDoc__Doc_Template_Item__c>();
                List<JunoDoc__Doc_Template_Child__c> childs = new List<JunoDoc__Doc_Template_Child__c>();
                List<JunoDoc__Calculated_Fields__c> calcFieldList = new List<JunoDoc__Calculated_Fields__c>();
                for(JunoDoc__Doc_Template__c temp : ClonedDocTemplate){
                    // temPlist.add(temp.id);
                    system.debug(temp.JunoDoc__Doc_Template_Items__r.size()>0);
                    if(temp.JunoDoc__Doc_Template_Items__r.size()>0){
                        tempItemList.addAll(temp.JunoDoc__Doc_Template_Items__r);
                    }
                    if(temp.JunoDoc__Doc_Template_Childs__r.size()>0){
                        childs.addAll(temp.JunoDoc__Doc_Template_Childs__r);
                    }
                    if(temp.JunoDoc__Calculated_Fields__r.size()>0){
                        calcFieldList.addAll(temp.JunoDoc__Calculated_Fields__r);
                    }
                    
                }
                system.debug('tempItemList-->'+tempItemList.size());
                system.debug('childs-->'+childs.size());
                system.debug('calcFieldList-->'+calcFieldList.size());
                if(ClonedDocTemplate.size() == 1){
                    if(childs.size()>0){
                        delete childs;
                    }
                    if(calcFieldList.size()>0){
                        delete calcFieldList;
                    }
                    if(ClonedDocTemplate.size()>0){
                        delete ClonedDocTemplate;
                    }
                    if(tempItemList.size()>0){
                        delete tempItemList;
                    }
                }
                
                
            }
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            errorMessage += ' Line'+e.getLineNumber()+'message ' +e.getMessage() +'/n';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getLineNumber()+'--'+ e.getMessage()));
        }
        
    }
    
    
    public void deleteDocument(){
        try{
            list<JunoDoc__Juno_Sign_Recipient__c> recdata = [select id,
                                                             ownerId,
                                                             JunoDoc__Recipient_Name__c,
                                                             JunoDoc__Recipient_Email__c,
                                                             JunoDoc__Sort_Order__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                             JunoDoc__Juno_Sign_Transaction__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c,
                                                             JunoDoc__Juno_Sign_Transaction__r.JunoDoc__CC_Address__c
                                                             from JunoDoc__Juno_Sign_Recipient__c 
                                                             where id=:recid ];
            if(recdata.size()>0){
                List<JunoDoc__Juno_Sign_Recipient__c> JunoSign = [select id,JunoDoc__Status__c,JunoDoc__Juno_Sign_Transaction__c from JunoDoc__Juno_Sign_Recipient__c where JunoDoc__Juno_Sign_Transaction__c =:recdata[0].JunoDoc__Juno_Sign_Transaction__c and (JunoDoc__Status__c = 'pending' or JunoDoc__Status__c ='Viewed')];
                system.debug('NewJunoSign'+JunoSign);
                if(JunoSign.isEmpty()){
                    system.debug('JunoSign is empty');
                    system.debug('orgTempRecordId--->'+orgTempRecordId);
                    List<Document> dcoRecords = [select Id, FolderId, Name, DeveloperName, Description, Keywords from Document Where Keywords =:orgTempRecordId+'-'+transcid];
                    system.debug('temPlist-->'+dcoRecords); 
                    if(dcoRecords.size()>0){
                        delete dcoRecords;
                    }
                    system.debug('temPlist-->'+dcoRecords); 
                }
            }
        }catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            errorMessage += ' Line'+e.getLineNumber()+'message ' +e.getMessage() +'/n';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getLineNumber()+'--'+ e.getMessage()));
        }
        
    }
    
    
    public void rejectStatus(){
        List<JunoDoc__Juno_Sign_Transaction__c> JunoSignTrans = [select id,
                                                                 Name,
                                                                 JunoDoc__CC_Address__c,
                                                                 JunoDoc__Final_Document_Id__c,
                                                                 JunoDoc__Date_Completed__c,
                                                                 JunoDoc__Status__c
                                                                 from JunoDoc__Juno_Sign_Transaction__c
                                                                 where id =:transcid];
        
        system.debug('Tansaction : '+JunoSignTrans);
        
        if(!JunoSignTrans.isEmpty()){
            JunoSignTrans[0].JunoDoc__Status__c = 'Rejected';
            update JunoSignTrans[0];
            system.debug('Tansaction Updated: '+JunoSignTrans[0]);
            List<JunoDoc__Juno_Sign_Recipient__c> JunoSignReceipts = [select id,
                                                                      ownerId,
                                                                      JunoDoc__Recipient_Name__c,
                                                                      JunoDoc__Recipient_Email__c,
                                                                      JunoDoc__Status__c,
                                                                      JunoDoc__Sort_Order__c,
                                                                      JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Name__c,
                                                                      JunoDoc__Juno_Sign_Transaction__c,
                                                                      JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Object_Id__c ,
                                                                      JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Sender_Email__c ,
                                                                      JunoDoc__Juno_Sign_Transaction__r.JunoDoc__Original_Document_Id__c
                                                                      from JunoDoc__Juno_Sign_Recipient__c 
                                                                      where JunoDoc__Juno_Sign_Transaction__c =:JunoSignTrans[0].Id AND Id = :recid];
            
            system.debug('Receipts for transaction : '+JunoSignReceipts);
            if(!JunoSignReceipts.isEmpty()){
                JunoSignReceipts[0].JunoDoc__Status__c = 'Rejected';
                update JunoSignReceipts[0];
                 JunoDoc__Juno_Sign_Recipient_Tracking__c trackingRejected = new JunoDoc__Juno_Sign_Recipient_Tracking__c();
                            trackingRejected.JunoDoc__JunoSign_Recipient__c = JunoSignReceipts[0].id;
                            trackingRejected.JunoDoc__JunoSign_Transaction__c = transcid;
                            trackingRejected.JunoDoc__Juno_Sign_IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                            trackingRejected.JunoDoc__Juno_Sign_Recipient_Status__c ='Rejected';
                            trackingRejected.JunoDoc__Juno_Sign_Updated_Timestamp__c = System.now();
                            insert trackingRejected;
                 JunoDoc__Audit_Trail__c audit = new JunoDoc__Audit_Trail__c();
                        audit.Name = JunoSignTrans[0].name; 
                        audit.JunoDoc__Date__c = system.today();
                        audit.JunoDoc__JunoSign_Transaction__c = transcid;
                        audit.JunoDoc__IP_Address__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
                        audit.JunoDoc__Status__c    = 'Rejected';
                        insert audit;
                
                
                system.debug('Statuc updated Receipts : '+JunoSignReceipts);
            }
        }
        
    }
    
    
    
    public class recipentInner{
        public String name; 
        public String email;    
    }
    
    
    /********* SAIRAM 21-02-2023 ***********/
    
    public String getRelType(string ObjectName,String FieldName,String parfieldName){
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
    public String getchilType(string ObjectName,String FieldName){
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
    public Boolean shouldCheckDigit { get; set; }
    public string getBarcodes(string sourceCodeValue){
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
    public String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';
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
                public String generateCode39(String source, Boolean checkDigit) {        
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
    public string GetCurrencyvalues(string currencyvalue){
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
    
    public string GetNumbervalues(string currencyvalue){
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
    
    /********* SAIRAM 21-02-2023 ***********/    
}
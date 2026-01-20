global class JunodocAttachFileBatch implements Database.Batchable<sobject> {
  /*  global List<sObject> batchRecordsList;
    global string DocTemplateIds;
    global JunodocAttachFileBatch(list<sObject> Items,string TemplateId){
        this.batchRecordsList = Items;
        this.DocTemplateIds = TemplateId;
        System.debug('batchRecordsList-->'+batchRecordsList);
    }
     global Iterable<sobject> start(Database.BatchableContext BC){
        return this.batchRecordsList;
        
    }
    global void execute(Database.BatchableContext BC,List<sObject> items){
        system.debug(items);
        for(sobject obj:items){
           // String sObjName = id.getSObjectType().getDescribe().getName();
            //string query = 'select id,Name from '+ sObjName + ' where id=: id';
          //  Sobject sobjectrec = Database.query(query);
            //String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            //PageReference pagePdf = new PageReference(baseUrl+'/apex/JunoDoc__PreviewPDF');
            //PageReference pagePdf = Page.PreviewPDF;
             
               system.debug('=='+obj);       
            PageReference pagePdf = new PageReference('/'+Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/JunoDoc__PreviewPDF'); 
           // PageReference pagePdf = new PageReference('https://junodoc-dev-ed--junodoc.visualforce.com/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', ''+obj.get('id')); 
            pagePdf.getParameters().put('DocTemplateId', DocTemplateIds);
            system.debug(DocTemplateIds+'==='+obj.get('id'));
            system.debug('pagepdf@@@'+pagePdf);
            system.debug('contentaspdf@@@'+pagePdf.getContentAsPDF());
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
                
            }
            else{ 
                pdfPageBlob = pagePdf.getContentAsPDF(); 
            }
           
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
            cVersion.PathOnClient = ''+obj.get('Name')+'.pdf';//File name with extention
            cVersion.Title =  ''+obj.get('Name');//Name of the file
            cVersion.VersionData = pdfPageBlob;//File content
            Insert cVersion;
            
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = ''+obj.get('id');//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            system.debug('cDocLink @@@'+cDocLink);
         /*   try{
                Insert cDocLink;      
                //redirect = 'Redirect';    
            }catch(Exception e){
                
            }
            
        }}*/
    
    global Iterable<sobject> start(Database.BatchableContext BC){
        return null;
        
    }   
    
     global void execute(Database.BatchableContext BC,List<sObject> items){ 
    
     }
   global void finish(Database.BatchableContext BC){
          
    } 

}
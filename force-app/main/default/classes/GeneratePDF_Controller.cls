global with sharing class GeneratePDF_Controller {
     global id id {get;set;}
     global String qtid {get;set;}
     global list<user> QTlist {get;set;}
     global list<contact> contactlist {get;set;}
     global string inputtext {get;set;}
     global string contactinputtext {get;set;}
     global string selectedid {get;set;}
    global list<sobject> sobjList{get;set;}
     global Doc_Template__c QuoteInfoList {get;set;}
     global map<string,string> mapLineItemFields {get;set;}
     global list<string> LineItemAPIFields {get;set;}
     global list<string> LineItemLabelFields {get;set;}
     global string  sendCC {get;set;}
     global string  userCC {get;set;}
     global string  userMails {get;set;}
     global string SiteName{get;set;}
     global string SiteUrl{get;set;}
     global Task Taskhistory {get;set;}
     private ApexPages.StandardController stdController;
     global String redirectUrl {global get; private set;}
     global Boolean shouldRedirect {global get; private set;}
     global Organization org1;
    
     global String CurrencyCode{get;set;}       
     global Boolean isMultiCurrencyEnabled {get;set;}  
    
     
     global GeneratePDF_Controller() {
                  
        string myCustomObjects = ApexPages.currentPage().getParameters().get('Id').escapeHtml4();
        id = myCustomObjects;
        String sObjName = id.getSObjectType().getDescribe().getName();
        string query = 'select id,Doc_Template__c from ' + sObjName + ' where id =: id';
        if(isSafeObject(sObjName)){
            sobjList = Database.query(String.escapeSingleQuotes(query));     
        }
        
         if(sobjList.size() > 0){
            selectedid = ''+sobjList[0].get('Doc_Template__c');
         }
                  
         if (Schema.sObjectType.User.fields.Id.isAccessible()
             && Schema.sObjectType.User.fields.Email.isAccessible()
             && Schema.sObjectType.User.fields.Name.isAccessible()) {
             QTlist = [select Id, Name,Email from User limit 1000];
         }
         if (Schema.sObjectType.contact.fields.Name.isAccessible()
             && Schema.sObjectType.contact.fields.FirstName.isAccessible()
             && Schema.sObjectType.contact.fields.LastName.isAccessible()
             && Schema.sObjectType.contact.fields.Email.isAccessible()
             && Schema.sObjectType.contact.fields.Id.isAccessible()) {
                 contactlist = [select id, name,FirstName,LastName,Email from contact limit 100];
         }
         LineItemAPIFields = new list<string>();
         LineItemLabelFields = new list<string>();
         mapLineItemFields = new map<string,string>();

         shouldRedirect = false;
         preview();
         List<String> a=new List<String>();
         a.add('site');
         Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
         Map<String , Map<String,Schema.SObjectField>> mapObj_FielMap = new Map<String , Map<String,Schema.SObjectField>>();
         Schema.SObjectType sobjType;
         sobjType = gd.get(a[0]);
         if(Schema.sObjectType.Organization.fields.OrganizationType.isAccessible()){
            org1 = [SELECT OrganizationType FROM Organization limit 49000];    
         }
        
    }  


     global void userValue(){
        
        for(user q:QTList){
            if(inputtext == q.name){
                if(userCC != null){
                userCC = userCC +', '+q.email;
                    if(sendCC != null){
                    sendCC = sendCC +', '+userCC;
                    }
                }
                else{
                userCC = q.email;
                sendCC = sendCC +', '+ userCC;  
                }

            }
        }
     }
     
     global void contactValue(){
        System.debug('contactlist'+contactlist);
        System.debug('contactinputtext'+contactinputtext);
        System.debug('userCC'+userCC);
        System.debug('userCC'+userCC);
        for(contact con:contactlist){
            if(contactinputtext == con.name){
                if(userCC != null){
                userCC = userCC +', '+con.email;
                    if(sendCC != null){
                    sendCC = sendCC +', '+userCC;
                    }
                }
                else{
                userCC = con.email;
                sendCC = sendCC +', '+ userCC;  
                }

            }
        }
        System.debug('sendCC'+sendCC);
     }
         
          
     global pagereference preview(){
         return null;
     }
     
     global void CreatePDF(){
        if(id != null){
            String sObjName = id.getSObjectType().getDescribe().getName();
            system.debug('sObjName ---------> '+sObjName);
            string query = 'Select id,Name From '+sObjName+' Where id=:id';
            Sobject sobjList;
            if(isSafeObject(sObjName)){
                sobjList = Database.query(String.escapeSingleQuotes(query));     
            }      
            PageReference pagePdf = new PageReference('/apex/JunoDoc__PreviewPDF'); 
            pagePdf.getParameters().put('id', id); 
            Blob pdfPageBlob; 
            if (Test.IsRunningTest()){
                 pdfPageBlob = Blob.valueOf('UNIT.TEST');
            }
            else{
                 pdfPageBlob = pagePdf.getContentAsPDF(); 
             }
            
            Attachment a = new Attachment(); 
            if(Schema.sObjectType.Attachment.fields.Body.isCreateable() 
               && Schema.sObjectType.Attachment.fields.ParentID.isCreateable()
               && Schema.sObjectType.Attachment.fields.Name.isCreateable() 
               && Schema.sObjectType.Attachment.fields.Description.isCreateable()
               && Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
            
                a.Body = pdfPageBlob; 
                a.ParentID = id; 
                a.Name =  'DynamicPDF.pdf';
                a.Description = 'Test'; 
                a.ContentType = 'application/pdf';
                insert a; 
             }    
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'PDF Attachment created to this quote.'));
             doStuffAndRedirect();
         }
         else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please search the correct value.'));
             
         }                      
     }
     
     global void SendPDF(){
     
     }
     
     global PageReference doStuffAndRedirect() {
        shouldRedirect = true;
        redirectUrl = '/'+id;
        return null;
    }
   
    global static boolean isSafeObject(String objName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        if (myObj.getDescribe().isAccessible() ) {
            return true;
        }
        else{
            return false;
        }
    }
    
}
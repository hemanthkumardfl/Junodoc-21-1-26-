public class PreviewPDFGenerator{
    public static string result{get;set;}
    public static string isLandscape{get;set;}
    public static void  getData(){
        string QuoteIds = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId')); 
        string isLatest = string.valueOf(ApexPages.currentPage().getParameters().get('islatest'));
        system.debug('isLatest================'+isLatest);
        string ParentId = id.valueof(ApexPages.currentPage().getParameters().get('ParentId')); 
        system.debug('template id: '+DocTemplateIds);
        PageReference ref = new PageReference('/apex/JunodocPDF?id='+QuoteIds+'&DocTemplateId='+DocTemplateIds+'&Type=DocTemplate');
        Blob pdfBlob;
        if (Test.IsRunningTest()){
            pdfBlob = Blob.valueOf('UNIT.TEST');
        }
        else{   
            pdfBlob = ref.getContentAsPDF();
        }
        Id myRecordId = ApexPages.currentPage().getParameters().get('id');
        Map<String,String> mapOfData = new Map<String,String>();
        List<ContentDocumentLink> lsOfCDL; 
        if(isLatest == 'true'){
            system.debug('true============');
            lsOfCDL = [SELECT Id, 
                       LinkedEntityId,
                       ContentDocumentId 
                       FROM ContentDocumentLink
                       WHERE LinkedEntityId=:ParentId
                       ORDER BY ContentDocument.CreatedDate DESC limit 1]; 
        }
        else if(isLatest == 'false'){
             system.debug('false============');
            lsOfCDL = [SELECT Id, 
                       LinkedEntityId,
                       ContentDocumentId 
                       FROM ContentDocumentLink
                       WHERE LinkedEntityId=:ParentId
                       ORDER BY ContentDocument.CreatedDate]; 
        }
        List<Id> tempsId =new List<Id>();
        for(ContentDocumentLink tempLoop:lsOfCDL){
            tempsId.add(tempLoop.ContentDocumentId);
        }
        List<ContentVersion> lsOfCV = [SELECT Id,VersionData,FileExtension FROM ContentVersion WHERE ContentDocumentId=:tempsId];
        List<String> lsOfFiles = new  List<String>();
        lsOfFiles.add(''+EncodingUtil.base64Encode(pdfBlob));
        for(ContentVersion tempLoopCv :lsOfCV){
            lsOfFiles.add(''+EncodingUtil.base64Encode(tempLoopCv.VersionData));
            System.debug('File Extension is  '+tempLoopCv.FileExtension);
        }
        result = JSON.serialize(lsOfFiles) ;
        system.debug('result >> '+result);
     }
}
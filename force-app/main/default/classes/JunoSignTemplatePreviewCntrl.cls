/**
* @File Name : JunoSignTemplatePreviewCntrl.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : June 18, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | June 18, 2025 |   | Initial Version
**/

public class JunoSignTemplatePreviewCntrl {
    
    
    public transient string pdfBase64 { get; set; }
    public transient string body {get; set;} 
    public transient string secondbody {get; set;}
    public decimal scale {get; set;}
    
    
     public  void generatePdfAndReturnBase64Clone() {
        String recordId = ApexPages.currentPage().getParameters().get('recordId');
        String templateId = ApexPages.currentPage().getParameters().get('templateId');
        String selectedOption = ApexPages.currentPage().getParameters().get('selectedOption');
        system.debug(recordId+'--'+templateId+'---'+selectedOption);
        List<String> selectedDocs = new List<String>();
        if(templateId.contains(',')){
            selectedDocs = templateId.split(',');
        }
        if(selectedOption == 'template'){
            scale = 1.5;
            // 1. Render the PDF content
            PageReference pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF'); 
            //pagePdf.getParameters().put('id', '0Q0KY000000g5OT0AY');  // id for testing
            //pagePdf.getParameters().put('DocTemplateId', 'a00KY000000z5eJYAQ'); // id for testing
            
            pagePdf.getParameters().put('id', recordId);  // id for testing
            pagePdf.getParameters().put('DocTemplateId', templateId); // id for testing
            
            Blob pdfPageBlob; 
            if(Test.IsRunningTest()){
                pdfPageBlob = Blob.valueOf('UNIT.TEST');
            }
            else{
                pdfPageBlob = pagePdf.getContentAsPDF(); 
            }
            
            // 2. Insert as ContentVersion
            ContentVersion contentVersionRec = new ContentVersion();
            contentVersionRec.Title = 'JunoSIgnTempPDF';
            contentVersionRec.PathOnClient = 'JunoSIgnTempPDF.pdf';
            contentVersionRec.VersionData = pdfPageBlob;
            insert contentVersionRec;
            
            
            // 3. Get Base64
            //String base64String = EncodingUtil.base64Encode(pdfPageBlob);
           // pdfBase64 = EncodingUtil.base64Encode(pdfPageBlob);
            
            ContentVersion contentVersionRecnew = [SELECT Id,VersionData,ContentDocumentId FROM ContentVersion WHERE Id=: contentVersionRec.Id];
            pdfBase64 = Encodingutil.base64encode(contentVersionRecnew.VersionData);
            ContentDocument concodc = [SELECT Id FROM ContentDocument WHERE Id = :contentVersionRecnew.ContentDocumentId];
            
            system.debug('contentVersionRecnew-->'+contentVersionRecnew);
            
            // 4. Delete ContentVersion
            delete concodc;
        }else if(selectedOption == 'records' || selectedOption == 'upload'){
            scale = 1.5;
            //ContentDocument concodc = [SELECT Id FROM ContentDocument WHERE Id = :templateId];
            ContentVersion  cont = [select id,VersionData,title from ContentVersion where ContentDocumentId =: templateId];
            pdfBase64 = Encodingutil.base64encode(cont.VersionData);
            
            
            /*if(Encodingutil.base64encode(cont.VersionData).length() <= 5999950){
                body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData));
            }
            else{
                body='data:application/pdf;base64,'+ (Encodingutil.base64encode(cont.VersionData)).substring(0,5999950);
                secondbody= (Encodingutil.base64encode(cont.VersionData)).substring(5999950,Encodingutil.base64encode(cont.VersionData).length());
            }*/
        }
        


        // 5. Return Base64
        //return base64String;
    }

   /* @AuraEnabled
    public static List<Id> createPageTabs(String droppedElementsJson) {
        try {
            // Validate input
            if (String.isBlank(droppedElementsJson)) {
                throw new AuraHandledException('No elements data provided');
            }
            
            // Deserialize with proper error handling
            List<DroppedElementDTO> droppedElements;
            try {
                droppedElements = (List<DroppedElementDTO>) JSON.deserialize(
                    droppedElementsJson, 
                    List<DroppedElementDTO>.class
                );
            } catch (JSONException e) {
                throw new AuraHandledException('Invalid JSON format: ' + e.getMessage());
            }
            
            if (droppedElements == null || droppedElements.isEmpty()) {
                throw new AuraHandledException('No elements to save');
            }

            List<JunoDoc__Junodoc_Page_Tab__c> elementsToInsert = new List<JunoDoc__Junodoc_Page_Tab__c>();
            Integer elementCount = 0;

            for (DroppedElementDTO dto : droppedElements) {
                if (dto == null) continue;
                
                // Validate required fields
                if (String.isBlank(dto.droptype)) {
                    System.debug('Skipping element with missing type: ' + JSON.serialize(dto));
                    continue;
                }

                JunoDoc__Junodoc_Page_Tab__c ele = new JunoDoc__Junodoc_Page_Tab__c();
                ele.JunoDoc__Type__c = dto.droptype;
                ele.JunoDoc__Pos_Left__c = String.valueOf(dto.x != null ? dto.x : 0);
                ele.JunoDoc__Pos_Top__c = String.valueOf(dto.y != null ? dto.y : 0);
                ele.Name = 'divPageNo_' + (dto.pgno != null ? dto.pgno : 0);
                ele.JunoDoc__Recipient_Sort_Order__c = dto.recipientOrder != null ? dto.recipientOrder : 1;
                
                // Set default values for required fields if any
                // ele.Required_Field__c = 'Default Value'; // Add if your object has required fields
                
                elementsToInsert.add(ele);
                elementCount++;
            }
            
            if (elementsToInsert.isEmpty()) {
                throw new AuraHandledException('No valid elements to save after validation');
            }
            
            // Check governor limits
            if (elementsToInsert.size() > Limits.getLimitDmlRows() - Limits.getDmlRows()) {
                throw new AuraHandledException('Exceeds DML limit. Please reduce the number of elements.');
            }
            
            // Insert with allOrNone false to allow partial success
            Database.SaveResult[] srList = Database.insert(elementsToInsert, false);
            
            // Check for errors
            List<Id> insertedIds = new List<Id>();
            Integer errorCount = 0;
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    insertedIds.add(sr.getId());
                } else {
                    errorCount++;
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error inserting element: ' + err.getMessage());
                    }
                }
            }
            
            if (errorCount > 0) {
                System.debug('Failed to insert ' + errorCount + ' out of ' + elementsToInsert.size() + ' elements');
            }
            
            if (insertedIds.isEmpty() && errorCount > 0) {
                throw new AuraHandledException('Failed to save any elements. Please check field validations.');
            }
            
            return insertedIds;
            
        } catch (Exception e) {
            System.debug('Error in createPageTabs: ' + e.getMessage() + ' at line: ' + e.getLineNumber());
            throw new AuraHandledException('Error saving elements: ' + e.getMessage());
        }
    }*/
    
  @AuraEnabled
public static List<Id> createPageTabs(String droppedElementsJson) {
    try {
        // Validate input
        if (String.isBlank(droppedElementsJson)) {
            throw new AuraHandledException('No elements data provided');
        }
        
        system.debug('droppedElementsJson >> '+droppedElementsJson);
        
        // Deserialize with proper error handling
        List<DroppedElementDTO> droppedElements;
        try {
            droppedElements = (List<DroppedElementDTO>) JSON.deserialize(
                droppedElementsJson, 
                List<DroppedElementDTO>.class
            );
        } catch (JSONException e) {
            system.debug('Error >> '+e.getStackTraceString());
            throw new AuraHandledException('Invalid JSON format: ' + e.getMessage()+' : '+e.getLineNumber());
        } catch (Exception e) {
            system.debug('Error >> '+e.getStackTraceString());
            throw new AuraHandledException('Error parsing elements data: ' + e.getMessage());
        }
        
        if (droppedElements == null || droppedElements.isEmpty()) {
            throw new AuraHandledException('No elements to save');
        }

        List<JunoDoc__Junodoc_Page_Tab__c> elementsToInsert = new List<JunoDoc__Junodoc_Page_Tab__c>();

        for (DroppedElementDTO dto : droppedElements) {
            if (dto == null) continue;
            
            // Validate required fields
            if (String.isBlank(dto.droptype)) {
                System.debug('Skipping element with missing type: ' + JSON.serialize(dto));
                continue;
            }

            JunoDoc__Junodoc_Page_Tab__c ele = new JunoDoc__Junodoc_Page_Tab__c();
            ele.JunoDoc__Type__c = dto.droptype;
            ele.JunoDoc__Page_Height__c = dto.pageHeight != null ? String.valueOf(dto.pageHeight) : '0';
            ele.JunoDoc__Page_Width__c = dto.pageWidth != null ? String.valueOf(dto.pageWidth) : '0';
            ele.JunoDoc__Pos_Left__c = String.valueOf(dto.x != null ? dto.x : 0);
            ele.JunoDoc__Pos_Top__c = String.valueOf(dto.y != null ? dto.y : 0);
            ele.Name = 'divPageNo_' + (dto.pgno != null ? dto.pgno : 0);
            ele.JunoDoc__Recipient_Sort_Order__c = dto.recipientOrder != null ? dto.recipientOrder : 1;
            
            elementsToInsert.add(ele);
        }
        
        if (elementsToInsert.isEmpty()) {
            throw new AuraHandledException('No valid elements to save after validation');
        }
        
        // Check governor limits
        if (elementsToInsert.size() > Limits.getLimitDmlRows() - Limits.getDmlRows()) {
            throw new AuraHandledException('Exceeds DML limit. Please reduce the number of elements.');
        }
        
        // Insert with allOrNone false to allow partial success
        Database.SaveResult[] srList = Database.insert(elementsToInsert, false);
        
        // Check for errors
        List<Id> insertedIds = new List<Id>();
        List<String> errorMessages = new List<String>();
        
        for (Integer i = 0; i < srList.size(); i++) {
            Database.SaveResult sr = srList[i];
            if (sr.isSuccess()) {
                insertedIds.add(sr.getId());
            } else {
                for(Database.Error err : sr.getErrors()) {
                    String errorMsg = 'Element ' + (i + 1) + ': ' + err.getMessage();
                    errorMessages.add(errorMsg);
                    System.debug(errorMsg);
                }
            }
        }
        
        if (!errorMessages.isEmpty()) {
            System.debug('Failed to insert ' + errorMessages.size() + ' out of ' + elementsToInsert.size() + ' elements');
            
            // If all failed, throw exception with details
            if (insertedIds.isEmpty()) {
                String errorDetail = String.join(errorMessages, '; ');
                throw new AuraHandledException('Failed to save elements: ' + errorDetail);
            }
        }
        
        return insertedIds;
        
    } catch (AuraHandledException e) {
        // Re-throw AuraHandledExceptions as-is
        throw e;
    } catch (Exception e) {
        // For other exceptions, log and throw user-friendly message
        System.debug('Error in createPageTabs: ' + e.getMessage() + ' Type: ' + e.getTypeName());
        throw new AuraHandledException('Error saving signature elements: ' + e.getMessage());
    }
}
    
    @AuraEnabled
    public static void updatePageTabs(List<Id> pageTabIdList, String transactionID) {
        try {
            if (pageTabIdList == null || pageTabIdList.isEmpty()) {
                throw new AuraHandledException('No page tab IDs provided');
            }
            
            if (String.isBlank(transactionID)) {
                throw new AuraHandledException('Transaction ID is required');
            }
            
            List<JunoDoc__Junodoc_Page_Tab__c> elementsToUpdate = new List<JunoDoc__Junodoc_Page_Tab__c>();
            
            for (Id pageTabId : pageTabIdList) {
                if (pageTabId != null) {
                    JunoDoc__Junodoc_Page_Tab__c pageTabRec = new JunoDoc__Junodoc_Page_Tab__c();
                    pageTabRec.Id = pageTabId;
                    pageTabRec.JunoDoc__Linked_To__c = transactionID;
                    elementsToUpdate.add(pageTabRec);
                }
            }
            
            if (!elementsToUpdate.isEmpty()) {
                Database.update(elementsToUpdate, false); // Allow partial success
            }
            
        } catch (Exception e) {
            System.debug('Error in updatePageTabs: ' + e.getMessage() + ' at line: ' + e.getLineNumber());
            throw new AuraHandledException('Error updating page tabs: ' + e.getMessage());
        }
    }

    public String docxBase64 { get; set; }
    public  void generateDocxAndReturnBase64Clone() {
        String recordId = ApexPages.currentPage().getParameters().get('recordId');
        String templateId = ApexPages.currentPage().getParameters().get('templateId');
        String selectedOption = ApexPages.currentPage().getParameters().get('selectedOption');
        system.debug(recordId+'--'+templateId+'---'+selectedOption);
        List<String> selectedDocs = new List<String>();
        if(templateId.contains(',')){
            selectedDocs = templateId.split(',');
        }
        if (selectedOption == 'records' || selectedOption == 'upload') {
            ContentVersion cont = [
                SELECT VersionData
                FROM ContentVersion
                WHERE ContentDocumentId = :templateId
                ORDER BY VersionNumber DESC
                LIMIT 1
            ];
    
            docxBase64 = EncodingUtil.base64Encode(cont.VersionData);
        }
    }

    public class DroppedElementDTO {
        @AuraEnabled public String droptype {get; set;}
        @AuraEnabled public Decimal x {get; set;}
        @AuraEnabled public Decimal y {get; set;}
        @AuraEnabled public Decimal pageHeight {get; set;}
        @AuraEnabled public Decimal pageWidth {get; set;}
        @AuraEnabled public Integer pgno {get; set;}
        @AuraEnabled public String typeLabel {get; set;}
        @AuraEnabled public Integer recipientOrder {get; set;}
        
        // Default constructor
        public DroppedElementDTO() {
            this.x = 0;
            this.y = 0;
            this.pgno = 0;
            this.recipientOrder = 1;
        }
    }
}
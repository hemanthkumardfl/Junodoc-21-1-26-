public with sharing class PDFPositionEditorController {

    @RemoteAction
    public static String getPDFById(String id, String conid, String recid) {
             try {
        // Check if we have a template ID and related record ID
        if (String.isBlank(id) || String.isBlank(conId) || String.isBlank(recid)) {
            throw new AuraHandledException('Template ID and related record ID are required');
        }

        // Generate the PDF using the JunoDoc PDF page
        PageReference pdfPage = new PageReference('/apex/JunoDoc__JunodocPDF');
        pdfPage.getParameters().put('id', conId);
        pdfPage.getParameters().put('DocTemplateId', id);
        
        Blob pdfBlob;
        if (Test.isRunningTest()) {
            // For test context, return a dummy blob
            pdfBlob = Blob.valueOf('UNIT.TEST');
        } else {
            // Get the PDF content
            pdfBlob = pdfPage.getContentAsPDF();
        }
            
          String base64Data = EncodingUtil.base64Encode(pdfBlob);
        return base64Data;
        
    } catch (Exception e) {
        throw new AuraHandledException('Error generating PDF: ' + e.getMessage());
    }
    }
    
    /**
     * Save positions data to object attachment
     * @param positionsJson JSON string containing position data
     * @param recId Recipient ID
     * @param conId Contact ID
     * @return Result as JSON string
     */
    @RemoteAction
    public static String savePositions(String positionsJson, String recId, String conId) {
        try {
            // Validate input parameters
            if (String.isBlank(positionsJson) || String.isBlank(recId) || String.isBlank(conId)) {
                throw new AuraHandledException('Missing required parameters');
            }
            
            // Create a ContentVersion record to store the positions data
            ContentVersion cv = new ContentVersion();
            cv.Title = 'PDF Positions - ' + System.now().format();
            cv.PathOnClient = 'positions.json';
            cv.VersionData = Blob.valueOf(positionsJson);
            cv.Origin = 'H'; // H for Salesforce
            
            // Insert the ContentVersion
            insert cv;
            
            // Get the ContentDocumentId
            cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            
            // Create a ContentDocumentLink to link the document to the recipient record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.LinkedEntityId = recId; // Link to recipient
            cdl.ShareType = 'V'; // V for Viewer permission
            cdl.Visibility = 'AllUsers';
            
            // Insert the ContentDocumentLink
            insert cdl;
            
            // Create a response object
            Map<String, Object> response = new Map<String, Object>();
            response.put('status', 'success');
            response.put('message', 'Positions saved successfully');
            response.put('documentId', cv.ContentDocumentId);
            
            return JSON.serialize(response);
        } catch (Exception e) {
            System.debug('Error in savePositions: ' + e.getMessage());
            
            // Create an error response
            Map<String, Object> errorResponse = new Map<String, Object>();
            errorResponse.put('status', 'error');
            errorResponse.put('message', e.getMessage());
            
            return JSON.serialize(errorResponse);
        }
    }
}
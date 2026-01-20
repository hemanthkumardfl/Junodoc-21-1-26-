public class JunoSignUploadePdfController {
     @RemoteAction
    public static String savePDFToSalesforce(String fileName, String pdfData, String recordId) {
        try {
            System.debug('Starting PDF save to Salesforce. File name: ' + fileName);
            
            // Remove the data:application/pdf;base64, prefix if present
            String base64Data = pdfData;
            if (pdfData.contains(',')) {
                base64Data = pdfData.substring(pdfData.indexOf(',') + 1);
            }
            
            System.debug('Base64 data length: ' + base64Data.length());
            
            // Create ContentVersion record
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;
            cv.VersionData = EncodingUtil.base64Decode(base64Data);
            cv.IsMajorVersion = true;
            
            // Insert with error handling
            try {
                insert cv;
                System.debug('ContentVersion created successfully. Id: ' + cv.Id);
            } catch (Exception e) {
                System.debug('Error inserting ContentVersion: ' + e.getMessage());
                return 'Error creating file: ' + e.getMessage();
            }
            
            // Get the ContentDocumentId
            Id contentDocumentId;
            try {
                contentDocumentId = [
                    SELECT ContentDocumentId 
                    FROM ContentVersion 
                    WHERE Id = :cv.Id
                    LIMIT 1
                ].ContentDocumentId;
                
                System.debug('Retrieved ContentDocumentId: ' + contentDocumentId);
            } catch (Exception e) {
                System.debug('Error retrieving ContentDocumentId: ' + e.getMessage());
                return 'Error retrieving document ID: ' + e.getMessage();
            }
            
            // If a record ID was provided, link the file to that record
            if (String.isNotBlank(recordId)) {
                System.debug('Linking file to record: ' + recordId);
                
                try {
                    // Check if a ContentDocumentLink already exists
                    List<ContentDocumentLink> existingLinks = [
                        SELECT Id 
                        FROM ContentDocumentLink 
                        WHERE ContentDocumentId = :contentDocumentId 
                        AND LinkedEntityId = :recordId
                        LIMIT 1
                    ];
                    
                    // Only create a new link if one doesn't exist
                    if (existingLinks.isEmpty()) {
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = contentDocumentId;
                        cdl.LinkedEntityId = recordId;
                        cdl.ShareType = 'V'; // Viewer permission
                        insert cdl;
                        System.debug('ContentDocumentLink created successfully');
                    } else {
                        System.debug('ContentDocumentLink already exists');
                    }
                } catch (Exception e) {
                    System.debug('Error linking file to record: ' + e.getMessage());
                    return 'File created but error linking to record: ' + e.getMessage();
                }
            }
            
            return 'Success: ' + contentDocumentId;
        } catch (Exception e) {
            System.debug('Error saving PDF: ' + e.getMessage() + ' ' + e.getStackTraceString());
            return 'Error: ' + e.getMessage();
        }
    }

}
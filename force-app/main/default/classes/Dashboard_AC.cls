public class Dashboard_AC {
    public Dashboard_AC(){    
    }
    
    
    public static String generateDashboardPDF(String dashboardId) {
        string DahsboardData = fetchDashboardContent(dashboardId);
        Map<String, Object> dashboardData = (Map<String, Object>) JSON.deserializeUntyped(DahsboardData);
        
        // Construct HTML content
        String htmlContent = constructHTML(dashboardData);
        
        // Convert HTML to PDF
        Blob pdfBlob = convertToPDF(htmlContent);
        
        // Store the PDF file in Salesforce
        String pdfId = storePDF(pdfBlob);
        
        // Return URL of the generated PDF
        return getPDFUrl(pdfId);
    }
    
    // Method to construct HTML content from JSON data
    public static String constructHTML(Map<String, Object> dashboardData) {
        // Initialize HTML content
        String htmlContent = '<html><head><title>' + dashboardData.get('dashboardName') + '</title></head><body>';
        
        // Iterate over dashboard components
        List<Object> components = (List<Object>) dashboardData.get('componentData');
        for (Object component : components) {
            Map<String, Object> componentData = (Map<String, Object>) component;
            Map<String, Object> reportResult = (Map<String, Object>) componentData.get('reportResult');
           // htmlContent += '<div>' + createReportHTML(reportResult) + '</div>';
        }
        
        htmlContent += '</body></html>';
        
        return htmlContent;
    }
    
    // Method to create HTML for report component
    public static String createReportHTML(Map<String, Object> reportResult) {
        // Construct HTML for report component
        String html = '<h2>' + ((Map<String, Object>)reportResult.get('reportMetadata')).get('name')  + '</h2>';
        html += '<table border="1">';
        html += '<tr>';
        html += '<th>Status</th>';
        html += '<th>Record Count</th>';
        html += '</tr>';
      // Extracting groupingsDown map
Map<String, Object> groupingsDownMap = (Map<String, Object>) reportResult.get('groupingsDown');

// Checking if groupingsDownMap is not null
if (groupingsDownMap != null) {
    // Extracting the list of groupings from groupingsDownMap
    List<Object> groupingsDownList = (List<Object>) groupingsDownMap.get('groupings');

    // Iterating over each groupingDown element in the list
    for (Object groupingDown : groupingsDownList) {
        // Casting groupingDown to a Map<String, Object>
        Map<String, Object> groupingDownMap = (Map<String, Object>) groupingDown;

        // Extracting the list of groupings from groupingDownMap
        List<Object> groupings = (List<Object>) groupingDownMap.get('groupings');

        // Now you can work with the 'groupings' list for each 'groupingsDown' element
        for (Object grouping : groupings) {
             Map<String, Object> groupingMap = (Map<String, Object>) grouping;
            List<Map<String, Object>> aggregates = (List<Map<String, Object>>) groupingMap.get('aggregates');
            Integer value = (Integer) aggregates[0].get('value');
            html += '<tr>';
            html += '<td>' + groupingMap.get('label') + '</td>';
            html += '<td>' + value + '</td>';
            html += '</tr>';
        }
    }
}
        
        html += '</table>';
        
        return html;
    }
    
    // Fetch dashboard content using Reports and Dashboards API
    public static String fetchDashboardContent(String dashboardId) {
         String dashboardContent;
        String instanceUrl = URL.getOrgDomainUrl().toExternalForm();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(instanceUrl+'/services/data/v53.0/analytics/dashboards/' + dashboardId);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            dashboardContent = res.getBody();
        } else {
            dashboardContent = null; // or handle error
        }
        
        return dashboardContent;
    }
    
    // Convert dashboard content to PDF format
    public static Blob convertToPDF(String dashboardContent) {
        // Create a new PageReference
       PageReference pageRef = new PageReference('about:blank');
    
    // Set the content of the PageReference to the HTML content
    pageRef.getParameters().put('content', EncodingUtil.urlEncode(dashboardContent, 'UTF-8'));
    
    // Generate the page content
    Blob pageBlob;
    try {
        pageBlob = pageRef.getContentAsPDF();
    } catch (Exception e) {
        // Handle any exceptions
        System.debug('Error generating PDF: ' + e.getMessage());
        pageBlob = Blob.valueOf('');
    }
        // Your implementation to convert content to PDF
        return pageBlob;
    }
    
    // Store the PDF file in Salesforce
    public static String storePDF(Blob pdfBlob) {
        // Your implementation to store PDF in Salesforce
        // For example:
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Dashboard PDF';
        cv.PathOnClient = 'dashboard.pdf';
        cv.VersionData = pdfBlob;
        insert cv;
        return cv.Id;
    }
    
    // Return URL of the generated PDF
    public static String getPDFUrl(String pdfId) {
        // Your implementation to get URL of the PDF
        // For example:
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :pdfId LIMIT 1];
        ContentDocumentLink cdl = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId LIMIT 1];
        return '/' + cdl.LinkedEntityId; // Return URL of the record linked to the PDF
    }
}
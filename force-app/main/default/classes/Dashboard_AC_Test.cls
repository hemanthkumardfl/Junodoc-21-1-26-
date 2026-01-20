@isTest
public class Dashboard_AC_Test {
        @isTest
    static void testGenerateDashboardPDF() {
        // Test generating a dashboard PDF
        String dashboardId = 'your_dashboard_id';
        String pdfUrl = Dashboard_AC.generateDashboardPDF(dashboardId);
        System.assertNotEquals(null, pdfUrl, 'PDF URL should not be null');
        // Add more assertions as needed
    }
    
    @isTest
    static void testConstructHTML() {
        // Test constructing HTML content
        Map<String, Object> dashboardData = new Map<String, Object>{
            'dashboardName' => 'Test Dashboard',
            'componentData' => new List<Object>{
                // Add test component data here
            }
        };
        Dashboard_AC.constructHTML(dashboardData);
        // Add assertions to validate HTML content
    }
    
    // Add similar test methods for other private methods
    
    @isTest
    static void testFetchDashboardContent() {
        // Test fetching dashboard content
        String dashboardId = 'your_dashboard_id';
        Dashboard_AC.fetchDashboardContent(dashboardId);
        // Add assertions to validate dashboard content
    }
    
    @isTest
    static void testConvertToPDF() {
        // Test converting dashboard content to PDF
        String dashboardContent = '<html><body><h1>Test</h1></body></html>';
        Blob pdfBlob = Dashboard_AC.convertToPDF(dashboardContent);
        // Add assertions to validate PDF blob
    }
    
    @isTest
    static void testStorePDF() {
        // Test storing PDF in Salesforce
        Blob pdfBlob = Blob.valueOf('Test PDF');
        String pdfId = Dashboard_AC.storePDF(pdfBlob);
        // Add assertions to validate PDF storage
    }
    
    @isTest
    static void testGetPDFUrl() {
        // Test getting URL of the generated PDF
        String pdfId = 'your_pdf_id';
        String pdfUrl = Dashboard_AC.getPDFUrl(pdfId);
        // Add assertions to validate PDF URL
    }
    
     @isTest
    static void testCreateReportHTML() {
        // Test case where groupingsDownMap is null
        Map<String, Object> reportResultNull = new Map<String, Object>{
            'reportMetadata' => new Map<String, Object>{ 'name' => 'Test Report' },
            'groupingsDown' => null
        };
        String htmlContentNull = Dashboard_AC.createReportHTML(reportResultNull);
        System.assertNotEquals(null, htmlContentNull, 'HTML content should not be null when groupingsDownMap is null');
        // Add assertions to validate HTML content
        
        // Test case where groupingsDownMap is not null
        Map<String, Object> reportResultNotNull = new Map<String, Object>{
            'reportMetadata' => new Map<String, Object>{ 'name' => 'Test Report' },
            'groupingsDown' => new Map<String, Object>{
                'groupings' => new List<Object>{
                    new Map<String, Object>{
                        'groupings' => new List<Object>{
                            new Map<String, Object>{
                                'label' => 'Label 1',
                                'aggregates' => new List<Map<String, Object>>{ new Map<String, Object>{ 'value' => 10 } }
                            }
                        }
                    }
                }
            }
            };
        String htmlContentNotNull = Dashboard_AC.createReportHTML(reportResultNotNull);
        System.assertNotEquals(null, htmlContentNotNull, 'HTML content should not be null when groupingsDownMap is not null');
        // Add assertions to validate HTML content
    }

}
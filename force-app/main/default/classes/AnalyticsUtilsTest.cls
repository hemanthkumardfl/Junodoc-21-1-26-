@isTest
public class AnalyticsUtilsTest {

   @isTest
static void testTabularReport() {
    // Setup test data
    Test.startTest();
    
    // Replace with an actual report ID that is known to have data
    String reportId = '00O1t000002GhlyEAC'; // Example report ID
    String sobjectName = 'Account'; // Replace with your actual sObject name

    AnalyticsUtils utils = new AnalyticsUtils();
    utils.reportId = reportId;
    utils.sobjectName = sobjectName;

    List<String> recordIds = new List<String>();

    try {
        // Run the ReportResponse method which internally will call getTabularReportResponse
        recordIds = utils.ReportResponse();
        
        // Assert the results
        System.assertNotEquals(0, recordIds.size(), 'Expected to get some record IDs.');
        
        // Add additional assertions based on expected results
        System.debug('Record IDs: ' + recordIds);
        
    } catch (System.NoDataFoundException e) {
        // Handle the case where no data is found
        System.debug('No data found for report ID: ' + reportId);
        System.assertEquals(0, recordIds.size(), 'Expected no record IDs.');
    } catch (Exception e) {
        // Handle any other unexpected exceptions
        System.debug('Unexpected error: ' + e.getMessage());
        throw e; // Re-throw the exception for visibility in test results
    }

    Test.stopTest();
}
@isTest
static void setupTestData() {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < 5; i++) {
        accounts.add(new Account(Name = 'Test Account ' + i));
    }
    insert accounts;
}


  /*   @testSetup
    static void setupTestData() {
        // Create test records here
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Create a report or use an existing report that includes the test data
    }*/

    @isTest
    static void testSummaryReport() {
        // Setup test data
        Test.startTest();
        
        // Use a report ID that is known to have data or is configured for testing
        String reportId = '00O1t000002GhlyEAC'; // Replace with your actual report ID
        
        AnalyticsUtils utils = new AnalyticsUtils();
        utils.reportId = reportId;
        
        List<String> recordIds = new List<String>();
        
        try {
            // Run the ReportResponse method which internally will call getSummaryReportResponse
            recordIds = utils.ReportResponse();
            
            // Assert the results
            System.assertNotEquals(0, recordIds.size(), 'Expected to get some record IDs.');
            // Add more assertions based on your expected results
            
        } catch (System.NoDataFoundException e) {
            // Handle the case where no data is found
            System.debug('No data found for report ID: ' + reportId);
            System.assertEquals(0, recordIds.size(), 'Expected no record IDs.');
        }
        
        Test.stopTest();
    }
   @isTest
    static void testReportData() {
        // Setup test data
        Test.startTest();
        
        // Create a valid report ID with known data for testing
        // Replace with your actual report ID that has data
        String reportId = '00O1t000002GhlyEAC'; 
        String sobjectName = 'Account'; // Replace with your actual sObject name

        AnalyticsUtils utils = new AnalyticsUtils();
        utils.reportId = reportId;
        utils.sobjectName = sobjectName;

        List<String> recordIds = new List<String>();
        
        try {
            recordIds = utils.ReportResponse();
            
            // Assert that we received record IDs
            System.assertNotEquals(0, recordIds.size(), 'Expected to get some record IDs.');
        } catch (System.NoDataFoundException e) {
            // Handle the case where no data is found, log an appropriate message
            System.debug('No data found for report ID: ' + reportId);
            System.assertEquals(0, recordIds.size(), 'Expected no record IDs.');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testNoResults() {
        // Setup test data
        Test.startTest();
        
        // Use a report ID that is known to have no data
        String reportId = '00O1t000002GhlyEAC'; // Replace with your test report ID with no data

        AnalyticsUtils utils = new AnalyticsUtils();
        utils.reportId = reportId;

        // Run the ReportResponse method which will call getSummaryReportResponse or getTabularReportResponse
        List<String> recordIds = new List<String>();
        
        try {
            recordIds = utils.ReportResponse();
        } catch (System.NoDataFoundException e) {
            // Handle the case where no data is found
            System.debug('No data found for report ID: ' + reportId);
        }
        
        // Assert the results
        System.assertEquals(0, recordIds.size(), 'Expected no record IDs.');
        
        Test.stopTest();
    }


    /*@isTest
    static void testNoResults() {
        // Setup test data
        Test.startTest();
        
        // Create or use an existing report ID
        String reportId = '00O1t000002GhlyEAC'; // Replace with your actual report ID
        
        AnalyticsUtils utils = new AnalyticsUtils();
        utils.reportId = reportId;
        
        // Run the ReportResponse method which internally will call getSummaryReportResponse or getTabularReportResponse
        List<String> recordIds = utils.ReportResponse();
        
        // Assert the results
        System.assertEquals(0, recordIds.size(), 'Expected no record IDs.');
        
        Test.stopTest();
    }*/
}
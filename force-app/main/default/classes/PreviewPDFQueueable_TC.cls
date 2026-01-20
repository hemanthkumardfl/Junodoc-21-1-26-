@IsTest
private class PreviewPDFQueueable_TC {
     @IsTest
    static void testExecute() {
        // Create test data
        List<String> quoteIds = new List<String>{'quoteId1', 'quoteId2'};
        String docTemplateId = 'docTemplateId';

        // Mock the HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Create an instance of the queueable class
        PreviewPDFQueueable queueable = new PreviewPDFQueueable(quoteIds, docTemplateId);

        // Execute the queueable
        Test.startTest();
        System.enqueueJob(queueable);
        Test.stopTest();

        // Check the output
        String output = queueable.getOutput();
        // Add your assertions here to verify the output
    }
    
    ////////////////////////
    /*@isTest
    static void testExecute() {
        // Create a list of mock quote IDs
        List<String> mockQuoteIds = new List<String>{'a0123456789ABCDEF', 'b0123456789ABCDEF'};
        String mockDocTemplateId = '0123456789ABCDEF';

        // Instantiate the PreviewPDFQueueable class with mock data
        PreviewPDFQueueable queueable = new PreviewPDFQueueable(mockQuoteIds, mockDocTemplateId);

        // Mocking PageReference and its getContent method
        Test.setMock(PageReference.class, new PageReferenceMock());

        // Execute the queueable
        Test.startTest();
        System.enqueueJob(queueable);
        Test.stopTest();

        // Validate the output
        String expectedOutput = '<html>Content for a0123456789ABCDEF</html><p style="page-break-after: always;"/>' +
                                '<html>Content for b0123456789ABCDEF</html>';
        System.assertEquals(expectedOutput, queueable.getOutput(), 'The output content is not as expected.');
    }

    // PageReferenceMock class to mock the behavior of PageReference
    private class PageReferenceMock implements System.PageReference {
        public String getContent() {
            // Mock the HTML content returned by the page reference
            if (ApexPages.currentPage().getParameters().get('id') == 'a0123456789ABCDEF') {
                return '<html>Content for a0123456789ABCDEF</html>';
            } else if (ApexPages.currentPage().getParameters().get('id') == 'b0123456789ABCDEF') {
                return '<html>Content for b0123456789ABCDEF</html>';
            }
            return '';
        }
    }*/
}
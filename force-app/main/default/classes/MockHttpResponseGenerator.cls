Public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Mock response body
            String responseBody = 'Mock PDF content';

            // Create a fake response
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/pdf');
            res.setBodyAsBlob(Blob.valueOf(responseBody));
            res.setStatusCode(200);
            return res;
        }
    }
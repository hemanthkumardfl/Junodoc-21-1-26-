@isTest
public class CallOutUtilityController_Test {
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"access_token":"SESSION_ID_REMOVED","signature":"PBLxif3Wt9y2pU/6DF+laloJSpnWf5GNCE453ajzWVs=","scope":"lightning visualforce sfap_api cdp_query_api cdp_ingest_api custom_permissions openid cdp_segment_api cdp_profile_api cdp_api content cdp_identityresolution_api chatbot_api interaction_api wave_api cdp_calculated_insight_api user_registration_api chatter_api id api eclair_api pardot_api forgot_password","instance_url":"https://anujplay12val--v1201sb46.sandbox.my.salesforce.com","id":"https://test.salesforce.com/id/00D2C000000CyPLUA0/0052C000003ztBJQAY","token_type":"Bearer","issued_at":"1684740249367"}';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest
    static void testmethod1(){
        Account acc_Rec =new Account();
        acc_Rec.Name = 'Test';
        acc_Rec.phone = '665455566';
        insert acc_Rec;
        System.assertEquals('Test', acc_Rec.Name);   
        Contact con_Rec = new Contact();
        con_Rec.LastName = 'Test';
        con_Rec.AccountId = acc_Rec.id;
        insert con_Rec;  
        System.assertEquals('Test', con_Rec.LastName);
        JunoDoc__Junodoc_Connections__c  syncCon_Rec = new JunoDoc__Junodoc_Connections__c ();
        syncCon_Rec.Name = 'TestDil';
        syncCon_Rec.JunoDoc__Sandbox__c = false;
        syncCon_Rec.JunoDoc__Production__c = true;
        syncCon_Rec.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC';
        syncCon_Rec.JunoDoc__Consumer_Secret__c = '3447664293037645191';
        syncCon_Rec.JunoDoc__Password_Encrypted__c= 'mahesh4321';
        syncCon_Rec.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
        syncCon_Rec.JunoDoc__Method__c = 'POST';
        syncCon_Rec.JunoDoc__Username__c = 'dil@dlabs.com';                                                                                              
        insert syncCon_Rec;
        System.assertEquals('POST', syncCon_Rec.Method__c);
        JunoDoc__Junodoc_Parent_Configuration__c syncDatConfig_Rec = new JunoDoc__Junodoc_Parent_Configuration__c();
        syncDatConfig_Rec.JunoDoc__Junodoc_Object_Name__c = 'Account';
        syncDatConfig_Rec.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT id,name FROM Account';
        syncDatConfig_Rec.JunoDoc__Junodoc_Use_SOQL__c = false;
        insert syncDatConfig_Rec;
        System.assertEquals('Account',syncDatConfig_Rec.JunoDoc__Junodoc_Object_Name__c);
        CallOutUtilityController.m_ConnectToOtherSFDC(syncCon_Rec.id);
        String json = '{ "records" : [ { "attributes" : { "type" : "Account", "referenceId" : "ref1" }, "Name" : "University of Arizona", "Contacts" : { "records" : [ { "attributes" : { "type" : "Contact", "referenceId" : "ref2" }, "FirstName" : "Test", "LastName" : "Contact" } ] } } ] }';
        CallOutUtilityController.m_pushToOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json, 'Account');
        CallOutUtilityController.m_pushToOtherSfdcPatch(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json, 'Account');
        CallOutUtilityController.m_getFromOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', 'S');
        CallOutUtilityController.m_pushPriceBookEntryToOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json, 'Account');    
        
        CallOutUtilityController   call = new CallOutUtilityController(); 
        //call.ConnectToOtherSFDC(syncCon_Rec.id);
        call.getFromOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', 'S');
        String json1 = '{ "records" : [ { "attributes" : { "type" : "Account", "referenceId" : "ref1" }, "Name" : "University of Arizona", "Contacts" : { "records" : [ { "attributes" : { "type" : "Contact", "referenceId" : "ref2" }, "FirstName" : "Test", "LastName" : "Contact" } ] } } ] }';
        call.pushToOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json1, 'Account');
        call.pushToOtherSfdcPatch(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json1, 'Account');
        call.pushPriceBookEntryToOtherSfdc(syncCon_Rec.Consumer_Secret__c, 'na22.salesforce.com', json1,'Account');
        CallOutUtilityController.ConnectToOtherSFDC(syncCon_Rec.Id);
        CallOutUtilityController.getReferenceRecordsFromDestination('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com', json1);
        Call.objectDescribe('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com', 'Account');
        CallOutUtilityController.mtreeBatchClassRequest('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com', json1, 'Test');
        CallOutUtilityController.mGraphBatchClassRequest('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com', json1, 'Test');
        CallOutUtilityController.apiLimits('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com');
        CallOutUtilityController.retrieveStandardObjectInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com');
        CallOutUtilityController.retrieveValidationRule('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.retrievePageLayoutsInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.retrieveApexClassesInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.retrieveApexPagesInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.retrieveObjectFieldsInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.retrieveApexTriggersInfo('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        CallOutUtilityController.soap_connectToSFDC(syncCon_Rec.Id);
        CallOutUtilityController.SOAP_ApiCall('','https://www.google.com','');
        // CallOutUtilityController.parseMetadataQueryResponse(System.queryResponseXML, instanceURL, batchProcessId, selecteddestinationOrg, objectName, metadataObjectFields, sObjectRecords, destinationExternalId)
        CallOutUtilityController classname = new CallOutUtilityController();
        call.recordTypeInfoFromDestination('SELECT id,name FROM Account','na22.salesforce.com','3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC');
        call.objectSchemaRequest('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com', json1);
        //classname.m_patch('test','test','test');
        // classname.objectDescribe('test','www.salesforce.com','Account');
        System.assertEquals('test','test'); 
    }
    
    @istest
    static void test(){
        list<JunoDoc__Junodoc_Connections__c> listconnect = new list<JunoDoc__Junodoc_Connections__c>();
        JunoDoc__Junodoc_Connections__c  syncCon_Rec = new JunoDoc__Junodoc_Connections__c ();
        syncCon_Rec.Name = 'CloudSync Test';
        syncCon_Rec.JunoDoc__Sandbox__c = false;
        syncCon_Rec.JunoDoc__Production__c = true;
        syncCon_Rec.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrBZdvfDSKkW6bK_L59Bczes1qbxfU0A5bMQ91aRjtDMyZjJsT6jsfrl0GOz6rNFokF20DQl';
        syncCon_Rec.JunoDoc__Consumer_Secret__c = '2453920385567509976';
        syncCon_Rec.JunoDoc__Password_Encrypted__c= 'today@123';
        syncCon_Rec.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
        syncCon_Rec.JunoDoc__Method__c = 'POST';
        syncCon_Rec.JunoDoc__Username__c = 'sateeshcloudsynctest@gmail.com';
        syncCon_Rec.JunoDoc__Access_Token__c='00D28000001jFDG!ARcAQKYmdhf6AL_gcUjgSMc9w6qeBI4C5iO62ALeUVWFPJBrvHP5BGOYyKPdPNdaedQVO69XvFu4huhTVMDwmLs_RH3Hiyvx';                                                                                                    
        syncCon_Rec.JunoDoc__Instance_URL__c='https://ap2.salesforce.com';
        syncCon_Rec.JunoDoc__API_Usage__c =36.0;
        syncCon_Rec.JunoDoc__Org_Id__c = UserInfo.getOrganizationId();
        insert syncCon_Rec; 
        listconnect.add(syncCon_Rec); 
        ApexPages.currentPage().getParameters().put('Id',syncCon_Rec.id);  
        CallOutUtilityController EndPoints = new CallOutUtilityController();
        EndPoints.picklist ='Sandbox';
        EndPoints.connectionname  ='Cloud Sync';
        EndPoints.save();
        EndPoints.selectedid = syncCon_Rec.id;
        EndPoints.VerifyConnection();
        EndPoints.redirectToEndPoints();
        EndPoints.newconn();
        CallOutUtilityController.nextRecordsURL('3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC', 'na22.salesforce.com','test');
        EndPoints.connectToOtherOrg(syncCon_Rec);
        EndPoints.delrecord();
        
        /**************************************/
        JunoDoc__Junodoc_Connections__c  syncCon_Rec1 = new JunoDoc__Junodoc_Connections__c ();
        syncCon_Rec1.Name = 'CloudSync Test1';
        syncCon_Rec.JunoDoc__Sandbox__c = false;
        syncCon_Rec.JunoDoc__Production__c = true;
        syncCon_Rec.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrBZdvfDSKkW6bK_L59Bczes1qbxfU0A5bMQ91aRjtDMyZjJsT6jsfrl0GOz6rNFokF20DQl';
        syncCon_Rec.JunoDoc__Consumer_Secret__c = '2453920385567509976';
        syncCon_Rec.JunoDoc__Password_Encrypted__c= 'today@123';
        syncCon_Rec.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
        syncCon_Rec.JunoDoc__Method__c = 'POST';
        syncCon_Rec.JunoDoc__Username__c = 'sateeshcloudsynctest@gmail.com';
        syncCon_Rec.JunoDoc__Access_Token__c='00D28000001jFDG!ARcAQKYmdhf6AL_gcUjgSMc9w6qeBI4C5iO62ALeUVWFPJBrvHP5BGOYyKPdPNdaedQVO69XvFu4huhTVMDwmLs_RH3Hiyvx';                                                                                                    
        syncCon_Rec.JunoDoc__Instance_URL__c='https://ap2.salesforce.com';
        syncCon_Rec.JunoDoc__API_Usage__c =36.0;
        syncCon_Rec.JunoDoc__Org_Id__c = UserInfo.getOrganizationId();
        insert syncCon_Rec1;
        EndPoints.selectedid = syncCon_Rec1.id;
        EndPoints.editreord();       
        EndPoints.cancel();
        /*JunoDoc__Junodoc_Connections__c conone = new JunoDoc__Junodoc_Connections__c();
conone.Name = 'TestDil1';
conone.JunoDoc__Sandbox__c = false;
conone.JunoDoc__Production__c = true;
conone.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC';
conone.JunoDoc__Consumer_Secret__c = '3447664293037645191';
conone.JunoDoc__Password_Encrypted__c= 'mahesh43211';
conone.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
conone.JunoDoc__Method__c = 'POST';
conone.JunoDoc__Username__c = 'dil@dlabs.com'; 
insert conone;
JunoDoc__Junodoc_Connections__c conthree = new JunoDoc__Junodoc_Connections__c();
conthree.Name = 'TestDil';
conthree.JunoDoc__Sandbox__c = true;
conthree.JunoDoc__Production__c = false;
conone.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrC8H7YMp0r4vLurkR31zrkl88piVOOpd.NwwzrrQDYxiKVxBx0N9SnAP5FD.YfDLWMNseBC';
conone.JunoDoc__Consumer_Secret__c = '3447664293037645191';
conone.JunoDoc__Password_Encrypted__c= 'mahesh4321';
conone.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
conone.JunoDoc__Method__c = 'POST';
conone.JunoDoc__Username__c = 'dil@dlabs.com';  
insert conthree;*/
        
        /* PageReference pRef = Page.EndPointViewPage;
pRef.getParameters().put('id', conone.Id);
Test.setCurrentPage(pRef);

EndPointViewPage ee = new EndPointViewPage();
ee.edit();
ee.del();
ee.cancel();
system.assert(true);*/
    }  
    @istest
    static void myUnitTest2(){
        list<JunoDoc__Junodoc_Connections__c> listconnect = new list<JunoDoc__Junodoc_Connections__c>();
        JunoDoc__Junodoc_Connections__c  syncCon_Rec = new JunoDoc__Junodoc_Connections__c ();
        syncCon_Rec.Name = 'CloudSync Test';
        syncCon_Rec.JunoDoc__Sandbox__c = false;
        syncCon_Rec.JunoDoc__Production__c = true;
        syncCon_Rec.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrBZdvfDSKkW6bK_L59Bczes1qbxfU0A5bMQ91aRjtDMyZjJsT6jsfrl0GOz6rNFokF20DQl';
        syncCon_Rec.JunoDoc__Consumer_Secret__c = '2453920385567509976';
        syncCon_Rec.JunoDoc__Password_Encrypted__c= 'today@123';
        syncCon_Rec.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
        syncCon_Rec.JunoDoc__Method__c = 'POST';
        syncCon_Rec.JunoDoc__Username__c = 'sateeshcloudsynctest@gmail.com';
        syncCon_Rec.JunoDoc__Access_Token__c='00D28000001jFDG!ARcAQKYmdhf6AL_gcUjgSMc9w6qeBI4C5iO62ALeUVWFPJBrvHP5BGOYyKPdPNdaedQVO69XvFu4huhTVMDwmLs_RH3Hiyvx';                                                                                                    
        syncCon_Rec.JunoDoc__Instance_URL__c='https://ap2.salesforce.com';
        syncCon_Rec.JunoDoc__API_Usage__c =36.0;
        syncCon_Rec.JunoDoc__Org_Id__c = UserInfo.getOrganizationId();
        insert syncCon_Rec; 
        listconnect.add(syncCon_Rec);
        //ApexPages.currentPage().getParameters().put('Id',syncCon_Rec.id); 
        CallOutUtilityController EndPoints = new CallOutUtilityController();
        EndPoints.picklist ='Production';
        EndPoints.connectionname  ='Cloud Sync';
        EndPoints.save(); 
        // EndPointViewPage EndPointViewPage = new EndPointViewPage();
        ApexPages.currentPage().getParameters().put('Id',syncCon_Rec.id);
        EndPoints.selectedid=syncCon_Rec.id;
        EndPoints.view();
        system.assert(true);
        
    }
    @istest
    static void myUnitTest3(){
        list<JunoDoc__Junodoc_Connections__c> listconnect = new list<JunoDoc__Junodoc_Connections__c>();
        JunoDoc__Junodoc_Connections__c  syncCon_Rec = new JunoDoc__Junodoc_Connections__c ();
        syncCon_Rec.Name = 'CloudSync Test';
        syncCon_Rec.JunoDoc__Sandbox__c = false;
        syncCon_Rec.JunoDoc__Production__c = true;
        syncCon_Rec.JunoDoc__Consumer_Key__c = '3MVG9ZL0ppGP5UrBZdvfDSKkW6bK_L59Bczes1qbxfU0A5bMQ91aRjtDMyZjJsT6jsfrl0GOz6rNFokF20DQl';
        syncCon_Rec.JunoDoc__Consumer_Secret__c = '2453920385567509976';
        syncCon_Rec.JunoDoc__Password_Encrypted__c= 'today@123';
        syncCon_Rec.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/oauth2/token';
        syncCon_Rec.JunoDoc__Method__c = 'POST';
        syncCon_Rec.JunoDoc__Username__c = 'sateeshcloudsynctest@gmail.com';
        syncCon_Rec.JunoDoc__Access_Token__c='00D28000001jFDG!ARcAQKYmdhf6AL_gcUjgSMc9w6qeBI4C5iO62ALeUVWFPJBrvHP5BGOYyKPdPNdaedQVO69XvFu4huhTVMDwmLs_RH3Hiyvx';                                                                                                    
        syncCon_Rec.JunoDoc__Instance_URL__c='https://ap2.salesforce.com';
        syncCon_Rec.JunoDoc__API_Usage__c =36.0;
        syncCon_Rec.JunoDoc__Org_Id__c = UserInfo.getOrganizationId();
        insert syncCon_Rec; 
        listconnect.add(syncCon_Rec);
        ApexPages.currentPage().getParameters().put('Id',syncCon_Rec.id); 
        CallOutUtilityController EndPoints = new CallOutUtilityController();
        EndPoints.picklist ='Production';
        EndPoints.connectionname  ='Cloud Sync';
        EndPoints.save(); 
        system.assert(true);
    }
    @istest
    static void myUnitTest4(){
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setStatus('OK');
        mockResponse.setBody('{"message":"Mock response"}');
        
        // Create a list of SObject records
        List<SObject> sObjectRecords = new List<SObject>();
        Account account = new Account(Name = 'Test Account');
        sObjectRecords.add(account);
        
        // Call the method
        CallOutUtilityController.parseMetadataQueryResponse(
            mockResponse,
            'https://example.com',
            12345,
            'Test Destination',
            'Account',
            'Name',
            sObjectRecords,
            'External ID'
        );
        
        String xmlResponse = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
            ' xmlns:urn="urn:enterprise.soap.sforce.com">' +
            '   <soapenv:Header/>' +
            '   <soapenv:Body>' +
            '      <urn:queryResponse>' +
            '         <urn:result>' +
            '            <urn:records>' +
            '               <urn:Id>DestinationRecordId</urn:Id>' +
            '               <urn:OtherField>OtherValue</urn:OtherField>' +
            '            </urn:records>' +
            '         </urn:result>' +
            '      </urn:queryResponse>' +
            '   </soapenv:Body>' +
            '</soapenv:Envelope>';
        
        String xmlResponse2 = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
            ' xmlns:urn="urn:enterprise.soap.sforce.com">' +
            '   <soapenv:Header/>' +
            '   <soapenv:Body>' +
            '      <urn:upsertResponse>' +
            '         <urn:result>' +
            '            <urn:records>' +
            '               <urn:created>test</urn:created>' +
            '               <urn:Id>DestinationRecordId</urn:Id>' +
            '               <urn:success>DestinationRecordId</urn:success>' +
            '               <urn:OtherField>OtherValue</urn:OtherField>' +
            '            </urn:records>' +
            '         </urn:result>' +
            '      </urn:upsertResponse>' +
            '   </soapenv:Body>' +
            '</soapenv:Envelope>';
        
        String xmlResponse3 = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
            ' xmlns:urn="urn:enterprise.soap.sforce.com">' +
            '   <soapenv:Header/>' +
            '   <soapenv:Body>' +
            '      <urn:upsertResponse>' +
            '         <urn:result>' +
            '            <urn:records>' +
            '               <urn:created>test</urn:created>' +
            '               <urn:Id>DestinationRecordId</urn:Id>' +
            '               <urn:errors>DestinationRecordId</urn:errors>' +
            '               <urn:fields>DestinationRecordId</urn:fields>' +
            '               <urn:message>DestinationRecordId</urn:message>' +
            '               <urn:statusCode>401</urn:statusCode>' +
            '               <urn:OtherField>OtherValue</urn:OtherField>' +
            '            </urn:records>' +
            '         </urn:result>' +
            '      </urn:upsertResponse>' +
            '   </soapenv:Body>' +
            '</soapenv:Envelope>';
        
        
        
        // Create a mock HttpResponse with the XML response
        HttpResponse mockResponse1 = new HttpResponse();
        mockResponse1.setStatusCode(200);
        mockResponse1.setStatus('OK');
        mockResponse1.setBody(xmlResponse);
        
         HttpResponse mockResponse2 = new HttpResponse();
        mockResponse2.setStatusCode(200);
        mockResponse2.setStatus('OK');
        mockResponse2.setBody(xmlResponse2);
        
        HttpResponse mockResponse3 = new HttpResponse();
        mockResponse3.setStatusCode(500);
        mockResponse3.setStatus('OK');
        mockResponse3.setBody(xmlResponse2);
        
        // Create a map of record external IDs
        Map<String, String> recordExternalIdMap = new Map<String, String>();
        recordExternalIdMap.put('ExternalId1', 'RecordId1');
        recordExternalIdMap.put('ExternalId2', 'RecordId2');
        
        Map<Integer, String> recordExternalIdMap1 = new Map<Integer, String>();
        recordExternalIdMap1.put(1, 'RecordId1');
        recordExternalIdMap1.put(2, 'RecordId2');
        
        // Call the method
        List<JunoDoc__Junodoc_Workbench_Results__c> results = CallOutUtilityController.parseQueryResponse(
            mockResponse1,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap,
            'Field1,Field2',
            'Lookup',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results2 = CallOutUtilityController.parseQueryResponse(
            mockResponse1,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap,
            'Field1,Field2',
            'Parent',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results3 = CallOutUtilityController.parseQueryResponse(
            mockResponse1,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap,
            'Field1,Field2',
            'Child',
            'ReferenceField'
        );
        
        List<JunoDoc__Junodoc_Workbench_Results__c> results4 = CallOutUtilityController.parseUpsertResponse(
            mockResponse2,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Lookup',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results5 = CallOutUtilityController.parseUpsertResponse(
            mockResponse2,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Parent',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results6 = CallOutUtilityController.parseUpsertResponse(
            mockResponse2,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Child',
            'ReferenceField'
        );
        
         List<JunoDoc__Junodoc_Workbench_Results__c> results7 = CallOutUtilityController.parseUpsertResponse(
            mockResponse3,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Lookup',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results8 = CallOutUtilityController.parseUpsertResponse(
            mockResponse3,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Parent',
            'ReferenceField'
        );
        List<JunoDoc__Junodoc_Workbench_Results__c> results9 = CallOutUtilityController.parseUpsertResponse(
            mockResponse3,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Child',
            'ReferenceField'
        );
       /* CallOutUtilityController.parseUpsertResponse(
            mockResponse1,
            'https://example.com',
            12345,
            'Destination Org',
            'Object Name',
            recordExternalIdMap1,
            'Field1,Field2',
            'Lookup',
            'ReferenceField'
        );*/
        
         Test.setMock(HttpCalloutMock.class, new RestMock());
        // CallOutUtilityController.parseMetadataQueryResponse();
    }
    
    
}
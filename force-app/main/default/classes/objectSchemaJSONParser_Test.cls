@isTest
public class objectSchemaJSONParser_Test {
 @isTest
    static void testRecordTypesParsing() {
        // Mock JSON string
        String jsonString = '{"name":"RecordType1","recordTypeId":"0123456789ABCDEF"}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call the RecordTypes constructor and pass the parser
        objectSchemaJSONParser.RecordTypes recordType = new objectSchemaJSONParser.RecordTypes(parser);

        // Assert the values
        System.assertEquals('RecordType1', recordType.name);
        System.assertEquals('0123456789ABCDEF', recordType.recordTypeId);
    }

  
 @isTest
    static void testFieldsParsing() {
        // Mock JSON string
        String jsonString = '{"externalId":true,"label":"Test Label","name":"TestName","nameField":true,"type":"Text","unique":true}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call the Fields constructor and pass the parser
        objectSchemaJSONParser fields = new objectSchemaJSONParser(parser);

      
    }

        @isTest
    static void testResultsParsing() {
        // Mock JSON string
        String jsonString = '{"statusCode":200,"result":{"someField":"someValue"}}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call the Results constructor and pass the parser
       objectSchemaJSONParser results = new objectSchemaJSONParser(parser);
          //  results.Results(parser);
    }

  
 @isTest
    static void testParse() {
        // Test JSON data
        String jsonData = '{"fields": [{"name": "Field1", "type": "Text"}, {"name": "Field2", "type": "Number"}],' +
                          '"keyPrefix": "ABC", "label": "Test Object", "labelPlural": "Test Objects", ' +
                          '"name": "TestObject", "recordTypeInfos": [{"name": "RecordType1"}, {"name": "RecordType2"}]}';
        
        // Call the parse method
        objectSchemaJSONParser result =  objectSchemaJSONParser.parse(jsonData);
        
        
      
    }
    /* 
       @isTest
    static void testConsumeObjecta() {
        // Mock JSON string
        String jsonString = '{"statusCode":200,"result":{"someField":"someValue"}}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call consumeObject method
        
        objectSchemaJSONParser.consumeObject(parser);

        // Assert that parser moves to the end of the object
      //  System.assertEquals(JSONToken.END_OBJECT, parser.getCurrentToken());
    }
 @isTest
    static void testConsumeObjects() {
        // Mock JSON string
        String jsonString = '{"externalId":true,"label":"Test Label","name":"TestName","nameField":true,"type":"Text","unique":true}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call consumeObject method
        objectSchemaJSONParser.consumeObject(parser);

        // Assert that parser moves to the end of the object
      //  System.assertEquals(JSONToken.END_OBJECT, parser.getCurrentToken());
    }
  @isTest
    static void testConsumeObject() {
        // Mock JSON string
        String jsonString = '{"name":"RecordType1","recordTypeId":"0123456789ABCDEF","otherField":"OtherValue"}';

        // Create a JSONParser instance
        JSONParser parser = JSON.createParser(jsonString);

        // Call consumeObject method
        objectSchemaJSONParser.consumeObject(parser);

        // Assert that parser moves to the end of the object
     //   System.assertEquals(JSONToken.END_OBJECT, parser.getCurrentToken());
    }


*/
    @isTest
    static void testObjectSchemaParsing() {
        // Create test JSON input
        String jsonInput = '{"externalId":true,"label":"Test Label","name":"TestName","nameField":true,"type":"TestType","unique":false}';
        
        // Create a new instance of JSONParser with the input JSON
        JSONParser parser = JSON.createParser(jsonInput);
        
        // Create a new instance of the objectSchemaJSONParser.Fields class passing the JSONParser instance
        objectSchemaJSONParser.Fields fields = new objectSchemaJSONParser.Fields(parser);
        
    }
 
    @isTest
    static void testObjectParsing() {
        // Create a mock JSON response
        String jsonResponse = '{"statusCode": 200, "result": {"name": "Test Object"}}';
        
        // Create a new instance of JSONParser and pass the mock JSON response
        JSONParser parser = JSON.createParser(jsonResponse);
        
        // Create an instance of the class to test
        objectSchemaJSONParser.Results parsedResults = new objectSchemaJSONParser.Results(parser);
        
}


}
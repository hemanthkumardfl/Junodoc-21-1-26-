public with sharing class objectSchemaJSONParser { 
    public static void consumeObject(JSONParser parser) {
        //system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+parser);  
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    public class RecordTypes{
        public string name {get;set;}
        public string recordTypeId {get;set;}
        public RecordTypes(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } 
                        else  if (text == 'recordTypeId') {
                            recordTypeId = parser.getText();
                        } 
                        
                        
                        else {
                            System.debug(LoggingLevel.WARN, 'Fields consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    public class Fields {
        public Boolean externalId {get;set;} 
        public String label {get;set;} 
        public String name {get;set;} 
        public Boolean nameField {get;set;} 
        public String type_Z {get;set;}
        public Boolean unique {get;set;}

        public Fields(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'externalId') {
                            externalId = parser.getBooleanValue();
                        } 
                        else  if (text == 'label') {
                            label = parser.getText();
                        } 
                        else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'nameField') {
                            nameField = parser.getBooleanValue();
                        } 
                        else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'unique') {
                            unique = parser.getBooleanValue();
                        } 
                        else {
                            System.debug(LoggingLevel.WARN, 'Fields consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Boolean hasErrors {get;set;} 
    public List<Results> results {get;set;} 

    public objectSchemaJSONParser(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'hasErrors') {
                        hasErrors = parser.getBooleanValue();
                    } else if (text == 'results') {
                        results = new List<Results>();
                        while (parser.nextToken() != JSONToken.END_ARRAY) {
                            results.add(new Results(parser));
                        }
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Results {
        public Integer statusCode {get;set;} 
        public Result result {get;set;} 

        public Results(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'statusCode') {
                            statusCode = parser.getIntegerValue();
                        } else if (text == 'result') {
                            result = new Result(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Results consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    public class Result {
        public List<Fields> fields {get;set;} 
        public List<RecordTypes> recordTypes {get;set;} 
        public String keyPrefix {get;set;} 
        public String label {get;set;} 
        public String labelPlural {get;set;} 
        public String name {get;set;} 
        public Result(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'fields') {
                            fields = new List<Fields>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                fields.add(new Fields(parser));
                            }
                        } else if (text == 'keyPrefix') {
                            keyPrefix = parser.getText();
                        } else if (text == 'label') {
                            label = parser.getText();
                        } else if (text == 'labelPlural') {
                            labelPlural = parser.getText();
                        } 
                        else if (text == 'name') {
                            name = parser.getText();
                        } 
                        else if(text == 'recordTypeInfos'){
                            recordTypes = new List<RecordTypes>(); 
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                recordTypes.add(new RecordTypes(parser));
                            }
                        }
                        else {
                            System.debug(LoggingLevel.WARN, 'Result consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    public static objectSchemaJSONParser parse(String json) {
        return new objectSchemaJSONParser(System.JSON.createParser(json));
    }
}
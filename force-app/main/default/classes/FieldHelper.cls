public class FieldHelper {
    public static String getAllFieldsForObject(String objectName) {
        // Get the global describe for all SObjects
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

        // Find the SObjectType for the given object name
        Schema.SObjectType sObjectType = globalDescribeMap.get(objectName);

        // If the object exists, get its fields
        if (sObjectType != null) {
            // Get the field map for the SObjectType
            Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();

            // Create a list to hold field names
            List<String> fieldNames = new List<String>();

            // Iterate through the field map and add field API names to the list
            for (String fieldName : fieldMap.keySet()) {
                fieldNames.add(fieldName);
            }

            // Join the field names into a comma-separated string
            return String.join(fieldNames, ','); // Corrected line
        } else {
            // If the object is not found, return an empty string or an appropriate message
            return 'Object not found';
        }
    }
}
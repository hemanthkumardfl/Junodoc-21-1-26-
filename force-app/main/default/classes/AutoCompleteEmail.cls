global class AutoCompleteEmail {
    @AuraEnabled
    global static List<RecordsData> fetchRecords(String objectName,String valueField, String filterField, String searchString, String values) {
       // try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            List<String> selectedvalues = (List<String>) JSON.deserialize(values, List<String>.class);
            String query = 'SELECT Id, ' +valueField+','+ filterField + ' FROM '+objectName;
            if(selectedvalues != null && selectedvalues.size() > 0) {
                query += ' WHERE Id IN: selectedvalues LIMIT 1000';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 1000';
            }
            for(SObject s : Database.query(query)) {
                system.debug('-------'+s);
                //recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get(valueField)) );
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get(valueField)) );
            }
            return recordsDataList;
       /* } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }*/
    }
    global class RecordsData {
        @AuraEnabled global String label;
        @AuraEnabled global String value;
        global RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}
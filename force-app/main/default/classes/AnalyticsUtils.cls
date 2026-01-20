public class AnalyticsUtils {
    public reportResponse reportData { get; set; }
    public String reportType { get; set; }
    public string reportId{get;set;}
     public string  sobjectName{get;set;}
    public list<string> ReportResponse() {
        //get the report result
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);     
        //get the metadata
        Reports.ReportMetadata reportMetadata = results.getReportMetadata();       
        reportType = 'Tabular';
        Integer groupingsDown = 0;
        Integer groupingsAcross = 0;
     
        List<Reports.GroupingInfo> groupingDownList = reportMetadata.getGroupingsDown();
        List<Reports.GroupingInfo> groupingAcrossList = reportMetadata.getGroupingsAcross();
     
        if (groupingDownList != null) {
            groupingsDown = groupingDownList.size();
        }
     
        if (groupingDownList != null) {
            groupingsAcross = groupingAcrossList.size();
        } 
        
         if ( (groupingsDown > 0) && (groupingsAcross == 0) ) {
            reportType = 'Summary'; 
        }
     
        if ( (groupingsDown > 0) && (groupingsAcross > 0) ) {
            reportType = 'matrix';  
        }       
          list<string> recordIds = new list<string>();
        if(reportType == 'Summary'){
            //find out what type of report it is by looking at the groupings down and groupings across
            recordIds = getSummaryReportResponse(results);
        }else if(reportType == 'Tabular'){
            recordIds = getTabularReportResponse(reportId);  
        }
       
        return recordIds;
    }
    
    public list<string> getTabularReportResponse(Id reportId) {
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Reports.ReportMetadata reportMetadata = results.getReportMetadata();
        List<String> fieldNames = reportMetadata.getDetailColumns();      
        Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();
        Map<String, Reports.DetailColumn> detailColumnMap = reportExtendedMetadata.getDetailColumnInfo();     
        //loop over the detailColumnMap and get the name, label, and data type
        for (String fieldName: fieldNames) {
          //  Reports.DetailColumn detailColumn = detailColumnMap.get(fieldName);  
        }
        // Get the fact map from the report results
        Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');         
        List<Reports.ReportDetailRow> reportDetailRowList = factDetails.getRows();
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(sobjectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        String keyPrefix = r.getKeyPrefix();
        list<string> recordIds = new  list<string>();
        set<string> setrecordIds = new  set<string>();
        //loop over the rows
        for (Reports.ReportDetailRow reportDetailRow: reportDetailRowList) {
            Integer cellCounter = 0;
            //loop over the cells in the row
            for (Reports.ReportDataCell reportDataCell: reportDetailRow.getDataCells()) {
                if(reportDataCell.getValue() != null){
                    if(string.valueof(reportDataCell.getValue()) != '' && string.valueof(reportDataCell.getValue()) != null){
                        if(string.valueof(reportDataCell.getValue()).startswith(keyPrefix) &&
                            !setrecordIds.contains(string.valueof(reportDataCell.getValue()))){
                            system.debug('reportDataCell *************' + reportDataCell.getValue());
                            recordIds.add((String)reportDataCell.getValue());  
                            setrecordIds.add((String)reportDataCell.getValue());
                        }
                    }
                }                               
            }     
        }     
        return recordIds;
    }
    
    public class reportResponse {
        public String reportType {get; set;}
        //public tabularReportResponse tabResp {get; set;}     
        public reportResponse(){}
    }  
    
    public static list<string> getSummaryReportResponse(Reports.ReportResults results) {    
        //get the metadata
        Reports.ReportMetadata reportMetadata = results.getReportMetadata();
     
        //get a string array of the field names
        List<String> fieldNames = reportMetadata.getDetailColumns();        
     
        //get the extended metadata
        Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();
       
        //get the map of the grouping column names to their name and label
        Map<String, Reports.GroupingColumn> groupingColumnMap = reportExtendedMetadata.getGroupingColumnInfo();       
     
        //get the grouping column info
        Reports.GroupingInfo groupingInfo = reportMetadata.getGroupingsDown()[0]; //only supports one grouping level
        Reports.GroupingColumn groupingColumnDetail = groupingColumnMap.get(groupingInfo.getName());                
    
        //get the summary grouping down dimension grouping values.  only going 1 level deep   
        list<string> recordIds = new  list<string>();
        for (Reports.GroupingValue groupingValue: results.getGroupingsDown().getGroupings()) {       
            recordIds.add((String)groupingValue.getValue());  
        }
        return recordIds;
    }    
}
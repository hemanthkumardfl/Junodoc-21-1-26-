public class JunoSignDocumentSelectorCntrl {
    
    @AuraEnabled(cacheable=true)
    public static ContentDocumentWrapper getDocuments(
        String recordId,
        Integer pageSize,
        Integer pageNumber,
        String searchKey
    ) {
        System.debug('recordId: ' + recordId);
        System.debug('pageSize: ' + pageSize + ', pageNumber: ' + pageNumber);
        System.debug('searchKey: ' + searchKey);
        
        List<ContentDocumentClass> MasterBudgetsClassList = new List<ContentDocumentClass>();
        
        // Count total records for pagination info
        String countQuery = 'SELECT COUNT() FROM ContentDocumentLink WHERE LinkedEntityId = :recordId';
        if (!String.isBlank(searchKey)) {
            countQuery += ' AND ContentDocument.Title LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        }
        Integer totalCount = (Integer)Database.countQuery(countQuery);
        String fileType = 'PDF';
        // Build main query
        String baseQuery = 'SELECT ContentDocumentId, ContentDocument.Title, LinkedEntityId ' +
            'FROM ContentDocumentLink ' +
            'WHERE LinkedEntityId = :recordId';// AND ContentDocument.FileType = :fileType';
        
        if (!String.isBlank(searchKey)) {
            baseQuery += ' AND ContentDocument.Title LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        }
        
        baseQuery += ' ORDER BY ContentDocumentId DESC ';
        
        Integer offsetVal = (pageNumber - 1) * pageSize;
        baseQuery += ' LIMIT ' + pageSize + ' OFFSET ' + offsetVal;
        
        System.debug('SOQL: ' + baseQuery);
        
        List<ContentDocumentLink> rfqList = Database.query(baseQuery);
        
        for (ContentDocumentLink bud : rfqList) {
            ContentDocumentClass MasterBudgetsClassRecord = new ContentDocumentClass();
            MasterBudgetsClassRecord.budgetRecord = bud;
            MasterBudgetsClassRecord.budgetCheck = false;
            MasterBudgetsClassList.add(MasterBudgetsClassRecord);
        }
        
        ContentDocumentWrapper result = new ContentDocumentWrapper();
        result.records = MasterBudgetsClassList;
        result.totalCount = totalCount;
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        
        return result;
    }
    
    public class ContentDocumentClass {
        @AuraEnabled public ContentDocumentLink budgetRecord { get; set; }
        @AuraEnabled public Boolean budgetCheck { get; set; }
    }
    
    public class ContentDocumentWrapper {
        @AuraEnabled public List<ContentDocumentClass> records { get; set; }
        @AuraEnabled public Integer totalCount { get; set; }
        @AuraEnabled public Integer pageSize { get; set; }
        @AuraEnabled public Integer pageNumber { get; set; }
    }
    
    @AuraEnabled(cacheable=true)
    public static InnerDocTemplates getAvailableDocTemplates(
        Id recordId, 
        Integer pageSize, 
        Integer pageNumber, 
        String searchKey
    ) {
        System.debug('recordId: ' + recordId);
        System.debug('pageSize: ' + pageSize + ' pageNumber: ' + pageNumber);
        System.debug('searchKey: ' + searchKey);
        
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        String TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        
        String DocTemplateField = '';
        DocTemplateField = String.valueOf(objectFieldsMap.get('JunoDoc__Doc_Template__c'));
        if(String.isBlank(DocTemplateField)) {
            DocTemplateField = String.valueOf(objectFieldsMap.get('Doc_Template__c'));
        }
        System.debug('DocTemplateField: ' + DocTemplateField);
        
        if(DocTemplateField == 'JunoDoc__Doc_Template__c' || DocTemplateField == 'Doc_Template__c') {
            String query = 'SELECT Id, Doc_Template__c FROM ' + sObjName + ' WHERE Id = :recordId';
            SObject record = Database.query(query);
            TemplateID = String.valueOf(record.get('Doc_Template__c'));
        }
        
        if(String.isBlank(TemplateID)) {
            TemplateID = '';
        }
        
        List<DocTemplatesWrap> AvailableDocTemplatesList = new List<DocTemplatesWrap>();
        
        String baseQuery = 'SELECT Id, Name FROM Doc_Template__c ' +
            'WHERE Parent_Object__c = :sObjName ' +
            'AND JunoDoc__Show_Templates__c = false';
        
        if (!String.isBlank(searchKey)) {
            baseQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        }
        Integer offsetVal = (pageNumber - 1) * pageSize;
        
        
        baseQuery += ' ORDER BY CreatedDate DESC';
        baseQuery += ' LIMIT ' + pageSize + ' OFFSET ' + offsetVal;
        
        List<Doc_Template__c> availableDocList = Database.query(baseQuery);
        
        
        for(Doc_Template__c rec : availableDocList) {
            DocTemplatesWrap obj = new DocTemplatesWrap();
            obj.label = rec.Name;
            obj.value = rec.Id;
            obj.type = 'template';
            AvailableDocTemplatesList.add(obj);
        }
        
        InnerDocTemplates result = new InnerDocTemplates();
        result.AvailableDocTemplatesList = AvailableDocTemplatesList;
        result.DocTemplateId = TemplateID;
        result.ObjectAPIName = sObjName;
        return result;
    }
    
    public class InnerDocTemplates {
        @AuraEnabled public List<DocTemplatesWrap> AvailableDocTemplatesList;
        @AuraEnabled public String DocTemplateId;
        @AuraEnabled public String ObjectAPIName;
    }
    
    public class DocTemplatesWrap {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String type;
    }
}
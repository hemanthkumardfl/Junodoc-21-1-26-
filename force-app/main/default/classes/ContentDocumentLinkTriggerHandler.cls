public class ContentDocumentLinkTriggerHandler {
    public static void onAfterInsert(list<ContentDocumentLink> lstCntLinks){
        system.debug('trigger fired');
        Set<Id> setCntDocIds = new set<Id>();
        set<Id> setAccIds = new set<Id>();
        string contentDocId;
        map<Id, Doc_Template__c> mapAccs;
        
        Map<Id, Id> ClinkVsdocIdMap = new  Map<Id, Id>(); // will hold documnet record id and content link id
        Map<Id, Id> cLinkIdVsCdocIdMap = new  Map<Id, Id>(); // will hold content link id and content documnet id
        
        for(ContentDocumentLink clIterator : lstCntLinks) {
                setCntDocIds.add(clIterator.ContentDocumentId);
                setAccIds.add(clIterator.LinkedEntityId);
           		 contentDocId = clIterator.ContentDocumentId;
            	system.debug('contentDocId @@@@@@' + contentDocId);
            	//cLinkIdVsCdocIdMap.put(clIterator.Id, clIterator.ContentDocumentId);
            	//docIdVsClinkMap.put(doc.Id, )
            
        }
        system.debug('setCntDocIds size@@@@@@' + setCntDocIds.size());
        system.debug('setAccIds size@@@@@@' + setAccIds.size());
        if(!setCntDocIds.isEmpty()) {
            if(!setAccIds.isEmpty()) {
               list<Doc_Template__c> documentRecords = [SELECT Id, Name FROM Doc_Template__c WHERE Id IN :setAccIds];
                list<Doc_Template__c> updateDocumentRecords = new list<Doc_Template__c>();
                system.debug('documentRecords size@@@@@' + documentRecords.size());
                for(Doc_Template__c doc : documentRecords){
                    system.debug('doc @@@@@@@'+doc);
                    doc.File_Id__c = contentDocId;
                   	updateDocumentRecords.add(doc);
                }
                if(updateDocumentRecords.size() > 0){
                    update updateDocumentRecords;
                    system.debug('updated @@@@@@');
                }
                else{
                    system.debug('updateDocumentRecords size @@@@@@@@'+updateDocumentRecords.size());
                }
            }
        }
    }

}
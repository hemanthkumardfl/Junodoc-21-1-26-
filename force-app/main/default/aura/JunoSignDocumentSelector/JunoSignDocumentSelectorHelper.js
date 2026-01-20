({
    fetchTemplates: function(component) {
        let action = component.get("c.getAvailableDocTemplates");
        action.setParams({
            recordId: component.get("v.recordId"),
            pageSize: component.get("v.pageSize"),
            pageNumber: component.get("v.templatesPageNumber"),
            searchKey: component.get("v.searchTerm")
        });
        
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                component.set("v.templates", result.AvailableDocTemplatesList);
                component.set("v.templatesTotalRecords", result.AvailableDocTemplatesList.length < component.get("v.pageSize") && result.AvailableDocTemplatesList.length > 0 ? 
                              result.AvailableDocTemplatesList.length : 1000); // Replace with real totalCount if available
                
                let templates = component.get("v.templates");
                if(templates){
                    
                    let defaultDoc = component.get("v.defaultDocTemplate");
                    let noDefaultDoc = true
                    
                    
                    if(!noDefaultDoc){
                        let exists = templates.some(function(t) {
                            return t.value === defaultDoc.value;
                        });
                        
                        if (!exists) {
                            templates.unshift(defaultDoc);
                        } else {
                            // If default already exists, ensure its isSelected is true
                            
                            let documentId=null
                            templates=  templates.map(function(t) {
                                return Object.assign({}, t, {
                                    isSelected: documentId ? t.value === documentId : false,
                                    type: 'records'
                                });
                            });
                            
                            templates = templates.map(function(t) {
                                if (t.value === defaultDoc.value) {
                                    t.isSelected = true;
                                }
                                return t;
                            });
                        } 
                    }
                    
                    
                    component.set("v.templates", templates);
                }
            } else {
                console.error(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchRecordFiles: function(component) {
        let action = component.get("c.getDocuments");
        action.setParams({
            recordId: component.get("v.recordId"),
            pageSize: component.get("v.pageSize"),
            pageNumber: component.get("v.recordsPageNumber"),
            searchKey: component.get("v.searchTerm")
        });
        
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                component.set("v.recordFiles", result.records);
                component.set("v.recordsTotalRecords", result.totalCount);
                if(component.get("v.recordFiles")){
                    let documentId = null
                    var recordFiles = component.get("v.recordFiles").map(function(t) {
                        return Object.assign({}, t, {
                            isSelected: documentId ? t.budgetRecord.ContentDocumentId === documentId : false,
                            type: 'records'
                        });
                    });
                    
                    component.set("v.recordFiles", recordFiles);
                }
            } else {
                console.error(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
})
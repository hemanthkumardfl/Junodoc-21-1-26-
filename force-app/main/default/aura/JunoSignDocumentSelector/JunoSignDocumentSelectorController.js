({
    doInit: function(component, event, helper) {
        // Initialize component
        console.log('Document Selector initialized');
        helper.fetchTemplates(component);
        helper.fetchRecordFiles(component);
        
        let documentId = null
        
        let defaultDoc = component.get("v.defaultDocTemplate");
        let noDefaultDoc = true
        
        if(defaultDoc && defaultDoc.value){
            // Mark the selectedDocument to match default
            component.set("v.selectedDocument", {
                id: defaultDoc.value,
                name: defaultDoc.label,
                type: "template"
            });
            noDefaultDoc = false
        }
        
    },
    
    handleTabChange: function(component, event, helper) {
        debugger
        var selectedTabId = event.getParam("id");
        component.set("v.activeTab", selectedTab);
        
        // Clear search term when switching tabs
        component.set("v.searchTerm", "");
        
        // Clear selected document when switching tabs
        component.set("v.selectedDocument", null);
        
        
       /* if(selectedTabId === 'template'){
            component.set("v.templatesPageNumber", 1);
            helper.fetchTemplates(component);
        } else if(selectedTabId === 'records'){
            component.set("v.recordsPageNumber", 1);
            helper.fetchRecordFiles(component);
        }*/
        
    },
    
    handleSearch: function(component, event, helper) {
        component.set("v.pageNumber", 1);
        if(component.get("v.activeTab") === 'template'){
            helper.fetchTemplates(component);
        } else if(component.get("v.activeTab") === 'records'){
            helper.fetchRecordFiles(component);
        }
    },
    
    handleNext: function(component, event, helper) {
        if(component.get("v.activeTab") === 'template'){
            component.set("v.templatesPageNumber", component.get("v.templatesPageNumber") + 1);
            helper.fetchTemplates(component);
        } else if(component.get("v.activeTab") === 'records'){
            component.set("v.recordsPageNumber", component.get("v.recordsPageNumber") + 1);
            helper.fetchRecordFiles(component);
        }
    },
    
    handlePrevious: function(component, event, helper) {
        if(component.get("v.activeTab") === 'template'){
            let pageNum = component.get("v.templatesPageNumber");
            if (pageNum > 1) {
                component.set("v.templatesPageNumber", pageNum - 1);
                helper.fetchTemplates(component);
            }
        } else if(component.get("v.activeTab") === 'records'){
            let pageNum = component.get("v.recordsPageNumber");
            if (pageNum > 1) {
                component.set("v.recordsPageNumber", pageNum - 1);
                helper.fetchRecordFiles(component);
            }
        }
    },

    
    handleDocumentSelect: function(component, event, helper) {
        var documentId = event.currentTarget.dataset.id;
        var documentType = event.currentTarget.dataset.type;
        
        let selectedDocument = null;
        
        if (documentType === "template") {
            var templates = component.get("v.templates");
            selectedDocument = templates.find(function(template) {
                return template.value === documentId;
            });
            selectedDocument.type = 'template'
            templates = component.get("v.templates").map(function(t) {
                return Object.assign({}, t, {
                    isSelected: documentId ? t.value === documentId : false
                });
            });
            component.set("v.templates", templates);
            
            var recordFiles = component.get("v.recordFiles");
            recordFiles = component.get("v.recordFiles").map(function(t) {
                return Object.assign({}, t, {
                    isSelected: documentId ? t.budgetRecord.ContentDocumentId === documentId : false
                });
            });
            component.set("v.recordFiles", recordFiles);
            
        } else if (documentType === 'records') {
            var recordFiles = component.get("v.recordFiles");
            selectedDocument = recordFiles.find(function(record) {
                return record.budgetRecord.ContentDocumentId === documentId;
            });
            recordFiles = component.get("v.recordFiles").map(function(t) {
                return Object.assign({}, t, {
                    isSelected: documentId ? t.budgetRecord.ContentDocumentId === documentId : false
                });
            });
            selectedDocument = selectedDocument.budgetRecord;
            selectedDocument.value = selectedDocument.ContentDocumentId;
            selectedDocument.label = selectedDocument.ContentDocument.Title;
            selectedDocument.type = "records"
            component.set("v.recordFiles", recordFiles);
            
            var templates = component.get("v.templates");
       
            templates = component.get("v.templates").map(function(t) {
                return Object.assign({}, t, {
                    isSelected: documentId ? t.value === documentId : false
                });
            });
            component.set("v.templates", templates);
        }
        
        if (selectedDocument) {
            var newSelectedDocument = Object.assign({}, selectedDocument);
            component.set("v.selectedDocument", newSelectedDocument);
            var compEvent = component.getEvent("docSelectorEvt");
            compEvent.setParams({
                "selectedDocument" : selectedDocument // Get data from child's attribute
            });
            compEvent.fire();
            // Show success toast
             var toastEvent = window.$A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Document Selected",
                "message": "Selected: " + selectedDocument.label,
                "type": "success",
                "duration": 2000
            });
            toastEvent.fire();
        }
        
    },
    
    handleFileUpload: function(component, event, helper) {
        // Handle file upload logic
       // console.log('File upload clicked');
        
        // You would typically open a file picker here
        // For demo purposes, we'll simulate a file selection
        var mockFile = {
            id: 'upload_1',
            name: 'Uploaded Document.pdf',
            type: 'PDF',
            size: '1.5 MB',
            date: new Date().toISOString().split('T')[0]
        };
        
        component.set("v.selectedDocument", mockFile);
        
        var toastEvent = window.$A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "File Uploaded",
            "message": "File uploaded successfully",
            "type": "success"
        });
        toastEvent.fire();
    },
    
    handleChangeDocument: function(component, event, helper) {
        component.set("v.selectedDocument", null);
        
        var toastEvent = window.$A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Selection Cleared",
            "message": "Please select a new document",
            "type": "info"
        });
        toastEvent.fire();
    },
    
    handleContinueToSign: function(component, event, helper) {
        var selectedDocument = component.get("v.selectedDocument");
        
        if (selectedDocument) {
            // Navigate to signing page or fire application event
            console.log('Continuing to sign document: ' + selectedDocument.name);
            
            // Fire application event to parent component
            var appEvent = window.$A.get("e.JunoDoc:DocumentSelectedEvent");
            appEvent.setParams({
                "selectedDocument": selectedDocument
            });
            appEvent.fire();
            
            var toastEvent = window.$A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Proceeding to Sign",
                "message": "Opening document for signing...",
                "type": "info"
            });
            toastEvent.fire();
        }
    },
    
    handleUploadFinished: function (component, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
        
        // Get the file name
        uploadedFiles.forEach(file => {
            console.log(file);
            component.set("v.selectedDocument", {
            value: file.documentId,
            label: file.name,
            type: 'upload'
        })
        
        //component.set("v.selectedDocument", selectedDocument);
        var compEvent = component.getEvent("docSelectorEvt");
        compEvent.setParams({
            "selectedDocument" : component.get("v.selectedDocument") // Get data from child's attribute
        });
        compEvent.fire();
    });
    
},

clearSelectedDocument : function(component, event, helper) {
    component.set("v.selectedDocument", null);
}
 })
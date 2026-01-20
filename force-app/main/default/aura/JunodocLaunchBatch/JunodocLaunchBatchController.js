({
	doInit : function(component, event, helper) {  
        component.set("v.spinner",true)
        component.set("v.ConsoleCount",0);
         var sessionId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getSessionId");

        action.setCallback(this, function(response) {
            var sessionId = response.getReturnValue();
            // Do something with the sessionId
            console.log('sessionId ****' + sessionId)
            component.set("v.sessionId",sessionId);
        });

        $A.enqueueAction(action);
        var recordId = component.get("v.recordId");
		var action = component.get("c.JunobatchData");  
        action.setParams({
            'recordId' : recordId
        }); 
        
        action.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.spinner",false)
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();                
                
                if(InnerResult.sobjectRecords.length > 0){
                    component.set("v.enablebuttons",false);
                }
                else{
                    component.set("v.enablebuttons",true);
                }
                component.set("v.sobjectrecords",InnerResult.sobjectRecords);
                component.set("v.childrecords",InnerResult.TriggerActions);
                component.set("v.DocTemplateId",InnerResult.DocTemplateId);  
                if(InnerResult.objectName != 'Case'){
                	component.set('v.columns', [
                                                { label: 'Name',  fieldName: 'nameUrl',type: 'url',
                                                typeAttributes: {label: { fieldName: 'Name'}, 
                                                target: '_top'},sortable: true},
                                                { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
                                                { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
                                        	]);
                }
                else if(InnerResult.objectName == 'Case'){
                   component.set('v.columns', [
                                        { label: 'Case Number',  fieldName: 'nameUrl',type: 'url',
                                        typeAttributes: {label: { fieldName: 'CaseNumber'}, 
                                        target: '_top'},sortable: true},
                                        { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
                                        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
        						]); 
                }        
            }
        });
        $A.enqueueAction(action);  
	},
    
    SinglePDFsDownload : function(component, event, helper) {
        
        var selectedRecords = component.get("v.sobjectrecords")
        var TemplateId = component.get("v.DocTemplateId")
        var recordIds=[];
        for(var i=0;i<selectedRecords.length;i++){
            recordIds.push(selectedRecords[i].Id);
        }
        for(var i=0;i<selectedRecords.length;i++){
                console.log(selectedRecords[i].Id);
                var url = '/apex/JunoDoc__Mainpages?id='+selectedRecords[i].Id+'&DocTemplateId='+TemplateId+'&Type=single';
            	helper.updatepostActions(component, event, helper,recordIds);
                window.open(url,"_blank");   
               // this.urlHelper(url);
            }
    },
    
    
    
    MultiplePDFsDownload : function(component, event, helper) {
        var recordIds=[];
        var selectedRecords = component.get("v.sobjectrecords")
        var TemplateId = component.get("v.DocTemplateId")
            for(var i=0;i<selectedRecords.length;i++){
                recordIds.push(selectedRecords[i].Id);
            }
            component.set("v.totalRecords",recordIds.length);
        	var chunks = [];
            var chunkSize = 25;
            for (var i = 0; i < recordIds.length; i += chunkSize) {
                var chunk = recordIds.slice(i, i + chunkSize);
                chunks.push(chunk);
            }
        	/*for(var k=0;k < chunks.length;k++){
                 var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(chunks[k])+'&DocTemplateId='+TemplateId+'&Type=multiple';
				  window.open(url,"_blank");
            }*/ 
        		var k=1; 
        		var l=50;
        		component.set("v.limitRec",l);
        		var output = '';
        		component.set("v.spinner",true);
        		component.set("v.showConsolidated",true);
        		//helper.getConsolidatedCount(component,event);
        		 helper.getMultiPDF(component,event,helper,0,recordIds,chunks)
              //  for(var m=0;m<recordIds.length;m++){
                    
               // } 
            
            
            console.log('chunks ' + chunks.length);  
            console.log('chunkSize ' + chunks);  
            
           // var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(recordIds)+'&DocTemplateId='+TemplateId+'&Type=multiple';
        	
          //	helper.updatepostActions(component, event, helper,recordIds);
          //  window.open(url,"_blank");
    	},
    
    
     updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
         var selectedIds = [];
        for(var i=0;i<selectedRows.length;i++){
            
            selectedIds.push(selectedRows[i].Id);
        }
         component.set("v.selectedrecordIds",selectedIds);
         
    }
})
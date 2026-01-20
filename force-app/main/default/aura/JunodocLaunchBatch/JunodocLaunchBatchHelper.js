({
	updatepostActions : function(component, event, helper,recordIds) {
        component.set("v.spinner",true)
		var action = component.get("c.junoActionUpdate"); 
        action.setParams({
            'recordIds' : JSON.stringify(recordIds),
            'childrecords' : component.get("v.childrecords"),
        }); 
        action.setCallback(this, function(response){
            component.set("v.spinner",false)
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var InnerResult = response.getReturnValue();
                if(InnerResult.isSuccess){
                    
                    if(component.get("v.VFPage") == false){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "The record has been updated successfully.",
                            "type": "success"
                        });
                        toastEvent.fire();
                         $A.get('e.force:refreshView').fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                    else{
                        window.open('/'+component.get("v.recordId"),'_self');
                    }
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": InnerResult.Errormesssage,
                        "type": "error"
                    });
                    toastEvent.fire();
                    
                }
            }
        });
        $A.enqueueAction(action);   
	},
    
    getConsolidatedCount: function(component, event) {
        var action = component.get("c.getConsolidatedData"); 
        action.setParams({
           'sessionId' : component.get("v.sessionId")
        }); 
        action.setCallback(this, function(response){
            component.set("v.ConsoleCount",response.getReturnValue())
            component.set("v.showConsolidated",true);
            var progress = (response.getReturnValue() / component.get("v.totalRecords")) * 100;
        
            // Set the progress value to an attribute for display
            component.set("v.progress", progress);
        });
        $A.enqueueAction(action);  
    },
    
    getMultiPDF: function(component, event,helper,k,recordIds,chunks) {
        var action = component.get("c.getMultiPDFData"); 
        action.setParams({
            'recordId' : recordIds[k],
            'TemplateId' : component.get("v.DocTemplateId"),
            'sessionId' : component.get("v.sessionId")
        }); 
        action.setCallback(this, function(response){
            
            var state = response.getState();
            component.set("v.spinner",false);
            if(state === "SUCCESS"){
                var output = component.get("v.output");
                // alert('response ***' + response.getReturnValue())
                output = output +','+ response.getReturnValue();
                component.set("v.output",output);
                component.set("v.ConsoleCount",k);
                var progress = (k / component.get("v.totalRecords")) * 100;
            
                // Set the progress value to an attribute for display
                component.set("v.progress", progress);
                var m = k+1;
                var l = component.get("v.limitRec");
                if(m == recordIds.length){
                    if(l != m){
                        var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(chunks[0])+'&DocTemplateId='+component.get("v.DocTemplateId")+'&Type=multiple&data='+ output;
                        window.open(url,"_blank");
                    }
                    helper.updatepostActions(component, event, helper,recordIds);
                }
                else{
                    this.getMultiPDF(component, event,helper,k+1,recordIds,chunks)
                }
                if(l==m){
                    
                    var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(chunks[0])+'&DocTemplateId='+component.get("v.DocTemplateId")+'&Type=multiple&data='+output;
                    window.open(url,"_blank");
                    component.set("v.output",'');
                    l = l+50;
                    component.get("v.limitRec",l);
                }
                
                
                
            }
        });
        $A.enqueueAction(action);  
    }
})
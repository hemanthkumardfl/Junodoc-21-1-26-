({
    doInit: function(component, event, helper) {
        component.set("v.Spinner",true);
        component.set("v.test1",'');
        var action = component.get("c.getObjectName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                var options = [];
                var allValues = response.getReturnValue();
                console.log(JSON.stringify(allValues));
                for(var i=0;i<allValues.length;i++){
                    options.push({
                        "label" : allValues[i].objectLabel,
                        "value" : allValues[i].objectName
                    });    
                }
                component.set("v.results", options);
                window.setTimeout(
                    $A.getCallback(function() {
                    }), 3000
                ); 
                component.set("v.Spinner",false); 
            }                    
            else if (state === "ERROR") {
                component.set("v.Spinner",false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    component.set("v.Spinner",false);
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action); 
       
       
    },
    
    
    searchAll : function (component, event, helper) {
        var showButton = component.get("v.showButton");
        if(showButton == true){
            component.set("v.showButton", false);	    
        }
        component.set("v.openDropDown", true);
    },
    searchHandler : function (component, event, helper) {
        helper.search(component, event, helper);
    },
    optionClickHandler : function (component, event, helper) {
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.accList",[]);
        component.set("v.SetReplyTo",'');
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        
        
        helper.openSendPDFModelHelper(component, event, helper);
        helper.fetchParentObjectOptions(component, event, helper,selectedValue);
       
        
        
        component.set("v.showButton", true);
        
    },
    
    
    
    record : function(component,event,helper){
        var inputValue = component.get("v.inputValue");
        var juno=component.get("v.test1");
        
        var standardemail= component.get("v.StandardEmailTemplateSelectedValue");
        
        var setreply=component.get("v.SetReplyTo");
       
        var fromemail=component.get("v.FromEmailAddress");
        var doctemplete=component.get("v.DocTemplates");
        
        var relatedemail=component.get("v.accList");
        var globalParentId = component.get("v.globalActivityParentId");
        
        var parentObjectName = component.get("v.parentObjectName");
        var childObjectName = component.get("v.childObjectName");
        var childObjectFieldName = component.get("v.childObjectFieldName");
        var parentObjectFieldName = component.get("v.parentObjectFieldName");
        var childObjectReplaceFieldName = component.get("v.childObjectReplaceFieldName");
        var attachAsPdf = component.get("v.attachAsPdf");
        var attachAsPdfParent = component.get("v.attachAsPdfParent");
       
      if(inputValue!=null && inputValue!='' && inputValue!=undefined){
        /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            var action = component.get("c.createrecord");
            action.setParams({
                "fromEmailAddress" :fromemail,
                "setReplyTo" : setreply,
                "standardEmailtemplates":standardemail,
                "junoDocEmailtemplates":juno,
                "selectedobject":inputValue,
                "docvalue":doctemplete,
                "emaillist":JSON.stringify(component.get("v.accList")),
                "globalParentId" : globalParentId,
                "parentObjectName" : parentObjectName,
                "childObjectName" : childObjectName,
                "childObjectFieldName" : childObjectFieldName,
                "parentObjectFieldName" : parentObjectFieldName,
                "childObjectReplaceFieldName" : childObjectReplaceFieldName,
                //"attachAsPdf" : attachAsPdf,
                //"attachAsPdfParent" : attachAsPdfParent,
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Saved Successfully"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
      
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select object"
            });
            toastEvent.fire();
        }
    },
    
    changejunoEmail : function(component,event,helper){
        if(component.get("v.StandardEmailTemplateSelectedValue") != "" ){
            component.set("v.test1",'')             
       }
    },
    
    changestandardEmail : function(component,event,helper){
        if(component.get("v.test1") != ""){
            component.set("v.StandardEmailTemplateSelectedValue",'')             
        }
    },
    
    
    goToUrl : function(component,event,helper){
        
        var action = component.get("c.getOrgUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result){
                    //alert("From server: " + response.getReturnValue());
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": result+'lightning/setup/OrgWideEmailAddresses/home'
                    });
                    urlEvent.fire();
                }
                else{
                    console.log('There is no Org Url in JunoDoc Settings');
                }
            }
            else if (state === "INCOMPLETE") {
                console.log("Incomplete");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    /* Added By Sainath on 09-Sep-2025 for Hide Attach as PDF and Save as Activity functionality */
    saveSetting : function(component,event,helper){
        var inputValue = component.get("v.inputValue");
        var juno=component.get("v.test1");
        
        var standardemail= component.get("v.StandardEmailTemplateSelectedValue");
        
        var setreply=component.get("v.SetReplyTo");
       
        var fromemail=component.get("v.FromEmailAddress");
        var doctemplete=component.get("v.DocTemplates");
        
        var relatedemail=component.get("v.accList");
        var globalParentId = component.get("v.globalActivityParentId");
        
        var parentObjectName = component.get("v.parentObjectName");
        var childObjectName = component.get("v.childObjectName");
        var childObjectFieldName = component.get("v.childObjectFieldName");
        var parentObjectFieldName = component.get("v.parentObjectFieldName");
        var childObjectReplaceFieldName = component.get("v.childObjectReplaceFieldName");
        
        //var attachAsPdf = component.get("v.attachAsPdf");
        //var attachAsPdfParent = component.get("v.attachAsPdfParent");
        
        var hideAttachAsPDF = component.get("v.hideAttachAsPDF");
        var hideSaveAsActivity = component.get("v.hideSaveAsActivity");
        let selectedParentObjects = component.get("v.selectedParentObjects");
        console.log('parentObjects >> '+selectedParentObjects);
        
      if(inputValue!=null && inputValue!='' && inputValue!=undefined){
          
        /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            var action = component.get("c.saveSettings");
            action.setParams({
                "fromEmailAddress" :fromemail,
                "setReplyTo" : setreply,
                "standardEmailtemplates":standardemail,
                "junoDocEmailtemplates":juno,
                "selectedobject":inputValue,
                "docvalue":doctemplete,
                "emaillist":JSON.stringify(component.get("v.accList")),
                "globalParentId" : globalParentId,
                "parentObjectName" : parentObjectName,
                "childObjectName" : childObjectName,
                "childObjectFieldName" : childObjectFieldName,
                "parentObjectFieldName" : parentObjectFieldName,
                "childObjectReplaceFieldName" : childObjectReplaceFieldName,
                "hideAttachAsPDF" : hideAttachAsPDF,
                "hideSaveAsActivity" : hideSaveAsActivity,
                "parentObjects" : selectedParentObjects
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state >> '+state);
                if(state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Saved Successfully"
                    });
                    toastEvent.fire();
                }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            });
            $A.enqueueAction(action);
        /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
      
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select object"
            });
            toastEvent.fire();
        }
    },
    
    handleChange: function (cmp, event) {
        var selectedOptionValue = cmp.get("v.parentValues");
        console.log('selectedOptionValue >> '+selectedOptionValue);
        cmp.set("v.selectedParentObjects",selectedOptionValue.toString());
        console.log(cmp.get("v.selectedParentObjects"))
      //  alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
    }
})
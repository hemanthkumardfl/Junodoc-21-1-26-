({
    doInit: function(component, event, helper) {
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
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action); 
        
        var action1 =component.get("c.getAttachmentData");
             action1.setParams({
                 
            });
             action1.setCallback(this,function(a){
                if(a.getState()==='SUCCESS'){
                    var result = a.getReturnValue();
                   
                     component.set("v.imgUrl","/servlet/servlet.FileDownload?file="+result);
                  }
            });
            $A.enqueueAction(action1);
        
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
        component.set("v.variable1",false);
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.accList",[]);
        component.set("v.ccaccList",[]);
        component.set("v.SetReplyTo",'');
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        
        
        helper.openSendPDFModelHelper(component, event, helper);
        
       
        
        
        component.set("v.showButton", true);
        
    },
    
          
    
    record : function(component,event,helper){
        component.set("v.toggleSpinner",true);
        var inputValue = component.get("v.inputValue");
        var doctemplete=component.get("v.docTemplate");
        var relatedemail=component.get("v.accList");
        var relatedemail=component.get("v.ccaccList");
       
      if(inputValue!=null && inputValue!='' && inputValue!=undefined){
        /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            var action = component.get("c.createrecord");
            action.setParams({
                "selectedobject":inputValue,
                "docvalue":doctemplete,
                "emaillist":JSON.stringify(component.get("v.accList")),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var VFPage = component.get("v.VFPage");
                    if(VFPage == false){
                         component.set("v.toggleSpinner",false);
                       var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Saved Successfully"
                        });
                        toastEvent.fire(); 
                    }
                    else{
                        component.set("v.isSuccess",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.isSuccess", false);
                            }), 5000
                        );
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
    /*handleOrgEmailEvent: function(component,event,helper){
        var OrgWideEmail = event.getParam("OrgEmail_Event");
        component.set("v.OrgEmailAddrId", OrgWideEmail);
    },*/
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
    
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
            component.set("v.isText",true);
        }
        component.set("v.fileName", fileName);
        
    },
    
    doSave: function(component, event, helper) {
        //component.set("v.isText",true);
        if (component.find("fileId").get("v.files") != undefined) {
            if(component.find("fileId").get("v.files").length > 0){
                helper.uploadHelper(component, event);
            }
            else{
                
                    var elmnt = document.getElementById("pageTop");
                    elmnt.scrollIntoView();
                    component.set("v.message", 'Please Select a Valid File.');
                    component.set("v.isError", true);
                    component.set("v.isSuccess", false);
                    //component.set("v.Spinner", false);
                    window.setTimeout(
                        $A.getCallback(function() {
                    component.set("v.isError", false);
                }), 3000
            );
                
                
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please Select a Valid File.",
                    "type":"error"
                });
                toastEvent.fire();*/
            }
            
        } else {
            
                //    var elmnt = document.getElementById("pageTop");
                //    elmnt.scrollIntoView();
                    component.set("v.message", 'Please Select a Valid File.');
                    component.set("v.isError", true);
                    component.set("v.isSuccess", false);
                    //component.set("v.Spinner", false);
                    window.setTimeout(
                        $A.getCallback(function() {
                    component.set("v.isError", false);
                }), 3000
            );
                
            
           /* var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Select a Valid File.",
                "type":"error"
            });
            toastEvent.fire();*/
        }
        var action =component.get("c.getAttachmentData");
            
             action.setCallback(this,function(a){
                 //alert(a.getState());
                if(a.getState()==='SUCCESS'){
                    var result = a.getReturnValue();
                     //alert('@@@@@@@@@@@@@'+result);
                     component.set("v.imgUrl",component.get("v.siteUrl")+"servlet/servlet.FileDownload?file="+result);
                    //component.sampleMethod();
                  }
            });
            $A.enqueueAction(action); 
               
    },
    
    
    
    
})
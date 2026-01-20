({
    
    redirectToRecord : function(component,event,helper,recordId){
        setTimeout(function(){
            var navEvent = $A.get("e.force:navigateToSObject");
            navEvent.setParams({
                recordId: recordId,
                slideDevName: "detail"
            });
            navEvent.fire();                        
        }, 3000);
    }
    ,
	
    openSendPDFModelHelper : function(component,event,helper){
        
        var recordId = component.get("v.objectName");
        var action = component.get("c.getEmailTemplates");
        action.setParams({
            "sObjName" : recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
               
                component.set("v.StandardEmailTemplatesList",InnerResult.StandardEmailTemplatesList);
                component.set("v.JunoDocEmailTemplatesList",InnerResult.JunoDocEmailTemplatesList);
            }
        });
        $A.enqueueAction(action);
        
        
    }
	,
    
    validateToAddressHelper: function(component, event,helper) {
           component.set("v.ErrorMessage",'');
        	component.set("v.isError",false);
           
        	if(   //$A.util.isEmpty(component.get("v.toEmails")) 
              //&& $A.util.isEmpty(component.get("v.toUserEmailsList")) 
              //&& $A.util.isEmpty(component.get("v.toContactEmailsList"))
                  $A.util.isEmpty(component.get("v.ToTextEmailsList"))   
               && $A.util.isEmpty(component.get("v.ToEmailMergeFieldsList"))
               && $A.util.isEmpty(component.get("v.CCTextEmailsList"))  
               && $A.util.isEmpty(component.get("v.CCEmailMergeFieldsList")) 
               && $A.util.isEmpty(component.get("v.BCCTextEmailsList"))   
               && $A.util.isEmpty(component.get("v.BCCEmailMergeFieldsList"))
             ){
               component.set("v.ErrorMessage", 'Please specify Email Recipient!');
        		component.set("v.isError",true);
               return false;
           }
        	else if(
                 $A.util.isEmpty(component.get("v.StandardEmailTemplateSelectedValue")) 
              && $A.util.isEmpty(component.get("v.JunoDocEmailTemplateSelectedValue")) 
             // && ($A.util.isEmpty(component.get("v.emailbody")) || $A.util.isEmpty(component.get("v.subject"))
            ){
               component.set("v.ErrorMessage",'Please Standard Email Template Or JunoDoc Email Template');
        		component.set("v.isError",true);
               return false;
           }
        else{
            return true;
        }
        	
    },
    
    SendPDFHeper: function(component, event, helper) {

            var recordId = component.get("v.records");
            //var recordId = component.get("v.recordId");
        //alert(recordId);
            var DocTemplateId = component.get("v.AvailableDocTemplateSelectedValue");
            var objectName = component.get("v.objectName");
        	var emailbody = '';
        	var subject = '';
            if(component.get("v.emailbody") != ''){
                emailbody = component.get("v.emailbody")
            }
        	if(component.get("v.subject") != ''){
                subject = component.get("v.subject")
            }
        
            var ToTextEmailsList = component.get("v.ToTextEmailsList");
            var ToEmailMergeFieldsList = component.get("v.ToEmailMergeFieldsList");
            
            var CCTextEmailsList = component.get("v.CCTextEmailsList");
            var CCEmailMergeFieldsList = component.get("v.CCEmailMergeFieldsList");

            var BCCTextEmailsList = component.get("v.BCCTextEmailsList");
            var BCCEmailMergeFieldsList = component.get("v.BCCEmailMergeFieldsList");
        	var FromEmailAddress = component.get("v.FromEmailAddress");
        	var SetReplyTo = component.get("v.SetReplyTo");
          // alert("RecordId"+recordId);
          //var NewrecordIds = JSON.parse(recordId);
            var action = component.get("c.SendPDFBatch");
            action.setParams({
                "ids" : recordId,
                "DocTemplateId" : DocTemplateId,
                "Subject" : subject,
                "Body" : emailbody,
                "SaveAsActivity" : component.get("v.SaveAsActivity"),
                "objectName" : objectName,
                "StandardEmailTemplateSelectedValue" : component.get("v.StandardEmailTemplateSelectedValue"),
                "JunoDocEmailTemplateSelectedValue" : component.get("v.JunoDocEmailTemplateSelectedValue"),
                "FromEmailAddress" : FromEmailAddress,
                "SetReplyTo" : SetReplyTo,
                "ToTextEmailsList" : ToTextEmailsList,
                "ToEmailMergeFieldsList" : ToEmailMergeFieldsList,
                "CCTextEmailsList" : CCTextEmailsList,
                "CCEmailMergeFieldsList" : CCEmailMergeFieldsList,
                "BCCTextEmailsList" : BCCTextEmailsList,
                "BCCEmailMergeFieldsList" : BCCEmailMergeFieldsList 
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                   window.open('/lightning/o/'+objectName+ '/list','_self');
                   /* if(component.get("v.listview") == true){
                        window.open('/lightning/o/'+objectName+ '/list','_self');
                    }
                    else{
                        window.open('/lightning/n/JunoDoc__Junodoc_Batch','_self'); 
                    }*/
                           

                    
                } 
            });
            $A.enqueueAction(action);
        
    },
    
    
    StandardEmailTemplateOnchangeHandlerHelper : function(component,event,helper,spinnerId){
        
        component.set("v."+spinnerId,true);
        var recordId = component.get("v.recordId");
        var EmailTemplateId = event.getSource().get("v.value");
        
        var action = component.get("c.getBodyFromEmailTemplate");
        action.setParams({
            "recordId" : recordId,
            /*"toUserEmailsList" : component.get("v.toUserEmailsList"),
            "toContactEmailsList" : component.get("v.toContactEmailsList"),
            "toEmails" : component.get("v.toEmails"),*/
            "EmailTemplateId" : EmailTemplateId
        });
            
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){                
                    component.set("v."+spinnerId,false);                
                    var Result = response.getReturnValue(); 
                    var Subject = Result.split('~')[0];
                    var Body = Result.split('~')[1];
                    var errorMessage = Result.split('~')[2];
                    if(errorMessage==''){
                        component.set("v.subject",Subject);
                        component.set("v.emailbody",Body);                    
                    }
                    
                    var toastEvent = $A.get("e.force:showToast");
                    if(errorMessage!=null){
                        toastEvent.setParams({
                            title : 'Error',
                            message:errorMessage,  //'Email limit exceeded. Please try later.';
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });               
                        toastEvent.fire();
                    }
                }
                else{
                    component.set("v."+spinnerId,false); 
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + 
                                  errors[0].message);
                        }
                    } 
                    else {
                        alert("Unknown error");
                    }
                }
                
            });
            $A.enqueueAction(action);         
        }
    ,    

    
 	JunoDocEmailTemplateOnchangeHandlerHelper : function(component,event,helper){
        //component.set("v."+spinnerId,true);
        var recordId = component.get("v.recordId");
        var EmailTemplateId = event.getSource().get("v.value");
        
        var action = component.get("c.getBodyFromJunoDocEmailTemplate1");
        action.setParams({
            "recordId" : recordId,
            "EmailTemplateId" : EmailTemplateId
        });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){                
                //component.set("v."+spinnerId,false);                
                var Result = response.getReturnValue(); 
                var Subject = Result.split('~')[0];
                var Body = Result.split('~')[1];
                component.set("v.subject",Subject);
                component.set("v.emailbody",Body);
            }
            else{
                //component.set("v."+spinnerId,false); 
                 var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + 
                                  errors[0].message);
                        }
                    } 
                    else {
                        alert("Unknown error");
                    }
            }
            
        });
        $A.enqueueAction(action);         
    }
    ,    

    
    
})
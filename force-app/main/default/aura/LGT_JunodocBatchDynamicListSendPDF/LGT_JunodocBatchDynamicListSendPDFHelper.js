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
                helper.recordDetails(component,event,helper);
            }
        });
        $A.enqueueAction(action);
        
        
    }
	,
    
    
    recordDetails: function(component,event,helper){
        var recId = component.get("v.objectName");
                var action = component.get("c.getrecorddetails"); 
                action.setParams({
                    "recordId" : recId
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var InnerResult = response.getReturnValue();
                        console.log("Query result"+JSON.stringify(InnerResult));
                        if(InnerResult!=null && InnerResult!='' && InnerResult!=undefined){
                           
                            //for (var i=0; i < InnerResult.length; i++) {
                            component.set("v.FromEmailAddress",InnerResult.junodoc[0].JunoDoc__From_Email_Address__c);
                            component.set("v.SetReplyTo",InnerResult.junodoc[0].JunoDoc__Set_Reply_To__c);
                            component.set("v.StandardEmailTemplateSelectedValue",InnerResult.junodoc[0].JunoDoc__Standard_Email_Templates__c);
                            
                           	component.set("v.JunoDocEmailTemplateSelectedValue",InnerResult.junodoc[0].JunoDoc__Junodoc_Email_Templates__c);
                            
                            if(component.get("v.AvailableDocTemplateSelectedValue") == undefined ||  
                              	component.get("v.AvailableDocTemplateSelectedValue") == null || 
                               	component.get("v.AvailableDocTemplateSelectedValue") == ''){
                         
                            	component.set("v.AvailableDocTemplateSelectedValue",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                            	if(InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c != null &&
                              	InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c != '' ){
                                component.set("v.isDocTemplate",true);
                                component.set("v.DocTemplateId",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                            }
                            }  
                            var juno = component.get("v.JunoDocEmailTemplateSelectedValue");
                          	
                            component.set("v.accList",InnerResult.junoEmailList);
                            var message = component.get("v.accList");
                            console.log('message ------> '+JSON.stringify(message));
                            var textValues = '';
                            var referenceValues = '';
                            var ToTextEmailsList = [];
                            var ToEmailMergeFieldsList = [];
                            
                            var CCTextEmailsList = [];
                            var CCEmailMergeFieldsList = [];  
                            
                            var BCCTextEmailsList = [];
                            var BCCEmailMergeFieldsList = [];  
                            for(var i=0;i<message.length;i++){
                                if(message[i].TextRefVal == 'Text'){
                                    textValues += message[i].Email+' - '+message[i].Tovalue+','; 
                                    if(message[i].Tovalue=='To'){
                                        ToTextEmailsList.push(message[i].Email);    
                                    }else if(message[i].Tovalue=='CC'){
                                        CCTextEmailsList.push(message[i].Email);    
                                    }else if(message[i].Tovalue=='BCC'){
                                        BCCTextEmailsList.push(message[i].Email);    
                                    } 
                                }
	
                                if(message[i].TextRefVal == 'Reference'){
                                    referenceValues += message[i].Email+' - '+message[i].Tovalue+',';     
                                    if(message[i].Tovalue=='To'){
                                        ToEmailMergeFieldsList.push(message[i].fieldDetails);
                                         
                                    }else if(message[i].Tovalue=='CC'){
                                        CCEmailMergeFieldsList.push(message[i].fieldDetails);    
                                    }else if(message[i].Tovalue=='BCC'){
                                        BCCEmailMergeFieldsList.push(message[i].fieldDetails);    
                                    } 
                                    
                                }  
                            }
                            textValues = textValues.slice(0, -1);
                            referenceValues = referenceValues.slice(0, -1);
                           // component.set("v.textValues", textValues);
                           // component.set("v.referenceValues", referenceValues);
                            component.set("v.ToTextEmailsList",ToTextEmailsList);
                            component.set("v.ToEmailMergeFieldsList",ToEmailMergeFieldsList);      
                            component.set("v.CCTextEmailsList",CCTextEmailsList);
                            component.set("v.CCEmailMergeFieldsList",CCEmailMergeFieldsList);
                            component.set("v.BCCTextEmailsList",BCCTextEmailsList);
                            component.set("v.BCCEmailMergeFieldsList",BCCEmailMergeFieldsList);

                            
                            var stand = component.get("v.StandardEmailTemplateSelectedValue");
                            
                            if(juno != null && juno !='' && juno != undefined){
                               
                                helper.JunoDocEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                            }else{
                                if(stand !=null && stand !='' && stand!=undefined){
                                    
                                    helper.StandardEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                                }
                            }  
                        }
                        else if(InnerResult==null || InnerResult==''){
                            component.set("v.FromEmailAddress","choose one...");
                            component.set("v.SetReplyTo","");
                            component.set("v.StandardEmailTemplateSelectedValue","choose one...");
                            component.set("v.JunoDocEmailTemplateSelectedValue","choose one...");
                        }
                        console.log('standard email template --------> '+component.get("v.StandardEmailTemplateSelectedValue"));
                        component.set("v.variable1",true);
                    }
                    
                    
                });
                $A.enqueueAction(action);
    },
    
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
                 $A.util.isEmpty(component.get("v.subject")) 
              && $A.util.isEmpty(component.get("v.emailbody")) 
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
           // var DocTemplateId = component.get("v.AvailableDocTemplateSelectedValue");
         	var DocTemplateId = component.get("v.batchId");
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
                    //window.open('/lightning/o/'+objectName+ '/list','_self');
                    
                    if(component.get("v.visualpage") == false){
                   		window.open('/lightning/n/JunoDoc__Junodoc_Batch','_parent');         
                    }
                    else{
                       window.open('/apex/JunoDoc__JunodocBatch','_parent');   
                    }
                    

                    
                } else if(state === "ERROR"){
                    
                }
            });
            $A.enqueueAction(action);
        
    },
    
    
    StandardEmailTemplateOnchangeHandlerHelper : function(component,event,helper,spinnerId){
        
        component.set("v."+spinnerId,true);
        var recordId = component.get("v.records");
        var recordList = recordId.split(',');
        var EmailTemplateId = component.get("v.StandardEmailTemplateSelectedValue");
        var action = component.get("c.getBodyFromEmailTemplate");
        action.setParams({
            "recordId" : recordList[0],
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
                    if(errorMessage=='' || errorMessage == undefined){    
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
        //var recordId = component.get("v.recordId");
        var recordId  = component.get("v.records");
        var recordList = recordId.split(',');
        var EmailTemplateId = component.get("v.JunoDocEmailTemplateSelectedValue");
        //console.log('recordId=='+recordId);
        console.log('EmailTemplateId=='+EmailTemplateId);
        var action = component.get("c.getBodyFromJunoDocEmailTemplate1");
        action.setParams({
            "recordId" : recordList[0],
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
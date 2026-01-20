({
	doInit : function(component, event, helper) {
        //alert(component.get("v.records"));
        /*alert(component.get("v.batchId"));
        alert(component.get("v.postActionWrapper"));
        alert(component.get("v.TemplateId"));*/
        if(component.get("v.records").length <= 2){
            //  component.set("v.isError",true);
          //  component.set("v.ErrorMessage",'Please select Records');
            component.set("v.ShowData",false);  
        }
        else{
            component.set("v.isError",false);
            component.set("v.ShowData",true);            
        }
        var recordId = component.get("v.objectName");
        
        var action = component.get("c.getAvailableDocTemplates"); 
        action.setParams({
            'sObjName' : recordId
        }); 
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.AvailableDocTemplatesList",InnerResult.AvailableDocTemplatesList);
                component.set("v.DocTemplateId",InnerResult.DocTemplateId); 
                component.set("v.ObjectAPIName",InnerResult.ObjectAPIName);  //9Dec2020
                component.set("v.ShowActData",true);
                component.set("v.OrgwideEmailAddressList",InnerResult.OrgwideEmailAddressList);  //9Dec2020                 
            } 
        });
        $A.enqueueAction(action);  
         

        var actions = component.get("c.getAvailableEmails"); 
        actions.setParams({
            'sObjName' : recordId
        }); 
        actions.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.DocTemplatesWraplist",InnerResult);               
            }
        });
        $A.enqueueAction(actions); 
		
		component.set("v.isSendPDF",true);
            
        component.set("v.subject",'');
        component.set("v.emailbody",[]);
        component.set("v.toUserEmailsList",[]);
        component.set("v.toContactEmailsList",[]);
        component.set("v.toEmails",'');
        component.set("v.StandardEmailTemplateSelectedValue",'');
        
        helper.openSendPDFModelHelper(component,event,helper);
        
      
        //(JSON.stringify(recordId));
        var action1 = component.get("c.getEmailTemplates");
        action1.setParams({
            "sObjName" : recordId
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.StandardEmailTemplatesList",InnerResult.StandardEmailTemplatesList);
                component.set("v.JunoDocEmailTemplatesList",InnerResult.JunoDocEmailTemplatesList);
                component.set("v.JunoDocPDFTemplatesList",InnerResult.JunoDocPDFTemplatesList);
                
         	var obj = recordId;
        
            }
        });
        $A.enqueueAction(action1); 
        
               
    
        
        
        
        
        
	},
    closeSendPDFModel : function(component, event, helper){
        component.set("v.isSendPDF",false);
        //window.open('/lightning/o/'+component.get("v.objectName")+ '/list','_self');
        
        window.open('/lightning/n/JunoDoc__Junodoc_Batch','_self');        
    }
    ,
    
    SaveAsActivityHandler : function(component, event, helper){
        var checked = event.getSource().get("v.value");
        if(checked){
            component.set("v.SaveAsActivity",true);
        }else{
        	component.set("v.SaveAsActivity",false);    
        }
    }
    ,
    
    SendPDFhandler : function(component, event, helper){
		if(helper.validateToAddressHelper(component, event, helper)){    
            
        	helper.SendPDFHeper(component, event, helper,'Spinner');
        }
        
    },
    
    
    
 	handleNotification :  function(component,event,helper){ 
       
        var message = event.getParam("emailList");
        var fieldDetails = event.getParam("fieldDetails");
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
                    alert('Aura --> '+message[i].Email);
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
        component.set("v.textValues", textValues);
        component.set("v.referenceValues", referenceValues);
        component.set("v.fieldDetails", fieldDetails);
        
        component.set("v.ToTextEmailsList",ToTextEmailsList);
        component.set("v.ToEmailMergeFieldsList",ToEmailMergeFieldsList);
        
        component.set("v.CCTextEmailsList",CCTextEmailsList);
        component.set("v.CCEmailMergeFieldsList",CCEmailMergeFieldsList);

        component.set("v.BCCTextEmailsList",BCCTextEmailsList);
        component.set("v.BCCEmailMergeFieldsList",BCCEmailMergeFieldsList);
                
    }    
    ,
    
     StandardEmailTemplateOnchangeHandler :  function(component,event,helper){
        
		//if(helper.validateToAddressHelper(component, event, helper)){             
            helper.StandardEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
        /*}else{
            component.set("v.StandardEmailTemplateSelectedValue",'');
        } */              
    },
    
    
    JunoDocEmailTemplateOnchangeHandler :  function(component,event,helper){        
        helper.JunoDocEmailTemplateOnchangeHandlerHelper(component,event,helper);
    },
    
    
    
    
})
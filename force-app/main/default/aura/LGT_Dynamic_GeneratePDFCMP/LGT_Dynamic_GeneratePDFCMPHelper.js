({
    
    redirectToRecord : function(component,event,helper,recordId){
        var vfPage = component.get("v.VFPage");
        setTimeout(function(){
            if(vfPage == false){
                var navEvent = $A.get("e.force:navigateToSObject");
                navEvent.setParams({
                    recordId: recordId,
                    slideDevName: "detail"
                });
                navEvent.fire(); 
            }
            else{
                window.open('/'+recordId,'_self');
            }
        }, 2000);
    },
    getEnableEmailTemplate : function(component,event,helper){
        var actions = component.get("c.getEnableEmails");  
        actions.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.DisableEmailBody",InnerResult);               
            }
        });
        $A.enqueueAction(actions); 
    },
    
    openSendPDFModelHelper : function(component,event,helper){
        var recordId = component.get("v.recordId");
        var action = component.get("c.getEmailTemplates");
        action.setParams({
            "id" : recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.StandardEmailTemplatesList",InnerResult.StandardEmailTemplatesList);
                component.set("v.JunoDocEmailTemplatesList",InnerResult.JunoDocEmailTemplatesList);
                helper.recordDetails(component,event,helper);
                
            }
            else{
                console.log(response.getError())
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    /* Added by Sainath on 09-Sep-2025 Start */
    hideSettings: function(component,event,helper){
       var recId = component.get("v.recordId");
        var action = component.get("c.getHideDetails"); 
        action.setParams({
            "recordId" : recId
        }); 
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                if(InnerResult != null && InnerResult != '' && InnerResult != undefined){
                    component.set("v.hideAttachAsPDF",InnerResult.hideAttachAsPDF);
                    console.log('hideAttachAsPDF => ' + InnerResult.hideAttachAsPDF);
                    component.set("v.hideSaveAsActivity",InnerResult.hideSaveAsActivity);
                }
            }
        });
        $A.enqueueAction(action);
    },
    /* Added by Sainath on 09-Sep-2025 End */
    
    recordDetails: function(component,event,helper){
        var recId = component.get("v.recordId");
        var action = component.get("c.getrecorddetails"); 
        action.setParams({
            "recordId" : recId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                
             //   console.log("Query result"+JSON.stringify(InnerResult));
                if(InnerResult!=null && InnerResult!='' && InnerResult!=undefined){
                    
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
                            var DocTemplateId = component.get("v.DocTemplateId");
                            var recordId = component.get("v.recordId");
                            
                            var action2 = component.get("c.getPostActList");
                            action2.setParams({
                                docId : DocTemplateId,
                                rid : recordId
                            });
                            action2.setCallback(this, function (response) {
                                if (response.getState() == "SUCCESS") {
                                    var result = response.getReturnValue();
                                    component.set("v.PostActList", result);
                                    var resultUpdate;
                                    var UpdatedPostActs = [];
                                    for (var i=0;i<result.length;i++){
                                        if(result[i].GenerateCheck == 'true'){
                                            resultUpdate = result[i].GenerateCheck;
                                            UpdatedPostActs.push(
                                                result[i]
                                            );
                                        }
                                    }
                                    
                                    if(UpdatedPostActs.length>0){
                                        var recordId = component.get("v.recordId");
                                        var PostActList = JSON.stringify(UpdatedPostActs);
                                        var action33 = component.get("c.UpdateRecs");
                                        action33.setParams({
                                            PostActs : PostActList,
                                            rid : recordId
                                        });
                                        action33.setCallback(this, function (response) {
                                            if (response.getState() == "SUCCESS") {
                                                var result = response.getReturnValue();
                                                if(result == 'SUCCESS'){
                                                    if(resultUpdate == 'true'){
                                                        if(component.get("v.VFPage") == false){
                                                            var toastEvent = $A.get("e.force:showToast");
                                                            toastEvent.setParams({
                                                                message: 'PostActions Updated Successfully!',
                                                                type: 'Success',
                                                            });
                                                            toastEvent.fire();
                                                        }
                                                    }
                                                }
                                                else{
                                                    if(component.get("v.VFPage") == false){
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            message: 'PostActions Update Failed!. '+ result,
                                                            type: 'error',
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                }
                                            }
                                        });
                                        $A.enqueueAction(action33);
                                    }
                                }
                            });
                            $A.enqueueAction(action2);
                            
                            //------------------------------------------
                            var DocList = component.get("v.AvailableDocTemplatesList");
                            for(var i=0;i<DocList.length;i++){
                                if(DocList[i].value == DocTemplateId && (DocList[i].reportType == '' || DocList[i].reportType == undefined || DocList[i].reportType == null)){
                                    if(DocList[i].type != 'Word Document' && DocList[i].type != 'Excel'){
                                        component.set("v.isDocTemplate",true);
                                        component.set("v.isDocWordTemplate",false);
                                        component.set("v.isDocWordTemplateAttach",false);
                                        component.set("v.isDocExcelTemplate",false);
                                    }
                                    else if(DocList[i].type == 'Word Document'){
                                        component.set("v.isDocWordTemplate",true);
                                        component.set("v.isDocTemplate",false);
                                        component.set("v.isDocWordTemplateAttach",false);
                                        component.set("v.isDocExcelTemplate",false);
                                    }
                                        else if(DocList[i].type == 'Excel'){
                                            component.set("v.isDocExcelTemplate",true);
                                            component.set("v.isDocWordTemplate",false);
                                            component.set("v.isDocTemplate",false);
                                            component.set("v.isDocWordTemplateAttach",false);
                                        } 
                                }
                                else if(DocList[i].value == DocTemplateId && DocList[i].reportType != ''){
                                    component.set("v.showCanvas",true);
                                }
                                
                                
                            }
                            //..........................................................................
                            
                            
                        }
                    }  
                    var juno = component.get("v.JunoDocEmailTemplateSelectedValue");
                    
                    component.set("v.accList",InnerResult.junoEmailList);
                    var message = component.get("v.accList");
                 //   console.log('message ------> '+JSON.stringify(message));
                    var textValues = '';
                    var referenceValues = '';
                    var ToTextEmailsList = [];
                    var ToEmailMergeFieldsList = [];
                    
                    var CCTextEmailsList = [];
                    var CCEmailMergeFieldsList = [];  
                    
                    var BCCTextEmailsList = [];
                    var BCCEmailMergeFieldsList = [];  
                    for(var i=0;i<message.length;i++){
                        if(message[i].TextRefVal == 'Text' || message[i].TextRefVal == 'User' || message[i].TextRefVal == 'Contact'){
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
                    component.set("v.textValues", textValues);
                    component.set("v.referenceValues", referenceValues);
                    component.set("v.ToTextEmailsList",ToTextEmailsList);
                    component.set("v.ToEmailMergeFieldsList",ToEmailMergeFieldsList);      
                    component.set("v.CCTextEmailsList",CCTextEmailsList);
                    component.set("v.CCEmailMergeFieldsList",CCEmailMergeFieldsList);
                    component.set("v.BCCTextEmailsList",BCCTextEmailsList);
                    component.set("v.BCCEmailMergeFieldsList",BCCEmailMergeFieldsList);
                    
                    
                    var stand = component.get("v.StandardEmailTemplateSelectedValue");
                    
                    if(juno!=null&&juno!=''&&juno!=undefined){
                        
                        helper.JunoDocEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                    }else{
                        if(stand !=null && stand !='' && stand!=undefined){
                            
                            helper.StandardEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                        }
                    }
                }
                else if(InnerResult==null || InnerResult==''){
                    component.set("v.FromEmailAddress","");
                    component.set("v.SetReplyTo","");
                    component.set("v.StandardEmailTemplateSelectedValue","");
                    component.set("v.JunoDocEmailTemplateSelectedValue","");
                }
                console.log('standard email template --------> '+component.get("v.StandardEmailTemplateSelectedValue"));
                component.set("v.variable1",true);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    validateToAddressHelper: function(component, event,helper) {
        if(   //$A.util.isEmpty(component.get("v.toEmails")) 
            //&& $A.util.isEmpty(component.get("v.toUserEmailsList")) 
            //&& $A.util.isEmpty(component.get("v.toContactEmailsList"))
            $A.util.isEmpty(component.get("v.ToTextEmailsList"))   // 09Dec2020
            && $A.util.isEmpty(component.get("v.ToEmailMergeFieldsList"))   // 09Dec2020
            && $A.util.isEmpty(component.get("v.CCTextEmailsList"))   // 09Dec2020
            && $A.util.isEmpty(component.get("v.CCEmailMergeFieldsList"))   // 09Dec2020
            && $A.util.isEmpty(component.get("v.BCCTextEmailsList"))   // 09Dec2020
            && $A.util.isEmpty(component.get("v.BCCEmailMergeFieldsList"))   // 09Dec2020               
        ){
            if(component.get("v.VFPage") == false){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please specify Email Recipient!',  
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error', 
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
            return false;
        }
        else{
            return true;
        }
        
    },
    
    SendPDFHeper: function(component, event, helper,SpinnerId) {
        debugger;
        if(component.get("v.subject") == "" || component.get("v.emailbody") == "" ){
            component.set("v.isError",false);
            if(component.get("v.VFPage") == false){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please Enter Subject and Body',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();  
            }else{
                component.set("v.isError",true);
                component.set("v.message","Please Enter Subject and Body")
            }
        }else{
            
            component.set("v.Spinner",true);
            var recordId = component.get("v.recordId");
            var DocTemplateId = component.get("v.DocTemplateId");  
            var ToTextEmailsList = component.get("v.ToTextEmailsList");
            var ToEmailMergeFieldsList = component.get("v.ToEmailMergeFieldsList");
            
            var CCTextEmailsList = component.get("v.CCTextEmailsList");
            var CCEmailMergeFieldsList = component.get("v.CCEmailMergeFieldsList");
            
            var BCCTextEmailsList = component.get("v.BCCTextEmailsList");
            var BCCEmailMergeFieldsList = component.get("v.BCCEmailMergeFieldsList");
            
           // console.log('uploadFileLists ' + JSON.stringify(component.get("v.fileData")))
            var action = component.get("c.SendPDFs");
            action.setParams({
                "id" : recordId,
                "DocTemplateId" : DocTemplateId,
                "Subject" : component.get("v.subject"),
                "Body" : component.get("v.emailbody"),
                "FromEmailAddress" : component.get("v.FromEmailAddress"),
                "SetReplyTo" : component.get("v.SetReplyTo"),
                "SetSenderDisplayName" : component.get("v.SetSenderDisplayName"),                
                "SaveAsActivity" : component.get("v.SaveAsActivity"),
                "ToTextEmailsList" : component.get("v.ToTextEmailsList"),
                "ToEmailMergeFieldsList" : component.get("v.ToEmailMergeFieldsList"),                
                "CCTextEmailsList" : component.get("v.CCTextEmailsList"),
                "CCEmailMergeFieldsList" : component.get("v.CCEmailMergeFieldsList"),
                "BCCTextEmailsList" : component.get("v.BCCTextEmailsList"),
                "BCCEmailMergeFieldsList" : component.get("v.BCCEmailMergeFieldsList") ,
                "fileData" : component.get("v.fileData"),
                'baseString' : component.get("v.baseString")
                
            });
            action.setCallback(this, function(response){ 
                
                var errors = response.getError();                       
                var state = response.getState();
                if(state === "SUCCESS"){
                    var resultmap = response.getReturnValue();
                    if(resultmap.state == 'success'){                                                                        
                        var resultList = component.get("v.PostActList");
                        var resultUpdate;
                        var UpdatedPostActs = [];
                        for (var i=0;i<resultList.length;i++){
                            if(resultList[i].MailCheck == 'true'){
                                resultUpdate = resultList[i].MailCheck;
                                UpdatedPostActs.push(
                                    resultList[i]
                                );
                            }
                        }
                        var recordId = component.get("v.recordId");
                        if(UpdatedPostActs.length>0){
                            var PostActList = JSON.stringify(UpdatedPostActs);
                            var action33 = component.get("c.UpdateRecs");
                            action33.setParams({
                                PostActs : PostActList,
                                rid : recordId
                            });
                            action33.setCallback(this, function (response) {
                                if (response.getState() == "SUCCESS") {
                                    component.set("v.Spinner",false);
                                    var result = response.getReturnValue();
                                    if(result == 'SUCCESS'){
                                        if(resultUpdate == 'true'){
                                            if(component.get("v.VFPage") == false){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    message: 'PostActions Updated Successfully!',
                                                    type: 'Success',
                                                });
                                                toastEvent.fire();
                                            }
                                            
                                        }
                                        $A.get("e.force:closeQuickAction").fire();
                                        $A.get('e.force:refreshView').fire();
                                    }
                                    else{
                                        if(component.get("v.VFPage") == false){
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                message: 'PostActions Update Failed!',
                                                type: 'error',
                                            });
                                            toastEvent.fire();
                                        }
                                        // $A.get("e.force:closeQuickAction").fire();
                                        // $A.get('e.force:refreshView').fire();
                                    }
                                }
                            });
                            $A.enqueueAction(action33);
                        }
                        else{
                            if(component.get("v.VFPage") == false){
                                $A.get("e.force:closeQuickAction").fire();
                                $A.get('e.force:refreshView').fire();
                            }
                        }
                        component.set("v.isSendPDF",false);
                        if(component.get("v.VFPage") == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Success!',
                                message: resultmap.Message,
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }else{
                            component.set("v.isError",true);
                            component.set("v.message",resultmap.Message)
                            component.set("v.Spinner",false);
                        }
                        helper.redirectToRecord(component,event,helper,recordId);
                        
                    }else{
                        component.set("v.Spinner",false);
                        if(component.get("v.VFPage") == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error',
                                message:resultmap.Message,
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();
                        }else{
                            component.set("v.isError",true);
                            component.set("v.message",resultmap.Message)
                        }
                    }
                    
                    
                }
                else{
                    console.log('Error');
                    console.log(response.getError());
                }
            });
            $A.enqueueAction(action); 
            
            
        }
    },
    
    StandardEmailTemplateOnchangeHandlerHelper : function(component,event,helper,spinnerId){
        
        component.set("v."+spinnerId,true);
        var recordId = component.get("v.recordId");
        // var EmailTemplateId = event.getSource().get("v.value");
        var EmailTemplateId=component.get("v.StandardEmailTemplateSelectedValue");
        console.log(recordId + ' ********* ' + EmailTemplateId);
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
            console.log('********* ' + state);
            if(state === "SUCCESS"){                
                component.set("v."+spinnerId,false);                
                var Result = response.getReturnValue(); 
                console.log('********* Result' + Result);
                var Subject = Result.split('~')[0];
                var Body = Result.split('~')[1];
                var errorMessage = Result.split('~')[2];
                if(errorMessage==''){
                    component.set("v.subject",Subject);
                    console.log('********* ' + Body);
                    var encodedHtml = Body;  
                    
                    component.set("v.emailbody",Body);                    
                }
                
                var toastEvent = $A.get("e.force:showToast");
                if(errorMessage!=null){
                    if(component.get("v.VFPage") == false){
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
            }
            else{
                component.set("v."+spinnerId,false); 
                var errors = response.getError();
                console.log('********* errors' + errors);
              //  console.log('********* errors' + JSON.stringify(errors));
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
    
    JunoDocEmailTemplateOnchangeHandlerHelper : function(component,event,helper,spinnerId){
        component.set("v."+spinnerId,true);
        var recordId = component.get("v.recordId");
        //var EmailTemplateId = event.getSource().get("v.value");
        
        var EmailTemplateId=component.get("v.JunoDocEmailTemplateSelectedValue");
        var action = component.get("c.getBodyFromJunoDocEmailTemplate");
        action.setParams({
            "recordId" : recordId,
            "EmailTemplateId" : EmailTemplateId
        });
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){                
                component.set("v."+spinnerId,false);                
                var Result = response.getReturnValue(); 
                var Subject = Result.split('~')[0];
                var Body = Result.split('~')[1];
                component.set("v.subject",Subject);
                component.set("v.emailbody",Body);
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
    
    showMessage : function(message,isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": isSuccess?"Success!":"Error!",
            "type":isSuccess?"success":"error",
            "message": message
        });
        toastEvent.fire();
    },
    readFiles : function(component, event, helper, file){
        var filesList = component.get("v.fileData");
        var reader = new FileReader(); 
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]; 
            var fileData = {
            'fileName': file.name,
            'Type': file.type,
            'fileContent': base64
            
        }
        //filesList.push(fileData);
        //component.set("v.fileData", filesList);
        component.get("v.fileData").push(fileData);
    }
    reader.readAsDataURL(file);
},
 
 
 })
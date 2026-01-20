({
    doInit : function(component, event, helper) {
        
        helper.getRecordName(component);
        
        helper.fetchEmailTemplates(component);
        let options = [
            { label: 'None', value: 'none' },
            { label: 'Daily', value: 'Daily' },
            { label: 'Monthly', value: 'monthly'},
            { label: 'Weekly', value: 'weekly' }
            
        ];
        component.set("v.optionsReminder", options);
        
        
        let action888 = component.get("c.getAccountFieldValue");
        action888.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let fieldValue = response.getReturnValue();
                // alert('fieldValue>>>>>>>>>>>>>>>>>>>>>>>>>'+fieldValue);
                component.set("v.showChildComponent", fieldValue); // Show or hide based on field value
            } else {
                console.error("Error retrieving account field value: " + response.getError());
            }
        });
        
        $A.enqueueAction(action888);
        /* debugger;
             helper.postActions(component, event, helper);*/
            
            component.set("v.Spinner",true);
            if(!component.get("v.recordId")){
                var myPageRef = component.get("v.pageReference");
                var id = myPageRef.state.c__recordId;
                component.set("v.recordId", id);
            }
            var recordId = component.get('v.recordId');
            component.set("v.ShowLevel1",true);
            component.set("v.Spinner", true);
            component.set("v.showMessage", true);
            component.set('v.addRecipents',false)
            component.set('v.showDocuments',true)
            component.set('v.isDocumentcmp',true)
            var action = component.get("c.getDocuments");
            var gefields = component.get("c.getObjectFields");
            action.setParams({
                recordId : component.get("v.recordId")
            });
            gefields.setParams({recordId : component.get("v.recordId")});
            gefields.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.clear();
                    console.log(response.getReturnValue())
                    component.set("v.fieldOptions", response.getReturnValue());
                }
                else {
                    console.error("Error fetching fields: " + response.getError());
                }
            });
            
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var fields = response.getReturnValue();
                    var fieldOptions = [];
                    
                    component.set("v.showMessage", false);
                    var result = response.getReturnValue();
                    component.set("v.ContentDocumentList", result);
                    if(result.length<=0){
                        component.set("v.DocCheckDisable", true);
                    }
                    var recId = component.get("v.recordId");
                    /*var action1 = component.get("c.getContactName");
                    action1.setParams({
                        recordId : recId
                    });
                    action1.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            component.set("v.Spinner", false);
                            component.set("v.showMessage", false);
                            var result = response.getReturnValue();
                            component.set("v.contactName", result.Name);
                            component.set("v.contactId", result.Id);    
                        }
                    });
                    $A.enqueueAction(action1);*/
                };
                var getDefaultFromEmailAction = component.get("c.getFromEmailAddress");
                getDefaultFromEmailAction.setCallback(this, function (response) {
                    if (response.getState() == "SUCCESS") {
                        component.set("v.EmailAddressSelectedValue", response.getReturnValue());
                    }
                });
                $A.enqueueAction(getDefaultFromEmailAction);
                
                var recordId = component.get("v.recordId");
                var action = component.get("c.getAvailableDocTemplates"); 
                action.setParams({
                    'recordId' : recordId
                });        
                action.setCallback(this, function(response){
                    var state = response.getState();
                    
                    if(state === "SUCCESS"){
                        var InnerResult = response.getReturnValue();
                        component.set("v.AvailableDocTemplatesList",InnerResult.AvailableDocTemplatesList);
                        console.log('AvailableDocTemplatesList'+InnerResult.AvailableDocTemplatesList.length);
                        component.set("v.DocTemplateId",InnerResult.DocTemplateId);
                        let docTemplates = component.get("v.AvailableDocTemplatesList");  
                        if(InnerResult.AvailableDocTemplatesList.length === 0){
                            component.set("v.isPicklistDisabled", false);
                        }
                        
                        component.set("v.DocTemplateId",InnerResult.DocTemplateId);
                        component.set("v.ObjectAPIName",InnerResult.ObjectAPIName); 
                        console.log("@@@"+InnerResult.JunodocUrl);                  
                    }
                });
                $A.enqueueAction(action);
                
                /* let docTemplates = component.get("v.AvailableDocTemplatesList");
                    alert('docTemplates>>>>>>>>>>>>>>>>'+docTemplates.size());
                    component.set("v.isPicklistDisabled", docTemplates.length > 0);*/
                
                
                var action3 = component.get("c.getCurrentObjectDetails"); 
                action3.setParams({
                    "recordId" : component.get("v.recordId")
                    
                });
                action3.setCallback(this,function(a){
                    if(a.getState()==='SUCCESS'){
                        var result = a.getReturnValue();
                        if(result != ''){
                            component.set("v.CurrentObject",result.ObjectName);
                            component.set("v.ObjectAPIName",result.ObjectName);
                            component.set("v.CurrentObjLabelName",result.ObjectLabel);
                            helper.GetObjectLabelName(component, event, helper);// dont delete
                        }
                    }
                });
                $A.enqueueAction(action3);
                
                //get default template
                var action4 = component.get("c.getDefaultDoctemplate"); 
                action4.setParams({
                    "recordId" : component.get("v.recordId")
                    
                });
                action4.setCallback(this,function(templateResponse){
                    if(templateResponse.getState() == 'SUCCESS'){
                        var responseResult = templateResponse.getReturnValue();
                        console.log('responseResult'+responseResult);
                        //component.set("v.defaultDocTemplate",responseResult)
                        if(responseResult && responseResult.temId){
                            component.set("v.defaultDocTemplate",responseResult) //.temId
                            component.set("v.AvailableDocTemplateSelectedValue",responseResult.temId)
                        }else{
                            component.set("v.isPicklistDisabled", false);  
                        }
                    }
                })
                $A.enqueueAction(action4);
                
                // get default email recipent list
                var action5 = component.get("c.getDefaultEmailListFromJunoObjectSettings")
                action5.setParams({
                    "recordId" : component.get("v.recordId")
                });
                action5.setCallback(this,function(emailListResponse){
                    if(emailListResponse.getState() == 'SUCCESS'){
                        var responseResult = emailListResponse.getReturnValue();
                        //component.set("v.defaultDocTemplate",responseResult)
                        if(responseResult && responseResult.length){
                            console.log('Result >>> '+JSON.stringify(responseResult));
                            console.log(JSON.parse(JSON.stringify(responseResult)))
                            // alert(JSON.parse(JSON.stringify(responseResult)))
                            for(let i=0;i<responseResult.length; i++){
                                // responseResult[i]['ExpirationDate']= new Date().toISOString().split('T')[0];
                                responseResult[i]['ExpirationDate']= new Date(new Date().setDate(new Date().getDate() + 7)).toISOString().split('T')[0];
                                console.log('new Date().toISOString()--->', new Date().toISOString().split('T')[0]);
                            }
                            component.set("v.ListOfContact",responseResult)
                        }
                    }else{
                        console.log('error-->', emailListResponse.getError());
                    }
                })
                $A.enqueueAction(action5);
                
                var getOrgWideactions = component.get("c.orgwideEmail");
                getOrgWideactions.setCallback(this, function (response) {
                    if (response.getState() == "SUCCESS") {
                        var result = response.getReturnValue();
                        //alert('result--->'+JSON.stringify(result));
                        var opts = [];
                        opts.push({
                            label: "None",
                            value: ""
                        });
                        for (var key in result) {
                            opts.push({
                                label: result[key] ,
                                value: key
                            });
                        }
                        /*if(opts.length >= 2 && !component.get("v.EmailAddressSelectedValue")){
                        component.set("v.EmailAddressSelectedValue", opts[1]['value'])
                    }*/
                        component.set("v.options2", opts);
                    }
                });
                $A.enqueueAction(getOrgWideactions);
                
                var action30 = component.get("c.getSetReplyTo");
                action30.setParams({
                    recordId : component.get("v.recordId")
                });
                action30.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var result = response.getReturnValue();
                        component.set("v.SetReplyToValue",result);
                    }
                    
                });
                $A.enqueueAction(action30);
                
                var action31 = component.get("c.getObjectAPIName");
                action31.setParams({
                    rid : component.get("v.recordId")
                });
                action31.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var result = response.getReturnValue();
                        component.set("v.ObjectAPIName",result);
                    }
                    
                });
                $A.enqueueAction(action31);
                var action32 = component.get("c.getObjectLabelName");
                // alert('component.get("v.recordId")'+component.get("v.recordId"));
                action32.setParams({
                    "rid" : component.get("v.recordId")
                });
                action32.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var result = response.getReturnValue();
                        component.set("v.ObjectLabelName",result);
                        //this.GetObjectFields(component,event,helper);
                    }
                    
                });
                $A.enqueueAction(action32);
                
                var toastEvent = $A.get("e.force:showToast");
                var action33 = component.get("c.getinitialObjectFields");
                action33.setParams({
                    "recId" : component.get('v.recordId')
                });
                action33.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        //component.set("v.toggleSpinner",false);
                        var Result = response.getReturnValue();
                        //alert(Result);
                        if(Result.IsSuccess){
                            component.set('v.ShowLevel1',true);
                            component.set('v.InitialObjectFields',Result.WrapperList);
                            var breadcrumbCollection = component.get("v.breadcrumbCollection");
                            var breadcrumb = {};
                            var obj = [];
                            breadcrumb.label= component.get('v.ObjectLabelName');
                            breadcrumb.name= component.get('v.ObjectAPIName');   
                            breadcrumb.level = 'Level 0';
                            if(breadcrumbCollection != undefined){
                                breadcrumbCollection.push(breadcrumb);
                                component.set('v.breadcrumbCollection', breadcrumbCollection);
                            }
                            else{
                                obj.push(breadcrumb);
                                component.set('v.breadcrumbCollection', obj);
                            }
                        }else{
                            toastEvent.setParams({
                                "title": "Error!",
                                "type" : "error",
                                "message": Result.Message
                            });
                            toastEvent.fire();
                        }
                    }
                    else if (state === "ERROR") {
                        
                    }
                });
                $A.enqueueAction(action33);
                
                // get attachment setting value from junodoc setting
                var attachmentSetAction = component.get("c.getEnableAttachmentSetting");
                attachmentSetAction.setCallback(this, function(response){
                    component.set("v.Spinner", false);
                    let state = response.getState();
                    if(state === "SUCCESS"){
                        let result = response.getReturnValue();
                        component.set("v.showAttachmentSettingEnabledValue", result);
                        
                    }
                    else if (state === "ERROR") {
                        
                    }
                });
                $A.enqueueAction(attachmentSetAction);
                
                component.set("v.SelDocsLabel","Selected Documents("+component.get("v.selectedDocCount")+")");
            });
            $A.enqueueAction(action); 
            $A.enqueueAction(gefields); 
            
            /*let action888 = component.get("c.getAccountFieldValue");
            action888.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let fieldValue = response.getReturnValue();
                    alert('fieldValue>>>>>>>>>>>>>>>>>>>>>>>>>'+fieldValue);
                    component.set("v.showChildComponent", fieldValue); // Show or hide based on field value
                } else {
                    console.error("Error retrieving account field value: " + response.getError());
                }
            });
            
            $A.enqueueAction(action888);*/
            
        },
        
        //-------------siddhu-----------------//
        
        handleemailSelection :function(component,event,helper){
            let EmailAddressSelectedValue = component.get("v.EmailAddressSelectedValue");  
            component.set("v.EmailAddressSelectedValue", EmailAddressSelectedValue);
            // alert('selectedValue>>>>>>>>>>'+emailAddressSelectedValue12);
        },
        
        AvailableDocTemplateOnchangeHandler :  function(component,event,helper){
            var DocTemplateId = event.getSource().get("v.value");
            //alert(DocTemplateId);
            console.log(DocTemplateId);
            if(DocTemplateId!=''){  
                //Code Start Here
                var DocList = component.get("v.AvailableDocTemplatesList");
                for(var i=0;i<DocList.length;i++){
                    if(DocList[i].value == DocTemplateId){
                        //alert(DocList[i].type)
                        if(DocList[i].type == 'DocTemplate'){
                            component.set("v.isDocTemplate",true);
                        }
                        else{
                            component.set("v.isDocExcelTemplate",true);
                            component.set("v.isDocTemplate",false);
                        }
                    }
                    
                    
                }
                // Code End Here
                component.set("v.DocTemplateId",DocTemplateId);
                component.set("v.AvailableDocTemplateSelectedValue",DocTemplateId);
                /*var selectedConIds = component.get("v.SelectedDocuments");
                 var selectedRecId = component.get("v.AvailableDocTemplateSelectedValue");
                if(selectedRecId != null && selectedRecId != ''){
                    selectedConIds.push(selectedRecId);
                }*/
                //component.set("v.isDocTemplate",true);
                //alert(component.get("v.isDocTemplate"))
                if(component.get("v.VFPage") == false){
                    /* setTimeout(function(){ 
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'info',
                            message: 'Please wait...PDF is generating.',
                            duration:'2000',
                            key: 'info_alt',
                            type: 'info',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                    }
                               , 500);*/
                }
                
            }
            else{
                component.set('v.DocTemplateId','');
            }
        },
        
        
        handleCheck : function(component, event, helper) {
            
            var selectedRec = event.getSource().get("v.checked");
            var selectedRecId = event.getSource().get("v.value");
            var getSelectedNumber = component.get("v.selectedDocCount");
            var docList = component.get("v.ContentDocumentList");
            var newdocList = [];
            for (var i = 0; i < docList.length; i++){
                if(docList[i].budgetRecord.ContentDocumentId == selectedRecId){
                    docList[i].budgetCheck = selectedRec;
                }
                newdocList.push(docList[i]);
            }
            component.set("v.ContentDocumentList",newdocList);
            var selectedConIds = component.get("v.SelectedDocuments");
            
            if(selectedRec){
                if(selectedConIds.indexOf(selectedRecId) == -1){
                    selectedConIds.push(selectedRecId);
                }
                
            }else{
                if(selectedConIds.indexOf(selectedRecId) > -1){
                    var index = selectedConIds.indexOf(selectedRecId);
                    selectedConIds.splice(index,1);
                }
            } 
            if (selectedRec == true) {
                getSelectedNumber++;
            } else {
                getSelectedNumber--;
            }
            // set the actual value on selectedCount attribute to show on header part. 
            component.set("v.selectedDocCount", selectedConIds.length);
            component.set("v.SelDocsLabel","Selected Documents("+component.get("v.selectedDocCount")+")");
            component.set("v.SelectedDocuments", selectedConIds);
        },
        
        selectAll : function(component, event, helper) {        
            
            //get the header checkbox value  
            var selectedHeaderCheck = event.getSource().get("v.checked");
            var getAllId = component.find("boxPack");
            var docIds = []
            if(! Array.isArray(getAllId)){
                if(selectedHeaderCheck == true){ 
                    component.find("boxPack").set("v.checked", true);
                    component.set("v.selectedDocCount", 1);
                }else{
                    component.find("boxPack").set("v.checked", false);
                    component.set("v.selectedDocCount", 0);
                }
            }else{
                if (selectedHeaderCheck == true) {
                    for (var i = 0; i < getAllId.length; i++) {
                        component.find("boxPack")[i].set("v.checked", true);
                        component.set("v.selectedDocCount", getAllId.length);
                        docIds.push(component.find("boxPack")[i].get("v.value"))
                        
                    }
                } else {
                    for (var i = 0; i < getAllId.length; i++) {
                        component.find("boxPack")[i].set("v.checked", false);
                        component.set("v.selectedDocCount", 0);
                        docIds = []
                    }
                } 
            } 
            
            
            component.set("v.SelectedDocuments", docIds);
            component.set("v.SelDocsLabel","Selected Documents("+component.get("v.selectedDocCount")+")");
            
        },
        
        sendEnv : function(component, event, helper) {
            debugger;
            component.set("v.Spinner", true);
            component.set("v.showMessage", true);
            var action = component.get("c.sendDocEnv");
            var recordId = component.get('v.recordId');
            var selectedDocId = component.get('v.SelectedDocuments');
            var ContactList = component.get("v.ListOfContact");
            
            var emailList = component.get("v.emailList")
            
            for(var i = 0;i<ContactList.length;i++){
                if(emailList.length){
                    if(emailList.indexOf(ContactList[i]['Email']) < 0){
                        emailList.push(ContactList[i]['Email'])
                    }
                }else{
                    emailList.push(ContactList[i]['Email'])
                }
            }
            
            component.set("v.emailList",emailList)
            
            
            var nameList = component.get("v.recipentNameList")
            
            for(var i = 0;i<ContactList.length;i++){
                if(nameList.length){
                    if(nameList.indexOf(ContactList[i]['Name']) < 0){
                        nameList.push(ContactList[i]['Name'])
                    }
                }else{
                    nameList.push(ContactList[i]['Name'])
                }
            }
            
            component.set("v.recipentNameList",nameList)
            
            
            
            //alert(selectedDocId);
            action.setParams({
                recordId : component.get("v.recordId"),
                SelectedDoc : selectedDocId,
                emailList : component.get("v.emailList"),
                recipentNameList : component.get("v.recipentNameList")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                component.set("v.Spinner", false);
                component.set("v.showMessage",false);
                //  alert(state);
                if(state === "SUCCESS"){
                    
                    $A.get("e.force:closeQuickAction").fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get('v.recordId'),
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Your Document Is Sent For DocuSign.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        },
        
        addReceipents: function(component, event) {
            var addressvalue = component.get("v.EmailAddressSelectedValue");
            // alert('addressvalue>>>>>>>>>>>>>>>>>>>>>>>'+addressvalue);
            debugger;
            if(component.get("v.AvailableDocTemplateSelectedValue")){
                component.set('v.showDocuments',false)
                
                component.set('v.addRecipents',true)
                component.set("v.isaddReceipentcmp",true)
                component.set("v.isPrepareandSend",false)
                var getselectedStep = component.get("v.selectedStep");
                if(getselectedStep == "step1"){
                    component.set("v.selectedStep", "step2");
                    component.set("v.isPrepareandSend",false)
                    component.set("v.isDocumentcmp",false)
                    component.set("v.isaddReceipentcmp",true)
                    component.set("v.isImmediateActions",false)
                    component.set("v.isPostActioncmp",false)
                    //event.getSource().set('v.label','Send')
                    // event.getSource().set('v.title','Send')
                    //component.find("backBtn").set("v.disabled",false)
                }
                else if(getselectedStep == "step2"){
                    if(component.get("v.ListOfContact").length && addressvalue !=null && addressvalue !='' ){
                        var orgemailId = component.get("v.OrgEmailAddrId");
                        var addressvalue = component.get("v.EmailAddressSelectedValue");
                        var getTemplateValues = component.get("c.generateEmailTemplateValues");
                        getTemplateValues.setParams({
                            recordId : component.get("v.recordId")
                        });
                        getTemplateValues.setCallback(this, function(response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            if(state == 'SUCCESS'){
                                let isNoExpirationDateValue = false;
                                let isExpirationDateValueCrossed = false;
                                let ListOfContact = component.get("v.ListOfContact");
                                for(let i=0;i<ListOfContact.length; i++){
                                    if(!ListOfContact[i]['ExpirationDate']){
                                        isNoExpirationDateValue = true;
                                        break;
                                    }
                                    if(ListOfContact[i]['ExpirationDate'] < new Date().toISOString().split('T')[0]){
                                        isExpirationDateValueCrossed = true;
                                        break;
                                    }                     
                                }
                                if(isNoExpirationDateValue){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "type" : "error",
                                        "message": "Please enter valid date for Expiration Date field."
                                    });
                                    toastEvent.fire();
                                }else if(isExpirationDateValueCrossed){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "type" : "error",
                                        "message": "Expiration date should be greater than or equal to today."
                                    });
                                    toastEvent.fire();
                                }
                                    else{
                                        var value = component.get("v.SetReplyToValue");
                                        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\ [\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9] {1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
                                        if(value.match(regExpEmailformat) && value != '' && value != undefined){
                                            component.set("v.selectedStep", "step3");
                                            component.set("v.isPrepareandSend",true);
                                            component.set('v.addRecipents',false)
                                            component.set('v.isaddReceipentcmp',false)
                                            component.set('v.isImmediateActions',false),
                                            component.set("v.isError",false);
                                            component.set("v.isErrorMessage","");
                                        }
                                        else if(value == ''){
                                            component.set("v.selectedStep", "step3");
                                            component.set("v.isPrepareandSend",true);
                                            component.set('v.addRecipents',false)
                                            component.set('v.isaddReceipentcmp',false)
                                            component.set("v.isError",false);
                                            component.set("v.isErrorMessage","");
                                        }
                                            else{
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "title": "ERROR!",
                                                    "type": "ERROR",
                                                    "message": "Set Reply To Email Address must be an Email Value"
                                                });
                                                toastEvent.fire();
                                                
                                            }
                                    }
                                
                                
                            }
                        });
                        $A.enqueueAction(getTemplateValues);
                        
                        //component.set("v.isPrepareandSend",true);
                        
                        
                        
                        
                        
                        
                        //save from address method
                        var SaveFromEmailaction2 = component.get("c.SaveFromEmailAddress");
                       // alert('addressvalue................'+addressvalue);
                        SaveFromEmailaction2.setParams({
                            recordId : component.get("v.recordId"),
                            FromAddress : addressvalue
                        });
                        SaveFromEmailaction2.setCallback(this, function(response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            if(state == 'SUCCESS'){
                                if(result = 'Success'){
                                }
                                else{
                                }
                            }
                            else{
                                console.log('Error >>> '+JSON.stringify(response.getError()));
                            }
                        });
                        $A.enqueueAction(SaveFromEmailaction2);
                        
                    }
                    else{
                        var VFPage = component.get("v.VFPage");
                        if(!addressvalue){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Info!",
                                "message": "Please Select 'From Email'"
                            });
                            toastEvent.fire();
                        }else{
                            if(VFPage == false){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Info!",
                                    "message": "Please add atleast one recipient to send."
                                });
                                toastEvent.fire();
                            }
                            else{
                                component.set("v.isError",true);
                                component.set("v.isErrorMessage","Please add atleast one recipient to send."); 
                            }
                        }
                        
                    }
                    
                }
                    else if(getselectedStep == "step3"){
                        // Calling child component method in JunoSignPostActions
                        /* var childCmp = component.find("childCmponent");
                       // alert('calling child component.')
                        childCmp.childMethod();
                        var getTemplateValues = component.get("c.generateEmailTemplateValues");
                        getTemplateValues.setParams({
                            recordId : component.get("v.recordId")
                        });
                        getTemplateValues.setCallback(this, function(response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            if(state == 'SUCCESS'){
                                component.set("v.selectedStep", "step3");
                                // helper.getGeneratedTempValues(component, event, helper);
                                component.set("v.isPrepareandSend",true)
                                component.set('v.addRecipents',false)
                            }
                        });
                        $A.enqueueAction(getTemplateValues);*/
                        component.set("v.selectedStep", "step2");
                        // helper.getGeneratedTempValues(component, event, helper);
                        component.set("v.isPrepareandSend",false)
                        //component.set('v.addRecipents',false)
                    }
                var action = component.get('c.fetchContact');
                action.setParams({
                    recordId : component.get("v.recordId")
                });
                action.setCallback(this, function(response) {
                    
                    debugger;
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        if(response.getReturnValue() && Object.keys(response.getReturnValue()).length){
                            //  alert(JSON.stringify(response.getReturnValue()))
                            for(let i=0;i<response.getReturnValue().length; i++){
                                //let futuremonth = new Date().setMonth(date.getMonth()+months);
                                //response.getReturnValue()[i]['ExpirationDate'] = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10);
                                response.getReturnValue()[i]['ExpirationDate']= new Date().toISOString().split('T')[0];
                                // response.getReturnValue()[i]['ExpirationDate'] = new Date(new Date(response.getReturnValue()[i]['ExpirationDate']).getTime() + 10 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
                                // response.getReturnValue()[i]['ExpirationDate'] = new Date(Date.now() + 10 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
                                
                                // arry['ExpirationDate'] = new Date(new Date().setDate(new Date().getDate() + 10)).toISOString().split('T')[0];
                                // console.log('new Date().toISOString()--->', new Date().toISOString().split('T')[0]);
                                //response.getReturnValue()[i]['ExpirationDate'] = new Date(new Date().setDate(new Date().getDate() + 10)).toISOString().split('T')[0];
                                // response.getReturnValue()[i]['ExpirationDate'] = new Date(new Date().setDate(new Date().getDate() + 10)).toISOString().split('T')[0];
                                
                                console.log('new Date().toISOString()--->', new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10));
                                
                            }
                            component.set("v.ListOfContact", response.getReturnValue());
                        }
                        
                        
                        //component.set("v.selectedCount", 0);
                        // component.find("box3").set("v.value", false);
                        
                        
                        
                    }
                });
                if(!component.get("v.isFirstNext")){
                    $A.enqueueAction(action);
                    component.set("v.isFirstNext",true)
                    component.set("v.isError",false);
                    component.set("v.isErrorMessage","");
                }
            }
            else{
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type" : "error",
                        "message": "Please select template before you proceed."
                        
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Please select template before you proceed.");
                }
            }   
        },
        
        
        addRecipentData : function(component, event, helper) {
            var con = {
                "label": component.get("v.CurrentObjLabelName"),
                "name": component.get("v.ObjectAPIName"),
                "level": "Level 0"
            }
            var arr = []
            arr.push(con)
            component.set("v.breadcrumbCollection",arr);
            
            var emailType = event.currentTarget.dataset.emailtype
            component.set("v.emailTypeForReceipient",emailType)
            
            component.set("v.isAddReceipent",true);
            component.set("v.selectedFieldValue",'')
            component.set("v.ShowLevel2",false)
            component.set("v.ShowLevel1",true)
            var action = component.get("c.getEmail");
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                component.set("v.results",result);
                //alert(JSON.stringify(component.get("v.results")));
                console.log(JSON.stringify(component.get("v.results")));
            });
            $A.enqueueAction(action);
            
            
            
        }, 
        
        
        
        cancelSigning : function(component, event, helper) {
            var VFPage = component.get("v.VFPage");
            if(VFPage == false){
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
                window.setTimeout(function(){
                    location.reload()
                },150)
            }
            else{
                window.open('/'+ component.get("v.recordId"),'_self')
                
            }
        },
        
        backToDocs : function(component, event, helper) {
            component.set('v.showDocuments',true)
            component.set('v.addRecipents',false)
            component.set("v.isDocumentcmp",true)
            component.set("v.isaddReceipentcmp",false)
            component.set("v.isPostActioncmp",false)
            
            component.set("v.selectedStep", "step1");
            
            /* var getselectedStep = component.get("v.selectedStep");
            if(getselectedStep == "step2"){
                component.find("nextBtn").set("v.label","Next")
                component.find("nextBtn").set("v.title","Next")
                component.find("backBtn").set("v.disabled",true)
                component.set("v.selectedStep", "step1");
                component.set("v.isPrepareandSend", false);
                component.set("v.addRecipents",false);
                component.set('v.showDocuments',true)
            }else if(getselectedStep == "step3"){
                component.set("v.selectedStep", "step2");
                component.set("v.isPrepareandSend", false);
                component.set('v.addRecipents',true)
                component.set('v.showDocuments',false)
            }else if(getselectedStep == "step4"){
                component.set("v.selectedStep", "step3");
            }*/
        }, 
        backToAddRec : function(component, event, helper) {
            component.set('v.isPostActioncmp',false)
            component.set('v.isaddReceipentcmp',true)
            component.set('v.isDocumentcmp',false)
            component.set('v.showDocuments',false);
            component.set('v.addRecipents',true);
            component.set("v.isPrepareandSend",false);
            component.set("v.showPostAction",false)
            component.set("v.isImmediateActions", false);
            //component.set("v.selectedStep", "step2");
            // component.set("v.selectedStep", "step3");
            component.set("v.selectedStep", "step2");
        },
        addPostAction : function(component, event, helper) {
            component.set('v.isPostActioncmp',true)
            component.set('v.isaddReceipentcmp',false)
            component.set('v.isDocumentcmp',false)
            component.set('v.showDocuments',false)
            component.set('v.addRecipents',false)
            component.set("v.isPrepareandSend",false)
            component.set("v.showPostAction",true)
            component.set("v.selectedStep", "step3");
             component.set("v.isImmediateActions", false);
            
        },
        
        addRecipent : function(component, event, helper) {
            
            component.set("v.isAddReceipent",true);
            
            var action = component.get("c.getEmail");
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                component.set("v.results",result);
                //alert(JSON.stringify(component.get("v.results")));
                console.log(JSON.stringify(component.get("v.results")));
            });
            $A.enqueueAction(action);
            
        },
        
        
        
        cancelScreen: function(component, event, helper) {
            component.set('v.isAddReceipent',false)
        },
        
        
        onselect : function (component, event, helper) {
            debugger;
            
            var selectedObject = component.get("v.selectedValue");
            var results = component.get("v.results");
            
            for(var i=0;i<results.length;i++){
                if(results[i].Selectedvalue=='Contact'){
                    results[i].showContact=true;
                    results[i].showUser=false;
                    results[i].showEmail=false;
                }
                if(results[i].Selectedvalue=='User'){
                    results[i].showUser=true;
                    results[i].showContact=false;
                    results[i].showEmail=false;
                }
                if(results[i].Selectedvalue=='Email'){
                    results[i].showUser=false;
                    results[i].showContact=false;
                    results[i].showEmail=true;
                }
            }
            component.set("v.results",results);  
        },
        
        /*searchAll : function (component, event, helper) {
            
            debugger;
            //alert('hiii')
            const selectedtitle = event.target.closest('div').dataset.title;
            //alert(selectedtitle)
            var showButton = component.get("v.showButton");
            if(showButton == true){
                component.set("v.showButton", false);	    
            }
            
            var results = component.get("v.results");
            
            for(var i=0;i<results.length;i++){
                //alert(selectedtitle + i)
                if(selectedtitle == i){
                    if(results[i].Selectedvalue=='Contact'){
                        results[i].showContact=true;
                        results[i].showUser=false;
                        results[i].showEmail=false;
                        results[i].showEmaildrop = true;
                        results[i].showUserdrop = false;
                    }
                    if(results[i].Selectedvalue=='User'){
                        results[i].showUser=true;
                        results[i].showContact=false;
                        results[i].showEmail=false;
                        results[i].showUserdrop = true;
                        results[i].showEmaildrop = true;
                    }
                }
            }
            component.set("v.results",results);  
        },
        
        searchHandler : function (component, event, helper) {
            debugger;
            helper.search(component, event, helper);
        },
        
        optionClickHandler : function (component, event, helper) {
            debugger;
            
            const selectedValue = event.target.closest('li').dataset.value;
            const selectedlabel = event.target.closest('li').dataset.name;
            const selectedtitle = event.target.closest('li').dataset.title;
            const selectedId = event.target.closest('li').dataset.Id;
            //alert(selectedValue + selectedtitle + selectedId);
            component.set("v.inputValue", selectedValue);
            component.set("v.openDropDown", true);
            //alert("###$$$$"+component.get("v.inputValue"));
            component.set("v.openDropDown", false);
            
            var results = component.get("v.results");
            
            for(var i=0;i<results.length;i++){
                //alert(results[i].selectedtitle + i);
                //alert(results[i].Email)
                if(selectedtitle == i){
                    
                    if(results[i].Selectedvalue=='Contact'){
                        results[i].showContact=true;
                        results[i].showUser=false;
                        results[i].showEmail=false;
                        results[i].showEmaildrop = false;
                        results[i].showUserdrop = false;
                        results[i].Email = selectedValue;
                        results[i].Name = selectedlabel;
                    }
                    if(results[i].Selectedvalue=='User'){
                        results[i].showUser=true;
                        results[i].showContact=false;
                        results[i].showEmail=false;
                        results[i].showUserdrop = false;
                        results[i].Email = selectedValue;
                        results[i].Name = selectedlabel;
                    }
                }
            }
            component.set("v.results",results);
            //alert("After result"+JSON.stringify(results));
            console.log("After result"+JSON.stringify(results));
            
        },*/
        
        /* AddSelectedReceipent : function (component, event, helper) {
            debugger;
            var contactList = component.get("v.ListOfContact");
            var newContact = component.get("v.results");
            var seleVal = {}
            seleVal['Name'] = newContact[0]['Name']
            seleVal['Email'] = newContact[0]['Email']
            
            contactList.push(seleVal);
            
            component.set("v.ListOfContact",contactList);
            
            component.get("v.ListOfContact")
            
            component.set("v.isAddReceipent",false);
            
        },*/
        
        AddSelectedReceipent : function (component, event, helper) {
            
            var newContact = component.get("v.results");
            var lookup = component.get("v.selectedFieldValue");
            var ar = lookup.split("--");
            var lookupfield = ar[0];
            var iserror = false;
            var EmailResult;
            var SelectChecklistval = component.get("v.selectedValue");
            
            if(component.get("v.selectedFieldValue") != undefined && (component.get("v.selectedFieldValue") != '') && lookupfield.includes(">")){
                iserror = true;
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Select Valid Email Field",
                        "type":"error"
                    });
                    
                    toastEvent.fire(); 
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Select Valid Email Field.");
                }
            }
            else if((newContact[0]['Name'] == undefined || newContact[0]['Name'] == "" || newContact[0]['Name'] == null || newContact[0]['Email'] == undefined || newContact[0]['Email'] == null || newContact[0]['Email'] == "")&& component.get("v.isText")){
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Name && Email are required",
                        "type":"error"
                    });          
                    toastEvent.fire(); 
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Name && Email are required");
                }
            }
                else if((newContact[0]['Name'] == undefined || newContact[0]['Name'] == "" || newContact[0]['Name'] == null)&& component.get("v.isText")){
                    var VFPage = component.get("v.VFPage");
                    if(VFPage == false){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Name is required",
                            "type":"error"
                        });
                        
                        toastEvent.fire();
                    }else{
                        component.set("v.isError",true);
                        component.set("v.isErrorMessage","Name is required");
                    }
                }
                    else{
                        component.set("v.isError",false);
                        component.set("v.isErrorMessage","");
                        var Parenttrue = component.get("v.IsParent");
                        var apiname = component.get("v.selectedFieldValue");
                        var myArr = apiname.split("--");
                        var fieldName = myArr[0];
                        var action =component.get("c.GetEmailFieldValue");
                        action.setParams({
                            "recordId" : component.get("v.recordId"),
                            "FieldName" : fieldName,
                            "isparent" : Parenttrue,
                            "parentObj" : component.get("v.SelectedparentObject"),
                            
                        });
                        action.setCallback(this,function(a){
                            var state = a.getState();
                            
                            if(state == "SUCCESS"){
                                component.set("v.toggleSpinner",false);
                                var EmailResult = a.getReturnValue();   
                                
                                if((EmailResult.Email == undefined || EmailResult.Email == null || EmailResult.Email == "")){
                                    var VFPage = component.get("v.VFPage");
                                    if(VFPage == false){
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Error!",
                                            "message": "Selected email field should not be null",
                                            "type":"error"
                                        });
                                        toastEvent.fire();
                                    }
                                    else{
                                        component.set("v.isError",true);
                                        component.set("v.isErrorMessage","Selected email field should not be null"); 
                                    }
                                }else if(EmailResult == 'error'){
                                    // need to check for error condition as we changed in apex class 455 line
                                    var VFPage = component.get("v.VFPage");
                                    if(VFPage == false){
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "Error!",
                                            "message": "Selected email field should not be null",
                                            "type":"error"
                                        });
                                        toastEvent.fire();
                                    }
                                    else{
                                        component.set("v.isError",true);
                                        component.set("v.isErrorMessage","Selected email field should not be null"); 
                                    }
                                }
                                    else{ 
                                        
                                        var contactList = component.get("v.ListOfContact");
                                        var newContact = component.get("v.results");
                                        var seleVal = {}
                                        seleVal['Name'] = EmailResult.Name ? EmailResult.Name : newContact[0]['Name']
                                        if(component.get("v.isText") == false){
                                            seleVal['Email'] = EmailResult.Email;
                                        }else{
                                            seleVal['Email'] = newContact[0]['Email']
                                        }
                                        seleVal['EmailType'] = component.get("v.emailTypeForReceipient")
                                        seleVal['ExpirationDate'] = new Date().toISOString().split('T')[0];
                                        seleVal['ispostChecked'] = false;
                                        // seleVal['ExpirationDate'] = new Date(new Date().setDate(new Date().getDate() + 10)).toISOString().split('T')[0];
                                        contactList.push(seleVal);
                                        component.set("v.ListOfContact",contactList);
                                        // component.get("v.ListOfContact")
                                        //component.set("v.InitialObjectFields",[])
                                        component.set("v.selectedFieldValue",'')
                                        component.set("v.ShowLevel2",false)
                                        component.set("v.ShowLevel1",true)
                                        component.set("v.isAddReceipent",false);
                                    }
                            }
                            
                        });
                        if(component.get("v.isText") == false){
                            $A.enqueueAction(action);
                        }else{
                            var contactList = component.get("v.ListOfContact");
                            var newContact = component.get("v.results");
                            var seleVal = {}
                            seleVal['Name'] = newContact[0]['Name']
                            seleVal['Email'] = newContact[0]['Email']
                            seleVal['EmailType'] = component.get("v.emailTypeForReceipient")
                            seleVal['ExpirationDate'] = new Date().toISOString().split('T')[0];
                            seleVal['ispostChecked'] = false;
                            contactList.push(seleVal);
                            component.set("v.ListOfContact",contactList);
                            component.get("v.ListOfContact")
                            component.set("v.isAddReceipent",false); 
                        }
                    }  
        },
        
        
        onClickDocuments : function (component, event, helper) {
            component.set('v.showDocuments',true);
            component.set('v.addRecipents',false);
            component.set("v.isPrepareandSend",false);
            component.set("v.showPostAction",false)
            component.set("v.isDocumentcmp",true)
            component.set("v.isaddReceipentcmp",false)
            component.set("v.isPostActioncmp",false)
            component.set("v.selectedStep", "step1");
            component.set("v.isPicklistDisabled", true);
            component.set("v.isImmediateActions", false);
            
            
        },
    onClickImmediateActions: function(component, event, helper) {
        if(component.get("v.AvailableDocTemplateSelectedValue")){
            component.set('v.showDocuments', false);
            component.set('v.addRecipents', false);
            component.set("v.isPrepareandSend", false);
            component.set("v.isDocumentcmp", false);
            component.set("v.isaddReceipentcmp", false);
            component.set('v.isImmediateActions', true);
            component.set("v.selectedStep", "step4");
        } else {
            var VFPage = component.get("v.VFPage");
            if(VFPage == false){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!",
                    "type" : "error",
                    "message": "Please select template before you proceed."
                });
                toastEvent.fire();
            } else {
                component.set("v.isError",true);
                component.set("v.isErrorMessage","Please select template before you proceed.");
            }
        }
    },
    
        
        onClickPrepareAndSend : function (component, event, helper) {
            // Get the ListOfContact
            
            /*  let contacts = component.get("v.ListOfContact");
    
            contacts.forEach(contact => {
                if (contact.selectedWeekdays) {
                    let selectedWeekdaysList = [];
    
                    contact.weekdayOptions.forEach(day => {
                        if (day.checked) {
                            selectedWeekdaysList.push({
                                label: day.label,
                                value: day.value,
                                checked: true
                            });
                        }
                    });
    
                    contact.selectedWeekdaysList = selectedWeekdaysList;
                } else {
                    contact.selectedWeekdaysList = [];
                }
            });
    
            component.set("v.ListOfContact", contacts);
            console.log("Saved Contacts:", JSON.stringify(contacts));
            console.log('ListOfContact>>>>>>>>>>>>>>>>>.111111'+JSON.stringify(ListOfContact));*/
            /* let notificationDate = component.get("v.notificationDate");
            if (selectedOption === "EveryDay") {
                notificationDate = null;
            }
    
            if(component.get("v.selectedOption")){
                for(let i in contactList){
                    contactList[i]['Remainder'] = notificationDate ;
                    contactList[i]['particularDay'] = component.get("v.selectedOption");
                }
                component.set("v.ListOfContact",contactList);
            }*/
            
            
            var getTemplateValues = component.get("c.generateEmailTemplateValuesEmail");
            var EmailAddressSelectedValue = component.get("v.EmailAddressSelectedValue");
            var params = {
                recordId: component.get("v.recordId")
            };
            if ( EmailAddressSelectedValue == undefined) {
                params.templateId = null;
            } else {
                
                params.templateId = component.get("v.EmailAddressSelectedValue");
            }
            getTemplateValues.setParams(params); 
            
            $A.enqueueAction(getTemplateValues);
            
            if (component.get("v.showPostAction")) {
                var childCmp = component.find("childCmponent");
                childCmp.childMethod();
            }
            if(component.get("v.AvailableDocTemplateSelectedValue")){
                var getTemplateValues = component.get("c.generateEmailTemplateValues");
                getTemplateValues.setParams({
                    recordId : component.get("v.recordId")
                });
                getTemplateValues.setCallback(this, function(response) {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    if(state == 'SUCCESS'){
                        var addressvalue = component.get("v.EmailAddressSelectedValue");
                        // alert('addressvalue>>>>>>>>>>>>'+addressvalue);
                        if(component.get("v.ListOfContact").length && addressvalue !=null && addressvalue !=''){
                            let isNoExpirationDateValue = false;
                            let isExpirationDateValueCrossed = false;
                            let ListOfContact = component.get("v.ListOfContact");
                            for(let i=0;i<ListOfContact.length; i++){ 
                                if(!ListOfContact[i]['ExpirationDate']){
                                    isNoExpirationDateValue = true;
                                    break;
                                }
                                if(ListOfContact[i]['ExpirationDate'] < new Date().toISOString().split('T')[0]){
                                    isExpirationDateValueCrossed = true;
                                    break;
                                }               
                            }
                            if(isNoExpirationDateValue){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "type" : "error",
                                    "message": "Please enter valid date for Expiration Date field."
                                });
                                toastEvent.fire();
                            }else if(isExpirationDateValueCrossed){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "type" : "error",
                                    "message": "Expiration date should be greater than or equal to today."
                                });
                                toastEvent.fire();
                            }else{
                                var value = component.get("v.SetReplyToValue");
                                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\ [\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9] {1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
                                if(value.match(regExpEmailformat) && value != '' && value != undefined){
                                    component.set('v.showDocuments',false);
                                    component.set('v.isDocumentcmp',false);
                                    
                                    component.set('v.isaddReceipentcmp',false);
                                    component.set('v.addRecipents',false);
                                    
                                    component.set("v.isPrepareandSend",false);
                                    component.set("v.selectedStep", "step3");
                                    component.set("v.isImmediateActions", false);
                                    
                                }
                                else if(value == ''){
                                    component.set('v.showDocuments',false);
                                    component.set('v.isDocumentcmp',false);
                                    component.set('v.isaddReceipentcmp',false);
                                    component.set('v.addRecipents',false);
                                    component.set("v.isPrepareandSend",true);
                                    component.set("v.selectedStep", "step3");
                                    component.set("v.isImmediateActions", false);
                                }
                                    else{
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            "title": "ERROR!",
                                            "type": "ERROR",
                                            "message": "Set Reply To Email Address must be an Email Value"
                                        });
                                        toastEvent.fire();
                                    }
                                component.set("v.isPrepareandSend",true);
                            }
                        }
                        else{
                            var VFPage = component.get("v.VFPage");
                            if(!addressvalue){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Info!",
                                    "message": "Please Select 'From Email'"
                                });
                                toastEvent.fire();
                            }else{
                                if(VFPage == false){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Info!",
                                        "message": "Please add atleast one recipient to send."
                                    });
                                    toastEvent.fire();
                                }
                                else{
                                    component.set("v.isError",true);
                                    component.set("v.isErrorMessage","Please add atleast one recipient to send."); 
                                }
                            }
                            
                        }
                        
                        helper.callTemplatePreviewLwcMethod(component);
                    }
                });
                $A.enqueueAction(getTemplateValues);
            }
            else{
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type" : "error",
                        "message": "Please select template before you proceed."
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Please select template before you proceed.");
                }
            }        
        },
        
        
        onClickRecipients : function (component, event, helper) {
            
            if(component.get("v.AvailableDocTemplateSelectedValue")){
                component.set('v.showDocuments',false)
                component.set('v.addRecipents',true)
                component.set("v.isPrepareandSend",false)
                component.set("v.showPostAction",false)
                component.set('v.isStep2', true)
                component.set("v.isDocumentcmp",false)
                component.set("v.isaddReceipentcmp",true)
                component.set("v.isPostActioncmp",false)
                component.set("v.selectedStep", "step2");
                 component.set("v.isImmediateActions", false);
            }else
            {
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type" : "error",
                        "message": "Please select template before you proceed."
                        
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Please select template before you proceed.");
                }
            } 
            
        },
    
    
         
        addImmediateActions : function (component, event, helper) {
            
            if(component.get("v.AvailableDocTemplateSelectedValue")){
                component.set('v.showDocuments',false)
                component.set('v.addRecipents',false)
                component.set("v.isPrepareandSend",false)
                component.set("v.isImmediateActions",true)
                component.set("v.isDocumentcmp",false)
                component.set("v.isaddReceipentcmp",false)
                 component.set("v.selectedStep", "step4");
               
            }else
            {
                var VFPage = component.get("v.VFPage");
                if(VFPage == false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "type" : "error",
                        "message": "Please select template before you proceed."
                        
                    });
                    toastEvent.fire();
                }
                else{
                    component.set("v.isError",true);
                    component.set("v.isErrorMessage","Please select template before you proceed.");
                }
            }
            
        },
        /*FirstLevelSelectChange:function(component, event, helper){
            component.set("v.IsParent",false);
            var FieldDetails = component.get("v.selectedFieldValue");
            //alert("FieldDetails"+FieldDetails)
            var breadcrumbListClone = component.get("v.breadcrumbCollection");
            if(FieldDetails == "Text"){
                component.set("v.isText",true);
                var con = {
                    "label": component.get('v.CurrentObjLabelName'),
                    "name": component.get('v.ObjectAPIName'),
                    "level": "Level 0"
                }
                var arr = []
                arr.push(con)
                component.set("v.breadcrumbCollection",arr);
                // alert(JSON.stringify(component.get("v.breadcrumbCollection")));
            }else{
                component.set("v.breadcrumbCollection",breadcrumbListClone);
                component.set("v.isText",false);
            }
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            
            component.set("v.SelectedparentObject",FieldDetails.split('-')[0]);
            // alert("parent"+component.get("v.SelectedparentObject"));
            // alert("val"+component.get("v.selectedFieldValue"));
            var ApiName = FieldDetails.split('-')[0];
            var LabelName = FieldDetails.split('-')[2];
            component.set('v.FirstLevField',ApiName);
            if(LabelName != '' && LabelName != undefined && LabelName.includes('>')){
                helper.GetFirstLevLookUpObjectFields(component, event, helper, LokUpApiName);
            }else{
                helper.GetFirstLevelFieldDetails(component, event, helper, ObjName, FieldDetails);
                //component.set("v.SaveButtonDisabled",false);
                //component.set("v.AddRowButtonDisabled",false);
            }
        },
        GetSecLevelSelectedField : function(component, event, helper){
            //alert("QQQQQ"+component.get("v.selectedFieldValue"));
            var FieldDetails = component.get("v.selectedFieldValue");
            
            var selectedobj = component.get("v.SelectedparentObject");
            component.set("v.SelectedparentObject",selectedobj+'.'+FieldDetails.split('-')[0]);
            // alert(FieldDetails);
            component.set("v.IsParent",true);
            // alert(component.get("v.IsParent"));
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var LabelName = FieldDetails.split('-')[2];
           // alert(FirstField);
            component.set('v.SecondLevField',ApiName);
            //if(LabelName.includes('>')){
            //helper.GetSecLevLookUpObjectFields(component, event, helper, LokUpApiName);
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
            // }else{
          //  alert(LabelName);
            if(LabelName.includes('>')){
                helper.GetSecLevLookUpObjectFields(component, event, helper, LokUpApiName);
               
            }else{
                helper.GetSecLevelFieldDetails(component, event, helper, ObjName, FirstField, FieldDetails);
               
            }
            
            //helper.GetSecLevelFieldDetails(component, event, helper, ObjName, FirstField, FieldDetails);
            
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
            //}
        },
        GetThirdLevelSelectedField : function(component, event, helper){
            
            var FieldDetails = component.get("v.selectedFieldValue");
           // alert(FieldDetails);
            var selectedobj = component.get("v.SelectedparentObject");
            component.set("v.SelectedparentObject",selectedobj+'.'+FieldDetails.split('-')[0]);
            component.set("v.IsParent",true); 
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var SecondField = component.get('v.SecondLevField');
            var LabelName = FieldDetails.split('-')[2];
            component.set('v.ThirdLevField',ApiName);
            
            if(LabelName.includes('>')){
                helper.GetThirdLevLookUpObjectFields(component, event, helper, LokUpApiName);
                component.set("v.SaveButtonDisabled",true);
                component.set("v.AddRowButtonDisabled",true);
            }
            else{
                helper.GetThirdLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, FieldDetails);
                component.set("v.SaveButtonDisabled",false);
                component.set("v.AddRowButtonDisabled",false);
            }
        },
         GetFinalLevelSelectedField : function(component, event, helper){
            
             var FieldDetails = component.get("v.selectedFieldValue");
           // alert(FieldDetails);
            var selectedobj = component.get("v.SelectedparentObject");
            component.set("v.SelectedparentObject",selectedobj+'.'+FieldDetails.split('-')[0]);
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var SecondField = component.get('v.SecondLevField');
            var ThirdField = component.get('v.ThirdLevField');
            
    
            
            //component.set('v.FinalLevField',ApiName);*/
        /*if(event.target.text.includes('>')){
                helper.GetFinalLevLookUpObjectFields(component, event, helper, LokUpApiName);
            }else{*/
        /*component.set("v.SaveButtonDisabled",false);
                component.set("v.AddRowButtonDisabled",false);
            helper.GetFinalLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FieldDetails);
            //}
        },*/
        /* navigateTo: function(component,event,helper){
            //component.set("v.selectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ThirdSelectedValue","");
            component.set("v.FourthSelectedValue","");
            // component.set("v.selectedFieldValue","")
            
            
            component.set("v.ToCcBccPicklistVal","To");
            component.set("v.TextRefPicklistVal","Reference");
            var level = event.getSource().get("v.name")
            
            var bread = component.get('v.breadcrumbCollection');
            //alert("bread"+JSON.stringify(bread));
            
            
            
            var number = level.split(' ')[1];
            for(var i=0;i<bread.length-number-1;i++){
                bread.pop();
                
            }
            component.set('v.breadcrumbCollection',bread);
            if(number == 0){
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
            }
            else if(number == 1 ){
                component.set("v.ShowLevel1",false);
                component.set("v.ShowLevel2",true);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
            }
                else if(number == 2 ){
                    component.set("v.ShowLevel1",false);
                    component.set("v.ShowLevel2",false);
                    component.set("v.ShowLevel3",true);
                    component.set("v.ShowLevel4",false);
                }
                    else if(number == 3 ){
                        component.set("v.ShowLevel1",false);
                        component.set("v.ShowLevel2",false);
                        component.set("v.ShowLevel3",false);
                        component.set("v.ShowLevel4",true);
                    }
            
            
            component.set("v.toAddRowListExist", true);
            
        },*/
        ConsolidateLines : function(component,event,helper){
            
            window.open('/'+component.get("v.recordId"),'_self')
            $A.get("e.force:closeQuickAction").fire();
        },
        handleRemoveItem : function(component, event, helper) {
            // var self = this;  // safe reference
            
            let contacts = component.get("v.ListOfContact");
            let index = event.currentTarget.getAttribute("data-index");
            // alert('deleteIndex>>>>>>>>>>>>>>'+index);
            if (index !== null) {
                contacts.splice(index, 1);
                component.set("v.ListOfContact", contacts);
            }
            
            /* var index = event.target.dataset.index;
            alert('index>>'+index);
            var lines = component.get("v.ListOfContact");
            lines.splice(index, 1);
            component.set("v.ListOfContact", lines);*/
        },
        
        getDate : function(component, event, helper) {
            // alert('hi');
        },
        
        onRefTypeChange : function(component,event,helper) {
            var value = component.get("v.RefType");
            //alert('value----->'+value);
            var AddRowList = component.get("v.AddRowTemporaryList");
            //alert('AddRowList---->'+AddRowList);
            //alert('AddRowList.length---->'+AddRowList.length);
            if(AddRowList!=null){
                if(AddRowList.length>0){
                    component.set('v.SaveButtonDisable', false);
                }
            }
            //alert('value----->'+value);
            if(value == 'Text'){
                //alert('value----->'+value);
                component.set("v.isText",true);
                component.set("v.isReference",false);
                component.set("v.isContactorUser",false);
                //component.set("v.isUser",false);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
                component.set("v.FirstSelectedValue","");
                component.set("v.SecondSelectedValue","");
                component.set("v.ThirdSelectedValue","");
                component.set("v.FourthSelectedValue","");
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
            }
            if(value == 'Reference'){
                component.set("v.isText",false);
                component.set("v.isReference",true);
                component.set('v.ShowLevel1',true);
                component.set("v.isContactorUser",false);
                //component.set("v.isUser",false);
                component.set("v.RecipientName","");
                component.set("v.TextEmailAddress","");
            }
            if(value == 'Contact'){
                component.set("v.isText",false);
                component.set("v.isReference",false);
                component.set("v.isContactorUser",true);
                //component.set("v.isUser",false);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
                component.set("v.FirstSelectedValue","");
                component.set("v.SecondSelectedValue","");
                component.set("v.ThirdSelectedValue","");
                component.set("v.FourthSelectedValue","");
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.RecipientName","");
                component.set("v.TextEmailAddress","");
            }
            if(value == 'User'){
                component.set("v.isText",false);
                component.set("v.isReference",false);
                component.set("v.isContactorUser",true);
                //component.set("v.isUser",true);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
                component.set("v.FirstSelectedValue","");
                component.set("v.SecondSelectedValue","");
                component.set("v.ThirdSelectedValue","");
                component.set("v.FourthSelectedValue","");
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.RecipientName","");
                component.set("v.TextEmailAddress","");
            }
        },
        searchHandler : function (component, event, helper) {
            helper.search(component, event, helper);
        },
        searchAll : function (component, event, helper) {
            const selectedtitle = event.target.closest('div').dataset.title;
            helper.searchAllHandler(component,selectedtitle,'');
        },
        optionClickHandler : function (component, event, helper) {
            debugger;
            const selectedValue = event.target.closest('li').dataset.value;
            const selectedlabel = event.target.closest('li').dataset.name;
            const selectedtitle = event.target.closest('li').dataset.title;
            const selectedId = event.target.closest('li').dataset.Id;
            component.set("v.TextEmailAddress",selectedValue);
            component.set("v.selectedConOrUser",selectedlabel);
            component.set("v.showdropdown",false)
            if(selectedValue){
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
                
            }
        },
        handleconUserEmailChange : function (component, event, helper) {
            
            if(component.get("v.TextEmailAddress")){
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }else{
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }
            var AddRowList = component.get("v.AddRowTemporaryList");
            //alert('AddRowList---->'+AddRowList);
            //alert('AddRowList.length---->'+AddRowList.length);
            if(AddRowList.length>0){
                component.set('v.SaveButtonDisable', false);
            }
            
        },
        FirstLevelSelectChange:function(component, event, helper){
            component.set("v.IsParent",false);
            var FieldDetails = component.get("v.FirstSelectedValue");
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var LabelName = FieldDetails.split('-')[2];
            component.set('v.FirstLevField',ApiName);
            if(LabelName.includes('>')){
                helper.GetFirstLevLookUpObjectFields(component, event, helper, LokUpApiName);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }else{
                helper.GetFirstLevelFieldDetails(component, event, helper, ObjName, FieldDetails);
                // component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }
            
        },
        GetSecLevelSelectedField : function(component, event, helper){
            component.set("v.IsParent",true);
            var FieldDetails = component.get("v.SecondSelectedValue");
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var LabelName = FieldDetails.split('-')[2];
            
            component.set('v.SecondLevField',ApiName);
            if(LabelName.includes('>')){
                helper.GetSecLevLookUpObjectFields(component, event, helper, LokUpApiName);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }else{
                helper.GetSecLevelFieldDetails(component, event, helper, ObjName, FirstField, FieldDetails);
                
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }
        },
        GetThirdLevelSelectedField : function(component, event, helper){
            component.set("v.IsParent",true);
            var FieldDetails = component.get("v.ThirdSelectedValue");
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var SecondField = component.get('v.SecondLevField');
            var LabelName = FieldDetails.split('-')[2];
            component.set('v.ThirdLevField',ApiName);
            
            if(LabelName.includes('>')){
                helper.GetThirdLevLookUpObjectFields(component, event, helper, LokUpApiName);
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }
            else{
                helper.GetThirdLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, FieldDetails);
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }
        },
        
        GetFinalLevelSelectedField : function(component, event, helper){
            var FieldDetails = component.get("v.FourthSelectedValue");
            var ObjName = component.get('v.ObjectAPIName');
            var LokUpApiName = FieldDetails.split('-')[1];
            var ApiName = FieldDetails.split('-')[0];
            var FirstField = component.get('v.FirstLevField');
            var SecondField = component.get('v.SecondLevField');
            var ThirdField = component.get('v.ThirdLevField');
            
            
            //component.set('v.FinalLevField',ApiName);
            /*if(event.target.text.includes('>')){
                helper.GetFinalLevLookUpObjectFields(component, event, helper, LokUpApiName);
            }else{*/
            //component.set("v.SaveButtonDisable",false);
            component.set("v.AddRowDisable",false);
            helper.GetFinalLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FieldDetails);
            //}
        },
        AddRows: function(component,event,helper) {
            try{
                var EmailType = component.get("v.emailTypeForReceipient");
                component.set("v.AddRowButtonClicked",true);
                var IterableList = component.get("v.AddRowTemporaryList");
                debugger;
                var selectedValue= component.get("v.ToCcBccSelectedVal"); //component.get("v.emailTypeRecipient");
                /*if(component.get("v.isSigneeMapping")){
                selectedValue = component.get("v.emailTypeRecipient");
            }*/
                var TextRefValue=component.get("v.RefType");
                var value = component.get("v.TextEmailAddress");
                var recipientName = '';
                if(TextRefValue == 'Contact' || TextRefValue == 'User'){
                    
                    recipientName = component.get("v.selectedConOrUser");
                }
                else if(TextRefValue == 'Text'){
                    recipientName = component.get("v.RecipientName");
                }
                    else{
                        
                    }
                //var TextName = component.get("v.TextName");
                var lookupValue = '';
                var APIvalue ='';
                var isLookup;
                if(component.get("v.ObjectLabelName") != undefined && component.get("v.ObjectLabelName") != ''){
                    lookupValue = component.get("v.ObjectLabelName");
                    APIvalue = component.get("v.ObjectAPIName");
                    isLookup =true;
                    if(component.get("v.FirstSelectedValue") != undefined && component.get("v.FirstSelectedValue") != ''){
                        
                        var FieldDetails =component.get("v.FirstSelectedValue");
                        var LokUpApiName = FieldDetails.split('-')[1];
                        var ApiName = FieldDetails.split('-')[0];
                        var LabelName = FieldDetails.split('-')[2];
                        lookupValue = lookupValue +'>'+ LabelName;
                        APIvalue = APIvalue+':'+ LokUpApiName;
                        if(LokUpApiName != '' && LabelName.includes('>')){
                            isLookup = true; 
                        }else{
                            isLookup =false;
                        }
                        if(component.get("v.SecondSelectedValue") != undefined && component.get("v.SecondSelectedValue") != ''){
                            var FieldDetails = component.get("v.SecondSelectedValue");
                            var LokUpApiName = FieldDetails.split('-')[1];
                            var ApiName = FieldDetails.split('-')[0];
                            var LabelName = FieldDetails.split('-')[2];
                            
                            lookupValue = lookupValue+ LabelName;
                            APIvalue =APIvalue+':'+ LokUpApiName;
                            if(LokUpApiName != '' && LabelName.includes('>')){
                                isLookup = true; 
                            }else{
                                isLookup =false;
                            }
                            if(component.get("v.ThirdSelectedValue") != undefined && component.get("v.ThirdSelectedValue") != ''){
                                var FieldDetails = component.get("v.ThirdSelectedValue");
                                var LokUpApiName = FieldDetails.split('-')[1];
                                var ApiName = FieldDetails.split('-')[0];
                                var LabelName = FieldDetails.split('-')[2];
                                
                                lookupValue = lookupValue+ LabelName;
                                APIvalue =APIvalue+':'+ LokUpApiName;
                                if(LokUpApiName != '' && LabelName.includes('>')){
                                    isLookup = true; 
                                }else{
                                    isLookup =false;
                                }
                                if(component.get("v.FourthSelectedValue") != undefined && component.get("v.FourthSelectedValue") != ''){
                                    var FieldDetails = component.get("v.FourthSelectedValue");
                                    var LokUpApiName = FieldDetails.split('-')[1];
                                    var ApiName = FieldDetails.split('-')[0];
                                    var LabelName = FieldDetails.split('-')[2];
                                    
                                    lookupValue = lookupValue+ LabelName;
                                    APIvalue =APIvalue+':'+ LokUpApiName;
                                    if(LokUpApiName != '' && LabelName.includes('>')){
                                        isLookup = true; 
                                    }else{
                                        isLookup =false;
                                    }
                                }
                            }
                        }
                    }
                }
                
                var finalFieldDetails;
                if(component.get("v.FirstLevSelectedFieldDetails") != undefined){
                    finalFieldDetails = component.get("v.FirstLevSelectedFieldDetails");     
                }else if(component.get("v.SecondLevSelectedFieldDetails") != undefined){
                    finalFieldDetails = component.get("v.SecondLevSelectedFieldDetails");    
                }else if(component.get("v.ThirdLevSelectedFieldDetails") != undefined){
                    finalFieldDetails = component.get("v.ThirdLevSelectedFieldDetails");      
                }else if(component.get("v.FinalLevSelectedFieldDetails") != undefined){
                    finalFieldDetails = component.get("v.FinalLevSelectedFieldDetails");     
                }
                var obj = [];
                
                var arry = {};
                
                /* if(selectedValue != '' && selectedValue != undefined && selectedValue != null){
                    arry.Tovalue = selectedValue;
                    
                }*/
                /*if(TextName != '' && TextName != undefined && TextName != null){
                arry.TextName = TextName;
                
            }*/
                arry.EmailType = EmailType;
                if(TextRefValue != '' && TextRefValue != undefined && TextRefValue != null){
                    arry.TextRefVal = TextRefValue;
                    
                }
                if(recipientName != ''&& recipientName != '' && recipientName != null){
                    arry.Recipient = recipientName;
                }
                if(value!=undefined && value != '' &&value != null){
                    arry.Email = value;
                    if(IterableList != undefined && IterableList != ''){
                        
                        if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User' || arry.TextRefVal == 'Reference') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName") )){
                            IterableList.push(arry);
                            component.set("v.AddRowTemporaryList",IterableList);
                            component.set("v.toAddRowListExist", true);
                        }
                    }
                    else{
                        
                        if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User' || arry.TextRefVal == 'Reference') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName"))){
                            obj.push(arry);
                            component.set("v.AddRowTemporaryList",obj);
                            component.set("v.toAddRowListExist", true);
                        }
                    }
                    var AddRowList = component.get("v.AddRowTemporaryList");
                    if(AddRowList.length>0){
                        component.set('v.SaveButtonDisable', false);
                    }
                } 
                else if(lookupValue != undefined && lookupValue != '' && lookupValue != null&& !lookupValue.includes('None')){
                    var Mail = '';
                    var Name = '';
                    var Parenttrue = component.get("v.IsParent").toString();
                    var recordId = component.get("v.recordId");
                    var fieldDetails = component.get('v.ObjectAPIName')+'.'+finalFieldDetails;
                    var action_LookUp = component.get("c.getLookUpMail");
                    action_LookUp.setParams({
                        recId : recordId,
                        LookUp_Value : fieldDetails,
                        //IsParent : Parenttrue
                    });
                    action_LookUp.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            
                            var result_Lookup = response.getReturnValue();
                            if(result_Lookup.Message == 'Success'){
                                arry.Email = result_Lookup.Mail;
                                arry.Recipient = result_Lookup.Name;
                            }
                            else if(result_Lookup.Message == 'Error'){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Selected email field should not be null",
                                    "type":"error"
                                });
                                toastEvent.fire();
                            }
                            
                            
                            if(IterableList != undefined && IterableList != ''){
                                
                                if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User' || arry.TextRefVal == 'Reference') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName") )){
                                    IterableList.push(arry);
                                    component.set("v.AddRowTemporaryList",IterableList);
                                    component.set("v.toAddRowListExist", true);
                                }
                            }
                            else{
                                
                                if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User' || arry.TextRefVal == 'Reference') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName"))){
                                    obj.push(arry);
                                    component.set("v.AddRowTemporaryList",obj);
                                    component.set("v.toAddRowListExist", true);
                                }
                            }
                            var AddRowList = component.get("v.AddRowTemporaryList");
                            
                            if(AddRowList.length>0){
                                component.set('v.SaveButtonDisable', false);
                            }
                        }
                    });
                    $A.enqueueAction(action_LookUp);
                    
                }
                
                component.set("v.TextEmailAddress", "");
                component.set("v.RecipientName", "");
                component.set("v.selectedConOrUser","");
                component.set("v.FirstSelectedValue","");
                component.set("v.SecondSelectedValue","");
                component.set("v.ThirdSelectedValue","");
                component.set("v.FourthSelectedValue","");
                component.set("v.ToCcBccSelectedVal","To");
                component.set("v.AddRowDisable",true);
                component.set("v.RefType",arry.TextRefVal);
                if(arry.TextRefVal =='Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User'){
                    component.set("v.isReference",false);
                }else{
                    component.set("v.isReference", true);
                }
                
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                component.set("v.FirstLevSelectedFieldDetails",undefined);
                component.set("v.SecondLevSelectedFieldDetails",undefined);
                component.set("v.ThirdLevSelectedFieldDetails",undefined);
                component.set("v.FinalLevSelectedFieldDetails",undefined);
                //Breadcrumbs cannot be null
                //BreadCrumb code start
                var breadcrumbCollection = [];
                var breadcrumb = {};
                var objBread = [];
                breadcrumb.label= component.get('v.ObjectLabelName');
                breadcrumb.name= component.get('v.ObjectAPIName');   
                breadcrumb.level = 'Level 0';
                if(breadcrumbCollection != undefined){
                    breadcrumbCollection.push(breadcrumb);
                    component.set('v.breadcrumbCollection', breadcrumbCollection);
                }
                else{
                    objBread.push(breadcrumb);
                    component.set('v.breadcrumbCollection', objBread);
                }    
            }catch(error){
                console.error(error);
            }
        },
        SaveRecipients:function(component, event, helper){
            
            var IterableList = component.get("v.accList");
            var selectedValue=component.get("v.ToCcBccSelectedVal");
            var TextRefValue=component.get("v.RefType");
            var value = component.get("v.TextEmailAddress");
            var lookupValue = '';
            var APIvalue ='';
            var isLookup;
            var AdditionalRowList = component.get("v.AddRowTemporaryList");
            
            if(AdditionalRowList != undefined){
                var obj = component.get("v.ListOfContact");
                var listLength = AdditionalRowList.length;
                
                for (var i=0; i < AdditionalRowList.length; i++) {
                    var arry = {};
                    
                    arry.EmailType = AdditionalRowList[i].EmailType;
                    arry.Email =AdditionalRowList[i].Email;
                    
                    arry.Name = AdditionalRowList[i].Recipient;
                    
                    arry['ExpirationDate'] = new Date(new Date().setDate(new Date().getDate() + 7)).toISOString().split('T')[0];
                    console.log('new Date().toISOString()--->',  new Date(new Date().setDate(new Date().getDate() + 7)).toISOString().split('T')[0]);
                    
                    //arry['ExpirationDate']= new Date().toISOString().split('T')[0];
                    
                    obj.push(arry);
                    
                }
                component.set("v.ListOfContact",obj);            
            }
            
            component.set("v.isAddReceipent",false);
            component.set("v.RecipientName","");
            component.set("v.TextEmailAddress", "");
            component.set("v.FirstSelectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ThirdSelectedValue","");
            component.set("v.FourthSelectedValue","");
            component.set("v.ToCcBccSelectedVal","To");
            component.set("v.RefType","Text");
            component.set("v.isText", true);
            component.set("v.isReference", false);
            component.set("v.isContactorUser", false);
            component.set("v.ShowLevel1",true);
            component.set("v.ShowLevel2",false);
            component.set("v.ShowLevel3",false);
            component.set("v.ShowLevel4",false);
            component.set("v.ShowLevel5",false);
            component.set("v.toEmailListExist", true);
            component.set("v.AddRowButtonClicked",false);
            component.set("v.AddRowDisable",true);
            component.set("v.SaveButtonDisable",true);
            //Breadcrumbs cannot be null
            //BreadCrumb code start
            var breadcrumbCollection = [];
            var breadcrumb = {};
            var obj = [];
            breadcrumb.label= component.get('v.ObjectLabelName');
            breadcrumb.name= component.get('v.ObjectAPIName');   
            breadcrumb.level = 'Level 0';
            if(breadcrumbCollection != undefined){
                breadcrumbCollection.push(breadcrumb);
                component.set('v.breadcrumbCollection', breadcrumbCollection);
            }
            else{
                obj.push(breadcrumb);
                component.set('v.breadcrumbCollection', obj);
            }   
            component.set("v.AddRowTemporaryList", null);
            //Breadcrumb Code End
            component.set("v.emailList", component.get("v.accList"));
        },
        navigateTo: function(component,event,helper){
            component.set("v.FirstSelectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ThirdSelectedValue","");
            component.set("v.FourthSelectedValue","");
            
            
            //component.set("v.ToCcBccSelectedVal","To");
            component.set("v.RefType","Reference");
            var level = event.getSource().get("v.name")
            var bread = component.get('v.breadcrumbCollection');
            
            //alert('level'+level);
            //alert('bread'+JSON.stringify(bread));
            //alert(bread.length);
            
            
            var number = level.split(' ')[1];
            for(var i=0;i<bread.length-number-1;i++){
                bread.pop();
                
            }
            component.set('v.breadcrumbCollection',bread);
            if(number == 0){
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
            }else if(number == 1 ){
                component.set("v.ShowLevel1",false);
                component.set("v.ShowLevel2",true);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
            }else if(number == 2 ){
                component.set("v.ShowLevel1",false);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",true);
                component.set("v.ShowLevel4",false);
            }else if(number == 3 ){
                component.set("v.ShowLevel1",false);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",true);
            }
            
            component.set("v.toAddRowListExist", true);
            
        },
        deleteAddRowClick: function(component,event,helper){
            
            var count = event.currentTarget.dataset.id;
            //alert('count==>'+count);
            var tempList = component.get("v.AddRowTemporaryList");
            tempList.splice(count, 1);
            component.set("v.AddRowTemporaryList", tempList);
            if(tempList.length <= 0){
                component.set("v.SaveButtonDisable", true);
            }
        },
        RecipientChange: function(component,event,helper) {
            var value2 = component.get("v.RecipientName");
            var value = component.get("v.TextEmailAddress");
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\ [\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9] {1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            if(value != undefined && value != '' && value2 != undefined && value2 != '' && value.match(regExpEmailformat)){
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }
            else{
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }
        },
        EmailChange: function(component,event,helper) {
            var value2 = component.get("v.RecipientName");
            var value = component.get("v.TextEmailAddress");
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\ [\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9] {1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
            if(value != undefined && value != '' && value2 != undefined && value2 != '' && value.match(regExpEmailformat)){
                //component.set("v.SaveButtonDisable",false);
                component.set("v.AddRowDisable",false);
            }
            else{
                //component.set("v.SaveButtonDisable",true);
                component.set("v.AddRowDisable",true);
            }
        },
        AddEmailRecipients: function(component,event,helper) {
            var recordId = component.get("v.recordId");
            component.set("v.isAddReceipent", true);
        },
        closeAddRecipients: function(component,event,helper) {
            component.set("v.isAddReceipent", false);
            component.set("v.RecipientName","");
            
            component.set("v.TextEmailAddress", "");
            component.set("v.FirstSelectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ToCcBccSelectedVal","To");
            component.set("v.RefType","Text");
            component.set("v.isReference", false);
            component.set("v.isContactorUser", false);
            component.set("v.isText", true);
            component.set("v.ShowLevel1",false);
            component.set("v.ShowLevel2",false);
            component.set("v.ShowLevel3",false);
            component.set("v.ShowLevel4",false);
            component.set("v.ShowLevel5",false);
            component.set("v.AddRowButtonClicked",false);
            component.set("v.AddRowTemporaryList",null);
            component.set("v.SaveButtonDisable",true);
            component.set("v.AddRowDisable",true);
            
            //Breadcrumbs cannot be null
            //BreadCrumb code start
            var breadcrumbCollection = [];
            var breadcrumb = {};
            var obj = [];
            breadcrumb.label= component.get('v.ObjectLabelName');
            breadcrumb.name= component.get('v.ObjectAPIName');   
            breadcrumb.level = 'Level 0';
            if(breadcrumbCollection != undefined){
                breadcrumbCollection.push(breadcrumb);
                component.set('v.breadcrumbCollection', breadcrumbCollection);
            }
            else{
                obj.push(breadcrumb);
                component.set('v.breadcrumbCollection', obj);
            }   
            //Breadcrumb Code End
        },
        handleUploadFinished: function (component, event, helper) {
            debugger;
            var uploadedFiles = event.getParam("files");
            //uploadedFiles.forEach(file => console.log(file.documentId + '' +file.name ));
            //var files = event.getSource().get("v.files");
            //alert('inn');
            var FilesUpload = [];     
            
            for(var i=0;i<uploadedFiles.length;i++){
                FilesUpload.push({
                    'name':uploadedFiles[i].name,
                    'fileContents': uploadedFiles[i].documentId
                });
            }
            component.set("v.UploadFiles", FilesUpload);
            
            if(uploadedFiles.length>0){
                component.set("v.FilesTable", true);
            }
            //component.set("v.UploadFiles",FilesUpload);
            
        },
        deleteThisFile : function (component, event) {
            var count = event.currentTarget.dataset.id;
            //alert('count==>'+count);
            var tempList = component.get("v.UploadFiles");
            var tempID = tempList.splice(count, 1);
            //alert('tempID--->'+JSON.stringify(tempID));
            var action = component.get("c.deleteUploadedFiles");
            action.setParams({
                'tempFileList' :  JSON.stringify(tempID)
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                component.set("v.UploadFiles", tempList);
                //alert('tempList--->'+tempList);
                //alert('tempList.length--->'+tempList.length);
                if(tempList.length<=0){
                    component.set("v.FilesTable", false);
                }
            });
            $A.enqueueAction(action);
        },
        allowShowAttachments : function (component, event) {
            component.set("v.showAttachmentSetting", event.getSource().get("v.checked"));
        },
        checkValidity : function(component, event, helper) {
            var inputCmp = event.target;
            inputCmp.setCustomValidity(""); //reset error
            var value = inputCmp.value;
            var lowerRange =  new Date().toISOString().split('T')[0]; 
            //var lowerRange = new Date(new Date().setDate(new Date().getDate() + 7)).toISOString().split('T')[0];
            // var higherRange =  new Date("2017/09/22"); 
            if(Date.parse(value)){
                if (Date.parse(value) < Date.parse(lowerRange)) {
                    inputCmp.setCustomValidity("Selected date should be greater than or equal to today");
                }
                //else if (Date.parse(value) > higherRange){
                //inputCmp.setCustomValidity("Select correct date range2"); 
                //}
            }else{
                inputCmp.setCustomValidity("Invalid value");
            }
            
            inputCmp.reportValidity();
        },
        
        addRow : function(component, event, helper) {
            var rows = component.get("v.rows");
            rows.push({ fieldName: '', fieldValue: '' });
            component.set("v.rows", rows);
        },   
        deleteRow : function(component, event, helper) {
            var auraId = event.getSource().getLocalId();
            var index = parseInt(auraId.split('-')[1], 10);
            var rows = component.get("v.rows");
            rows.splice(index, 1);
            component.set("v.rows", rows);
        },
        handleRowsFromChild: function(component, event, helper) {
            // Get the updated rows data from the event
            var updatedRows = event.getParam("rowsData");
            
            // Set the updated rows in the parent component's attribute
            component.set("v.childRows", updatedRows);
        },
        handleInsertedIds : function(component, event, helper) {
            var insertedIds = event.getParam("insertedIds");
            console.log("Received Inserted IDs in Parent: " + JSON.stringify(insertedIds))
            component.set("v.insertedIds", insertedIds);
        },
        
        
        handleCheckboxChange: function(component, event, helper) {
            let isChecked = event.getSource().get("v.checked");
            component.set("v.isChecked", isChecked);
            let contacts = component.get("v.ListOfContact");
            console.log('List of contacts:', JSON.stringify(contacts));
            if (isChecked && contacts.length > 1) { 
                let firstTextValue = contacts[0].textValue;
                contacts.forEach((contact) => {
                    contact.textValue = firstTextValue;
                    
                });
                    component.set("v.ListOfContact", contacts);
                }
                },
                    
                    handleChange :function(component, event, helper) {
                        let contacts = component.get("v.ListOfContact");
                        let index = event.currentTarget.getAttribute("data-index");
                        if (index !== null) {
                            contacts[index].textValue = event.target.value;
                            component.set("v.ListOfContact", contacts);
                        }
                    },
                    
                    handleNotifyChange : function(component, event, helper){
                        let notifyDate = event.getParam("value");
                        component.set("v.notificationDate",notifyDate);
                    },
                    
                    toggleDropdown: function(component, event, helper) {
                        event.stopPropagation(); // Prevents event from bubbling up
                        let isDropdownVisible = component.get("v.isDropdownVisible");
                        component.set("v.isDropdownVisible", !isDropdownVisible);
                    },
                    
                    selectNumber: function(component, event, helper) {
                        let selectedNumber = event.currentTarget.dataset.id;
                        let selectedNumbers = component.get("v.selectedNumbers");
                        
                        if (!selectedNumbers.includes(selectedNumber)) {
                            selectedNumbers.push(selectedNumber);
                        }
                        
                        component.set("v.selectedNumbers", selectedNumbers);
                        component.set("v.isDropdownVisible", false); // Close dropdown after selection
                    },
                    
                    removeNumber: function(component, event, helper) {
                        let numberToRemove = event.currentTarget.dataset.id;
                        let selectedNumbers = component.get("v.selectedNumbers").filter(num => num !== numberToRemove);
                        component.set("v.selectedNumbers", selectedNumbers);
                    },
                    
                    handlePause: function(component, event, helper) {
                        alert("Paused!");
                    },
                    
                    handleFinish: function(component, event, helper) {
                       // alert("Finished with: " + JSON.stringify(component.get("v.selectedNumbers")));
                        
                    },
                    toggleEditPicklist: function(component, event, helper) {
                        let isDisabled = component.get("v.isPicklistDisabled");
                        component.set("v.isPicklistDisabled", !isDisabled);
                    },
                    handleRadioChange: function(component, event, helper) {
                        var selectedValue = event.getSource().get("v.value");
                        component.set("v.selectedOption", selectedValue);
                    },
                    /*   handlePostActionsCheckboxChange: function (component, event, helper) {
                         try {
                        debugger;
                        let contacts = component.get("v.ListOfContact");
                        let index = event.getSource().get("v.name"); 
                        let selectedContact = contacts[index]; 
                        let childRows = component.get("v.childRows") || [];
                        console.log(JSON.stringify(childRows));
                        if (index != null && index != undefined) {
                            const isChecked = event.getSource().get("v.checked");
                            contacts[index].ispostChecked = isChecked
                            component.set("v.ListOfContact", contacts);
                        }
                        
                        if (event.getSource().get("v.checked")) {
                            
                            childRows.push(selectedContact);
                           console.log("Contact added to childRows:", childRows);
                        } else {
                            
                            childRows = childRows.filter(row => row.Id !== selectedContact.Id);
                           console.log("Contact removed from childRows:", childRows);
                        }
                        
                        component.set("v.childRows", childRows);
                       console.log("Updated childRows:", childRows);
                        } catch (error) {
                            console.error("Error in handlePostActionsCheckboxChange:", error);
                        }
                    }*/
                    handlePostActionsCheckboxChange: function (component, event, helper) {
                        debugger
                        let index = event.getSource().get("v.name");
                        let listOfContacts = component.get("v.ListOfContact");
                        let childRows = component.get("v.childRows");
                        
                        if (index != null && index != undefined) { 
                            let isChecked = event.getSource().get("v.checked");
                            
                            if (!listOfContacts[index].childRows) {
                                listOfContacts[index].childRows = JSON.parse(JSON.stringify(childRows));
                                
                            }
                            console.log("Updated Record:", JSON.stringify(listOfContacts[index]));
                            listOfContacts[index].ispostChecked = isChecked;
                            component.set("v.ListOfContact", listOfContacts);
                        }
                    },
                    
                    handleUncheck: function(component, event, helper) {
                        var isChecked = event.getParam("isChecked");
                       // alert('isChecked>>>>>>>>>'+isChecked)
                        let listOfContacts = component.get("v.ListOfContact");
                        let isCheckedbox = event.getSource().get("v.checked");
                        
                        console.log('handleUncheck>>>1111>>>>>>>>>>>'+ JSON.stringify(listOfContacts))
                        if (isChecked === false || isChecked === undefined) {
                            listOfContacts[0].ispostChecked = false;
                            isCheckedbox = false
                            component.set("v.listOfContacts", listOfContacts);
                            console.log('handleUncheck>>>>>>>>>>>>>>'+ JSON.stringify(listOfContacts))
                        }
                    },
                    handleChangeReminder: function(component, event, helper) {
                        let selectedValue = event.getParam("value");
                        if(selectedValue === 'monthly'){
                            component.set("v.selectedValueMonthly", true);
                            component.set("v.selectedValueWeekly", false);
                            component.set("v.selectedValueDaily", false);
                        }else if(selectedValue === 'weekly'){
                            component.set("v.selectedValueWeekly", true);
                            component.set("v.selectedValueMonthly", false);
                            component.set("v.selectedValueDaily", false);
                        }else if(selectedValue === 'None'){
                            component.set("v.selectedValueNone", true);
                            component.set("v.selectedValueDaily",false);
                            component.set("v.selectedValueMonthly", false);
                            component.set("v.selectedValueWeekly", false);
                        }else if(selectedValue === 'Daily'){
                            component.set("v.selectedValueDaily", true);
                            component.set("v.selectedValueMonthly", false);
                            component.set("v.selectedValueWeekly", false);
                        }
                        component.set("v.selectedReminderValue", selectedValue);
                    },
                    handleOptionChangeReminder: function(component, event, helper) {
                        component.set("v.selectedOption", event.getSource().get("v.value"));
                    },
                    handleRecurrenceChange: function(component, event) {
                        var selectedValue = event.getSource().get("v.value");
                        component.set("v.recurrenceType", selectedValue);
                    },
                    
                    handleDayIntervalChange: function(component, event) {
                        var value = event.getSource().get("v.value");
                        component.set("v.dayInterval", value);
                    },
                    
                    /*handleRecurrenceWeekdayChange: function(component, event, helper) {
                         let index = event.getSource().get("v.name");
                        let isChecked = event.getSource().get("v.checked"); 
                        alert(isChecked)
                    let contacts = component.get("v.ListOfContact");
                         alert(JSON.stringify(contacts));
                        console.log(JSON.stringify(contacts))
                    contacts[index].selectedWeekdays = isChecked
            
                    component.set("v.ListOfContact", contacts);
    
                    },*/
                    
                    handleRecurrenceWeekdayChange: function(component, event, helper) {
                        
                        let index = parseInt(event.getSource().get("v.name"), 10);
                        let isChecked = event.getSource().get("v.checked"); 
                        let contacts = component.get("v.ListOfContact");
                        
                        if (contacts && contacts.length > index) {
                            contacts[index].selectedWeekdays = isChecked;
                            if (!isChecked) {
                                contacts[index].dailyTemplateId = '';
                            }
                            
                            component.set("v.ListOfContact", contacts);
                        } else {
                            console.error("Invalid index or ListOfContact is undefined.");
                            
                            console.log("index:", index);
                            console.log("contacts:", contacts);
                        }
                    },
                    
                    
                    handleRecurrenceEveryDayChange: function(component, event, helper) {
                        let isChecked = component.get("v.selectedEveryday");
                        component.set("v.selectedEveryday", !isChecked);
                        console.log("Every Day selected:", component.get("v.selectedEveryday"));
                    },
                    
                    
                    /* handleRecurrenceBeforeDayChange: function(component, event, helper) {
                        let isChecked = component.get("v.selectedBeforeDay");
                        component.set("v.selectedBeforeDay", !isChecked);
                        console.log("Before Day selected:", component.get("v.selectedBeforeDay"));
                    },*/
                    handleRecurrenceBeforeDayChange: function(component, event, helper) {
                        let index = event.getSource().get("v.value");
                        let contacts = component.get("v.ListOfContact");
                        let rec = contacts[index];
                        
                        rec.selectedBeforeDays = event.getSource().get("v.checked");
                        
                        if (!rec.selectedBeforeDays) {
                            rec.selectedDays = [];
                            rec.customTemplateId = "";
                            rec.customDay = "";
                            let inputCmp = component.find("customDayInput_" + index);
                            if (inputCmp) {
                                inputCmp.setCustomValidity(""); // Clear the error
                                inputCmp.reportValidity();      // Hide the red error message
                            }
                            
                        }
                        
                        component.set("v.ListOfContact", contacts);
                    },
                    
                    handleRecurrenceRecurringDaysChange: function(component, event, helper) {
                        let index = event.getSource().get("v.value");
                        let contacts = component.get("v.ListOfContact");
                        let rec = contacts[index];
                        
                        rec.selectedRecurringDay = event.getSource().get("v.checked");
                        
                        if (!rec.selectedRecurringDay) {
                            rec.selectedRecurringDays = [];
                            rec.customTemplateId = "";
                            rec.customRecurringDay = "";
                        }
                        
                        component.set("v.ListOfContact", contacts);
                    },
                    
                    
                    handleCheckboxChangeReminde : function(component, event, helper) {
                        let weekdayOptions = component.get("v.weekdayOptions"); // Get the list of weekday options
                        let index = event.getSource().get("v.label"); // Get the index of the changed checkbox
                        let isChecked = event.getSource().get("v.checked"); // Get the checked status
                        
                        if (index !== undefined && weekdayOptions[index]) {
                            weekdayOptions[index].checked = event.getSource().get("v.checked"); // Update the checked status
                            component.set("v.weekdayOptions", weekdayOptions); // Set the updated list back to the attribute
                        }
                    },

                    handleImmediateRows: function(component, event, helper) {
                    var data = event.getParam("rowsData");
                    console.log('Received Immediate Action Rows:', JSON.stringify(data));
                    component.set("v.immediateActionRows", data);
                },
                    
                    handleAddDay : function(component, event, helper) { 
                        var index = event.getSource().get("v.value");
                        var recs = component.get("v.ListOfContact");
                        var rec = recs[index];
                        
                        // Calculate expirationDays from ExpirationDate
                        var today = new Date();
                        var expirationDate = new Date(rec.ExpirationDate);
                        
                        
                        // Clear time part to avoid partial day discrepancies
                        today.setHours(0, 0, 0, 0);
                        expirationDate.setHours(0, 0, 0, 0);
                        
                        var expirationDays = Math.floor((expirationDate - today) / (1000 * 60 * 60 * 24));
                        
                        var customDay = rec.customDay;
                        
                        var inputs = component.find("customDayInput");
                        var inputCmp = Array.isArray(inputs) ? inputs[index] : inputs;
                        
                        if (!customDay || customDay <= 0 || customDay > expirationDays) {
                            if (inputCmp) {
                                inputCmp.setCustomValidity("Please enter a number between 1 and " + expirationDays);
                                inputCmp.reportValidity();
                            }
                            return;
                        } else if (inputCmp) {
                            inputCmp.setCustomValidity(""); // clear error
                            inputCmp.reportValidity();
                        }
                        
                        
                        
                        
                        if (!rec.selectedDays) {
                            rec.selectedDays = [];
                        }
                        
                        if (rec.selectedDays.includes(customDay)) {
                            //alert("This day is already added.");
                            if (inputCmp) {
                                inputCmp.setCustomValidity("This day is already added.");
                                inputCmp.reportValidity();
                            }
                            return;
                        }
                        
                        rec.selectedDays.push(customDay);
                        rec.selectedDays.sort(function(a, b) { return a - b; });
                        
                        rec.customDay = null;
                        
                        component.set("v.ListOfContact", recs);
                    },
                    
                    
                    
                    handleRecurringAddDays : function(component, event, helper) { 
                        
                        var index = event.getSource().get("v.value");
                        var recs = component.get("v.ListOfContact");
                        var rec = recs[index];
                        
                        // Calculate expirationDays from ExpirationDate
                        var today = new Date();
                        var expirationDate = new Date(rec.ExpirationDate);
                        
                        
                        // Clear time part to avoid partial day discrepancies
                        today.setHours(0, 0, 0, 0);
                        expirationDate.setHours(0, 0, 0, 0);
                        
                        var expirationDays = Math.floor((expirationDate - today) / (1000 * 60 * 60 * 24));
                        
                        var customRecurringDay = rec.customRecurringDay;
                        
                        
                        var inputs = component.find("RecurringDayInput");
                        var inputCmp = Array.isArray(inputs) ? inputs[index] : inputs;
                        
                        if (!customRecurringDay || customRecurringDay <= 0 || customRecurringDay > expirationDays) {
                            if (inputCmp) {
                                inputCmp.setCustomValidity("Please enter a number between 1 and " + expirationDays);
                                inputCmp.reportValidity();
                            }
                            return;
                        } else if (inputCmp) {
                            inputCmp.setCustomValidity(""); // clear error
                            inputCmp.reportValidity();
                        }
                        
                        if (!rec.selectedRecurringDays) {
                            rec.selectedRecurringDays = [];
                        }
                        
                        if (rec.selectedRecurringDays.includes(customRecurringDay)) {
                            alert("This day is already added.");
                            return;
                        }
                        
                        rec.selectedRecurringDays.push(customRecurringDay);
                        rec.selectedRecurringDays.sort(function(a, b) { return a - b; });
                        
                        rec.customRecurringDay = null;
                        
                        component.set("v.ListOfContact", recs);
                    },
                    
                    
                    
                    removeDay : function(component, event, helper) {
                        var dayToRemove = parseInt(event.getSource().get("v.value"), 10);
                        var index = event.getSource().get("v.name");
                        
                        var contacts = component.get("v.ListOfContact");
                        var contact = contacts[index];
                        
                        if (contact.selectedDays) {
                            contact.selectedDays = contact.selectedDays.filter(function(day) {
                                return parseInt(day, 10) !== dayToRemove;
                            });
                        }
                        
                        component.set("v.ListOfContact", contacts);
                    },
                    removeRecurringDays : function(component, event, helper) {
                        var dayToRemove = parseInt(event.getSource().get("v.value"), 10);
                        var index = event.getSource().get("v.name");
                        
                        var contacts = component.get("v.ListOfContact");
                        var contact = contacts[index];
                        
                        if (contact.selectedRecurringDays) {
                            contact.selectedRecurringDays = contact.selectedRecurringDays.filter(function(day) {
                                return parseInt(day, 10) !== dayToRemove;
                            });
                        }
                        
                        component.set("v.ListOfContact", contacts);
                    },
                    
                    
                    handleTemplateChange: function(component, event, helper) {
                        try {
                            var selectedTemplateId = event.getParam("value");
                            var index = parseInt(event.getSource().get("v.name"), 10);
                            var type = event.getSource().get("v.dataset").type;
                            
                            console.log("Selected ID:", selectedTemplateId);
                            console.log("Index:", index);
                            console.log("Type:", type);
                            
                            var contacts = component.get("v.ListOfContact");
                            
                            if (Array.isArray(contacts) && contacts[index]) {
                                if (type === "daily") {
                                    contacts[index].dailyTemplateId = selectedTemplateId;
                                } else if (type === "custom") {
                                    contacts[index].customTemplateId = selectedTemplateId;
                                }
                                component.set("v.ListOfContact", contacts);
                            } else {
                                console.warn("Invalid index or contact list.");
                            }
                            
                        } catch (e) {
                            console.error("Error in handleTemplateChange:", e.message);
                        }
                    },
                    
                    
                    handleExpirationDateChange: function(component, event, helper) {
                        let index = event.target.dataset.index;
                        let value = event.target.value;
                        
                        let contacts = component.get("v.ListOfContact");
                        
                        if (contacts && contacts.length > index) {
                            contacts[index].ExpirationDate = value;
                            contacts[index].selectedDays = [];
                            contacts[index].selectedRecurringDays = [];
                            contacts[index].selectedWeekdays= false;
                            contacts[index].selectedBeforeDays = false;
                            contacts[index].selectedRecurringDay = false;
                            
                            
                            component.set("v.ListOfContact", contacts);
                        }
                    },
                    
                    signOptionChange: function(component, event, helper) {
                        // This will contain the string of the "value" attribute of the selected option
                        var selectedOptionValue = event.getParam("value");
                        component.set("v.selectedSignOption", selectedOptionValue);
                    },
                    
                    handleselectedDocument: function(component, event, helper) {
                        debugger
                        var message = event.getParam("selectedDocument");
                        console.log('message', JSON.parse(JSON.stringify(message)))
                        component.set("v.AvailableDocTemplateSelectedValue", message.value);
                        component.set("v.selectedSignOption", message.type);
                        
                    },
                    
                    showSendConfirmationDialog: function(component, event, helper) {
                        console.log('showSendConfirmationDialog called'); 
                        component.set("v.showSendConfirmation", true);
                    },
                    
                    
                    handleSendSuccess: function(component, event, helper) {
                        debugger;
                        var immediateActions = component.get("v.immediateActionRows");
                        
                        if (immediateActions && immediateActions.length > 0 && immediateActions[0].fieldName) {
                            var recordId = component.get("v.recordId");
                            var immediateActionsStr = JSON.stringify(immediateActions);
                             console.log('immediateActions >>> ' + immediateActionsStr);
                            //alert('immediateActions >>> ' + immediateActionsStr);
                            var action = component.get("c.performImmediateUpdate");
                            action.setParams({
                                recordId: recordId,
                                actionsToPerform: immediateActionsStr
                            });
                            
                            action.setCallback(this, function(response) {
                                debugger;
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    console.log('Post-send immediate update completed successfully.');
                                } else if (state === "ERROR") {
                                    var errors = response.getError();
                                    var errorMessage = 'Unknown error';
                                    if (errors && errors[0] && errors[0].message) {
                                        errorMessage = errors[0].message;
                                    }
                                    
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Post-Send Action Failed",
                                        "type": "warning",
                                        "message": "The document was sent, but a follow-up action failed: " + errorMessage
                                    });
                                    toastEvent.fire();
                                }
                            });
                            $A.enqueueAction(action);
                        } else {
                            console.log('No immediate actions to perform after send.');
                        }
                    },
                    
                    confirmSend: function(component, event, helper) {
                        try {
                            component.set("v.toggleSpinner", true);
                            component.set("v.showSendConfirmation", false);
                            
                            var junoTemplatePreviewCmp = component.find("junoTemplatePreviewCmp");
                            if (junoTemplatePreviewCmp) {
                                junoTemplatePreviewCmp.handleSendForSignatures(); 
                            } else {
                                console.error("Could not find the preview component to initiate send.");
                                component.set("v.toggleSpinner", false);
                            }
                        } catch (error) {
                            console.error('Error in confirmSend:', error);
                            component.set("v.toggleSpinner", false);
                            component.set("v.isError", true);
                            component.set("v.isErrorMessage", "Error processing send action: " + error.message);
                        }
                    },
                    
                    closeSendConfirmation: function(component, event, helper) {
                        console.log('closeSendConfirmation called'); 
                        component.set("v.showSendConfirmation", false);
                    },
                    
                })
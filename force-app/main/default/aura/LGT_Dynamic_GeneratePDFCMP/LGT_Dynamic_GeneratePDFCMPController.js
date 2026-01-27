({
    doInit : function(component, event, helper){
        component.set("v.Spinner",true);        
        helper.getEnableEmailTemplate(component,event,helper);
        component.set("v.urillink",window.location.href);
        var locations = window.location.href;
        var pageRef = component.get("v.pageReference");
      //  console.log('pageRef--->'+JSON.stringify(pageRef));
        var recordId = '';
        
        var formFactor = $A.get("$Browser.formFactor");
        var isS1 = $A.get("$Browser.isS1");
        if (isS1 || formFactor === "PHONE") {
            console.log("Mobile App");
            component.set("v.isMobile", true);
        } else {
            console.log("Desktop Browser");
            component.set("v.isMobile", false);
        }
        
        window.addEventListener("message", function(event) {
            // Process the received data
            var receivedData = JSON.parse(event.data);
           // alert(JSON.stringify('receivedData==>'))
            console.log("Received data from Visualforce:", receivedData);
            component.set("v.baseString",receivedData.message);
        }, false);
        if(pageRef!==undefined && pageRef!==null && pageRef.state!=null)
        {
            recordId = pageRef.state.c__recordId;
            console.log('pageRef.state.c__recordId--->'+pageRef.state.c__recordId);
            component.set("v.recordId", pageRef.state.c__recordId);
            var AvailableDocTemplates = pageRef.state.c__AvailableDocList;
            console.log('pageRef.state.c__AvailableDocList--->'+pageRef.state.c__AvailableDocList);
            var DefaultTempID = pageRef.state.c__DefaultTempID;
            
            
            
            if(AvailableDocTemplates != '' && AvailableDocTemplates != null && AvailableDocTemplates != undefined){
                var action2 = component.get("c.getAvailDocTemps");
                action2.setParams({
                    'recordId' : recordId,
                    'DocIds' : AvailableDocTemplates
                }); 
                action2.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var InnerResult = response.getReturnValue();
                        component.set("v.isCancelGenerate", true);
                        component.set("v.DivStyle",'background:white;padding-top:20px;padding-left:8px;padding-right:8px');
                        component.set("v.AvailableDocTemplatesList",InnerResult.AvailableDocTemplatesList); 
                        component.set("v.ObjectAPIName",InnerResult.ObjectAPIName); 
                        component.set("v.OrgwideEmailAddressList",InnerResult.OrgwideEmailAddressList); 
                        component.set("v.JunodocUrl",InnerResult.JunodocUrl); 
                        component.set("v.EnableJuno",InnerResult.EnableJuno);  
                        setTimeout(function(){ 
                            if(DefaultTempID != undefined && 
                               DefaultTempID != null && DefaultTempID != '' && AvailableDocTemplates.includes(DefaultTempID)){
                                component.set("v.AvailableDocTemplateSelectedValue",DefaultTempID);
                                component.set("v.DocTemplateId",DefaultTempID);
                                component.set("v.isDocTemplate",true);
                                var DocTemplateId = component.get("v.DocTemplateId");
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
                                var action22 = component.get("c.getPostActList");
                                action22.setParams({
                                    docId : DocTemplateId,
                                    rid : recordId
                                });
                                action22.setCallback(this, function (response) {
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
                                                                message: 'PostActions Update Failed! ' + result,
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
                                        
                                      
                                    }
                                });
                                $A.enqueueAction(action22);
                            }
                        }
                                   , 2000);
                    }
                });
                $A.enqueueAction(action2);
            }
            else{
                var action = component.get("c.getAvailableDocTemplates"); 
                action.setParams({
                    'recordId' : recordId
                }); 
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var InnerResult = response.getReturnValue();
                        component.set("v.isCancelGenerate", true);
                        component.set("v.DivStyle",'background:white;padding-top:20px;padding-left:8px;padding-right:8px');
                        component.set("v.AvailableDocTemplatesList",InnerResult.AvailableDocTemplatesList);
                        console.log(InnerResult.AvailableDocTemplatesList);
                        console.log('222222222222222222222'+InnerResult.isVFpage);
                       console.log('11111111111111111111'+InnerResult.VFpageName);
                        component.set("v.isVFPage",InnerResult.isVFpage);
                        component.set("v.VFpageName",InnerResult.VFpageName);
                        component.set("v.DocTemplateId",InnerResult.DocTemplateId);
                        component.set("v.ObjectAPIName",InnerResult.ObjectAPIName); 
                        component.set("v.OrgwideEmailAddressList",InnerResult.OrgwideEmailAddressList); 
                        component.set("v.JunodocUrl",InnerResult.JunodocUrl); 
                        component.set("v.EnableJuno",InnerResult.EnableJuno);
                        console.log("@@@"+InnerResult.JunodocUrl);
                        if(InnerResult.isUpload == true){
                            component.set("v.isFile",true);
                            component.set("v.FileId",InnerResult.FileId);
                            component.set("v.recType",InnerResult.recType);
                        }
                        
                        setTimeout(function(){ 
                            if(DefaultTempID != undefined && 
                               DefaultTempID != null && DefaultTempID != ''){
                                component.set("v.AvailableDocTemplateSelectedValue",DefaultTempID);
                                component.set("v.DocTemplateId",DefaultTempID);
                                component.set("v.isDocTemplate",true);
                                var DocTemplateId = component.get("v.DocTemplateId");
                                
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
                                        //if(result.UpdateType == 'PDF Generate'){
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
                                                                message: 'PostActions Update Failed! ' + result,
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
                                    }
                                });
                                $A.enqueueAction(action2);
                                
                                
                            }
                        }
                                   , 2000);
                        
                        
                        
                    }
                });
                $A.enqueueAction(action);
                
            }
            //Do whatever we want to do with record id 
        }
        else{
            recordId = component.get("v.recordId");
            var action = component.get("c.getAvailableDocTemplates"); 
            action.setParams({
                'recordId' : recordId
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state **********  '+state);
                if(state === "SUCCESS"){
                    
                    var InnerResult = response.getReturnValue();
                  //  console.log('doc **********  '+JSON.stringify(InnerResult.AvailableDocTemplatesList));
                    component.set("v.AvailableDocTemplatesList",InnerResult.AvailableDocTemplatesList);
                    component.set("v.DocTemplateId",InnerResult.DocTemplateId);
                    component.set("v.ObjectAPIName",InnerResult.ObjectAPIName); 
                    component.set("v.OrgwideEmailAddressList",InnerResult.OrgwideEmailAddressList); 
                    component.set("v.JunodocUrl",InnerResult.JunodocUrl);  
                    component.set("v.EnableJuno",InnerResult.EnableJuno);  
                    
                    if(InnerResult.DocTemplateId != undefined && 
                       InnerResult.DocTemplateId != null &&
                       InnerResult.DocTemplateId != ''){
                        setTimeout(function(){ 
                            
                            component.set("v.AvailableDocTemplateSelectedValue",InnerResult.DocTemplateId);
                            component.set("v.isDocTemplate",true);
                            var DocTemplateId = component.get("v.AvailableDocTemplateSelectedValue");
                            
                            var action2 = component.get("c.getPostActList");
                            action2.setParams({
                                docId : DocTemplateId,
                                rid : recordId
                            });
                            action2.setCallback(this, function (response) {
                                if (response.getState() == "SUCCESS") {
                                    var result = response.getReturnValue();
                                    //alert('result---->'+JSON.stringify(result));
                                    component.set("v.PostActList", result);
                                    var resultUpdate;
                                    var UpdatedPostActs = [];
                                    for (var i=0;i<result.length;i++){
                                        //alert(result[i].UpdateType);
                                        if(result[i].GenerateCheck == 'true'){
                                            resultUpdate = result[i].GenerateCheck;
                                            UpdatedPostActs.push(
                                                result[i]
                                            );
                                        }
                                    }
                                    //alert('UpdatedPostActs--->'+UpdatedPostActs);
                                    //if(result.UpdateType == 'PDF Generate'){
                                    if(UpdatedPostActs.length>0){
                                        var recordId = component.get("v.recordId");
                                        var PostActList = JSON.stringify(UpdatedPostActs);
                                        //alert('PostActList---->'+PostActList);
                                        var action33 = component.get("c.UpdateRecs");
                                        action33.setParams({
                                            PostActs : PostActList,
                                            rid : recordId
                                        });
                                        action33.setCallback(this, function (response) {
                                            //alert('State---->'+response.getState());
                                            if (response.getState() == "SUCCESS") {
                                                var result = response.getReturnValue();
                                                //alert('result---->'+result);
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
                                                            message: 'PostActions Update Failed! ' + result,
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
                                }
                            });
                            $A.enqueueAction(action2);
                            
                            
                            
                        }
                                   , 2000);
                        
                    }
                    else{
                        helper.recordDetails(component,event,helper)
                    }
                    
                }
            });
            $A.enqueueAction(action);
            
        }
        /* Added by Sainath on 09-Sep-2025 Start */
        helper.hideSettings(component,event,helper)
        /* Added by Sainath on 09-Sep-2025 End */
        
        var actions = component.get("c.getAvailableEmails"); 
        actions.setParams({
            'recordId' : recordId
        }); 
        actions.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.DocTemplatesWraplist",InnerResult);               
            }
            setTimeout(()=>{
                component.set("v.Spinner",false);
            },3000) 
            });
                $A.enqueueAction(actions); 
            },
                CancelGenerate: function(component,event,helper){
                    var pageRef = component.get("v.pageReference");
                    if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == true){
                        var recId = component.get("v.recordId");
                    	window.open('/'+recId , "_self");
                    }
                    else if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == false){
                        var recId = component.get("v.recordId");
                        helper.redirectToRecord(component,event,helper,recId);
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                    }
                    
                },
                AvailableDocTemplateOnchangeHandler :  function(component,event,helper){
                    debugger;
                    var DocTemplateId = event.getSource().get("v.value");
                    var recordId = component.get("v.recordId");
                    var action = component.get("c.getPostActList");
                    action.setParams({
                        docId : DocTemplateId,
                        rid : recordId
                    });
                    action.setCallback(this, function (response) {
                        if (response.getState() == "SUCCESS") {
                            var result = response.getReturnValue();
                            if(DocTemplateId!=''){  
                                //Code Start Here
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
                                        
                                         if(DocList[i].isUpload == true){
                                            component.set("v.isFile",true);
                                            component.set("v.FileId",DocList[i].FileId);
                                            component.set("v.recType",DocList[i].recType);
                                        }
                                        else{
                                            component.set("v.isFile",false);
                                            component.set("v.FileId",'');
                                        }
                                    }
                                    else if(DocList[i].value == DocTemplateId && DocList[i].reportType != ''){
                                        component.set("v.showCanvas",true);
                                    }
                                    
                                    
                                }
                                // Code End Here
                                component.set("v.DocTemplateId",DocTemplateId);
                                component.set("v.AvailableDocTemplateSelectedValue",DocTemplateId);
                                if(component.get("v.VFPage") == false && component.get("v.isDocWordTemplate")){
                                    setTimeout(function(){ 
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            title : 'info',
                                            message: 'Please wait...Word is generating.',
                                            duration:'2000',
                                            key: 'info_alt',
                                            type: 'info',
                                            mode: 'dismissible'
                                        });
                                        toastEvent.fire();
                                    }
                                               , 500);
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
                                    //if(result.UpdateType == 'PDF Generate'){
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
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            message: 'PostActions Updated Successfully!',
                                                            type: 'Success',
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                }
                                                else{
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
                                                        message: 'PostActions Update Failed! '+ result,
                                                        type: 'error',
                                                    });
                                                    toastEvent.fire();
                                                }
                                            }
                                        });
                                        $A.enqueueAction(action33);
                                    }
                                }
                                if(component.get("v.VFPage") == false && component.get("v.isDocTemplate")){
                                    setTimeout(function(){ 
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
                                               , 500);
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
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            message: 'PostActions Updated Successfully!',
                                                            type: 'Success',
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                }
                                                else{
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
                                                        message: 'PostActions Update Failed! '+ result,
                                                        type: 'error',
                                                    });
                                                    toastEvent.fire();
                                                }
                                            }
                                        });
                                        $A.enqueueAction(action33);
                                    }
                                }
                            }
                            else{
                                component.set('v.DocTemplateId','');
                            }
                        }
                    });
                    $A.enqueueAction(action);
                },
                
                
                handleCreatePDF : function(component, event, helper) {
                    component.set("v.Spinner",true);
                    var recordId = component.get("v.recordId");
                    var DocTemplateId = component.get("v.DocTemplateId");
                    var action = component.get("c.CreatePDFs");
                    action.setParams({
                        'id' : recordId,
                        'DocTemplateId' : DocTemplateId,
                        'fromJunosign':false
                    }); 
                    
                    action.setCallback(this, function(response){
                        
                        var state = response.getState();
                        var result = response.getReturnValue();
                        
                        if(state === "SUCCESS"){
                            var resultList = component.get("v.PostActList");
                            var resultUpdate;
                            var UpdatedPostActs = [];
                            for (var i=0;i<resultList.length;i++){
                                if(resultList[i].AttachCheck == 'true'){
                                    resultUpdate = resultList[i].AttachCheck;
                                    UpdatedPostActs.push(
                                        resultList[i]
                                    );
                                }
                            }
                            if(UpdatedPostActs.length>0){
                                var PostActList = JSON.stringify(UpdatedPostActs);
                                var action2 = component.get("c.UpdateRecs");
                                action2.setParams({
                                    PostActs : PostActList,
                                    rid : recordId
                                });
                                action2.setCallback(this, function (response) {
                                    if (response.getState() == "SUCCESS") {
                                        var res = response.getReturnValue();
                                        if(res == 'SUCCESS'){
                                            if(resultUpdate == 'true'){
                                                if(component.get("v.VFPage") == false){
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
                                                        message: 'PostActions Updated Successfully!',
                                                        type: 'Success',
                                                    });
                                                    toastEvent.fire();
                                                    $A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                                }
                                            }
                                            
                                        }
                                        else{
                                            if(component.get("v.VFPage") == false){
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    message: 'PostActions Update Failed! '+ result,
                                                    type: 'error',
                                                });
                                                toastEvent.fire();
                                            }
                                            // $A.get("e.force:closeQuickAction").fire();
                                            // $A.get('e.force:refreshView').fire();
                                        }
                                    }
                                });
                                $A.enqueueAction(action2);
                            }
                            var pageRef = component.get("v.pageReference");
                            component.set("v.Spinner",false);
                            if(result=='Redirect'){
                                if(component.get("v.VFPage") == false){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title : 'Success',
                                        message: 'PDF file is created to this record. You will be redirected to record page',
                                        duration:' 3000',
                                        key: 'info_alt',
                                        type: 'success',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                }
                                if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == true){
                                    var recId = component.get("v.recordId");
                                    window.open('/'+recId , "_system");
                                }
                                else if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == false){
                                    var recId = component.get("v.recordId");
                                    if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recId);
                                    	$A.get("e.force:closeQuickAction").fire();
                                        $A.get('e.force:refreshView').fire();
                                    }
                                }
                                else{
                                    if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recordId);
                                    	$A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                    }
                                }
                            }                    
                            
                        }
                    });
                    $A.enqueueAction(action);
                    
                    
                    
                    
                },
                
                handleCreateWord : function(component, event, helper) {
                    component.set("v.Spinner",true);
                    var recordId = component.get("v.recordId");
                    var DocTemplateId = component.get("v.DocTemplateId");
                    var action = component.get("c.CreateWords");   
                    action.setParams({
                        'id' : recordId,
                        'baseString' : component.get("v.baseString"),
                        'fromJunosign':false
                    }); 
                    
                    action.setCallback(this, function(response){
                        
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            var result = response.getReturnValue();
                            
                            if(result=='Redirect'){
                                if(component.get("v.VFPage") == false){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title : 'Success',
                                        message: 'Word file is created to this record. You will be redirected to record page',
                                        duration:' 3000',
                                        key: 'info_alt',
                                        type: 'success',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                    
                                }
                                var resultList = component.get("v.PostActList");
                                var resultUpdate;
                                var UpdatedPostActs = [];
                                for (var i=0;i<resultList.length;i++){
                                    if(resultList[i].AttachCheck == 'true'){
                                        resultUpdate = resultList[i].AttachCheck;
                                        UpdatedPostActs.push(
                                            resultList[i]
                                        );
                                    }
                                }
                                if(UpdatedPostActs.length>0){
                                    var PostActList = JSON.stringify(UpdatedPostActs);
                                    var action2 = component.get("c.UpdateRecs");
                                    action2.setParams({
                                        PostActs : PostActList,
                                        rid : recordId
                                    });
                                    action2.setCallback(this, function (response) {
                                        if (response.getState() == "SUCCESS") {
                                            var res = response.getReturnValue();
                                            if(res == 'SUCCESS'){
                                                if(resultUpdate == 'true'){
                                                    if(component.get("v.VFPage") == false){
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            message: 'PostActions Updated Successfully!',
                                                            type: 'Success',
                                                        });
                                                        toastEvent.fire();
                                                        $A.get("e.force:closeQuickAction").fire();
                                                        $A.get('e.force:refreshView').fire();
                                                    }
                                                }
                                                
                                            }
                                            else{
                                                if(component.get("v.VFPage") == false){
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
                                                        message: 'PostActions Update Failed! '+result,
                                                        type: 'error',
                                                    });
                                                    toastEvent.fire();
                                                }
                                                // $A.get("e.force:closeQuickAction").fire();
                                                // $A.get('e.force:refreshView').fire();
                                            }
                                        }
                                    });
                                    $A.enqueueAction(action2);
                                }
                                var pageRef = component.get("v.pageReference")
                                if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == true){
                                    var recId = component.get("v.recordId");
                                    window.open('/'+recId , "_self");
                                }
                                 else if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == false){
                                    var recId = component.get("v.recordId");
                                     if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recId);
                                     $A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                     }
                                }
                                else{
                                    if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recordId);
                                    $A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                    }
                                }
                                
                                component.set("v.Spinner",false);
                            }                    
                            
                        }
                        else{
                            console.log(response.getError())
                        }
                    });
                    $A.enqueueAction(action);
                    
                    
                    
                    
                },
                /* handleCreateWord : function(component, event, helper) {
        
        component.set('v.isDocWordTemplateAttach',false);
        component.set('v.isDocWordTemplate',true);
        component.set('v.isDocTemplate',false);
        component.set('v.isDocExcelTemplate',false);
    },*/
                handleCreateExcel : function(component, event, helper) {
                    component.set("v.Spinner",true);
                    var recordId = component.get("v.recordId");
                    var DocTemplateId = component.get("v.DocTemplateId");
                    var baseString = component.get("v.baseString")
                    var action = component.get("c.CreateExcels");   
                    action.setParams({
                        'id' : recordId,
                        'DocTemplateId' : DocTemplateId,
                        'fromJunosign':false,
                        'baseString': baseString
                    }); 
                    
                    action.setCallback(this, function(response){
                        
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            var result = response.getReturnValue();
                            
                            if(result=='Redirect'){
                                if(component.get("v.VFPage") == false){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        title : 'Success',
                                        message: 'Excel file is created to this record. You will be redirected to record page',
                                        duration:' 3000',
                                        key: 'info_alt',
                                        type: 'success',
                                        mode: 'pester'
                                    });
                                    toastEvent.fire();
                                    
                                }
                                var resultList = component.get("v.PostActList");
                                var resultUpdate;
                                var UpdatedPostActs = [];
                                for (var i=0;i<resultList.length;i++){
                                    if(resultList[i].AttachCheck == 'true'){
                                        resultUpdate = resultList[i].AttachCheck;
                                        UpdatedPostActs.push(
                                            resultList[i]
                                        );
                                    }
                                }
                                if(UpdatedPostActs.length>0){
                                    var PostActList = JSON.stringify(UpdatedPostActs);
                                    var action2 = component.get("c.UpdateRecs");
                                    action2.setParams({
                                        PostActs : PostActList,
                                        rid : recordId
                                    });
                                    action2.setCallback(this, function (response) {
                                        if (response.getState() == "SUCCESS") {
                                            var res = response.getReturnValue();
                                            if(res == 'SUCCESS'){
                                                if(resultUpdate == 'true'){
                                                    if(component.get("v.VFPage") == false){
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            message: 'PostActions Updated Successfully!',
                                                            type: 'Success',
                                                        });
                                                        toastEvent.fire();
                                                        $A.get("e.force:closeQuickAction").fire();
                                                        $A.get('e.force:refreshView').fire();
                                                    }
                                                }
                                                
                                            }
                                            else{
                                                if(component.get("v.VFPage") == false){
                                                    var toastEvent = $A.get("e.force:showToast");
                                                    toastEvent.setParams({
                                                        message: 'PostActions Update Failed! '+ result,
                                                        type: 'error',
                                                    });
                                                    toastEvent.fire();
                                                }
                                                // $A.get("e.force:closeQuickAction").fire();
                                                // $A.get('e.force:refreshView').fire();
                                            }
                                        }
                                    });
                                    $A.enqueueAction(action2);
                                }
                                var pageRef = component.get("v.pageReference")
                                if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == true){
                                    var recId = component.get("v.recordId");
                                    window.open('/'+recId , "_self");
                                }
                                else  if(pageRef!==undefined && pageRef!==null && pageRef.state!=null && component.get("v.VFPage") == false){
                                    var recId = component.get("v.recordId");
                                    if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recId);
                                    $A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                    }
                                }
                                
                                else{
                                    if(UpdatedPostActs.length == 0){
                                        helper.redirectToRecord(component,event,helper,recordId);
                                    $A.get("e.force:closeQuickAction").fire();
                                                    $A.get('e.force:refreshView').fire();
                                    }
                                }
                                component.set("v.Spinner",false);
                            }                    
                            
                        }
                        else{
                            console.log(response.getError())
                        }
                    });
                    $A.enqueueAction(action);
                    
                    
                },
                openJunosignModel : function(component, event, helper){
                    var recordId = component.get("v.recordId");
                    var DocTemplateId = component.get("v.DocTemplateId");
                    var action = component.get("c.CreatePDFs");
                    action.setParams({
                        'id' : recordId,
                        'DocTemplateId' : DocTemplateId,
                        'fromJunosign': true
                    }); 
                    
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        var result = response.getReturnValue();
                        if(state === "SUCCESS"){
                            var result = response.getReturnValue();
                            component.set("v.Selectedfile",result);
                            component.set("v.isJunosign",true);
                            
                            
                        }
                    });
                    $A.enqueueAction(action);
                    
                },
                closeJunosignModel : function(component, event, helper){
                    component.set("v.isJunosign",false);
                },
                openSendPDFModel : function(component, event, helper){
                    component.set("v.subject",'');
                    component.set("v.emailbody",[]);
                    component.set("v.toUserEmailsList",[]);
                    component.set("v.toContactEmailsList",[]);
                    component.set("v.toEmails",'');
                    component.set("v.StandardEmailTemplateSelectedValue",'');
                    if(component.get("v.AvailableDocTemplateSelectedValue")!=''){
                        component.set("v.isSendPDF",true);
                        helper.openSendPDFModelHelper(component,event,helper);
                        
                    }else{
                        if(component.get("v.VFPage") == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Error',
                                message:'Please Select Available Doc Template',
                                duration:' 5000',
                                key: 'info_alt',
                                type: 'error',
                                mode: 'pester'
                            });
                            toastEvent.fire();  
                        }
                    }
                    
                    
                }
                ,
                
                closeSendPDFModel : function(component, event, helper){
                    component.set("v.isSendPDF",false);
                }
                ,
                
              /*  SaveAsActivityHandler : function(component, event, helper){
                    var checked = event.getSource().get("v.value");
                    if(checked){
                        component.set("v.SaveAsActivity",true);
                    }else{
                        component.set("v.SaveAsActivity",false);    
                    }
                    
                    
                }
                ,*/
                
                SaveAsActivityHandler : function(component, event, helper) {
    let isChecked = document.getElementById("SaveAsActivityCheckbox").checked;
                   
    component.set("v.SaveAsActivity", isChecked);
}
                ,
                SendPDFhandler : function(component, event, helper){
                    var message = component.get("v.accList");
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
                    component.set("v.DisableEmailBody",true);
                    if(helper.validateToAddressHelper(component, event, helper)){             
                        helper.SendPDFHeper(component, event, helper,'Spinner');
                    }
                    
                },
                
                StandardEmailTemplateOnchangeHandler :  function(component,event,helper){
                    
                    //if(helper.validateToAddressHelper(component, event, helper)){             
                    helper.StandardEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                    /*}else{
            component.set("v.StandardEmailTemplateSelectedValue",'');
        } */              
                },
                
                JunoDocEmailTemplateOnchangeHandler :  function(component,event,helper){        
                    helper.JunoDocEmailTemplateOnchangeHandlerHelper(component,event,helper,'Spinner');
                },
                
                
                
                handleNotification :  function(component,event,helper){ 
                    
                    var message = event.getParam("emailList");
                    var fieldDetails = event.getParam("fieldDetails");
                    
                //    console.log('message ------> '+JSON.stringify(message));
                    
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
                    component.set("v.fieldDetails", fieldDetails);
                    
                    
                    
                    
                    component.set("v.ToTextEmailsList",ToTextEmailsList);
                    component.set("v.ToEmailMergeFieldsList",ToEmailMergeFieldsList);
                    
                    component.set("v.CCTextEmailsList",CCTextEmailsList);
                    component.set("v.CCEmailMergeFieldsList",CCEmailMergeFieldsList);
                    
                    component.set("v.BCCTextEmailsList",BCCTextEmailsList);
                    component.set("v.BCCEmailMergeFieldsList",BCCEmailMergeFieldsList);
                    
                    
                } ,
                
                handleFilesChange : function(component, event, helper) {
                    
                    var fileName = "No File Selected..";  
                    var fileCount = event.target.files;
                    var fileList = component.get("v.uploadFileList")
                    for(var i=0;i<event.target.files.length;i++){
                        
                        fileList.push( event.target.files[i])
                    }
                    component.set("v.uploadFileList",fileList)
                    
                    component.set("v.removefiledataList",fileCount);
                    var files='';
                    
                    var names =[];
                    for (var i = 0; i < component.get("v.fileData").length; i++) {
                        names.push(component.get("v.fileData")[i]["fileName"])
                    }
                    for (var i = 0; i < fileCount.length; i++) 
                    {
                        names.push(fileCount[i]["name"])
                    }
                    
                    component.get("v.fileData")
                    component.set("v.FileNameList",names);
                    var filedata = component.get("v.FileLabelList");
                    if (fileCount.length > 0) {
                        component.set("v.uploadFile", true);
                        for (var i = 0; i < fileCount.length; i++) 
                        {
                            fileName = fileCount[i]["name"];
                            if(files == ''){
                                files = fileName;
                            }else{
                                files = files+','+fileName;
                            }
                            helper.readFiles(component, event, helper, fileCount[i]);
                        }
                    }
                    component.set("v.fileName", files);	
                    
                },
                removeRow : function(component, event, helper) {
                    var index = event.target.title;
                    var namelist = component.get("v.FileNameList");
                    namelist.splice(index,1);
                    component.set("v.FileNameList",namelist);
                    var oldFilelist = component.get("v.fileData");
                    oldFilelist.splice(index,1);
                    component.set("v.fileData",oldFilelist);
                  //  console.log(JSON.stringify(component.get("v.fileData")));
                    var fileList =  component.get("v.uploadFileList")
                    fileList.splice(index,1)
                    
                    component.set("v.uploadFileList",fileList)
                    
                    
                },
                
                goToUrl : function(component,event,helper){
                    
                    var action = component.get("c.getOrganizationUrl");
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var result = response.getReturnValue();
                            if(result){
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
                
                handleClick : function(component,event,helper){
                    component.set("v.DisableEmailBody",false)
                },
                
                handleout : function(component,event,helper){
                    component.set("v.DisableEmailBody",true)
                },
                
           
                
            })
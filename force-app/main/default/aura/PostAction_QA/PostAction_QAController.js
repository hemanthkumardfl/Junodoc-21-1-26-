({
    doInit : function(component) {
        var recordId = component.get("v.recordId");
        var action1 = component.get("c.getFields");
        action1.setParams({
            rid : recordId
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS" ){
                var responseValue = response.getReturnValue();
                component.set("v.Fields", responseValue);
            }
        });
        $A.enqueueAction(action1);
        
        
        
       /* var action3 = component.get("c.getUpdateTypes");
        action3.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS" ){
                var responseValue = response.getReturnValue();
                //alert('responseValue'+ response.getReturnValue());
                component.set("v.UpdateList", responseValue);
            }
        });
        $A.enqueueAction(action3);*/
        
        var action2 = component.get("c.getPostActs");
        action2.setParams({
            rid : recordId
        });
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS" ){
                var responseValue = response.getReturnValue();
                 //alert('Inn--->'+JSON.stringify(responseValue));
                component.set("v.docList",responseValue);
                // alert('Inn2--->'+JSON.stringify(component.get("v.PostActRecords")));
                //component.set("v.editData", true);
            }
        });
        $A.enqueueAction(action2);
        
    },
    
    addRow: function(component, event, helper) {
       // var PostRecords = component.get("v.PostActRecords");
        var docList = component.get("v.docList");
        docList.push({
            'SelectedValue': '',
            'value':'',
            'FieldType':'',
            'GenerateCheck':false,
            'AttachCheck':false,
            'MailCheck':false,
            //'SelectedUpdate':'',
            'PickValues':[],
            //'MultiPickValues':[],
            'Fields':component.get("v.Fields")
            //'MultiPickVals':[],
            //'PickVals':[]
            //'UpdateList':component.get("v.UpdateList")
        });
        component.set("v.docList", docList);
        //alert('***Addrow****'+JSON.stringify(component.get("v.docList")));
    },

    valueType: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var docList = JSON.stringify(component.get("v.docList"));
        //alert('docList--->'+docList);
        console.log('docList--->'+docList);
        var action = component.get("c.ChangeDataType");
        action.setParams({
            docList : docList,
            rid : recordId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log(response.getReturnValue());
                var responseValue = JSON.parse(response.getReturnValue());
                /*alert('responseValue---->'+JSON.stringify(responseValue));
                var newdocList = [];
                for(var i = 0;i<responseValue.length;i++){
                    if(responseValue[i].FieldType == 'MULTIPICKLIST'){
                        var MulPics = responseValue[i].MultiPickValues;
                        alert('MulPics--->'+MulPics);
                        for(var z = 0;z<MulPics;z++){
                            var MulStrVals = responseValue[i].MultiPickVals;
                            alert('MulStrVals---->'+MulStrVals);
                            MulStrVals.add(MulPics[z].pickvalue);
                            alert('MulStrVals---->'+MulStrVals);
                        }
                        var Picks = responseValue[i].PickValues;
                        alert('Picks--->'+Picks);
                        for(var x = 0;x<Picks;x++){
                            var StrVals = responseValue[i].PickVals;
                            alert('StrVals---->'+StrVals);
                            StrVals.add(Picks[z].pickvalue);
                            alert('StrVals---->'+StrVals);
                        }
                        newdocList.add(responseValue[i]);
                    }
                    else{
                        newdocList.add(responseValue[i]);
                    }
                }
                alert('newdocList---->'+JSON.stringify(newdocList));*/
                component.set("v.docList",responseValue);
                //alert('dlist--->'+JSON.stringify(component.get("v.docList")));
            }
        });
        $A.enqueueAction(action);
        //alert(JSON.stringify(component.get("v.docList")));
    },
    removeRecord: function(component, event, helper) {
        var docList = component.get("v.docList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var newdoclist = [];
        for(var i=0;i< docList.length;i++){
            if(i != index){
                newdoclist.push(docList[i]);
            }
        }
        component.set("v.docList",newdoclist);
        //alert('Lasts ' + JSON.stringify(component.get("v.docList")));
    },
    
    doSave: function(component, event, helper) {      
        if (helper.validateAccountRecords(component, event)) {
            var docList = JSON.stringify(component.get("v.docList"));
           /* var newdoclist = [];
            for(var i=0;i< docList.length;i++){
                if(docList[i].FieldType == 'MULTIPICKLIST'){
                    alert('docList--->'+docList[i].MultiPickValues);
                    var mulpickvals = docList[i].MultiPickValues;
                    for(var z=0;z< mulpickvals.length;z++){
                        if(z = mulpickvals.length-1){
                            docList[i].value += mulpickvals[z].pickvalue;
                        }
                        else{
                            docList[i].value += mulpickvals[z].pickvalue+';';
                        }
                        
                    }
                }
               newdoclist.push(docList[i]); 
            }*/
            var recordId = component.get("v.recordId");
            var action = component.get("c.savePostactList");
            action.setParams({
                docList : docList,
                rid : recordId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var responseValue = response.getReturnValue();
                    if(responseValue == "SUCCESS"){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: "Post Action Created Successfully!",
                            type: "success"
                        });
                        toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                       
                    }
                    else if(responseValue == "ERROR1"){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: "Please Select Field!",
                            type: "warning"
                        });
                        toastEvent.fire();
                    }
                        else if(responseValue == "ERROR2"){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                message: "Please Insert Field Value!",
                                type: "warning"
                            });
                            toastEvent.fire();
                        }
                            else if(responseValue == "ERROR3"){
                                var toastEvent1 = $A.get("e.force:showToast");
                                toastEvent1.setParams({
                                    message: "Please Insert Field Value!",
                                    type: "warning"
                                });
                                toastEvent1.fire();
                                var toastEvent2 = $A.get("e.force:showToast");
                                toastEvent2.setParams({
                                    message: "Please Select Field!",
                                    type: "warning"
                                });
                                toastEvent2.fire();
                            }
                                else if(responseValue == "ERROR4"){
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        message: "Please Don't Insert Duplicate Field!",
                                        type: "warning"
                                    });
                                    toastEvent.fire();
                                }
                                    else if(responseValue == "ERROR5"){
                                        var toastEvent = $A.get("e.force:showToast");
                                        toastEvent.setParams({
                                            message: "Please Add Row to create Post Action!",
                                            type: "warning"
                                        });
                                        toastEvent.fire();
                                    }
                                        else if(responseValue == "ERROR6"){
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                message: "Previous Post Actions are deleted!",
                                                type: "Success"
                                            });
                                            toastEvent.fire();
                                            $A.get("e.force:closeQuickAction").fire();
                                            $A.get('e.force:refreshView').fire();
                                        }
                }
            });
            $A.enqueueAction(action);
        }
    },
    doCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
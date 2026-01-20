({
    doInit:function(component, event, helper) {
        helper.addAccountRecord(component, event);
        var action = component.get("c.getFileDeatils");
        action.setParams({
            "recordId" :component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            //alert(JSON.stringify(result));
            component.set("v.FileList",result);
            component.set("v.Selectedfile",component.get("v.Selectedfiles"));
            
        });
        $A.enqueueAction(action);
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
    addRow: function(component, event, helper) {
        component.set("v.isEmailObj",false);
        var count;
        helper.addAccountRecord(component, event);
        var results = component.get("v.results");
        //alert(results.length);
        if(results.length >=1){
            component.set("v.removerow",false); 
        }
        var accountList = JSON.stringify(component.get("v.accountList"));
        //var val = document.getElementById("myText").value;
        
    },
    
    removeRow: function(component, event, helper) {
        //Get the account list
        var results = component.get("v.results");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        results.splice(index, 1);
        component.set("v.results", results);
        component.set("v.indexval", 5);
        
        //  alert(accountList.length);
        if(results.length == 1){
            component.set("v.removerow",true); 
        }
        
    },
    
    save: function(component, event, helper) {
        if (helper.validateAccountList(component, event)) {
            helper.saveAccountList(component, event);
        }
    },
    OnDateChange: function(component, event, helper){
        //alert("onchange date"+component.get("v.selectedDate"));
        //alert(JSON.stringify(component.get("v.accountList")));
        //alert("emailsub"+component.get("v.emailsubject"));
        //alert("emailbody"+component.get("v.emailbody"));
        // var selecteddate = component.get("v.selectedDate");
        //var dd = today.getDate();
        ////if(selecteddate==dd){
        
        //}
    },
    OnRecipientChange: function(component, event, helper){
        //alert("onchange Reciepent"+component.get("v.selectedRecipientName"));
    },
    create: function(component, event, helper){
        
        var file = component.get("v.Selectedfile");
        var date = component.get("v.selectedDate");
        var subject = component.get("v.emailsubject");
        var body = component.get("v.emailbody");
        var emaillist = component.get("v.results");
        var process = component.get("v.Selectedprocess");
        
        //alert("emaillist"+JSON.stringify(emaillist));
        console.log("emaillist"+JSON.stringify(emaillist));
        var d0 = new Date();
        //alert(d0);
        var today = d0.getFullYear()+'-'+parseInt(d0.getMonth()+1)+'-'+d0.getDate();
        //alert("today"+today);
        var selecteddate = component.get("v.selectedDate");
        //alert("selecteddate"+selecteddate);
        var d1 = Date.parse(selecteddate);
        var d2 = Date.parse(today);
       // alert("d1"+d1);
       // alert("d2"+d2);
        
        var showerror = false;
        //alert("@@@@@"+emaillist.length);
        //alert("showerror1"+showerror);
        for(var i=0;i<emaillist.length;i++){
            //alert(emaillist[i].Email);
            if(emaillist[i].Email==""){
                showerror=true;
                //   alert("showerror"+showerror);

            }
        }
        if(subject!=null && subject!='' && subject!=undefined 
           && body!=null && body!='' && body!=undefined
           && file!=null && file!='' && file!=undefined
          && showerror==false
          ){
            //alert("enter");
            
            var action = component.get("c.createrecord");
            //alert("2")
            action.setParams({
                "fileid" :file,
                "expdate" : date,
                "emailbody":body,
                "emailsub":subject,
                "recipent" :emaillist,
                "selectedProcess" :process,
                "recordId" :component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if(state === "SUCCESS"){
                    if(component.get("v.isVFpage")){
                        var recid = component.get("v.recordId");
                        
                        window.location.href ='/'+recid;
                    }else{  
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "success",
                            "message": "Saved Successfully"
                        });
                        toastEvent.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.recordId"),
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                    }  
                }
            });
            $A.enqueueAction(action);
            
        }
        else{
             if(selecteddate =="" || selecteddate==undefined || selecteddate==null){
                 if(component.get("v.isVFpage")){
                     component.set("v.isError",true);
                     component.set("v.message","please select date")
                 }else{
                    //alert("date error");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "please select date"
                    });
                    toastEvent.fire();
                 }
            
             }else if(d1 < d2){
                 if(component.get("v.isVFpage")){
                     component.set("v.isError",true);
                     component.set("v.message","Select a valid date")
                 }else{
                    //alert("date error");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "Select a valid date"
                    });
                    toastEvent.fire();
                 }
            
             }else if(file =="" || file==undefined || file==null){
                //alert("file error");
                 if(component.get("v.isVFpage")){
                     component.set("v.isError",true);
                     component.set("v.message","file is required")
                 }else{
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "title": "Error!",
                         "type": "error",
                         "message": "file is required"
                     });
                     toastEvent.fire();
                 }
            }
            else if(subject =="" || subject==undefined || subject==null){
                //alert("subject error");
                if(component.get("v.isVFpage")){
                    component.set("v.isError",true);
                    component.set("v.message","Email Subject is required")
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type": "error",
                        "message": "Email Subject is required"
                    });
                    toastEvent.fire();
                }  
            }
                else if(body =="" || body==undefined || body==null){
                  //  alert("body error");
                    if(component.get("v.isVFpage")){
                        component.set("v.isError",true);
                        component.set("v.message","Email Body is required")
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type": "error",
                            "message": "Email Body is required"
                        });
                        toastEvent.fire();
                    }
                }
                    
        
        else if(showerror=true){
            if(component.get("v.isVFpage")){
                component.set("v.isError",true);
                component.set("v.message","signee is required")
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "signee is required"
                });
                toastEvent.fire();
            }
        }
       
        
        } 
        
    }
    
    ,
    onchangename :function(component, event, helper){
        var accountList = component.get("v.accountList");
        var index = accountList.length-1;
        //alert(accountList.length);
        //alert(JSON.stringify(accountList));
        //alert(accountList[index].Recipient_Name__c);
        //alert(accountList[index].Recipient_Email__c);
        
        if((accountList[index].Recipient_Name__c!=undefined && accountList[index].Recipient_Name__c!=null && accountList[index].Recipient_Name__c!='')
           && (accountList[index].Recipient_Email__c !=undefined && accountList[index].Recipient_Email__c !=null && accountList[index].Recipient_Email__c!='')){
            
            component.set("v.Addrow",false);
        }
        
    }, 
    
    searchHandler : function (component, event, helper) {
        helper.search(component, event, helper);
    },
    
    onselect : function (component, event, helper) {
        var selectedObject = component.get("v.selectedValue");
        var results = component.get("v.results");
        
        for(var i=0;i<results.length;i++){
            //alert(results[i].Selectedvalue);
            //alert(results[i].Email)
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
    
    cancel :function(component, event, helper){
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    }, 
    
    optionClickHandler : function (component, event, helper) {
        const selectedValue = event.target.closest('li').dataset.value;
        const selectedlabel = event.target.closest('li').dataset.name;
        const selectedtitle = event.target.closest('li').dataset.title;
        const selectedId = event.target.closest('li').dataset.Id;
        //alert(selectedValue + selectedtitle + selectedId);
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", true);
        //alert("###$$$$"+component.get("v.inputValue"));
        component.set("v.openDropDown", false);
        //helper.openSendPDFModelHelper(component, event, helper);
        //component.set("v.showButton", true);
        //component.set("v.variable1",true);
        
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
        
    },
        test : function (component, event, helper) {
            //alert(component.get("v.Selectedprocess"));
        },
    searchAll : function (component, event, helper) {
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
     dragstart: function(component, event, helper) {
         //alert("drag started");
        component.set("v.dragid", event.target.dataset.dragId);
    },
    allowdrop: function(component, event, helper){
       event.preventDefault(); 
    },
    drop: function(component, event, helper) {
        //alert("drag ended");
        var dragId = component.get("v.dragid"),
            results = component.get("v.results"),
            temp;
        var a = parseInt(dragId);
        temp = results[dragId];
        results[dragId] = results[event.target.dataset.dragId];
        results[event.target.dataset.dragId] = temp;
        component.set("v.results", results);
        event.preventDefault(); 
    },
    cancel: function(component, event, helper) {
       
        if(component.get("v.isVFpage")){
            var recid = component.get("v.recordId");
            window.location.href ='/'+recid;
        }else{
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
            // elementorProFrontend.modules.popup.closePopup( {}, event );
            //var rec = component.get("v.recordId");
            //window.open('lightning/n/Quote/rec/view');
      } 
    }
   
    
    
    
    
    
})
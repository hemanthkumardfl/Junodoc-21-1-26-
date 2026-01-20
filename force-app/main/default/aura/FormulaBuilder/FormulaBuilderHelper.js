({
	GetFirstLevelFieldDetails : function(component, event, helper, ObjName, FieldDetails) {
		//alert('--GetFirstLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                component.set("v.ShowLevel2",true);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                	component.set('v.FirstLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FirstLevSelectedFieldDetails','{!'+Result + '}'); 
                }
                var myDiv = document.getElementById("myDiv");
                setTimeout(function() {
                    myDiv.scrollLeft = myDiv.scrollWidth;
                }, 100);
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
	},
    
    GetSecLevelFieldDetails : function(component, event, helper, ObjName, FirstField, FieldDetails) {
		//alert('--GetSecondLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetSecLevelFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                component.set("v.ShowLevel3",true);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                	component.set('v.SecondLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.SecondLevSelectedFieldDetails','{!'+Result+ '}');
                }
                var myDiv = document.getElementById("myDiv");
                setTimeout(function() {
                    myDiv.scrollLeft = myDiv.scrollWidth;
                }, 100);
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
	},
    
    GetThirdLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, FieldDetails) {
		//alert('--GetThirdLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetThirdLevelFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : SecondField,
            "ThirdField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('--state--'+state);
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                component.set("v.ShowLevel4",true);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                	component.set('v.ThirdLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.ThirdLevSelectedFieldDetails','{!'+Result+'}');
                }
                var myDiv = document.getElementById("myDiv");
                setTimeout(function() {
                    myDiv.scrollLeft = myDiv.scrollWidth;
                }, 100);
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
	},
    
    GetFinalLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FieldDetails) {
		//alert('--GetThirdLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetFinalLevelFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : SecondField,
            "ThirdField" : ThirdField,
            "FinalField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('--state--'+state);
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                component.set("v.ShowLevel5",true);
                if(component.get("v.parents") != 'yes'){
                        component.set('v.FinalLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FinalLevSelectedFieldDetails','{!'+Result + '}'); 
                }
                
                var myDiv = document.getElementById("myDiv");
                setTimeout(function() {
                    myDiv.scrollLeft = myDiv.scrollWidth;
                }, 100);
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
	},
    
    GetObjectFields : function(component, event, helper) {
        //alert('--clicked--');
        debugger;
        console.log(component.get('v.ObjectAPIName'))
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getinitialObjectFields");
        action.setParams({
            "ObjAPIName" : component.get('v.ObjectAPIName')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',true);
                    component.set('v.InitialObjectFields',Result.WrapperList);
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
        $A.enqueueAction(action);
        
    },
    
    GetFirstLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert('--clicked--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel2',true);
                    component.set('v.ShowLevel3',false);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FirstLevelObjectFields',Result.WrapperList);
                    var myDiv = document.getElementById("myDiv");
                    setTimeout(function() {
                        myDiv.scrollLeft = myDiv.scrollWidth;
                    }, 100);
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
        $A.enqueueAction(action);
        
    },
    
    GetSecLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert('--clicked--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel3',true);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevelObjectFields',Result.WrapperList);
                    var myDiv = document.getElementById("myDiv");
                    setTimeout(function() {
                        myDiv.scrollLeft = myDiv.scrollWidth;
                    }, 100);
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
        $A.enqueueAction(action);
        
    },
    
    GetThirdLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert('--clicked--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel4',true);
                    component.set('v.ShowLevel5',false);
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevelObjectFields',Result.WrapperList);
                    var myDiv = document.getElementById("myDiv");
                    setTimeout(function() {
                        myDiv.scrollLeft = myDiv.scrollWidth;
                    }, 100);
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
        $A.enqueueAction(action);
        
    },
    
    GetFinalLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert('--clicked--');
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel5',true);
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FinalLevSelectedFieldDetails',undefined);
                    
                    component.set('v.FinalLevelObjectFields',Result.WrapperList);
                    var myDiv = document.getElementById("myDiv");
                    setTimeout(function() {
                        myDiv.scrollLeft = myDiv.scrollWidth;
                    }, 100);
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
        $A.enqueueAction(action);
        
    },
    
    GetObjLabel : function(component, event, helper) {
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetLabelName");
        action.setParams({
            "ObjAPIName" : component.get('v.ObjectAPIName')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var LabelName = response.getReturnValue();
                component.set('v.ObjectLabelName',LabelName);
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    copyTextHelper : function(component,event,text) {
        // Create an hidden input
        var hiddenInput = document.createElement("input");
        // passed text into the input
        hiddenInput.setAttribute("value", text);
        // Append the hiddenInput input to the body
        document.body.appendChild(hiddenInput);
        // select the content
        hiddenInput.select();
        // Execute the copy command
        document.execCommand("copy");
        // Remove the input from the body after copy text
        document.body.removeChild(hiddenInput); 
        // store target button label value
        var orignalLabel = event.getSource().get("v.label");
        // change button icon after copy text
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);
        
    }
})
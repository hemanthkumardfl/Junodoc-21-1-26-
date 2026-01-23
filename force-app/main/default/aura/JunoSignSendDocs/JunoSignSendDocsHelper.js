({
    search : function(component, event, helper) {
        debugger;
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        ul = document.getElementById("myUL");
        li = ul.getElementsByTagName("li");
        for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("span")[2];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }
    },
    GetObjectLabelName:function(component,event,helper){
        
        var action = component.get("c.getObjectLabelName");
        var obj = component.get("v.CurrentObject");
        //alert("object"+obj);
        action.setParams({
            "ObjAPIName" : obj
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var result = JSON.stringify(response.getReturnValue());
                // alert(result);
                component.set("v.ObjectLabelName",result);
                this.GetObjectFields(component,event,helper);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    GetObjectFields : function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        // component.set("v.toggleSpinner",true);
        var obj = component.get("v.CurrentObject");
        var action = component.get("c.getinitialObjectFields");
        action.setParams({
            "ObjAPIName" : obj,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                //  alert(Result)
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',true);
                    component.set('v.InitialObjectFields',Result.WrapperList);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    
                    breadcrumb.label= component.get('v.CurrentObjLabelName');
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
        $A.enqueueAction(action);
        
    },
    GetFirstLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        // alert("FieldDetails"+FieldDetails);
        
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getObjectLabelName");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',true);
                    component.set('v.ShowLevel3',false);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 1';
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FirstLevelObjectFields',Result.WrapperList);
                    
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
    GetFirstLevelFieldDetails : function(component, event, helper, ObjName, FieldDetails) {
        
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
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                    component.set('v.FirstLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FirstLevSelectedFieldDetails','{!'+Result + '}'); 
                }
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    GetSecLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert("FieldDetails"+FieldDetails);
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
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set('v.ShowLevel3',true);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 2';
                    
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevelObjectFields',Result.WrapperList);
                    
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
    GetSecLevelFieldDetails : function(component, event, helper, ObjName, FirstField, FieldDetails) {
        //alert("first");
        //alert(ObjName);
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetSecLevelFieldDetailscontroller");
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
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',true);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                    component.set('v.SecondLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.SecondLevSelectedFieldDetails','{!'+Result+ '}');
                }
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    GetThirdLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, FieldDetails) {
        
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
            
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',false);
                component.set("v.ShowLevel3",true);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                
                if(component.get("v.parents") != 'yes'){
                    component.set('v.ThirdLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.ThirdLevSelectedFieldDetails','{!'+Result+'}');
                }
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    
    GetThirdLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getFinalObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set("v.ShowLevel3",false);
                    component.set('v.ShowLevel4',true);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 3';
                    
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevelObjectFields',Result.WrapperList);
                    
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
        
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.getFinalObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set("v.ShowLevel3",false);
                    component.set('v.ShowLevel4',true);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FinalLevSelectedFieldDetails',undefined);
                    
                    component.set('v.FinalLevelObjectFields',Result.WrapperList);
                    
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
    
    GetFinalLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FourthField) {
        
        var toastEvent = $A.get("e.force:showToast");
        component.set("v.toggleSpinner",true);
        var action = component.get("c.GetFinalLevelFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : SecondField,
            "ThirdField" : ThirdField,
            "FinalField" : FourthField
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',false);
                component.set("v.ShowLevel3",false);
                component.set('v.ShowLevel4',true);
                component.set('v.ShowLevel5',false);    
                
                if(component.get("v.parents") != 'yes'){
                    component.set('v.FinalLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FinalLevSelectedFieldDetails','{!'+Result + '}'); 
                }
                
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    getResultEmailvalue : function(component, event, helper) {
        var action = component.get("c.GetEmailFieldValue");
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "FieldName" : fieldName,
            "isparent" : Parenttrue,
            "parentObj" : component.get("v.SelectedparentObject"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
            }else{
                // alert(state);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    search : function(component, event, helper) {
        debugger;
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("mySearchInput");
        filter = input.value.toUpperCase();
        if(!filter){
            component.set("v.AddRowDisable",false);
        }
        /*ul = document.getElementById("mySearchUL");
        li = ul.getElementsByTagName("li");
        for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("span")[2];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }*/
        const selectedtitle = event.target.closest('div').dataset.title;
        this.searchAllHandler(component,selectedtitle,input.value);
    },
    
    searchAllHandler : function(component,selectedtitle,str){
        var action = component.get("c.getConUserRec");
        action.setParams({
            selectedObj : selectedtitle,
            matchStr: str
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var returnVal = response.getReturnValue();
                console.log(returnVal)
                component.set("v.conorUserListInOrg",returnVal);
                component.set("v.showdropdown",true)
            }
        })
        $A.enqueueAction(action)
    },
    GetFirstLevLookUpObjectFields : function(component, event, helper, FieldDetails) {
        //alert('FieldDetails--->'+FieldDetails);
        
        //component.set("v.toggleSpinner",true);
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            //alert('state--->'+state);
            if(state === "SUCCESS"){
                //component.set("v.toggleSpinner",false);
                var Result = response.getReturnValue();
                // alert('Result--->'+Result);
                if(Result.IsSuccess){
                    //alert('Result--->'+Result);
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',true);
                    component.set('v.ShowLevel3',false);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 1';
                    if(breadcrumbCollection != undefined){
                        //alert('breadcrumbCollection--->'+breadcrumbCollection);
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        //alert('breadcrumbCollection--->'+breadcrumbCollection);
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FirstLevelObjectFields',Result.WrapperList);
                    
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
    GetFirstLevelFieldDetails : function(component, event, helper, ObjName, FieldDetails) {
        //alert('--GetFirstLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.GetFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                component.set("v.ShowLevel1",true);
                component.set("v.ShowLevel2",false);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                    component.set('v.FirstLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FirstLevSelectedFieldDetails','{!'+Result + '}'); 
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
        var action = component.get("c.getAllObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert(state);
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set('v.ShowLevel3',true);
                    component.set('v.ShowLevel4',false);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 2';
                    
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    component.set('v.FirstLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.SecondLevelObjectFields',Result.WrapperList);
                    
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
    GetSecLevelFieldDetails : function(component, event, helper, ObjName, FirstField, FieldDetails) {
        //alert('--GetSecondLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.GetSecLevelFieldDetailscontroller");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',true);
                component.set("v.ShowLevel3",false);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                if(component.get("v.parents") != 'yes'){
                    component.set('v.SecondLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.SecondLevSelectedFieldDetails','{!'+Result+ '}');
                }
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    GetThirdLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, FieldDetails) {
        //alert('--GetThirdLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
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
                var Result = response.getReturnValue();
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',false);
                component.set("v.ShowLevel3",true);
                component.set("v.ShowLevel4",false);
                component.set("v.ShowLevel5",false);
                
                if(component.get("v.parents") != 'yes'){
                    component.set('v.ThirdLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.ThirdLevSelectedFieldDetails','{!'+Result+'}');
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
        var action = component.get("c.getFinalObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set("v.ShowLevel3",false);
                    component.set('v.ShowLevel4',true);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    breadcrumb.level = 'Level 3';
                    
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevSelectedFieldDetails',undefined);
                    component.set('v.ThirdLevelObjectFields',Result.WrapperList);
                    
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
        var action = component.get("c.getFinalObjectFields");
        action.setParams({
            "ObjAPIName" : FieldDetails
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                if(Result.IsSuccess){
                    component.set('v.ShowLevel1',false);
                    component.set('v.ShowLevel2',false);
                    component.set("v.ShowLevel3",false);
                    component.set('v.ShowLevel4',true);
                    component.set('v.ShowLevel5',false);
                    var breadcrumbCollection = component.get("v.breadcrumbCollection");
                    var breadcrumb = {};
                    var obj = [];
                    breadcrumb.label= FieldDetails;
                    breadcrumb.name= FieldDetails;   
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb);
                        component.set('v.breadcrumbCollection', breadcrumbCollection);
                    }
                    else{
                        obj.push(breadcrumb);
                        component.set('v.breadcrumbCollection', obj);
                    }
                    //component.set('v.FirstLevSelectedFieldDetails',undefined);
                    //component.set('v.SecondLevSelectedFieldDetails',undefined);
                    component.set('v.FinalLevSelectedFieldDetails',undefined);
                    
                    component.set('v.FinalLevelObjectFields',Result.WrapperList);
                    
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
    
    GetFinalLevelFieldDetails : function(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FourthField) {
        //alert('--GetThirdLevelFieldDetails--');
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.GetFinalLevelFieldDetails");
        action.setParams({
            "ObjectName" : ObjName,
            "FirstField" : FirstField,
            "SecondField" : SecondField,
            "ThirdField" : ThirdField,
            "FinalField" : FourthField
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('--state--'+state);
            if(state === "SUCCESS"){
                var Result = response.getReturnValue();
                //alert('--Result--'+Result);
                component.set('v.ShowLevel1',false);
                component.set('v.ShowLevel2',false);
                component.set("v.ShowLevel3",false);
                component.set('v.ShowLevel4',true);
                component.set('v.ShowLevel5',false);    
                
                if(component.get("v.parents") != 'yes'){
                    component.set('v.FinalLevSelectedFieldDetails',Result);
                }
                else{
                    component.set('v.FinalLevSelectedFieldDetails','{!'+Result + '}'); 
                }
                
                
            }
            else if (state === "ERROR") {
                
            }
        });
        $A.enqueueAction(action);
    },
    /********* SAIRAM 13-03-2023 ***********/
    getGeneratedTempValues : function(component,event,helper){
        var getTemplateValues = component.get("c.generateEmailTemplateValues");
        getTemplateValues.setParams({
            recordId : component.get("v.recordId")
        });
        getTemplateValues.setCallback(this, function(response) {
            var state = response.getState();
            //alert('state---->'+state);
            var result = response.getReturnValue();
            //alert('result---->'+JSON.stringify(result));
            if(state == 'SUCCESS'){
                /*component.set("v.templateHTMLvalue",result.templateHTMLValue);
                component.set("v.templateSubject",result.templateSubject);*/
                component.set("v.selectedStep", "step3");
                component.set("v.isPrepareandSend",true);
            }
        });
        $A.enqueueAction(getTemplateValues);
    },
    /********* SAIRAM 13-03-2023 ***********/
    uploadHelper : function (component, event,filename, fileabc, FilesUpload){
        debugger;
        var name = filename;
        //alert(name+'--->name');
        var file = fileabc;
        
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            //alert('fileContents'+fileContents);
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            var Filesection = JSON.parse(JSON.stringify(component.get("v.UploadFiles")));
            
            Filesection.push({
                'name' : name,
                'fileContents' : fileContents
            });
            component.set("v.UploadFiles", Filesection);
        });
        objFileReader.readAsDataURL(file);
        
            
            /*const reader = new FileReader();
            
            reader.onload = function(e) {
                let blobVal = new Blob([new Uint8Array(reader.result)], {type: file.type });
                var Filesection = JSON.parse(JSON.stringify(component.get("v.UploadFiles")));
                
                Filesection.push({
                    'name' : name,
                    'fileContents' : blobVal
                });
                console.log(blobVal);
                console.log(Filesection)
                //localStorage.setItem('filesContent',JSON.stringify(Filesection))
                component.set("v.UploadFiles", Filesection);
               	//Filesection = JSON.parse(JSON.stringify(component.get("v.UploadFiles")));
                //console.log(Filesection)
            };
            reader.readAsArrayBuffer(file);*/
    },
    /* postActions : function (component, event,filename, fileabc, FilesUpload){
    
     let action888 = component.get("c.getAccountFieldValue");
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
        
        $A.enqueueAction(action888);
    
    }*/
    fetchEmailTemplates : function(component) {
    var action = component.get("c.getClassicEmailTemplates");
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            var templates = response.getReturnValue();
            var options = templates.map(function(template) {
                return { label: template.Name, value: template.Id };
            });
            component.set("v.emailTemplateOptions", options);
        }
    });
    $A.enqueueAction(action);
},
})
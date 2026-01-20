({
    init: function(component, event, helper) {
        document.title = "Object Selector";
        component.set("v.PDFStyle","sldscoldiv ")
            component.set("v.EmailStyle","sldscoldiv ")
        	component.set("v.WordStyle","sldscoldiv ")
            component.set("v.ExcelStyle","sldscoldiv")
          var action = component.get("c.getObjectName");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                var options = [];
                var allValues = response.getReturnValue();
                for(var i=0;i<allValues.length;i++){
                	options.push({
                        "label" : allValues[i].objectLabel,
                        "value" : allValues[i].objectName
                    });    
                }
                component.set("v.results", options);
            }                    
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    searchAll : function (component, event, helper) {
        var showButton = component.get("v.showButton");
        if(showButton == true){
        	component.set("v.showButton", false);	    
        }
        component.set("v.openDropDown", true);
    },
    
    blur : function (component, event, helper) {
    	component.set("v.openDropDown", false);    
    },
    
    searchHandler : function (component, event, helper) {
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        console.log('input------>'+input);
        filter = input.value.toUpperCase();
        console.log('filter------>'+filter);
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
        //helper.search(component, event, helper);
    },

    optionClickHandler : function (component, event, helper) {
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedValue);
        component.set("v.showButton", true);
    },
    
    redirectToPdfBuilder : function (component, event, helper) {
      /*  var selectedValue = component.get("v.selectedOption");
        var JunodocUrl='apex';
        
    	//window.open('/apex/JunoDoc__MasterObjectSelector', '_self');
        if(selectedValue == undefined || selectedValue == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please Select Object",
                type: "error"
            });
            toastEvent.fire();
        }
        else if(component.get("v.selectedFormat") == '' || component.get("v.selectedFormat") == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please Select Template",
                type: "error"
            });
            toastEvent.fire();
        }
        else if(component.get("v.selectedFormat") == 'PDF'){ 
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
                    window.open('/'+JunodocUrl+'/PDFTemplateBuilder?objectName='+ selectedValue, '_self'); 
                }                    
            });
            $A.enqueueAction(action); 
        	
        }
        else if(component.get("v.selectedFormat") == 'EMAIL'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/EmailTemplateBuilder?objectName='+ selectedValue, '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }
        else if(component.get("v.selectedFormat") == 'WORD'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/WordDocTemplateBuilder?objectName='+ selectedValue+'&TemplateType=Word Document', '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }
        //New code
        else if(component.get("v.selectedFormat") == 'EXCEL'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/ExcelTemplateBuilder?objectName='+ selectedValue+'&TemplateType=Excel', '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }*/
        
    },
    
    selectFormat : function (component, event, helper) {
        const selectedValue = event.currentTarget.dataset.value;
        component.set("v.selectedFormat",selectedValue);
        if(selectedValue == 'EMAIL'){
        	var cmpTarget = component.find('PDF');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            var cmpTarget = component.find('EMAIL');
        	//$A.util.addClass(cmpTarget, 'avatarIconColor');
            
            
            component.set("v.PDFStyle","sldscoldiv")
            component.set("v.EmailStyle","sldscoldiv PDFdiv")
        	component.set("v.WordStyle","sldscoldiv")
            component.set("v.ExcelStyle","sldscoldiv")
        }
        if(selectedValue == 'PDF'){
            var cmpTarget = component.find('PDF');
        	//$A.util.addClass(cmpTarget, 'avatarIconColor');
        	var cmpTarget = component.find('EMAIL');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            	component.set("v.PDFStyle","sldscoldiv PDFdiv")
            component.set("v.EmailStyle","sldscoldiv ")
        	component.set("v.WordStyle","sldscoldiv")
            component.set("v.ExcelStyle","sldscoldiv")
            }
        if(selectedValue == 'WORD'){
            var cmpTarget = component.find('WORD');
        	//$A.util.addClass(cmpTarget, 'avatarIconColor');
        	var cmpTarget = component.find('EMAIL');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            var cmpTarget = component.find('PDF');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            	component.set("v.PDFStyle","sldscoldiv ")
            component.set("v.EmailStyle","sldscoldiv ")
        	component.set("v.WordStyle","sldscoldiv PDFdiv")
            component.set("v.ExcelStyle","sldscoldiv")
             }
        //New code
        if(selectedValue == 'EXCEL'){
            
            var cmpTarget = component.find('EXCEL');
        	//$A.util.addClass(cmpTarget, 'avatarIconColor');
            var cmpTarget = component.find('WORD');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
        	var cmpTarget = component.find('EMAIL');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            var cmpTarget = component.find('PDF');
        	//$A.util.removeClass(cmpTarget, 'avatarIconColor');
            component.set("v.PDFStyle","sldscoldiv ")
            component.set("v.EmailStyle","sldscoldiv ")
        	component.set("v.WordStyle","sldscoldiv ")
            component.set("v.ExcelStyle","sldscoldiv PDFdiv")
             }
        
        var selectedValue2 = component.get("v.selectedOption");
        var JunodocUrl='apex';
        
    	//window.open('/apex/JunoDoc__MasterObjectSelector', '_self');
        if(selectedValue2 == undefined || selectedValue2 == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please Select Object",
                type: "error"
            });
            toastEvent.fire();
        }
        else if(component.get("v.selectedFormat") == '' || component.get("v.selectedFormat") == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please Select Template",
                type: "error"
            });
            toastEvent.fire();
        }
        else if(component.get("v.selectedFormat") == 'PDF'){ 
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
                    window.open('/'+JunodocUrl+'/PDFTemplateBuilder_MOD?objectName='+ selectedValue2, '_self'); 
                }                    
            });
            $A.enqueueAction(action); 
        	
        }
        else if(component.get("v.selectedFormat") == 'EMAIL'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/EmailTemplateBuilder_MOD?objectName='+ selectedValue2, '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }
        else if(component.get("v.selectedFormat") == 'WORD'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/WordDocTemplateBuilder_MOD?objectName='+ selectedValue2+'&TemplateType=Word Document', '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }
        //New code
        else if(component.get("v.selectedFormat") == 'EXCEL'){
            var action = component.get("c.getJunodocUrl");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {   
                    JunodocUrl = response.getReturnValue();
		            window.open('/'+JunodocUrl+'/ExcelTemplateBuilder_MOD?objectName='+ selectedValue2+'&TemplateType=Excel', '_self');
                }                    
            });
            $A.enqueueAction(action);             
            
        }
    },
})
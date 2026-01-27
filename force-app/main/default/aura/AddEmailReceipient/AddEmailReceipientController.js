({
    doInit :  function(component, event, helper){
        component.set("v.ShowLevel1",true);
        helper.GetObjectLabelName(component, event, helper);// dont delete
        //helper.GetObjectFields(component, event, helper);
        var acclistsize = component.get("v.accList");
        component.set("v.toEmailListExist",false);
        
        
        if(acclistsize.length > 0){
            component.set("v.toEmailListExist",true);
        }
        
        component.set("v.toggleSpinner",true)
        var inputValue = component.get("v.ObjectAPIName");
        
        
        
        var action1 = component.get("c.getAvailableDocTemplates");
        action1.setParams({
            "selectedobject":inputValue,
        });
        action1.setCallback(this,function(response){
            console.log(response.getState())
            console.log(response.getReturnValue())
            component.set("v.AvailableDocTemplatesList",response.getReturnValue().AvailableDocTemplatesList);
            var getSelectedTemplateAction = component.get("c.getDefaultTemplate");
            getSelectedTemplateAction.setParams({
                "selectedobject":inputValue,
            });
            getSelectedTemplateAction.setCallback(this,function(response){
                console.log(response.getState())
                console.log(response.getReturnValue())
                var returnVal = response.getReturnValue();
                if(returnVal['value']){
                    component.set("v.selectedDefaultDocTemplate",response.getReturnValue());
                    var selectedval = component.get("v.selectedDefaultDocTemplate.value");
                    component.set("v.AvailableDocTemplateSelectedValue", selectedval);
                }
                
                component.set("v.toggleSpinner",false)
            });
            $A.enqueueAction(getSelectedTemplateAction);         	
            //component.set("v.toggleSpinner",false)
        });
        
        $A.enqueueAction(action1);
        
        /************* SaiRam 21-02-2023 *************/
        /***** Juno EmailTemplate - Get action *****/
        
        var action2 = component.get("c.getJunoEmailTemplates");
        action2.setParams({
            "selectedobject":inputValue,
        });
        action2.setCallback(this,function(response){
            console.log(response.getState())
            console.log(response.getReturnValue())
            component.set("v.JunoEmailTemplatesList",response.getReturnValue().JunoEmailTemplatesList);
            var getSelectedEmailTemplateAction = component.get("c.getJunoEmailTemplate");
            getSelectedEmailTemplateAction.setParams({
                "selectedobject":inputValue,
            });
            getSelectedEmailTemplateAction.setCallback(this,function(response){
                console.log(response.getState())
                console.log(response.getReturnValue())
                var returnVal = response.getReturnValue();
                if(returnVal['value']){
                    component.set("v.selectedJunoEmailTemplate",response.getReturnValue());
                    var selectedval = component.get("v.selectedJunoEmailTemplate.value");
                    component.set("v.JunoEmailTemplateSelectedValue", selectedval);
                }
                
                component.set("v.toggleSpinner",false)
            });
            $A.enqueueAction(getSelectedEmailTemplateAction);         	
            //component.set("v.toggleSpinner",false)
        });
        
        $A.enqueueAction(action2);
        
        /***** Juno EmailTemplate For Owner - Get action *****/
        
        var action3 = component.get("c.getJunoEmailTemplatesForOwner");
        action3.setParams({
            "selectedobject":inputValue,
        });
        action3.setCallback(this,function(response){
            console.log(response.getState())
            console.log(response.getReturnValue())
            component.set("v.JunoEmailTemplatesForOwnerList",response.getReturnValue().JunoEmailTemplatesForOwnerList);
            var getSelectedEmailTemplateForOwnerAction = component.get("c.getJunoEmailTemplateForOwner");
            getSelectedEmailTemplateForOwnerAction.setParams({
                "selectedobject":inputValue,
            });
            getSelectedEmailTemplateForOwnerAction.setCallback(this,function(response){
                console.log(response.getState())
                console.log(response.getReturnValue())
                var returnVal = response.getReturnValue();
                if(returnVal['value']){
                    component.set("v.selectedJunoEmailTemplateForOwner",response.getReturnValue());
                    var selectedval = component.get("v.selectedJunoEmailTemplateForOwner.value");
                    component.set("v.JunoEmailTemplateSelectedValueForOwner", selectedval);
                }
                
                component.set("v.toggleSpinner",false)
            });
            $A.enqueueAction(getSelectedEmailTemplateForOwnerAction);         	
            //component.set("v.toggleSpinner",false)
        });
        
        $A.enqueueAction(action3);
        
        /***** Juno EmailTemplate For Signee - Get action *****/
        
        var action4 = component.get("c.getJunoEmailTemplatesForSignee");
        action4.setParams({
            "selectedobject":inputValue,
        });
        action4.setCallback(this,function(response){
            console.log(response.getState())
            console.log(response.getReturnValue())
            component.set("v.JunoEmailTemplatesForSigneeList",response.getReturnValue().JunoEmailTemplatesForSigneeList);
            var getSelectedEmailTemplateForSigneeAction = component.get("c.getJunoEmailTemplateForSignee");
            getSelectedEmailTemplateForSigneeAction.setParams({
                "selectedobject":inputValue,
            });
            getSelectedEmailTemplateForSigneeAction.setCallback(this,function(response){
                console.log(response.getState())
                console.log(response.getReturnValue())
                var returnVal = response.getReturnValue();
                if(returnVal['value']){
                    component.set("v.selectedJunoEmailTemplateForSignee",response.getReturnValue());
                    var selectedval = component.get("v.selectedJunoEmailTemplateForSignee.value");
                    component.set("v.JunoEmailTemplateSelectedValueForSignee", selectedval);
                }
                
                component.set("v.toggleSpinner",false)
            });
            $A.enqueueAction(getSelectedEmailTemplateForSigneeAction);         	
            //component.set("v.toggleSpinner",false)
        });
        
        $A.enqueueAction(action4);
        
        var action5 = component.get("c.getSetReplyTo");
        action5.setParams({
            "selectedobject":inputValue,
        });
        action5.setCallback(this,function(response){
            component.set("v.SetReplyToValue",response.getReturnValue());
        });
        $A.enqueueAction(action5);
        /************* SaiRam 21-02-2023 *************/
        
      /*  var actions = component.get("c.orgwideEmail");
        actions.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
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
                component.set("v.options2", opts);
            }
        });
        $A.enqueueAction(actions);*/
        
        let action888 = component.get("c.getAccountFieldValue");
        action888.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let fieldValue = response.getReturnValue();
                component.set("v.showChildComponent", fieldValue); // Show or hide based on field value
            } else {
                console.error("Error retrieving account field value: " + response.getError());
            }
        });
        
        $A.enqueueAction(action888);
    },
    handleAddEmailRecipientButtonClick:function(component, event, helper){
        var modal = component.find('ToEmailPopupdialog');
        var backdrop = component.find('ToEmailPopupbackdrop');
        $A.util.addClass(modal,'slds-fade-in-open');
        $A.util.addClass(backdrop,'slds-backdrop--open');
       
        component.set("v.SaveButtonDisabled",true);
        component.set("v.AddRowButtonDisabled",true);
        
        var emailType = event.currentTarget.dataset.emailtype
        component.set("v.emailTypeRecipient",emailType)
    },
    closeToEmailPopup:function(component, event, helper){
        component.set("v.isContactorUser",false);
        var modal = component.find('ToEmailPopupdialog');
        var backdrop = component.find('ToEmailPopupbackdrop');
        $A.util.removeClass(modal,'slds-fade-in-open');
        $A.util.removeClass(backdrop,'slds-backdrop--open'); 
        component.set("v.manualEmailAddress", "");
         component.set("v.TextName","");
        component.set("v.selectedConOrUser",'');
        component.set("v.selectedValue","");
        component.set("v.SecondSelectedValue","");
        component.set("v.ToCcBccPicklistVal","To");
        component.set("v.TextRefPicklistVal","Text");
        component.set("v.isReference", false);
        component.set("v.ShowLevel1",false);
        component.set("v.ShowLevel2",false);
        component.set("v.ShowLevel3",false);
        component.set("v.ShowLevel4",false);
        component.set("v.ShowLevel5",false);
        component.set("v.AddRowButtonClicked",false);
        component.set("v.AddRowTemporaryList",null);
        component.set("v.SaveButtonDisabled",true);
        component.set("v.AddRowButtonDisabled",true);
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
    onToCcBccChange:function(component, event, helper){
        var selectedValue=component.get("v.ToCcBccPicklistVal");
        component.set("v.emailTypeRecipient",selectedValue)
    },
   
    onTextRefChange:function(component, event, helper){
        var selectedValue=component.get("v.TextRefPicklistVal");
        component.set("v.manualEmailAddress", "");
        component.set("v.TextName","")
        component.set("v.selectedConOrUser","");
        if(selectedValue == 'Reference'){
            component.set("v.isReference", true);
            component.set('v.ShowLevel1',true);
            
        }else if(selectedValue == 'Contact' || selectedValue == 'User'){
            component.set("v.isContactorUser",true);
            component.set("v.isReference", false);
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
            component.set("v.selectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ThirdSelectedValue","");
            component.set("v.FourthSelectedValue","");
            component.set("v.ShowLevel1",true);
            component.set("v.ShowLevel2",false);
            component.set("v.ShowLevel3",false);
            component.set("v.ShowLevel4",false);
            var action = component.get("c.getConUserRec")
            action.setParams({
                selectedObj : selectedValue
            });
            action.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    var returnVal = response.getReturnValue();
                    console.log(returnVal)
                    component.set("v.conorUserListInOrg",returnVal);
                }
            })
            $A.enqueueAction(action)
        }else{
            component.set("v.isContactorUser",false);
            component.set("v.isReference", false);
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
            component.set("v.selectedValue","");
            component.set("v.SecondSelectedValue","");
            component.set("v.ThirdSelectedValue","");
            component.set("v.FourthSelectedValue","");
            component.set("v.ShowLevel1",true);
            component.set("v.ShowLevel2",false);
            component.set("v.ShowLevel3",false);
            component.set("v.ShowLevel4",false);
        }
    },
    OnEmailChange:function(component, event, helper){
        var value = component.get("v.manualEmailAddress");
        var TextName = component.get("v.TextName");
        if(value != undefined && value != '' && 
          ((TextName != undefined && TextName != '') || !component.get("v.isSigneeMapping"))  && !component.get("v.isReference")){
            //component.set("v.")
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
        }else{
            component.set("v.AddRowButtonDisabled",true);
            component.set("v.SaveButtonDisabled",true);
        }
    },
    handleSetReplyTo:function(component, event, helper){
        var SetReplyTo = component.get("v.SetReplyToValue");
        var inputValue = component.get("v.ObjectAPIName");
       // var doctemplete=component.get("v.DocTemplates");
        
       
        if(inputValue!=null && inputValue!='' && inputValue!=undefined)
        {
            /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
          
            if(component.get("v.isSigneeMapping")){
                var action = component.get("c.createrecordSetReplyTo");
                action.setParams({
                    "selectedobject":inputValue,
                    //"docvalue":doctemplete,
                    "SetReplyTo":SetReplyTo
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    //alert(state)
                    if(state === "SUCCESS"){
                        var VFPage = component.get("v.VFPage");
                        if(VFPage == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "type": "success",
                                "message": "Saved Successfully"
                            });
                            toastEvent.fire(); 
                        }
                        else{
                            component.set("v.isSuccess",true);
                            window.setTimeout(
                                $A.getCallback(function() {
                                    component.set("v.isSuccess", false);
                                }), 5000
                            );
                        }
                        
                    }
                    else{
                        console.log('Error');
                        console.log(response.getError())
                    }
                });
                $A.enqueueAction(action);
            }
            
          /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
          
      }else{
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "title": "ERROR!",
              "type": "ERROR",
              "message": "Plaease select object"
          });
          toastEvent.fire();
      }
        
    },
    SaveEmail:function(component, event, helper){
        debugger;
        var IterableList = component.get("v.accList");
        
        var selectedValue= '';
        selectedValue = component.get("v.ToCcBccPicklistVal");
        if(component.get("v.isSigneeMapping")){
            selectedValue = component.get("v.emailTypeRecipient") //component.get("v.ToCcBccPicklistVal");
        }
          
        
        var TextRefValue=component.get("v.TextRefPicklistVal");
        
        var value = component.get("v.manualEmailAddress");
        var TextName = component.get("v.TextName");
        var lookupValue = '';
        var APIvalue ='';
        var isLookup;
        var AdditionalRowList = component.get("v.AddRowTemporaryList");
        if(component.get("v.ObjectLabelName") != undefined){
            lookupValue = component.get("v.ObjectLabelName");
            APIvalue = component.get("v.ObjectAPIName");
            isLookup= true;
            if(component.get("v.selectedValue") != undefined && component.get("v.selectedValue") != ''){
                debugger;
                var FieldDetails =component.get("v.selectedValue");
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
                    if(LokUpApiName != null && LabelName.includes('>')){
                        isLookup = true; 
                    }else{
                        isLookup =false;
                    }
                    if(component.get("v.ThirdSelectedValue") != undefined && component.get("v.ThirdSelectedValue") != ''){
                        var FieldDetails = component.get("v.ThirdSelectedValue");
                        var LokUpApiName = FieldDetails.split('-')[1];
                        var ApiName = FieldDetails.split('-')[0];
                        var LabelName = FieldDetails.split('-')[2];
                        
                        lookupValue = lookupValue+  LabelName;
                        APIvalue =APIvalue+':'+ LokUpApiName;
                        if(LokUpApiName != null && LabelName.includes('>')){
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
                            if(LokUpApiName != null && LabelName.includes('>')){
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
        if(selectedValue != '' && selectedValue != undefined && selectedValue != null){
            arry.Tovalue = selectedValue;
            
        }
        if(TextName != '' && TextName != undefined && TextName != null){
            arry.TextName = TextName;
            
        }
        if(TextRefValue != '' && TextRefValue != undefined && TextRefValue != null){
            arry.TextRefVal = TextRefValue;
            
        }
        if(value!=undefined && value != '' &&value != null){
            arry.Email = value;
            
        } 
        else if(lookupValue != undefined && lookupValue != '' && lookupValue != null && !lookupValue.includes('None')){
            arry.Email = lookupValue;
        }
        if(finalFieldDetails != undefined && finalFieldDetails != '' && finalFieldDetails != null ){
            arry.fieldDetails = component.get('v.ObjectAPIName')+'.'+finalFieldDetails;
        }
        if(IterableList != undefined && IterableList != ''){
            
            if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName")) ){
                IterableList.push(arry);
                component.set("v.accList",IterableList);
            }
        }
        else{
            
            if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName"))){
                obj.push(arry);
                component.set("v.accList",obj);
            }
        }
        if(AdditionalRowList != undefined){
            var obj = component.get("v.accList");
            var listLength = AdditionalRowList.length;
            
            for (var i=0; i < AdditionalRowList.length; i++) {
                /**/
                var arry = {};
                arry.Tovalue = AdditionalRowList[i].Tovalue;
                
                
                arry.TextRefVal = AdditionalRowList[i].TextRefVal;
                
                arry.TextName = AdditionalRowList[i].TextName;
                
                
                arry.Email =AdditionalRowList[i].Email;
                
                arry.fieldDetails = AdditionalRowList[i].fieldDetails;
                obj.push(arry);
                
            }
          /*  if("fieldDetails" in obj[0]){
               
            }
            else{
                 alert("Entered")
                for(let i in obj){
                    obj[i]["fieldDetails"] = "yes";
                }
            } */
            component.set("v.accList",obj);
        }
        var modal = component.find('ToEmailPopupdialog');
        var backdrop = component.find('ToEmailPopupbackdrop');
        $A.util.removeClass(modal,'slds-fade-in-open');
        $A.util.removeClass(backdrop,'slds-backdrop--open'); 
        component.set("v.manualEmailAddress", "");
        component.set("v.TextName","")
        component.set("v.selectedConOrUser","");
        component.set("v.selectedValue","");
        component.set("v.SecondSelectedValue","");
        component.set("v.ThirdSelectedValue","");
        component.set("v.FourthSelectedValue","");
        /*component.set("v.ToCcBccPicklistVal","To");
        component.set("v.TextRefPicklistVal",arry.TextRefVal);
        if(arry.TextRefVal =='Text'){
           component.set("v.isReference",false);
        }else{
           component.set("v.isReference", true);
        }*/
        component.set("v.ToCcBccPicklistVal","To");
        component.set("v.TextRefPicklistVal","Text");
        component.set("v.isReference", false);
        component.set("v.ShowLevel1",true);
        component.set("v.ShowLevel2",false);
        component.set("v.ShowLevel3",false);
        component.set("v.ShowLevel4",false);
        component.set("v.ShowLevel5",false);
        component.set("v.toEmailListExist", true);
        component.set("v.AddRowButtonClicked",false);
        component.set("v.isContactorUser",false)
        
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
        //Submit code
        var inputValue = component.get("v.ObjectAPIName");
       // var doctemplete=component.get("v.DocTemplates");
        
        var relatedemail=component.get("v.accList");
        var relatedemail=component.get("v.ccaccList");
        if(inputValue!=null && inputValue!='' && inputValue!=undefined)
        {
            /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
          
            if(component.get("v.isSigneeMapping")){
                var action = component.get("c.createrecord");
                action.setParams({
                    "selectedobject":inputValue,
                    //"docvalue":doctemplete,
                    "emaillist":JSON.stringify(component.get("v.accList"))
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    //alert(state)
                    if(state === "SUCCESS"){
                        var VFPage = component.get("v.VFPage");
                        if(VFPage == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "type": "success",
                                "message": "Saved Successfully"
                            });
                            toastEvent.fire(); 
                        }
                        else{
                            component.set("v.isSuccess",true);
                            window.setTimeout(
                                $A.getCallback(function() {
                                    component.set("v.isSuccess", false);
                                }), 5000
                            );
                        }
                        
                    }
                    else{
                        console.log('Error');
                        console.log(response.getError())
                    }
                });
                $A.enqueueAction(action);
            }
            
          /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
          
      }else{
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "title": "ERROR!",
              "type": "ERROR",
              "message": "Plaease select object"
          });
          toastEvent.fire();
      }
        //End of Submit
        var MessageEvent = component.getEvent("emailList"); 
        MessageEvent.setParams({
            "emailList": component.get("v.accList"),
            "fieldDetails": finalFieldDetails
        });                               
        MessageEvent.fire();  
    },
    /*SelectedToOrgEmail: function(component,event,helper){
        var getOrgEmail = component.get("v.EmailAddressSelectedValue");
        var getcompEvent = component.getEvent("OrgEmailSelectedEvent");
        getcompEvent.setParams({"OrgEmail_Event":getOrgEmail});
        getcompEvent.fire();
    },*/
    FirstLevelSelectChange:function(component, event, helper){
        var FieldDetails = component.get("v.selectedValue");
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('-')[1];
        var ApiName = FieldDetails.split('-')[0];
        var LabelName = FieldDetails.split('-')[2];
        component.set('v.FirstLevField',ApiName);
        if(LabelName.includes('>')){
            helper.GetFirstLevLookUpObjectFields(component, event, helper, LokUpApiName);
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
        }else{
            
            helper.GetFirstLevelFieldDetails(component, event, helper, ObjName, FieldDetails);
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
        }
        /*if(!component.get("v.TextName")){
            component.set("v.SaveButtonDisabled",true);
        }*/
    },
    
    GetSecLevelSelectedField : function(component, event, helper){
        var FieldDetails = component.get("v.SecondSelectedValue");
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('-')[1];
        var ApiName = FieldDetails.split('-')[0];
        var FirstField = component.get('v.FirstLevField');
        var LabelName = FieldDetails.split('-')[2];
        
        component.set('v.SecondLevField',ApiName);
        if(LabelName.includes('>')){
            helper.GetSecLevLookUpObjectFields(component, event, helper, LokUpApiName);
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
        }else{
            helper.GetSecLevelFieldDetails(component, event, helper, ObjName, FirstField, FieldDetails);
            
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
        }
        /* if(!component.get("v.TextName")){
            component.set("v.SaveButtonDisabled",true);
        }*/
    },
    GetThirdLevelSelectedField : function(component, event, helper){
        
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
        component.set("v.SaveButtonDisabled",false);
        component.set("v.AddRowButtonDisabled",false);
        helper.GetFinalLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FieldDetails);
        //}
    },
    handleAddRowButtonClick: function(component,event,helper){
        component.set("v.AddRowButtonClicked",true);
        var IterableList = component.get("v.AddRowTemporaryList");
        var selectedValue= component.get("v.ToCcBccPicklistVal"); //component.get("v.emailTypeRecipient");
        if(component.get("v.isSigneeMapping")){
            selectedValue = component.get("v.emailTypeRecipient");
        }
        var TextRefValue=component.get("v.TextRefPicklistVal");
        var value = component.get("v.manualEmailAddress");
        var TextName = component.get("v.TextName");
        var lookupValue = '';
        var APIvalue ='';
        var isLookup;
        if(component.get("v.ObjectLabelName") != undefined && component.get("v.ObjectLabelName") != ''){
            lookupValue = component.get("v.ObjectLabelName");
            APIvalue = component.get("v.ObjectAPIName");
            isLookup =true;
            if(component.get("v.selectedValue") != undefined && component.get("v.selectedValue") != ''){
                
                var FieldDetails =component.get("v.selectedValue");
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
        
        if(selectedValue != '' && selectedValue != undefined && selectedValue != null){
            arry.Tovalue = selectedValue;
            
        }
        if(TextName != '' && TextName != undefined && TextName != null){
            arry.TextName = TextName;
            
        }
        if(TextRefValue != '' && TextRefValue != undefined && TextRefValue != null){
            arry.TextRefVal = TextRefValue;
            
        }
        if(value!=undefined && value != '' &&value != null){
            arry.Email = value;
            
        } 
        else if(lookupValue != undefined && lookupValue != '' && lookupValue != null&& !lookupValue.includes('None')){
            arry.Email = lookupValue;
            
        }
        
        arry.fieldDetails = component.get('v.ObjectAPIName')+'.'+finalFieldDetails;
        
        if(IterableList != undefined && IterableList != ''){
            
            if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName") )){
                IterableList.push(arry);
                component.set("v.AddRowTemporaryList",IterableList);
                component.set("v.toAddRowListExist", true);
            }
        }
        else{
            
            if((!arry.Email.includes("None") && isLookup ==false) || ((arry.TextRefVal == 'Text' || arry.TextRefVal == 'Contact' || arry.TextRefVal == 'User') && arry.Email!= null && arry.Email!= component.get("v.ObjectLabelName"))){
                obj.push(arry);
                component.set("v.AddRowTemporaryList",obj);
                component.set("v.toAddRowListExist", true);
            }
        }
        component.set("v.manualEmailAddress", "");
        component.set("v.TextName","")
        component.set("v.selectedConOrUser","");
        component.set("v.selectedValue","");
        component.set("v.SecondSelectedValue","");
        component.set("v.ThirdSelectedValue","");
        component.set("v.FourthSelectedValue","");
        component.set("v.ToCcBccPicklistVal","To");
        component.set("v.TextRefPicklistVal",arry.TextRefVal);
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
        //Breadcrumb Code End
        component.set("v.TextName",'');
    },
    
    deleteAddRowClick: function(component,event,helper){
        
        var count = event.currentTarget.dataset.id;
        
        var tempList = component.get("v.AddRowTemporaryList");
        tempList.splice(count, 1);
        component.set("v.AddRowTemporaryList", tempList);
    },
    
    deleteMainListClick: function(component,event,helper){
        
        var count = event.currentTarget.dataset.id;
        
        var tempList = component.get("v.accList");
        tempList.splice(count, 1);
        component.set("v.accList", tempList);
        
        if(tempList.length ==0){
            component.set("v.toEmailListExist",false);
        }
        
        //Breadcrumb Code End
        //Submit code
        var inputValue = component.get("v.ObjectAPIName");
        //var doctemplete=component.get("v.DocTemplates");
        
        var relatedemail=component.get("v.accList");
        var relatedemail=component.get("v.ccaccList");
        
        if(inputValue!=null && inputValue!='' && inputValue!=undefined){
            /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            
            if(component.get("v.isSigneeMapping")){
                var action = component.get("c.createrecord");
                action.setParams({
                    "selectedobject":inputValue,
                    //"docvalue":doctemplete,
                    "emaillist":JSON.stringify(component.get("v.accList"))
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var VFPage = component.get("v.VFPage");
                        if(VFPage == false){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title : 'Success',
                                message: 'Saved Successfully!',
                                duration:' 2000',
                                key: 'info_alt',
                                type: 'success',
                                mode: 'dismissible'
                            });
                            toastEvent.fire(); 
                        }
                        else{
                            component.set("v.isSuccess",true);
                            window.setTimeout(
                                $A.getCallback(function() {
                                    component.set("v.isSuccess", false);
                                }), 5000
                            );
                        }
                        
                    }
                });
                $A.enqueueAction(action);
            }
            
            /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
          
      }else{
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
              "title": "ERROR!",
              "type": "ERROR",
              "message": "Plaease select object"
          });
          toastEvent.fire();
      }
    },
    
    navigateTo: function(component,event,helper){
        component.set("v.selectedValue","");
        component.set("v.SecondSelectedValue","");
        component.set("v.ThirdSelectedValue","");
        component.set("v.FourthSelectedValue","");
        
        
        component.set("v.ToCcBccPicklistVal","To");
        component.set("v.TextRefPicklistVal","Reference");
        var level = event.getSource().get("v.name")
        var bread = component.get('v.breadcrumbCollection');
        
        
        
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
        
    },
    AvailableDocTemplateOnchangeHandler :  function(component,event,helper){
        var DocTemplateId = event.getSource().get("v.value");
        // alert('EmailTemplateId111>>>>>>>>>>>>>'+DocTemplateId);
        var inputValue = component.get("v.ObjectAPIName");
        //alert(DocTemplateId);
        console.log(DocTemplateId);
        if(DocTemplateId){ 
        //if (DocTemplateId != '' && DocTemplateId != undefined) { 
            //Code Start Here
            var DocList = component.get("v.AvailableDocTemplatesList");
            /*for(var i=0;i<DocList.length;i++){
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
                
                
            }*/
            // Code End Here
            component.set("v.DocTemplateId",DocTemplateId);
            //alert('EmailTemplateId>>>>>>>>>>>>>'+DocTemplateId);
            component.set("v.AvailableDocTemplateSelectedValue",DocTemplateId);
            
            var action2 = component.get("c.setDefaultTemplate");
            action2.setParams({
                "selectedobject":inputValue,
                "DocTemplate":DocTemplateId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
            
        }
        else{
            component.set('v.DocTemplateId','');
            //alert('EmailTemplateId>>>>>>>>>>>>>'+EmailTemplateId);
            
            component.set("v.AvailableDocTemplateSelectedValue",DocTemplateId);
            
            var action2 = component.get("c.setDefaultTemplate");
            action2.setParams({
                "selectedobject":inputValue,
                "DocTemplate":DocTemplateId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
        }
    },
    
    /************* SaiRam 21-02-2023 *************/
        /***** Juno EmailTemplate - Set function *****/
    
    JunoEmailTemplateOnchangeHandler :  function(component,event,helper){
        var EmailTemplateId = event.getSource().get("v.value");
        var inputValue = component.get("v.ObjectAPIName");
        //alert(DocTemplateId);
        console.log(EmailTemplateId);
        if(EmailTemplateId!=''){  
            //Code Start Here
            var EmailTempList = component.get("v.JunoEmailTemplatesList");
           
            // Code End Here
            component.set("v.EmailTemplateId",EmailTemplateId);
            component.set("v.JunoEmailTemplateSelectedValue",EmailTemplateId);
            
            var action2 = component.get("c.setJunoEmailTemplate");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
            
        }
        else{
            component.set("v.EmailTemplateId",EmailTemplateId);
            component.set("v.JunoEmailTemplateSelectedValue",EmailTemplateId);
            
            var action2 = component.get("c.setJunoEmailTemplate");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
        }
    },
    
    /***** Juno EmailTemplate For Owner - Set function *****/
    
     JunoEmailTemplateOnchangeHandlerForOwner :  function(component,event,helper){
        var EmailTemplateForOwnerId = event.getSource().get("v.value");
        var inputValue = component.get("v.ObjectAPIName");
        //alert(DocTemplateId);
        console.log(EmailTemplateForOwnerId);
        if(EmailTemplateForOwnerId!=''){  
            //Code Start Here
            var EmailTempList = component.get("v.JunoEmailTemplatesForOwnerList");
            
            // Code End Here
            component.set("v.EmailTemplateForOwnerId",EmailTemplateForOwnerId);
            component.set("v.JunoEmailTemplateSelectedValueForOwner",EmailTemplateForOwnerId);
            
            var action2 = component.get("c.setJunoEmailTemplateForOwner");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateForOwnerId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
            
        }
        else{
            component.set("v.EmailTemplateForOwnerId",EmailTemplateForOwnerId);
            component.set("v.JunoEmailTemplateSelectedValueForOwner",EmailTemplateForOwnerId);
            
            var action2 = component.get("c.setJunoEmailTemplateForOwner");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateForOwnerId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
        }
    },
    
    /***** Juno EmailTemplate For Signee - Set function *****/
    
    JunoEmailTemplateOnchangeHandlerForSignee :  function(component,event,helper){
        var EmailTemplateForSigneeId = event.getSource().get("v.value");
        var inputValue = component.get("v.ObjectAPIName");
        //alert(DocTemplateId);
        console.log(EmailTemplateForSigneeId);
        
        if(EmailTemplateForSigneeId!=''){  
            //Code Start Here
            var EmailTempList = component.get("v.JunoEmailTemplatesForSigneeList");
            
            // Code End Here
            component.set("v.EmailTemplateForSigneeId",EmailTemplateForSigneeId);
            component.set("v.JunoEmailTemplateSelectedValueForSignee",EmailTemplateForSigneeId);
            
            var action2 = component.get("c.setJunoEmailTemplateForSignee");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateForSigneeId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
            
        }
        else{
            component.set("v.EmailTemplateForSigneeId",EmailTemplateForSigneeId);
            component.set("v.JunoEmailTemplateSelectedValueForSignee",EmailTemplateForSigneeId);
            var action2 = component.get("c.setJunoEmailTemplateForSignee");
            action2.setParams({
                "selectedobject":inputValue,
                "EmailTemplate":EmailTemplateForSigneeId,
            });
            action2.setCallback(this,function(response){
                console.log(response.getState());
                console.log(response.getReturnValue());
                var state = response.getState();
                if(state=='SUCCESS'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Saved Successfully',
                        duration:' 2000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            })
            $A.enqueueAction(action2);
            //component.set("v.isDocTemplate",true);
            //alert(component.get("v.isDocTemplate"))
            if(component.get("v.VFPage") == false){
                
            }
        }
    },
    
    /************* SaiRam 21-02-2023 *************/
    
    /************* SaiRam 09-03-2023 *************/
    record : function(component,event,helper){
        //alert('11111111111111111');
         var childCmp = component.find("childCmponent");
        childCmp.childMethod();
        var immediateCmp = component.find("ImmediateActions");
        if (immediateCmp) {
            immediateCmp.saveData();
        }
        
        
        //alert('PARENT: Starting record function.');
        
       /* var remindersCmp = component.find("Reminders");
        if (!remindersCmp) {
            console.error("ERROR: Reminders component not found.");
            return;
        } */
        
       // alert('PARENT: Calling saveData() on Reminders component.');
       /* remindersCmp.saveData(); */
        
       // alert('PARENT: Reminders saveData() called successfully.');
        
       // alert('22222');
        component.set("v.toggleSpinner",true);
        var inputValue = component.get("v.ObjectAPIName");
        var doctemplete=component.get("v.docTemp");
        var relatedemail=component.get("v.accList");
        var relatedemail=component.get("v.ccaccList");
        var value = component.get("v.SetReplyToValue");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\ [\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9] {1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
        
       if(value.match(regExpEmailformat) && value != '' && value != undefined){
      if(inputValue!=null && inputValue!='' && inputValue!=undefined){
        /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            var action = component.get("c.createrecord2");
            action.setParams({
                "selectedobject":inputValue,
                "docvalue":doctemplete,
                "SetReplyTo":component.get("v.SetReplyToValue"),
                "emaillist":JSON.stringify(component.get("v.accList")),
                "DocTemplateId": component.get("v.AvailableDocTemplateSelectedValue"),
                "EmailTemplateId": component.get("v.JunoEmailTemplateSelectedValue"),
                "EmailTemplateIdForOwner": component.get("v.JunoEmailTemplateSelectedValueForOwner"),
                "EmailTemplateIdForSignee": component.get("v.JunoEmailTemplateSelectedValueForSignee"),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var VFPage = component.get("v.VFPage");
                    if(VFPage == false){
                         component.set("v.toggleSpinner",false);
                       var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Saved Successfully"
                        });
                        toastEvent.fire(); 
                    }
                    else{
                        component.set("v.isSuccess",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.isSuccess", false);
                            }), 5000
                        );
                    }
                    
                }
            });
            $A.enqueueAction(action);
        /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
      
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Please select object"
            });
            toastEvent.fire();
            component.set("v.toggleSpinner",false);
        }
        }
        else if(value == ''){
      if(inputValue!=null && inputValue!='' && inputValue!=undefined){
        /*if((juno!=null&&juno!=''&&juno!=undefined)||
              (standardemail!=null&&standardemail!=''&&standardemail!=undefined)){*/
            var action = component.get("c.createrecord2");
            action.setParams({
                "selectedobject":inputValue,
                "docvalue":doctemplete,
                "SetReplyTo":'',
                "emaillist":JSON.stringify(component.get("v.accList")),
                "DocTemplateId": component.get("v.AvailableDocTemplateSelectedValue"),
                "EmailTemplateId": component.get("v.JunoEmailTemplateSelectedValue"),
                "EmailTemplateIdForOwner": component.get("v.JunoEmailTemplateSelectedValueForOwner"),
                "EmailTemplateIdForSignee": component.get("v.JunoEmailTemplateSelectedValueForSignee"),
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var VFPage = component.get("v.VFPage");
                    if(VFPage == false){
                         component.set("v.toggleSpinner",false);
                       var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Saved Successfully"
                        });
                        toastEvent.fire(); 
                    }
                    else{
                        component.set("v.isSuccess",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.isSuccess", false);
                            }), 5000
                        );
                    }
                    
                }
            });
            $A.enqueueAction(action);
        /*}else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Plaease select Standard Email Templates or Junodoc Email Templates"
            });
            toastEvent.fire();
            
        }*/
      
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Please select object"
            });
            toastEvent.fire();
            component.set("v.toggleSpinner",false);
        }
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "ERROR!",
                "type": "ERROR",
                "message": "Set Reply To Email Address must be an Email Value"
            });
            toastEvent.fire();
            component.set("v.toggleSpinner",false);
        }
    },
    /************* SaiRam 09-03-2023 *************/
    
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
        component.set("v.manualEmailAddress",selectedValue);
        component.set("v.selectedConOrUser",selectedlabel);
        component.set("v.TextName",selectedlabel)
        component.set("v.showdropdown",false)
        if(selectedValue){
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
            
        }
    },
    closeDropDown : function (component, event, helper) {
        component.set("v.showdropdown",false)
    },
    handleconUserEmailChange : function (component, event, helper) {
        if(component.get("v.manualEmailAddress")){
            component.set("v.SaveButtonDisabled",false);
            component.set("v.AddRowButtonDisabled",false);
        }else{
            component.set("v.SaveButtonDisabled",true);
            component.set("v.AddRowButtonDisabled",true);
        }
    }
    
})
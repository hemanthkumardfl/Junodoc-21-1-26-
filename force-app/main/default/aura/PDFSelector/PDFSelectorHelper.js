({
    search : function(component, event, helper) {
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        ul = document.getElementById("myUL");
        li = ul.getElementsByTagName("li");
        console.log(JSON.stringify(li[0]))
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
    
    openSendPDFModelHelper : function(component,event,helper){
        var sObjName = component.get("v.inputValue");
        var action = component.get("c.getEmailTemplates");
        action.setParams({
            "sObjName" : sObjName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.StandardEmailTemplatesList",InnerResult.StandardEmailTemplatesList);
                component.set("v.JunoDocEmailTemplatesList",InnerResult.JunoDocEmailTemplatesList);
                component.set("v.JunoDocPDFTemplatesList",InnerResult.JunoDocPDFTemplatesList);
                component.set("v.OrgwideEmailAddressList",InnerResult.OrgwideEmailAddressList);
                component.set("v.attachAsPdfOptionsList", InnerResult.attachAsPdfOptions);
                var obj = component.get("v.inputValue");
                var action = component.get("c.getrecorddetails"); 
                action.setParams({
                    "selectedobject" : obj
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    
                    if(state === "SUCCESS"){
                        //(state);
                        var InnerResult = response.getReturnValue();
                        console.log("Query result"+JSON.stringify(InnerResult));
                        if(InnerResult!=null && InnerResult !=undefined){
                            
                            
                            
                            /* //for (var i=0; i < InnerResult.length; i++) {
                        component.set("v.FromEmailAddress",InnerResult[0].JunoDoc__From_Email_Address__c);
                        component.set("v.SetReplyTo",InnerResult[0].JunoDoc__Set_Reply_To__c);
                        component.set("v.StandardEmailTemplateSelectedValue",InnerResult[0].JunoDoc__Standard_Email_Templates__c);
                        component.set("v.test1",InnerResult[0].JunoDoc__Junodoc_Email_Templates__c);*/
                            component.set("v.FromEmailAddress",InnerResult.junodoc[0].JunoDoc__From_Email_Address__c);
                            component.set("v.SetReplyTo",InnerResult.junodoc[0].JunoDoc__Set_Reply_To__c);
                            component.set("v.DocTemplates",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                            component.set("v.StandardEmailTemplateSelectedValue",InnerResult.junodoc[0].JunoDoc__Standard_Email_Templates__c);
                            
                            component.set("v.globalActivityParentId",InnerResult.junodoc[0].JunoDoc__Global_Activity_Parent_Record_ID__c);
                            
                            component.set("v.parentObjectName",InnerResult.junodoc[0].JunoDoc__Parent_Object_Name__c);
                            component.set("v.childObjectName",InnerResult.junodoc[0].JunoDoc__Child_Object_Name__c);
                            component.set("v.childObjectFieldName",InnerResult.junodoc[0].JunoDoc__Child_Object_Field_Name__c);
                            component.set("v.parentObjectFieldName",InnerResult.junodoc[0].JunoDoc__Parent_Object_Field_Name__c);
                            component.set("v.childObjectReplaceFieldName",InnerResult.junodoc[0].JunoDoc__Child_Object_Replace_Field_Name__c);
                            /* Added by Sainath on 22-Aug-2025 Start*/
                            component.set("v.attachAsPdf", InnerResult.junodoc[0].JunoDoc__Attach_as_PDF__c);
                            component.set("v.attachAsPdfParent", InnerResult.junodoc[0].JunoDoc__Attach_as_PDF_Parent__c);
                            component.set("v.attachAsPdfOptionsList", InnerResult.attachAsPdfOptions);
                            /* Added by Sainath on 22-Aug-2025 End*/
                            
                            /* Added by Sainath on 09-Sep-2025 Start */
                            component.set("v.hideAttachAsPDF", InnerResult.junodoc[0].JunoDoc__Hide_Attach_as_PDF__c);
                            component.set("v.hideSaveAsActivity", InnerResult.junodoc[0].JunoDoc__Hide_Save_as_Activity__c);
                            /* Added by Sainath on 09-Sep-2025 End */
                            
                            component.set("v.test1",InnerResult.junodoc[0].JunoDoc__Junodoc_Email_Templates__c);
                            component.set("v.DocTemplates",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                            component.set("v.accList",InnerResult.junoEmailList);
                            component.set("v.parentValues",InnerResult.junodoc[0].JunoDoc__Parent_Object__c.split(','));
                            component.set("v.selectedParentObjects",InnerResult.junodoc[0].JunoDoc__Parent_Object__c);
                        }
                        else if(InnerResult==null || InnerResult==''){
                            component.set("v.FromEmailAddress","");
                            component.set("v.SetReplyTo","");
                            component.set("v.globalActivityParentId","");
                            component.set("v.StandardEmailTemplateSelectedValue","");
                            component.set("v.JunoDocEmailTemplateSelectedValue","");
                        }
                        console.log('standard email template --------> '+component.get("v.StandardEmailTemplateSelectedValue"));
                        component.set("v.variable1",true);
                    }
                    
                    
                });
                $A.enqueueAction(action);
            }
        });
        $A.enqueueAction(action); 
        
        
    },
    
    
    fetchParentObjectOptions: function(component,event,helper,selectedObjectName){
        var action = component.get("c.getParentObjects");
        action.setParams({
            "childObjectApiName" : selectedObjectName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                let options = response.getReturnValue();
                console.log('Result getParentObjects >> '+JSON.stringify(options));
                component.set("v.parentObjectOptions",options);
            }
        });
        $A.enqueueAction(action); 
    }
    
    
})
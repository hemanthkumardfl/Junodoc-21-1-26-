({
    doInit : function(component, event, helper) {
         var VFPage = component.get("v.VFPage");
        if(VFPage == false){
            var navigateEvent = $A.get("e.force:navigateToComponent");
            navigateEvent.setParams({
               componentDef: "c:JunoSignSendDocs",
                //  componentDef: "JunoDoc:DocuSignInPersonSigning",
               // componentDef: "JunoDoc:DocuSignInPersonSigningClone",
                //You can pass attribute value from Component1 to Component2
                componentAttributes :{ recordId: component.get('v.recordId')}
                
                
            });
            navigateEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
        }
    }
})
({
                getAccontRecord : function( component ) {
                                var action = component.get("c.getAudit");
                    //Calling Apex class controller 'getAccountRecord' method
                    action.setParams({
                        "AuditId" : component.get("v.recordId"),
                    })

        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            //alert(JSON.stringify(response.getReturnValue()));
            console.log(JSON.stringify(response.getReturnValue()));
            console.log("esult"+result);
            if (component.isValid() && state === "SUCCESS")
                component.set("v.accLst", response.getReturnValue());  // Adding values in Aura attribute variable.   
        });
        $A.enqueueAction(action);
                }
})
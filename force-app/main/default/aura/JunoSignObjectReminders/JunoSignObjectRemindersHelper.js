({
    fetchReminders: function(component) {
        var recordId = component.get("v.recordId");
        console.log('JunoSignObjectReminders: Trying to fetch data for recordId ->', recordId); // LOG 1
        
        var action = component.get("c.getReminders");
        action.setParams({ "recordId": recordId });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('JunoSignObjectReminders: Apex returned data ->', response.getReturnValue()); // LOG 2
                component.set("v.remindersList", response.getReturnValue());
            } else {
                console.error("JunoSignObjectReminders: Apex call failed -> ", response.getError()); // LOG 3
            }
        });
        $A.enqueueAction(action);
    }
})
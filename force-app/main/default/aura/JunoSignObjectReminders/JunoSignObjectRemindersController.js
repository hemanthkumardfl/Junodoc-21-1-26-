({
    doInit: function(component, event, helper) {
        var recordId = component.get("v.recordId");
        //alert('recordId passed');
        var objectApi = component.get("v.ObjectAPIName");
        //alert('recordId ObjectAPIName');
        var action = component.get("c.getExistingReminders");
        //alert('Apex method called');
        action.setParams({ 
                          recordId:recordId });
        //alert('Set Params in ObjectReminders');
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") { 
                component.set("v.existingReminders", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        //alert('Set call back in ObjectReminders');
    },
    
    saveData: function(component, event, helper) {
        var childCmp = component.find("reminderSection");
        if (childCmp) {
            childCmp.saveData();
        }
         //alert('Save data method in ObjectReminders');
    }
});
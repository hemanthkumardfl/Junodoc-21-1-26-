({
    doInit: function(component, event, helper) {
        var objectApiName = component.get("v.ObjectAPIName");
        
        if (!objectApiName) {
            var emptyReminders = [{
                selectedBeforeDays: false,
                customDay: null,
                selectedDays: [],
                selectedRecurringDay: false,
                customRecurringDay: null,
                selectedRecurringDays: []
            }];
            component.set("v.reminderData", emptyReminders);
            return;
        }

        var action = component.get("c.getExistingReminders");
        action.setParams({ objectApiName: objectApiName });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var existingReminders = response.getReturnValue();

                if (!existingReminders || existingReminders.length === 0) {
                    component.set("v.reminderData", [{
                        selectedBeforeDays: false,
                        customDay: null,
                        selectedDays: [],
                        selectedRecurringDay: false,
                        customRecurringDay: null,
                        selectedRecurringDays: []
                    }]);
                    alert('reminderData',emptyReminders);
                    return;
                }

                var beforeDays = [];
                var everyDays = [];

                existingReminders.forEach(function(rec) {
                    if (rec.JunoDoc__Reminder__c === 'Before') {
                        beforeDays.push(String(rec.JunoDoc__Reminder_Day__c));
                    } else if (rec.JunoDoc__Reminder__c === 'Every') {
                        everyDays.push(String(rec.JunoDoc__Reminder_Day__c));
                    }
                });

                var processedData = [{
                    selectedBeforeDays: beforeDays.length > 0,
                    customDay: null,
                    selectedDays: beforeDays,
                    selectedRecurringDay: everyDays.length > 0,
                    customRecurringDay: null,
                    selectedRecurringDays: everyDays
                }];

                component.set("v.reminderData", processedData);
            } else {
                console.error("Failed to retrieve reminders: ", response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    saveData: function(component, event, helper) {
        //alert('Entered SaveData method');
        var objectApiName = component.get("v.ObjectAPIName");
         //alert('objectApiName',objectApiName);
        
        if (!objectApiName) {
            //alert('ObjectAPIName is missing. Cannot save.');
            return;
        }

        var reminderData = component.get("v.reminderData");
        //alert('reminderData',reminderData);
        var remindersToSave = [];

        reminderData.forEach(function(rule) {
            if (rule.selectedDays && rule.selectedDays.length > 0) {
                rule.selectedDays.forEach(function(day) {
                    remindersToSave.push({
                        JunoDoc__Reminder_Day__c: day,
                        JunoDoc__Recurring_Days__c :day,
                        JunoDoc__Reminder__c: 'Before',
                        JunoDoc__JunoSignObjectAPIName__c: objectApiName
                    });
                });
                //alert('Before saved');
            }
            if (rule.selectedRecurringDays && rule.selectedRecurringDays.length > 0) {
                rule.selectedRecurringDays.forEach(function(day) {
                    remindersToSave.push({
                        JunoDoc__Reminder_Day__c: day,
                        JunoDoc__Recurring_Days__c :day,
                        JunoDoc__Reminder__c: 'Every',
                        JunoDoc__JunoSignObjectAPIName__c: objectApiName
                    });
                });
                //alert('every saved');
            }
        });
           
        var action = component.get("c.saveReminders");
       //alert('set params called');
        action.setParams({
            objectApiName: objectApiName,
            remindersJson: JSON.stringify(remindersToSave)
        });
         //alert('set Call back called');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Reminders saved successfully.");
            } else {
                console.error("Error saving reminders: ", response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    addRow: function(component, event, helper) {
        var rows = component.get("v.reminderData");
        rows.push({
            selectedBeforeDays: false,
            customDay: null,
            selectedDays: [],
            selectedRecurringDay: false,
            customRecurringDay: null,
            selectedRecurringDays: []
        });
        component.set("v.reminderData", rows);
    },

    deleteRow: function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var rows = component.get("v.reminderData");
        rows.splice(index, 1);
        component.set("v.reminderData", rows);
    },

    handleRecurrenceBeforeDayChange: function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        data[index].selectedBeforeDays = event.getSource().get("v.checked");
        component.set("v.reminderData", data);
    },

    handleAddDay: function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        var inputCmp = component.find("customDayInput");
        let inputValue = Array.isArray(inputCmp) ? inputCmp[index].get("v.value") : inputCmp.get("v.value");
        if (inputValue && !data[index].selectedDays.includes(inputValue)) {
            data[index].selectedDays.push(inputValue);
        }
        data[index].customDay = '';
        component.set("v.reminderData", data);
    },

    removeDay: function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var dayToRemove = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        data[index].selectedDays = data[index].selectedDays.filter(day => day != dayToRemove);
        component.set("v.reminderData", data);
    },

    handleRecurrenceRecurringDaysChange: function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        data[index].selectedRecurringDay = event.getSource().get("v.checked");
        component.set("v.reminderData", data);
    },

    handleRecurringAddDays: function(component, event, helper) {
        var index = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        var inputCmp = component.find("RecurringDayInput");
        let inputValue = Array.isArray(inputCmp) ? inputCmp[index].get("v.value") : inputCmp.get("v.value");
        if (inputValue && !data[index].selectedRecurringDays.includes(inputValue)) {
            data[index].selectedRecurringDays.push(inputValue);
        }
        data[index].customRecurringDay = '';
        component.set("v.reminderData", data);
    },

    removeRecurringDays: function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var dayToRemove = event.getSource().get("v.value");
        var data = component.get("v.reminderData");
        data[index].selectedRecurringDays = data[index].selectedRecurringDays.filter(day => day != dayToRemove);
        component.set("v.reminderData", data);
    }
});
({
    processExistingReminders: function(component, existingReminders) {
        if (!existingReminders || existingReminders.length === 0) {
            this.initializeEmptyRule(component);
            return;
        }

        var beforeDays = [];
        var everyDays = [];

        existingReminders.forEach(function(rec) {
            if (rec.JunoDoc__Reminder_Type__c === 'Before') {
                beforeDays.push(String(rec.JunoDoc__Reminder_Day__c));
            } else if (rec.JunoDoc__Reminder_Type__c === 'Every') {
                everyDays.push(String(rec.JunoDoc__Reminder_Day__c));
            }
        });
        
        var reminderData = [{
            selectedBeforeDays: beforeDays.length > 0,
            customDay: null,
            selectedDays: beforeDays,
            selectedRecurringDay: everyDays.length > 0,
            customRecurringDay: null,
            selectedRecurringDays: everyDays
        }];

        component.set("v.reminderData", reminderData);
    },

    initializeEmptyRule: function(component) {
        var reminders = [{
            selectedBeforeDays: false,
            customDay: null,
            selectedDays: [],
            selectedRecurringDay: false,
            customRecurringDay: null,
            selectedRecurringDays: []
        }];
        component.set("v.reminderData", reminders);
    }
})
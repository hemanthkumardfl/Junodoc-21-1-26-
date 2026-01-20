({
    doInit: function(component, event, helper) {
        var getExistingRecordsAction = component.get("c.getExistingRecords");
        getExistingRecordsAction.setParams({
            recordId: component.get("v.recordId")
        });
        
        getExistingRecordsAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var existingRecords = response.getReturnValue();
                var records = response.getReturnValue();
                component.set("v.rows", response.getReturnValue());
                for (var i = 0; i < records.length; i++) {
                    let record = records[i];
                    let row = record || {};
                    
                    row.fieldName = record.fieldName;
                    row.fieldType = (record.fieldType == "reference") ? "reference" : record.fieldType;
                    row.fieldDetail = JSON.parse(record.fieldDetail);
                    if (record.fieldType == "reference") {
                        row.isReference = true;
                        row.objectName = record.fieldDetail.referenceTo[0];
                        row.isPicklist = false;
                        row.iscurrency = false;
                        row.isboolean = false;
                        row.isstring = false;
                        row.isdate = false;
                    } else if (record.fieldType == "picklist") {
                        row.isPicklist = true;
                        row.isReference = false;
                        row.iscurrency = false;
                        row.isboolean = false;
                        row.isstring = false;
                        row.isdate = false;
                        row.picklistvalues = record.fieldDetail.picklistValues;
                    } else if (record.fieldType == "currency") {
                        row.iscurrency = true;
                        row.isReference = false;
                        row.isPicklist = false;
                        row.isboolean = false;
                        row.isstring = false;
                        row.isdate = false;
                    } else if (record.fieldType == "boolean") {
                        row.fieldValue = record.fieldValue == 'true' ? true : false;
                        row.isboolean = true;
                        row.isReference = false;
                        row.iscurrency = false;
                        row.isPicklist = false;
                        row.isstring = false;
                        row.isdate = false;
                        row.booleanvalues = [{ label: 'true', value: true }, { label: 'false', value: false }];
                    } else if (record.fieldType == "string") {
                        row.isstring = true;
                        row.isReference = false;
                        row.isPicklist = false;
                        row.iscurrency = false;
                        row.isboolean = false;
                        row.isdate = false;
                    } else if (record.fieldType == "date") {
                        row.isdate = true;
                        row.isstring = false;
                        row.isReference = false;
                        row.isPicklist = false;
                        row.iscurrency = false;
                        row.isboolean = false;
                    }
                    
                    records[i] = row;
                }
                component.set("v.rows", records);
                console.log("Existing records retrieved successfully:", existingRecords);
                component.set("v.rows", existingRecords);
            } else {
                console.error("Failed to retrieve existing records:", response.getError());
            }
        });

        var getObjectFieldsAction = component.get("c.getObjectFields");
        getObjectFieldsAction.setParams({
            recordId: component.get("v.recordId")
        });

        getObjectFieldsAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fields = response.getReturnValue();
                console.log("Object fields retrieved successfully:", fields);
                component.set("v.showPostActions", true);
                component.set("v.fieldOptions", fields);
            } else {
                console.error("Error fetching fields:", response.getError());
            }
        });

        $A.enqueueAction(getExistingRecordsAction);
        $A.enqueueAction(getObjectFieldsAction);
    },

    addRow: function(component, event, helper) {
        var rows = component.get("v.rows");
        let AllFields = component.get("v.fieldOptions");
        let selectedFieldsList = [];
        for(let record of rows) {
            if(record.fieldName) {
                selectedFieldsList.push(record.fieldName);
            }
        }
        AllFields = AllFields.filter(ele => {
            if(!selectedFieldsList.includes(ele.value)) {
                return ele;
            }
        });
        
        rows.push({ 
            fieldName: '',
            fieldValue: '',
            fieldType: '',
            fieldList: AllFields,
            isReference: false,
            objectName: '',
            picklistvalues: [],
            isPicklist: false,
            iscurrency: false,
            isboolean: false,
            isdate: false,
            isstring: false
        });
        component.set("v.rows", rows);
    },

    deleteRow: function(component, event, helper) {
        var index = event.getSource().get("v.name");
        var rows = component.get("v.rows");
        rows.splice(index, 1);
        component.set("v.rows", rows);
    },

    handlePostField: function(component, event, helper) {
        let field = event.target.value; // Use event.target.value for <select>
        let index = event.target.getAttribute('data-index'); // Use data-index attribute
        let filteredOptions;
        var action = component.get("c.getFieldValue");
        action.setParams({ recordId: component.get("v.recordId"), fieldName: field });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let data = JSON.parse(response.getReturnValue());
                let rows = component.get("v.rows");
                rows[index].fieldName = field;
                rows[index].fieldType = (data.type == "reference") ? "reference" : data.type;
                if(data.type == "reference") {
                    rows[index].isReference = true;
                    rows[index].objectName = data.referenceTo[0];
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                } else if(data.type == "picklist") {
                    rows[index].isPicklist = true;
                    rows[index].isReference = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                    rows[index].picklistvalues = data.picklistValues;
                } else if(data.type == "currency") {
                    rows[index].iscurrency = true;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                } else if(data.type == "boolean") {
                    rows[index].isboolean = true;
                    rows[index].isReference = false;
                    rows[index].iscurrency = false;
                    rows[index].isPicklist = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                    rows[index].booleanvalues = [{label: 'true', value: true}, {label: 'false', value: false}];
                } else if(data.type == "string") {
                    rows[index].isstring = true;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isdate = false;
                } else if(data.type == "date") {
                    rows[index].isdate = true;
                    rows[index].isstring = false;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                }
                component.set("v.rows", rows);
            } else if (state === "INCOMPLETE") {
                console.log('Pending');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    handlePicklistValues: function(component, event, helper) {
        var index = event.target.getAttribute('data-index');
        var selectedValue = event.target.value;
        var rows = component.get("v.rows");
        rows[index].fieldValue = selectedValue;
        component.set("v.rows", rows);
    },

    handlebooleanValues: function(component, event, helper) {
        try {
            var index = event.target.getAttribute('data-index');
            var selectedValue = event.target.value;
            var rows = component.get("v.rows");
            rows[index].fieldValue = (selectedValue === 'true');
            component.set("v.rows", rows);
        } catch(error) {
            console.clear();
            console.log(error.stack);
        }
    },

    sendDataToParent: function(component, event, helper) {
        let rows = component.get("v.rows");
        for(let data of rows) {
            data.fieldDetail = JSON.stringify(data.fieldDetail);
        }
        component.set("v.rows", rows);
        console.log('test111111111' + JSON.stringify(component.get("v.rows")));
        var action = component.get("c.updateRecord");
        action.setParams({ 
            recordId: component.get("v.recordId"),
            rows: JSON.stringify(component.get("v.rows"))
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var insertedIds = response.getReturnValue();
                console.log("Inserted IDs: " + JSON.stringify(insertedIds));
                var insertedIdsEvent = component.getEvent("passInsertedIds");
                insertedIdsEvent.setParams({ "insertedIds": insertedIds });
                insertedIdsEvent.fire();
                console.log('Completed Child Method');
            } else if (state === "INCOMPLETE") {
                console.log("Incomplete error");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleRowsUpdate: function(component, event, helper) {
        var rows = component.get("v.rows");
        var updateEvent = component.getEvent("rowsUpdated");
        updateEvent.setParams({
            "rowsData": rows
        });
        updateEvent.fire();
    }
})
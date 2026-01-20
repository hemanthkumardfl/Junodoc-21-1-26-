({
    doInit: function(component, event, helper) {
        debugger;
        var gefields = component.get("c.getObjectFields");
        console.log(component.get("v.ObjectAPIName"))
        gefields.setParams({
            objectApiName: component.get("v.ObjectAPIName")
            
        });
        gefields.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showPostActions", true);
                component.set("v.fieldOptions", response.getReturnValue());
            } else {
                console.error("Error fetching fields: " + response.getError());
            }
        });
        $A.enqueueAction(gefields);
        
        // Fetch existing records for the ObjectAPIName
        var getRecords = component.get("c.getExistingRecords");
        getRecords.setParams({
            ObjectAPIName: component.get("v.ObjectAPIName")
        });
        getRecords.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set("v.rows", response.getReturnValue());
                for (var i = 0; i < records.length; i++) {
                    let record = records[i];
                    let row = record || {}; // Assuming rows is prepopulated with objects, or create a new one
                    
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
                    } 
                    else if (record.fieldType == "picklist") {
                        row.isPicklist = true;
                        row.isReference = false;
                        row.iscurrency = false;
                        row.isboolean = false;
                        row.isstring = false;
                        row.isdate = false;
                        row.picklistvalues = record.fieldDetail.picklistValues;
                    } 
                        else if (record.fieldType == "currency") {
                           // alert( record.fieldValue)
                            row.iscurrency = true;
                            row.isReference = false;
                            row.isPicklist = false;
                            row.isboolean = false;
                            row.isstring = false;
                            row.isdate = false;
                        } 
                            else if (record.fieldType == "boolean") {
                               // alert(record.fieldValue)
                                row.fieldValue = record.fieldValue =='true' ? true : false;
                                row.isboolean = true;
                                row.isReference = false;
                                row.iscurrency = false;
                                row.isPicklist = false;
                                row.isstring = false;
                                row.isdate = false;
                                row.booleanvalues = [{ label: 'true', value: true }, { label: 'false', value: false }];
                            } 
                                else if (record.fieldType == "string") {
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
                    
                    // Update the rows array with the modified row
                    records[i] = row;
                }
                
                // After the loop, set the updated rows back to the component
                component.set("v.rows", records);
                
                
                console.log("Rows>>>>>>>>>>>>>>>>>"+ JSON.stringify(component.get("v.rows")))
                console.log("Existing records: ", response.getReturnValue());
            } else {
                console.error("Error fetching records: " + response.getError());
            }
        });
        $A.enqueueAction(getRecords);
    },
    
    
    addRow : function(component, event, helper) {
        var rows = component.get("v.rows");
        let AllFields = component.get("v.fieldOptions");
        let selectedFieldsList = [];
        for(let record of rows){
            if(record.fieldName)
                selectedFieldsList.push(record.fieldName);
        }
        AllFields = AllFields.filter(ele =>{
            if(!selectedFieldsList.includes(ele.value))
            return ele;
        });
        
        rows.push({ fieldName: '',
                   fieldValue: '',
                   fieldType : '',
                   fieldList : AllFields,
                   isReference : false ,
                   objectName : '',
                   picklistvalues : [],
                   isPicklist :false,
                   iscurrency :false,
                   isboolean : false,
                   isdate : false,
                   isstring: false});
        component.set("v.rows", rows);
    },   
    
    deleteRow : function(component, event, helper) {
        // var auraId = event.getSource().get("v.name");
        var index = event.getSource().get("v.name")
        //alert( index)
        var rows = component.get("v.rows");
        rows.splice(index, 1);
        component.set("v.rows", rows);
        /* var index = event.getSource().get("v.dataset").index;
        
        // Remove the row at the specified index
        var rows = component.get("v.rows");
        rows.splice(index, 1);
        component.set("v.rows", rows);*/
    },
    
    
    handlePostField : function(component, event, helper) {
        debugger;
        let field = event.getSource().get("v.value");
        let index = event.getSource().get("v.title");
        let filteredOptions;
        var action = component.get("c.getFieldValue");
        action.setParams({ objectApiName : component.get("v.ObjectAPIName"), fieldName : field});
        //alert('ObjectAPIName>>>>>>>>>>>>>>>'+ObjectAPIName);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let data = JSON.parse(response.getReturnValue())
                
                let rows = component.get("v.rows");
                rows[index].fieldName = field;
                rows[index].fieldType = (data.type == "reference") ? "reference" : data.type;
                if(data.type == "reference"){
                    rows[index].isReference = true;
                    rows[index].objectName = data.referenceTo[0];
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                }else if(data.type == "picklist"){
                    rows[index].isPicklist = true;
                    rows[index].isReference = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                    rows[index].picklistvalues = data.picklistValues;
                }else if(data.type == "currency"){
                    rows[index].iscurrency = true;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].isboolean = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                }else if(data.type == "boolean"){
                    
                    rows[index].isboolean = true;
                    rows[index].isReference = false;
                    rows[index].iscurrency = false;
                    rows[index].isPicklist = false;
                    rows[index].isstring = false;
                    rows[index].isdate = false;
                    rows[index].booleanvalues = data.booleanvalues;
                    rows[index].booleanvalues = [{label : 'true',value : true},{label : 'false',value : false}];
                }else if(data.type == "string"){
                    rows[index].isstring = true;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                    rows[index].isdate = false;
                }else if(data.type == "date"){
                    rows[index].isdate = true;
                    rows[index].isstring = false;
                    rows[index].isReference = false;
                    rows[index].isPicklist = false;
                    rows[index].iscurrency = false;
                    rows[index].isboolean = false;
                }
                
                component.set("v.rows",rows);
            }
            else if (state === "INCOMPLETE") {
                console.log('Pending');
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    handlePicklistValues  : function(component, event, helper) {
        var index = event.getSource().get("v.title");
        var selectedValue = event.getSource().get("v.value");
        var rows = component.get("v.rows");
        rows[index].fieldValue = selectedValue;
        component.set("v.rows", rows);
    },
    handlebooleanValues  : function(component, event, helper) {
        try{
            debugger;
            console.clear();
            var index =event.getSource().get("v.title");
            var selectedValue = event.getSource().get("v.value");
            var rows = component.get("v.rows");
            rows[index].fieldValue = (selectedValue == 'true');
            component.set("v.rows", rows);
        }
        catch(error){
            console.log(error.stack);
        }
    },
    
    sendDataToParent : function(component, event, helper) {
        var action = component.get("c.updateRecord");
        console.log(component.get("v.ObjectAPIName"))
        console.log('tttttttttttttt'+JSON.stringify(component.get("v.rows")))
        action.setParams({  ObjectAPIName : component.get("v.ObjectAPIName"),
                          rows: JSON.stringify(component.get("v.rows"))
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
            }
            else if (state === "INCOMPLETE") {
                console.log("Incomplete error");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
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
        
        // Get the event instance using the registered name
        var updateEvent = component.getEvent("rowsUpdated");
        
        // Set parameters for the event
        updateEvent.setParams({
            "rowsData": rows
        });
        
        // Fire the event
        updateEvent.fire();
    }
    
})
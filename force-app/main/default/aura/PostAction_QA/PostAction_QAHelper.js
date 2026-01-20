({
    validateAccountRecords: function(component, event) {
        //Validate all account records
        var isValid = true;
        var docList = component.get("v.docList");
        for (var i = 0; i < docList.length; i++) {
            if (docList[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on '+(i + 1)+' row number');
            }
        }
        return isValid;
    },
    
})
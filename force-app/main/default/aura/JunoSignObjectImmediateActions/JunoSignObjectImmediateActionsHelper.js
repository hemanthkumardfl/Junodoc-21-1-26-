({
    fetchFieldOptions: function(component) {
        // Simulated field options (replace with actual server-side call if needed)
        var fieldOptions = [
            { label: 'Owner Id', value: 'OwnerId' },
            { label: 'Quote Name', value: 'QuoteName' },
            { label: 'Price Book Id', value: 'PriceBookId' },
            { label: 'Contact Id', value: 'ContactId' },
            { label: 'Shipping and Handling', value: 'ShippingAndHandling' },
            { label: 'Tax', value: 'Tax' },
            { label: 'Status', value: 'Status' },
            { label: 'Expiration Date', value: 'ExpirationDate' },
            { label: 'Description', value: 'Description' },
            { label: 'Bill To Street', value: 'BillToStreet' },
            { label: 'Bill To City', value: 'BillToCity' }
            // Add more fields as needed
        ];
        component.set('v.fieldOptions', fieldOptions);
    },

    updateFieldType: function(component, index, fieldName) {
        var rows = component.get('v.rows');
        if (!rows[index]) return;

        // Reset all type flags
        rows[index].isReference = false;
        rows[index].isPicklist = false;
        rows[index].iscurrency = false;
        rows[index].isboolean = false;
        rows[index].isstring = false;
        rows[index].isdate = false;

        // Determine the field type based on fieldName
        // This is a simplified example; replace with actual logic or metadata
        if (fieldName === 'OwnerId' || fieldName === 'ContactId') {
            rows[index].isReference = true;
            rows[index].objectName = fieldName === 'OwnerId' ? 'User' : 'Contact'; // Example
        } else if (fieldName === 'Status' || fieldName === 'Description') {
            rows[index].isPicklist = true;
            rows[index].picklistvalues = [
                { label: 'Presented', value: 'Presented' },
                { label: 'In Review', value: 'InReview' },
                { label: 'Approved', value: 'Approved' },
                { label: 'Rejected', value: 'Rejected' },
                { label: 'Closed', value: 'Closed' },
                { label: 'Test', value: 'Test' }
            ];
        } else if (fieldName === 'ShippingAndHandling' || fieldName === 'Tax') {
            rows[index].iscurrency = true;
        } else if (fieldName === 'IsActive') { // Example boolean field
            rows[index].isboolean = true;
            rows[index].booleanvalues = [
                { label: 'True', value: 'true' },
                { label: 'False', value: 'false' }
            ];
        } else if (fieldName === 'ExpirationDate') {
            rows[index].isdate = true;
        } else {
            rows[index].isstring = true; // Default to string for fields like QuoteName, BillToStreet, etc.
        }

        component.set('v.rows', rows);
    }
})
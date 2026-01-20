import { LightningElement,api,track } from 'lwc';
import getScheduleConditions from '@salesforce/apex/ScheduleActions.getScheduleConditions';
export default class junoDocScheduleGetFields extends LightningElement {
@track searchFieldsList = [];
@track showSearchFields = false;
@track ObjectLabel = '';
@track SalesforceObj='';    
@api ObjectFieldsWrapper=[];
@api objName;
@api indexNumber;
@track indexValue = '';
@api SchName;
@api fieldValue;
@api fieldLabel;
@track ShowFields = false;
@api schConditionsWrap;

connectedCallback() {
    this.isLoaded = true;
    console.log('name---->'+this.objName);
    console.log('fieldval----->'+this.fieldValue);
    //var fieldval = this.fieldValue;
    this.SalesforceObj = this.objName;
    this.indexValue = this.indexNumber;
    this.fetchSelectedObjectDataHelper(this.SalesforceObj);
    //this.getFieldLabel(fieldval);
}
/*handleChangeFields(event){
    alert('1111111111111111111111');
    this.searchFieldsList = [];
    
    var filter = event.target.value.toUpperCase();
    alert('filter>>>>>>>>>>>>>>>>>'+filter);
    for (var i = 0; i < this.ObjectFieldsWrapper.length; i++) {
        var txtValue = this.ObjectFieldsWrapper[i].label+this.ObjectFieldsWrapper[i].value;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            this.searchFieldsList.push({
                label:this.ObjectFieldsWrapper[i].label,
                value:this.ObjectFieldsWrapper[i].value}
            );
        }  
    }
    
    if(this.searchFieldsList.length>0){
        this.ShowFields = true;            
    }else{
        this.ShowFields = false;
    }

    

    

}*/
handleChangeFields(event) {
    alert(event.target.value)
    const filter = event.target.value.toUpperCase(); // Get the user input
    this.searchFieldsList = []; // Clear the previous list
    
    this.ObjectFieldsWrapper.forEach((field) => {
        const fieldText = `${field.label} ${field.value}`.toUpperCase();
        if (fieldText.includes(filter)) {
            this.searchFieldsList.push({ label: field.label, value: field.value });
        }
    });

    // Show or hide fields based on search result
    this.ShowFields = this.searchFieldsList.length > 0;
}

fetchSelectedObjectDataHelper(actionObject){
    this.isLoaded = true;
    /*var isSearch=false;
    for(var i=0;i<this.ObjectsList.length;i++){
        if(actionObject==this.ObjectsList[i].value){
            this.ObjectLabel = this.ObjectsList[i].label;
            isSearch = true;
            break;
        }
    }*/

    console.log('schedule action--->'+actionObject);

    //if(isSearch){
        getScheduleConditions({ ObjectName : actionObject, ScheduleName : this.SchName} )
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                console.log('result---->'+result);
                this.isLoaded = false;
                /*this.selectedEmailFieldsMultiPicklistValues = [];
                this.selectedUserEmailsList = [];
                this.selectedContactEmailsList = [];
                
                this.SalesforceObject = actionObject; 
                this.EmailFieldsMultiPicklist = result.EmailFields;
                this.AvailableDocTemplatesList = result.AvailableDocTemplatesList; 
                this.StandardEmailTemplatesList = result.StandardEmailTemplatesList;
                this.JunoDocEmailTemplatesList = result.JunoDocEmailTemplatesList;*/
                this.ObjectFieldsWrapper = result.ObjectFieldsWrapper; 
                var fieldval = this.fieldValue;
        this.getFieldLabel(fieldval);               
            }
        
        })
        .catch(error => {
            this.isLoaded = false;
            this.message = undefined;
            this.error = error;
            console.log('error'+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while fetching fields',
                    message: this.error,
                    variant: 'error'
                })
            );
        });

    //}else{
        this.isLoaded = false;
        
    //}

}
handleOnClickFields(event){
    this.ShowFields = false;
    
    var searchField = event.currentTarget.dataset.item;
    for (var i = 0; i < this.ObjectFieldsWrapper.length; i++) {           
        if (searchField == this.ObjectFieldsWrapper[i].value) {
            this.fieldValue = this.ObjectFieldsWrapper[i].value;
            this.fieldLabel = this.ObjectFieldsWrapper[i].label;
            break;                
        }
    }

    var Fieldlist = [];
    Fieldlist.push({
        fieldValue:this.fieldValue,
        indx:this.indexValue,
        eventType:'Field'
    });
    
    const selectedEvent = new CustomEvent("getfielddetails", {
        detail:Fieldlist
    });
    console.log('Fieldlist----->'+JSON.stringify(Fieldlist));
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);

}
getFieldLabel(fieldVal){
    console.log('fieldVal112---->'+fieldVal);
    for (var i = 0; i < this.ObjectFieldsWrapper.length; i++) {           
        if (fieldVal == this.ObjectFieldsWrapper[i].value) {
            console.log('fieldVal114---->'+this.ObjectFieldsWrapper[i].value);
            //this.fieldValue = this.ObjectFieldsWrapper[i].value;
            this.fieldLabel = this.ObjectFieldsWrapper[i].label;
            break;                
        }
    }

    
}
}
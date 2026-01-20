import { LightningElement,api,track } from 'lwc';
import TriggerActionsTabClick from '@salesforce/apex/TriggerActions.TriggerActionsTabClick';
import getTriggerAction from '@salesforce/apex/TriggerActions.getTriggerAction';
import getSelectedPicklistValues from '@salesforce/apex/TriggerActions.getSelectedPicklistValues';
import saveTriggerActionConditions from '@salesforce/apex/TriggerActions.saveTriggerActionConditions';
import saveTriggerAction from '@salesforce/apex/TriggerActions.saveTriggerAction';
import savePostTriggerActions from '@salesforce/apex/TriggerActions.savePostTriggerActions';
import deleteJunoDocTrigger from '@salesforce/apex/TriggerActions.deleteJunoDocTrigger';
import updateTriggerStatus from '@salesforce/apex/TriggerActions.updateTriggerStatus';
import updateRecurringTrigger from '@salesforce/apex/TriggerActions.updateRecurringTrigger';
import getJunodocObjectsettings from '@salesforce/apex/TriggerActions.getJunodocObjectsettings';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class JunoDocTriggerActions extends LightningElement {

    activeSections = ['A','B','C','D','S'];
    @api addEmailRecipientsList = [];
    @api showRecips = false;
    @track isLoaded = false;
    @track isDialogVisible = false;
    @track originalMessage;
    @track displayMessage = 'Click on the \'Open Confirmation\' button to test the dialog.';
    @track ConfirmationAlertMsg='';
    @track ObjectLabel = '';
    @track searchKey = '';
    @track searchObjectsList = [];
    @track showSearchObjects = false;
    @track ShowHomeScreen = false;
    @track ShowObjectDetails = false;
    @track selectedStep = '';
    @track DupeselectedStep = '';
    @track searchFieldsList = [];
    @track showSearchFields = false;
    @track savedbutton = false;
    @track SalesforceObject='';    
    @api ObjectFieldsWrapper=[];
    @api OperatorOptions=[{label:'Equals',value:'Equals'},
    {label:'Not Equal to',value:'Not Equal to'},
    {label:'Contains',value:'Contains'},
    {label:'Does not contain',value:'Does not contain'},
    {label:'Greater than',value:'Greater than'},
    {label:'Less than',value:'Less than'},
    {label:'Greater or equal',value:'Greater or equal'},
    {label:'Less or equal',value:'Less or equal'}
    ];
    @track TriggerConditionsWrapper=[];
    @track showActivateButton=false;
    @track showDeactiveButton=false;
    @track filterConditionsValue='';
    @track TriggerActionsList=[];
    @track TriggerActionKeyIndex=0; 
    @track createNewTriggerAction=false;
    @track showTriggerActions=true;
    @track triggerName='';
    @track disableTriggerName = false;
    @track ObjectsList=[];

    @track openPicklistModal = false;
    @track pickListValuesList = [];
    @track selectedPicklistLabel = '';
    @api booleanOptions=[
         {label:'true',value:'true'},
         {label:'false',value:'false'}
     ];
 
    @track EmailAddresses='';
    @track FromEmailAddress ='';
    @track EmailFields='';
    @track OrgwideEmailAddressList=[];
    @api EmailFieldsMultiPicklist=[];
    @api AvailableDocTemplatesList=[];
    @track AvailableDocTemplate = '';
    @api StandardEmailTemplatesList=[];
    @track StandardEmailTemplate='';
    @api JunoDocEmailTemplatesList=[];
    @track JunoDocEmailTemplate='';
    @track SaveAsActivity = true;
    @track SetReplyTo = '';
    @track SetSenderDisplayName='';

    @track PostTriggerActionsWrapper=[];
    @track showTriggerConditions = false;
    @track showTriggerAction = false; 
    @track showPostTriggerActions = false;
    @track showTriggerConditionsNextButton = false;
    @track showTriggerActionNextButton = false;
    @track EmailSubject = '';
    @track UserEmailsList=[];
    @track ContactEmailsList=[];
    @track selectedUserEmailsList=[];
    @track selectedContactEmailsList=[];

    connectedCallback() {
        this.isLoaded = true;
        this.ShowHomeScreen = true;
        this.fetchAvailableTriggerActionsDataHelper();
    }
        

    selectStep1() {
        console.log('this.selectedStep--167---->'+this.selectedStep);
        //
        this.DupeselectedStep ='';
       setTimeout(() => {
        console.log('s1'+this.isLoaded);
        this.isLoaded = false;
        this.DupeselectedStep = this.selectedStep;
    }, 800);
    //this.DupeselectedStep = this.selectedStep;
        //this.ShowObjectDetails = true;
    }
    
    selectStep2() {
        console.log('this.selectedStep--174---->'+this.selectedStep);
          //  
         this.DupeselectedStep ='';
       setTimeout(() => {
        console.log('s2'+this.isLoaded);
        //this.DupeselectedStep = this.selectedStep;
        this.isLoaded = false;
        this.DupeselectedStep = this.selectedStep;
    }, 800);
    //this.DupeselectedStep = this.selectedStep;    
        //this.showScheduleConditions = true;
    }
    
    selectStep3() {
        console.log('this.selectedStep--181--->'+this.selectedStep);
       // this.DupeselectedStep = this.selectedStep;
       this.DupeselectedStep ='';
       setTimeout(() => {
        console.log('s3'+this.isLoaded);
        //this.DupeselectedStep = this.selectedStep;
        this.isLoaded = false;
        this.DupeselectedStep = this.selectedStep;
    }, 1500);
    //this.DupeselectedStep = this.selectedStep;
        
       
    }
    
    selectStep4() {
        console.log('this.selectedStep--194--->'+this.selectedStep);
       // this.DupeselectedStep = this.selectedStep;
       this.DupeselectedStep ='';
       setTimeout(() => {
        console.log('s4'+this.isLoaded);
       // this.DupeselectedStep = this.selectedStep;
        this.isLoaded = false;
        this.DupeselectedStep = this.selectedStep;
    }, 1500);
    //this.DupeselectedStep = this.selectedStep;
       
    }
    

    handleProgress(event){
        console.log('Progress'+event.target.value);
        if(event.target.value=='Step1'){
            console.log('1');
            this.selectedStep = 'Step1';
            //this.DupeselectedStep = this.selectedStep;
            this.ShowObjectDetails = true;
            this.showTriggerConditions = false;
            this.showTriggerAction = false;
            this.ShowTriggerSetUp = false;
            this.showPostTriggerActions = false;

        }
        else if(event.target.value == 'Step2'){
            //this.selectedStep = 'Step2';
            if(this.createNewTriggerAction == true){
                console.log('2');
                
                this.handleNewTriggerNext();
                console.log('selectedStep--220--->'+this.selectedStep);
            }
            else{
                this.fetchTriggerActionHelper(this.SalesforceObject,this.triggerName);
                console.log('3');
             
            }
                
                
        }
        else if(event.target.value == 'Step3'){
            if(this.showTriggerConditions == true){
                console.log('4');
                this.handleTriggerConditionsSave();
                console.log('selectedStep--238--->'+this.selectedStep);
            }
            else if(this.showTriggerConditions == false){
                if(this.ShowObjectDetails==true){ 
                console.log('5');
                this.handleNewTriggerNext();
                console.log('selectedStep--243--->'+this.selectedStep);
                }
                else if(this.showPostTriggerActions == true){
                    console.log('6');
                    this.selectedStep = 'Step3';
                    this.showPostTriggerActions = false;
                            this.showTriggerConditions = false;
                            this.showTriggerAction = true;
                }
                
                //this.selectedStep = 'Step2';
            }
            
        
        
        }
        
        else if(event.target.value == 'Step4'){
            if(this.showTriggerAction == true){
                console.log('10');
                this.handleTriggerActionSave();
                console.log('selectedStep--286--->'+this.selectedStep);
                }
            else if(this.showTriggerAction == false){
                console.log('11');
                if(this.ShowObjectDetails == true){
                    this.handleNewTriggerNext();
                    console.log('selectedStep--292--->'+this.selectedStep);
                }
                else if(this.showTriggerConditions == true){
                    if(this.createNewTriggerAction == true){
                        this.handleTriggerConditionsSave();
                        }
                        else{
                            this.selectedStep = 'Step4';
                            this.showTriggerConditions = false;
                            this.showTriggerAction = false;
                            this.showPostTriggerActions = true;
                          
                        }
                
                console.log('selectedStep--296--->'+this.selectedStep);
                }
               /* else if(this.showScheduleAction == true){
                    if(this.createNewScheduleAction == true){
                        this.handleScheduleActionSave();
                        }
                        else{
                            this.getPostSchActions();
                            
                        }
                    
                    console.log('selectedStep--300--->'+this.selectedStep);
                }*/
                //this.selectedStep = 'Step4';
            }
        }
        console.log('this.selectedStep'+this.selectedStep);
    }

    fetchAvailableTriggerActionsDataHelper(){
        console.log('trigger actions');
        this.isLoaded = true;

        TriggerActionsTabClick()
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                this.isLoaded = false;
                this.showTriggerActions = true;
                console.log('result---->'+result);
                this.ObjectsList = result.ObjectsList;
                this.TriggerActionsList = result.TriggerActionsList;
                console.log('objects list--->'+result.ObjectsList);
                console.log(result.TriggerActionsList);
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
    }
    
    handleToggleSection(event) {

        console.log( 'Selected Sections ' + event.detail.openSections );

    }

    handleCreateNewTriggerAction(){
        this.ShowHomeScreen = false;
        this.selectedStep = 'Step1';
        this.ShowObjectDetails = true;
        this.createNewTriggerAction = true;
        this.triggerName = '';
        this.SalesforceObject='';
        this.ObjectLabel = '';
        this.TriggerConditionsWrapper=[];
        this.filterConditionsValue='';
        this.disableTriggerName = false;
    }


    handleBack(event){
        this.createNewTriggerAction = false;
        this.showTriggerActions = true;
        this.getTriggerActionssDataHelper();
    }

    handleTriggerName(event){
        this.triggerName = event.target.value;
        this.showSearchObjects = false;
        this.ObjectLabel = '';
        this.SalesforceObject = '';
    }

    handleTriggerActionEditClick(event){
        this.SalesforceObject = this.TriggerActionsList[event.target.accessKey].JunoDoc__Object_Name__c;
        this.triggerName = this.TriggerActionsList[event.target.accessKey].Name;
        this.showTriggerConditions = true;
        this.fetchTriggerActionHelper(this.SalesforceObject,this.triggerName);
    }

    handleTriggerActionDeleteClick(event){
        this.SalesforceObject = this.TriggerActionsList[event.target.accessKey].JunoDoc__Object_Name__c;
        this.triggerName =  this.TriggerActionsList[event.target.accessKey].Name;
        this.ConfirmationAlertMsg = 'Do you want to delete '+this.triggerName+' ?';
        //alert(this.SalesforceObject);
        this.isDialogVisible = true;
    }


    handleToggleChange(event){
        var TriggerName= this.TriggerActionsList[event.target.accessKey].Name;
        var toogleCheckedValue = event.target.checked;

        console.log('TriggerName--->'+TriggerName);
        console.log('toogleCheckedValue--->'+toogleCheckedValue);

        console.log('test');
        updateTriggerStatus({toogleValue: toogleCheckedValue, 
            TriggerName:TriggerName}
                            )
        .then(result => {
            if(result!=''){
                    this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: result,
                        variant: 'success'
                    })
                ); 

                this.fetchAvailableTriggerActionsDataHelper();
            }          
        })
        .catch(error => {
            console.log('error ****'+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while Updating record',
                    message: 'unable to update the record',
                    variant: 'error'
                })
            );
            this.isLoaded = false;

        });
    

    }

    handleToggleRecurringChange(event){
        var TriggerName= this.TriggerActionsList[event.target.accessKey].Name;
        var toogleCheckedValue = event.target.checked;

        console.log('TriggerName--->'+TriggerName);
        console.log('toogleCheckedValue--->'+toogleCheckedValue);

        console.log('test');
        updateRecurringTrigger({recurringTrigger: toogleCheckedValue, 
            TriggerName:TriggerName}
                            )
        .then(result => {
            if(result!=''){
                    this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: result,
                        variant: 'success'
                    })
                ); 

                this.fetchAvailableTriggerActionsDataHelper();
            }          
        })
        .catch(error => {
            console.log('error ****'+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while Updating record',
                    message: 'unable to update the record',
                    variant: 'error'
                })
            );
            this.isLoaded = false;

        });
    

    }

    ObjectChangeHandler(event){
        this.disableTriggerName = false;
        //this.triggerName = '';
        this.filterConditionsValue = '';        
        var actionObject = event.target.value;
        //alert(event.target.label);
        this.SalesforceObject = actionObject;
        this.fetchTriggerActionHelper(actionObject);
    }

    fetchTriggerActionHelper(actionObject,triggerName){
        this.selectedStep = '';
        this.isLoaded = true;
        var isSearch=false;
        for(var i=0;i<this.ObjectsList.length;i++){
            if(actionObject==this.ObjectsList[i].value){
                this.ObjectLabel = this.ObjectsList[i].label;
                isSearch = true;
                break;
            }
        }

        console.log('trigger action--->'+actionObject);        
        console.log('triggerName--->'+triggerName);

        if(isSearch){
            getTriggerAction({ ObjectName : actionObject,
                TriggerName : triggerName
             } )
            .then((result) =>  {                   
                if(result!==undefined && result!=''){
                    console.log('result---->'+result);
                    this.isLoaded = false;
                    this.ShowHomeScreen = false;
    
    this.selectedStep= 'Step2';
    this.ShowObjectDetails = false;
    this.showSearchFields = false;
    this.showTable = true;
    this.showConditionsTable = true;
    
    this.showTriggerAction = false;
                        this.ShowObjectDetails = false;
                        this.showPostTriggerActions = false;
                        this.showTriggerConditions = true;
                    this.selectedEmailFieldsMultiPicklistValues = [];
                    this.selectedUserEmailsList = [];
                    this.selectedContactEmailsList = [];
                 
                    this.SalesforceObject = actionObject; 
                    this.EmailFieldsMultiPicklist = result.EmailFields;
                    this.AvailableDocTemplatesList = result.AvailableDocTemplatesList; 
                    this.StandardEmailTemplatesList = result.StandardEmailTemplatesList;
                    this.JunoDocEmailTemplatesList = result.JunoDocEmailTemplatesList;
                    this.addEmailRecipientsList = result.AddEmailRecipientsList;
                    this.TriggerConditionsWrapper = result.TriggerConditionsList;
                    this.OrgwideEmailAddressList = result.OrgwideEmailAddressList;

                    if(this.addEmailRecipientsList.length>0){
                        this.showRecips = true;
                    }
                    else{
                        this.showRecips = false;
                    }
                    if(this.TriggerConditionsWrapper.length>0){
                        this.showTriggerConditionsNextButton = true;
                    }
    
    
                    this.ObjectFieldsWrapper = result.ObjectFieldsWrapper;
                    console.log('JunoDocTriggerRec---->'+result.JunoDocTriggerRec);
                    if(result.JunoDocTriggerRec!=undefined){
                        console.log(result.JunoDocTriggerRec);
                        this.filterConditionsValue = result.JunoDocTriggerRec.JunoDoc__Trigger_Conditions_Formula__c;
                        var isActive = result.JunoDocTriggerRec.JunoDoc__IsActive__c;
                        console.log('result.JunoDocTriggerRec.Name;---->'+result.JunoDocTriggerRec.Name);
                        if(result.JunoDocTriggerRec.Name!=undefined){
                            this.triggerName = result.JunoDocTriggerRec.Name;
                        }
                        
                    }
    
                    if(Object.keys(result.TriggerActionRec).length != 0){
                        console.log(result.TriggerActionRec + '458');
                        var UsersEmailAddresses = result.TriggerActionRec.JunoDoc__Users_Email_Addresses__c;
                        if(UsersEmailAddresses!=undefined){
                            var arrUsersEmailAddresses = UsersEmailAddresses.split(';');
                            for(var i=0;i<arrUsersEmailAddresses.length;i++){
                                var name = arrUsersEmailAddresses[i].split('~')[0];
                                var email = arrUsersEmailAddresses[i].split('~')[1];
                                this.selectedUserEmailsList.push({
                                    label : name,
                                    value : email
                                });                        
                            }
                        }
                        var ContactsEmailAddresses = result.TriggerActionRec.JunoDoc__Contacts_Email_Addresses__c;
                        if(ContactsEmailAddresses!=undefined){
                            var arrContactsEmailAddresses = ContactsEmailAddresses.split(';');
                            for(var i=0;i<arrContactsEmailAddresses.length;i++){
                                var name = arrContactsEmailAddresses[i].split('~')[0];
                                var email = arrContactsEmailAddresses[i].split('~')[1];
                                this.selectedContactEmailsList.push({
                                    label : name,
                                    value : email
                                });                        
                            }
                        }
                        this.EmailAddresses = result.TriggerActionRec.JunoDoc__Email_Addresses__c;
                        if(this.EmailAddresses==undefined){
                            this.EmailAddresses = '';
                        }

                        this.FromEmailAddress = result.TriggerActionRec.JunoDoc__From_Email_Address__c;
                        if(this.FromEmailAddress==undefined){
                            this.FromEmailAddress = '';
                        }

                        this.SetReplyTo = result.TriggerActionRec.JunoDoc__Set_Reply_To__c;
                        if(this.SetReplyTo==undefined){
                            this.SetReplyTo = '';
                        }

                        this.SetSenderDisplayName = result.TriggerActionRec.JunoDoc__Set_Sender_Display_Name__c;
                        if(this.SetSenderDisplayName==undefined){
                            this.SetSenderDisplayName = '';
                        }

                        var selectedEmailFields = result.TriggerActionRec.JunoDoc__Email_Fields__c;
                        if(selectedEmailFields!=undefined){
                            var arrEmailFields = selectedEmailFields.split(';');
                            for(var i=0;i<arrEmailFields.length;i++){
                                var fieldLabel = arrEmailFields[i].split('~')[0];
                                var fieldName = arrEmailFields[i].split('~')[1];
                                this.selectedEmailFieldsMultiPicklistValues.push({
                                    label : fieldLabel,
                                    value : fieldName
                                });                        
                            }
                        }
                        this.AvailableDocTemplate = result.TriggerActionRec.JunoDoc__Available_Doc_Template__c;
                        if(this.AvailableDocTemplate==undefined){
                            this.AvailableDocTemplate = '';
                        }
                        this.JunoDocEmailTemplate = result.TriggerActionRec.JunoDoc__Juno_Doc_Email_Template__c;
                        if(this.JunoDocEmailTemplate==undefined){
                            this.JunoDocEmailTemplate = '';
                        }
                        this.StandardEmailTemplate = result.TriggerActionRec.JunoDoc__Standard_Email_Template__c;
                        if(this.StandardEmailTemplate==undefined){
                            this.StandardEmailTemplate = '';
                        }
                        this.EmailSubject = result.TriggerActionRec.JunoDoc__Email_Subject__c;
                        if(this.EmailSubject==undefined){
                            this.EmailSubject = '';
                        }
                        this.SaveAsActivity = result.TriggerActionRec.JunoDoc__Save_as_Activitiy__c;
                        if(this.SaveAsActivity==undefined){
                            this.SaveAsActivity = true;
                        }
                        console.log('JunoDocEmailTemplate--->'+this.JunoDocEmailTemplate);
                        console.log('StandardEmailTemplate--->'+this.StandardEmailTemplate);                   
                        if(result.TriggerActionRec.Name!=undefined){
                            this.showTriggerActionNextButton = true;
                        }
                        
                    }
                    else{
                        console.log('1111');
                        this.getObjectSettings();
                    }
    
                    console.log('SaveAsActivity--->'+this.SaveAsActivity);
                    //selectedUserEmailsList=[];
                    //selectedContactEmailsList=[];
                    this.PostTriggerActionsWrapper = result.PostTriggerActionsList;
                
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
    
        }else{
            this.isLoaded = false;
        }

    }

    fetchSelectedObjectDataHelper(actionObject){
        this.isLoaded = true;
        var isSearch=false;
        for(var i=0;i<this.ObjectsList.length;i++){
            if(actionObject==this.ObjectsList[i].value){
                this.ObjectLabel = this.ObjectsList[i].label;
                isSearch = true;
                break;
            }
        }

        console.log('trigger action--->'+actionObject);

        if(isSearch){
            getTriggerAction({ ObjectName : actionObject } )
            .then((result) =>  {                   
                if(result!==undefined && result!=''){
                    console.log('result---->'+result);
                    this.isLoaded = false;
                    this.selectedEmailFieldsMultiPicklistValues = [];
                    this.selectedUserEmailsList = [];
                    this.selectedContactEmailsList = [];
                 
                    this.SalesforceObject = actionObject; 
                    this.EmailFieldsMultiPicklist = result.EmailFields;
                    this.AvailableDocTemplatesList = result.AvailableDocTemplatesList; 
                    this.StandardEmailTemplatesList = result.StandardEmailTemplatesList;
                    this.JunoDocEmailTemplatesList = result.JunoDocEmailTemplatesList;
                    this.ObjectFieldsWrapper = result.ObjectFieldsWrapper;                
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
    
        }else{
            this.isLoaded = false;
        }

    }

    @track triggerConditionIndex=0; 
    addTriggerConditionRow(){
        if(this.SalesforceObject!=''){
            this.triggerConditionIndex+1;    
            //alert(this.TriggerConditionsWrapper);
            var rownumber = this.TriggerConditionsWrapper.length+1;
            //alert(rownumber);
            this.TriggerConditionsWrapper.push({
                RowNumber:rownumber,
                field:'',
                Operator:'',
                fieldValue:'',
                type:'',
                isPicklist:false,
                isBoolean:false
            });    

            console.log(this.filterConditionsValue);
            var firstChar='';
            var lastChar='';
            var filterConditionswithoutBrackets='';
            if(this.filterConditionsValue!='' && this.filterConditionsValue!=undefined){
                firstChar = this.filterConditionsValue.substring(0,1);
                lastChar = this.filterConditionsValue.substring(this.filterConditionsValue.length,(this.filterConditionsValue.length-1));
                filterConditionswithoutBrackets = this.filterConditionsValue.substring(1,(this.filterConditionsValue.length-1));    
            }
            

            if(this.filterConditionsValue=='' || this.filterConditionsValue==undefined){
                this.filterConditionsValue = '(1)';
                rownumber=1;
            }else{
                filterConditionswithoutBrackets = filterConditionswithoutBrackets + ' AND ' + this.TriggerConditionsWrapper.length;
                this.filterConditionsValue = '(' + filterConditionswithoutBrackets + ')';
            }
        
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Alert!',
                    message: 'Please Select Salesforce Object',
                    variant: 'error'
                })
            );

        }
        
    }

    removeTriggerConditionRow(event){
        if(this.TriggerConditionsWrapper.length>=1){
            this.TriggerConditionsWrapper.splice(event.target.accessKey,1);
            this.triggerConditionIndex-1;
        }

        for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            this.TriggerConditionsWrapper[i].RowNumber = (i+1);
        }


    }    

    handleFilterConditionsFormulaOnChange(event){
        this.filterConditionsValue = event.target.value;
    }

    ConditionChangeHandler(event){
        this.optionValues = [];
        
        if(event.target.name==='Field'){
            this.TriggerConditionsWrapper[event.target.accessKey].fieldValue='';
            this.TriggerConditionsWrapper[event.target.accessKey].field=event.target.value;
            for(var i=0;i<this.ObjectFieldsWrapper.length;i++){
                if(event.target.value==this.ObjectFieldsWrapper[i].value){
                    this.TriggerConditionsWrapper[event.target.accessKey].type=this.ObjectFieldsWrapper[i].type;
                    if(this.ObjectFieldsWrapper[i].type=='PICKLIST'){
                        this.TriggerConditionsWrapper[event.target.accessKey].isPicklist = true;
                        this.TriggerConditionsWrapper[event.target.accessKey].isBoolean = false;
                    }
                    else if(this.ObjectFieldsWrapper[i].type=='BOOLEAN'){
                        this.TriggerConditionsWrapper[event.target.accessKey].isBoolean = true;
                        this.TriggerConditionsWrapper[event.target.accessKey].isPicklist = false;
                    }else{
                        this.TriggerConditionsWrapper[event.target.accessKey].isBoolean = false;
                        this.TriggerConditionsWrapper[event.target.accessKey].isPicklist = false;
                    }

                }
            }
        }else if(event.target.name==='Operator'){
            this.TriggerConditionsWrapper[event.target.accessKey].Operator=event.target.value;
        }
        else if(event.target.name==='FieldValue'){
            this.TriggerConditionsWrapper[event.target.accessKey].fieldValue=event.target.value;
        }
    }

    handleTriggerConditionsSave(){
        this.selectedStep = '';
        var message='';      

        if(this.TriggerConditionsWrapper.length>0){
            var FieldNames=[];
            for(let i=0; i< this.TriggerConditionsWrapper.length; i++) {
                var field = this.TriggerConditionsWrapper[i].field;
                var Operator = this.TriggerConditionsWrapper[i].Operator;
                var value = this.TriggerConditionsWrapper[i].fieldValue;
                /*if(FieldNames.length>0){
                    for(var j=0;j<FieldNames.length;j++){
                        if(FieldNames[j]==field){
                            message='There is already an item in this list with '+field;
                            break;
                        }
                    }    
                }*/
                if(message==''){
                    FieldNames.push(field);
                    if(field=='' && Operator=='' && value==''){
                        message='Empty rows can not be saved!';
                        break;
                    }else if(field!='' && Operator==''){
                        message='Please select Operator for '+field;
                        break;
                    }else if(field!='' && Operator!='' && value==''){
                        message='Please select Value for '+field;
                        break;
                    }    
                    
                }
            }    
        }else{
            message = 'Please add Filter Conditions!';
        }

        if(message==''){
            if(this.template.querySelector("[data-field='filterConditionsFormula']").value==''){
                message = 'Please Enter Filter Conditions Formula!';
            }
        }

        var rowNumbersList=[];

        if(message==''){
            var exists=false;

            var filterConditionsFormula = this.filterConditionsValue.replace(/\s/g, '');
            for(var i=0;i<filterConditionsFormula.length;i++){
                if(isNaN(filterConditionsFormula[i])==false && filterConditionsFormula[i]*1>0){
                    exists=false;
                    if(rowNumbersList.length>0){
                        for(var k=0;k<rowNumbersList.length;k++){                            
                            if(filterConditionsFormula[i]==rowNumbersList[k]){
                                exists = true;
                            }
                        }
                        
                        if(exists==false){
                            rowNumbersList.push(filterConditionsFormula[i]);
                        }

                    }else{
                        rowNumbersList.push(filterConditionsFormula[i]);
                    }

                }
            }
        }

        if(rowNumbersList.length > this.TriggerConditionsWrapper.length){
            message = 'Please check formula once! It contains indexes that are not in actual conditions!';
        }
    

        if(message!=''){
            this.selectedStep = '';
            this.selectedStep = 'Step2';
            this.ShowObjectDetails = false;
            this.showTriggerConditions = true;
            this.showTriggerAction = false;
            this.showPostTriggerActions = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Alert',
                    message: message,
                    variant: 'error'
                })
            );   
            if(this.savedbutton == true){
                this.DupeselectedStep = this.selectedStep;
              }    
            this.isLoaded = false;
        }


        if(message==''){

            saveTriggerActionConditions( 
                { 
                    TriggerName : this.triggerName, //this.template.querySelector("[data-field='triggerName']").value,
                    ObjectName : this.SalesforceObject,
                    TriggerConditionsFormula : this.template.querySelector("[data-field='filterConditionsFormula']").value,
                    records : JSON.stringify(this.TriggerConditionsWrapper)
                } 
            )          
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    
                    this.selectedStep = 'Step3';
                    this.ShowObjectDetails = false;
                    this.showTriggerConditions = false;
                    this.showTriggerAction = true;
                    this.showPostTriggerActions = false;
                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    if(this.savedbutton == true){
                        this.DupeselectedStep = this.selectedStep;
                      }
                      if(this.addEmailRecipientsList.length == 0){
                        this.getObjectSettings();
                      }
                    //this.isLoaded = false;
                    console.log('this.selectedStep-->'+this.selectedStep);
                    //this.isLoaded = false;
                    console.log('result-->'+result);  
                }
            })
            .catch(error => {
                console.log('error'+error);
                this.selectedStep = '';
            this.selectedStep = 'Step2';
            this.ShowObjectDetails = false;
            this.showTriggerConditions = true;
            this.showTriggerAction = false;
            this.showPostTriggerActions = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while Updating record',
                    message: this.error,
                    variant: 'error'
                })
            );
            if(this.savedbutton == true){
                this.DupeselectedStep = this.selectedStep;
              } 
                //this.isLoaded = false;
            });

        } 

    }


    @track selectedPicklistField = '';
    handleSearchPicklistClick(event){
        this.optionValues = [];

        this.selectedPicklistField = this.TriggerConditionsWrapper[event.target.accessKey].field;
        
        //this.selectedPicklistLabel = this.TriggerConditionsWrapper[event.target.accessKey].value;
        getSelectedPicklistValues( 
            { 
                ObjectName : this.SalesforceObject, 
                picklistField : this.selectedPicklistField
            } 
        )          
        .then((result) =>  {
            if(result!==undefined && result!=''){
                console.log('search picklist--->result--->'+result);
                this.pickListValuesList = result;                
                this.openPicklistModal = true;   
                for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
                    var loopField = this.TriggerConditionsWrapper[i].field;
                    if(loopField==this.selectedPicklistField){  
                        this.optionValues = this.TriggerConditionsWrapper[i].fieldValue;
                    }
                }               
        
                console.log('picklist values-->'+result);   
            }
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            console.log('error'+error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while fetching data',
                    message: this.error,
                    variant: 'error'
                })
            );
        });


    }

    @track selectedPicklistValues = [];
    @track optionValues=[];

    get selectedPicklistValues() {
        return this.optionValues.join(',');
    }

    handlePickListValueChange(event) {
        this.optionValues = event.detail.value;
    }

    onclickPicklistInsertValues(){
        var selectedPicklistField = this.selectedPicklistField;

        for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            var loopField = this.TriggerConditionsWrapper[i].field;
            if(loopField==selectedPicklistField){  
                this.TriggerConditionsWrapper[i].fieldValue = this.optionValues.toString();
                this.selectedPicklistValues = [];
                this.optionValues = [];
                this.selectedPicklistField = '';
                this.openPicklistModal = false;   
            }
        }        
         
    }

    closePicklistModal(){
        this.selectedPicklistField = '';
        this.selectedPicklistValues = [];
        this.optionValues = [];
        this.openPicklistModal = false;   
    }



    //multi lookup 
    //@track selectedItemsToDisplay = ''; //to display items in comma-delimited way
    //@track values = []; //stores the labels in this array
    //@track isItemExists = false; //flag to check if message can be displayed

    //captures the retrieve event propagated from lookup component
    selectUserEmailEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        this.selectedUserEmailsList = [];
        this.UserEmailsList = [];
        args.map(element=>{
            this.UserEmailsList.push({
                label:element.label,
                value:element.value
            });              
        });
        console.log('this.UserEmailsList---->'+JSON.stringify(this.UserEmailsList));
    }


    //captures the remove event propagated from lookup component
    deleteUserEmailEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        //this.displayItem(args);

        this.UserEmailsList = []; //initialize first
        args.map(element=>{
            this.UserEmailsList.push({
                label:element.label,
                value:element.value
            });  
        });
        console.log('this.UserEmailsList---->'+JSON.stringify(this.UserEmailsList));
    }
     

    //captures the retrieve event propagated from lookup component
    selectContactEmailEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        this.selectedContactEmailsList = [];
        this.ContactEmailsList = []; //initialize first
        args.map(element=>{
            this.ContactEmailsList.push({
                label:element.label,
                value:element.value
            });  
        });
        console.log('this.ContactEmailsList---->'+JSON.stringify(this.ContactEmailsList));
    }



    //captures the remove event propagated from lookup component
    deleteContactEmailEventHandler(event){
        let args = JSON.parse(JSON.stringify(event.detail.arrItems));
        //this.displayItem(args);

        this.ContactEmailsList = []; //initialize first
        args.map(element=>{
            this.ContactEmailsList.push({
                label:element.label,
                value:element.value
            }); 
        });
        console.log('this.ContactEmailsList---->'+JSON.stringify(this.ContactEmailsList));
    }



    //displays the items in comma-delimited way
    /*displayItem(args){
        this.values = []; //initialize first
        args.map(element=>{
            this.values.push(element.label);
        });

        this.isItemExists = (args.length>0);
        this.selectedItemsToDisplay = this.values.join(', ');
    }*/
    //multi lookup


    handleEmailAddressesOnChange(event){
        this.EmailAddresses = event.target.value;
    }

    handleFromEmailAddressOnChange(event){
        this.FromEmailAddress = event.target.value;
    }

    handleSetReplyToOnChange(event){
        this.SetReplyTo = event.target.value;
    }

    handleSetSenderDisplayNameOnChange(event){
        this.SetSenderDisplayName = event.target.value;
    }


    @track selectedEmailFieldsMultiPicklistValues = [];
    handleEmailFieldsMultiPicklist(event){
        if(!this.selectedEmailFieldsMultiPicklistValues.includes(event.target.value)){
            for(var i=0;i<this.EmailFieldsMultiPicklist.length;i++){
                if(this.EmailFieldsMultiPicklist[i].value==event.target.value){
                    this.selectedEmailFieldsMultiPicklistValues.push(
                            {
                                label : this.EmailFieldsMultiPicklist[i].label,
                                value : this.EmailFieldsMultiPicklist[i].value
                            }
                        )
                        ;
                }                
            }            
        }
    }

    handleRemoveEmailFieldsMultiPicklistValue(event){
        const valueRemoved = event.target.name;
        this.selectedEmailFieldsMultiPicklistValues.splice(this.selectedEmailFieldsMultiPicklistValues.indexOf(valueRemoved), 1);
    }     

    handleEmailTemplateOnChange(event){
        if(event.target.name==='AvailableDocTemplates'){
            this.AvailableDocTemplate = event.target.value;
        }
        else if(event.target.name==='StandardEmailTemplates'){
            this.JunoDocEmailTemplate = '';
            this.StandardEmailTemplate = event.target.value;            
        }
        else if(event.target.name==='JunoDocEmailTemplates'){
            this.StandardEmailTemplate = '';
            this.JunoDocEmailTemplate = event.target.value;
        }

    }



    @track PostTriggerActionKeyIndex=0; 
    addPostTriggerActionRow(){
        //this.message='';
        this.PostTriggerActionKeyIndex+1;
        var rownumber = this.PostTriggerActionsWrapper.length+1;
        this.PostTriggerActionsWrapper.push({
            RowNumber:rownumber,
            Field:'',
            Value:''
        });  
    }
    removePostTriggerActionRow(event){
        if(this.PostTriggerActionsWrapper.length>=1){
            this.PostTriggerActionsWrapper.splice(event.target.accessKey,1);
            this.PostTriggerActionKeyIndex-1;
        }

        for(var i=0;i<this.PostTriggerActionsWrapper.length;i++){
            this.PostTriggerActionsWrapper[i].RowNumber = (i+1);
        }

    } 


    handlePostTriggerActionOnChange(event){       

        if(event.target.name==='PostTriggerActionField'){
            this.PostTriggerActionsWrapper[event.target.accessKey].Value='';
            var fieldName=event.target.value;
            var msg='';
            /*for(var j=0;j<this.PostTriggerActionsWrapper.length;j++){
               if(fieldName==this.PostTriggerActionsWrapper[j].Field){
                   msg=fieldName+' is already Selected';
                  break;
                }
            }*/


            if(msg==''){
                this.PostTriggerActionsWrapper[event.target.accessKey].Field = fieldName;
                for(var i=0;i<this.ObjectFieldsWrapper.length;i++){

                    if(event.target.value==this.ObjectFieldsWrapper[i].value){
                        this.PostTriggerActionsWrapper[event.target.accessKey].type=this.ObjectFieldsWrapper[i].type;
                        if(this.ObjectFieldsWrapper[i].type=='PICKLIST'){                            
                            this.PostTriggerActionsWrapper[event.target.accessKey].isPicklist = true;
                            this.PostTriggerActionsWrapper[event.target.accessKey].picklistValues = this.ObjectFieldsWrapper[i].picklistValues;
                        }
                        else{
                            this.PostTriggerActionsWrapper[event.target.accessKey].isPicklist = false;
                        }
    
                    }
                }

            }
            else if(msg!=''){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Alert',
                        message: msg,
                        variant: 'error'
                    })
                );
            }
        }
        else if(event.target.name==='PostTriggerActionValue'){
            this.PostTriggerActionsWrapper[event.target.accessKey].Value=event.target.value;
        }
    } 

    handleNewTriggerClose(event){
        this.selectedStep = 'Step1';
        this.ShowObjectDetails = false;
        this.createNewTriggerAction = false;
        
        location.reload();
    }

    handleNewTriggerNext(event){
        this.selectedStep = '';
        var msg='';
        if(this.triggerName==''){
            msg='Please Enter Trigger Name';
        }

        if(msg==''){
            for(var i=0;i<this.TriggerActionsList.length;i++){
                if(this.triggerName == this.TriggerActionsList[i].Name){
                    msg='This trigger name already exists!';
                }
            }
        }

        if(msg==''){
            if(this.SalesforceObject==''){
                msg='Please Select Object';
            }    
        }

        if(msg!=''){
            this.ShowObjectDetails = true;
                    this.showTriggerConditions = false;
                    this.showTriggerAction = false;
                    this.ShowTriggerSetUp = false;
                    this.showPostTriggerActions = false;
                    this.selectedStep = 'Step1';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Alert',
                            message: msg,
                            variant: 'error'
                        })
                    );     
                   // 
                    
                      if(this.savedbutton == true){
                        this.DupeselectedStep = this.selectedStep;
                      }                
        }

        else{
            this.selectedStep = '';
                    
                    this.ShowObjectDetails = false;
                    this.showTable = true;
                    this.showTriggerConditions = true;
                    this.showTriggerAction = false;
                    this.showPostTriggerActions = false;
                    this.selectedStep = 'Step2';
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Update Filter conditions to your schedule action',
                            variant: 'success'
                        })
                    );
                    
                    if(this.savedbutton == true){
                        this.DupeselectedStep = this.selectedStep;
                      }
        }
    }

    closeTriggerConditionsModal(event){
        this.showTriggerConditions = false;
    }

    handleTriggerConditionsBack(event){
        if(this.createNewTriggerAction == true){
            this.showTriggerConditions = false;
            this.selectedStep = 'Step1';
            this.DupeselectedStep = this.selectedStep;
            this.ShowObjectDetails = true;
            this.showTriggerAction = false;
            this.showPostTriggerActions = false;
            }
            else{
            this.selectedStep = 'Step2';
            this.DupeselectedStep = this.selectedStep;
            this.showTriggerConditions = false;
            this.ShowObjectDetails = false;
            this.showTriggerAction = false;
            this.showPostTriggerActions = false;
            location.reload();
            }
        //this.showTriggerConditions = false;
    }


    handleTriggerConditionsNext(event){
        if(this.TriggerConditionsWrapper.length>0){
            this.showTriggerAction = true;
            this.handleTriggerConditionsSave();    
        }else{             
            var message = 'Please Add rows and save!'; 
            this.filterConditionsValue = '';        

            if(message!=''){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Alert',
                        message: message,
                        variant: 'error'
                    })
                );    
                this.isLoaded = false;
            }
    
        }
    }

    handleTriggerActionBack(event){
        this.showTriggerAction = false;
        this.showTriggerConditions = true;
        this.selectedStep = 'Step2';
        this.DupeselectedStep = this.selectedStep;
        this.ShowObjectDetails = false;
        this.showPostTriggerActions = false;
    }

    handleTriggerActionNext(event){
        this.showTriggerConditions = false;
        this.showTriggerAction = false;
        this.showPostTriggerActions = true;
    }

    handlePostTriggerActionBack(event){
        this.showPostTriggerActions = false;
        this.selectedStep = 'Step3';
        this.DupeselectedStep = this.selectedStep;
        this.showTriggerAction = true;
        this.ShowObjectDetails = false;
        this.showTriggerConditions = false;
    }

    handlePostTriggerActionClose(event){
        //this.selectedStep = 'Step3';
        this.showTriggerAction = false;
        this.ShowObjectDetails = false;
        this.showPostTriggerActions = false;
        this.showTriggerConditions = false;
        this.ShowHomeScreen = true;
        location.reload();
    }

    
    handlePostTriggerActionNext(event){
        this.showPostTriggerActions = false;
    }

    handleEmailSubjectOnChange(event){        
        this.EmailSubject = event.target.value;    
    }
    handleSaveAsActivityOnChange(event){        
        this.SaveAsActivity = event.target.checked;    
    }    

    handleTriggerActionSave(){

        var message='';      
 
        if(   
            /* this.UserEmailsList.length==0 
            && this.ContactEmailsList.length==0
            && this.EmailAddresses ==''
            && this.selectedEmailFieldsMultiPicklistValues.length==0*/
            this.addEmailRecipientsList.length==0

            ){
            message = 'Please add Email Recipients!';
        }

        if(message==''){
            if(this.AvailableDocTemplate==''){
                message = 'Please Select Available Doc Template!';
            }
        }

        if(message==''){
            if(this.StandardEmailTemplate=='' && this.JunoDocEmailTemplate==''){
                message = 'Please Select Standard Email Template or Juno Doc Email Template!';
            }
        }
    

     /*   if(message==''){
            if(this.EmailSubject=='' && this.StandardEmailTemplate!=''){
               // message = 'Please Enter Email Subject!';
            }
        }*/


        if(message!=''){
            this.selectedStep = '';
            this.selectedStep = 'Step3';
            this.ShowObjectDetails = false;
                    this.showTriggerAction = true;
                    this.showTriggerConditions = false;
                    this.showPostTriggerActions = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Alert',
                    message: message,
                    variant: 'error'
                })
            );   
            if(this.savedbutton == true){
                this.DupeselectedStep = this.selectedStep;
              }  
            this.isLoaded = false;
        }


        if(message==''){

            var UsersEmailAddresses = ''; 
            if(this.UserEmailsList.length>0){
                for(var i=0;i<this.UserEmailsList.length;i++){
                    var name = this.UserEmailsList[i].label;
                    var email = this.UserEmailsList[i].value;
                    if(UsersEmailAddresses==''){
                        UsersEmailAddresses = name+'~'+email;
                    }else{
                        UsersEmailAddresses = UsersEmailAddresses+';'+name+'~'+email;
                    }
                }
            }

            if(this.selectedUserEmailsList.length>0){
                for(var i=0;i<this.selectedUserEmailsList.length;i++){
                    var name = this.selectedUserEmailsList[i].label;
                    var email = this.selectedUserEmailsList[i].value;
                    if(UsersEmailAddresses==''){
                        UsersEmailAddresses = name+'~'+email;
                    }else{
                        UsersEmailAddresses = UsersEmailAddresses+';'+name+'~'+email;
                    }
                }
            }


            var ContactsEmailAddresses = ''; 
            if(this.ContactEmailsList.length>0){
                for(var i=0;i<this.ContactEmailsList.length;i++){
                    var name = this.ContactEmailsList[i].label;
                    var email = this.ContactEmailsList[i].value;
                    if(ContactsEmailAddresses==''){
                        ContactsEmailAddresses = name+'~'+email;
                    }else{
                        ContactsEmailAddresses = ContactsEmailAddresses+';'+name+'~'+email;
                    }
                }
            }

            if(this.selectedContactEmailsList.length>0){
                for(var i=0;i<this.selectedContactEmailsList.length;i++){
                    var name = this.selectedContactEmailsList[i].label;
                    var email = this.selectedContactEmailsList[i].value;
                    if(UsersEmailAddresses==''){
                        UsersEmailAddresses = name+'~'+email;
                    }else{
                        UsersEmailAddresses = UsersEmailAddresses+';'+name+'~'+email;
                    }
                }
            }

            var selectedEmailFields = '';
            console.log('pill--->'+this.selectedEmailFieldsMultiPicklistValues);
            if(this.selectedEmailFieldsMultiPicklistValues.length>0){
                
                for(var i=0;i<this.selectedEmailFieldsMultiPicklistValues.length;i++){

                    var fieldLabel = this.selectedEmailFieldsMultiPicklistValues[i].label;
                    var fieldName = this.selectedEmailFieldsMultiPicklistValues[i].value;
                    if(selectedEmailFields==''){
                        selectedEmailFields = fieldLabel+'~'+fieldName;
                    }else{
                        selectedEmailFields = selectedEmailFields+';'+fieldLabel+'~'+fieldName;
                    }
                }                
            }

            console.log('this.SalesforceObject--->'+this.SalesforceObject);
            console.log('this.triggerName--->'+this.triggerName);
            console.log('this.UsersEmailAddresses--->'+UsersEmailAddresses);
            console.log('this.ContactsEmailAddresses--->'+this.ContactsEmailAddresses);
            console.log('this.EmailAddresses--->'+this.EmailAddresses);
            console.log('this.EmailFields--->'+selectedEmailFields);
            console.log('this.AvailableDocTemplate--->'+this.AvailableDocTemplate);
            console.log('this.StandardEmailTemplate--->'+this.StandardEmailTemplate);
            console.log('this.JunoDocEmailTemplate--->'+this.JunoDocEmailTemplate);
            console.log('this.EmailSubject--->'+this.EmailSubject);
            console.log('email list--->'+JSON.stringify(this.addEmailRecipientsList));

            saveTriggerAction( 
                { 
                    ObjectName : this.SalesforceObject,
                    TriggerName : this.triggerName,
                    UsersEmailAddresses :  UsersEmailAddresses,
                    ContactsEmailAddresses : ContactsEmailAddresses,
                    EmailAddresses : this.EmailAddresses,
                    FromEmailAddress : this.FromEmailAddress,
                    SetReplyTo : this.SetReplyTo,
                    SetSenderDisplayName : this.SetSenderDisplayName,
                    EmailFields :  selectedEmailFields,
                    AvailableDocTemplate : this.AvailableDocTemplate,
                    StandardEmailTemplate : this.StandardEmailTemplate,
                    JunoDocEmailTemplate : this.JunoDocEmailTemplate,                    
                    EmailSubject : this.EmailSubject,
                    SaveAsActivity : this.SaveAsActivity,
                    AddEmailRecipientsList : this.addEmailRecipientsList
                } 
            )          
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    this.showPostTriggerActions = true;
                    this.showTriggerAction = false;
                    this.showTriggerConditions = false;

                    //this.showTriggerActionNextButton = true;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    this.selectedStep = '';
                    this.selectedStep = 'Step4';
                    this.ShowObjectDetails = false;
                    //this.showScheduleAction = false;
                    this.showTriggerConditions = false;
                    this.showPostTriggerActions = true;
                    /*if(this.savedbutton == true){
                        this.isLoaded = false;
                        this.savedbutton = false;
                    }*/
                    //this.isLoaded = false;
                    if(this.savedbutton == true){
                        this.DupeselectedStep = this.selectedStep;
                      }
                    //this.isLoaded = false;
                    console.log('result-->'+result);   
                }
            })
            .catch(error => {
                console.log('error'+error);
                this.selectedStep = '';
                this.selectedStep = 'Step3';
                this.ShowObjectDetails = false;
                    this.showTriggerAction = true;
                    this.showTriggerConditions = false;
                    this.showPostTriggerActions = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while Updating record',
                        message: this.error,
                        variant: 'error'
                    })
                );
                if(this.savedbutton == true){
                    this.DupeselectedStep = this.selectedStep;
                  }
                //this.isLoaded = false;
            });

        } 

    }

    closeTriggerActionModal(event){
        this.showTriggerAction = false;
    }


    handlePostTriggerActionSave(){
        var message = '';
        if(this.PostTriggerActionsWrapper.length>0){
            var FieldNames=[];
            for(let i=0; i< this.PostTriggerActionsWrapper.length; i++) {
                var field = this.PostTriggerActionsWrapper[i].Field;
                var value = this.PostTriggerActionsWrapper[i].Value;
                if(FieldNames.length>0){
                    for(var j=0;j<FieldNames.length;j++){
                        if(FieldNames[j]==field){
                            message='There is already an item in this list with '+field;
                            break;
                        }
                    }    
                }
                if(message==''){
                    FieldNames.push(field);
                    if(field=='' && value==''){
                        message='Empty rows can not be saved!';
                        break;
                    }else if(field!='' && value==''){
                        message='Please select Value for '+field;
                        break;
                    }    
                    
                }
            }    
        }else{
            //message = 'Please Add rows!'; 
        }   

        if(message!=''){
            this.selectedStep = '';
            this.selectedStep = 'Step4';
            this.ShowObjectDetails = false;
                    this.showTriggerConditions = false;
                    this.showTriggerAction = false;
                    this.showPostTriggerActions = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Alert',
                    message: message,
                    variant: 'error'
                })
            );    
            if(this.savedbutton == true){
                this.DupeselectedStep = this.selectedStep;
              }
            this.isLoaded = false;
        }


        if(message==''){

            savePostTriggerActions( 
                { 
                    ObjectName : this.SalesforceObject, 
                    TriggerName : this.triggerName,
                    records : JSON.stringify(this.PostTriggerActionsWrapper)
                } 
            )          
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    //this.isLoaded = false;
                    console.log('result-->'+result);  
                    
                    this.ShowHomeScreen = true;
        location.reload();
                }
            })
            .catch(error => {
                console.log('error'+error);
                this.selectedStep = 'Step5';
                this.ShowObjectDetails = false;
                    this.showTriggerConditions = false;
                    this.showTriggerAction = false;
                    this.showPostTriggerActions = true;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while Updating record',
                        message: this.error,
                        variant: 'error'
                    })
                );
                //this.isLoaded = false;
            });

        } 
       
    }

    handleNewTriggerNext2(){
        this.savedbutton = true;
        this.selectedStep = '';
       // this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.handleNewTriggerNext();
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 800);
        //this.DupeselectedStep = this.selectedStep;
       // this.isLoaded = false;
    }

    handleTriggerConditionsSave2(){
        this.selectedStep = '';
        //this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handleTriggerConditionsSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 1500);
    }

    handleTriggerActionSave2(){
        this.selectedStep = '';
       // this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handleTriggerActionSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 1500);
    }

   

    handlePostTriggerActionSave2(){
        this.selectedStep = '';
        //this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handlePostTriggerActionSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 800);
    }

    handleClick(event){
        if(event.target.name === 'openConfirmation'){
            //it can be set dynamically based on your logic
            this.originalMessage = 'test message';
            //shows the component
            this.isDialogVisible = true;
        }else if(event.target.name === 'confirmModal'){

            //when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
            if(event.detail !== 1){
                //gets the detail message published by the child component
                this.displayMessage = 'Status: ' + event.detail.status + '. Event detail: ' + JSON.stringify(event.detail.originalMessage) + '.';

                //you can do some custom logic here based on your scenario
                if(event.detail.status === 'confirm') {
                    
                    deleteJunoDocTrigger( { TriggerName : this.triggerName } )
                    .then((result) =>  {
                        if(result!==undefined && result!=''){

                            console.log('test');
                            this.showTriggerActions = false;
                            this.fetchAvailableTriggerActionsDataHelper();
                           

                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: result,
                                    variant: 'success'
                                })
                            );
                            //this.isLoaded = false;

                            location.reload();

                            //window.realod();
                            
                            //refreshApex(this.fetchAvailableTriggerActionsDataHelper());
                        }
                    })
                    .catch(error => {
                        console.log('error'+error);
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error while deleting trigger',
                                message: this.error,
                                variant: 'error'
                            })
                        );
                        //this.isLoaded = false;
                    });                    
                    
                }else if(event.detail.status === 'cancel'){
                }
            }

            //hides the component
            this.isDialogVisible = false;
        }
    }


    handleChange(event){
        //alert(event.target.value);
        this.searchObjectsList = [];
        var filter = event.target.value.toUpperCase();
        for (var i = 0; i < this.ObjectsList.length; i++) {
            var txtValue = this.ObjectsList[i].label+this.ObjectsList[i].value;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                this.searchObjectsList.push({
                    label:this.ObjectsList[i].label,
                    value:this.ObjectsList[i].value}
                );
            }  
        }
        
        if(this.searchObjectsList.length>0){
            this.showSearchObjects = true;            
        }else{
            this.showSearchObjects = false;
        }

    }

    handleSearchOnClick(event){
        this.showSearchObjects = false;
        this.SalesforceObject = '';

        /*var searchObjectLabel = event.currentTarget.dataset.item;
        alert(searchObjectLabel);
        for (var i = 0; i < this.ObjectsList.length; i++) {           
            if (searchObjectLabel == this.ObjectsList[i].label) {
                this.ObjectLabel = searchObjectLabel;
                this.SalesforceObject = this.ObjectsList[i].value;
                break;                
            }
        }*/

        var searchObject = event.currentTarget.dataset.item;
        for (var i = 0; i < this.ObjectsList.length; i++) {           
            if (searchObject == this.ObjectsList[i].value) {
                this.ObjectLabel = this.ObjectsList[i].label;
                this.SalesforceObject = this.ObjectsList[i].value;
                break;                
            }
        }


        if(this.SalesforceObject!=''){
            this.fetchSelectedObjectDataHelper(this.SalesforceObject);
        }
        

    }

    handleFieldChange(event){
     
        this.searchFieldsList = [];
        var filter = event.target.value.toUpperCase();
        for (var i = 0; i < this.ObjectFieldsWrapper.length; i++) {
            var txtValue = this.ObjectFieldsWrapper[i].label+this.ObjectFieldsWrapper[i].value;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                this.searchFieldsList.push({
                        label:this.ObjectFieldsWrapper[i].label,
                        value:this.ObjectFieldsWrapper[i].value,
                        type:this.ObjectFieldsWrapper[i].type,
                        isPicklist:this.ObjectFieldsWrapper[i].isBoolean,
                        isBoolean:this.ObjectFieldsWrapper[i].isBoolean
                    }
                );
            }  
        }
        
        if(this.searchFieldsList.length>0){
            this.showSearchFields = true;            
        }else{
            this.showSearchFields = false;
        }
        
    }


    handleSearchFieldsOnClick(event){
        this.showSearchFields = false;
        var searchFieldLabel = event.currentTarget.dataset.item;
        var selectedFieldName = '';
        for(var i = 0; i < this.searchFieldsList.length; i++) {           
            if (searchFieldLabel == this.searchFieldsList[i].label) {
                selectedFieldName = this.searchFieldsList[i].value;
                break;
            }
        }

    }




   
    hanldeAddEmailRecipientSave(event) {
        this.addEmailRecipientsList = [];
  
        let args = JSON.parse(JSON.stringify(event.detail));
        args.map(element=>{
            this.addEmailRecipientsList.push({
              indx: element.indx,
              ToCCBCC: element.ToCCBCC,
              ReferenceType: element.ReferenceType,
              EmailValue: element.EmailValue,
              FinalFieldDetails: element.FinalFieldDetails
            }); 
        });
        console.log('this.addEmailRecipientsList--->'+this.addEmailRecipientsList);
        if(this.addEmailRecipientsList.length >0){
            this.showRecips = true;
        }
        else{
            this.showRecips = false;
        }
  
  
  
    }

getObjectSettings(){
        getJunodocObjectsettings({ObjectName : this.SalesforceObject})
        .then((result2) =>  {                   
            if(result2!==undefined && result2!=''){
                console.log('result97888---->'+JSON.stringify(result2));
                //this.isLoaded = false;
                console.log('1164---->'+("JunoDoc__From_Email_Address__c" in result2));
                console.log('1165---->'+("JunoDoc__Set_Reply_To__c" in result2));
                console.log('1166---->'+("JunoDoc__Junodoc_Doc_Template__c" in result2));
                console.log('1167---->'+("JunoDoc__Junodoc_Email_Templates__c" in result2));
                console.log('1168---->'+("JunoDoc__Standard_Email_Templates__c" in result2));
                
                if(("JunoDoc__From_Email_Address__c" in result2) != false){
                this.FromEmailAddress = result2.JunoDoc__From_Email_Address__c;
                if(this.FromEmailAddress==undefined){
                    this.FromEmailAddress = '';
                }
                }else{
                        this.FromEmailAddress = '';
                    }

                    if(("JunoDoc__Set_Reply_To__c" in result2) != false){
                    this.SetReplyTo = result2.JunoDoc__Set_Reply_To__c;
                    if(this.SetReplyTo==undefined){
                        this.SetReplyTo = '';
                    }
                    }
                    else{
                        this.SetReplyTo = '';
                    }

                    if(("JunoDoc__Junodoc_Doc_Template__c" in result2) != false){
                        this.AvailableDocTemplate = result2.JunoDoc__Junodoc_Doc_Template__c;
                        if(this.AvailableDocTemplate==undefined){
                            this.AvailableDocTemplate = '';
                        }
                        }
                        else{
                            this.AvailableDocTemplate = '';
                        }
                    
                        if(("JunoDoc__Junodoc_Email_Templates__c" in result2) != false){
                            this.JunoDocEmailTemplate = result2.JunoDoc__Junodoc_Email_Templates__c;
                            if(this.JunoDocEmailTemplate==undefined){
                                this.JunoDocEmailTemplate = '';
                            }
                            }
                            else{
                                this.JunoDocEmailTemplate = '';
                            }
                    
                            if(("JunoDoc__Standard_Email_Templates__c" in result2) != false){
                                this.StandardEmailTemplate = result2.JunoDoc__Standard_Email_Templates__c;
                                if(this.StandardEmailTemplate==undefined){
                                    this.StandardEmailTemplate = '';
                                }
                                }
                                else{
                                    this.StandardEmailTemplate = '';
                                }
                    
                    

            }
        })
        .catch(error => {
            //this.isLoaded = false;
            this.message = undefined;
            this.error = error;
            console.log('error1233--->'+error);
        });
    }
}
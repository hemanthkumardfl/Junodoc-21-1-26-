import { LightningElement,api,track } from 'lwc';
import ScheduleActionsTabClick from '@salesforce/apex/ScheduleActions.ScheduleActionsTabClick';
import getScheduleConditions from '@salesforce/apex/ScheduleActions.getScheduleConditions';
import getScheduleAction from '@salesforce/apex/ScheduleActions.getScheduleAction';
import getPostScheduleAction from '@salesforce/apex/ScheduleActions.getPostScheduleAction';
import getSelectedPicklistValues from '@salesforce/apex/ScheduleActions.getSelectedPicklistValues';
import saveScheduleActionConditions from '@salesforce/apex/ScheduleActions.saveScheduleActionConditions';
import saveScheduleAction from '@salesforce/apex/ScheduleActions.saveScheduleAction';
import getScheduleSetup from '@salesforce/apex/ScheduleActions.getScheduleSetup';
import saveScheduleSetup from '@salesforce/apex/ScheduleActions.saveScheduleSetup';
import savePostScheduleActions from '@salesforce/apex/ScheduleActions.savePostScheduleActions';
import deleteJunoDocSchedule from '@salesforce/apex/ScheduleActions.deleteJunoDocSchedule';
import updateScheduleStatus from '@salesforce/apex/ScheduleActions.updateScheduleStatus';
import getJunodocObjectsettings from '@salesforce/apex/ScheduleActions.getJunodocObjectsettings';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class junoDocScheduleActions extends LightningElement {
    activeSections = ['A','B','C','D','S','X','Y','Z'];
    @api addEmailRecipientsList = [];
    @api showRecips = false;
    @track isLoaded = false;
    @track savedbutton = false;
    @track LoadActions = false;
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
    @track showConditionsTable = false;
    @track ShowPostActsTable = false;
    @track fieldListed = [];

    @track searchFieldsList = [];
    @track showSearchFields = false;

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
    @track ScheduleConditionsWrapper=[];
    @track showActivateButton=false;
    @track showDeactiveButton=false;
    @track filterConditionsValue='';
    @track ScheduleActionsList=[];
    @track ScheduleActionKeyIndex=0; 
    @track createNewScheduleAction=false;
    @track showScheduleActions=false;
    @track ScheduleName='';
    @track disableScheduleName = false;
    @track ObjectsList=[];

    @track openPicklistModal = false;
    @track pickListValuesList = [];
    @track selectedPicklistLabel = '';
    @api booleanOptions=[
         {label:'true',value:'true'},
         {label:'false',value:'false'}
     ];

     @track openingConditions = false;
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
    @track IsSendEmail = false;
    @track IsAttachEmail = false;
    @track ToAttachEmail = false;
    @track ToSendEmail = false;
    @track SchedulerTypeList = [];
    @track SchedulerWeekDays = [];
    @track SchedulerDatesList = [];
    @track SchedulerMonthsList = [];
    @track SchedulerHoursList = [];
    @track ScheduleClockFormats = [];
    @track SchedulerType = '';
    @track ScheduleDates = [];
    @track ScheduleMonths = [];
    @track ScheduleHour = '';
    @track ScheduledClockFormat = '';
    @track UserGMTvalue = '';
    @track ScheduleDays = [];
    @track ShowScheduleHours = false;
    @track ShowScheduleDays = false;
    @track ShowScheduleDates = false;

    @track PostScheduleActionsWrapper=[];
    @track showScheduleConditions = false;
    @track showScheduleAction = false; 
    @track showPostScheduleActions = false;
    @track showScheduleConditionsNextButton = false;
    @track showScheduleActionNextButton = false;
    @track EmailSubject = '';
    @track UserEmailsList=[];
    @track ContactEmailsList=[];
    @track selectedUserEmailsList=[];
    @track selectedContactEmailsList=[];
    @track ScheduleConditionIndex=0;
    @track selectedPicklistField = '';
    @track selectedPicklistValues = [];
    @track optionValues=[];
    @track selectedEmailFieldsMultiPicklistValues = [];
    @track PostScheduleActionKeyIndex=0;
    @track ShowScheduleSetUp = false;
    @track Show_Y_accordion = false;
    @track ScheduleLabel = '';
    @track DupeselectedStep = '';

    connectedCallback() {
        this.LoadActions = true;
        this.ShowHomeScreen = true;
        this.fetchAvailableScheduleActionsDataHelper();
    }

    fetchAvailableScheduleActionsDataHelper(){
        console.log('schedule actions');
        
        this.LoadActions = true;
        ScheduleActionsTabClick()
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                this.LoadActions = false;
                this.showScheduleActions = true;
                console.log('result---->'+result);
                this.ObjectsList = result.ObjectsList;
                this.ScheduleActionsList = result.ScheduleActionsList;
                if(this.ScheduleActionsList.length > 0){
                    this.showScheduleActions = true;
                }
                console.log('objects list--->'+result.ObjectsList);
                console.log('resssss--->'+JSON.stringify(result.ScheduleActionsList));
                
            }
        })
        .catch(error => {
            this.LoadActions = false;
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
    }, 1000);
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
    }, 2000);
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
    }, 2500);
    //this.DupeselectedStep = this.selectedStep;
       
    }
    selectStep5() {
        console.log('this.selectedStep--205--->'+this.selectedStep);
       this.DupeselectedStep ='';
       setTimeout(() => {
        console.log('s5'+this.isLoaded);
        //this.DupeselectedStep = this.selectedStep;
        this.isLoaded = false;
        this.DupeselectedStep = this.selectedStep;
    }, 1200);
    //this.DupeselectedStep = this.selectedStep;
        
       
    }

    handleProgress(event){
        console.log('Progress'+event.target.value);
        if(event.target.value=='Step1'){
            console.log('1');
            this.selectedStep = 'Step1';
            //this.DupeselectedStep = this.selectedStep;
            this.ShowObjectDetails = true;
            this.showScheduleConditions = false;
            this.showScheduleAction = false;
            this.ShowScheduleSetUp = false;
            this.showPostScheduleActions = false;

        }
        else if(event.target.value == 'Step2'){
            //this.selectedStep = 'Step2';
            if(this.createNewScheduleAction == true){
                console.log('2');
                
                this.handleNewScheduleNext();
                console.log('selectedStep--220--->'+this.selectedStep);
            }
            else{
                this.fetchScheduleActionHelper(this.SalesforceObject,this.ScheduleName);
                console.log('3');
             
            }
                
                
        }
        else if(event.target.value == 'Step3'){
            if(this.showScheduleConditions == true){
                console.log('4');
                this.handleScheduleConditionsSave();
                console.log('selectedStep--238--->'+this.selectedStep);
            }
            else if(this.showScheduleConditions == false){
                if(this.ShowObjectDetails==true){ 
                console.log('5');
                this.handleNewScheduleNext();
                console.log('selectedStep--243--->'+this.selectedStep);
                }
                else if(this.ShowScheduleSetUp == true){
                    this.getSchAction();
                }else if(this.showPostScheduleActions == true){
                    console.log('6');
                    this.getSchAction();
                    
                }
                
                //this.selectedStep = 'Step2';
            }
            
        
        
        }
        else if(event.target.value == 'Step4'){
            if(this.showScheduleAction == true){
                console.log('7');
                this.handleScheduleActionSave();
                console.log('selectedStep--260--->'+this.selectedStep);
            }
            else if(this.showScheduleAction == false){ 
                if(this.ShowObjectDetails == true){
                this.handleNewScheduleNext();
                console.log('selectedStep--264--->'+this.selectedStep);
                }
                else if( this.showScheduleConditions == true ){
                    if(this.createNewScheduleAction == true){
                    this.handleScheduleConditionsSave();
                    }
                    else{
                        this.getSchSetup();
                       
                    }
                    console.log('selectedStep--268--->'+this.selectedStep);
                    //this.selectedStep = 'Step3';
                }
                else if(this.showPostScheduleActions == true){
                    this.getSchSetup();
                    console.log('9');
                   
                } 
                
            }
            
        }
        else if(event.target.value == 'Step5'){
            if(this.ShowScheduleSetUp == true){
                console.log('10');
                this.handleScheduleSetupSave();
                console.log('selectedStep--286--->'+this.selectedStep);
                }
            else if(this.ShowScheduleSetUp == false){
                console.log('11');
                if(this.ShowObjectDetails == true){
                    this.handleNewScheduleNext();
                    console.log('selectedStep--292--->'+this.selectedStep);
                }
                else if(this.showScheduleConditions == true){
                    if(this.createNewScheduleAction == true){
                        this.handleScheduleConditionsSave();
                        }
                        else{
                            this.getPostSchActions();
                          
                        }
                
                console.log('selectedStep--296--->'+this.selectedStep);
                }
                else if(this.showScheduleAction == true){
                    if(this.createNewScheduleAction == true){
                        this.handleScheduleActionSave();
                        }
                        else{
                            this.getPostSchActions();
                            
                        }
                    
                    console.log('selectedStep--300--->'+this.selectedStep);
                }
                //this.selectedStep = 'Step4';
            }
        }
        console.log('this.selectedStep'+this.selectedStep);
    }

    handleCreateNewScheduleAction(){
        this.ShowHomeScreen = false;
        this.selectedStep = 'Step1';
        this.ShowObjectDetails = true;
        this.createNewScheduleAction = true;
        this.ScheduleName = '';
        this.SalesforceObject='';
        this.ObjectLabel = '';
        this.ScheduleConditionsWrapper=[];
        this.filterConditionsValue='';
        this.disableScheduleName = false;
    }

    handleScheduleActionEditClick(event){
        this.openingConditions = true;
        this.SalesforceObject = this.ScheduleActionsList[event.target.accessKey].JunoDoc__Junodoc_Selected_Object__c;
        this.ScheduleName = this.ScheduleActionsList[event.target.accessKey].Name;
        console.log('this.SalesforceObject----->'+this.SalesforceObject);
        console.log('this.ScheduleName----->'+this.ScheduleName);
        this.fetchScheduleActionHelper(this.SalesforceObject,this.ScheduleName);
        
    }

    ObjectChangeHandler(event){
        this.disableScheduleName = false;
        this.filterConditionsValue = '';        
        var actionObject = event.target.value;
        this.SalesforceObject = actionObject;
        this.fetchScheduleActionHelper(actionObject);
    }

    fetchScheduleActionHelper(actionObject,scheduleName){
        this.selectedStep = '';
        this.ScheduleConditionsWrapper = [];
        this.isLoaded = true;
        var isSearch=false;
        for(var i=0;i<this.ObjectsList.length;i++){
            if(actionObject==this.ObjectsList[i].value){
                this.ObjectLabel = this.ObjectsList[i].label;
                isSearch = true;
                break;
            }
        }

        console.log('schedule action--->'+actionObject);        
        console.log('scheduleName--->'+scheduleName);

        if(isSearch){
            getScheduleConditions({ ObjectName : actionObject,
                ScheduleName : scheduleName
             } )
             .then((result) =>  {                   
                if(result!==undefined && result!=''){
                this.isLoaded = false;
                this.ShowHomeScreen = false;
    
    this.selectedStep= 'Step2';
    this.ShowObjectDetails = false;
    this.showSearchFields = false;
    this.showTable = true;
    this.showConditionsTable = true;
    
    this.showScheduleAction = false;
                        this.ShowObjectDetails = false;
                        this.showPostScheduleActions = false;
                        this.showScheduleConditions = true;
                        this.ShowScheduleSetUp = false;
                    console.log('result---->'+JSON.stringify(result));
                    this.SalesforceObject = actionObject;
                    this.ScheduleConditionsWrapper = result.ScheduleConditionsList;
                    if(this.ScheduleConditionsWrapper.length>0){
                        this.showScheduleConditionsNextButton = true;
                    }

                    console.log('this.ObjectFieldsWrapper ====' +result.ObjectFieldsWrapper);
                    this.ObjectFieldsWrapper = result.ObjectFieldsWrapper;

                    console.log('JunoDocscheduleRec24---->'+JSON.stringify(result.JunoDocScheduleRec));
                    if(result.JunoDocScheduleRec!=undefined){
                        console.log(result.JunoDocScheduleRec);
                        this.filterConditionsValue = result.JunoDocScheduleRec.JunoDoc__Junodoc_Selected_Criteria__c;
                        var isActive = result.JunoDocScheduleRec.JunoDoc__Junodoc_IsActive__c;
                        console.log('result.JunoDocScheduleRec.Name;---->'+result.JunoDocScheduleRec.Name);
                        if(result.JunoDocScheduleRec.Name!=undefined){
                            this.ScheduleName = result.JunoDocScheduleRec.Name;
                        }
                        
                    }
                    if(this.ShowObjectDetails == false){
                        if(this.openingConditions == true){
                            this.openingConditions = false;
                        }
                        else{
                        /*this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Updated your Schedule Actions',
                                variant: 'success'
                            })
                        );*/
                        }
                    }
                    
                }
            })
            .catch(error => {
              //  this.isLoaded = false;
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
          //  this.isLoaded = false;
        }

    }

    handleScheduleActionDeleteClick(event){
        this.SalesforceObject = this.ScheduleActionsList[event.target.accessKey].JunoDoc__Junodoc_Selected_Object__c;
        this.ScheduleName =  this.ScheduleActionsList[event.target.accessKey].Name;
        this.ConfirmationAlertMsg = 'Do you want to delete '+this.ScheduleName+' ?';
        this.isDialogVisible = true;
    }


    handleToggleChange(event){
        var ScheduleName= this.ScheduleActionsList[event.target.accessKey].Name;
        var toogleCheckedValue = event.target.checked;

        console.log('ScheduleName--->'+ScheduleName);
        console.log('toogleCheckedValue--->'+toogleCheckedValue);

        console.log('test');
        updateScheduleStatus({toogleValue: toogleCheckedValue, 
            ScheduleName:ScheduleName}
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
                location.reload();

                //this.fetchAvailableScheduleActionsDataHelper();
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
                    
                    deleteJunoDocSchedule( { ScheduleName : this.ScheduleName } )
                    .then((result) =>  {
                        if(result!==undefined && result!=''){

                            console.log('test');
                            this.showScheduleActions = false;
                            this.fetchAvailableScheduleActionsDataHelper();
                           

                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message: result,
                                    variant: 'success'
                                })
                            );
                            

                            location.reload();

                           
                        }
                    })
                    .catch(error => {
                        console.log('error'+error);
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error while deleting Schedule',
                                message: this.error,
                                variant: 'error'
                            })
                        );
                        
                    });                    
                    
                }else if(event.detail.status === 'cancel'){
                }
            }

            //hides the component
            this.isDialogVisible = false;
        }
    }

    handleNewScheduleClose(event){
        this.selectedStep = 'Step1';
        this.ShowObjectDetails = false;
        this.createNewScheduleAction = false;
        
        location.reload();

    }

    handleScheduleName(event){
        this.ScheduleName = event.target.value;
        this.showSearchObjects = false;
       // this.ObjectLabel = '';
       // this.SalesforceObject = '';
    }

    handleChange(event){
        //alert('2222222222222222222222');
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
        this.savedbutton = true;

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

    closeScheduleConditionsModal(event){
        this.showScheduleConditions = false;
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

        console.log('schedule action--->'+actionObject);

        if(isSearch){
            getScheduleConditions({ ObjectName : actionObject, ScheduleName : this.ScheduleName} )
            .then((result) =>  {                   
                if(result!==undefined && result!=''){
                    console.log('result---->'+result);
                   // this.isLoaded = false;
                    
                    this.ObjectFieldsWrapper = result.ObjectFieldsWrapper;   
                    if(this.savedbutton == true){
                        this.isLoaded = false;
                        this.savedbutton = false;
                    }
                    else{
                        this.isLoaded = true;
                    }             
                }
            
            })
            .catch(error => {
                if(this.savedbutton == true){
                    this.isLoaded = false;
                    this.savedbutton = false;
                }
                else{
                    this.isLoaded = true;
                }
               // this.isLoaded = false;
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
            if(this.savedbutton == true){
                this.isLoaded = false;
                this.savedbutton = false;
            }
            else{
                this.isLoaded = true;
            }
           // this.isLoaded = false;
        }

    }

    addScheduleConditionRow(){
        if(this.SalesforceObject!=''){
            this.ScheduleConditionIndex+1;    
            var rownumber = this.ScheduleConditionsWrapper.length+1;
            this.ScheduleConditionsWrapper.push({
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
                filterConditionswithoutBrackets = filterConditionswithoutBrackets + ' AND ' + this.ScheduleConditionsWrapper.length;
                this.filterConditionsValue = '(' + filterConditionswithoutBrackets + ')';
            }
            this.showConditionsTable = true;
        
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

    handleFilterConditionsFormulaOnChange(event){
        this.filterConditionsValue = event.target.value;
    }

    ConditionChangeHandler2(event){
        console.log('event---->'+event);
        var fieldList = [];
        
        console.log('JSON.stringify(event.detail)---->'+JSON.stringify(event.detail));
        let args = JSON.parse(JSON.stringify(event.detail));
        console.log('args---->'+args);
        args.map(element=>{
            fieldList.push({
                fieldValue: element.fieldValue,
                indx: element.indx,
                eventType: element.eventType
            }); 
        });

        this.fieldListed = fieldList;
        console.log('fieldList[0]---->'+fieldList[0]);
        this.optionValues = [];
        console.log('testt---->'+JSON.stringify(this.ObjectFieldsWrapper));
        if(fieldList[0].eventType === 'Field'){
            this.ScheduleConditionsWrapper[fieldList[0].indx].fieldValue='';
        this.ScheduleConditionsWrapper[fieldList[0].indx].field=fieldList[0].fieldValue;
        for(var i=0;i<this.ObjectFieldsWrapper.length;i++){
            if(fieldList[0].fieldValue==this.ObjectFieldsWrapper[i].value){
                this.ScheduleConditionsWrapper[fieldList[0].indx].type=this.ObjectFieldsWrapper[i].type;
                if(this.ObjectFieldsWrapper[i].type=='PICKLIST'){
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isPicklist = true;
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isBoolean = false;
                }
                else if(this.ObjectFieldsWrapper[i].type=='BOOLEAN'){
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isBoolean = true;
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isPicklist = false;
                }else{
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isBoolean = false;
                    this.ScheduleConditionsWrapper[fieldList[0].indx].isPicklist = false;
                }

            }
        }
        }
    }
    ConditionChangeHandler(event){
      //  alert('1111111111111111111111');
        console.log('event.target.name---->'+event.target.name);
        if(event.target.name==='Operator'){
            console.log('accesskey---->'+event.target.accessKey);
            console.log('event.target.value---->'+event.target.value);
            this.ScheduleConditionsWrapper[event.target.accessKey].Operator=event.target.value;
        }
        else if(event.target.name==='FieldValue'){
            this.ScheduleConditionsWrapper[event.target.accessKey].fieldValue=event.target.value;
        }
    }

    handleSearchPicklistClick(event){
        this.optionValues = [];

        this.selectedPicklistField = this.ScheduleConditionsWrapper[event.target.accessKey].field;
        
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
                for(var i=0;i<this.ScheduleConditionsWrapper.length;i++){
                    var loopField = this.ScheduleConditionsWrapper[i].field;
                    if(loopField==this.selectedPicklistField){  
                        this.optionValues = this.ScheduleConditionsWrapper[i].fieldValue;
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

    get selectedPicklistValues() {
        return this.optionValues.join(',');
    }

    removeScheduleConditionRow(event){
        //this.isLoaded = true;
        
        if(this.ScheduleConditionsWrapper.length>=1){
            this.ScheduleConditionsWrapper.splice(event.target.accessKey,1);
            this.ScheduleConditionIndex-1;
            
        }

        for(var i=0;i<this.ScheduleConditionsWrapper.length;i++){
            this.ScheduleConditionsWrapper[i].RowNumber = (i+1);
        }

       if(this.ScheduleConditionsWrapper.length>0){
        this.showConditionsTable = true;
       }
       else{
        this.showConditionsTable = false;
       }
        console.log('this.ScheduleConditionsWrapper.length--->'+this.ScheduleConditionsWrapper.length);
        console.log('this.filterConditionsValue--->'+this.filterConditionsValue);
        const len = this.ScheduleConditionsWrapper.length+1;
        console.log('len-->'+len);

        if(len == 1){
            this.filterConditionsValue = '';
        }
        
        if(this.filterConditionsValue.includes(' AND '+len)){
            const condition = this.filterConditionsValue;
            //console.log(condition.replace(' ('+len+')', ""));
            //this.filterConditionsValue = condition.replace('OR ('+len+')', "");
            this.filterConditionsValue = condition.replace(' AND '+len, "");
        }
        if(this.filterConditionsValue.includes(' OR '+len)){
            const condition = this.filterConditionsValue;
            //console.log(condition.replace(' ('+len+')', ""));
            //this.filterConditionsValue = condition.replace('OR ('+len+')', "");
            this.filterConditionsValue = condition.replace(' OR '+len, "");
        }
        /*if(this.filterConditionsValue.includes(' AND '+len)){
            
            const condition = this.filterConditionsValue;
            console.log(condition.replace(new RegExp(` AND \\d{1,${len}}\\b`, 'g'), ""));
            
            this.filterConditionsValue = condition.replace(new RegExp(` AND \\d{1,${len}}\\b`, 'g'), "");
            console.log('this.filterConditionsValue-->'+this.filterConditionsValue);
            
        }

        if(this.filterConditionsValue.includes(' OR '+len)){
            
            const condition = this.filterConditionsValue;
            console.log(condition.replace(new RegExp(` OR \\d{1,${len}}\\b`, 'g'), ""));
            
            this.filterConditionsValue = condition.replace(new RegExp(` OR \\d{1,${len}}\\b`, 'g'), "");
            console.log('this.filterConditionsValue-->'+this.filterConditionsValue);
            
        }

        if(this.filterConditionsValue.includes(' AND'+len)){
            
            const condition = this.filterConditionsValue;
            console.log(condition.replace(new RegExp(` AND\\d{1,${len}}\\b`, 'g'), ""));
            
            this.filterConditionsValue = condition.replace(new RegExp(` AND\\d{1,${len}}\\b`, 'g'), "");
            console.log('this.filterConditionsValue-->'+this.filterConditionsValue);
            
        }

        if(this.filterConditionsValue.includes(' OR'+len)){
            
            const condition = this.filterConditionsValue;
            console.log(condition.replace(new RegExp(` OR \\d{1,${len}}\\b`, 'g'), ""));
            
            this.filterConditionsValue = condition.replace(new RegExp(` OR\\d{1,${len}}\\b`, 'g'), "");
            console.log('this.filterConditionsValue-->'+this.filterConditionsValue);
            
        }*/
        console.log('this.filterConditionsValue--->'+this.filterConditionsValue);

        /*setTimeout(() => {
            this.isLoaded = false;
        }, 1000);*/

    }

    closePicklistModal(){
        this.selectedPicklistField = '';
        this.selectedPicklistValues = [];
        this.optionValues = [];
        this.openPicklistModal = false;   
    }

    handlePickListValueChange(event) {
        this.optionValues = event.detail.value;
    }

    onclickPicklistInsertValues(){
        var selectedPicklistField = this.selectedPicklistField;

        for(var i=0;i<this.ScheduleConditionsWrapper.length;i++){
            var loopField = this.ScheduleConditionsWrapper[i].field;
            if(loopField==selectedPicklistField){  
                this.ScheduleConditionsWrapper[i].fieldValue = this.optionValues.toString();
                this.selectedPicklistValues = [];
                this.optionValues = [];
                this.selectedPicklistField = '';
                this.openPicklistModal = false;   
            }
        }        
         
    }

    handleScheduleConditionsBack(event){
        if(this.createNewScheduleAction == true){
        this.showScheduleConditions = false;
        this.selectedStep = 'Step1';
        this.DupeselectedStep = this.selectedStep;
        this.ShowObjectDetails = true;
        this.showScheduleAction = false;
        this.showPostScheduleActions = false;
        }
        else{
        this.selectedStep = 'Step2';
        this.DupeselectedStep = this.selectedStep;
        this.showScheduleConditions = false;
        this.ShowObjectDetails = false;
        this.showScheduleAction = false;
        this.showPostScheduleActions = false;
        location.reload();
        }
        //this.showTriggerConditions = false;
    }

    handleScheduleConditionsSave(){
       // this.selectedStep = 'Step3';
        this.isLoaded = true;
        var message='';      

        if(this.ScheduleConditionsWrapper.length>0){
            var FieldNames=[];
            for(let i=0; i< this.ScheduleConditionsWrapper.length; i++) {
                var field = this.ScheduleConditionsWrapper[i].field;
                var Operator = this.ScheduleConditionsWrapper[i].Operator;
                var value = this.ScheduleConditionsWrapper[i].fieldValue;
                
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
                    } else if(field == ''){
                        message='Please select field at Rownumber - '+(i+1);
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

        if(rowNumbersList.length > this.ScheduleConditionsWrapper.length){
            message = 'Please check formula once! It contains indexes that are not in actual conditions!';
        }
    

        if(message!=''){
            this.selectedStep = '';
            this.selectedStep = 'Step2';
            this.ShowObjectDetails = false;
            this.showScheduleConditions = true;
            this.showScheduleAction = false;
            this.ShowScheduleSetUp = false;
            this.showPostScheduleActions = false;
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
            //this.isLoaded = false;
        }


        if(message==''){

            saveScheduleActionConditions( 
                
                { 
                    ScheduleName : this.ScheduleName, 
                    ObjectName : this.SalesforceObject,
                    ScheduleConditionsFormula : this.template.querySelector("[data-field='filterConditionsFormula']").value,
                    records : JSON.stringify(this.ScheduleConditionsWrapper)
                    
                } 
            )          
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    this.selectedStep = '';
                    this.selectedStep = 'Step3';
                    this.ShowObjectDetails = false;
                    this.showScheduleConditions = true;
                    this.showScheduleAction = true;
                    this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    //this.isLoaded = false;
                    console.log('result-->'+result);
                    
            /*if(this.savedbutton == true){
                this.isLoaded = false;
                this.savedbutton = false;
            } */ 
            
                }
                this.getSchAction();
                

        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.selectedStep = '';
            this.selectedStep = 'Step2';
            this.ShowObjectDetails = false;
            this.showScheduleConditions = true;
            this.showScheduleAction = false;
            this.ShowScheduleSetUp = false;
            this.showPostScheduleActions = false;
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
            /*if(this.savedbutton == true){
                this.isLoaded = false;
                this.savedbutton = false;
            }*/  
            //this.isLoaded = false;
        });

            

            

           

        } 

    }
    handleNewScheduleNext(){
        this.isLoaded = true;
        this.selectedStep = '';
        var msg='';
                if(this.ScheduleName==''){
                    msg='Please Enter Schedule Name';
                }
                
                if(msg==''){
                    for(var i=0;i<this.ScheduleActionsList.length;i++){
                        if(this.ScheduleName == this.ScheduleActionsList[i].Name){
                            msg='This Schedule name already exists!';
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
                    this.showScheduleConditions = false;
                    this.showScheduleAction = false;
                    this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = false;
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
                    this.showScheduleConditions = true;
                    this.showScheduleAction = false;
                    this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = false;
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
                    /*setTimeout(() => {
                        this.isLoaded = false;
                    }, 1000);*/
                    //this.DupeselectedStep = this.selectedStep;
                    //this.createNewScheduleAction = false;
                }
    }

    closeScheduleActionModal(event){
        this.showScheduleAction = false;
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

    handleToggleSection(event) {

        console.log( 'Selected Sections ' + event.detail.openSections );

    }

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

    handleEmailSubjectOnChange(event){        
        this.EmailSubject = event.target.value;    
    }
    handleSaveAsActivityOnChange(event){        
        this.SaveAsActivity = event.target.checked;    
    }
    handleSendEmailOnChange(event){
        this.IsSendEmail = event.target.checked;
        this.ToSendEmail = this.IsSendEmail;
        this.handleToAttachEmail();
    }
    handleAttachEmailOnChange(event){
        this.IsAttachEmail = event.target.checked;
        this.handleToAttachEmail();
    }
    handleToAttachEmail(){
        var Attach = this.IsAttachEmail;
        var Send = this.IsSendEmail;

        if(Attach == true || Send == true){
            this.ToAttachEmail = true;
        }
        else{
            this.ToAttachEmail = false;
        }
        
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

    handleScheduleActionBack(event){
        this.showScheduleAction = false;
        this.showScheduleConditions = true;
        this.selectedStep = 'Step2';
        this.DupeselectedStep = this.selectedStep;
        this.ShowObjectDetails = false;
        this.showPostScheduleActions = false;
    }

    handleScheduleActionSave(){
        this.isLoaded = true;
        console.log('this.addEmailRecipientsList--->'+JSON.stringify(this.addEmailRecipientsList));
        //this.selectedStep = 'Step4';
        var message='';
        if(this.IsSendEmail == true && this.IsAttachEmail == true && this.SaveAsActivity == true){
            this.SaveAsActivity = false;
        }
        if(this.IsSendEmail == false && this.IsAttachEmail == false){
            message = 'Please select Schedule Action Type!';
        } 
 
        if(this.IsSendEmail == true && this.addEmailRecipientsList.length==0){
            message = 'Please add Email Recipients!';
        }
        if(message==''){
            if(this.IsSendEmail == true && this.AvailableDocTemplate==''){
                message = 'Please Select Available Doc Template!';
            }
        }

        if(message==''){
            if(this.IsAttachEmail == true && this.AvailableDocTemplate==''){
                message = 'Please Select Available Doc Template!';
            }
        }

        if(message==''){
            if(this.IsSendEmail == true && this.StandardEmailTemplate=='' && this.JunoDocEmailTemplate==''){
                message = 'Please Select Standard Email Template or Juno Doc Email Template!';
            }
        }
    

     


        if(message!=''){
            this.selectedStep = '';
            this.selectedStep = 'Step3';
            this.ShowObjectDetails = false;
                    this.ShowScheduleSetUp = false;
                    this.showScheduleAction = true;
                    this.showScheduleConditions = false;
                    this.showPostScheduleActions = false;
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
           /* setTimeout(() => {
                this.isLoaded = false;
            }, 1000);*/
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
            console.log('this.ScheduleName--->'+this.ScheduleName);
            console.log('this.UsersEmailAddresses--->'+UsersEmailAddresses);
            console.log('this.ContactsEmailAddresses--->'+this.ContactsEmailAddresses);
            console.log('this.EmailAddresses--->'+this.EmailAddresses);
            console.log('this.EmailFields--->'+selectedEmailFields);
            console.log('this.AvailableDocTemplate--->'+this.AvailableDocTemplate);
            console.log('this.StandardEmailTemplate--->'+this.StandardEmailTemplate);
            console.log('this.JunoDocEmailTemplate--->'+this.JunoDocEmailTemplate);
            console.log('this.EmailSubject--->'+this.EmailSubject);
            console.log('email list--->'+JSON.stringify(this.addEmailRecipientsList));
           
            saveScheduleAction( 
                { 
                    ObjectName : this.SalesforceObject,
                    ScheduleName : this.ScheduleName,
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
                    IsSendEmail : this.IsSendEmail,
                    IsAttachEmail : this.IsAttachEmail,
                    AddEmailRecipientsList : this.addEmailRecipientsList
                } 
                
            )          
            
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    //this.isLoaded = false;
                    
                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    this.getSchSetup();
                    console.log(this.isLoaded + '---->1547' );
                    this.selectedStep = '';
                    this.selectedStep = 'Step4';
                    this.ShowObjectDetails = false;
                    this.ShowScheduleSetUp = true;
                    //this.showScheduleAction = false;
                    this.showScheduleConditions = false;
                    this.showPostScheduleActions = false;
                    /*if(this.savedbutton == true){
                        this.isLoaded = false;
                        this.savedbutton = false;
                    }*/
                    //this.isLoaded = false;
                    if(this.savedbutton == true){
                        this.DupeselectedStep = this.selectedStep;
                      }
                    console.log('resultsaveaction-->'+result);   
                }
            })
            .catch(error => {
                //this.isLoaded = false;
                console.log('error'+error);
                this.selectedStep = '';
                this.selectedStep = 'Step3';
                this.ShowObjectDetails = false;
                    this.ShowScheduleSetUp = false;
                    this.showScheduleAction = true;
                    this.showScheduleConditions = false;
                    this.showPostScheduleActions = false;
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
        

        
        /*if(this.savedbutton == true){
            this.isLoaded = false;
            this.savedbutton = false;
        }*/

    }

    handleSchedulerTypeOnChange(event){
        var SchedulerType = event.target.value;
        this.SchedulerType = SchedulerType;
        if(SchedulerType == 'Daily'){
            this.ShowScheduleHours = true;
            this.ScheduleHour = '';
            this.ScheduledClockFormat = '';
            this.ScheduleDates = [];
            this.ScheduleDays = [];
            this.ScheduleMonths = [];
            this.ShowScheduleDays = false;
            this.ShowScheduleDates = false;
            this.ScheduleLabel = '';
            this.Show_Y_accordion = false;
        }
        else if(SchedulerType == 'Weekly'){
            this.ShowScheduleHours = true;
            this.ScheduleHour = '';
            this.ScheduledClockFormat = '';
            this.ScheduleDates = [];
            this.ScheduleMonths = [];
            this.ShowScheduleDays = true;
            this.ShowScheduleDates = false;
            this.Show_Y_accordion = true;
            this.ScheduleLabel = 'Select Schedule Days';
        }
        else if(SchedulerType == 'Monthly'){
            this.ShowScheduleHours = true;
            this.ScheduleHour = '';
            this.ScheduledClockFormat = '';
            this.ScheduleDays = [];
            this.ShowScheduleDays = false;
            this.ShowScheduleDates = true;
            this.Show_Y_accordion = true;
            this.ScheduleLabel = 'Select Schedule Months & Dates';
        }
        else{
            this.ShowScheduleHours = false;
            this.ShowScheduleDays = false;
            this.ShowScheduleDates = false;
            this.ScheduleLabel = '';
            this.Show_Y_accordion = false;
        }
    }

    handleSchedulerWeekDayOnChange(event){
        var ScheduleDays = event.target.value;
        this.ScheduleDays = ScheduleDays;
    }
    handleSchedulerHourOnChange(event){
        var ScheduleHour = event.target.value;
        this.ScheduleHour = ScheduleHour;
    }
    handleSchedulerDateOnChange(event){
        var ScheduleDates = event.target.value;
        this.ScheduleDates = ScheduleDates;
    }
    handleSchedulerMonthOnChange(event){
        var ScheduleMonths = event.target.value;
        this.ScheduleMonths = ScheduleMonths;
    }
    handleSchedulerClockFormatOnChange(event){
        var ScheduledClockFormat = event.target.value;
        this.ScheduledClockFormat = ScheduledClockFormat;
    }

    handlePostScheduleActionClose(event){
        this.showPostScheduleActions = false;
        location.reload();
    }

    handleScheduleSetupClose(event){
        this.ShowScheduleSetUp = false;
        location.reload();
    }

    handleScheduleSetupSave(){
        //this.selectedStep = 'Step5';
        this.isLoaded = true;
        var SchedulerType = this.SchedulerType;
        var ScheduleDays = this.ScheduleDays;
        var ScheduleHour = this.ScheduleHour;
        var ScheduleDates = this.ScheduleDates;
        var ScheduleMonths = this.ScheduleMonths;
        var ScheduledClockFormat = this.ScheduledClockFormat;

        var message = '';

        if(ScheduledClockFormat == ''){
            message = 'Please select Schedule Time Format!';
        }
        if(SchedulerType == 'Daily' && ScheduleHour == ''){
            message = 'Please select Schedule Hour!';
        }
        else if(SchedulerType == 'Weekly' && ScheduleDays.length==0 && ScheduleHour == ''){
            message = 'Please select Schedule Days and select Schedule Hour!';
        }
        else if(SchedulerType == 'Weekly' && ScheduleDays.length==0){
            message = 'Please select Schedule Days!';
        }
        else if(SchedulerType == 'Weekly' && ScheduleHour == ''){
            message = 'Please insert Schedule Hour!';
        }
        else if(SchedulerType == 'Monthly' && ScheduleDates.length==0 && ScheduleHour == ''){
            message = 'Please select Schedule Dates and select Schedule Hour!';
        }
        else if(SchedulerType == 'Monthly' && ScheduleDates.length==0){
            message = 'Please select Schedule Dates!';
        }
        else if(SchedulerType == 'Monthly' && ScheduleHour == ''){
            message = 'Please select Schedule Hour!';
        }
        else if(SchedulerType == 'Monthly' && ScheduleMonths.length==0){
            message = 'Please select Schedule Month!';
        }

        if(message!=''){
           // this.isLoaded = false;
            this.selectedStep = '';
            this.selectedStep = 'Step4';
            this.ShowObjectDetails = false;
                    this.showScheduleConditions = false;
                    this.showScheduleAction = false;
                    this.ShowScheduleSetUp = true;
                    this.showPostScheduleActions = false;
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
            /*setTimeout(() => {
                this.isLoaded = false;
            }, 1000);*/
        }

        if(message == ''){
            saveScheduleSetup({
                ScheduleName : this.ScheduleName,
                SchedulerType : SchedulerType,
                ScheduleHour : ScheduleHour,
                ScheduleDates : ScheduleDates,
                ScheduleDays : ScheduleDays,
                ScheduleMonths : ScheduleMonths,
                ScheduledClockFormat : ScheduledClockFormat
            })
            .then((result) =>  {
                if(result!==undefined && result!=''){
                    //this.isLoaded = false;
                    //this.selectedStep = '';
                    //this.selectedStep = 'Step5';
                    this.ShowObjectDetails = false;
                    this.showScheduleConditions = false;
                    this.showScheduleAction = false;
                    //this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = true;
                    this.getPostSchActions();
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
                    //this.isLoaded = false;
                    console.log('result-->'+result);  
                    
                }
            })
            .catch(error => {
                //this.isLoaded = false;
                console.log('error'+error);
                this.selectedStep = '';
                this.selectedStep = 'Step4';
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

    addPostScheduleActionRow(){
        console.log('index----->'+this.PostScheduleActionKeyIndex);
        this.PostScheduleActionKeyIndex+1;
        console.log('index2----->'+this.PostScheduleActionKeyIndex);
        console.log('PostScheduleActionsWrapper----->'+this.PostScheduleActionsWrapper);
        console.log('PostScheduleActionsWrapper.length----->'+this.PostScheduleActionsWrapper.length);
        var rownumber = this.PostScheduleActionsWrapper.length+1;
        console.log('rownumber----->'+rownumber);
        this.PostScheduleActionsWrapper.push({
            RowNumber:rownumber,
            Field:'',
            Value:''
        });  
        this.ShowPostActsTable = true;
    }
    removePostScheduleActionRow(event){
        if(this.PostScheduleActionsWrapper.length>=1){
            this.PostScheduleActionsWrapper.splice(event.target.accessKey,1);
            this.PostScheduleActionKeyIndex-1;
        }

        for(var i=0;i<this.PostScheduleActionsWrapper.length;i++){
            this.PostScheduleActionsWrapper[i].RowNumber = (i+1);
        }
        if(this.PostScheduleActionsWrapper.length>0){
            this.ShowPostActsTable = true;
        }
        else{
            this.ShowPostActsTable = false;
        }

    } 

    handlePostScheduleActionBack(event){
        this.showPostScheduleActions = false;
        this.selectedStep = 'Step4';
        this.DupeselectedStep = this.selectedStep;
        this.ShowScheduleSetUp = true;
        this.showScheduleAction = false;
        this.ShowObjectDetails = false;
        this.showScheduleConditions = false;
    }

    handleScheduleSetupBack(event){
        this.ShowScheduleSetUp = false;
        this.selectedStep = 'Step3';
        this.DupeselectedStep = this.selectedStep;
        this.showScheduleAction = true;
        this.ShowObjectDetails = false;
        this.showPostScheduleActions = false;
        this.showScheduleConditions = false;
    }

    handlePostScheduleActionClose(event){
        this.ShowScheduleSetUp = false;
        //this.selectedStep = 'Step3';
        this.showScheduleAction = false;
        this.ShowObjectDetails = false;
        this.showPostScheduleActions = false;
        this.showScheduleConditions = false;
        this.ShowHomeScreen = true;
        location.reload();
    }

    handleScheduleSetupClose(event){
        this.ShowScheduleSetUp = false;
    }

    


    handlePostScheduleActionOnChange(event){       

        if(event.target.name==='PostScheduleActionField'){
            this.PostScheduleActionsWrapper[event.target.accessKey].Value='';
            var fieldName=event.target.value;
            var msg='';
           


            if(msg==''){
                this.PostScheduleActionsWrapper[event.target.accessKey].Field = fieldName;
                for(var i=0;i<this.ObjectFieldsWrapper.length;i++){

                    if(event.target.value==this.ObjectFieldsWrapper[i].value){
                        this.PostScheduleActionsWrapper[event.target.accessKey].type=this.ObjectFieldsWrapper[i].type;
                        if(this.ObjectFieldsWrapper[i].type=='BOOLEAN'){
                            this.PostScheduleActionsWrapper[event.target.accessKey].isBoolean = true;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isPicklist = false;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isText = false;
                            //this.PostScheduleActionsWrapper[event.target.accessKey].picklistValues = this.ObjectFieldsWrapper[i].picklistValues;
                        }
                        else if(this.ObjectFieldsWrapper[i].type=='PICKLIST'){                            
                            this.PostScheduleActionsWrapper[event.target.accessKey].isPicklist = true;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isBoolean = false;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isText = false;
                            this.PostScheduleActionsWrapper[event.target.accessKey].picklistValues = this.ObjectFieldsWrapper[i].picklistValues;
                        }
                        else{
                            this.PostScheduleActionsWrapper[event.target.accessKey].isBoolean = false;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isPicklist = false;
                            this.PostScheduleActionsWrapper[event.target.accessKey].isText = true;
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
        else if(event.target.name==='PostScheduleActionValue'){
            this.PostScheduleActionsWrapper[event.target.accessKey].Value=event.target.value;
        }
    }

    handlePostScheduleActionSave(){
        //this.selectedStep = 'Step5';
        this.isLoaded = true;
        var message = '';
        if(this.PostScheduleActionsWrapper.length>0){
            var FieldNames=[];
            for(let i=0; i< this.PostScheduleActionsWrapper.length; i++) {
                var field = this.PostScheduleActionsWrapper[i].Field;
                var value = this.PostScheduleActionsWrapper[i].Value;
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
            this.selectedStep = 'Step5';
            this.ShowObjectDetails = false;
                    this.showScheduleConditions = false;
                    this.showScheduleAction = false;
                    this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = true;
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
           // this.isLoaded = false;
        }


        if(message==''){

            savePostScheduleActions( 
               
                { 
                    ObjectName : this.SalesforceObject, 
                    ScheduleName : this.ScheduleName,
                    records : JSON.stringify(this.PostScheduleActionsWrapper),
                    DocTempID :this.AvailableDocTemplate
                } 
                
            )          
            .then((result) =>  {
                if(result!==undefined && result!=''){
                   // this.isLoaded = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                   this.ShowHomeScreen = true;
                  
                    //this.isLoaded = false;
                    console.log('result-->'+result);  
                    
                    location.reload();
                }
            })
            .catch(error => {
                console.log('error'+error);
                this.selectedStep = 'Step5';
                this.ShowObjectDetails = false;
                    this.showScheduleConditions = false;
                    this.showScheduleAction = false;
                    this.ShowScheduleSetUp = false;
                    this.showPostScheduleActions = true;
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

    handleNewScheduleNext2(){
        this.savedbutton = true;
        this.selectedStep = '';
       // this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.handleNewScheduleNext();
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 800);
        //this.DupeselectedStep = this.selectedStep;
       // this.isLoaded = false;
    }

    handleScheduleConditionsSave2(){
        this.selectedStep = '';
        //this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handleScheduleConditionsSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 1500);
    }

    handleScheduleActionSave2(){
        this.selectedStep = '';
       // this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handleScheduleActionSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 1500);
    }

    handleScheduleSetupSave2(){
        this.selectedStep = '';
        //this.DupeselectedStep = '';
        //this.selectedStep = '';
        this.savedbutton = true;
        this.handleScheduleSetupSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 1200);
    }

    handlePostScheduleActionSave2(){
        this.selectedStep = '';
        //this.DupeselectedStep = '';
       // this.selectedStep = '';
        this.savedbutton = true;
        this.handlePostScheduleActionSave();
        //this.DupeselectedStep = this.selectedStep;
        setTimeout(() => {
        
            this.isLoaded = false;
            //this.DupeselectedStep = this.selectedStep;
        }, 800);
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

    getSchAction(){
        if(this.createNewScheduleAction == false){
            this.selectedStep = '';
        }
        
       /* if(this.savedbutton == true){
            console.log('2203');
            this.isLoaded = false;
            this.savedbutton = false;
        } 
        else{
            console.log('2208');
            this.isLoaded = true;
        }*/
        getScheduleAction({ ObjectName : this.SalesforceObject,
            ScheduleName : this.ScheduleName

         } )
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                console.log('result---->'+JSON.stringify(result));
                
                this.selectedEmailFieldsMultiPicklistValues = [];
                this.selectedUserEmailsList = [];
                this.selectedContactEmailsList = [];
             
                //this.SalesforceObject = actionObject; 
                this.EmailFieldsMultiPicklist = result.EmailFields;
                this.AvailableDocTemplatesList = result.AvailableDocTemplatesList; 
                this.StandardEmailTemplatesList = result.StandardEmailTemplatesList;
                this.JunoDocEmailTemplatesList = result.JunoDocEmailTemplatesList;
                this.addEmailRecipientsList = result.AddEmailRecipientsList;
                this.OrgwideEmailAddressList = result.OrgwideEmailAddressList;
                if(this.addEmailRecipientsList.length>0){
                    this.showRecips = true;
                }
                else{
                    this.showRecips = false;
                }
                
                

                
                console.log('result1006---->'+JSON.stringify(result.ScheduleActionRec));
                if(Object.keys(result.ScheduleActionRec).length != 0){ 
                    console.log('result1044---->'+JSON.stringify(result.ScheduleActionRec));
                    
                    this.IsSendEmail = result.ScheduleActionRec.JunoDoc__Junodoc_Is_Send__c;
                    
                    this.IsAttachEmail = result.ScheduleActionRec.JunoDoc__Junodoc_Is_Attach__c;

                    var UsersEmailAddresses = result.ScheduleActionRec.JunoDoc__Junodoc_Users_Email_Addresses__c;
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
                    var ContactsEmailAddresses = result.ScheduleActionRec.JunoDoc__Junodoc_Contacts_Email_Addresses__c;
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
                    this.EmailAddresses = result.ScheduleActionRec.JunoDoc__Junodoc_Email_Addresses__c;
                    if(this.EmailAddresses==undefined){
                        this.EmailAddresses = '';
                    }

                    this.FromEmailAddress = result.ScheduleActionRec.JunoDoc__Junodoc_From_Email_Address__c;
                    if(this.FromEmailAddress==undefined){
                        this.FromEmailAddress = '';
                    }

                    this.SetReplyTo = result.ScheduleActionRec.JunoDoc__Junodoc_Set_Reply_To__c;
                    if(this.SetReplyTo==undefined){
                        this.SetReplyTo = '';
                    }

                    this.SetSenderDisplayName = result.ScheduleActionRec.JunoDoc__Junodoc_Set_Sender_Display_Name__c;
                    if(this.SetSenderDisplayName==undefined){
                        this.SetSenderDisplayName = '';
                    }

                    
                

                    var selectedEmailFields = result.ScheduleActionRec.JunoDoc__Junodoc_Email_Fields__c;
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
                    this.AvailableDocTemplate = result.ScheduleActionRec.JunoDoc__Junodoc_Available_Doc_Template__c;
                    if(this.AvailableDocTemplate==undefined){
                        this.AvailableDocTemplate = '';
                    }
                    this.JunoDocEmailTemplate = result.ScheduleActionRec.JunoDoc__Junodoc_Doc_Email_Template__c;
                    if(this.JunoDocEmailTemplate==undefined){
                        this.JunoDocEmailTemplate = '';
                    }
                    this.StandardEmailTemplate = result.ScheduleActionRec.JunoDoc__Junodoc_Standard_Email_Template__c;
                    if(this.StandardEmailTemplate==undefined){
                        this.StandardEmailTemplate = '';
                    }
                    this.EmailSubject = result.ScheduleActionRec.JunoDoc__Junodoc_Email_Subject__c;
                    if(this.EmailSubject==undefined){
                        this.EmailSubject = '';
                    }
                    this.SaveAsActivity = result.ScheduleActionRec.JunoDoc__Junodoc_Save_as_Activity__c;
                    if(this.SaveAsActivity==undefined){
                        this.SaveAsActivity = true;
                    }
                    console.log('JunoDocEmailTemplate--->'+this.JunoDocEmailTemplate);
                    console.log('StandardEmailTemplate--->'+this.StandardEmailTemplate);                   
                    if(result.ScheduleActionRec.Name!=undefined){
                        this.showScheduleActionNextButton = true;
                    }
                    
                }
                else{
                   this.getObjectSettings();
                }
                if(this.IsSendEmail==undefined){
                    this.IsSendEmail = false;
                }

        if(this.IsSendEmail==true){
        this.ToSendEmail = true;
        }

        if(this.IsAttachEmail==undefined){
            this.IsAttachEmail = false;
        }
        if(this.IsAttachEmail==true){
            this.ToAttachEmail = true;
            }

        var Attach = this.IsAttachEmail;
var Send = this.IsSendEmail;

if(Attach == true || Send == true){
this.ToAttachEmail = true;
}
else{
this.ToAttachEmail = false;
}



if(this.createNewScheduleAction == false && (this.showScheduleConditions == true || this.ShowScheduleSetUp == true || this.showPostScheduleActions == true)){
    console.log('2238');
    //this.selectedStep = '';
                this.selectedStep = 'Step3';
    if(this.showScheduleConditions == true){
        console.log('2240');
        //this.isLoaded = true;
        this.showScheduleConditions = false;
        this.ShowObjectDetails = false;
                this.showScheduleAction = true;
                this.ShowScheduleSetUp = false;
                this.showPostScheduleActions = false;
                /*setTimeout(() => {
                    this.isLoaded = false;
                }, 1000);*/
    }
    else if(this.ShowScheduleSetUp == true){
        console.log('2249');
        //this.isLoaded = true;
        //this.selectedStep = '';
                this.selectedStep = 'Step3';
                console.log(this.selectedStep);
        this.showScheduleConditions = false;
        this.ShowObjectDetails = false;
                this.showScheduleAction = true;
                this.ShowScheduleSetUp = false;
                this.showPostScheduleActions = false;
        /*this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Updated your Schedule Actions',
                variant: 'success'
            })
        );*/
        /*setTimeout(() => {
            this.isLoaded = false;
        }, 1000);*/
    }
    else if(this.showPostScheduleActions == true){
        console.log('2265');
       // this.isLoaded = true;
       //this.selectedStep = '';
                this.selectedStep = 'Step3';
        this.showScheduleConditions = false;
        this.ShowObjectDetails = false;
                this.showScheduleAction = true;
                this.ShowScheduleSetUp = false;
                this.showPostScheduleActions = false;
        /*this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Updated your Schedule Actions',
                variant: 'success'
            })
        );*/
       /* setTimeout(() => {
            this.isLoaded = false;
        }, 1000);*/
    }
    
    

}
else{
    console.log('2285');
   // this.isLoaded = true;
    this.selectedStep = 'Step3';
    this.showScheduleConditions = false;
        this.ShowObjectDetails = false;
                this.showScheduleAction = true;
                this.ShowScheduleSetUp = false;
                this.showPostScheduleActions = false;
                /*setTimeout(() => {
                    this.isLoaded = false;
                }, 1000);*/
}
                console.log('SaveAsActivity--->'+this.SaveAsActivity);
                if(this.savedbutton == true){
                    this.DupeselectedStep = this.selectedStep;
                  } 
                  else{
                    this.DupeselectedStep = this.selectedStep;
                  }
            
            }
        
        })
        .catch(error => {
            /*setTimeout(() => {
                this.isLoaded = false;
            }, 1000);*/
            this.message = undefined;
            this.error = error;
            console.log('error'+error);
            this.selectedStep = '';
            this.selectedStep = 'Step2';
            this.ShowObjectDetails = false;
            this.showScheduleConditions = true;
            this.showScheduleAction = false;
            this.ShowScheduleSetUp = false;
            this.showPostScheduleActions = false;
            /*this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while fetching fields',
                    message: this.error,
                    variant: 'error'
                })
            );*/
        });
    }

    getSchSetup(){
        /*if(this.savedbutton == true){
            this.isLoaded = false;
            this.savedbutton = false;
        } 
        else{
            this.isLoaded = true;
        }*/
        getScheduleSetup({ScheduleName : this.ScheduleName})
        .then((result) =>  {
            console.log('result2225---->'+result);
            if(result!==undefined && result!=''){
                
                this.SchedulerTypeList = result.SchedulerTypeList;
                this.SchedulerWeekDays = result.SchedulerWeekDays;
                this.SchedulerHoursList = result.SchedulerHoursList;
                this.SchedulerDatesList = result.SchedulerDatesList;
                this.ScheduleClockFormats = result.ScheduleClockFormats;
                this.SchedulerMonthsList = result.SchedulerMonthsList;
                this.UserGMTvalue = result.UserGMT;

                this.SchedulerType = result.ScheduleSetUpRec.JunoDoc__Junodoc_Scheduler_Type__c;
                if(this.SchedulerType == undefined){
                    this.SchedulerType = '';
                }

    

                this.ScheduleHour = result.ScheduleSetUpRec.JunoDoc__Junodoc_Selected_Schedule_Hour__c;
                if(this.ScheduleHour == undefined){
                    this.ScheduleHour = '';
                }

                this.ScheduledClockFormat = result.ScheduleSetUpRec.JunoDoc__Junodoc_Clock_Format__c;
                if(this.ScheduledClockFormat == undefined){
                    this.ScheduledClockFormat = '';
                }

                this.ScheduleDates = result.ScheduledDates;
                console.log('ScheduleDates----->'+this.ScheduleDates);
                if(this.ScheduleDates == undefined){
                    this.ScheduleDates = [];
                }
                this.ScheduleDays = result.ScheduledDays;
                console.log('ScheduleDays----->'+this.ScheduleDays);
                if(this.ScheduleDays == undefined){
                    this.ScheduleDays = [];
                }
                this.ScheduleMonths = result.ScheduledMonths;
                console.log('ScheduleMonths----->'+this.ScheduleMonths);
                if(this.ScheduleMonths == undefined){
                    this.ScheduleMonths = [];
                }

                if(this.SchedulerType == 'Daily'){
                    this.ShowScheduleHours = true;
                    this.ShowScheduleDays = false;
                    this.ShowScheduleDates = false;
                    this.Show_Y_accordion = false;
                    this.ScheduleLabel = '';
                }
                else if(this.SchedulerType == 'Weekly'){
                    this.ScheduleLabel = 'Select Schedule Days';
                    this.ShowScheduleHours = true;
                    this.ShowScheduleDays = true;
                    this.Show_Y_accordion = true;
                    this.ShowScheduleDates = false;
                }
                else if(this.SchedulerType == 'Monthly'){
                    this.ScheduleLabel = 'Select Schedule Months & Dates';
                    this.ShowScheduleHours = true;
                    this.ShowScheduleDays = false;
                    this.ShowScheduleDates = true;
                    this.Show_Y_accordion = true;
                }
                else{
                    this.ScheduleLabel = '';
                    this.ShowScheduleHours = false;
                    this.ShowScheduleDays = false;
                    this.ShowScheduleDates = false;
                    this.Show_Y_accordion = false;
                }
                
                
                if(this.createNewScheduleAction == false && this.showScheduleAction == false){
                    this.selectedStep = '';
                this.selectedStep = 'Step4';
                    console.log('2512');
                    this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.ShowScheduleSetUp = true;
                this.showPostScheduleActions = false;
                /*this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updated your Schedule Actions',
                        variant: 'success'
                    })
                );*/
                /*setTimeout(() => {
                    this.isLoaded = false;
                }, 1000);*/
                }
                else{
                    console.log('2530');
                    
                    this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.ShowScheduleSetUp = true;
                this.showPostScheduleActions = false;
                //this.selectedStep = '';
                this.selectedStep = 'Step4';
                this.DupeselectedStep = this.selectedStep;
                    /*setTimeout(() => {
                        this.isLoaded = false;
                    }, 1000);*/
                }
                //this.isLoaded = false;
                console.log('result-->'+result);   
            }
        })
        .catch(error => {
            /*setTimeout(() => {
                this.isLoaded = false;
            }, 1000);*/
            console.log('error'+error);
            
                this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = true;
                this.ShowScheduleSetUp = false;
                this.showPostScheduleActions = false;
                this.selectedStep = '';
                this.selectedStep = 'Step3';
                this.DupeselectedStep = this.selectedStep;
        }
        );
    }
    getPostSchActions(){
        /*if(this.savedbutton == true){
            this.isLoaded = false;
            this.savedbutton = false;
        } 
        else{
            this.isLoaded = true;
        }*/
        //this.selectedStep = '';
        getPostScheduleAction({ ObjectName : this.SalesforceObject,
            ScheduleName : this.ScheduleName

         } )
        .then((result) =>  {              
            console.log('result2315---->'+JSON.stringify(result));     
            if(result!==undefined && result!=''){
                
                console.log('result---->'+JSON.stringify(result));
                this.PostScheduleActionsWrapper = result;
                if(this.PostScheduleActionsWrapper.length>0){
                    this.ShowPostActsTable = true;
                }
                else{
                    this.ShowPostActsTable = false;
                }
                
                
                if(this.createNewScheduleAction == false && this.ShowScheduleSetUp == false){
                    this.ShowScheduleSetUp = false;
                    this.selectedStep = '';
                this.selectedStep = 'Step5';
                this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.showPostScheduleActions = true;
               /* this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updated your Schedule Actions',
                        variant: 'success'
                    })
                );*/
                /*setTimeout(() => {
                    this.isLoaded = false;
                }, 1000);*/
                }
                else{
                    this.ShowScheduleSetUp = false;
                    this.selectedStep = '';
                this.selectedStep = 'Step5';
                this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.showPostScheduleActions = true;
                    /*setTimeout(() => {
                        this.isLoaded = false;
                    }, 1000);*/
                }
            }
            else{
                
                //this.isLoaded = true;
                
                
                if(this.createNewScheduleAction == false && this.ShowScheduleSetUp == false){
                    this.selectedStep = '';
                this.selectedStep = 'Step5';
                    this.ShowScheduleSetUp = false;
                    this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.showPostScheduleActions = true;
                /*this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updated your Schedule Actions',
                        variant: 'success'
                    })
                );*/
                /*setTimeout(() => {
                    this.isLoaded = false;
                }, 1000);*/
                }
                else{
                    this.ShowScheduleSetUp = false;
                    this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.showPostScheduleActions = true;
                this.selectedStep = '';
                this.selectedStep = 'Step5';
                    /*setTimeout(() => {
                        this.isLoaded = false;
                    }, 1000);*/
                }
               // this.PostScheduleActionsWrapper = [];
            }
            if(this.savedbutton == true){
                this.DupeselectedStep = this.selectedStep;
              } 
        })
        .catch(error => {
            /*setTimeout(() => {
                this.isLoaded = false;
            }, 1000);*/
            console.log('error'+error);
            this.selectedStep = '';
            this.selectedStep = 'Step4';
            this.ShowObjectDetails = false;
                this.showScheduleConditions = false;
                this.showScheduleAction = false;
                this.showPostScheduleActions = false;
                this.ShowScheduleSetUp = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while fetching fields',
                    message: this.error,
                    variant: 'error'
                })
            );
            //this.isLoaded = false;
        });
    }
}
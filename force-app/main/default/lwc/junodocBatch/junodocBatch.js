import { LightningElement,api,wire,track } from 'lwc';
import getPageloadDataHelper from '@salesforce/apex/JunodocBatchController.getPageloadDataHelper';
import getObjectDataHelper from '@salesforce/apex/JunodocBatchController.getObjectDataHelper';
import getSelectedPicklistValues from '@salesforce/apex/JunodocBatchController.getSelectedPicklistValues';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getAllRecords from '@salesforce/apex/JunodocBatchController.getAllRecords';
import SaveQueryToObject from '@salesforce/apex/JunodocBatchController.SaveQueryToObject';
import getQueryBatch from '@salesforce/apex/JunodocBatchController.getQueryBatch';
import ExecuteSearchQuery from '@salesforce/apex/JunodocBatchController.ExecuteSearchQuery';
import savePostTriggerActions from '@salesforce/apex/JunodocBatchController.savePostTriggerActions';
import getAvailableDocTemplates from '@salesforce/apex/JunodocBatchController.getAvailableDocTemplates';
import SaveTemplateAndPostActions from '@salesforce/apex/JunodocBatchController.SaveTemplateAndPostActions';
import DynamicListView_ACAction from '@salesforce/apex/DynamicListView_AC.getOrgWideEmails';
import getEmailTemplatesAction from '@salesforce/apex/DynamicListView_AC.getEmailTemplates';
import getBodyFromEmailTemplateAction from '@salesforce/apex/DynamicListView_AC.getBodyFromEmailTemplate';
import getBodyFromJunoDocEmailTemplate1Action from '@salesforce/apex/DynamicListView_AC.getBodyFromJunoDocEmailTemplate1';
import getrecorddetailsAction from '@salesforce/apex/DynamicListView_AC.getrecorddetails';
import SendPDFBatchAction from '@salesforce/apex/DynamicListView_AC.SendPDFBatch';
import getMultiPDFData from '@salesforce/apex/JunodocLaunchBatch.getMultiPDFData';
import getConsolidatedData from '@salesforce/apex/JunodocLaunchBatch.getConsolidatedData';
import getSessionId from '@salesforce/apex/JunodocLaunchBatch.getSessionId';

import { CurrentPageReference, } from "lightning/navigation";
const columns = [
    { label: 'Name',  fieldName: 'nameUrl',type: 'url',
    typeAttributes: {label: { fieldName: 'Name'}, 
    target: '_top'},sortable: true},
    //{ label: 'Owner', fieldName: 'OwnerName',type:'text'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
   
];
const CaseColumnsList = [

    { label: 'Case Number',  fieldName: 'nameUrl',type: 'url',
    typeAttributes: {label: { fieldName: 'CaseNumber'}, 
    target: '_top'},sortable: true},
    //{ label: 'Owner', fieldName: 'OwnerName',type:'text'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
   
];
const WorkOrderColumnsList = [

    { label: 'Work Order Number',  fieldName: 'nameUrl',type: 'url',
    typeAttributes: {label: { fieldName: 'WorkOrderNumber'}, 
    target: '_top'},sortable: true},
    //{ label: 'Owner', fieldName: 'OwnerName',type:'text'},
    { label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
   
];
export default class JunodocBatch extends LightningElement {
    //@track columns;
    @api addEmailRecipientsList = [];
    activeSections = ['A','B','C','D','S'];
    @track OrgwideEmailAddressList = [];
    @track FromEmailAddress ='';
    @track StandardEmailTemplatesList = [];
    @track StandardEmailTemplate = '';
    @track JunoDocEmailTemplatesList = [];
    @track JunoDocEmailTemplate = '';
    @track subject = '';
    @track body = '';
    @track SetReplyTo = '';
    @track ToTextEmailsList = [];
    @track ToEmailMergeFieldsList = [];
    @track CCTextEmailsList = [];
    @track CCEmailMergeFieldsList = [];
    @track BCCTextEmailsList = [];
    @track BCCEmailMergeFieldsList = [];
    columns = columns;
    CaseColumnsList = CaseColumnsList;
    WorkOrderColumnsList = WorkOrderColumnsList;
    @track CaseColumns;
    @track WorkOrderColumns;
    @api visualpage = false;
    @track disableupdate = true;
    @api AvailableForSearchOptions=[];
    @track closeModal = true;
    @track isLoaded = false;
    @track ObjectLabel = '';
    @track searchKey = '';
    @track searchObjectsList = [];
    @track showSearchObjects = false;

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
    @track TriggerConditionsWrapper=[];
    @track filterConditionsValue='';
    @track TriggerActionsList=[];
    @track TriggerActionKeyIndex=0; 
    @track showRecords=false;
    @track ObjectsList=[];

    @track openPicklistModal = false;
    @track pickListValuesList = [];
    @track selectedPicklistLabel = '';
    @api booleanOptions=[
         {label:'true',value:'true'},
         {label:'false',value:'false'}
     ];
 
    @track showTriggerConditions = false;
    @track showTriggerAction = false; 
    
  
    @track showPostTriggerActions = false;
    @track showTriggerConditionsNextButton = false;
    @track showTriggerActionNextButton = false;
    @track PostTriggerActionsWrapper=[];
    @track openSaveQuery=false;
    @track AvailableForSearchValue='';
    @track AvailableForSearchLabel='';
    @track batchName='';
    @track FirstNextScreen=false;
    @track SaveCriteriaScreen=false;
    @track SecondNextScreen=false;
    @track selectedStep = '';
    @track sessionId= '';
    @track progressValue = 50;
    @track progressVariant = 'base';
    @track showProgress = false;
    connectedCallback() {
        let reloadEventDetail = true;
        let reloadEvent = new CustomEvent('pageReload',{
            detail: {reloadEventDetail},
        });
        this.dispatchEvent(reloadEvent);
        //window.location.reload();
        //eval("$A.get('e.force:refreshView').fire();");
        this.isLoaded = true;
        //this.isShowRecordsDisable = true;
        if(this.showRecords == false && this.AvailableForSearchValue=='' && this.TriggerConditionsWrapper =='' && (this.filterConditionsValue==undefined || this.filterConditionsValue=='')){
            this.saveQueryDisable = true;
        }
        this.fetchPageloadDataHelper();
        
        getSessionId()
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                this.sessionId = result;
            }
        })
       
    }

    handleToggleSection(event) {

        console.log( 'Selected Sections ' + event.detail.openSections );

    }

    @wire(DynamicListView_ACAction)
    getOrgEmails({error,data}){
        if(data){
            this.OrgwideEmailAddressList = data;
        }
        else{
            console.log(JSON.stringify(error))
        }
    }
   
@wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;

        if (currentPageReference.state) {
            console.log("this.activeTab", currentPageReference);
            this.ObjectLabel = '';
            this.selectedStep = 'Step1';
            this.SecondNextScreen = false;
            this.ThirdNextScreen = false;
            this.FourthNextScreen = false;
            this.isPOPupOpen = false;
            this.showTriggerConditions = false;
            this.FirstNextScreen = false;
            this.showRecords = false;
            this.showSearchObjects = false
            this.searchObjectsList=[];
            this.selectedRecords=[];
            this.SalesforceObject=[];
        }
        if(this.selectedStep == 'Step1'){
            this.selectedStep = '';
        }
    }
    handleInputFocus(event) {
        console.log('onfocus fired');
        //console.log(event.target.name);
      // window.location.reload();
    }  
    renderedCallback() {
        console.log('Fired');
        //window.location.reload();
        //do something
    }
    fetchPageloadDataHelper(){
        console.log('trigger actions');
        this.isLoaded = true;

        getPageloadDataHelper()
        .then((result) =>  {                   
            if(result!==undefined && result!=''){
                this.isLoaded = false;
                console.log('result---->'+result);
                this.ObjectsList = result;
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
    ObjectChangeHandler(event){
        var actionObject = event.target.value;
        /*if(this.selectedStep == ''){
            this.selectedStep = 'Step1';
        }
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step1'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step5';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step6';
        }*/
       
        this.SalesforceObject = actionObject;
      
        this.fetchObjectDataHelper(actionObject);

    }
    @track batchID = '';
    fetchObjectDataHelper(actionObject){
        this.isLoaded = true;
        var isSearch=false;
        this.TriggerConditionsWrapper =[];
        this.filterConditionsValue=undefined;
        this.AvailableForSearchValue = '';  
        //this.isShowRecordsDisable = true;
        //this.saveQueryDisable = true;
        for(var i=0;i<this.ObjectsList.length;i++){
            if(actionObject==this.ObjectsList[i].value){
                this.ObjectLabel = this.ObjectsList[i].label;
                isSearch = true;
                break;
            }
        }

        console.log('trigger action--->'+actionObject);

        if(isSearch){
            getObjectDataHelper({ ObjectName : actionObject } )
            .then((result) =>  {                   
                if(result!==undefined && result!=''){
                    console.log('result---->'+result);
                    this.isLoaded = false;
                    this.SalesforceObject = actionObject; 
                    //this.TriggerConditionsWrapper = result.TriggerConditionsList;
                    this.ObjectFieldsWrapper = result;
                    console.log('ObjectFieldsWrapper '+this.ObjectFieldsWrapper);
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

        getQueryBatch({objectName:this.SalesforceObject})
        .then(result => {
            console.log(' getQueryBatch result '+result);
            this.AvailableForSearchOptions = result;   
            
            
            console.log('this.AvailableForSearchOptions  '+JSON.stringify(this.AvailableForSearchOptions));
            this.isLoaded = false;  
        })
        .catch(error => {
            console.log('error ****'+error);
            this.isLoaded = false;
        });

    }

    @track triggerConditionIndex=0; 
    @track NewlyAddedFilter='';
    addTriggerConditionRow(){
        this.isShowRecordsDisable = false;
        this.showRecords = false;
        this.NewlyAddedFilter='';
       // this.getRecords=[];
        //this.AvailableForSearchValue = '';
        if(this.SalesforceObject!=''){
            this.triggerConditionIndex+1;    
            if(this.TriggerConditionsWrapper.length<=0){
               
               
            }else{
                this.saveQueryDisable = false;
            }
            var rownumber = this.TriggerConditionsWrapper.length+1;

            this.TriggerConditionsWrapper.push({
                RowNumber:rownumber,
                field:'',
                Operator:'',
                fieldValue:'',
                type:'',
                isPicklist:false,
                isBoolean:false
            });    

            console.log('New condition' + this.filterConditionsValue);
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
                this.NewlyAddedFilter = ' AND ' + this.TriggerConditionsWrapper.length;
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
        //alert(JSON.stringify(this.TriggerConditionsWrapper[event.target.accessKey]));
        //this.filterConditionsValue = '';
        this.filterConditionsValue = this.filterConditionsValue.replace(this.NewlyAddedFilter, '');
        if(this.TriggerConditionsWrapper.length>=1){
            this.TriggerConditionsWrapper.splice(event.target.accessKey,1);
            this.triggerConditionIndex-1;
        }

        for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            this.TriggerConditionsWrapper[i].RowNumber = (i+1);
        }
        if(this.TriggerConditionsWrapper.length<=0){
            this.getRecords =[];
            this.isShowRecordsDisable = true;
            this.saveQueryDisable = true;
        }else{
            this.isShowRecordsDisable = false;
            this.saveQueryDisable = false;
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


    @track selectedPicklistField = '';
    handleSearchPicklistClick(event){
        this.optionValues = [];

        this.selectedPicklistField = this.TriggerConditionsWrapper[event.target.accessKey].field;
        
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
    @track openPicklist = false;
   // @track selectedPicklistField = '';
    handlePicklistClick(event){
        this.optionValues = [];

        this.selectedPicklistField = this.PostTriggerActionsWrapper[event.target.accessKey].Field;
        
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
                this.openPicklist = true;   
                for(var i=0;i<this.PostTriggerActionsWrapper.length;i++){
                    var loopField = this.PostTriggerActionsWrapper[i].field;
                    if(loopField==this.selectedPicklistField){  
                        this.picklistVal = this.PostTriggerActionsWrapper[i].Value;
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
    @track picklistVal='';

    get selectedPicklistValues() {
        return this.optionValues.join(',');
    }

    handlePickListValueChange(event) {  
        this.optionValues = event.target.value;
        //alert(event.target.value);
    }

    posthandlePickListValueChange(event) {  
        this.picklistVal = event.target.value;
        //alert(event.target.value);
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
    PicklistInsertValues(){
        var selectedPicklistField = this.selectedPicklistField;
        for(var i=0;i<this.PostTriggerActionsWrapper.length;i++){
            var loopField = this.PostTriggerActionsWrapper[i].Field;
            if(loopField==selectedPicklistField){  
                this.PostTriggerActionsWrapper[i].Value = this.picklistVal;
                this.selectedPicklistValues = [];
                this.picklistVal = [];
                this.selectedPicklistField = '';
                this.openPicklist = false;   
            }
        }   
    }
    closePicklistModal(){
        this.selectedPicklistField = '';
        this.selectedPicklistValues = [];
        this.optionValues = [];
        this.openPicklistModal = false;   
        this.openPicklist = false;   
        this.picklistVal = '';
    }

    handleChange(event){
        //alert(event.target.value);
       
        this.getRecords = [];
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
            console.log('this.searchObjectsList.length '+this.searchObjectsList.length);
            this.showSearchObjects = true;            
        }else{
            this.showSearchObjects = false;
        }
        
    }
    @track getRecords=[];
    handleSearchOnClick(event){
        this.showSearchObjects = false;
        this.SalesforceObject = '';
        var searchObjectLabel = event.currentTarget.dataset.item;
        for (var i = 0; i < this.ObjectsList.length; i++) {           
            if (searchObjectLabel == this.ObjectsList[i].value) {
                this.ObjectLabel = searchObjectLabel;
                this.SalesforceObject = this.ObjectsList[i].value;
                break;                
            }
        }
       /* if(this.SalesforceObject!='' && this.SalesforceObject!=null){
            this.selectedStep = 'Step2';
        } */
        if(this.SalesforceObject!=''){
            this.fetchObjectDataHelper(this.SalesforceObject);
        }
        if( this.SalesforceObject!=''){
            this.showTriggerConditions = true;
            this.getRecords = '';
           
        }
        else{
            this.showTriggerConditions = false; 
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
   

    rowOffset = 0;
    @track message='';
    @track isLoaded=false;
    @track query = '';
    @track isCaseObject =false;
    @track isWorkOrderObject =false;
    handleShowRecords(){
        this.showTriggerConditions = true;
        this.isPOPupOpen = false;
        this.showSearchObjects = false;
        //this.isProgressBarVisible = true;
        this.FirstNextScreen = true;
        this.showRecords = true;
        this.isLoaded = true;
        var getselectedStep = '';
        if(getselectedStep === ''){
            this.selectedStep = 'Step1';
        }else if(getselectedStep === 'Step1'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step4';
        }
        /*else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step5';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step6';
        }*/
        console.log('hii');
        var msg = '';
        console.log('object '+this.SalesforceObject);
        console.log('TriggerConditionsWrapper '+JSON.stringify(this.TriggerConditionsWrapper));
        console.log(this.filterConditionsValue);
       // this.AvailableForSearchValue = '--None--';
       for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            if(this.TriggerConditionsWrapper[i].field == '' && this.TriggerConditionsWrapper[i].fieldValue == '' && this.TriggerConditionsWrapper[i].Operator == ''){
              msg = 'Please Enter value(s)';
            }
            else if(this.TriggerConditionsWrapper[i].Operator == '' || this.TriggerConditionsWrapper[i].fieldValue == ''){
               msg = 'Please Enter value(s)';
            }
       }
       if(this.TriggerConditionsWrapper=='' && this.filterConditionsValue==undefined){
        this.showRecords = false;
        msg = 'Please add conditions and check formula for filter conditions';
    }
       if(msg!=''){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error while getting records',
                message: msg,
                variant: 'error'
            })
        );
        this.isLoaded = false;
       }
       
        if(msg==''){
             this.saveQueryDisable = false;
            //alert('before calling');
            getAllRecords({selectedObject:this.SalesforceObject,
                listOfRecords:JSON.stringify(this.TriggerConditionsWrapper),
                filterCons:this.filterConditionsValue})
                .then(result => {
                    if(result!=''){
                        this.showRecords = true; 
                        //alert('after calling');
                        //alert(JSON.stringify(JSON.stringify(result.recordsList)));
                        /*this.getRecords = result.recordsList.map(record => Object.assign(
                            { "nameUrl": '/'+record.Id},
                            record
                        ));*/
                        var str = JSON.stringify(result.recordsList);
                        this.query = result.query;
                        console.log('str=='+str);
                        console.log('this.query=='+this.query);
                        //alert('contains name or not'+str.indexOf('Name'));
                        if(str.indexOf('Name')>0){
                            this.isCaseObject = false;
                            this.isWorkOrderObject = false;
                        }
                        else if(str.indexOf('CaseNumber')>0){
                            this.isCaseObject = true;
                            this.isWorkOrderObject = false;
                        }
                        else if(str.indexOf('WorkOrderNumber')>0){
                            this.isCaseObject = false;
                            this.isWorkOrderObject = true;
                        }
                        
                        this.getRecords = result.recordsList.map(record => Object.assign(
                            { "nameUrl": '/'+record.Id},
                            record
                        ));
                        /*if(this.isCaseObject==true && this.showRecords == true){                 
                            this.getRecords = result.recordsList.map(record => Object.assign(
                                { "nameUrl": '/'+record.Id},
                                record
                            ));
                        }
                        else if(this.isCaseObject == false && this.showRecords == true){
                            //alert('not case object'); 
                            this.getRecords = result.recordsList.map(record => Object.assign(
                                { "nameUrl": '/'+record.Id},
                                record
                            ));
                        }    */  
                        
                    }
                    else{
                        this.showRecords = false; 
                    }
                
                   /* if(this.TriggerConditionsWrapper!='' && this.showRecords == true){
                    this.AvailableForSearchValue = [];
                    }*/
                    if(this.showRecords == true && this.AvailableForSearchValue=='' && this.TriggerConditionsWrapper !='' && this.filterConditionsValue!=''){
                        this.saveQueryDisable = false;
                    }
                
                if(this.showRecords == false && this.AvailableForSearchValue!='' && this.TriggerConditionsWrapper =='' && this.filterConditionsValue==''){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'Please add Conditions',
                                variant: 'error'
                            })
                        );
                    }
                    this.isLoaded = false;
                })
                .catch(error => {
                    this.getRecords = [];
                    console.log('error ****'+JSON.stringify(error));
                    this.saveQueryDisable = true;
                    var str = JSON.stringify(error);
                    var ERR_result = str.includes("unexpected token:");
                    if(ERR_result==true){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'Please Check Formula for filter conditions',
                                variant: 'error'
                            })
                        );
                        this.isLoaded = false;
                    }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'No Records Found',
                                variant: 'error'
                            })
                        );
                        this.isLoaded = false;
                    }
                   
                });
            }
        
    }
    //@track preSelectedRows = ['0Q0e0000000XqmVCAS','0Q0e0000000Xd1ZCAS'];
    @track Selection = [];
    @track Selection11 = [];
    @track selectedRecords = [];
    @track isSendPdfDisable = true;
    @track selectedrecordIds = [];
    rowSelection(event) {
           // this.Selection11 = event.detail.selectedRows;
            //alert(this.Selection11);
           
            this.selectedRecords =  
            this.template.querySelector("lightning-datatable").getSelectedRows();  
            console.log('selectedRecords '+JSON.stringify(this.selectedRecords));
            //this.Selection = this.getRecords.map(record=>record.id);
           
            console.log(this.selectedRecords.length);
            if(this.selectedRecords.length>0){
                this.isSendPdfDisable = false;
              }
              else{
                this.isSendPdfDisable = true; 
              }
              var selectedIds = [];
              for(var i=0;i<this.selectedRecords.length;i++){
               
                selectedIds.push(this.selectedRecords[i].Id);
                this.selectedrecordIds = selectedIds;
                console.log('id'+this.selectedrecordIds);
            }
        
    }
    @track isSendDoc=false;
    @track sendDocURL='';
    handleVFPage(){
        this.recordDetails();
        this.isLoaded = true;
        console.log(this.SalesforceObject+' hello '+this.selectedrecordIds);
       
       
    }
  
    handleBatchName(event){
        this.batchName = event.target.value;
        this.AvailableForSearchLabel = event.target.value;
    }
    handleSaveCriteria(){
        this.disableupdate = true;
            if(this.AvailableForSearchValue != undefined && this.AvailableForSearchValue != ''){
               
                    this.disableupdate = false;
            }
     this.openSaveQuery=true;
    }
    handleCancel(){
     this.openSaveQuery=false;
     this.FirstNextScreen=true;
    }
 
   
    handleSaveQueryToObject(){
        this.isLoaded = true;
        this.batchName = this.AvailableForSearchValue;
        var msg = '';
        for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            if(this.TriggerConditionsWrapper[i].field == '' && this.TriggerConditionsWrapper[i].fieldValue == '' && this.TriggerConditionsWrapper[i].Operator == ''){
              msg = 'Please Enter Conditions using Add Row(+)';
            }
       }
       if(msg!=''){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while saving batch',
                    message: msg,
                    variant: 'error'
                })
            );
            this.isLoaded = false;
       }
        if(msg==''){
            var type='Save';
            this.SaveQueryHelper(this.batchName,this.query,this.filterConditionsValue,this.TriggerConditionsWrapper,this.AvailableForSearchLabel,type);

        }
    }
    handleUpdateQueryToObject(){
        this.isLoaded = true;
        this.batchName = this.AvailableForSearchValue;
        var msg = '';
        for(var i=0;i<this.TriggerConditionsWrapper.length;i++){
            if(this.TriggerConditionsWrapper[i].field == '' && this.TriggerConditionsWrapper[i].fieldValue == '' && this.TriggerConditionsWrapper[i].Operator == ''){
              msg = 'Please Enter Conditions using Add Row(+)';
            }
       }
       if(msg!=''){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while saving batch',
                    message: msg,
                    variant: 'error'
                })
            );
            this.isLoaded = false;
       }
        if(msg==''){
            //alert(this.query);
            var type='Update';
            //alert(' 1.'+this.query+' 2.'+this.filterConditionsValue+' 3.'+this.AvailableForSearchValue+' 4.'+this.AvailableForSearchLabel);
           this.SaveQueryHelper(this.batchName,this.query,this.filterConditionsValue,this.TriggerConditionsWrapper,this.AvailableForSearchLabel,type);
        }
    }
    SaveQueryHelper(batchId,query,filterConditions,conditionWrapper,batchName,type){
       
        SaveQueryToObject({batchId:batchId,
            objectName:this.SalesforceObject,
            query:query,
            filterConditions:JSON.stringify(conditionWrapper),
            filterCons:filterConditions,
            type:type,
            batchName:batchName,
        })
            .then(result => {
            console.log('result '+JSON.stringify(result));
            if(result.message=='Duplicate Batch Name'){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Duplicate Batch name,Please give another name',
                        variant: 'error'
                    })
                );
               // this.openSaveQuery = false;
                this.isLoaded = false;
            }
             if(result.batchRecord!=null){
                this.TriggerConditionsWrapper=[];
                this.AvailableForSearchValue = result.batchRecord.Id;
                this.handleExecuteQueryBatch(); 
                        this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Saved Successfully',
                            variant: 'success'
                        })
                    );
                    getQueryBatch({objectName:this.SalesforceObject})
                    .then(result => {
                        console.log(' getQueryBatch result '+result);
                        this.AvailableForSearchOptions = result;   
                        console.log('this.AvailableForSearchOptions  '+JSON.stringify(this.AvailableForSearchOptions));
                        this.isLoaded = false;  
                    })
                    .catch(error => {
                        console.log('error ****'+error);
                        this.isLoaded = false;
                    });
                 
                    this.openSaveQuery=false;
                    this.isLoaded = false;
            }
          
            })
            .catch(error => {
            console.log('error ****'+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while saving batch',
                    message: 'unable to save the batch',
                    variant: 'error'
                })
            );
            this.isLoaded = false;

            });
    }
    
    
    @track saveQueryDisable=false;
    @track isShowRecordsDisable = false;
    handleAvailableForSearch(event){
       this.AvailableForSearchValue = event.target.value;
       this.AvailableForSearchLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
       //alert('label===='+this.AvailableForSearchLabel);
       this.isLoaded = true;
       this.TriggerConditionsWrapper=[];
       this.filterConditionsValue=undefined;
       this.isShowRecordsDisable = false;
       if(this.AvailableForSearchValue=='--None--'){
            this.showRecords = false;
            this.isLoaded = false;
           
       }else{
        this.isShowRecordsDisable = true;
        console.log('this.batchId '+this.AvailableForSearchValue);
        this.handleExecuteQueryBatch(); /*this.getRecords = result.map(record => Object.assign(
            { "nameUrl": '/'+record.Id,"OwnerName":record.Owner.Name},
            record
        ));*/
        /*ExecuteSearchQuery({batchId:this.AvailableForSearchValue})
        .then(result => {
             //alert(JSON.stringify(result));
             console.log('result '+result);
            
             //alert(result.filterConditionWrapperList.length);
                for(var i=0;i<result.filterConditionWrapperList.length;i++){
                    console.log((result.filterConditionWrapperList[i]));
                    this.TriggerConditionsWrapper.push({
                        RowNumber:result.filterConditionWrapperList[i].RowNumber,
                        field:result.filterConditionWrapperList[i].field,
                        Operator:result.filterConditionWrapperList[i].Operator,
                        fieldValue:result.filterConditionWrapperList[i].fieldValue,
                        type:result.filterConditionWrapperList[i].type,
                        isPicklist:false,
                        isBoolean:false
                    });    
                }
                this.AvailableForSearchLabel = result.batchRecord.Name;
                this.AvailableForSearchValue = result.batchRecord.Id;
                this.filterConditionsValue = result.batchRecord.Filter_Conditions__c;
                this.query = result.batchRecord.Query__c;
             var str = JSON.stringify(result.recordsList);
             //alert('contains name or not'+str.indexOf('Name'));
             if(str.indexOf('Name')>0){
                 this.isCaseObject = false;
             }
             else{
                 this.isCaseObject = true;
             }
         
             this.getRecords = result.recordsList.map(record => Object.assign(
                 { "nameUrl": '/'+record.Id},
                 record
             ));
 
             if(this.getRecords.length<=0){
                 this.showRecords = false;
                 this.isShowRecordsDisable = true;
             }
             else{
                 this.showRecords = true;
                 this.isShowRecordsDisable = false;
             }
  
             
             if((this.showRecords == true && this.AvailableForSearchValue!='' && this.TriggerConditionsWrapper =='' && (this.filterConditionsValue==undefined || this.filterConditionsValue==''))){
                // this.saveQueryDisable = true;
                // this.isShowRecordsDisable = true;
             }
             else if(this.showRecords == true && this.TriggerConditionsWrapper !='' && this.filterConditionsValue!=''){
                 //this.AvailableForSearchValue = [];
                 this.saveQueryDisable = false;
             }
             else if(this.showRecords == false && this.AvailableForSearchValue=='' && this.TriggerConditionsWrapper =='' && this.filterConditionsValue==''){
                 this.saveQueryDisable = false;
             }
           
            
             this.isLoaded = false;
         })
         .catch(error => {
             console.log('error ****ExecuteSearchQuery '+error);
             this.isLoaded = false;
 
         });*/
       }
      
    }
    handleExecuteQueryBatch(){
        ExecuteSearchQuery({batchId:this.AvailableForSearchValue})
        .then(result => {
             //alert(JSON.stringify(result));
             console.log('result '+result);
             this.isShowRecordsDisable = false;
             //alert(result.filterConditionWrapperList.length);
                for(var i=0;i<result.filterConditionWrapperList.length;i++){
                    console.log((result.filterConditionWrapperList[i]));
                    if(result.filterConditionWrapperList[i].type=='PICKLIST'){
                        this.TriggerConditionsWrapper.push({
                            RowNumber:result.filterConditionWrapperList[i].RowNumber,
                            field:result.filterConditionWrapperList[i].field,
                            Operator:result.filterConditionWrapperList[i].Operator,
                            fieldValue:result.filterConditionWrapperList[i].fieldValue,
                            type:result.filterConditionWrapperList[i].type,
                            isPicklist:true,
                            isBoolean:false
                        });    
                    }else{
                        this.TriggerConditionsWrapper.push({
                            RowNumber:result.filterConditionWrapperList[i].RowNumber,
                            field:result.filterConditionWrapperList[i].field,
                            Operator:result.filterConditionWrapperList[i].Operator,
                            fieldValue:result.filterConditionWrapperList[i].fieldValue,
                            type:result.filterConditionWrapperList[i].type,
                            isPicklist:false,
                            isBoolean:false
                        });    
                    }
                   
                }
                this.AvailableForSearchLabel = result.batchRecord.Name;
                this.AvailableForSearchValue = result.batchRecord.Id;
                
                this.filterConditionsValue = result.batchRecord.JunoDoc__Filter_Conditions__c;
                this.query = result.batchRecord.JunoDoc__Query__c;
             var str = JSON.stringify(result.recordsList);
             //alert('contains name or not'+str.indexOf('Name'));
             if(str.indexOf('Name')>0){
                 this.isCaseObject = false;
             }
             else if(str.indexOf('CaseNumber')>0){
                 this.isCaseObject = true;
                 this.isWorkOrderObject = false;
             }else if(str.indexOf('WorkOrderNumber')>0){
                this.isCaseObject = false;
                this.isWorkOrderObject = true;
             }
         
             this.getRecords = result.recordsList.map(record => Object.assign(
                 { "nameUrl": '/'+record.Id},
                 record
             ));
                //alert(this.getRecords.length);
             if(this.getRecords.length<=0){
                 this.showRecords = false;
                 //this.isShowRecordsDisable = true;
                 this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'No records found!',
                        variant: 'error'
                    })
                );
             }
             else{
                 this.FirstNextScreen = true;
                 this.showRecords = true;
                 this.isShowRecordsDisable = false;
             }
  
             
             if((this.showRecords == true && this.AvailableForSearchValue!='' && this.TriggerConditionsWrapper =='' && (this.filterConditionsValue==undefined || this.filterConditionsValue==''))){
                // this.saveQueryDisable = true;
                 this.isShowRecordsDisable = false;
             }
             else if(this.showRecords == true && this.TriggerConditionsWrapper !='' && this.filterConditionsValue!=''){
                 //this.AvailableForSearchValue = [];
                 this.saveQueryDisable = false;
             }
             else if(this.showRecords == false && this.AvailableForSearchValue=='' && this.TriggerConditionsWrapper =='' && this.filterConditionsValue==''){
                 this.saveQueryDisable = false;
             }
           
            
             this.isLoaded = false;
         })
         .catch(error => {
             console.log('error ****ExecuteSearchQuery '+error);
             this.isLoaded = false;
 
         });
    }
    @track isPOPupOpen=false;
    @track AvailableDocTemplatesList=[];
    @track AvailableDocTemplateSelectedValue='';
    @track TemplateId='';
    @track fullUrl='';
    @track isProgressBarVisible=false;
    handleDownloadPDF(){
        this.isPOPupOpen = true;
        this.showTriggerConditions = false;
        this.FirstNextScreen = false;
        this.SecondNextScreen = true;
        if(this.selectedStep == ''){
            this.selectedStep = 'Step1';
        }
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step1'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step4';
        }
        /*else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step5';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step6';
        }*/
        var recordId = this.selectedRecords[0].Id;
        getAvailableDocTemplates({sObjName:this.SalesforceObject,recordId:recordId,batchId:this.AvailableForSearchValue})
        .then(result => {
            this.AvailableDocTemplatesList = result.AvailableDocTemplatesList;
            this.AvailableDocTemplateSelectedValue = result.batchSettingsRecord.JunoDoc__Junodoc_Templates__c;
            if( this.AvailableDocTemplateSelectedValue!='' &&  this.AvailableDocTemplateSelectedValue !=null){
                this.isSelectedTemplate = true;
            }else{

            }
            for(var i=0;i<this.selectedRecords.length;i++){
                this.isSelectedTemplate = true;
                this.fullUrl = '/apex/JunoDoc__JunodocPDF?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.AvailableDocTemplateSelectedValue;
            }
            this.TemplateId = result.batchSettingsRecord.JunoDoc__Junodoc_Templates__c;
            for(var i=0;i<result.PostActionWrapperList.length;i++){
                console.log((result.PostActionWrapperList[i]));
                this.PostTriggerActionsWrapper.push({
                    RowNumber:result.PostActionWrapperList[i].RowNumber,
                    Field:result.PostActionWrapperList[i].Field,
                    Value:result.PostActionWrapperList[i].Value
                    
                });    
            }
            this.PostTriggerActionsWrapper = result.PostActionWrapperList;
            
        })
        .catch(error => {
            console.log('error **** '+error);

        });

    }
    @track recordId='';
    @track isRequired=false;
    @track isSelectedTemplate=false;
    @track templateType = '';
    AvailableDocTemplateOnchangeHandler(event){
        this.AvailableDocTemplateSelectedValue = event.target.value;
        if(event.target.value!=null || event.target.value!=''){
            this.isSelectedTemplate = true;
        }else{
            this.isSelectedTemplate = false;
        }
        this.recordId = this.selectedRecords[0].Id;
        this.TemplateId = this.AvailableDocTemplateSelectedValue;
        console.log('recordId=='+this.recordId+' this.TemplateId=== '+this.TemplateId);
        this.templateType = '';
        for(var k=0;k<this.AvailableDocTemplatesList.length;k++){
            if(this.AvailableDocTemplatesList[k].value == event.target.value){
                this.templateType = this.AvailableDocTemplatesList[k].type;
            }
        }
        for(var i=0;i<this.selectedRecords.length;i++){
            if(this.templateType == 'Word Document'){
                this.fullUrl = '/apex/JunoDoc__PreviewTemplateWord?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.TemplateId;
            }
            else if(this.templateType == 'Excel'){
                this.fullUrl = '/apex/JunoDoc__PreviewExcel?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.TemplateId;   
            }
            else{
                this.fullUrl = '/apex/JunoDoc__JunodocPDF?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.TemplateId;
            }
            
        }
        console.log('this.fullUrl==='+this.fullUrl);
        //this.fullUrl = '/apex/DownloadPDF_VF';
    }
    closePopUp(){
       console.log('close');
      /*  this.isPOPupOpen = false;
        this.ThirdNextScreen = false;
        this.AvailableDocTemplateSelectedValue = '';
        this.isSendPdfDisable = true;
        this.FirstNextScreen = false;
        this.isPOPupOpen = false;
        this.openSaveQuery = false;
        this.selectedStep = '';
        this.showTriggerConditions = false;
        this.isLoaded = false;
        this.ObjectLabel='';*/
        this.openSaveQuery = false;
    }
    @track l = 0;
    @track output = '';
    @track TotalRecords = 0;
    @track processingRecords = 0;
    MultiplePDFsDownload(){
        if(this.isSelectedTemplate == true){
            console.log('download');
            //this.isPOPupOpen = false;
            var recordIds=[];
            for(var i=0;i<this.selectedRecords.length;i++){
                recordIds.push(this.selectedRecords[i].Id);
            }  

            var k=1; 
            this.l=50;
            this.output = '';
            this.multipleData(0,recordIds)
            this.TotalRecords = recordIds.length;
            this.showProgress = true;
            //alert(recordIds);
           // var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(recordIds)+'&DocTemplateId='+this.TemplateId+'&Type=multiple';
            
            //this.template.querySelector("c-child-junodoc-btach").handlePostTriggerActionSave();

           // window.open(url,"_blank");
           
           /* for(var i=0;i<this.selectedRecords.length;i++){
                
                console.log(this.selectedRecords[i].Id);
                var url = '/apex/JunoDoc__JunodocPDF?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.TemplateId;
                window.open(url,"_blank");
               // this.urlHelper(url);
            }*/
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please select Doc Template',
                    message: this.error,
                    variant: 'error'
                })
            );
        }
       
    }
    multipleData(k,recordIds){
         var chunks = [];
                 console.log('recordIds[k]>> '+recordIds[k]+' this.TemplateId>>> '+this.TemplateId+' this.sessionId>>'+this.sessionId)

         getMultiPDFData({ recordId : recordIds[k], TemplateId: this.TemplateId, sessionId: this.sessionId })
                    .then(response => {
                        this.output = this.output  +','+ response;
                        var m = k+1;
                        this.processingRecords = k;
                        this.progressValue = parseInt((k/recordIds.length)*100);
                        if(m == recordIds.length){
                            if(this.l != m){
                                var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(chunks[0])+'&DocTemplateId='+this.TemplateId+'&Type=multiple&data='+ this.output ;
                                window.open(url,"_blank");
                            }
                            this.showProgress = false;
                            this.handlePostTriggerActionSave();
                        }
                        else{
                            
                            this.multipleData(k+1,recordIds)
                            
                        }
                        if(this.l==m){ 
                            var url = '/apex/JunoDoc__Mainpages?id='+JSON.stringify(chunks[0])+'&DocTemplateId='+this.TemplateId+'&Type=multiple&data='+this.output ;
                            window.open(url,"_blank");
                            this.output  = '';  
                            this.l = this.l+50;
                        }
                        
                        // Handle the response here
                        // Accumulate output, check conditions, and open URL if needed
                    })
                    .catch(error => {
                        // Handle errors if any
                    });
    }
    SinglePDFsDownload(){
        debugger;
        //alert(this.isSelectedTemplate);
        if(this.isSelectedTemplate == true){
            console.log('download');
            //this.isPOPupOpen = false;
            
            for(var i=0;i<this.selectedRecords.length;i++){
                
                console.log(this.selectedRecords[i].Id);
                var url = '/apex/JunoDoc__Mainpages?id='+this.selectedRecords[i].Id+'&DocTemplateId='+this.TemplateId+'&Type=single&TempType='+this.templateType;
                console.log('url===='+url);
                //window.open(url,"_blank");
                //alert(JSON.stringify(this.PostTriggerActionsWrapper));
                this.handlePostTriggerActionSave();
               // this.template.querySelector('[data-id="childJuno"]').handlePostTriggerActionSave();
                //this.template.querySelector("c-child-junodoc-btach").handlePostTriggerActionSave();
                console.log('url=='+url);
                window.open(url,"_blank");
               // this.urlHelper(url);
            }
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Please select Doc Template',
                    message: this.error,
                    variant: 'error'
                })
            );
        }
    }
    urlHelper(url){
        window.open(url,"_blank");
    }
    
    @track PostTriggerActionKeyIndex=0; 
    addPostTriggerActionRow(){
        //this.message='';
        this.PostTriggerActionKeyIndex+1;
        var rownumber = this.PostTriggerActionsWrapper.length+1;
        this.PostTriggerActionsWrapper.push({
            recordId:'',
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
            var msg = '';
            var fieldName = event.target.value;
            this.PostTriggerActionsWrapper[event.target.accessKey].Value='';
            for(var i=0;i<this.PostTriggerActionsWrapper.length;i++){
                if(event.target.value==this.PostTriggerActionsWrapper[i].Field){
                    msg = fieldName+' is already selected';
                }
            }
            if(msg==''){
                this.PostTriggerActionsWrapper[event.target.accessKey].Field=event.target.value;
                for(var i=0;i<this.ObjectFieldsWrapper.length;i++){
                    if(event.target.value==this.ObjectFieldsWrapper[i].value){
                        this.PostTriggerActionsWrapper[event.target.accessKey].type=this.ObjectFieldsWrapper[i].type;
                        if(this.ObjectFieldsWrapper[i].type=='PICKLIST'){
                            this.PostTriggerActionsWrapper[event.target.accessKey].isPicklist = true;
                            this.PostTriggerActionsWrapper[event.target.accessKey].isBoolean = false;
                        }
                        else if(this.ObjectFieldsWrapper[i].type=='BOOLEAN'){
                            this.PostTriggerActionsWrapper[event.target.accessKey].isBoolean = true;
                            this.PostTriggerActionsWrapper[event.target.accessKey].isPicklist = false;
                        }else{
                            this.PostTriggerActionsWrapper[event.target.accessKey].isBoolean = false;
                            this.PostTriggerActionsWrapper[event.target.accessKey].isPicklist = false;
                        }

                    }
                } 
            }  else if(msg!=''){
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
    
   /* handlePostTriggerActionSave(url){
        //alert('hii');
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
            message = 'Please Add rows in post actions!'; 
        }   

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

        //alert('hi');
           if(message==''){
            savePostTriggerActions( 
                { 
                    ObjectName : this.SalesforceObject,                    
                    records : JSON.stringify(this.PostTriggerActionsWrapper),
                    selectedRecordIds : this.selectedrecordIds
                } 
            )          
            .then((result) =>  {
                //alert('result-->'+result);  
                if(result!==undefined && result!=''){
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: result,
                            variant: 'success'
                        })
                    );
                    //this.isLoaded = false;
                   
                    
                    //location.reload();
                }
            })
            .catch(error => {
                console.log('error'+error);
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
         
           window.open(url,"_blank");
        
       
    }*/
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
           //  message = 'Please Add rows!'; 
         }  
 
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
 
            if(message==''){
                savePostTriggerActions( 
                    { 
                        ObjectName : this.SalesforceObject,                    
                        records : JSON.stringify(this.PostTriggerActionsWrapper),
                        selectedRecordIds : this.selectedrecordIds
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
                       this.isLoaded = false;
                    }
                })
                .catch(error => {
                    console.log('error'+error);
                    this.dispatchEvent(
                       new ShowToastEvent({
                           title: 'Error',
                           message: 'Error while Updating record',
                           variant: 'error'
                       })
                   );    
                   this.isLoaded = false;
                   // this.alertMessage = 'Error while Updating record'; this.successMessage = false; this.errorMessage = true;
                });
            }
            
 
         
        
     }
   

    @track ThirdNextScreen = false;
    @track FourthNextScreen = false;
   /* handleBack(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step6'){
            this.selectedStep = 'Step5';
        }
        this.FirstNextScreen = false;
        this.isPOPupOpen = false;
    }*/
    @track preSelectedRows;
    handleSecondPrevious(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }/*else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step6'){
            this.selectedStep = 'Step5';
        }*/
        //this.selectedRecords = [];
        //this.selectedRecords =  
        //this.isSendPdfDisable = true;
        let my_ids = [];
        for(var i=0;i<this.selectedRecords.length;i++){
          
            my_ids.push(this.selectedRecords[i].Id);
     
        }
        this.Selection = (my_ids);
       /* let my_ids = [];
        my_ids.push('0Q0e0000000XqmVCAS');
        my_ids.push('0Q0e0000000Xd1ZCAS');
        this.preSelectedRows = my_ids;*/

      
      //this.preSelectedRows = ['0Q0e0000000XqmVCAS','0Q0e0000000Xd1ZCAS'];
     
       
        this.FirstNextScreen = true;
        this.showRecords = true;
        this.isSendPdfDisable = true;
        this.showTriggerConditions = true;
        this.SecondNextScreen = false;
        this.isPOPupOpen = false;
    }
    handleSecondNextScreen(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step1'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step4';
        }/*else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step5';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step6';
        }*/
        this.ThirdNextScreen = true;
        this.FirstNextScreen = false;
        this.SecondNextScreen = false;
        this.FourthNextScreen = false;
        this.isPOPupOpen = true;
    }
    handleFirstPrevious(){
        this.showTriggerConditions = true;
        //this.FirstNextScreen = true;
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }/*else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step6'){
            this.selectedStep = 'Step5';
        }*/
        this.FirstNextScreen = false;
        this.isPOPupOpen = false;
        this.showSearchObjects = false;
    }
    handleThirdPrevious(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }/*else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step6'){
            this.selectedStep = 'Step5';
        }*/
        this.SecondNextScreen = true;
        this.ThirdNextScreen = false;
        this.isPOPupOpen = true;
    }
    handleThirdNextScreen(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step1'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step3';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step4';
        }/*else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step5';
        }
        else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step6';
        }*/
        this.ThirdNextScreen = false;
        this.FourthNextScreen = true;
    }
    handleFourthPrevious(){
        var getselectedStep = this.selectedStep;
        if(getselectedStep === 'Step2'){
            this.selectedStep = 'Step1';
        }
        else if(getselectedStep === 'Step3'){
            this.selectedStep = 'Step2';
        }
        else if(getselectedStep === 'Step4'){
            this.selectedStep = 'Step3';
        }/*else if(getselectedStep === 'Step5'){
            this.selectedStep = 'Step4';
        }
        else if(getselectedStep === 'Step6'){
            this.selectedStep = 'Step5';
        }*/
        this.ThirdNextScreen = true;
        this.FourthNextScreen = false;
    }
    selectStep1() {
        this.selectedStep = 'Step1';
    }
 
    selectStep2() {
        this.selectedStep = 'Step2';
    }
 
    selectStep3() {
        this.selectedStep = 'Step3';
    }
    
    selectStep4() {
        this.selectedStep = 'Step4';
    }
   /* selectStep5() {
        this.selectedStep = 'Step5';
    }
    selectStep6() {
        this.selectedStep = 'Step6';
    }*/
    handleProgress(event){
        if(event.target.value=='Step1'){
            if(this.SalesforceObject!='' && this.SalesforceObject!=null){
                this.selectedStep = 'Step1';
                this.FirstNextScreen = false;
                this.isPOPupOpen = false;
                this.isSendPdfDisable = true;
                this.showSearchObjects = false;
                this.showTriggerConditions = true;
                this.FourthNextScreen = false;
                this.ThirdNextScreen = false;
                this.FirstNextScreen = true;
                this.SecondNextScreen = false;
            }else{
                this.showTriggerConditions = false;
                this.FourthNextScreen = false;
                this.ThirdNextScreen = false;
                this.FirstNextScreen = false;
            }
        }else if(event.target.value=='Step2'){
            this.selectedStep = 'Step2';
            
           if(this.selectedRecords.length<=0){
                this.selectedStep = 'Step1';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select records',
                        variant: 'error'
                    })
                ); 
            }else{
                this.showTriggerConditions = false;
                this.FourthNextScreen = false;
                this.ThirdNextScreen = false;
                this.FirstNextScreen = false;
                this.SecondNextScreen = true;
                this.isPOPupOpen = true;
                this.handleDownloadPDF();
            }this.selectedStep = 'Step1';
        }
        else if(event.target.value=='Step3'){
            this.selectedStep = 'Step3';
            if(this.SalesforceObject!='' && this.SalesforceObject!=null){
                //this.handleDownloadPDF();
                this.FirstNextScreen = false;
                this.SecondNextScreen = false;
                this.FourthNextScreen = false;
                this.ThirdNextScreen = true;
                this.showTriggerConditions = false;
                this.isPOPupOpen = true;
            }else{
                this.selectedStep = 'Step1';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select object',
                        variant: 'error'
                    })
                ); this.selectedStep = 'Step1';
            }
        }else if(event.target.value=='Step4'){
            //this.selectedStep = 'Step4';
            if(this.selectedRecords.length>0){
                if(this.isSelectedTemplate == true){
                    this.FirstNextScreen = false;
                    this.SecondNextScreen = false;
                    this.ThirdNextScreen = false;
                    this.FourthNextScreen = true;
                    this.isPOPupOpen = true;
                    this.showTriggerConditions = false;
                }else{
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Please select doc template',
                            variant: 'error'
                        })
                    );     this.selectedStep = 'Step3';
                }
                
            }else{
                
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select records',
                        variant: 'error'
                    })
                );     this.selectedStep = 'Step1';
            }
           
        }/*else if(event.target.value=='Step5'){
            if(this.selectedRecords.length>0){
                this.ThirdNextScreen = true;
                this.FirstNextScreen = false;
                this.SecondNextScreen = false;
                this.FourthNextScreen = false;
                this.showTriggerConditions = false;
            }else{
                this.selectedStep = 'Step4';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select records',
                        variant: 'error'
                    })
                );     
            }
           
        }else if(event.target.value=='Step6'){
            if(this.selectedRecords.length>0){
                this.FourthNextScreen = true;
                this.ThirdNextScreen = false;
                this.FirstNextScreen = false;
                this.SecondNextScreen = false;
                this.showTriggerConditions = false;
            }else{
                this.selectedStep = 'Step5';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please select records',
                        variant: 'error'
                    })
                );     
            }
           
        }*/
    }
    handleSaveActions(){
        this.isLoaded = true;
        if(this.AvailableDocTemplateSelectedValue!=null && this.AvailableDocTemplateSelectedValue!=''){
            if(this.PostTriggerActionsWrapper.length>0){
                SaveTemplateAndPostActions({ ObjectName : this.SalesforceObject,
                    templateId: this.AvailableDocTemplateSelectedValue,
                    postActionWrapper: JSON.stringify(this.PostTriggerActionsWrapper),
                    batchId:this.AvailableForSearchValue} )
                .then((result) =>  {                   
              
                    console.log('result---->'+result);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Successfully saved batch settings and post actions ',
                            variant: 'success'
                        })
                    );  
                    //this.alertMessage = 'Successfully saved batch settings and post actions '; this.successMessage = true; this.errorMessage = false;
                    this.isLoaded = false;
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'Cannot save the post actions ',
                            variant: 'error'
                        })
                    );  
                   // this.alertMessage = 'Cannot save the post actions '; this.successMessage = false; this.errorMessage = true;
                });
                this.isLoaded = false;
            }else{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Please add rows',
                        variant: 'error'
                    })
                );
                this.isLoaded = false;
              //  this.alertMessage = 'Please add rows and give values!'; this.successMessage = false; this.errorMessage = true;
            }
            
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select Doc Template',
                    variant: 'error'
                })
            );
            this.isLoaded = false;     //this.alertMessage = 'Please select Doc Template'; this.successMessage = false; this.errorMessage = true;
        }
    }

    handleFromEmailAddressOnChange(event){
        this.FromEmailAddress = event.target.value;
    }

    handleEmailTemplateOnChange(event){
        if(event.target.name==='AvailableDocTemplates'){
            this.AvailableDocTemplate = event.target.value;
        }
        else if(event.target.name==='StandardEmailTemplates'){
            this.JunoDocEmailTemplate = '';
            this.StandardEmailTemplate = event.target.value;  
            this.StandardEmailTemplateOnchangeHandlerHelper();
        }
        else if(event.target.name==='JunoDocEmailTemplates'){
            this.StandardEmailTemplate = '';
            this.JunoDocEmailTemplate = event.target.value;
            this.JunoDocEmailTemplateOnchangeHandlerHelper();
        }

    }

    StandardEmailTemplateOnchangeHandlerHelper(){
        var recordId = this.selectedrecordIds;
        debugger;
       // var recordList = recordId.split(',');
       var recordList = this.selectedrecordIds;
        var EmailTemplateId = this.StandardEmailTemplate;
        getBodyFromEmailTemplateAction({ recordId : recordList[0], EmailTemplateId : EmailTemplateId})
            .then(result => {
                var Result = result 
                    var Subject = Result.split('~')[0];
                    var Body = Result.split('~')[1];
                    var errorMessage = Result.split('~')[2];
                    if(errorMessage=='' || errorMessage == undefined){    
                        this.subject = Subject
                        this.body =   Body            
                    }
                    
                    
                    
                    if(errorMessage!=null){
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: errorMessage,
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                    }
            })
            .catch(error => {
                console.log(JSON.stringify(error))
            });
    }

    JunoDocEmailTemplateOnchangeHandlerHelper(){

        var recordList = this.selectedrecordIds;
        var EmailTemplateId = this.JunoDocEmailTemplate;
        getBodyFromJunoDocEmailTemplate1Action({ recordId : recordList[0],
        EmailTemplateId : EmailTemplateId})
        .then(result => {
            var Result = result;
                var Subject = Result.split('~')[0];
                var Body = Result.split('~')[1];
                
                this.subject = Subject;
                this.body = Body;
        })
        .catch(error => {
           console.log(JSON.stringify(error))
        });
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
        var message =  this.addEmailRecipientsList;

        var textValues = '';
        var referenceValues = '';
        var ToTextEmailsList = [];
        var ToEmailMergeFieldsList = [];
        
        var CCTextEmailsList = [];
        var CCEmailMergeFieldsList = [];  
        
        var BCCTextEmailsList = [];
        var BCCEmailMergeFieldsList = [];          
        
        for(var i=0;i<message.length;i++){
            if(message[i].ReferenceType == 'Text'){
            	textValues += message[i].EmailValue+' - '+message[i].ToCCBCC+','; 
                if(message[i].ToCCBCC=='To'){
                	ToTextEmailsList.push(message[i].EmailValue);    
                }else if(message[i].ToCCBCC=='CC'){
                	CCTextEmailsList.push(message[i].EmailValue);    
                }else if(message[i].ToCCBCC=='BCC'){
                	BCCTextEmailsList.push(message[i].EmailValue);    
                } 
            }
            
            if(message[i].ReferenceType == 'Reference'){
            	referenceValues += message[i].EmailValue+' - '+message[i].ToCCBCC+',';     
                if(message[i].ToCCBCC=='To'){
                    ToEmailMergeFieldsList.push(message[i].FinalFieldDetails);
                }else if(message[i].ToCCBCC=='CC'){
                	CCEmailMergeFieldsList.push(message[i].FinalFieldDetails);    
                }else if(message[i].ToCCBCC=='BCC'){
                	BCCEmailMergeFieldsList.push(message[i].FinalFieldDetails);    
                } 
                
            }  
        }
        textValues = textValues.slice(0, -1);
        referenceValues = referenceValues.slice(0, -1);
        /*component.set("v.textValues", textValues);
        component.set("v.referenceValues", referenceValues);
        component.set("v.fieldDetails", fieldDetails); */
        
        this.ToTextEmailsList = ToTextEmailsList
        this.ToEmailMergeFieldsList = ToEmailMergeFieldsList
        
        this.CCTextEmailsList = CCTextEmailsList
        this.CCEmailMergeFieldsList = CCEmailMergeFieldsList

        this.BCCTextEmailsList = BCCTextEmailsList
        this.BCCEmailMergeFieldsList = BCCEmailMergeFieldsList
    }

    recordDetails(){
        var recId = this.SalesforceObject;
        getrecorddetailsAction({recordId : recId})
        .then(result => {
            var InnerResult = result;
            debugger;
                        console.log("Query result"+JSON.stringify(InnerResult));
                        if(InnerResult!=null && InnerResult!='' && InnerResult!=undefined){
                           
                            //for (var i=0; i < InnerResult.length; i++) {
                            this.FromEmailAddress = InnerResult.junodoc[0].JunoDoc__From_Email_Address__c;
                            this.SetReplyTo = InnerResult.junodoc[0].JunoDoc__Set_Reply_To__c
                            this.StandardEmailTemplate = InnerResult.junodoc[0].JunoDoc__Standard_Email_Templates__c
                            
                           	this.JunoDocEmailTemplate = InnerResult.junodoc[0].JunoDoc__Junodoc_Email_Templates__c
                            
                           
                            var juno = this.JunoDocEmailTemplate
                          	
                            var receivedData =  InnerResult.junoEmailList;
                           // var changesKeys = {};
                            var changeData = [];
                            for(let i in receivedData){
                                changeData.push({'ToCCBCC' : receivedData[i]['Tovalue'],
                            'ReferenceType' :  receivedData[i]['TextRefVal'],
                            'EmailValue' :receivedData[i]['Email'],
                            'FinalFieldDetails' : receivedData[i]['fieldDetails'],
                            'indx' : i+1
                        })
                            } 

                            this.addEmailRecipientsList = changeData
                            var message =  this.addEmailRecipientsList
                            console.log('message ------> '+JSON.stringify(message));
                            var textValues = '';
                            var referenceValues = '';
                            var ToTextEmailsList = [];
                            var ToEmailMergeFieldsList = [];
                            
                            var CCTextEmailsList = [];
                            var CCEmailMergeFieldsList = [];  
                            
                            var BCCTextEmailsList = [];
                            var BCCEmailMergeFieldsList = [];  
                            for(var i=0;i<message.length;i++){
                                if(message[i].ReferenceType == 'Text'){
                                    textValues += message[i].EmailValue+' - '+message[i].ToCCBCC+','; 
                                    if(message[i].ToCCBCC=='To'){
                                        ToTextEmailsList.push(message[i].EmailValue);    
                                    }else if(message[i].ToCCBCC=='CC'){
                                        CCTextEmailsList.push(message[i].EmailValue);    
                                    }else if(message[i].ToCCBCC=='BCC'){
                                        BCCTextEmailsList.push(message[i].EmailValue);    
                                    } 
                                }
	
                                if(message[i].ReferenceType == 'Reference'){
                                    referenceValues += message[i].EmailValue+' - '+message[i].ToCCBCC+',';     
                                    if(message[i].ToCCBCC=='To'){
                                        ToEmailMergeFieldsList.push(message[i].FinalFieldDetails);
                                         
                                    }else if(message[i].ToCCBCC=='CC'){
                                        CCEmailMergeFieldsList.push(message[i].FinalFieldDetails);    
                                    }else if(message[i].ToCCBCC=='BCC'){
                                        BCCEmailMergeFieldsList.push(message[i].FinalFieldDetails);    
                                    } 
                                    
                                }  
                            }
                            textValues = textValues.slice(0, -1);
                            referenceValues = referenceValues.slice(0, -1);
                           // component.set("v.textValues", textValues);
                           // component.set("v.referenceValues", referenceValues);
                            this.ToTextEmailsList = ToTextEmailsList
                            this.ToEmailMergeFieldsList= ToEmailMergeFieldsList  
                            this.CCTextEmailsList = CCTextEmailsList
                           this.CCEmailMergeFieldsList = CCEmailMergeFieldsList
                            this.BCCTextEmailsList = BCCTextEmailsList
                            this.BCCEmailMergeFieldsList = BCCEmailMergeFieldsList

                            
                            var stand = this.StandardEmailTemplate;
                            
                            if(juno != null && juno !='' && juno != undefined){
                               
                                this.JunoDocEmailTemplateOnchangeHandlerHelper();
                            }else{
                                if(stand !=null && stand !='' && stand!=undefined){
                                    
                                    this.StandardEmailTemplateOnchangeHandlerHelper();
                                }
                            }  
                        }
                        else if(InnerResult==null || InnerResult==''){
                            this.FromEmailAddress = "choose one...";
                            this.SetReplyTo= ""
                            this.StandardEmailTemplate = "choose one...";
                            this.JunoDocEmailTemplate = "choose one...";
                        }

                        if(this.isSelectedTemplate == true){
                            this.handlePostTriggerActionSave();
                            var url = '/apex/JunoDoc__JunodocBatchListView?objectName='+this.SalesforceObject+'&records='+this.selectedrecordIds+'&batchId='+this.AvailableDocTemplateSelectedValue+'&visualpage='+this.visualpage;
                            console.log(url);
                            this.sendDocURL = url;
                            getEmailTemplatesAction({sObjName : this.SalesforceObject})
                            .then(result => {
                                this.StandardEmailTemplatesList = result.StandardEmailTemplatesList;
                                this.JunoDocEmailTemplatesList = result.JunoDocEmailTemplatesList;
                                
                            })
                            .catch(error => {
                                console.log(JSON.stringify(error));
                            });
                            this.isSendDoc=true;
                            this.isLoaded = false;
                            //window.location.href=url;
                        }else{
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message: 'Please select doc template',
                                    variant: 'error'
                                })
                            );
                            this.isLoaded = false;
                        }          
                    })
        .catch(error => {
            console.log(JSON.stringify(error));
        }) 
    


              
                
               
                    
              
    } 

    SendPDFHelper(){
        if(this.validateToAddressHelper()){
            this.SendPDF();
        }
    }


    validateToAddressHelper(){
        debugger;
        if(this.ToTextEmailsList  &&
        this.ToEmailMergeFieldsList &&
        this.CCTextEmailsList &&
        this.CCEmailMergeFieldsList &&
        this.BCCTextEmailsList &&
       this.BCCEmailMergeFieldsList){
        if( this.subject
        && this.body ){
            return true;
        }
        else{
            return false;
        }
       }
       else{
        return false;
       }
    }


    SendPDF(){
        this.isLoaded = true;
        var recordId = this.selectedrecordIds;
        var DocTemplateId = this.AvailableDocTemplateSelectedValue;
            var objectName = this.SalesforceObject;
        	var emailbody = '';
        	var subject = '';
            if(this.body != ''){
                emailbody = this.body
            }
        	if(this.subject != ''){
                subject = this.subject
            }
        
            var ToTextEmailsList =this.ToTextEmailsList
            var ToEmailMergeFieldsList = this.ToEmailMergeFieldsList
            
            var CCTextEmailsList = this.CCTextEmailsList
            var CCEmailMergeFieldsList = this.CCEmailMergeFieldsList

            var BCCTextEmailsList =this.BCCTextEmailsList
            var BCCEmailMergeFieldsList = this.BCCEmailMergeFieldsList
        	var FromEmailAddress =this.FromEmailAddress
        	var SetReplyTo = this.SetReplyTo
            var saveActivitty = false
          //var NewrecordIds = JSON.parse(recordId);
          SendPDFBatchAction(
            {
                ids : recordId,
                DocTemplateId : DocTemplateId,
                Subject : subject,
                Body : emailbody,
                SaveAsActivity : false,
                objectName : objectName,
                StandardEmailTemplateSelectedValue :this.StandardEmailTemplate,
                JunoDocEmailTemplateSelectedValue : this.JunoDocEmailTemplate,
                FromEmailAddress : FromEmailAddress,
                SetReplyTo : SetReplyTo,
                ToTextEmailsList : ToTextEmailsList,
                ToEmailMergeFieldsList : ToEmailMergeFieldsList,
                CCTextEmailsList : CCTextEmailsList,
                CCEmailMergeFieldsList : CCEmailMergeFieldsList,
                BCCTextEmailsList : BCCTextEmailsList,
                BCCEmailMergeFieldsList : BCCEmailMergeFieldsList 
            })
            .then(result =>{
                this.isLoaded = false;
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Mail sent successfully',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                location.reload();
            })
            .catch(error => {
                this.isLoaded = false;
                console.error(error);
            });
           
        
    }

    openForthScreen(){
        this.JunoDocEmailTemplate = '';
        this.StandardEmailTemplate = '';
        this.isSendDoc = false;
        this.FourthNextScreen = true;
    }

    handleSetReplyToOnChange(event){
        this.SetReplyTo = event.target.value;
    }
}
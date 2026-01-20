import { LightningElement,track,api } from 'lwc';
import getinitialObjectFields from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getinitialObjectFields';
import getFirstLevelObjectFields from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getFirstLevelObjectFields';
import getSecondLevelObjectFields from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getSecondLevelObjectFields';
import getThirdLevelObjectFields from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getThirdLevelObjectFields';
import getJunodocObjectsettings from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getJunodocObjectsettings';
import getConUserRec from '@salesforce/apex/JunoschLwcAddEmailRecipientController.getConUserRec';
export default class JunoschLwcAddEmailRecipient extends LightningElement {
    @track isAddEmailClick = false;
    @track isCloseModal = false;
    @track ToValue = 'To';
    @track ReferenceTypeValue = 'Text';
    @track manualEmailAddress = '';
    @track isVisibleEmail = true;
    @track isContactOrUser = false;
    @track conorUserListInOrg = [];
    @track showdropdown = false;
    @track selectedConOrUser = '';
    @track FieldsList = [];
    @track selectedObject = '';
    @track ShowLevel1 = false;
    @track ShowLevel2 = false;
    @track ShowLevel3 = false;
    @track ShowLevel4 = false;
    @track breadcrumbCollection=[]; 
    @track breadCrumbSet = [];
    @track isAddRowDisable = true;
    @track isLoaded = false;
    @track ObjSetEmailList = [];
    @api finalList = [];
    @api finalList2 = [];
    @api emailRecipients;
    @api showHead;
    @api objectLabel;
    @api objectName;
    @track selectedObjectLabel ='';
    @track selectedObjectAPIName = '';

    
    handleAddEmailRecipientClick(){
       this.isAddEmailClick = true;
       this.isCloseModal = true;
       this.finalList = [];
       this.isAddRowDisable = true;
       this.ShowLevel4 = false;
       this.ShowLevel3 = false;
       this.ShowLevel2 = false;
       this.ShowLevel1 = true;
       this.level1Value = '';
       this.ReferenceTypeValue = 'Text';
       this.isContactOrUser = false;
       this.selectedConOrUser = '';
       this.isVisibleEmail = true;
    }
    closeModal(){
        this.isLoaded = true;
        this.isAddEmailClick = false;
        this.isCloseModal = false;
        this.isLoaded = false;
        if(this.finalList2.length == 0){
            this.removeHead = true;
            }
    }
    handleChange(event){
        if(event.target.name=='ToCCBCC'){
          this.ToValue = event.target.value;
        }
        else if(event.target.name=='ReferenceType'){
          this.ReferenceTypeValue = event.target.value;
          if(this.ReferenceTypeValue == 'Reference'){
            this.isVisibleEmail = false;
            this.isContactOrUser = false;
            //this.selectedObjectLabel = this.ObjectLabel;
            //this.selectedObjectAPIName = this.ObjectName;
            var breadcrumbCollection = [];
            var breadcrumb = {};
            var obj = [];
            breadcrumb.label= this.selectedObjectLabel;
            breadcrumb.name=this.selectedObjectAPIName;   
            breadcrumb.level = 'Level 0';
            if(breadcrumbCollection != undefined){
            breadcrumbCollection.push(breadcrumb); 
            //alert('0 '+breadcrumbCollection);
            this.breadCrumbSet = breadcrumbCollection;
            }
            this.ShowLevel1 = true;
            this.ShowLevel2 = false;
            this.ShowLevel3 = false;
            this.ShowLevel4 = false;
            /*this.level1Value = '';
            this.level2Value = '';
            this.level3Value = '';
            this.level4Value = '';*/
            //this.finalList = [];
            this.isAddRowDisable = false;
            this.manualEmailAddress = '';
            if(this.finalList2.length == 0){
                this.removeHead = true;
                }
          }
          else if(this.ReferenceTypeValue == 'Contact' || this.ReferenceTypeValue == 'User'){
            this.isVisibleEmail = true;
            this.isAddRowDisable = false;
            this.isContactOrUser = true;
            getConUserRec({selectedObj : this.ReferenceTypeValue})
            .then(result => {
                console.log(result);
                this.conorUserListInOrg = result;
            })
            .catch(error => {
                console.log('error'+error);
            });
        if(this.finalList2.length == 0){
        this.removeHead = true;
        }
          }
          else{
            this.isVisibleEmail = true;
            this.isContactOrUser = false;
            this.isAddRowDisable = false;
        if(this.finalList2.length == 0){
        this.removeHead = true;
        }
          }
        }
        else if(event.target.name=='email'){
          this.manualEmailAddress = event.target.value;
          console.log('manualEmailAddress '+this.manualEmailAddress); 
          this.isAddRowDisable = false;
        }
    }
    searchHandler(event){
        var filter = event.target.value;
        this.selectedConOrUser = filter;
        console.log(filter);
        //const selectedtitle = event.target.closest('div').dataset.title;
        getConUserRec({selectedObj : this.ReferenceTypeValue, matchStr : filter.toUpperCase()})
            .then(result => {
                console.log(result);
                this.conorUserListInOrg = result;
                this.showdropdown = true;
            })
            .catch(error => {
                console.log('error'+error);
            });
    }
    searchAllHandler(event){
        getConUserRec({selectedObj : this.ReferenceTypeValue, matchStr : ''})
            .then(result => {
                console.log(result);
                this.conorUserListInOrg = result;
                this.showdropdown = true;
            })
            .catch(error => {
                console.log('error'+error);
            });
    }
    optionClickHandler(event){
        const selectedValue = event.target.closest('li').dataset.value;
        const selectedlabel = event.target.closest('li').dataset.name;
        const selectedtitle = event.target.closest('li').dataset.title;
        const selectedId = event.target.closest('li').dataset.id;
        this.selectedConOrUser = selectedlabel;
        this.manualEmailAddress = selectedValue;
        this.showdropdown = false;
        if(selectedValue){
            this.isAddRowDisable = false;
        }
    }
    get ToCCBCCoptions(){
        return [
            { label: 'To', value: 'To' },
            { label: 'CC', value: 'CC' },
            { label: 'BCC', value: 'BCC' },
        ];
    }
    get ReferenceTypeOptions(){
        return [
            { label: 'Text', value: 'Text' },
            { label: 'Reference', value: 'Reference' },
            { label: 'Contact', value: 'Contact' },
            { label: 'User', value: 'User' },
        ];
    }
 
    connectedCallback(){
        //this.ShowLevel1 = true;
        this.isLoaded = true;
        this.selectedObjectLabel = this.objectLabel;
        this.selectedObjectAPIName = this.objectName;
        //alert('this.EmailRecipients '+this.emailRecipients);
        //JSON.parse(JSON.stringify(this.emailRecipients));
        this.finalList2 = [];
        console.log('emailRecipients---->'+this.emailRecipients);
        this.removeHead = false;
        if(this.emailRecipients == '' || this.emailRecipients==null || this.emailRecipients==undefined){
            console.log('selectedObjectAPIName---->'+this.selectedObjectAPIName);
            getJunodocObjectsettings({ObjAPIName : this.selectedObjectAPIName})
            .then(result => {
                this.removeHead = false;
                this.ObjSetEmailList = result;
                console.log('result2w2---->'+JSON.stringify(result));

                var ObjEmailList = [];

                for(var i=0;i<result.length;i++){
                    ObjEmailList.push({
                        indx: i+1,
                        ToCCBCC: result[i].JunoDoc__To_Value__c,
                        ReferenceType: result[i].JunoDoc__Text_Ref_Value__c,
                        EmailValue: result[i].JunoDoc__Email__c,
                        FinalFieldDetails: result[i].JunoDoc__field_Details__c
                    });
                }
                this.finalList2 = ObjEmailList;
                const selectedEvent = new CustomEvent("addemailrecipientsave", {
                    detail:this.finalList2
                });
    
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
                console.log('this.finalList2'+JSON.stringify(this.finalList2));
                
            })
            .catch(error => {
                console.log('error'+error);
            });
        }
        else{
            //this.removeHead = true;
            this.finalList2 = this.emailRecipients;
           
        }
        
        this.showSaveValues = true;
        
        this.isAddRowDisable = false;

        
       /* var breadcrumbCollection = [];
        var breadcrumb = {};
        var obj = [];
        breadcrumb.label= this.selectedObjectLabel;
        breadcrumb.name=this.selectedObjectAPIName;   
        breadcrumb.level = 'Level 0';
        if(breadcrumbCollection != undefined){
            breadcrumbCollection.push(breadcrumb); 
            //alert('0 '+breadcrumbCollection);
            this.breadCrumbSet = breadcrumbCollection;
        }*/
        if(this.level1Value=='' && this.level2Value=='' && this.level3Value=='' && this.level4Value==''){
            this.isAddRowDisable = true; 
        }
        getinitialObjectFields({ObjAPIName : this.selectedObjectAPIName})
        .then(result => {
                this.FieldsList1 = result.WrapperList;
                console.log('this.FieldsList1  ***'+JSON.stringify(this.FieldsList1));
                this.ShowLevel1 = true;
                this.ShowLevel2 = false;
                this.ShowLevel3 = false;
                this.ShowLevel4 = false;
                this.isLoaded = false;
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            console.log('error'+error);
            this.isLoaded = false;
        });
    }
    @track level1Label = '';
    @track level1Value = '';
    @track lookUpObject1 = '';
    @track lookUpObject2 = '';
    @track FieldsList2=[];
    
    handleShowLevel1ObjectFields(event){
        this.isLoaded = true;
        this.ShowLevel1 = true;
        this.ShowLevel2 = false;
        this.ShowLevel3 = false;
        this.ShowLevel4 = false;
        var breadcrumbCollection = this.breadCrumbSet;
        var breadcrumb = {};
        if(event.target.name=='fields'){
          //  alert("Target.Value"+event.target.value);
            this.level1Value =  event.target.value;
            for(let i=0;i<this.FieldsList1.length;i++){
                if(this.level1Value==this.FieldsList1[i].value){
                    this.level1Label = this.FieldsList1[i].label+'';
                }
            }
            console.log('level1Label '+this.level1Label);
            if(this.level1Label.indexOf('>')!=-1){
                //alert('FirstFieldLabel '+level1Label+' FirstFieldValue'+this.level1Value);
                getFirstLevelObjectFields({ObjectName : this.selectedObjectAPIName,FirstFieldValue : this.level1Value})
                .then(result => {
                   this.FieldsList2 = result.WrapperList;
                   this.lookUpObject1 = result.lookUpObject;
                  // alert(this.lookUpObject1);
                   breadcrumb.label= this.lookUpObject1;
                   breadcrumb.name=this.lookUpObject1;
                   if(breadcrumbCollection != undefined){
                    breadcrumbCollection.push(breadcrumb);
                    this.breadCrumbSet = breadcrumbCollection;
                   }
                   console.log('this.FieldsList2  ***'+JSON.stringify(this.FieldsList2));
                   this.ShowLevel1 = false;
                   this.ShowLevel2 = true;
                   this.ShowLevel3 = false;
                   this.ShowLevel4 = false;
                   this.isLoaded = false;
                    })
                    .catch(error => {
                    this.message = undefined;
                    this.error = error;
                    console.log('error'+error);
                    this.isLoaded = false;
                });
                
            }
            else{
                this.isAddRowDisable = false;
                this.isLoaded = false;
            }
        }
      
        
    }
    @track FieldsList3=[];
    @track level2Value ='';
    @track level2Label = '';
    handleShowLevel2ObjectFields(event){
        this.isLoaded = true;
        this.ShowLevel1 = false;
        this.ShowLevel2 = true;
        this.ShowLevel3 = false;
        this.ShowLevel4 = false;
        var breadcrumbCollection = this.breadCrumbSet;
        var breadcrumb = {};
        if(event.target.name=='fields2'){
            this.level2Value =  event.target.value;
            for(let i=0;i<this.FieldsList2.length;i++){
                if(this.level2Value==this.FieldsList2[i].value){
                    this.level2Label = this.FieldsList2[i].label+'';
                }
            }
            console.log('level2Label '+this.level2Label);
            if(this.level2Label.indexOf('>')!=-1){
                //alert('SecondFieldLabel '+level2Label+' SecondFieldValue'+this.level2Value);
                getSecondLevelObjectFields({ObjectName : this.lookUpObject1,FirstFieldValue : this.level1Value,SecondFieldValue : this.level2Value})
                .then(result => {
                    this.FieldsList3 = result.WrapperList;
                    this.lookUpObject2 = result.lookUpObject;
                    breadcrumb.label= this.lookUpObject2;
                    breadcrumb.name=this.lookUpObject2;
                    if(breadcrumbCollection != undefined){
                        breadcrumbCollection.push(breadcrumb); 
                       this.breadCrumbSet = breadcrumbCollection;
                    } 
                    console.log('this.FieldsList3  ***'+JSON.stringify(this.FieldsList3));
                    this.ShowLevel1 = false;
                    this.ShowLevel2 = false;
                    this.ShowLevel3 = true;
                    this.ShowLevel4 = false;
                    this.isLoaded = false;
                     })
                     .catch(error => {
                     this.message = undefined;
                     this.error = error;
                     console.log('error'+error);
                     this.isLoaded = false;
                     
                 });
            }
            else{
                    this.isAddRowDisable = false;
                    this.isLoaded = false;
            }
        }
    }
    @track FieldsList4=[];
    @track level3Value ='';
    @track level3Label ='';
    handleShowLevel3ObjectFields(event){
        this.isLoaded = true;
        this.ShowLevel1 = false;
        this.ShowLevel2 = false;
        this.ShowLevel3 = true;
        this.ShowLevel4 = false;
        var breadcrumbCollection = this.breadCrumbSet;
        var breadcrumb = {};
        if(event.target.name=='fields3'){
            this.level3Value =  event.target.value;
            for(let i=0;i<this.FieldsList3.length;i++){
                if(this.level3Value==this.FieldsList3[i].value){
                    this.level3Label = this.FieldsList3[i].label+'';
                }
            }
            console.log('level3Label '+this.level3Label);
            if(this.level3Label.indexOf('>')!=-1){
                //alert('ThirdLabel '+level3Label+' ThirdFieldValue'+this.level3Value);
                getThirdLevelObjectFields({ObjectName : this.lookUpObject2,FirstFieldValue : this.level1Value,SecondFieldValue : this.level2Value,ThirdFieldValue : this.level3Value})
                .then(result => {
                    if(result!=''){
                        this.FieldsList4 = result.WrapperList;
                        this.lookUpObject3 = result.lookUpObject;
                        breadcrumb.label= this.lookUpObject3;
                        breadcrumb.name=this.lookUpObject3;
                        if(breadcrumbCollection != undefined){
                           breadcrumbCollection.push(breadcrumb);
                           this.breadCrumbSet = breadcrumbCollection;
                           //alert('3 '+JSON.stringify(this.breadcrumbCollection));
                        } 
                       
                    }
                    else{
                        var noneList = [];
                        this.FieldsList4 = noneList.push('--None--');
                    }
                   
                    console.log('this.FieldsList4  ***'+JSON.stringify(this.FieldsList4));
                        this.ShowLevel1 = false;
                        this.ShowLevel2 = false;
                        this.ShowLevel3 = false;
                        this.ShowLevel4 = true;
                        this.isLoaded = false;
                     })
                     .catch(error => {
                     this.message = undefined;
                     this.error = error;
                     console.log('error'+error);
                     this.isLoaded = false;
                 });
            }
            else{
                this.isAddRowDisable = false;
                this.isLoaded = false;
            }
        }
    }
    @track level4Label ='';
    @track level4Value ='';
    handleShowLevel4ObjectFields(event){
        this.ShowLevel1 = false;
        this.ShowLevel2 = false;
        this.ShowLevel3 = false;
        this.ShowLevel4 = true;
        this.isLoaded = true;
        if(event.target.name=='fields4'){
            this.level4Value =  event.target.value;
            for(let i=0;i<this.FieldsList4.length;i++){
                if(this.level4Value==this.FieldsList4[i].value){
                    this.level4Label = this.FieldsList4[i].label+'';
                }
            }
            console.log('this.level4Label '+this.level4Label);
            if(this.level4Label.indexOf('>')!=-1){
                //alert('4Label '+this.level4Label+' 4FieldValue'+this.level4Value);
                getFourthLevelObjectFields({ObjectName : this.lookUpObject3,FirstFieldValue : this.level1Value,SecondFieldValue : this.level2Value,ThirdFieldValue : this.level3Value,FourthFieldValue : this.level4Value})
                .then(result => {
                   console.log(result);
                   this.isLoaded = false;
                     })
                     .catch(error => {
                     this.message = undefined;
                     this.error = error;
                     console.log('error'+error);
                     this.isLoaded = false;
                 });
            }
            else{
                this.isAddRowDisable = false;
                this.isLoaded = false;
            }
        }
       
    }
    handleNavigateTo(event){
        
        var removeElement = event.target.label;
        //alert('removeElement '+removeElement+this.breadCrumbSet);
        //var popped = removeElement.pop();
        //alert('popped'+popped);
        //alert( 'index first'+this.breadCrumbSet[0]);
        var index = this.breadCrumbSet.indexOf(removeElement);
        //alert('removeElement'+removeElement+' index '+index);
        this.isLoaded = true;
        if (index >= -1 && removeElement!=this.selectedObjectLabel) {
            this.breadCrumbSet.splice(index, 1);
            if(removeElement == this.lookUpObject3){
                this.ShowLevel4 = false;
                this.ShowLevel3 = true;
                this.ShowLevel2 = false;
                this.ShowLevel1 = false;
                this.level3Value = '';
                this.isLoaded = false;
            }
            else if(removeElement == this.lookUpObject2){
                this.ShowLevel4 = false;
                this.ShowLevel3 = false;
                this.ShowLevel2 = true;
                this.ShowLevel1 = false;
                this.level2Value = '';
                this.isLoaded = false;
            }
            else if(removeElement == this.lookUpObject1){
                this.ShowLevel4 = false;
                this.ShowLevel3 = false;
                this.ShowLevel2 = false;
                this.ShowLevel1 = true;
                this.level1Value = '';
                this.connectedCallback();
                this.isLoaded = false;
            }
            this.isLoaded = false;
        }
        else if(removeElement==this.selectedObjectLabel){
            this.isLoaded = false;
        }
      
    }
    @track finalListIndex=0; 
    @track finalList2Index=0;
    @track index;
    handleAddRow(){
        //this.isLoaded = true
        this.isAddRowDisable = false;
        this.removeHead = false;
        this.finalListIndex+1;
        console.log('add row');
        this.index = this.finalList.length+1;
        console.log('finalList index--->'+this.index);
        console.log('finalList addrow--->'+this.finalList);
        //this.selectedObjectLabel = 'Account';
        //this.selectedObjectAPIName = 'Account';
        var breadcrumbCollection = [];
        var breadcrumb = {};
        breadcrumb.label= this.selectedObjectLabel;
        breadcrumb.name=this.selectedObjectAPIName;   
        breadcrumb.level = 'Level 0';
        if(breadcrumbCollection != undefined){
            breadcrumbCollection.push(breadcrumb); 
            //alert('0 '+breadcrumbCollection);
            this.breadCrumbSet = breadcrumbCollection;
        }
        console.log('this.breadCrumbSet '+JSON.stringify(this.breadCrumbSet));    

        if(this.isVisibleEmail == false){
            var FinalList =  JSON.parse(JSON.stringify(this.finalList));
            if(this.level1Value.indexOf('Email')>=0){
           
                var rowExists=false;
                for(var i=0;i<FinalList.length;i++){
                    if(FinalList[i].ToCCBCC==this.ToValue 
                        && FinalList[i].ReferenceType==this.ReferenceTypeValue 
                        && FinalList[i].EmailValue==this.selectedObjectLabel+'>'+this.level1Label ){
                            rowExists = true;
                            break;
                    }
                }


                if(rowExists==false){
                    FinalList.push({
                        indx: this.index,
                        ToCCBCC: this.ToValue,
                        ReferenceType: this.ReferenceTypeValue,
                        EmailValue: this.selectedObjectLabel+'>'+this.level1Label,
                        FinalFieldDetails: this.selectedObjectAPIName+'.'+this.level1Value
                    });
                    this.finalList = FinalList;
                }

                
                console.log('api--->'+this.selectedObjectAPIName+'.'+this.level1Value);

             //   alert('api--->'+this.selectedObjectAPIName+'.'+this.level1Value);


                    this.isSaveDisable = false;
                    this.isLoaded = false;
                    this.level1Value = '';
                    this.level2Value = '';
                    this.level3Value = '';
                    this.level4Value = '';
                    this.ShowLevel4 = false;
                    this.ShowLevel3 = false;
                    this.ShowLevel2 = false;
                    this.ShowLevel1 = true;
                    this.removeHead = false;

            }
            else if(this.level2Value.indexOf('Email')>=0){


                var rowExists=false;
                for(var i=0;i<FinalList.length;i++){
                    if(FinalList[i].ToCCBCC==this.ToValue 
                        && FinalList[i].ReferenceType==this.ReferenceTypeValue 
                        && FinalList[i].EmailValue==this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label){
                            rowExists = true;
                            break;
                    }
                }


                if(rowExists==false){
                    if(this.level1Value.includes('__c')){
                        this.level1Value = this.level1Value.replace('__c','__r');
                    }
                    else{
                        this.level1Value = this.level1Value.substring(0, this.level1Value.length-2);
                    }
                    FinalList.push({
                        indx: this.index,
                        ToCCBCC: this.ToValue,
                        ReferenceType: this.ReferenceTypeValue,
                        EmailValue: this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label,
                        FinalFieldDetails: this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value
                    });    
                    this.finalList = FinalList;
                }                
                console.log('api level2--->'+this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value);

               // alert('level2 api--->'+this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value);


                this.removeHead = false;

                this.isSaveDisable = false;
                this.level1Value = '';
                this.level2Value = '';
                this.level3Value = '';
                this.level4Value = '';
                this.ShowLevel4 = false;
                this.ShowLevel3 = false;
                this.ShowLevel2 = false;
                this.ShowLevel1 = true;
                this.isLoaded = false;
            }
            else if(this.level3Value.indexOf('Email')>=0){
            
                var rowExists=false;
                for(var i=0;i<FinalList.length;i++){
                    if(FinalList[i].ToCCBCC==this.ToValue 
                        && FinalList[i].ReferenceType==this.ReferenceTypeValue 
                        && FinalList[i].EmailValue==this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label+''+this.level3Label){
                            rowExists = true;
                            break;
                    }
                }


                if(rowExists==false){
                  //  alert('this.level1Value' + this.level1Value);
                    if(this.level1Value.includes('__c')){
                        this.level1Value = this.level1Value.replace('__c','__r');
                    }
                    else{
                        this.level1Value = this.level1Value.substring(0, this.level1Value.length-2);
                    }
                 //   alert('this.level1Value 1' + this.level1Value);
                    if(this.level2Value.includes('__c')){
                        this.level2Value = this.level2Value.replace('__c','__r');
                    }
                    else{
                        this.level2Value = this.level2Value.substring(0, this.level2Value.length-2);
                    }
                    FinalList.push({
                        indx: this.index,
                        ToCCBCC: this.ToValue,
                        ReferenceType: this.ReferenceTypeValue,
                        EmailValue: this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label+''+this.level3Label,
                        FinalFieldDetails: this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value+'.'+this.level3Value
                    });
                    this.finalList = FinalList;    
                }

                console.log('level3 api--->'+this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value+'.'+this.level3Value);

               // alert('level3 api--->'+this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value+'.'+this.level3Value);



                this.isSaveDisable = false;
                this.level1Value = '';
                this.level2Value = '';
                this.level3Value = '';
                this.level4Value = '';
                this.ShowLevel4 = false;
                this.ShowLevel3 = false;
                this.ShowLevel2 = false;
                this.ShowLevel1 = true;
                this.isLoaded = false;
                this.removeHead = false;
            }
            else if(this.level4Value.indexOf('Email')>=0){
                var rowExists=false;
                for(var i=0;i<FinalList.length;i++){
                    if(FinalList[i].ToCCBCC==this.ToValue 
                        && FinalList[i].ReferenceType==this.ReferenceTypeValue 
                        && FinalList[i].EmailValue==this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label+''+this.level3Label+''+this.level4Label){
                            rowExists = true;
                            break;
                    }
                }


                if(rowExists==false){
                    if(this.level1Value.includes('__c')){
                        this.level1Value = this.level1Value.replace('__c','__r');
                    }
                    else{
                        this.level1Value = this.level1Value.substring(0, this.level1Value.length-2);
                    }
                    if(this.level2Value.includes('__c')){
                        this.level2Value = this.level2Value.replace('__c','__r');
                    }
                    else{
                        this.level2Value = this.level2Value.substring(0, this.level2Value.length-2);
                    }
                    if(this.level3Value.includes('__c')){
                        this.level3Value = this.level3Value.replace('__c','__r');
                    }
                    else{
                        this.level3Value = this.level3Value.substring(0, this.level3Value.length-2);
                    }
                    FinalList.push({
                        indx: this.index,
                        ToCCBCC: this.ToValue,
                        ReferenceType: this.ReferenceTypeValue,
                        EmailValue: this.selectedObjectLabel+'>'+this.level1Label+''+this.level2Label+''+this.level3Label+''+this.level4Label,
                        FinalFieldDetails: this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value+'.'+this.level3Value+'.'+this.level4Value
                    });
                    this.finalList = FinalList;    
                }            

                console.log('api--->'+this.selectedObjectAPIName+'.'+this.level1Value);

              //  alert('level4 api--->'+this.selectedObjectAPIName+'.'+this.level1Value+'.'+this.level2Value+'.'+this.level3Value+'.'+this.level4Value);


                this.isSaveDisable = false;
                this.level1Value = '';
                this.level2Value = '';
                this.level3Value = '';
                this.level4Value = '';
                this.ShowLevel4 = false;
                this.ShowLevel3 = false;
                this.ShowLevel2 = false;
                this.ShowLevel1 = true;
                this.isLoaded = false;
                this.removeHead = false;
            }
        }
        else if(this.isVisibleEmail == true && this.manualEmailAddress!=''){
            var FinalList = [];
            FinalList = JSON.parse(JSON.stringify(this.finalList));            
            var rowExists=false;
            for(var i=0;i<FinalList.length;i++){
                if(FinalList[i].ToCCBCC==this.ToValue 
                    && FinalList[i].ReferenceType==this.ReferenceTypeValue 
                    && FinalList[i].EmailValue==this.manualEmailAddress ){
                        rowExists = true;
                        break;
                }
            }

            if(rowExists==false){
                FinalList.push({
                    indx: this.index,
                    ToCCBCC: this.ToValue,
                    ReferenceType: this.ReferenceTypeValue,
                    EmailValue: this.manualEmailAddress,
                    FinalFieldDetails: this.manualEmailAddress
                });    
            }

            

            this.finalList = FinalList;
            this.isSaveDisable = false;
            this.isLoaded = false;
            this.removeHead = false;
            this.manualEmailAddress = '';
        }
    }  
    
    @track removeHead = false;
    @track globalRemoveRows=[];
    removeRow(event){
        //var count = event.currentTarget.dataset.id;
        if(this.finalList.length>=1){
            var FinalList = JSON.parse(JSON.stringify(this.finalList));
            //alert('this.finalList.length '+this.finalList.length);
            FinalList.splice(event.target.accessKey, 1);                
            this.finalList = FinalList;
            //count--;
            //alert('After remove '+this.finalList.length);
            for(var i=0;i<FinalList.length;i++){
                finalList2.push({
                    //indx: (FinalList[i].indx + finalList2.length),
                        ToCCBCC: FinalList[i].ToCCBCC,
                        ReferenceType: FinalList[i].ReferenceType,
                        EmailValue: FinalList[i].EmailValue,
                        FinalFieldDetails: FinalList[i].FinalFieldDetails
                });
            }
           this.finalListIndex-1;
           const selectedEvent = new CustomEvent("addemailrecipientsave", {
                detail:this.finalList2
            });

            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
            if(this.finalList==''){
                this.removeHead = true;
            }
        }
        else if(this.finalList== ''){

            this.isSaveDisable = true;
            
        }
        console.log('remove:finallist '+JSON.stringify(this.finalList));
        for(var i=0;i<this.finalList2.length;i++){
            this.finalList2[i].indx = (i+1);
        }
        console.log(' this.finalList remove rows -->'+JSON.stringify(this.finalList));
        const selectedEvent = new CustomEvent("addemailrecipientsave", {
            detail:this.finalList2
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
                    
    }
    removeRow2(event){
        //var count = event.currentTarget.dataset.id;
        if(this.finalList2.length>=1){
            var FinalList2 = JSON.parse(JSON.stringify(this.finalList2));
            //alert('this.finalList.length '+this.finalList.length);
            FinalList2.splice(event.target.accessKey, 1);                
            this.finalList2 = FinalList2;
            //count--;
            //alert('After remove '+this.finalList.length);
           this.finalList2Index-1;
           const selectedEvent = new CustomEvent("addemailrecipientsave", {
                detail:this.finalList2
            });

            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
            if(this.finalList2==''){
                this.removeHead = true;
            }
        }
        else if(this.finalList2=='' || this.finalList2==undefined){
            
            
        }
        console.log('remove:finallist '+JSON.stringify(this.finalList));
        for(var i=0;i<this.finalList2.length;i++){
            this.finalList[i].indx = (i+1);
        }
        console.log(' this.finalList remove rows -->'+JSON.stringify(this.finalList2));
        const selectedEvent = new CustomEvent("addemailrecipientsave", {
            detail:this.finalList2
        });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
                    
    }
    @track showSaveValues = false;
    @track isSaveDisable = true;
    @track saveFinalList = [];
    handleSave(){
        this.isLoaded = true;
        console.log(' this.finalList before save-->'+JSON.stringify(this.finalList));
        if(this.finalList.length>0){
           // this.saveFinalList = this.finalList;
            this.isAddEmailClick = false;
            this.isCloseModal = false;
            this.showSaveValues = true;8
            this.isSaveDisable = false;
            
            console.log('Final List '+JSON.stringify(this.finalList));
            var finalList2 = JSON.parse(JSON.stringify(this.finalList2));
            for(var i=0;i<this.finalList.length;i++){
                finalList2.push({
                    indx: (this.finalList[i].indx + finalList2.length),
                        ToCCBCC: this.finalList[i].ToCCBCC,
                        ReferenceType: this.finalList[i].ReferenceType,
                        EmailValue: this.finalList[i].EmailValue,
                        FinalFieldDetails: this.finalList[i].FinalFieldDetails
                });
            }
            this.finalList2 = finalList2;
            this.finalList = [];
            if(this.finalList2.length == 0){
                this.removeHead = true;
                }
            // Creates the event with the data.
            const selectedEvent = new CustomEvent("addemailrecipientsave", {
                detail:finalList2
            });
            this.isLoaded = false;
            console.log('finallist2--->'+this.finalList2);
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
        }
        else{
            this.isSaveDisable = true;
            this.isLoaded = false;
        }
    } 
}
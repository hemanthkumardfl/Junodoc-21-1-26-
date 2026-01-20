import { LightningElement, track, wire, api } from 'lwc';
import getFields from '@salesforce/apex/MergeFieldGeneratorController.getAllFields';
import getRelation from '@salesforce/apex/MergeFieldGeneratorController.getRelationshipName';
import getSecondRelation from '@salesforce/apex/MergeFieldGeneratorController.secondRelation';
//import createJunoTemplate from '@salesforce/apex/MergeFieldGeneratorController.createJunoTemplate';
//import UpdateJunoSMSTemplateData from '@salesforce/apex/MergeFieldGeneratorController.UpdateJunoSMST';
export default class JunoSMSMergeFieldButton extends LightningElement {

    /* @api selectedObjectApiName = ''
     @track fieldBoxOpen = false;
     @track firstBoxFields = [];
     @track showSpinner = false;
     @track thirdBoxSelected = false;
     @track secondBoxSelected = false;
     @track firstBoxSelected = false;
     @track openThirdBox = false;
     @track openSecondBox = false;
     @track firstBoxReferenceFields = [];
     @track firstBox = [];
     @track showbutton = true;*/
    @api selectedObjectApiName = ''
    @track ObjectList = [];
    @track displayedNames = [];
    @track showSearchObjects = false;
    @api isLoaded = false;
    @track objectName = '';
    @api objectName;
    @track selectedObject = '';
    @track selectedObjectApiName = '';
    @track showTemplates = false;
    @track TemplateRecords = [];
    @track selectedvalue = '';
    recordOptions;
    @track selectedTemplate;
    @track fieldBoxOpen = false;
    @track fieldlist = [];

    @track firstBoxFields = [];
    @track firstBoxReferenceFields = [];
    @track firstBox = [];
    @track firstBoxSelected = false;
    @track firstBoxselectedField = '';
    @track parameterToCopy = '';
    @track copytoparameter = '';
    @track parametercopy = '';
    @track firstRelationShipName = '';
    @track secondRelationShipName = '';

    @track openSecondBox = false;
    @track showbutton = true;
    @track hidebutton = false;
    @track secondshowbutton = true;
    @track secondhidebutton = false;
    @track thirdshowbutton = true;
    @track thirdhidebutton = false;
    @track secondBoxFields = [];
    @track secondBoxReferenceFields = [];
    @track secondBox = [];
    @track secondBoxSelected = false;
    @track secondBoxselectedField = '';

    @track openThirdBox = false;
    @track thirdBoxFields = [];
    @track thirdBoxReferenceFields = [];
    @track thirdBox = [];
    @track thirdBoxSelected = false;
    @track thirdBoxselectedField = '';
    @track showsave = false;
    @track closeupdate = false;
    @track templatename = '';
    @track body = '';
    @track showSpinner = false;
    @api recordId;
    @track wiredResult;
    @track activeSection = null;
    @track showaccordion = false;
    @track hidefooter = true;
    @track showfooter = false;
    @track showlistbox = false;

    @track showAddTemplateButton = false;
    @track showTemplateName = false;
    @track showMessageBox = false;

    connectedCallback() {

    }


    openFieldsBox() {
        this.fieldBoxOpen = true;
        getFields({ objectName: this.selectedObjectApiName })
            .then(result => {
                var firstBoxFields = [];
                var firstBoxReferenceFields = [];
                this.firstBox = result;
                for (let i in result) {
                    if (result[i]['type'] == 'REFERENCE') {
                        firstBoxReferenceFields.push(result[i]);
                    }
                    else {
                        firstBoxFields.push(result[i]);
                    }
                }
                this.firstBoxReferenceFields = firstBoxReferenceFields;
                this.firstBoxFields = firstBoxFields;
            })
            .catch(error => {
                console.log('Error >>>> ' + JSON.stringify(error));
            })
    }


    closeModal(event) {
        this.fieldBoxOpen = false;
    }

    selectOption(event) {
        this.showSpinner = true;
        var selectedField = event.currentTarget.value;
        this.firstBoxselectedField = selectedField;
        var checkReference = 'NotReference';
        for (let i in this.firstBox) {
            if (this.firstBox[i]['value'] == selectedField && this.firstBox[i]['type'] == 'REFERENCE') {
                checkReference = 'Reference';
            }
        }
        if (checkReference == 'Reference') {
            this.firstBoxSelected = false;

            getRelation({ objectName: this.selectedObjectApiName, fieldApiName: selectedField })
                .then(result => {
                  //  alert('result--->' + JSON.stringify(result));
                    this.firstRelationShipName = result.relationName;
                    this.secondBox = result.innerFieldsList;
                    var secondBoxFields = [];
                    var secondBoxReferenceFields = [];
                    for (let i in this.secondBox) {
                        if (this.secondBox[i]['type'] == 'REFERENCE') {
                            secondBoxReferenceFields.push(this.secondBox[i]);
                        }
                        else {
                            secondBoxFields.push(this.secondBox[i]);
                        }
                    }
                    this.secondBoxReferenceFields = secondBoxReferenceFields;
                    this.secondBoxFields = secondBoxFields;
                    this.openSecondBox = true;
                    this.secondBoxSelected = false;
                    this.secondBoxselectedField = '';
                })
                .catch(error => {
                    console.log('Error >>>>>> ' + JSON.stringify(error));
                })
        }
        else {
            this.firstBoxSelected = true;
            this.openSecondBox = false;
            this.secondBoxSelected = false;
            this.secondBoxselectedField = '';
            this.thirdBoxSelected = false;
            this.openThirdBox = false;
            this.showbutton = true;
            this.hidebutton = false;
        }
        setTimeout(() => {
            this.showSpinner = false;
        }, 1000);
    }


    selectOption2(event) {
        this.showSpinner = true;
        var selectedField = event.currentTarget.value;
        this.secondBoxselectedField = selectedField;
        var checkReference = 'NotReference';
        for (let i in this.secondBox) {
            if (this.secondBox[i]['value'] == selectedField && this.secondBox[i]['type'] == 'REFERENCE') {
                checkReference = 'Reference';
            }
        }

        if (checkReference == 'Reference') {
            this.secondBoxSelected = false;
            getSecondRelation({ objectName: this.selectedObjectApiName, fieldApiName: this.firstBoxselectedField, secondfieldApiName: selectedField })
                .then(result => {
                    this.secondRelationShipName = result.relationName;
                    this.thirdBox = result.innerFieldsList;
                    this.openThirdBox = true;
                    this.thirdBoxSelected = false
                })
                .catch(error => {
                    console.log('Error >>> ' + JSON.stringify(error))
                })
        }
        else {
            this.secondBoxSelected = true;
            this.openThirdBox = false;
            this.thirdBoxSelected = false
            this.secondshowbutton = true;
            this.secondhidebutton = false;
        }
        setTimeout(() => {
            this.showSpinner = false;
        }, 1000);
    }

    clipboardcopy(event) {
        this.secondshowbutton = false;
        const optionselect = '{' + '!' + 'relatedTo' + '.' + this.firstRelationShipName + '.' + this.secondBoxselectedField + '}';
        this.copytoparameter = optionselect;
       // alert(this.parameterToCopy);
        const input = document.createElement('input');
        input.setAttribute('value', this.copytoparameter);
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        input.remove();
        console.log('Parameter copied to clipboard: ' + this.copytoparameter);
        this.secondhidebutton = true;
    }

    copyToClipboard(event) {
        this.showbutton = false;
        const selectedOption = '{' + '!' + 'relatedTo' + '.' + this.firstBoxselectedField + '}';
        this.parameterToCopy = selectedOption;
        const input = document.createElement('input');
        input.setAttribute('value', this.parameterToCopy);
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        input.remove();
        console.log('Parameter copied to clipboard: ' + this.parameterToCopy);
        this.hidebutton = true;
    }

    clipboard(event) {
       // alert('Test')
        this.thirdshowbutton = false;
        const seloption = '{' + '!' + 'relatedTo' + '.' + this.firstRelationShipName + '.' + this.secondRelationShipName + '__r' + '.' + this.thirdBoxselectedField + '}';
        this.parametercopy = seloption;
        const input = document.createElement('input');
        input.setAttribute('value', this.parametercopy);
        document.body.appendChild(input);
        input.select();
        document.execCommand('copy');
        input.remove();
        console.log('Parameter copied to clipboard: ' + this.parametercopy);
        this.thirdhidebutton = true;
    }


    selectOption3(event) {
        this.showSpinner = true;
        var selectedField = event.currentTarget.value;
        this.thirdBoxselectedField = selectedField;
        this.thirdBoxSelected = true;
        this.thirdshowbutton = true;
        this.thirdhidebutton = false;
        setTimeout(() => {
            this.showSpinner = false;
        }, 1000);
    }
    submitDetails(event) {
        this.fieldBoxOpen = false;
        this.openSecondBox = false;
        this.openThirdBox = false;
        this.firstBoxSelected = false;
        this.secondBoxSelected = false;
        this.thirdBoxSelected = false;
    }

}
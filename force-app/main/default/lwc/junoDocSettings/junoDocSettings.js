import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSettingsRecord from '@salesforce/apex/JunoDocSettingsController.getSettingsRecord';
import runScheduleJobs from '@salesforce/apex/JunoDocSettingsController.runScheduleJobs';
import runJunodocScheduleJobs from '@salesforce/apex/JunoDocSettingsController.runJunodocScheduleJobs';
import createSetting from '@salesforce/apex/JunoDocSettingsController.createSetting';
import createSettings from '@salesforce/apex/JunoDocSettingsController.createSettings';
import getOrgWideEmails from '@salesforce/apex/JunoDocSettingsController.orgwideEmail';
import createQuote from '@salesforce/apex/JunoDocSettingsController.createQuote';
import createOpportunity from '@salesforce/apex/JunoDocSettingsController.createOpportunity';
import createAscent from '@salesforce/apex/JunoDocSettingsController.createAscentQuote';
import createRecords from '@salesforce/apex/JunoDocSettingsController.CreateEmailTemplatesRecords';

import getrecorddetails from '@salesforce/apex/JunoDocSettingsController.getrecorddetails';

export default class JunoDocSettings extends LightningElement {

    @track isScheduleActive = '';
    @track isScheduleActive2 = '';
    @track toogleFieldValue = '';
    @track toogleFieldValue2 = '';
    @track disableEmailBody = false;
    @api cancel = '';
    @api success = '';
    @api url = '';
    @api Enablejunosign = false;
    @api EnableattachmentList = false;
    @api EnableSenderBCC = false;
    @api communityurl = '';
    @api Orgurl = '';
    @api selectedSignValue = '';
    @api selectedDefaultFromEmail;
    @api fromEmailOptions = [];
    @track isOpportunityDisable = false;
    @track iscreatemailtemplateDisable = false;
    @track iscreateAcentDisable = false;
    @track isQuoteDisable = false;
    @track condition;

    connectedCallback() {
        this.condition = 'Check';
        this.CheckRecords();
        this.condition = 'Create';
        this.selectedSignValue = 'Text';

        getOrgWideEmails()
            .then((result) => {
                if (result !== undefined && result != '') {
                    let opts = this.fromEmailOptions;
                    opts.push({
                        label: "None",
                        value: ""
                    });
                    for (var key in result) {
                        opts.push({
                            label: result[key],
                            value: key
                        });
                    }
                    /*if(opts.length >= 2){
                        this.selectedDefaultFromEmail = opts[1]['value']
                    }*/
                    this.fromEmailOptions = opts;
                }
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                console.log('error' + error);

            });

        getSettingsRecord()
            .then((result) => {
                if (result !== undefined && result != '') {
                    console.log(JSON.parse(JSON.stringify(result)));
                    var scheduleActive = JSON.parse(JSON.stringify(result));
                    this.isScheduleActive = scheduleActive.scheduleTriggers;
                    console.log('isScheduleActive--->' + this.isScheduleActive);
                    this.isScheduleActive2 = scheduleActive.JunodocscheduleTriggers;
                    console.log('isScheduleActive2--->' + this.isScheduleActive2);
                }
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                console.log('error' + error);

            });

        getrecorddetails()
            .then((result) => {
                if (result !== undefined && result != '' && result != null) {
                    //alert('----ReturnValue------>'+this.cancel); 
                    if (result.JunoDoc__Signature_Cancel_Message__c != null)
                        this.cancel = result.JunoDoc__Signature_Cancel_Message__c;
                    if (result.JunoDoc__Signature_Success_Message__c != null)
                        this.success = result.JunoDoc__Signature_Success_Message__c;
                    if (result.JunoDoc__Site_URL__c != null)
                        this.url = result.JunoDoc__Site_URL__c;
                    if (result.JunoDoc__Community_URL__c != null)
                        this.communityurl = result.JunoDoc__Community_URL__c;
                    if (result.JunoDoc__Enable_JunoSign__c != null)
                        this.Enablejunosign = result.JunoDoc__Enable_JunoSign__c;
                    if (result.JunoDoc__Enable_Attachment_List_View__c != null)
                        this.EnableattachmentList = result.JunoDoc__Enable_Attachment_List_View__c;
                    if (result.JunoDoc__Disable_Email_Template_Body__c != null)
                        this.disableEmailBody = result.JunoDoc__Disable_Email_Template_Body__c;
                    if (result.JunoDoc__Enable_SenderBCC__c != null)
                        this.EnableSenderBCC = result.JunoDoc__Enable_SenderBCC__c;
                    if (result.JunoDoc__Organization_Url__c != null)
                        this.Orgurl = result.JunoDoc__Organization_Url__c;
                    this.selectedSignValue = result.JunoDoc__Signature_Format__c ? result.JunoDoc__Signature_Format__c : 'Text';
                    this.selectedDefaultFromEmail = result.JunoDoc__JunoSign_Default_From_Address__c;
                }
            })
    }
    handleToggleChange(event) {
        if (event.target.label == 'Junodoc Triggers') {
            this.toogleFieldValue = event.target.checked;
            console.log('this.toogleFieldValue  ' + this.toogleFieldValue);

            runScheduleJobs({ toggleValue: this.toogleFieldValue })
                .then(result => {
                    console.log('result');
                })
                .catch(error => {
                    console.log('error ****' + error);
                });

        }
    }
    handleToggleChange2(event) {
        if (event.target.label == 'Junodoc Schedule') {
            this.toogleFieldValue2 = event.target.checked;
            console.log('this.toogleFieldValue2  ' + this.toogleFieldValue2);

            runJunodocScheduleJobs({ toggleValue: this.toogleFieldValue2 })
                .then(result => {
                    console.log('result');
                })
                .catch(error => {
                    console.log('error ****' + error);
                });

        }
    }
    handleClick() {
        //alert('----------->'+this.cancel);
        if (this.cancel.trim() == "" || this.success.trim() == "" || this.url.trim() == "") {
            var msg = "";
            if (this.success.trim() == "") {
                msg = 'Signature Sucess Message';
            }
            if (this.cancel.trim() == "") {
                msg = (msg != "") ? msg + ', Signature Cancel Message' : 'Signature Cancel Message';
            }
            if (this.communityurl.trim() == "") {
                msg = (msg != "") ? msg + ', Site URL' : 'Site URL';
            }
            if (this.Orgurl.trim() == "") {
                msg = (msg != "") ? msg + ', Org URL' : 'Org URL';
            }
            msg += ' required';
            const evt = new ShowToastEvent({
                title: 'Error',
                message: msg,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
        else {
            createSetting({
                cancel: this.cancel,
                success: this.success,
                url: this.url,
                communityurl: this.communityurl,
                EnableJuno: this.Enablejunosign,
                EnableattachmentList: this.EnableattachmentList,
                EnableSender: this.EnableSenderBCC,
                OrgUrl: this.Orgurl,
                signFormat: this.selectedSignValue,
                defaultFromEmailAddress: this.selectedDefaultFromEmail
            })
                .then(result => {
                    //  if(result.isSuccess == true){

                    //  }
                    if (result == "success") {
                        const evt = new ShowToastEvent({
                            title: 'Success',
                            message: 'Juno settings updated successfully',
                            variant: 'success',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                        // getrecorddetails()
                        // .then((result) =>   { 
                        //     if(result!==undefined && result!=''){ 
                        //         //alert('----ReturnValue------>'+this.cancel);   

                        //     }
                        // })
                    }
                });
        }

    }


    handleClicksave() {
        createSettings({
            EnableSender: this.EnableSenderBCC,
            DisableEmailBody: this.disableEmailBody
        })
            .then(result => {
                if (result == "success") {
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Juno settings updated successfully',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }
            });
    }

    changeSuccessHandler(event) {
        //this.cancel = event.target.value;
        this.success = event.target.value;
    }
    changeerrorHandler(eve) {
        this.cancel = eve.target.value;
        //this.success = eve.target.value;
    }
    changeurlHandler(event) {
        this.url = event.target.value;
    }


    changecommunityurlHandler(event) {
        this.communityurl = event.target.value;
    }
    changejunosignHandler(event) {
        this.Enablejunosign = event.detail.checked;
    }
    changeEnableattachmentListHandler(event) {
        this.EnableattachmentList = event.detail.checked;
    }

    changeSenderBCCHandler(event) {
        this.EnableSenderBCC = event.detail.checked;
    }

    changeDisableHandler(event) {
        this.disableEmailBody = event.detail.checked;
    }

    changeOrgurlHandler(event) {
        this.Orgurl = event.target.value;
    }



    get options() {
        return [
            { label: 'Draw', value: 'Draw' },
            { label: 'Text', value: 'Text' }
        ];
    }

    handleChange(event) {
        this.selectedSignValue = event.detail.value;
    }

    handleEmailChange(event) {
        this.selectedDefaultFromEmail = event.detail.value
    }

    CreateOpportunitySetting(event) {
        createOpportunity({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.isOpportunityDisable = result
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Sample Opportunity Template created successfully.',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })
    }

    CreateQuoteSetting(event) {
        createQuote({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.isQuoteDisable = result
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Sample Quote Template created successfully.',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })
    }

    CheckRecords() {
        createQuote({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.isQuoteDisable = result
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })

        createOpportunity({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.isOpportunityDisable = result
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })

     createRecords({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.iscreatemailtemplateDisable = result
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })
    
    createAscent({ condition: this.condition })
            .then(result => {
                console.log(result);
                this.iscreateAcentDisable = result
            })
            .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            })
            
    }

    ctrateJunosinTemplate(event){
        createRecords({condition: this.condition})
           .then(result => {
               console.log(result);
                this.iscreatemailtemplateDisable = result
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Sample JunoSign Email Template created successfully.',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
             .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            });
    }


    CreateAscentSetting(event){
          createAscent({condition: this.condition})
           .then(result => {
               console.log(result);
                this.iscreateAcentDisable = result
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Sample JunoSign Email Template created successfully.',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
            })
             .catch(error => {
                console.log('Error >>> ' + JSON.stringify(error));
            });
    }
}
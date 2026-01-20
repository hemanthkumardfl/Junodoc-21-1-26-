import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSettingsRecord from '@salesforce/apex/JunoDocSettingsController.getSettingsRecord';
import runDeleteScheduleJobs from '@salesforce/apex/JunoDocSettingsController.runDeleteScheduleJobs';
import reminderScheduleJobs from '@salesforce/apex/JunoDocSettingsController.reminderScheduleJobs';
import createSetting from '@salesforce/apex/JunoDocSettingsController.createSetting';
import createSettings from '@salesforce/apex/JunoDocSettingsController.createSettings';
import getOrgWideEmails from '@salesforce/apex/JunoDocSettingsController.orgwideEmail';
import getrecorddetails from '@salesforce/apex/JunoDocSettingsController.getrecorddetails';
import updateScheduleDocTemplateSetting from '@salesforce/apex/JunoDocSettingsController.updateScheduleDocTemplateSetting';

export default class JunoSignGeneralSettings extends LightningElement {

    @track isScheduleActive = '';
    @track isReminderScheduleActive = 'false';
    @track toogleFieldValue = '';
    @track RemindertoogleFieldValue;
    @api cancel = '';
    @api success = '';
    @api url = '';
    @api EnablejunosignPostActions = false;
    @api Enablejunosign = false;
    @api Enablesignaturerejection = false;
    @api EnableattachmentList = false;
    @api EnableSenderBCC = false;
    @api communityurl = '';
    @api Orgurl = '';
    @api selectedSignValue = '';
    @api selectedDefaultFromEmail;
    @api fromEmailOptions = [];
    @track isReminderActive = false;
    @track reminderInput = '';
    @track reminderHours = '';
    @track reminderMinutes = '';
    @track reminderPeriod = 'AM';
     @track isLoading = false;
     @track EnableToSendEmail = false;
    @track EnableToSendEmailAllrecp = false;
     


    periodOptions = [
        { label: 'AM', value: 'AM' },
        { label: 'PM', value: 'PM' }
    ];

    handleHoursChange(event) {
        const value = event.target.value;
        const numValue = parseInt(value, 10);
        if (value === '' || (numValue >= 1 && numValue <= 12 && value.length <= 2)) {
            this.reminderHours = value;
            this.errorMessage = '';
        } else {
            this.errorMessage = 'Hours must be between 1 and 12.';
            event.target.value = this.reminderHours; // Revert to previous valid value
        }
    }

    handleMinutesChange(event) {
        const value = event.target.value;
        const numValue = parseInt(value, 10);
        if (value === '' || (numValue >= 0 && numValue <= 59 && value.length <= 2)) {
            this.reminderMinutes = value;
            this.errorMessage = '';
        } else {
            this.errorMessage = 'Minutes must be between 0 and 59.';
            event.target.value = this.reminderMinutes; // Revert to previous valid value
        }
    }

    handlePeriodChange(event) {
        this.reminderPeriod = event.detail.value;
        this.errorMessage = '';
    }

    connectedCallback() {
        this.selectedSignValue = 'Text';

        getOrgWideEmails()
            .then((result) => {
                if (result !== undefined && result != '') {
                    let opts = this.fromEmailOptions;
                    /* opts.push({
                        label: "None",
                        value: ""
                    });
                    for (var key in result) {
                        opts.push({
                            label: result[key] ,
                            value: key
                        });
                    } */
                    /*if(opts.length >= 2){
                        this.selectedDefaultFromEmail = opts[1]['value']
                    }*/
                    this.fromEmailOptions = result;
                    console.log('this.fromEmailOptions' + JSON.stringify(this.fromEmailOptions));
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
                    this.isScheduleActive = scheduleActive.JunoSignScheduleTrigger;
                    this.isReminderScheduleActive = scheduleActive.JunoSignReminderSchedule;
                    this.reminderInput = scheduleActive.JunoSignReminderScheduleTime;

                     if (this.reminderInput && this.reminderInput.trim() !== '') {
                        const [time, period] = this.reminderInput.split(' ');
                        const [hours, minutes] = time.split(':');
                        this.reminderHours = parseInt(hours, 10);
                        this.reminderMinutes = parseInt(minutes, 10);
                        this.reminderPeriod = period;
                    } else {
                        // Set default values if reminderInput is empty
                        this.reminderHours = '';
                        this.reminderMinutes = '';
                        this.reminderPeriod = 'AM';
                    }
                    if (this.isReminderScheduleActive == false) {
                        this.isReminderActive = true;
                    } else {
                        this.isReminderActive = false;
                    }


                    console.log('isScheduleActive--->' + this.isScheduleActive);
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

                    /* if (result.JunoDoc__Enable_Signature_Rejection__c != null)
                        this.Enablesignaturerejection = result.JunoDoc__Enable_Signature_Rejection__c;
                    console.log('Enablesignaturerejection-->' + this.Enablesignaturerejection); */


                    if (result.JunoDoc__Enable_JunoSign_Post_Actions__c != null)
                        this.EnablejunosignPostActions = result.JunoDoc__Enable_JunoSign_Post_Actions__c;
                    console.log('EnablejunosignPostActions-->' + this.EnablejunosignPostActions);


                    if (result.JunoDoc__Enable_Attachment_List_View__c != null)
                        this.EnableattachmentList = result.JunoDoc__Enable_Attachment_List_View__c;

                    if (result.JunoDoc__Enable_To_Send_Email__c != null)
                    this.EnableToSendEmail = result.JunoDoc__Enable_To_Send_Email__c; 
                    console.log('juno email field'+JSON.stringify(result));
                    /*  if (result.JunoDoc__Enable_To_Send_signed_document_To_All_Re__c != null)
                    this.EnableToSendEmailAllrecp = result.JunoDoc__Enable_To_Send_signed_document_To_All_Re__c;  
                    console.log('juno email field'+JSON.stringify(result))*/
                        

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
        if (event.target.label == 'Delete Cloned Templates') {
            this.isScheduleActive = event.target.checked;
            console.log('this.toogleFieldValue  ' + this.toogleFieldValue);
        }
    }


    /* handleClick() {
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
 
             if (!this.validateTime()) {
                 const evt = new ShowToastEvent({
                     title: 'Error',
                     message: this.errorMessage,
                     variant: 'error',
                     mode: 'dismissable'
                 });
                 this.dispatchEvent(evt);
             createSetting({
                 cancel: this.cancel,
                 success: this.success,
                 url: this.url,
                 communityurl: this.communityurl,
                 EnableJuno: this.Enablejunosign,
                 EnableSignature: this.Enablesignaturerejection,
                 EnableattachmentList: this.EnableattachmentList,
                 EnableSender: this.EnableSenderBCC,
                 PostAction: this.EnablejunosignPostActions,
                 OrgUrl: this.Orgurl,
                 signFormat: this.selectedSignValue,
                 defaultFromEmailAddress: this.selectedDefaultFromEmail
             })
                 .then(result => {
                     if (result === "success") {
                             if (this.validateTime()) {
                             const formattedMinutes = this.reminderMinutes < 10 ? `0${this.reminderMinutes}` : this.reminderMinutes;
                             this.reminderInput = `${this.reminderHours}:${formattedMinutes} ${this.reminderPeriod}`;
                             } else {
                             this.reminderInput = '';
                             }
                         reminderScheduleJobs({
                             toggleValue: this.RemindertoogleFieldValue,
                             reminder: this.reminderInput
                         })
                             .then(result => {
                                 if (result === "success") {
                                     console.log('Reminder scheduled successfully');
 
                                     runDeleteScheduleJobs({
                                         toggleValue: this.toogleFieldValue
                                     })
                                         .then(result => {
                                             if (result === "success") {
                                                 console.log('Scheduled jobs deleted successfully');
                                             }
                                         })
                                         .catch(error => {
                                             console.error('Error deleting scheduled jobs: ', error);
                                         });
 
                                     updateScheduleDocTemplateSetting({
                                         isActive: this.isScheduleActive
                                     })
                                         .then(() => {
                                             const evt = new ShowToastEvent({
                                                 title: 'Success',
                                                 message: 'Juno settings updated successfully',
                                                 variant: 'success',
                                                 mode: 'dismissable'
                                             });
                                             this.dispatchEvent(evt);
                                             window.location.reload();
                                         })
                                         .catch(err => {
                                             console.error('Error updating schedule setting: ', err);
                                         });
                                 }
                             })
                             .catch(error => {
                                 console.error('Error scheduling reminder jobs: ', error);
                             });
                     }
                 })
                 .catch(error => {
                     console.error('Error creating settings: ', error);
                 });
 
         }
 
 
 
     }*/

  /*  async handleClick() {
        debugger;
        this.isLoading = true; // Start loading state

        if (this.cancel.trim() === "" || this.success.trim() === "" || this.url.trim() === "") {
            let msg = "";
            if (this.success.trim() === "") {
                msg = 'Signature Success Message';
            }
            if (this.cancel.trim() === "") {
                msg = (msg !== "") ? msg + ', Signature Cancel Message' : 'Signature Cancel Message';
            }
            if (this.communityurl.trim() === "") {
                msg = (msg !== "") ? msg + ', Site URL' : 'Site URL';
            }
            if (this.Orgurl.trim() === "") {
                msg = (msg !== "") ? msg + ', Org URL' : 'Org URL';
            }
            msg += ' required';
            this.showToast('Error', msg, 'error');
        } else if (!this.validateTime()) {
            this.showToast('Error', this.errorMessage, 'error');
        } else {
            const formattedMinutes = this.reminderMinutes < 10 ? `0${this.reminderMinutes}` : this.reminderMinutes;
            this.reminderInput = `${this.reminderHours}:${formattedMinutes} ${this.reminderPeriod}`;

              if (!this.isReminderScheduleActive) {
                this.reminderInput = '';
            }

            try {
                const createResult = await createSetting({
                    cancel: this.cancel,
                    success: this.success,
                    url: this.url,
                    communityurl: this.communityurl,
                    EnableJuno: this.Enablejunosign,
                    EnableSignature: this.Enablesignaturerejection,
                    EnableattachmentList: this.EnableattachmentList,
                    EnableSender: this.EnableSenderBCC,
                    PostAction: this.EnablejunosignPostActions,
                    OrgUrl: this.Orgurl,
                    signFormat: this.selectedSignValue,
                    defaultFromEmailAddress: this.selectedDefaultFromEmail
                });

                if (createResult === "success") {
                    const reminderResult = await reminderScheduleJobs({ toggleValue: this.isReminderScheduleActive, reminder: this.reminderInput });
                    if (reminderResult === "success") {
                        console.log('Reminder scheduled successfully');
                        const deleteResult = await runDeleteScheduleJobs({
                            toggleValue: this.isScheduleActive
                        });
                        if (deleteResult === "success") {
                            console.log('Scheduled jobs deleted successfully');
                        }

                        await updateScheduleDocTemplateSetting({
                            isActive: this.isScheduleActive
                        });

                        this.showToast('Success', 'Juno settings updated successfully', 'success');
                        window.location.reload();
                    }
                }
            } catch (error) {
                console.error('Error in handleSave: ', error);
                this.showToast('Error', 'An error occurred while saving settings.', 'error');
            }
        }

        this.isLoading = false; // End loading state
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }*/


     async handleClick() {
        this.isLoading = true;

        if (this.cancel.trim() === "" || this.success.trim() === "" || this.url.trim() === "") {
            let msg = "";
            if (this.success.trim() === "") {
                msg = 'Signature Success Message';
            }
            if (this.cancel.trim() === "") {
                msg = (msg !== "") ? msg + ', Signature Cancel Message' : 'Signature Cancel Message';
            }
            if (this.communityurl.trim() === "") {
                msg = (msg !== "") ? msg + ', Site URL' : 'Site URL';
            }
            if (this.Orgurl.trim() === "") {
                msg = (msg !== "") ? msg + ', Org URL' : 'Org URL';
            }
            msg += ' required';
            this.showToast('Error', msg, 'error');
            this.isLoading = false;
            return;
        }

        // Handle reminder time based on toggle state
        if (!this.isReminderScheduleActive) {
            // If toggle is false, set reminderInput to empty and skip validation
            this.reminderInput = '';
        } else {
            console.clear();
            console.log( this.reminderMinutes +'______'+this.reminderHours);
            // If toggle is true, validate time
            this.reminderMinutes != null ? this.reminderMinutes : 0;
           // if (!this.reminderHours || (this.reminderMinutes != null && this.reminderMinutes != undefined && this.reminderMinutes != '')) {
            if (this.reminderHours === '' || this.reminderHours === null || this.reminderHours === undefined ||
                this.reminderMinutes === '' || this.reminderMinutes === null || this.reminderMinutes === undefined) {
                this.showToast('Error', 'Hours and Minutes are required when reminder is active.', 'error');
                this.isLoading = false;
                return;
            }
             if (!this.validateTime()) {
                this.showToast('Error', this.errorMessage, 'error');
                this.isLoading = false;
                return;
            }
            const formattedMinutes = this.reminderMinutes < 10 ? `0${this.reminderMinutes}` : this.reminderMinutes;
            this.reminderInput = `${this.reminderHours}:${formattedMinutes} ${this.reminderPeriod}`;
        }

        try {
            const createResult = await createSetting({
                cancel: this.cancel,
                success: this.success,
                url: this.url,
                communityurl: this.communityurl,
                EnableJuno: this.Enablejunosign,
                EnableSignature: this.Enablesignaturerejection,
                EnableattachmentList: this.EnableattachmentList,
                
                EnableSender: this.EnableSenderBCC,
                PostAction: this.EnablejunosignPostActions,
                OrgUrl: this.Orgurl,
                signFormat: this.selectedSignValue,
                defaultFromEmailAddress: this.selectedDefaultFromEmail,
                EnableToSendEmail: this.EnableToSendEmail,
                EnableToSendEmailAllrecp: this.EnableToSendEmailAllrecp
            });

            if (createResult === "success") {
                const reminderResult = await reminderScheduleJobs({
                    toggleValue: this.isReminderScheduleActive,
                    reminder: this.reminderInput
                });

                if (reminderResult === "success") {
                    console.log('Reminder scheduled successfully');
                    const deleteResult = await runDeleteScheduleJobs({
                        toggleValue: this.isScheduleActive
                    });
                    if (deleteResult === "success") {
                        console.log('Scheduled jobs deleted successfully');
                    }

                    await updateScheduleDocTemplateSetting({
                        isActive: this.isScheduleActive
                    });

                    this.showToast('Success', 'Juno settings updated successfully', 'success');
                    window.location.reload();
                }
            }
        } catch (error) {
            console.error('Error in handleSave: ', error);
            this.showToast('Error', 'An error occurred while saving settings.', 'error');
        }

        this.isLoading = false;
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }


    handleClicksave() {
        createSettings({
            EnableSender: this.EnableSenderBCC
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

    changesignatureHandler(event) {
        this.Enablesignaturerejection = event.detail.checked;
    }
    changeEnableattachmentListHandler(event) {
        this.EnableattachmentList  = event.detail.checked;
    }

    changeEnableToSendEmailHandler(event) {
    this.EnableToSendEmail = event.detail.checked;
    }

    changeEnableToSendEmailAllrecpHandler(event) {
    this.EnableToSendEmailAllrecp = event.detail.checked;
    }


    changeSenderBCCHandler(event) {
        this.EnableSenderBCC = event.detail.checked;
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
        this.selectedDefaultFromEmail = event.detail.value;
    }

    handleEnablejunosignPostActions(event) {
        this.EnablejunosignPostActions = event.target.checked;
    }

    handleReminderToggle(event) {
        this.isReminderScheduleActive = event.target.checked;
        console.log('this.isReminderScheduleActive  ' + this.isReminderScheduleActive);
        this.isReminderActive = !this.isReminderActive;
    }


    handleReminderInputChange(event) {
        this.reminderInput = event.target.value;
    }

    validateTime() {
        const hours = parseInt(this.reminderHours, 10);
        const minutes = parseInt(this.reminderMinutes, 10);
        if (isNaN(hours) || hours < 1 || hours > 12 || this.reminderHours.length > 2) {
            this.errorMessage = 'Hours must be between 1 and 12.';
            return false;
        }
        if (isNaN(minutes) || minutes < 0 || minutes > 59 || this.reminderMinutes.length > 2) {
            this.errorMessage = 'Minutes must be between 0 and 59.';
            return false;
        }
        this.errorMessage = '';
        return true;
    }

}
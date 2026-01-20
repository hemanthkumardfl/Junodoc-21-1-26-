import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPageTabs from '@salesforce/apex/JunoSignTemplatePreviewCntrl.createPageTabs';
import updatePageTabs from '@salesforce/apex/JunoSignTemplatePreviewCntrl.updatePageTabs';
import insertRecipientsAndRows from '@salesforce/apex/JunoPrepareandSend.insertRecipientsAndRows';

export default class JunoSignTemplatePreview extends LightningElement {receiverJson
    @api setReplyTo;
    @api selectedDocumentsForsend;
    @api receiver;
    @api recordId;
    @api isInPerson;
    @api selectedDocumentsForsendItem;
    @api uploadedFiles;
    @api showAttachmentSetting;
    @api insertedIds;
    @api selectedDocOption;

    @track recipients = [];
    @track elements = [];
    @track selectedRecipient = '0'; // Default to first recipient
    @track isDraggingNew = false;
    @track showSendDialog = false;
    @track dragElement = null;
    @track previewElements = [];
    @track previewLoaded = false;
    @track base64Data = '';
    @track inputType = 'text';
    
    dragState = {
        isDragging: false,
        elementId: null,
        pageIndex: null,
        startX: 0,
        startY: 0,
        offsetX: 0,
        offsetY: 0
    };

    colorOptions = ['blue', 'green', 'purple', 'orange', 'teal', 'pink', 'indigo'];

    constructor() {
        super();
        this.boundMouseMove = this.handleGlobalMouseMove.bind(this);
        this.boundMouseUp = this.handleGlobalMouseUp.bind(this);
        this.boundMessageHandler = this.handleVFMessage.bind(this);
    }

    // Getters
    get recipientsCount() {
        return this.recipients.length;
    }

    get elementsCount() {
        return this.elements.length;
    }

    get totalFieldsLabel() {
        return `Total Fields: ${this.elementsCount}`;
    }

    get totalRecipientsLabel() {
        return `Recipients: ${this.recipientsCount}`;
    }

    get selectedRecipientName() {
        const recipient = this.recipients.find(r => r.id === this.selectedRecipient);
        return recipient ? recipient.Name : 'No recipient selected';
    }

    get recipientOptions() {
        let recipients = this.receiver ? JSON.parse(JSON.stringify(this.receiver)) : [];
        recipients = recipients.filter(ele => {
            return ele.EmailType != 'CC';
        })
        this.recipients = recipients.map((recipient, index) => {
            return {
                ...recipient,
                color: this.colorOptions[index % this.colorOptions.length],
                order: index + 1,
                id: '' + index
            };
        });

        return recipients.map((recipient, index) => ({
            label: recipient.Name,
            value: '' + index
        }));
    }

    get vfPageUrl() {
        let docSelected = this.selectedDocumentsForsendItem ? this.selectedDocumentsForsendItem : this.selectedDocumentsForsend;
        return '/apex/JunoTemplatePreviewVF?recordId=' + this.recordId + '&templateId=' + docSelected + '&selectedOption=' + this.selectedDocOption + '&parentOrigin=' + window.location.origin;
    }

    // Lifecycle hooks
    connectedCallback() {
        window.addEventListener('message', this.boundMessageHandler);
        document.addEventListener('mousemove', this.boundMouseMove);
        document.addEventListener('mouseup', this.boundMouseUp);
    }

    disconnectedCallback() {
        window.removeEventListener('message', this.boundMessageHandler);
        document.removeEventListener('mousemove', this.boundMouseMove);
        document.removeEventListener('mouseup', this.boundMouseUp);
    }

    // Event handlers
    handleVFMessage(event) {
        if (event.data?.pageImages && event.data.actionfrom === 'junodoc') {
            let pageImages = event.data.pageImages;
            let previewElementsList = [];
            
            for (let i = 0; i < Object.keys(pageImages).length; i++) {
                let elementObj = {
                    id: 'imgId-' + i,
                    pageImages: pageImages[i],
                    droppedEles: []
                };
                previewElementsList.push(elementObj);
            }
            
            this.previewElements = previewElementsList;
            this.previewLoaded = true;
        }
    }

    handleRecipientChange(event) {
        this.selectedRecipient = event.detail.value;
    }

    handleDragStart(event) {
        if (!this.selectedRecipient) {
            this.showToast('Error', 'Please select a recipient first', 'error');
            event.preventDefault();
            return;
        }
        
        this.dragElement = event.target.dataset.elementType;
        this.isDraggingNew = true;
        event.dataTransfer.effectAllowed = 'move';
    }

    handleDragOver(event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'move';
    }

     handleDrop(event) {
        event.preventDefault();
        if (!this.dragElement || !this.selectedRecipient) return;
 
        const container = event.currentTarget;
        console.log(container)
        const containerWidth = container.offsetWidth;
        console.log('Parent Width >> '+containerWidth);
        const containerHeight = container.offsetHeight;
        console.log('Parent Height >> '+containerHeight);
        const rect = container.getBoundingClientRect();
        const x = Math.round(event.clientX - rect.left);
        const y = Math.round(event.clientY - rect.top);
        const pgnoValue = Number(container.dataset.pgno);
 
        const newElement = {
            id: Date.now().toString(),
            type: this.dragElement,
            fieldType: this.dragElement === 'checkbox' ? 'checkbox' : 'text',
            x: x,
            y: y,
            pageHeight: containerHeight,
            pageWidth: containerWidth,
            xpercent: (x/containerWidth)*100,
            ypercent: (y/containerHeight)*100,
            width: this.dragElement === 'signature' ? 200 : 150,
            height: this.dragElement === 'signature' ? 45 : 40,
            recipientId: this.selectedRecipient,
            label: `${this.dragElement.charAt(0).toUpperCase() + this.dragElement.slice(1)} Field`,
            required: true
        };
 
        console.log('newElement >> '+JSON.stringify(newElement));
 
        let previewElements = JSON.parse(JSON.stringify(this.previewElements));
        let eleWithMeta = this.getElementsWithMeta(newElement);
        previewElements[pgnoValue].droppedEles.push(eleWithMeta);
        this.previewElements = [...previewElements];
       
        this.isDraggingNew = false;
        this.dragElement = null;
    }

    handleElementMouseDown(event) {
        event.preventDefault();
        event.stopPropagation();

        const elementId = event.currentTarget.dataset.elementId;
        const pageIndex = Number(event.target.closest('[data-pgno]').dataset.pgno);

        const allDropped = this.previewElements[pageIndex].droppedEles;
        const element = allDropped.find(el => el.id === elementId);
        if (!element) return;

        const container = this.template.querySelector(`[data-pgno="${pageIndex}"]`);
        const rect = container.getBoundingClientRect();

        const offsetX = event.clientX - rect.left - element.x;
        const offsetY = event.clientY - rect.top - element.y;

        this.dragState = {
            isDragging: true,
            elementId,
            pageIndex,
            startX: event.clientX,
            startY: event.clientY,
            offsetX,
            offsetY
        };
    }

    handleGlobalMouseMove(event) {
        if (!this.dragState.isDragging) return;

        const pageIndex = this.dragState.pageIndex;
        let clonedPreview = JSON.parse(JSON.stringify(this.previewElements));

        const container = this.template.querySelector(`[data-pgno="${pageIndex}"]`);
        const rect = container.getBoundingClientRect();

        const elementIndex = clonedPreview[pageIndex].droppedEles.findIndex(
            el => el.id === this.dragState.elementId
        );

        if (elementIndex === -1) return;

        const draggedElement = clonedPreview[pageIndex].droppedEles[elementIndex];

        const newX = Math.max(0, Math.min(event.clientX - rect.left - this.dragState.offsetX, rect.width - draggedElement.width));
        const newY = Math.max(0, Math.min(event.clientY - rect.top - this.dragState.offsetY, rect.height - draggedElement.height));

        // Snap to grid
        const snappedX = Math.round(newX / 10) * 10;
        const snappedY = Math.round(newY / 10) * 10;

        // Update element position
        draggedElement.x = snappedX;
        draggedElement.y = snappedY;
        draggedElement.elementStyle = `left: ${snappedX}px; top: ${snappedY}px; width: ${draggedElement.width}px; height: ${draggedElement.height}px;`;

        clonedPreview[pageIndex].droppedEles[elementIndex] = draggedElement;
        this.previewElements = [...clonedPreview];
    }

    handleGlobalMouseUp() {
        this.dragState = {
            isDragging: false,
            elementId: null,
            pageIndex: null,
            startX: 0,
            startY: 0,
            offsetX: 0,
            offsetY: 0
        };
    }

    removeElement(event) {
        event.stopPropagation();
        const elementId = event.target.dataset.elementId;
        
        let previewElements = JSON.parse(JSON.stringify(this.previewElements));
        for (let i = 0; i < previewElements.length; i++) {
            previewElements[i].droppedEles = previewElements[i].droppedEles.filter(el => el.id !== elementId);
        }
        this.previewElements = [...previewElements];
    }

    // Helper methods
    getElementsWithMeta(drpEle) {
        const recipient = this.recipients.find(r => r.id === drpEle.recipientId);
        const isBeingDragged = this.dragState.isDragging && this.dragState.elementId === drpEle.id;
        
        return {
            ...drpEle,
            recipientName: recipient ? recipient.Name : '',
            recipientOrder: recipient ? recipient.order : 1,
            recipientColor: recipient ? recipient.color : 'blue',
            elementClass: `placed-element ${recipient ? recipient.color : 'blue'} ${isBeingDragged ? 'dragging' : ''}`,
            elementStyle: `left: ${drpEle.x}px; top: ${drpEle.y}px; width: ${drpEle.width}px; height: ${drpEle.height}px;`,
            iconName: this.getElementIcon(drpEle.type),
            typeLabel: drpEle.type.charAt(0).toUpperCase() + drpEle.type.slice(1)
        };
    }

    getElementIcon(type) {
        switch (type) {
            case 'signature': return 'utility:signature';
            case 'date': return 'utility:date_input';
            case 'text': return 'utility:text';
            default: return 'utility:text';
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }

    // Main send method
    @api
    handleSendForSignatures() {
        if (!this.selectedRecipient) {
            this.showToast('Error', 'Please select a recipient before sending', 'error');
            return;
        }
        debugger;
        // Validate and prepare dropped elements
        const allDropped = [];
        this.previewElements.forEach((page, index) => {
            if (page.droppedEles && Array.isArray(page.droppedEles)) {
                page.droppedEles.forEach(ele => {
                    if (ele && ele.type) {
                        allDropped.push({
                            droptype: ele.type,
                           // fieldType : ele.fieldType,
                         /* x: Math.round(Number(ele.x) || 0),
                            y: Math.round(Number(ele.y) || 0), */
                            // x: Number(ele.xpercent?.toFixed(2)),
                            // y: Number(ele.ypercent?.toFixed(2)),
                            x: ele.x,
                            y: ele.y,
                            pageHeight: ele.pageHeight,
                            pageWidth: ele.pageWidth,
                            pgno: Number(index) || 0,
                            typeLabel: ele.typeLabel || ele.type,
                            recipientOrder: Math.round(Number(ele.recipientOrder) || 1)
                        });
                    }
                });
            }
        });

        console.log('allDropped >> '+JSON.stringify(allDropped));

        if (allDropped.length === 0) {
            this.showToast('Warning', 'No signature elements to save', 'warning');
            return;
        }

        this.showSendDialog = true;
        debugger;

        createPageTabs({ droppedElementsJson: JSON.stringify(allDropped) })
            .then(resultIds => {
                console.log('Successfully saved', resultIds.length, 'elements');
                //alert('JSON.stringify(this.receiver>>>>>>>>>>>>>>>>>>>>>>)'+JSON.stringify(this.receiver));
                console.log('JSON.stringifythis.receiver>>>>>>>>>>>>>>>>>>>>>>'+JSON.stringify(this.receiver));
                if (resultIds.length === 0) {
                    throw new Error('No elements were saved successfully');
                }
 
                const docList = this.selectedDocumentsForsend?.length ? JSON.stringify(this.selectedDocumentsForsend) : '';
                const files = this.uploadedFiles ? JSON.stringify(this.uploadedFiles) : '';
                const receiverJson = JSON.stringify(this.receiver);
                const isInPerson = this.isInPerson || false;
 
                return insertRecipientsAndRows({
                    receiverJson: receiverJson,
                    recId: this.recordId,
                    docList: docList,
                    Files: files,
                    SetReplyTo: this.setReplyTo,
                    showattachment: this.showAttachmentSetting,
                    isInPersons: isInPerson,
                    recordId: this.recordId,
                    docidList: this.selectedDocumentsForsendItem
                }).then(response => {
                    return updatePageTabs({
                        pageTabIdList: resultIds,
                        transactionID: response.TransactionId
                    });
                });
            })
            .then(() => {
                this.showSendDialog = false;
                this.showToast('Success', 'Document sent to all recipients for signatures!', 'success');
                this.dispatchEvent(new CustomEvent('sendsuccess'));
               
                setTimeout(() => {
                    window.location.href = '/' + this.recordId;
                }, 1000);
            })
            .catch(error => {
                this.showSendDialog = false;
                console.error('Error details:', error);
                this.showToast('Error',
                    'Failed to save signature elements: ' +
                    (error.body?.message || error.message || 'Unknown error'),
                    'error'
                );
            });
 

        
    }



   
}
import { LightningElement,api,track,wire } from 'lwc';
import getAllTransactions from '@salesforce/apex/junoSignTransactionsController.getAllTransactions';
export default class JunoSignTransactionsLWC extends LightningElement {
    @api recordId;
    @track TransactionsList = [];
    @track RecipientsList = [];
    connectedCallback(){
        //alert(this.recordId);
       /* getAllTransactions({recordId:this.recordId})
        .then(result => {
           /*alert(JSON.stringify(result));
           for(var i=0;i<result.length;i++){
            this.TransactionsList.push(result[i].TransactionRec);
            this.RecipientsList.push(result[i].allRecipients);
           }
           //var records = this.TransactionsList;
          // this.TransactionsList = result.allRecipients;
           alert(JSON.stringify(this.RecipientsList));
           var ObjData = JSON.parse(JSON.stringify(this.TransactionsList));
           ObjData.forEach(Record => {
            Record.recordLink = "/" + Record.Id;  
            Record.Name = Record.Name;
           
            });
            
        
            this.TransactionsList = ObjData;
           console.log(JSON.stringify(this.TransactionsList));*/
         /*  for (let key in result) {
            this.TransactionsList.push({value:result[key], key:'/'+key});
         }
         var ObjData = JSON.parse(JSON.stringify(this.TransactionsList));
         ObjData.forEach(Record => {
          Record.recordLink = "/" + Record.Id;  
          Record.Name = Record.Name;
         
          });
          
      
          this.TransactionsList = ObjData;
        })
        .catch(error => {
            this.error = error;
        });*/
    }
    handleToggleSection(event) {
        console.log( 'Selected Sections ' + event.detail.openSections );
    }
    @track error;
    @wire(getAllTransactions,{recordId: '$recordId'})
    wiredTransactions({ error, data }) {
        if (data) {
            //alert(JSON.stringify(data));
            this.TransactionsList = data;
            this.error = undefined;
            var ObjData = JSON.parse(JSON.stringify(data));
           
            ObjData.forEach(Record => {
             Record.recordLink = "/" + Record.transactionRecord.Id;  
             Record.Name = Record.transactionRecord.Name;
             Record.FinalLink = "/"+Record.transactionRecord.JunoDoc__Final_Document_Id__c;
             Record.originalLink = "/"+Record.transactionRecord.JunoDoc__Original_File_Id__c;
             var i=0;
             Record.recipientList.forEach(Rec => {
                 
             Rec.link = "/"+Rec.Id;
             Rec.Signlink = "/"+Rec.JunoDoc__Signed_File_Id__c;
             Rec.RowNumber = i+1;
             i=i+1;
             });
             });
             this.TransactionsList = ObjData;
        } else if (error) {
            this.error = error;
            this.TransactionsList = undefined;
        }
    }
    @track Child1TabClickCount=0;
    @track showChild1Info=false;
    handleChild1InfoOnclick(event){
        this.Child1TabClickCount=this.Child1TabClickCount+1;
       // alert(this.Child1TabClickCount%2);
        for(var i=0;i<this.TransactionsList.length;i++){
            if(event.target != undefined){
                if(i==event.target.accessKey){
                    if(this.Child1TabClickCount%2==0){
                        this.TransactionsList[i].isOpen = true;
                        //this.showChild1Info=true;
                    }else{
                        this.TransactionsList[i].isOpen = false;
                        //this.showChild1Info=false;
                    }
                }
            }
        }
       
    }
}
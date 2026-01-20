({
    search : function(component, event, helper) {
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        ul = document.getElementById("myUL");
        li = ul.getElementsByTagName("li");
        for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("span")[2];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }
    },
    
     openSendPDFModelHelper : function(component,event,helper){
        var sObjName = component.get("v.inputValue");
        var action = component.get("c.getEmailTemplates");
        action.setParams({
            "sObjName" : sObjName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var InnerResult = response.getReturnValue();
                component.set("v.JunoDocPDFTemplatesList",InnerResult.JunoDocPDFTemplatesList);

         var obj = component.get("v.inputValue");
        var action = component.get("c.getrecorddetails"); 
        action.setParams({
            "selectedobject" : obj
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
                //(state);
                var InnerResult = response.getReturnValue();
                console.log("Query result"+JSON.stringify(InnerResult));
                if(InnerResult!=null && InnerResult !=undefined){                    
                    component.set("v.DocTemplates",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                    component.set("v.DocTemplates",InnerResult.junodoc[0].JunoDoc__Junodoc_Doc_Template__c);
                    component.set("v.accList",InnerResult.junoEmailList);
                  	component.set("v.ccaccList",InnerResult.junoEmailList);
                }
                else if(InnerResult==null || InnerResult==''){

                }
                component.set("v.variable1",true);
            }
              

        });
        $A.enqueueAction(action);
            }
        });
        $A.enqueueAction(action); 
        
               
    }
	,
       
     MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        //alert(file.name);
        //alert(file.type);
        //alert(getchunk);
        var action = component.get("c.saveChunks");
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    
                   // var elmnt = document.getElementById("pageTop");
                   // elmnt.scrollIntoView();
                    component.set("v.message", 'PreQual settings created successfully.');
                    component.set("v.isText",false);
                    component.set("v.isSuccess", true);
                    //component.set("v.Spinner", false);
                    window.setTimeout(
                        $A.getCallback(function() {
                    component.set("v.isSuccess", false);
                }), 1500
            );
                    component.set("v.showLoadingSpinner", false);
                    /*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    "title": "Success!",
                    "message": "Checklist settings created successfully.",
                    "type":"success"
                });
                toastEvent.fire();*/
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }
    

})
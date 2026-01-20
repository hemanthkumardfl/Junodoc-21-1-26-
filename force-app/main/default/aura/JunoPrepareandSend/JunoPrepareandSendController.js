({
    doInit: function(component, event, helper) {
       debugger
        var doc = JSON.parse(JSON.stringify(component.get("v.selectedDocumentsForsend")))
        var docList = component.get("v.selectedDocumentsForsend").toString();
        var recId = component.get("v.recordId");
        var Files = JSON.stringify(component.get("v.UploadedFiles"));
        let fileContent = component.get("v.UploadedFiles");
        let showattachment = component.get("v.showAttachmentSetting")
       
        console.log('Test >>> '+JSON.stringify(component.get("v.receiver")));
        let SetReplyTo =component.get("v.setReplyTo");
         var receiverJson = JSON.stringify(component.get("v.receiver"));
        var action = component.get("c.insertRecipientsAndRows");
         var docidList = component.get("v.selectedDocumentsForsendItem")
        var isInPerson ='';
        if(!component.get("v.isInPerson")){
        isInPerson = false;
        }else{
        isInPerson = component.get("v.isInPerson");
        }
        
        let recordId = component.get("v.recordId");
        let receiverList= component.get("v.receiverstring")
        var responseData;
        action.setParams({ receiverJson: receiverJson, recId: recId , docList: docList ,Files:Files, SetReplyTo :SetReplyTo, showattachment:showattachment, isInPersons : isInPerson ,recordId :recordId ,docidList : docidList});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                responseData = response.getReturnValue();
                component.set("v.responseData", responseData);
                component.set("v.receiverstring",JSON.stringify(component.get("v.receiver")))
                var insertedIds = component.get("v.insertedIds");
                var serializedData = JSON.stringify(insertedIds);
                location.href= '/'+recordId;
               // var url = '/apex/JunoDoc__JunoPrepareDocVf?TransactionIds='+responseData.TransactionId
                // var url = '/apex/JunoDoc__JunoPrepareDocVf?docidList='+ component.get("v.selectedDocumentsForsendItem")+'&recordId='+component.get("v.recordId")+'&receiverList='+component.get("v.receiverstring")+'&isInPerson='+component.get("v.isInPerson")+'&docList='+docList+'&FileList='+Files+'&showAttachmentSetting='+showAttachmentSetting+'&SetReplyTo='+component.get("v.setReplyTo")+'&insertedIds='+serializedData
                //console.log(url);
        		//component.set("v.url",url)
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.error('Error:', errors[0].message);
                }
            }
        });
        
        $A.enqueueAction(action);
        
       
    },
    
    handleAfterLoad : function(component, event, helper) {
        var action = component.get("c.getDocument")
        var docList = JSON.parse(JSON.stringify(component.get("v.selectedDocumentsForsend")))
        action.setParams({
            docidList : docList,
        });
        action.setCallback(this, function(response) {
            var pdfObj
            var state = response.getState();
            var result = response.getReturnValue();
            console.log(result)
            var docBody = result.contentBody+result.contentsecondBody;
            document.getElementById('pdfViewer').children[0].src = docBody;
            var file = new File( [docBody], { type: 'application/pdf' } )
            // document.getElementById('pdfViewer').children[0].src = URL.createObjectURL( file )
            
            /*
             *  var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url":"/apex/JunoPrepareDocVf"
            });
            urlEvent.fire();console.log(document.getElementById('Nav_fields'))
            if(!document.getElementById('Nav_fields').claassList.contains('draggables')) {
                document.getElementById('Nav_fields').claassList.add('draggables');
                //draggableFields();
                draggableFieldsClone();
            }
            // var file = e.target.files[0]
            var fileReader = new FileReader();  
            fileReader.onload = function() {
                function renderPage(page) {
                    var scale = 1.5;
                    var viewport = page.getViewport({scale: scale});
                    var canvasContainer = document.getElementById("drop");
                    var wrapper = document.getElementById("pdfViewer");
                    wrapper.className = "canvas-wrapper";
                    var canvas = document.createElement('canvas');
                    var pageDiv = document.createElement('div')
                    pageDiv.setAttribute("id",'divPageNo_'+wrapper.children.length)
                    pageDiv.setAttribute("class","drop ui-droppable")
                    pageDiv.setAttribute("style","height : auto;overflow:unset;")
                    canvas.setAttribute("id",'pageNo_'+wrapper.children.length);
                    var ctx = canvas.getContext('2d');
                    
                    var renderContext = {
                        canvasContext: ctx,
                        viewport: viewport
                    };
                    
                    canvas.height = viewport.height;
                    canvas.width = viewport.width;
                    pageDiv.appendChild(canvas);
                    // wrapper.appendChild(canvas)
                    wrapper.appendChild(pageDiv)
                    canvasContainer.appendChild(wrapper);
                    page.render(renderContext);
                    droppableClone()
                }
                
                //
                function renderPages(pdfDoc) {
                    for(var num = 1; num <= pdfDoc.numPages; num++)
                        pdfDoc.getPage(num).then(renderPage);
                }
                
                var pdfData = convertDataURIToBinary(docBody);//new Uint8Array(this.result);
                // Using DocumentInitParameters object to load binary data.
                var loadingTask = pdfjsLib.getDocument({data: pdfData});
                loadingTask.promise.then(function(pdf) {
                    console.log('PDF loaded');
                    var total = pdf._pdfInfo.numPages;
                    // Fetch the first page
                    var pageNumber = 1;
                    document.getElementById('pdfViewer').innerHTML = ''
                    // $("#pdfViewer").empty()
                    pdfObj = pdf
                    renderPages(pdf);
                    
                    
                }, function (reason) {
                    // PDF loading error
                    console.error(reason);
                });
            };
            fileReader.readAsArrayBuffer(file);*/
            /*else{
               var reader  = new FileReader();
                reader.readAsDataURL(file);
                reader.onloadend = function (e) {         
                    var image = new Image();        
                    image.src = e.target.result;     
                    image.onload = function(ev) {   
                        var canvas = document.getElementById('pdfViewer');    
                        canvas.width = image.width;    
                        canvas.height = image.height;       
                        var ctx = canvas.getContext('2d');  
                        ctx.drawImage(image,0,0);
                    }      
                } 
            }*/      
            /*if (docBody.slice(5, 20) == "application/pdf") {
                
            }*/
            });
        $A.enqueueAction(action);
    },
    handle13AfterLoad:  function(component, event, helper) {
        component.set("v.jQueryUI13Loaded",true)
        if(component.get("v.jQuery12Loaded") && component.get("v.pdfJsLoaded")){
            component.set("v.loadedJs",true)
        }
    },
    handl12eAfterLoad:  function(component, event, helper) {
        component.set("v.jQuery12Loaded",true)
        if(component.get("v.jQueryUI13Loaded") && component.get("v.pdfJsLoaded")){
            component.set("v.loadedJs",true)
        }
    },
    handlePdfAfterLoad:  function(component, event, helper) {
        component.set("v.pdfJsLoaded",true)
        if(component.get("v.jQuery12Loaded") && component.get("v.jQueryUI13Loaded")){
            component.set("v.loadedJs",true)
        }
    },
})
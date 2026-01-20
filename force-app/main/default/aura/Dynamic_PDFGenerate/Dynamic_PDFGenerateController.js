({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        //alert("pageRef---->"+pageRef);
        if(pageRef!==undefined && pageRef!==null && pageRef.state!=null)
        {
            component.set("v.recId", pageRef.state.c__recordId);
            component.set("v.DocTemplateIds", pageRef.state.c__AvailableDocTemplates);
            var AvailableDocTemplates =pageRef.state.c__AvailableDocTemplates;
            var recId = pageRef.state.c__recordId;
            
         //   if(AvailableDocTemplates != '' && AvailableDocTemplates != null && AvailableDocTemplates != undefined){
             /*   var action2 = component.get("c.getAvailDocTemps");
                action2.setParams({
                    'recordId' : recId,
                    'DocIds' : AvailableDocTemplates
                }); 
                action2.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        var InnerResult = response.getReturnValue();
                        component.set("v.DocTemplateIdsList",InnerResult.AvailableDocTemplatesList);*/
                       var pageReference = {
                            type: 'standard__component',
                            attributes: {
                                componentName: "JunoDoc__LGT_Dynamic_GeneratePDFCMP"
                            },
                            state: {
                                c__recordId: component.get("v.recId"),
                                c__AvailableDocList : AvailableDocTemplates
                                //c__isGeneratedFrom : true
                            }
                        };
                        const navService = component.find('navService');
                        const generatedUrl = navService.generateUrl(pageReference);
                        //redirection
                        $A.get("e.force:closeQuickAction").fire();
                        component.set("v.pageReference", pageReference);
                        const device = $A.get("$Browser.formFactor");
                        const handleUrl = function(url) {
                            if (device.toLowerCase() === 'phone') {
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": url
                                });
                                urlEvent.fire(); 
                            } else {
                                window.open(url,'_self');
                            }
                        };
                        const handleError = function(error) {
                            console.log(error);
                        };
                        generatedUrl.then(handleUrl, handleError);
                        
            /*
            
                  /*  }
                });
                $A.enqueueAction(action2);*/
        //    }
            
            
            
        }
    }
})
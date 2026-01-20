({
    afterScriptsLoaded : function(component, event, helper) {
        window.setTimeout(()=>{
                    helper.download(component, helper);
                },2000)
        component.set("v.ready", true);
        helper.createChart(component, helper);
    },
    
	 doInit : function(component, event, helper) {
        helper.getData(component,helper);
        
         
    },
    
    downloadChart : function(component, event, helper) {
        helper.download(component, helper)
    }
})
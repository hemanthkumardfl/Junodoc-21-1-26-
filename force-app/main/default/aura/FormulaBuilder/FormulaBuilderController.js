({
    doInit :  function(component, event, helper){
        console.log('ObjectAPIName >>>> '+component.get("v.ObjectAPIName"));
        console.log('parents >>> '+component.get("v.parents"));
       // helper.GetObjLabel(component, event, helper);
        helper.GetObjectFields(component, event, helper);
    },
    
    GetMainObjectFields : function(component, event, helper) {
        helper.GetObjectFields(component, event, helper);
    },
    
    GetFirstLevelSelectedField : function(component, event, helper){
        //alert('--selected Field--'+event.target.value+'---id--'+event.target.text);
        //alert(event.target.value+'--contains--');
        var FieldDetails = event.target.value;
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('@@@')[1];
        var ApiName = FieldDetails.split('@@@')[0];
        var LabelName = FieldDetails.split('@@@')[2];
        component.set('v.FirstLevField',ApiName);
        if(LabelName.includes('>')){
            helper.GetFirstLevLookUpObjectFields(component, event, helper, LokUpApiName);
        }else{
            helper.GetFirstLevelFieldDetails(component, event, helper, ObjName, FieldDetails);
        }
    },
    
    GetSecLevelSelectedField : function(component, event, helper){
        //alert('--selected Field--'+event.target.value+'---id--'+event.target.text);
        //alert('--contains--'+event.target.text.includes('>'));
        var FieldDetails = event.target.value;
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('@@@')[1];
        var ApiName = FieldDetails.split('@@@')[0];
        var FirstField = component.get('v.FirstLevField');
        var LabelName = FieldDetails.split('@@@')[2];
        component.set('v.SecondLevField',ApiName);
        if(LabelName.includes('>')){
            helper.GetSecLevLookUpObjectFields(component, event, helper, LokUpApiName);
        }else{
            helper.GetSecLevelFieldDetails(component, event, helper, ObjName, FirstField, FieldDetails);
        }
    },
    
    GetThirdLevelSelectedField : function(component, event, helper){
        //alert('--selected Field--'+event.target.value+'---id--'+event.target.text);
        //alert('--contains--'+event.target.text.includes('>'));
        var FieldDetails = event.target.value;
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('@@@')[1];
        var ApiName = FieldDetails.split('@@@')[0];
        var FirstField = component.get('v.FirstLevField');
        var SecondField = component.get('v.SecondLevField');
        var LabelName = FieldDetails.split('@@@')[2];
        component.set('v.ThirdLevField',ApiName);
        if(LabelName.includes('>')){
            helper.GetThirdLevLookUpObjectFields(component, event, helper, LokUpApiName);
        }
    	else{
            helper.GetThirdLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, FieldDetails);
        }
    },
    
    GetFinalLevelSelectedField : function(component, event, helper){
        //alert('--selected Field--'+event.target.value+'---id--'+event.target.text);
        //alert('--contains--'+event.target.text.includes('>'));
        var FieldDetails = event.target.value;
        var ObjName = component.get('v.ObjectAPIName');
        var LokUpApiName = FieldDetails.split('@@@')[1];
        var ApiName = FieldDetails.split('@@@')[0];
        var FirstField = component.get('v.FirstLevField');
        var SecondField = component.get('v.SecondLevField');
        var ThirdField = component.get('v.ThirdLevField');
        //component.set('v.FinalLevField',ApiName);
        /*if(event.target.text.includes('>')){
            helper.GetFinalLevLookUpObjectFields(component, event, helper, LokUpApiName);
        }else{*/
        helper.GetFinalLevelFieldDetails(component, event, helper, ObjName, FirstField, SecondField, ThirdField, FieldDetails);
        //}
    },
    
    copyHardcoreTextFirst : function(component, event, helper) {
        // get HTML hardcore value using aura:id
        var textForCopy = component.find('pId1').getElement().innerHTML;
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    copyHardcoreTextSecond : function(component, event, helper) {
        // get HTML hardcore value using aura:id
        var textForCopy = component.find('pId2').getElement().innerHTML;
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    copyHardcoreTextThird : function(component, event, helper) {
        // get HTML hardcore value using aura:id
        var textForCopy = component.find('pId3').getElement().innerHTML;
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    copyHardcoreTextFInal : function(component, event, helper) {
        // get HTML hardcore value using aura:id
        var textForCopy = component.find('pId4').getElement().innerHTML;
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
})
public without sharing class EmailTemplateFullpage_AC {
    public string Body{get;set;}
    public EmailTemplateFullpage_AC(){
        string EmailTemplateId = ApexPages.currentPage().getParameters().get('EmailTemplateId');
        string recordId = ApexPages.currentPage().getParameters().get('recordId');
        string SObjectName = ApexPages.currentPage().getParameters().get('SObjectName');
         PageReference ref = new PageReference(Dynamic_GeneratePDF_Controller.getJunodocUrl()+'/EmailTemplate_VF?SObjectName='+SObjectName+'&EmailTemplateId='+EmailTemplateId+'&recordId='+recordId);
                
                if(!Test.isRunningTest()){
                    Body  = string.valueof( ref.getcontent().tostring().trim() + '');   
                }
                else{
                    Body = '<div>Test</div>';
                }
                system.debug(Body + '*********Body');
                Body  = Body.unescapeHtml4(); 
                Body  = Body.replace('<div style="font-size: 0px;">"</div>','');
    }
}
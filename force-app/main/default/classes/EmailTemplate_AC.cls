global without sharing class EmailTemplate_AC {
    global string output{get;set;}
    global string Body{get;set;}
    global String getPrintView()
    {
        return
        '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
        }
    global EmailTemplate_AC(){
        string EmailTemplateId = ApexPages.currentPage().getParameters().get('EmailTemplateId');
        string recordId = ApexPages.currentPage().getParameters().get('recordId');
        string SObjectName = ApexPages.currentPage().getParameters().get('SObjectName');
        MergeFieldsController md = new MergeFieldsController();
        md.SObjectName = SObjectName;
        md.recordId = recordId;
        Email_Template__c DocTemplates = [select id,
                                            Parent_Object__c,
                                            Parent_Fields__c 
                                            From Email_Template__c
                                            where id =: EmailTemplateId];
            Body = '';
            integer itemcount= database.countQuery('select count() from Email_Template_Item__c Where Email_Template__c=:EmailTemplateId limit 1');
            if(itemcount>0){                
                /*list<Email_Template_Item__c> eTemplateItemRec = Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplate(recordId, EmailTemplateId);                
                if(eTemplateItemRec.size() > 0){
                    for(Email_Template_Item__c Emp : eTemplateItemRec){
                        if(Emp.Template_Body__c!=null){ 
                            Body += md.m_MergeData(Emp.Template_Body__c);
                        }
                    }
                }
                */
                 Body = Dynamic_GeneratePDF_Controller.getJunoDocEmailTemplates(recordId, EmailTemplateId); 
                
                if(Body != null && Body != ''){
                    Body = md.m_MergeData(Body);    
                }
                Body = Body.replace('data-title="Td Element" style="','data-title="Td Element" style="font-family:unset;'); 
                Body = Body.replace('<td>','<td style="font-family:unset;">'); 
                Body = '<style>td{font-family:unset;}</style><div class="main-section"><table style="position: relative;" ><tr><td>'+Body+'</td></tr></table></div>';
                system.debug('*********Body' + Body );                             
            }           
       
    }
    
    global Component.Apex.OutputText getEmailBody() {
        Component.Apex.OutputText head1 = new Component.Apex.OutputText();        
        head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',\'\')}"</div>'+Body ;   
        system.debug('*********Body'+ head1.expressions.value); 
        return head1;
    }
}
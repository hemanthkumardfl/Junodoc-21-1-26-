global class DownloadPDF_AC {
    transient global string output{get;set;}
    transient global string output2{get;set;}
    transient global string output3{get;set;}
    transient global List<String> pageContents{get;set;}
    global string Headermargin{get;set;}
    global string Footermargin{get;set;}
    global string HeaderFirstmargin{get;set;}
    global string FooterFirstmargin{get;set;}   
    global string height{get;set;}
    global string heightsecond{get;set;}  
    global String getPrintView(){
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
     global DownloadPDF_AC(){          
        Headermargin = '0.1in';
        Footermargin = '0.1in';
        FooterFirstmargin = '0.01in';
        HeaderFirstmargin = '0.01in';
        
        System.debug((ApexPages.currentPage().getParameters().get('DocTemplateId')));
        Id DocTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId')); 
        
        string TemplateID = '';
       
        if(DocTemplateId!=null){ // selected Available Template Id
            TemplateID = DocTemplateId;
        }
        
        
        
        Doc_Template__c DocTemplates = [select id,
                                        Page_Size__c,
                                        PDF_Name__c,
                                        Parent_Object__c,
                                        Doc_Template_Header__c,
                                        Doc_Template_Header__r.Master_Object_Fields__c,
                                        Doc_Template_Header__r.header_body__c,
                                        Doc_Template_Header__r.Master_object__c,
                                        Doc_Template_Footer__c,
                                        Doc_Template_Footer__r.Master_Object_Fields__c,
                                        Doc_Template_Footer__r.Footer_body__c,
                                        Doc_Template_Footer__r.Master_object__c,
                                        Parent_Fields__c 
                                        from Doc_Template__c 
                                        where id =: TemplateID];
        
        String query ='';
        String SobjectApiName = DocTemplates.Parent_Object__c;
        string fieldNames = '';
        string Title = 'PreviewPDF';
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        if(DocTemplates.Page_Size__c == 'A3'){
            height = '9.3in 12.54in';
        }
        else if(DocTemplates.Page_Size__c == 'A4 Letter'){
            height = '7in 8.9in';
        }
        else if(DocTemplates.Page_Size__c == 'A4 Legal'){
            height = '7in 11.0in';
        }
        else if(DocTemplates.Page_Size__c == 'A5'){
            height = '5in 6.9in ';
        }
        else if(DocTemplates.Page_Size__c == 'Label 4x6'){
            height = '3.7in 5.35in';
        }
        else if(DocTemplates.Page_Size__c == 'Landscape'){
            height = '11in 8.5in';
        }
        else{
            height = '9in 11.5in';
        }
        if(DocTemplates.Doc_Template_Header__c != null){
            if(DocTemplates.Doc_Template_Header__r.header_body__c != null){
                Headermargin = '1.1in';
                HeaderFirstmargin = '1.4in';
                
                if(DocTemplates.Page_Size__c == 'A3'){
                    height = '9.3in 13.65in';
                }
                else if(DocTemplates.Page_Size__c == 'A4 Letter'){
                    height = '7in 10.4in';
                }
                else if(DocTemplates.Page_Size__c == 'A4 Legal'){
                    height = '7in 12.15in';
                }
                else if(DocTemplates.Page_Size__c == 'A5'){
                    height = '5in 8.4in ';
                }
                else if(DocTemplates.Page_Size__c == 'Label 4x6'){
                    height = '3.7in 6.49in';
                }
                else if(DocTemplates.Page_Size__c == 'Landscape'){
                    height = '11in 10in';
                }
                else{
                    height = '9in 12.65in';
                }
            }           
        }
        if(DocTemplates.Doc_Template_Footer__c != null){
            
            if(DocTemplates.Doc_Template_Footer__r.Footer_body__c != null){
                Footermargin = '1.1in';
                FooterFirstmargin = '1.1in';
                if(DocTemplates.Page_Size__c == 'A3'){
                    height = '9.3in 13.63in';
                }
                else if(DocTemplates.Page_Size__c == 'A4 Letter'){
                    height = '7in 10.4in';
                }
                else if(DocTemplates.Page_Size__c == 'A4 Legal'){
                    height = '7in 12.15in';
                }
                else if(DocTemplates.Page_Size__c == 'A5'){
                    height = '5in 8.4in ';
                }
                else if(DocTemplates.Page_Size__c == 'Label 4x6'){
                    height = '3.7in 6.49in';
                }
                else if(DocTemplates.Page_Size__c == 'Landscape'){
                    height = '11in 10in';
                }
                else{
                    height = '9in 12.65in';
                }
            }
            // FooterBody = FooterBody.Replace('position: absolute','position: relative');
        }
        if(DocTemplates.Doc_Template_Header__c != null && DocTemplates.Doc_Template_Footer__c != null){
            if(DocTemplates.Doc_Template_Header__r.header_body__c != null
               && DocTemplates.Doc_Template_Footer__r.Footer_body__c != null){
                   if(DocTemplates.Page_Size__c == 'A3'){
                       height = '9.3in 14.64in';
                   }
                   else if(DocTemplates.Page_Size__c == 'A4 Letter'){
                       height = '7in 10.9in ';
                   }
                   else if(DocTemplates.Page_Size__c == 'A4 Legal'){
                       height = '7in 13.0in';
                   }
                   else if(DocTemplates.Page_Size__c == 'A5'){
                       height = '5in 8.9in ';
                   }
                   else if(DocTemplates.Page_Size__c == 'Label 4x6'){
                       height = '3.5in 7.35in';
                   }
                   else if(DocTemplates.Page_Size__c == 'Landscape'){
                       height = '11in 10.5in';
                   }
                   else{
                       height = '9in 13.5in';
                   }
               }
        }
        
    }
    global PageReference methodone(){ 
        System.debug('Test');
        string QuoteIds = ApexPages.currentPage().getParameters().get('id');
        System.debug('QuoteIds=='+QuoteIds);
       // list<string> QuotelistIds = (list<string>)JSON.deserialize(QuoteIds, list<string>.class);
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
        output='';
        output2 = '';
        output3 = '';
        //integer i = 1;
        pageContents = new List<String>(); 
        string data = ApexPages.currentPage().getParameters().get('data');
        system.debug('data **** ' + data);
        string[] datalist = data.split(',');
        list<JunoDoc__Consolidate_Records__c> ConsolidateRecord = [select id,Output__c from JunoDoc__Consolidate_Records__c where id IN: datalist];
        for(JunoDoc__Consolidate_Records__c str : ConsolidateRecord){
            pageContents.add(str.Output__c);
        } 
        string dataPDF = ApexPages.currentPage().getParameters().get('PDF');
        if(dataPDF == 'true')
        deleteConsolidateRecords(datalist);
        //<p style="page-break-after: always;"/>
        //for (String str : QuotelistIds) {
          //  PageReference ref = new PageReference('/apex/JunoDoc__PreviewTemplatePDF?id=' + str + '&DocTemplateId=' + DocTemplateIds);
           // pageContents.add(ref.getContent().toString().trim());
        //}
       /* if (pageContents.size() > 40) {
    Integer chunkSize = 20;
    List<String> outputs = new List<String>();

    for (Integer i = 0; i < Math.ceil(pageContents.size() / chunkSize); i++) {
        String outputChunk = '';

        for (Integer j = i * chunkSize; j < Math.min((i + 1) * chunkSize, pageContents.size()); j++) {
            outputChunk += pageContents[j] + '<p style="page-break-after: always;"/>';
        }
        
        outputs.add(outputChunk);
    }

    if (outputs.size() > 0) {
        output = outputs[0];
    }
    if (outputs.size() > 1) {
        output2 = outputs[1];
    }
    if (outputs.size() > 2) {
        output3 = outputs[2];
    }
    // You can continue this pattern for additional outputs if needed
}
        
        else if(pageContents.size() > 25){
            for(integer k=0;k<20;k++){
                output += pageContents[k] + '<p style="page-break-after: always;"/>';
            }
            for(integer k=20;k<pageContents.size();k++){
                if (k < pageContents.size() - 1) {
                    output2 += pageContents[k] + '<p style="page-break-after: always;"/>';
                } else {
                    output2 += pageContents[k];
                }
            }
        }
        else{
            for (Integer i = 0; i < pageContents.size(); i++) {
                if (i < pageContents.size() - 1) {
                    output += pageContents[i] + '<p style="page-break-after: always;"/>';
                } else {
                    output += pageContents[i];
                }
            }
        }*/
        
        return null; 
    }  
    @future
    public static void deleteConsolidateRecords(list<string> ConsolidateRecordIds){
       list<JunoDoc__Consolidate_Records__c> ConsolidateRecord = [select id from JunoDoc__Consolidate_Records__c where id IN: ConsolidateRecordIds]; 
       delete ConsolidateRecord;
    }
}
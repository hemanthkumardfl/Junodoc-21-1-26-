global without sharing class PreviewTemplatePDF_AC {
    global string output{get;set;}
    global string pagenumber{get;set;}
    global string Headermargin{get;set;}
    global string Footermargin{get;set;}
    global string HeaderFirstmargin{get;set;}
    global string FooterFirstmargin{get;set;}   
    global string height{get;set;}
    global string heightsecond{get;set;}  
    global string backgroundImage{get;set;}  
    global string hideheaderfooter{get;set;}
    global string worddocName{get;set;}
    global string loadstring{get;set;}
    global string recordId{get;set;}
    global string DocId{get;set;}
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
    global string margin{get;set;}
    global string padding{get;set;}
    global string paddingLeft{get;set;}
    global string paddingRight{get;set;}
    global string marginLeft {get;set;}
    global string marginLeftHeader {get;set;}
    global PreviewTemplatePDF_AC(){          
        
     
        Id QuoteId = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        Id DocTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));   
        system.debug('*********** QuoteId' + QuoteId);
        recordId = ApexPages.currentPage().getParameters().get('id');
        DocId = ApexPages.currentPage().getParameters().get('DocTemplateId');  
        String sObjName = QuoteId.getSObjectType().getDescribe().getName();
        string TemplateID = '';
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        string DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
        if(DocTemplateField=='Doc_Template__c'){
            string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: QuoteId' ;
            sobject NewQuote = Database.query(Newqueries);
            TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
        } 
        if(DocTemplateId !=null){ // selected Available Template Id
            TemplateID = DocTemplateId;
        } 
        Junodoc__Doc_Template__c DocTemplates = [select id,
                                                Junodoc__Page_Size__c,
                                                JunoDoc__Hide_Header__c,
                                                JunoDoc__Hide_Footer__c,
                                                JunoDoc__Show_Page_Number__c,
                                                Junodoc__PDF_Name__c,
                                                 Junodoc__Date_Format__c,
                                                Junodoc__Parent_Object__c,
                                                JunoDoc__Background_Image_URL__c,
                                                 JunoDoc__Disable_Margin_Width__c,
                                                Junodoc__Doc_Template_Header__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__Master_Object_Fields__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__header_body__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__Master_object__c,
                                                Junodoc__Doc_Template_Footer__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Master_Object_Fields__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Master_object__c,
                                                Junodoc__Page_Height__c,
                                                Junodoc__Page_Width__c,
                                                Junodoc__Parent_Fields__c 
                                                from Junodoc__Doc_Template__c 
                                                where id =: TemplateID];
       
        String query ='';
        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == false){
            Headermargin = '0.1in';
            Footermargin = '0.1in';
            FooterFirstmargin = '0.01in';
            HeaderFirstmargin = '0.01in';
            margin = '0.155in'; //0.2in
            padding = '3px';
            paddingLeft = '8px';
            paddingRight = '8px';
            marginLeftHeader = '0in';
            marginLeft = '0.155in';
        }
        else{
            Headermargin = '0in';
            Footermargin = '0in';
            FooterFirstmargin = '0in';
            HeaderFirstmargin = '0in';
            margin = '0in'; //0.2in
            padding = '0px';
            paddingLeft = '0px'; 
            paddingRight = '0px';
          //  marginLeftHeader = '0.069in';
          //  marginLeft = '-0.09in';
            
            marginLeftHeader = '5px';
            marginLeft = '-7px';
        }
         
        String SobjectApiName = DocTemplates.Junodoc__Parent_Object__c;
        string fieldNames = '';
        string Title = 'PreviewPDF';
        worddocName = 'PreviewWordDoc';
        if(DocTemplates.Junodoc__PDF_Name__c != '' && DocTemplates.Junodoc__PDF_Name__c != null){
            Title = DocTemplates.Junodoc__PDF_Name__c;
            string DateFormats = 'MM/dd/yyyy';
            if(DocTemplates.Junodoc__Date_Format__c != null && DocTemplates.Junodoc__Date_Format__c != ''){
                DateFormats = DocTemplates.Junodoc__Date_Format__c;
            }
        if(Title.contains('{!TODAY()}')){
            Date Datestr = system.Today();
            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
            DocTemplates.Junodoc__PDF_Name__c = Title.replace('{!TODAY()}',Parentvalues);  
                Title = Title.replace('{!TODAY()}',Parentvalues); 
        }
        if(Title.contains('{!NOW()}')){
            string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
            DocTemplates.Junodoc__PDF_Name__c = Title.replace('{!NOW()}',Parentvalues);     
            Title = Title.replace('{!NOW()}',Parentvalues); 
        }
            if(DocTemplates.Junodoc__PDF_Name__c.contains('{!')){
            string finalstrings = string.valueof(DocTemplates.Junodoc__PDF_Name__c).replace('{!','xxwwwee');
            string[] pdfnames = finalstrings.split('xxwwwee');
            integer k = 0;
            for(string str : pdfnames){
                if(k != 0){
                    string[] strlist = str.split('}');
                    fieldNames += strlist[0]+ ',';
                }
                k = k+1;  
            }
        }
        }
       
        if(fieldNames != ''){
            system.debug('fieldNames-----------'+fieldNames);
            fieldNames = fieldNames.substring(0,fieldNames.length()-1);
            
            string pdfquery = 'select id,'+fieldNames+' from '+SobjectApiName+ ' where id=:QuoteId';
            system.debug('pdfquery------------------'+pdfquery);
            sobject dynamicobject = Database.query(pdfquery);
            string[] fieldlist = fieldNames.split(',');
            for(string names : fieldlist){
                //  system.debug('names **' + names);
                if(!names.contains('.')){
                    Title = Title.replace('{!'+names + '}',''+dynamicobject.get(names));
                }
                else if(names.contains('.')){
                    string Stringobjct = names.replace('.',',');
                    string[] Stringobjcts = Stringobjct.split(',');
                    if(Stringobjcts.size() > 3){
                        if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) { 
                                   Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                }
                            }
                        }
                    }
                    else if(Stringobjcts.size() > 2){
                        if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                            if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                if(dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) { 
                                   Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                }
                            }
                        }
                    }
                    else if(Stringobjcts.size() > 1){
                        if(dynamicobject.getsobject(Stringobjcts[0]) != null){
                            if(dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null){
                                   Title = Title.replace('{!'+names + '}',''+dynamicobject.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                }
                            }
                        }
                    }               
            }
        }
        // system.debug('Title **' + Title);
        Title = Title.replace(',','');
        Title = Title.replace('.','');
        Title = Title.replace('\'','');
        Title = Title.replace(';','');
        worddocName = Title;
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+Title+'.pdf');          
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        if(DocTemplates.JunoDoc__Background_Image_URL__c != null && DocTemplates.JunoDoc__Background_Image_URL__c != ''){
            backgroundImage = 'url("'+DocTemplates.JunoDoc__Background_Image_URL__c+'")';
        }
        else{
           backgroundImage = 'unset';  
        }
        if(DocTemplates.Junodoc__Page_Height__c != null && DocTemplates.Junodoc__Page_Width__c != null && DocTemplates.Junodoc__Page_Size__c == 'Custom'){
             decimal inches = 0.15;
             Headermargin = '0.1in';
            Footermargin = '0in';
            FooterFirstmargin = '0in';
            HeaderFirstmargin = '-0.12in';
             margin = '0in';
             padding = '0px';
             paddingLeft = '0px';
             if(DocTemplates.Junodoc__Doc_Template_Header__c != null){
                if(DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c != null){
                    Headermargin = '1.3in';
                    HeaderFirstmargin = '1in';
                    inches += 1.3;
                }
             }
             if(DocTemplates.Junodoc__Doc_Template_Footer__c != null){
                
                if(DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c != null){
                     Footermargin = '1.1in';  
                     FooterFirstmargin = '1.1in';  
                     inches += 1.1;
                }
             }
             height = (DocTemplates.Junodoc__Page_Width__c+0.16) +'in '+ (DocTemplates.Junodoc__Page_Height__c+inches+'')+ 'in';
        }
        else{
            if(DocTemplates.Junodoc__Page_Size__c == 'A3'){
                height = '9.3in 12.68in';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                    height = '8.78in 12.68in';
                }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Letter'){
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                    height = '6.37in 8.9in';
                }
                else{
                     height = '7in 8.9in';
                }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'US Letter'){
            	height = '8.5in 11in';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                    height = '8.04in 11in';
                }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Legal'){
                height = '7in 11.0in';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.40in 11in';
                        }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'A5'){
                height = '5in 6.9in ';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '4.42in 6.9in ';
                        }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'Label 4x6'){
                height = '3.6in 5.35in';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                    height = '3.1in 5.35in';
                }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'Landscape'){
                height = '11in 8.5in';
                if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                    height = '10.45in 8.5in';
                }
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'A3 New'){
                height = '11in 17in';
            }
            else if(DocTemplates.Junodoc__Page_Size__c == 'A4 New'){
                height = '8.5in 14in';
            }
            else{
                height = '9in 11.5in';
            }
            if(DocTemplates.Junodoc__Doc_Template_Header__c != null){
                if(DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c != null){
                    Headermargin = '1.3in';
                    HeaderFirstmargin = '1in';
           
                    if(DocTemplates.Junodoc__Page_Size__c == 'A3'){
                        height = '9.3in 13.79in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.78in 13.79in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'US Letter'){
                        height = '8.5in 11in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.04in 11in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Letter'){
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.37in 10.4in';
                        }
                        else{
                             height = '7in 10.4in';
                        }

                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Legal'){
                        height = '7in 12.15in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.40in 12.15in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A5'){
                        height = '5in 8.4in ';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '4.42in 8.4in ';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Label 4x6'){
                        height = '3.6in 6.49in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '3.1in 6.49in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Landscape'){
                        height = '11in 10in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '10.45in 10in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A3 New'){
                        height = '11in 17in';
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 New'){
                        height = '8.5in 14in';
                    }
                    else{
                        height = '9in 12.65in';
                    }
                }           
            }
            if(DocTemplates.Junodoc__Doc_Template_Footer__c != null){
                
                if(DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c != null){
                    Footermargin = '1.1in';  
                     FooterFirstmargin = '1.1in';  
                    if(DocTemplates.Junodoc__Page_Size__c == 'A3'){
                        height = '9.3in 13.77in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.78in 13.77in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'US Letter'){
                        height = '8.5in 11in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.04in 11in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Letter'){
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.37in 10.4in';
                        }
                        else{
                             height = '7in 10.4in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Legal'){
                        height = '7in 12.15in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.40in 12.15in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A5'){
                        height = '5in 8.4in ';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '4.42in 8.4in ';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Label 4x6'){
                        height = '3.6in 6.49in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '3.1in 6.49in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Landscape'){
                        height = '11in 10in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '10.45in 10in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A3 New'){
                        height = '11in 17in';
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 New'){
                        height = '8.5in 14in';
                    }
                    else{
                        height = '9in 12.65in';
                    }
                }
            }
            if(DocTemplates.Junodoc__Doc_Template_Header__c != null && DocTemplates.Junodoc__Doc_Template_Footer__c != null){
            if(DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c != null
              && DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c != null){
                    if(DocTemplates.Junodoc__Page_Size__c == 'A3'){
                        height = '9.3in 14.78in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.78in 14.78in';
                        }
                    }
                   else if(DocTemplates.Junodoc__Page_Size__c == 'US Letter'){
                        height = '8.5in 11in';
                       if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '8.04in 11in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Letter'){
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.40in 10.9in';
                        }
                        else{
                             height = '7in 10.9in';
                        }

                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 Legal'){
                        height = '7in 13.0in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '6.40in 13.0in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A5'){
                        height = '5in 8.9in ';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '4.42in 8.9in ';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Label 4x6'){
                        height = '3.6in 7.35in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '3.1in 7.35in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'Landscape'){
                        height = '11in 10.5in';
                        if(DocTemplates.JunoDoc__Disable_Margin_Width__c == true){
                            height = '10.45in 10.5in';
                        }
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A3 New'){
                        height = '11in 17in';
                    }
                    else if(DocTemplates.Junodoc__Page_Size__c == 'A4 New'){
                        height = '8.5in 14in';
                    }
                    else{
                        height = '9in 13.5in';
                    }
              }
        }
        }
        
        if(DocTemplates.JunoDoc__Show_Page_Number__c){
            Footermargin = '1.1in';
            FooterFirstmargin = '1.1in';  
            pagenumber = 'content: "Page " counter(page) " of " counter(pages);';
        }  
        hideheaderfooter = '';
        if(DocTemplates.JunoDoc__Hide_Header__c){
            hideheaderfooter += ' @top { content: normal } @top-center {content: normal;} ';
        }
        
        if(DocTemplates.JunoDoc__Hide_Footer__c){
            hideheaderfooter += ' @bottom-right { content: normal }  @bottom-left {content: normal;} ';
        }
        
        if(DocTemplates.JunoDoc__Hide_Footer__c && DocTemplates.JunoDoc__Show_Page_Number__c){
            Footermargin = '1.1in';
            FooterFirstmargin = '1.1in';  
            hideheaderfooter += ' @bottom-right {content: "Page " counter(page) " of " counter(pages) }  @bottom-left {content: normal;} ';
        }
        
         string QuoteIds = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
      
        
    }
    global PageReference methodone(){
        string QuoteIds = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
        PageReference ref = new PageReference('/apex/JunoDoc__PreviewTemplatePDF?id='+QuoteIds+'&DocTemplateId='+DocTemplateIds+'&Type=DocTemplate');
        if(!Test.isRunningTest()){
            
            output= string.valueof( ref.getContent().tostring().trim() + '').unescapeHtml4().replace('<div style="font-size: 0px;">"</div>','').replace('<div class="content">null','<div class="content">').replace('µ','&micro;').replace('--lt--','&lt;').replace('--gt--','&gt;');
            system.debug('strings ********** ' + output );
        }
        else{
            output= string.valueof( 'tested');
        }
        // system.debug('output *********************' + output);
        return null;
    }
    
    global PageReference methodtwo(){
        string QuoteIds = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
        PageReference ref = new PageReference('/apex/JunoDoc__PreviewWordDoc?id='+QuoteIds+'&DocTemplateId='+DocTemplateIds+'&Type=WordTemplate');
        if(!Test.isRunningTest()){
            output= string.valueof( ref.getcontent().tostring().trim() + '');
        }
        else{
            output= string.valueof( 'tested');
        }
        
        output  = output.unescapeHtml4(); 
        output = output.replace('<div style="font-size: 0px;">"</div>','');
        output = output.replace('<div class="content">null','<div class="content">');
        loadstring = '<script> loadwordScrip1t() </script>';
       
        
        return null;
    }   
    
    global PageReference methodthree(){
        string QuoteIds = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        string DocTemplateIds = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
        PageReference ref = new PageReference('/apex/JunoDoc__ExcelWordDoc?id='+QuoteIds+'&DocTemplateId='+DocTemplateIds+'&Type=Excel');
        if(!Test.isRunningTest()){
            output= string.valueof( ref.getcontent().tostring().trim() + '');
        }
        else{
            output= string.valueof( 'tested');
        }
        
        output  = output.unescapeHtml4(); 
        output = output.replace('<div style="font-size: 0px;">"</div>','');
        output = output.replace('<div class="content">null','<div class="content">');
        loadstring = '<script> loadwordScrip1t() </script>';
       // system.debug('output *********************' + output);
        return null;
    }    
}
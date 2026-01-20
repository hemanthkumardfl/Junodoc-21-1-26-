public class MainPage_AC {
    public string PDFValue{get;set;}
    public string Title{get;set;}
    public string output{get;set;} 
    public string junodocURL{get;set;}
    public Id QuoteId{get;set;}
    public string QuoteIds{get;set;}
    public Id DocTemplateId{get;set;}
    public string body{get;set;}
    public string secondbody{get;set;}
    public string data{get;set;}
    public boolean showSinglePage{get;set;}
    public boolean showMultiplePage{get;set;}
    public MainPage_AC(){
        junodocURL = Dynamic_GeneratePDF_Controller.getJunodocUrl();
        
        DocTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));        
       
        string Type = ApexPages.currentPage().getParameters().get('Type');
        showSinglePage = false;
        showMultiplePage = false;
        if(Type == 'multiple'){
            showMultiplePage = true;
        }
        if(Type == 'single'){
            showSinglePage = true;
        }
        
        
        
        Doc_Template__c DocTemplates = [select id,Date_Format__c,
                                                PDF_Name__c,
                                                Parent_Object__c,
                                                Parent_Fields__c 
                                                from Doc_Template__c 
                                                where id =: DocTemplateId];
        Title = 'PreviewPDF';
        PageReference pagePdf;
        String query ='';
        String SobjectApiName = DocTemplates.Parent_Object__c;
         string fieldNames = '';
        if(Type == 'single'){
            QuoteId = id.valueof(ApexPages.currentPage().getParameters().get('id'));
            
            /* if(DocTemplates.PDF_Name__c != '' && DocTemplates.PDF_Name__c != null){
            Title = DocTemplates.PDF_Name__c;
            if(DocTemplates.PDF_Name__c.contains('{!')){
            string finalstrings = string.valueof(DocTemplates.PDF_Name__c).replace('{!','xxwwwee');
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
        } */
             if(DocTemplates.PDF_Name__c != '' && DocTemplates.PDF_Name__c != null){
            Title = DocTemplates.PDF_Name__c;
            string DateFormats = 'MM/dd/yyyy';
            if(DocTemplates.Date_Format__c != null && DocTemplates.Date_Format__c != ''){
                DateFormats = DocTemplates.Date_Format__c;
            }
        if(Title.contains('{!TODAY()}')){
            Date Datestr = system.Today();
            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);                
            DocTemplates.PDF_Name__c = Title.replace('{!TODAY()}',Parentvalues);  
                Title = Title.replace('{!TODAY()}',Parentvalues); 
        }
        if(Title.contains('{!NOW()}')){
            string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormats + ' HH:mm a');
            DocTemplates.PDF_Name__c = Title.replace('{!NOW()}',Parentvalues);     
            Title = Title.replace('{!NOW()}',Parentvalues); 
        }
            if(DocTemplates.Junodoc__PDF_Name__c.contains('{!')){
            string finalstrings = string.valueof(DocTemplates.PDF_Name__c).replace('{!','xxwwwee');
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
            fieldNames = fieldNames.substring(0,fieldNames.length()-1);
            string pdfquery = 'select id,'+fieldNames+' from '+SobjectApiName+ ' where id=:QuoteId';
                system.debug('pdfquery ----> '+pdfquery);
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
            
            pagePdf = new PageReference('/apex/JunoDoc__JunodocPDF?id='+QuoteId+'&DocTemplateId='+DocTemplateId+'&Type=DocTemplate');
        }
        else if(Type == 'multiple'){
            QuoteIds = ApexPages.currentPage().getParameters().get('id');
            Title = SobjectApiName + ' Multiple PDFs';
            data = ApexPages.currentPage().getParameters().get('data');
            system.debug('MainPage data *** ' + data);
            pagePdf = new PageReference('/apex/JunoDoc__DownloadPDF_VF?id='+QuoteIds+'&DocTemplateId='+DocTemplateId+'&Type=DocTemplate&data='+data);
        }
        if(!Test.isRunningTest()){
            blob pdfPageBlob = pagePdf.getContentAsPDF();
            
            if(Encodingutil.base64encode(pdfPageBlob).length() <= 5999950){
                body='data:application/pdf;base64,'+ (Encodingutil.base64encode(pdfPageBlob));
            }
            else{
                body='data:application/pdf;base64,'+ (Encodingutil.base64encode(pdfPageBlob)).substring(0,5999950);
                secondbody= (Encodingutil.base64encode(pdfPageBlob)).substring(5999950,Encodingutil.base64encode(pdfPageBlob).length());
            }
        }
        else{
            output= string.valueof( 'tested');
        }
    }
}
global class DownloadMultiPDF_AC {
    global list<string> QuotelistIds{get;set;}  
    global string DocTemplate{get;set;}
    global DownloadMultiPDF_AC(){
        DocTemplate = ApexPages.currentPage().getParameters().get('DocTemplateId'); 
        string QuoteIds = ApexPages.currentPage().getParameters().get('id');
        System.debug('QuoteIds=='+QuoteIds);
        QuotelistIds = QuoteIds.replace('(','').replace(')','').split(',');
        system.debug(QuotelistIds);
    }
    
     @RemoteAction
    public static string getQuoteDetails(String quoteId,string DocTemplateIds) {
        List<String> pageContents = new List<String>(); 
        string output = '';
        PageReference ref = new PageReference('/apex/JunoDoc__PreviewTemplatePDF?id=' + quoteId + '&DocTemplateId=' + DocTemplateIds);
        pageContents.add(ref.getContent().toString().trim());
        
        for (Integer i = 0; i < pageContents.size(); i++) {
            if (i < pageContents.size() - 1) {
                output += pageContents[i] + '<p style="page-break-after: always;"/>';
            } else {
                output += pageContents[i];
            }
        }
        output = output.unescapeHtml4().replace('<div style="font-size: 0px;">"</div>', '').replace('<div class="content">null', '<div class="content">');
        return output; // Replace with actual details
    }
}
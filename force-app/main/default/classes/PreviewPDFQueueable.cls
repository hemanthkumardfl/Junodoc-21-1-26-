public class PreviewPDFQueueable implements Queueable {
    private List<String> quoteIds;
    private string DocTemplateIds;
    public String output;

    public PreviewPDFQueueable(List<String> quoteIds,string DocTemplateIds) {
        this.quoteIds = quoteIds;
        this.DocTemplateIds = DocTemplateIds;
        this.output = '';
    }

    public void execute(QueueableContext context) {
        List<String> pageContents = new List<String>();

        for (String quoteId : quoteIds) {
            PageReference ref = new PageReference('/apex/JunoDoc__PreviewTemplatePDF?id=' + quoteId + '&DocTemplateId=' + DocTemplateIds);
            pageContents.add(ref.getContent().toString().trim());
        }

        for (Integer i = 0; i < pageContents.size(); i++) {
            if (i < pageContents.size() - 1) {
                output += pageContents[i] + '<p style="page-break-after: always;"/>';
            } else {
                output += pageContents[i];
            }
        }

        output = output.unescapeHtml4();
        output = output.replace('<div style="font-size: 0px;">"</div>', '');
        output = output.replace('<div class="content">null', '<div class="content">');
    }

    public String getOutput() {
        return output;
    }
}
public class PDFControllerVF {
    public string attID { get; set; }
    public PDFControllerVF(){
    	attID = ApexPages.currentPage().getParameters().get('id'); 
        //Attachment att = [select id from Attachment where id =: attID];
    }
    
    
}
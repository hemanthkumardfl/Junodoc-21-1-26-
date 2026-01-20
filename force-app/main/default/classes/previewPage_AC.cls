public class previewPage_AC {
    public string TemplateBodys{get;set;}
    public previewPage_AC(){
        PageReference ref = new PageReference('/apex/TestPageVF');
        if(!Test.isRunningTest()){
            TemplateBodys= string.valueof( ref.getcontent().tostring().trim() + '');
        }
        else{
            TemplateBodys= string.valueof( 'tested');
        }
    }
    public Component.Apex.OutputText getClassroomRelatedLists() {
        Component.Apex.OutputText head1 = new Component.Apex.OutputText();
        
       
        if(TemplateBodys != null){
            head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',null)}"</div>'+TemplateBodys ;
        }
        else{
            head1.expressions.value = '';
        }
        
        return head1;
    }
}
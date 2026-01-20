@isTest
public class JunosignObjectSettings_TC {
    @isTest static void test1(){
        Doc_Template__c doctemp = new Doc_Template__c();
        doctemp.Name='test';
        doctemp.Parent_Object__c='Account';
        doctemp.Parent_Fields__c='JunoDoc__Doc_Template__c';
        insert doctemp;
        
        Email_Template__c email = new Email_Template__c();
        email.Name='test';
        email.Parent_Object__c='Account';
        email.Parent_Fields__c='fileds';
        insert email;
        
        JunoDoc__Junodoc_Page_Tab__c pt = new JunoDoc__Junodoc_Page_Tab__c();
        pt.Name='test';
        pt.JunoDoc__Pos_Left__c='test';
        pt.JunoDoc__Pos_Top__c='test';
        pt.JunoDoc__Sign_Completed__c=true;
        pt.JunoDoc__Type__c='test';
        pt.JunoDoc__Linked_To__c='test';
        pt.JunoDoc__Recipient_Sort_Order__c=5;
        insert pt;
        
        
        JunoDoc__Junosign_Object_Setting__c juno = new JunoDoc__Junosign_Object_Setting__c(); 
        juno.Selected_object__c='Account';
        insert juno;
        
        JunoDoc__Email_Details__c jemail = new JunoDoc__Email_Details__c();
        jemail.JunoDoc__To_Value__c='To';
        jemail.JunoDoc__Text_Ref_Value__c= '';
        jemail.JunoDoc__field_Details__c='';
        jemail.JunoDoc__Name__c = 'Test';
        jemail.JunoDoc__Email__c='Test@gmail.com';
        jemail.JunoDoc__Junosign_Object_Setting__c=juno.id;
        insert jemail;
        
        Attachment att = new Attachment();
        att.Name ='test';
        att.ParentId=pt.Id;
        
        list<JunosignObjectSettings.returnEmailDetails> returnEmailDetailslist = new list<JunosignObjectSettings.returnEmailDetails>();
        JunosignObjectSettings.returnEmailDetails returnEmailDetailsrec = new JunosignObjectSettings.returnEmailDetails();
        returnEmailDetailsrec.Tovalue = 'To';
        returnEmailDetailsrec.TextRefVal = 'Text';
        returnEmailDetailsrec.Email = 'test@gmail.com';
        returnEmailDetailsrec.fieldDetails = '';
        returnEmailDetailslist.add(returnEmailDetailsrec);
        string emaillist = JSON.serialize(returnEmailDetailslist);
        
        JunosignObjectSettings.getObjectName();
        JunosignObjectSettings.getJunodocUrl();
        JunosignObjectSettings.getEmailTemplates('Account');
        JunosignObjectSettings.getrecorddetails('Account');
        JunosignObjectSettings.createrecord('Account',emaillist,'Test','');
        //JunosignObjectSettings.getAttachmentData();
        JunosignObjectSettings.saveChunks('Test', 'Data', 'pdf');
        JunosignObjectSettings.saveTheFile(pt.Id,'Test', 'Data', 'pdf');
        JunosignObjectSettings.getAttachmentData();
        
    }
}
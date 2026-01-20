@isTest
public class AddEmailRecipientController_TC {
    
    private static testMethod void Test(){
        Contact Con = new Contact();
        Con.LastName = 'test';
        Con.Email = 'test@gmail.com';
        insert Con;
        
        Account Acc = new Account();
        Acc.Name = 'testacc';
        insert Acc;
        
        
        Doc_Template__c temp = new Doc_Template__c();
        temp.Name = 'test';
        temp.Parent_Object__c = 'Contact';
        temp.Parent_Fields__c = 'LastName';
        temp.JunoDoc__Show_Templates__c = false;
        insert temp;
                
        JunoDoc__Email_Template__c jemailtemplate = new JunoDoc__Email_Template__c();
        jemailtemplate.Name='testtemplate';
        jemailtemplate.JunoDoc__Parent_Object__c='Account';
        jemailtemplate.JunoDoc__Parent_Fields__c='Name';
        insert jemailtemplate;
        
        JunoDoc__Junosign_Object_Setting__c juno = new JunoDoc__Junosign_Object_Setting__c(); 
        juno.Selected_object__c='Account';
        juno.JunoDoc__Junodoc_Default_EmailTemplate__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Default_EmailTemplate_For_Owner__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Default_EmailTemplate_For_Signee__c = jemailtemplate.Id;
        juno.JunoDoc__Junodoc_Doc_Template__c = temp.Id;
        insert juno;
        
        JunoDoc__Email_Details__c jemail = new JunoDoc__Email_Details__c();
         jemail.JunoDoc__To_Value__c='To';
         jemail.JunoDoc__Text_Ref_Value__c= '';
         jemail.JunoDoc__field_Details__c='';
         jemail.JunoDoc__Name__c = 'Test';
         jemail.JunoDoc__Email__c='Test@gmail.com';
         jemail.JunoDoc__Junosign_Object_Setting__c=juno.id;
         insert jemail;
        
        list<JunosignObjectSettings.returnEmailDetails> returnEmailDetailslist = new list<JunosignObjectSettings.returnEmailDetails>();
        JunosignObjectSettings.returnEmailDetails returnEmailDetailsrec = new JunosignObjectSettings.returnEmailDetails();
        returnEmailDetailsrec.Tovalue = 'To';
        returnEmailDetailsrec.TextRefVal = 'Text';
        returnEmailDetailsrec.Email = 'test@gmail.com';
        returnEmailDetailsrec.fieldDetails = '';
        returnEmailDetailslist.add(returnEmailDetailsrec);
        string emaillist = JSON.serialize(returnEmailDetailslist);
        
        AddEmailRecipientController.getObjectLabelName('Contact');
        AddEmailRecipientController.getinitialObjectFields('Contact');
        AddEmailRecipientController.getinitialObjectFields('Contact1');
        AddEmailRecipientController.getAllObjectFields('Contact');
        AddEmailRecipientController.getAllObjectFields('Contact1');
        AddEmailRecipientController.GetSecLevelFieldDetailscontroller('Contact','AccountId','Email__c-Email__c-Email__c');
        AddEmailRecipientController.GetThirdLevelFieldDetails('Contact','AccountId','OwnerId','Email-Email-Email');
        AddEmailRecipientController.GetFinalLevelFieldDetails('Contact','AccountId','OwnerId','Email','Email-Email-Email');        
        AddEmailRecipientController.getFinalObjectFields('Contact');
        AddEmailRecipientController.getFinalObjectFields('Contact1');
        AddEmailRecipientController.GetFieldDetails('Contact','AccountId');
        AddEmailRecipientController.getAvailableDocTemplates('Contact');
        AddEmailRecipientController.setDefaultTemplate('Account',temp.Id);
        AddEmailRecipientController.getDefaultTemplate('Account');
        AddEmailRecipientController.createrecord('Account',emaillist);
        AddEmailRecipientController.getJunoEmailTemplates('Account');
        AddEmailRecipientController.setJunoEmailTemplate('Account', jemailtemplate.Id);
        AddEmailRecipientController.getJunoEmailTemplate('Account');
        AddEmailRecipientController.getJunoEmailTemplatesForOwner('Account');
        AddEmailRecipientController.setJunoEmailTemplateForOwner('Account', jemailtemplate.Id);
        AddEmailRecipientController.getJunoEmailTemplateForOwner('Account');
        AddEmailRecipientController.getJunoEmailTemplatesForSignee('Account');
        AddEmailRecipientController.setJunoEmailTemplateForSignee('Account', jemailtemplate.Id);
        AddEmailRecipientController.getJunoEmailTemplateForSignee('Account');
        AddEmailRecipientController.getConUserRec('Contact','s');
        AddEmailRecipientController.getSelectedConUserRecEmail(Con.Id, 'Contact');
        AddEmailRecipientController.createrecord2('Account','test@gmail.com','',emaillist,temp.Id,jemailtemplate.Id,jemailtemplate.Id,jemailtemplate.Id);
        AddEmailRecipientController.getSetReplyTo('Account');
      // AddEmailRecipientController.getAccountFieldValue();
        //AddEmailRecipientController.createrecordSetReplyTo('Account', 'test@gmail.com');
    }
    
    
}
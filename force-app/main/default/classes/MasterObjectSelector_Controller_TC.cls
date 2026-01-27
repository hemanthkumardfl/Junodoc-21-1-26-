@isTest
public class MasterObjectSelector_Controller_TC {
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
        
        
        Junodoc_Details__c juno = new Junodoc_Details__c(); 
        juno.From_Email_Address__c='test@gmail.com';
        juno.Junodoc_Email_Templates__c='test';
        juno.Standard_Email_Templates__c='testid';
        juno.Set_Reply_To__c='testing@gmail.com';
        juno.Selected_object__c='Account';
        insert juno;
        
        JunoDoc__Email_Details__c JunoEm = new JunoDoc__Email_Details__c();
        JunoEm.JunoDoc__Text_Ref_Value__c = 'Text';
       JunoEm.JunoDoc__Junodoc_Details__c = juno.Id;
        JunoEm.JunoDoc__field_Details__c = '';
        JunoEm.JunoDoc__Email__c = 'test@gmail.com';
        JunoEm.JunoDoc__To_Value__c = 'To';
        insert JunoEm;
        
         list<MasterObjectSelector_Controller.returnEmailDetails> returnEmailDetailslist = new list<MasterObjectSelector_Controller.returnEmailDetails>();
        MasterObjectSelector_Controller.returnEmailDetails returnEmailDetailsrec = new MasterObjectSelector_Controller.returnEmailDetails();
        returnEmailDetailsrec.Tovalue = 'To';
        returnEmailDetailsrec.TextRefVal = 'Text';
        returnEmailDetailsrec.Email = 'test@gmail.com';
        returnEmailDetailsrec.fieldDetails = '';
        returnEmailDetailslist.add(returnEmailDetailsrec);
        string emaillist = JSON.serialize(returnEmailDetailslist);
        
        MasterObjectSelector_Controller.getObjectName();
        MasterObjectSelector_Controller.getOrgUrl();
        MasterObjectSelector_Controller.getJunodocUrl();
        MasterObjectSelector_Controller.getAvailableDoc('Account');
        MasterObjectSelector_Controller.getEmailTemplates('Account');
        MasterObjectSelector_Controller.getrecorddetails('Account');
        MasterObjectSelector_Controller.getAvailableEmails('Account');
        MasterObjectSelector_Controller.createrecord('test@gmail.com','testreply@gmail.com','testid','testjuno','Account',emaillist,'Test','Test','test','Test','Test','test','test');
        /* Added by sainath on 09-Sep-2025 Start */
        MasterObjectSelector_Controller.saveSettings('test@gmail.com','testreply@gmail.com','testid','testjuno','Account',emaillist,'Test','Test','test','Test','Test','test','test', true, false,'Account');
        /* Added by sainath on 09-Sep-2025 End */
    }
    
    @isTest static void test2(){
        JunoDoc__Junodoc_Setting__c JunoSet = new JunoDoc__Junodoc_Setting__c();
        JunoSet.JunoDoc__Organization_Url__c = 'test';
        insert JunoSet;
        
        MasterObjectSelector_Controller.getrecorddetails('Account');
         MasterObjectSelector_Controller.getOrgUrl();
        MasterObjectSelector_Controller.getParentObjects('Contact');
    }
    
    @isTest static void test3(){
        Test.startTest();
        MasterObjectSelector_Controller.getObjectName();
        Test.stopTest();
    }
}
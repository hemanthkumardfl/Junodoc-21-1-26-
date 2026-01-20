@isTest
public class PostAction_TC {
    @isTest
    public static void method1(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        List<Post_Action__c> PostActs = new List<Post_Action__c>();
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        PostActs.add(PostAct);
        //insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        PostActs.add(PostAct1);
        //insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        PostActs.add(PostAct2);
        //insert PostAct2;
        insert PostActs;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"Status","value":"Approved","FieldType":"PICKLIST","PickValues":[{"pickvalue":"Draft", "picklabel":"Draft"},{"pickvalue":"Needs Review", "picklabel":"Needs Review"},{"pickvalue":"In Review", "picklabel":"In Review"},{"pickvalue":"Approved", "picklabel":"Approved"},{"pickvalue":"Rejected", "picklabel":"Rejected"},{"pickvalue":"Presented", "picklabel":"Presented"},{"pickvalue":"Accepted", "picklabel":"Accepted"},{"pickvalue":"Denied", "picklabel":"Denied"}],"Check":null,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method2(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"","value":"Approved","FieldType":"PICKLIST","PickValues":[{"pickvalue":"Draft", "picklabel":"Draft"},{"pickvalue":"Needs Review", "picklabel":"Needs Review"},{"pickvalue":"In Review", "picklabel":"In Review"},{"pickvalue":"Approved", "picklabel":"Approved"},{"pickvalue":"Rejected", "picklabel":"Rejected"},{"pickvalue":"Presented", "picklabel":"Presented"},{"pickvalue":"Accepted", "picklabel":"Accepted"},{"pickvalue":"Denied", "picklabel":"Denied"}],"Check":null,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method3(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"ExpirationDate","value":"","FieldType":"DATE","PickValues":[],"Check":null,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method4(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"IsSyncing","value":"false","FieldType":"BOOLEAN","PickValues":[],"Check":false,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method5(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"","value":"","FieldType":"","PickValues":[],"Check":null,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method6(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"Status","value":"Approved","FieldType":"PICKLIST","PickValues":[{"pickvalue":"Draft", "picklabel":"Draft"},{"pickvalue":"Needs Review", "picklabel":"Needs Review"},{"pickvalue":"In Review", "picklabel":"In Review"},{"pickvalue":"Approved", "picklabel":"Approved"},{"pickvalue":"Rejected", "picklabel":"Rejected"},{"pickvalue":"Presented", "picklabel":"Presented"},{"pickvalue":"Accepted", "picklabel":"Accepted"},{"pickvalue":"Denied", "picklabel":"Denied"}],"Check":null,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method7(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"IsSyncing","value":"","FieldType":"BOOLEAN","PickValues":[],"Check":false,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false},{"SelectedValue":"Status","value":"","FieldType":"PICKLIST","PickValues":[{"pickvalue":"Approved", "picklabel":"Approved"},{"pickvalue":"Net", "picklabel":"Net"}],"Check":false,"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method8(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[{"SelectedValue":"","value":""}]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method9(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method10(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist = '[{"SelectedValue":"Status","value":"","FieldType":"","PickValues":[],"GenerateCheck":true,"MailCheck":false,"AttachCheck":false}]';
        String doclist2 = '[]';
        
        PostAction_AC.getFields(JDT.Id);
        PostAction_AC.getPostActs(JDT.Id);
        PostAction_AC.ChangeDataType(doclist, JDT.Id);
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
    @isTest
    public static void method11(){
        JunoDoc__Doc_Template__c JDT = new JunoDoc__Doc_Template__c();
        JDT.Name = 'test';
        JDT.JunoDoc__Parent_Object__c = 'Quote';
        insert JDT;
        
        Post_Action__c PostAct = new Post_Action__c();
        PostAct.Name = 'Status';
        PostAct.JunoDoc__Field_Type__c = 'PICKLIST';
        PostAct.JunoDoc__Field_Values__c = 'Approved';
        PostAct.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct.JunoDoc__Generate_Check__c = 'true';
        PostAct.JunoDoc__Attach_Check__c = 'false';
        PostAct.JunoDoc__Mail_Check__c = 'false';
        insert PostAct;
        
        Post_Action__c PostAct1 = new Post_Action__c();
        PostAct1.Name = 'IsSyncing';
        PostAct1.JunoDoc__Field_Type__c = 'BOOLEAN';
        PostAct1.JunoDoc__Field_Values__c = 'true';
        PostAct1.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct1.JunoDoc__Generate_Check__c = 'false';
        PostAct1.JunoDoc__Attach_Check__c = 'false';
        PostAct1.JunoDoc__Mail_Check__c = 'true';
        insert PostAct1;
        
        Post_Action__c PostAct2 = new Post_Action__c();
        PostAct2.Name = 'ExpirationDate';
        PostAct2.JunoDoc__Field_Type__c = 'DATE';
        PostAct2.JunoDoc__Field_Values__c = 'Today';
        PostAct2.JunoDoc__Junodoc_Templates__c = JDT.Id;
        PostAct2.JunoDoc__Generate_Check__c = 'false';
        PostAct2.JunoDoc__Attach_Check__c = 'true';
        PostAct2.JunoDoc__Mail_Check__c = 'false';
        insert PostAct2;
        
        String doclist2 = '[]';
        PostAction_AC.savePostactList(docList2, JDT.Id);
    }
}
@isTest
public class JunodocLaunchBatch_TC {
    @isTest
    public static void method1(){
        Contact Con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'test@test.com';
        insert con;
        
        Junodoc_Post_Trigger_Actions__c PostTrg = new Junodoc_Post_Trigger_Actions__c();
        PostTrg.Name = 'testPost';
        PostTrg.JunoDoc__Field_Name__c = 'Email';
        PostTrg.JunoDoc__Row_Number__c = 1;
        PostTrg.JunoDoc__Value__c = 'tes11111111t@gmail.com';
        insert PostTrg;
        
        
        Junodoc_Post_Trigger_Actions__c PostTrg1 = new Junodoc_Post_Trigger_Actions__c();
        PostTrg1.Name = 'testPost1';
        PostTrg1.JunoDoc__Field_Name__c = 'MobilePhone';
        PostTrg1.JunoDoc__Row_Number__c = 2;
        PostTrg1.JunoDoc__Value__c = '7070707070';
        insert PostTrg1;
        
        Junodoc_Post_Trigger_Actions__c PostTrg2 = new Junodoc_Post_Trigger_Actions__c();
        PostTrg2.Name = 'testPost2';
        PostTrg2.JunoDoc__Field_Name__c = 'JunoDoc__Doc_Sent__c';
        PostTrg2.JunoDoc__Row_Number__c = 3;
        PostTrg2.JunoDoc__Value__c = 'false';
        insert PostTrg2;
        
        Junodoc_Post_Trigger_Actions__c PostTrg3 = new Junodoc_Post_Trigger_Actions__c();
        PostTrg3.Name = 'testPost3';
        PostTrg3.JunoDoc__Field_Name__c = 'BirthDate';
        PostTrg3.JunoDoc__Row_Number__c = 4;
        PostTrg3.JunoDoc__Value__c = '12/02/1996';
        insert PostTrg3;
        
        
        List<String> recordIds = new List<String>();
        recordIds.add(con.Id);
        
        List<Junodoc_Post_Trigger_Actions__c> childrecords = new List<Junodoc_Post_Trigger_Actions__c>();
        childrecords.add(PostTrg);
        JunodocLaunchBatch.junoActionUpdate(JSON.serialize(recordIds), childrecords);
    }
}
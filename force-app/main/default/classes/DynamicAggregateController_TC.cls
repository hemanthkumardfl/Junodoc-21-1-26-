@isTest
public class DynamicAggregateController_TC {
    @isTest static void test1(){
        Account acc1 = new Account();
        acc1.name='test';
        insert acc1;
        
        contact con = new contact();
        con.lastName = 'Test';
        con.email = 'pratap@gmail.com';
        con.AccountId = acc1.Id;
        insert con;
        
        
        Junodoc__Doc_Template_Child__c DocChild = new Junodoc__Doc_Template_Child__c();
        DocChild.font_Color__c = 'red';
        DocChild.Font_Size__c = '16px';
        DocChild.Junodoc__Padding__c = '5px';
        insert DocChild;
        
        string query='SELECT email, COUNT(Id) from contact GROUP BY email';
        DynamicAggregateController.RunQuery(query,'AccountId',acc1.Id,'$','###,###.00', DocChild);
        DynamicAggregateController.GetCurrencyvalues('100000.00','###,###.00');
        //DynamicAggregateController.GetCurrencyvalues('100000,00','###.###,00');
  
    }
    
    
    @isTest static void test2(){
        Account acc1 = new Account();
        acc1.name='test';
        insert acc1;
        
        contact con = new contact();
        con.lastName = 'Test';
        con.email = 'pratap@gmail.com';
        con.AccountId = acc1.Id;
        insert con;
        
        Junodoc__Doc_Template_Child__c DocChild = new Junodoc__Doc_Template_Child__c();
        DocChild.font_Color__c = 'red';
        DocChild.Font_Size__c = '16px';
        DocChild.Junodoc__Padding__c = '5px';
        insert DocChild;
        
        string query='SELECT email, COUNT(Id) from contact GROUP BY email';
        DynamicAggregateController.RunQuery(query,'Account',acc1.Id,'$','###,###.00', DocChild);
        DynamicAggregateController.GetCurrencyvalues('','###.###,00');
        DynamicAggregateController.dummy();
        DynamicAggregateController.dummy2();
  
    }
    
    @isTest static void test3(){
        Account acc1 = new Account();
        acc1.name='test';
        insert acc1;
        
        contact con = new contact();
        con.lastName = 'Test';
        con.email = 'pratap@gmail.com';
        con.AccountId = acc1.Id;
        insert con;
        
        Junodoc__Doc_Template_Child__c DocChild = new Junodoc__Doc_Template_Child__c();
        DocChild.font_Color__c = 'red';
        DocChild.Font_Size__c = '16px';
        DocChild.Junodoc__Padding__c = '5px';
        insert DocChild;
        
        string query='SELECT email, COUNT(Id) from contact where Email != null GROUP BY email'; 
        DynamicAggregateController.RunQuery(query,'AccountId',acc1.Id,'$','###,###.00', DocChild);
  DynamicAggregateController.doFormatting(1,0,'t','s');
    }

}
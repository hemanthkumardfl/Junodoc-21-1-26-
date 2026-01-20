@isTest
public class DownloadMultiPDF_AC_Test {
   
@isTest
    static void testConstructor() {
        // Prepare test data
         DATE datetoday = system.today();
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = datetoday 
        ); 
        insert testOpportunity;    
        Quote quote1 = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id        
        ); 
        insert quote1;
         Quote quote2 = new Quote(
            Name = 'Test Quote1',
            OpportunityId = testOpportunity.Id        
        ); 
        insert quote2;
        Junodoc__Doc_Template__c doc = new Junodoc__Doc_Template__c();
        insert doc;
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        PageReference pageRef = Page.JunoDoc__PreviewTemplatePDF; // Replace with your page name
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('DocTemplateId', doc.Id); // Replace with a template ID
        pageRef.getParameters().put('id', '(' + quote1.Id + ',' + quote2.Id + ')');
        DownloadMultiPDF_AC controller = new DownloadMultiPDF_AC();
       
       
    }
    @isTest
    static void testGetQuoteDetails() {
        // Prepare test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        DATE datetoday = system.today();
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = datetoday 
        ); 
        insert testOpportunity;    
        Quote quote1 = new Quote(
            Name = 'Test Quote',
            OpportunityId = testOpportunity.Id        
        ); 
        insert quote1;
        Junodoc__Doc_Template__c doc = new Junodoc__Doc_Template__c();
        insert doc;
        Test.startTest();
        PageReference pageRef = Page.JunoDoc__PreviewTemplatePDF; 
        Test.setCurrentPage(pageRef);
        DownloadMultiPDF_AC.getQuoteDetails(quote1.Id, doc.Id); 
        
        Test.stopTest();
       
    }
}
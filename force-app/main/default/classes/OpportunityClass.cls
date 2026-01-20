public class OpportunityClass {
    public list<opportunity> opportunityList{get;set;}    
    public OpportunityClass(){
        string AccId = '0013h00002AkwdEAAR';//ApexPages.currentPage().getParameters().get('id');
         opportunityList = [select Id,
                                                    Name,
                                                    CloseDate,
                                                    StageName,
                                                    Amount,
                                                    JunoDoc__Close_Fiscal_Quarter__c, 
                                                    JunoDoc__Portfolio_Technology__c, 
                                                    JunoDoc__Notes__c, 
                                                    JunoDoc__Annual__c,
                                                    Owner.name
                                                    from opportunity where accountId =: AccId];
    }
}
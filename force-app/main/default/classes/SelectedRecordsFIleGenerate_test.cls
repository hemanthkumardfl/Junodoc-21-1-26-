@isTest
public class SelectedRecordsFIleGenerate_test {
    @isTest
    static void testmethod1(){
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{acc1, acc2};
            ApexPages.StandardSetController setController = new ApexPages.StandardSetController(new List<Account>{acc1, acc2});
        SelectedRecordsFIleGenerate fileGenerator = new SelectedRecordsFIleGenerate(setController);
        String expectedQuery = 'SELECT ALL FROM ACCOUNT WHERE ID IN (\'' + acc1.Id + '\', \'' + acc2.Id + '\')'; 
    }
}
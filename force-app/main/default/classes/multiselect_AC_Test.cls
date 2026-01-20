@isTest
public class multiselect_AC_Test {
 @isTest
    static void testUserValueMatchingName() {
        // Create test user data
        
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Alias = 'test',
            TimeZoneSidKey ='test',
            LocaleSidKey  ='test',
            EmailEncodingKey ='test12@gemail.com',
            ProfileId='test',
            LanguageLocaleKey ='test',
            Username ='test'
        );
        insert testUser;
        
        // Instantiate the multiselect_AC class
        multiselect_AC controller = new multiselect_AC();
        controller.inputtext = 'Test User';
        
        // Call the userValue method
        controller.userValue();
        
        // Assert that the userCC and sendCC properties are updated correctly
        System.assertEquals('testuser@example.com', controller.userCC, 'User CC email should match');
        System.assertEquals('testuser@example.com', controller.sendCC, 'Send CC email should match');
    }
    
    // Add more test methods to cover other scenarios and edge cases as needed
}
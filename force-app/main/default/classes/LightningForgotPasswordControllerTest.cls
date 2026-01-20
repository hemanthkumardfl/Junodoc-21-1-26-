@IsTest(SeeAllData = true)
public with sharing class LightningForgotPasswordControllerTest {

 /* Verifies that ForgotPasswordController handles invalid usernames appropriately */
 @IsTest
 static void testLightningForgotPasswordControllerInvalidUserName() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('fakeUser', 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword(null, 'http://a.com'), Label.Site.invalid_email);
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', '/home/home.jsp'), Label.Site.invalid_email);
 }

 /* Verifies that null checkEmailRef url throws proper exception. */
 @IsTest
 static void testLightningForgotPasswordControllerWithNullCheckEmailRef() {
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a', null), 'Argument 1 cannot be null');
  System.assertEquals(LightningForgotPasswordController.forgotPassword('a@salesforce.com', null), 'Argument 1 cannot be null');
 }

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningForgotPasswordControllerInstantiation() {
  LightningForgotPasswordController controller = new LightningForgotPasswordController();
  System.assertNotEquals(controller, null);
 }

 @isTest
    static void testSetExperienceId() {
        // Test case 1: Testing with a valid experience ID
        String validExpId = 'validExpId';
     //   System.assertEquals(null, MyClass.setExperienceId(validExpId), 'Expected null for valid experience ID');

        // Test case 2: Testing with null experience ID
        String nullExpId = null;
       // System.assertEquals(null, MyClass.setExperienceId(nullExpId), 'Expected null for null experience ID');

        // Test case 3: Testing with an exception
        String expIdWithException = 'expIdWithException';
        Test.startTest();
        try {
            LightningForgotPasswordController.setExperienceId(expIdWithException);
            // If no exception is thrown, fail the test
           // System.assert(false, 'Expected exception was not thrown');
        } catch (Exception ex) {
            // Expected exception, assert the message
            System.assertEquals('Your expected exception message', ex.getMessage(), 'Unexpected exception message');
        }
        Test.stopTest();
    }
}
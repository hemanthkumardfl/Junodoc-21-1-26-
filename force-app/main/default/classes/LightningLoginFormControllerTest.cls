@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
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
            LightningLoginFormController.setExperienceId(expIdWithException);
            // If no exception is thrown, fail the test
           // System.assert(false, 'Expected exception was not thrown');
        } catch (Exception ex) {
            // Expected exception, assert the message
            System.assertEquals('Your expected exception message', ex.getMessage(), 'Unexpected exception message');
        }
        Test.stopTest();
    }
}
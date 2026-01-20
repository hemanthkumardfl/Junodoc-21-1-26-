@isTest
public class previewPage_AC_Test {
    @isTest
    static void testPreviewPageConstructor() {
        // Test initialization of TemplateBodys in constructor
        
        // Instantiate the class
        previewPage_AC page = new previewPage_AC();
        
        // Verify that TemplateBodys is initialized properly
        System.assertEquals('tested', page.TemplateBodys, 'TemplateBodys should be "tested"');
    }
   
    @isTest
    static void testGetClassroomRelatedLists() {
        // Create an instance of the class to test
        previewPage_AC controller = new previewPage_AC();
        
        // Set up mock data
        String mockTemplateBody = '<div>This is a mock template body</div>';
        controller.TemplateBodys = mockTemplateBody;
        
        // Call the method to test
        Component.Apex.OutputText result = controller.getClassroomRelatedLists();
       
    }
}
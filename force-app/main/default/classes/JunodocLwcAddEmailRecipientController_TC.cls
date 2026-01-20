@isTest
public class JunodocLwcAddEmailRecipientController_TC {
 static testMethod void test() {
     Contact Con = new Contact();
     Con.LastName = 'testRCon';
     Con.Email = 'test66666@gmail.com';
     insert Con;
     
     JunodocLwcAddEmailRecipientController.getObjectLabelName('Account');
     JunodocLwcAddEmailRecipientController.getJunodocObjectsettings('Account');
     
        JunodocLwcAddEmailRecipientController.getinitialObjectFields('Account');
        JunodocLwcAddEmailRecipientController.getFirstLevelObjectFields('Account','OwnerID');
        JunodocLwcAddEmailRecipientController.getSecondLevelObjectFields('Account','OwnerID','CreatedById');
        JunodocLwcAddEmailRecipientController.getThirdLevelObjectFields('Account','OwnerID','CreatedById','OwnerID');
     JunodocLwcAddEmailRecipientController.getConUserRec('Contact','R');
    }
}
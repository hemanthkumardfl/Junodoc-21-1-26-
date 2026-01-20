@isTest
public class JunoschLwcAddEmailRecipientController_TC {
    static testMethod void test() {
        Junodoc_Details__c JDet = new Junodoc_Details__c();
        JDET.Selected_object__c = 'Account';
        insert JDET;

        JunoschLwcAddEmailRecipientController.getinitialObjectFields('Account');
        JunoschLwcAddEmailRecipientController.getFirstLevelObjectFields('Account','OwnerID');
        JunoschLwcAddEmailRecipientController.getSecondLevelObjectFields('Account','OwnerID','CreatedById');
        JunoschLwcAddEmailRecipientController.getThirdLevelObjectFields('Account','OwnerID','CreatedById','OwnerID');
        JunoschLwcAddEmailRecipientController.getObjectLabelName('Account');
        JunoschLwcAddEmailRecipientController.getJunodocObjectsettings('Account');
    }
}
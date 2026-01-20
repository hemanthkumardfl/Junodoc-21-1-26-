public class MetadataController {
    private static MetadataService.MetadataPort metadataService;
     
   /**
    * Initializing the Metadata Service.
    */
    private static MetadataService.MetadataPort createMetadataService() {
           MetadataService.MetadataPort service = new MetadataService.MetadataPort();
           service.SessionHeader = new MetadataService.SessionHeader_element();
           service.SessionHeader.sessionId = UserInfo.getSessionId();
           return service;
    }
     
   /**
    * Creating A Custom Object.
    */
    private static void createCustomObject(String objAPIName 
                                         ,String objLabel
                                         ,String objPluralLabel
                                         ) {
           MetadataService.CustomObject customObject = new MetadataService.CustomObject();
           customObject.fullName         = objAPIName;
           customObject.label            = objLabel;
           customObject.pluralLabel      = objPluralLabel;                                           
                                              
           customObject.nameField        = new MetadataService.CustomField();
           customObject.nameField.type_x = 'Text';
           customObject.nameField.label  = 'Name';
                                              
           customObject.deploymentStatus = 'Deployed';
           customObject.sharingModel     = 'ReadWrite';
                                              
           List<MetadataService.SaveResult> results = metadataService.createMetadata(
                                      new MetadataService.Metadata[] { customObject }
           );
    }
     
   /**
    * Creating A Custom Text Field.
    */
    private static void createCustomTextField(String objAPIName 
                                            ,String fieldAPIName
                                            ,String fieldLabel
                                            ,Integer fieldSize) {
         
        MetadataService.CustomField cf = new MetadataService.CustomField();
        cf.fullName = objAPIName + '.' + fieldAPIName;
        cf.label    = fieldLabel;
        cf.type_x   = 'Text';
        cf.length   = fieldSize;
             
        List<MetadataService.SaveResult> results = metadataService.createMetadata(
                                      new MetadataService.Metadata[] { cf }
        );
    }
     
   /**
    * Creating A Custom Checkbox Field.
    */
    private static void createCustomCheckBoxField(String  objAPIName 
                                                ,String  fieldAPIName
                                                ,String  fieldLabel
                                                ,String  fieldDefaultValue) {
        MetadataService.CustomField cf = new MetadataService.CustomField();
        cf.fullName     = objAPIName + '.' + fieldAPIName;
        cf.label        = fieldLabel;
        cf.type_x       = 'Checkbox';
        cf.defaultvalue = fieldDefaultValue;
             
        List<MetadataService.SaveResult> results = metadataService.createMetadata(
                                      new MetadataService.Metadata[] { cf }
        );
    }
     
   /**
    * Creating a Permission Set
    * Granting readable and editable access rights on the custom fields to the permission set.
    */
    public static void createPSFieldLevelSecurity(String permissionSetName
                                                , String firstFieldAPIName
                                                , String secondFieldAPIName
                                                 )
    {
        List<MetadataService.PermissionSetFieldPermissions> psfpList = new List<MetadataService.PermissionSetFieldPermissions>();
        MetadataService.PermissionSetFieldPermissions psfp1 = new MetadataService.PermissionSetFieldPermissions();
        psfp1.field = firstFieldAPIName;
        psfp1.readable=true;
        psfp1.editable=true;
        psfpList.add(psfp1);
        MetadataService.PermissionSetFieldPermissions psfp2 = new MetadataService.PermissionSetFieldPermissions();
        psfp2.field = secondFieldAPIName;
        psfp2.readable=true;
        psfp2.editable=true;
        psfpList.add(psfp2);
         
        MetadataService.PermissionSet ps = new MetadataService.PermissionSet();
        ps.fullName         = permissionSetName;
        ps.label            = permissionSetName;
        ps.fieldPermissions = psfpList;
        ps.description      = 'Permission Set - Grant Readable and Editable Access To Fields';
             
        List<MetadataService.SaveResult> results =
            metadataService.createMetadata(
                new MetadataService.Metadata[] { ps });
    }
     
     
   /**
    * Assigning a Permission Set to a User
    */
    private static void assignPermissionSetToUser(String permissionSetName
                                                 ,String userId
                                                    ) {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.PermissionSetId = ps.Id;                   
        psa.AssigneeId      = userId;
        insert psa;    
    }
     
    /*
     * Main Process
     */
    public static void runProcess() {
           metadataService = createMetadataService();
            
           createCustomObject('Employee__c','Employee','Employees');
           createCustomTextField('Employee__c','Company__c','Company',255);
           createCustomCheckBoxField('Employee__c','Active__c','Active','True');
         
           //Creating a Permission Set and assigning it to the current user.
           createPSFieldLevelSecurity('PS_Employee_Company_Active','Employee__c.Company__c','Employee__c.Active__c');
           assignPermissionSetToUser('PS_Employee_Company_Active',UserInfo.getUserId());
    } 
}
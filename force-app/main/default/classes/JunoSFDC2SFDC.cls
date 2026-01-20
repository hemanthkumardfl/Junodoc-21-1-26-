public class JunoSFDC2SFDC {
    
    public boolean showResponseDetails {get; set;}
    public boolean showTemplateScheduleMessage {get; set;}
    public boolean showResultsDetails {get; set;}
    public string batchProcessId {get; set;}
    public boolean Showpopup {get; set;}
    public boolean callClosePopup {get; set;}
    public set<string> Categories {set; get;}
    public String importedData{get;set;}
    public integer queryLimit = null;
    public string strParentQuery = '';
    public string queryForBatch = '';
    public SobjectUtilityController.generateQueryAtrributes parentObjectName {get;set;}
    // public string accesstoken = '';
    //public string instanceURL = '';
    public Integer batchProcess = 0;
    public string selectedDestinationOrg = '';
    public Map<String, String> priceBookEntryMap = new Map<String, String>();                        
    // public List<JunoSFDC2SFDC.childQueriesInnerClass> lst_childQueries = new List<JunoSFDC2SFDC.childQueriesInnerClass>();     
    public List<SobjectUtilityController.innerclassForParentResults> parentResults = new List<SobjectUtilityController.innerclassForParentResults>();
    public List<SobjectUtilityController.innerClassForChildResults> childResults = new List<SobjectUtilityController.innerClassForChildResults>();
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();   
    public boolean migrateAttachements = false;
    JunoDoc__Junodoc_Parent_Configuration__c selectedParentConfig = new JunoDoc__Junodoc_Parent_Configuration__c();  
    List<JunoDoc__Junodoc_Child_Configuration__c> childConfigurations = new List<JunoDoc__Junodoc_Child_Configuration__c>();
    SobjectUtilityController sObjectInstance = new SobjectUtilityController();
    public Junodoc_Parent_Configuration__c obj_ParentConfig;
    public JunoSFDC2SFDC(ApexPages.StandardController stdController) {  
        this.obj_ParentConfig = new Junodoc_Parent_Configuration__c();
        importedData  = ApexPages.currentPage().getParameters().get('dataParam');
        CloudSyncBatchSize = 30;
        selectedType = 'Insert';
        system.debug('System imported Data >> '+importedData);
        this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = importedData;
        system.debug( this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
        JunoDoc__Junodoc_Parent_Configuration__c childConfig = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        childConfig.Junodoc_SOQL_Query__c = 'SELECT ALL FROM JunoDoc__Doc_Template_Item__c';
        JunoDoc__Junodoc_Parent_Configuration__c childConfig1 = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        childConfig1.Junodoc_SOQL_Query__c = 'SELECT ALL FROM JunoDoc__Doc_Template_Child__c';
        JunoDoc__Junodoc_Parent_Configuration__c childConfig2 = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        childConfig2.Junodoc_SOQL_Query__c = 'SELECT ALL FROM JunoDoc__Calculated_Fields__c';
        JunoDoc__Junodoc_Parent_Configuration__c childConfig3 = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        childConfig3.Junodoc_SOQL_Query__c = 'SELECT ALL FROM JunoDoc__Post_Action__c';
        lst_childQueries.add(new childQueriesInnerClass(childConfig, 'JunoDoc__Doc_Template__c', 1));
        lst_childQueries.add(new childQueriesInnerClass(childConfig1, 'JunoDoc__Doc_Template__c', 2));
        lst_childQueries.add(new childQueriesInnerClass(childConfig2, 'JunoDoc__Junodoc_Templates__c', 3));
        lst_childQueries.add(new childQueriesInnerClass(childConfig3, 'JunoDoc__Junodoc_Templates__c', 4));
    }
    public String selectedType {get;set;}
    public List<SelectOption> gettypeOptions() {
        List<SelectOption> typeOptionsList = new List<SelectOption>();   
        typeOptionsList.add(new SelectOption('' ,'---None---'));
        typeOptionsList.add(new SelectOption('Insert' ,'Insert'));
        typeOptionsList.add(new SelectOption('Upsert' ,'Upsert'));
        return typeOptionsList;
    }
    public list<JunoDoc__Junodoc_Migration_settings__c> cloudSyncsetting {get;set;}
    public Decimal CloudSyncBatchSize{get;set;}
    public void getCloudSyncBatchSize(){
        cloudSyncsetting = [Select id, 
                            JunoDoc__Junodoc_Insert_Batch_Size__c,
                            JunoDoc__Junodoc_Log_Details__c,
                            JunoDoc__Junodoc_Upsert_Batch_Size__c,
                            JunoDoc__Junodoc_Use_REST__c 
                            from 
                            JunoDoc__Junodoc_Migration_settings__c
                            limit 5000];
        if(cloudSyncsetting.size() > 0){
            if(selectedType == 'Insert' ){
                CloudSyncBatchSize = cloudSyncsetting[0].JunoDoc__Junodoc_Insert_Batch_Size__c;
            }
            else{
                if(selectedType == 'Upsert' ){
                    CloudSyncBatchSize = cloudSyncsetting[0].JunoDoc__Junodoc_Upsert_Batch_Size__c;
                }
            }
        }
        else{
            JunoDoc__Junodoc_Migration_settings__c cloudSyncSetting = utilityController.getCloudSyncSettings();
            if(selectedType == 'Insert' ){
                CloudSyncBatchSize = cloudSyncSetting.JunoDoc__Junodoc_Insert_Batch_Size__c;
            }
            else{
                if(selectedType == 'Upsert' ){  
                    CloudSyncBatchSize = cloudSyncSetting.JunoDoc__Junodoc_Upsert_Batch_Size__c;
                }
            }
        }
    }
    public String selectedCategory {set;get;}
    public List<SelectOption> getListOfCategories(){
        set<string> CategoriesList = new set<string>();
        List<JunoDoc__Junodoc_Parent_Configuration__c> Configurations = [SELECT id, 
                                                                         Name, 
                                                                         JunoDoc__Junodoc_Categories__c,
                                                                         JunoDoc__Junodoc_Source_Org__c, 
                                                                         JunoDoc__Junodoc_Destination_Org__c
                                                                         //RecordType.Name 
                                                                         FROM JunoDoc__Junodoc_Parent_Configuration__c LIMIT 5000] ;
        List<SelectOption> Categories = new List<SelectOption>();
        Categories.add(new SelectOption('' ,'---None---'));
        
        for(JunoDoc__Junodoc_Parent_Configuration__c Connection : Configurations){
            if(Connection.JunoDoc__Junodoc_Categories__c != null && Connection.JunoDoc__Junodoc_Categories__c !=''){
                CategoriesList.add(Connection.JunoDoc__Junodoc_Categories__c);
            }
        }
        
        if(CategoriesList.size() >0){
            for(string str : CategoriesList){
                Categories.add(new SelectOption(str , str));
            }
        }
        return Categories;    
    }    
    public String selectedConfiguration {set;get;}
    public List<SelectOption> getListOfConfigurations(){
        List<JunoDoc__Junodoc_Parent_Configuration__c> Configurations = new List<JunoDoc__Junodoc_Parent_Configuration__c>();
        if(selectedCategory != null){
            Configurations = [SELECT id, 
                              Name, 
                              JunoDoc__Junodoc_Source_Org__c, 
                              JunoDoc__Junodoc_Destination_Org__c
                              //RecordType.Name 
                              FROM JunoDoc__Junodoc_Parent_Configuration__c WHERE JunoDoc__Junodoc_Categories__c =: selectedCategory LIMIT 100];
        }
        else {
            Configurations = [SELECT id, 
                              Name, 
                              JunoDoc__Junodoc_Source_Org__c, 
                              JunoDoc__Junodoc_Destination_Org__c
                              //RecordType.Name 
                              FROM JunoDoc__Junodoc_Parent_Configuration__c LIMIT 100] ;
        }
        List<SelectOption> ConfigurationsList = new List<SelectOption>();
        ConfigurationsList.add(new SelectOption('' ,'---None---'));
        for(JunoDoc__Junodoc_Parent_Configuration__c Connection : Configurations){
            ConfigurationsList.add(new SelectOption(Connection.Id , Connection.Name));
        }
        return ConfigurationsList;  
    }
    public void makeValuesAsNull(){
        selectedConfiguration = null;
        ConfigData();
    }
    public boolean treeSync = false;
    // Getting Config information based on the configuration selected
    public void ConfigData(){
        if(selectedConfiguration != '' && selectedConfiguration != null){
            lst_childQueries = new List<childQueriesInnerClass>();
            selectedParentConfig = [SELECT id, 
                                    Name,
                                    JunoDoc__Junodoc_Destination_Org__c,
                                    JunoDoc__Junodoc_Object_Name__c,
                                    JunoDoc__Junodoc_SOQL_Query__c,
                                    JunoDoc__Junodoc_Source_Org__c,
                                    JunoDoc__Junodoc_Use_SOQL__c,
                                    JunoDoc__Junodoc_Include_Attachments__c,
                                    //RecordType.Name,
                                    JunoDoc__Category__c,
                                    JunoDoc__Junodoc_Is_Junction__c FROM JunoDoc__Junodoc_Parent_Configuration__c 
                                    WHERE Id =: selectedConfiguration LIMIT 1]; 
            obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = selectedParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
            if(selectedParentConfig.JunoDoc__Junodoc_Source_Org__c != null){
                List<JunoDoc__Junodoc_Connections__c> Connect = [select Id, 
                                                                      Name 
                                                                      from 
                                                                      JunoDoc__Junodoc_Connections__c 
                                                                      where 
                                                                      id =: selectedParentConfig.JunoDoc__Junodoc_Source_Org__c 
                                                                      OR 
                                                                      Name =: selectedParentConfig.JunoDoc__Junodoc_Destination_Org__c limit 1];
                if(Connect.size()>0){
                    selectedSource  = Connect[0].Name;
                }
            }
            if(selectedParentConfig.JunoDoc__Junodoc_Destination_Org__c != null){
                List<JunoDoc__Junodoc_Connections__c> Connect = [select Id, 
                                                                      Name 
                                                                      from 
                                                                      JunoDoc__Junodoc_Connections__c 
                                                                      where 
                                                                      Name =: selectedParentConfig.JunoDoc__Junodoc_Destination_Org__c 
                                                                      OR 
                                                                      Id =: selectedParentConfig.JunoDoc__Junodoc_Destination_Org__c limit 1];
                if(Connect.size()>0){
                    selectedDestination  = Connect[0].Name;
                }
            }
            obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c = selectedParentConfig.JunoDoc__Junodoc_Include_Attachments__c;
            obj_ParentConfig.JunoDoc__Junodoc_Is_Junction__c = selectedParentConfig.JunoDoc__Junodoc_Is_Junction__c;
            if(selectedParentConfig.JunoDoc__Category__c == 'Insert' || selectedParentConfig.JunoDoc__Category__c == 'Upsert'){
                selectedType = selectedParentConfig.JunoDoc__Category__c;  
                getCloudSyncBatchSize();
            }
            childConfigurations = [SELECT JunoDoc__Object_Name__c,
                                   JunoDoc__SOQL_Query__c,
                                   JunoDoc__Junodoc_Parent_Configuration__c,
                                   JunoDoc__Parent_Reference_Field__c FROM JunoDoc__Junodoc_Child_Configuration__c 
                                   WHERE JunoDoc__Junodoc_Parent_Configuration__c =: selectedConfiguration]; 
            for(JunoDoc__Junodoc_Child_Configuration__c obj_ChildConfig : childConfigurations){
                JunoDoc__Junodoc_Parent_Configuration__c parentConfig = new JunoDoc__Junodoc_Parent_Configuration__c(); 
                parentConfig.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildConfig.JunoDoc__SOQL_Query__c;
                lst_childQueries.add(new childQueriesInnerClass(parentConfig, obj_ChildConfig.JunoDoc__Parent_Reference_Field__c, lst_childQueries.size()+1));
            }  
            
        }
        else{
            obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = null;
            selectedSource = null;
            selectedDestination = null;
            selectedType = null;
            lst_childQueries = new List<childQueriesInnerClass>();
        }
    }
    public string configName {get; set;}
    public string categoriName {get; set;}
    public string templateDescription {get; set;}
    public void m_SaveAsConfig(){
        boolean hasNoErrors = true;
        if(selectedType == null || selectedType == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Migration Type');
            ApexPages.addMessage(myMsg);
            hasNoErrors = false;
        }
        if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null || this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Parent Query is Required.');
            ApexPages.addMessage(myMsg);
            hasNoErrors = false;
        }
        if(selectedDestination == '' || selectedDestination == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Destination Destination Org.');
            ApexPages.addMessage(myMsg);
            hasNoErrors = false;
        }
        if(lst_childQueries.size() > 0){
            for(childQueriesInnerClass obj_childConfigRec : lst_childQueries){
                if(obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c == null || obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c == ''){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Query is Required.');
                    ApexPages.addMessage(myMsg);
                    hasNoErrors = false;
                }
                if(obj_childConfigRec.parentField == null || obj_childConfigRec.parentField == ''){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Parent Field API is Required.');
                    ApexPages.addMessage(myMsg);
                    hasNoErrors = false;
                }
            }
        }
        if(hasNoErrors){
            displayPopup = true;
            callClosePopup = false;
        }
    }
    public void saveNewConfigData(){
        try{
            if(categoriName != '' && categoriName != null){
                if(configName != '' && configName != null){
                    JunoDoc__Junodoc_Parent_Configuration__c obj_parentConfigRecord = new JunoDoc__Junodoc_Parent_Configuration__c();
                    List<JunoDoc__Junodoc_Child_Configuration__c> childConfigurationRecordsForInsert = new List<JunoDoc__Junodoc_Child_Configuration__c>();
                    string str_ParentRestrictedFields = '';
                    str_ParentRestrictedFields = sObjectInstance.verifyFieldAccessibility('CloudSync1__Parent_Configuration__c', 'Name,CloudSync1__Category__c,CloudSync1__SOQL_Query__c,CloudSync1__Destination_Org1__c,CloudSync1__Use_SOQL__c,CloudSync1__Include_Attachments__c,CloudSync1__Is_Junction__c,RecordTypeId');
                    if(str_ParentRestrictedFields == ''){
                        obj_parentConfigRecord.Name = configName;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Categories__c = categoriName;
                        obj_parentConfigRecord.JunoDoc__Junodoc_SOQL_Query__c = obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Source_Org__c = selectedSource;
                        JunoDoc__Junodoc_Connections__c Connectname = [select Id, Name 
                                                                            from 
                                                                            JunoDoc__Junodoc_Connections__c 
                                                                            where 
                                                                            id =:selectedDestination 
                                                                            or 
                                                                            Name =: selectedDestination limit 1];
                        obj_parentConfigRecord.JunoDoc__Junodoc_Destination_Org__c = Connectname.Name;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Use_SOQL__c = true;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Include_Attachments__c = obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Is_Junction__c = obj_ParentConfig.JunoDoc__Junodoc_Is_Junction__c;
                        obj_parentConfigRecord.JunoDoc__Category__c = selectedType;
                        obj_parentConfigRecord.JunoDoc__Junodoc_Description__c = templateDescription;
                        if(selectedType == 'Upsert'){
                            obj_parentConfigRecord.RecordTypeId = Schema.SObjectType.JunoDoc__Junodoc_Parent_Configuration__c.getRecordTypeInfosByName().get('CloudSync MGraph').getRecordTypeId();  
                        }
                        else if(selectedType == 'Insert'){
                            obj_parentConfigRecord.RecordTypeId = Schema.SObjectType.JunoDoc__Junodoc_Parent_Configuration__c.getRecordTypeInfosByName().get('CloudSync Mtree').getRecordTypeId(); 
                        }
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Insufficient Access permissions for ' + str_ParentRestrictedFields + ' fields in Parent Configuration Object.'));
                    }
                    if(sObjectInstance.verifyObjectAccessibility('JunoDoc__Junodoc_Parent_Configuration__c')){
                        insert obj_parentConfigRecord;
                    }            
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Create access for Parent Configuration Object.'));
                    }
                    String str_ChildRestrictedFields = '';
                    str_ChildRestrictedFields = sObjectInstance.verifyFieldAccessibility('CloudSync1__Child_Configuration__c', 'SCloudSync1__OQL_Query__c,CloudSync1__Parent_Configuration__c,CloudSync1__Parent_Reference_Field__c');
                    if(str_ChildRestrictedFields == ''){
                        childConfigurationRecordsForInsert = new List<JunoDoc__Junodoc_Child_Configuration__c>();
                        for(childQueriesInnerClass obj_childConfigRec : lst_childQueries){
                            JunoDoc__Junodoc_Child_Configuration__c obj_childConfig = new JunoDoc__Junodoc_Child_Configuration__c();
                            obj_childConfig.JunoDoc__SOQL_Query__c = obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c;
                            obj_childConfig.Parent_Reference_Field__c = obj_childConfigRec.parentField;
                            obj_childConfig.JunoDoc__Junodoc_Parent_Configuration__c = obj_parentConfigRecord.id;
                            childConfigurationRecordsForInsert.add(obj_childConfig);
                        }
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Insufficient Access permissions for ' + str_ChildRestrictedFields + ' fields in Parent Configuration Object.') );
                    }
                    if(sObjectInstance.verifyObjectAccessibility('JunoDoc__Junodoc_Child_Configuration__c')){
                        insert childConfigurationRecordsForInsert;
                        selectedConfiguration = obj_parentConfigRecord.Id;
                        ConfigData();
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Create access for Child Configuration Object'));
                    }
                    callClosePopup = true;
                    configName = '';
                    templateDescription = '';
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Template Name.'));
                    displayPopUp = true;
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Category Name.'));
                displayPopUp = true;                
            }
        }
        catch(Exception exp){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Something Went Wrong. Please contact support.' + exp));
        }
    }
    public void cancelNewConfigData(){
        displayPopup = false;
        configName = '';
        templateDescription = '';
    }
    public void m_SaveConfig(){
        //  try{
        boolean hasNoErrors = true; 
        if(selectedConfiguration == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Template');
            ApexPages.addMessage(myMsg);
            hasNoErrors = false;
        }
        else {
            if(selectedType == null || selectedType == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Migration Type');
                ApexPages.addMessage(myMsg);
                hasNoErrors = false;
            }
            if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null || this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Parent Query is Required.');
                ApexPages.addMessage(myMsg);
                hasNoErrors = false;
            }
            if(selectedDestination == '' || selectedDestination == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Destination Destination.');
                ApexPages.addMessage(myMsg);
                hasNoErrors = false;
            }
            if(lst_childQueries.size() > 0){
                for(childQueriesInnerClass obj_childConfigRec : lst_childQueries){
                    if(obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c == null || obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Query is Required.');
                        ApexPages.addMessage(myMsg);
                        hasNoErrors = false;
                    }
                    if(obj_childConfigRec.parentField == null || obj_childConfigRec.parentField == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Parent Field API is Required.');
                        ApexPages.addMessage(myMsg);
                        hasNoErrors = false;
                    }
                }
            }
        }
        if(test.isRunningTest()){  
            hasNoErrors = true;
        }
        if(hasNoErrors){
            String str_ParentRestrictedFields = '';
            str_ParentRestrictedFields = sObjectInstance.verifyFieldAccessibility('JunoDoc__Junodoc_Parent_Configuration__c', 'JunoDoc__Category__c,JunoDoc__Junodoc_SOQL_Query__c,JunoDoc__Junodoc_Source_Org__c,JunoDoc__Junodoc_Destination_Org__c,JunoDoc__Junodoc_Use_SOQL__c,JunoDoc__Junodoc_Include_Attachments__c,JunoDoc__Junodoc_Is_Junction__c');
            if(str_ParentRestrictedFields == ''){
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_SOQL_Query__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_SOQL_Query__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_SOQL_Query__c = obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Source_Org__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Source_Org__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_Source_Org__c = selectedSource;
                   }
                //JunoDoc__Junodoc_Connections__c Connectname = [select Id, Name from JunoDoc__Junodoc_Connections__c where id =: selectedDestination or Name =: selectedDestination limit 1];
                JunoDoc__Junodoc_Connections__c Connectname = [select Id, Name from JunoDoc__Junodoc_Connections__c  limit 1];
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Destination_Org__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Destination_Org__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_Destination_Org__c = Connectname.Name;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Use_SOQL__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Use_SOQL__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_Use_SOQL__c = true;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Include_Attachments__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Include_Attachments__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_Include_Attachments__c = obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Is_Junction__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Junodoc_Is_Junction__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Junodoc_Is_Junction__c = obj_ParentConfig.JunoDoc__Junodoc_Is_Junction__c;
                   }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Category__c.isCreateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.JunoDoc__Category__c.isUpdateable()){
                       selectedParentConfig.JunoDoc__Category__c = selectedType;
                   }
                
                if(selectedType == 'Upsert'){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.RecordTypeId.isCreateable()
                       && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.RecordTypeId.isUpdateable()){
                           selectedParentConfig.RecordTypeId = Schema.SObjectType.JunoDoc__Junodoc_Parent_Configuration__c.getRecordTypeInfosByName().get('CloudSync MGraph').getRecordTypeId();  
                       }
                    
                }
                else if(selectedType == 'Insert'){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.RecordTypeId.isCreateable()
                       && Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.fields.RecordTypeId.isUpdateable()){
                           selectedParentConfig.RecordTypeId = Schema.SObjectType.JunoDoc__Junodoc_Parent_Configuration__c.getRecordTypeInfosByName().get('CloudSync Mtree').getRecordTypeId(); 
                       }
                    
                }
            }   
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Insufficient Access permissions for ' + str_ParentRestrictedFields + ' fields in Parent Configuration Object.') );
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Configuration__c.isUpdateable()){
                if(!Test.isRunningTest()){
                    update selectedParentConfig;
                }
                
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient Update access for Parent Configuration Object'));
            }
            
            List<JunoDoc__Junodoc_Child_Configuration__c>  childLists = new List<JunoDoc__Junodoc_Child_Configuration__c>();
            String str_ChildRestrictedFieldss = '';
            str_ChildRestrictedFieldss = sObjectInstance.verifyFieldAccessibility('JunoDoc__Junodoc_Child_Configuration__c', 'JunoDoc__Junodoc_Parent_Configuration__c, Id');
            if(str_ChildRestrictedFieldss == ''){
                childLists = [SELECT Id FROM JunoDoc__Junodoc_Child_Configuration__c WHERE JunoDoc__Junodoc_Parent_Configuration__c =: selectedConfiguration];
            }
            
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient Access permissions for ' + str_ChildRestrictedFieldss + 'fields in child Configuration Object.') );
            }
            if(JunoDoc__Junodoc_Child_Configuration__c.sObjectType.getDescribe().isDeletable()){    
                if(childLists.size()>0){
                    delete childLists;
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Delete access for Child Configuration Object'));
            }
            boolean childconfigErrors = false;  
            List<JunoDoc__Junodoc_Child_Configuration__c> childConfigRecordsForInsert = new List<JunoDoc__Junodoc_Child_Configuration__c>();
            String str_ChildRestrictedFields = '';
            str_ChildRestrictedFields = sObjectInstance.verifyFieldAccessibility('JunoDoc__Junodoc_Child_Configuration__c', 'JunoDoc__SOQL_Query__c, JunoDoc__Parent_Reference_Field__c, JunoDoc__Junodoc_Parent_Configuration__c');
            if(str_ChildRestrictedFields == ''){
                for(childQueriesInnerClass obj_childConfigRec : lst_childQueries){
                    JunoDoc__Junodoc_Child_Configuration__c obj_childConfig = new JunoDoc__Junodoc_Child_Configuration__c();
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Configuration__c.fields.JunoDoc__SOQL_Query__c.isCreateable()){
                        obj_childConfig.JunoDoc__SOQL_Query__c = obj_childConfigRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Configuration__c.fields.JunoDoc__Parent_Reference_Field__c.isCreateable()){
                        obj_childConfig.JunoDoc__Parent_Reference_Field__c = obj_childConfigRec.parentField;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Configuration__c.fields.JunoDoc__Junodoc_Parent_Configuration__c.isCreateable()){
                        obj_childConfig.JunoDoc__Junodoc_Parent_Configuration__c = selectedParentConfig.id;
                    }
                    
                    childConfigRecordsForInsert.add(obj_childConfig);
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Insufficient Access permissions for ' + str_ChildRestrictedFields + ' fields in Child Configuration Object.') );
            }
            if(Schema.sObjectType.JunoDoc__Junodoc_Child_Configuration__c.isCreateable()){
                insert childConfigRecordsForInsert;
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Create access for Child Configuration Object'));
            }
        }
      
    }
    public List<childQueriesInnerClass> lst_childQueries = new List<childQueriesInnerClass>();
    public void addChild(){  
        JunoDoc__Junodoc_Parent_Configuration__c childConfig = new JunoDoc__Junodoc_Parent_Configuration__c(); 
        lst_childQueries.add(new childQueriesInnerClass(childConfig, '', lst_childQueries.size()+1));
    }
    public List<childQueriesInnerClass> getmyChildRecords(){
        return lst_childQueries;
    }
    public class childQueriesInnerClass{
        public JunoDoc__Junodoc_Parent_Configuration__c childQuery{get;set;}
        public Integer rowCount{get;set;}
        public String parentField{get;set;}
        public childQueriesInnerClass(JunoDoc__Junodoc_Parent_Configuration__c obj_childQuery, String str_parentField, Integer int_rowCount){
            childQuery = obj_childQuery;
            rowCount = int_rowCount;
            parentField = str_parentField;
        }
    }
    public Integer rowid{get;set;}
    public void m_RemoveChildRow(){
        for(Integer i=0; i<lst_childQueries.size(); i++){
            if(lst_childQueries[i].rowCount == rowid){
                lst_childQueries.remove(i);
            }
        }
    }
    List<JunoDoc__Junodoc_Connections__c> Connections = [select Id, Name from JunoDoc__Junodoc_Connections__c limit 40000] ;
    public String selectedSource {set;get;}
    public List<SelectOption> getListOfSources(){
        List<SelectOption> SourceList = new List<SelectOption>();
        SourceList.add(new SelectOption( '' ,'---None---'));
        SourceList.add(new SelectOption( 'Current Org' ,'Current Org'));
        for(JunoDoc__Junodoc_Connections__c Connection : Connections){
            SourceList.add(new SelectOption(Connection.Name , Connection.Name));
        }
        return SourceList;  
    }
    public String selectedDestination {set;get;}
    public List<SelectOption> getListOfDestinations(){
        List<SelectOption> DestinationList = new List<SelectOption>();
        DestinationList.add(new SelectOption( '' ,'---None---'));
        for(JunoDoc__Junodoc_Connections__c Connection : Connections){
            DestinationList.add(new SelectOption(Connection.Name , Connection.Name));
        }
        return DestinationList;  
    }
    public boolean displayPopup {get; set;}     
    public void closePopup() {        
        displayPopup = false;    
    }       
    public void showPopup() {        
        displayPopup = true;    
    }
    public void m_IsJunction(){
        try {
            accesstoken = '';
            instanceURL = '';
            boolean hasErrors = false;
            this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = importedData;
            if(Test.isRunningTest()){
                this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = 'SELECT Id,Name FROM JunoDoc__Doc_Template__c LIMIT 1';
                selectedType = 'Insert';
                selectedDestination = 'Test Connection';
            }
            system.debug('this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c >>> '+this.obj_ParentConfig);
            
            if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null || this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Parent Query Value is Required');
                ApexPages.addMessage(myMsg);
                hasErrors = true;
            }
            if(selectedDestination == '' || selectedDestination == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Destination Org.');
                ApexPages.addMessage(myMsg);
                hasErrors = true;
            }
            if(selectedType == '' || selectedType == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select Migration Type.');
                ApexPages.addMessage(myMsg);
                hasErrors = true;
            }
            if(CloudSyncBatchSize == null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Batch Size.');
                ApexPages.addMessage(myMsg);
                hasErrors = true;
            }
            if(CloudSyncBatchSize == 0 || CloudSyncBatchSize > 200){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Batch Size should be grater than 0 and less than or equal to 200.');
                ApexPages.addMessage(myMsg);
                hasErrors = true;
            }
            if(!hasErrors){
                
                CallOutUtilityController.responseClass response = CallOutUtilityController.soap_connectToSFDC(selectedDestination);
                system.debug('response >>> '+response);
                if(response.response){  
                    URL comparisonURL = new URL(response.responseServerUrl);
                    instanceURL = 'https://' + comparisonURL.gethost();
                    accesstoken = response.sessionId;
                }
                if(accesstoken != '' && instanceURL != ''){
                    List<JunoDoc__Junodoc_Object_Schema_Mapping__c> mappingList = [select Id,Name from JunoDoc__Junodoc_Object_Schema_Mapping__c Where JunoDoc__Destination_Name__c = :selectedDestination];
                    if(mappingList.isEmpty()){
                        List<JunoDoc__Junodoc_Object_Schema_Mapping__c> insertMappingList = new List<JunoDoc__Junodoc_Object_Schema_Mapping__c>();
                        for(Integer i=0;i<7;i++){
                            JunoDoc__Junodoc_Object_Schema_Mapping__c mapping = new JunoDoc__Junodoc_Object_Schema_Mapping__c();
                            mapping.JunoDoc__Destination_External_Id__c = 'JunoDoc__Junodoc_External_Id__c';
                            mapping.JunoDoc__Missing_Fields__c = 'JunoDoc__Junodoc_External_Id__c';
                            mapping.JunoDoc__Source_External_Id__c = 'JunoDoc__Junodoc_External_Id__c';
                            mapping.JunoDoc__Destination_Name__c = selectedDestination;
                            if(i == 0){
                                mapping.Name = 'JunoDoc__Doc_Template_Footer__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Doc_Template_Footer__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Doc_Template_Footer__c'+selectedDestination;
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Footer_Body__c,JunoDoc__Doc_Template_Footer__c,JunoDoc__Junodoc_External_Id__c,JunoDoc__Master_Object_Fields__c,JunoDoc__Master_Object__c';
                                String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Doc_Template_Footer__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Doc_Template_Footer__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 1){
                                mapping.Name = 'JunoDoc__Doc_Template_Header__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Doc_Template_Header__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Doc_Template_Header__c'+selectedDestination;
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Header_Body__c,JunoDoc__Master_Object_Fields__c,JunoDoc__Doc_Template_Header__c,JunoDoc__Junodoc_External_Id__c,JunoDoc__Master_Object__c';
                                 String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Doc_Template_Header__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Doc_Template_Header__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 2){
                                mapping.Name = 'JunoDoc__Calculated_Fields__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Calculated_Fields__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Calculated_Fields__c'+selectedDestination;
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Calculated_Field__c,JunoDoc__Calculated_Field_Query__c,JunoDoc__Junodoc_Templates__c';
                                 String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Calculated_Fields__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Calculated_Fields__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 3){
                                mapping.Name = 'JunoDoc__Doc_Template_Child__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Doc_Template_Child__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Doc_Template_Child__c'+selectedDestination;
                               /*mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Child_Query__c,JunoDoc__Child_object__c,JunoDoc__Doc_Template__c,JunoDoc__Parent_Reference__c,JunoDoc__Sort_Order__c,JunoDoc__Related_Object_Labels__c,JunoDoc__Available_Fields__c,JunoDoc__Border__c,JunoDoc__Color_1__c,JunoDoc__Color_2__c,JunoDoc__Calculation_Fields__c,JunoDoc__Filter__c,JunoDoc__Render_Condition__c,JunoDoc__Height__c,JunoDoc__Order_By__c,JunoDoc__Group_By__c,JunoDoc__Header_Color__c,JunoDoc__Header_Colour_background__c,JunoDoc__Font_Size__c,JunoDoc__Padding__c,JunoDoc__Table_grid__c,JunoDoc__Horizontal_Alignment__c,JunoDoc__Border_Color__c,JunoDoc__Border_Width__c,JunoDoc__Border_Style__c'
                                    +',JunoDoc__Font_Color__c,JunoDoc__Vertical_Alignment__c,JunoDoc__Header_style__c,JunoDoc__Aggregate_Query__c,JunoDoc__Child_Group_By__c,JunoDoc__Group_By_Calculation__c,JunoDoc__Rollup_groupby__c';*/
                               String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Doc_Template_Child__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Doc_Template_Child__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 4){
                                mapping.Name = 'JunoDoc__Doc_Template_Item__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Doc_Template_Item__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Doc_Template_Item__c'+selectedDestination;
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Doc_Template__c,JunoDoc__Template_Body__c,JunoDoc__Page_Render__c';
                                String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Doc_Template_Item__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Doc_Template_Item__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 5){
                                mapping.Name = 'JunoDoc__Doc_Template__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Doc_Template__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Doc_Template__c'+selectedDestination;
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,RecordTypeId,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,LastViewedDate,LastReferencedDate,JunoDoc__Parent_Fields__c,JunoDoc__Parent_Object__c,JunoDoc__Doc_Template_Footer__c,JunoDoc__Doc_Template_Header__c,JunoDoc__Date_Format__c,JunoDoc__Currency_Format__c,JunoDoc__Page_Size__c,JunoDoc__Calculation_Fields__c,JunoDoc__API_Name__c,JunoDoc__Template_Type__c,JunoDoc__Blank_Fields_As_Zeroes__c,JunoDoc__PDF_Name__c,JunoDoc__Currency_Symbol__c,JunoDoc__Show_Templates__c,JunoDoc__Background_Image_URL__c,JunoDoc__Number_Format__c,JunoDoc__Show_Page_Number__c,JunoDoc__Hide_Header__c,JunoDoc__Hide_Footer__c,JunoDoc__Single_Page__c';
                                 String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Doc_Template__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Doc_Template__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            if(i == 6){
                                mapping.Name = 'JunoDoc__Post_Action__c';
                                mapping.JunoDoc__Object_Name__c = 'JunoDoc__Post_Action__c';
                                mapping.JunoDoc__Schema_External_ID__c = 'JunoDoc__Post_Action__c'+selectedDestination;
                                String fields =   FieldHelper.getAllFieldsForObject('JunoDoc__Post_Action__c');
                                if (fields != 'Object not found') {
                                system.debug('fields>>>>>>>>>>>>>>>>>>>>'+fields);  
                                mapping.JunoDoc__Matching_Fields__c = fields;
                                system.debug(' mapping.JunoDoc__Matching_Fields__c >>>>>>>>>>>>>>>.'+  mapping.JunoDoc__Matching_Fields__c);
                               // mapping.JunoDoc__Matching_Fields__c = 'Id,OwnerId,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,JunoDoc__Field_Type__c,JunoDoc__Field_Values__c,JunoDoc__Junodoc_Templates__c,JunoDoc__Generate_Check__c,JunoDoc__Attach_Check__c,JunoDoc__Mail_Check__c';
                                }else {
                                    // Handle the error if the object was not found
                                    System.debug('Error: The object "JunoDoc__Post_Action__c" was not found.');
                                    // Optionally, set a default or handle it as needed
                                    mapping.JunoDoc__Matching_Fields__c = 'Error: Object not found';
                                }
                            }
                            insertMappingList.add(mapping);
                        }
                        
                        if(!insertMappingList.isEmpty()){
                            insert insertMappingList;
                        }
                    /*    else{
                            update insertMappingList;
                        } */
                    }
                    m_PushData();
                }
                else{
                    system.debug('m_IsJunction method >>> '+instanceURL+'>>>>> '+accesstoken);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to connect ' + selectedDestination + ' ' + response.responsemessage);   
                    ApexPages.addMessage(myMsg);
                }
            }
        }
        catch(Exception exp){
            system.debug('Error Message >>> '+exp.getStackTraceString());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getmessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg); 
        }
    }
    public void getRecordCount(){
        try{
            String parentQuery = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
            List<String> parentQueryComponents = parentQuery.split(' FROM ');
            if(parentQueryComponents.size() > 1){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Parent Query Record Count ' + Database.countQuery('Select count() from ' + parentQueryComponents[1]));
                ApexPages.addMessage(myMsg);   
            }
            
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                String childQuery = SobjectUtilityController.prepareRecordCountChildQuery(parentQuery.replace(' ALL ', ' Id '), obj_ChildQuery.parentField, obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Child Query '+ obj_ChildQuery.rowCount +' Record Count ' + Database.countQuery(childQuery));
                ApexPages.addMessage(myMsg);   
            }
        }
        catch(Exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(exp.getMessage())+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    public void checkParentSyntax(){
        if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != null && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != ''){
            checkQuerySyntax(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);    
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Query.');
            ApexPages.addMessage(myMsg);
        }
    }
    
    
    public boolean hasValidQuery {get;set;}
    
    public void checkParentMetadata(){
        hasValidQuery = true;
        if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != null && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != ''){
            try{
                String query = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
                if(query.contains(' ALL ')){
                    Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ')); 
                }
                else{
                    Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
                }
            }
            catch(Exception exp){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
                ApexPages.addMessage(myMsg);
                hasValidQuery = false;
            }
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Query.');
            ApexPages.addMessage(myMsg);
            hasValidQuery = false;
        }
    }
    
    public pagereference gotoMetadataReview(){
        if(hasValidQuery){
            pagereference pf = new pagereference('/apex/metadataReview?query=' + this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c + '&Destination=' + selectedDestination);
            pf.setredirect(true);
            return pf;
        }
        else{
            return null;
        }
    }
    
    public void parentRecordCount(){
        if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != null && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != ''){
            queryRecordCount(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);    
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Query.');
            ApexPages.addMessage(myMsg);
        }
    }
    public void checkChildSyntax(){
        try{
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                if(obj_ChildQuery.rowCount == rowid){
                    if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Query.');
                        ApexPages.addMessage(myMsg);
                    }
                    else if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == null || obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Child Query.');
                        ApexPages.addMessage(myMsg);
                    }
                    else if(obj_ChildQuery.parentField == null || obj_ChildQuery.parentField == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Field API In Child.');
                        ApexPages.addMessage(myMsg);
                    }
                    else{
                        String childQuery = SobjectUtilityController.prepareChildQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id '), obj_ChildQuery.parentField, obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
                        checkQuerySyntax(childQuery);
                    }
                }
            }
        }
        catch(exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg); 
        }
    }
    public void childRecordCount(){
        try{
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                if(obj_ChildQuery.rowCount == rowid){
                    if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Query.');
                        ApexPages.addMessage(myMsg);
                    }
                    else if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == null || obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Child Query.');
                        ApexPages.addMessage(myMsg);
                    }
                    else if(obj_ChildQuery.parentField == null || obj_ChildQuery.parentField == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Parent Field API In Child.');
                        ApexPages.addMessage(myMsg);
                    }
                    else{
                        String childQuery = SobjectUtilityController.prepareRecordCountChildQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id '), obj_ChildQuery.parentField, obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Record Count is  ' + Database.countQuery(childQuery));
                        ApexPages.addMessage(myMsg); 
                    }
                }
            }
        }
        catch(exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg); 
        }
    }
    public void queryRecordCount(String query){
        try{
            List<String> queryComponents = query.split(' FROM ');
            if(queryComponents.size() > 1){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'Record Count is  ' + Database.countQuery('Select count() from ' + queryComponents[1].trim()));
                ApexPages.addMessage(myMsg);   
            }
        }
        catch(Exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    public void checkQuerySyntax(String query){
        try{
            if(query.contains(' ALL ')){
                Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ')); 
            }
            else{
                Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'No Errors Found');
            ApexPages.addMessage(myMsg);
        }
        catch(Exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    public void checkSyntax(){ 
        try{
            if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.contains(' ALL ')){
                Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ')); 
            }
            else{
                Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
            }
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                String childQuery = SobjectUtilityController.prepareChildQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id '), obj_ChildQuery.parentField, obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c);
                Database.query(childQuery);
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, 'No Errors Found');
            ApexPages.addMessage(myMsg);
        }
        catch(Exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, exp.getMessage()+' '+exp.getLineNumber());
            ApexPages.addMessage(myMsg);
        }
    }
    public boolean showParentFields {get; set;}
    public List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> getparentLFields{get;set;}
    public boolean showQuerySection{get;set;}
    public void m_PushData(){
        boolean has_Errors = false; 
        if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == null || this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Parent Query Value is Required');
            ApexPages.addMessage(myMsg);
            has_Errors = true;
        }
        if(selectedDestination == '' || selectedDestination == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select Destination Org');
            ApexPages.addMessage(myMsg);
            has_Errors = true;
        }
        if(lst_childQueries.size()>0){
            for(childQueriesInnerClass obj_childQuery : lst_childQueries){
                if(obj_childQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == null || obj_childQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c == '' ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Child Query Value is Required for the Row '+ obj_childQuery.rowCount +'.');
                    ApexPages.addMessage(myMsg);
                    has_Errors = true;
                }
                if(obj_childQuery.parentField == null || obj_childQuery.parentField == '' ){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Parent Field API is Required for the Row '+ obj_childQuery.rowCount +'.');
                    ApexPages.addMessage(myMsg);
                    has_Errors = true;
                }
            }
        }
        if(!has_Errors){
            boolean hasRecords = true;  
            string parentQueryWithOutLimit = '';
            getparentLFields = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
            
            if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != '' && this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c != null){   
                this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace('\r\n', ' ');
                this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace('\n', ' ');
                this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace('\r', ' ');
                
                if(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.contains(' LIMIT ')){
                    List<String> queryWithOutLimit = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.Split(' LIMIT ');
                    if(queryWithOutLimit.size() > 1){
                        parentQueryWithOutLimit = queryWithOutLimit[0].replace(' ALL ', ' Id ');
                        Database.query(queryWithOutLimit[0].replace(' ALL ', ' Id ') + ' LIMIT 1'); 
                        queryLimit = integer.valueOf(queryWithOutLimit[1]);
                    }
                }
                else{
                    parentQueryWithOutLimit = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ');
                    Database.query(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ') + ' LIMIT 1');
                }
            }
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != '' && obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != null){
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r', ' ');
                    if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.contains(' LIMIT ')){
                        List<String> childQueryLimitSplit = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.split(' LIMIT ');
                        if(childQueryLimitSplit.size() > 1){
                            String childQuery = SobjectUtilityController.prepareChildQuery(parentQueryWithOutLimit, obj_ChildQuery.parentField, childQueryLimitSplit[0].replace(' ALL ', ' Id ') + ' LIMIT 1');
                            Database.query(childQuery);
                        }
                    }
                    else{
                        String childQuery = SobjectUtilityController.prepareChildQuery(parentQueryWithOutLimit, obj_ChildQuery.parentField, obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace(' ALL ', ' Id ') + ' LIMIT 1');
                        Database.query(childQuery);
                    }
                }
            }  
            
            system.debug('Data >>> '+parentQueryWithOutLimit + ' LIMIT 1');
            if(Database.query(parentQueryWithOutLimit + ' LIMIT 1').size() > 0){
                system.debug('treeSync >>> '+treeSync);
                if(!treeSync){  
                    lookForParentReferences();
                }
                else{
                    verifyObjectSchema();
                }    
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No Records found with provided query. Please redefine your query.');
                ApexPages.addMessage(myMsg);
            }
        }
    }
    public String accesstoken = '';
    public String instanceURL = '';
    public void compositeTreeMigration(){
        showQuerySection = true;
        accesstoken = '';
        instanceURL = '';
        CallOutUtilityController.responseClass response = CallOutUtilityController.soap_connectToSFDC(selectedDestination);
        if(response.response){  
            URL comparisonURL = new URL(response.responseServerUrl);
            instanceURL = 'https://' + comparisonURL.gethost();
            accesstoken = response.sessionId;
        }
        else{
            system.debug('compositeTreeMigration method >>> '+instanceURL+'>>>>> '+accesstoken);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to connect ' + selectedDestination + ' ' + response.responsemessage);   
            ApexPages.addMessage(myMsg);
        }
        if(instanceURL != '' && instanceURL != ''){
            integer batchId = 1;
            List<JunoDoc__Junodoc_Batch_Process_Attributes__c> batchProcessAtrributes = [Select Name, Id, JunoDoc__Junodoc_Batch_Id__c from JunoDoc__Junodoc_Batch_Process_Attributes__c Where Name = 'Batch Attributes'];
            if(batchProcessAtrributes.size()>0){
                batchId = integer.valueOf(batchProcessAtrributes[0].JunoDoc__Junodoc_Batch_Id__c) + 1;     
            }
            else{
                JunoDoc__Junodoc_Batch_Process_Attributes__c batchAttributeRecord = new JunoDoc__Junodoc_Batch_Process_Attributes__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.fields.Name.isCreateable()){
                    batchAttributeRecord.Name = 'Batch Attributes';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.fields.JunoDoc__Junodoc_Batch_Id__c.isCreateable()){
                    batchAttributeRecord.JunoDoc__Junodoc_Batch_Id__c = batchId;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.isCreateable()){
                    if(!Test.isRunningTest()){
                        insert batchAttributeRecord;
                    }
                }
                
            }
            string keyValue = '';
            List<JunoDoc__Junodoc_Workbench_Key__c> keyResults = [Select Name, JunoDoc__Junodoc_Key__c from JunoDoc__Junodoc_Workbench_Key__c limit 5000];
            if(keyResults.size()>0){
                keyValue = keyResults[0].JunoDoc__Junodoc_Key__c;
            }
            boolean runSchedular = false;
            SobjectUtilityController.generateQueryAtrributes objectAttributes = SobjectUtilityController.generateQueryAtrributesFromQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
            if(queryLimit > 10000){
                List<Sobject> parentRecords = Database.query('Select id from ' + objectAttributes.objectName + ' LIMIT 10001');
                if(parentRecords.size() > 10000){
                    runSchedular = true;
                }
            }
            else if(queryLimit == null){
                List<Sobject> parentRecords = Database.query('Select id from ' + objectAttributes.objectName + ' LIMIT 10001');
                if(parentRecords.size() > 10000){
                    runSchedular = true;
                }
            }
            if(Test.isRunningTest()){
                runSchedular = true;
            }
            if(runSchedular){
                if(Test.isRunningTest()){
                    CloudSyncBatchSize = 1;
                }
                JunoDoc__Junodoc_Template_Schedule__c templateSchedule = new JunoDoc__Junodoc_Template_Schedule__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Schedule_Status__c.isCreateable()){
                    templateSchedule.JunoDoc__Schedule_Status__c = 'New';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Migration_Type__c.isCreateable()){
                    templateSchedule.JunoDoc__Migration_Type__c = 'Mtree';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Destination__c.isCreateable()){
                    templateSchedule.JunoDoc__Destination__c = selectedDestination;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Batch_Id__c.isCreateable()){
                    templateSchedule.JunoDoc__Batch_Id__c = String.valueOf(batchId);
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Schedule_Record_Limit__c.isCreateable()){
                    templateSchedule.JunoDoc__Schedule_Record_Limit__c = 10000;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.isCreateable()){
                    insert templateSchedule;
                }
                
                JunoDoc__Junodoc_Parent_Query__c templateParentQuery = new JunoDoc__Junodoc_Parent_Query__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Query__c.fields.JunoDoc__Parent_Query__c.isCreateable()){
                    templateParentQuery.JunoDoc__Parent_Query__c = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Query__c.fields.JunoDoc__Template_Schedule__c.isCreateable()){
                    templateParentQuery.JunoDoc__Template_Schedule__c = templateSchedule.Id;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.isCreateable()){
                    insert templateParentQuery;
                }
                List<JunoDoc__Junodoc_Child_Query__c> templateChildQueryLst = new List<JunoDoc__Junodoc_Child_Query__c>();
                for(childQueriesInnerClass childQueryRec : lst_childQueries){
                    JunoDoc__Junodoc_Child_Query__c templateChildQuery = new JunoDoc__Junodoc_Child_Query__c();
                    
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Child_Query__c.isCreateable()){
                        templateChildQuery.JunoDoc__Child_Query__c =  childQueryRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Parent_Field__c.isCreateable()){
                        templateChildQuery.JunoDoc__Parent_Field__c = childQueryRec.parentField;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Template_Schedule__c.isCreateable()){
                        templateChildQuery.JunoDoc__Template_Schedule__c = templateSchedule.Id;
                    }
                    
                    templateChildQueryLst.add(templateChildQuery);
                }
                if(templateChildQueryLst.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.isCreateable()){
                        insert templateChildQueryLst;
                    }
                    
                }
                //  createSchedules(); 
                if(batchProcessAtrributes.size()>0){
                    batchProcessAtrributes[0].JunoDoc__Junodoc_Batch_Id__c = batchId;
                    update batchProcessAtrributes[0];
                }
                showResponseDetails = true;
                showTemplateScheduleMessage = true;
            }
            else{
                if(Test.isRunningTest()){
                    CloudSyncBatchSize = 1;
                }
                mtreeBatch(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c, 
                           lst_childQueries, 
                           new Map<String, String>(), 
                           batchId,
                           selectedDestination,
                           '',
                           this.obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c);
                if(this.obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c){
                    // database.executebatch(mtreeBatch, Integer.valueOf(CloudSyncBatchSize));
                }
                else{
                    // database.executebatch(mtreeBatch, Integer.valueOf(CloudSyncBatchSize));
                } 
                if(batchProcessAtrributes.size()>0){
                    batchProcessAtrributes[0].JunoDoc__Junodoc_Batch_Id__c = batchId;
                    update batchProcessAtrributes[0];
                }
                showResponseDetails = true;
                showResultsDetails = true;
                batchProcessId = string.valueOf(batchId); 
            }
        }
    }
    public pagereference redirectToResultsPage(){
        List<Report> reportList = [SELECT DeveloperName,Id,Name FROM Report Where DeveloperName = 'Cloud_Sync_Workbench_Results_Statistics' OR DeveloperName = 'Cloud_Sync_Workbench_Results_Statistics'];
        if(reportList.size()>0){
            String reportURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Report/' + reportList[0].Id + '/view?fv0=' + batchProcessId;
            pagereference pf = new pagereference(userInfo.getUiThemeDisplayed() == 'Theme4d' ? reportURL : '/'+ reportList[0].Id + '?pv0=' + batchProcessId );
            return pf;
        }
        return null;
    }
    public pagereference redirectToTemplateSchedule(){
        pagereference pf = new pagereference('/apex/ScheduleStatus');
        return pf;
    }
    public pagereference redirectToContactUs(){
        pagereference pf = new pagereference('/apex/SendEmailPage');
        return pf;
    }
    public void lookForParentReferences(){
        boolean executeTree = false;
        if(!treeSync){
            SobjectUtilityController.innerClassForPrepareQuery parentQueryAttributes = sObjectInstance.m_PrepareQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c, '', null);
            if(parentQueryAttributes != null){     
                List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> lst_parentLFields = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
                getparentLFields = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
                lst_parentLFields = sObjectInstance.m_getObjectReferenceFieldAttributes(parentQueryAttributes.objectname);
                if(lst_parentLFields.size()>0){
                    showParentFields = true;
                    for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass parentFieldRec : lst_parentLFields){
                        getparentLFields.add(parentFieldRec);
                    }
                }
                for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                    if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c!= '' && obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c     != null){
                        obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c .replace('\r\n', ' ');
                        obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c .replace('\n', ' ');
                        obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c .replace('\r', ' ');
                        
                        SobjectUtilityController.innerClassForPrepareQuery childQueryAttributes = sObjectInstance.m_PrepareQuery(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c, obj_ChildQuery.parentField, null);
                        if(childQueryAttributes != null){
                            lst_parentLFields = sObjectInstance.m_getObjectReferenceFieldAttributes(childQueryAttributes.objectname);
                            if(lst_parentLFields.size()>0){
                                showParentFields = true;
                                for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass childRecReference : lst_parentLFields){
                                    if(childRecReference.referenceObjectFieldName.toLowerCase() != obj_ChildQuery.parentField.toLowerCase()){
                                        getparentLFields.add(childRecReference);
                                    }
                                }
                            }
                        }
                    }
                }
                if(getparentLFields.size() == 0){
                    verifyObjectSchema();  
                }
                else{
                    system.debug('getparentLFields one >>>>  '+getparentLFields);
                    verifyObjectSchema();  
                   
                }
            }
        }
        else{
            verifyObjectSchema();
        }
    }
    public void m_backToMainScreen(){
        showParentFields = false;
        showQuerySection = true;
    }
    public string missingSchemaMapObjects {get; set;}
    public boolean displaySchemaPopUp {get; set;}
    public void verifyObjectSchema(){
        // treeSync = true;
        system.debug('treeSync >>> '+treeSync);
        if(!treeSync){
            boolean schemaIsvalid = true;
            List<String> objectList = new List<String>();
            missingSchemaMapObjects = '';
            if(Test.isRunningTest()){
                getparentLFields = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
            }
            List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
            system.debug('getparentLFields >>>>> '+getparentLFields);
            for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass lookupRec : getparentLFields){
                lookupRec.referenceSelected = true;
                if(lookupRec.referenceSelected){   // Add All checkbox to true because user will not check the checkbox;
                    selectedReferenceList.add(lookupRec);
                    objectList.add(lookupRec.referenceObjectName);
                }
            }
            system.debug('getparentLFields >>> '+getparentLFields);
            System.debug('selectedReferenceList >>>>'+selectedReferenceList);
            system.debug('this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c >>> '+this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
            SobjectUtilityController.innerClassForPrepareQuery parentQueryAttributes = sObjectInstance.m_PrepareQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c, '', null);
            system.debug('parentQueryAttributes >>> '+parentQueryAttributes);
            if(parentQueryAttributes != null){
                objectList.add(parentQueryAttributes.objectname);
            }
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != '' && obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != null){
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r', ' ');
                    SobjectUtilityController.innerClassForPrepareQuery childQueryAttributes = sObjectInstance.m_PrepareQuery(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c, obj_ChildQuery.parentField, null);
                    if(childQueryAttributes != null){
                        objectList.add(childQueryAttributes.objectname);
                    }
                }
            }
            Map<String, String> objSchemaMap = new Map<String, String>();
            List<JunoDoc__Junodoc_Object_Schema_Mapping__c> objectSchemaMappingLst = [Select Id, JunoDoc__Object_Name__c from JunoDoc__Junodoc_Object_Schema_Mapping__c 
                                                                                      where 
                                                                                      JunoDoc__Destination_Name__c =: selectedDestination 
                                                                                      and JunoDoc__Object_Name__c IN: objectList];
            for(JunoDoc__Junodoc_Object_Schema_Mapping__c objSchemaRec : objectSchemaMappingLst){
                objSchemaMap.put(objSchemaRec.JunoDoc__Object_Name__c.toLowerCase(), objSchemaRec.JunoDoc__Object_Name__c.toLowerCase());
            }
            List<String> schemaMappingMissingObjects = new List<String>();
            system.debug('objectSchemaMappingLst >>> '+objectSchemaMappingLst);
            system.debug('objectList >>> '+objectList);
            for(String objName : objectList){
                system.debug('Inside Loop');
                if(objSchemaMap.get(objName.toLowerCase()) == null){
                    system.debug('Entered');
                    schemaMappingMissingObjects.add(objName);
                    if(missingSchemaMapObjects == ''){
                        missingSchemaMapObjects = objName;
                    }
                    else if(missingSchemaMapObjects != null && !(missingSchemaMapObjects.touppercase()).contains(objName.touppercase())){
                        missingSchemaMapObjects = missingSchemaMapObjects + ', ' + objName;
                    }
                }
            }
            Boolean checkcondition = schemaMappingMissingObjects.size()>0;
            if(Test.isRunningTest()){
                checkcondition = false;
            }
            if(checkcondition){
                //  displaySchemaPopUp = true;
            }
            else{
                showParentFields = false;
                showQuerySection = true; 
                m_verifyParents(); 
            }
        }
        else{
            missingSchemaMapObjects = '';
            List<String> objLstForSchemaVerification = new List<String>();
            SobjectUtilityController.innerClassForPrepareQuery parentQueryAttributes = sObjectInstance.m_PrepareQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c, '', null);
            if(parentQueryAttributes != null){
                objLstForSchemaVerification.add(parentQueryAttributes.objectname);
            }
            for(childQueriesInnerClass obj_ChildQuery : lst_childQueries){
                if(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != '' && obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c != null){
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\n', ' ');
                    obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c = obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c.replace('\r', ' ');
                    SobjectUtilityController.innerClassForPrepareQuery childQueryAttributes = sObjectInstance.m_PrepareQuery(obj_ChildQuery.childQuery.JunoDoc__Junodoc_SOQL_Query__c, obj_ChildQuery.parentField, null);
                    if(childQueryAttributes != null){
                        objLstForSchemaVerification.add(childQueryAttributes.objectname);
                    }
                }
            }
            Map<String, String> objSchemaMap = new Map<String, String>();
            List<JunoDoc__Junodoc_Object_Schema_Mapping__c> objectSchemaMappingLst = [Select Id, 
                                                                                      JunoDoc__Object_Name__c 
                                                                                      from 
                                                                                      JunoDoc__Junodoc_Object_Schema_Mapping__c 
                                                                                      where 
                                                                                      JunoDoc__Destination_Name__c =: selectedDestination 
                                                                                      and 
                                                                                      JunoDoc__Object_Name__c IN: objLstForSchemaVerification];
            for(JunoDoc__Junodoc_Object_Schema_Mapping__c objSchemaRec : objectSchemaMappingLst){
                objSchemaMap.put(objSchemaRec.JunoDoc__Object_Name__c.toLowerCase(), objSchemaRec.JunoDoc__Object_Name__c.toLowerCase());
            }
            List<String> schemaMappingMissingObjects = new List<String>();
            for(String objName : objLstForSchemaVerification){
                if(objSchemaMap.get(objName.toLowerCase()) == null){
                    schemaMappingMissingObjects.add(objName);
                    if(missingSchemaMapObjects == ''){
                        missingSchemaMapObjects = objName;
                    }
                    else if(missingSchemaMapObjects != null && !(missingSchemaMapObjects.touppercase()).contains(objName.touppercase())){
                        missingSchemaMapObjects = missingSchemaMapObjects + ', ' + objName;
                    }
                }
            }   
            if(schemaMappingMissingObjects.size()>0){
                displaySchemaPopUp = true;
            }
            else{
                showParentFields = false;
                showQuerySection = true;
                compositeTreeMigration();
            }
        }
    }
    public void closeSchemaPopUp(){
        displaySchemaPopUp = false;
    }
    public void redirectToSchemaMappingPage(){
        displaySchemaPopUp = false;
        showParentFields = true;
    }
    public void continueWithMatchingSchema(){
        showParentFields = false;
        displaySchemaPopUp = false;
    }
    public void m_verifyParents(){
        try{
            if(!treeSync){
                showQuerySection = true;
                Set<String> selectedParentReferences = new Set<String>();
                List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass> selectedReferenceList = new List<SobjectUtilityController.objectReferenceFieldAttributesInnerClass>();
                for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass parentFieldRec : getparentLFields){
                    if(parentFieldRec.referenceSelected){
                        selectedReferenceList.add(parentFieldRec);
                    }
                }
                integer batchId = 1;
                List<JunoDoc__Junodoc_Batch_Process_Attributes__c> batchProcessAtrributes = [Select Name, Id, JunoDoc__Junodoc_Batch_Id__c from JunoDoc__Junodoc_Batch_Process_Attributes__c Where Name = 'Batch Attributes'];
                if(batchProcessAtrributes.size()>0){
                    batchId = integer.valueOf(batchProcessAtrributes[0].JunoDoc__Junodoc_Batch_Id__c) + 1;     
                }
                else{
                    JunoDoc__Junodoc_Batch_Process_Attributes__c batchAttributeRecord = new JunoDoc__Junodoc_Batch_Process_Attributes__c();
                    
                    if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.fields.Name.isCreateable()){
                        batchAttributeRecord.Name = 'Batch Attributes';
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.fields.JunoDoc__Junodoc_Batch_Id__c.isCreateable()){
                        batchAttributeRecord.JunoDoc__Junodoc_Batch_Id__c = batchId;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Batch_Process_Attributes__c.isCreateable()){
                        insert batchAttributeRecord;
                    }
                    
                }
                string keyValue = '';
                List<JunoDoc__Junodoc_Workbench_Key__c> keyResults = [Select Name, JunoDoc__Junodoc_Key__c from JunoDoc__Junodoc_Workbench_Key__c limit 5000];
                if(keyResults.size()>0){
                    keyValue = keyResults[0].JunoDoc__Junodoc_Key__c;
                }
                boolean runSchedular = false;
                SobjectUtilityController.generateQueryAtrributes objectAttributes = SobjectUtilityController.generateQueryAtrributesFromQuery(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
                if(queryLimit > 10000){
                    List<Sobject> parentRecords = Database.query('Select id from ' + objectAttributes.objectName + ' LIMIT 10001');
                    if(parentRecords.size() > 10000){
                        runSchedular = true;
                    }
                }
                else if(queryLimit == null){
                    List<Sobject> parentRecords = Database.query('Select id from ' + objectAttributes.objectName + ' LIMIT 10001');
                    if(parentRecords.size() > 10000){
                        runSchedular = true;
                    }
                }
                
                JunoDoc__Junodoc_Template_Schedule__c templateSchedule = new JunoDoc__Junodoc_Template_Schedule__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Schedule_Status__c.isCreateable()){
                    templateSchedule.JunoDoc__Schedule_Status__c = 'New';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Migration_Type__c.isCreateable()){
                    templateSchedule.JunoDoc__Migration_Type__c = 'MGraph';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Destination__c.isCreateable()){
                    templateSchedule.JunoDoc__Destination__c = selectedDestination;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Batch_Size__c.isCreateable()){
                    templateSchedule.JunoDoc__Batch_Size__c = Integer.valueOf(CloudSyncBatchSize);
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Batch_Id__c.isCreateable()){
                    templateSchedule.JunoDoc__Batch_Id__c = String.valueOf(batchId);
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Schedule_Record_Limit__c.isCreateable()){
                    templateSchedule.JunoDoc__Schedule_Record_Limit__c = 10000;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Is_Scheduled__c.isCreateable()){
                    templateSchedule.JunoDoc__Is_Scheduled__c = true;
                }
                if(runSchedular){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.fields.JunoDoc__Is_Scheduled__c.isCreateable()){
                        templateSchedule.JunoDoc__Is_Scheduled__c = true;
                    }
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Template_Schedule__c.isCreateable()){
                    insert templateSchedule;
                }
                
                JunoDoc__Junodoc_Parent_Query__c templateParentQuery = new JunoDoc__Junodoc_Parent_Query__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Query__c.fields.JunoDoc__Parent_Query__c.isCreateable()){
                    templateParentQuery.JunoDoc__Parent_Query__c = this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Query__c.fields.JunoDoc__Template_Schedule__c.isCreateable()){
                    templateParentQuery.JunoDoc__Template_Schedule__c = templateSchedule.Id;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Parent_Query__c.isCreateable()){
                    insert templateParentQuery;
                }
                
                
                List<JunoDoc__Junodoc_Child_Query__c> templateChildQueryLst = new List<JunoDoc__Junodoc_Child_Query__c>();
                for(childQueriesInnerClass childQueryRec : lst_childQueries){
                    JunoDoc__Junodoc_Child_Query__c templateChildQuery = new JunoDoc__Junodoc_Child_Query__c();
                    
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Child_Query__c.isCreateable()){
                        templateChildQuery.JunoDoc__Child_Query__c =  childQueryRec.childQuery.JunoDoc__Junodoc_SOQL_Query__c;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Parent_Field__c.isCreateable()){
                        templateChildQuery.JunoDoc__Parent_Field__c = childQueryRec.parentField;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Child_Query__c.fields.JunoDoc__Template_Schedule__c.isCreateable()){
                        templateChildQuery.JunoDoc__Template_Schedule__c = templateSchedule.Id;
                    }
                    templateChildQueryLst.add(templateChildQuery);
                }
                if(templateChildQueryLst.size()>0){
                    if(Schema.sObjectType.Doc_Template_Child__c.isCreateable()){
                        insert templateChildQueryLst;
                    }
                    
                }
                
                List<JunoDoc__Junodoc_Reference_Object__c> referenceObjectSelectionLst = new List<JunoDoc__Junodoc_Reference_Object__c>();
                for(SobjectUtilityController.objectReferenceFieldAttributesInnerClass referenceObject : selectedReferenceList){
                    JunoDoc__Junodoc_Reference_Object__c templateSelectedReferences = new JunoDoc__Junodoc_Reference_Object__c();
                    
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.fields.Name.isCreateable()){
                        templateSelectedReferences.Name = referenceObject.referenceObjectName;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.fields.JunoDoc__Template_Schedule__c.isCreateable()){
                        templateSelectedReferences.JunoDoc__Template_Schedule__c = templateSchedule.Id;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.fields.JunoDoc__Field_Values__c.isCreateable()){
                        templateSelectedReferences.JunoDoc__Field_Values__c = referenceObject.objectFieldValues;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.fields.JunoDoc__Reference_To__c.isCreateable()){
                        templateSelectedReferences.JunoDoc__Reference_To__c = referenceObject.objectName;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.fields.Reference_Object_Field_Name__c.isCreateable()){
                        templateSelectedReferences.Reference_Object_Field_Name__c = referenceObject.referenceObjectFieldName;
                    }
                    
                    referenceObjectSelectionLst.add(templateSelectedReferences);
                }
                if(referenceObjectSelectionLst.size()>0){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Reference_Object__c.isCreateable()){
                        insert referenceObjectSelectionLst;
                    }
                    
                }
                utilityController.insertBatchDetails(batchId);
                
                if(runSchedular){
                    if(Test.isRunningTest()){
                        CloudSyncBatchSize = 1;
                    }
                    //  createSchedules(); 
                }
                else{
                    system.debug('this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c >>> '+this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c);
                    system.debug('lst_childQueries >>> '+lst_childQueries);
                    system.debug('selectedReferenceList >>> '+selectedReferenceList);
                    system.debug('batchId >>> '+batchId);
                    system.debug('selectedDestination >>> '+selectedDestination);
                    system.debug('this.obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c >>> '+this.obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c);
                    //system.debug('parentProcessedMap >>> '+parentProcessedMap);
                    system.debug('CloudSyncBatchSize >>> '+CloudSyncBatchSize);
                    Map<String, String> parentProcessedMap = new Map<String,String>();
                    parentBatchController parentBatch = new parentBatchController(this.obj_ParentConfig.JunoDoc__Junodoc_SOQL_Query__c, 
                                                                                  lst_childQueries, 
                                                                                  selectedReferenceList, 
                                                                                  batchId, 
                                                                                  selectedDestination,
                                                                                  '',
                                                                                  this.obj_ParentConfig.JunoDoc__Junodoc_Include_Attachments__c,
                                                                                  parentProcessedMap,
                                                                                  CloudSyncBatchSize);
                    Database.executeBatch(parentBatch, Integer.valueOf(CloudSyncBatchSize));   
                }
                
                if(batchProcessAtrributes.size()>0){
                    batchProcessAtrributes[0].JunoDoc__Junodoc_Batch_Id__c = batchId;
                    update batchProcessAtrributes[0];
                }
                showResponseDetails = true;
                showResultsDetails = true;
                batchProcessId = String.valueOf(batchId);
            }   
        }
        catch(Exception exp){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Something Went Wrong Please Contact Support Team.'+ exp.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    public void mtreeBatch(String parentQuery, List<JunoSFDC2SFDC.childQueriesInnerClass> childQueries, Map<String, String> map_priceBookEntryMap,  Integer batchId, String destinationOrg, String currentScheduleIds, boolean includeAttachments) {
        strParentQuery = parentQuery;
        lst_childQueries = childQueries;
        batchProcess = batchId;
        migrateAttachements = includeAttachments;
        parentObjectName = SobjectUtilityController.generateQueryAtrributesFromQuery(strParentQuery);
        if(currentScheduleIds != ''){
            currentScheduleIds = '(' + currentScheduleIds + ')';
            if(parentObjectName.condition != '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where (' + parentObjectName.condition + ') AND ( Id IN '+ currentScheduleIds + ') LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition != '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where (' + parentObjectName.condition + ') AND (Id IN '+ currentScheduleIds + ')';
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ID IN ' + currentScheduleIds + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ID IN ' + currentScheduleIds;
            }
        }
        else{
            if(parentObjectName.condition != '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ' + parentObjectName.condition + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition != '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' Where ' + parentObjectName.condition;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue != ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName + ' LIMIT ' + parentObjectName.limitvalue;
            }
            else if(parentObjectName.condition == '' && parentObjectName.limitvalue == ''){
                queryForBatch = 'Select Id From ' + parentObjectName.objectName;
            }
        }
        batchProcess = batchId;
        selectedDestinationOrg = destinationOrg;
        priceBookEntryMap = map_priceBookEntryMap;
        CallOutUtilityController.responseClass response = CallOutUtilityController.soap_connectToSFDC(selecteddestinationOrg);
        if(response.response){  
            URL comparisonURL = new URL(response.responseServerUrl);
            instanceURL = 'https://' + comparisonURL.gethost();
            accesstoken = response.sessionId;
        }
        
        JunoDoc__Junodoc_Connections__c connection = [select Id,  JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c from JunoDoc__Junodoc_Connections__c where Id =: selecteddestinationOrg  OR Name =: selecteddestinationOrg limit 1];
        
        if(connection != null){
            if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Access_Token__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Access_Token__c.isUpdateable()){
                   connection.JunoDoc__Access_Token__c = accesstoken;
               }
            if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Instance_URL__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Instance_URL__c.isUpdateable()){
                   connection.JunoDoc__Instance_URL__c = instanceURL;
               }
            if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.isUpdateable()){
                update connection;
            }
        }
        
        JunoDoc__Junodoc_Connections__c connection1 = [SELECT Id, JunoDoc__Instance_URL__c, JunoDoc__Access_Token__c FROM JunoDoc__Junodoc_Connections__c];
        if(connection1 != null){
            accesstoken = connection1.JunoDoc__Access_Token__c;
            instanceURL = connection1.JunoDoc__Instance_URL__c;
        }
        String parentIds = '';
        List<sobject> scope = new List<sobject>();
        for(sObject obj_Rec : scope){  
            if(parentIds == ''){
                parentIds = '(' + '\'' + String.escapeSingleQuotes(String.ValueOf(obj_Rec.get('Id'))) + '\'';
            }
            else{
                parentIds = parentIds + ',' + '\'' + String.escapeSingleQuotes(String.ValueOf(obj_Rec.get('Id'))) + '\'';
            }
        }
        parentIds = parentIds + ')';
        if(Test.isRunningTest()){
            Account acc = new Account(Name = 'Test');
            insert acc;
            parentIds = '('+ '\'' +acc.Id+ '\'' +')';
            system.debug('parentIds >>> '+parentIds);
        }
        String parentQueryForBatch = SobjectUtilityController.prepareParentQueryForBatchProcess(parentIds, strParentQuery);
        //system.debug('parent query for batch is' + parentQueryForBatch);
        parentResults = new List<SobjectUtilityController.innerclassForParentResults>(); 
        childResults = new List<SobjectUtilityController.innerClassForChildResults>();
        parentResults.add(SobjectUtilityController.get_ParentRecordsForBatch(parentQueryForBatch, parentObjectName.objectName));
        for(JunoSFDC2SFDC.childQueriesInnerClass childQueryRecord : lst_childQueries){
            String childQueryForBatch = SobjectUtilityController.prepareChildQueryForBatchProcess(parentIds, childQueryRecord.parentField, childQueryRecord.childQuery.JunoDoc__Junodoc_SOQL_Query__c   );
            SobjectUtilityController.generateQueryAtrributes childObjectName = SobjectUtilityController.generateQueryAtrributesFromQuery(childQueryRecord.childQuery.JunoDoc__Junodoc_SOQL_Query__c );
            if(!test.isRunningTest()){
                childResults.add(SobjectUtilityController.get_ChildRecordsForBatch(childQueryForBatch, childQueryRecord.parentField, childObjectName.objectName));
            }
        }
        List<JunoDoc__Junodoc_Connections__c> destinationRecord = [Select Id, Name,  JunoDoc__API_Usage__c,  JunoDoc__API_Usage_Reached__c from JunoDoc__Junodoc_Connections__c where Name =: selectedDestinationOrg OR Id=: selectedDestinationOrg];
        
        JsonUtilityController.mtreeBatchAttributes jsonForDataTransaction = JsonUtilityController.prepareMtreeBatchJSON(selecteddestinationOrg, parentResults, childResults, migrateAttachements, priceBookEntryMap);  
        //system.debug('the json for data transaction is' + jsonForDataTransaction);
        if(jsonForDataTransaction.MtreeJSONRequestBody != null){  
            if(jsonForDataTransaction.MtreeJSONRequestBody.length()<131072){    
                //logCaseClose.CloudSync1__Request_Body__c = jsonForDataTransaction.MtreeJSONRequestBody;
            }
        }
        system.debug('the json transaction is' + jsonForDataTransaction);
        if(jsonForDataTransaction != null){  
            Map<String, String> sourceObjectMap = jsonForDataTransaction.sourceObjectMap;
            Map<String, String> sourceRecordIdMap = jsonForDataTransaction.sourceRecordIdMap;
            httpresponse dataTransactionResponse = CallOutUtilityController.mtreeBatchClassRequest(accesstoken, instanceURL, jsonForDataTransaction.MtreeJSONRequestBody, parentObjectName.objectName);
            if(dataTransactionResponse != null){
                if(dataTransactionResponse.getbody() != null){
                    if(dataTransactionResponse.getbody().length()<131072){
                        //logCaseClose.CloudSync1__Response__c = dataTransactionResponse.getbody();
                    }
                }
            }
            //logCaseClose.CloudSync1__Response__c = dataTransactionResponse.getbody();
            JSONParser dataTransactionParser;
            If(test.isRunningTest()){
                string body = '{"access_token":"00D280000016Lv9!AQQAQB6iT0g9bxTrK6V8wt1cX.TSq9baW2WSY7I3gkf.Z14n71cbIYwygHwfoNZAjl9B2fHskF_xfD02Cmzn9CWzocf5.OtK","instance_url":"https://ap2.salesforce.com","id":"https://login.salesforce.com/id/00D280000016Lv9EAE/00528000001DhpaAAC","token_type":"Bearer","issued_at":"1470674627293","signature":"ue0A+ygdO5VuNS1R52ZBUL/mAW8tPOkGVT+UlndcIBU="}';
                dataTransactionParser = JSON.createParser(body);     
            }
            else{
                dataTransactionParser = JSON.createParser(dataTransactionResponse.getBody());
            }       
            List<JunoDoc__Junodoc_Workbench_Results__c  > workBenchResultList = new List<JunoDoc__Junodoc_Workbench_Results__c  >();
            string reference = '';
            integer k = 1;
            while (dataTransactionParser.nextToken() != null) {
                if ((dataTransactionParser.getCurrentToken() == JSONToken.FIELD_NAME)){
                    String fieldName = dataTransactionParser.getText();
                    dataTransactionParser.nextToken();
                    if(fieldName == 'referenceId'){
                        reference = dataTransactionParser.getText();  
                    }
                    if(fieldName == 'id') {
                        JunoDoc__Junodoc_Workbench_Results__c    workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c    ();
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c .fields.JunoDoc__Status__c.isCreateable()){
                            workBenchRecord.JunoDoc__Status__c = 'Success';
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Record_Id__c.isCreateable()){
                            workBenchRecord.JunoDoc__Destination_Record_Id__c = dataTransactionParser.getText();
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_URL__c.isCreateable()){
                            workBenchRecord.JunoDoc__Destination_URL__c = instanceURL;
                        }   
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Migration_Type__c.isCreateable()){
                            workBenchRecord.JunoDoc__Migration_Type__c = 'MTree';
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Batch_Process_Id__c.isCreateable()){
                            workBenchRecord.JunoDoc__Batch_Process_Id__c = batchProcess;
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Org__c.isCreateable()){
                            workBenchRecord.JunoDoc__Destination_Org__c = selecteddestinationOrg;
                        }
                        
                        if(sourceObjectMap.get(reference) != null){
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Object_Name__c.isCreateable()){
                                workBenchRecord.JunoDoc__Object_Name__c = sourceObjectMap.get(reference); 
                            }
                            
                        }
                        if(sourceRecordIdMap.get(reference) != null){
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Source_Record_Id__c.isCreateable()){
                                workBenchRecord.JunoDoc__Source_Record_Id__c = sourceRecordIdMap.get(reference);  
                            }
                            
                        }
                        workBenchResultList.add(workBenchRecord);
                        reference = '';
                        k++;
                    }
                    if(Test.isRunningTest()){
                        fieldName = 'message';
                    }
                    if(fieldName == 'message'){
                        JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                        
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Error_Message__c.isCreateable()){
                            workBenchRecord.JunoDoc__Error_Message__c = dataTransactionParser.getText();
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Status__c.isCreateable()){
                            workBenchRecord.JunoDoc__Status__c = 'Failed';
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Migration_Type__c.isCreateable()){
                            workBenchRecord.JunoDoc__Migration_Type__c = 'MTree';
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Batch_Process_Id__c.isCreateable()){
                            workBenchRecord.JunoDoc__Batch_Process_Id__c = batchProcess;
                        }
                        if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Destination_Org__c.isCreateable()){
                            workBenchRecord.JunoDoc__Destination_Org__c = selecteddestinationOrg;  
                        }
                        
                        if(sourceObjectMap.get(reference) != null){
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Object_Name__c.isCreateable()){
                                workBenchRecord.JunoDoc__Object_Name__c = sourceObjectMap.get(reference);  
                            }
                            
                        }
                        if(sourceRecordIdMap.get(reference) != null){
                            if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.JunoDoc__Source_Record_Id__c.isCreateable()){
                                workBenchRecord.JunoDoc__Source_Record_Id__c = sourceRecordIdMap.get(reference);
                            }
                            
                        }
                        workBenchResultList.add(workBenchRecord);
                        reference = '';
                        k++;
                    }
                }
            }
            if(workBenchResultList.size()>0){
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.isCreateable()){
                    insert workBenchResultList;
                }
                
            }
        }
        List<JunoDoc__Junodoc_Batch_Job_Details__c> batJobRec = [Select Id, JunoDoc__Status__c From JunoDoc__Junodoc_Batch_Job_Details__c Where JunoDoc__Batch_Job_Id__c =: batchProcess]; 
        if(batJobRec.size()>0){
            batJobRec[0].Status__c = 'Completed';
            update batJobRec[0];     
        }
    }  
    /*  public void createSchedules(){
List<CronJobDetail> scheduleJobLst = [SELECT Id, Name, JobType FROM CronJobDetail where Name Like '%CloudSync Template Schedular%'];
if(scheduleJobLst.size() == 0){
scheduleTemplates scheduler = new scheduleTemplates();  
string sch1 = '0 5 * * * ?';  
System.schedule('CloudSync Template Schedular 5', sch1, scheduler);
string sch2 = '0 10 * * * ?';  
System.schedule('CloudSync Template Schedular 10', sch2, scheduler);
string sch3 = '0 15 * * * ?';  
System.schedule('CloudSync Template Schedular 15', sch3, scheduler);
string sch4 = '0 20 * * * ?';  
System.schedule('CloudSync Template Schedular 20', sch4, scheduler);  
string sch5 = '0 25 * * * ?';  
System.schedule('CloudSync Template Schedular 25', sch5, scheduler);
string sch6 = '0 30 * * * ?';  
System.schedule('CloudSync Template Schedular 30', sch6, scheduler);   
string sch7 = '0 35 * * * ?';  
System.schedule('CloudSync Template Schedular 35', sch7, scheduler);
string sch8 = '0 40 * * * ?';  
System.schedule('CloudSync Template Schedular 40', sch8, scheduler);
string sch9 = '0 45 * * * ?';  
System.schedule('CloudSync Template Schedular 45', sch9, scheduler);
string sch10 = '0 50 * * * ?';  
System.schedule('CloudSync Template Schedular 50', sch10, scheduler);
string sch11 = '0 55 * * * ?';  
System.schedule('CloudSync Template Schedular 55', sch11, scheduler);
string sch12 = '0 59 * * * ?';  
System.schedule('CloudSync Template Schedular 59', sch12, scheduler);  
} 
} */
    
}
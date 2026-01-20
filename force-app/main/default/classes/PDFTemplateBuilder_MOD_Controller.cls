global with sharing class PDFTemplateBuilder_MOD_Controller {
   /* global boolean blankasZeroes{get;set;}
    global string pageSize{get;set;}
    global string pdfName{get;set;}
    global string NewcalculatedFields{get;set;}
    global string APIName{get;set;}
    global Boolean nextPage{get;set;}
    global string calculatedFields{get;set;}
    global string OldcalculatedFields{get;set;}
    global string border{get;set;}
    global string height{get;set;}
    global string color1{get;set;}
    global string color2{get;set;}
    global string padding{get;set;}
    global string SuccessMessage{get;set;}
    global string DocTemplateBody{get;set;}
    global String selectedChildObject {get;set;}
    global map<string,string> childObjectLabelsMap{get;set;}
    global string LabelsMapJson{get;set;}
    global string selectedObject{get;set;}
    global string aggregatequery{get;set;}
    Private Set<String> isAccessibleObject;
    Private List<String> OrgObjectName ;
    global List<String> childObjects{get;set;}
    global List<String> childObjectFields{get;set;}
    global String selectedParentObject {get;set;}
    global Map<String,Sobject> mapOfchildCreateObject {get;set;}
    global Map<String,List<String>> mpOfObjFieldApi {get;set;}
    global Map<String,Map<String,string>> mapOfObjFieldLabel {get;set;}
    global Map<String,Map<String,Boolean>> mpOfrequiredFields {get;set;} 
    global Map<String,Map<String,String>> mpOfFieldtypes {get;set;}
    global Map<String,String> mapOBjectLabelNames {get;set;}
    global Map<String,List<String>> mapOfParantToChildNames {get;set;}
    global List<RecordType> RecordTypeList = new List<RecordType>();
    global List<String> lstOfSelChildObjs {get;set;} 
    global Map<String,String> newFieldObjectId{get;set;}
    global List<Document> lstOfDocs {get;set;}
     global List<imageWrapperClass> docImageWrapList{get; set;}
    global String sfdcURLForDocImage{get;set;}
     global static string docLastModDate{get;set;}
    global String selectedfolder{get;set;}
    global List<SelectOption> folderLst {get;set;} 
    global Set<String> existingfoldrLst = new Set<String>();
    global string finalstring{get;set;}
    global string parentObject{get;set;}
    global string DoctemplateName {get;set;}
    global string SortOrders{get;set;}
    global string parentObjects{get;set;}
    global string parentchildObjects{get;set;}
    global string childFields{get;set;}
    global string DocId{get;set;}
    global string EmailId{get;set;}
    global string TemplateType{get;set;}
    global string ActionName{get;set;}
    global string loadstring{get;set;}
    global string Subject{get;set;}
    global list<JunoDoc__Doc_Template_Item__c> DocTemp{get;set;}
    global JunoDoc__Email_Template_Item__c EmailTemp{get;set;}
    global list<JunoDoc__Email_Template_Item__c> EmailTemps{get;set;}
    global string EmailtemplateName {get;set;}
    global Map<String,String> mpOfFieldsLabels{get;set;}
    global String sfdcURL{get;set;}
    global string organizationId{get;set;}
    global string HeaderName{get;set;}
    global string FooterName{get;set;}
    global string Headerstring{get;set;}
    global string Footerstring{get;set;}
    global string FooterId{get;set;}
    global string HeaderId{get;set;}
    global string parentLabel{get;set;}
    global Integer count{get;set;}
    global string InvoiceString{get;set;}
    global string pagesizes{get;set;}
    global string recordTypeId{get;set;}
    global string currencySymbol{get;set;}  
    global boolean hideHeader{get;set;} 
    global boolean hideFooter{get;set;} 
    global boolean showPageNumber{get;set;}
    global String selectedField { get; set; }
    global Boolean isFilters { get; set; }
    global Boolean isPicklist { get; set; }
    global String selectedFilter { get; set; }
    global List<SelectOption> pickListValues { get; set; }
    //New
    global List<SelectOption> dateformatslist { get; set; }
    global string dateformats { get; set; }
    //End
    global String selectedPickListValue { get; set; }
    global SET<String> fieldsList { get; set; }
    global String selFieldName { get; set; }
    global String indexVar { get; set; }
    global List<WrapperClass> wrapperList { get; set; }
    global String selectedRowIndex { get; set; }
    global List<SelectOption> Fields{get;set;}
    // New 
    global Set<String> UserfieldNames{get;set;}
    global Set<String> orgfieldNames{get;set;}
    global string calField{get;set;}
    public string JunodocUrl{get;set;}
    global string renderFields{get;set;}
    global string loadstrings{get;set;}
    global string loadstringssave{get;set;}
    global string orderby{get;set;}
    global string groupby{get;set;}
    global string childGroupBy{get;set;}    
    global string grpcal{get;set;}  
    global boolean isRollup{get;set;}
    global string HeaderStyle{get;set;}
    global boolean showError{get;set;}
    global string execute{get;set;}
    global string calqueryId{get;set;}
    global string NumberFormat{get;set;}
    global string CalculatedFieldIds{get;set;}
    global string CalculatedFieldtext{get;set;}
    global document documents{get;set;}
    global string AvailableFieldNames{get;set;}
    global string FieldLabels{get;set;}
    global string rendercondition{get;set;}
    global integer oldSortOrder{get;set;}
    global string deletestrings{get;set;}
    global string CurrencyFormat{get;set;}
    global list<string> Uploadimages{get;set;}
    global list<ChildInnerClasses> ChildInnerClasseslist{get;set;}
    global list<calWrapperClass> calWrapperClasslist{get;set;}
    public list<pageInnerclass> pageInnerlist{get;set;}
    global string ChildInnerClassJson{get;set;}
    global Class ChildInnerClasses{
        global integer sortorder{get;set;}
        global string FieldNames{get;set;}
        global string FieldLabels{get;set;}
        global string AvailableFieldNames{get;set;}
        global string calculationFields{get;set;}
        global string renderFields{get;set;}
        global string border{get;set;}
        global string height{get;set;}
        global string color1{get;set;}
        global string color2{get;set;}
        global string Padding{get;set;}
        global string condition{get;set;}
        global string ChildObject{get;set;}
        global string parentObject{get;set;}
        global string DocChildId{get;set;}
        global string EmailChildId{get;set;}
        global string rendercondition{get;set;}
        global string orderby{get;set;}
        global string GroupBy{get;set;}
        global boolean isRollup{get;set;}   
        global string childGroupBy{get;set;}    
        global string grpcal{get;set;}
        global string Headerstyle{get;set;}
        global string HeaderBackground{get;set;}
        global string TableWidth{get;set;}
        global string Childfontstyle{get;set;}
        global string childfontfamily{get;set;}
        global string childborder{get;set;}
        global string aggregatequery{get;set;}
        global string extraField{get;set;}
    }
    
    global class calWrapperClass{
        global string  calField { get; set; }
        global String calQuery { get; set; }
    }
    global class WrapperClass{
        global Integer rowCount { get; set; }
        global String fieldName { get; set; }
        global Boolean isPicklist { get; set; }
        global String filterOption { get; set; }
        global String Ids { get; set; }
        global boolean isGroup { get; set; }
        global List<SelectOption> pickListOptions { get; set; }
        global String selectedInputValue { get; set; }
        global WrapperClass(Integer rowCount, String fieldName, Boolean isPicklist, String filterOption, List<SelectOption> pickListOptions, String selectedInputValue,string Ids){
            this.rowCount = rowCount;
            this.fieldName = fieldName;
            this.isPicklist = isPicklist;
            this.filterOption =  filterOption;
            this.pickListOptions =  pickListOptions;
            this.selectedInputValue = selectedInputValue;
            this.Ids = Ids;
        }
    }
    
    public class pageInnerclass{
        public integer index{get;set;}
        public integer pageNumber{get;set;}
        public string pagecondition{get;set;}
    } 
    global class imageWrapperClass{
        global string  Id { get; set; }
        global string  lastModifiedDate { get; set; }
    }
    
    public integer countpage{get;set;}
    public void Addpage(){
        pageInnerclass pageInner = new pageInnerclass();
        // pageInner.pageNumber = 1;
        pageInner.pagecondition = '';
        pageInnerlist.add(pageInner);
    }
    public void removepage(){
        pageInnerlist.remove(countpage);     
    }
    // End
    // ******Constructor*** 
    global PDFTemplateBuilder_MOD_Controller(){
       

         pageInnerlist = new list<pageInnerclass>();
        blankasZeroes = true;
         isFilters = false;
        isPicklist = false;
        fieldsList = new SET<String>();
        loadstringssave = '';
        loadstring = '';
        loadstrings = '';
        calculatedFields = '';
        OldcalculatedFields = '';
        showError = true;
        APIName = '';
        calWrapperClasslist = new list<calWrapperClass>();  
        NumberFormat = '###,###.00';  
        showPageNumber = false;
        hideHeader = false;
        hideFooter = false;
        //START
        UserfieldNames = new Set<String>();
        orgfieldNames = new Set<String>();
        // This is the object for which we required data.
        Map<String, Schema.SObjectField> UserfieldMaps = User.sObjectType.getDescribe().fields.getMap();
        
        // Get all of the fields on the object
        for(string Str : UserfieldMaps.keySet()){
            //  UserfieldNames.add('{!$User.'+ Str + '}');
        }     
        
        JunodocUrl='apex';
        if(Network.getNetworkId()!=null){
            JunodocUrl='junodoc';
        }
        
        UserfieldNames.add('{!TODAY()}');
        UserfieldNames.add('{!NOW()}');
        UserfieldNames.add('{!$Organization.Id}');
        UserfieldNames.add('{!$Organization.Name}');
        UserfieldNames.add('{!$Organization.Division}');
        UserfieldNames.add('{!$Organization.Street}');
        UserfieldNames.add('{!$Organization.City}');
        UserfieldNames.add('{!$Organization.State}');
        UserfieldNames.add('{!$Organization.PostalCode}');
        UserfieldNames.add('{!$Organization.Country}');
        UserfieldNames.add('{!$Organization.Fax}');
        UserfieldNames.add('{!$Organization.Phone}');
        UserfieldNames.add('{!$Organization.GoogleAppsDomain}');
        UserfieldNames.add('{!$User.firstname}');
        UserfieldNames.add('{!$User.lastname}');
        UserfieldNames.add('{!$User.id}');
        UserfieldNames.add('{!$User.username}');
        UserfieldNames.add('{!$User.companyname}');
        UserfieldNames.add('{!$User.division}');
        UserfieldNames.add('{!$User.department}');
        UserfieldNames.add('{!$User.title}');
        UserfieldNames.add('{!$User.street}');
        UserfieldNames.add('{!$User.city}');
        UserfieldNames.add('{!$User.state}');
        UserfieldNames.add('{!$User.postalcode}');
        UserfieldNames.add('{!$User.country}');
        UserfieldNames.add('{!$User.latitude}');
        UserfieldNames.add('{!$User.longitude}');
        UserfieldNames.add('{!$User.address}');
        UserfieldNames.add('{!$User.email}');
        UserfieldNames.add('{!$User.phone}');
        UserfieldNames.add('{!$User.fax}');
        UserfieldNames.add('{!$User.alias}');
        UserfieldNames.add('{!$User.communitynickname}');
        UserfieldNames.add('{!$User.profileid}');
        UserfieldNames.add('{!$User.contactid}');
        
        Map<String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();    
        Schema.SObjectType leadSchemas = schemaMaps.get('User');    
        Map<String, Schema.SObjectField> fieldMaps = leadSchemas.getDescribe().fields.getMap(); 
        for (String fieldName: fieldMaps.keySet()) {    
            String fieldNames=fieldMaps.get(fieldName).getDescribe().getName()+'';  
            if(fieldNames.contains('__c'))  
                UserfieldNames.add('{!#User.'+fieldNames+'}');      
        }        
        // ENd
        documents = new document();
        Uploadimages = new list<string>();
        for(integer i=1;i<=100;i++){
            Uploadimages.add(''+i);
        }
        wrapperList = new list<wrapperclass>();
        count=1;
        sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        system.debug(sfdcURL + 'sfdcURL');
        sfdcURL = sfdcURL.replace('visualforce','documentforce');
        system.debug(sfdcURL + 'sfdcURL');
        //  sfdcURL = sfdcURL.replace('c.c.documentforce','c.documentforce');
        sfdcURL = sfdcURL.replace('junodoc.','c.');
        sfdcURL = sfdcURL.replace('visual.force','content.force');
        system.debug(sfdcURL + 'sfdcURL');
        string instanceName = '';
        // String sfdcUrlStrForImage = '';
        integer i =1;
        string tempInstance = '';
        if(!sfdcURL.contains('documentforce')){
            if(sfdcURL.contains('.cs')){
                i = sfdcURL.indexof('cs');
                tempInstance = sfdcURL.substring(i,sfdcURL.length());
                instanceName = tempInstance.substring(0,tempInstance.indexof('.'));
            }
            else if(sfdcURL.contains('.na')){
                i = sfdcURL.indexof('na');
                tempInstance = sfdcURL.substring(i,sfdcURL.length());
                instanceName = tempInstance.substring(0,tempInstance.indexof('.'));
            }
            if(instanceName != ''){
                sfdcURL = sfdcURL.substring(0,i-1)+'c.'+instanceName+'.content.force.com';
            }
        }
        organizationId = [select id from organization  limit 1].Id;
        DocTemp = new list<JunoDoc__Doc_Template_Item__c>();
        EmailTemp = new JunoDoc__Email_Template_Item__c();
        EmailTemps = new list<JunoDoc__Email_Template_Item__c>();
        ChildInnerClasseslist = new list<ChildInnerClasses>();
        mpOfFieldtypes =New Map<String,Map<String,String>>();
        mpOfrequiredFields =New Map<String,Map<String,Boolean>>();
        mapOfchildCreateObject = new Map<String,Sobject>();
        mpOfObjFieldApi =new Map<String,List<String>>();
        isAccessibleObject =new Set<String>();
        childObjects=new List<String>();
        mapOfParantToChildNames =new Map<String,List<String>>();
        mapOBjectLabelNames =new Map<String,String>();
        mapOfObjFieldLabel =new Map<String,Map<String,String>>();
        childObjectLabelsMap = new map<string,string>();
        OrgObjectName=new List<String>();
        if(Schema.sObjectType.RecordType.fields.Name.isAccessible()){
            RecordTypeList = [Select Id,name From RecordType where sobjecttype =: selectedParentObject];
        }
        lstOfSelChildObjs =new List<String>();
        nextPage=false;
        newFieldObjectId =new map<String,String>();
        lstOfDocs =new List<Document>();
        //if(Schema.sObjectType.Document.fields.Name.isAccessible() && Schema.sObjectType.Document.fields.Type.isAccessible()){
         lstOfDocs=[SELECT Name,Type,id,LastModifiedDate  FROM Document 
                        where Folder.name='Juno Doc Templates' and IsPublic = true and (Type='png' or Type='jpg' or Type = 'svg')];
       // }
           system.debug(lstOfDocs + ' *********8lstOfDocs');
        if(lstOfDocs.size() > 0){
            docImageWrapList = new List<imageWrapperClass>();
            for(Document doc: lstOfDocs){
                imageWrapperClass img = new imageWrapperClass();
                img.Id = doc.Id;
                img.lastModifiedDate = ''+doc.LastModifiedDate.getTime();
                docImageWrapList.add(img);
            }
        }
        system.debug(lstOfDocs + ' *********8lstOfDocs');
        selectedChildObject = ApexPages.currentPage().getParameters().get('objectName');
        parentObject = ApexPages.currentPage().getParameters().get('objectName');
        DocId = ApexPages.currentPage().getParameters().get('DocTempId');
        EmailId = ApexPages.currentPage().getParameters().get('EmailTempId');
        TemplateType = ApexPages.currentPage().getParameters().get('TemplateType');
        if(TemplateType == 'Word Document'){
            recordTypeId = [select id,Name from recordType where developerName ='Junodoc_Word_Template'].Id;
            
        }
        else if(TemplateType == 'Excel'){
            // recordTypeId = [select id,Name from recordType where developerName ='Excel_Template'].Id;
        }
        else{
            TemplateType = 'PDF';
            recordTypeId = [select id,Name from recordType where developerName ='PDF_Template'].Id;
        }
        system.debug(DocId + ' DocId*********************');
        system.debug(recordTypeId + ' recordTypeId*********************');
        system.debug(parentObject + ' parentObject*********************');
        if(parentObject != null && parentObject != ''){
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(parentobject);
            parentLabel = leadSchema.getDescribe().getLabel();
        }
        if(DocId != null){
            DoctemplateName = [select Id,Name from JunoDoc__Doc_Template__c where Id =: DocId].Name;
            JunoDoc__Doc_Template__c DocTemplateRec = [select Id,Name,
                                                       JunoDoc__Date_Format__c,
                                                       JunoDoc__Hide_Header__c,
                                                       JunoDoc__Hide_Footer__c,
                                                       JunoDoc__Show_Page_Number__c,
                                                       JunoDoc__Calculation_Fields__c,
                                                       
                                                       JunoDoc__page_size__c,
                                                       JunoDoc__Currency_Format__c,
                                                       JunoDoc__Number_Format__c,
                                                       JunoDoc__Currency_Symbol__c,
                                                       JunoDoc__PDF_Name__c,
                                                       JunoDoc__Blank_Fields_As_Zeroes__c,
                                                       JunoDoc__Doc_Template_Header__c,
                                                       JunoDoc__API_Name__c,
                                                       JunoDoc__Template_Type__c,
                                                       JunoDoc__Doc_Template_Header__r.JunoDoc__Header_Body__c,
                                                       JunoDoc__Doc_Template_Header__r.Name,
                                                       JunoDoc__Doc_Template_Footer__c,
                                                       JunoDoc__Doc_Template_Footer__r.Name,
                                                       JunoDoc__Doc_Template_Footer__r.Footer_Body__c 
                                                       from JunoDoc__Doc_Template__c where Id =: DocId];
            calculatedFields = DocTemplateRec.JunoDoc__Calculation_Fields__c;
            OldcalculatedFields = DocTemplateRec.JunoDoc__Calculation_Fields__c;
            currencySymbol = DocTemplateRec.JunoDoc__Currency_Symbol__c;    
            TemplateType = DocTemplateRec.JunoDoc__Template_Type__c;    
            APINAME = DocTemplateRec.JunoDoc__API_Name__c;
            string widths = '';
            string heights = '';
            if(pagesize == 'A3'){
                widths = '842px';
                heights = '1191px';
            }
            else if(pagesize == 'A4 Letter'){
                
                widths =  '612px'; //'912px';  
                heights = '791px'; //1000px';
            }
            else if(pagesize == 'US Letter'){
                
                widths =  '816px'; //'912px';  
                heights = '1056px'; //1000px';
            }
            else if(pagesize == 'A4 Legal'){
                widths = '612px';
                heights = '1006px';
            }
            else if(pagesize == 'A5'){
                widths = '422px';
                heights = '595px';
            }
            else if(pagesize == 'Label 4x6'){
                widths = '291px';
                heights = '460px';
            }
            else if(pagesize == 'Landscape'){
                widths = '1000px';
                heights = '580px'; 
            }
            else{
                widths = '842px';
                heights = '1191px';
                pagesize = 'A3';
            }
            DocTemp = [select id,JunoDoc__Template_body__c,JunoDoc__Page_Render__c from JunoDoc__Doc_Template_Item__c where JunoDoc__Doc_Template__c =: DocId order by Name ASC];
            integer pageInsize = 1;     
            for(JunoDoc__Doc_Template_Item__c ItemDocs : DocTemp){  
                pageInnerclass pageInner = new pageInnerclass();    
                pageInner.pageNumber = pageInsize;  
                pageInner.pagecondition = ItemDocs.JunoDoc__Page_Render__c; 
                pageInnerlist.add(pageInner);   
                pageInsize = pageInsize + 1;    
            }   
            hideFooter = false; 
            DateFormats = DocTemplateRec.JunoDoc__Date_Format__c ;  
            pageWidth = DocTemplateRec.Page_Width__c;
            pageHeight = DocTemplateRec.Page_height__c;
            if(pagesize == 'Custom'){
                if(pageWidth != null){
                    if(pageWidth > 0){
                        widths = (pageWidth*96)+'px';
                    }
                    else{
                        widths = '842px';
                    }
                }
                else{
                    widths = '842px';
                }
                if(pageHeight != null){
                    if(pageHeight > 0){
                        heights = (pageHeight*96)+'px';
                    }
                    else{
                        heights = '1191px';
                    }
                    
                }
                else{
                    heights = '1191px';
                }
            }
            CurrencyFormat = DocTemplateRec.JunoDoc__Currency_Format__c;    
            NumberFormat = DocTemplateRec.JunoDoc__Number_Format__c;    
            pdfName = DocTemplateRec.JunoDoc__PDF_Name__c;  
            hideHeader = false; 
            hideFooter = false; 
            if(DocTemplateRec.JunoDoc__Hide_Header__c != null)  
                hideHeader = DocTemplateRec.JunoDoc__Hide_Header__c;    
            if(DocTemplateRec.JunoDoc__Hide_Footer__c != null)  
                hideFooter = DocTemplateRec.JunoDoc__Hide_Footer__c;    
            showPageNumber = DocTemplateRec.JunoDoc__Show_Page_Number__c;   
            blankasZeroes = DocTemplateRec.JunoDoc__Blank_Fields_As_Zeroes__c;  
            DocTemplateBody = '';
            //if(TemplateType != 'Word Document'){
             if(TemplateType != 'Word Document' && TemplateType != 'Excel' && TemplateType != 'PDF New'){   
                DocTemplateBody += '<div class="tab" style="width: 842px;margin-bottom: 2px;display:inline-flex;">';
                DocTemplateBody += '<a class="tablinks active slds-box slds-box_small hoverclass" onclick="openCity(event, \'content_area\')" style = "width:8%; height:5%; padding-top:6px;padding-bottom:6px; margin-right:10px; text-decoration: none;"><b><center>Body</center></b></a><br/>';
                DocTemplateBody += '<a class="tablinks slds-box slds-box_small hoverclass" onclick="openCity(event, \'content_area_header\')" style = "width:10%; height:5%; padding-top:6px;padding-bottom:6px; margin-right:10px; text-decoration: none;"><b><center>Header</center></b></a><br/>';
                DocTemplateBody += '<a class="tablinks slds-box slds-box_small hoverclass" onclick="openCity(event, \'content_area_footer\')" style = "width:10%; height:5%; padding-top:6px;padding-bottom:6px; text-decoration: none;"><b><center>Footer</center></b></a><br/>';
                DocTemplateBody += '</div>';
                integer l = 1;
                for(JunoDoc__Doc_Template_Item__c ItemDocs : DocTemp){  
                    if(l > 1){
                        DocTemplateBody += '<div class = "invoice-container" id="page'+l+'" style = "width:'+widths+'">';
                        DocTemplateBody  +=  '<div class = "invoice-content-box ui-droppable" id = "content_area" style = "height:'+heights+'">'+ ItemDocs.JunoDoc__Template_body__c+'</div>';
                        DocTemplateBody += '</div>';
                    }
                    else{
                        DocTemplateBody += '<div class = "invoice-container" id = "page'+l+'" style = "width:'+widths+'">';
                        if(DocTemplateRec.JunoDoc__Doc_Template_Header__c != null){
                            DocTemplateBody +=  '<div class = "invoice-header-box ui-droppable tabcontent" id = "content_area_header" style = "height:100px;">'+ DocTemplateRec.JunoDoc__Doc_Template_Header__r.JunoDoc__Header_Body__c + '</div>';
                            HeaderId = DocTemplateRec.JunoDoc__Doc_Template_Header__c;
                            HeaderName = DocTemplateRec.JunoDoc__Doc_Template_Header__r.Name;
                        }
                        else{
                            DocTemplateBody +=  '<div class = "invoice-header-box ui-droppable tabcontent" id = "content_area_header" style = "height:100px;"></div>';
                        }
                        DocTemplateBody  +=  '<div class = "invoice-content-box tabcontent actives ui-droppable" id = "content_area" style = "height: '+heights+';">';
                        if(ItemDocs.JunoDoc__Template_body__c != null){
                            DocTemplateBody  +=  ItemDocs.JunoDoc__Template_body__c;
                        }
                        DocTemplateBody += '</div>';
                        
                        if(DocTemplateRec.JunoDoc__Doc_Template_Footer__c != null){
                            DocTemplateBody +=  '<div class = "invoice-header-box ui-droppable tabcontent" id = "content_area_footer" style = "height:100px;">'+DocTemplateRec.JunoDoc__Doc_Template_Footer__r.JunoDoc__Footer_Body__c + '</div>';
                            FooterId = DocTemplateRec.JunoDoc__Doc_Template_Footer__c;
                            FooterName = DocTemplateRec.JunoDoc__Doc_Template_Footer__r.Name;
                        }
                        else{
                            DocTemplateBody +=  '<div class = "invoice-header-box ui-droppable tabcontent" id="content_area_footer" style = "height:100px;"></div>'; 
                        }
                        DocTemplateBody += '</div>';
                    }
                    l = l+1;
                }
            }
            //else if(TemplateType == 'Word Document' || TemplateType == 'Excel'){
            else if(TemplateType == 'Word Document' || TemplateType == 'Excel' || TemplateType == 'PDF New'){
                integer l = 1;
                for(JunoDoc__Doc_Template_Item__c ItemDocs : DocTemp){  
                    if(l > 1){
                        
                        DocTemplateBody += '<div class = "invoice-container" id="page'+l+'" style = "width:790px">';  
                        DocTemplateBody  +=  '<div class = "invoice-body-part main-row" id = "invoice-body-part" style = "max-width: 790px;height: 880px; min-height: 105px;">'+ ItemDocs.JunoDoc__Template_body__c+'</div>';
                        DocTemplateBody += '</div>';
                    }
                    else{
                        DocTemplateBody += '<div class = "invoice-container" id="page'+l+'" style = "width:790px">';
                        if(DocTemplateRec.JunoDoc__Doc_Template_Header__c != null){
                            DocTemplateBody +=  '<div class = "invoice-header-part main-row" id = "invoice-header-part" style = "height:auto; min-height: 105px;max-width: 790px;">'+ DocTemplateRec.JunoDoc__Doc_Template_Header__r.JunoDoc__Header_Body__c + '</div>';
                            HeaderId = DocTemplateRec.JunoDoc__Doc_Template_Header__c;
                            HeaderName = DocTemplateRec.JunoDoc__Doc_Template_Header__r.Name;
                        }
                        else{
                            DocTemplateBody +=  '<div class = "invoice-header-part main-row" id = "invoice-header-part" style = "height:auto; min-height: 105px;max-width: 790px;"></div>';
                        }
                        DocTemplateBody  +=  '<div class="invoice-body-part main-row" id="invoice-body-part" style="max-width: 790px;height: 880px; min-height: 105px;">';
                        if(ItemDocs.JunoDoc__Template_body__c != null){
                            DocTemplateBody  +=  ItemDocs.JunoDoc__Template_body__c;
                        }
                        DocTemplateBody += '</div>';
                        
                        if(DocTemplateRec.Doc_Template_Footer__c != null){
                            DocTemplateBody +=  '<div class="invoice-footer-part main-row" id="invoice-footer-part" style="height:auto;  min-height: 105px;max-width: 790px;">'+DocTemplateRec.JunoDoc__Doc_Template_Footer__r.JunoDoc__Footer_Body__c + '</div>';
                            FooterId = DocTemplateRec.JunoDoc__Doc_Template_Footer__c;
                            FooterName = DocTemplateRec.JunoDoc__Doc_Template_Footer__r.Name;
                        }
                        else{
                            DocTemplateBody +=  '<div class="invoice-footer-part main-row" id="invoice-footer-part" style="height:auto;  min-height: 105px;max-width: 790px;"></div>'; 
                        }
                        DocTemplateBody += '</div>';
                    }
                    l = l+1;
                }
            }
            list<JunoDoc__Calculated_Fields__c> calFieldsList = [select id, 
                                                                 JunoDoc__Calculated_Field__c,  
                                                                 JunoDoc__Calculated_Field_Query__c 
                                                                 from JunoDoc__Calculated_Fields__c 
                                                                 where JunoDoc__Junodoc_Templates__c =: DocId ];    
            NewcalculatedFields = '';                                                                       
            for(JunoDoc__Calculated_Fields__c calFieldsListrec :  calFieldsList){   
                NewcalculatedFields += calFieldsListrec.JunoDoc__Calculated_Field__c + ';'; 
            }   
            
            system.debug(DocTemplateBody + '*********************');    
            list<JunoDoc__Doc_Template_Child__c> DocChilds = [select id,    
                                                              JunoDoc__Child_object__c, 
                                                              JunoDoc__Child_Query__c,  
                                                              JunoDoc__Available_Fields__c, 
                                                              JunoDoc__Group_By__c, 
                                                              JunoDoc__Group_By_Calculation__c, 
                                                              JunoDoc__Rollup_groupby__c,   
                                                              JunoDoc__Child_Group_by__c,   
                                                              JunoDoc__Color_1__c,  
                                                              JunoDoc__Color_2__c,  
                                                              JunoDoc__Filter__c,   
                                                              JunoDoc__border__c,   
                                                              JunoDoc__height__c,   
                                                              JunoDoc__padding__c,  
                                                              JunoDoc__Aggregate_Query__c,  
                                                              JunoDoc__Header_style__c, 
                                                              JunoDoc__Related_object_Labels__c,    
                                                              JunoDoc__Render_Condition__c, 
                                                              JunoDoc__Calculation_Fields__c,   
                                                              JunoDoc__Parent_Reference__c, 
                                                              JunoDoc__Sort_Order__c,JunoDoc__order_by__c   
                                                              from JunoDoc__Doc_Template_Child__c   
                                                              where JunoDoc__Doc_Template__c =: DocId];     
            system.debug(DocChilds + '*********************');  
            ChildInnerClasseslist = new list<ChildInnerClasses>();  
            
            for(Doc_Template_Child__c DocChild : DocChilds){    
                ChildInnerClasses ChildInner = new ChildInnerClasses(); 
                ChildInner.FieldNames = DocChild.JunoDoc__Child_Query__c;   
                ChildInner.parentObject = parentObject; 
                ChildInner.sortorder = integer.valueof(DocChild.JunoDoc__Sort_Order__c);    
                ChildInner.ChildObject = DocChild.JunoDoc__Child_object__c; 
                ChildInner.color1 = DocChild.JunoDoc__Color_1__c;       
                ChildInner.color2 = DocChild.JunoDoc__Color_2__c;       
                ChildInner.Padding = DocChild.JunoDoc__Padding__c;      
                ChildInner.Border = DocChild.JunoDoc__border__c;    
                ChildInner.height = DocChild.JunoDoc__height__c;    
                ChildInner.AvailableFieldNames = DocChild.JunoDoc__Available_Fields__c;     
                ChildInner.FieldLabels = DocChild.Related_object_Labels__c; 
                ChildInner.DocChildId = DocChild.Id;    
                ChildInner.condition = DocChild.JunoDoc__Filter__c; 
                ChildInner.rendercondition = DocChild.JunoDoc__Render_Condition__c; 
                ChildInner.orderby = DocChild.JunoDoc__order_by__c; 
                ChildInner.Groupby = DocChild.JunoDoc__Group_by__c; 
                CHildInner.isRollup = DocChild.JunoDoc__Rollup_groupby__c;  
                ChildInner.childGroupby = DocChild.JunoDoc__Child_Group_by__c;  
                ChildInner.grpcal = DocChild.JunoDoc__Group_By_Calculation__c;  
                ChildInner.Headerstyle = DocChild.JunoDoc__Header_style__c; 
                ChildInner.aggregatequery = DocChild.JunoDoc__Aggregate_Query__c;
                ChildInner.extraField = DocChild.JunoDoc__Extra_Fields__c;
                ChildInnerClasseslist.add(ChildInner);  
                if(DocChild.JunoDoc__Filter__c != null){    
                    String[] ChildFiltercon = DocChild.JunoDoc__Filter__c.split(' AND ');   
                    system.debug('ChildFiltercon *** '+ ChildFiltercon);    
                    for(string str : ChildFiltercon){   
                        String[] ChildFiltercons = str.split(' ');  
                        system.debug('ChildFiltercons *** '+ ChildFiltercons);  
                        string condmap = '';    
                        if(!ChildFiltercons[0].contains('(NOT')){
                            if(ChildFiltercons[1] == '>'){
                                condmap = 'greater than';
                            }
                            if(ChildFiltercons[1] == '='){
                                condmap = 'equals';
                            }
                            if(ChildFiltercons[1] == '!='){
                                condmap = 'not equals';
                            }
                            if(ChildFiltercons[1] == '<'){
                                condmap = 'less than';
                            }
                            if(ChildFiltercons[1] == 'like'){
                                condmap = 'contains';
                            }
                            
                            isFilters = true;
                            string childvalue = null;
                            if(ChildFiltercons.size() > 2){
                                childvalue = ChildFiltercons[2].replace('ssz','').replace('%','').replace('\'','');
                            }
                            WrapperClass Wrap = new WrapperClass(count, ChildFiltercons[0], false, condmap, null, childvalue,''+DocChild.JunoDoc__Sort_Order__c);   
                            if(DocChild.JunoDoc__Group_By__c != '' && DocChild.JunoDoc__Group_By__c != null)    
                                Wrap.isGroup = true;    
                            wrapperList.add(Wrap);
                        }
                        if(ChildFiltercons[0].contains('(NOT')){
                            
                            if(ChildFiltercons[2] == 'like'){
                                condmap = 'not contains';
                            }
                            isFilters = true;
                            string childvalue = null;
                            if(ChildFiltercons.size() > 3){
                                childvalue = ChildFiltercons[3].replace('ssz','').replace('%','').replace('\'','');
                            }
                            WrapperClass Wrap = new WrapperClass(count, ChildFiltercons[1], false, condmap, null, childvalue,''+DocChild.JunoDoc__Sort_Order__c);   
                            if(DocChild.JunoDoc__Group_By__c != '' && DocChild.JunoDoc__Group_By__c != null)    
                                Wrap.isGroup = true;    
                            wrapperList.add(Wrap);
                        }
                        count++;
                    }
                }
                
            }
            ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
            loadstring = '<script> loadscript() </script>';
        }
        if(EmailId != null){
            EmailtemplateName = [select Id,Name from JunoDoc__Email_Template__c where Id =: EmailId].Name;
            JunoDoc__Email_Template__c EmailTemplateRec = [select Id,Name,
                                                           JunoDoc__Calculation_Fields__c,
                                                           JunoDoc__page_size__c
                                                           from JunoDoc__Email_Template__c where Id =: EmailId];
            
            EmailTemps = [select id,JunoDoc__Template_body__c,JunoDoc__Subject__c from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: EmailId];
            Subject = EmailTemps[0].JunoDoc__Subject__c;
            calculatedFields = EmailTemplateRec.JunoDoc__Calculation_Fields__c;
            OldcalculatedFields = EmailTemplateRec.JunoDoc__Calculation_Fields__c;
            widthContainer = EmailTemplateRec.Width__c;
                if(widthContainer == null || widthContainer == ''){
                     widthContainer = '1191px';
                }
            pagesize = EmailTemplateRec.JunoDoc__page_size__c;
            string widths = '';
            string heights = '';
            if(pagesize == 'A3'){
                widths = '842px';
                heights = '1191px';
            }
            else if(pagesize == 'A4 Letter'){
                widths = '612px';
                heights = '791px';
            }
            else if(pagesize == 'A4 Legal'){
                widths = '612px';
                heights = '1006px';
            }
            else if(pagesize == 'A5'){
                widths = '422px';
                heights = '595px';
            }
            else if(pagesize == 'Label 4x6'){
                widths = '291px';
                heights = '460px';
            }
            else{
                widths = '842px';
                heights = widthContainer;
                pagesize = 'A3';
            }
            DocTemplateBody = '';
              //  DocTemplateBody += '<div class="tab" style="width:842px;margin-bottom: 2px;">';
    // DocTemplateBody += '<a class="tablinks active" onclick="openCity(event, \'content_area\')">Body</a>';
    // DocTemplateBody += '<a class="tablinks" onclick="openCity(event, \'content_area_header\')">Header</a>';
    // DocTemplateBody += '<a class="tablinks" onclick="openCity(event, \'content_area_footer\')">Footer</a>';
    // DocTemplateBody += '</div>'; 
            integer k = 1;
            for(JunoDoc__Email_Template_Item__c ItemDocs : EmailTemps){ 
                if(k > 1){
                    
                    DocTemplateBody += '<div class="invoice-container" id="page'+k+'" style="width:'+widths+'">';
                    DocTemplateBody  +=  '<div class="invoice-content-box ui-droppable" id="content_area" style="height:'+heights+'">'+ ItemDocs.JunoDoc__Template_body__c+'</div>';
                    DocTemplateBody += '</div>';
                }
                else{
                    DocTemplateBody += '<div class="invoice-container" id="page'+k+'" style="width:'+widths+'">';
                    //   DocTemplateBody +=  '<div class="invoice-header-box ui-droppable tabcontent" id="content_area_header" style="height:100px;"></div>';
                    DocTemplateBody  +=  '<div class="invoice-content-box tabcontent actives ui-droppable" id="content_area" style="height: '+heights+';">';
                    if(ItemDocs.JunoDoc__Template_body__c != null){
                        DocTemplateBody  +=  ItemDocs.JunoDoc__Template_body__c;
                    }
                    
                    DocTemplateBody += '</div>';
                    //   DocTemplateBody +=  '<div class="invoice-footer-box ui-droppable tabcontent" id="content_area_footer" style="height:100px;"></div>';
                    DocTemplateBody += '</div>';
                }
                k = k+1;    
            }
            system.debug(DocTemplateBody + '*********************');
            list<JunoDoc__Email_Template_Child__c> EmailChilds = [select id,
                                                                  JunoDoc__Child_object__c,
                                                                  JunoDoc__Child_Query__c,
                                                                  JunoDoc__Available_Fields__c,
                                                                  JunoDoc__Color_1__c,
                                                                  JunoDoc__Color_2__c,
                                                                  JunoDoc__border__c,
                                                                  
                                                                  JunoDoc__height__c,
                                                                  JunoDoc__Filter__c,
                                                                  JunoDoc__Render_Condition__c,
                                                                  
                                                                  JunoDoc__Parent_Reference__c,
                                                                  JunoDoc__Related_object_Labels__c,
                                                                  JunoDoc__Sort_Order__c,JunoDoc__Order_By__c
                                                                  from JunoDoc__Email_Template_Child__c 
                                                                  where JunoDoc__Email_Template__c =: EmailId]; 
            
            
            system.debug(EmailChilds + '*********************');
            ChildInnerClasseslist = new list<ChildInnerClasses>();
            for(Email_Template_Child__c EmailChild : EmailChilds){
                ChildInnerClasses ChildInner = new ChildInnerClasses();  
                ChildInner.color1 = EmailChild.JunoDoc__Color_1__c;  
                ChildInner.color2 = EmailChild.JunoDoc__Color_2__c;  
                ChildInner.Border = EmailChild.JunoDoc__border__c;   
                ChildInner.FieldNames = EmailChild.JunoDoc__Child_Query__c;
                ChildInner.parentObject = parentObject;
                ChildInner.sortorder = integer.valueof(EmailChild.JunoDoc__Sort_Order__c);
                ChildInner.ChildObject = EmailChild.JunoDoc__Child_object__c;
                ChildInner.AvailableFieldNames = EmailChild.JunoDoc__Available_Fields__c;    
                ChildInner.EmailChildId = EmailChild.Id;
                ChildInner.FieldLabels = EmailChild.JunoDoc__Related_object_Labels__c;
                ChildInner.condition = EmailChild.JunoDoc__Filter__c;
                ChildInner.rendercondition = EmailChild.JunoDoc__Render_Condition__c;
                ChildInner.orderby = EmailChild.JunoDoc__order_by__c;
                ChildInner.height = EmailChild.JunoDoc__height__c;
                ChildInnerClasseslist.add(ChildInner);
                if(EmailChild.JunoDoc__Filter__c != null){
                    String[] ChildFiltercon = EmailChild.JunoDoc__Filter__c.split(' AND ');
                    system.debug('ChildFiltercon *** '+ ChildFiltercon);
                    for(string str : ChildFiltercon){
                        String[] ChildFiltercons = str.split(' ');
                        system.debug('ChildFiltercons *** '+ ChildFiltercons);
                        string condmap = '';
                        if(!ChildFiltercons[0].contains('(NOT')){
                            if(ChildFiltercons[1] == '>'){
                                condmap = 'greater than';
                            }
                            if(ChildFiltercons[1] == '='){
                                condmap = 'equals';
                            }
                            if(ChildFiltercons[1] == '!='){
                                condmap = 'not equals';
                            }
                            if(ChildFiltercons[1] == '<'){
                                condmap = 'less than';
                            }
                            if(ChildFiltercons[1] == 'like'){
                                condmap = 'contains';
                            }
                            
                            isFilters = true;
                            string childvalue = null;
                            if(ChildFiltercons.size() > 2){
                                childvalue = ChildFiltercons[2].replace('ssz','').replace('%','').replace('\'','');
                            }
                            wrapperList.add(new WrapperClass(count, ChildFiltercons[0], false, condmap, null, childvalue,''+EmailChild.JunoDoc__Sort_Order__c));
                        }
                        if(ChildFiltercons[0].contains('(NOT')){
                            
                            if(ChildFiltercons[2] == 'like'){
                                condmap = 'not contains';
                            }
                            isFilters = true;
                            string childvalue = null;
                            if(ChildFiltercons.size() > 3){
                                childvalue = ChildFiltercons[3].replace('ssz','').replace('%','').replace('\'','');
                            }
                            wrapperList.add(new WrapperClass(count, ChildFiltercons[1], false, condmap, null, childvalue,''+EmailChild.JunoDoc__Sort_Order__c));
                        }
                        count++;
                    }
                }
                
            }
            ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
            loadstring = '<script> loadscript() </script>';
        }
        
        system.debug(selectedChildObject);
        if(selectedChildObject != null){
            getparentobjectFields();
            fillparentChildObject();
            selectedParentObject = selectedChildObject;
            getChildObjectFields();
            parentToChildObject();
            
        }
    }
    
    
    global void filterdropdown(){
        folderLst = new List<SelectOption>();
        folderLst.add(new SelectOption('','All'));
        for(string str: existingfoldrLst){
            folderLst.add(new SelectOption(str,str));
        }
    }
    // ******Created for Remote site*** 
    global String Host {get;set;}
    global String ConnnectionName {get;set;}
    global String MetadataResponse {get;set;}
    global Boolean MetadataConnectionWarning {get;set;}
    global PageReference checkMetadataAPIConnection()
    { 
        Host = ApexPages.currentPage().getHeaders().get('Host'); 
        ConnnectionName='callout'; 
        MetadataConnectionWarning = false;
        return null;
    }
    
    
    global list<parentInnerClass> parentobjectFields{get;set;}
    global void getparentobjectFields(){
        parentobjectFields = new list<parentInnerClass>();
        mpOfFieldsLabels = new map<string,string>();
        system.debug('parentobject **** '+ parentobject);
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(parentobject);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            String LblName=fieldMap.get(fieldName).getDescribe().getLabel()+'';
            String fieldNames=fieldMap.get(fieldName).getDescribe().getName()+'';
            parentInnerClass parentclass = new parentInnerClass();
            parentclass.parentName = '{!'+fieldNames + '}';
            parentclass.rendparentName = '{{'+ fieldNames + '}}';
            parentclass.parentLabel = LblName;
            parentobjectFields.add(parentclass);
        }
    }
    
    global class parentInnerClass{
        global string parentName{get;set;}
        global string rendparentName{get;set;}
        global string parentLabel{get;set;}
    }
    global Map<string,string> CalculateFieldsMap{get;set;}
    global list<string> CalculateFields{get;set;}
    global void getChildObjectFields(){
        childObjectFields = new list<string>();
        CalculateFields = new list<string>();
        CalculateFieldsMap = new map<string,string>();
        system.debug('selectedChildObject **** '+ selectedChildObject);
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedChildObject);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        Fields = new List<SelectOption>();
        for (String fieldName: fieldMap.keySet()) {
            childObjectFields.add(string.valueOf(fieldName));
            Fields.add(new SelectOption(fieldName, fieldMap.get(fieldName).getDescribe().getLabel()));
            childObjectLabelsMap.put(string.valueOf(fieldName),string.valueOf(fieldMap.get(fieldName).getDescribe().getLabel()));
            if(string.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'CURRENCY'
               || string.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'NUMBER'
               || string.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'DOUBLE'
               || string.valueOf(fieldMap.get(fieldName).getDescribe().getType()) == 'DECIMAL'){
                   CalculateFields.add(string.valueOf(fieldName));
                   CalculateFieldsMap.put(string.valueOf(fieldName),string.valueOf(fieldMap.get(fieldName).getDescribe().getLabel()));
                   
               }
        }
        LabelsMapJson = JSON.serialize(childObjectLabelsMap);
        loadstrings = '';
        system.debug('--------'+Wrapperlist);
    }
    global Map<string,string> ChildobjGetNamemap;
    Private void fillparentChildObject(){
        Set<String> setOfChildObjName =new Set<String>();
        ChildobjGetNamemap = new Map<string,string>();
        Schema.DescribeSObjectResult R = Schema.getGlobalDescribe().get(parentObject).getDescribe();
        for (Schema.ChildRelationship cr: R.getChildRelationships()) {
            string sobjects = ''+cr.getChildSObject();
            if (!sobjects.containsignorecase('history') && 
                !sobjects.containsignorecase('tag') && 
                !sobjects.containsignorecase('share') && 
                !sobjects.containsignorecase('feed') &&
                !sobjects.containsignorecase('Action') && 
                !sobjects.containsignorecase('Collab') && 
                !sobjects.containsignorecase('ProcessInstance') &&
                !sobjects.containsignorecase('ChangeEvent') && 
                !sobjects.containsignorecase('ErrorEvent') && 
                sobjects != 'Event' &&
                !sobjects.containsignorecase('Attachment') && 
                !sobjects.containsignorecase('Document') && 
                !sobjects.containsignorecase('Content') && 
                !sobjects.containsignorecase('Activity') && 
                !sobjects.containsignorecase('Email') &&
                !sobjects.containsignorecase('Task') && 
                !sobjects.containsignorecase('FlowRecordRelation') && 
                !sobjects.containsignorecase('EntitySubscription') ) { 
                    //if(isAccessibleObject.contains(cr.getChildSObject()+'')){ 
                    if(!setOfChildObjName.contains(cr.getChildSObject()+'')){
                        setOfChildObjName.add(cr.getChildSObject()+'');
                        ChildobjGetNamemap.put(cr.getChildSObject()+'' ,''+cr.getField());
                    } 
                }
        }           
        //Fill parant child Object Names
        List<String> lstOfChildObjectNames =new List<String>();
        for(String s:setOfChildObjName){
            lstOfChildObjectNames.add(s);
        }             
        mapOfParantToChildNames.put(parentObject,lstOfChildObjectNames);
        
    }
    
    //Fill selected parent Child Object
    global void parentToChildObject(){
        childObjects.clear();
        childObjects = mapOfParantToChildNames.get(selectedParentObject);      
    }
    
    global pageReference SaveData(){
        loadstrings = '';
        loadstring = '';
        loadstringssave = '';
        system.debug('*************** '+ finalstring);
        //for(string str : mpOfObjFieldApi.get(parentObject)){
 //system.debug('str '+ str);
//if(string.valueof(finalstring).contains(str)){
//system.debug('str Succes '+ str);
//finalstring = finalstring.replace('<br>','<br/>');
//string replacestring  = str.replace('{!','').replace('}','');
//finalstring = string.valueof(finalstring).replace(str,'<apex:outputtext value="{!ParentRef[\''+replacestring+'\']}" ></apex:outputtext>');  
//}
//} 
        DocTemplateBody = InvoiceString;
        loadstringssave = '<script> loadscripts() </script>';
        string ChildparentFields = '';
        list<string> Finalstringlists = new list<string>(); 
        if(finalstring != null){    
            Finalstringlists = finalstring.split('seperatedocs');   
            for(string Finalsstr : Finalstringlists){   
                if(string.valueof(Finalsstr).contains('{!')){   
                    system.debug('contains ***********');   
                    string finalstrings = string.valueof(Finalsstr).replace('{!','xxwwwee');    
                    string[] finalstringlist = finalstrings.split('xxwwwee');   
                    integer i = 0;  
                    system.debug('finalstringlist ***********' + finalstringlist.size());   
                    for(string str : finalstringlist){  
                        system.debug('str ***********' + str);  
                        system.debug('str> ***********' + str.contains('}'));   
                        system.debug('str$ ***********' + str.contains('$'));   
                        system.debug('str# ***********' + str.contains('#'));   
                        system.debug('str() ***********' + str.contains('()')); 
                        system.debug('strIF ***********' + str.contains('IF('));    
                        system.debug('str i ***********' + i);  
                        if(str.contains('}') && i >= 1 && !str.contains('$') && !str.contains('#User') && !str.contains('()') && !str.contains('IF(') ){    
                            string[] lists =  str.split('}');   
                            ChildparentFields += lists[0] + ',';    
                        }   
                        i++;    
                    }                   
                }   
                if(string.valueof(Finalsstr).contains('{{')){   
                    string finalstrings = string.valueof(Finalsstr).replace('{{','xxwwwee');    
                    string[] finalstringlist = finalstrings.split('xxwwwee');   
                    integer i = 0;  
                    for(string str : finalstringlist){  
                        if(str.contains('}') && i >= 1  ){  
                            string[] lists =  str.split('}}');  
                            ChildparentFields += lists[0] + ',';    
                        }   
                        i++;    
                    }                   
                }       
            }               
        }
        
        
        if(ChildparentFields != ''){
            ChildparentFields = ChildparentFields.substring(0,ChildparentFields.length() - 1);
        }
        
        string HeaderparentFields = '';
        if(Headerstring != ''){
            if(string.valueof(Headerstring).contains('{!')){
                string finalstrings = string.valueof(Headerstring).replace('{!','xxwwwee');
                string[] finalstringlist = finalstrings.split('xxwwwee');
                integer i = 0;
                for(string str : finalstringlist){
                    if(str.contains('}') && i >= 1 && !str.contains('#User') && !str.contains('$') && !str.contains('()')){
                        string[] lists =  str.split('}');
                        HeaderparentFields += lists[0] + ',';
                    }
                    i++;
                }            
            }
        }
        
        if(HeaderparentFields != ''){
            HeaderparentFields = HeaderparentFields.substring(0,HeaderparentFields.length() - 1);
        }
        
        string FooterparentFields = '';
        if(string.valueof(Footerstring).contains('{!')){
            string finalstrings = string.valueof(Footerstring).replace('{!','xxwwwee');
            string[] finalstringlist = finalstrings.split('xxwwwee');
            integer i = 0;
            for(string str : finalstringlist){
                if(str.contains('}') && i >= 1 && !str.contains('#') && !str.contains('$') && !str.contains('()')){
                    string[] lists =  str.split('}');
                    FooterparentFields += lists[0] + ',';
                }
                i++;
            }            
        }
        
        if(FooterparentFields != ''){
            FooterparentFields = FooterparentFields.substring(0,FooterparentFields.length() - 1);
        }
        
        //  if(ChildInnerClassJson != '' && ChildInnerClassJson != null){
//list<ChildInnerClasses> ChildInnerClasseslists = (List<ChildInnerClasses>)System.JSON.deserialize(ChildInnerClassJson, List<ChildInnerClasses>.class);
//for(ChildInnerClasses child: ChildInnerClasseslists){
//if(child.renderFields != null){
//string[] renders = child.renderFields.split(',');
//for(string rend : renders){
//if(rend != null){
//ChildparentFields += child;
//}
//}
//}
//}
//}        
        
        JunoDoc__Doc_Template_Header__c DTH= new JunoDoc__Doc_Template_Header__c();
        system.debug(HeaderString.trim() + 'HeaderString ********************');
        if(HeaderString != null && HeaderString.trim() != ''){
            if(HeaderName == null || HeaderName == ''){
                HeaderName = DoctemplateName + ' Header';
            }
            if(Schema.sObjectType.JunoDoc__Doc_Template_Header__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.Name.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Master_Object__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Master_Object_Fields__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Header_Body__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.Name.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Master_Object__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Master_Object_Fields__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Header__c.fields.JunoDoc__Header_Body__c.isUpdateable()
              ){
                  DTH.Name = HeaderName;
                  DTH.JunoDoc__Master_Object__c = parentObject;
                  DTH.JunoDoc__Master_Object_Fields__c = HeaderparentFields;
                  DTH.JunoDoc__Header_Body__c = HeaderString;
                  if(HeaderId != null && ActionName != 'saveas'){
                      DTH.Id = headerId; 
                  }                   
                  upsert DTH;
              }
        }
        
        JunoDoc__Doc_Template_Footer__c DTF= new JunoDoc__Doc_Template_Footer__c();
        if(FooterString != null && FooterString.trim() != ''){
            if(FooterName == null || FooterName == ''){
                FooterName = DoctemplateName + ' Footer';
            }
            if(Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.Name.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Master_Object__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Master_Object_Fields__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Footer_Body__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.Name.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Master_Object__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Master_Object_Fields__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Footer__c.fields.JunoDoc__Footer_Body__c.isUpdateable()
              ){
                  DTF.Name = FooterName;
                  DTF.JunoDoc__Master_Object__c = parentObject;
                  DTF.JunoDoc__Master_Object_Fields__c = FooterparentFields;
                  DTF.JunoDoc__Footer_Body__c = FooterString;
                  if(HeaderId != null  && ActionName != 'saveas'){
                      DTF.Id = FooterId; 
                  }            
                  upsert DTF;
              }
        }
        pagesizes = pagesize;
        SuccessMessage = 'Doc Template Created successfully';
        JunoDoc__Doc_Template__c Doc = new JunoDoc__Doc_Template__c();
        if(Schema.sObjectType.Doc_Template__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.Name.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__page_size__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Date_Format__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Currency_Format__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Parent_Object__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Parent_Fields__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Doc_Template_Header__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Doc_Template_Footer__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.Name.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__page_size__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Date_Format__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Currency_Format__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Parent_Object__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Parent_Fields__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Doc_Template_Header__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Doc_Template__c.fields.JunoDoc__Doc_Template_Footer__c.isUpdateable()
          ){
              Doc.Name = DoctemplateName;                   
              Doc.JunoDoc__API_Name__c = APIName;   
              Doc.JunoDoc__page_size__c = pageSize;     
              Doc.JunoDoc__Date_Format__c = DateFormats;
              Doc.JunoDoc__Page_Width__c = pageWidth;
              Doc.JunoDoc__Page_height__c = pageHeight;
              Doc.JunoDoc__Currency_Format__c = CurrencyFormat; 
              Doc.JunoDoc__Number_Format__c = NumberFormat; 
              Doc.JunoDoc__PDF_Name__c = pdfName;   
              Doc.JunoDoc__Currency_Symbol__c = currencySymbol; 
              Doc.JunoDoc__Blank_Fields_As_Zeroes__c = blankasZeroes;   
              Doc.JunoDoc__Template_Type__c = TemplateType; 
              if(hideHeader != null)    
                  Doc.JunoDoc__Hide_Header__c = hideHeader; 
              Doc.JunoDoc__Hide_Footer__c = hideFooter; 
              system.debug('showPageNumber*************** '+ showPageNumber);
              Doc.JunoDoc__Show_Page_Number__c  = showPageNumber;   
              Doc.JunoDoc__Parent_Object__c = parentObject;
              system.debug('calculatedFields ***' + calculatedFields);
              Doc.JunoDoc__Calculation_Fields__c = OldcalculatedFields + calculatedFields;
              Doc.JunoDoc__Parent_Fields__c = ChildparentFields;
              if(DTH.Id != null && HeaderString != null && HeaderString.trim() != ''){
                  Doc.JunoDoc__Doc_Template_Header__c = DTH.Id;
              }
              else{
                  Doc.JunoDoc__Doc_Template_Header__c = null;
              }
              if(DTF.Id != null && FooterString != null && FooterString.trim() != ''){
                  Doc.JunoDoc__Doc_Template_Footer__c = DTF.Id;
              }
              else{
                  Doc.JunoDoc__Doc_Template_Footer__c = null;
              }
              if(DocId != null && ActionName != 'saveas'){
                  Doc.Id = DocId;
                  SuccessMessage = 'Doc Template Updated successfully';
              }
              else{
                  Doc.recordTypeId = recordTypeId;
              }
              
              upsert Doc;
          }
        Docid = Doc.Id;
        
        list<Calculated_Fields__c> CalculatedFieldsList = new list<Calculated_Fields__c>();
        for(calWrapperClass calWrapperClassrec : calWrapperClasslist){
            JunoDoc__Calculated_Fields__c calFieldsRec = new JunoDoc__Calculated_Fields__c();   
            calFieldsRec.JunoDoc__Calculated_Field__c = calWrapperClassrec.calField;    
            calFieldsRec.JunoDoc__Calculated_Field_Query__c = calWrapperClassrec.calQuery;  
            calFieldsRec.JunoDoc__Junodoc_Templates__c = Docid; 
            CalculatedFieldsList.add(calFieldsRec);
            
        }
        insert CalculatedFieldsList;
        calWrapperClasslist = new list<calWrapperClass>();
        list<JunoDoc__Doc_Template_Child__c> DocChildsList = [select id,JunoDoc__sort_order__c,JunoDoc__Child_object__c from JunoDoc__Doc_Template_Child__c where JunoDoc__Doc_Template__c =: Doc.Id];
        Map<string,string> DocChildsListMap = new Map<string,string>();
        if(DocChildsList.size() > 0){
            for(JunoDoc__Doc_Template_Child__c Docs : DocChildsList){
                DocChildsListMap.put(Docs.JunoDoc__Child_object__c + ''+Docs.JunoDoc__sort_order__c,Docs.Id);
            }
        }
        list<JunoDoc__Doc_Template_Item__c> listDocItems;
        if (Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.id.isAccessible()
            && Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.JunoDoc__Doc_Template__c.isAccessible()
           ) {
               listDocItems = [select id from JunoDoc__Doc_Template_Item__c where JunoDoc__Doc_Template__c =: Docid];
           }
        if(JunoDoc__Doc_Template_Item__c.sObjectType.getDescribe().isDeletable()){
            Delete listDocItems;
        }
        
        string Finalstringone = '';
        string Finalstringsec = '';
        string Finalstringthird = '';
        
        if(!Finalstringlists.isEmpty()){    
            
            list<JunoDoc__Doc_Template_Item__c> Itemslist = new list<JunoDoc__Doc_Template_Item__c>();  
            Map<integer,string> pageMap = new Map<integer,string>();    
            for(pageInnerclass pagein : pageInnerlist){ 
                pageMap.put(pagein.pagenumber,pagein.pagecondition);    
            }   
            integer finalcount = 1; 
            for(string finals : Finalstringlists){  
                system.debug('finals **' + finals); 
                JunoDoc__Doc_Template_Item__c Item = new JunoDoc__Doc_Template_Item__c();   
                Item.JunoDoc__Template_Body__c = finals;    
                Item.JunoDoc__Doc_Template__c = Doc.Id; 
                if(DocTemp.size() >= 1  && ActionName != 'saveas'){ 
                    //  Item.Id = DocTemp[0].Id;    
                }   
                if(pageMap.get(finalcount) != null){    
                    Item.JunoDoc__Page_Render__c = pageMap.get(finalcount); 
                }   
                else{   
                    Item.JunoDoc__Page_Render__c = '';  
                }   
                finalcount = finalcount+1;  
                Itemslist.add(Item);    
            }   
            if(Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.JunoDoc__Template_Body__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.JunoDoc__Doc_Template__c.isCreateable()   
               && Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.JunoDoc__Template_Body__c.isUpdateable()  
               && Schema.sObjectType.JunoDoc__Doc_Template_Item__c.fields.JunoDoc__Doc_Template__c.isUpdateable()){ 
                   upsert Itemslist;    
               }    
        }
        // if(finalstring.length() > 131072){
//Finalstringone = finalstring.substring(0,131072);
//if(finalstring.length() < 262145){
//Finalstringsec = finalstring.substring(131073,finalstring.length());
//}
//else{
//Finalstringsec = finalstring.substring(131073,262144);
//Finalstringthird = finalstring.substring(262145,finalstring.length());
//}
//}
//else{
//Finalstringone = finalstring; 
//}
//Doc_Template_Item__c Item = new Doc_Template_Item__c();
//Item.Template_Body__c = Finalstringone;
//Item.Doc_Template__c = Doc.Id;
//if(DocTemp.size() >= 1  && ActionName != 'saveas'){
//  Item.Id = DocTemp[0].Id;
//}
//upsert Item;

//if(Finalstringsec != ''){
//Doc_Template_Item__c Items = new Doc_Template_Item__c();
//Items.Template_Body__c = Finalstringsec;
//Items.Doc_Template__c = Doc.Id;
//if(DocTemp.size() >= 2  && ActionName != 'saveas'){
//  Items.Id = DocTemp[1].Id;
//}
//upsert Items;
//}
//if(Finalstringthird != ''){
//Doc_Template_Item__c DOcItems = new Doc_Template_Item__c();
//DOcItems.Template_Body__c = Finalstringthird;
//DOcItems.Doc_Template__c = Doc.Id;
//if(DocTemp.size() >= 3  && ActionName != 'saveas'){
// DOcItems.Id = DocTemp[2].Id;
//}
//upsert DOcItems;
//} 
        list<JunoDoc__Doc_Template_Child__c> DocTemplatechildList = new list<JunoDoc__Doc_Template_Child__c>();
        system.debug('  ****************************** ' + ChildInnerClassJson);
        if(ChildInnerClassJson != '' && ChildInnerClassJson != null){
            list<ChildInnerClasses> ChildInnerClasseslists = (List<ChildInnerClasses>)System.JSON.deserialize(ChildInnerClassJson, List<ChildInnerClasses>.class);
            system.debug('ChildInnerClasseslists **** '+ ChildInnerClasseslists);
            
            Map<integer,string> calculatemaps = new Map<integer,string>();
            if(!Finalstringlists.isEmpty()){    
                for(string finstr : Finalstringlists){  
                    if(string.valueof(finstr).contains('[{') ){ 
                        system.debug('********************** Goin');    
                        string finalstrings = string.valueof(finstr).replace('SUM(','xxwwwee'); 
                        finalstrings = finalstrings.replace('AVG(','xxwwwee');  
                        finalstrings = finalstrings.replace('PAR(','xxwwwee');  
                        string[] Chfinalstringlists = finalstrings.split('xxwwwee');    
                        integer i = 0;  
                        system.debug('finalstringlists ****'+ Chfinalstringlists);  
                        
                        for(string str : Chfinalstringlists){   
                            if(str.contains(')') && i >= 1 ){   
                                system.debug('str ****'+ str);  
                                String strs  = str.replace(')','xxeeww');   
                                string[] lists =  strs.split('xxeeww');     
                                string listrec = lists[0];  
                                for(ChildInnerClasses child: ChildInnerClasseslists){   
                                    string CalparentFields = '';    
                                    string sales = listrec.replace(''+child.sortorder,'');  
                                    system.debug(sales+'lists[0]' + listrec);   
                                    if(listrec == (sales +''+child.sortorder)){ 
                                        CalparentFields += listrec.replace(''+child.sortorder,'') + ',';    
                                    }   
                                    if(sales.contains('.')){    
                                        CalparentFields += listrec + ',';   
                                    }   
                                    if(calculatemaps.get(child.sortorder) == null){ 
                                        calculatemaps.put(child.sortorder,CalparentFields); 
                                    }   
                                    else{   
                                        CalparentFields += calculatemaps.get(child.sortorder);  
                                        calculatemaps.put(child.sortorder,CalparentFields); 
                                    }   
                                }   
                            }   
                            i++;    
                        }   
                    }   
                }   
            }
            
            //  if(CalparentFields != ''){
//CalparentFields = CalparentFields.substring(0,CalparentFields.length() - 1);
//}
            list<decimal> Sortorderlist = new list<decimal>();
            system.debug(ChildInnerClasseslists.size() + '  ChildInnerClasseslists ****************************** ');
            for(ChildInnerClasses child: ChildInnerClasseslists){
                Sortorderlist.add(child.sortorder);
                system.debug(child.ChildObject + '  ****************************** ' + child.sortorder);
                if(string.valueof(finalstring).contains(child.ChildObject+''+child.sortorder)){
                    string childRelationship = '';
                    childRelationship = ChildobjGetNamemap.get(child.ChildObject);
                    JunoDoc__Doc_Template_Child__c DocChild = new JunoDoc__Doc_Template_Child__c();
                    DocChild.JunoDoc__Child_Query__c = child.FieldNames;
                    DocChild.JunoDoc__Parent_Reference__c = childRelationship;
                    DocChild.JunoDoc__Sort_Order__c = integer.valueof(child.sortorder);
                    DocChild.JunoDoc__Child_object__c = child.ChildObject;
                    DocChild.JunoDoc__Available_Fields__c = child.AvailableFieldNames;
                    DocChild.JunoDoc__color_1__c = child.color1; 
                    DocChild.JunoDoc__color_2__c = child.color2; 
                    DocChild.JunoDoc__Padding__c = child.Padding; 
                    DocChild.JunoDoc__Border__c = child.Border;  
                    DOcChild.JunoDoc__height__c = child.height;
                    DocChild.JunoDoc__Filter__c = child.condition;  
                    DocChild.JunoDoc__Related_Object_Labels__c = child.FieldLabels;
                    DocChild.JunoDoc__Doc_Template__c = Doc.Id;
                    DocChild.JunoDoc__Calculation_Fields__c = calculatemaps.get(child.sortorder);  
                    DocChild.JunoDoc__Render_Condition__c = child.rendercondition;
                    DocChild.JunoDoc__Order_By__c = child.orderby;
                    DocChild.JunoDoc__Group_By__c = child.GroupBy;
                    DocChild.JunoDoc__Extra_Fields__c = child.extraField;
                    if(child.isRollup != null){ 
                        DocChild.JunoDoc__Rollup_groupby__c = child.isRollup;   
                    }   
                    else{   
                        DocChild.JunoDoc__Rollup_groupby__c = false;    
                    }   
                    DocChild.JunoDoc__Child_Group_By__c = child.childGroupBy;   
                    DocChild.JunoDoc__Group_By_Calculation__c = child.grpcal;
                    DocChild.JunoDoc__Aggregate_Query__c =  child.aggregatequery;
                    DocChild.JunoDoc__Header_style__c = child.HeaderStyle;
                    DocChild.JunoDoc__Header_Colour_background__c = child.HeaderBackground;
                    DocChild.JunoDoc__Border_Width__c = child.TableWidth;
                    DocChild.JunoDoc__Font_Size__c = child.Childfontstyle;
                    DocChild.JunoDoc__Table_grid__c = child.childborder;
                    DocChild.JunoDoc__Font_Color__c = child.childfontfamily;
                    
                    
                    if(ActionName != 'saveas'){
                        if(DocChildsListMap.get(child.ChildObject+''+child.sortorder) != null){
                            child.DocChildId = DocChildsListMap.get(child.ChildObject+''+child.sortorder);
                        }
                        DocChild.Id = child.DocChildId;
                    }
                    DocTemplatechildList.add(DocChild);
                }
            }
            if(Schema.sObjectType.JunoDoc__Doc_Template_Child__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Child_Query__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Parent_Reference__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Sort_Order__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Child_object__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Available_Fields__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__color_1__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__color_2__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Border__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__height__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Filter__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Related_Object_Labels__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Doc_Template__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Calculation_Fields__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Render_Condition__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Order_By__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Child_Query__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Parent_Reference__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Sort_Order__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Child_object__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Available_Fields__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__color_1__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__color_2__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Border__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__height__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Filter__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Related_Object_Labels__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Doc_Template__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Calculation_Fields__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Render_Condition__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Doc_Template_Child__c.fields.JunoDoc__Order_By__c.isUpdateable()){
                   upsert DocTemplatechildList;
               }
            system.debug(Sortorderlist + ' Sortorderlist');
            if(JunoDoc__Doc_Template_Child__c.sObjectType.getDescribe().isDeletable()) {
                Delete [select id from JunoDoc__Doc_Template_Child__c where JunoDoc__Doc_Template__c =: DocId and JunoDoc__Sort_Order__c NOT IN: Sortorderlist];
            }
            system.debug(finalstring + '<---- finalstring');
            system.debug(ActionName + '<---- ActionName');
            system.debug(ChildInnerClassJson + '<---- ChildInnerClassJson');
            system.debug(Headerstring + '<---- Headerstring');
            system.debug(FooterString + '<---- FooterString');
            system.debug(InvoiceString + '<---- InvoiceString');
            system.debug(pageSize + '<---- pageSize');
            system.debug(calculatedFields + '<---- calculatedFields');
        }
        if(ActionName == 'saveandclose' || ActionName == 'saveas'){
            pageReference pageref = new pageReference('/'+Docid);
            return pageref;
        }
        return null;
        
        
    }
    global pageReference SaveEmailData(){
        pagesizes = pagesize;
        loadstrings = '';
        loadstring = '';
        loadstringssave = '';
        string ChildparentFields = '';
        if(string.valueof(finalstring).contains('{!')){
            string finalstrings = string.valueof(finalstring).replace('{!','xxwwwee');
            string[] finalstringlist = finalstrings.split('xxwwwee');
            integer i = 0;
            for(string str : finalstringlist){
                if(str.contains('}') && i >= 1 && !str.contains('$') && !str.contains('()') && !str.contains('#')){
                    string[] lists =  str.split('}');
                    ChildparentFields += lists[0] + ',';
                }   
                i++;
            }            
        }  
        if(string.valueof(finalstring).contains('{{')){
            string finalstrings = string.valueof(finalstring).replace('{{','xxwwwee');
            string[] finalstringlist = finalstrings.split('xxwwwee');
            integer i = 0;
            for(string str : finalstringlist){
                if(str.contains('}') && i >= 1 ){
                    string[] lists =  str.split('}}');
                    ChildparentFields += lists[0] + ',';
                }
                i++;
            }                
        }
        
        
        if(ChildparentFields != ''){
            ChildparentFields = ChildparentFields.substring(0,ChildparentFields.length() - 1);
        }
        
        
        JunoDoc__Email_Template__c Email = new JunoDoc__Email_Template__c();
        Email.Name = EmailtemplateName; 
        if(widthContainer == null || widthContainer == ''){
            widthContainer = '1192';
        }
        Email.Width__c = widthContainer+ 'px';
        Email.JunoDoc__page_size__c = pageSize; 
        Email.JunoDoc__Parent_Object__c = parentObject;
        Email.JunoDoc__Parent_Fields__c = ChildparentFields;
        Email.JunoDoc__Calculation_Fields__c = OldcalculatedFields + calculatedFields;
        Email.JunoDoc__Date_Format__c = DateFormats;
        Email.JunoDoc__Currency_Format__c = CurrencyFormat;
        if(EmailId != null && ActionName != 'saveas'){
            Email.Id = EmailId;
        }
        if(Schema.sObjectType.JunoDoc__Email_Template__c.isCreateable()
           &&Schema.sObjectType.JunoDoc__Email_Template__c.fields.Name.isCreateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__page_size__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__Parent_Object__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__Parent_Fields__c.isCreateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.Name.isUpdateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__page_size__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__Parent_Object__c.isUpdateable()
           && Schema.sObjectType.JunoDoc__Email_Template__c.fields.JunoDoc__Parent_Fields__c.isUpdateable()){
               upsert Email;            
           }
        EmailId = Email.Id;
        list<JunoDoc__Email_Template_Child__c> DocChildsList = [select id,JunoDoc__sort_order__c,JunoDoc__Child_object__c from JunoDoc__Email_Template_Child__c where JunoDoc__EMail_Template__c =: Email.Id];
        Map<string,string> DocChildsListMap = new Map<string,string>();
        if(DocChildsList.size() > 0){
            for(JunoDoc__Email_Template_Child__c Docs : DocChildsList){
                DocChildsListMap.put(Docs.JunoDoc__Child_object__c + ''+Docs.JunoDoc__sort_order__c,Docs.Id);
            }
        }
        SuccessMessage = 'Email Template Created successfully';
        
        list<JunoDoc__Email_Template_Item__c> listDocItems;
        if (Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.id.isAccessible()
            || Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Email_Template__c.isAccessible()
           ){
               listDocItems = [select id from JunoDoc__Email_Template_Item__c where JunoDoc__Email_Template__c =: EmailId];
           }
        if(JunoDoc__Doc_Template_Child__c.sObjectType.getDescribe().isDeletable()) {
            Delete listDocItems;
        }
        
        if(finalstring != null){
            string[] Finalstringlist = finalstring.split('seperatedocs');
            list<JunoDoc__Email_Template_Item__c> Itemslist = new list<JunoDoc__Email_Template_Item__c>();
            Map<integer,string> pageMap = new Map<integer,string>();
            for(pageInnerclass pagein : pageInnerlist){
                pageMap.put(pagein.pagenumber,pagein.pagecondition); 
            }
            integer finalcount = 1;
            for(string finals : Finalstringlist){
                JunoDoc__Email_Template_Item__c Item = new JunoDoc__Email_Template_Item__c();
                Item.JunoDoc__Template_Body__c = finals;
                Item.JunoDoc__Subject__c = Subject;
                Item.JunoDoc__Email_Template__c = Email.Id;
                if(pageMap.get(finalcount) != null){
                    // Item.JunoDoc__Page_Render__c = pageMap.get(finalcount);
                }
                else{
                    // Item.JunoDoc__Page_Render__c = '';
                }
                finalcount = finalcount+1;
                Itemslist.add(Item);
            }
            if(Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Template_Body__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Subject__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Email_Template__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Template_Body__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Subject__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Item__c.fields.JunoDoc__Email_Template__c.isUpdateable()){
                   upsert Itemslist;
               }
        }
        list<JunoDoc__Email_Template_Child__c> EmailTemplatechildList = new list<JunoDoc__Email_Template_Child__c>();
        system.debug(ChildInnerClasseslist + '  ****************************** ');
        if(ChildInnerClassJson != '' && ChildInnerClassJson != null){
            list<ChildInnerClasses> ChildInnerClasseslists = (List<ChildInnerClasses>)System.JSON.deserialize(ChildInnerClassJson, List<ChildInnerClasses>.class);
            string CalparentFields = '';
            if(string.valueof(finalstring).contains('[{') ){
                system.debug('********************** Goin');
                string finalstrings = string.valueof(finalstring).replace('SUM(','xxwwwee');
                finalstrings = finalstrings.replace('AVG(','xxwwwee');
                finalstrings = finalstrings.replace('PAR(','xxwwwee');
                string[] finalstringlists = finalstrings.split('xxwwwee');
                integer i = 0;
                system.debug('finalstringlists ****'+ finalstringlists);
                for(string str : finalstringlists){
                    if(str.contains(')') && i >= 1 ){
                        system.debug('str ****'+ str);
                        String strs  = str.replace(')','xxeeww');
                        string[] lists =  strs.split('xxeeww'); 
                        for(ChildInnerClasses child: ChildInnerClasseslists){
                            string sales = lists[0].replace(''+child.sortorder,'');
                            system.debug(sales+'lists[0]' + lists[0]);
                            if(lists[0] == (sales +''+child.sortorder)){
                                CalparentFields += lists[0].replace(''+child.sortorder,'') + ',';
                            }
                            if(sales.contains('.')){
                                CalparentFields += lists[0] + ',';
                            }
                        }
                    }
                    i++;
                } 
            }
            
            if(CalparentFields != ''){
                CalparentFields = CalparentFields.substring(0,CalparentFields.length() - 1);
            }
            list<decimal> Sortorderlist = new list<decimal>();
            for(ChildInnerClasses child: ChildInnerClasseslists){
                Sortorderlist.add(child.sortorder);
                if(string.valueof(finalstring).contains(child.ChildObject+''+child.sortorder)){
                    string childRelationship = ''; 
                    childRelationship = ChildobjGetNamemap.get(child.ChildObject);
                    
                    JunoDoc__Email_Template_Child__c EmailChild = new JunoDoc__Email_Template_Child__c();
                    EmailChild.JunoDoc__Child_Query__c = child.FieldNames;
                    EmailChild.JunoDoc__Parent_Reference__c = childRelationship;
                    EmailChild.JunoDoc__Sort_Order__c = integer.valueof(child.sortorder);
                    EmailChild.JunoDoc__Child_object__c = child.ChildObject;
                    EmailChild.JunoDoc__Available_Fields__c = child.AvailableFieldNames;
                    EmailChild.JunoDoc__Email_Template__c = Email.Id;
                    EmailChild.JunoDoc__Related_Object_Labels__c = child.FieldLabels;
                    EmailChild.JunoDoc__color_1__c = child.color1;   
                    EmailChild.JunoDoc__color_2__c = child.color2;   
                    EmailChild.JunoDoc__Border__c = child.Border;  
                    EmailChild.JunoDoc__Filter__c = child.condition;  
                    EmailChild.JunoDoc__Render_Condition__c = child.rendercondition;
                    EmailChild.JunoDoc__Calculation_Fields__c = CalparentFields ;
                    EmailChild.JunoDoc__Order_By__c = child.orderby;
                    EmailChild.JunoDoc__height__c = child.height;
                    //     EmailChild.Padding__c = child.Padding; 
//EmailChild.Group_By__c = child.GroupBy;
//if(child.isRollup != null){
//EmailChild.JunoDoc__Rollup_groupby__c = child.isRollup;
//}
//else{
//EmailChild.JunoDoc__Rollup_groupby__c = false;
//}
//EmailChild.JunoDoc__Child_Group_By__c = child.childGroupBy;
//EmailChild.JunoDoc__Group_By_Calculation__c = child.grpcal;
//EmailChild.Aggregate_Query__c =  child.aggregatequery;
//EmailChild.Header_style__c = child.HeaderStyle;
//EmailChild.Header_Colour_background__c = child.HeaderBackground;
//EmailChild.Border_Width__c = child.TableWidth;
//EmailChild.Font_Size__c = child.Childfontstyle;
//EmailChild.Table_grid__c = child.childborder;
//EmailChild.Font_Color__c = child.childfontfamily;
                    if(ActionName != 'saveas'){
                        if(DocChildsListMap.get(child.ChildObject+''+child.sortorder) != null){
                            child.EmailChildId = DocChildsListMap.get(child.ChildObject+''+child.sortorder);
                        }
                        EmailChild.Id = child.EmailChildId;
                    }
                    EmailTemplatechildList.add(EmailChild);
                }
            }
            if(Schema.sObjectType.JunoDoc__Email_Template_Child__c.isCreateable() 
               &&Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Child_Query__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Parent_Reference__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Sort_Order__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Child_object__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Available_Fields__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Email_Template__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Related_Object_Labels__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__color_1__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__color_2__c.isCreateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Border__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Filter__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Render_Condition__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Calculation_Fields__c.isCreateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Child_Query__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Parent_Reference__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Sort_Order__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Child_object__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Available_Fields__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Email_Template__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Related_Object_Labels__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__color_1__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__color_2__c.isUpdateable() 
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Border__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Filter__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Render_Condition__c.isUpdateable()
               && Schema.sObjectType.JunoDoc__Email_Template_Child__c.fields.JunoDoc__Calculation_Fields__c.isUpdateable()){
                   upsert EmailTemplatechildList;
               }
            if(JunoDoc__Email_Template_Child__c.sObjectType.getDescribe().isDeletable()){
                Delete [select id from JunoDoc__Email_Template_Child__c where JunoDoc__Email_Template__c =: EmailId and  JunoDoc__Sort_Order__c NOT IN: Sortorderlist];
            }
            
        }
        if(ActionName == 'saveandclose' || ActionName == 'saveas'){
            pageReference pageref = new pageReference('/'+Emailid);
            return pageref;
        }
        return null;
    }
    
    global void deleteTables(){
        
        list<ChildInnerClasses> ChildInnerClasslists = new list<ChildInnerClasses>();
        list<string> strlist = new list<string>();
        if(deletestrings != null && deletestrings != ''){
            strlist = deletestrings.split(',');
        }
        system.debug('deletestrings 8888' + deletestrings);
        system.debug('ChildInnerClasseslist 8888' + ChildInnerClasseslist);
        for(ChildInnerClasses newchilds : ChildInnerClasseslist){
            for(string strs :strlist){
                system.debug(newchilds.sortorder + 'yyyy'+ strs);
                if(''+newchilds.sortorder == strs){
                    ChildInnerClasslists.add(newchilds);
                }
            }
        }
        ChildInnerClasseslist = ChildInnerClasslists;
        loadstringssave = '';
        loadstring = '';
        loadstrings = '';
        ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
    }
    global void CopyLineItems(){
        
        system.debug(ChildInnerClasseslist.size() + 'Sizzes');
        ChildInnerClasses childs =  new ChildInnerClasses();
        for(ChildInnerClasses newchilds : ChildInnerClasseslist){
            system.debug(newchilds.sortorder  + 'newSizzes' + OldSortorder);
            if(newchilds.sortorder == OldSortorder){
                childs = newchilds;
            }
        }
        
        
        
        ChildInnerClasses childInnerRec =  new ChildInnerClasses();
        childInnerRec.sortorder = integer.valueof(SortOrders);
        childInnerRec.FieldNames =  childs.FieldNames; 
        childInnerRec.FieldLabels =  childs.FieldLabels ; 
        childInnerRec.AvailableFieldNames = childs.AvailableFieldNames;
        childInnerRec.ChildObject = childs.ChildObject;
        childInnerRec.parentObject = childs.parentObject;
        childInnerRec.color1 = childs.color1 ; 
        childInnerRec.color2 = childs.color2 ; 
        childInnerRec.Padding = childs.Padding ; 
        childInnerRec.Border = childs.Border ; 
        childInnerRec.height = childs.height;
        childInnerRec.HeaderStyle = childs.HeaderStyle;
        childInnerRec.condition = childs.condition ;
        childInnerRec.renderFields = childs.renderFields ;
        childInnerRec.rendercondition = childs.rendercondition ;
         childInnerRec.extraField = childs.extraField;
        system.debug(childInnerRec  + 'childInnerRec');
        ChildInnerClasseslist.add(childInnerRec);
        count = 1;
        Wrapperlist = new list<WrapperClass>();
        for(ChildInnerClasses DocChild : ChildInnerClasseslist){
            if(DocChild.condition != null && DocChild.condition.length() > 2){
                String[] ChildFiltercon = DocChild.condition.split(' AND ');
                system.debug('ChildFiltercon *** '+ ChildFiltercon);
                for(string str : ChildFiltercon){
                    String[] ChildFiltercons = str.split(' ');
                    system.debug('ChildFiltercons *** '+ ChildFiltercons);
                    string condmap = '';
                    if(!ChildFiltercons[0].contains('(NOT')){
                        if(ChildFiltercons[1] == '>'){
                            condmap = 'greater than';
                        }
                        if(ChildFiltercons[1] == '='){
                            condmap = 'equals';
                        }
                        if(ChildFiltercons[1] == '!='){
                            condmap = 'not equals';
                        }
                        if(ChildFiltercons[1] == '<'){
                            condmap = 'less than';
                        }
                        if(ChildFiltercons[1] == 'like'){
                            condmap = 'contains';
                        }
                        system.debug(condmap + ' **** condmap');
                        isFilters = true;
                        string childvalue = null;
                        if(ChildFiltercons.size() > 2){
                            childvalue = ChildFiltercons[2].replace('ssz','').replace('%','').replace('\'','');
                        }
                        wrapperList.add(new WrapperClass(count, ChildFiltercons[0], false, condmap, null, childvalue,''+DocChild.sortorder));
                    }
                    if(ChildFiltercons[0].contains('(NOT')){
                        
                        if(ChildFiltercons[2] == 'like'){
                            condmap = 'not contains';
                        }
                        isFilters = true;
                        string childvalue = null;
                        if(ChildFiltercons.size() > 3){
                            childvalue = ChildFiltercons[3].replace('ssz','').replace('%','').replace('\'','');
                        }
                        wrapperList.add(new WrapperClass(count, ChildFiltercons[1], false, condmap, null, childvalue,''+DocChild.sortorder));
                    }
                    count++;
                }
            }
        }
        system.debug(wrapperList  + 'wrapperList');
        
        
        ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
        system.debug(ChildInnerClassJson  + 'ChildInnerClassJson');
        loadstringssave = '';
        loadstring = '';
        loadstrings = '';
        DocTemplateBody = InvoiceString;
        loadstrings = '<script> loadscripts() </script>';  
        
    }
    
    
    global void checksyntaxforaggregate(){
        showError = true;
        if(aggregatequery != ''){
            execute = DynamicAggregateController.RunQuery(aggregatequery,'','','','',new Doc_Template_Child__c());
            system.debug('execute ********************** '+ execute);
            if(!execute.contains('statuscode400')){  
                showError = false;
                execute = '';
            }
            else{
                execute = execute.replace('statuscode400',''); 
            }
        }
    }
    global void saveSectionChildDetails(){
        
        system.debug(aggregatequery + '****************** '+ aggregatequery);
        boolean gonew = false;
        loadstringssave = '';
        loadstring = '';
        system.debug('************** '+ condition);
        if(rendercondition != null && rendercondition != ''){
            rendercondition = rendercondition.replace('\'','ssz');
        }
        system.debug('************** ChildInnerClasseslist size'+ ChildInnerClasseslist.size());
        system.debug('************** ChildInnerClasseslist '+ ChildInnerClasseslist);
        system.debug('************** SortOrders '+ SortOrders);
        system.debug('************** parentObjects '+ parentObjects);
        for(ChildInnerClasses childs : ChildInnerClasseslist){
            system.debug('**************1899 '+ childs.sortorder+childs.ChildObject);
            system.debug('************** '+ integer.valueof(SortOrders)+parentObjects);
            system.debug('rendercondition-->'+rendercondition);
            system.debug('rendercondition1-->'+(childs.sortorder+childs.ChildObject) == integer.valueof(SortOrders)+parentObjects);
            if((childs.sortorder+childs.ChildObject) == integer.valueof(SortOrders)+parentObjects){
                saveWrapperList(integer.valueof(SortOrders));
                childs.sortorder = integer.valueof(SortOrders);
                //if(childFields.length() > 1){
                   // childs.FieldNames = childFields.substring(0,childFields.length() - 1);
                //}
               // else{
               //     childs.FieldNames =  childFields;           
               // }
               // if(FieldLabels.length() > 1){
               //     childs.FieldLabels = FieldLabels.substring(0,FieldLabels.length() - 1);
               // }
               // else{
               //     childs.FieldLabels =  FieldLabels;           
               // }
                
               // childs.AvailableFieldNames = AvailableFieldNames;
                system.debug('rendercondition-->'+rendercondition);
                childs.ChildObject = parentObjects;
                childs.parentObject = parentObject;
                childs.renderFields = renderFields;
                childs.rendercondition = rendercondition;
                childs.orderby = orderby;
                gonew = true;
            }
        }
        system.debug('gonew-->'+gonew);
        if(gonew == false){
            system.debug('rendercondition-->'+rendercondition);
            saveWrapperList(integer.valueof(SortOrders));
            ChildInnerClasses childclass = new ChildInnerClasses();
            childclass.sortorder = integer.valueof(SortOrders);
            //if(childFields.length() > 1){
              //  childclass.FieldNames = childFields.substring(0,childFields.length() - 1);
           // }
           // else{
            //    childclass.FieldNames =  childFields;           
           // }
           // if(FieldLabels.length() > 1){
           //     childclass.FieldLabels = FieldLabels.substring(0,FieldLabels.length() - 1);
           // }
           // else{
            //    childclass.FieldLabels =  FieldLabels;           
        //    }
            childclass.ChildObject = parentObjects;
            childclass.parentObject = parentObject;
            ChildClass.renderFields = renderFields;
            ChildClass.rendercondition = rendercondition;
            ChildInnerClasseslist.add(childclass);           
        }
        system.debug('ChildInnerClasseslist *************' + ChildInnerClasseslist.size());
        ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
        system.debug('invoicestring-->'+invoicestring);
        system.debug('DocTemplateBody-->'+DocTemplateBody);
        DocTemplateBody = invoicestring;
       
        loadstrings = '<script> loadscripts() </script>';      
        system.debug('ChildInnerClassJson *************' + ChildInnerClassJson);
    }
    global void savechilddetails(){
        
        system.debug(aggregatequery + '****************** '+ aggregatequery);
        boolean gonew = false;
        loadstringssave = '';
        loadstring = '';
        system.debug('************** '+ condition);
        if(rendercondition != null && rendercondition != ''){
            rendercondition = rendercondition.replace('\'','ssz');
        }
        system.debug('************** ChildInnerClasseslist size'+ ChildInnerClasseslist.size());
        for(ChildInnerClasses childs : ChildInnerClasseslist){
            system.debug('************** childs.sortorder+childs.ChildObject'+ childs.sortorder+childs.ChildObject);
            system.debug('************** integer.valueof(SortOrders)+parentObjects'+ integer.valueof(SortOrders)+parentObjects);
            if((childs.sortorder+childs.ChildObject) == integer.valueof(SortOrders)+parentObjects){
                saveWrapperList(integer.valueof(SortOrders));
                childs.sortorder = integer.valueof(SortOrders);
                if(childFields.length() > 1){
                    childs.FieldNames = childFields.substring(0,childFields.length() - 1);
                }
                else{
                    childs.FieldNames =  childFields;           
                }
                if(FieldLabels.length() > 1){
                    childs.FieldLabels = FieldLabels.substring(0,FieldLabels.length() - 1);
                }
                else{
                    childs.FieldLabels =  FieldLabels;           
                }
                childs.AvailableFieldNames = AvailableFieldNames;
                childs.ChildObject = parentObjects;
                childs.parentObject = parentObject;
                childs.color1 = color1; 
                childs.color2 = color2; 
                childs.Padding = Padding; 
                childs.Border = Border; 
                childs.height = height;
                childs.condition = condition;
                childs.renderFields = renderFields;
                childs.rendercondition = rendercondition;
                childs.orderby = orderby;
                childs.GroupBy = GroupBy;
                childs.childGroupBy = childGroupBy; 
                childs.isRollup = isRollup; 
                childs.grpcal = grpcal;
                childs.aggregatequery =  aggregatequery;
                childs.HeaderStyle = HeaderStyle;
                childs.extraField = extraField;
                gonew = true;
            }
        }
        
        if(gonew == false){
            saveWrapperList(integer.valueof(SortOrders));
            ChildInnerClasses childclass = new ChildInnerClasses();
            childclass.sortorder = integer.valueof(SortOrders);
            if(childFields.length() > 1){
                childclass.FieldNames = childFields.substring(0,childFields.length() - 1);
            }
            else{
                childclass.FieldNames =  childFields;           
            }
            if(FieldLabels.length() > 1){
                childclass.FieldLabels = FieldLabels.substring(0,FieldLabels.length() - 1);
            }
            else{
                childclass.FieldLabels =  FieldLabels;           
            }
            childclass.ChildObject = parentObjects;
            childclass.parentObject = parentObject;
            ChildClass.AvailableFieldNames = AvailableFieldNames;
            ChildClass.color1 = color1; 
            ChildClass.color2 = color2; 
            ChildClass.Padding = Padding; 
            ChildClass.Border = Border; 
            ChildClass.height = height; 
            ChildClass.condition = condition;
            ChildClass.renderFields = renderFields;
            ChildClass.rendercondition = rendercondition;
            ChildClass.orderby = orderby;
            ChildClass.GroupBy = GroupBy;
            ChildClass.childGroupBy = childGroupBy;     
            ChildClass.grpcal = grpcal;
            ChildClass.aggregatequery =  aggregatequery;
            ChildClass.HeaderStyle = HeaderStyle;
            ChildClass.extraField = extraField;
            ChildInnerClasseslist.add(childclass);           
        }
        ChildInnerClassJson = JSON.serialize(ChildInnerClasseslist);
        
        DocTemplateBody = invoicestring;
        
        loadstrings = '<script> loadscripts() </script>';      
        system.debug('ChildInnerClassJson *************' + ChildInnerClassJson);
    }
    global pageReference close(){
        pageReference pageref = new pageReference('/'+Docid);
        return pageref;
    }
    global pageReference closeEmailTemplate(){
        pageReference pageref = new pageReference('/'+Emailid);
        return pageref;
    }
    
    
    
    @RemoteAction 
    global static string getDocument(string Name,string Body){
        
        Blob afterblob = EncodingUtil.base64Decode(Body);
        string FolderId = [select id from folder where name = 'Juno Doc Templates' limit 1].Id;
        document doc = new document();
        doc.Name = Name;
        doc.Body = afterblob;
        doc.FolderId = FolderId;
        doc.Ispublic = true;
        if (Schema.sObjectType.document.fields.Name.isCreateable()
            && Schema.sObjectType.document.fields.Body.isCreateable()
            && Schema.sObjectType.document.fields.FolderId.isCreateable()
            && Schema.sObjectType.document.fields.Ispublic.isCreateable()) {
                insert doc;
            }
        return doc.Id;
    }
    
    
    
    
    
    
    
    
    global List<SelectOption> getConditions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('equals', 'equals'));
        options.add(new SelectOption('greater than', 'greater than'));
        options.add(new SelectOption('contains', 'contains'));
        //  options.add(new SelectOption('starts with', 'starts with'));
        options.add(new SelectOption('not contains', 'not contains'));
        options.add(new SelectOption('less than', 'less than'));
        options.add(new SelectOption('not equals', 'not equals'));
        return options;
    }
    
    global List<SelectOption> getdateFormatLists() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('MM/dd/yyyy ', 'MM/dd/yyyy'));
        options.add(new SelectOption('yyyy/MM/dd', 'yyyy/MM/dd'));
        options.add(new SelectOption('dd/MM/yyyy', 'dd/MM/yyyy'));
        options.add(new SelectOption('MM-dd-yyyy ', 'MM-dd-yyyy'));
        options.add(new SelectOption('yyyy-MM-dd', 'yyyy-MM-dd'));
        options.add(new SelectOption('dd-MM-yyyy', 'dd-MM-yyyy'));
        
        return options;
    }
    
    
    global List<SelectOption> getCurrencyFormatLists() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('###,###.00 ', '###,###.00'));
        options.add(new SelectOption('###,###.000', '###,###.000'));
        options.add(new SelectOption('###,###.0000', '###,###.0000'));
        options.add(new SelectOption('###.###,00', '###.###,00'));
        options.add(new SelectOption('###.###,000', '###.###,000'));
        options.add(new SelectOption('###.###,0000', '###.###,0000'));
        
        return options;
    }
    
    global List<SelectOption> getNumberFormatLists() {
        List<SelectOption> newoptions = new List<SelectOption>();   
        newoptions.add(new SelectOption('### ', '###'));    
        newoptions.add(new SelectOption('###,###', '###,###')); 
        newoptions.add(new SelectOption('###.###', '###.###')); 
        newoptions.add(new SelectOption('###.###,00', '###.###,00'));   
        newoptions.add(new SelectOption('###,###.00', '###,###.00'));   
        
        return newoptions; 
    }
    
    global void showFilters(){
        isFilters = true;
        
        //wrapperList = new List<WrapperClass>();
        system.debug('fieldsList --------> '+fieldsList);
        
        list<string> fieldlist = new list<string>();
        fieldlist.add(selectedField);
        system.debug('fieldsList --------> '+fieldlist);
        for(String fieldName : fieldlist){  
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();    
            Map <String, Schema.SObjectField> M = schemaMap.get(selectedChildObject).getDescribe().fields.getMap(); 
            //  Map<String, Schema.SObjectField> M = Schema.SObjectType.getQuotelineitem.fields.getMap();   
            system.debug('fieldName --------> '+M); 
            system.debug('fieldName --------> '+fieldName); 
            Schema.SObjectField field = M.get(fieldName);   
            Schema.DisplayType FldType = field.getDescribe().getType(); 
            system.debug('FldType -------> '+FldType);  
            if(String.valueOf(FldType) == 'PICKLIST'){  
                Map<String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();    
                Schema.SObjectType objType = schemaMaps.get(selectedChildObject);   
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();   
                Map< String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();  
                List< Schema.PicklistEntry > values = fieldMap.get(fieldName).getDescribe().getPickListValues();    
                pickListValues = getPicklistValues(values); 
                WrapperClass Wrap= new WrapperClass(count, fieldName, true, '', pickListValues, '',SortOrders); 
                Wrap.isGroup = false;   
                wrapperList.add(Wrap);  
            }else{              
                WrapperClass Wrap = new WrapperClass(count, fieldName, false, '', null, '',SortOrders); 
                Wrap.isGroup = false;   
                wrapperList.add(Wrap);  
            }   
            count++;    
        }   
        
        
        system.debug('wrapperList -------> '+wrapperList);  
    }   
    
    global void grpshowFilters(){   
        isFilters = true;   
        
        //wrapperList = new List<WrapperClass>();   
        system.debug('fieldsList --------> '+fieldsList);   
        
        list<string> fieldlist = new list<string>();    
        fieldlist.add(selectedField);   
        
        for(String fieldName : fieldlist){
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> M = schemaMap.get(selectedChildObject).getDescribe().fields.getMap();
            //  Map<String, Schema.SObjectField> M = Schema.SObjectType.getQuotelineitem.fields.getMap();
            system.debug('fieldName --------> '+M);
            system.debug('fieldName --------> '+fieldName);
            Schema.SObjectField field = M.get(fieldName);
            Schema.DisplayType FldType = field.getDescribe().getType();
            system.debug('FldType -------> '+FldType);
            if(String.valueOf(FldType) == 'PICKLIST'){
                Map<String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
                Schema.SObjectType objType = schemaMaps.get(selectedChildObject);
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                Map< String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
                List< Schema.PicklistEntry > values = fieldMap.get(fieldName).getDescribe().getPickListValues();
                pickListValues = getPicklistValues(values);
                WrapperClass Wrap= new WrapperClass(count, fieldName, true, '', pickListValues, '',SortOrders); 
                Wrap.isGroup = true;    
                wrapperList.add(Wrap);  
            }else{              
                WrapperClass Wrap = new WrapperClass(count, fieldName, false, '', null, '',SortOrders); 
                Wrap.isGroup = true;    
                wrapperList.add(Wrap);
            } 
            count++;
        }
        
        
        system.debug('wrapperList -------> '+wrapperList);
    }
    
    global List<SelectOption> getPicklistValues(List<Schema.PicklistEntry> pList) {
        List<SelectOption> options = new List<SelectOption>();
        for (Schema.PicklistEntry p: pList) {
            options.add(new SelectOption(p.getValue(), p.getLabel()));      
        }
        return options;
    }
    
    global void deleteRow(){
        system.debug('selectedRowIndex ------> '+selectedRowIndex);
        wrapperList.remove(Integer.valueOf(selectedRowIndex) - 1);
        system.debug('wrapperList -----> '+wrapperList);
        count = 1;
        for(wrapperClass Wrap : wrapperList){
            Wrap.rowCount = count;
            count++;
        }
        selectedField = '';
    }
    
    global String condition{get;set;}
    global void saveWrapperList(integer sortOrder){
        system.debug('wrapperList -------> '+wrapperList); 
        Map<String,String> sMap = new Map<String, String>();
        sMap.put('equals',' = ');
        sMap.put('greater than',' > ');
        sMap.put('less than',' < ');
        sMap.put('not equals',' != ');
        sMap.put('contains',' like ');
        // sMap.put('starts with',' like ');
        sMap.put('not contains',' not like ');
        condition = '';
        String objectType = selectedChildObject;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = schemaMap.get(objectType);
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        
        //for(String field : fieldMap.keySet()){
        system.debug('wrapperList ************ '+ wrapperList);
        if(wrapperList != null){
            for(WrapperClass wrapper : wrapperList){
                system.debug(sortOrder + ' wrapper.Ids ************ '+ wrapper.Ids);
                if(wrapper.Ids == ''+sortOrder){
                    String fType = String.valueOf(fieldMap.get(wrapper.fieldName).getDescribe().getType()); 
                    system.debug('fType ************ '+ fType); 
                    if(fType == 'NUMBER' || fType =='CURRENCY' || fType =='DOUBLE' || fType =='DECIMAL' || fType =='PERCENT'){  
                        if(wrapper.selectedInputValue == '' || wrapper.selectedInputValue == null){ 
                            wrapper.selectedInputValue = null;  
                        }   
                        if(wrapper.filterOption == 'greater than'   
                           || wrapper.filterOption == 'less than'   
                           || wrapper.filterOption == 'equals'  
                           || wrapper.filterOption == 'not equals'){    
                               condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + '' + wrapper.selectedInputValue +' AND ';                 
                           }    
                        
                    }   
                    else if(fType == 'BOOLEAN'){    
                        if(wrapper.selectedInputValue == '' || wrapper.selectedInputValue == null){ 
                            wrapper.selectedInputValue = 'false';   
                        }   
                        if(wrapper.filterOption == 'equals'     
                           || wrapper.filterOption == 'not equals'){    
                               condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + '' + wrapper.selectedInputValue +' AND ';                 
                           }    
                    }   
                    else {  
                        if(wrapper.selectedInputValue == '' || wrapper.selectedInputValue == null){ 
                            wrapper.selectedInputValue = null;  
                        }   
                        if(wrapper.filterOption == 'contains'){ 
                            condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + 'ssz%' + wrapper.selectedInputValue +'%ssz AND ';                            
                        }   
                        else if(wrapper.filterOption == 'not contains'){    
                            condition += '(NOT '+ wrapper.FieldName + ' like ssz%' + wrapper.selectedInputValue +'%ssz) AND ';                          
                        }   
                        else if(wrapper.filterOption == 'starts with'){ 
                            condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + 'ssz' + wrapper.selectedInputValue +'%ssz AND ';                             
                        }else if(wrapper.selectedInputValue != null && wrapper.selectedInputValue != '' ){  
                            condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + 'ssz' + wrapper.selectedInputValue +'ssz AND ';                      
                        }   
                        else{   
                            condition += wrapper.FieldName + '' + sMap.get(wrapper.filterOption) + 'null AND ';                     
                        }   
                    }   
                    //} 
                    
                }   
            }   
            condition = condition.removeEnd('AND ');    
        }   
        system.debug('condition -------> '+condition);  
    }   
    
    
    global string validErrorMessage{get;set;}
    global boolean validError{get;set;}
    global void Validate(){ 
        
        try{    
            
            set<string> ChildParLists = new set<string>();  
            string ChildparentFields = '';  
            if(finalstring != null){    
                
                if(string.valueof(finalstring).contains('{!')){
                    
                    string finalstrings = string.valueof(finalstring).replace('{!','xxwwwee');  
                    string[] finalstringlist = finalstrings.split('xxwwwee');   
                    integer i = 0;  
                    for(string str : finalstringlist){  
                        if(str.contains('}') && i >= 1 && !str.contains('$') && !str.contains('()')){   
                            string[] lists =  str.split('}');   
                            if(!ChildParLists.contains(lists[0].toLowercase())){    
                                ChildparentFields += lists[0].toLowercase() + ',';  
                                ChildParLists.add(lists[0].toLowercase());  
                            }   
                        }       
                        i++;    
                    }               
                }   
                if(string.valueof(finalstring).contains('{{')){ 
                    string finalstrings = string.valueof(finalstring).replace('{{','xxwwwee');  
                    string[] finalstringlist = finalstrings.split('xxwwwee');   
                    integer i = 0;  
                    for(string str : finalstringlist){  
                        if(str.contains('}') && i >= 1 ){   
                            string[] lists =  str.split('}}');  
                            if(!ChildParLists.contains(lists[0].toLowercase())){    
                                ChildparentFields += lists[0].toLowercase() + ',';  
                                ChildParLists.add(lists[0].toLowercase());  
                            }   
                        }   
                        i++;    
                    }                   
                }   
                
                if(ChildparentFields != ''){
                    ChildparentFields = ChildparentFields.substring(0,ChildparentFields.length() - 1);  
                }   
                if(ChildparentFields != null && ChildparentFields != ''){   
                    string query = 'select '+ ChildparentFields + ' from '+ parentObject + ' limit 1';
                    SObject Sobj = Database.query(String.escapeSingleQuotes(query));
                }   
            }   
            for(ChildInnerClasses child: ChildInnerClasseslist){    
                string query = 'select '+ child.FieldNames + ' from '+ child.ChildObject + ' limit 1';
                SObject Sobj = Database.query(String.escapeSingleQuotes(query));                    
            }   
            
            validErrorMessage = 'Validate Success'; 
            validError = true;  
            Color = 'green';    
        }   
        catch(Exception e){ 
            validErrorMessage = e.getMessage();     
            validError = true;  
            Color = 'red';  
        }   
    }
    public string Color{get;set;}
    
    global void CLosevalidError(){
        validError = false;
    }
    global string grpselectedField{get;set;}
    global string widthContainer{get;set;}
     global string extraField{get;set;}
    global decimal pageWidth{get;set;}
    global decimal pageHeight{get;set;}
    global void getcalInnerFields(){
        calWrapperClass calWrapperClassrec = new calWrapperClass();
        calWrapperClassrec.calField =   CalculatedFieldtext;  
        if(calqueryId != '' && calqueryId != null){
            calWrapperClassrec.calQuery =  'Select '+ CalculatedFieldIds + 'Total from ' + selectedChildObject + ' where '+ calqueryId.replace('\'','$$') +' and ' + ChildobjGetNamemap.get(selectedChildObject);  
        }
        else{
            calWrapperClassrec.calQuery =  'Select '+ CalculatedFieldIds + 'Total from ' + selectedChildObject + ' where '+ ChildobjGetNamemap.get(selectedChildObject);   
        }
        calWrapperClasslist.add(calWrapperClassrec);
    }
    
 */   
    
}
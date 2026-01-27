global without sharing class PreviewPDF_Controller {
    global Junodoc__Doc_Template__c DocTemplate{get;set;}
    global list<Junodoc__Doc_Template_Item__c> DocTemplateItem{get;set;}
    global Sobject parentRef{get;set;}
    global string HeaderBody{get;set;}
    global string FooterBody{get;set;}
    global string Headermargin{get;set;}  
    global string Footermargin{get;set;}
    global boolean Showpdf{get;set;}
    global string Docbody{get;set;}
    global string DateFormats{get;set;}
    global string CurrencyFormat{get;set;}
    global string NumberFormat{get;set;}
    global boolean blankasZeroes{get;set;}
    global boolean showpageNumber{get;set;}
    global Id QuoteId {get;set;}
    global string currencysymbols{get;set;}
    global String docTemplateId { get; set; }
    global String sobjectname { get; set; }
    global Id recordId { get; set; }
    global  map<string,string> currencySymbolMap{ get; set; }
    global string type{get;set;}
    public List<DateFormatEntry> dateFormatEntries { get; set; }
    public Map<String, String> resultMap{ get; set; }
    global PreviewPDF_Controller(){
        currencySymbolMap = new map<string,string>();
        list<JunoDoc__Junodoc_Currency__c> currencylist = [select Id,JunoDoc__Currency_Code__c,JunoDoc__Currency_Symbol__c from JunoDoc__Junodoc_Currency__c];
        if(!currencylist.isEmpty()){
            for(JunoDoc__Junodoc_Currency__c currencys : currencylist){
                currencySymbolMap.put(currencys.JunoDoc__Currency_Code__c,currencys.JunoDoc__Currency_Symbol__c);   
            }
        }
              
        HeaderBody = '';
        FooterBody = '';
        Headermargin = '0.15in';
        Footermargin = '0.15in';
        QuoteId = id.valueof(ApexPages.currentPage().getParameters().get('id'));
        recordId = QuoteId;
        docTemplateId = id.valueof(ApexPages.currentPage().getParameters().get('DocTemplateId'));
        type = ApexPages.currentPage().getParameters().get('Type');
        getTemplateId();
    }
    
    global string getBarcodes(string sourceCodeValue){
        shouldCheckDigit = false;
        list<string> barcodelist = generateCode39(sourceCodeValue, shouldCheckDigit).split('');
        string barcodes = '<div style="display: inline-block; border: 0px solid black;">';
        barcodes += '<div >';
        for(integer barc = 0;barc< barcodelist.size();barc++){
            if(barcodelist[barc] == '1'){
                barcodes += '<h3  style="margin-left: -2.4px;font-weight:bold;background-color: black;display: inline-block;padding: 0;width: 1px;height: 1.5cm;display: inline-block;" />';
            }
            else{
                barcodes += '<h3  style="margin-left: -2.4px;font-weight:bold;background-color: white;display: inline-block;padding: 0;width: 1px;height: 1.5cm;display: inline-block;" />';
            }
        }
        barcodes += '</div>';
        barcodes += '<div style="text-align: center">';
        barcodes += sourceCodeValue;
        barcodes += '</div>';
        barcodes += '</div>';
        return barcodes;
    }
    
    public static String safeReplaceOutsideStyle(String input, String placeholder, String replacement) {
        String result = '';
        Pattern stylePattern = Pattern.compile('style\\s*=\\s*"[^"]*"|style\\s*=\\s*\'[^\']*\'');
        Matcher m = stylePattern.matcher(input);
    
        Integer lastIndex = 0;
        while (m.find()) {
            // Safe replacement before style attribute
            String beforeStyle = input.substring(lastIndex, m.start());
            result += beforeStyle.replace(placeholder, replacement);
    
            // Do not replace inside style attribute
            String styleAttr = input.substring(m.start(), m.end());
            result += styleAttr;
    
            lastIndex = m.end();
        }
    
        // Remainder of the string
        if (lastIndex < input.length()) {
            String after = input.substring(lastIndex);
            result += after.replace(placeholder, replacement);
        }
    
        return result;
    }
     public class DateFormatEntry {
        public String dateValue { get; set; }
        public String dateFormat { get; set; }
    } 
    global void  getTemplateId(){
       // try{
      string TemplateID = '';
        String sObjName = QuoteId.getSObjectType().getDescribe().getName();
        sobjectname = sObjName;
        Map<String, Schema.SObjectField> objectFieldsMap = Schema.getGlobalDescribe().get(sObjName).getDescribe().fields.getMap();
        string DocTemplateField = string.valueOf(objectFieldsMap.get('Doc_Template__c'));
        if(DocTemplateField=='Doc_Template__c'){
            string Newqueries  = 'select id,Doc_Template__c from '+ sObjName +'  where id =: QuoteId' ;
            sobject NewQuote = Database.query(Newqueries);
            TemplateID = string.valueof(NewQuote.get('Doc_Template__c'));
        }        
        if(docTemplateId!=null){ // selected Available Template Id
            TemplateID = docTemplateId;
        }
        List<Junodoc__Doc_Template__c> DocTemplatesList = new List<Junodoc__Doc_Template__c>(); 
        Junodoc__Doc_Template__c DocTemplates = new Junodoc__Doc_Template__c();
        Document uncheckdocument = new Document();
        Document  checkdocument = new Document();
        
        list<Document>  uncheckdocumentlist =[SELECT Name,Type,id FROM Document where Folder.name='JunoDoc Checkbox Folder' 
                                             and Name = 'unchecked002.png' and IsPublic = true and (Type='png' or Type='jpg' or Type = 'svg')];
        
         list<Document>  checkdocumentlist =[SELECT Name,Type,id FROM Document where Folder.name='JunoDoc Checkbox Folder' 
                                             and Name = 'checked.png' and IsPublic = true and (Type='png' or Type='jpg' or Type = 'svg')];
        if(uncheckdocumentlist.size() > 0)
            uncheckdocument = uncheckdocumentlist[0];
        
        if(checkdocumentlist.size() > 0)
            checkdocument = checkdocumentlist[0];
        
        string sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        sfdcURL = sfdcURL.replace('visualforce','documentforce');
        sfdcURL = sfdcURL.replace('junodoc.','c.');
        sfdcURL = sfdcURL.replace('visual.force','content.force');
        string instanceName = '';
        integer surl =1;
        string tempInstance = '';
        if(!sfdcURL.contains('documentforce')){
            if(sfdcURL.contains('.cs')){
                surl = sfdcURL.indexof('cs');
                tempInstance = sfdcURL.substring(surl,sfdcURL.length());
                instanceName = tempInstance.substring(0,tempInstance.indexof('.'));
            }
            else if(sfdcURL.contains('.na')){
                surl = sfdcURL.indexof('na');
                tempInstance = sfdcURL.substring(surl,sfdcURL.length());
                instanceName = tempInstance.substring(0,tempInstance.indexof('.'));
            }
            if(instanceName != ''){
                sfdcURL = sfdcURL.substring(0,surl-1)+'c.'+instanceName+'.content.force.com';
            }
        }
        string sfdcURLForDocImage = '';
        sfdcURLForDocImage = System.Url.getOrgDomainUrl().toExternalForm().replace('.my.salesforce.com','') +'.file.force.com'; 
         DocTemplatesList = [select id,JunoDoc__Show_Page_Number__c,
                                                JunoDoc__Single_Page__c,
                                                Junodoc__Parent_Object__c,
                                                Junodoc__Doc_Template_Header__c,
                                                JunoDoc__Currency_Symbol__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__Master_Object_Fields__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__header_body__c,
                                                Junodoc__Doc_Template_Header__r.Junodoc__Master_object__c,
                                                Junodoc__Doc_Template_Footer__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Master_Object_Fields__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c,
                                                Junodoc__Doc_Template_Footer__r.Junodoc__Master_object__c,
                                                Junodoc__Parent_Fields__c ,
                                                Junodoc__Date_Format__c,
                             					JunoDoc__Date_Formats__c,
                                                Junodoc__Currency_Format__c,
                                                JunoDoc__Number_Format__c,
                                                VisualForce_Page__c,
                                                JunoDoc__Template_Type__c,
                                                JunoDoc__Blank_Fields_As_Zeroes__c
                                                from Junodoc__Doc_Template__c 
                                                where id =: TemplateID];
        
        
       
        if(DocTemplatesList.size() > 0){
            DocTemplates = DocTemplatesList[0];    
        }
        
     
       
        
        
        showpageNumber = false; 
        if(DocTemplates.JunoDoc__Show_Page_Number__c == true){
            showpageNumber = true;
        }
         blankasZeroes = DocTemplates.JunoDoc__Blank_Fields_As_Zeroes__c;
        if(DocTemplates.Junodoc__Date_Format__c != null && DocTemplates.Junodoc__Date_Format__c != ''){
            DateFormats = DocTemplates.Junodoc__Date_Format__c;
        }
        else{
            DateFormats = 'MM/dd/yyyy';
        }
        resultMap = new Map<String, String>();
        if (String.isNotBlank(DocTemplates.JunoDoc__Date_Formats__c)) {
             try {
                 dateFormatEntries = (List<DateFormatEntry>) JSON.deserialize(DocTemplates.JunoDoc__Date_Formats__c, List<DateFormatEntry>.class);
                if (dateFormatEntries != null) {
                    for (DateFormatEntry entry : dateFormatEntries) {
                        if (!String.isBlank(entry.dateValue) && !String.isBlank(entry.dateFormat)) {
                            resultMap.put(entry.dateValue, entry.dateFormat);
                        }
                    }
                }
             } catch (Exception e) {
                 dateFormatEntries = new List<DateFormatEntry>();
             }
        } else {
             dateFormatEntries = new List<DateFormatEntry>();
        }
        if(DocTemplates.Junodoc__Currency_Format__c != null && DocTemplates.Junodoc__Currency_Format__c != ''){
            CurrencyFormat = DocTemplates.Junodoc__Currency_Format__c;
        }
        else{
            CurrencyFormat = '###,###.00';
        }
        
        if(DocTemplates.JunoDoc__Number_Format__c != null && DocTemplates.JunoDoc__Number_Format__c != ''){
            NumberFormat = DocTemplates.JunoDoc__Number_Format__c;
        }
        else{
            NumberFormat = '###,###.00';
        }
        
        
         currencysymbols = '$';
         if(currencySymbolMap.get(UserInfo.getDefaultCurrency())!= null){
            currencysymbols = currencySymbolMap.get(UserInfo.getDefaultCurrency());
         }
         Boolean multiCurrencyEnabled = UserInfo.isMultiCurrencyOrganization();
        // if(multiCurrencyEnabled){
            if(DocTemplates.JunoDoc__Currency_Symbol__c != null && DocTemplates.JunoDoc__Currency_Symbol__c != ''){
                DocTemplates.JunoDoc__Currency_Symbol__c = DocTemplates.JunoDoc__Currency_Symbol__c.replace('{!','').replace('}','');
                Sobject Sobj = Database.query('select id,'+ DocTemplates.JunoDoc__Currency_Symbol__c+ ' from '+ sobjectname + ' where Id=:recordId');
                currencysymbols = currencySymbolMap.get(''+Sobj.get(DocTemplates.JunoDoc__Currency_Symbol__c));
            }    
        //}
        if(DocTemplates.VisualForce_Page__c == null || DocTemplates.VisualForce_Page__c == ''){
        
        list<JunoDoc__Calculated_Fields__c> calFieldsList = [select id,
                                                                    JunoDoc__Calculated_Field__c,
                                                                    JunoDoc__Calculated_Field_Query__c
                                                                    from JunoDoc__Calculated_Fields__c
                                                                    where JunoDoc__Junodoc_Templates__c =: TemplateID ];
        
        DocTemplateItem = [select id,
                                    Junodoc__Template_Body__c ,
                                    JunoDoc__Template_Body_2__c,
                                    JunoDoc__Page_Render__c
                                    from Junodoc__Doc_Template_Item__c 
                                    where Junodoc__Doc_Template__c =: TemplateID order by Name ASC];
        string NewTemplateBody = '';
        integer l = 0;
        if(DocTemplates.JunoDoc__Single_Page__c == true){
            NewTemplateBody +=  '<div style="" class="invoice-container">' ;
        }
        for (Junodoc__Doc_Template_Item__c DocTemplate : DocTemplateItem) {
            boolean Allowpage = false;
        
            if (DocTemplate.JunoDoc__Page_Render__c != '' && DocTemplate.JunoDoc__Page_Render__c != null) {
                string queries = 'SELECT Id FROM ' + sobjName + ' WHERE Id =: QuoteId AND ' + DocTemplate.JunoDoc__Page_Render__c;
                list<SObject> parentRefs = Database.query(queries);
                if (!parentRefs.isEmpty()) {
                    Allowpage = true;
                }
            } else {
                Allowpage = true;
            }
        
            if (Allowpage) {
                // Handle `JunoDoc__Template_Body_2__c`
                string CombinedTemplateBody = DocTemplate.Junodoc__Template_Body__c;
                if (DocTemplate.JunoDoc__Template_Body_2__c != null) {
                    CombinedTemplateBody += DocTemplate.JunoDoc__Template_Body_2__c;
                }
                list<string> Templatesstr = CombinedTemplateBody.split('inset:');
                for (integer i = 1; i < Templatesstr.size(); i++) {
                    string Templatesplit = Templatesstr[i].split(';')[0];
                    list<string> Topleftstring = Templatesplit.split(' ');
                    string top = 'top: ' + Topleftstring[1];
                    if(Topleftstring.size() > 4){
                        top += ';left:'+ Topleftstring[4];
                    }
                    CombinedTemplateBody = CombinedTemplateBody.replace(
                        'inset:' + Templatesplit, 
                        top
                    );
        
                    // Clean up unnecessary UI classes and attributes
                    CombinedTemplateBody = CombinedTemplateBody
                        .replace('<div class="ui-resizable-handle ui-resizable-e" style="z-index: 90;"></div>', '')
                        .replace('<div class="ui-resizable-handle ui-resizable-s" style="z-index: 90;"></div>', '')
                        .replace('<div class="ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se" style="z-index: 90;"></div>', '<div style="font-size:0px">&nbsp;</div>')
                        .replace('ssz', '\'')
                        .replace('ui-draggable', '').replace('ui-draggable-handle', '')
                        .replace('ui-resizable blur', '').replace('element_item', '')
                        .replace('item_element', '').replace('ui-draggable-dragging', '')
                        .replace('contenteditable="true"', '').replace('property-editing', '')
                        .replace('data-title="Table Element"', '').replace('data-title="Td Element"', '')
                        .replace('data-title="Paragraph Element"', '').replace('data-title="Label Element"', '')
                        .replace('data-title="Edit"', '').replace('data-title="Image Element"', '')
                        .replace('item-label', '').replace('td-label', '')
                        .replace('hover-row', '').replace('table-element', '')
                        .replace('order-list', '').replace('table-drag', '');
                }

                if (DocTemplates.JunoDoc__Template_Type__c != 'Word Document') {
                    if (DocTemplates.Single_Page__c == true) {
                        NewTemplateBody += CombinedTemplateBody;
                    } else {
                        integer k = l + 1;
                        if (k == 1) {
                            NewTemplateBody += '<div style="" class="invoice-container">' + CombinedTemplateBody + '</div>';
                        } else {
                            NewTemplateBody += '<div style="position:relative;font-size:5px">&nbsp;&nbsp;</div>' +
                                               '<div style="page-break-after: always;font-size:0px;color:white;"/>' +
                                               '<div class="invoice-container">' + CombinedTemplateBody + '</div>';
                        }
                        l = l + 1;
                    }
                } else {
                    integer k = l + 1;
                    if (k == 1) {
                        // First page without a page break
                        NewTemplateBody += '<div class="main-section"><table><tbody class="word-body-content' + k + '"><tr><td>';
                        NewTemplateBody += CombinedTemplateBody.trim() + '</td></tr></tbody></table></div>';
                    } else {
                        // Add page break before subsequent pages
                        NewTemplateBody += '<div class="main-section" style="page-break-before: always;"><div class="main-section" style="height:auto"><table><tbody class="word-body-content' + k + '"><tr><td>';
                        NewTemplateBody += CombinedTemplateBody.trim() + '</td></tr></tbody></table></div></div>';
                    }
                    l = l + 1;
                }
            }
        }

        if(DocTemplates.Single_Page__c == true){
            NewTemplateBody += '</div>';
        }
        NewTemplateBody = NewTemplateBody.replace('&quot;','').replace('break-inside: avoid','page-break-inside: avoid');
        
        for(JunoDoc__Calculated_Fields__c calFieldsrec : calFieldsList){
            string replacecal =calFieldsrec.JunoDoc__Calculated_Field__c; 
            string query = calFieldsrec.JunoDoc__Calculated_Field_Query__c.replace('$$','\'') + ' =: QuoteId';
            list<AggregateResult> allvalues = Database.query(query);
            for(AggregateResult aggregate : allvalues){
                if(aggregate.get('Total') != null){
                    string Alldec = GetCurrencyvalues(''+aggregate.get('Total'));
                        NewTemplateBody = NewTemplateBody.replace(replacecal,Alldec);
                }
                else{
                    NewTemplateBody = NewTemplateBody.replace(replacecal,'');  
                }
            }
           // decimal 
        }
            
                if(DocTemplates.Junodoc__Doc_Template_Header__c != null){
            if(DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c != null){
                if(DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__Master_Object_Fields__c != null && 
                   DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__Master_Object_Fields__c != ''){
                    string[] parentHeaderFieldsApi = DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__Master_Object_Fields__c.split(',');
                    string  TemplateBody = '<div class="invoice-header-box ui-droppable" id="content_area_header" style="height:100px">'+ DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c + '</div>';
                   
                       string Parentobject =  DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__Master_object__c;
                        HeaderBody = getBody(parentHeaderFieldsApi,TemplateBody,QuoteId,Parentobject,sfdcURLForDocImage,checkdocument.Id,uncheckdocument.Id);
                    }
                    else{
                        HeaderBody = '<div class="invoice-header-box ui-droppable" id="content_area_header" style="height:100px">'+ DocTemplates.Junodoc__Doc_Template_Header__r.Junodoc__header_body__c + '</div>';
                    }
                      list<string> Templatesstr = HeaderBody.split('inset:');
                    for(integer i=1;i<Templatesstr.size();i++){
                        string Templatesplit = Templatesstr[i].split(';')[0];
                        list<string> Topleftstring = Templatesplit.split(' ');
                        if(topLeftString.size() > 4)
                       HeaderBody = HeaderBody.replace('inset:'+Templatesplit,'top: '+Topleftstring[1] +';left:'+Topleftstring[4]);
                        if(topLeftString.size() < 4)
                       HeaderBody = HeaderBody.replace('inset:'+Templatesplit,'top: '+Topleftstring[1]);     
                        
                    }
                    //HeaderBody = HeaderBody.replace('top: -','top: ');
                    Headermargin = '1.0in';
            }
        }
        else{
            HeaderBody = '<div class="invoice-header-box ui-droppable" id="content_area_header" style="height:100px;"></div>';
            Headermargin = '1.0in';
        }
        if(DocTemplates.Junodoc__Doc_Template_Footer__c != null){
            if(DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c != null){
                if(DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Master_Object_Fields__c != null && 
                   DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Master_Object_Fields__c != ''){
                    string[] parentHeaderFieldsApi = DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Master_Object_Fields__c.split(',');
                    string  TemplateBody = '<div class="invoice-header-box ui-droppable" id="content_area_footer" style="height:100px;">'+ DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c + '</div>';
                    string Parentobject = DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Master_object__c;
                    FooterBody = getBody(parentHeaderFieldsApi,TemplateBody,QuoteId,Parentobject,sfdcURLForDocImage,checkdocument.Id,uncheckdocument.Id);
                   }
                else{
                    FooterBody = '<div class="invoice-header-box ui-droppable" id="content_area_footer" style="height:100px;">'+ DocTemplates.Junodoc__Doc_Template_Footer__r.Junodoc__Footer_body__c + '</div>';
                }
                
                list<string> Templatesstr = FooterBody.split('inset:');
                    for(integer i=1;i<Templatesstr.size();i++){
                        string Templatesplit = Templatesstr[i].split(';')[0];
                        list<string> Topleftstring = Templatesplit.split(' ');
                        if(topLeftString.size() > 4)
                       FooterBody = FooterBody.replace('inset:'+Templatesplit,'top: '+Topleftstring[1] +';left:'+Topleftstring[4]);
                        if(topLeftString.size() < 4)
                       FooterBody = FooterBody.replace('inset:'+Templatesplit,'top: '+Topleftstring[1]);     
                        
                    }
               // FooterBody = HeaderBody.replace('top: -','top: ');
                Footermargin = '1.0in';
            }
           // FooterBody = FooterBody.Replace('position: absolute','position: relative');
        }
      
            
            // Step 1: Get field mappings from JunoDoc__Junodoc_Details__c
        List<JunoDoc__Junodoc_Details__c> mappings = [
            SELECT JunoDoc__Child_Object_Field_Name__c, 
                   JunoDoc__Child_Object_Name__c, 
                   JunoDoc__Parent_Object_Field_Name__c, 
                   JunoDoc__Parent_Object_Name__c,
                    JunoDoc__Child_Object_Replace_Field_Name__c
            FROM JunoDoc__Junodoc_Details__c 
            WHERE JunoDoc__Selected_object__c = :DocTemplates.Junodoc__Parent_Object__c
        ];
        
        if (!mappings.isEmpty()) {
            if(mappings[0].JunoDoc__Parent_Object_Name__c != null && mappings[0].JunoDoc__Parent_Object_Name__c != ''){
                string queryQues = 'select ' + mappings[0].JunoDoc__Parent_Object_Name__c + ' from ' + DocTemplates.Junodoc__Parent_Object__c + ' where id=: QuoteId';
                sobject parentData = Database.query(queryQues);
                
                 String childObject = mappings[0].JunoDoc__Child_Object_Name__c;
                String childField = mappings[0].JunoDoc__Child_Object_Field_Name__c;
                String parentLookupField = mappings[0].JunoDoc__Parent_Object_Field_Name__c;
                string parenDataId = ''+parentData.get(mappings[0].JunoDoc__Parent_Object_Name__c);
                
                // Step 2: Construct Dynamic SOQL
                String query = 'SELECT Id, ' + childField + ','+mappings[0].JunoDoc__Child_Object_Replace_Field_Name__c + ' FROM ' + childObject +
                               ' WHERE ' + parentLookupField + ' = :parenDataId order by createddate asc';
                
                List<SObject> records = Database.query(query);
                for(SObject rec : records){
                    String placeholder = '' + rec.get(mappings[0].JunoDoc__Child_Object_Replace_Field_Name__c);
                    String replacement = '' + rec.get(childField);
                
                    NewTemplateBody = safeReplaceOutsideStyle(NewTemplateBody, placeholder, replacement);
                
                    if (FooterBody != null) {
                        FooterBody = safeReplaceOutsideStyle(FooterBody, placeholder, replacement);
                    }
                    if (HeaderBody != null) {
                        HeaderBody = safeReplaceOutsideStyle(HeaderBody, placeholder, replacement);
                    }
                }
                
            }
        }

        
        
        list<Junodoc__Doc_Template_Child__c> DocChilds = [select id,
                                                        Junodoc__Child_object__c,
                                                        Junodoc__Child_Query__c,
                                                        Junodoc__Parent_Reference__c,
                                                        JunoDoc__Group_By_Calculation__c,
                                                        Junodoc__Calculation_Fields__c,
                                                        Junodoc__Color_1__c,
                                                        Junodoc__Color_2__c,
                                                        Junodoc__border__c,
                                                        Junodoc__height__c,
                                                        Junodoc__Filter__c,
                                                        Junodoc__Order_by__c,
                                                        Junodoc__Header_style__c,
                                                        Junodoc__Header_Colour_background__c,
                                                        Junodoc__Border_Width__c,
                                                        Junodoc__Padding__c,
                                                        Junodoc__Render_Condition__c,  
                                                        Junodoc__Sort_Order__c,
                                                        Junodoc__group_by__c,
                                                        JunoDoc__Child_Group_By__c,
                                                          JunoDoc__Rollup_groupby__c,
                                                        Junodoc__Related_Object_Labels__c,
                                                        Junodoc__Font_Size__c,
                                                        Junodoc__Table_grid__c,
                                                        JunoDoc__Aggregate_Query__c,
                                                        Junodoc__Font_Color__c,
                                                        JunoDoc__Doc_Template__r.JunoDoc__Template_Type__c,
                                                        JunoDoc__Extra_Fields__c,
                                                        JunoDoc__Parent_Child_Object__c,
                                                        JunoDoc__Parent_Child_Object_Reference__c,
                                                        JunoDoc__Parent_Child_Reference__c,
                                                        JunoDoc__Related_Object_Child_Query__c,
                                                        JunoDoc__Related_Object_Child_Labels__c,
                                                        JunoDoc__Child_Color_1__c,
                                                        JunoDoc__Child_Color_2__c,
                                                        JunoDoc__Child_Header_style__c,
                                                        JunoDoc__Child_Border__c,
                                                        JunoDoc__Child_Height__c,
                                                        JunoDoc__Child_Padding__c,
                                                        JunoDoc__Child_Header_Color__c,
                                                        JunoDoc__Child_Header_Colour_background__c,
                                                        JunoDoc__Child_Table_grid__c,
                                                        JunoDoc__Child_Horizontal_Alignment__c,
                                                        JunoDoc__Child_Border_Color__c,
                                                        JunoDoc__Child_Border_Width__c,
                                                        JunoDoc__Child_Border_Style__c,
                                                        JunoDoc__Child_Font_Size__c,
                                                        JunoDoc__Child_Vertical_Alignment__c
                                                        from Junodoc__Doc_Template_Child__c 
                                                        where Junodoc__Doc_Template__c =: TemplateID]; 
        String query ='';
        String SobjectApiName = DocTemplates.Junodoc__Parent_Object__c;
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        String strFields = '';
        
      	if(NewTemplateBody.contains('DATEVALUE(\'{!TODAY()}\')')){
            Date Datestr = system.Today();
            string DateInt = ''+ Datestr.month();
            if(Datestr.month() < 10){
                DateInt = '0'+Datestr.month();
            }
            NewTemplateBody = NewTemplateBody.replace('DATEVALUE(\'{!TODAY()}\')','DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')'); 
      	}
        if(NewTemplateBody.contains('DATETIMEVALUE(\'{!TODAY()}\')')){
            DateTime Datestr = system.Now();
            string DateInt = ''+ Datestr.month();
            if(Datestr.month() < 10){
                DateInt = '0'+Datestr.month();
            }
            NewTemplateBody = NewTemplateBody.replace('DATETIMEVALUE(\'{!TODAY()}\')','DATETIMEVALUE(\''+ Datestr.format('yyyy-MM-dd HH:mm:ss') +'\')'); 
      	}
            if(NewTemplateBody.contains('DATETIMEVALUE(\'{!YESTERDAY()}\')')){
            Datetime Datestr = system.Now().adddays(-1);
            string DateInt = ''+ Datestr.month();
            if(Datestr.month() < 10){
                DateInt = '0'+Datestr.month();
            }
            NewTemplateBody = NewTemplateBody.replace('DATETIMEVALUE(\'{!YESTERDAY()}\')','DATETIMEVALUE(\''+ Datestr.format('yyyy-MM-dd HH:mm:ss') +'\')'); 
      	}
        if(NewTemplateBody.contains('DATEVALUE(\'{!YESTERDAY()}\')')){
            Date Datestr = system.Today().adddays(-1);
            string DateInt = ''+ Datestr.month();
            if(Datestr.month() < 10){
                DateInt = '0'+Datestr.month();
            }
            NewTemplateBody = NewTemplateBody.replace('DATEVALUE(\'{!YESTERDAY()}\')','DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')'); 
      	}
        
        if((NewTemplateBody.contains('{!TODAY()}') && !NewTemplateBody.contains('DATEVALUE(\'{!TODAY()}\')'))
            || FooterBody.contains('{!TODAY()}') 
            || HeaderBody.contains('{!TODAY()}')){
            Date Datestr = system.Today();
                string DateFormat = DateFormats;
                if(resultMap.get('{!TODAY()}') != null){
                    DateFormat = resultMap.get('{!TODAY()}');
                }
            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);                
            NewTemplateBody = NewTemplateBody.replace('{!TODAY()}',Parentvalues); 
            if(FooterBody != null){
                FooterBody = FooterBody.replace('{!TODAY()}',Parentvalues); 
            }
            if(HeaderBody != null){
                HeaderBody = HeaderBody.replace('{!TODAY()}',Parentvalues); 
            }
        }
        if(NewTemplateBody.contains('{{showPageNumber}}') 
            || FooterBody.contains('{{showPageNumber}}') 
            || HeaderBody.contains('{{showPageNumber}}')){
                           
          /*  NewTemplateBody = NewTemplateBody.replace('{{showPageNumber}}','Page <span class="pagenumber"/> of <span class="pagecount"/>');
            if(FooterBody != null){
                FooterBody = FooterBody.replace('{{showPageNumber}}','Page <span class="pagenumber"/> of <span class="pagecount"/>');
            }
            if(HeaderBody != null){
                HeaderBody = HeaderBody.replace('{{showPageNumber}}','Page <span class="pagenumber"/> of <span class="pagecount"/>');
            }*/
                
                String pdfPageNumber =
                    'Page <span class="pagenumber"></span> of <span class="pagecount"></span>';
                
                String wordPageNumber = 'Page <span class="pagenumber"></span> of <span class="pagecount"></span>';
                
                if (DocTemplates.JunoDoc__Template_Type__c == 'Word Document') {
                    NewTemplateBody = NewTemplateBody.replace('{{showPageNumber}}', wordPageNumber);
                    if (FooterBody != null)
                        FooterBody = FooterBody.replace('{{showPageNumber}}', wordPageNumber);
                    if (HeaderBody != null)
                        HeaderBody = HeaderBody.replace('{{showPageNumber}}', wordPageNumber);
                } else {
                    NewTemplateBody = NewTemplateBody.replace('{{showPageNumber}}', pdfPageNumber);
                    if (FooterBody != null)
                        FooterBody = FooterBody.replace('{{showPageNumber}}', pdfPageNumber);
                    if (HeaderBody != null)
                        HeaderBody = HeaderBody.replace('{{showPageNumber}}', pdfPageNumber);
                }
        }
        if(NewTemplateBody.contains('{!NOW()}') 
           || FooterBody.contains('{!NOW()}') 
            || HeaderBody.contains('{!NOW()}')){
                string DateFormat = DateFormats;
                if(resultMap.get('{!NOW()}') != null){
                    DateFormat = resultMap.get('{!NOW()}');
                }
                TimeZone userTimeZone = UserInfo.getTimeZone();
                String dateTimeFormat = DateFormat + ' HH:mm a'; 
                DateTime nowInUserContext = System.now();
             //   string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormat + ' HH:mm a');
                String Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                NewTemplateBody = NewTemplateBody.replace('{!NOW()}',Parentvalues);  
                if(FooterBody != null){
                    FooterBody = FooterBody.replace('{!NOW()}',Parentvalues); 
                }
                if(HeaderBody != null){
                    HeaderBody = HeaderBody.replace('{!NOW()}',Parentvalues); 
                }
        }
        
        if(NewTemplateBody.contains('{!#User.')){
            string qry = 'select ';
            NewTemplateBody = NewTemplateBody.replace('{!#User.','##user##');
            string[] strlist = NewTemplateBody.split('##user##');
            list<string> userfields = new list<string>();
            integer i = 0;
            for(string newstr : strlist){
                if(i >= 1){
                    string[] userstr = newstr.split('}');
                        qry += userstr[0] + ',';
                        userfields.add(userstr[0]);
                    
                }
                i = i+1;
            }
            string userId = userinfo.getUserId();
            qry += 'Id from user where id=: userId';
            user users = Database.query(qry);
            if(!userfields.isEmpty()){
                for(string str : userfields){
                    NewTemplateBody = NewTemplateBody.replace('##user##'+str+'}',''+users.get(str));  
                }
            }
        }
        NewTemplateBody = NewTemplateBody.replace('display: inline-block;','').replace('overflow: hidden;','');
        if(DocTemplates.Junodoc__Parent_Fields__c != null){
            string[] parentFieldsApi = DocTemplates.Junodoc__Parent_Fields__c.split(',');
            set<string> Setstring = new set<string>();
            for(String fieldName : parentFieldsApi )
            {
                if(!Setstring.contains(fieldName.toLowerCase()) ){
                    if(strFields == null || strFields == ''){
                        strFields = fieldName.toLowerCase();
                    }
                    else{
                        strFields = strFields + ' , ' + fieldName.toLowerCase();
                    }
                    Setstring.add(fieldName.toLowerCase());
                }
            }      
            if(SobjectApiName == 'Billing__c'){
                query = 'select ' + strFields + ' from Billing__c where Id =:  QuoteId';    
            }
            else{
               query = 'select ' + strFields + ' from ' + SobjectApiName + ' where Id =:  QuoteId';   
            }
            parentRef = Database.query(query);
            
            Map<string,string> parentobjectsMap = new Map<string,string>();
            Map<string,string> RelparentobjectsMap = new Map<string,string>();
            Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMaps = schemaMap.get(DocTemplates.Junodoc__Parent_Object__c).getDescribe().fields.getMap();
            
            for(Schema.SObjectField sfield : fieldMaps.Values()){
                schema.describefieldresult dfield = sfield.getDescribe();
                
                parentobjectsMap.put(dfield.getname().toLowercase(),''+dfield.getType ());
                if(dfield.getRelationshipName() != null){
                    RelparentobjectsMap.put(''+dfield.getRelationshipName().toLowercase(),''+dfield.getname().toLowercase());
                }
            }
           // for(Doc_Template_Item__c DocTemplate : DocTemplateItem){              
                if(NewTemplateBody != null){
                    NewTemplateBody = '<div class="invoice-content-box ui-droppable" id="content_area">'+NewTemplateBody+'</div>';
                    
                    for(string Strs : parentFieldsApi){
                        string str = strs.replace(' ','');  
                        string Parentvalues = '';
                        string rendParentvalue = ''; 
                        if(!str.contains('.')){
                            if(parentRef.get(str) != null){
                                if(parentobjectsMap.get(str.toLowercase()) == 'BOOLEAN'){
                                    
                                    if(parentRef.get(str) != null){
                                        boolean textbool = boolean.valueof(parentRef.get(str));
                                        rendParentvalue = '' + textbool;
                                        if(textbool == true){
                                            Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                        else{
                                            Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                        }
                                    }
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'DATE'){
                                    if(parentRef.get(str) != null){
                                        Date Datestr = Date.valueof(parentRef.get(str));
                                        string DateFormat = DateFormats;
                                        if(resultMap.get('{!'+str+'}') != null){
                                            DateFormat = resultMap.get('{!'+str+'}');
                                        }
                                        Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                        string DateInt = ''+ Datestr.month();
                                        if(Datestr.month() < 10){
                                            DateInt = '0'+Datestr.month();
                                        }
                                        rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                    }
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'NUMBER' || parentobjectsMap.get(str.toLowercase()) == 'DOUBLE'){ 
                                    string currencyvalue = GetNumbervalues(''+parentRef.get(str));
                                    Parentvalues =  currencyvalue; 
                                    rendParentvalue = ''+parentRef.get(str);
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'CURRENCY'){ 
                                    string currencyvalue = GetCurrencyvalues(''+parentRef.get(str));
                                    Parentvalues =  currencyvalue; 
                                    rendParentvalue = ''+parentRef.get(str);
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'DATETIME'){
                                    if(parentRef.get(str) != null){
                                        string DateFormat = DateFormats;
                                        if(resultMap.get('{!'+str+'}') != null){
                                            DateFormat = resultMap.get('{!'+str+'}');
                                        }
                                          TimeZone userTimeZone = UserInfo.getTimeZone();
                                        String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                        DateTime nowInUserContext = Datetime.valueof(parentRef.get(str));
                                        Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                        rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRef.get(str)).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                    }
                                }
                                else{
                                    Parentvalues = convertHtmlString((''+ parentRef.get(str)).replace('\n','<br/>'));
                                    rendParentvalue = '\''+ parentRef.get(str) + '\'';
                                }                                
                            }
                            else{
                                Parentvalues = '';
                                rendParentvalue = '\'\'';
                                
                            }
                        }
                        else{
                            
                            string Stringobjct = str.replace('.',',');
                            string[] Stringobjcts = Stringobjct.split(',');
                            if(Stringobjcts.size() > 3){
                                if(parentRef.getsobject(Stringobjcts[0]) != null){
                                    if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {  
                                        if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                            string firstchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                            string secchild = getchilType(firstchild,Stringobjcts[1]);
                                            string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                            if(Types == 'CURRENCY'){
                                                rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            }
                                            else if(Types == 'DATE'){
                                                if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                    string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                    Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                                    string DateInt = ''+ Datestr.month();
                                                    if(Datestr.month() < 10){
                                                        DateInt = '0'+Datestr.month();
                                                    }
                                                    rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                                }
                                            }
                                            else if(Types == 'DATETIME'){
                                                if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                    string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                     TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                    rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                                }
                                            }
                                            else if(Types == 'BOOLEAN'){
                                                boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                rendParentvalue = '' + textbool;
                                                if(textbool == true){
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                            }
                                            else{ 
                                                Parentvalues = convertHtmlString(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                rendParentvalue = '\''+ Parentvalues + '\'';
                                            }
                                           // Parentvalues = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                        }
                                    }
                                }
                            }
                            else if(Stringobjcts.size() > 2){
                                if(parentRef.getsobject(Stringobjcts[0]) != null){
                                    if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                        if(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                            string secchild = getchilType(SobjectApiName,Stringobjcts[0]);
                                            string Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);  
                                           
                                            if(Types == 'CURRENCY'){
                                                rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                Parentvalues = GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                Parentvalues = GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                string DateInt = ''+ Datestr.month();
                                                if(Datestr.month() < 10){
                                                    DateInt = '0'+Datestr.month();
                                                }
                                                rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                                string DateFormat = DateFormats;
                                                if(resultMap.get('{!'+str+'}') != null){
                                                    DateFormat = resultMap.get('{!'+str+'}');
                                                }
                                                Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                            }
                                            else if(Types == 'DATETIME'){
                                                string DateFormat = DateFormats;
                                                if(resultMap.get('{!'+str+'}') != null){
                                                    DateFormat = resultMap.get('{!'+str+'}');
                                                }
                                                 TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                            }
                                            else if(Types == 'BOOLEAN'){
                                                boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                              rendParentvalue = '' + textbool;
                                                if(textbool == true){
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                            }
                                            else{ 
                                                Parentvalues = convertHtmlString(''+parentRef.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                rendParentvalue = '\''+ Parentvalues + '\'';
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                
                                if(parentRef.getsobject(Stringobjcts[0]) != null){    
                                    if(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                        string Types = getRelType(SobjectApiName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                         
                                        if(Types == 'CURRENCY'){
                                            rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                            Parentvalues =  GetCurrencyvalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                        }
                                        else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                            rendParentvalue = ''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                            Parentvalues =  GetNumbervalues(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                        }
                                        else if(Types == 'DATE'){
                                            Date Datestr = Date.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            string DateInt = ''+ Datestr.month();
                                            if(Datestr.month() < 10){
                                                DateInt = '0'+Datestr.month();
                                            }
                                            rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                            string DateFormat = DateFormats;
                                            if(resultMap.get('{!'+str+'}') != null){
                                                DateFormat = resultMap.get('{!'+str+'}');
                                            }
                                            Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                        }
                                        else if(Types == 'DATETIME'){
                                            string DateFormat = DateFormats;
                                            if(resultMap.get('{!'+str+'}') != null){
                                                DateFormat = resultMap.get('{!'+str+'}');
                                            }
                                            TimeZone userTimeZone = UserInfo.getTimeZone();
                                            String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                            DateTime nowInUserContext = Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                        }
                                        else if(Types == 'BOOLEAN'){
                                            
                                            boolean textbool = boolean.valueof(parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                rendParentvalue = '' + textbool;
                                                if(textbool == true){
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                        }
                                        else{ 
                                            Parentvalues = convertHtmlString(''+parentRef.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            rendParentvalue = '\''+ Parentvalues + '\'';
                                        }
                                        
                                    }
                                }
                            }    
                        }
                        if(Parentvalues != ''){
                            Parentvalues = Parentvalues.replaceAll('[\u0000-\u001F]', ' ');
                            if(NewTemplateBody.contains('Barcode[{!'+Str+'}]')){
                                NewTemplateBody = NewTemplateBody.replace('Barcode[{!'+Str+'}]',getBarcodes(Parentvalues)).replace('{!'+Str+'}',Parentvalues);
                            }
                            else{
                               Parentvalues = Parentvalues.replace('\n','<br/>');
                               NewTemplateBody = NewTemplateBody.replace('{!'+Str+'}',Parentvalues); 
                            }
                            
                        }
                        else{
                           NewTemplateBody = NewTemplateBody.replace('Barcode[{!'+Str+'}]','').replace('{!'+Str+'}',''); 
                        }
                        if(rendParentvalue != ''){
                            NewTemplateBody = NewTemplateBody.replace('{{'+Str+'}}',rendParentvalue.replace('\r', ' ').replace('\n', ' '));  
                        }
                        else{
                            NewTemplateBody = NewTemplateBody.replace('{{'+Str+'}}','\'\'');  
                        }
                    }
                }
           // }  
        }
        map<string,string> ChildobjectsMap = new map<string,string>();
        Map<string,string> RelatedparentobjectsMap = new Map<string,string>();
            
            map<string,string> ParentChildobjectsMap = new map<string,string>();
        string calstring = '';
        for(Junodoc__Doc_Template_Child__c DocChild : DocChilds){
            string ChildObjField = DocChild.Junodoc__Child_object__c.replace('[','---').split('---')[0];
            if(DocChild.Junodoc__Child_object__c.contains(':')){
                ChildObjField = DocChild.Junodoc__Child_object__c.split(':')[1];
            }
           Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
           if(schemaMaps.get(ChildObjField) != null){
                Map <String, Schema.SObjectField> fieldMaps = schemaMaps.get(ChildObjField).getDescribe().fields.getMap();    
                for(Schema.SObjectField sfield : fieldMaps.Values()){
                    schema.describefieldresult dfield = sfield.getDescribe();
                    ChildobjectsMap.put(dfield.getname().toLowercase()+ChildObjField.toLowercase(),''+dfield.getType ());
                    if(dfield.getRelationshipName() != null){
                        RelatedparentobjectsMap.put(''+dfield.getRelationshipName().toLowercase(),''+dfield.getname().toLowercase());
                    }
                }
            }   
            if(DocChild.JunoDoc__Parent_Child_Object__c != null && DocChild.JunoDoc__Parent_Child_Object__c != ''){
                string ParentChildObjField = DocChild.JunoDoc__Parent_Child_Object__c.replace('[','---').split('---')[0];
                if(DocChild.Junodoc__Child_object__c.contains(':')){
                    ParentChildObjField = DocChild.JunoDoc__Parent_Child_Object__c.split(':')[1];
                }
                Map <String, Schema.SObjectType> parentSchemaMaps = Schema.getGlobalDescribe();
               if(parentSchemaMaps.get(ChildObjField) != null){
                    Map <String, Schema.SObjectField> fieldMaps = parentSchemaMaps.get(ChildObjField).getDescribe().fields.getMap();    
                    for(Schema.SObjectField sfield : fieldMaps.Values()){
                        schema.describefieldresult dfield = sfield.getDescribe();
                        ParentChildobjectsMap.put(dfield.getname().toLowercase()+ChildObjField.toLowercase(),''+dfield.getType ());                       
                    }
                }   
            }
        }    
           
        for(Junodoc__Doc_Template_Child__c DocChild : DocChilds){
            if(DocChild.JunoDoc__Aggregate_Query__c != '' && DocChild.JunoDoc__Aggregate_Query__c != null){
                String Queries = DynamicAggregateController.RunQuery(DocChild.JunoDoc__Aggregate_Query__c,Docchild.Junodoc__Parent_Reference__c,QuoteId,currencysymbols,CurrencyFormat,DocChild);
                NewTemplateBody = NewTemplateBody.replace(DocChild.JunoDoc__Aggregate_Query__c,Queries);
                continue;
            }
            set<string>  DuplChilds = new set<string>();
            string chquries = '';
            if(DocChild.Junodoc__Calculation_Fields__c != null){
                list<string> ChildFieldN = DocChild.Junodoc__Calculation_Fields__c.split(',');
                for(string str : ChildFieldN){
                    if(!DuplChilds.contains(str.toLowerCase()) && str != '' && str != null){
                        DuplChilds.add(str.toLowerCase());
                        chquries += str.toLowerCase() + ',';
                    }
                }
            }
            list<string> ChildFieldNameslist = DocChild.Junodoc__Child_Query__c.split(',');
            for(string str : ChildFieldNameslist){
                if(!DuplChilds.contains(str.toLowerCase())){ 
                    DuplChilds.add(str.toLowerCase());
                    chquries += str.toLowerCase() + ',';
                }
            }
            if(DocChild.JunoDoc__Extra_Fields__c != null && DocChild.JunoDoc__Extra_Fields__c != '' && DocChild.JunoDoc__Extra_Fields__c != '--select one--'){
                list<string> ExtraFieldList = DocChild.JunoDoc__Extra_Fields__c.split(',');
                for(string str : ExtraFieldList){
                    if(!DuplChilds.contains(str.toLowerCase())){
                        DuplChilds.add(str.toLowerCase());
                        chquries += str.toLowerCase() + ',';
                    }
                }
            }
            if(DocChild.JunoDoc__Parent_Child_Reference__c != null && DocChild.JunoDoc__Parent_Child_Reference__c != '' && DocChild.JunoDoc__Parent_Child_Reference__c != '--select one--'){
                list<string> ExtraFieldList = DocChild.JunoDoc__Parent_Child_Reference__c.split(',');
                for(string str : ExtraFieldList){
                    if(!DuplChilds.contains(str.toLowerCase())){
                        DuplChilds.add(str.toLowerCase());
                        chquries += str.toLowerCase() + ',';
                    }
                }
            }
            
            if(chquries.length() > 1){
                chquries = chquries.substring(0,chquries.length() - 1);
            }
            string ChildObjField = DocChild.Junodoc__Child_object__c.replace('[','---').split('---')[0];
            string quoteNewId = QuoteId;
            system.debug('DocChild.Junodoc__Child_object__c **** ' + DocChild.Junodoc__Child_object__c);
            if(DocChild.Junodoc__Child_object__c.contains(':')){
                ChildObjField = DocChild.Junodoc__Child_object__c.split(':')[1];
                DocChild.Junodoc__Parent_Reference__c = DocChild.Junodoc__Child_object__c.split(':')[2];
                system.debug(DocChild.Junodoc__Child_object__c.split(':')[1] + '***DocChild.Junodoc__Child_object__c **** ' + DocChild.Junodoc__Child_object__c.split(':')[2] + ' ***** ' + DocChild.Junodoc__Child_object__c.split(':')[0]);
                string quoteObjString = 'select ' + DocChild.Junodoc__Child_object__c.split(':')[0] + ' From ' + SobjectApiName + ' WHERE Id =: quoteId';
                Sobject quoteObj = Database.query(quoteObjString);
              //  if(quoteObj.get(DocChild.Junodoc__Child_object__c.split(':')[0]) != null){
                	quoteNewId = ''+quoteObj.get(DocChild.Junodoc__Child_object__c.split(':')[0]);
              //  }
                
            }
            String Queries = ' SELECT '+ chquries + ' from ' + ChildObjField + ' where '+ DocChild.Junodoc__Parent_Reference__c + ' =: quoteNewId ';
            if(DocChild.Junodoc__Filter__c != null){
                if(DocChild.Junodoc__Filter__c.contains('ssz')){ 
                    DocChild.Junodoc__Filter__c = DocChild.Junodoc__Filter__c.replace('ssz','\'');
                }
               Queries += 'and ' + DocChild.Junodoc__Filter__c;

            }
            if(DocChild.Junodoc__Order_by__c != null){
                Queries += ' order by ' + DocChild.Junodoc__Order_by__c;
            }
            if(DocChild.Junodoc__Render_Condition__c != null){
                if(DocChild.Junodoc__Render_Condition__c.contains('ssz')){ 
                    DocChild.Junodoc__Render_Condition__c = DocChild.Junodoc__Render_Condition__c.replace('ssz','\'');
                }
            }
          	  system.debug( 'Queries **** ' + Queries);
             
            list<Sobject> SobjectRecs = Database.query(Queries);
            string checks = '<tbody id="'+DocChild.Junodoc__Child_object__c+DocChild.Junodoc__Sort_Order__c+'">';
         
            if(NewTemplateBody.contains('<tbody id="'+DocChild.Junodoc__Child_object__c+DocChild.Junodoc__Sort_Order__c+'">')){
             	 string parentstr = '';
                string divStr = '';
               /* if(NewTemplatebody.contains('<tr id="parenttr4"')){
                    string parentstrBody = NewTemplatebody.split('<tr id="parenttr4"')[1];
                    parentstr = '<tr id="parenttr4"' + parentstrBody.split('</tr>')[0] + '</tr>';
                    NewTemplatebody = NewTemplatebody.replace(parentstr,'');
                }*/
                if(NewTemplatebody.contains('<div id="parentTable'+DocChild.Junodoc__Sort_Order__c+'"')){
                    string parentstrBody = NewTemplatebody.split('<div id="parentTable'+DocChild.Junodoc__Sort_Order__c+'"')[1];
                    parentstr = '<div id="parentTable'+DocChild.Junodoc__Sort_Order__c+'"' + parentstrBody.split('</tr>')[0] + '</tr>';
                  //  NewTemplatebody = NewTemplatebody.replace(parentstr,'');
                }
                if(NewTemplatebody.contains('<tr id="parenttr'+DocChild.Junodoc__Sort_Order__c+'"')){
                    string parentstrBody = NewTemplatebody.split('<tr id="parenttr'+DocChild.Junodoc__Sort_Order__c+'"')[1];
                    string parentstrs = '<tr id="parenttr'+DocChild.Junodoc__Sort_Order__c+'"' + parentstrBody.split('</tr>')[0] + '</tr>';
                    NewTemplatebody = NewTemplatebody.replace(parentstrs,'');
                }
                string str = '';
                str += '<tbody id="'+DocChild.Junodoc__Child_object__c+DocChild.Junodoc__Sort_Order__c+'">';
                string[] childqueries = DocChild.Junodoc__Child_Query__c.split(',');
                string[] childLabels = new list<string>();
                if(DocChild.JunoDoc__Related_Object_Labels__c != null && DocChild.JunoDoc__Related_Object_Labels__c != '')
                childLabels = DocChild.JunoDoc__Related_Object_Labels__c.split(',');
                list<string> calqueries = new list<string>();
                list<string> AllCalqueries = new list<string>();
                set<string> CalSetString = new set<string>();
                 
                if(DocChild.Junodoc__Calculation_Fields__c != null){
                    string[] scalqueries = DocChild.Junodoc__Calculation_Fields__c.split(',');
                    for(string strs : scalqueries){
                        if(strs != '' && strs != null && !CalSetString.contains(strs.toLowerCase())){
                            CalSetString.add(strs.toLowerCase());
                            calqueries.add(strs.toLowerCase());
                        }
                        if(strs != null && strs != ''){
                            AllCalqueries.add(strs);
                        }
                    }
                }
              //  for(Doc_Template_Item__c DocTemplate : DocTemplateItem){
                    Map<string,decimal> ChildsobjMap = new Map<string,decimal>();
                     Map<string,decimal> parChildsobjMap = new Map<string,decimal>();
                     Map<string,decimal> AvgChildsobjMap = new Map<string,decimal>();
                     Map<string,decimal> AvgChildsCountMap = new Map<string,decimal>();
                    Map<string,string> RenChildsobjMap = new Map<string,string>();
                    integer AvgCalucaltion  =  SobjectRecs.size();
                    if(DocChild.Junodoc__Group_By__c == null || DocChild.Junodoc__Group_By__c == ''){
                   // for(Sobject Sb : SobjectRecs){                         
                        
                   // }
                    
                    integer i =1;
                   
                   string veralign = 'top';                                               
                   string curralign = 'right';
                   string stringaling = 'left';
                   Map<integer,string> curralignmap = new Map<integer,string>();
                   Map<integer,string> stralignmap = new Map<integer,string>();
                   Map<integer,string> veralignmap = new Map<integer,string>();
                   
                   if(!childLabels.isEmpty()){
                       integer labelsize = 1;
                       for(string lables : childLabels){
                           if(lables.contains('[[')){
                               string[] childlabellist = (lables).replace('[[','ssss').split('ssss');
                               for(string childs : childlabellist){
                                   if(!childs.tolowercase().contains('top') || !childs.tolowercase().contains('bottom')){
                                       string curralignInn = childs.replace(']]','ssss').split('ssss')[0];  
                                       string stringalingInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                       curralignInn = curralignInn.replace('s','');
                                       stringalingInn = stringalingInn.replace('s','');
                                       curralignmap.put(labelsize,curralignInn);
                                       stralignmap.put(labelsize,stringalingInn);
                                   }
                                   else{
                                       string veralignInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                       veralignInn = veralignInn.replace('s','');
                                       veralignmap.put(labelsize,veralignInn);
                                   }  
                               }
                           }
                           labelsize = labelsize + 1;
                       }
                   } 
                     RenChildsobjMap = new Map<string,string>(); 
                    for(Sobject Sb : SobjectRecs){ 
                        for(string childs : calqueries){
                                NewTemplateBody = NewTemplateBody.replace('SUM ('+childs+DocChild.Junodoc__Sort_Order__c+')','SUM('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('AVG ('+childs+DocChild.Junodoc__Sort_Order__c+')','AVG('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('PAR ('+childs+')','PAR('+childs+')');
                                decimal Childstrings = 0;
                                if(!childs.contains('.') ){
                                    if(Sb.get(childs)  != null){
                                        Childstrings = decimal.valueof(''+ Sb.get(childs));                
                                    }
                                }
                                else{
                                string Stringobjct = childs.replace('.',',');
                                string[] Stringobjcts = Stringobjct.split(',');
                                
                                if(Stringobjcts.size() > 3){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                            }
                                        }
                                    }
                                }
                                else if(Stringobjcts.size() > 2){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                            }
                                        }
                                    }
                                }
                                else{
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                            Childstrings =  decimal.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                        }
                                    }
                                } 
                            }
                            
                            if(ChildsobjMap.get('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')') == null){
                                ChildsobjMap.put('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')',  Childstrings);
                            }
                            else{
                                childstrings += ChildsobjMap.get('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')');
                                ChildsobjMap.put('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')',  Childstrings);   
                            }
                            
                          if(ChildsobjMap.get('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')') == null){
                                AvgChildsobjMap.put('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')',  Childstrings);
                            }
                            else{
                                childstrings += AvgChildsobjMap.get('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')');
                                AvgChildsobjMap.put('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')',  Childstrings);   
                            }

                            if(parChildsobjMap.get('PAR('+childs+')') == null && childs.contains('.')){
                                parChildsobjMap.put('PAR('+childs+')',Childstrings);
                            }  
                            
                            if(RenChildsobjMap.get(''+childs) == null){
                                RenChildsobjMap.put(''+childs,''+Childstrings); 
                            }   
                        }  
                        
                        for(string childs : calqueries){
                            string allvalues = RenChildsobjMap.get(childs);
                            if(childs.contains('.') ){
                                NewTemplateBody = NewTemplateBody.replace(''+childs,allvalues);
                            }   
                        }
                        string addcolor = DocChild.Junodoc__color_1__c;
                        Integer y = i/2;
                        Integer z = y * 2;
                        if(i == z ){
                            addcolor = DocChild.Junodoc__color_2__c;
                        }
                        str += '<tr style="background-color:'+addcolor+'">';
                        integer crows = 1;
                        for(string childs : childqueries){
                            if(curralignmap.get(crows) != null){
                                curralign = curralignmap.get(crows);
                            }
                            else{
                                curralign = 'right';
                            }
                            if(veralignmap.get(crows) != null){
                                veralign = veralignmap.get(crows);
                            }
                            else{
                                veralign = 'top';
                            }
                            if(stralignmap.get(crows) != null){
                                stringaling = stralignmap.get(crows);
                            }
                            else{
                                stringaling = 'left';
                            }
                            string Childstring = '';
                            if(!childs.contains('.')){
                                if(Sb.get(childs)  != null){
                                    string Types = ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase());
                                    
                                            if(Types == 'CURRENCY'){
                                                Childstring =  GetCurrencyvalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Childstring =  GetNumbervalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(Sb.get(childs));
                                                Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            }
                                            else if(Types == 'DATETIME'){
                                                TimeZone userTimeZone = UserInfo.getTimeZone();
                                                String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                DateTime nowInUserContext = Datetime.valueof(Sb.get(childs));
                                                Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            }
                                            if(TYpes == 'BOOLEAN'){
                                                //Childstring = ''+ Sb.get(childs);   
                                                boolean textbool = boolean.valueof(''+ Sb.get(childs));
                                                if(textbool == true){
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                        }
                                        else{
                                            system.debug('childs**********'+ Sb.get(childs));
                                            Childstring = convertHtmlString(''+ Sb.get(childs));   
                                                          system.debug('Childstring**********'+ Childstring);
                                        }
                                }
                            }
                            else{
                                string Stringobjct = childs.replace('.',',');
                                string[] Stringobjcts = Stringobjct.split(',');
                                if(Stringobjcts.size() > 3){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                         
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                               		TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                      
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }

                                               }
                                            }
                                        }
                                    }
                                }
                                else if(Stringobjcts.size() > 2){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                         
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }

                                            }
                                        }
                                    }
                                }
                                else{
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                            string Types = getRelType(ChildObjField,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                           
                                            if(Types == 'CURRENCY'){
                                                Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            }
                                            else if(Types == 'DATETIME'){
                                                TimeZone userTimeZone = UserInfo.getTimeZone();
                                                String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            }
                                            else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox"  src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                            else{
                                                Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }                                        
                                        }
                                    }
                                }  
                            }
                             
                            if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'CURRENCY'){
                                 string currencyvalue = GetCurrencyvalues(''+Childstring);
                                str += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  currencyvalue + '</td>';
                            }
                            
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'NUMBER' 
                                    || ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DOUBLE'
                                    || ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DECIMAL'){
                                        string Numbervalue = GetNumbervalues(''+Childstring);
                                str += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  Numbervalue+ '</td>';
                            }
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DATE'){  
                                if(Childstring != null && Childstring != ''){
                                    Date Datestr = Date.valueof(Childstring);
                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                }
                                str += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  Childstring + '</td>';
                            }
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DATETIME'){
                                if(Childstring != null && Childstring != ''){
                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                    DateTime nowInUserContext = Datetime.valueof(Childstring);
                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                }
                                str += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  Childstring + '</td>';
                            }
                            else{
                                                  
                                Childstring = string.join(Childstring.split(' '),' ');
                              //  Childstring = Childstring.replace('nbsp','888');
                                Childstring = string.join(Childstring.split('&nbsp;'),' ');
                                Childstring = Childstring.replaceAll('[\u0000-\u001F]', ' ');
                                system.debug('Childstring last *** ' + Childstring);
                                //Childstring = processFormulaFieldHtml(Childstring);
                                str += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+'; height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  Childstring + '</td>';
                            }   
                            crows = crows+1;
                        }
                        str += '</tr>'; 
                        
                        if(DocChild.JunoDoc__Extra_Fields__c != null && DocChild.JunoDoc__Extra_Fields__c != '' && DocChild.JunoDoc__Extra_Fields__c != '--select one--'){
                            decimal colspanVal = childLabels.size()/DocChild.JunoDoc__Extra_Fields__c.split(',').size();
                            str += '<tr >'; 
                            for(string childs : DocChild.JunoDoc__Extra_Fields__c.split(',')){
                                string Childstring = '';
                                if(childs.contains('.')){
                                    string Stringobjct = childs.replace('.',',');
                                    string[] Stringobjcts = Stringobjct.split(',');
                                    if(Stringobjcts.size() > 3){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                         
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                    
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }

                                               }
                                            }
                                        }
                                    }
                                }
                                else if(Stringobjcts.size() > 2){
                                        if(Sb.getsobject(Stringobjcts[0]) != null){
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                    string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                    string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                             
                                                    if(Types == 'CURRENCY'){
                                                        Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    }
                                                    else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                        Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    }
                                                    else if(Types == 'DATE'){
                                                        Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                        Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                    }
                                                    else if(Types == 'DATETIME'){
                                                        TimeZone userTimeZone = UserInfo.getTimeZone();
                                                        String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                        DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                        Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                    }
                                                    else if(Types == 'BOOLEAN'){
                                                        boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                        if(textbool == true){
                                                            Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                        }
                                                        else{
                                                            Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                        }
                                                    }
                                                    else{ 
                                                        Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    }
                                    
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        if(Sb.getsobject(Stringobjcts[0]) != null){
                                            if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                string Types = getRelType(ChildObjField,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                               
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                        boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                        if(textbool == true){
                                                            Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                        }
                                                        else{
                                                            Childstring = '<img data-forstyle="checkbox"  src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                        }
                                                    }
                                                else{
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                }                                        
                                            }
                                        }
                                    }  
                                }
                                else{
                                    if(Sb.get(childs)  != null){
                                    string Types = ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase());
                                    
                                            if(Types == 'CURRENCY'){
                                                Childstring =  GetCurrencyvalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Childstring =  GetNumbervalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(Sb.get(childs));
                                                Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            }
                                            else if(Types == 'DATETIME'){
                                                TimeZone userTimeZone = UserInfo.getTimeZone();
                                                String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                DateTime nowInUserContext = Datetime.valueof(Sb.get(childs));
                                                Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            }
                                            if(TYpes == 'BOOLEAN'){
                                                //Childstring = ''+ Sb.get(childs);   
                                                boolean textbool = boolean.valueof(''+ Sb.get(childs));
                                                if(textbool == true){
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                        }
                                        else{
                                            Childstring = convertHtmlString(''+ Sb.get(childs));        
                                        }
                                }
                                }
                                Childstring = Childstring.replaceAll('[\u0000-\u001F]', ' ');
                                str += '<td colspan="'+colspanVal+'" style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';height:'+DocChild.Junodoc__height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.Junodoc__border__c+';padding:'+DocChild.Junodoc__Padding__c+'">'+  Childstring + '</td>';
                            
                            }
                            str += '</tr>'; 
                        }
                        if(DocChild.JunoDoc__Related_Object_Child_Query__c != null && DocChild.JunoDoc__Related_Object_Child_Query__c != '' && DocChild.JunoDoc__Related_Object_Child_Query__c != '--select one--'){
                          //  str += '<tr >'; 
                            str += getChildTabelData(DocChild,str,uncheckdocument,checkdocument,sfdcURLForDocImage,ParentChildobjectsMap,Sb,parentstr,ChildFieldNameslist.size());
                          //  str += '</tr >'; 
                        }
                        i = i+1;
                    
                    } 
                    }
                
                    for(string childs : Allcalqueries){ 
                        decimal values = ChildsobjMap.get('SUM('+childs.toLowercase()+DocChild.Junodoc__Sort_Order__c+')');
                        if(ChildsobjMap.get('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')') == null){
                            values = 0;
                        } 
                        decimal avgval = 0;
                        if(AvgChildsobjMap.get('AVG('+childs.toLowercase()+DocChild.Junodoc__Sort_Order__c+')') != null){
                            avgval = AvgChildsobjMap.get('AVG('+childs.toLowercase()+DocChild.Junodoc__Sort_Order__c+')')/AvgCalucaltion;
                           
                        }
                        
                        decimal parvalues = parChildsobjMap.get('PAR('+childs.toLowercase()+')');
                        if(parChildsobjMap.get('PAR('+childs.toLowercase()+')') == null){
                            parvalues = 0;
                        }
                        string allvalues = RenChildsobjMap.get(childs);
                        if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'CURRENCY'){
                            NewTemplateBody = NewTemplateBody.replace('SUM ('+childs+DocChild.Junodoc__Sort_Order__c+')','SUM('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('AVG ('+childs+DocChild.Junodoc__Sort_Order__c+')','AVG('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('PAR ('+childs+')','PAR('+childs+')').replace('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')','\''+GetCurrencyvalues(''+values)+'\'').replace('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')','\''+GetCurrencyvalues(''+avgval)+'\'').replace('PAR('+childs+')','VALUE(\''+parvalues + '\')');               
                        }
                        else{
                            NewTemplateBody = NewTemplateBody.replace('SUM ('+childs+DocChild.Junodoc__Sort_Order__c+')','SUM('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('AVG ('+childs+DocChild.Junodoc__Sort_Order__c+')','AVG('+childs+DocChild.Junodoc__Sort_Order__c+')').replace('PAR ('+childs+')','PAR('+childs+')').replace('SUM('+childs+DocChild.Junodoc__Sort_Order__c+')','\''+GetNumbervalues(''+values)+'\'').replace('AVG('+childs+DocChild.Junodoc__Sort_Order__c+')','\''+GetNumbervalues(''+avgval)+'\'').replace('PAR('+childs+')','VALUE(\''+parvalues + '\')');               
                        }    
                    }
                    
                    if(DocChild.JunoDoc__Child_Group_By__c != null && DocChild.JunoDoc__Child_Group_By__c != '' && DocChild.JunoDoc__Child_Group_By__c != '--select one--' &&
                        DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                        str = JunoDocDynamicGroupBy_AC.ChildGetDataDynamically(ChildObjField,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                            QuoteId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                            DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                            DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,DateFormats,sfdcURLForDocImage,checkdocument,uncheckdocument,
                                                                            CurrencyFormat,currencySymbols,DocChild.JunoDoc__Child_Group_By__c,SobjectApiName);    
                    }
                
                    else if(DocChild.Junodoc__Group_By__c != null && DocChild.Junodoc__Group_By__c != ''){
                        str = JunoDocDynamicGroupBy_AC.GetDataDynamically(ChildObjField,DocChild.Junodoc__Group_By__c,chquries,DocChild.Junodoc__Parent_Reference__c,
                                                                            QuoteId,DocChild.Junodoc__Filter__c,DocChild.Junodoc__Order_by__c,DocChild.Junodoc__Related_Object_Labels__c,
                                                                            DocChild.Junodoc__Color_1__c,DocChild.Junodoc__Color_2__c,DocChild.Junodoc__Header_style__c,DocChild.Junodoc__Header_Colour_background__c,
                                                                            DocChild.Junodoc__Border_Width__c,ChildobjectsMap,DocChild,DateFormats,sfdcURLForDocImage,checkdocument,uncheckdocument,
                                                                            CurrencyFormat,currencySymbols,DocChild.JunoDoc__Rollup_groupby__c,SobjectApiName);    
                    }
                
                
                    
                    NewTemplateBody = NewTemplateBody.replace(checks,str);
                   
             //   }      
               // for(Doc_Template_Item__c DocTemplate : DocTemplateItem){
                                              
                        }
         } 
        
        if(NewTemplateBody.contains('{{') || NewTemplateBody.contains('[{')){
            NewTemplateBody = NewTemplateBody.replace('{{','{!').replace('[{','{!').replace('}]','}').replace('}}','}');
        }
        TemplateBodys = '';
        if(NewTemplateBody != null)
        TemplateBodys = NewTemplateBody.replace('[[center]]','').replace('[[Center]]','').replace('[[Left]]','').replace('[[left]]','').replace('[[Right]]','').replace('[[right]]','').replace('<img', ' <img').replace('</a>', '  </a>');
        }
        else{
            PageReference ref = new PageReference('/apex/'+DocTemplates.VisualForce_Page__c+'?id='+recordId);
            if(!Test.isRunningTest()){
                TemplateBodys= string.valueof( ref.getcontent().tostring().trim() + '');
            }
            else{          
                TemplateBodys= string.valueof( 'tested');
            }
        }
        
        system.debug('TemplateBodys *** ' + TemplateBodys);
        
      
       /* }
        catch(Exception e){
            
        } */
    }
    global string TemplateBodys{get;set;}
   
    global string getBody(list<string> parentHeaderFieldsApi,string TemplateBody,string QuoteId,String Parentobject){
        return '';
    }
    global string getBody(list<string> parentHeaderFieldsApi,string TemplateBody,string QuoteId,String Parentobject,
                        string sfdcURL,string checkdocument,string uncheckdocument){
         String strFields = '';
        set<string> Setstring = new set<string>();     
        for(String fieldName : parentHeaderFieldsApi)
        {
            if(!Setstring.contains(fieldName.toLowerCase())){
                if(strFields == null || strFields == ''){
                    strFields = fieldName.toLowerCase();
                }
                else{
                    strFields = strFields + ' , ' + fieldName.toLowerCase();
                }
                Setstring.add(fieldName.toLowerCase());
            }
        } 
        string queries = '';                    
        if(Parentobject == 'Billing__c'){
            queries = 'select ' + strFields + ' from Billing__c where Id =:  QuoteId';                        
        }  
        else{
            queries = 'select ' + strFields + ' from ' + Parentobject + ' where Id =:  QuoteId';                                           
        }                    
        
        Sobject parentRefs = Database.query(queries); //Database.query(String.escapeSingleQuotes(queries));
        
        if(TemplateBody.contains('{!TODAY()}')){
            Date Datestr = system.Today();
            string DateFormat = DateFormats;
            if(resultMap.get('{!TODAY()}') != null){
                                            DateFormat = resultMap.get('{!TODAY()}');
                                        }
            string Parentvalues = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);                
            TemplateBody = TemplateBody.replace('{!TODAY()}',Parentvalues);           
        }
        if(TemplateBody.contains('{!NOW()}')){
            string DateFormat = DateFormats;
            if(resultMap.get('{!NOW()}') != null){
                                            DateFormat = resultMap.get('{!NOW()}');
                                        }
            string Parentvalues = Datetime.valueof(''+system.Now()).format(DateFormat + ' HH:mm a');
            TemplateBody = TemplateBody.replace('{!NOW()}',Parentvalues);
            
        }
        
        //DocTemplates.Parent_Fields__c = strFields; 
        Map<string,string> parentobjectsMap = new Map<string,string>();
        Map<string,string> RelparentobjectsMap = new Map<string,string>();
        Map <String, Schema.SObjectType> schemaMaps = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMaps = schemaMaps.get(Parentobject).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMaps.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            parentobjectsMap.put(dfield.getname().toLowercase(),''+dfield.getType ());
            if(dfield.getRelationshipName() != null){
                RelparentobjectsMap.put(''+dfield.getRelationshipName().toLowercase(),''+dfield.getname().toLowercase());
            }
        }


                    TemplateBody = TemplateBody.replace('<div class="ui-resizable-handle ui-resizable-e" style="z-index: 90;"></div>','').replace('<div class="ui-resizable-handle ui-resizable-s" style="z-index: 90;"></div>','').replace('<div class="ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se" style="z-index: 90;"></div>','');
                   
                    //TemplateBody = TemplateBody.replace('top: -','top: ');
                    string[] StringValues = parentHeaderFieldsApi;
                    //TemplateBody = TemplateBody;
                    
                    for(string Strs : StringValues){
                        string str = strs.replace(' ','');  
                        string Parentvalue = '';
                        string rendParentvalue = '';
                        if(!str.contains('.')){
                            if(parentRefs.get(str) != null){
                                if(parentobjectsMap.get(str.toLowercase()) == 'DATE'){
                                  //  Date Datestr = Date.valueof(parentRefs.get(str));
                                    // Parentvalue = Datestr.month() + '/' +Datestr.day() + '/'+ Datestr.year();
                                     Date Datestr = Date.valueof(parentRefs.get(str));
                                    string DateFormat = DateFormats;
                                    if(resultMap.get('{!'+str+'}') != null){
                                            DateFormat = resultMap.get('{!'+str+'}');
                                        }
                                    Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                    string DateInt = ''+ Datestr.month();
                                    if(Datestr.month() < 10){
                                        DateInt = '0'+Datestr.month();
                                    }
                                     rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                }
                                
                                else if(parentobjectsMap.get(str.toLowercase()) == 'CURRENCY'){
                                    Parentvalue = GetCurrencyvalues(''+parentRefs.get(str));
                                    rendParentvalue = ''+parentRefs.get(str);
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'NUMBER' || parentobjectsMap.get(str.toLowercase()) == 'DOUBLE'){
                                    Parentvalue = GetNumbervalues(''+parentRefs.get(str));
                                    rendParentvalue = ''+parentRefs.get(str);
                                }
                                
                                else if(parentobjectsMap.get(str.toLowercase()) == 'DATETIME'){
                                    string DateFormat = DateFormats;
                                    if(resultMap.get('{!'+str+'}') != null){
                                            DateFormat = resultMap.get('{!'+str+'}');
                                        }
                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                    String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                    DateTime nowInUserContext = Datetime.valueof(parentRefs.get(str));
                                    Parentvalue = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                    rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRefs.get(str)).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                }
                                else if(parentobjectsMap.get(str.toLowercase()) == 'BOOLEAN'){
                                    boolean textbool = boolean.valueof(''+parentRefs.get(str)); 
                                    rendParentvalue = '' + textbool;
                                    if(textbool == true){
                                        Parentvalue = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                    else{
                                        Parentvalue = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                    }
                                }
                                else{
                                    Parentvalue = convertHtmlString(''+ parentRefs.get(str));
                                    rendParentvalue = '\''+parentRefs.get(str)+'\'';
                                }
                                TemplateBody = TemplateBody.replace('{!'+Str+'}',Parentvalue);
                                TemplateBody = TemplateBody.replace('{{'+Str+'}}',rendParentvalue.replace('\r', ' ').replace('\n', ' '));  
                            }
                            else{
                                TemplateBody = TemplateBody.replace('{!'+Str+'}','');
                            }
                        }
                        else{
                            string Stringobjct = str.replace('.',',');
                            string[] Stringobjcts = Stringobjct.split(',');
                            if(Stringobjcts.size() > 3){
                                    if(parentRefs.getsobject(Stringobjcts[0]) != null){
                                        if(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                string firstchild = getchilType(Parentobject,Stringobjcts[0]);
                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                string Parentvalues = '';
                                                rendParentvalue =  '';
                                                if(Types == 'CURRENCY'){
                                                    Parentvalues =  GetCurrencyvalues(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                }
                                                if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Parentvalues =  GetNumbervalues(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                }
                                                else if(Types == 'DATE'){
                                                    string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                    Date Datestr = Date.valueof(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                                    string DateInt = ''+ Datestr.month();
                                                    if(Datestr.month() < 10){
                                                        DateInt = '0'+Datestr.month();
                                                    }
                                                    rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                                }
                                                else if(Types == 'DATETIME'){
                                                     string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                   rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])); 
                                                    rendParentvalue = ''+textbool;
                                                    if(textbool == true){
                                                        Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Parentvalues = convertHtmlString(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    rendParentvalue = '\'' + Parentvalues + '\'';
                                                }
                                                TemplateBody = TemplateBody.replace('{!'+Str+'}',''+Parentvalues);
                                                TemplateBody = TemplateBody.replace('{{'+Str+'}}',rendParentvalue.replace('\r', ' ').replace('\n', ' '));  
                                            }
                                        }
                                    }
                                }
                                else if(Stringobjcts.size() > 2){
                                    if(parentRefs.getsobject(Stringobjcts[0]) != null){
                                        if(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                string firstchild = getchilType(Parentobject,Stringobjcts[0]);
                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                string Parentvalues = '';
                                                rendParentvalue =  '';
                                                if(Types == 'CURRENCY'){
                                                    Parentvalues =  GetCurrencyvalues(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Parentvalues =  GetNumbervalues(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                }
                                                else if(Types == 'DATE'){
                                                    string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                    Date Datestr = Date.valueof(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                                    string DateInt = ''+ Datestr.month();
                                                    if(Datestr.month() < 10){
                                                        DateInt = '0'+Datestr.month();
                                                    }
                                                    rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                                }
                                                else if(Types == 'DATETIME'){
                                                    string DateFormat = DateFormats;
                                                    if(resultMap.get('{!'+str+'}') != null){
                                                        DateFormat = resultMap.get('{!'+str+'}');
                                                    }
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                    rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    rendParentvalue = ''+textbool;
                                                    if(textbool == true){
                                                        Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Parentvalues = '<img data-forstyle="checkbox" src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Parentvalues = convertHtmlString(''+parentRefs.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    rendParentvalue = '\''+Parentvalues + '\'';
                                                }
                                                Parentvalues = Parentvalues.replaceAll('[\u0000-\u001F]', ' ');
                                                TemplateBody = TemplateBody.replace('{!'+Str+'}',''+Parentvalues);
                                                 TemplateBody = TemplateBody.replace('{{'+Str+'}}',rendParentvalue.replace('\r', ' ').replace('\n', ' ')); 
                                            }
                                        }
                                    }
                                }
                            else{
                                if(parentRefs.getsobject(Stringobjcts[0]) != null){
                                    
                                    if(parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                        string Types = getRelType(Parentobject,Stringobjcts[0],Stringobjcts[1]);
                                        
                                        string Parentvalues = '';
                                        rendParentvalue =  '';
                                        if(Types == 'CURRENCY'){
                                            Parentvalues =  GetCurrencyvalues(''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                        }
                                        else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                            Parentvalues =  GetNumbervalues(''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            rendParentvalue = ''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                        }
                                        else if(Types == 'DATE'){
                                            string DateFormat = DateFormats;
                                            if(resultMap.get('{!'+str+'}') != null){
                                                DateFormat = resultMap.get('{!'+str+'}');
                                            }
                                            Date Datestr = Date.valueof(''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            Parentvalue = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormat);
                                            string DateInt = ''+ Datestr.month();
                                                    if(Datestr.month() < 10){
                                                        DateInt = '0'+Datestr.month();
                                                    }
                                                    rendParentvalue = 'DATEVALUE(\''+Datestr.year() + '-' +DateInt + '-'+ Datestr.day()+ '\')';
                                        }
                                        else if(Types == 'DATETIME'){
                                            string DateFormat = DateFormats;
                                            if(resultMap.get('{!'+str+'}') != null){
                                                DateFormat = resultMap.get('{!'+str+'}');
                                            }
                                            TimeZone userTimeZone = UserInfo.getTimeZone();
                                            String dateTimeFormat = DateFormat + ' HH:mm a'; 
                                            DateTime nowInUserContext = Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            Parentvalues = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            rendParentvalue = 'DATETIMEVALUE(\''+ Datetime.valueof(parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format('yyyy-MM-dd HH:mm:ss') +'\')';
                                        }
                                        else if(Types == 'BOOLEAN'){
                                            boolean textbool = boolean.valueof(parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1])); 
                                            rendParentvalue = ''+rendParentvalue;
                                            if(textbool == true){
                                                Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                            }
                                            else{
                                                Parentvalues = '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                            }
                                        }
                                        else{ 
                                            Parentvalues = convertHtmlString(''+parentRefs.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            rendParentvalue = '\''+Parentvalues+'\'';
                                        }
                                        Parentvalues = Parentvalues.replaceAll('[\u0000-\u001F]', ' ');
                                        Parentvalues = Parentvalues.replace('\n','<br/>');
                                         TemplateBody = TemplateBody.replace('{!'+Str+'}',Parentvalues);
                                        TemplateBody = TemplateBody.replace('{{'+Str+'}}',rendParentvalue.replace('\r', ' ').replace('\n', ' ')); 
                                    }
                                    else{
                                         TemplateBody = TemplateBody.replace('{!'+Str+'}','');
                                    }
                                }
                                else{
                                    TemplateBody = TemplateBody.replace('{!'+Str+'}','');
                                }
                            }
                        }
                    }
       if(TemplateBody.contains('{{') || TemplateBody.contains('[{')){
           TemplateBody = TemplateBody.replace('{{','{!').replace('[{','{!').replace('}]','}').replace('}}','}');
        }
       TemplateBody = TemplateBody.replace('[[top]]','').replace('[[Top]]','').replace('[[bottom]]','').replace('[[Bottom]]','').replace('[[center]]','').replace('[[Center]]','').replace('[[Left]]','').replace('[[left]]','').replace('[[Right]]','').replace('[[right]]','');
                            
    return TemplateBody;
}
    
    global Component.Apex.OutputText getClassroomRelatedLists() {
        Component.Apex.OutputText head1 = new Component.Apex.OutputText();
        if(TemplateBodys != null){
            if(Type != 'WordTemplate'){
                head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',null)}"</div>'+TemplateBodys.replace('<p>','').replace('</p>','<br/>') ;
            }
            else{
                head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',null)}"</div>'+TemplateBodys ;
            }
        }
        else{
            head1.expressions.value = '';
        }
        
        return head1;
    }
    
    global Component.Apex.OutputText getheaderLists() {
        Component.Apex.OutputText head1 = new Component.Apex.OutputText();
        if(HeaderBody.contains('{{showPageNumber}}')){                          
            HeaderBody = HeaderBody.replace('{{showPageNumber}}','Page <span class="pagenumber"/> of <span class="pagecount"/>');
        }
        head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',null)}"</div>'+HeaderBody ;
        return head1;
    }
    
    global Component.Apex.OutputText getFooterLists() {
        Component.Apex.OutputText head1 = new Component.Apex.OutputText();
        system.debug('FooterBody***' + FooterBody);
        if(FooterBody.contains('{{showPageNumber}}')){                          
            FooterBody = FooterBody.replace('{{showPageNumber}}','Page <span class="pagenumber"/> of <span class="pagecount"/>');
        }
        head1.expressions.value = '<div style="font-size: 0px;">{!IF((2==2),\'\',null)}"</div>'+FooterBody;
        return head1;
    }

    global string output{get;set;}
    global PageReference methodone(){  
        
        return null;
    }
    
    
    global string GetCurrencyvalues(string currencyvalue){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
      //  system.debug('CurrencyFormat' + CurrencyFormat);
        if(CurrencyFormat.contains('.0')){
            CurrList = CurrencyFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
        }
        if(CurrencyFormat.contains(',0')){
            CurrList = CurrencyFormat.replace(',','xx').split('xx');
           // system.debug('CurrList' + CurrList);
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
       // system.debug(currencyvalue + ' currencyvalue');
        string currencies = '';
        
        string currencysymbol = '$';
        if(currencysymbols != null && currencysymbols != ''){
            currencysymbol = currencysymbols;
        }
        
        if(currencyvalue != '' && currencyvalue != null){
            if(decimal.valueof(''+currencyvalue) > 0){
                currencies =  currencysymbol +  doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
            }
            else if(blankasZeroes == true){
                currencies = currencysymbol + doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
            }
        }
        else if(blankasZeroes == true){
            currencies = currencysymbol +  doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
    
    }
    
    public String processFormulaFieldHtml(String formulaFieldHtml) {
    if (String.isBlank(formulaFieldHtml)) {
        return '';
    }

    String imageUrl = '';
    String siteLink = '';

    // Extract the image URL from <img src="URL">
    Pattern imgPattern = Pattern.compile('img src="([^"]+)"');
    Matcher imgMatcher = imgPattern.matcher(formulaFieldHtml);
    if (imgMatcher.find()) {
        imageUrl = imgMatcher.group(1);
    }

    // Extract the hyperlink from <a href="URL">
    Pattern linkPattern = Pattern.compile('a href="([^"]+)"');
    Matcher linkMatcher = linkPattern.matcher(formulaFieldHtml);
    if (linkMatcher.find()) {
        siteLink = linkMatcher.group(1);
    }

    // If no image URL found, return original content
    if (String.isBlank(imageUrl)) {
        return formulaFieldHtml;
    }
    string newHtml = ''; 
    if (!String.isBlank(siteLink)) {
        newHtml += '<a href="' + siteLink + '" target="blank" style="text-decoration:none">' + 
               '<img src="' + imageUrl + '" alt="Click Image"' + 
               ' style="width: 100px; height: 50px;"/><p>Click Here</p>' + 
               '</a>';
    } else {
        newHtml += '<img src="' + imageUrl + '" alt="Click Image" border="0"/>';
    }

    return newHtml;
}
    
    global string GetNumbervalues(string currencyvalue){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
        boolean showcurrency = false;
       // system.debug(currencyvalue + ' CurrencyFormat ' + NumberFormat);
        if(NumberFormat.contains('.0')){
            CurrList = NumberFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
            
        }
        else if(NumberFormat.contains(',0')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
          //  system.debug('CurrList' + CurrList);
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
        else if(NumberFormat.contains(',')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
          //  system.debug('CurrList' + CurrList);
            currlength = 0;
            firstcol = ',';
        }
        else if(NumberFormat.contains('.')){
            CurrList = NumberFormat.replace(',','xx').split('xx');
          //  system.debug('CurrList' + CurrList);
            currlength = 0;
            firstcol = '.';
        }
        else{
            showcurrency = true;
        }
       // system.debug(currencyvalue + ' currencyvalue');
        string currencies = '';
        
        if(currencyvalue != '' && currencyvalue != null){
            if(showcurrency == false){
                if(decimal.valueof(''+currencyvalue) > 0){
                    currencies =  doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
                }
                else if(blankasZeroes == true){
                    currencies = doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
                }
            }
            else{
                currencies = ''+integer.valueof(''+currencyvalue);
            }
        }
        else if(blankasZeroes == true){
            currencies = doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
    
    }
    global static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
        String s, tmp;
        Integer i = 4 + dec;
      //    system.debug(i + ' ****** ' + dec);
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
        //system.debug(i + ' ******new ');
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
       // system.debug(s + ' ******s ');
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
       // system.debug(s + ' ******tmp ');
        
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
        //system.debug(s + ' ******last5 ');
        return s;
    }
    global String getRelType(string ObjectName,String FieldName,String parfieldName){
   // system.debug(ObjectName + '***** '+ FieldName);
    if(FieldName.contains('__r')){
        FieldName = FieldName.replace('__r','__c');
    }
    else{
        FieldName = FieldName+'Id';
    }
    Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
        .get(objectName)
        .getDescribe()
        .fields
        .getMap()
        .get(fieldName)
        .getDescribe();
    string parObjectName = '';
    for(Schema.SObjectType reference : f.getReferenceTo()) {
        parObjectName = reference.getDescribe().getName();
    }
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType leadSchema = schemaMap.get(parObjectName);
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    string Types = ''+ fieldMap.get(parfieldName).getDescribe().getType();
    //debug('Types ' + Types);
    return Types;
    
}
    global String getchilType(string ObjectName,String FieldName){
   // system.debug(ObjectName + '***** '+ FieldName);
    if(FieldName.contains('__r')){
        FieldName = FieldName.replace('__r','__c');
    }
    else{
        FieldName = FieldName+'Id';
    }
    Schema.DescribeFieldResult f = Schema.getGlobalDescribe()
        .get(objectName)
        .getDescribe()
        .fields
        .getMap()
        .get(fieldName)
        .getDescribe();
    string parObjectName = '';
    for(Schema.SObjectType reference : f.getReferenceTo()) {
        parObjectName = reference.getDescribe().getName();
    }
    return parObjectName;
}
    
    public static String convertHtmlString(String content) {
    if (String.isBlank(content)) return content;

    // Regex to match any HTML tag (opening, closing, or self-closing)
    Pattern tagPattern = Pattern.compile('<[^>]+>');
    Matcher matcher = tagPattern.matcher(content);

    String result = '';
    Integer lastEnd = 0;

    while (matcher.find()) {
        // Text *outside* of tags → escape < >
        String textBetween = content.substring(lastEnd, matcher.start());
        result += escapePlainText(textBetween);

        // Keep the HTML tag itself unchanged
        result += matcher.group();

        lastEnd = matcher.end();
    }

    // Escape text after last tag
    result += escapePlainText(content.substring(lastEnd));

    return result;
}

// Escapes only < and > in plain text (not inside tags)
private static String escapePlainText(String value) {
    if (String.isBlank(value)) return value;
    return value.replace('<', '--lt--').replace('>', '--gt--');
}

    public Boolean shouldCheckDigit { get; set; }
    public String sourceCodeValue   { get; set; }
    public String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';
    
 // The binary representation of each character, 16 bits each.
    public static String[] values = new String[] {
        '1010001110111010', '1110100010101110', '1011100010101110', '1110111000101010',
        '1010001110101110', '1110100011101010', '1011100011101010', '1010001011101110',
        '1110100010111010', '1011100010111010', '1110101000101110', '1011101000101110',
        '1110111010001010', '1010111000101110', '1110101110001010', '1011101110001010',
        '1010100011101110', '1110101000111010', '1011101000111010', '1010111000111010',
        '1110101010001110', '1011101010001110', '1110111010100010', '1010111010001110',
        '1110101110100010', '1011101110100010', '1010101110001110', '1110101011100010',
        '1011101011100010', '1010111011100010', '1110001010101110', '1000111010101110',
        '1110001110101010', '1000101110101110', '1110001011101010', '1000111011101010',
        '1000101011101110', '1110001010111010', '1000111010111010', '1000100010001010',
        '1000100010100010', '1000101000100010', '1010001000100010', '1000101110111010' };

   

    // Returns a string in case we also want to debug the output.
    public String generateCode39(String source, Boolean checkDigit) {        
        // Output
        String[] result = new String[0];
        Integer index,      // Temp variable
        total = 0;  // Checksum calculation
        source = source == null? '': source;
        result.add(values[keys.indexOf('*')]);
        for(String sourceChar: source.toUpperCase().split('')) {
            if((index = keys.indexOf(sourceChar)) > -1) {
                result.add(values[index]);
                total += index;
            }
        }
        if(checkDigit) {
            result.add(values[Math.mod(total, 43)]);
        }
        result.add(values[keys.indexOf('*')]);
        return String.join(result,'');
    }
   /* public static void dummy(){
        integer i = 0;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
    
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
    i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
    i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
         i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
    i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
    i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;i=i+1;
        i=i+1;i=i+1;i=i+1;i=i+1;
       
    }*/
    
    public string getChildTabelData(JunoDoc__Doc_Template_Child__c DocChild,string str,Document uncheckdocument,Document  checkdocument,string sfdcURLForDocImage,map<string,string> ChildobjectsMap,Sobject childSobj,string parentstr,integer colspan){
          integer i =1;
            set<string>  DuplChilds = new set<string>();
            string chquries = '';
            
            list<string> ChildFieldNameslist = DocChild.JunoDoc__Related_Object_Child_Query__c.split(',');
            for(string strs : ChildFieldNameslist){
                if(!DuplChilds.contains(strs.toLowerCase())){ 
                    DuplChilds.add(strs.toLowerCase());
                    chquries += strs.toLowerCase() + ',';
                }
            }
        if(chquries.length() > 1){
                chquries = chquries.substring(0,chquries.length() - 1);
            }
                   string veralign = 'top';                                               
                   string curralign = 'right';
                   string stringaling = 'left';
                   Map<integer,string> curralignmap = new Map<integer,string>();
                   Map<integer,string> stralignmap = new Map<integer,string>();
                   Map<integer,string> veralignmap = new Map<integer,string>();
        string ChildObjField = DocChild.JunoDoc__Parent_Child_Object__c.replace('[','---').split('---')[0];
        list<string> childqueries = DocChild.JunoDoc__Related_Object_Child_Query__c.split(',');
        string quoteNewId = ''+childSobj.get(DocChild.JunoDoc__Parent_Child_Reference__c);
        system.debug('DocChild.JunoDoc__Parent_Child_Object__c **** ' + DocChild.JunoDoc__Parent_Child_Object__c);
        String Queries = ' SELECT '+ chquries + ' from ' + ChildObjField + ' where '+ DocChild.JunoDoc__Parent_Child_Object_Reference__c + ' = \''+ quoteNewId+ '\' ';
         system.debug('Queries **** ' + Queries);
        list<Sobject> SobjectRecs = Database.query(Queries);
        string strs = '';
        strs += '<tr><td colspan="'+colspan+'">';
        strs += parentstr;
        system.debug('strs*** ' + strs);
        for(Sobject Sb : SobjectRecs){ 
                        
                        string addcolor = DocChild.JunoDoc__Child_Color_1__c;
                        Integer y = i/2;
                        Integer z = y * 2;
                        if(i == z ){
                            addcolor = DocChild.JunoDoc__Child_Color_2__c;
                        }
            			
                        strs += '<tr style="background-color:'+addcolor+'">';
                        integer crows = 1;
                        for(string childs : childqueries){
                            if(curralignmap.get(crows) != null){
                                curralign = curralignmap.get(crows);
                            }
                            else{
                                curralign = 'right';
                            }
                            if(veralignmap.get(crows) != null){
                                veralign = veralignmap.get(crows);
                            }
                            else{
                                veralign = 'top';
                            }
                            if(stralignmap.get(crows) != null){
                                stringaling = stralignmap.get(crows);
                            }
                            else{
                                stringaling = 'left';
                            }
                            string Childstring = '';
                            if(!childs.contains('.')){
                                if(Sb.get(childs)  != null){
                                    string Types = ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase());
                                    
                                            if(Types == 'CURRENCY'){
                                                Childstring =  GetCurrencyvalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Childstring =  GetNumbervalues(''+Sb.get(childs));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(Sb.get(childs));
                                                Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            }
                                            else if(Types == 'DATETIME'){
                                                TimeZone userTimeZone = UserInfo.getTimeZone();
                                                String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                DateTime nowInUserContext = Datetime.valueof(Sb.get(childs));
                                                Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            }
                                            if(TYpes == 'BOOLEAN'){
                                                //Childstring = ''+ Sb.get(childs);   
                                                boolean textbool = boolean.valueof(''+ Sb.get(childs));
                                                if(textbool == true){
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                                else{
                                                    Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                }
                                        }
                                        else{
                                            system.debug('childs**********'+ Sb.get(childs));
                                            Childstring = convertHtmlString(''+ Sb.get(childs));   
                                                          system.debug('Childstring**********'+ Childstring);
                                        }
                                }
                            }
                            else{
                                string Stringobjct = childs.replace('.',',');
                                string[] Stringobjcts = Stringobjct.split(',');
                                if(Stringobjcts.size() > 3){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                         
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                               		TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                      
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                }

                                               }
                                            }
                                        }
                                    }
                                }
                                else if(Stringobjcts.size() > 2){
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                string firstchild = getchilType(ChildObjField,Stringobjcts[0]);
                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                         
                                                if(Types == 'CURRENCY'){
                                                    Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }
                                                else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                    Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }
                                                else if(Types == 'DATE'){
                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                }
                                                else if(Types == 'DATETIME'){
                                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                    DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                                }
                                                else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                                else{ 
                                                    Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                }

                                            }
                                        }
                                    }
                                }
                                else{
                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                            string Types = getRelType(ChildObjField,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                           
                                            if(Types == 'CURRENCY'){
                                                Childstring =  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }
                                            else if(Types == 'NUMBER' || Types == 'DOUBLE'){
                                                Childstring =  GetNumbervalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }
                                            else if(Types == 'DATE'){
                                                Date Datestr = Date.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                            }
                                            else if(Types == 'DATETIME'){
                                                TimeZone userTimeZone = UserInfo.getTimeZone();
                                                String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                                DateTime nowInUserContext = Datetime.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                            }
                                            else if(Types == 'BOOLEAN'){
                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                    if(textbool == true){
                                                        Childstring = '<img data-forstyle="checkbox" src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image"  class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                    else{
                                                        Childstring = '<img data-forstyle="checkbox"  src="'+sfdcURLForDocImage+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" class="images" style="width: 15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                    }
                                                }
                                            else{
                                                Childstring = convertHtmlString(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                            }                                        
                                        }
                                    }
                                }  
                            }
                             
                            if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'CURRENCY'){
                                 string currencyvalue = GetCurrencyvalues(''+Childstring);
                                strs += '<td style="font-family:'+DocChild.JunoDoc__Child_Border_Style__c+';font-size:'+DocChild.JunoDoc__Child_Font_Size__c+';height:'+DocChild.JunoDoc__Child_Height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.JunoDoc__Child_Border__c+';padding:'+DocChild.JunoDoc__Child_Padding__c+'">'+  currencyvalue + '</td>';
                            }
                            
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'NUMBER' 
                                    || ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DOUBLE'
                                    || ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DECIMAL'){
                                        string Numbervalue = GetNumbervalues(''+Childstring);
                                strs += '<td style="font-family:'+DocChild.JunoDoc__Child_Border_Style__c+';font-size:'+DocChild.JunoDoc__Child_Font_Size__c+';height:'+DocChild.JunoDoc__Child_Height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.JunoDoc__Child_Border__c+';padding:'+DocChild.JunoDoc__Child_Padding__c+'">'+  Numbervalue+ '</td>';
                            }
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DATE'){  
                                if(Childstring != null && Childstring != ''){
                                    Date Datestr = Date.valueof(Childstring);
                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                }
                                strs += '<td style="font-family:'+DocChild.JunoDoc__Child_Border_Style__c+';font-size:'+DocChild.JunoDoc__Child_Font_Size__c+';height:'+DocChild.JunoDoc__Child_Height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.JunoDoc__Child_Border__c+';padding:'+DocChild.JunoDoc__Child_Padding__c+'">'+  Childstring + '</td>';
                            }
                            else if(ChildobjectsMap.get(childs.toLowercase()+ChildObjField.toLowercase()) == 'DATETIME'){
                                if(Childstring != null && Childstring != ''){
                                    TimeZone userTimeZone = UserInfo.getTimeZone();
                                    String dateTimeFormat = DateFormats + ' HH:mm a'; 
                                    DateTime nowInUserContext = Datetime.valueof(Childstring);
                                    Childstring = nowInUserContext.format(dateTimeFormat, userTimeZone.getID());
                                }
                                strs += '<td style="font-family:'+DocChild.JunoDoc__Child_Border_Style__c+';font-size:'+DocChild.JunoDoc__Child_Font_Size__c+';height:'+DocChild.JunoDoc__Child_Height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.JunoDoc__Child_Border__c+';padding:'+DocChild.JunoDoc__Child_Padding__c+'">'+  Childstring + '</td>';
                            }
                            else{
                                                  
                                Childstring = string.join(Childstring.split(' '),' ');
                              //  Childstring = Childstring.replace('nbsp','888');
                                Childstring = string.join(Childstring.split('&nbsp;'),' ');
                                Childstring = Childstring.replaceAll('[\u0000-\u001F]', ' ');
                                system.debug('Childstring last *** ' + Childstring);
                                //Childstring = processFormulaFieldHtml(Childstring);
                                strs += '<td style="font-family:'+DocChild.JunoDoc__Child_Border_Style__c+';font-size:'+DocChild.JunoDoc__Child_Font_Size__c+'; height:'+DocChild.JunoDoc__Child_Height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.JunoDoc__Child_Border__c+';padding:'+DocChild.JunoDoc__Child_Padding__c+'">'+  Childstring + '</td>';
                            }   
                            crows = crows+1;
                        }
                        strs += '</tr>'; 
        }
        strs += '</tbody></table></div></td></tr>';
        system.debug('strs end *** ' + strs);
        return strs;
}
  
}
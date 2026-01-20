global class FileUploadAndReplace { 
    public string xmlText{get;set;}
    public string text{get;set;}
    public FileUploadAndReplace(){
        xmlText = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:oel="http://schemas.microsoft.com/office/2019/extlst" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cex="http://schemas.microsoft.com/office/word/2018/wordml/cex" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16="http://schemas.microsoft.com/office/word/2018/wordml" xmlns:w16du="http://schemas.microsoft.com/office/word/2023/wordml/word16du" xmlns:w16sdtdh="http://schemas.microsoft.com/office/word/2020/wordml/sdtdatahash" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 w16se w16cid w16 w16cex w16sdtdh w16du wp14"><w:body><w:p w14:paraId="58300518" w14:textId="1E782A10" w:rsidR="00FD43E3" w:rsidRDefault="005B5E2B"><w:pPr><w:rPr><w:color w:val="FF0000"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="005B5E2B"><w:rPr><w:color w:val="FF0000"/><w:lang w:val="en-US"/></w:rPr><w:t>TEST</w:t></w:r></w:p><w:p w14:paraId="723143BB" w14:textId="61C406B6" w:rsidR="005B5E2B" w:rsidRDefault="005B5E2B" w:rsidP="005B5E2B"><w:pPr><w:jc w:val="center"/><w:rPr><w:color w:val="FF0000"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="005B5E2B"><w:rPr><w:color w:val="FF0000"/><w:highlight w:val="green"/><w:lang w:val="en-US"/></w:rPr><w:t>New Document text</w:t></w:r></w:p><w:p w14:paraId="1E0B9ADD" w14:textId="5D4A6C92" w:rsidR="005B5E2B" w:rsidRDefault="005B5E2B" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="005B5E2B"><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing Docs</w:t></w:r></w:p><w:p w14:paraId="59897553" w14:textId="77777777" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr></w:p><w:tbl><w:tblPr><w:tblStyle w:val="TableGrid"/><w:tblW w:w="0" w:type="auto"/><w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/></w:tblPr><w:tblGrid><w:gridCol w:w="9016"/></w:tblGrid><w:tr w:rsidR="008547A3" w14:paraId="4DE54D69" w14:textId="77777777" w:rsidTr="008547A3"><w:tc><w:tcPr><w:tcW w:w="9016" w:type="dxa"/></w:tcPr><w:tbl><w:tblPr><w:tblStyle w:val="TableGrid"/><w:tblW w:w="0" w:type="auto"/><w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/></w:tblPr><w:tblGrid><w:gridCol w:w="2197"/><w:gridCol w:w="2197"/><w:gridCol w:w="2198"/><w:gridCol w:w="2198"/></w:tblGrid><w:tr w:rsidR="008547A3" w14:paraId="79D25110" w14:textId="77777777" w:rsidTr="008547A3"><w:tc><w:tcPr><w:tcW w:w="2197" w:type="dxa"/></w:tcPr><w:p w14:paraId="4C6B8887" w14:textId="254C6AF0" w:rsidR="008547A3" w:rsidRPr="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2197" w:type="dxa"/></w:tcPr><w:p w14:paraId="546178D6" w14:textId="674CE92D" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>1</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2198" w:type="dxa"/></w:tcPr><w:p w14:paraId="3A6582C2" w14:textId="19740F33" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>2</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2198" w:type="dxa"/></w:tcPr><w:p w14:paraId="63561E39" w14:textId="54F57D0A" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>3</w:t></w:r></w:p></w:tc></w:tr><w:tr w:rsidR="008547A3" w14:paraId="68FED5AD" w14:textId="77777777" w:rsidTr="008547A3"><w:tc><w:tcPr><w:tcW w:w="2197" w:type="dxa"/></w:tcPr><w:p w14:paraId="147CC348" w14:textId="47DAF360" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>4</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2197" w:type="dxa"/></w:tcPr><w:p w14:paraId="115C6D5D" w14:textId="5D502920" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>5</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2198" w:type="dxa"/></w:tcPr><w:p w14:paraId="21DC31D9" w14:textId="1837E909" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>6</w:t></w:r></w:p></w:tc><w:tc><w:tcPr><w:tcW w:w="2198" w:type="dxa"/></w:tcPr><w:p w14:paraId="177119FE" w14:textId="278397B9" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r w:rsidRPr="008547A3"><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>Testing</w:t></w:r><w:r><w:rPr><w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="en-US"/></w:rPr><w:t>7</w:t></w:r></w:p></w:tc></w:tr></w:tbl><w:p w14:paraId="5335B172" w14:textId="77777777" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr></w:p></w:tc></w:tr></w:tbl><w:p w14:paraId="489477CA" w14:textId="77777777" w:rsidR="008547A3" w:rsidRDefault="008547A3" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr></w:p><w:p w14:paraId="655ED2B7" w14:textId="3E35F670" w:rsidR="005B5E2B" w:rsidRPr="005B5E2B" w:rsidRDefault="005B5E2B" w:rsidP="005B5E2B"><w:pPr><w:rPr><w:b/><w:bCs/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr></w:pPr><w:r><w:rPr><w:b/><w:bCs/><w:noProof/><w:sz w:val="40"/><w:szCs w:val="40"/><w:lang w:val="en-US"/></w:rPr><w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0" wp14:anchorId="373BFE6F" wp14:editId="701FECFE"><wp:extent cx="63503" cy="69854"/><wp:effectExtent l="0" t="0" r="0" b="6350"/><wp:docPr id="1004427202" name="Picture 1"/><wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1"/></wp:cNvGraphicFramePr><a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"><a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture"><pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"><pic:nvPicPr><pic:cNvPr id="1004427202" name="Picture 1004427202"/><pic:cNvPicPr/></pic:nvPicPr><pic:blipFill><a:blip r:embed="rId4"><a:extLst><a:ext uri="{28A0092B-C50C-407E-A947-70E740481C1C}"><a14:useLocalDpi xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main" val="0"/></a:ext></a:extLst></a:blip><a:stretch><a:fillRect/></a:stretch></pic:blipFill><pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="63503" cy="69854"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr></pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing></w:r></w:p><w:sectPr w:rsidR="005B5E2B" w:rsidRPr="005B5E2B"><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="708" w:footer="708" w:gutter="0"/><w:cols w:space="708"/><w:docGrid w:linePitch="360"/></w:sectPr></w:body></w:document>';
            }
    @AuraEnabled
    global static sobject getObjectData(string recordId,list<string> FieldApiNames){
        
        system.debug(FieldApiNames+'******** ' +recordId);
        string objectName = Id.valueof(recordId).getSObjectType().getDescribe().getName();
        set<string> fieldsets = new set<string>(FieldApiNames);
        //FieldApiNames.remove(null);
        string Fields = string.join(fieldsets,',');
        if(Fields == ''){
            Fields = 'Id';
        }
        
        string query = 'select '+ Fields + ' from '+ objectName + ' where Id=:recordId';
        sobject sObjectRecord = database.query(query);
        
        return sObjectRecord;
    }
    
    
    
    
    @AuraEnabled
    global static list<childClass> getChildObjectData(string recordId,list<string> FieldApiNames){
        system.debug(FieldApiNames+'******** ' +recordId);
        set<string> childobjectNames = new set<string>();
        set<string> fieldsets = new set<string>(); 
        string objectName = Id.valueof(recordId).getSObjectType().getDescribe().getName();
        for(string str : FieldApiNames){
            system.debug(str+'******** ' +str.replace('.','@@@').split('@@@'));
            string[] strList = str.replace('.','@@@').split('@@@');
            childobjectNames.add(strList[0].replace('!',''));
            fieldsets.add(str.replace(strList[0]+'.',''));
        }
        //FieldApiNames.remove(null);
        string Fields = string.join(fieldsets,',');
        list<childClass> childClassList = new list<childClass>();
        for(string obj : childobjectNames){
            childClass chChild = new childClass();
            chChild.objectName = obj;
            if(Fields == ''){
                Fields = 'Id';
            }
            string query = 'select '+ Fields + ' from '+ obj + ' where quoteId=:recordId';
            list<sobject> sObjectRecords = database.query(query); 
            chChild.sObjectRecords = sObjectRecords;
            childClassList.add(chChild);
        }
        
        return childClassList;
    }
    
    
    @RemoteAction
    global static parentClass getObjectDatas(String recordId, List<String> FieldApiNames) {
        parentClass ParentRecord = new parentClass();
        
        try {
            System.debug(FieldApiNames + ' ******** ' + recordId);
            
            String objectName = Id.valueOf(recordId).getSObjectType().getDescribe().getName();
            Set<String> fieldsets = new Set<String>(FieldApiNames);
            Map<String, String> FieldMap = new Map<String, String>();
            
            String Fields = String.join(fieldsets, ',');
            if (Fields == '') {
                Fields = 'Id';
            }
            
            // Build and run the dynamic query safely
            String query = 'SELECT ' + Fields + ' FROM ' + objectName + ' WHERE Id = :recordId';
            SObject sObjectRecord = Database.query(query);
            
            // Determine field types
            for(string c : fieldsets){
                string Stringobjct = c.replace('.',',');
                string[] Stringobjcts = Stringobjct.split(',');
                string Types = 'String';
                if(Stringobjcts.size() > 3){
                    string firstchild = getchilType(objectName,Stringobjcts[0]);
                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                    Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                }
                else if(Stringobjcts.size() > 2){
                    string secchild = getchilType(objectName,Stringobjcts[0]);
                    Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);  
                }
                else if(Stringobjcts.size() > 1){
                    Types = getRelType(objectName,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                }
                else if(Stringobjcts.size() > 0){
                    SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    system.debug(c + '*********' + d);
                    if(c != null && c != '' && d.fields.getMap().containsKey(c) && d.fields.getMap().get(c).getDescribe() != null)
                        Types = ''+(d.fields.getMap().get(c).getDescribe().getType());
                }
                
                FieldMap.put(c, Types);
            }
            
            ParentRecord.sObjectRecord = sObjectRecord;
            ParentRecord.fieldMap = FieldMap;
            return ParentRecord;
            
        } catch (Exception ex) {
            // Send error details back
            parentClass errorResult = new parentClass();
            errorResult.errorMessage = 'Error fetching data: ' + ex.getMessage();
            return errorResult;
        }
    }
    
    @RemoteAction
    global static List<globalMap> getGlobalValues(List<String> globalList) {
        Set<String> userFields = new Set<String>();
        Set<String> orgFields = new Set<String>();
        List<globalMap> globalMapList = new List<globalMap>();
        
        // 1. Identify the fields dynamically
        for (String str : globalList) {
            if (str.startsWith('$User.')) {
                userFields.add(str.replace('$User.', ''));
            } else if (str.startsWith('$Organization.')) {
                orgFields.add(str.replace('$Organization.', ''));
            }
        }
        string userId = UserInfo.getUserId(); 
        // 2. Build dynamic SOQL queries
        String userQuery = 'SELECT Id' + (userFields.isEmpty() ? '' : ', ' + String.join(userFields, ',')) +
            ' FROM User WHERE Id = :userId';
        String orgQuery = 'SELECT Id' + (orgFields.isEmpty() ? '' : ', ' + String.join(orgFields, ',')) +
            ' FROM Organization LIMIT 1';
        
        User currentUser = Database.query(userQuery);
        Organization orgInfo = Database.query(orgQuery);
        
        // 3. Add function-based globals like Today(), Now(), etc.
        for (String str : globalList) {
            globalMap glob = new globalMap();
            glob.label = str;
            
            if (str.equalsIgnoreCase('Today()')) {
                glob.value = String.valueOf(System.today());
                glob.type = 'Date';
            }
            else if (str.equalsIgnoreCase('Now()')) {
                glob.value = String.valueOf(System.now());
                glob.type = 'Datetime';
            }
            else if (str.equalsIgnoreCase('Yesterday()')) {
                glob.value = String.valueOf(System.today().addDays(-1));
                glob.type = 'Date';
            }
            else if (str.equalsIgnoreCase('Tomorrow()')) {
                glob.value = String.valueOf(System.today().addDays(1));
                glob.type = 'Date';
            }
            else if (str.startsWith('$User.')) {
                String field = str.replace('$User.', '');
                if (userFields.contains(field)) {
                    glob.value = String.valueOf(currentUser.get(field));
                    glob.type = 'String';
                } else {
                    glob.value = '';
                    glob.type = 'String';
                }
            }
            else if (str.startsWith('$Organization.')) {
                String field = str.replace('$Organization.', '');
                if (orgFields.contains(field)) {
                    glob.value = String.valueOf(orgInfo.get(field));
                    glob.type = 'String';
                } else {
                    glob.value = '';
                    glob.type = 'String';
                }
            } else {
                glob.value = '';
                glob.type = 'String';
            }
            
            globalMapList.add(glob);
        }
        
        return globalMapList;
    }
    
    
    global class globalMap{
        global string label{get;set;}
        global string value{get;set;}
        global string type{get;set;}
    }
    
    
    @RemoteAction
    global static list<childClass> getChildObjectDatas(string recordId,list<string> FieldApiNames){
        system.debug(FieldApiNames+'******** ' +recordId);
        list<childClass> childClassList = new list<childClass>();
        try {
            set<string> childobjectNames = new set<string>();
            set<string> fieldsets = new set<string>(); 
            Map<string,set<string>> objectMap = new Map<string,set<string>>();
            string objectName = Id.valueof(recordId).getSObjectType().getDescribe().getName();
            for(string str : FieldApiNames){
                
                system.debug(str+'******** ' +str.replace('.','@@@').split('@@@'));
                string[] strList = str.replace('.','@@@').split('@@@');
                childobjectNames.add(strList[0].replace('!',''));
                if(objectMap.get(strList[0].replace('!','')+'.'+strList[1]) == null){
                    objectMap.put(strList[0].replace('!','')+'.'+strList[1],new set<string>());
                }
                objectMap.get(strList[0].replace('!','')+'.'+strList[1]).add(str.replace(strList[0]+'.'+strList[1]+'.',''));
                fieldsets.add(str.replace(strList[0]+'.','')); 
            }
            //FieldApiNames.remove(null);
            
            
            for(string obj : objectMap.keyset()){
                string Fields = string.join(objectMap.get(obj),',');
                string[] childObjNames =  obj.replace('.','@@@').split('@@@');
                string childObj = childObjNames[0].replace('[','@@@').split('@@@')[0];
                childClass chChild = new childClass();
                chChild.objectName = obj;
                if(Fields == ''){
                    Fields = 'Id';
                }
                string query = 'select '+ Fields + ' from '+ childObjNames[1] + ' where '+childObj+'=:recordId';
                list<sobject> sObjectRecords = database.query(query); 
                Map<string,string> FieldMap = new Map<string,string>();
                for(string c : objectMap.get(obj)){
                    string Stringobjct = c.replace('.',',');
                    string[] Stringobjcts = Stringobjct.split(',');
                    string Types = 'String';
                    if(Stringobjcts.size() > 3){
                        string firstchild = getchilType(childObjNames[1],Stringobjcts[0]);
                        string secchild = getchilType(firstchild,Stringobjcts[1]);
                        Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                    }
                    else if(Stringobjcts.size() > 2){
                        string secchild = getchilType(childObjNames[1],Stringobjcts[0]);
                        Types = getRelType(secchild,Stringobjcts[1],Stringobjcts[2]);  
                    }
                    else if(Stringobjcts.size() > 1){
                        Types = getRelType(childObjNames[1],Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                    }
                    else if(Stringobjcts.size() > 0){
                        SObjectType r = ((SObject)(Type.forName('Schema.'+childObjNames[1]).newInstance())).getSObjectType();
                        DescribeSObjectResult d = r.getDescribe();
                        system.debug('objectName *** ' + c);
                        if(c != null && c != '')
                            Types = ''+(d.fields.getMap().get(c.trim()).getDescribe().getType());
                    }
                    FieldMap.put(c.trim(), Types);
                }
                
                chChild.sObjectRecords = sObjectRecords;
                chChild.fieldMap = FieldMap;
                childClassList.add(chChild);
                
            }
            return childClassList;
        } catch (Exception ex) {
            // Send error details back
            childClass errorResult = new childClass();
            errorResult.errorMessage = 'Error fetching data: ' + ex.getMessage();
            childClassList = new list<childClass>();
            childClassList.add(errorResult);
            return childClassList;
        }
        
    }
    
    global class childClass{
        @AuraEnabled public string objectName{get;set;}
        @AuraEnabled public list<sobject> sObjectRecords{get;set;}
        @AuraEnabled public Map<string,string> fieldMap{get;set;}
        @AuraEnabled public String errorMessage{get;set;}
    }
    
    global class parentClass{
        @AuraEnabled public Map<string,string> fieldMap{get;set;}
        @AuraEnabled public sobject sObjectRecord{get;set;}
        @AuraEnabled public String errorMessage{get;set;}
    }
    
    global static String getRelType(string ObjectName,String FieldName,String parfieldName){
        system.debug(ObjectName + '***** '+ FieldName);
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
        string Types = '';
        if(fieldMap.get(parfieldName) != null)
            Types = ''+ fieldMap.get(parfieldName).getDescribe().getType();
        system.debug('Types ' + Types);
        return Types;
        
    }
    global static String getchilType(string ObjectName,String FieldName){
        system.debug(ObjectName + '***** '+ FieldName);
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
}
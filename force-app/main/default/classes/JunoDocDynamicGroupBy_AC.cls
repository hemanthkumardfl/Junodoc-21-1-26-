public class JunoDocDynamicGroupBy_AC {
    public static string GetDataDynamically(string ObjName,string GroupField,string FieldsOnTable,
                                            string parentObject,string parentId,string Filter,string order,
                                            string FieldslableOnTable,string color1,string color2,string HeaderStyle, 
                                            string Headerbackground,string tablewidth, Map<string,string> ChildobjectsMap,
                                            Doc_Template_Child__c DocChild,String DateFormats,string sfdcURL,
                                            document checkdocument,document uncheckdocument,string CurrencyFormat,string currencySymbol,boolean isRollup,string SobjectApiName) {
                                                string TempTypes = 'div';
                                                if(DocChild.JunoDoc__Doc_Template__r.JunoDoc__Template_Type__c != 'Word Document'){
                                                    TempTypes = 'table';  
                                                }
                                                DocChild.Child_object__c = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                string quoteNewId = parentId;
                                                if(DocChild.Junodoc__Child_object__c.contains(':')){
                                                    string ChildObjField = DocChild.Junodoc__Child_object__c.split(':')[1];
                                                    parentObject = DocChild.Junodoc__Child_object__c.split(':')[2];
                                                    string quoteObjString = 'select ' + DocChild.Junodoc__Child_object__c.split(':')[0] + ' From ' + SobjectApiName + ' WHERE Id =: quoteNewId';
                                                    Sobject quoteObj = Database.query(quoteObjString);
                                                    quoteNewId = ''+quoteObj.get(DocChild.Junodoc__Child_object__c.split(':')[0]);
                                                    DocChild.Child_object__c = ChildObjField;
                                                    
                                                }
                                                List<sobject> objList = new List<sobject>();
                                                Map<string,List<sobject>> MapVsValues = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> MapVsValues1 = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> grpMapVsValues = new Map<string,List<sobject>>();
                                                list<string> Fieldsontablelist = new list<string>();
                                                Fieldsontablelist = FieldsOnTable.split(',');
                                                if(!FieldsOnTable.contains(GroupField)){
                                                    FieldsOnTable += ','+GroupField;
                                                }
                                                
                                                string Query = 'select '+FieldsOnTable+' from '+ObjName + ' where '+ parentObject + ' =: quoteNewId';
                                                if(Filter != '' && Filter != null){
                                                    Query += ' and ' + Filter;
                                                }
                                                if(order != '' && order != null){
                                                    Query += ' order by ' + Order + ' NULLS LAST';
                                                }
                                                else{
                                                    Query += ' order by ' + GroupField + ' NULLS LAST';
                                                }
                                                objList = Database.query(Query);
                                                List<PicklistOptions> fieldList = new List<PicklistOptions>();
                                                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                                                Schema.SObjectType sobjType = gd.get(ObjName); 
                                                Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
                                                Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 
                                                String groupFieldLabelName;
                                                Schema.DisplayType groupFieldDataType;
                                                
                                                String groupFieldLabelName1;
                                                Schema.DisplayType groupFieldDataType1;
                                                for(string str: fieldsMap.keySet()){
                                                    if(FieldsOnTable.toLowerCase().contains(fieldsMap.get(str).getDescribe().getName().toLowerCase())){
                                                        PicklistOptions fieldsDataRec = new PicklistOptions(fieldsMap.get(str).getDescribe().getLabel(),fieldsMap.get(str).getDescribe().getName(),'');
                                                        fieldsDataRec.Label = fieldsMap.get(str).getDescribe().getLabel();
                                                        fieldsDataRec.Value = fieldsMap.get(str).getDescribe().getName();
                                                        if(fieldsDataRec.Value == GroupField){
                                                            groupFieldLabelName = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                        if(GroupField == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        
                                                        
                                                        fieldList.add(fieldsDataRec);
                                                    }
                                                }
                                                
                                                    for(sobject Obj:objList){
                                                        if(MapVsValues.get(''+Obj.get(GroupField)) == null){
                                                            MapVsValues.put(''+Obj.get(GroupField),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues.get(''+Obj.get(GroupField)).add(Obj);
                                                        }
                                                    }
                                                String Table = '';
                                                
                                                string veralign = 'top';                                               
                                                string curralign = 'right';
                                                string stringaling = 'left';
                                                Map<integer,string> curralignmap = new Map<integer,string>();
                                                Map<integer,string> stralignmap = new Map<integer,string>();
                                                Map<integer,string> veralignmap = new Map<integer,string>();
                                                
                                                    if(!Fieldsontablelist.isEmpty()){
                                                        integer m = 1;
                                                        for(string lables : FieldslableOnTable.split(',')){
                                                            if(lables.contains('[[')){
                                                                string[] childlabellist = (lables).replace('[[','ssss').split('ssss');
                                                                for(string childs : childlabellist){
                                                                    if(!childs.tolowercase().contains('top') || !childs.tolowercase().contains('bottom')){
                                                                        string curralignInn = childs.replace(']]','ssss').split('ssss')[0];  
                                                                        string stringalingInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        curralignInn = curralignInn.replace('s','');
                                                                        stringalingInn = stringalingInn.replace('s','');
                                                                        curralignmap.put(m,curralignInn);
                                                                        stralignmap.put(m,stringalingInn);
                                                                    }
                                                                    else{
                                                                        string veralignInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        veralignInn = veralignInn.replace('s','');
                                                                        veralignmap.put(m,veralignInn);
                                                                    }  
                                                                }
                                                            }
                                                            m = m+1;
                                                            
                                                        }
                                                    } 
                                                
                                                if(!isRollup){
                                                    for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                    
                                                    
                                                   
                                                   

                                                    Table += '<div class="" style="margin-top:5px;">';
                                                    Table += '<'+TempTypes+' style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table   += '<tr><td class="page-break" style="white-space: normal;text-align:left;margin-top:10px;color:black;font-family:'+DocChild.font_Color__c+';font-size:12px;padding-top:8px">';
                                                    if(str != 'null' && str != null && str != ''){
                                                        Table += '<b>'+str+'</b>';
                                                    }
                                                    else if(str == 'null' || str != null || str != '' ){
                                                        Table += '<b>None</b>';
                                                    }
                                                    Table += '</td></tr><tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                   
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !='' && tablewidth != 'auto'){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/FieldslableOnTablelist.size());
                                                    }
                                                    //for(string lables : FieldslableOnTablelist){
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>';
                                                    decimal Total = 0; 
                                                    string addcolor = color1;
                                                    for(sobject sb : MapVsValues.get(str)){
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        if(i == z ){
                                                            addcolor = color2;
                                                        }
                                                        if(Docchild.JunoDoc__Group_By_Calculation__c != null && Docchild.JunoDoc__Group_By_Calculation__c != ''){
                                                            if(sb.get(Docchild.JunoDoc__Group_By_Calculation__c) != null)
                                                            Total += (decimal)sb.get(Docchild.JunoDoc__Group_By_Calculation__c);
                                                        }
                                                        Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                        integer crows = 1;
                                                        for(string lables : Fieldsontablelist){
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                }
                                                                                else if(Types == 'DATE'){
                                                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                    Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                }
                                                                                else if(Types == 'DATETIME'){
                                                                                    Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
                                                                                }
                                                                                else if(Types == 'BOOLEAN'){
                                                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                    if(textbool == true){
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                    else{
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                }
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 2){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                                else if(Types == 'DATE'){
                                                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                    Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                }
                                                                                else if(Types == 'DATETIME'){
                                                                                    Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
                                                                                }
                                                                                else if(Types == 'BOOLEAN'){
                                                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                    if(textbool == true){
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                    else{
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                }
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                            else if(Types == 'DATE'){
                                                                                Date Datestr = Date.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                            }
                                                                            else if(Types == 'DATETIME'){
                                                                                Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
                                                                            }
                                                                            else if(Types == 'BOOLEAN'){
                                                                                boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                if(textbool == true){
                                                                                    Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                }
                                                                                else{
                                                                                    Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                }
                                                                            }
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }      
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
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
                                                            crows = crows + 1;
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+Childstring,CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  Childstring+ '</td>';
                                                                    }
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DATE'){  
                                                                if(Childstring != null && Childstring != '' && Childstring != 'null'){
                                                                    Date Datestr = Date.valueof(Childstring);
                                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DATETIME'){
                                                                if(Childstring != null && Childstring != 'null' && Childstring != ''){
                                                                    Childstring = Datetime.valueof(Childstring).format(DateFormats + ' HH:mm a');
                                                                }
                                                                
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                            else{
                                                                if(Childstring == null || Childstring == 'null'){
                                                                    Childstring = ''; 
                                                                }
                                                                Childstring = Childstring.replaceAll('[\u0000-\u001F]', '');
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    }
                                                    if(addcolor == color1){
                                                        addcolor = color2;
                                                    }
                                                    else{
                                                        addcolor = color1;
                                                    }
                                                    if(Docchild.JunoDoc__Group_By_Calculation__c != null && Docchild.JunoDoc__Group_By_Calculation__c != ''){
                                                        Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                        for(integer k= 0;k< (Fieldsontablelist.size()-2);k++){
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+'"></td>';
                                                        }
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">Total</td>';
                                                        string Types = ChildobjectsMap.get(Docchild.JunoDoc__Group_By_Calculation__c.toLowercase()+DocChild.Child_object__c.toLowercase());
                                                        
                                                        if(Types == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+total,CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">'+currencysymbol+currencyvalue+'</td>';
                                                        }
                                                        else{
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">'+total+'</td>';    
                                                        }
                                                        Table += '</tr>';
                                                    }
                                                    Table += '</'+TempTypes+'>';
                                                        Table += '</div>';
                                                }
                                                }
                                                else{
                                                    decimal totalgroup = 0;
                                                    Table += '<div style="margin-top:5px;">';
                                                    Table += '<'+TempTypes+' style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table += '<tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                  
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !=''){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/(FieldslableOnTablelist.size()+1));
                                                    }
                                                   
                                                    //for(string lables : FieldslableOnTablelist){
                                                   
                                                    string[] splits = HeaderStyle.split('</td>'); 
                                                    string[] tdsplit = splits[0].replace('>','@@@@@').split('@@@@@');
                                                    Table += tdsplit[0] +'>'+groupFieldLabelName +'</td>';
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>'; 
                                                  
                                                       Map<string,string> Totallables = new Map<string,string>();
                                                    string addcolor = '';
                                                for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                 if(MapVsValues.get(str) != null){
                                                    Map<string,string> decimalmap = new Map<string,string>();
                                                            
                                                    for(sobject sb : MapVsValues.get(str)){
                                                        
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        
                                                        if(i == z ){
                                                           
                                                            addcolor = color2;
                                                        }
                                                        
                                                        integer crows = 1;
                                                        for(string lables : Fieldsontablelist){
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
                                                            crows = crows + 1;
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                    string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                   
                                                                                    if(Types == 'CURRENCY'){
                                                                                        Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                    }
                                                                                    
                                                                                    else{ 
                                                                                        Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
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
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                               
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                           
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }  
                                                                
                                                                
                                                                
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
                                                            if(Childstring != ''){
                                                                if(decimalmap.get(lables) == null){
                                                                    decimalmap.put(lables,Childstring);
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(decimalmap.get(lables));
                                                                    decimalmap.put(lables,''+(decval + decimal.valueof(Childstring)));
                                                                }
                                                            }
                                                            else{
                                                                decimalmap.put(lables,'0');
                                                            }
                                                        }    
                                                    }
                                                     Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     if(str == null || Str == '' || Str == 'null'){
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">None</td>';    
                                                     }
                                                     else{
                                                         Str = str.replaceAll('[\u0000-\u001F]', '');
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">'+Str+'</td>';
                                                     }      
                                                     integer l = 1;
                                                      for(string lables : decimalmap.keyset()){ 
                                                            if(curralignmap.get(l) != null){
                                                                curralign = curralignmap.get(l);
                                                            }
                                                            else{
                                                                curralign = 'right';
                                                            }
                                                            if(veralignmap.get(l) != null){
                                                                veralign = veralignmap.get(l);
                                                            }
                                                            else{
                                                                veralign = 'top';
                                                            }
                                                            if(stralignmap.get(l) != null){
                                                                stringaling = stralignmap.get(l);
                                                            }
                                                            else{
                                                                stringaling = 'left';
                                                            }
                                                            l = l+1;
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+decimalmap.get(lables),CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables)+ '</td>';
                                                            }
                                                            else{
                                                                if(decimalmap.get(lables) == null || decimalmap.get(lables) == 'null'){
                                                                    decimalmap.put(lables,'0'); 
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables) + '</td>';
                                                            }
                                                                
                                                                if(Totallables.get(lables) == null){
                                                                    Totallables.put(lables,decimalmap.get(lables));
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(Totallables.get(lables));
                                                                    Totallables.put(lables,''+(decval + decimal.valueof(decimalmap.get(lables))));
                                                                }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    
                                                    }    
                                                }
                                                Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     Table += '<td style="padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:left;border:'+DocChild.border__c+';font-weight:bold">Total</td>';
                                                     for(string lables : Totallables.keyset()){ 
                                                        if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+Totallables.get(lables),CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+ currencySymbol +currencyvalue + '</td>';
                                                        }
                                                        
                                                        else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                    Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables)+ '</td>';
                                                        }
                                                        else{
                                                            if(Totallables.get(lables) == null || Totallables.get(lables) == 'null'){
                                                                Totallables.put(lables,'0'); 
                                                            }
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables) + '</td>';
                                                        }         
                                                            
                                                    }
                                                    Table += '</tr>';
                                                    Table += '</'+TempTypes+'>';
                                                    Table += '</div>';
                                           }       
                                                return table;
                                            }
    
   public static string ChildGetDataDynamically(string ObjName,string GroupField,string FieldsOnTable,
                                            string parentObject,string parentId,string Filter,string order,
                                            string FieldslableOnTable,string color1,string color2,string HeaderStyle,
                                            string Headerbackground,string tablewidth, Map<string,string> ChildobjectsMap,
                                            Doc_Template_Child__c DocChild,String DateFormats,string sfdcURL,
                                            document checkdocument,document uncheckdocument,string CurrencyFormat,string currencySymbol,string GroupField1,string SobjectApiName) {
                                                 string TempTypes =  'div';
                                                if(DocChild.JunoDoc__Doc_Template__r.JunoDoc__Template_Type__c != 'Word Document'){
                                                    TempTypes = 'table';  
                                                }
                                                 DocChild.Child_object__c = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                string quoteNewId = parentId;
                                                if(DocChild.Junodoc__Child_object__c.contains(':')){
                                                    string ChildObjField = DocChild.Junodoc__Child_object__c.split(':')[1];
                                                    parentObject = DocChild.Junodoc__Child_object__c.split(':')[2];
                                                    string quoteObjString = 'select ' + DocChild.Junodoc__Child_object__c.split(':')[0] + ' From ' + SobjectApiName + ' WHERE Id =: quoteNewId';
                                                    Sobject quoteObj = Database.query(quoteObjString);
                                                    quoteNewId = ''+quoteObj.get(DocChild.Junodoc__Child_object__c.split(':')[0]);
                                                    DocChild.Child_object__c = ChildObjField;
                                                    
                                                }
                                                 //GroupField1 = 'Quantity';
                                                List<sobject> objList = new List<sobject>();
                                                Map<string,List<sobject>> MapVsValues = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> MapVsValues1 = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> grpMapVsValues = new Map<string,List<sobject>>();
                                                list<string> Fieldsontablelist = new list<string>();
                                                Fieldsontablelist = FieldsOnTable.split(',');
                                                if(!FieldsOnTable.contains(GroupField)){
                                                    FieldsOnTable += ','+GroupField;
                                                }
                                                if(GroupField1 != null){
                                                    if(!FieldsOnTable.toLowerCase().contains(GroupField1.toLowerCase())){
                                                        FieldsOnTable += ','+GroupField1;
                                                    }
                                                }
                                                string Query = 'select '+FieldsOnTable+' from '+ObjName + ' where '+ parentObject + ' =: quoteNewId';
                                                if(Filter != '' && Filter != null){
                                                    Query += ' and ' + Filter;
                                                }
                                                if(order != '' && order != null){
                                                    Query += ' order by ' + Order + ' NULLS LAST';
                                                }
                                                else{
                                                    Query += ' order by ' + GroupField + ' NULLS LAST';
                                                }
                                                objList = Database.query(Query);
                                                List<PicklistOptions> fieldList = new List<PicklistOptions>();
                                                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                                                Schema.SObjectType sobjType = gd.get(ObjName); 
                                                Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
                                                Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 
                                                String groupFieldLabelName;
                                                Schema.DisplayType groupFieldDataType;
                                                
                                                String groupFieldLabelName1;
                                                Schema.DisplayType groupFieldDataType1;

                                                for(string str: fieldsMap.keySet()){
                                                    
                                                    if(FieldsOnTable.toLowerCase().contains(fieldsMap.get(str).getDescribe().getName().toLowerCase())){
                                                        PicklistOptions fieldsDataRec = new PicklistOptions(fieldsMap.get(str).getDescribe().getLabel(),fieldsMap.get(str).getDescribe().getName(),'');
                                                        fieldsDataRec.Label = fieldsMap.get(str).getDescribe().getLabel();
                                                        fieldsDataRec.Value = fieldsMap.get(str).getDescribe().getName();
                                                        if(fieldsDataRec.Value == GroupField){
                                                            groupFieldLabelName = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                       
                                                        if(GroupField == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        
                                                        if(fieldsDataRec.Value == GroupField1){
                                                            groupFieldLabelName1 = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                       
                                                        if(GroupField1 == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType1 = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        fieldList.add(fieldsDataRec);
                                                    }
                                                }
                                                
                                                    for(sobject Obj:objList){
                                                        if(MapVsValues1.get(''+Obj.get(GroupField1)) == null){
                                                            MapVsValues1.put(''+Obj.get(GroupField1),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues1.get(''+Obj.get(GroupField1)).add(Obj);
                                                        }
                                                        
                                                        if(MapVsValues.get(''+Obj.get(GroupField)) == null){
                                                            MapVsValues.put(''+Obj.get(GroupField),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues.get(''+Obj.get(GroupField)).add(Obj);
                                                        }
                                                        
                                                        if(grpMapVsValues.get((''+Obj.get(GroupField))+(''+Obj.get(GroupField1))) == null){
                                                            grpMapVsValues.put((''+Obj.get(GroupField))+(''+Obj.get(GroupField1)),new List<sobject>{Obj});
                                                        }else{
                                                            grpMapVsValues.get((''+Obj.get(GroupField))+(''+Obj.get(GroupField1))).add(Obj);
                                                        }    
                                                    }
                                                String Table = '';
                                                string veralign = 'top';                                               
                                                string curralign = 'right';
                                                string stringaling = 'left';
                                                Map<string,string> curralignmap = new Map<string,string>();
                                                Map<string,string> stralignmap = new Map<string,string>();
                                                Map<string,string> veralignmap = new Map<string,string>();
                                                
                                                    if(!Fieldsontablelist.isEmpty()){
                                                        for(string lables : Fieldsontablelist){
                                                            if(lables.contains('[[')){
                                                                string[] childlabellist = (lables).replace('[[','ssss').split('ssss');
                                                                for(string childs : childlabellist){
                                                                    if(!childs.tolowercase().contains('top') || !childs.tolowercase().contains('bottom')){
                                                                        string curralignInn = childs.replace(']]','ssss').split('ssss')[0];  
                                                                        string stringalingInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        curralignInn = curralignInn.replace('s','');
                                                                        stringalingInn = stringalingInn.replace('s','');
                                                                        curralignmap.put(lables,curralignInn);
                                                                        stralignmap.put(lables,stringalingInn);
                                                                    }
                                                                    else{
                                                                        string veralignInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        veralignInn = veralignInn.replace('s','');
                                                                        veralignmap.put(lables,veralignInn);
                                                                    }  
                                                                }
                                                            }
                                                        }
                                                    } 
                                                
                                                
                                                for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                    
                                                    
                                                    
                                                    decimal totalgroup = 0;
                                                    Table += '<div style="margin-top:5px;page-break-before:auto;">';
                                                    Table += '<'+TempTypes+' style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table   += '<tr><td class="" style="white-space: normal;text-align:left;margin-top:10px;color:black;font-family:'+DocChild.font_Color__c+';font-size:12px;padding-top: 8px;">';
                                                    if(str != 'null' && str != null && str != ''){
                                                        Table += '<b>'+str+'</b>';
                                                    }
                                                    else if(str == 'null' || str != null || str != '' ){
                                                        Table += '<b>None</b>';
                                                    }
                                                    Table += '</td></tr>';
                                                    Table += '<tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                  
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !=''){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/(FieldslableOnTablelist.size()+1));
                                                    }
                                                   
                                                    //for(string lables : FieldslableOnTablelist){
                                                   
                                                    string[] splits = HeaderStyle.split('</td>'); 
                                                    string[] tdsplit = splits[0].replace('>','@@@@@').split('@@@@@');
                                                    Table += tdsplit[0] +'>'+groupFieldLabelName1 +'</td>';
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>';
                                                    Map<string,string> Totallables = new Map<string,string>();
                                                    string addcolor = '';
                                                    for(string str1 : MapVsValues1.keyset()){
                                                        if(grpMapVsValues.get(str + str1) != null){
                                                                                                                
                                                    
                                                    
                                                    
                                                    Map<string,string> decimalmap = new Map<string,string>();
                                                            
                                                    for(sobject sb : grpMapVsValues.get(str + str1)){
                                                        
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        
                                                        if(i == z ){
                                                           
                                                            addcolor = color2;
                                                        }
                                                       
                                                        
                                                        for(string lables : Fieldsontablelist){
                                                            if(curralignmap.get(lables) != null){
                                                                curralign = curralignmap.get(lables);
                                                            }
                                                            if(veralignmap.get(lables) != null){
                                                                veralign = veralignmap.get(lables);
                                                            }
                                                            if(stralignmap.get(lables) != null){
                                                                stringaling = stralignmap.get(lables);
                                                            }
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                    string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                   
                                                                                    if(Types == 'CURRENCY'){
                                                                                        Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                    }
                                                                                    
                                                                                    else{ 
                                                                                        Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
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
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                               
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                           
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }  
                                                                
                                                                
                                                                
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
                                                            if(Childstring != ''){
                                                                if(decimalmap.get(lables) == null){
                                                                    decimalmap.put(lables,Childstring);
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(decimalmap.get(lables));
                                                                    decimalmap.put(lables,''+(decval + decimal.valueof(Childstring)));
                                                                }
                                                            }
                                                            else{
                                                                decimalmap.put(lables,'0');
                                                            }
                                                        }    
                                                    }
                                                            Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">'+Str1+'</td>';
                                                            
                                                            for(string lables : decimalmap.keyset()){ 
                                                                 if(curralignmap.get(lables) != null){
                                                                curralign = curralignmap.get(lables);
                                                            }
                                                            if(veralignmap.get(lables) != null){
                                                                veralign = veralignmap.get(lables);
                                                            }
                                                            if(stralignmap.get(lables) != null){
                                                                stringaling = stralignmap.get(lables);
                                                            }
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+decimalmap.get(lables),CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables)+ '</td>';
                                                            }
                                                            else{
                                                                if(decimalmap.get(lables) == null || decimalmap.get(lables) == 'null'){
                                                                    decimalmap.put(lables,'0'); 
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables) + '</td>';
                                                            }
                                                                
                                                                if(Totallables.get(lables) == null){
                                                                    Totallables.put(lables,decimalmap.get(lables));
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(Totallables.get(lables));
                                                                    Totallables.put(lables,''+(decval + decimal.valueof(decimalmap.get(lables))));
                                                                }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    
                                                    }
                                                    }
                                                     Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:left;border:'+DocChild.border__c+';font-weight:bold">Total</td>';
                                                     for(string lables : Totallables.keyset()){ 
                                                        if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+Totallables.get(lables),CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+ currencySymbol +currencyvalue + '</td>';
                                                        }
                                                        
                                                        else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                    Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables)+ '</td>';
                                                        }
                                                        else{
                                                            if(Totallables.get(lables) == null || Totallables.get(lables) == 'null'){
                                                                Totallables.put(lables,'0'); 
                                                            }
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables) + '</td>';
                                                        }
                                                            
                                                            
                                                    }
                                                    Table += '</tr>';
                                                    Table += '</'+TempTypes+'>';
                                                    Table += '</div>';
                                                }   
                                              //  table = '<div><tr><td>Testing</td><td>Group</td></tr></div>';
                                                return table;
                                            }
    
    
     public static string GetEmailDataDynamically(string ObjName,string GroupField,string FieldsOnTable,
                                            string parentObject,string parentId,string Filter,string order,
                                            string FieldslableOnTable,string color1,string color2,string HeaderStyle, 
                                            string Headerbackground,string tablewidth, Map<string,string> ChildobjectsMap,
                                            JunoDoc__Email_Template_Child__c DocChild,String DateFormats,string sfdcURL,
                                            document checkdocument,document uncheckdocument,string CurrencyFormat,string currencySymbol,boolean isRollup) {
                                                 DocChild.Child_object__c = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                 
                                                List<sobject> objList = new List<sobject>();
                                                Map<string,List<sobject>> MapVsValues = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> MapVsValues1 = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> grpMapVsValues = new Map<string,List<sobject>>();
                                                list<string> Fieldsontablelist = new list<string>();
                                                Fieldsontablelist = FieldsOnTable.split(',');
                                                if(!FieldsOnTable.contains(GroupField)){
                                                    FieldsOnTable += ','+GroupField;
                                                }
                                                
                                                string Query = 'select '+FieldsOnTable+' from '+ObjName + ' where '+ parentObject + ' =: parentId';
                                                if(Filter != '' && Filter != null){
                                                    Query += ' and ' + Filter;
                                                }
                                                if(order != '' && order != null){
                                                    Query += ' order by ' + Order + ' NULLS LAST';
                                                }
                                                else{
                                                    Query += ' order by ' + GroupField + ' NULLS LAST';
                                                }
                                                objList = Database.query(Query);
                                                List<PicklistOptions> fieldList = new List<PicklistOptions>();
                                                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                                                Schema.SObjectType sobjType = gd.get(ObjName); 
                                                Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
                                                Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 
                                                String groupFieldLabelName;
                                                Schema.DisplayType groupFieldDataType;
                                                
                                                String groupFieldLabelName1;
                                                Schema.DisplayType groupFieldDataType1;
                                                for(string str: fieldsMap.keySet()){
                                                    if(FieldsOnTable.toLowerCase().contains(fieldsMap.get(str).getDescribe().getName().toLowerCase())){
                                                        PicklistOptions fieldsDataRec = new PicklistOptions(fieldsMap.get(str).getDescribe().getLabel(),fieldsMap.get(str).getDescribe().getName(),'');
                                                        fieldsDataRec.Label = fieldsMap.get(str).getDescribe().getLabel();
                                                        fieldsDataRec.Value = fieldsMap.get(str).getDescribe().getName();
                                                        if(fieldsDataRec.Value == GroupField){
                                                            groupFieldLabelName = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                        if(GroupField == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        
                                                        
                                                        fieldList.add(fieldsDataRec);
                                                    }
                                                }
                                                
                                                    for(sobject Obj:objList){
                                                        if(MapVsValues.get(''+Obj.get(GroupField)) == null){
                                                            MapVsValues.put(''+Obj.get(GroupField),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues.get(''+Obj.get(GroupField)).add(Obj);
                                                        }
                                                    }
                                                String Table = '';
                                                
                                                string veralign = 'top';                                               
                                                string curralign = 'right';
                                                string stringaling = 'left';
                                                Map<integer,string> curralignmap = new Map<integer,string>();
                                                Map<integer,string> stralignmap = new Map<integer,string>();
                                                Map<integer,string> veralignmap = new Map<integer,string>();
                                                
                                                    if(!Fieldsontablelist.isEmpty()){
                                                        integer m = 1;
                                                        for(string lables : FieldslableOnTable.split(',')){
                                                            if(lables.contains('[[')){
                                                                string[] childlabellist = (lables).replace('[[','ssss').split('ssss');
                                                                for(string childs : childlabellist){
                                                                    if(!childs.tolowercase().contains('top') || !childs.tolowercase().contains('bottom')){
                                                                        string curralignInn = childs.replace(']]','ssss').split('ssss')[0];  
                                                                        string stringalingInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        curralignInn = curralignInn.replace('s','');
                                                                        stringalingInn = stringalingInn.replace('s','');
                                                                        curralignmap.put(m,curralignInn);
                                                                        stralignmap.put(m,stringalingInn);
                                                                    }
                                                                    else{
                                                                        string veralignInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        veralignInn = veralignInn.replace('s','');
                                                                        veralignmap.put(m,veralignInn);
                                                                    }  
                                                                }
                                                            }
                                                            m = m+1;
                                                            
                                                        }
                                                    } 
                                                
                                                if(!isRollup){
                                                    for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                    
                                                    
                                                   
                                                   

                                                    Table += '<div class="" style="margin-top:5px;">';
                                                    Table += '<Table style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table   += '<tr><td class="page-break" style="white-space: normal;text-align:left;margin-top:10px;color:black;font-family:'+DocChild.font_Color__c+';font-size:12px;padding-top:8px">';
                                                    if(str != 'null' && str != null && str != ''){
                                                        Table += '<b>'+str+'</b>';
                                                    }
                                                    else if(str == 'null' || str != null || str != '' ){
                                                        Table += '<b>None</b>';
                                                    }
                                                    Table += '</td></tr><tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                   
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !='' && tablewidth != 'auto'){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/FieldslableOnTablelist.size());
                                                    }
                                                    //for(string lables : FieldslableOnTablelist){
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>';
                                                    decimal Total = 0; 
                                                    string addcolor = color1;
                                                    for(sobject sb : MapVsValues.get(str)){
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        if(i == z ){
                                                            addcolor = color2;
                                                        }
                                                        if(Docchild.JunoDoc__Group_By_Calculation__c != null && Docchild.JunoDoc__Group_By_Calculation__c != ''){
                                                            if(sb.get(Docchild.JunoDoc__Group_By_Calculation__c) != null)
                                                            Total += (decimal)sb.get(Docchild.JunoDoc__Group_By_Calculation__c);
                                                        }
                                                        Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                        integer crows = 1;
                                                        for(string lables : Fieldsontablelist){
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                }
                                                                                else if(Types == 'DATE'){
                                                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                    Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                }
                                                                                else if(Types == 'DATETIME'){
                                                                                    Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3])).format(DateFormats + ' HH:mm a');
                                                                                }
                                                                                else if(Types == 'BOOLEAN'){
                                                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]));
                                                                                    if(textbool == true){
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                    else{
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                }
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else if(Stringobjcts.size() > 2){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]) != null) {
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                                else if(Types == 'DATE'){
                                                                                    Date Datestr = Date.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                    Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                                }
                                                                                else if(Types == 'DATETIME'){
                                                                                    Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2])).format(DateFormats + ' HH:mm a');
                                                                                }
                                                                                else if(Types == 'BOOLEAN'){
                                                                                    boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]));
                                                                                    if(textbool == true){
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                    else{
                                                                                        Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                    }
                                                                                }
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string childobject = DocChild.Child_object__c;
                                                           if(DocChild.Child_object__c.contains('[')){
                                                               childobject = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                           }
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring += currencySymbol + GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                            else if(Types == 'DATE'){
                                                                                Date Datestr = Date.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                Childstring += DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                            }
                                                                            else if(Types == 'DATETIME'){
                                                                                Childstring += Datetime.valueof(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1])).format(DateFormats + ' HH:mm a');
                                                                            }
                                                                            else if(Types == 'BOOLEAN'){
                                                                                boolean textbool = boolean.valueof(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]));
                                                                                if(textbool == true){
                                                                                    Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+checkdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                }
                                                                                else{
                                                                                    Childstring += '<img src="'+sfdcURL+'/servlet/servlet.ImageServer?id='+uncheckdocument.Id+'&amp;oid='+UserInfo.getOrganizationId()+'" alt="your image" style="width: 15px;height:15px;margin-right: 5px;background:white;cursor: grab;overflow: hidden;box-sizing: border-box;">';
                                                                                }
                                                                            }
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }      
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
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
                                                            crows = crows + 1;
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+Childstring,CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  Childstring+ '</td>';
                                                                    }
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DATE'){  
                                                                if(Childstring != null && Childstring != '' && Childstring != 'null'){
                                                                    Date Datestr = Date.valueof(Childstring);
                                                                    Childstring = DateTime.newInstance(Datestr.year(), Datestr.month(), Datestr.day()).format(DateFormats);
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DATETIME'){
                                                                if(Childstring != null && Childstring != 'null' && Childstring != ''){
                                                                    Childstring = Datetime.valueof(Childstring).format(DateFormats + ' HH:mm a');
                                                                }
                                                                
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                            else{
                                                                if(Childstring == null || Childstring == 'null'){
                                                                    Childstring = ''; 
                                                                }
                                                                Childstring = Childstring.replaceAll('[\u0000-\u001F]', '');
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+stringaling+';border:'+DocChild.border__c+'">'+  Childstring + '</td>';
                                                            }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    }
                                                    if(addcolor == color1){
                                                        addcolor = color2;
                                                    }
                                                    else{
                                                        addcolor = color1;
                                                    }
                                                    if(Docchild.JunoDoc__Group_By_Calculation__c != null && Docchild.JunoDoc__Group_By_Calculation__c != ''){
                                                        Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                        for(integer k= 0;k< (Fieldsontablelist.size()-2);k++){
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+'"></td>';
                                                        }
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">Total</td>';
                                                        string Types = ChildobjectsMap.get(Docchild.JunoDoc__Group_By_Calculation__c.toLowercase()+DocChild.Child_object__c.toLowercase());
                                                        
                                                        if(Types == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+total,CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">'+currencysymbol+currencyvalue+'</td>';
                                                        }
                                                        else{
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';border:'+DocChild.border__c+';text-align:right;font-weight:bold">'+total+'</td>';    
                                                        }
                                                        Table += '</tr>';
                                                    }
                                                    Table += '</table>';
                                                        Table += '</div>';
                                                }
                                                }
                                                else{
                                                    decimal totalgroup = 0;
                                                    Table += '<div style="margin-top:5px;">';
                                                    Table += '<div style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table += '<tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                  
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !='' && tablewidth != 'auto'){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/(FieldslableOnTablelist.size()+1));
                                                    }
                                                   
                                                    //for(string lables : FieldslableOnTablelist){
                                                   
                                                    string[] splits = HeaderStyle.split('</td>'); 
                                                    string[] tdsplit = splits[0].replace('>','@@@@@').split('@@@@@');
                                                    Table += tdsplit[0] +'>'+groupFieldLabelName +'</td>';
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>'; 
                                                  
                                                       Map<string,string> Totallables = new Map<string,string>();
                                                    string addcolor = '';
                                                for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                 if(MapVsValues.get(str) != null){
                                                    Map<string,string> decimalmap = new Map<string,string>();
                                                            
                                                    for(sobject sb : MapVsValues.get(str)){
                                                        
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        
                                                        if(i == z ){
                                                           
                                                            addcolor = color2;
                                                        }
                                                        
                                                        integer crows = 1;
                                                        for(string lables : Fieldsontablelist){
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
                                                            crows = crows + 1;
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                    string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                   
                                                                                    if(Types == 'CURRENCY'){
                                                                                        Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                    }
                                                                                    
                                                                                    else{ 
                                                                                        Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
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
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                               
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                           
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }  
                                                                
                                                                
                                                                
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
                                                            if(Childstring != ''){
                                                                if(decimalmap.get(lables) == null){
                                                                    decimalmap.put(lables,Childstring);
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(decimalmap.get(lables));
                                                                    decimalmap.put(lables,''+(decval + decimal.valueof(Childstring)));
                                                                }
                                                            }
                                                            else{
                                                                decimalmap.put(lables,'0');
                                                            }
                                                        }    
                                                    }
                                                     Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     if(str == null || Str == '' || Str == 'null'){
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">None</td>';    
                                                     }
                                                     else{
                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">'+Str+'</td>';
                                                     }      
                                                     integer l = 1;
                                                      for(string lables : decimalmap.keyset()){ 
                                                            if(curralignmap.get(l) != null){
                                                                curralign = curralignmap.get(l);
                                                            }
                                                            else{
                                                                curralign = 'right';
                                                            }
                                                            if(veralignmap.get(l) != null){
                                                                veralign = veralignmap.get(l);
                                                            }
                                                            else{
                                                                veralign = 'top';
                                                            }
                                                            if(stralignmap.get(l) != null){
                                                                stringaling = stralignmap.get(l);
                                                            }
                                                            else{
                                                                stringaling = 'left';
                                                            }
                                                            l = l+1;
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+decimalmap.get(lables),CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables)+ '</td>';
                                                            }
                                                            else{
                                                                if(decimalmap.get(lables) == null || decimalmap.get(lables) == 'null'){
                                                                    decimalmap.put(lables,'0'); 
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables) + '</td>';
                                                            }
                                                                
                                                                if(Totallables.get(lables) == null){
                                                                    Totallables.put(lables,decimalmap.get(lables));
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(Totallables.get(lables));
                                                                    Totallables.put(lables,''+(decval + decimal.valueof(decimalmap.get(lables))));
                                                                }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    
                                                    }    
                                                }
                                                Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     Table += '<td style="padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:left;border:'+DocChild.border__c+';font-weight:bold">Total</td>';
                                                     for(string lables : Totallables.keyset()){ 
                                                        if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+Totallables.get(lables),CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+ currencySymbol +currencyvalue + '</td>';
                                                        }
                                                        
                                                        else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                    Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables)+ '</td>';
                                                        }
                                                        else{
                                                            if(Totallables.get(lables) == null || Totallables.get(lables) == 'null'){
                                                                Totallables.put(lables,'0'); 
                                                            }
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables) + '</td>';
                                                        }         
                                                            
                                                    }
                                                    Table += '</tr>';
                                                    Table += '</div>';
                                                    Table += '</div>';
                                           }       
                                                return table;
                                            }
    
   public static string ChildGetEmailDataDynamically(string ObjName,string GroupField,string FieldsOnTable,
                                            string parentObject,string parentId,string Filter,string order,
                                            string FieldslableOnTable,string color1,string color2,string HeaderStyle,
                                            string Headerbackground,string tablewidth, Map<string,string> ChildobjectsMap,
                                            JunoDoc__Email_Template_Child__c DocChild,String DateFormats,string sfdcURL,
                                            document checkdocument,document uncheckdocument,string CurrencyFormat,string currencySymbol,string GroupField1) {
                                                 string TempTypes =  'table';
                                                 DocChild.Child_object__c = DocChild.Child_object__c.replace('[','---').split('---')[0];
                                                 
                                                 //GroupField1 = 'Quantity';
                                                List<sobject> objList = new List<sobject>();
                                                Map<string,List<sobject>> MapVsValues = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> MapVsValues1 = new Map<string,List<sobject>>();
                                                Map<string,List<sobject>> grpMapVsValues = new Map<string,List<sobject>>();
                                                list<string> Fieldsontablelist = new list<string>();
                                                Fieldsontablelist = FieldsOnTable.split(',');
                                                if(!FieldsOnTable.contains(GroupField)){
                                                    FieldsOnTable += ','+GroupField;
                                                }
                                                if(GroupField1 != null){
                                                    if(!FieldsOnTable.toLowerCase().contains(GroupField1.toLowerCase())){
                                                        FieldsOnTable += ','+GroupField1;
                                                    }
                                                }
                                                string Query = 'select '+FieldsOnTable+' from '+ObjName + ' where '+ parentObject + ' =: parentId';
                                                if(Filter != '' && Filter != null){
                                                    Query += ' and ' + Filter;
                                                }
                                                if(order != '' && order != null){
                                                    Query += ' order by ' + Order + ' NULLS LAST';
                                                }
                                                else{
                                                    Query += ' order by ' + GroupField + ' NULLS LAST';
                                                }
                                                objList = Database.query(Query);
                                                List<PicklistOptions> fieldList = new List<PicklistOptions>();
                                                Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                                                Schema.SObjectType sobjType = gd.get(ObjName); 
                                                Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
                                                Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap(); 
                                                String groupFieldLabelName;
                                                Schema.DisplayType groupFieldDataType;
                                                
                                                String groupFieldLabelName1;
                                                Schema.DisplayType groupFieldDataType1;

                                                for(string str: fieldsMap.keySet()){
                                                    
                                                    if(FieldsOnTable.toLowerCase().contains(fieldsMap.get(str).getDescribe().getName().toLowerCase())){
                                                        PicklistOptions fieldsDataRec = new PicklistOptions(fieldsMap.get(str).getDescribe().getLabel(),fieldsMap.get(str).getDescribe().getName(),'');
                                                        fieldsDataRec.Label = fieldsMap.get(str).getDescribe().getLabel();
                                                        fieldsDataRec.Value = fieldsMap.get(str).getDescribe().getName();
                                                        if(fieldsDataRec.Value == GroupField){
                                                            groupFieldLabelName = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                       
                                                        if(GroupField == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        
                                                        if(fieldsDataRec.Value == GroupField1){
                                                            groupFieldLabelName1 = fieldsMap.get(str).getDescribe().getLabel();
                                                        }
                                                       
                                                        if(GroupField1 == fieldsMap.get(str).getDescribe().getName()){
                                                            groupFieldDataType1 = fieldsMap.get(str).getDescribe().getType();
                                                        }
                                                        fieldList.add(fieldsDataRec);
                                                    }
                                                }
                                                
                                                    for(sobject Obj:objList){
                                                        if(MapVsValues1.get(''+Obj.get(GroupField1)) == null){
                                                            MapVsValues1.put(''+Obj.get(GroupField1),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues1.get(''+Obj.get(GroupField1)).add(Obj);
                                                        }
                                                        
                                                        if(MapVsValues.get(''+Obj.get(GroupField)) == null){
                                                            MapVsValues.put(''+Obj.get(GroupField),new List<sobject>{Obj});
                                                        }else{
                                                            MapVsValues.get(''+Obj.get(GroupField)).add(Obj);
                                                        }
                                                        
                                                        if(grpMapVsValues.get((''+Obj.get(GroupField))+(''+Obj.get(GroupField1))) == null){
                                                            grpMapVsValues.put((''+Obj.get(GroupField))+(''+Obj.get(GroupField1)),new List<sobject>{Obj});
                                                        }else{
                                                            grpMapVsValues.get((''+Obj.get(GroupField))+(''+Obj.get(GroupField1))).add(Obj);
                                                        }    
                                                    }
                                                String Table = '';
                                                string veralign = 'top';                                               
                                                string curralign = 'right';
                                                string stringaling = 'left';
                                                Map<string,string> curralignmap = new Map<string,string>();
                                                Map<string,string> stralignmap = new Map<string,string>();
                                                Map<string,string> veralignmap = new Map<string,string>();
                                                
                                                    if(!Fieldsontablelist.isEmpty()){
                                                        for(string lables : Fieldsontablelist){
                                                            if(lables.contains('[[')){
                                                                string[] childlabellist = (lables).replace('[[','ssss').split('ssss');
                                                                for(string childs : childlabellist){
                                                                    if(!childs.tolowercase().contains('top') || !childs.tolowercase().contains('bottom')){
                                                                        string curralignInn = childs.replace(']]','ssss').split('ssss')[0];  
                                                                        string stringalingInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        curralignInn = curralignInn.replace('s','');
                                                                        stringalingInn = stringalingInn.replace('s','');
                                                                        curralignmap.put(lables,curralignInn);
                                                                        stralignmap.put(lables,stringalingInn);
                                                                    }
                                                                    else{
                                                                        string veralignInn = childs.replace(']]','ssss').split('ssss')[0]; 
                                                                        veralignInn = veralignInn.replace('s','');
                                                                        veralignmap.put(lables,veralignInn);
                                                                    }  
                                                                }
                                                            }
                                                        }
                                                    } 
                                                
                                                
                                                for(string str : MapVsValues.keyset()){
                                                    integer i=1;
                                                    
                                                    
                                                    
                                                    decimal totalgroup = 0;
                                                    Table += '<div style="margin-top:5px;page-break-before:auto;">';
                                                    Table += '<'+TempTypes+' style="border-collapse: collapse;width:'+tablewidth+'">';
                                                    Table   += '<tr><td class="" style="white-space: normal;text-align:left;margin-top:10px;color:black;font-family:'+DocChild.font_Color__c+';font-size:12px;padding-top: 8px;">';
                                                    if(str != 'null' && str != null && str != ''){
                                                        Table += '<b>'+str+'</b>';
                                                    }
                                                    else if(str == 'null' || str != null || str != '' ){
                                                        Table += '<b>None</b>';
                                                    }
                                                    Table += '</td></tr>';
                                                    Table += '<tr style="border-collapse: collapse;background-color:'+Headerbackground+'">';
                                                  
                                                    string[] FieldslableOnTablelist = FieldslableOnTable.split(',');
                                                    integer widthvalue = 0;
                                                    if(tablewidth != null && tablewidth !='' && tablewidth != 'auto' ){
                                                        decimal tables = decimal.valueof(tablewidth.replace('px',''));
                                                       
                                                        widthvalue = integer.valueof(tables/(FieldslableOnTablelist.size()+1));
                                                    }
                                                   
                                                    //for(string lables : FieldslableOnTablelist){
                                                   
                                                    string[] splits = HeaderStyle.split('</td>'); 
                                                    string[] tdsplit = splits[0].replace('>','@@@@@').split('@@@@@');
                                                    Table += tdsplit[0] +'>'+groupFieldLabelName1 +'</td>';
                                                    Table += HeaderStyle;
                                                    //}
                                                    Table += '</tr>';
                                                    Map<string,string> Totallables = new Map<string,string>();
                                                    string addcolor = '';
                                                    for(string str1 : MapVsValues1.keyset()){
                                                        if(grpMapVsValues.get(str + str1) != null){
                                                                                                                
                                                    
                                                    
                                                    
                                                    Map<string,string> decimalmap = new Map<string,string>();
                                                            
                                                    for(sobject sb : grpMapVsValues.get(str + str1)){
                                                        
                                                        addcolor = color1;
                                                        Integer y = i/2;
                                                        Integer z = y * 2;
                                                        
                                                        if(i == z ){
                                                           
                                                            addcolor = color2;
                                                        }
                                                       
                                                        
                                                        for(string lables : Fieldsontablelist){
                                                            if(curralignmap.get(lables) != null){
                                                                curralign = curralignmap.get(lables);
                                                            }
                                                            if(veralignmap.get(lables) != null){
                                                                veralign = veralignmap.get(lables);
                                                            }
                                                            if(stralignmap.get(lables) != null){
                                                                stringaling = stralignmap.get(lables);
                                                            }
                                                            string Childstring = '';
                                                            if(lables.contains('.')){
                                                                string Stringobjct = lables.replace('.',',');
                                                                string[] Stringobjcts = Stringobjct.split(',');
                                                                if(Stringobjcts.size() > 3){
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]) != null) {
                                                                            if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]) != null) {
                                                                                if(Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]) != null){
                                                                                    string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                    string secchild = getchilType(firstchild,Stringobjcts[1]);
                                                                                    string Types = getRelType(secchild,Stringobjcts[2],Stringobjcts[3]);
                                                                                   
                                                                                    if(Types == 'CURRENCY'){
                                                                                        Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]),CurrencyFormat);
                                                                                    }
                                                                                    
                                                                                    else{ 
                                                                                        Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).getsobject(Stringobjcts[2]).get(Stringobjcts[3]);
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
                                                                                string firstchild = getchilType(DocChild.Child_object__c,Stringobjcts[0]);
                                                                                string Types = getRelType(firstchild,Stringobjcts[1],Stringobjcts[2]);
                                                                                
                                                                                if(Types == 'CURRENCY'){
                                                                                    Childstring += GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]),CurrencyFormat);
                                                                                }
                                                                               
                                                                                else{ 
                                                                                    Childstring += ''+Sb.getsobject(Stringobjcts[0]).getsobject(Stringobjcts[1]).get(Stringobjcts[2]);
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else{
                                                                    if(Sb.getsobject(Stringobjcts[0]) != null){
                                                                        if(Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]) != null) {
                                                                            string Types = getRelType(DocChild.Child_object__c,Stringobjcts[0].tolowercase(),Stringobjcts[1]);
                                                                            
                                                                            if(Types == 'CURRENCY'){
                                                                                Childstring +=  GetCurrencyvalues(''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]),CurrencyFormat);
                                                                            }
                                                                           
                                                                            else{
                                                                                Childstring += ''+Sb.getsobject(Stringobjcts[0]).get(Stringobjcts[1]);
                                                                            }                                        
                                                                        }
                                                                    }
                                                                }  
                                                                
                                                                
                                                                
                                                            }
                                                            else{
                                                                if(sb.get(lables) != null){
                                                                    Childstring += sb.get(lables);
                                                                }
                                                                else{
                                                                    Childstring += '';
                                                                }
                                                            }
                                                            if(Childstring != ''){
                                                                if(decimalmap.get(lables) == null){
                                                                    decimalmap.put(lables,Childstring);
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(decimalmap.get(lables));
                                                                    decimalmap.put(lables,''+(decval + decimal.valueof(Childstring)));
                                                                }
                                                            }
                                                            else{
                                                                decimalmap.put(lables,'0');
                                                            }
                                                        }    
                                                    }
                                                            Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:left;border:'+DocChild.border__c+'">'+Str1+'</td>';
                                                            
                                                            for(string lables : decimalmap.keyset()){ 
                                                                 if(curralignmap.get(lables) != null){
                                                                curralign = curralignmap.get(lables);
                                                            }
                                                            if(veralignmap.get(lables) != null){
                                                                veralign = veralignmap.get(lables);
                                                            }
                                                            if(stralignmap.get(lables) != null){
                                                                stringaling = stralignmap.get(lables);
                                                            }
                                                            if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                                string currencyvalue = GetCurrencyvalues(''+decimalmap.get(lables),CurrencyFormat);
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+ currencySymbol +currencyvalue + '</td>';
                                                            }
                                                            
                                                            else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                    || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                        Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables)+ '</td>';
                                                            }
                                                            else{
                                                                if(decimalmap.get(lables) == null || decimalmap.get(lables) == 'null'){
                                                                    decimalmap.put(lables,'0'); 
                                                                }
                                                                Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:'+veralign+';text-align:'+curralign+';border:'+DocChild.border__c+'">'+  decimalmap.get(lables) + '</td>';
                                                            }
                                                                
                                                                if(Totallables.get(lables) == null){
                                                                    Totallables.put(lables,decimalmap.get(lables));
                                                                }
                                                                else{
                                                                    decimal decval = decimal.valueof(Totallables.get(lables));
                                                                    Totallables.put(lables,''+(decval + decimal.valueof(decimalmap.get(lables))));
                                                                }
                                                        }
                                                        Table += '</tr>'; 
                                                        i = i+1;
                                                    
                                                    }
                                                    }
                                                     Table += '<tr style="border-collapse: collapse;background-color:'+addcolor+'">';
                                                     Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:left;border:'+DocChild.border__c+';font-weight:bold">Total</td>';
                                                     for(string lables : Totallables.keyset()){ 
                                                        if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'CURRENCY'){
                                                            string currencyvalue = GetCurrencyvalues(''+Totallables.get(lables),CurrencyFormat);
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+ currencySymbol +currencyvalue + '</td>';
                                                        }
                                                        
                                                        else if(ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'NUMBER' 
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DOUBLE'
                                                                || ChildobjectsMap.get(lables.toLowercase()+DocChild.Child_object__c.toLowercase()) == 'DECIMAL'){
                                                                    Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables)+ '</td>';
                                                        }
                                                        else{
                                                            if(Totallables.get(lables) == null || Totallables.get(lables) == 'null'){
                                                                Totallables.put(lables,'0'); 
                                                            }
                                                            Table += '<td style="font-family:'+DocChild.font_Color__c+';font-size:'+DocChild.Font_Size__c+';padding:'+DocChild.Junodoc__Padding__c+';width:'+widthvalue+'px;height:'+DocChild.height__c+';vertical-align:middle;text-align:right;border:'+DocChild.border__c+';font-weight:bold">'+  Totallables.get(lables) + '</td>';
                                                        }
                                                            
                                                            
                                                    }
                                                    Table += '</tr>';
                                                    Table += '</'+TempTypes+'>';
                                                    Table += '</div>';
                                                }   
                                              //  table = '<div><tr><td>Testing</td><td>Group</td></tr></div>';
                                                return table;
                                            }
    
    
    public class Innerclass{
        @AuraEnabled
        public Map<string,List<sobject>> ResultMap;
        @AuraEnabled
        public List<PicklistOptions> Columns;
        @AuraEnabled
        public String groupFieldLabelName;
    }
    
    public class PicklistOptions implements Comparable {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public String datatype;
        public PicklistOptions(String label, String value, String datatype) {
            this.label = label;
            this.value = value;
            this.datatype = datatype;
        }
        
        public Integer compareTo(Object ObjToCompare) {
            return label.CompareTo(((PicklistOptions)ObjToCompare).label);
        }
    }
    public static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
        String s, tmp;
        Integer i = 4 + dec;
        
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
        
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
        
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
        
        return s;
    }
    
    public static string GetCurrencyvalues(string currencyvalue,string CurrencyFormat){
        list<string> CurrList = new list<string>();
        integer currlength = 0;
        string firstcol = '';
        string secondcol = '';
        if(CurrencyFormat.contains('.0')){
            CurrList = CurrencyFormat.replace('.','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = ',';
            secondcol = '.';
        }
        if(CurrencyFormat.contains(',0')){
            CurrList = CurrencyFormat.replace(',','xx').split('xx');
            currlength = CurrList[1].length();
            firstcol = '.';
            secondcol = ',';
        }
        string currencies = '';
        if(currencyvalue != '' && currencyvalue != null){
            currencies = doFormatting(decimal.valueof(''+currencyvalue),currlength,firstcol,secondcol);
        }
        else{
            currencies = doFormatting(decimal.valueof('0'),currlength,firstcol,secondcol);
        }
        return currencies;
        
    }
    
    public static String getRelType(string ObjectName,String FieldName,String parfieldName){
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
        return Types;
        
    }
    public static String getchilType(string ObjectName,String FieldName){
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
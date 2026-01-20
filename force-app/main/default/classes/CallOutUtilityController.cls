global with sharing class CallOutUtilityController{
    
    private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String NS_SF = 'urn:partner.soap.sforce.com';
    
    public Static HttpResponse ConnectToOtherSFDC(String destinationOrg){
        List<JunoDoc__Junodoc_Connections__c> connectionInstance = [SELECT Id, IsDeleted, Name, SetupOwnerId, CreatedDate, 
                                                                         CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, JunoDoc__Access_Token__c, 
                                                                         JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c, JunoDoc__Consumer_Key__c, 
                                                                         JunoDoc__Consumer_Secret__c, JunoDoc__End_Point_New_URL__c, JunoDoc__End_Point_URL__c, 
                                                                         JunoDoc__Hourly_Scheduled__c, JunoDoc__Instance_URL__c, JunoDoc__Last_Schedule_Run_Time__c, 
                                                                         JunoDoc__Method__c, JunoDoc__Org_Id__c, JunoDoc__Password__c, JunoDoc__Password_Encrypted__c, 
                                                                         JunoDoc__Production__c, JunoDoc__Sandbox__c, JunoDoc__Security_Token__c, JunoDoc__Set_Audit_Fields__c,
                                                                         JunoDoc__Used_Percentage__c, JunoDoc__Username__c FROM JunoDoc__Junodoc_Connections__c  where Id =: destinationOrg  OR Name =: destinationOrg limit 1];
        if(connectionInstance.size() > 0){
            string passWord = '';
            passWord = passWord + connectionInstance[0].JunoDoc__Password_Encrypted__c;
            if(connectionInstance[0].JunoDoc__Security_Token__c != null){
                passWord = passWord + connectionInstance[0].JunoDoc__Security_Token__c;
            }
            String reqbody = 'grant_type=password&client_id='
                            +connectionInstance[0].JunoDoc__Consumer_Key__c
                            +'&client_secret='
                            +connectionInstance[0].JunoDoc__Consumer_Secret__c
                            +'&username='
                            +connectionInstance[0].JunoDoc__Username__c
                            +'&password='  
                            +passWord;
            Http securityTokenHTTP = new Http();
            HttpRequest securityTokenReq = new HttpRequest();
            securityTokenReq.setBody(reqbody);
            securityTokenReq.setMethod('POST');
            securityTokenReq.setEndpoint(connectionInstance[0].JunoDoc__End_Point_New_URL__c);
            HttpResponse securityTokenres;
            if (!Test.isRunningTest()){
                securityTokenres = securityTokenHTTP.send(securityTokenReq);
            }
            return securityTokenres;
        }
        else{
            return null;
        }
    }
    
    public static responseClass soap_connectToSFDC(String connection){
        List<JunoDoc__Junodoc_Connections__c> destination = [SELECT Id, IsDeleted, Name, SetupOwnerId, CreatedDate, 
                                                                         CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, JunoDoc__Access_Token__c, 
                                                                         JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c, JunoDoc__Consumer_Key__c, 
                                                                         JunoDoc__Consumer_Secret__c, JunoDoc__End_Point_New_URL__c, JunoDoc__End_Point_URL__c, 
                                                                         JunoDoc__Hourly_Scheduled__c, JunoDoc__Instance_URL__c, JunoDoc__Last_Schedule_Run_Time__c, 
                                                                         JunoDoc__Method__c, JunoDoc__Org_Id__c, JunoDoc__Password__c, JunoDoc__Password_Encrypted__c, 
                                                                         JunoDoc__Production__c, JunoDoc__Sandbox__c, JunoDoc__Security_Token__c, JunoDoc__Set_Audit_Fields__c,
                                                                         JunoDoc__Used_Percentage__c, JunoDoc__Username__c FROM JunoDoc__Junodoc_Connections__c
                                                    where 
                                                    Id =: connection 
                                                    OR 
                                                    Name =: connection limit 1];
        system.debug('destination 80>>> '+destination);
        responseClass responseRec = new responseClass();
        if(destination.size() > 0){
            String userName = '';
            String passWord = '';
            userName = destination[0].JunoDoc__Username__c;  
            if(destination[0].JunoDoc__Security_Token__c != null && destination[0].JunoDoc__Security_Token__c != '') {
                passWord = destination[0].JunoDoc__Password_Encrypted__c + destination[0].JunoDoc__Security_Token__c;
            }
            else {
                passWord = destination[0].JunoDoc__Password_Encrypted__c;
            }
            system.debug('userName >> '+userName);
            system.debug('passWord >> '+passWord);
            system.debug('Token >>> '+destination[0].JunoDoc__Security_Token__c);
            //password = 'Amma@123';
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setMethod('POST');   
            req.setTimeout(60000);
            if(destination[0].JunoDoc__Sandbox__c){
                req.setEndpoint('https://test.salesforce.com/services/Soap/u/43.0');    
            }
            else{
                req.setEndpoint('https://login.salesforce.com/services/Soap/u/43.0');    
            }
            req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
            req.setHeader('SOAPAction', '""');
            req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + userName + '</username><password>' + passWord + '</password></login></Body></Envelope>');        
            if (!Test.isRunningTest()){
                res =  new Http().send(req);
                if(res.getStatusCode() != 200){
                    Dom.Document responseDocument = res.getBodyDocument();  
                    Dom.Xmlnode rootElm = responseDocument.getRootElement(); 
                    Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); 
                    Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); 
                    Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); 
                    responseRec.response = false;
                    responseRec.responsemessage = faultStringElm.getText();
                }
                else {
                    Dom.Document responseDocument = res.getBodyDocument();
                    Dom.Xmlnode rootElm = responseDocument.getRootElement();
                    Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP);
                    Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF);
                    Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF);
                    Dom.Xmlnode sessionId = resultElm.getChildElement('sessionId', NS_SF);
                    Dom.Xmlnode serverUrlElm = resultElm.getChildElement('serverUrl', NS_SF);
                    responseRec.response = true;
                    responseRec.sessionId = string.valueOf(sessionId.getText());
                    responseRec.responseServerUrl = string.valueOf(serverUrlElm.getText());
                }
            }
            else{
                responseRec.response = true;
                responseRec.sessionId = 'sessionId';
                responseRec.responseServerUrl = 'https://ap2.salesforce.com';
            }
        }
        else if(Test.isRunningTest()){
            responseRec.response = true;
            responseRec.sessionId = 'sessionId';
            responseRec.responseServerUrl = 'https://ap2.salesforce.com';
        }
        return responseRec;
    }
    
    public Static httpResponse SOAP_ApiCall(String str_securityToken, String str_InstanceUrl, String str_jsonBody){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        URL instanceUrl = new URL(str_InstanceUrl);
        post_Req.setEndpoint('https://' + instanceUrl.gethost() + '/services/Soap/c/43.0');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        post_Req.setHeader('Content-Type', 'text/xml'); 
        post_Req.setHeader('SOAPAction', '""');
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public httpResponse getFromOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_Query){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setMethod('GET');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/query?q='+str_Query);
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
         post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public httpResponse recordTypeInfoFromDestination(String str_securityToken, String str_InstanceUrl, String str_Query){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setMethod('GET');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v37.0/query?q='+str_Query);
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    
    public httpResponse pushToOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        
        ParentObjectName = ParentObjectName.replace('\r\n','');
        ParentObjectName = ParentObjectName.replace('\n', '');
        ParentObjectName = ParentObjectName.replace('\r', '');
        ParentObjectName = ParentObjectName.trim();
        ParentObjectName = ParentObjectName.replace(' ','');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/tree/'+ParentObjectName+'/');
        HttpResponse post_Res;
        if(!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
     public Static httpResponse getReferenceRecordsFromDestination(String str_securityToken, String str_InstanceUrl, String str_jsonBody){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');   
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/batch');
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
     
     
     public httpResponse pushToOtherSfdcPatch(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/batch');
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public httpResponse pushPriceBookEntryToOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/batch');
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public httpResponse objectSchemaRequest(String str_accessToken, String str_InstanceUrl, String str_JsonBody){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+ str_accessToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_JsonBody);
        post_Req.setMethod('POST');
        post_Req.setEndpoint(str_InstanceUrl + '/services/data/v34.0/composite/batch');
        HttpResponse post_Res;
        if (!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public static httpResponse apiLimits(String str_securityToken, String str_InstanceUrl){
        Http obj_http = new Http();
        HttpResponse obj_res = new HttpResponse();
        HttpRequest obj_req = new HttpRequest();
        obj_req.setHeader('Authorization','Bearer '+ str_securityToken);
        obj_req.setHeader('Content-Type','application/json');
        obj_req.setHeader('accept','application/json');
        obj_req.setMethod('GET');
        obj_req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/limits/');
        HttpResponse post_Res;
        if(!Test.isRunningTest()){
            obj_res = obj_http.send(obj_req);
        }
        return obj_res;
    }
    
    public static httpResponse mtreeBatchClassRequest(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        
        ParentObjectName = ParentObjectName.replace('\r\n','');
        ParentObjectName = ParentObjectName.replace('\n', '');
        ParentObjectName = ParentObjectName.replace('\r', '');
        ParentObjectName = ParentObjectName.trim();
        ParentObjectName = ParentObjectName.replace(' ','');
        
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/tree/'+ParentObjectName+'/');
        HttpResponse post_Res;
        if(!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public static httpResponse mGraphBatchClassRequest(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        Http post_Http = new Http();
        HttpRequest post_Req = new HttpRequest();
        post_Req.setHeader('Authorization','Bearer '+str_securityToken);
        post_Req.setHeader('Content-Type','application/json;charset=UTF-8');
        post_Req.setBody(str_jsonBody);
        post_Req.setMethod('POST');
        ParentObjectName = ParentObjectName.replace('\r\n','');
        ParentObjectName = ParentObjectName.replace('\n', '');
        ParentObjectName = ParentObjectName.replace('\r', '');
        ParentObjectName = ParentObjectName.trim();
        ParentObjectName = ParentObjectName.replace(' ','');
        post_Req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/composite/tree/'+ParentObjectName+'/');
        HttpResponse post_Res;
        if(!Test.isRunningTest()){
            post_Res = post_Http.send(post_Req);
        }
        return post_Res;
    }
    
    public static HttpResponse retrieveStandardObjectInfo(String accesstoken, string instanceURL){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + '/services/data/v39.0/sobjects/');
        HttpResponse postRes;
        if(!Test.isRunningTest())
        postRes = post.send(req);
        return postRes;
    }
    
    public httpResponse objectDescribe(String str_accessToken, String str_InstanceUrl, String objectName){
        Http obj_http = new Http();
        HttpResponse obj_res = new HttpResponse();
        HttpRequest obj_req = new HttpRequest();
        obj_req.setHeader('Authorization','Bearer '+str_accessToken);
        obj_req.setHeader('Content-Type','application/json');
        obj_req.setHeader('accept','application/json');
        obj_req.setMethod('GET');
        obj_req.setEndpoint(str_InstanceUrl+'/services/data/v34.0/sobjects/'+objectName+'/describe');
        if(!test.isRunningTest()){
            obj_res = obj_http.send(obj_req);
        }
        return obj_res;
    }
    
    public static HttpResponse retrieveValidationRule(String accesstoken, string instanceURL, string describeURL){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + describeURL);
        HttpResponse postRes;
        if(!Test.isRunningTest()){
            postRes = post.send(req);
        }
        return postRes;   
    }
    
    public static HttpResponse retrievePageLayoutsInfo(String accesstoken, string instanceURL, string query){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + '/services/data/v39.0/tooling/query?q=' + 'SELECT+Name,TableEnumOrId+FROM+Layout');
        HttpResponse postRes;
        if(!Test.isRunningTest()){
            postRes = post.send(req);
        }
        return postRes;
    } 
    
    public static HttpResponse retrieveApexClassesInfo(String accesstoken, string instanceURL, string query){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + '/services/data/v39.0/tooling/query?q=' + query);
        HttpResponse postRes;
        if(!Test.isRunningTest()){
            postRes = post.send(req);
        }
        return postRes;
    }
    
    public static HttpResponse retrieveApexTriggersInfo(String accesstoken, string instanceURL, string query){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + '/services/data/v39.0/tooling/query?q=' + query);
        HttpResponse postRes;
        if(!Test.isRunningTest()){
            postRes = post.send(req);
        }
        return postRes;
    } 
    
    public static HttpResponse retrieveApexPagesInfo(String accesstoken, string instanceURL, string query){
        Http post = new Http();  
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + '/services/data/v39.0/tooling/query?q='+ query); //Select+Id,+Name,+NamespacePrefix+From+apexpage');
        HttpResponse postRes;
        if(!Test.isRunningTest())
        postRes = post.send(req);
        return postRes;
    }
    
    public static HttpResponse retrieveObjectFieldsInfo(String accesstoken, string instanceURL, string describeURL){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + describeURL);
        HttpResponse postRes;
        if(!Test.isRunningTest())
        postRes = post.send(req);
        return postRes;

    }
    
    public static HttpResponse nextRecordsURL(String accesstoken, string instanceURL, string nextRecordsURL){
        Http post = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+ accesstoken);
        req.setHeader('Content-Type','application/json;charset=UTF-8');
        req.setMethod('GET');
        req.setEndpoint(instanceURL + nextRecordsURL);
        HttpResponse postRes;
        if(!Test.isRunningTest())
        postRes = post.send(req);
        return postRes;
    } 
    
    public class responseClass {
        public boolean response {get;set;}
        public String responsemessage {get;set;}
        public string responseServerUrl {get;set;}
        public string sessionId {get;set;}
    }
    
    
    global Static HttpResponse m_ConnectToOtherSFDC(String destinationOrg){
        return null;
        
    }
    global Static httpResponse m_getFromOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_Query){
        return null;
    }
    global Static httpResponse m_pushToOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        return null;
    }
    global Static httpResponse m_pushToOtherSfdcPatch(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        return null;
    }
    public static httpResponse m_pushPriceBookEntryToOtherSfdc(String str_securityToken, String str_InstanceUrl, String str_jsonBody, String ParentObjectName){
        return null;
    } 
    
    
    //EndPoint Class 

    
    public string picklist {get; set;}
    public string connectionname {get; set;}
    public boolean show {get; set;}
    public boolean hide {get; set;}
    public string selectedid {get; set;}
    public string hiddenPassword {get;set;}
    
    public JunoDoc__Junodoc_Connections__c newconnection {get; set;}
    public list<wrap> wraplist{get;set;}
    public list<JunoDoc__Junodoc_Connections__c> connectionlist{get;set;}
    
    public string remoteSiteSettingURL {get;set;}
    public string HostUrl {get;set;}
    public boolean callRemoteSite {get;set;}
    public string remoteSiteSettingName {get;set;}
    public boolean upsertRemoteSiteSettings {get;set;}
    public boolean createRemoteSiteSettings {get;set;}
    
    public boolean newConnectionCreating{get;set;}
    public boolean callRedirect{get;set;}
    public   CallOutUtilityController(){
        Id id = ApexPages.currentPage().getParameters().get('id');
        HostUrl = ApexPages.currentPage().getHeaders().get('Host');
        if(id == null){
            newConnectionCreating = true;
        }
        else{
            newConnectionCreating = false;
        }
        newconnection = (id == null) ? new JunoDoc__Junodoc_Connections__c() : [SELECT Name, Id, JunoDoc__Access_Token__c, JunoDoc__Username__c, JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c, JunoDoc__Consumer_Key__c, JunoDoc__End_Point_New_URL__c, JunoDoc__End_Point_URL__c, JunoDoc__Instance_URL__c, JunoDoc__Hourly_Scheduled__c, JunoDoc__Last_Schedule_Run_Time__c, JunoDoc__Method__c, JunoDoc__Org_Id__c, JunoDoc__Password__c, JunoDoc__Password_Encrypted__c, JunoDoc__Production__c, JunoDoc__Sandbox__c, JunoDoc__Security_Token__c, JunoDoc__Set_Audit_Fields__c, JunoDoc__Used_Percentage__c FROM JunoDoc__Junodoc_Connections__c where id =: String.escapeSingleQuotes(id)];
            load();
        if(id != null){
            show = true;
            hide = false;
            connectionname = newconnection.name;
            if(newconnection.JunoDoc__Sandbox__c == true){
                picklist = 'Sandbox';
            } 
            if(newconnection.JunoDoc__Production__c == true){
                picklist = 'Production';
            } 
        }
    }
    public void load(){
        hide = true;
        connectionlist = [SELECT Name, Id, JunoDoc__Access_Token__c, JunoDoc__Username__c, JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c, JunoDoc__Consumer_Key__c, JunoDoc__End_Point_New_URL__c, JunoDoc__End_Point_URL__c, JunoDoc__Instance_URL__c, JunoDoc__Hourly_Scheduled__c, JunoDoc__Last_Schedule_Run_Time__c, JunoDoc__Method__c, JunoDoc__Org_Id__c, JunoDoc__Password__c, JunoDoc__Password_Encrypted__c, JunoDoc__Production__c, JunoDoc__Sandbox__c, JunoDoc__Security_Token__c, JunoDoc__Set_Audit_Fields__c, JunoDoc__Used_Percentage__c FROM JunoDoc__Junodoc_Connections__c limit 40000];
        wraplist = new list<wrap>();
        for(JunoDoc__Junodoc_Connections__c a: connectionlist){
            wrap w = new wrap();
            w.connection = a;
            if(a.JunoDoc__Sandbox__c){
                w.type ='Sandbox';
            }
            else{
                w.type ='Production';  
            }
            wraplist.add(w);
        }
    }
    public void save(){
        system.debug('newcon >>> '+newconnection);
        system.debug('Password >>> '+newconnection.JunoDoc__Password_Encrypted__c);
        system.debug('hiddenPassword >>> '+hiddenPassword);
        if(hiddenPassword != null){
            newconnection.JunoDoc__Password_Encrypted__c = hiddenPassword;
        }
        boolean hasErrors = false;
        if(picklist.equals('None') || String.isBlank(connectionname) || String.isBlank(newconnection.JunoDoc__Username__c) || String.isBlank(newconnection.JunoDoc__Password_Encrypted__c)  || newconnection.JunoDoc__API_Usage__c == null|| String.isBlank(newconnection.JunoDoc__Org_Id__c) || newconnection.JunoDoc__Org_Id__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Provide values for all of the Required Fields.'));
            hasErrors = true;
        }
        if(picklist == 'Sandbox'){
            if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isAccessible() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isAccessible() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isAccessible()){
                   
                   if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isUpdateable()
                      && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isCreateable()){
                          newconnection.JunoDoc__Sandbox__c = true;
                      }
                   if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isUpdateable()
                      && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isCreateable()){
                          newconnection.JunoDoc__Production__c = false;
                      }
                   if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isUpdateable()
                      && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isCreateable()){
                          newconnection.JunoDoc__End_Point_New_URL__c = 'https://test.salesforce.com/services/Soap/u/50.0';
                      }
                   
               }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access permissions for '+'JunoDoc__Junodoc_Connections__c'+' '+' Object Fields'));
                hasErrors = true;
            }
        }
        else if(picklist == 'Production'){
            if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isAccessible() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isAccessible() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isAccessible() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isCreateable() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isCreateable() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isCreateable() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Production__c.isUpdateable() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Sandbox__c.isUpdateable() &&
               Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__End_Point_New_URL__c.isUpdateable()){
                   newconnection.JunoDoc__Production__c = true;
                   newconnection.JunoDoc__Sandbox__c = false;
                   newconnection.JunoDoc__End_Point_New_URL__c = 'https://login.salesforce.com/services/Soap/u/50.0';
               }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access permissions for '+'JunoDoc__Junodoc_Connections__c'+' '+' Object Fields'));
                hasErrors = true;
            }
        }
        try{
            if(!hasErrors){
                if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.isCreateable() && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.isUpdateable()){
                    responseClass response = connectToOtherOrg(newconnection);
                    if(response.response){
                        
                        if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.name.isUpdateable()
                           && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.name.isCreateable()){
                               newconnection.name = connectionname;
                           }
                        URL comparisonURL = new URL(response.responseServerUrl);
                        if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Instance_URL__c.isUpdateable()
                           && Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.JunoDoc__Instance_URL__c.isCreateable()){
                               newconnection.JunoDoc__Instance_URL__c = 'https://' + comparisonURL.gethost();
                           }
                        
                        if(hiddenPassword != null){
                            newconnection.JunoDoc__Password_Encrypted__c = hiddenPassword;
                        }
                        upsert newconnection;
                        remoteSiteSettingName = newconnection.name.replace(' ','_');
                        remoteSiteSettingURL = newconnection.JunoDoc__Instance_URL__c;
                        createRemoteSiteSettings = true;
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, response.responsemessage));
                    }
                }
                else{    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient insert/Create access for Junodoc__Connection_Custom_Setting__c Object'));
                }
            }
        }
        catch(Exception exp){
            system.debug('Error >>> '+exp);
        }
    }
    public void delrecord(){
        list<JunoDoc__Junodoc_Connections__c> del =new list<JunoDoc__Junodoc_Connections__c>();
        if(Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.Id.isAccessible() &&
           Schema.sObjectType.JunoDoc__Junodoc_Connections__c.fields.Name.isAccessible()){
               del = [select id, name from JunoDoc__Junodoc_Connections__c where id =: String.escapeSingleQuotes(selectedid)];
           }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access permissions for Endpoints'));
        }
        if(JunoDoc__Junodoc_Connections__c.sObjectType.getDescribe().isDeletable()){
            if(del.size()>0){
                delete del;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Delete access for Endpoints'));
        }
        load();
    }
    public pagereference editreord(){
        JunoDoc__Junodoc_Connections__c a = [select Id, JunoDoc__Org_Id__c, Name From JunoDoc__Junodoc_Connections__c Where Id =: String.escapeSingleQuotes(selectedid)];
        pagereference p = new pagereference('/apex/DocTemplate_Connectionvf?id='+a.Id);
        p.setRedirect(true);
        return p;
    }
    
    public pagereference redirectToEndPoints(){
        pagereference pageRef = new pagereference('/apex/DocTemplate_Connectionvf');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
  
    public void VerifyConnection(){
        JunoDoc__Junodoc_Connections__c connectionInstance = [SELECT Name, Id, JunoDoc__Access_Token__c, JunoDoc__Username__c, JunoDoc__API_Usage__c, JunoDoc__API_Usage_Reached__c, JunoDoc__Consumer_Key__c, JunoDoc__End_Point_New_URL__c, JunoDoc__End_Point_URL__c, JunoDoc__Instance_URL__c, JunoDoc__Hourly_Scheduled__c, JunoDoc__Last_Schedule_Run_Time__c, JunoDoc__Method__c, JunoDoc__Org_Id__c, JunoDoc__Password__c, JunoDoc__Password_Encrypted__c, JunoDoc__Production__c, JunoDoc__Sandbox__c, JunoDoc__Security_Token__c, JunoDoc__Set_Audit_Fields__c, JunoDoc__Used_Percentage__c FROM JunoDoc__Junodoc_Connections__c 
                                                                       Where Id =: selectedid LIMIT 1];
        responseClass response = connectToOtherOrg(connectionInstance);
        if(response.response) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, connectionInstance.Name +' was '+ 'Connected Successfully!'));
            remoteSiteSettingName = connectionInstance.name.replace(' ','_');
            remoteSiteSettingURL = response.responseServerUrl;
            upsertRemoteSiteSettings = true;
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, response.responsemessage));
        }
    }
    
 
    public void newconn(){
        show = true;
        hide = false;
    }
    
    public pagereference cancel(){
        pagereference p = new pagereference('/apex/DocTemplate_Connectionvf');
        p.setRedirect(true);
        return p;
    }
    
    public pagereference view(){
        JunoDoc__Junodoc_Connections__c a = [select id, name from JunoDoc__Junodoc_Connections__c where id =: String.escapeSingleQuotes(selectedid)];
        pagereference p = new pagereference('/apex/DocTemplate_Connectionvf?id='+a.id);
      //  pagereference p = new pagereference('/apex/EndPointViewPage?id='+a.id);
        p.setRedirect(true);
        return p;
    }
    
    public class wrap{
        public JunoDoc__Junodoc_Connections__c connection{get;set;}
        public string type {get;set;}
    } 
    
    public responseClass connectToOtherOrg(JunoDoc__Junodoc_Connections__c connection){
        try{
        String userName = '';
        String passWord = '';
        userName = connection.JunoDoc__Username__c;
        if(connection.JunoDoc__Security_Token__c != null && connection.JunoDoc__Security_Token__c != '') {
            passWord = connection.JunoDoc__Password_Encrypted__c + connection.JunoDoc__Security_Token__c;
        }
        else {
            passWord = connection.JunoDoc__Password_Encrypted__c;
        }
        responseClass responseRec = new responseClass();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('POST');   
        req.setTimeout(60000);
        req.setEndpoint(connection.JunoDoc__End_Point_New_URL__c);
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
        req.setHeader('SOAPAction', '""');
        req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + userName + '</username><password>' + passWord + '</password></login></Body></Envelope>');        
        if (!Test.isRunningTest()){
            res =  new Http().send(req);
            if(res.getStatusCode() != 200){
                Dom.Document responseDocument = res.getBodyDocument();  
                Dom.Xmlnode rootElm = responseDocument.getRootElement(); 
                Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); 
                Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); 
                Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); 
                responseRec.response = false;
                responseRec.responsemessage = faultStringElm.getText();
            }
            else {
                Dom.Document responseDocument = res.getBodyDocument();
                Dom.Xmlnode rootElm = responseDocument.getRootElement();
                Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP);
                Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF);
                Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF);
                Dom.Xmlnode sessionId = resultElm.getChildElement('sessionId', NS_SF);
                Dom.Xmlnode serverUrlElm = resultElm.getChildElement('serverUrl', NS_SF);
                responseRec.response = true;
                responseRec.sessionId = string.valueOf(sessionId.getText());
                responseRec.responseServerUrl = string.valueOf(serverUrlElm.getText());
            }
        }
        else{
            responseRec.response = true;
            responseRec.sessionId = 'sessionId';
            responseRec.responseServerUrl = 'https://ap2.salesforce.com';
        }
        return responseRec;
        }
        catch(Exception e){
            system.debug('Error >>> '+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            return null;
        }
    }
  // responseUtilityController 
    
       
    public Static void parseMetadataQueryResponse(httpResponse queryResponseXML, 
                                                            String instanceURL, 
                                                            Integer batchProcessId, 
                                                            String selecteddestinationOrg, 
                                                            String objectName, 
                                                            String metadataObjectFields,
                                                            List<Sobject> sObjectRecords,
                                                            String destinationExternalId){
        //List<CloudSync1__JunoDoc__Junodoc_Analyze_Data__c> analyzeDataResults = new List<CloudSync1__JunoDoc__Junodoc_Analyze_Data__c>();
        
        JunoDoc__Junodoc_Analyze_Data__c analyzeDataRec = new JunoDoc__Junodoc_Analyze_Data__c();
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Source_Record_Id__c.isCreateable()){
            analyzeDataRec.Source_Record_Id__c = string.valueOf(sObjectRecords[0].get('id'));
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.MetaData_Fields_To_Compare__c.isCreateable()){
            analyzeDataRec.MetaData_Fields_To_Compare__c = metadataObjectFields;
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Destination_Data__c.isCreateable()){
            analyzeDataRec.Destination_Data__c = queryResponseXML.getbody();
            system.debug('jjjjjjjj'+analyzeDataRec.Destination_Data__c);
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Object__c.isCreateable()){
            analyzeDataRec.Object__c = objectName;
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Destination__c.isCreateable()){
            analyzeDataRec.Destination__c = selecteddestinationOrg;
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Batch_Id__c.isCreateable()){
            analyzeDataRec.Batch_Id__c = batchProcessId;
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.fields.Destination_External_Id__c.isCreateable()){
            analyzeDataRec.Destination_External_Id__c = destinationExternalId;
        }
        if(Schema.sObjectType.JunoDoc__Junodoc_Analyze_Data__c.isCreateable()){
            insert analyzeDataRec;
        }
        
        
     
    }
    
    
  
    public Static List<JunoDoc__Junodoc_Workbench_Results__c> parseUpsertResponse(httpResponse upsertResponseXML, 
                                                                                String instanceURL, 
                                                                                Integer batchProcessId, 
                                                                                String selecteddestinationOrg, 
                                                                                String objectName, 
                                                                                Map<Integer, String> recordMap, 
                                                                                String objectFields, 
                                                                                string upsertType, 
                                                                                String referenceObjectFieldName){
        List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
        map<String, string> failedRecordsMap = new map<String, string>();
        boolean failedRecord = false;
        integer k = 0;
        if(upsertResponseXML.getStatusCode() == 200){
            dom.Document resDoc = upsertResponseXML.getBodyDocument();
            dom.XmlNode root = resDoc .getRootElement();
            DOM.XmlNode bodyNode = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            DOM.XmlNode upsertResponse = bodyNode.getChildElement('upsertResponse','urn:enterprise.soap.sforce.com');
            DOM.XmlNode[] result = upsertResponse.getChildElements();
            for(DOM.XmlNode x : result){
                k = k + 1; 
                DOM.XmlNode created = x.getChildElement('created', 'urn:enterprise.soap.sforce.com');
                DOM.XmlNode idvalue = x.getChildElement('id', 'urn:enterprise.soap.sforce.com'); 
                DOM.XmlNode success = x.getChildElement('success', 'urn:enterprise.soap.sforce.com'); 
                DOM.XmlNode errors = x.getChildElement('errors', 'urn:enterprise.soap.sforce.com');
                if(errors != null){
                    DOM.XmlNode errorsfields = errors.getChildElement('fields', 'urn:enterprise.soap.sforce.com');
                    DOM.XmlNode errorsmessage = errors.getChildElement('message', 'urn:enterprise.soap.sforce.com');
                    DOM.XmlNode errorsstatusCode = errors.getChildElement('statusCode', 'urn:enterprise.soap.sforce.com');    
                    JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                    workBenchRecord.Status__c = 'Failed';
                    workBenchRecord.Result_From__c = 'Upsert';
                    workBenchRecord.Fields__c = objectFields;
                    if(upsertType == 'Lookup'){
                        workBenchRecord.Is_Lookup__c = true;
                        workBenchRecord.Reference_Object_Field_Name__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'LookUp';
                    } 
                    if(upsertType == 'Parent'){
                        workBenchRecord.Is_Parent__c = true;   
                        workBenchRecord.Record_Source__c = 'Parent';
                    } 
                    if(upsertType == 'Child'){
                        workBenchRecord.Parent_Field__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'Child';
                    } 
                    workBenchRecord.Destination_URL__c = instanceURL;
                    workBenchRecord.Migration_Type__c = 'MGraph';
                    workBenchRecord.Batch_Process_Id__c = batchProcessId;
                    workBenchRecord.Object_Name__c = objectName;  
                    workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                    workBenchRecord.Error_Message__c = errorsmessage.getText();
                    if(recordMap.get(k) != null){
                        workBenchRecord.Source_Record_Id__c = recordMap.get(k);
                        failedRecordsMap.put(recordMap.get(k), recordMap.get(k));
                    }  
                    workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcessId + workBenchRecord.Record_Source__c;
                    cloudSyncResults.add(workBenchRecord);
                }
                else if(idvalue != null){
                    JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                    workBenchRecord.Status__c = 'Success';
                    workBenchRecord.Result_From__c = 'Upsert';
                    workBenchRecord.Fields__c = objectFields;
                    if(upsertType == 'Lookup'){
                        workBenchRecord.Is_Lookup__c = true;
                        workBenchRecord.Reference_Object_Field_Name__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'LookUp';
                    } 
                    if(upsertType == 'Parent'){
                        workBenchRecord.Is_Parent__c = true;   
                        workBenchRecord.Record_Source__c = 'Parent';
                    } 
                    if(upsertType == 'Child'){
                        workBenchRecord.Parent_Field__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'Child';
                    } 
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Record_Id__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Record_Id__c.isCreateable()){
                            workBenchRecord.Destination_Record_Id__c = idvalue.getText();
                    }
                    
                    workBenchRecord.Destination_URL__c = instanceURL;
                    workBenchRecord.Migration_Type__c = 'MGraph';
                    workBenchRecord.Batch_Process_Id__c = batchProcessId;
                    workBenchRecord.Object_Name__c = objectName;  
                    workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                    //workBenchRecord.Error_Message__c = errorsmessage.getText();
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isCreateable()){
                            workBenchRecord.Error_Message__c = '';
                    }
                    
                    if(recordMap.get(k) != null){
                        workBenchRecord.Source_Record_Id__c = recordMap.get(k);
                        failedRecordsMap.put(recordMap.get(k), recordMap.get(k));
                    }  
                    workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcessId + workBenchRecord.Record_Source__c;
                    cloudSyncResults.add(workBenchRecord);
                }
            }
        }
        else if(upsertResponseXML.getStatusCode() == 500){
            for(String sourceRecord : recordMap.values()){
                JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Status__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Status__c.isCreateable()){
                        workBenchRecord.Status__c = 'Failed';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Result_From__c.isCreateable()){
                        workBenchRecord.Result_From__c = 'Upsert';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Fields__c.isUpdateable()
                    && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Fields__c.isCreateable()){
                        workBenchRecord.Fields__c = objectFields;
                }
                if(upsertType == 'Lookup'){
                    
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Lookup__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Lookup__c.isCreateable()){
                            workBenchRecord.Is_Lookup__c = true;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Reference_Object_Field_Name__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Reference_Object_Field_Name__c.isCreateable()){
                            workBenchRecord.Reference_Object_Field_Name__c = referenceObjectFieldName;
                    }
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Record_Source__c.isCreateable()){
                            workBenchRecord.Record_Source__c = 'LookUp';
                    }
                    
                } 
                if(upsertType == 'Parent'){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Is_Parent__c.isCreateable()){
                    workBenchRecord.Is_Parent__c = true; 
                }
                      
                    workBenchRecord.Record_Source__c = 'Parent';
                } 
                if(upsertType == 'Child'){
                    if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Parent_Field__c.isUpdateable()
                        && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Parent_Field__c.isCreateable()){
                            workBenchRecord.Parent_Field__c = referenceObjectFieldName;
                    }
                    
                    workBenchRecord.Record_Source__c = 'Child';
                }
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_URL__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_URL__c.isCreateable()){
                    workBenchRecord.Destination_URL__c = instanceURL;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Migration_Type__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Migration_Type__c.isCreateable()){
                    workBenchRecord.Migration_Type__c = 'MGraph';
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Batch_Process_Id__c.isCreateable()){
                    workBenchRecord.Batch_Process_Id__c = batchProcessId;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Object_Name__c.isCreateable()){
                    workBenchRecord.Object_Name__c = objectName;  
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Org__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Destination_Org__c.isCreateable()){
                    workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Error_Message__c.isCreateable()){
                    workBenchRecord.Error_Message__c = upsertResponseXML.getbody();
                }
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.Source_Record_Id__c.isCreateable()){
                    workBenchRecord.Source_Record_Id__c = sourceRecord;
                }
                
                if(Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isUpdateable()
                   && Schema.sObjectType.JunoDoc__Junodoc_Workbench_Results__c.fields.External_Id__c.isCreateable()){
                    workBenchRecord.External_Id__c = sourceRecord +  workBenchRecord.Result_From__c + batchProcessId + workBenchRecord.Record_Source__c;
                }
                
                cloudSyncResults.add(workBenchRecord);    
            }
        }
        return cloudSyncResults;
    } 
    
    
     public Static List<JunoDoc__Junodoc_Workbench_Results__c> parseQueryResponse(httpResponse queryResponseXML, 
                                                                                String instanceURL, 
                                                                                Integer batchProcessId, 
                                                                                String selecteddestinationOrg, 
                                                                                String objectName, 
                                                                                Map<String, String> recordExternalIdMap, 
                                                                                String objectFields, 
                                                                                String upsertType, 
                                                                                String referenceObjectFieldName){
        List<JunoDoc__Junodoc_Workbench_Results__c> cloudSyncResults = new List<JunoDoc__Junodoc_Workbench_Results__c>();
        if(queryResponseXML.getStatusCode() == 200){
            dom.Document resDoc = queryResponseXML.getBodyDocument();
            dom.XmlNode root = resDoc .getRootElement();
            DOM.XmlNode bodyNode = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            DOM.XmlNode queryResponse = bodyNode.getChildElement('queryResponse','urn:enterprise.soap.sforce.com');
            DOM.XmlNode result = queryResponse.getChildElement('result','urn:enterprise.soap.sforce.com');
            DOM.XmlNode[] resultChild = result.getChildElements();
            for(DOM.XmlNode x : resultChild){ 
                if(x.getName() == 'records'){
                    string destinationRecordId = '';
                    string destinationExternalId = '';
                    DOM.XmlNode[] Record = x.getChildElements();
                    for(DOM.XmlNode recordFields : Record){
                        if(recordFields.getName() == 'Id'){
                            destinationRecordId = recordFields.getText();  
                        }
                        else{
                            destinationExternalId = recordFields.getText();
                        }
                    }
                    JunoDoc__Junodoc_Workbench_Results__c workBenchRecord = new JunoDoc__Junodoc_Workbench_Results__c();
                    workBenchRecord.Status__c = 'Success';
                    workBenchRecord.Result_From__c = 'Query';
                    if(objectFields != null && objectFields != ''){
                        workBenchRecord.Fields__c = objectFields;  
                    } 
                    workBenchRecord.Destination_Record_Id__c = destinationRecordId;
                    if(recordExternalIdMap.get(destinationExternalId) != null){
                        workBenchRecord.Source_Record_Id__c = recordExternalIdMap.get(destinationExternalId);
                    }
                    if(upsertType == 'Lookup'){
                        workBenchRecord.Is_Lookup__c = true;
                        workBenchRecord.Reference_Object_Field_Name__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'LookUp';
                    } 
                    if(upsertType == 'Parent'){
                        workBenchRecord.Is_Parent__c = true;   
                        workBenchRecord.Record_Source__c = 'Parent';
                    } 
                    if(upsertType == 'Child'){
                        workBenchRecord.Parent_Field__c = referenceObjectFieldName;
                        workBenchRecord.Record_Source__c = 'Child';
                    } 
                    workBenchRecord.Destination_URL__c = instanceURL;
                    workBenchRecord.Migration_Type__c = 'MGraph';
                    workBenchRecord.Batch_Process_Id__c = batchProcessId;
                    workBenchRecord.Object_Name__c = objectName;  
                    workBenchRecord.Destination_Org__c = selecteddestinationOrg;
                    workBenchRecord.Error_Message__c = '';
                    workBenchRecord.External_Id__c = workBenchRecord.Source_Record_Id__c +  workBenchRecord.Result_From__c + batchProcessId + workBenchRecord.Record_Source__c;
                    cloudSyncResults.add(workBenchRecord);
                }
             }
        }
        return cloudSyncResults;
    } 
    
 
}
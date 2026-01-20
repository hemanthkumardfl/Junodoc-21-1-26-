global without sharing class MergeFieldsController {
    //global String mergeFieldData = 'Account name is {!Account__r.Name} and FAX is {!Fax} and Phone is {!Phone}';
    
    global String recordId{get;set;}
    global String SObjectName{get;set;}
    
    global String m_MergeData(String mergeFieldData){
        Set<String> fieldNames = new Set<String>(); 
        Map<String, String> fieldMapping = new Map<String, String>();
        mergeFieldData = mergeFieldData.replace('{!',' {!');
        mergeFieldData = mergeFieldData.replace('}',' }');
        
        if(mergeFieldData.contains('{!#User.')){
            string qry = 'select ';
            mergeFieldData = mergeFieldData.replace('{!#User.','##user##');
            string[] strlist = mergeFieldData.split('##user##');
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
            sobject users = Database.query(qry);
            system.debug(' users ' + qry);
            system.debug(' user record ' + users);
            if(!userfields.isEmpty()){
                for(string str : userfields){
                    system.debug('######'+str+'###########');
                    mergeFieldData = mergeFieldData.replace('##user##'+str+'}',''+users.get(str.replace(' ','')));  
                }
            }
        }
        
        for(String s : mergeFieldData.split(' ')){
             system.debug(' emails ' + s);
            if(s.StartsWith('{!')){ 
                
                string st = s.subString(2,s.length()-0);
                st = st.replace('<strong>','');
                st = st.replace('</strong>','');
                if(!st.contains('$') && !st.contains('()') 
                   && !st.contains('VALUE(') && !st.contains('IF(')
                  && !st.contains('SUM(') && !st.contains('AVG('))
                fieldNames.add(st);
            }
        }
        
        system.debug('fieldNames--->'+fieldNames);
        
        if(fieldNames.size() > 0){
        
        String sObjectQuery = 'SELECT Id';
        Integer i=0;
        
        for(String s : fieldNames){
            if(i == fieldNames.size()){
                if(s.toUpperCase()!='ID'){
                    sObjectQuery = sObjectQuery + s + ' ';    
                }                
            }                
            else{
                if(s.toUpperCase()!='ID'){
                    sObjectQuery = sObjectQuery + ', '+ s;    
                }                
            }
                
                
            i++;
        }

        sObjectQuery = sObjectQuery + ' FROM '+SObjectName+' where id =:recordId LIMIT 1';
        system.debug(sObjectQuery + '**** sObjectQuery');
        sObject querySOject = DataBase.query(String.escapeSingleQuotes(sObjectQuery));
    System.debug('------querySOject--------'+querySOject);
    //System.debug('--------------'+fieldNames);
        for(String s : fieldNames){
            if(!s.contains('.')){
                if(querySOject.get(s) != null){
                    
                    if(s.trim() == 'Date__c'){
                    Date DateValue = Date.valueof(querySOject.get('Date__c'));
                    
                    Datetime D = Datetime.newInstance(DateValue.year(),DateValue.Month(),DateValue.day());
                    String dateOutput = D.format('MM/dd/yyyy');
                    mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', dateOutput );   
                    }
                     
                    mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', String.valueOf(querySOject.get(s)));
                    }
                    else{
                    if(s.trim() == 'Date__c'){
                    Date DateValue = date.today();
                    
                    Datetime D = Datetime.newInstance(DateValue.year(),DateValue.Month(),DateValue.day());
                    String dateOutput = D.format('MM/dd/yyyy');
                    mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', dateOutput );   
                    }                   
                    mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ''); 
                  }
            }else{
                List<String> splitList = s.split('\\.');
                string ReleationField = '';
                if(splitList.size() > 3){
                    if(splitList[0].contains('__r')){
                        ReleationField = splitList[0].replace('__r','__c');
                    }
                    else{
                        ReleationField = splitList[0]+'Id';
                    }
                                 
                    if(splitList.size()>0 && querySOject.get(ReleationField) != null){
                        if(String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).getSobject(s.split('\\.')[2]).get(s.split('\\.')[3])) == null || String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).getSobject(s.split('\\.')[2]).get(s.split('\\.')[3])) == ''){
                            mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                        }
                        else{
                            mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }',String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).getSobject(s.split('\\.')[2]).get(s.split('\\.')[3]))); 
                        }
                    }else{
                        mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                        
                    }
                }
                else if(splitList.size() > 2){
                    if(splitList[0].contains('__r')){
                        ReleationField = splitList[0].replace('__r','__c');
                    }
                    else{
                        ReleationField = splitList[0]+'Id';
                    }

                    system.debug('sss--->'+s);
                    if(splitList.size()>0 && querySOject.get(ReleationField) != null){
                        if( String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]))!=null ){
                            if(String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).get(s.split('\\.')[2])) == null || String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).get(s.split('\\.')[2])) == ''){
                                mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                            }
                            else{ 
                                mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', String.valueOf(querySOject.getSobject(s.split('\\.')[0]).getSobject(s.split('\\.')[1]).get(s.split('\\.')[2]))); 
                            }                            
                        }
                    }else{
                        mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                        
                    }
                }
                else{
                
                    if(splitList[0].contains('__r')){
                        ReleationField = splitList[0].replace('__r','__c');
                    }
                    else{
                        ReleationField = splitList[0]+'Id';
                    }
                                 
                    if(splitList.size()>0 && querySOject.get(ReleationField) != null){
                        if(String.valueOf(querySOject.getSobject(s.split('\\.')[0]).get(s.split('\\.')[1])) == null || String.valueOf(querySOject.getSobject(s.split('\\.')[0]).get(s.split('\\.')[1])) == ''){
                            mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                        }
                        else{
                            mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', String.valueOf(querySOject.getSobject(s.split('\\.')[0]).get(s.split('\\.')[1]))); 
                        }
                    }else{
                        mergeFieldData = mergeFieldData.replace('{!'+s.trim()+' }', ' ');
                        
                    }
                }
            }
        }
            mergeFieldData = mergeFieldData.replace(' }','}');
        return mergeFieldData;
        }
        else{
        return mergeFieldData;  
        }
    }
}
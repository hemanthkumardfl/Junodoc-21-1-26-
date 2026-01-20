public class PostAction_AC{   
    
    public class FieldData{
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        @AuraEnabled public String sObjectType;
    }
    
    @AuraEnabled
    public static List<FieldData> getFields(String rid){
        List <FieldData> FD = new List<FieldData>();
        String docTempPobj = [SELECT id, JunoDoc__Parent_Object__c FROM JunoDoc__Doc_Template__c WHERE id =: rid].JunoDoc__Parent_Object__c;
        SObjectType accountType = Schema.getGlobalDescribe().get(docTempPobj);
        List<Schema.SObjectType> obj = new List<Schema.SObjectType>{ accountType};
            
            for(Schema.SObjectType objType: obj){
                for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                    FieldData F = new FieldData();
                    F.value = ''+fld.getDescribe().getName();
                    F.label = ''+fld.getDescribe().getLabel();
                    F.sObjectType = ''+objType.getDescribe().getName();
                    FD.add(F);
                }
            }
        system.debug('FD---->'+FD);
        return FD;
    }
    
    /*public class UpdateList{
        @AuraEnabled public String value;
        @AuraEnabled public String label;
    }
    
    @AuraEnabled
    public static List<UpdateList> getUpdateTypes(){
        List<UpdateList> UpdLst = new List<UpdateList>();
        UpdateList Up = new  UpdateList();
        Up.value = '';
        Up.label = 'None';
        UpdLst.add(Up);
        UpdateList Upd = new  UpdateList();
        Upd.value = 'PDF Generate';
        Upd.label = 'PDF Generate';
        UpdLst.add(Upd);
        UpdateList Upd2 = new  UpdateList();
        Upd2.value = 'PDF Sent';
        Upd2.label = 'PDF Sent';
        UpdLst.add(Upd2);
        system.debug('UpdLst---->'+UpdLst);
        return UpdLst;
    }*/
    
    @AuraEnabled
    public static List<PostActData> getPostActs(String rid){
        List <JunoDoc__Post_Action__c> PostAC = [SELECT id, Name, JunoDoc__Field_Type__c, JunoDoc__Field_Values__c, JunoDoc__Junodoc_Templates__c, JunoDoc__Generate_Check__c, JunoDoc__Mail_Check__c, JunoDoc__Attach_Check__c FROM JunoDoc__Post_Action__c WHERE JunoDoc__Junodoc_Templates__c =: rid];
        List<PostActData> PostAct = new List<PostActData>();
        String docTempPobj = [SELECT id, JunoDoc__Parent_Object__c FROM JunoDoc__Doc_Template__c WHERE id =: rid].JunoDoc__Parent_Object__c;
        SObjectType accountType = Schema.getGlobalDescribe().get(docTempPobj);
        
        List<Schema.SObjectType> obj = new List<Schema.SObjectType>{ accountType};
            List<Schema.PicklistEntry> PickOptions = new List<Schema.PicklistEntry>();
        for(Schema.SObjectType objType: obj){
            for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                for(JunoDoc__Post_Action__c Post : PostAC){
                    PostActData PAD = new PostActData();
                    if(Post.Name == ''+fld.getDescribe().getName()){
                        List <PickValues> PV = new List <PickValues>();
                        if(Post.JunoDoc__Field_Type__c == 'PICKLIST'){ //|| Post.JunoDoc__Field_Type__c == 'MULTIPICKLIST'){
                            PickOptions = fld.getDescribe().getPickListValues();
                            for (Schema.PicklistEntry PickOpts : PickOptions) {
                                PickValues PikValues = new PickValues();
                                PikValues.pickvalue = ''+PickOpts.getValue();
                                PikValues.picklabel = ''+PickOpts.getLabel();
                                PV.add(PikValues);
                                system.debug('PV-------->'+PV);
                            }
                            PAD.SelectedValue = Post.Name;
                            //if(Post.JunoDoc__Field_Type__c == 'PICKLIST'){
                                PAD.value = Post.JunoDoc__Field_Values__c;
                            /*}
                            if(Post.JunoDoc__Field_Type__c == 'MULTIPICKLIST'){
                                String FieldVals = Post.JunoDoc__Field_Values__c;
                                List<PickValues> MultiPickVals = new List<PickValues>();
                                for(PickValues PVal : PV){
                                    if(FieldVals.contains(PVal.pickvalue)){
                                        PickValues MultiPic = new PickValues();
                                        MultiPic.pickvalue = PVal.pickvalue;
                                        MultiPic.picklabel = PVal.picklabel;
                                        MultiPickVals.add(MultiPic);
                                    }
                                }
                                PAD.MultiPickValues = MultiPickVals;
                            }*/
                            PAD.FieldType = Post.JunoDoc__Field_Type__c;
                            PAD.PickValues = PV;
                            PAD.GenerateCheck = boolean.valueof(Post.JunoDoc__Generate_Check__c);
                            PAD.AttachCheck =  boolean.valueof(Post.JunoDoc__Attach_Check__c);
                            PAD.MailCheck =  boolean.valueof(Post.JunoDoc__Mail_Check__c);
                            //PAD.SelectedUpdate = Post.Which_Update__c;
                            //PAD.UpdateList = PostAction_AC.getUpdateTypes();
                            system.debug('PV123-------->'+PV);
                        }
                        else if(Post.JunoDoc__Field_Type__c == 'BOOLEAN'){
                            PAD.SelectedValue = Post.Name;
                            PAD.Check = Boolean.valueof(Post.JunoDoc__Field_Values__c);
                            PAD.FieldType = Post.JunoDoc__Field_Type__c;
                            PAD.GenerateCheck = boolean.valueof(Post.JunoDoc__Generate_Check__c);
                            PAD.AttachCheck = boolean.valueof(Post.JunoDoc__Attach_Check__c);
                            PAD.MailCheck = boolean.valueof(Post.JunoDoc__Mail_Check__c);
                            //PAD.SelectedUpdate = Post.Which_Update__c;
                            //PAD.UpdateList = PostAction_AC.getUpdateTypes();
                        }
                        else{
                            PAD.SelectedValue = Post.Name;
                            PAD.value = Post.JunoDoc__Field_Values__c;
                            PAD.FieldType = Post.JunoDoc__Field_Type__c;
                            PAD.GenerateCheck = boolean.valueof(Post.JunoDoc__Generate_Check__c);
                            PAD.AttachCheck = boolean.valueof(Post.JunoDoc__Attach_Check__c);
                            PAD.MailCheck = boolean.valueof(Post.JunoDoc__Mail_Check__c);
                            //PAD.SelectedUpdate = Post.Which_Update__c;
                            //PAD.UpdateList = PostAction_AC.getUpdateTypes();
                        }
                        PostAct.add(PAD);
                    }
                }
            }
        }
        /* for(Post_Action__c Post: PostAC){
PostActData PAD = new PostActData();
if(Post.Field_Type__c == 'PICKLIST'){
PAD.SelectedValue = Post.Name;
PAD.value = Post.Field_Value__c;
PAD.FieldType = Post.Field_Type__c;
PAD.PickValues = PickValues;
}
else if(Post.Field_Type__c == 'BOOLEAN'){
PAD.SelectedValue = Post.Name;
PAD.Check = Boolean.valueof(Post.Field_Value__c);
PAD.FieldType = Post.Field_Type__c;
}
else{
PAD.SelectedValue = Post.Name;
PAD.value = Post.Field_Value__c;
PAD.FieldType = Post.Field_Type__c;
}
PostAct.add(PAD);
}*/
        system.debug('PostAct----->'+PostAct);
        return PostAct;
    }
    
    @AuraEnabled
    public static String ChangeDataType(String docList, String rid){
        system.debug(docList);
        List<PostActData> resultlist = (List<PostActData>)JSON.deserialize(docList, List<PostActData>.class);
        String docTempPobj = [SELECT id, JunoDoc__Parent_Object__c FROM JunoDoc__Doc_Template__c WHERE id =: rid].JunoDoc__Parent_Object__c;
        SObjectType accountType = Schema.getGlobalDescribe().get(docTempPobj);
        
        List<Schema.SObjectType> obj = new List<Schema.SObjectType>{ accountType};
            List<Schema.PicklistEntry> PickOptions = new List<Schema.PicklistEntry>();
        for(Schema.SObjectType objType: obj){
            for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
                for(PostActData PostAct : resultlist){
                    if(PostAct.SelectedValue == ''+fld.getDescribe().getName()){
                        List <PickValues> PV = new List <PickValues>();
                        PostAct.FieldType = ''+fld.getDescribe().getType();
                        if(PostAct.Check == null){
                            PostAct.Check = false;
                        }
                        if(PostAct.FieldType == 'PICKLIST'){ //|| PostAct.FieldType == 'MULTIPICKLIST'){
                            PickOptions = fld.getDescribe().getPickListValues();
                            for (Schema.PicklistEntry PickOpts : PickOptions) {
                                PickValues PikValues = new PickValues();
                                PikValues.pickvalue = ''+PickOpts.getValue();
                                PikValues.picklabel = ''+PickOpts.getLabel();
                                PV.add(PikValues);
                                system.debug('PV-------->'+PV);
                            }
                            PostAct.PickValues = PV;
                            system.debug('PV123-------->'+PV);
                            
                        }
                        
                    }
                }
            }
        }
        system.debug('resultlist---->'+resultlist);
        String PD = JSON.serialize(resultlist);
        system.debug('PD---->'+PD);
        return PD;
    }
    
    public class PostActData{
        @AuraEnabled public String value;
        @AuraEnabled public String SelectedValue;
        @AuraEnabled public String FieldType;
        @AuraEnabled public Boolean Check;
        @AuraEnabled public List<PickValues> PickValues;
        @AuraEnabled public boolean GenerateCheck;
        @AuraEnabled public boolean MailCheck;
        @AuraEnabled public boolean AttachCheck;
        //@AuraEnabled public List<PickValues> MultiPickValues;
        //@AuraEnabled public String SelectedUpdate;
        // @AuraEnabled public List<UpdateList> UpdateList;
    }
    
    public class PickValues{
        @AuraEnabled public String pickvalue;
        @AuraEnabled public String picklabel;
    }
    
    @AuraEnabled
    public static String savePostactList(String docList, String rid){
        String result;
        List <JunoDoc__Post_Action__c> PostAC = [SELECT id, Name, JunoDoc__Field_Type__c, JunoDoc__Field_Values__c, JunoDoc__Junodoc_Templates__c,  JunoDoc__Generate_Check__c, JunoDoc__Mail_Check__c, JunoDoc__Attach_Check__c FROM JunoDoc__Post_Action__c WHERE JunoDoc__Junodoc_Templates__c =: rid];
        system.debug('PostAC---->'+PostAC);
        system.debug('PostAC_size---->'+PostAC.size());
        if(PostAC.size()>0 && docList == '[]'){
            delete PostAC; 
            result =  'ERROR6';
        }
        else if(docList == '[]'){
            result =  'ERROR5';
        }
       // delete PostAC;
        system.debug('docList---->'+docList);
        
        List<PostActData> resultlist = (List<PostActData>)JSON.deserialize(docList, List<PostActData>.class);
        system.debug('resultlist---->'+resultlist);
        
        List<JunoDoc__Post_Action__c> PostActionRec = new List<JunoDoc__Post_Action__c>();
        Map<String, String> DuplicateMap = new Map<String, String>();
        List<String> DuplicateList = new List<String>();
        for(PostActData PostAct : resultlist){
            JunoDoc__Post_Action__c PostActRec = new JunoDoc__Post_Action__c();
            if(PostAct.value == '' && PostAct.SelectedValue == ''){
                result =  'ERROR3';
            }
            else if(PostAct.SelectedValue != '' && PostAct.value != ''){
                PostActRec.Name = PostAct.SelectedValue;
                PostActRec.JunoDoc__Field_Type__c = PostAct.FieldType;
                if(PostActRec.JunoDoc__Field_Type__c == 'BOOLEAN'){
                    PostActRec.JunoDoc__Field_Values__c = String.valueof(PostAct.check);
                }
                else{
                    PostActRec.JunoDoc__Field_Values__c = PostAct.value;
                }
                if(DuplicateMap.containskey(PostAct.SelectedValue)){
                    DuplicateList.add(PostAct.SelectedValue);
                }
                else{
                    DuplicateMap.put(PostAct.SelectedValue,PostActRec.JunoDoc__Field_Values__c);
                }
                PostActRec.JunoDoc__Junodoc_Templates__c = rid;
                PostActRec.JunoDoc__Generate_Check__c = ''+PostAct.GenerateCheck;
                PostActRec.JunoDoc__Attach_Check__c = ''+PostAct.AttachCheck;
                PostActRec.JunoDoc__Mail_Check__c = ''+PostAct.MailCheck;
                //PostActRec.Which_Update__c = PostAct.SelectedUpdate;
                PostActionRec.add(PostActRec);
                result =  'SUCCESS';
            }
            else if(PostAct.SelectedValue == ''){
                result =  'ERROR1';
            }
            else if(PostAct.value == '' && PostAct.check == null){
                result =  'ERROR2';
            }
            else if(PostAct.value == ''){
                if(PostAct.FieldType != 'BOOLEAN'){
                    result =  'ERROR2';
                }
                else{
                    PostActRec.name = PostAct.SelectedValue;
                    PostActRec.JunoDoc__Field_Type__c = PostAct.FieldType;
                    PostActRec.JunoDoc__Field_Values__c = String.valueof(PostAct.check);
                    PostActRec.JunoDoc__Junodoc_Templates__c = rid;
                    PostActRec.JunoDoc__Generate_Check__c = ''+PostAct.GenerateCheck;
                    PostActRec.JunoDoc__Attach_Check__c = ''+PostAct.AttachCheck;
                    PostActRec.JunoDoc__Mail_Check__c = ''+PostAct.MailCheck;
                    //PostActRec.Which_Update__c = PostAct.SelectedUpdate;
                    PostActionRec.add(PostActRec);
                    result =  'SUCCESS';
                }
            }
            
        }
        system.debug('result----->'+result);
        if(DuplicateList.size()>0){
            result =  'ERROR4';
        }
        else{
            if(!result.contains('ERROR')){
                delete PostAC;
                insert PostActionRec;
                result =  'SUCCESS';
            }
        }
        return result;
    }
}
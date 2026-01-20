public class multiselect_AC {
     public string  sendCC                              {get;set;}
     public string  userCC                              {get;set;}
     public string  userMails                           {get;set;}
    public string inputtext{get;set;}
    public list<user> userlist {get;set;}
    public multiselect_AC(){
        userlist = [select id, name,email from user limit 1000];
    }
    public void userValue(){    
        for(user q:userlist){
            if(inputtext == q.name){
                if(userCC != null){
                    userCC = userCC +', '+q.email;
                    if(sendCC != null){
                        sendCC = sendCC +', '+userCC;
                    }
                }
                else{
                    userCC = q.email;
                    sendCC = sendCC +', '+ userCC;  
                }
            }
        }
}   
}
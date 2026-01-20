({
    addAccountRecord: function(component, event) {
        
        
        var action = component.get("c.getEmail");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            var results = component.get("v.results");
            //alert("results1"+component.get("v.results"));
            console.log("results1"+component.get("v.results"));
            for(var i=0;i<result.length;i++){
                results.push(result[i]);
            }
            component.set("v.results", results);
            component.set("v.Addrow",true);
        });
        $A.enqueueAction(action);
        
        
        //alert(component.get("v.accountList"));
    },
    search : function(component, event, helper) {
        var input, filter, ul, li, a, i, txtValue;
        input = document.getElementById("myInput");
        filter = input.value.toUpperCase();
        ul = document.getElementById("myUL");
        li = ul.getElementsByTagName("li");
        for (i = 0; i < li.length; i++) {
            a = li[i].getElementsByTagName("span")[2];
            txtValue = a.textContent || a.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
                li[i].style.display = "";
            } else {
                li[i].style.display = "none";
            }
        }
    }
    
})
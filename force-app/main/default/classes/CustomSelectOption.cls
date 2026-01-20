public class CustomSelectOption {
    @AuraEnabled public String value { get; set; }
    @AuraEnabled public String label { get; set; }

    public CustomSelectOption(String value, String label) {
        this.value = value;
        this.label = label;
    }
}
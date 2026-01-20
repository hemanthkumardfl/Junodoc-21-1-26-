public class Barcode_AC {
     public string imageUrl { get; set; }
    public Barcode_AC(){
           imageUrl='https://www.barcodesinc.com/generator/image.php?code=8806090360770&style=325&type=C128B&width=200&height=50&xres=1&font=3';
    }
    // Determines if the check digit should be generated
    // If true, scanners must be enabled to use it
    public Boolean shouldCheckDigit { get; set; }
    // The source string to use. Currently only supports
    // the characters in the "keys" string. Do not use '*'.
    public String sourceCodeValue   { get; set; }

    // The index for supported characters.
    static String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';

    // The binary representation of each character, 16 bits each.
    static String[] values = new String[] {
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

    // Renders the barcode on the screen
    public String[] getBarCodeBars() {
        shouldCheckDigit = false;
        sourceCodeValue = '8806090360770';
        return generateCode39(sourceCodeValue, shouldCheckDigit).split('');
        
    }

    // Returns a string in case we also want to debug the output.
    String generateCode39(String source, Boolean checkDigit) {
        
        // Output
        String[] result = new String[0];

        Integer index,      // Temp variable
                total = 0;  // Checksum calculation

        // Avoid System.NullPointerException
        source = source == null? '': source;
        // Start character is *
        result.add(values[keys.indexOf('*')]);
        // For each character in source
        for(String sourceChar: source.toUpperCase().split('')) {
            // Valid character, add to checksum and output bits
            if((index = keys.indexOf(sourceChar)) > -1) {
                result.add(values[index]);
                total += index;
            }
        }
        // Add the check digit
        if(checkDigit) {
            result.add(values[Math.mod(total, 43)]);
        }
        // Add the stop character
        result.add(values[keys.indexOf('*')]);
        // Join as string
        return String.join(result,'');
    }

}
@isTest
public class Barcode_AC_Test {
    @isTest
    static void testGetBarCodeBars() {
        Barcode_AC barcode = new Barcode_AC();       
        String[] barCodeBars = barcode.getBarCodeBars();    
        System.assertNotEquals(null, barCodeBars);
        System.assertNotEquals(0, barCodeBars.size());
      }
}
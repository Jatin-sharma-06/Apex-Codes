public with sharing class Assignment2BasicApexTasks {
    
    /*  Print Pattern : A
                        ZY
                        BCD
                        XWVU
                        EFGHI
    */
    public void pattern1() {
        String f_alphabet = 'A';
        String r_alphabet = 'Z';        

        for(Integer i = 1; i <= 5; i++) {
            
            String row = '';

            for(Integer j = 1; j <= i; j++) {

                if(Math.mod(i, 2) <> 0) {
                    //code
                    row += f_alphabet;
                    Integer f_asciiValue = f_alphabet.charAt(0);
                    f_asciiValue++;
                    f_alphabet = String.fromCharArray(new List<Integer>{f_asciiValue});
                }
                
                else {
                    //code
                    row += r_alphabet;
                    Integer r_asciiValue = r_alphabet.charAt(0);
                    r_asciiValue--;
                    r_alphabet = String.fromCharArray(new List<Integer>{r_asciiValue});
                }
            }

            System.debug(row);
        }
    }

    /*  Print Pattern : * * * * * * * * * * *

                        * * * *       * * * *

                        * * *           * * *

                        * *               * *

                        *                   *
    */
}


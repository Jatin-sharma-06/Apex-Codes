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

    public void starPattern() {        
        for(Integer i = 5; i>=1; i--) {
            String str = '';
            for (Integer j = 1; j <= i; j++) {
                str += '*';
            }
            for (Integer j = 1; j <= 2*(5-i) + 1; j++) {
                if( i == 5 && j == 1) {
                    str += '*';
                } else {
                    str += '_';  
                }               
            }
            for (Integer j = 1; j <= i; j++) {
                str += '*';
            }
            System.debug(str);
        }
    }

    // 3. Print the count of each alphabet in any paragraph taken

    public static Map<String, Integer> countAlphabet(String paragraph) {
        Map<String, Integer> alphabet = new Map<String, Integer>();
        paragraph = paragraph.toLowerCase();

        for (Integer i = 0; i < paragraph.length(); i++) {
            String letter = paragraph.substring(i, i+1);

            if (letter >= 'a' && letter <= 'z') {
                if (alphabet.containsKey(letter)) {
                    alphabet.put(letter, alphabet.get(letter) + 1);
                } else {
                    alphabet.put(letter, 1);
                }
            }
        }
        return alphabet;
    }


    // using array
    // public Integer[] countAlphabet(String paragraph) {

    //     if (String.isBlank(paragraph)) {
    //         return null;
    //     }

    //     Integer[] alphabetCount = new Integer[26];
    //     for (Integer i = 0; i < 26; i++) {
    //         alphabetCount[i] = 0;
    //     }

    //     paragraph = paragraph.toLowerCase();

    //     for (Integer i = 0; i < paragraph.length(); i++) {

    //         Integer asciiValue = paragraph.charAt(i);

    //         if (asciiValue >= 97 && asciiValue <= 122) {

    //             Integer index = asciiValue - 97;
    //             alphabetCount[index]++;

    //         }
    //     }

    //     return alphabetCount;
    // }

    // 4. Take two different list of Integers and sort them in one list without using any predefined methods.
 
    public void mergeAndSortList(List<Integer> list1, List<Integer> list2){
        //Merge both lists into one
        List<Integer> mergedList = new List<Integer>();
        
        for(Integer num : list1) {
            mergedList.add(num);
        }
        for(Integer num : list2) {
            mergedList.add(num);
        }
        
        Integer n = mergedList.size();
        // Sorting using bubble sort
        for(Integer i = 0; i < n; i++) {
            for(Integer j = 0; j < n - i - 1; j++) {
                if(mergedList[j] > mergedList[j + 1]) {
                    Integer temp = mergedList[j];
                    mergedList[j] = mergedList[j + 1];
                    mergedList[j + 1] = temp;
                }
            }
        }
        
        System.debug('Sorted Merged List: ' + mergedList);
    }
}
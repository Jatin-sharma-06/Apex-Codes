public with sharing class Assignment1BasicApexTasks {
    // 1. Reverse a String
    public String reverseString(String inputString) {
        if(inputString == null) {
            return null;
        }

        String reverseString = '';
        
        for(Integer i = inputString.length() - 1; i >= 0; i--) {
            reverseString += inputString.substring(i, i+1);
        }
        return reverseString; 
    }

    // 2. Check Palindrome

    // Using string
    public void checkPalindromeOfString(String inputString){
        if(String.isEmpty(inputString)) { 
            System.debug('Null Value');
        } else if(inputString == reverseString(inputString)) {
            System.debug(inputString + ' is a Palindrome');
        } else {
            System.debug(inputString + ' is not a Palindrome');
        }
    }

    // Using Integer
    // public void checkPalindromeOfInteger(Integer inputNumber){
    //     Integer temp;
    //     Integer 
    //     for(Integer i = 0; i < inputNumber.length(); i++) {
    //         temp = inputNumber;
            
    //     }
        
    // }


    // 3. Count Vowels and Consonants

    public void countVowelsAndConsonants(String inputString){
        if(String.isEmpty(inputString)) { 
            System.debug('Please enter a valid string.');
            return;
        }

        Integer vowelsCount = 0;
        Integer consonantsCount = 0;

        for (Integer i = 0; i < inputString.length(); i++) {
            String ch = inputString.substring(i, i + 1);

            if (!Pattern.matches('[A-Za-z]', ch)) {
                continue;
            }
            

            if ('aeiouAEIOU'.contains(ch)) {
                vowelsCount++;
            } else {
                consonantsCount++;
            }
        }

        System.debug('Vowels Count: ' + vowelsCount + '\n' + 'Consonents Count: ' + consonantsCount);
    }

    // 4. Check Prime Number
    public void checkPrimeNum(Integer inputNum) {

        Boolean primeFlag = false;

        if(inputNum <= 1) {
            System.debug('This is not a Prime Number');
            return;
        }

        for(Integer i = 2; i * i <= inputNum; i++) {

            if(Math.mod(inputNum, i) == 0) {
                primeFlag = true;
                break;
            }
        }

        if(primeFlag == true) {
            System.debug('This is not a Prime Number');
        } 
        else {
            System.debug('This is a Prime Number');
        }
    }

    // 5. FizzBuzz : Print numbers from 1 to 100. But for multiples of 3, print Fizz, for multiples of 5 print Buzz, and for multiples of both print FizzBuzz.

    public void fizzBuzz() {
        for(Integer num = 1; num <= 100; num++ ) {
            if(Math.mod(num, 3) == 0 && Math.mod(num, 5) == 0) {
                System.debug('FizzBuzz');
            } 
            else if(Math.mod(num, 3) == 0 && Math.mod(num, 5) != 0) {
                System.debug('Fizz');
            }
            else if(Math.mod(num, 3) != 0 && Math.mod(num, 5) == 0) {
                System.debug('Buzz');
            }
            else {
                System.debug(num);
            }
        }
    }

    // 6. Factorial of a Number: Create a method that returns the factorial of a given number using both for loop and recursion.

    // Using For Loop
    public Integer factorialUsingForLoop(Integer inputNumber) {
        Integer factorial = 1;
        for(Integer i = inputNumber; i > 1; i--) {
            factorial *= i;
        }

        return factorial;
    }

    // Using Recursion
    public Integer factorialUsingRecursion(Integer inputNumber) {
        if(inputNumber > 1) {
            return (inputNumber * FactorialUsingRecursion(inputNumber - 1));
        }
        else  {
            return 1;
        }
    }

    // 7. Fibonacci Series: Write a method to generate the first n Fibonacci numbers using a loop

    public void fibonacciSeries( Integer CountNumber) {
        System.debug('Fibonacci Series (' + CountNumber + ' numbers are as follows) ::::\n');
        Integer firstNum = 0;
        Integer secondNum = 1;
        
        if(CountNumber >= 1) {
            System.debug(firstNum);
        }
        if(CountNumber >= 2) {
            System.debug(secondNum);
        }
        for(Integer i = 3; i <=CountNumber; i++) {
            Integer count = firstNum+secondNum;
            System.debug(count);

            firstNum = secondNum;
            secondNum = count;
        }

    }

    // 8. Even and Odd Number Count : Write a method that takes a list of integers and returns how many are even and how many are odd.

    public List<Integer> countEvenOdd(List<Integer>  integerList)  {
        Integer evenCount = 0;
        Integer oddCount = 0;
        
        for(Integer i : integerList) {
            if(Math.mod(i, 2) == 0) {
                evencount++;
            } else {
                oddCount++;
            }
        }
        List<Integer> evenOddcountList = new List<Integer>();
        evenOddcountList.add(evenCount);
        evenOddcountList.add(oddCount);
        return evenOddcountList;
    }

    // 9. Sum of Digits of a Number: Write a method that calculates the sum of digits of a given number. Input: 123 → 6 (1 + 2 + 3)

    public Integer sumDigitOfNumber(Integer inputNumber) {
        Integer sum = 0;
        Integer num = Math.abs(inputNumber);

        while (num > 0) {
            sum += Math.mod(num, 10);
            num = num / 10;
        }

        return sum;
    }

    // 10. Check Armstrong Number : Write a method to check if a number is an Armstrong number

    public void checkArmstrongNum(Integer inputNumber) {
        Integer originalNum = Math.abs(inputNumber);
        Integer numLength = (String.valueOf(inputNumber)).length();
        Integer num = originalNum;
        Integer sum = 0;
        
        while(num > 0) {
            Integer digit = Math.mod(num, 10);
            sum += (Integer)Math.pow(digit, numLength);
            num = num / 10;
        }

        if(inputNumber == sum) {
            System.debug(inputNumber + ' is an Armstrong number.');
        } else {
            System.debug(inputNumber + ' is not an Armstrong number.');
        }
    }

    // 11. Remove Duplicates from List : Given a list with duplicate integers, return a new list with only unique values.

    /*public void removeDuplicates(List<Integer> inputNumber) {

        Set<Integer> uniqueSet = new Set<Integer>(inputNumber);

        List<Integer> uniqueList = new List<Integer>(uniqueSet);
        
        System.debug(uniqueList);
    }*/

    // Using Custom method
    public static void removeDuplicates(List<Integer> inputNumber) {

        System.debug('\nOriginal List :' + inputNumber);
        
        Integer inputListSize = inputNumber.size();

        List<Integer> uniqueList = new List<Integer>();
        
        for(Integer i = 0; i < inputListSize; i++) {
            Integer currentNumber = inputNumber[i];
            Boolean isDuplicate = false;

            for(Integer j = 0; j < uniqueList.size(); j++) {

                if(uniqueList[j] == currentNumber) {
                    isDuplicate = true;
                    break;
                }
            }

            if(!isDuplicate) {
                uniqueList.add(currentNumber);
            }
        }
        System.debug('List after removing duplicates: ' + uniqueList);
    }

    // 12. Sort a List in Descending Order : Write an Apex method that sorts a list of integers in descending order without using built-in sort.

    public List<Integer> descendingSortList(List<Integer> nums) {
       Integer n = nums.size();

        for (Integer i = 0; i < n - 1; i++) {
            Boolean swapped = false;

            for (Integer j = 0; j < n - i - 1; j++) {
                // DESCENDING order
                if (nums[j] < nums[j + 1]) {
                   Integer temp = nums[j];
                   nums[j] = nums[j + 1];
                   nums[j + 1] = temp;
                   swapped = true;
               }
            }

            if (!swapped) {
               break;
            }
        }
        return nums;
    }

    //13. Find Largest and Smallest Number: Given a list of integers, find the largest and smallest number manually.

    public void findLargestAndSmallest(List<Integer> inputNumber){ 
        Integer largest = inputNumber[0];
        Integer smallest = inputNumber[0];

        for(Integer i : inputNumber) {
            if(largest < i) 
                largest = i;
            
            if(smallest > i) 
                smallest = i;
        }

        System.debug('Smallest :::: ' + smallest + '\n' + 'Largest :::: ' + largest);
    }

    // 14. Find Second Highest Number: From a list of integers, find the second highest value.

    public void secondLargest(List<Integer> inputNumberList) {
        if(inputNumberList.size() < 2) {
            System.debug('List must have atleast two elements.');
            return;
        }

        Set<Integer> uniqueSet = new Set<Integer>(inputNumberList); //Set does not include duplicate values.
        
        List<Integer> uniqueList = new List<Integer>(uniqueSet);
        
        if(uniqueList.size() < 2){
            System.debug('No second largest element exist in list.');
            return;
        }
        List<Integer> descendingSortedList = descendingSortList(uniqueList);

        Integer answer = descendingSortedList[1];

        System.debug('Second Largest ::::' + answer);
    }

    // 15. Find Common Elements in Two Lists : Given two lists of integers, write code to find and return the common elements.

    public Set<Integer> findCommonElementsInTwoList(List<Integer> inputList1, List<Integer> inputList2) { 
        List<Integer> commonElements = new List<Integer>();

        for(Integer i : inputList1) {
            for(Integer j : inputList2) {
                if(i == j) {
                    commonElements.add(i);
                }
            }
        }

        Set<Integer> uniqueSet = new Set<Integer>(commonElements);

        return uniqueSet;
    }
}
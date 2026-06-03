/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 
*/
public class ExceptionHandling {

    // 1. Write an Apex method that tries to insert an Account without a required field (e.g., Name). Catch the exception and log the error message using System.debug().

    public static void contactException() {
        try {
            List<Contact> contactList = new List<Contact>();
            Contact con = new Contact();
            con.FirstName = 'Raj';  // last name is missing

            contactList.add(con);

            insert contactList;
        }
        catch (DmlException e) {
            System.debug('\nRequired Fidld Missing : ' + e.getMessage());
            System.debug('\nError in Line : ' + e.getLineNumber());
        }
    }

    // 2. Create a method that performs a SOQL query and then a DML operation. Use separate catch blocks for QueryException and DmlException, and log distinct messages for each.

    public static void contactSOQLDMLException() {
        try {
                        
            // Account acc = new Account(); // DML Error
            // Account acc = new Account(Name = 'Laxmi Account');
            // insert acc; 
            
            String inputQuery = 'SELECT Id, Name FROM Contact WHERE Naasdfme != \'piffdfdku\''; // FirstName ->> FirstNaame : QueryException
            List<Contact> contactList = new List<Contact>();
            contactList = Database.query(inputQuery);          
            for(Contact con : contactList) {
                // Contact con = new Contact();
                con.FirstName = 'Raja';
            }
            // update contactList;

            // System.debug('Contact List Updated Successfully.');

            // Integer math = 10/0; // generic error
            // System.debug(math);
        }
        catch(QueryException q) {
            System.debug('\nQuery Exception : ' + q.getMessage());
            System.debug('\nError in Line : ' + q.getLineNumber());
        }
        catch(DmlException d) {
            System.debug('\nDML Exception : ' + d.getMessage());
            System.debug('\nError in Line : ' + d.getLineNumber());
        }
        catch (Exception e) {
            System.debug('\nGeneric Exception : ' + e.getMessage());
            System.debug('\nError in Line : ' + e.getLineNumber());
        }

        finally{
            System.debug('Finally Completed. !!!');
        }
    }

    // 3. Write a method that divides two integers provided as parameters. Use try-catch-finally to handle division by zero and always log “Operation complete” in the finally block.

    public static void tryCatchFinallyException() {
        try {
            Integer num1 = 10; 
            Integer num2 = 0; 
            System.debug(num1/num2);
        }
        catch (Exception e) {
            System.debug('\nException Occor : ' + e.getMessage());
            System.debug('\nError in Line   : ' + e.getLineNumber());
        }

        finally{
            System.debug('\nOperation completed');
        }
    }

    // 4. Define a custom exception class called InvalidDataException. Write a method that throws this exception if a string parameter is null or empty.

    public static void customException() {
        try {
            String Name;
            List<Account> searchQuery = new List<Account>([SELECT Id, Name FROM Account WHERE Name = 'chiku']);
            if(Name == null) {
                throw new InvalidDataException('Custom Exception : (null value)');
            }

            if(searchQuery.isEmpty()){
                throw new InvalidDataException('Custom Exception : (Empty List)');

            }
        }
        catch (InvalidDataException e) {
            System.debug(e.getMessage());
            System.debug('\nError in Line   : ' + e.getLineNumber());
        }

        finally{
            System.debug('\nOperation completed');
        }
    }
    
    // 5. Write a method that attempts to insert a list of Contacts, some of which are missing required fields. Catch the DmlException and log which records failed.
    
    public static void createContact() {
        try{
            List<Contact> conList = new List<Contact>();
            for(Integer i = 1; i <= 10; i++) {
                Contact con = new Contact();
                if(i / 3 == 0) {
                    con.Email = 'exception@gmail.com';
                } else {
                    con.LastName = 'Exception Contact ' + i;
                    con.Email = 'practice2@gmail.com'; 
                }
                conList.add(con);
            } 
            Database.insert(conList, false);
        }
        catch(DmlException d) {
            System.debug('ERROR : inserting record ' + d.getMessage());
        }
        catch(Exception e) {
            System.debug('ERROR : inserting record ' + e.getMessage());
        }
    }

    // 6. In a catch block, use the exception methods (getMessage(), getTypeName(), getLineNumber(), getStackTraceString()) to log detailed information about the error.

    public static void exceptionMethods() {
        try{
            List<Contact> conList = new List<Contact>();
            for(Integer i = 1; i <= 10; i++) {
                Contact con = new Contact();
                if(i / 3 == 0) {
                    con.Email = 'exceptionMethods@gmail.com';
                } else {
                    con.LastName = 'Exception Methods Contact ' + i;
                    con.Email = 'exceptionMethods@gmail.com'; 
                }
                conList.add(con);
            } 
            insert conList;
        }
        catch(Exception e) {
            System.debug(
                '\nERROR : inserting record ' + e.getMessage() +
                '\nError : Type ' + e.getTypeName() +
                '\nError : Line Number ' + e.getLineNumber() +
                '\nError : Stack Trace ' + e.getStackTraceString()
            );
        }
    }

    // 7. Write a method with a nested try-catch structure. The inner block should handle one type of exception, and the outer block should handle any others.

    public static void nestedTryCatchException() {
        try {
            Account acc = new Account();
            String Name = 'TCF Assignment';
            acc.Website = '0'; 
            acc.Name = ' ';
            acc.Phone = 'assa';
            try {
                insert acc;
                
            }  
            catch(NullPointerException n) {
                System.debug('\nNull pointer Exception Occor : ' + n.getMessage());
                System.debug('\nError in Line       : ' + n.getLineNumber());
            }          
            catch (DmlException d) {
                System.debug('\nDML Exception Occor : ' + d.getMessage());
                System.debug('\nError in Line       : ' + d.getLineNumber());
            }
            Integer num1 = 10; 
            Integer num2 = 0; 
            System.debug(num1/num2);
        }
        catch (Exception e) {
            System.debug('\nException Occor : ' + e.getMessage());
            System.debug('\nError in Line   : ' + e.getLineNumber());
        }
    }

    // 8. Write a method that catches an exception, logs it, and then rethrows it to the calling method. Demonstrate how the calling method can handle the rethrown exception.

    public static void exceptionCallingMethod() {
        try{            
            methodWithException();
        }
        catch(InvalidDataException e) {
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
    }

    public static void methodWithException(){
        try{
            Account acc = new Account();
            insert acc;
        }
        catch(DmlException e) {
            // System.debug('Exception in Account Insrtion : ' + e.getMessage());
            // System.debug('Stack trace : ' + e.getStackTraceString());            
            throw new InvalidDataException('Account could not be inserted', e);   // Rethrow the original exception to the calling method(exception is rethrown with its original type and stack trace preserved)
        }
    }

    // 9. Write a method that validates input data (e.g., checks if an email is valid). If invalid, throw a custom exception with a user-friendly message. Catch and log this message.

    public static void emailValidationException() {
        try {
            String emailRegex = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';
            
            Contact contact = new Contact();
            contact.LastName = 'idani';
            contact.Email = 'aa22@@@-..com..';

            Pattern pattern = Pattern.compile(emailRegex);
            Matcher matcher = pattern.matcher(contact.Email);


            if(contact.Email == null || !matcher.matches()) {
                throw new InvalidEmailException('Invalid Email: Please enter a valid email address.');
            }
            insert contact;
            System.debug('Contact Inserted Successfully.');
        }
        catch (InvalidEmailException e) {
            System.debug('\nEmail Validation Error : ' + e.getMessage());
            System.debug('\nError in Line : ' + e.getLineNumber());
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}
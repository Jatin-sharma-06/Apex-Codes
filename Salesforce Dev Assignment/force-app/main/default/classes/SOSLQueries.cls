public class SOSLQueries {
    
    // PART 1: MULTI-LEVEL RELATIONSHIPS IN SOQL


    // 1. Retrieve all Accounts and list each related Contact's FirstName and LastName.

    // SELECT Id, Name, (SELECT FirstName, LastName FROM Contacts)  FROM Account WHERE Id IN (SELECT AccountId FROM Contact)

    // 2. From the Opportunity object, fetch:
    // - Opportunity Name
    // - Related Account Name

    // SELECT Id, Name, Account.Name  FROM Opportunity WHERE AccountId != null

    // 3. From the Case object, retrieve:
    // - Subject
    // - Related Account Name
    // - Email of the Account’s Owner

    // SELECT Subject, Account.Name, Account.Owner.Email  FROM Case 

    // 4. Write a query to fetch the following:
    // - Contact’s Full Name
    // - Their Account Name
    // - The Email of the Account Owner

    // SELECT Name, Account.Name, Account.Owner.Email FROM Contact 

    // 5. Retrieve:
    // - All Accounts
    // - Their related Opportunities
    // - For each Opportunity, get OpportunityLineItems including:
    // - Product Name
    // - Quantity

    // SELECT Id, Name, (SELECT Id, Name, Amount, StageName, (SELECT product2.Name, Quantity FROM OpportunityLineItems) FROM Opportunities) FROM Account

    // 6. Use a subquery to retrieve all child records (Contacts) from Accounts.
    // - Note down the difference between API name and relationship name in the FROM clause of subqueries.
    // -Use Schema or Object Manager to find the correct relationship name.

    // SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account

    // 7. Write a nested query to retrieve:
    // - Account Name
    // - All related Contacts (Name, Email)
    // - For each Contact, all related Cases (Subject, Status)
    // Identify how many relationship levels are involved. 

    // SELECT Id, Name, (SELECT Id, Name, Email, (SELECT subject, status FROM Cases) FROM Contacts) FROM Account
    


    // PART 2: DYNAMIC SOQL


    // 1. Create a dynamic SOQL query to retrieve all Accounts where the Name equals a user input variable.

    public static void getAccount(String accName) {
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + String.escapeSingleQuotes(accName) + '\'';
        
        List<Account> accounts = Database.QUERY(query);

        if(!accounts.isEmpty()) {
            for(Account acc : accounts) {
                System.debug('Retrive Accounts : ' + acc);
            } 
            
        } else {
            System.debug('Record not found.');
        }
    }


    // 2. Use Database.query() to run the above query.
    // - Print the result in logs.
    // - Modify the input to test different values.

    public static void getAccountInLog(String accName) {
        String query = 'SELECT Id, Name FROM Account WHERE Name = \'' + String.escapeSingleQuotes(accName) + '\'';
        
        List<Account> accounts = Database.QUERY(query);

        if(!accounts.isEmpty()) {
            for(Account acc : accounts) {
                System.debug('Retrive Accounts : ' + acc);
            } 
            
        } else {
            System.debug('Record not found.');
        }
    }



    // 3. Convert the following static query into a dynamic version:
    // SELECT Id, Name FROM Contact WHERE Email = 'test@example.com'

    public static void getContact(String Email) {
        String query = 'SELECT Id, Name FROM Contact WHERE Email = \'' + String.escapeSingleQuotes(Email) + '\'';
        
        List<Contact> contacts = Database.QUERY(query);
        
        if(!contacts.isEmpty()) {
            for(Contact con : contacts) {
                System.debug('Retrive Contacts : ' + contacts);
            }         
        } else {
            System.debug('Record not found.');
        }
    }


    // 4. Write a method:
    // Input: Object name, Field name, Field value
    // Output: List of records matching the field
    // Example: fetchRecords('Contact', 'Email', 'john@example.com')

    public static void getRecord(String objectName, String fieldName, String fieldValue) {
        String query = 'SELECT Id, Name FROM ' + objectName + ' WHERE ' + fieldName + ' = \'' + String.escapeSingleQuotes(fieldValue) + '\'' ;
        
        List<sObject> result = Database.QUERY(query);

        if(!result.isEmpty()) {
            for(SObject res : result) {
                System.debug('Retrive Accounts : ' + res);
            } 
            
        } else {
            System.debug('No record found.');
        }
    }
    

    // 5. Write a method that accepts LastName and builds a dynamic SOQL query to find Contacts. Make sure the input is safely handled.

    public static void getContactWithInput(String lastName) {
        String query = 'SELECT Id, LastName FROM Contact WHERE LastName =\''  + String.escapeSingleQuotes(LastName) + '\'';
        
        List<Contact> contacts = Database.QUERY(query);
        
        if(!contacts.isEmpty()) {
            for(Contact con : contacts) {
                System.debug('Retrive Contacts : ' + contacts);
            }         
        } else {
            System.debug('Record not found.');
        }
    }

    // 6. Demonstrate how SOQL injection could happen with user input in a dynamic query. Then fix it using String.escapeSingleQuotes().

    public static void safeContactSearch(String userInput){
        
        // String queryString = 'SELECT Id, Name, Email FROM Contact WHERE LastName = \'' + userInput + '\''; // in this query sql injuction is possible
        
        String queryString = 'SELECT Id, Name, Email FROM Contact WHERE LastName = \'' + String.escapeSingleQuotes(userInput) + '\'';

        List<Contact> contacts = Database.query(queryString);

        System.debug(contacts);
    }

    
    
    // 7. Build a method that accepts LastName and Email as inputs and returns matching Contact records using dynamic SOQL with input sanitization.

    public static void getContactWithInputSanitization(String lastName, String Email){
       
        String query = 'SELECT Id, LastName, Email FROM Contact WHERE LastName = \'' + String.escapeSingleQuotes(lastName) + '\'' + ' AND Email = \'' + String.escapeSingleQuotes(Email) + '\'';

        List<Contact> contacts = Database.query(query);

        System.debug(contacts);
    }


    // PART 3: INTRODUCTION TO SOSL

    // 1. Write a SOSL query to search for the word 'Edge' across:
    // - All fields in Account
    // - All fields in Contact
    
    // FIND {Edge} IN Name FIELDS RETURNING Account, Contact


    // 2. Modify this SOSL to use wildcards:
    // FIND 'Acme' RETURNING Account(Id, Name)

    // FIND {Acme OR A?m*} RETURNING Account(Id, Name)


    // 3. Create a SOSL query to search across:
    // - Lead: Name, Email
    // -Case: Subject
    // Return all matched records. Print total count and results for each object.

    public static void findLeadAndCase() {
        List<List<SObject>> queryResult = [FIND 'Raghav' IN ALL FIELDS RETURNING Lead(Name, Email), Case(Subject) ];

        List<Lead> leadList = (List<Lead>) queryResult[0];
        List<Case> caseList = (List<Case>) queryResult[1];
        
        System.debug('Total Leads found : ' + leadList.size());

        for(Lead l : leadList) {
            System.debug('Lead Name : ' + l.Name + 'Email : ' + l.Email);
        }
        
        System.debug('Total Cases found : ' + caseList.size());

        for(Case c : caseList) {
            System.debug('Case Subject : ' + c.Subject);
        }
    }


    // 4. Search Accounts by keyword
    // Write a method that takes a search term and returns Accounts and Cases matching that term using SOSL.

    public static void findAccountAndCase(String inputName) {

        List<List<SObject>> queryResult = [FIND :('*'+ inputName +'*') IN ALL FIELDS RETURNING Account(Id, Name), Case(Subject)];

        List<Account> accList = (List<Account>) queryResult[0];
        List<Case> caseList = (List<Case>) queryResult[1];
        
        System.debug('Total Accounts found : ' + accList.size());

        for(Account acc : accList) {
            System.debug('Account Name : ' + acc.Name);
        }
        
        System.debug('Total Cases found : ' + caseList.size());

        for(Case c : caseList) {
            System.debug('Case Subject : ' + c.Subject);
        }
    }

    // 5. Find Contacts and Leads by name
    // Create a method that searches Contacts and Leads for a given name and returns Id and Name fields.

    public static void findContactAndLead(String inputName) {

        List<List<SObject>> queryResult = [FIND :inputName IN ALL FIELDS RETURNING Lead(Id, Name), Contact(Id, Name) ];

        List<Lead> leadList = (List<Lead>) queryResult[0];
        List<Contact> contactList = (List<Contact>) queryResult[1];
        
        System.debug('Total Leads found : ' + leadList.size());

        for(Lead l : leadList) {
            System.debug('Lead id : ' + l.Id + ' Lead Name : ' + l.Name);
        }
        
        System.debug('Total Contacts found : ' + contactList.size());

        for(Contact con : contactList) {
            System.debug('Contact Id : ' + con.Id + ' Contact Name : ' + con.Name);
        }
    }
    

    // 6. Search Cases by subject
    // Implement a method that accepts a keyword and returns Cases whose Subject contains that keyword.

    public static void findCaseBySubject(String inputSubject) {

        List<List<SObject>> queryResult = [FIND :('*' + inputSubject + '*') IN ALL FIELDS RETURNING Case(Subject) ];

        List<Case> caseList = (List<Case>) queryResult[0];
        
        System.debug('Total Cases found : ' + caseList.size());

        for(Case c : caseList) {
            System.debug('Case Subject : ' + c.Subject);
        }
    }


    // 7.Search Accounts and Opportunities for a term
    // Write a method that searches both Account and Opportunity objects by a term and returns their Id and Name.

    public static void findAccountAndOpportunity(String inputName) {

        List<List<SObject>> queryResult = [FIND :('*'+ inputName +'*') IN ALL FIELDS RETURNING Account(Id, Name), Opportunity(Id, Name)];

        List<Account> accList = (List<Account>) queryResult[0];
        List<Opportunity> oppList = (List<Opportunity>) queryResult[1];
        
        System.debug('Total Accounts found : ' + accList.size());

        for(Account acc : accList) {
            System.debug('Account Id : ' + acc.Id + 'Account Name : ' + acc.Name);
        }
        
        System.debug('Total Opportunities found : ' + oppList.size());

        for(Opportunity opp : oppList) {
            System.debug('Opportunity Id : ' + opp.Id + 'Opportunity Name : ' + opp.Name);
        }
    }


    // 8.Search Users and Groups by keyword
    // Build a method to find Users and Groups containing the search term, returning Id and Name/GroupName.
    
    public static void findUserAndGroup(String inputName) {

        List<List<SObject>> queryResult = [FIND :('*'+ inputName +'*') IN ALL FIELDS RETURNING User(Id, Name), Group(Id, Name)];

        List<User> userList = (List<User>) queryResult[0];
        List<Group> groupList = (List<Group>) queryResult[1];
        
        System.debug('Total Users found : ' + userList.size());

        for(User u : userList) {
            System.debug('User Id : ' + u.Id + 'User Name : ' + u.Name);
        }
        
        System.debug('Total Groups found : ' + groupList.size());

        for(Group grp : groupList) {
            System.debug('Group Id : ' + grp.Id + 'Group Name : ' + grp.Name);
        }
    }


    // 9. Search Leads for any field containing a term
    // Write a method to return Leads where any searchable field contains the input term.

    public static void findLeads(String input) {

        List<List<SObject>> queryResult = [FIND :('*' + input + '*') IN ALL FIELDS RETURNING Lead(Id, Name) ];

        List<Lead> leadList = (List<Lead>) queryResult[0];
        
        System.debug('Total Leads found : ' + leadList.size());

        for(Lead l : leadList) {
            System.debug('Lead Id : ' + l.Id + 'Lead Name : ' + l.Name);
        }
    }
    


    // 10.Wildcard SOSL search in Account and Contact
    // Create a method that uses wildcards to find any Account or Contact records containing a partial term

    public static void findAccountAndContact(String inputName) {

        List<List<SObject>> queryResult = [FIND :('*'+ inputName +'*') IN ALL FIELDS RETURNING Account(Id, Name), Contact(Id, Name)];

        List<Account> accList = (List<Account>) queryResult[0];
        List<Contact> contList = (List<Contact>) queryResult[1];
        
        System.debug('Total Accounts found : ' + accList.size());

        for(Account acc : accList) {
            System.debug('Account Id : ' + acc.Id + 'Account Name : ' + acc.Name);
        }
        
        System.debug('Total Contacts found : ' + contList.size());

        for(Contact cont : contList) {
            System.debug('Opportunity Id : ' + cont.Id + 'Opportunity Name : ' + cont.Name);
        }
    }


}
public class DMLStatements{
    //Customer Management System
    // You’re working with a customer management system. You need to:

    // 1. Insert 5 accounts, each with a related contact.

    // 2. Update the billing city of accounts with name starting with 'Practice DML'.

    // 3. Delete contacts whose email is null

   
    // 1. Insert 5 accounts, each with a related contact. 
    
    public static void insertAccountContact() {
        List<Account> accList = new List<Account>();

        for(Integer i = 1; i <= 5; i++) {
            Account acc = new Account();

            acc.name = 'Practice DML Account' + i;
            acc.BillingCity = 'Jaipur';

            accList.add(acc);
        }
        insert accList;
        System.debug('Account Inserted Successfully.');

        List<Contact> conList = new List<Contact>();

        for(Account acc : accList) {
            Contact con = new Contact();

            con.LastName = 'Practice DML Contact ';
            con.AccountId = acc.Id;

            conList.add(con);

        }

        insert conList;
        System.debug('Contact Created Successfully.');

    }

    // 2. Update the billing city of accounts with name starting with 'Practice DML'. 


    public static void updateBillingCity() {
        List<Account> accList = new List<Account>();

        accList = [SELECT Name FROM Account WHERE Name LIKE 'Practice DML%'];

        for(Account acc : accList) {
            acc.BillingCity = 'Ranchi';
            acc.Phone = '1234562124';
        }

        update accList;
        System.debug('Billing City of Account Updated Successfully.');

    }

    // 3. Delete contacts whose email is null 

    public static void deleteContactWithNullEmail() {
        List<Contact> conList = new List<Contact>();

        conList = [SELECT Id, Name FROM Contact WHERE Email = null];

        delete conList;

        System.debug('Contacts with Null Email Deleted Successfully.');

    }

    // Your app must handle records smartly:

    // 1. Upsert 5 accounts using external ID field.

    // 2. Delete 2 accounts by ID.

    // 3. Undelete the deleted accounts using SOQL with ALL ROWS.

    // 1.
    public static void upsertUsingExternalID() {
        List<Account> accountList = new List<Account>();

        for(Integer i = 4; i <= 8; i++) {
            Account acc = new Account();

            acc.Name = 'Upsert Account DML Updated ' + i;
            acc.ExternalId__c = 'A-004' + i;

            accountList.add(acc);
        }

        upsert accountList ExternalId__c;
        System.debug('Records Upserted Successfully');
    
    }

    // 2.
    public static void deleteAccountByID(String acc1ExternalId, String acc2ExternalId) {
        List<Account> deleteAccList = new List<Account>();

        deleteAccList = [SELECT ExternalId__c, Name FROM Account WHERE ExternalId__c = :acc1ExternalId OR ExternalId__c = :acc2ExternalId ];

        delete deleteAccList;

        System.debug('Account with External Id : ' + acc1ExternalId + ' and ' + acc2ExternalId + ' Deleted successfully.');
    }

    // 3.
    public static void undeleteAccount() {
        List<Account> undeleteAccList = new List<Account>();

        undeleteAccList = [SELECT Id, Name FROM Account WHERE isDeleted = true ALL ROWS ];

        undelete undeleteAccList;

        System.debug('Accounts Undeleted successfully.');
    }


    // Use Database Class Methods with result handling to:

    // 1. Simulate importing 10 contacts.

    // 2. Purposely leave out required fields on a few records.

    // 3. Debug success and error messages.

    // 1.
    public static void createContact() {
        List<Contact> conList = new List<Contact>();

        for(Integer i = 1; i <= 10; i++) {
            Contact con = new Contact();
            if(i / 3 == 0) {
                con.Email = 'testing'+i+'mail@gmail.com';
            } else {
                con.LastName = 'Testing ' + i;
                con.Email = 'testing'+i+'mail@gmail.com'; 
            }
            conList.add(con);

        } 
        // 2.
        Database.SaveResult[] result = Database.insert(conList, false); // if true, rollback form the error
    
        // 3.
        
        for(Integer i = 0; i < result.size(); i++) {
            if(result[i].isSuccess()) {
                System.debug('SUCCESS : contact inserted with ID ' + result[i].getId());
            } else {
                for(Database.Error err : result[i].getErrors()) {
                    System.debug('ERROR : inserting record ' + i + ' Message ' + err.getMessage());
                }
            }
        }

    }


    // Simulate a multi-step transaction:

    // 1. Insert Account

    // 2. Insert Contact (with one missing required field to simulate error)

    // 3. Insert Opportunity

    // 4. Rollback all if any step fails

    public static void multiStepTransacton() {
        // savepoint 
        savepoint sp = Database.setSavepoint();

        try {
            Account acc = new Account( Name = 'multiStep Transaction Account Testing');

            insert acc;

            System.debug('Account Created' + acc.Id);
            
            
            Contact con = new Contact( LastName = 'multiStep Transaction Contact Testing');

            insert con; //Last name not inserted 

            System.debug('Contact Created' + con.Id);


            Opportunity opp = new Opportunity( 
                Name = 'multiStep Transaction Opportunity Testing',
                StageName = 'Prospecting',
                // CloseDate = Date.today().addDays(22),
                AccountId = acc.Id
            );

            insert opp;

            System.debug('Opportunity Created' + opp.Id);
        }
        catch(Exception e) {
            Database.rollback(sp);
            System.debug('Transaction Rollbacked');
            System.debug('Error Message :  ' + e.getMessage());        
        }
    }
    


    // Write code to: 

    //1.  Convert a lead using a custom Converted Status 

    //2.  Skip opportunity creation 

    //3.  Log all IDs of the new Account and Contact 

    //4.  If conversion fails, notify via debug logs 

    public static void convertLeadRecord(Id leadId){    // the ID of the Lead record to convert
        // Query the LeadStatus object to get a valid converted status
        // LeadStatus is a standard Salesforce object that stores lead status values
        LeadStatus status =
        [
            SELECT MasterLabel          // MasterLabel is the label/name of the status
            FROM LeadStatus             // Querying the LeadStatus object
            WHERE IsConverted = true    // Filter only statuses marked as "Converted"
            LIMIT 1                     // Return only one converted status
        ];
        Database.LeadConvert lc = new Database.LeadConvert();   // Create an instance of Database.LeadConvert class. This object stores all configuration required for lead conversion
        
        lc.setLeadId(leadId);   // Specify which Lead record should be converted using its ID

        lc.setConvertedStatus(status.MasterLabel);   // Set the converted status for the lead, The value comes from the LeadStatus query above
        
        lc.setDoNotCreateOpportunity(true);  // Tell Salesforce NOT to create an Opportunity during conversion
 
        Database.LeadConvertResult result = Database.convertLead(lc);    // Perform the lead conversion using the configured LeadConvert object, The method returns a LeadConvertResult object containing success/failure details

        // Check whether the conversion was successful
        if(result.isSuccess()){
            System.debug('Lead converted successfully');
            System.debug('New Account ID : ' + result.getAccountId());
            System.debug('New Contact ID : ' + result.getContactId());
        }
        else{
            // If conversion fails, loop through the list of errors returned
            for(Database.Error err : result.getErrors()){
                System.debug('Lead conversion failed : ' + err.getMessage());
            }
        }

    }

}
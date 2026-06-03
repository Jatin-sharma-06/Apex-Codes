public with sharing class ContactSOQLQueries {
    
    // 3. Retrieve the names of Contacts associated with an Opportunity named "XYZ Opportunity." 
    public static void contactWithXYZOpp() {
        List<Contact> contactList = new List<Contact>();

        contactList = [SELECT Id,Name FROM Contact WHERE AccountId IN (SELECT AccountId FROM Opportunity WHERE Name = 'XYZ Opportunity')];
        for(Contact contact : contactList) {
            System.debug('\nContact Id ::: ' + contact.Id + '\nContact Name ::: ' + contact.Name);
        }
    }


    // 9. Retrieve the names and email addresses of all Contacts associated with Opportunities that are in the "Proposal" stage.
    public static void contactWithProposalStageOpp() {
        List<Contact> contactList = new List<Contact>();

        contactList = [SELECT Name, Email FROM Contact WHERE AccountId IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Proposal/Price Quote')];
        for(Contact contact : contactList) {
            System.debug('\nContact Name ::: ' + contact.Name + '\nEmail ::: ' + contact.Email);
        }
    }

    // 16. List the Contacts whose Mailing State is not equal to their Billing State.
    // NOTE: (Billing address is present in Account not in Contact)
    public static void contactsWithDiffMailAndBillAddress() {
        List<Contact> conList = new List<Contact>();
        conList = [SELECT Name, MailingState, Account.BillingState FROM Contact WHERE AccountId != null AND MailingState != null];
        
        for(Contact con: conList) {
            if(con.MailingState != con.Account.BillingState) {
                System.debug('\nContact Name ::: ' + con.Name + '\nMailingState ::: ' + con.MailingState + '\nAccount Billing Address ::: ' + con.Account.BillingState);
            }
        }
    }

    // Not possible using One line query.
    // 20. List the Contacts who are related to Opportunities with an Amount greater than the average Opportunity Amount.
    public static void contactsWithOppAmtGreaterThenAvg() {
        List<AggregateResult> avgOppAmount = new List<AggregateResult>();
        avgOppAmount = [SELECT AVG(Amount) avgAmount FROM Opportunity];

        Decimal oppAvg = (Decimal) avgOppAmount[0].get('avgAmount');

        System.debug('\nOpportunity Average :: ' + oppAvg);

        List<Contact> contactList= new List<Contact>();

        contactList = [SELECT Name FROM Contact WHERE AccountID IN (SELECT AccountID FROM Opportunity WHERE Amount != null AND Amount > :oppAvg)];

        for(Contact contact : contactList) {
            System.debug('\nContact Name :: ' + contact.Name);
        }
    }

    // 29. Find the Contacts who are associated with Opportunities in the "Closed/Won" stage and have not been contacted in the last 30 days.
    public static void contactWithClosedWonOppNotContacted() {
        List<Contact> contactList= new List<Contact>();

        contactList = [SELECT Name FROM Contact WHERE AccountID IN (SELECT AccountID FROM Opportunity WHERE StageName = 'Closed Won' AND LastModifiedDate < LAST_N_DAYS:30)];

        for(Contact contact : contactList) {
            System.debug('\nContact Name :: ' + contact.Name);
        }
    }

    // 33. Find the Contacts associated with Opportunities in the "Negotiation" stage that have not been updated in the last 15 days.
    public static void contactWithNegotiationOppStageNotUpdatedInLast15Days() {
        List<Contact> contactList= new List<Contact>();

        contactList = [SELECT Name FROM Contact WHERE AccountID IN (SELECT AccountID FROM Opportunity WHERE StageName = 'Negotiation/Review' AND LastModifiedDate < LAST_N_DAYS:15)];

        for(Contact contact : contactList) {
            System.debug('\nContact Name :: ' + contact.Name);
        }
    }

}
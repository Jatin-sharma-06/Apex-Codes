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


}
public with sharing class AccountSOQLQueries {
    
    // 1. Retrieve all Account names and their corresponding Industry from Salesforce.
    public static void accountNameWithIndustry() {
        List<Account> accountList = new List<Account>();
        accountList = [SELECT Name, Industry FROM Account];
        for(Account acc : accountList){
            System.debug(acc.Name + ' : ' + acc.Industry);
        }
    }

    // 2. Find the total number of Opportunities for each Account.
    public static void totalOpportunitiesWithAccount() {
        List<Account> accountList = new List<Account>();
        accountList = [SELECT Id, Name, (SELECT Id FROM Opportunities) FROM Account];

        for(Account acc : accountList) {
            Integer oppCount = acc.Opportunities.size();
            System.debug('\nAccount Name ::: ' + acc.Name + '\nCount of Opportunities ::: ' + oppCount);
        }
    }

    // 6. Retrieve Account names and their associated Opportunities where the Opportunity Amount is greater than $50,000.
    public static void accWithOppAmountGretaerthan50000(){
        List<Account> accountList = new List<Account>();

        accountList = [SELECT Id, Name, (SELECT Name FROM Opportunities WHERE Amount > 50000) FROM Account WHERE Id IN (SELECT AccountId FROM opportunity WHERE Amount > 50000)];
    
        for(Account acc : accountList) {
            System.debug('\nAccount Id ::: ' + acc.Id + '\nAccount Name ::: ' + acc.Name /*+ '\nOpportunities Name :::' + acc.Opportunities*/);
            for(Opportunity opp : acc.Opportunities) {
                System.debug('\nOpportunity Name ::: ' + opp.Name);
            }
        }
    }
      
    // 12. Retrieve the names of all Accounts that have both Opportunities and Cases associated with them.
    public static void accWithOppAndCase() {
        List<Account> accList = new List<Account>();
        
        accList = [SELECT Name, (SELECT Name FROM Opportunities), (SELECT CaseNumber FROM Cases) FROM Account WHERE Id IN (SELECT AccountId FROM opportunity) AND Id IN (SELECT AccountID FROM Case)];

        for(Account acc : accList) {
            System.debug('\nAccount Name : ' + acc.Name + '\nOpportunity : ' + acc.Opportunities + '\nCaseNumber : ' + acc.Cases);
            // for(Opportunity opp : acc.Opportunities) {
            //     System.debug('\nOpportunity : ' + opp.Name);
            // }
            // for(Case c : acc.Cases) {
            //     System.debug('\nCaseNumber : ' + c.CaseNumber);
            // }
        }
    }

    // 15. Retrieve the names of Accounts that have Billing Postal Code starting with "9".
    public static void accPostalCodeStartWith9(){
        List<Account> accList = new List<Account>();
        accList = [SELECT Name, BillingPostalCode FROM Account WHERE BillingPostalCode LIKE '9%'];

        for(Account acc : accList) {
            System.debug('\nAccount Name(Postal Code start with \'9\') ::: ' + acc.Name + '\nBilling Postal Code ::: ' + acc.BillingPostalCode);
        }
    }

  
}

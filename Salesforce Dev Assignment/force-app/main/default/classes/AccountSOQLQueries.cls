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

        List<AggregateResult> accountList =  [SELECT AccountId, Account.Name, COUNT(Id) oppCount  FROM Opportunity  GROUP BY AccountId, Account.Name];

        for(AggregateResult acc : accountList) {

            String accName = (String) acc.get('Name');
            Integer oppCount = (Integer) acc.get('oppCount');

            System.debug('\nAccount Name ::: ' + accName + '\nCount of Opportunities ::: ' + oppCount);
        }
    }

    // 6. Retrieve Account names and their associated Opportunities where the Opportunity Amount is greater than $50,000.
    public static void accWithOppAmountGretaerthan50000() {
        List<Account> accountList = new List<Account>();
        // SELECT Id, Name, (SELECT Name FROM Opportunities WHERE Amount > 50000) FROM Account 
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
    public static void accPostalCodeStartWith9() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Name, BillingPostalCode FROM Account WHERE BillingPostalCode LIKE '9%'];

        for(Account acc : accList) {
            System.debug('\nAccount Name(Postal Code start with \'9\') ::: ' + acc.Name + '\nBilling Postal Code ::: ' + acc.BillingPostalCode);
        }
    }

    //21. Retrieve the top 3 Opportunities with the highest Amount for each Account.
    public static void accHaveTopThreeOpp() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Name, (SELECT Name, Amount FROM Opportunities ORDER BY Amount DESC LIMIT 3) FROM Account];
    
        for(Account acc : accList) {
            System.debug('\nAccount Name ::: ' + acc.Name);

            for(Opportunity opp : acc.Opportunities) {
                System.debug('\nOpportunity :: ' + opp.Name + '\nAmount :: ' + opp.Amount);
            }
        }
    }

    // 23. Find the Accounts that have not been modified in the last 60 days. ----> 25 days
    public static void accNotModifiedInLastTwoMonth() {
        List<Account> accList = new List<Account>();

        accList = [SELECT Name, LastModifiedDate FROM Account WHERE LastModifiedDate < N_DAYS_AGO:60];
   
        for(Account acc : accList) {
            System.debug('\nAccount Name ::: ' + acc.Name + '\nLast Modified Date ::: ' + acc.LastModifiedDate);
        }
    }

    // 25. Retrieve the names of Accounts along with the total number of Contacts associated with each Account.
    public static void accNameWithNumberOfContacts() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Name, (SELECT Name FROM Contacts) FROM Account];
   
        for(Account acc : accList) {
            System.debug('\nAccount Name ::: ' + acc.Name);
            System.debug('\nNumber of Contacts ::: ' + acc.Contacts.size());
        }
    }

    // 28. Retrieve the names of Accounts that have at least one Opportunity with a Stage of "Prospecting."
    public static void accWithOppStageProspecting() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Prospecting')];

        for(Account acc : accList) {
            System.debug('\nAccount Name : ' + acc.Name);
        }
    }

    // 31. Retrieve the names of Accounts along with the count of Opportunities, grouped by Industry.
    public static void accWithOppCountGroupByIndustry() {
        List<Account> accountList = new List<Account>();
        // SELECT Account.Industry, Account.Name, COUNT(Id) FROM Opportunity GROUP BY Account.Industry, Account.Name
        accountList = [SELECT Name, (SELECT Id FROM Opportunities), Industry FROM Account ORDER BY Industry];

        for(Account acc : accountList) {
            Integer oppCount = acc.Opportunities.size();
            System.debug('\n Industry ::: ' + acc.Industry + ' | Count of Opportunities ::: ' + oppCount + ' | Account Name ::: ' + acc.Name);
        }
    }

    // 35. Retrieve the names of Accounts with the Billing Country set to "United States" and Annual Revenue greater than $1 million.
    public static void accBillingCityUSRevenue1M() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Name, BillingCountry, AnnualRevenue FROM Account WHERE BillingCountry = 'United States' AND AnnualRevenue > 1000000];

        for(Account acc : accList) {
            System.debug('\nAccount Name ::: ' + acc.Name + '\nBilling Country ::: ' + acc.BillingCountry + '\nAnnual Revenue ::: ' + acc.AnnualRevenue);
        }
    }


    // Query from 41 to 50 

    // SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)
    // SELECT Id, Name, CloseDate FROM Opportunity WHERE CloseDate = THIS_FISCAL_QUARTER
    // SELECT Id, Name, Priority__c, Approval_Status__c FROM Opportunity WHERE Priority__c = 'High' AND Approval_Status__c = 'Pending'
    // SELECT Id, Name, Amount, CreatedDate FROM Opportunity WHERE CreatedDate = LAST_N_DAYS:7 AND Amount > 50000
    // SELECT Id, Name, BillingCity FROM Account WHERE BillingCity LIKE '%Tech%'
    // SELECT Id, Name, Forecast_Category__c FROM Opportunity WHERE Forecast_Category__c IN ('Commit','Omitted')
    // SELECT AccountId, COUNT(Id) FROM Opportunity WHERE StageName = 'Closed Won' GROUP BY AccountId HAVING COUNT(Id) > 5
    // SELECT ContactId, Contact.Name FROM OpportunityContactRole WHERE Opportunity.Renewal_Opportunity__c = TRUE 
    // SELECT Id, Name, CloseDate, Amount FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:90 AND Amount >= 50000 AND Amount <= 100000
    // SELECT Id, Name, StageName, LastModifiedDate FROM Opportunity WHERE StageName = 'Prospecting' AND LastModifiedDate < N_DAYS_AGO:15

}
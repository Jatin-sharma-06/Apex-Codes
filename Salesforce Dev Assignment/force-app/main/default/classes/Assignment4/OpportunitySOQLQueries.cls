public with sharing class OpportunitySOQLQueries {
    
    // 4. List all closed Won Opportunities along with their amounts.
    public static void closedWonOpp() {
        List<Opportunity> opportunityList = new List<Opportunity>();

        opportunityList = [SELECT Name, StageName, Amount FROM Opportunity WHERE StageName = 'Closed Won'];

        for(Opportunity opp : opportunityList) {
            System.debug('\nOpportunity Name ::: ' + opp.Name +'\nOpportunity Stage ::: ' + opp.StageName +'\nAmount ::: ' + opp.Amount);
        }
    }

    // 7. Find the average amount of all closed Won Opportunities.
    public static void avgOfClosedWonOppGrpByName() {
        List<AggregateResult> aggregateResult = new List<AggregateResult>();
        aggregateResult = [SELECT Name, AVG(Amount) avgAmount FROM Opportunity WHERE StageName = 'Closed Won' AND Amount != Null GROUP BY Name];

        for(AggregateResult result : aggregateResult) {
            String name = (String)result.get('Name');
            Decimal avgAmount = (Decimal)result.get('avgAmount');

            System.debug('\nOpportunity Name ::: ' + name + '\nAverage amount is ::: ' + avgAmount);
        }
    }

    /* public static void avgOfAllClosedWonOpp() {
        AggregateResult result = [SELECT AVG(Amount) avgAmount FROM Opportunity WHERE StageName = 'Closed Won' AND Amount != Null];
        Decimal averageAmount = (Decimal)result.get('avgAmount');
        System.debug('\nAverage amount for all Closed Won Opportunities :::' + averageAmount);
    } */
    
    // 8. List the Opportunities that are due to close in the next 7 days.
    public static void dueOpportunities() {
        List<Opportunity> opportunityList = new List<Opportunity>();

        Date today = Date.today();
        Date next7thDay = Date.today() + 7;

        opportunityList = [SELECT Name, CloseDate FROM Opportunity WHERE CloseDate >= :today AND CloseDate < :next7thDay];

        for(Opportunity opp : opportunityList) {
            System.debug('\nOpportunity Name ::: ' + opp.Name + '\nClosed Date ::: ' + opp.CloseDate);
        }
    }

    // 10. Find the Account with the maximum number of Opportunities.
    public static void accountWithMaximumOpp(){
        List<AggregateResult> opportunityList = new List<AggregateResult>();
        opportunityList = [SELECT Account.Name accName, COUNT(Id) maxCount FROM Opportunity GROUP BY Account.Name ORDER BY COUNT(Id) DESC LIMIT 1];
        Integer maxOppCount = (Integer)opportunityList[0].get('maxCount');
        String accNameWithMaxOpp = (String)opportunityList[0].get('accName');
        System.debug('\nAccount Name ::: ' + accNameWithMaxOpp  + '\nMaximum Opportunity Count ::: ' + maxOppCount);
    }

    //11. List the Opportunities that have a Close Date in the current month.
    public static void oppCloseInMonth() {
        List<Opportunity> oppList = new List<Opportunity>();

        oppList = [SELECT Name, CloseDate FROM Opportunity WHERE CloseDate > LAST_MONTH AND CloseDate < NEXT_MONTH];

        for(Opportunity opp : oppList) {
            System.debug('\nOppportunity Name ::: ' + opp.Name + '\nClose Date ::: ' + opp.CloseDate);
        }
    }

    //ERROR: NO DEBUG STATEMENT
    //13. Identify the Opportunities that have not been updated in the last 30 days.
    public static void oppUpdatedBefore30Days() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, LastModifiedDate FROM Opportunity WHERE LastModifiedDate < N_DAYS_AGO:30];
        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name ::: ' + opp.Name + 'Last Modified Date ::: ' +opp.LastModifiedDate);
        }
    }

    // 17. Find the Opportunities with a Stage of "Negotiation" and an Amount greater than $100,000.
    public static void oppWithNegotiationAndAmountGreateThanOneLakh() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, StageName, Amount FROM  Opportunity WHERE StageName = 'Negotiation/Review' AND Amount > 100000];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name ::: ' + opp.Name + '\nStage ::: ' + opp.StageName + '\nAmount ::: ' + opp.Amount);
        }
    }

    // 18. Retrieve the names of Accounts along with the total amount of all their associated Opportunities.
    public static void accNamesWithTotalOppAmount(){

        List<AggregateResult> oppList = new List<AggregateResult>();

        oppList = [SELECT Account.Name accName, SUM(Amount) sumOpportunitiesAmount FROM Opportunity WHERE Amount != NULL GROUP BY Account.Name];

        for(AggregateResult result : oppList) {

            String accName = (String) result.get('accName');
            Decimal totalAmount = (Decimal) result.get('sumOpportunitiesAmount');

            System.debug('\nAccount Name : ' + accName + '\nSum of all Opportunities Amounts is : ' + totalAmount);
        }
    }

    //19. Find the Opportunities with a Close Date in the next 14 days and sort them by Close Date in ascending order.
    // public static void

}
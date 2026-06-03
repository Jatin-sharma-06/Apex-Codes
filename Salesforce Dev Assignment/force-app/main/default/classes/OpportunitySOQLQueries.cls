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
        //SELECT Name, CloseDate FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:7
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

    //ERROR: NO DEBUG STATEMENT (there is no opportunity which is updated before 30 days -----> use 25 insted)
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
    public static void accNamesWithTotalOppAmount() {

        List<AggregateResult> oppList = new List<AggregateResult>();

        oppList = [SELECT Account.Name accName, SUM(Amount) sumOpportunitiesAmount FROM Opportunity WHERE Amount != NULL GROUP BY Account.Name];

        for(AggregateResult result : oppList) {

            String accName = (String) result.get('accName');
            Decimal totalAmount = (Decimal) result.get('sumOpportunitiesAmount');

            System.debug('\nAccount Name : ' + accName + '\nSum of all Opportunities Amounts is : ' + totalAmount);
        }
    }

    // 19. Find the Opportunities with a Close Date in the next 14 days and sort them by Close Date in ascending order.
    public static void oppWithCloseInTwoWeeks() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, CloseDate FROM Opportunity WHERE CloseDate < NEXT_N_DAYS:14 ORDER BY CloseDate ASC];

        for(Opportunity opp : oppList) {
            System.debug('\npportunity Name : ' + opp.Name + '\nOpportunity CloseDate : ' + opp.CloseDate);
        }
    }

    // 22. Identify the Opportunities that have a custom field "Approval_Status_c" set to "Pending."   
    public static void oppWithPendingApproval() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, Approval_Status__c FROM Opportunity WHERE Approval_Status__c = 'Pending'];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nOpportunity Approval Status : ' + opp.Approval_Status__c);
        }
    }

    // 24. List the Opportunities with a Stage of "Closed/Won" and a Close Date in the last quarter.
    public static void oppStageClosedWonClosedInLastQuarter() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, StageName, CloseDate FROM Opportunity WHERE StageName = 'Closed Won' AND CloseDate = LAST_QUARTER];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nStage Name : ' + opp.StageName + '\nClosed Date : ' + opp.CloseDate);
        }
    }

    // 26. Find the Opportunities created by a specific User.
    public static void oppCreatedBySpecificUser(Id userId) {
        List<Opportunity> oppList = new List<Opportunity>();
        // SELECT Name, CreatedById, CreatedBy.Name FROM Opportunity WHERE CreatedById = '005gL00000FGu42QAD'
        oppList = [SELECT Name, CreatedById, CreatedBy.Name FROM Opportunity WHERE CreatedById = :userId];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nUser  Name : ' + opp.CreatedBy.Name + '\nCreated By Id : ' + opp.CreatedById);
        }
    }

    // 27. List the Opportunities with a custom field "Priority__c" set to "High" and an Amount greater than $50,000.
    public static void oppPriorityHighAmountGreaterThan50000() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, Priority__c, Amount FROM Opportunity WHERE Priority__c = 'High' AND Amount > 50000];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nPriority : ' + opp.Priority__c + '\nAmount : ' + opp.Amount);
        }
    }

    // 30. List the Opportunities with a custom field "Type_c" set to "New Business" and an Amount greater than $75,000.
    public static void oppWithNewBusinessTypeAmtGreaterThen75000() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, Type, Amount FROM Opportunity WHERE Type = 'New Business' AND Amount > 75000];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nType : ' + opp.Type + '\nAmount : ' + opp.Amount);
        }
    }

    // 32. Identify the Opportunities with a Close Date in the next 30 days and an Amount greater than $100,000, sorted by Amount in descending order.
    public static void oppClosedInNext30DaysAmtGreateThen100000() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, CloseDate, Amount FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:30 AND Amount > 100000 ORDER BY Amount DESC];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nClose Date: ' + opp.CloseDate + '\nAmount : ' + opp.Amount);
        }
    } 

    // 34. List the Opportunities that have Products with a Quantity greater than 10.
    //This query will be run on "Opportunity-Product Object"
    public static void oppWithMoreThan10ProductQuantity() {
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList = [SELECT Opportunity.Name, Quantity FROM OpportunityLineItem WHERE Product2Id != null AND Quantity > 10];

        for(OpportunityLineItem oli : oliList) {
            System.debug('\nOpportunity Name : ' + oli.Opportunity.Name + '\nProduct Quantity : ' + oli.Quantity);
        }
    }

    // 36. Find the Opportunities with a custom field "Approval_Status_c" set to "Approved" and a Close Date in the next 60 days.
    public static void oppApprovalApprovedClosedIn60Days() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, Approval_Status__c, CloseDate FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:60 AND Approval_Status__c = 'Approved'];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nApproval Status : ' + opp.Approval_Status__c + '\nClose Date : ' + opp.CloseDate);
        }
    }

    // 37. Identify the Opportunities with a Stage of "Closed/Lost" and a custom field "Reason_for_Loss_c" set to "Price."
     public static void oppClosedLostWithResonPrice() {
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Name, StageName, Reason_for_Loss__c FROM Opportunity WHERE StageName = 'Closed Lost' AND Reason_for_Loss__c = 'Price'];

        for(Opportunity opp : oppList) {
            System.debug('\nOpportunity Name : ' + opp.Name + '\nStageName : ' + opp.StageName + '\nReason_for_Loss__c : ' + opp.Reason_for_Loss__c);
        }
    }

    // 38. Retrieve the names of Contacts who are associated with multiple Opportunities.
    public static void contactWithMultipleOpp(){
        List<AggregateResult> resultList = [SELECT Contact.Name contactName FROM OpportunityContactRole GROUP BY Contact.Name HAVING COUNT(OpportunityId) > 1];

        for(AggregateResult result : resultList){
            String contactName = (String) result.get('contactName');
            System.debug('Contact Name : ' + contactName);
        }
    }
    

    // Not possible using single query.
    // 39. Find the Opportunities with a Stage of "Proposal" and an Amount greater than the average Opportunity Amount.
    public static void oppProposalGreaterThanAvg(){
        AggregateResult avgResult = [SELECT AVG(Amount) avgAmount FROM Opportunity WHERE Amount != null];

        Decimal avgAmount = (Decimal) avgResult.get('avgAmount');

        List<Opportunity> oppList = [SELECT Name, StageName, Amount FROM Opportunity WHERE StageName = 'Proposal/Price Quote' AND Amount > :avgAmount];
        for(Opportunity opp : oppList){
            System.debug('\nOpportunity Name : ' + opp.Name + '\nStage : ' + opp.StageName + '\nAmount : ' + opp.Amount);
        }
    }

    // 40. Select the Opportunities that have at least one associated Task with a status of "Completed."
    public static void oppWithOneCompletedTask(){
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Id, Name, CloseDate, (SELECT Id, Status FROM Tasks WHERE Status = 'Completed') FROM Opportunity];
        
        for(Opportunity opp : oppList){
            if(!opp.Tasks.isEmpty()){
                System.debug('\nOpportunity Name : ' + opp.Name);
            }
        }
    }
}
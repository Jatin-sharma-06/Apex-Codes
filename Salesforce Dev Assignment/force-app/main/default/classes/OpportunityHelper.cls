/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class OpportunityHelper {
    
    public static void updateOnInsert(List<Opportunity> opportunityList) {

        try {

            for(Opportunity opportunityRecord : opportunityList) {
                if( opportunityRecord.Amount == null) {
                    opportunityRecord.addError('Opportunity Amount cannot be blank.');
                } else if(opportunityRecord.Amount != null && opportunityRecord.Amount > 100000) {    //2
                    opportunityRecord.Description += ' Hot Opportunity.';
                }
            }

        }

        catch(Exception e){
            System.debug('Exception : ' + e.getMessage());
        }
    }

    public static void updateDescriptionOnUpdate(List<Opportunity> opportunityList) {

        try {
            for(Opportunity opportunityRecord : opportunityList) {
                if(opportunityRecord.StageName != null) {   //13
                    if(opportunityRecord.StageName == 'Closed Won'){
                        opportunityRecord.Description += ' Opportunity is Closed Won.';
                    }
                    else if(opportunityRecord.StageName == 'Closed Lost'){
                        opportunityRecord.Description += ' Opportunity is Closed Lost.';
                    }
                    else{
                        opportunityRecord.Description += ' Opportunity is Open.';
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('Exception : ' + e.getMessage());
        }
    }

    public static void updateReasonForLossBeforeChangeStagetoLost(List<Opportunity> opportunityList) {

        try {
            for(Opportunity opportunityRecord : opportunityList) {
                if(opportunityRecord.StageName == 'Closed Lost' && opportunityRecord.Reason_for_Loss__c == null) {
                    opportunityRecord.addError('Please select \'Reason for Loss\' before change stage to Closed Lost');
                }
            }
        }
        catch(Exception e){
            System.debug('Exception : ' + e.getMessage());
        }
    }
    
    public static void createOpportunityRelatedToAccount(List<Account> accountList) {   // 4
        try {
            List<Opportunity> opportunityList = new List<Opportunity>();
            for(Account account : accountList) {
                if(account.CreateRelatedOpportunity__c == true && account.Active__c == 'Yes') {
                    Opportunity opportunityRecord = new Opportunity();

                    opportunityRecord.AccountId = account.Id;
                    opportunityRecord.Name = account.Name;
                    opportunityRecord.StageName = 'Prospecting';
                    opportunityRecord.CloseDate = Date.today()+30;
                    opportunityRecord.Amount = 0;

                    opportunityList.add(opportunityRecord);
                }
            }
            if(!(opportunityList.isEmpty())) {
                insert opportunityList;
            }
        } 
        catch(DmlException e) {
            System.debug('DML Exception :' + e.getMessage());
        }
        catch(Exception e) {
            System.debug('Exception :' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    public static void updateAccountRecordOnOpportunityCreation(Set<Id> accountIds) {   //8
        List<Account> accountToUpdate = new List<Account>();

        List<Opportunity> opportunityList = [SELECT Amount, AccountId FROM Opportunity WHERE AccountId IN :accountIds ORDER BY CreatedDate DESC];

        Map<Id, Opportunity> latestOpportunityMap = new Map<Id, Opportunity>();

        for(Opportunity opportunityRecord : opportunityList) {
            if(!(latestOpportunityMap.containsKey(opportunityRecord.AccountId))){
                latestOpportunityMap.put(opportunityRecord.AccountId, opportunityRecord);
            }
        }

        for(Id accountId : latestOpportunityMap.keySet()) {
            Account accountRecord = new Account();

            accountRecord.Id = accountId;
            accountRecord.RecentOpportunityAmount__c = latestOpportunityMap.get(accountId).Amount;

            accountToUpdate.add(accountRecord);
        }


        if(!accountToUpdate.isEmpty()){
            update accountToUpdate;
        }
    }
    
    public static void closeOpportunitiesRelatedToAccount(List<Account> accountList){
        Set<Id> accountIdSet = new Set<Id>();

        for(Account accountRecord : accountList){
            accountIdSet.add(accountRecord.Id);
        }

        List<Opportunity> opportuityList = [SELECT Id, StageName FROM Opportunity WHERE AccountId IN :accountIdSet AND StageName != 'Closed Won'];

        for(Opportunity opportunityRecord : opportuityList){
            opportunityRecord.StageName = 'Closed Lost';
        }

        if(!opportuityList.isEmpty()){
            update opportuityList;
        }
    }

    public static void preventDeletionIfClosed(List<Opportunity> opportunityList){

        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;

        for(Opportunity opportunityRecord : opportunityList){

            if(opportunityRecord.StageName == 'Closed Won' || opportunityRecord.StageName == 'Closed Lost'){

                if(UserInfo.getProfileId() != adminProfileId){
                    opportunityRecord.addError('Only System Administrators can delete closed Opportunities.');
                }

            }

        }
    }

    public static void updateAccountRevenue(Set<Id> accountIds) {    // 34

        // if (accountIds == null || accountIds.isEmpty()) {
        //     return;
        // }

        Map<Id, Decimal> accountAmountMap = new Map<Id, Decimal>();

        for (AggregateResult ar : [ SELECT AccountId, SUM(Amount) totalAmount FROM Opportunity WHERE AccountId IN :accountIds GROUP BY AccountId ]) {
            accountAmountMap.put( (Id) ar.get('AccountId'), (Decimal) ar.get('totalAmount') );
        }

        List<Account> accListToUpdate = new List<Account>();

        for (Id accId : accountIds) {
            Account acc = new Account();
            acc.Id = accId;

            // If no Opportunities → set 0
            if (accountAmountMap.containsKey(accId)) {
                acc.AnnualRevenue = accountAmountMap.get(accId);
            } else {
                acc.AnnualRevenue = 0;
            }
            accListToUpdate.add(acc);
        }

        if (!accListToUpdate.isEmpty()) {
            update accListToUpdate;
        }
    }

        

    //Trigger Handling --- 3
    public static void calculateDiscount(List<Opportunity> opportunityList){

        for(Opportunity opportunityRecord : opportunityList){
            try{
                if(opportunityRecord.Amount != null && opportunityRecord.Quantity__c != null && opportunityRecord.Quantity__c != 0){
                    opportunityRecord.Discount__c = opportunityRecord.Amount / opportunityRecord.Quantity__c;
                }
            }
            catch(Exception e){
                System.debug('Discount calculation error: ' + e.getMessage());
            }
        }
    }
}
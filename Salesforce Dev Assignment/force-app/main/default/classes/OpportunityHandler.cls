/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class OpportunityHandler {
    //Before
    public static void onBeforeInsert(List<Opportunity> opportunityList) {  
        try {
            if(!(opportunityList.isEmpty()) && opportunityList != null) {
                OpportunityHelper.updateOnInsert(opportunityList);  //2
                // OpportunityHelper.validateOpportunityAmount(opportunityList);  //22
            }
        }
        catch(DmlException e) {
            System.debug('Before Insert DML Exception :' + e.getMessage());
        }
        catch(Exception e) {
            System.debug('Before Insert Exception :' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }
    
    public static void onBeforeUpdate(List<Opportunity> opportunityList) {  
        try {
            if(!(opportunityList.isEmpty()) && opportunityList != null) {
                OpportunityHelper.updateDescriptionOnUpdate(opportunityList);  // 13

                OpportunityHelper.updateReasonForLossBeforeChangeStagetoLost(opportunityList); //23
            }
        }
        catch(DmlException e) {
            System.debug('Before Update DML Exception :' + e.getMessage());
        }
        catch(Exception e) {
            System.debug('Before Update Exception :' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }

    public static void onBeforeDelete(List<Opportunity> opportunityList){
        if(opportunityList != null && !opportunityList.isEmpty()){
            OpportunityHelper.preventDeletionIfClosed(opportunityList);
        }
    }

    //after insert
    public static void updateAccountFieldOnCreation(Map<Id, Opportunity> opportunityRecordMap){     //8
        if(!(opportunityRecordMap.values()).isEmpty() && opportunityRecordMap != null){
            Set<Id> accountIds = new Set<Id>();

            for(Opportunity opportunityRecord : opportunityRecordMap.values()){
                if(opportunityRecord.AccountId != null) {
                    accountIds.add(opportunityRecord.AccountId);
                }
            }
            
            if(!(accountIds.isEmpty()) && accountIds != null) {
                OpportunityHelper.updateAccountRecordOnOpportunityCreation(accountIds);
            } else {
                System.debug('Account Id Set is Empty');
            }
        }
        else {
            System.debug('Account Field "Recent Opportunity Amount" not updated: Opportunity List is Empty');
        }
    }

    public static void afterInsert(List<Opportunity> oppList){
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity oppRecord : oppList){
            if(oppRecord.AccountId != null && oppRecord.Amount != null){
                accountIdSet.add(oppRecord.AccountId);
            }
        }

        if (!accountIdSet.isEmpty()) {
            OpportunityHelper.updateAccountRevenue(accountIdSet);
        }
    }

    //after update
    public static void createTaskOnStageChange(List<Opportunity> newOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {
        if(newOpportunityList != null && !(newOpportunityList.isEmpty())){
            List<Opportunity> stageChangedOpportunity = new List<Opportunity>();
            
            for(Opportunity opportunityRecord : newOpportunityList) {
                if(opportunityRecord.StageName != oldOpportunityMap.get(opportunityRecord.Id).StageName) {
                    stageChangedOpportunity.add(opportunityRecord);
                }
            }

            if(!stageChangedOpportunity.isEmpty()) {
                TaskHelper.createTaskRelatedToOpportunity(stageChangedOpportunity);
            }
        }
    }

    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {  //34

        Set<Id> accountIdSet = new Set<Id>();

        for (Opportunity newOpp : newList) {
            Opportunity oldOpp = oldMap.get(newOpp.Id);

            if (newOpp.Amount != oldOpp.Amount ||
                newOpp.AccountId != oldOpp.AccountId) {

                if (newOpp.AccountId != null)
                    accountIdSet.add(newOpp.AccountId);

                if (oldOpp.AccountId != null)
                    accountIdSet.add(oldOpp.AccountId);
            }
        }

        if (!accountIdSet.isEmpty()) {
            OpportunityHelper.updateAccountRevenue(accountIdSet);
        }
    }

    //after delete
    public static void afterDelete(List<Opportunity> oldList) {   //34
        Set<Id> accountIdSet = new Set<Id>();

        for (Opportunity opp : oldList) {
            if (opp.AccountId != null) {
                accountIdSet.add(opp.AccountId);
            }
        }

        if (!accountIdSet.isEmpty()) {
            OpportunityHelper.updateAccountRevenue(accountIdSet);
        }
    }

    //after undelete
    public static void afterUndelete(List<Opportunity> newList) {   //34

        Set<Id> accountIdSet = new Set<Id>();

        for (Opportunity opp : newList) {
            if (opp.AccountId != null) {
                accountIdSet.add(opp.AccountId);
            }
        }

        if (!accountIdSet.isEmpty()) {
            OpportunityHelper.updateAccountRevenue(accountIdSet);
        }
    }

    //Trigger Handling --- 3
    public static void calculateDiscount(List<Opportunity> opportunityList){
        OpportunityHelper.calculateDiscount(opportunityList);
    }

}
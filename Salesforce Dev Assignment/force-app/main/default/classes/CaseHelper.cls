/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class CaseHelper {
    
    public static void updateAccountRecordOnCaseCreation(Set<Id> accountIds) {  //7
        List<Account> accountToUpdate = new List<Account>();  //store accounts whose cases is create.

        List<Case> caseList = [SELECT CaseNumber, AccountId FROM Case WHERE AccountId IN :accountIds ORDER BY CreatedDate DESC];

        Map<Id, Case> latestCaseMap = new Map<Id, Case>();

        for(Case caseRecord : caseList) {
            if(!(latestCaseMap.containsKey(caseRecord.AccountId))) {
                latestCaseMap.put(caseRecord.AccountId, caseRecord);
            }
        }

        for(Id accountId : latestCaseMap.keySet()) {
            Account accountRecord = new Account();
            
            accountRecord.Id = accountId;
            accountRecord.LatestCaseNumber__c = latestCaseMap.get(accountId).CaseNumber;

            accountToUpdate.add(accountRecord);
        }

        if(!accountToUpdate.isEmpty()) {
            update accountToUpdate;
        }
    }


    public static void updateCaseCount(List<Case> caseList){

        Set<Id> accountIdSet = new Set<Id>();

        for(Case caseRecord : caseList){
            if(caseRecord.AccountId != null){
                accountIdSet.add(caseRecord.AccountId);
            }
        }

        if(accountIdSet.isEmpty()) return;

        Map<Id,Integer> partnerCaseCount = new Map<Id,Integer>();
        Map<Id,Integer> customerCaseCount = new Map<Id,Integer>();

        for(AggregateResult ar : [SELECT AccountId accountId, RecordType.DeveloperName recordTypeName, COUNT(Id) totalId FROM Case WHERE AccountId IN :accountIdSet GROUP BY AccountId, RecordType.DeveloperName]){

            Id accountId = (Id) ar.get('accountId');
            String recordTypeName = (String) ar.get('recordTypeName');
            Integer totalId = (Integer) ar.get('totalId');

            if(recordTypeName == 'PartnerCase'){
                partnerCaseCount.put(accountId, totalId);
            }

            if(recordTypeName == 'CustomerCase'){
                customerCaseCount.put(accountId, totalId);
            }
        }

        List<Account> accountList =[SELECT Id, TotalPartnerCases__c, TotalCustomerCases__c FROM Account WHERE Id IN :accountIdSet];

        for(Account accountRecord : accountList){

            accountRecord.TotalPartnerCases__c = partnerCaseCount.containsKey(accountRecord.Id) ? partnerCaseCount.get(accountRecord.Id) : 0;

            accountRecord.TotalCustomerCases__c = customerCaseCount.containsKey(accountRecord.Id) ? customerCaseCount.get(accountRecord.Id) : 0;
        }

        update accountList;
    }
}
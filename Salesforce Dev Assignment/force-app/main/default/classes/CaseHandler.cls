/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class CaseHandler {
    public static void updateCaseIdInAccount(Map<Id, Case> newCaseMap) {  //7
        if(!(newCaseMap.isEmpty()) && newCaseMap != null) {
            Set<Id> accountIds = new Set<Id>();

            for(case caseRecord : newCaseMap.values()) {
                if(caseRecord.AccountId != null) {
                    accountIds.add(caseRecord.AccountId);
                }
            }

            if(!(accountIds.isEmpty()) && accountIds != null){
                CaseHelper.updateAccountRecordOnCaseCreation(accountIds);
            } else {
                System.debug('AccountId Set is Empty');
            }
        }
        else {
            System.debug('Account Field "Latest Case Number" not updated: Case List is Empty');
        }
    }

    public static void onAfterInsert(List<Case> newCasesList){
        CaseHelper.updateCaseCount(newCasesList);
    }


}
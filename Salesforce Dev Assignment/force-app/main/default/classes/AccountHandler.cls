/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/

public class AccountHandler {

    public static void onBeforeInsert(List<Account> accountList){   
        try {
            if(!(accountList.isEmpty()) && accountList != null) {
                AccountHelper.updateAccountFieldBeforeInsert(accountList); //1, 3
            } 
        }
        catch(Exception e) {
            System.debug('Before Insert : Account List is Empty ' + e.getMessage());
        }
    }

    public static void shareAfterInsert(List<Account> newAccountList) {
        List<Account> accountList = new List<Account>();

        for(Account accountRecord : newAccountList) {
            if(accountRecord.Id != null) {
                accountList.add(accountRecord);
            }
        }    
        if(!accountList.isEmpty()) {
            // AccountHelper.sharAccountWithStandardUser(accountList);
        }
    }

    public static void onAfterInsert(List<Account> accountList){  
        try {
            if(!(accountList.isEmpty()) && accountList != null) {
                ContactHelper.createContactRelatedToAccount(accountList);   //4
                OpportunityHelper.createOpportunityRelatedToAccount(accountList);   //5
            }
        }
        catch(Exception e) {
            System.debug('After Insert : Account List is Empty ' + e.getMessage());
        }
    }

    public static void onBeforeUpdate(List<Account> accountList, Map<Id, Account> oldAccountMap) { 
        try{
            if(!(accountList.isEmpty()) && accountList != null) {
                if(!(oldAccountMap.isEmpty()) && oldAccountMap != null) {
                    AccountHelper.updateAccountFieldBeforeUpdate(accountList, oldAccountMap);   //10, 11, 12
                    AccountHelper.preventEditAfter7Days(accountList); //21
                    //Trigger Handling ---- 1
                    AccountHelper.preventAccountRecursion(accountList, oldAccountMap);
                } 
            }
        }
        catch(Exception e) {
            System.debug('Before Update : Account List is Empty ' + e.getMessage());
        }
    }

    public static void onBeforeDelete(List<Account> accountList) {
        if(accountList != null &&  !accountList.isEmpty()) {
            AccountHelper.preventActiveAccountDeletion(accountList);
            // AccountHelper.preventAccountDeletionIfOpportunityExist(accountList);    //26
            // AccountHelper.preventAccountDeletionIfCaseExist(accountList); // Q27
            AccountHelper.preventAccountDeletionIfRelatedRecordsExist(accountList);     //26, 27
        }
    }

    // After Update
    public static void updateContactHomePhone(List<Account> accountList, Map<Id, Account> oldAccountMap) { 
        try{
            if(!(accountList.isEmpty()) && accountList != null) {
                if(!(oldAccountMap.isEmpty()) && oldAccountMap != null) {

                    Map<Id, String> accountPhoneMap = new Map<Id, String>();
                    
                    for(Account accountRecord : accountList) {
                        Account oldAccount = oldAccountMap.get(accountRecord.Id);

                        // 14, 15
                        if(accountRecord.Phone != oldAccount.Phone && accountRecord.Phone != null) {
                            accountPhoneMap.put(accountRecord.Id, accountRecord.Phone);
                        }
                    }

                    if(!accountPhoneMap.isEmpty()) {
                        AccountHelper.updateRelatedContactsPhone(accountPhoneMap);
                    }
                } 
            }
        }
        catch(Exception e) {
            System.debug('After Update : Account List is Empty ' + e.getMessage());
        }
    }

    public static void updateContactMailingAddress(List<Account> accountList, Map<Id, Account> oldAccountMap) { 
        try{
            if(!(accountList.isEmpty()) && accountList != null) {
                if(!(oldAccountMap.isEmpty()) && oldAccountMap != null) {

                    Map<Id, Account> updatedAccountsMap = new Map<Id, Account>();
                    
                    for(Account accountRecord : accountList) {
                        Account oldAccount = oldAccountMap.get(accountRecord.Id);
                        //16, 17
                        if(
                            accountRecord.BillingStreet != oldAccount.BillingStreet ||
                            accountRecord.BillingCity != oldAccount.BillingCity ||
                            accountRecord.BillingState != oldAccount.BillingState ||
                            accountRecord.BillingPostalCode != oldAccount.BillingPostalCode ||
                            accountRecord.BillingCountry != oldAccount.BillingCountry){

                            updatedAccountsMap.put(accountRecord.Id, accountRecord);
                        }
                    }

                    if(!updatedAccountsMap.isEmpty()) {
                        AccountHelper.updateRelatedContactMailing(updatedAccountsMap);
                    }
                } 
            }
        }
        catch(Exception e) {
            System.debug('After Update : Account List is Empty ' + e.getMessage());
        }
    }

    public static void updateContactOwner(List<Account> newList, List<Account> oldList) {  //38

        List<Account> filteredAccounts = new List<Account>();

        for (Integer i = 0; i < newList.size(); i++) {

            Account newAcc = newList[i];
            Account oldAcc = oldList[i];

            if (newAcc.OwnerId != oldAcc.OwnerId) {
                filteredAccounts.add(newAcc);
            }
        }

        if (!filteredAccounts.isEmpty()) {
            AccountHelper.updateContactOwner(filteredAccounts);
        }
    }

    public static void updateContactOwnerWithMap(List<Account> newList, Map<Id, Account> oldMap) {   //39
        List<Account> filteredAccounts = new List<Account>();
        for (Account newAcc : newList) {
            Account oldAcc = oldMap.get(newAcc.Id);

            if (newAcc.OwnerId != oldAcc.OwnerId) {
                filteredAccounts.add(newAcc);
            }
        }

        if (!filteredAccounts.isEmpty()) {
            AccountHelper.updateContactOwnerWithMap(filteredAccounts);
        }
    }

    public static void onAfterUpdate(List<Account> newAccountList, Map<Id, Account> oldAccountMap){

        List<Account> deactivatedAccounts = new List<Account>();

        for(Account accountRecord : newAccountList){

            Account oldAccount = oldAccountMap.get(accountRecord.Id);

            if(oldAccount.Active__c == 'Yes' && accountRecord.Active__c == 'No'){
                deactivatedAccounts.add(accountRecord);
            }
        }

        if(!deactivatedAccounts.isEmpty()){
            OpportunityHelper.closeOpportunitiesRelatedToAccount(deactivatedAccounts);
        }
    }


    //Trigger Handling --- 4
    public static void afterUpdateRecursiveTrigger(List<Account> accountList){ //36

        if(TriggerExecutionControl.accountTriggerExecution){
            return;
        }

        TriggerExecutionControl.accountTriggerExecution = true;

        AccountHelper.updateRecursiveRelatedContacts(accountList);

    }

}
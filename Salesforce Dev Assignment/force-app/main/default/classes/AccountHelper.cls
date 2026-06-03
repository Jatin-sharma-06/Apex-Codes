/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class AccountHelper {
    //Trigger Handling ---- 1
    public static Boolean isFirstExecution = true;
    public static void preventAccountRecursion(List<Account> accountList, Map<Id,Account> oldAccountMap){

        if(!isFirstExecution){
            return;
        }

        isFirstExecution = false;

        for(Account accountRecord : accountList){

            Account oldAccountRecord = oldAccountMap.get(accountRecord.Id);

            if(oldAccountRecord != null && accountRecord.Description != oldAccountRecord.Description){
                accountRecord.Description = accountRecord.Description + ' - Updated by Trigger';
            }
        }

    }

    
    public static void updateAccountFieldBeforeInsert(List<Account> accountList){ 
        try{
            for(Account account : accountList) {
                if(account.Industry != null && account.Industry == 'Media'){    //1
                    account.Rating = 'Hot';
                    System.debug('Account Rating Changed to \'Hot\' based on Industry = \'Media\'');
                }

                if(account.CopyBillingToShipping__c == true){   //3
                    if(account.BillingCountryCode != null) {
                        account.ShippingCountryCode = account.BillingCountryCode;
                    }
                    if(account.BillingStreet != null) {
                        account.ShippingStreet = account.BillingStreet;
                    }
                    if(account.BillingCity != null) {
                        account.ShippingCity = account.BillingCity;
                    }
                    if(account.BillingStateCode != null) {
                        account.ShippingStateCode = account.BillingStateCode;
                    }
                    if(account.BillingPostalCode != null) {
                        account.ShippingPostalCode = account.BillingPostalCode;
                    }                   
                    System.debug('Account Shipping Address copied form Billing Address.');
                } 
            }
        }
        catch(DmlException e)  {
            System.debug('Before Insert Dml Exception : ' + e.getMessage() + '\n'  + e.getStackTraceString());
        }
        catch(Exception e) {
            System.debug('Before Insert Exception : ' + e.getMessage() + '\n'  + e.getStackTraceString());
        }
    }

    public static void updateAccountFieldBeforeUpdate(List<Account> accountList, Map<Id, Account> oldAccountMap) { 
        try{
            List<Account> updatedAccountList = new List<Account>();

            for(Account accountRecord : accountList) {
                
                Account oldAccount = oldAccountMap.get(accountRecord.Id);
                
                if(accountRecord.Phone != oldAccount.Phone){    //10
                    accountRecord.Description = 'Phone is Updated! Old Value '+ oldAccount.Phone + ' & New Value ' + accountRecord.Phone;
                    updatedAccountList.add(accountRecord);
                }

                if(accountRecord.CopyBillingToShipping__c == true) {    // 11
                    if(accountRecord.BillingCountryCode != null) {
                        accountRecord.ShippingCountryCode = oldAccount.BillingCountryCode;
                    }
                    if(accountRecord.BillingStreet != null) {
                        accountRecord.ShippingStreet = oldAccount.BillingStreet;
                    }
                    if(accountRecord.BillingCity != null) {
                        accountRecord.ShippingCity = oldAccount.BillingCity;
                    }
                    if(accountRecord.BillingStateCode != null) {
                        accountRecord.ShippingStateCode = oldAccount.BillingStateCode;
                    }
                    if(accountRecord.BillingPostalCode != null) {
                        accountRecord.ShippingPostalCode = oldAccount.BillingPostalCode;
                    }                   
                    System.debug('Account Shipping Address copied form Billing Address.');
                }

                if(accountRecord.Industry != null && accountRecord.Industry == 'Media' && accountRecord.Industry != oldAccount.Industry){    //12
                    accountRecord.Rating = 'Hot';
                    System.debug('Account Rating Changed to \'Hot\' based on Industry = \'Media\'');
                }
            }  
        } 
        catch(DmlException e)  {
            System.debug('After Update Dml Exception : ' + e.getMessage() + '\n'  + e.getStackTraceString());
        }
        catch(Exception e) {
            System.debug('After Update Exception : ' + e.getMessage() + '\n'  + e.getStackTraceString());
        }
    }

    public static void updateRelatedContactsPhone(Map<Id, String> accountPhoneMap) {
        List<Contact> contactsToUpdate = new List<Contact>();
        
        //  14
        
        
        List<Contact> contactList = [SELECT Id, AccountId, HomePhone FROM Contact WHERE AccountId IN :accountPhoneMap.keySet()];
        for(Contact contactRecord : contactList){
            contactRecord.HomePhone = accountPhoneMap.get(contactRecord.AccountId);
            contactsToUpdate.add(contactRecord);
        }


        //  15
        // List<Account> accountList = [SELECT Id, (SELECT Id, HomePhone FROM Contacts) FROM Account WHERE Id IN :accountPhoneMap.keySet()];  // Parent to child query

        // for(Account accountRecord : accountList) {
        //     for(Contact contactRecord : accountRecord.contacts) {
        //         contactRecord.HomePhone = accountPhoneMap.get(accountRecord.Id);
                
        //         contactsToUpdate.add(contactRecord);
        //     }
        // }
        // if(!contactsToUpdate.isEmpty()){
        //     update contactsToUpdate;
        // } 
    }

    public static void updateRelatedContactMailing(Map<Id, Account> updatedAccountsMap) {
        List<Contact> contactsToUpdate = new List<Contact>();
        /*
        //  16
        List<Contact> contactList = [SELECT Id, AccountId, MailingAddress  FROM Contact WHERE AccountId IN :updatedAccountsMap.keySet()];

        for(Contact contactRecord : contactList){
            Account acc = updatedAccountsMap.get(contactRecord.AccountId);
            
            contactRecord.MailingStreet = acc.BillingStreet;
            contactRecord.MailingCity = acc.BillingCity;
            contactRecord.MailingStateCode = acc.BillingStateCode;
            contactRecord.MailingPostalCode = acc.BillingPostalCode;
            contactRecord.MailingCountryCode = acc.BillingCountryCode;
            
            contactsToUpdate.add(contactRecord);
        }
        */

        //  17
        List<Account> accountList = [SELECT Id, BillingStreet, BillingCity, BillingStateCode, BillingPostalCode, BillingCountryCode, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :updatedAccountsMap.keySet()];  // Parent to child query

        for(Account accountRecord : accountList) {
            for(Contact contactRecord : accountRecord.contacts) {
                contactRecord.MailingStreet = accountRecord.BillingStreet;
                contactRecord.MailingCity = accountRecord.BillingCity;
                contactRecord.MailingStateCode = accountRecord.BillingStateCode;
                contactRecord.MailingPostalCode = accountRecord.BillingPostalCode;
                contactRecord.MailingCountryCode = accountRecord.BillingCountryCode;
                
                contactsToUpdate.add(contactRecord);
            }
        }
        

        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }  
    }

    public static void preventActiveAccountDeletion(List<Account> accountList) {
        
        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;

        for(Account accountRecord : accountList) {

            if(accountRecord.Active__c == 'Yes') {
                accountRecord.addError('Active Accounts cannot be deleted.\n');   
            }
            if(UserInfo.getProfileId() != adminProfileId) {
                accountRecord.addError('Only System Admin can delete accounts');
            }

        }
    }

    /*
    public static void preventAccountDeletionIfOpportunityExist(List<Account> accountList) {   // 26
        Set<Id> accountIds = new Set<Id>(); //find unique accounts

        for(Account accountRecord : accountList) {
            accountIds.add(accountRecord.Id);
        }

        List<Opportunity> opportunityList = [SELECT Id, AccountId FROM Opportunity WHERE AccountId In :accountIds];
        // find opp having accounts in set
        Set<Id> accountsWithOpportunities = new Set<Id>();

        for(Opportunity opportunityRecord : opportunityList) {
            accountsWithOpportunities.add(opportunityRecord.AccountId);
        }
        

        for(Account accountRecord : accountList) {
            if(accountsWithOpportunities.contains(accountRecord.Id)){
                accountRecord.addError('Account cannot be deleted because it has related Opportunities.');
            }
        }
    }

    public static void preventAccountDeletionIfCaseExist(List<Account> accountList){   // Q27
        Set<Id> accountIds = new Set<Id>();

        for(Account accountRecord : AccountList) {
            accountIds.add(accountRecord.Id);
        }

        Set<Id> accountsWithCases = new Set<Id>();

        for(Case caseRecord : [SELECT AccountId FROM Case WHERE AccountId  IN :accountIds]) {
            accountsWithCases.add(caseRecord.AccountId);
        }

        for(Account accountRecord : accountList){
            if(accountsWithCases.contains(accountRecord.Id)) {
                accountRecord.addError('Account cannot be deleted because it has related case.');
            }
        }
    }
    */
    
    // 26,27
    public static void preventAccountDeletionIfRelatedRecordsExist(List<Account> accountList) {   // Q26 + Q27

        Set<Id> accountIds = new Set<Id>();   // find unique accounts

        for(Account accountRecord : accountList) {
            accountIds.add(accountRecord.Id);
        }

        // ----- Opportunities -----
        List<Opportunity> opportunityList = [ SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accountIds];

        Set<Id> accountsWithOpportunities = new Set<Id>();

        for(Opportunity opportunityRecord : opportunityList) {
            accountsWithOpportunities.add(opportunityRecord.AccountId);
        }


        // ----- Cases -----
        List<Case> caseList = [ SELECT Id, AccountId FROM Case WHERE AccountId IN :accountIds];

        Set<Id> accountsWithCases = new Set<Id>();

        for(Case caseRecord : caseList) {
            accountsWithCases.add(caseRecord.AccountId);
        }


        // ----- Validation -----
        for(Account accountRecord : accountList) {

            if(accountsWithOpportunities.contains(accountRecord.Id)) {
                accountRecord.addError('Account cannot be deleted because it has related Opportunities.');
            }

            if(accountsWithCases.contains(accountRecord.Id)) {
                accountRecord.addError('Account cannot be deleted because it has related Cases.');
            }

        }
    }

    public static void preventEditAfter7Days(List<Account> accountList) {

        for(Account accountRecord : accountList) {
            Integer daysSinceCreation = accountRecord.CreatedDate.date().daysBetween(Date.today());

            if(daysSinceCreation > 7) {
                accountRecord.addError('Account records older than 7 days cannot be edited.');
            }

        }
    }

    //38
    public static void updateContactOwner(List<Account> accList) {
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accList) {
            accIds.add(acc.Id);
        }
        List<Contact> conList = [ SELECT Id, AccountId, OwnerId FROM Contact WHERE AccountId IN :accIds ];
        //Update Contact Owner based on Account Owner using loop.
        for (Contact con : conList) {
            for (Account acc : accList) {
                if (con.AccountId == acc.Id) {
                    con.OwnerId = acc.OwnerId;
                }
            }
        }
        if (!conList.isEmpty()) {
            update conList;
        }
    }

    public static void updateContactOwnerWithMap(List<Account> accList) {

        //  this map stores Map<AccountId, OwnerId>
        Map<Id, Id> accOwnerMap = new Map<Id, Id>();

        for (Account acc : accList) {
            accOwnerMap.put(acc.Id, acc.OwnerId);
        }

        // Get related Contacts
        List<Contact> conList = [ SELECT Id, AccountId, OwnerId FROM Contact WHERE AccountId IN :accOwnerMap.keySet() ];

        for (Contact con : conList) {
            if (accOwnerMap.containsKey(con.AccountId)) {
                con.OwnerId = accOwnerMap.get(con.AccountId);
            }
        }

        if (!conList.isEmpty()) {
            update conList;
        }
    }

    public static void shareAccountWithStandardUser(List<Account> accountList) {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User standardUser = [SELECT Id FROM User WHERE Profile.Id = :standardProfile.Id AND IsActive = true LIMIT 1];

        List<AccountShare> shareList = new List<AccountShare>();
        
        for(Account accountRecord : accountList) {
            AccountShare accountRecordShare = new AccountShare();
           
            accountRecordShare.AccountId = accountRecord.Id;
            accountRecordShare.UserOrGroupId = standardUser.Id;
            accountRecordShare.AccountAccessLevel = 'Read';
            accountRecordShare.CaseAccessLevel = 'Read';
            accountRecordShare.OpportunityAccessLevel = 'Read';
            accountRecordShare.RowCause = Schema.AccountShare.RowCause.Manual;
            
            shareList.add(accountRecordShare);
        }

        if(!shareList.isEmpty()) {
            insert shareList;
        }
    }
    

    //Trigger Handling --- 4
    public static void updateRecursiveRelatedContacts(List<Account> accountList){
        Set<Id> accountIdSet = new Set<Id>();

        for(Account accountRecord : accountList){
            accountIdSet.add(accountRecord.Id);
        }

        // if(accountIdSet.isEmpty()){
        //     return;
        // }

        List<Contact> contactList = [ SELECT Id, AccountId, Description FROM Contact WHERE AccountId IN :accountIdSet];

        for(Contact contactRecord : contactList){
            contactRecord.Description = 'Updated from Account Trigger';
        }

        if(!contactList.isEmpty()){
            update contactList;
        }

    }


}
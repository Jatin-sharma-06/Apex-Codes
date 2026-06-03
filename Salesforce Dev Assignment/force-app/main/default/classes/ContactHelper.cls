/*
Author: Jatin Sharma
Created Date: 22.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class ContactHelper {

    public static void createContactRelatedToAccount(List<Account> accountList) {   // 4
        List<Contact> contactList = new List<Contact>();
        for(Account account : accountList) {
            if(account.CreateRelatedContact__c == true){
                Contact contactRecord = new Contact();
            
                contactRecord.LastName = account.Name;
                contactRecord.AccountId = account.Id;

                contactList.add(contactRecord);
            }
        }
        if(!(contactList.isEmpty())) {
            insert contactList;
        }
    }


    public static void sendEmailToContacts(List<Contact> contacts){

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Contact_Welcome_Template' LIMIT 1];

        for(Contact contactRecord : contacts){

            if(contactRecord.Email != null){

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                mail.setTargetObjectId(contactRecord.Id);
                mail.setTemplateId(template.Id);
                mail.setSaveAsActivity(true);

                mail.setToAddresses(new String[]{contactRecord.Email});

                emailList.add(mail);
            }
        }

        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    }    

    public static void validateDuplicateEmailInContacts(List<Contact> contactRecordList) {

        Set<String> emailSet = new Set<String>();
        Set<Id> recordIds = new Set<Id>();

        for (Contact contactRecord : contactRecordList) {
            emailSet.add(contactRecord.Email);
            if (contactRecord.Id != null) {
                recordIds.add(contactRecord.Id);
            }
        }

        List<Contact> existingContacts = [ SELECT Id, Email FROM Contact WHERE Email IN :emailSet AND Id NOT IN :recordIds ];

        Set<String> existingEmailSet = new Set<String>();

        for (Contact contactRecord : existingContacts) {
            existingEmailSet.add(contactRecord.Email);
        }

        for (Contact contactRecord : contactRecordList) {
            if (existingEmailSet.contains(contactRecord.Email)) {
                contactRecord.Email.addError('Duplicate Email not allowed');
            }
        }
    }


    //apex handler ---- 2
    public static void updateAccountContactCount(List<Contact> contactList){
        Set<Id> accountIdSet = new Set<Id>();

        for(Contact contactRecord : contactList){
            if(contactRecord.AccountId != null){
                accountIdSet.add(contactRecord.AccountId);
            }
        }

        if(accountIdSet.isEmpty()){
            return;
        } 

        List<Account> accountList = [ SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIdSet];

        for(Account accountRecord : accountList){
            accountRecord.AccountContactCount__c = (Decimal)accountRecord.Contacts.size();
        }

        if(!accountList.isEmpty()){
            update accountList;
        }
    }

    public static void updateRecursiveRelatedAccounts(List<Contact> contactList){
        Set<Id> accountIdSet = new Set<Id>();

        for(Contact contactRecord : contactList){
            if(contactRecord.AccountId != null){
                accountIdSet.add(contactRecord.AccountId);
            }
        }

        // if(accountIdSet.isEmpty()){
        //     return;
        // }

        List<Account> accountList = [ SELECT Id, Description FROM Account WHERE Id IN :accountIdSet];

        for(Account accountRecord : accountList){
            accountRecord.Description = 'Updated from Contact Trigger';
        }

        if(!accountList.isEmpty()){
            update accountList;
        }
    }
}
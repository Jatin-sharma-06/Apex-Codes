/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class ContactHandler {

    public static void onAfterInsert(List<Contact> newContactsList){
        if(!newContactsList.isEmpty()) {
            ContactHelper.sendEmailToContacts(newContactsList);
        }
    }

    public static void validateDuplicateEmail(List<Contact> newContactsList) {
        List<Contact> filteredContactList = new List<Contact>();
        for(Contact contactRecord : newContactsList) {
            if(contactRecord.Email != null) {
                filteredContactList.add(contactRecord);
            }
        }

        if(!(filteredContactList.isEmpty())) {
            ContactHelper.validateDuplicateEmailInContacts(filteredContactList);
        }
    }

    
    //apex trigger handler ---- 2
    public static void onAfterDelete(List<Contact> contactList){
        ContactHelper.updateAccountContactCount(contactList);
    }

    // Trigger Handler ---- 4
    public static void afterUpdateRecursiveTrigger(List<Contact> contactList){
        if(TriggerExecutionControl.contactTriggerExecution){
            return;
        }
        
        TriggerExecutionControl.contactTriggerExecution = true;

        ContactHelper.updateRecursiveRelatedAccounts(contactList);
    }
}
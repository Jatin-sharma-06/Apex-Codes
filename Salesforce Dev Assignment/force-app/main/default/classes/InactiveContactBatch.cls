/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
global class InactiveContactBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    Integer totalProcessed = 0;
    Integer totalInactiveUpdated = 0;
    Integer totalFailed = 0;

    List<String> errorMessages = new List<String>();

    // start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, LastModifiedDate, Is_Inactive__c FROM Contact WHERE LastModifiedDate < LAST_N_MONTHS:1';
        return Database.getQueryLocator(query);
    }


    // execute method
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
       
        totalProcessed += scope.size();
       
        for(Contact con : scope){
            con.Is_Inactive__c = true;
        }
      
        Database.SaveResult[] results = Database.update(scope, false);

        for(Integer i = 0; i < results.size(); i++){
            if(results[i].isSuccess()){
                totalInactiveUpdated++;
            }
            else{
                totalFailed++;
                for(Database.Error err : results[i].getErrors()){
                    errorMessages.add('Contact Id: ' + scope[i].Id + ' | Error: ' + err.getMessage());
                }
            }
        }
    }


    // finish method
    global void finish(Database.BatchableContext BC) {
        System.debug('Total Processed Contacts : ' + totalProcessed);
        System.debug('Total Inactive Updated   : ' + totalInactiveUpdated);
        System.debug('Total Failed Updates     : ' + totalFailed);

        if(!errorMessages.isEmpty()){
            System.debug('Failure Details:');
            for(String msg : errorMessages){
                System.debug(msg);
            }
        }
    }
}
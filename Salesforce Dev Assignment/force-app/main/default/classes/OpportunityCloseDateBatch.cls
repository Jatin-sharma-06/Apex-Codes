/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
global class OpportunityCloseDateBatch implements Database.Batchable<SObject>, Database.Stateful {

    Integer totalProcessedOpp = 0;
    Integer totalSuccess = 0;
    Integer totalFailed = 0;

    List<String> errorMessages = new List<String>();

    // start method 
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, StageName, CloseDate FROM Opportunity WHERE StageName = \'Closed Won\' AND CloseDate == System.';
        
        return Database.getQueryLocator(query);
    }

    // execute method
    global void execute(Database.BatchableContext BC, List<Opportunity> opportunityScope) {
        totalProcessedOpp += opportunityScope.size();
        for(Opportunity opportunityRecord : opportunityScope) {
            opportunityRecord.CloseDate = System.today();
        }
        Database.SaveResult[]  results = Database.update(opportunityScope, false);
        for(Integer i = 0; i < results.size(); i++) {
            if(results[i].isSuccess()) {
                totalSuccess++;
            } else {
                totalFailed++;
                for(Database.Error err : results[i].getErrors()){
                    errorMessages.add('Opportunity Id: ' + opportunityScope[i].Id + '\nError: ' + err.getMessage());
                }
            }
        }
    }

    // finish method

    global void finish(Database.BatchableContext BC) {
        System.debug('\nTotal Processed Opportunity : ' + totalProcessedOpp);
        System.debug('\nTotal Success               : ' + totalSuccess);
        System.debug('\nTotal Failed                : ' + totalFailed);

        if(!errorMessages.isEmpty()) {
            System.debug('Failure Reasons: ');
            for(String msg : errorMessages) {
                System.debug(msg);
            }
        }
    }
}
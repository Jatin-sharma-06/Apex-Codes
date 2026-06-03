/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class TaskHelper {
    public static void createTaskRelatedToOpportunity(List<Opportunity> stageChangedOpportunity){
        if(!stageChangedOpportunity.isEmpty() && stageChangedOpportunity != null) {
            List<Task> taskList = new List<Task>();

            for(Opportunity opportunityRecord : stageChangedOpportunity) {
                Task taskRecord = new Task();
                taskRecord.Subject = 'Opportunity Stage Changed';
                taskRecord.Status = 'Not Started';
                taskRecord.Priority = 'Normal';
                taskRecord.ActivityDate = Date.today();
                taskRecord.WhatId = opportunityRecord.Id; //Assign task to opportunity

                taskList.add(taskRecord);
            }

            if(!taskList.isEmpty()) {
                insert taskList;
            }
        }
    }
}
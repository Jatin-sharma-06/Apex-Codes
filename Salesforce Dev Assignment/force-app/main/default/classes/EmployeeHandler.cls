/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class EmployeeHandler {
    public static void onAfterInsert(List<Employee__c> newEmployees){
        if(newEmployees != null && !(newEmployees.isEmpty())){
            EmployeeHelper.updatePresentEmployeeCount(newEmployees);
        }
    }

    public static void onAfterDelete(List<Employee__c> oldEmployees){
        if(!(oldEmployees.isEmpty()) && oldEmployees != null) {
            EmployeeHelper.updateLeftEmployeeCount(oldEmployees);
            EmployeeHelper.updatePresentEmployeeCount(oldEmployees);
        }
    }

    public static void onAfterUndelete(List<Employee__c> newEmployees){
        if(!(newEmployees.isEmpty()) && newEmployees != null) {
            EmployeeHelper.setEmployeeActive(newEmployees);
            EmployeeHelper.updateLeftEmployeeCountOnUndelete(newEmployees);
            EmployeeHelper.updatePresentEmployeeCount(newEmployees);
        }
    }

    public static void onAfterUpdate(List<Employee__c> newEmployeeList, Map<Id,Employee__c> oldEmployeeMap){
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employeeRecord : newEmployeeList){
            Employee__c oldEmployee = oldEmployeeMap.get(employeeRecord.Id);
            if(employeeRecord.AccountName__c != oldEmployee.AccountName__c){
                if(employeeRecord.AccountName__c != null)
                    accountIds.add(employeeRecord.AccountName__c);
                if(oldEmployee.AccountName__c != null)
                    accountIds.add(oldEmployee.AccountName__c);
            }
        }

        EmployeeHelper.recalculatePresentEmployeeCount(accountIds);
    }
    
}
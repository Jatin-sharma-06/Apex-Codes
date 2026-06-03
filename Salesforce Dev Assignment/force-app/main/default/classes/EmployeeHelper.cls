/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class EmployeeHelper {
    
    public static void updatePresentEmployeeCount(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();

        for(Employee__c employeeRecord : employeeList) {
            if(employeeRecord.AccountName__c != null) {
                accountIds.add(employeeRecord.AccountName__c);
            }
        }

        if(accountIds.isEmpty()) {
            return;
        }

        List<Account> accountList = [SELECT Id, PresentEmployeeCount__c, (SELECT Id, Active__c FROM Employees__r) FROM Account WHERE Id IN :accountIds];
        
        for(Account AccountRecord : accountList) {
            Integer presentCount = 0;

            for(Employee__c employeeRecord: AccountRecord.Employees__r) {
                if(employeeRecord.Active__c == true) {
                    presentCount++;
                }
            }

            AccountRecord.PresentEmployeeCount__c = presentCount;
        }

        update accountList;
    }

    public static void updateLeftEmployeeCount(List<Employee__c> oldEmployees){
        Map<Id, Integer> accountCountMap = new Map<Id, Integer>();
        for(Employee__c employeeRecord : oldEmployees){
            if(employeeRecord.AccountName__c != null){
                if(!accountCountMap.containsKey(employeeRecord.AccountName__c)){
                    accountCountMap.put(employeeRecord.AccountName__c,1);
                }
                else{
                    accountCountMap.put(employeeRecord.AccountName__c, accountCountMap.get(employeeRecord.AccountName__c)+1);
                }
            }
        }

        List<Account> accountList =[SELECT Id, LeftEmployeeCount__c FROM Account WHERE Id IN :accountCountMap.keySet()];

        for(Account accountRecord : accountList){
            Decimal leftCount = (accountRecord.LeftEmployeeCount__c == null ? 0 : accountRecord.LeftEmployeeCount__c);
            accountRecord.LeftEmployeeCount__c = leftCount + accountCountMap.get(accountRecord.Id);
        }

        update accountList;
    }

    public static void updateLeftEmployeeCountOnUndelete(List<Employee__c> newEmployees){
        Map<Id, Integer> accountCountMap = new Map<Id, Integer>();

        for(Employee__c employeeRecord : newEmployees){
            if(employeeRecord.AccountName__c != null){
                if(!accountCountMap.containsKey(employeeRecord.AccountName__c)){
                    accountCountMap.put(employeeRecord.AccountName__c, 1);
                }
                else{
                    accountCountMap.put(employeeRecord.AccountName__c, accountCountMap.get(employeeRecord.AccountName__c) + 1);
                }
            }
        }

        List<Account> accountList = [ SELECT Id, LeftEmployeeCount__c FROM Account WHERE Id IN :accountCountMap.keySet()];

        for(Account accountRecord : accountList){
            Decimal leftCount = (accountRecord.LeftEmployeeCount__c == null ? 0 : accountRecord.LeftEmployeeCount__c);

            accountRecord.LeftEmployeeCount__c =
            leftCount - accountCountMap.get(accountRecord.Id);
        }
        update accountList;
    }

    public static void setEmployeeActive(List<Employee__c> employees){
        List<Employee__c> employeeToUpdate = new List<Employee__c>();
        
        for(Employee__c employeeRecord : employees){
            Employee__c updatedEmp = new Employee__c();

            updatedEmp.Id = employeeRecord.Id;
            updatedEmp.Active__c = true;

            employeeToUpdate.add(updatedEmp);
        }
        if(!employeeToUpdate.isEmpty()){
            update employeeToUpdate;
        }    
    }   

    public static void recalculatePresentEmployeeCount(Set<Id> accountIds){
        Map<Id,Integer> employeeCountMap = new Map<Id,Integer>();
        for(AggregateResult ar : [SELECT AccountName__c accountName, COUNT(Id) totalId FROM Employee__c WHERE Active__c = true AND AccountName__c IN :accountIds GROUP BY AccountName__c]){
            employeeCountMap.put((Id)ar.get('accountName'), (Integer)ar.get('totalId'));
        }

        List<Account> accountList = [SELECT Id, PresentEmployeeCount__c FROM Account WHERE Id IN :accountIds];

        for(Account accountRecord : accountList){
            accountRecord.PresentEmployeeCount__c = employeeCountMap.containsKey(accountRecord.Id) ? employeeCountMap.get(accountRecord.Id) : 0;
        }

        update accountList;
    }

    
}
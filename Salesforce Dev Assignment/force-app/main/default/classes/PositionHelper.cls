/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class PositionHelper {
    public static void updateFieldsBasedOnPosition(List<Position__c> positionList) {   //4
        try {
            for(Position__c position : positionList) {
                if(position.PositionType__c == 'New') {
                    if(position.OpenDate__c == null){
                        position.OpenDate__c = Date.today();
                        System.debug('Default : Open Date assigned today.');
                    }
                    if(position.MinPay__c == null){
                        position.MinPay__c = 10000;
                        System.debug('Default : Min Pay = 10000');

                    }
                    if(position.MaxPay__c == null){
                        position.MaxPay__c = 15000;
                        System.debug('Default : Max Pay = 15000');
                    }
                }
            }
        } 
        catch(DmlException e) {
            System.debug('Before Insert DML Exception :' + e.getMessage());
        }
        catch(Exception e) {
            System.debug('Before Insert DML Exception :' + e.getMessage() + '\n' + e.getStackTraceString());
        }
    }
}
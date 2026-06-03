/*
Author: Jatin Sharma
Created Date: 15.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class PositionHandler {
    public static void onBeforeInsert(List<Position__c> positionList){  
        try {
            if(!(positionList.isEmpty()) && positionList != null) {
                PositionHelper.updateFieldsBasedOnPosition(positionList);  //4
            }
        }
        catch(Exception e) {
            System.debug('Before Insert : Position List is Empty ' + e.getMessage());
        }
    }
}
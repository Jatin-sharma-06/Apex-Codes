/*
Author: Jatin Sharma
Created Date: 25.03.2026
Last Modified By: Jatin Sharma
Description: 

*/
public class UserHandler {
/*  public static void addAdminsToGroupHandler(List<User> newUsersList) {
        List<User> filteredUsers = new List<User>();

        for(User userRecord : newUsersList) {
            if(userRecord.IsActive == true && userRecord.ProfileId != null && userRecord.Profile.Name == 'System Administrator') {
                filteredUsers.add(userRecord);
            }
        }

        if(!filteredUsers.isEmpty()) {
            UserHelper.addUsersToAdminsGroup(filteredUsers);
        }
    }
*/

    public static void addAdminsToGroupHandler(List<User> newUsersList) {
        List<User> filteredUsers = new List<User>();
        Set<Id> profileIds = new Set<Id>();

        for (User usr : newUsersList) {
            if (usr.ProfileId != null) {
                profileIds.add(usr.ProfileId);
            }
        }

        // Query Profiles
        Map<Id, Profile> profileMap = new Map<Id, Profile>( [SELECT Id, Name FROM Profile WHERE Id IN :profileIds] );

        for (User usr : newUsersList) {
            Profile prof = profileMap.get(usr.ProfileId);
            if (usr.IsActive == true && prof != null && prof.Name == 'System Administrator') {
                filteredUsers.add(usr);
            }
        } 

        if (!filteredUsers.isEmpty()) {
            UserHelper.addUsersToAdminsGroup(filteredUsers);
        }
    }    
}
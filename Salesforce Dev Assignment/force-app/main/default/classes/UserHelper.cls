public class UserHelper {
    public static void addUsersToAdminsGroup(List<User> usersList) {
        Group adminGroup = [ SELECT Id FROM Group WHERE Name = 'Admins' AND Type = 'Regular' LIMIT 1 ];

        List<GroupMember> membersToInsert = new List<GroupMember>();

        for (User userRecord : usersList) {

            GroupMember grpMember = new GroupMember();
            grpMember.GroupId = adminGroup.Id;
            grpMember.UserOrGroupId = userRecord.Id;

            membersToInsert.add(grpMember);
        }

        if (!membersToInsert.isEmpty()) {
            insert membersToInsert;
        }
    }
}
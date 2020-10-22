@IsTest
public with sharing class UserDataManagerTest {
    
    @IsTest
    public static void test() {
        List<User> users = UserDataManager.getUser(new Set<Id>{UserInfo.getUserId()});
        System.assert(users.size() == 1);
    }

}

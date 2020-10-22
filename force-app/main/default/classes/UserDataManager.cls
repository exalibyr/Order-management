public with sharing class UserDataManager {
    
    public static List<User> getUser(Set<Id> ids) {
        return ([
            SELECT Id, IsManager__c
            FROM User 
            WHERE Id IN :ids
        ]);
    }
}

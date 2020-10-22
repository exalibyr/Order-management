public with sharing class AccountDataManager {
    
    public static List<Account> getById(Set<Id> ids) {
        return ([
            SELECT Name, AccountNumber
            FROM Account
            WHERE Id IN :ids
        ]);
    }


}

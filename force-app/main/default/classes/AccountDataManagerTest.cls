@IsTest
public with sharing class AccountDataManagerTest {
    
    @IsTest
    public static void testGetById() {
        Account account = TestUtils.createAccount();
        insert account;

        List<Account> accounts = AccountDataManager.getById(new Set<Id>{account.Id});
        Account data = accounts.get(0);
        System.assertEquals(account.Name, data.Name);
        System.assertEquals(account.AccountNumber, data.AccountNumber);
    }

}

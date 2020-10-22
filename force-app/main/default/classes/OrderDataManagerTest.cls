@IsTest
public with sharing class OrderDataManagerTest {
    
    @IsTest
    public static void testGetOrderMap() {
        Account account = TestUtils.createAccount();
        insert account;
        Order_c__c order = TestUtils.createOrder(account.Id);
        insert order;

        Map<Id, Order_c__c> orderMap = OrderDataManager.getOrderMap(new Set<Id>{order.Id});
        Order_c__c data = orderMap.get(order.Id);
        System.assertEquals(order.TotalPrice__c, data.TotalPrice__c);
        System.assertEquals(order.TotalProductCount__c, data.TotalProductCount__c);
    }

}

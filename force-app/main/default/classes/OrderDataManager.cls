public with sharing class OrderDataManager {
    
    public static Map<Id, Order_c__c> getOrderMap(Set<Id> ids) {
        return new Map<Id,Order_c__c>([
            SELECT Id, TotalProductCount__c, TotalPrice__c
            FROM Order_c__c
            WHERE Id IN :ids
        ]);
    }

}

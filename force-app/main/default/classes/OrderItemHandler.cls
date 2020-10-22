public with sharing class OrderItemHandler {
    
    public static Set<Id> getOrderIds(List<OrderItem_c__c> orderItems) {
        Set<Id> orderIds = new Set<Id>();
        for (OrderItem_c__c item : orderItems) {
            orderIds.add(item.Order_c__c);
        }
        return orderIds;
    }

    public static void handleOrder(List<OrderItem_c__c> orderItems) {
        Set<Id> orderIds = OrderItemHandler.getOrderIds(orderItems);
        Map<Id, Order_c__c> orderMap = OrderDataManager.getOrderMap(orderIds);
        for (OrderItem_c__c item : orderItems) {
            Order_c__c order = orderMap.get(item.Order_c__c);
            order.TotalProductCount__c += item.Quantity__c;
            order.TotalPrice__c += item.Price__c * item.Quantity__c;
        }
        update orderMap.values();
    }

}

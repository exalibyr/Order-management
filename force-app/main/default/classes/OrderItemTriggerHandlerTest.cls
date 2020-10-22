@IsTest
public with sharing class OrderItemTriggerHandlerTest {
    
    @IsTest
    public static void testGetOrderIds() {
        Account account = TestUtils.createAccount();
        insert account;
        Order_c__c order = TestUtils.createOrder(account.Id);
        insert order;
        List<Product_c__c> products = TestUtils.createProducts();
        insert products;
        OrderItem_c__c orderItem = TestUtils.createOrderItem(order.Id, products.get(0));
        insert orderItem;

        Set<Id> ids = OrderItemHandler.getOrderIds(new List<OrderItem_c__c>{orderItem});
        System.assert(ids.contains(order.Id));
    }

    @IsTest
    public static void testHandleOrder() {
        List<Product_c__c> testData = TestUtils.createProducts();
        insert testData;
        Account account = TestUtils.createAccount();
        insert account;
        List<Id> productIds = new List<Id>();
        for (Product_c__c p : testData) {
            productIds.add(p.Id);
        }
        
        OrderManagementService.checkOut(productIds, account.Id);
        Order_c__c order = ([
            SELECT Id, Name, TotalProductCount__c, TotalPrice__c, Account__c
            FROM Order_c__c
            WHERE Account__c = :account.Id
        ]);
        System.assertEquals(account.Id, order.Account__c);
        System.assertEquals(account.Name, order.Name);

        List<OrderItem_c__c> orderItems = ([
            SELECT Id, Order_c__c, Product_c__c, Quantity__c, Price__c
            FROM OrderItem_c__c
            WHERE Order_c__c = :order.Id
        ]);
        Double totalPrice = 0;
        Double totalAmount = 0;
        Map<Id, Integer> idPriceMap = new Map<Id, Integer>();
        for (Product_c__c product : testData) {
            idPriceMap.put(product.Id, Integer.valueOf(product.Price__c));
            totalAmount++;
            totalPrice += product.Price__c;
        }
        for (OrderItem_c__c item : orderItems) {
            System.assertEquals(item.Order_c__c, order.Id);
            System.assert(idPriceMap.keySet().contains(item.Product_c__c));  
            System.assert(idPriceMap.values().contains(Integer.valueOf(item.Price__c)));  
        }
        System.assertEquals(totalAmount, order.TotalProductCount__c);
        System.assertEquals(totalPrice, order.TotalPrice__c);
    }

}

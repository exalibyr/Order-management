@IsTest
public with sharing class OrderManagementServiceTest {
    
    @IsTest
    public static void testGetAccount() {
        Account account = TestUtils.createAccount();
        insert account;

        Account data = OrderManagementService.getAccount(account.Id);
        System.assertEquals(account.Name, data.Name);
        System.assertEquals(account.AccountNumber, data.AccountNumber);
    }

    @IsTest
    public static void testFindProducts() {
        List<Product_c__c> testData = TestUtils.createProducts();
        insert testData;

        List<Product_c__c> products = OrderManagementService.findProducts(
            '',
            new List<String> {''},
            new List<String> {''}
        );
        System.assert(products.isEmpty());

        products = OrderManagementService.findProducts(
            '',
            new List<String> {'Type 1', 'Type 2', 'Type 3'},
            new List<String> {'Family 1', 'Family 2', 'Family 3'}
        );
        System.assert(products.size() == 3);

        products = OrderManagementService.findProducts(
            '',
            new List<String> {'Type 1'},
            new List<String> {'Family 1'}
        );
        System.assert(products.size() == 1);
        Product_c__c data = products.get(0);
        System.assertEquals('name 1', data.Name);
        System.assertEquals('desc 1', data.Description__c);
        System.assertEquals('Type 1', data.Type__c);
        System.assertEquals('Family 1', data.Family__c);

        products = OrderManagementService.findProducts(
            '2',
            new List<String> {'Type 1', 'Type 2', 'Type 3'},
            new List<String> {'Family 1', 'Family 2', 'Family 3'}
        );
        System.assert(products.size() == 1);
        data = products.get(0);
        System.assertEquals('name 2', data.Name);
        System.assertEquals('desc 2', data.Description__c);
        System.assertEquals('Type 2', data.Type__c);
        System.assertEquals('Family 2', data.Family__c);
    }

    @IsTest
    public static void testGetUser() {
        User user = OrderManagementService.getUser(UserInfo.getUserId());
        System.assert(user != null);
    }

    @IsTest
    public static void testcheckout() {
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

public with sharing class TestUtils {
    
    public static Account createAccount() {
        Account account = new Account(
            Name = 'test',
            AccountNumber = '2342342'
        );
        return account;
    }

    public static Order_c__c createOrder(Id accountId) {
        Order_c__c order = new Order_c__c(
            Account__c = accountId,
            TotalProductCount__c = 1, 
            TotalPrice__c = 100
        );
        return order;
    }

    public static List<Product_c__c> createProducts() {
        List<Product_c__c> testData = new List<Product_c__c>{
            new Product_c__c(
                Name = 'name 1',
                Description__c = 'desc 1',
                Type__c = 'Type 1',
                Family__c = 'Family 1', 
                Price__c = 100
            ),
            new Product_c__c(
                Name = 'name 2',
                Description__c = 'desc 2',
                Type__c = 'Type 2',
                Family__c = 'Family 2',
                Price__c = 200
            ),
            new Product_c__c(
                Name = 'name 3',
                Description__c = 'desc 3',
                Type__c = 'Type 3',
                Family__c = 'Family 3',
                Price__c = 500
            )
        };
        return testData;
    }

    public static OrderItem_c__c createOrderItem(Id orderId, Product_c__c product) {
        return new OrderItem_c__c(
            Order_c__c = orderId,
            Product_c__c = product.Id,
            Quantity__c = 1,
            Price__c = product.Price__c
        );
    }
}

public without sharing class OrderManagementService {
    
    @AuraEnabled(cacheable=true)
    public static Account getAccount(String id) {
        List<Account> accounts = AccountDataManager.getById(new Set<Id> {id});
        System.debug(accounts);
        return accounts.isEmpty() ? null : accounts.get(0);
    }

    @AuraEnabled(cacheable=true)
    public static List<Product_c__c> findProducts(String name, List<String> types ,List<String> families) {
        List<Product_c__c> products = ProductDataManager.getProducts(name, types, families);
        System.debug(products);
        return products;
    }

    @AuraEnabled(cacheable=true)
    public static User getUser(String id){
        List<User> users = UserDataManager.getUser(new Set<Id> {id});
        System.debug(users);
        return users.isEmpty() ? null : users.get(0);
    }

    @AuraEnabled
    public static Boolean checkOut(List<Id> productIds, String accountId) {
        try {
            Set<Id> ids = new Set<Id>();
            Map<Id, Integer> idAmountProductMap = new Map<Id, Integer>();
            for (Id id : productIds) {
                ids.add(id);
                if (idAmountProductMap.containsKey(id)) {
                    Integer amount = idAmountProductMap.get(id);
                    idAmountProductMap.put(id, amount + 1);
                } else {
                    idAmountProductMap.put(id, 1);
                }
            }
            Account account = getAccount(accountId);
            List<Product_c__c> products = ProductDataManager.getProducts(ids);
            
            Order_c__c order = new Order_c__c(
                Name = account.Name,
                Account__c = account.Id, 
                TotalProductCount__c = 0,
                TotalPrice__c = 0
            );
            insert order;
            List<OrderItem_c__c> orderItems = new List<OrderItem_c__c>();
            for (Product_c__c product : products) {
                orderItems.add(
                    new OrderItem_c__c(
                        Order_c__c = order.Id,
                        Product_c__c = product.Id,
                        Quantity__c = idAmountProductMap.get(product.Id),
                        Price__c = product.Price__c
                    )
                );
            }
            insert orderItems;
            return true;
        } catch (Exception e) {
            System.debug(e);
            return false;
        }
    }

    public class ProductWrapper {

        public Product_c__c product;
        public Integer amount;

    }

}

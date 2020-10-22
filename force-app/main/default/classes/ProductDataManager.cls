public with sharing class ProductDataManager {
    
    public static List<Product_c__c> getProducts(String name, List<String> types , List<String> families) {
        if (name == null) {
            return null;
        } else {
            String nameKey = '%' + name + '%';
            System.debug(types);
            System.debug(families);
            return ([
                SELECT Id, Name, Description__c, Type__c, Family__c
                FROM Product_c__c
                WHERE Name LIKE :nameKey
                AND Family__c IN :families
                AND Type__c IN :types
            ]);
        }
    }

    public static List<Product_c__c> getProducts(Set<Id> ids) {
        return ([
                SELECT Id, Price__c
                FROM Product_c__c
                WHERE Id IN :ids
            ]);
    }

}

@IsTest
public with sharing class ProductDataManagerTest {
    
    @IsTest
    public static void testGetProducts() {
        List<Product_c__c> testData = TestUtils.createProducts();
        insert testData;

        List<Product_c__c> products = ProductDataManager.getProducts(
            '',
            new List<String> {''},
            new List<String> {''}
        );
        System.assert(products.isEmpty());

        products = ProductDataManager.getProducts(
            '',
            new List<String> {'Type 1', 'Type 2', 'Type 3'},
            new List<String> {'Family 1', 'Family 2', 'Family 3'}
        );
        System.assert(products.size() == 3);

        products = ProductDataManager.getProducts(
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

        products = ProductDataManager.getProducts(
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
    public static void testGetProductsByIds() {
        List<Product_c__c> testData = TestUtils.createProducts();
        insert testData;

        Set<Id> ids = new Set<Id>();
        for (Product_c__c p : testData) {
            ids.add(p.Id);
        }

        List<Product_c__c> products = ProductDataManager.getProducts(ids);
        System.assertEquals(3, products.size());
    }

}

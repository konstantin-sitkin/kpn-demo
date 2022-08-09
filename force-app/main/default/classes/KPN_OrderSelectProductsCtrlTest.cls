/**
 * @description  : KPN_OrderSelectProductsCtrl Test
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
**/
@IsTest
private class KPN_OrderSelectProductsCtrlTest {
   
    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
    }

    @isTest
    static void testGetOrderableProductsCount() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        List<PricebookEntry> pbes = [
            SELECT Id, IsActive
            FROM PricebookEntry
        ];
        Integer pbesTotalDefault = pbes.size();
        Integer pbesToDeleteCount = 10;
        List<PricebookEntry> pbesToDelete = new List<PricebookEntry>();
        for (Integer i = 0; i < pbesToDeleteCount; i++) {
            pbesToDelete.add(pbes.get(i));
            pbes.remove(i);
        }
        delete pbesToDelete;
        List<PricebookEntry> pbesToUpdate = new List<PricebookEntry>();
        Integer pbesToDeactivateCount = 20;
        for (Integer i = 0; i < pbesToDeactivateCount; i++) {
            pbes.get(i).IsActive = false;
            pbesToUpdate.add(pbes.get(i));
        }
        update pbesToUpdate;

        Test.startTest();
        Integer actualPbesCount = KPN_OrderSelectProductsCtrl.getOrderableProductsCount(orderId);
        Test.stopTest();

        Integer expectedPbesCount = pbesTotalDefault - pbesToDeleteCount - pbesToDeactivateCount;
        System.assertEquals(expectedPbesCount, actualPbesCount, 'method should return correct PBEs count');
    } 


    @isTest
    static void testGetOrderableProductsOffset0() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.startTest();
        KPN_OrderSelectProductsCtrl.AvailableProductsResponse res = KPN_OrderSelectProductsCtrl.getOrderableProducts(orderId, 0);
        Test.stopTest();

        System.assertEquals(KPN_AppConstants.PRODUCTS_PAGE_SIZE, res.pageSize, 'page size should be saved in response');
        System.assertNotEquals(0, res.availableProducts.size(), 'products should be returned');
        System.assert(res.availableProducts.size() <= KPN_AppConstants.PRODUCTS_PAGE_SIZE, 'paged products cannot exceed page size');
        System.assert(res.availableProductsCount <= KPN_AppConstants.PRODUCTS_PAGE_SIZE, 'products count should be equal to products');
    }

    @isTest
    static void testGetOrderableProductsOffsetMultiple() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;

        Test.startTest();
        KPN_OrderSelectProductsCtrl.AvailableProductsResponse resOffset1 = KPN_OrderSelectProductsCtrl.getOrderableProducts(orderId, 0);
        KPN_OrderSelectProductsCtrl.AvailableProductsResponse resOffset2 = KPN_OrderSelectProductsCtrl.getOrderableProducts(orderId, KPN_AppConstants.PRODUCTS_PAGE_SIZE);
        KPN_OrderSelectProductsCtrl.AvailableProductsResponse resOffset3 = KPN_OrderSelectProductsCtrl.getOrderableProducts(orderId, KPN_AppConstants.PRODUCTS_PAGE_SIZE * 2);
        Test.stopTest();

        Map<String, Integer> countProductsMap = new Map<String, Integer>();
        List<KPN_OrderSelectProductsCtrl.AvailableProduct> availableProducts = new List<KPN_OrderSelectProductsCtrl.AvailableProduct>();
        availableProducts.addAll(resOffset1.availableProducts);
        availableProducts.addAll(resOffset2.availableProducts);
        availableProducts.addAll(resOffset3.availableProducts);
        for (KPN_OrderSelectProductsCtrl.AvailableProduct availableProduct : availableProducts) {
            String key = availableProduct.pbeId;
            if (!countProductsMap.containsKey(key)) {
                countProductsMap.put(key, 0);
            }
            countProductsMap.put(key, countProductsMap.get(key) + 1);
            System.assertEquals(1, countProductsMap.get(key), 'each product should appear only in a single page');
        }
    }

}
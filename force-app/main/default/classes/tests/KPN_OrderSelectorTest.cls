/**
 * @description  : KPN_OrderSelector Test
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
**/
@IsTest
private class KPN_OrderSelectorTest {
    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
        KPN_TestDataFactory.createOrderItems(order1.Id, 10);
    }

    @isTest
    static void testGetByIdNull() {
        Id orderId = null;
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            KPN_OrderSelector.getById(orderId);
        } catch (KPN_OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'an exception should be thrown on null id');
    }

    @isTest
    static void testGetByIdWithChildrenNull() {
        Id orderId = null;
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            KPN_OrderSelector.getByIdWithChildren(orderId);
        } catch (KPN_OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'an exception should be thrown on null id');
    }

    @isTest
    static void testGetByIdRecordFound() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Order actualOrder;
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            actualOrder = KPN_OrderSelector.getById(orderId);
        } catch (KPN_OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, actualOrder, 'an order should be returned');
        System.assertEquals(orderId, actualOrder.Id, 'an exact order should be found by id');
    }

    @isTest
    static void testGetByIdWithChildrenRecordFound() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Order actualOrder;
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            actualOrder = KPN_OrderSelector.getByIdWithChildren(orderId);
        } catch (KPN_OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, actualOrder, 'an order should be returned');
        System.assertEquals(orderId, actualOrder.Id, 'an exact order should be found by id');
        System.assert(!actualOrder.OrderItems.isEmpty(), 'order items should be returned with order');
    }
}

/**
 * @description  : KPN_OrderProductCtrl Test
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
 **/
@IsTest
private class KPN_OrderProductCtrlTest {
    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
    }

    @isTest
    static void testAddProductNew() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE IsActive = TRUE LIMIT 1].Id;

        Test.startTest();
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        Test.stopTest();

        List<OrderItem> orderItems = KPN_OrderItemSelector.getByOrderId(orderId);
        System.assert(!orderItems.isEmpty(), 'should return order items');
        System.assertEquals(1, orderItems.get(0).Quantity, 'an order item record should be created with quantity 1');
    }

    @isTest
    static void testAddProductDouble() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE IsActive = TRUE LIMIT 1].Id;

        Test.startTest();
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        Test.stopTest();

        List<OrderItem> orderItems = KPN_OrderItemSelector.getByOrderId(orderId);
        System.assert(!orderItems.isEmpty(), 'should return order items');
        System.assertEquals(2, orderItems.get(0).Quantity, 'an existing order item record quantity should be increased');
    }
}

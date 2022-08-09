@IsTest
private class KPN_OrderViewOrderItemsCtrlTest {
    
    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
    }

    @isTest
    static void testGetOrderItems() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Integer orderItemSize = 201;
        KPN_TestDataFactory.createOrderItems(orderId, orderItemSize);

        Test.startTest();
        List<OrderItem> orderItemsActual = KPN_OrderViewOrderItemsCtrl.getOrderItems(orderId);
        Test.stopTest();

        System.assert(!orderItemsActual.isEmpty(), 'should return order items');
        System.assertEquals(orderItemSize, orderItemsActual.size(), 'all order items should be returned');
    }
    
}
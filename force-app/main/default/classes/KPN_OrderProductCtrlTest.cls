@IsTest
private class KPN_OrderProductCtrlTest {
    
    @testSetup
    static void setup() {
        TestDataFactory.createProductsAndEntries();
        Account baseAcc = TestDataFactory.createAccount();
        Contract baseCtr = TestDataFactory.createContract(baseAcc.Id);
        Order order1 = TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
    }

    @isTest
    static void testAddProductNew() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE IsActive = TRUE LIMIT 1].Id;

        Test.startTest();
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        Test.stopTest();

        List<OrderItem> orderItems = OrderItemSelector.getByOrderId(orderId);
        System.assert(!orderItems.isEmpty(), 'should return order items');
        System.assertEquals(1, orderItems.get(0).Quantity);
    }

    @isTest
    static void testAddProductDouble() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE IsActive = TRUE LIMIT 1].Id;

        Test.startTest();
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        KPN_OrderProductCtrl.addProduct(orderId, pbeId);
        Test.stopTest();

        List<OrderItem> orderItems = OrderItemSelector.getByOrderId(orderId);
        System.assert(!orderItems.isEmpty(), 'should return order items');
        System.assertEquals(2, orderItems.get(0).Quantity);
    }
}

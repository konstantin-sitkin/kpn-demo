@IsTest
private class KPN_OrderItemSelectorTest {

    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
        KPN_TestDataFactory.createOrderItems(order1.Id, 201);
    }

    @isTest
    static void testGetByIdNull() {
        Id orderItemId = null;
        Boolean exceptionThrown = false;
        try {
            KPN_OrderItemSelector.getById(orderItemId);
        } catch (KPN_OrderItemSelector.OrderItemSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(exceptionThrown, 'an exception should be thrown on null id');
    } 

    @isTest
    static void testGetByIdRecordFound() {
        Id orderItemId = [SELECT Id FROM OrderItem LIMIT 1].Id;
        OrderItem actualOrderItem;
        Boolean exceptionThrown = false;
        try {
            actualOrderItem = KPN_OrderItemSelector.getById(orderItemId);
        } catch (KPN_OrderItemSelector.OrderItemSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, actualOrderItem, 'an order item should be returned');
        System.assertEquals(orderItemId, actualOrderItem.Id, 'an exact order item should be found by id');
    } 

    @isTest
    static void testGetByOrderIdRecordsFound() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        List<OrderItem> orderItems;
        Boolean exceptionThrown = false;
        try {
            orderItems = KPN_OrderItemSelector.getByOrderId(orderId);
        } catch (KPN_OrderItemSelector.OrderItemSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, orderItems, 'an order item should be returned');
        System.assert(!orderItems.isEmpty(), 'an exact order item should be found by id');
    } 
}
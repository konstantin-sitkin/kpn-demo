@IsTest
private class OrderItemSelectorTest {

    @testSetup
    static void setup() {
        TestDataFactory.createProductsAndEntries();
        Account baseAcc = TestDataFactory.createAccount();
        Contract baseCtr = TestDataFactory.createContract(baseAcc.Id);
        Order order1 = TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
        TestDataFactory.createOrderItems(order1.Id, 201);
    }

    @isTest
    static void testGetByIdNull() {
        Id orderItemId = null;
        Boolean exceptionThrown = false;
        try {
            OrderItemSelector.getById(orderItemId);
        } catch (OrderItemSelector.OrderItemSelectorException ose) {
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
            actualOrderItem = OrderItemSelector.getById(orderItemId);
        } catch (OrderItemSelector.OrderItemSelectorException ose) {
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
            orderItems = OrderItemSelector.getByOrderId(orderId);
        } catch (OrderItemSelector.OrderItemSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, orderItems, 'an order item should be returned');
        System.assert(!orderItems.isEmpty(), 'an exact order item should be found by id');
    } 
}
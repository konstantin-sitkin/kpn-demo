@IsTest
private class OrderSelectorTest {

    @testSetup
    static void setup() {
        TestDataFactory.createProductsAndEntries();
        Account baseAcc = TestDataFactory.createAccount();
        Contract baseCtr = TestDataFactory.createContract(baseAcc.Id);
        Order order1 = TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
    }
    
    @isTest
    static void testGetByIdNull() {
        Id orderId = null;
        Boolean exceptionThrown = false;
        try {
            OrderSelector.getById(orderId);
        } catch (OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(exceptionThrown, 'an exception should be thrown on null id');
    } 

    @isTest
    static void testGetByIdRecordFound() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Order actualOrder;
        Boolean exceptionThrown = false;
        try {
            actualOrder = OrderSelector.getById(orderId);
        } catch (OrderSelector.OrderSelectorException ose) {
            System.debug(ose.getMessage());
            exceptionThrown = true;
        }

        System.assert(!exceptionThrown, 'no exception should be thrown on valid id');
        System.assertNotEquals(null, actualOrder, 'an order should be returned');
        System.assertEquals(orderId, actualOrder.Id, 'an exact order should be found by id');
    } 

}

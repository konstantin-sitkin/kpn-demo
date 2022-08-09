@IsTest
private class KPN_OrderSelectorTest {

    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
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

}
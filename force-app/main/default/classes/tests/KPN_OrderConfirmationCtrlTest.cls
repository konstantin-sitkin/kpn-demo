/**
 * @description  : KPN_OrderConfirmationCtrl Test
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-10
 **/
@IsTest
private class KPN_OrderConfirmationCtrlTest {
    @testSetup
    static void setup() {
        KPN_TestDataFactory.createProductsAndEntries();
        Account baseAcc = KPN_TestDataFactory.createAccount();
        Contract baseCtr = KPN_TestDataFactory.createContract(baseAcc.Id);
        Order order1 = KPN_TestDataFactory.createOrder(baseAcc.Id, baseCtr.Id);
        KPN_TestDataFactory.createOrderItems(order1.Id, 10);
    }

    @isTest
    static void testPostOrderSuccess() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Test.setMock(HttpCalloutMock.class, KPN_ExternalSystemPostOrderMock.getSuccessMock());

        Test.startTest();
        KPN_OrderConfirmationCtrl.postOrder(orderId);
        Test.stopTest();

        Order updatedOrder = KPN_OrderSelector.getById(orderId);
        System.assertEquals(KPN_AppConstants.ORDER_STATUS_ACTIVATED, updatedOrder.Status, 'order should be activated after confirmation');
    }

    @isTest
    static void testPostOrderError() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Boolean exceptionThrown = false;
        Test.setMock(HttpCalloutMock.class, KPN_ExternalSystemPostOrderMock.getErrorMock());

        Test.startTest();
        try {
            KPN_OrderConfirmationCtrl.postOrder(orderId);
        } catch (KPN_ExternalSystemPostOrderApiHandler.KPN_ExternalSystemPostOrderException espoe) {
            System.debug(espoe.getMessage());
            System.debug(espoe.getTypeName());
            exceptionThrown = true;
        }
        Test.stopTest();

        Order updatedOrder = KPN_OrderSelector.getById(orderId);
        System.assert(exceptionThrown, 'an exception should be thrown on error response');
        System.assertNotEquals(KPN_AppConstants.ORDER_STATUS_ACTIVATED, updatedOrder.Status, 'order should remain the same after failed confirmation');
    }

    @isTest
    static void testPostOrderException() {
        Id orderId = [SELECT Id FROM Order LIMIT 1].Id;
        Boolean exceptionThrown = false;
        Test.setMock(HttpCalloutMock.class, new KPN_ExternalSystemPostOrderMock.CalloutExceptionMock());

        Test.startTest();
        try {
            KPN_OrderConfirmationCtrl.postOrder(orderId);
        } catch (KPN_ExternalSystemApi.KPN_ExternalSystemApiException esae) {
            System.debug(esae.getMessage());
            System.debug(esae.getTypeName());
            exceptionThrown = true;
        }
        Test.stopTest();

        Order updatedOrder = KPN_OrderSelector.getById(orderId);
        System.assert(exceptionThrown, 'an callout exception should be thrown and catched with api class');
        System.assertNotEquals(KPN_AppConstants.ORDER_STATUS_ACTIVATED, updatedOrder.Status, 'order should remain the same after failed confirmation');
    }
}

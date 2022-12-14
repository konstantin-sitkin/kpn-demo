public with sharing class KPN_OrderConfirmationCtrl {
    
    @AuraEnabled(cacheable=false)
    public static void postOrder(String orderId) {
        Order currentOrder = KPN_OrderSelector.getByIdWithChildren(orderId);

        KPN_ExternalSystemPostOrderApiHandler apiHandler = new KPN_ExternalSystemPostOrderApiHandler();
        apiHandler.setOrder(currentOrder);
        apiHandler.setOrderItems(currentOrder.OrderItems);
        KPN_ExternalSystemResponse apiRes = apiHandler.doPost();
        System.debug(apiRes);
        if (apiRes.isSuccess == false) {
            throw new KPN_ExternalSystemPostOrderApiHandler.KPN_ExternalSystemPostOrderException(apiRes.rawJson);
        }
        currentOrder.Status = KPN_AppConstants.ORDER_STATUS_ACTIVATED;
        update currentOrder;
    }
}

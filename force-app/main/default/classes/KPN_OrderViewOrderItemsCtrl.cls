public with sharing class KPN_OrderViewOrderItemsCtrl {
    
    @AuraEnabled(cacheable=false)
    public static List<OrderItem> getOrderItems(String orderId) {
        return KPN_OrderItemSelector.getByOrderId(orderId);
    }

    
}
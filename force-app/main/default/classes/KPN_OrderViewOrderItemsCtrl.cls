public with sharing class KPN_OrderViewOrderItemsCtrl {
    
    @AuraEnabled(cacheable=false)
    public static List<OrderItem> getOrderItems(String orderId) {
        return OrderItemSelector.getByOrderId(orderId);
    }

    
}

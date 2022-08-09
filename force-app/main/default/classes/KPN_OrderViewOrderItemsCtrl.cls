/**
 * @description  : Controller for LWC kpnOrderViewOrderItems.js
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
 **/
public with sharing class KPN_OrderViewOrderItemsCtrl {
    /**
     * @description Extracts OrderItems for current Order
     * @author Konstantin Sitkin | 2022-08-09
     * @param orderId
     * @return List<OrderItem>
     **/
    @AuraEnabled(cacheable=false)
    public static List<OrderItem> getOrderItems(String orderId) {
        return KPN_OrderItemSelector.getByOrderId(orderId);
    }
}

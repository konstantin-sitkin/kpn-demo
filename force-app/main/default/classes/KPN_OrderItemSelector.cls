public with sharing class KPN_OrderItemSelector {
    public static OrderItem getById(String orderItemId) {
        List<OrderItem> orderItems = [
            SELECT Id, Quantity, PricebookEntryId, Product2Id, 
            Product2.Name,
            OrderId, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE Id = :orderItemId
            WITH SECURITY_ENFORCED
        ];
        if (orderItems.isEmpty()) {
            throw new OrderItemSelectorException('No records found for id: ' + orderItemId);
        }
        return orderItems.get(0);
    }

    public static List<OrderItem> getByOrderId(String orderId) {
        List<OrderItem> orderItems = [
            SELECT Id, Quantity, PricebookEntryId, Product2Id, 
            Product2.Name,
            OrderId, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE OrderId = :orderId
            WITH SECURITY_ENFORCED
            ORDER BY LastModifiedDate DESC
        ];
        return orderItems;
    }

    public class OrderItemSelectorException extends Exception {
        
    }
}
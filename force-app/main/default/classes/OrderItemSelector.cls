public with sharing class OrderItemSelector {
    public static OrderItem getById(String orderItemId) {
        List<OrderItem> orderItems = [
            SELECT Id, Quantity, PricebookEntryId, Product2Id, 
            Product2.Name,
            OrderId, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE Id = :orderItemId
        ];
        return orderItems.get(0);
    }

    public static List<OrderItem> getByOrderId(String orderId) {
        List<OrderItem> orderItems = [
            SELECT Id, Quantity, PricebookEntryId, Product2Id, 
            Product2.Name,
            OrderId, UnitPrice, TotalPrice
            FROM OrderItem
            WHERE OrderId = :orderId
            ORDER BY LastModifiedDate DESC
        ];
        return orderItems;
    }
}

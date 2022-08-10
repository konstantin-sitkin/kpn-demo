/**
 * @description  : Selector pattern implementation for Order Item
 * @author       : Konstantin Sitkin
 * @created by   : 2022-08-09
**/
public with sharing class KPN_OrderItemSelector {
    /**
    * @description OrderItem Selector by OrderItem.Id
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderItemId 
    * @return OrderItem 
    * @throws OrderItemSelectorException 
    **/
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

    /**
    * @description OrderItems Selector by Order.Id
    * @author Konstantin Sitkin | 2022-08-09 
    * @param orderId 
    * @return List<OrderItem> 
    **/
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